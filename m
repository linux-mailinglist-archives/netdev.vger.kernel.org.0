Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00259103A50
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbfKTMsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:48:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22392 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727656AbfKTMsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:48:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574254092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LyhREK0lOCVd2inH/YqfxSiWGw3LIVBQYcmz+1ImE10=;
        b=J0mQUut5Qsdyo5lAlzZbKiGcl3ZN7UVShn2rqGX0W7hhfaYIhoRuVZH7K78ZYXDksn3O+h
        PltLLNdPFtSyuwyBu88KHYDAeIt1Y8JUBCHe4gs000xxFySv8GdRLw5hjr++UP05c8m/I1
        CKJTbcOUI+bWdGKgF2chcC5f04vz16A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-z84pT70SP4G7b4tWqB7LDQ-1; Wed, 20 Nov 2019 07:48:08 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CE20104ED2B;
        Wed, 20 Nov 2019 12:48:07 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-23.ams2.redhat.com [10.36.117.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D49DC2CA76;
        Wed, 20 Nov 2019 12:48:05 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next v4 5/5] ipv4: use dst hint for ipv4 list receive
Date:   Wed, 20 Nov 2019 13:47:37 +0100
Message-Id: <70221ba2d3cca4a2afb39c8ea95f7a2870326c13.1574252982.git.pabeni@redhat.com>
In-Reply-To: <cover.1574252982.git.pabeni@redhat.com>
References: <cover.1574252982.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: z84pT70SP4G7b4tWqB7LDQ-1
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

Hints are explicitly disabled if the destination is a local broadcast,
that keeps the code simple and local broadcast are a slower path anyway.

UDP flood performances vs recvmmsg() receiver:

vanilla=09=09patched=09=09delta
Kpps=09=09Kpps=09=09%
1683=09=091871=09=09+11

In the worst case scenario - each packet has a different
destination address - the performance delta is within noise
range.

v3 -> v4:
 - re-enable hints for forward

v2 -> v3:
 - really fix build (sic) and hint usage check
 - use fib4_has_custom_rules() helpers (David A.)
 - add ip_extract_route_hint() helper (Edward C.)
 - use prev skb as hint instead of copying data (Willem)

v1 -> v2:
 - fix build issue with !CONFIG_IP_MULTIPLE_TABLES

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/route.h |  4 ++++
 net/ipv4/ip_input.c | 35 +++++++++++++++++++++++++++++++----
 net/ipv4/route.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 6c516840380d..a9c60fc68e36 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -185,6 +185,10 @@ int ip_route_input_rcu(struct sk_buff *skb, __be32 dst=
, __be32 src,
 =09=09       u8 tos, struct net_device *devin,
 =09=09       struct fib_result *res);
=20
+int ip_route_use_hint(struct sk_buff *skb, __be32 dst, __be32 src,
+=09=09      u8 tos, struct net_device *devin,
+=09=09      const struct sk_buff *hint);
+
 static inline int ip_route_input(struct sk_buff *skb, __be32 dst, __be32 s=
rc,
 =09=09=09=09 u8 tos, struct net_device *devin)
 {
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 24a95126e698..aa438c6758a7 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -302,16 +302,31 @@ static inline bool ip_rcv_options(struct sk_buff *skb=
, struct net_device *dev)
 =09return true;
 }
