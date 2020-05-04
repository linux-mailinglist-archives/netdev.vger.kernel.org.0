Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4827D1C3406
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgEDIGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728098AbgEDIGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:06:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A51C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:06:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jVW7a-000673-FM; Mon, 04 May 2020 10:06:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 6/7] xfrm: remove extract_output indirection from xfrm_state_afinfo
Date:   Mon,  4 May 2020 10:06:08 +0200
Message-Id: <20200504080609.14648-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504080609.14648-1-fw@strlen.de>
References: <20200504080609.14648-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move this to xfrm_output.c.  This avoids the state->extract_output
indirection.

This patch also removes the duplicated __xfrm6_extract_header helper
added in an earlier patch, we can now use the one from xfrm_inout.h .

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h      |  3 --
 net/ipv6/xfrm6_output.c | 58 -----------------------------------
 net/ipv6/xfrm6_state.c  |  1 -
 net/xfrm/xfrm_output.c  | 67 ++++++++++++++++++++++++++++++++++++-----
 4 files changed, 59 insertions(+), 70 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 8f7fb033d557..db814a7e042f 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -362,8 +362,6 @@ struct xfrm_state_afinfo {
 
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
 	int			(*output_finish)(struct sock *sk, struct sk_buff *skb);
-	int			(*extract_output)(struct xfrm_state *x,
-						  struct sk_buff *skb);
 	int			(*transport_finish)(struct sk_buff *skb,
 						    int async);
 	void			(*local_error)(struct sk_buff *skb, u32 mtu);
@@ -1601,7 +1599,6 @@ int xfrm6_tunnel_register(struct xfrm6_tunnel *handler, unsigned short family);
 int xfrm6_tunnel_deregister(struct xfrm6_tunnel *handler, unsigned short family);
 __be32 xfrm6_tunnel_alloc_spi(struct net *net, xfrm_address_t *saddr);
 __be32 xfrm6_tunnel_spi_lookup(struct net *net, const xfrm_address_t *saddr);
-int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb);
 int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index be64f280510c..b7d65b344679 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -47,64 +47,6 @@ void xfrm6_local_error(struct sk_buff *skb, u32 mtu)
 	ipv6_local_error(sk, EMSGSIZE, &fl6, mtu);
 }
 
