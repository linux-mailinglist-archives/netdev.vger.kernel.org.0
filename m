Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD1DFEB4E
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 10:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfKPJPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 04:15:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34859 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727456AbfKPJPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 04:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573895730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LYtdoHalG9yonfwN/tOZPBCBhnx4HxnHzRhqiPTRTo8=;
        b=Q6P8Xfr7Ix6+9J4BWPh2MgTC4X4foFBhNteGxoXx/qAL5iEoM+qE1vHif11XGYzn27hPOW
        1EhCjpdUO8CV96iNbIQT6QH1pnXDFhS1Qj4y2m6hWW3w1bZ2H7BfX3/Gzi4lIf2svLzDFv
        dzyx5kmu/bym7qfQnyBrEeHrFyIDubc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-lHrtz1gbNPa7lOL4OkkQeQ-1; Sat, 16 Nov 2019 04:15:27 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62AA21858F11;
        Sat, 16 Nov 2019 09:15:26 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-32.ams2.redhat.com [10.36.116.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42C421E3;
        Sat, 16 Nov 2019 09:15:25 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/2] ipv6: introduce and uses route look hints for list input
Date:   Sat, 16 Nov 2019 10:14:50 +0100
Message-Id: <9b3b3a66894a1714266db1d3cb3268efe243509e.1573893340.git.pabeni@redhat.com>
In-Reply-To: <cover.1573893340.git.pabeni@redhat.com>
References: <cover.1573893340.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: lHrtz1gbNPa7lOL4OkkQeQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing RX batch packet processing, we currently always repeat
the route lookup for each ingress packet. If policy routing is
configured, and IPV6_SUBTREES is disabled at build time, we
know that packets with the same destination address will use
the same dst.

This change tries to avoid per packet route lookup caching
the destination address of the latest successful lookup, and
reusing it for the next packet when the above conditions are
in place. Ingress traffic for most servers should fit.

The measured performance delta under UDP flood vs a recvmmsg
receiver is as follow:

vanilla=09=09patched=09=09delta
Kpps=09=09Kpps=09=09%
1431=09=091664=09=09+14

In the worst-case scenario - each packet has a different
destination address - the performance delta is within noise
range

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv6/ip6_input.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index ef7f707d9ae3..b7b947a9ddc9 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -44,10 +44,16 @@
 #include <net/inet_ecn.h>
 #include <net/dst_metadata.h>
=20
+struct ip6_route_input_hint {
+=09unsigned long=09refdst;
+=09struct in6_addr daddr;
+};
+
 INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *));
 static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
-=09=09=09=09struct sk_buff *skb)
+=09=09=09=09struct sk_buff *skb,
+=09=09=09=09struct ip6_route_input_hint *hint)
 {
 =09void (*edemux)(struct sk_buff *skb);
=20
@@ -59,7 +65,13 @@ static void ip6_rcv_finish_core(struct net *net, struct =
sock *sk,
 =09=09=09INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
 =09=09=09=09=09udp_v6_early_demux, skb);
 =09}
-=09if (!skb_valid_dst(skb))
+
+=09if (skb_valid_dst(skb))
+=09=09return;
+
+=09if (hint && ipv6_addr_equal(&hint->daddr, &ipv6_hdr(skb)->daddr))
+=09=09__skb_dst_copy(skb, hint->refdst);
+=09else
 =09=09ip6_route_input(skb);
 }
=20
@@ -71,7 +83,7 @@ int ip6_rcv_finish(struct net *net, struct sock *sk, stru=
ct sk_buff *skb)
 =09skb =3D l3mdev_ip6_rcv(skb);
 =09if (!skb)
 =09=09return NET_RX_SUCCESS;
-=09ip6_rcv_finish_core(net, sk, skb);
+=09ip6_rcv_finish_core(net, sk, skb, NULL);
=20
 =09return dst_input(skb);
 }
@@ -89,6 +101,7 @@ static void ip6_sublist_rcv_finish(struct list_head *hea=
d)
 static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
 =09=09=09=09struct list_head *head)
 {
+=09struct ip6_route_input_hint _hint, *hint =3D NULL;
 =09struct dst_entry *curr_dst =3D NULL;
 =09struct sk_buff *skb, *next;
 =09struct list_head sublist;
@@ -104,9 +117,18 @@ static void ip6_list_rcv_finish(struct net *net, struc=
t sock *sk,
 =09=09skb =3D l3mdev_ip6_rcv(skb);
 =09=09if (!skb)
 =09=09=09continue;
-=09=09ip6_rcv_finish_core(net, sk, skb);
+=09=09ip6_rcv_finish_core(net, sk, skb, hint);
 =09=09dst =3D skb_dst(skb);
 =09=09if (curr_dst !=3D dst) {
+#ifndef CONFIG_IPV6_SUBTREES
+=09=09=09if (!net->ipv6.fib6_has_custom_rules) {
+=09=09=09=09_hint.refdst =3D skb->_skb_refdst;
+=09=09=09=09memcpy(&_hint.daddr, &ipv6_hdr(skb)->daddr,
+=09=09=09=09       sizeof(_hint.daddr));
+=09=09=09=09hint =3D &_hint;
+=09=09=09}
+#endif
+
 =09=09=09/* dispatch old sublist */
 =09=09=09if (!list_empty(&sublist))
 =09=09=09=09ip6_sublist_rcv_finish(&sublist);
--=20
2.21.0