=20
+static bool ip_can_use_hint(const struct sk_buff *skb, const struct iphdr =
*iph,
+=09=09=09    const struct sk_buff *hint)
+{
+=09return hint && !skb_dst(skb) && ip_hdr(hint)->daddr =3D=3D iph->daddr &=
&
+=09       ip_hdr(hint)->tos =3D=3D iph->tos;
+}
+
 INDIRECT_CALLABLE_DECLARE(int udp_v4_early_demux(struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(int tcp_v4_early_demux(struct sk_buff *));
 static int ip_rcv_finish_core(struct net *net, struct sock *sk,
-=09=09=09      struct sk_buff *skb, struct net_device *dev)
+=09=09=09      struct sk_buff *skb, struct net_device *dev,
+=09=09=09      const struct sk_buff *hint)
 {
 =09const struct iphdr *iph =3D ip_hdr(skb);
 =09int (*edemux)(struct sk_buff *skb);
 =09struct rtable *rt;
 =09int err;
=20
+=09if (ip_can_use_hint(skb, iph, hint)) {
+=09=09err =3D ip_route_use_hint(skb, iph->daddr, iph->saddr, iph->tos,
+=09=09=09=09=09dev, hint);
+=09=09if (unlikely(err))
+=09=09=09goto drop_error;
+=09}
+
 =09if (net->ipv4.sysctl_ip_early_demux &&
 =09    !skb_dst(skb) &&
 =09    !skb->sk &&
@@ -408,7 +423,7 @@ static int ip_rcv_finish(struct net *net, struct sock *=
sk, struct sk_buff *skb)
 =09if (!skb)
 =09=09return NET_RX_SUCCESS;
=20
-=09ret =3D ip_rcv_finish_core(net, sk, skb, dev);
+=09ret =3D ip_rcv_finish_core(net, sk, skb, dev, NULL);
 =09if (ret !=3D NET_RX_DROP)
 =09=09ret =3D dst_input(skb);
 =09return ret;
@@ -535,11 +550,20 @@ static void ip_sublist_rcv_finish(struct list_head *h=
ead)
 =09}
 }
=20
+static struct sk_buff *ip_extract_route_hint(const struct net *net,
+=09=09=09=09=09     struct sk_buff *skb, int rt_type)
+{
+=09if (fib4_has_custom_rules(net) || rt_type =3D=3D RTN_BROADCAST)
+=09=09return NULL;
+
+=09return skb;
+}
+
 static void ip_list_rcv_finish(struct net *net, struct sock *sk,
 =09=09=09       struct list_head *head)
 {
+=09struct sk_buff *skb, *next, *hint =3D NULL;
 =09struct dst_entry *curr_dst =3D NULL;
-=09struct sk_buff *skb, *next;
 =09struct list_head sublist;
=20
 =09INIT_LIST_HEAD(&sublist);
@@ -554,11 +578,14 @@ static void ip_list_rcv_finish(struct net *net, struc=
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
+=09=09=09hint =3D ip_extract_route_hint(net, skb,
+=09=09=09=09=09       ((struct rtable *)dst)->rt_type);
+
 =09=09=09/* dispatch old sublist */
 =09=09=09if (!list_empty(&sublist))
 =09=09=09=09ip_sublist_rcv_finish(&sublist);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index dcc4fa10138d..f88c93c38f11 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2019,10 +2019,52 @@ static int ip_mkroute_input(struct sk_buff *skb,
 =09return __mkroute_input(skb, res, in_dev, daddr, saddr, tos);
 }
=20
+/* Implements all the saddr-related checks as ip_route_input_slow(),
+ * assuming daddr is valid and the destination is not a local broadcast on=
e.
+ * Uses the provided hint instead of performing a route lookup.
+ */
+int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
+=09=09      u8 tos, struct net_device *dev,
+=09=09      const struct sk_buff *hint)
+{
+=09struct in_device *in_dev =3D __in_dev_get_rcu(dev);
+=09struct rtable *rt =3D (struct rtable *)hint;
+=09struct net *net =3D dev_net(dev);
+=09int err =3D -EINVAL;
+=09u32 tag =3D 0;
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
+=09if (rt->rt_type !=3D RTN_LOCAL)
+=09=09goto skip_validate_source;
+
+=09tos &=3D IPTOS_RT_MASK;
+=09err =3D fib_validate_source(skb, saddr, daddr, tos, 0, dev, in_dev, &ta=
g);
+=09if (err < 0)
+=09=09goto martian_source;
+
+skip_validate_source:
+=09skb_dst_copy(skb, hint);
+=09return 0;
+
+martian_source:
+=09ip_handle_martian_source(dev, in_dev, skb, daddr, saddr);
+=09return err;
+}
+
 /*
  *=09NOTE. We drop all the packets that has local source
  *=09addresses, because every properly looped back packet
  *=09must have correct destination already attached by output routine.
+ *=09Changes in the enforced policies must be applied also to
+ *=09ip_route_use_hint().
  *
  *=09Such approach solves two big problems:
  *=091. Not simplex devices are handled properly.
--=20
2.21.0

