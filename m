Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2B3479E8F
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 01:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhLSA21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 19:28:27 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:58956 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229911AbhLSA21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 19:28:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C1FF82058E;
        Sun, 19 Dec 2021 01:28:25 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G-NSGS0I67UO; Sun, 19 Dec 2021 01:28:25 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0AC0B2053D;
        Sun, 19 Dec 2021 01:28:25 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id EB08780004A;
        Sun, 19 Dec 2021 01:28:24 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 19 Dec 2021 01:28:24 +0100
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Sun, 19 Dec
 2021 01:28:24 +0100
Date:   Sun, 19 Dec 2021 01:28:16 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Antony Antony <antony.antony@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: [RFC PATCH ipsec-next] xfrm: add forwarding ICMP error message
Message-ID: <e9b8e0f951662162cc761ee5473be7a3f54183a7.1639872656.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
References: <YTXGGiMzsda6mcm2@AntonyAntony.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YTXGGiMzsda6mcm2@AntonyAntony.local>
Organization: secunet
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IETF RFC 4301, Section 6, requires a configurable option to forward
unauthenticated ICMP error message that does not match any
policies using. Use reverse of ICMP payload, which will be partial IP
packet.
Add this reverse lookup (using ICMP payload as skb) for xfrm forward path.

To enable this add the flag XFRM_POLICY_ICMP to fwd and out policy
and the flag XFRM_STATE_ICMP on incoming SA.

ip xfrm policy add flag icmp tmpl

ip xfrm policy
src 192.0.2.0/24 dst 192.0.1.0/25
	dir fwd priority 2084302 ptype main flag icmp

ip xfrm state add ...flag icmp

ip xfrm state
root@west:~#ip x s
src 192.1.2.23 dst 192.1.2.45
	proto esp spi 0xa7b76872 reqid 16389 mode tunnel
	replay-window 32 flag icmp af-unspec

Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_policy.c | 137 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 135 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 9341298b2a70..8505c36413c7 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -29,6 +29,7 @@
 #include <linux/audit.h>
 #include <linux/rhashtable.h>
 #include <linux/if_tunnel.h>
+#include <linux/icmp.h>
 #include <net/dst.h>
 #include <net/flow.h>
 #include <net/xfrm.h>
@@ -3475,6 +3476,123 @@ static inline int secpath_has_nontransport(const struct sec_path *sp, int k, int
 	return 0;
 }

