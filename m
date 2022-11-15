Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5A6629515
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237901AbiKOJ7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238051AbiKOJ73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:59:29 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E81A23BDE;
        Tue, 15 Nov 2022 01:59:27 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 4/6] netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RESET
Date:   Tue, 15 Nov 2022 10:59:20 +0100
Message-Id: <20221115095922.139954-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115095922.139954-1-pablo@netfilter.org>
References: <20221115095922.139954-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Analogous to NFT_MSG_GETOBJ_RESET, but for rules: Reset stateful
expressions like counters or quotas. The latter two are the only
consumers, adjust their 'dump' callbacks to respect the parameter
introduced earlier.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  2 +-
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nf_tables_api.c            | 49 ++++++++++++++++--------
 net/netfilter/nft_counter.c              |  2 +-
 net/netfilter/nft_dynset.c               |  4 +-
 net/netfilter/nft_inner.c                |  2 +-
 net/netfilter/nft_quota.c                |  2 +-
 7 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c557a57fb0f1..e69ce23566ea 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -383,7 +383,7 @@ int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
-		  const struct nft_expr *expr);
+		  const struct nft_expr *expr, bool reset);
 bool nft_expr_reduce_bitwise(struct nft_regs_track *track,
 			     const struct nft_expr *expr);
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e4b739d57480..cfa844da1ce6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -97,6 +97,7 @@ enum nft_verdicts {
  * @NFT_MSG_NEWFLOWTABLE: add new flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_DELFLOWTABLE: delete flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_GETRULE_RESET: get rules and reset stateful expressions (enum nft_obj_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -124,6 +125,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_GETRULE_RESET,
 	NFT_MSG_MAX,
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 741a0e386406..80e613405f6f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2759,7 +2759,7 @@ static const struct nla_policy nft_expr_policy[NFTA_EXPR_MAX + 1] = {
 };
 
 static int nf_tables_fill_expr_info(struct sk_buff *skb,
-				    const struct nft_expr *expr)
+				    const struct nft_expr *expr, bool reset)
 {
 	if (nla_put_string(skb, NFTA_EXPR_NAME, expr->ops->type->name))
 		goto nla_put_failure;
@@ -2769,7 +2769,7 @@ static int nf_tables_fill_expr_info(struct sk_buff *skb,
 							    NFTA_EXPR_DATA);
 		if (data == NULL)
 			goto nla_put_failure;
-		if (expr->ops->dump(skb, expr, false) < 0)
+		if (expr->ops->dump(skb, expr, reset) < 0)
 			goto nla_put_failure;
 		nla_nest_end(skb, data);
 	}
@@ -2781,14 +2781,14 @@ static int nf_tables_fill_expr_info(struct sk_buff *skb,
 };
 
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
-		  const struct nft_expr *expr)
+		  const struct nft_expr *expr, bool reset)
 {
 	struct nlattr *nest;
 
 	nest = nla_nest_start_noflag(skb, attr);
 	if (!nest)
 		goto nla_put_failure;
-	if (nf_tables_fill_expr_info(skb, expr) < 0)
+	if (nf_tables_fill_expr_info(skb, expr, reset) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
 	return 0;
@@ -3034,7 +3034,8 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 				    u32 flags, int family,
 				    const struct nft_table *table,
 				    const struct nft_chain *chain,
-				    const struct nft_rule *rule, u64 handle)
+				    const struct nft_rule *rule, u64 handle,
+				    bool reset)
 {
 	struct nlmsghdr *nlh;
 	const struct nft_expr *expr, *next;
@@ -3067,7 +3068,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 	if (list == NULL)
 		goto nla_put_failure;
 	nft_rule_for_each_expr(expr, next, rule) {
-		if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
+		if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, list);
@@ -3118,7 +3119,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 
 	err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
 				       event, flags, ctx->family, ctx->table,
-				       ctx->chain, rule, handle);
+				       ctx->chain, rule, handle, false);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -3139,7 +3140,8 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 				  unsigned int *idx,
 				  struct netlink_callback *cb,
 				  const struct nft_table *table,
-				  const struct nft_chain *chain)
+				  const struct nft_chain *chain,
+				  bool reset)
 {
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
@@ -3166,7 +3168,7 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule, handle) < 0)
+					table, chain, rule, handle, reset) < 0)
 			return 1;
 
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -3189,6 +3191,10 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
+	bool reset = false;
+
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		reset = true;
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
@@ -3213,14 +3219,15 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 				if (!nft_is_active(net, chain))
 					continue;
 				__nf_tables_dump_rules(skb, &idx,
-						       cb, table, chain);
+						       cb, table, chain, reset);
 				break;
 			}
 			goto done;
 		}
 
 		list_for_each_entry_rcu(chain, &table->chains, list) {
-			if (__nf_tables_dump_rules(skb, &idx, cb, table, chain))
+			if (__nf_tables_dump_rules(skb, &idx,
+						   cb, table, chain, reset))
 				goto done;
 		}
 
