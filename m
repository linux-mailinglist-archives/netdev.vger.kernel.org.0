Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB382245446
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgHOWTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:19:07 -0400
Received: from correo.us.es ([193.147.175.20]:38946 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728968AbgHOWS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 18:18:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2C9FBDA888
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D825DA84A
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 13149DA73F; Sat, 15 Aug 2020 12:32:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E26CADA722;
        Sat, 15 Aug 2020 12:32:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 15 Aug 2020 12:32:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.48.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id F2EEA42EF4E0;
        Sat, 15 Aug 2020 12:32:15 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/8] netfilter: avoid ipv6 -> nf_defrag_ipv6 module dependency
Date:   Sat, 15 Aug 2020 12:31:56 +0200
Message-Id: <20200815103201.1768-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200815103201.1768-1-pablo@netfilter.org>
References: <20200815103201.1768-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
---
 include/linux/netfilter_ipv6.h             | 18 ------------------
 net/bridge/netfilter/nf_conntrack_bridge.c |  8 ++++++--
 net/ipv6/netfilter.c                       |  3 ---
 3 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index aac42c28fe62..9b67394471e1 100644
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
index 809673222382..8d033a75a766 100644
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
index 409e79b84a83..6d0e942d082d 100644
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
2.20.1