-static int xfrm6_tunnel_check_size(struct sk_buff *skb)
-{
-	int mtu, ret = 0;
-	struct dst_entry *dst = skb_dst(skb);
-
-	if (skb->ignore_df)
-		goto out;
-
-	mtu = dst_mtu(dst);
-	if (mtu < IPV6_MIN_MTU)
-		mtu = IPV6_MIN_MTU;
-
-	if ((!skb_is_gso(skb) && skb->len > mtu) ||
-	    (skb_is_gso(skb) &&
-	     !skb_gso_validate_network_len(skb, ip6_skb_dst_mtu(skb)))) {
-		skb->dev = dst->dev;
-		skb->protocol = htons(ETH_P_IPV6);
-
-		if (xfrm6_local_dontfrag(skb->sk))
-			xfrm6_local_rxpmtu(skb, mtu);
-		else if (skb->sk)
-			xfrm_local_error(skb, mtu);
-		else
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
-		ret = -EMSGSIZE;
-	}
-out:
-	return ret;
-}
-
-static void __xfrm6_extract_header(struct sk_buff *skb)
-{
-	struct ipv6hdr *iph = ipv6_hdr(skb);
-
-	XFRM_MODE_SKB_CB(skb)->ihl = sizeof(*iph);
-	XFRM_MODE_SKB_CB(skb)->id = 0;
-	XFRM_MODE_SKB_CB(skb)->frag_off = htons(IP_DF);
-	XFRM_MODE_SKB_CB(skb)->tos = ipv6_get_dsfield(iph);
-	XFRM_MODE_SKB_CB(skb)->ttl = iph->hop_limit;
-	XFRM_MODE_SKB_CB(skb)->optlen = 0;
-	memcpy(XFRM_MODE_SKB_CB(skb)->flow_lbl, iph->flow_lbl,
-	       sizeof(XFRM_MODE_SKB_CB(skb)->flow_lbl));
-}
-
-int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	int err;
-
-	err = xfrm6_tunnel_check_size(skb);
-	if (err)
-		return err;
-
-	XFRM_MODE_SKB_CB(skb)->protocol = ipv6_hdr(skb)->nexthdr;
-
-	__xfrm6_extract_header(skb);
-	return 0;
-}
-
 int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb)
 {
 	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index 8fbf5a68ee6e..15247f2f78e1 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -19,7 +19,6 @@ static struct xfrm_state_afinfo xfrm6_state_afinfo = {
 	.proto			= IPPROTO_IPV6,
 	.output			= xfrm6_output,
 	.output_finish		= xfrm6_output_finish,
-	.extract_output		= xfrm6_extract_output,
 	.transport_finish	= xfrm6_transport_finish,
 	.local_error		= xfrm6_local_error,
 };
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index a7b3af7f7a1e..3a646df1318d 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -17,6 +17,11 @@
 #include <net/inet_ecn.h>
 #include <net/xfrm.h>
 
+#if IS_ENABLED(CONFIG_IPV6)
+#include <net/ip6_route.h>
+#include <net/ipv6_stubs.h>
+#endif
+
 #include "xfrm_inout.h"
 
 static int xfrm_output2(struct net *net, struct sock *sk, struct sk_buff *skb);
@@ -651,11 +656,60 @@ static int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static int xfrm6_tunnel_check_size(struct sk_buff *skb)
+{
+	int mtu, ret = 0;
+	struct dst_entry *dst = skb_dst(skb);
+
+	if (skb->ignore_df)
+		goto out;
+
+	mtu = dst_mtu(dst);
+	if (mtu < IPV6_MIN_MTU)
+		mtu = IPV6_MIN_MTU;
+
+	if ((!skb_is_gso(skb) && skb->len > mtu) ||
+	    (skb_is_gso(skb) &&
+	     !skb_gso_validate_network_len(skb, ip6_skb_dst_mtu(skb)))) {
+		skb->dev = dst->dev;
+		skb->protocol = htons(ETH_P_IPV6);
+
+		if (xfrm6_local_dontfrag(skb->sk))
+			ipv6_stub->xfrm6_local_rxpmtu(skb, mtu);
+		else if (skb->sk)
+			xfrm_local_error(skb, mtu);
+		else
+			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+		ret = -EMSGSIZE;
+	}
+out:
+	return ret;
+}
+#endif
+
+static int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	int err;
+
+	err = xfrm6_tunnel_check_size(skb);
+	if (err)
+		return err;
+
+	XFRM_MODE_SKB_CB(skb)->protocol = ipv6_hdr(skb)->nexthdr;
+
+	xfrm6_extract_header(skb);
+	return 0;
+#else
+	WARN_ON_ONCE(1);
+	return -EAFNOSUPPORT;
+#endif
+}
+
 static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
-	const struct xfrm_state_afinfo *afinfo;
 	const struct xfrm_mode *inner_mode;
-	int err = -EAFNOSUPPORT;
 
 	if (x->sel.family == AF_UNSPEC)
 		inner_mode = xfrm_ip2inner_mode(x,
@@ -669,14 +723,11 @@ static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 	switch (inner_mode->family) {
 	case AF_INET:
 		return xfrm4_extract_output(x, skb);
+	case AF_INET6:
+		return xfrm6_extract_output(x, skb);
 	}
-	rcu_read_lock();
-	afinfo = xfrm_state_afinfo_get_rcu(inner_mode->family);
-	if (likely(afinfo))
-		err = afinfo->extract_output(x, skb);
-	rcu_read_unlock();
 
-	return err;
+	return -EAFNOSUPPORT;
 }
 
 void xfrm_local_error(struct sk_buff *skb, int mtu)
-- 
2.26.2