@@ -3291,6 +3298,7 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct sk_buff *skb2;
+	bool reset = false;
 	int err;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
@@ -3327,9 +3335,12 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!skb2)
 		return -ENOMEM;
 
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
+		reset = true;
+
 	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
 				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
-				       family, table, chain, rule, 0);
+				       family, table, chain, rule, 0, reset);
 	if (err < 0)
 		goto err_fill_rule_info;
 
@@ -4104,7 +4115,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 
 	if (set->num_exprs == 1) {
 		nest = nla_nest_start_noflag(skb, NFTA_SET_EXPR);
-		if (nf_tables_fill_expr_info(skb, set->exprs[0]) < 0)
+		if (nf_tables_fill_expr_info(skb, set->exprs[0], false) < 0)
 			goto nla_put_failure;
 
 		nla_nest_end(skb, nest);
@@ -4115,7 +4126,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 
 		for (i = 0; i < set->num_exprs; i++) {
 			if (nft_expr_dump(skb, NFTA_LIST_ELEM,
-					  set->exprs[i]) < 0)
+					  set->exprs[i], false) < 0)
 				goto nla_put_failure;
 		}
 		nla_nest_end(skb, nest);
@@ -4946,7 +4957,7 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 	if (num_exprs == 1) {
 		expr = nft_setelem_expr_at(elem_expr, 0);
-		if (nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, expr) < 0)
+		if (nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, expr, false) < 0)
 			return -1;
 
 		return 0;
@@ -4957,7 +4968,7 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 
 		nft_setelem_expr_foreach(expr, elem_expr, size) {
 			expr = nft_setelem_expr_at(elem_expr, size);
-			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, false) < 0)
 				goto nla_put_failure;
 		}
 		nla_nest_end(skb, nest);
@@ -8311,6 +8322,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
 	},
+	[NFT_MSG_GETRULE_RESET] = {
+		.call		= nf_tables_getrule,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_RULE_MAX,
+		.policy		= nft_rule_policy,
+	},
 	[NFT_MSG_DELRULE] = {
 		.call		= nf_tables_delrule,
 		.type		= NFNL_CB_BATCH,
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 06482fb9c145..dccc68a5135a 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -206,7 +206,7 @@ static int nft_counter_dump(struct sk_buff *skb,
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
 
-	return nft_counter_do_dump(skb, priv, false);
+	return nft_counter_do_dump(skb, priv, reset);
 }
 
 static int nft_counter_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 01c61e090639..274579b1696e 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -380,7 +380,7 @@ static int nft_dynset_dump(struct sk_buff *skb,
 	if (priv->set->num_exprs == 0) {
 		if (priv->num_exprs == 1) {
 			if (nft_expr_dump(skb, NFTA_DYNSET_EXPR,
-					  priv->expr_array[0]))
+					  priv->expr_array[0], reset))
 				goto nla_put_failure;
 		} else if (priv->num_exprs > 1) {
 			struct nlattr *nest;
@@ -391,7 +391,7 @@ static int nft_dynset_dump(struct sk_buff *skb,
 
 			for (i = 0; i < priv->num_exprs; i++) {
 				if (nft_expr_dump(skb, NFTA_LIST_ELEM,
-						  priv->expr_array[i]))
+						  priv->expr_array[i], reset))
 					goto nla_put_failure;
 			}
 			nla_nest_end(skb, nest);
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 6d96b826db4e..28e2873ba24e 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -359,7 +359,7 @@ static int nft_inner_dump(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nft_expr_dump(skb, NFTA_INNER_EXPR,
-			  (struct nft_expr *)&priv->expr) < 0)
+			  (struct nft_expr *)&priv->expr, reset) < 0)
 		goto nla_put_failure;
 
 	return 0;
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index b1a1217bca4c..123578e28917 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -222,7 +222,7 @@ static int nft_quota_dump(struct sk_buff *skb,
 {
 	struct nft_quota *priv = nft_expr_priv(expr);
 
-	return nft_quota_do_dump(skb, priv, false);
+	return nft_quota_do_dump(skb, priv, reset);
 }
 
 static void nft_quota_destroy(const struct nft_ctx *ctx,
-- 
2.30.2

