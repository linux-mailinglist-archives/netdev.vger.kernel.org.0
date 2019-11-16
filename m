Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6688FEB4F
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 10:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfKPJPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 04:15:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57929 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726831AbfKPJPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 04:15:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573895732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zgo0hK+lGlcBlzZOYcSbDTksGm3Gy/CCrxM21zZwX84=;
        b=QInrj6cmYGrATw4EZR20Qie8ZiX3reTs3P+vToHF+TYTITIVkcTdSCxeA9SWbjqz9HP2Qp
        JPTsXF8XP08ByoUFdKtbc1ktqLempTZ6D+nkjE1Qm4QOr9uKK/8GIyw+/tUpjdqxc46QK1
        tP2Nk87FRfzmrGOZT0ZPaAtqP0EzgWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-xrj3xnFBOmK3vlV80wvtPg-1; Sat, 16 Nov 2019 04:15:29 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC4AE801E7E;
        Sat, 16 Nov 2019 09:15:27 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-32.ams2.redhat.com [10.36.116.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7C585DDB3;
        Sat, 16 Nov 2019 09:15:26 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/2] ipv4: use dst hint for ipv4 list receive
Date:   Sat, 16 Nov 2019 10:14:51 +0100
Message-Id: <5b7407edd15edaf912214ee62ea3d56d4b4e16b1.1573893340.git.pabeni@redhat.com>
In-Reply-To: <cover.1573893340.git.pabeni@redhat.com>
References: <cover.1573893340.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: xrj3xnFBOmK3vlV80wvtPg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is alike the previous change, with some additional ipv4 specific
quirk. Even when using the route hint we still have to do perform
additional per packet checks about source address validity: a new
helper is added to wrap them.

Moreover, the ipv4 route lookup, even in the absence of policy routing,
may depend on pkts ToS, so we cache that values, too.

Explicitly avoid hints for local broadcast: this simplify the code
and broadcasts are slower path anyway.

UDP flood performances vs recvmmsg() receiver:

vanilla=09=09patched=09=09delta
Kpps=09=09Kpps=09=09%
1683=09=091833=09=09+8

In the worst case scenario - each packet has a different
destination address - the performance delta is within noise
range.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/route.h | 11 +++++++++++
 net/ipv4/ip_input.c | 29 ++++++++++++++++++++++++-----
 net/ipv4/route.c    | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 6c516840380d..f7a8a52318cd 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -185,6 +185,17 @@ int ip_route_input_rcu(struct sk_buff *skb, __be32 dst=
, __be32 src,
 =09=09       u8 tos, struct net_device *devin,
 =09=09       struct fib_result *res);