+static bool icmp_err_packet(const struct flowi *fl, unsigned short family)
+{
+	const struct flowi6 *fl6 = &fl->u.ip6;
+	const struct flowi4 *fl4 = &fl->u.ip4;
+
+	if (family == AF_INET)
+		if (fl4->flowi4_proto == IPPROTO_ICMP &&
+		    (fl4->fl4_icmp_type == ICMP_DEST_UNREACH ||
+		      fl4->fl4_icmp_type == ICMP_TIME_EXCEEDED))
+			return false;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (fl6->flowi6_proto == IPPROTO_ICMPV6 &&
+	    (fl6->fl6_icmp_type == ICMPV6_DEST_UNREACH ||
+	      fl6->fl6_icmp_type == ICMPV6_TIME_EXCEED))
+		return false;
+#endif
+	return true;
+}
+
+static struct sk_buff *xfrm_icmp_flow_decode(struct sk_buff *skb,
+					     unsigned short family,
+					     struct flowi *fl,
+					     struct flowi *fl1)
+{
+	struct net *net = dev_net(skb->dev);
+	struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
+
+	if (!pskb_pull(newskb, (sizeof(struct iphdr) + sizeof(struct icmphdr))))
+		return NULL;
+	skb_reset_network_header(newskb);
+
+	if (xfrm_decode_session_reverse(newskb, fl1, family) < 0) {
+		kfree_skb(newskb);
+		XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
+		return NULL;
+	}
+
+	/* inherit more from the old flow ???
+	 * the inner skb may have these values different from outer skb
+	 */
+
+	fl1->flowi_oif = fl->flowi_oif;
+	fl1->flowi_mark = fl->flowi_mark;
+	fl1->flowi_tos = fl->flowi_tos;
+	nf_nat_decode_session(newskb, fl1, family);
+
+	return newskb;
+}
+
+static bool xfrm_sa_icmp_flow(struct sk_buff *skb,
+			      unsigned short family, const struct xfrm_selector *sel,
+			      struct flowi *fl)
+{
+	bool ret = false;
+
+	if (!icmp_err_packet(fl, family)) {
+		struct flowi fl1;
+		struct sk_buff *newskb = xfrm_icmp_flow_decode(skb, family, fl, &fl1);
+
+		if (!newskb)
+			return ret;
+
+		ret = xfrm_selector_match(sel, &fl1, family);
+		kfree_skb(newskb);
+	}
+
+	return ret;
+}
+
+static inline
+struct xfrm_policy *xfrm_in_fwd_icmp(struct sk_buff *skb, struct flowi *fl,
+				     unsigned short family, u32 if_id)
+{
+	struct xfrm_policy *pol = NULL;
+
+	if (!icmp_err_packet(fl, family)) {
+		struct flowi fl1;
+		struct net *net = dev_net(skb->dev);
+		struct sk_buff *newskb = xfrm_icmp_flow_decode(skb, family, fl, &fl1);
+
+		if (!newskb)
+			return pol;
+		pol = xfrm_policy_lookup(net, &fl1, family, XFRM_POLICY_FWD, if_id);
+		kfree_skb(newskb);
+	}
+
+	return pol;
+}
+
+static inline
+struct dst_entry *xfrm_out_fwd_icmp(struct sk_buff *skb, struct flowi *fl,
+				    unsigned short family, struct dst_entry *dst)
+{
+	if (!icmp_err_packet(fl, family)) {
+		struct net *net = dev_net(skb->dev);
+		struct dst_entry *dst2;
+		struct flowi fl1;
+		struct sk_buff *newskb = xfrm_icmp_flow_decode(skb, family, fl, &fl1);
+
+		if (!newskb)
+			return dst;
+
+		dst2 = xfrm_lookup(net, dst, &fl1, NULL, XFRM_LOOKUP_QUEUE);
+
+		kfree_skb(newskb);
+
+		if (IS_ERR(dst2))
+			return dst;
+
+		if (dst2->xfrm)
+			dst = dst2;
+	}
+
+	return dst;
+}
+
 int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			unsigned short family)
 {
@@ -3521,9 +3639,17 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,

 		for (i = sp->len - 1; i >= 0; i--) {
 			struct xfrm_state *x = sp->xvec[i];
+			int ret = 0;
+
 			if (!xfrm_selector_match(&x->sel, &fl, family)) {
-				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMISMATCH);
-				return 0;
+				ret = true;
+				if (x->props.flags & XFRM_STATE_ICMP &&
+				    xfrm_sa_icmp_flow(skb, family, &x->sel, &fl))
+					ret = false;
+				if (ret) {
+					XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMISMATCH);
+					return 0;
+				}
 			}
 		}
 	}
@@ -3546,6 +3672,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		return 0;
 	}

+	if (!pol && dir == XFRM_POLICY_FWD)
+		pol = xfrm_in_fwd_icmp(skb, &fl, family, if_id);
+
 	if (!pol) {
 		if (!xfrm_default_allow(net, dir)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOPOLS);
@@ -3675,6 +3804,10 @@ int __xfrm_route_forward(struct sk_buff *skb, unsigned short family)
 		res = 0;
 		dst = NULL;
 	}
+
+	if (dst && !dst->xfrm)
+		dst = xfrm_out_fwd_icmp(skb, &fl, family, dst);
+
 	skb_dst_set(skb, dst);
 	return res;
 }
--
2.30.2

