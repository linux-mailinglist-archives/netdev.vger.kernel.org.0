Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CC5250477
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgHXRDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbgHXQih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6589922EBF;
        Mon, 24 Aug 2020 16:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287096;
        bh=AJ5GY7sStFFpN4d2wp55vrmNmGGsqU3GnYKHqvcwtPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NcTrTsiYfvGpMlRCWhEfukPMsIP/Z3L5oO1AGkAlWbBI0mdxRdkZg/1xMSzI5vot
         xo08f3suUM5NeU9AhuGwhmUm6NW1LN1jgS/INHzTigC2Yw/nIeXFD+h0AYaAYfFkou
         NzalKI5dq/MTKq+YQNa11uvrX0Y8vI7y5bLEU5zI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/38] netfilter: avoid ipv6 -> nf_defrag_ipv6 module dependency
Date:   Mon, 24 Aug 2020 12:37:30 -0400
Message-Id: <20200824163751.606577-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163751.606577-1-sashal@kernel.org>
References: <20200824163751.606577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 2404b73c3f1a5f15726c6ecd226b56f6f992767f ]

nf_ct_frag6_gather is part of nf_defrag_ipv6.ko, not ipv6 core.

The current use of the netfilter ipv6 stub indirections  causes a module
dependency between ipv6 and nf_defrag_ipv6.

This prevents nf_defrag_ipv6 module from being removed because ipv6 can't
be unloaded.

Remove the indirection and always use a direct call.  This creates a
depency from nf_conntrack_bridge to nf_defrag_ipv6 instead:

modinfo nf_conntrack
depends:        nf_conntrack,nf_defrag_ipv6,bridge

.. and nf_conntrack already depends on nf_defrag_ipv6 anyway.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter_ipv6.h             | 18 ------------------
 net/bridge/netfilter/nf_conntrack_bridge.c |  8 ++++++--
 net/ipv6/netfilter.c                       |  3 ---
 3 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index aac42c28fe62d..9b67394471e1c 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -58,7 +58,6 @@ struct nf_ipv6_ops {
 			int (*output)(struct net *, struct sock *, struct sk_buff *));
 	int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
 #if IS_MODULE(CONFIG_IPV6)
-	int (*br_defrag)(struct net *net, struct sk_buff *skb, u32 user);
 	int (*br_fragment)(struct net *net, struct sock *sk,
 			   struct sk_buff *skb,
 			   struct nf_bridge_frag_data *data,
@@ -117,23 +116,6 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
 
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 
-static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
-				    u32 user)
-{
-#if IS_MODULE(CONFIG_IPV6)
-	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
-
-	if (!v6_ops)
-		return 1;
-
-	return v6_ops->br_defrag(net, skb, user);
-#elif IS_BUILTIN(CONFIG_IPV6)
-	return nf_ct_frag6_gather(net, skb, user);
-#else
-	return 1;
-#endif
-}
-
 int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		    struct nf_bridge_frag_data *data,
 		    int (*output)(struct net *, struct sock *sk,
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8096732223828..8d033a75a766e 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -168,6 +168,7 @@ static unsigned int nf_ct_br_defrag4(struct sk_buff *skb,
 static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
 				     const struct nf_hook_state *state)
 {
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
 	enum ip_conntrack_info ctinfo;
 	struct br_input_skb_cb cb;
@@ -180,14 +181,17 @@ static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
 
 	br_skb_cb_save(skb, &cb, sizeof(struct inet6_skb_parm));
 
-	err = nf_ipv6_br_defrag(state->net, skb,
-				IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);
+	err = nf_ct_frag6_gather(state->net, skb,
+				 IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);
 	/* queued */
 	if (err == -EINPROGRESS)
 		return NF_STOLEN;
 
 	br_skb_cb_restore(skb, &cb, IP6CB(skb)->frag_max_size);
 	return err == 0 ? NF_ACCEPT : NF_DROP;
+#else
+	return NF_ACCEPT;
+#endif
 }
 
 static int nf_ct_br_ip_check(const struct sk_buff *skb)
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 409e79b84a830..6d0e942d082d4 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -245,9 +245,6 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
-#if IS_MODULE(CONFIG_IPV6) && IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
-	.br_defrag		= nf_ct_frag6_gather,
-#endif
 #if IS_MODULE(CONFIG_IPV6)
 	.br_fragment		= br_ip6_fragment,
 #endif
-- 
2.25.1