=20
+struct ip_route_input_hint {
+=09unsigned long=09refdst;
+=09__be32=09=09daddr;
+=09char=09=09tos;
+=09bool=09=09local;
+};
+
+int ip_route_use_hint(struct sk_buff *skb, __be32 dst, __be32 src,
+=09=09      u8 tos, struct net_device *devin,
+=09=09      struct ip_route_input_hint *hint);
+
 static inline int ip_route_input(struct sk_buff *skb, __be32 dst, __be32 s=
rc,
 =09=09=09=09 u8 tos, struct net_device *devin)
 {
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 24a95126e698..78fd60bf1c8a 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -305,7 +305,8 @@ static inline bool ip_rcv_options(struct sk_buff *skb, =
struct net_device *dev)
 INDIRECT_CALLABLE_DECLARE(int udp_v4_early_demux(struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(int tcp_v4_early_demux(struct sk_buff *));
 static int ip_rcv_finish_core(struct net *net, struct sock *sk,
-=09=09=09      struct sk_buff *skb, struct net_device *dev)
+=09=09=09      struct sk_buff *skb, struct net_device *dev,
+=09=09=09      struct ip_route_input_hint *hint)
 {
 =09const struct iphdr *iph =3D ip_hdr(skb);
 =09int (*edemux)(struct sk_buff *skb);
@@ -335,8 +336,12 @@ static int ip_rcv_finish_core(struct net *net, struct =
sock *sk,
 =09 *=09how the packet travels inside Linux networking.
 =09 */
 =09if (!skb_valid_dst(skb)) {
-=09=09err =3D ip_route_input_noref(skb, iph->daddr, iph->saddr,
-=09=09=09=09=09   iph->tos, dev);
+=09=09if (hint && hint->daddr =3D=3D iph->daddr && hint->tos =3D=3D iph->t=
os)
+=09=09=09err =3D ip_route_use_hint(skb, iph->daddr, iph->saddr,
+=09=09=09=09=09=09iph->tos, dev, hint);
+=09=09else
+=09=09=09err =3D ip_route_input_noref(skb, iph->daddr, iph->saddr,
+=09=09=09=09=09=09   iph->tos, dev);
 =09=09if (unlikely(err))
 =09=09=09goto drop_error;
 =09}
@@ -408,7 +413,7 @@ static int ip_rcv_finish(struct net *net, struct sock *=
sk, struct sk_buff *skb)
 =09if (!skb)
 =09=09return NET_RX_SUCCESS;
=20
-=09ret =3D ip_rcv_finish_core(net, sk, skb, dev);
+=09ret =3D ip_rcv_finish_core(net, sk, skb, dev, NULL);
 =09if (ret !=3D NET_RX_DROP)
 =09=09ret =3D dst_input(skb);
 =09return ret;
@@ -538,6 +543,7 @@ static void ip_sublist_rcv_finish(struct list_head *hea=
d)
 static void ip_list_rcv_finish(struct net *net, struct sock *sk,
 =09=09=09       struct list_head *head)
 {
+=09struct ip_route_input_hint _hint, *hint =3D NULL;
 =09struct dst_entry *curr_dst =3D NULL;
 =09struct sk_buff *skb, *next;
 =09struct list_head sublist;
@@ -554,11 +560,24 @@ static void ip_list_rcv_finish(struct net *net, struc=
t sock *sk,
 =09=09skb =3D l3mdev_ip_rcv(skb);
 =09=09if (!skb)
 =09=09=09continue;
-=09=09if (ip_rcv_finish_core(net, sk, skb, dev) =3D=3D NET_RX_DROP)
+=09=09if (ip_rcv_finish_core(net, sk, skb, dev, hint) =3D=3D NET_RX_DROP)
 =09=09=09continue;
=20
 =09=09dst =3D skb_dst(skb);
 =09=09if (curr_dst !=3D dst) {
+=09=09=09struct rtable *rt =3D (struct rtable *)dst;
+
+=09=09=09if (!net->ipv4.fib_has_custom_rules &&
+=09=09=09    rt->rt_type !=3D RTN_BROADCAST) {
+=09=09=09=09_hint.refdst =3D skb->_skb_refdst;
+=09=09=09=09_hint.daddr =3D ip_hdr(skb)->daddr;
+=09=09=09=09_hint.tos =3D ip_hdr(skb)->tos;
+=09=09=09=09_hint.local =3D rt->rt_type =3D=3D RTN_LOCAL;
+=09=09=09=09hint =3D &_hint;
+=09=09=09} else {
+=09=09=09=09hint =3D NULL;
+=09=09=09}
+
 =09=09=09/* dispatch old sublist */
 =09=09=09if (!list_empty(&sublist))
 =09=09=09=09ip_sublist_rcv_finish(&sublist);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index dcc4fa10138d..b0ddff17db80 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2019,6 +2019,44 @@ static int ip_mkroute_input(struct sk_buff *skb,
 =09return __mkroute_input(skb, res, in_dev, daddr, saddr, tos);
 }
=20
+/* Implements all the saddr-related checks as ip_route_input_slow(),
+ * assuming daddr is valid and this is not a local broadcast.
+ * Uses the provided hint instead of performing a route lookup.
+ */
+int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
+=09=09      u8 tos, struct net_device *dev,
+=09=09      struct ip_route_input_hint *hint)
+{
+=09struct in_device *in_dev =3D __in_dev_get_rcu(dev);
+=09struct net *net =3D dev_net(dev);
+=09int err =3D -EINVAL;
+=09u32 itag =3D 0;
+
+=09if (ipv4_is_multicast(saddr) || ipv4_is_lbcast(saddr))
+=09=09goto martian_source;
+
+=09if (ipv4_is_zeronet(saddr))
+=09=09goto martian_source;
+
+=09if (ipv4_is_loopback(saddr) && !IN_DEV_NET_ROUTE_LOCALNET(in_dev, net))
+=09=09goto martian_source;
+
+=09if (hint->local) {
+=09=09err =3D fib_validate_source(skb, saddr, daddr, tos, 0, dev,
+=09=09=09=09=09  in_dev, &itag);
+=09=09if (err < 0)
+=09=09=09goto martian_source;
+=09}
+
+=09err =3D 0;
+=09__skb_dst_copy(skb, hint->refdst);
+=09return err;
+
+martian_source:
+=09ip_handle_martian_source(dev, in_dev, skb, daddr, saddr);
+=09return err;
+}
+
 /*
  *=09NOTE. We drop all the packets that has local source
  *=09addresses, because every properly looped back packet
--=20
2.21.0

