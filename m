Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17F441CFB4
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347425AbhI2XGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:06:54 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34770 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347366AbhI2XGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 19:06:48 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 279D663ECB;
        Thu, 30 Sep 2021 01:03:41 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/5] netfilter: nf_tables: add position handle in event notification
Date:   Thu, 30 Sep 2021 01:04:57 +0200
Message-Id: <20210929230500.811946-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929230500.811946-1-pablo@netfilter.org>
References: <20210929230500.811946-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add position handle to allow to identify the rule location from netlink
events. Otherwise, userspace cannot incrementally update a userspace
cache through monitoring events.

Skip handle dump if the rule has been either inserted (at the beginning
of the ruleset) or appended (at the end of the ruleset), the
NLM_F_APPEND netlink flag is sufficient in these two cases.

Handle NLM_F_REPLACE as NLM_F_APPEND since the rule replacement
expansion appends it after the specified rule handle.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b9546defdc28..085783b14075 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2866,8 +2866,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 				    u32 flags, int family,
 				    const struct nft_table *table,
 				    const struct nft_chain *chain,
-				    const struct nft_rule *rule,
-				    const struct nft_rule *prule)
+				    const struct nft_rule *rule, u64 handle)
 {
 	struct nlmsghdr *nlh;
 	const struct nft_expr *expr, *next;
@@ -2887,9 +2886,8 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 			 NFTA_RULE_PAD))
 		goto nla_put_failure;
 
-	if (event != NFT_MSG_DELRULE && prule) {
-		if (nla_put_be64(skb, NFTA_RULE_POSITION,
-				 cpu_to_be64(prule->handle),
+	if (event != NFT_MSG_DELRULE && handle) {
+		if (nla_put_be64(skb, NFTA_RULE_POSITION, cpu_to_be64(handle),
 				 NFTA_RULE_PAD))
 			goto nla_put_failure;
 	}
@@ -2925,7 +2923,10 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 				  const struct nft_rule *rule, int event)
 {
 	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
+	const struct nft_rule *prule;
 	struct sk_buff *skb;
+	u64 handle = 0;
+	u16 flags = 0;
 	int err;
 
 	if (!ctx->report &&
@@ -2936,9 +2937,18 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 	if (skb == NULL)
 		goto err;
 
+	if (event == NFT_MSG_NEWRULE &&
+	    !list_is_first(&rule->list, &ctx->chain->rules) &&
+	    !list_is_last(&rule->list, &ctx->chain->rules)) {
+		prule = list_prev_entry(rule, list);
+		handle = prule->handle;
+	}
+	if (ctx->flags & (NLM_F_APPEND | NLM_F_REPLACE))
+		flags |= NLM_F_APPEND;
+
 	err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
-				       event, 0, ctx->family, ctx->table,
-				       ctx->chain, rule, NULL);
+				       event, flags, ctx->family, ctx->table,
+				       ctx->chain, rule, handle);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -2964,6 +2974,7 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
 	unsigned int s_idx = cb->args[0];
+	u64 handle;
 
 	prule = NULL;
 	list_for_each_entry_rcu(rule, &chain->rules, list) {
@@ -2975,12 +2986,17 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 			memset(&cb->args[1], 0,
 					sizeof(cb->args) - sizeof(cb->args[0]));
 		}
+		if (prule)
+			handle = prule->handle;
+		else
+			handle = 0;
+
 		if (nf_tables_fill_rule_info(skb, net, NETLINK_CB(cb->skb).portid,
 					cb->nlh->nlmsg_seq,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule, prule) < 0)
+					table, chain, rule, handle) < 0)
 			return 1;
 
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -3143,7 +3159,7 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
 				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
-				       family, table, chain, rule, NULL);
+				       family, table, chain, rule, 0);
 	if (err < 0)
 		goto err_fill_rule_info;
 
-- 
2.30.2

