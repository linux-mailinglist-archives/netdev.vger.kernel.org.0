Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0361336B7D0
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237254AbhDZRNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:13:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51532 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbhDZRL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 070A164132;
        Mon, 26 Apr 2021 19:10:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 20/22] netfilter: nfnetlink: pass struct nfnl_info to batch callbacks
Date:   Mon, 26 Apr 2021 19:10:54 +0200
Message-Id: <20210426171056.345271-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update batch callbacks to use the nfnl_info structure. Rename one
clashing info variable to expr_info.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h |   6 +-
 net/netfilter/nf_tables_api.c       | 338 ++++++++++++++--------------
 net/netfilter/nfnetlink.c           |  14 +-
 3 files changed, 182 insertions(+), 176 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index c11f2f99eac4..df0e3254c57b 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -19,10 +19,8 @@ struct nfnl_callback {
 		    const struct nlattr * const cda[]);
 	int (*call_rcu)(struct sk_buff *skb, const struct nfnl_info *info,
 			const struct nlattr * const cda[]);
-	int (*call_batch)(struct net *net, struct sock *nl, struct sk_buff *skb,
-			  const struct nlmsghdr *nlh,
-			  const struct nlattr * const cda[],
-			  struct netlink_ext_ack *extack);
+	int (*call_batch)(struct sk_buff *skb, const struct nfnl_info *info,
+			  const struct nlattr * const cda[]);
 	const struct nla_policy *policy;	/* netlink attribute policy */
 	const u_int16_t attr_count;		/* number of nlattr's */
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f7c4e6f14130..280ca136df56 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1055,15 +1055,15 @@ static int nft_objname_hash_cmp(struct rhashtable_compare_arg *arg,
 	return strcmp(obj->key.name, k->name);
 }
 
-static int nf_tables_newtable(struct net *net, struct sock *nlsk,
-			      struct sk_buff *skb, const struct nlmsghdr *nlh,
-			      const struct nlattr * const nla[],
-			      struct netlink_ext_ack *extack)
+static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
+			      const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_next(net);
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
 	int family = nfmsg->nfgen_family;
+	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_table *table;
 	struct nft_ctx ctx;
@@ -1078,14 +1078,15 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 		if (PTR_ERR(table) != -ENOENT)
 			return PTR_ERR(table);
 	} else {
-		if (nlh->nlmsg_flags & NLM_F_EXCL) {
+		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return -EEXIST;
 		}
-		if (nlh->nlmsg_flags & NLM_F_REPLACE)
+		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+
 		return nf_tables_updtable(&ctx);
 	}
 
@@ -1126,7 +1127,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	if (table->flags & NFT_TABLE_F_OWNER)
 		table->nlpid = NETLINK_CB(skb).portid;
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
 	if (err < 0)
 		goto err_trans;
@@ -1250,19 +1251,19 @@ static int nft_flush(struct nft_ctx *ctx, int family)
 	return err;
 }
 
-static int nf_tables_deltable(struct net *net, struct sock *nlsk,
-			      struct sk_buff *skb, const struct nlmsghdr *nlh,
-			      const struct nlattr * const nla[],
-			      struct netlink_ext_ack *extack)
+static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
+			      const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_next(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
 	int family = nfmsg->nfgen_family;
+	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_table *table;
 	struct nft_ctx ctx;
 
-	nft_ctx_init(&ctx, net, skb, nlh, 0, NULL, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, 0, NULL, NULL, nla);
 	if (family == AF_UNSPEC ||
 	    (!nla[NFTA_TABLE_NAME] && !nla[NFTA_TABLE_HANDLE]))
 		return nft_flush(&ctx, family);
@@ -1281,7 +1282,7 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 		return PTR_ERR(table);
 	}
 
-	if (nlh->nlmsg_flags & NLM_F_NONREC &&
+	if (info->nlh->nlmsg_flags & NLM_F_NONREC &&
 	    table->use > 0)
 		return -EBUSY;
 
@@ -2350,16 +2351,16 @@ static struct nft_chain *nft_chain_lookup_byid(const struct net *net,
 	return ERR_PTR(-ENOENT);
 }
 
-static int nf_tables_newchain(struct net *net, struct sock *nlsk,
-			      struct sk_buff *skb, const struct nlmsghdr *nlh,
-			      const struct nlattr * const nla[],
-			      struct netlink_ext_ack *extack)
+static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
+			      const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_next(net);
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
 	int family = nfmsg->nfgen_family;
 	struct nft_chain *chain = NULL;
+	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_table *table;
 	u8 policy = NF_ACCEPT;
@@ -2431,14 +2432,14 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 	if (flags & ~NFT_CHAIN_FLAGS)
 		return -EOPNOTSUPP;
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	if (chain != NULL) {
-		if (nlh->nlmsg_flags & NLM_F_EXCL) {
+		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return -EEXIST;
 		}
-		if (nlh->nlmsg_flags & NLM_F_REPLACE)
+		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
 		flags |= chain->flags & NFT_CHAIN_BASE;
@@ -2449,14 +2450,14 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 	return nf_tables_addchain(&ctx, family, genmask, policy, flags);
 }
 
-static int nf_tables_delchain(struct net *net, struct sock *nlsk,
-			      struct sk_buff *skb, const struct nlmsghdr *nlh,
-			      const struct nlattr * const nla[],
-			      struct netlink_ext_ack *extack)
+static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
+			      const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_next(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
 	int family = nfmsg->nfgen_family;
+	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_table *table;
 	struct nft_chain *chain;
@@ -2486,11 +2487,11 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 		return PTR_ERR(chain);
 	}
 
-	if (nlh->nlmsg_flags & NLM_F_NONREC &&
+	if (info->nlh->nlmsg_flags & NLM_F_NONREC &&
 	    chain->use > 0)
 		return -EBUSY;
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	use = chain->use;
 	list_for_each_entry(rule, &chain->rules, list) {
@@ -2713,15 +2714,15 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 }
 
 static int nf_tables_newexpr(const struct nft_ctx *ctx,
-			     const struct nft_expr_info *info,
+			     const struct nft_expr_info *expr_info,
 			     struct nft_expr *expr)
 {
-	const struct nft_expr_ops *ops = info->ops;
+	const struct nft_expr_ops *ops = expr_info->ops;
 	int err;
 
 	expr->ops = ops;
 	if (ops->init) {
-		err = ops->init(ctx, expr, (const struct nlattr **)info->tb);
+		err = ops->init(ctx, expr, (const struct nlattr **)expr_info->tb);
 		if (err < 0)
 			goto err1;
 	}
@@ -2745,21 +2746,21 @@ static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
 static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 				      const struct nlattr *nla)
 {
-	struct nft_expr_info info;
+	struct nft_expr_info expr_info;
 	struct nft_expr *expr;
 	struct module *owner;
 	int err;
 
-	err = nf_tables_expr_parse(ctx, nla, &info);
+	err = nf_tables_expr_parse(ctx, nla, &expr_info);
 	if (err < 0)
 		goto err1;
 
 	err = -ENOMEM;
-	expr = kzalloc(info.ops->size, GFP_KERNEL);
+	expr = kzalloc(expr_info.ops->size, GFP_KERNEL);
 	if (expr == NULL)
 		goto err2;
 
-	err = nf_tables_newexpr(ctx, &info, expr);
+	err = nf_tables_newexpr(ctx, &expr_info, expr);
 	if (err < 0)
 		goto err3;
 
@@ -2767,9 +2768,9 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 err3:
 	kfree(expr);
 err2:
-	owner = info.ops->type->owner;
-	if (info.ops->type->release_ops)
-		info.ops->type->release_ops(info.ops);
+	owner = expr_info.ops->type->owner;
+	if (expr_info.ops->type->release_ops)
+		expr_info.ops->type->release_ops(expr_info.ops);
 
 	module_put(owner);
 err1:
@@ -3216,28 +3217,28 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 
 #define NFT_RULE_MAXEXPRS	128
 
-static int nf_tables_newrule(struct net *net, struct sock *nlsk,
-			     struct sk_buff *skb, const struct nlmsghdr *nlh,
-			     const struct nlattr * const nla[],
-			     struct netlink_ext_ack *extack)
+static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_next(net);
-	struct nft_expr_info *info = NULL;
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	unsigned int size, i, n, ulen = 0, usize = 0;
+	u8 genmask = nft_genmask_next(info->net);
+	struct nft_rule *rule, *old_rule = NULL;
+	struct nft_expr_info *expr_info = NULL;
 	int family = nfmsg->nfgen_family;
+	struct net *net = info->net;
 	struct nft_flow_rule *flow;
+	struct nft_userdata *udata;
 	struct nft_table *table;
 	struct nft_chain *chain;
-	struct nft_rule *rule, *old_rule = NULL;
-	struct nft_userdata *udata;
-	struct nft_trans *trans = NULL;
+	struct nft_trans *trans;
+	u64 handle, pos_handle;
 	struct nft_expr *expr;
 	struct nft_ctx ctx;
 	struct nlattr *tmp;
-	unsigned int size, i, n, ulen = 0, usize = 0;
 	int err, rem;
-	u64 handle, pos_handle;
 
 	lockdep_assert_held(&nft_net->commit_mutex);
 
@@ -3276,17 +3277,17 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 			return PTR_ERR(rule);
 		}
 
-		if (nlh->nlmsg_flags & NLM_F_EXCL) {
+		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
 			return -EEXIST;
 		}
-		if (nlh->nlmsg_flags & NLM_F_REPLACE)
+		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			old_rule = rule;
 		else
 			return -EOPNOTSUPP;
 	} else {
-		if (!(nlh->nlmsg_flags & NLM_F_CREATE) ||
-		    nlh->nlmsg_flags & NLM_F_REPLACE)
+		if (!(info->nlh->nlmsg_flags & NLM_F_CREATE) ||
+		    info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EINVAL;
 		handle = nf_tables_alloc_handle(table);
 
@@ -3309,15 +3310,15 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		}
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	n = 0;
 	size = 0;
 	if (nla[NFTA_RULE_EXPRESSIONS]) {
-		info = kvmalloc_array(NFT_RULE_MAXEXPRS,
-				      sizeof(struct nft_expr_info),
-				      GFP_KERNEL);
-		if (!info)
+		expr_info = kvmalloc_array(NFT_RULE_MAXEXPRS,
+					   sizeof(struct nft_expr_info),
+					   GFP_KERNEL);
+		if (!expr_info)
 			return -ENOMEM;
 
 		nla_for_each_nested(tmp, nla[NFTA_RULE_EXPRESSIONS], rem) {
@@ -3326,10 +3327,10 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 				goto err1;
 			if (n == NFT_RULE_MAXEXPRS)
 				goto err1;
-			err = nf_tables_expr_parse(&ctx, tmp, &info[n]);
+			err = nf_tables_expr_parse(&ctx, tmp, &expr_info[n]);
 			if (err < 0)
 				goto err1;
-			size += info[n].ops->size;
+			size += expr_info[n].ops->size;
 			n++;
 		}
 	}
@@ -3363,20 +3364,20 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 
 	expr = nft_expr_first(rule);
 	for (i = 0; i < n; i++) {
-		err = nf_tables_newexpr(&ctx, &info[i], expr);
+		err = nf_tables_newexpr(&ctx, &expr_info[i], expr);
 		if (err < 0) {
-			NL_SET_BAD_ATTR(extack, info[i].attr);
+			NL_SET_BAD_ATTR(extack, expr_info[i].attr);
 			goto err2;
 		}
 
-		if (info[i].ops->validate)
+		if (expr_info[i].ops->validate)
 			nft_validate_state_update(net, NFT_VALIDATE_NEED);
 
-		info[i].ops = NULL;
+		expr_info[i].ops = NULL;
 		expr = nft_expr_next(expr);
 	}
 
-	if (nlh->nlmsg_flags & NLM_F_REPLACE) {
+	if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
 		if (trans == NULL) {
 			err = -ENOMEM;
@@ -3396,7 +3397,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 			goto err2;
 		}
 
-		if (nlh->nlmsg_flags & NLM_F_APPEND) {
+		if (info->nlh->nlmsg_flags & NLM_F_APPEND) {
 			if (old_rule)
 				list_add_rcu(&rule->list, &old_rule->list);
 			else
@@ -3408,7 +3409,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 				list_add_rcu(&rule->list, &chain->rules);
 		}
 	}
-	kvfree(info);
+	kvfree(expr_info);
 	chain->use++;
 
 	if (nft_net->validate_state == NFT_VALIDATE_DO)
@@ -3427,13 +3428,14 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	nf_tables_rule_release(&ctx, rule);
 err1:
 	for (i = 0; i < n; i++) {
-		if (info[i].ops) {
-			module_put(info[i].ops->type->owner);
-			if (info[i].ops->type->release_ops)
-				info[i].ops->type->release_ops(info[i].ops);
+		if (expr_info[i].ops) {
+			module_put(expr_info[i].ops->type->owner);
+			if (expr_info[i].ops->type->release_ops)
+				expr_info[i].ops->type->release_ops(expr_info[i].ops);
 		}
 	}
-	kvfree(info);
+	kvfree(expr_info);
+
 	return err;
 }
 
@@ -3454,17 +3456,17 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 	return ERR_PTR(-ENOENT);
 }
 
-static int nf_tables_delrule(struct net *net, struct sock *nlsk,
-			     struct sk_buff *skb, const struct nlmsghdr *nlh,
-			     const struct nlattr * const nla[],
-			     struct netlink_ext_ack *extack)
+static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_next(net);
-	struct nft_table *table;
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	int family = nfmsg->nfgen_family, err = 0;
+	u8 genmask = nft_genmask_next(info->net);
 	struct nft_chain *chain = NULL;
+	struct net *net = info->net;
+	struct nft_table *table;
 	struct nft_rule *rule;
-	int family = nfmsg->nfgen_family, err = 0;
 	struct nft_ctx ctx;
 
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask,
@@ -3485,7 +3487,7 @@ static int nf_tables_delrule(struct net *net, struct sock *nlsk,
 			return -EOPNOTSUPP;
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	if (chain) {
 		if (nla[NFTA_RULE_HANDLE]) {
@@ -4166,28 +4168,27 @@ static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 	return err;
 }
 
-static int nf_tables_newset(struct net *net, struct sock *nlsk,
-			    struct sk_buff *skb, const struct nlmsghdr *nlh,
-			    const struct nlattr * const nla[],
-			    struct netlink_ext_ack *extack)
+static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_next(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	u32 ktype, dtype, flags, policy, gc_int, objtype;
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
 	int family = nfmsg->nfgen_family;
 	const struct nft_set_ops *ops;
 	struct nft_expr *expr = NULL;
+	struct net *net = info->net;
+	struct nft_set_desc desc;
 	struct nft_table *table;
+	unsigned char *udata;
 	struct nft_set *set;
 	struct nft_ctx ctx;
-	char *name;
-	u64 size;
 	u64 timeout;
-	u32 ktype, dtype, flags, policy, gc_int, objtype;
-	struct nft_set_desc desc;
-	unsigned char *udata;
+	char *name;
+	int err, i;
 	u16 udlen;
-	int err;
-	int i;
+	u64 size;
 
 	if (nla[NFTA_SET_TABLE] == NULL ||
 	    nla[NFTA_SET_NAME] == NULL ||
@@ -4295,7 +4296,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		return PTR_ERR(table);
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	set = nft_set_lookup(table, nla[NFTA_SET_NAME], genmask);
 	if (IS_ERR(set)) {
@@ -4304,17 +4305,17 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			return PTR_ERR(set);
 		}
 	} else {
-		if (nlh->nlmsg_flags & NLM_F_EXCL) {
+		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
 			return -EEXIST;
 		}
-		if (nlh->nlmsg_flags & NLM_F_REPLACE)
+		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
 		return 0;
 	}
 
-	if (!(nlh->nlmsg_flags & NLM_F_CREATE))
+	if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
 		return -ENOENT;
 
 	ops = nft_select_set_ops(&ctx, nla, &desc, policy);
@@ -4448,13 +4449,13 @@ static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 	kvfree(set);
 }
 
-static int nf_tables_delset(struct net *net, struct sock *nlsk,
-			    struct sk_buff *skb, const struct nlmsghdr *nlh,
-			    const struct nlattr * const nla[],
-			    struct netlink_ext_ack *extack)
+static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_next(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
+	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_set *set;
 	struct nft_ctx ctx;
@@ -4465,7 +4466,7 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 	if (nla[NFTA_SET_TABLE] == NULL)
 		return -EINVAL;
 
-	err = nft_ctx_init_from_setattr(&ctx, net, skb, nlh, nla, extack,
+	err = nft_ctx_init_from_setattr(&ctx, net, skb, info->nlh, nla, extack,
 					genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
@@ -4483,7 +4484,8 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 		return PTR_ERR(set);
 	}
 	if (set->use ||
-	    (nlh->nlmsg_flags & NLM_F_NONREC && atomic_read(&set->nelems) > 0)) {
+	    (info->nlh->nlmsg_flags & NLM_F_NONREC &&
+	     atomic_read(&set->nelems) > 0)) {
 		NL_SET_BAD_ATTR(extack, attr);
 		return -EBUSY;
 	}
@@ -5654,13 +5656,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	return err;
 }
 
-static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
-				struct sk_buff *skb, const struct nlmsghdr *nlh,
-				const struct nlattr * const nla[],
-				struct netlink_ext_ack *extack)
+static int nf_tables_newsetelem(struct sk_buff *skb,
+				const struct nfnl_info *info,
+				const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
-	u8 genmask = nft_genmask_next(net);
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
+	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_set *set;
 	struct nft_ctx ctx;
@@ -5669,7 +5672,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL)
 		return -EINVAL;
 
-	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, extack,
+	err = nft_ctx_init_from_elemattr(&ctx, net, skb, info->nlh, nla, extack,
 					 genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
@@ -5683,7 +5686,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 		return -EBUSY;
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_add_set_elem(&ctx, set, attr, nlh->nlmsg_flags);
+		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags);
 		if (err < 0)
 			return err;
 	}
@@ -5866,18 +5869,19 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 	return err;
 }
 
-static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
-				struct sk_buff *skb, const struct nlmsghdr *nlh,
-				const struct nlattr * const nla[],
-				struct netlink_ext_ack *extack)
+static int nf_tables_delsetelem(struct sk_buff *skb,
+				const struct nfnl_info *info,
+				const struct nlattr * const nla[])
 {
-	u8 genmask = nft_genmask_next(net);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
+	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_set *set;
 	struct nft_ctx ctx;
 	int rem, err = 0;
 
-	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, extack,
+	err = nft_ctx_init_from_elemattr(&ctx, net, skb, info->nlh, nla, extack,
 					 genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
@@ -6161,15 +6165,15 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	return err;
 }
 
-static int nf_tables_newobj(struct net *net, struct sock *nlsk,
-			    struct sk_buff *skb, const struct nlmsghdr *nlh,
-			    const struct nlattr * const nla[],
-			    struct netlink_ext_ack *extack)
+static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
 	const struct nft_object_type *type;
-	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
+	struct net *net = info->net;
 	struct nft_table *table;
 	struct nft_object *obj;
 	struct nft_ctx ctx;
@@ -6197,20 +6201,20 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 			return err;
 		}
 	} else {
-		if (nlh->nlmsg_flags & NLM_F_EXCL) {
+		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_NAME]);
 			return -EEXIST;
 		}
-		if (nlh->nlmsg_flags & NLM_F_REPLACE)
+		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
 		type = __nft_obj_type_get(objtype);
-		nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	type = nft_obj_type_get(net, objtype);
 	if (IS_ERR(type))
@@ -6507,14 +6511,14 @@ static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
 	kfree(obj);
 }
 
-static int nf_tables_delobj(struct net *net, struct sock *nlsk,
-			    struct sk_buff *skb, const struct nlmsghdr *nlh,
-			    const struct nlattr * const nla[],
-			    struct netlink_ext_ack *extack)
+static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_next(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
 	int family = nfmsg->nfgen_family;
+	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_table *table;
 	struct nft_object *obj;
@@ -6550,7 +6554,7 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 		return -EBUSY;
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	return nft_delobj(&ctx, obj);
 }
@@ -6937,19 +6941,19 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 
 }
 
-static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
-				  struct sk_buff *skb,
-				  const struct nlmsghdr *nlh,
-				  const struct nlattr * const nla[],
-				  struct netlink_ext_ack *extack)
+static int nf_tables_newflowtable(struct sk_buff *skb,
+				  const struct nfnl_info *info,
+				  const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
 	struct nft_flowtable_hook flowtable_hook;
+	u8 genmask = nft_genmask_next(info->net);
 	const struct nf_flowtable_type *type;
-	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
 	struct nft_flowtable *flowtable;
 	struct nft_hook *hook, *next;
+	struct net *net = info->net;
 	struct nft_table *table;
 	struct nft_ctx ctx;
 	int err;
@@ -6975,17 +6979,17 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 			return err;
 		}
 	} else {
-		if (nlh->nlmsg_flags & NLM_F_EXCL) {
+		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_NAME]);
 			return -EEXIST;
 		}
 
-		nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
-		return nft_flowtable_update(&ctx, nlh, flowtable);
+		return nft_flowtable_update(&ctx, info->nlh, flowtable);
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	flowtable = kzalloc(sizeof(*flowtable), GFP_KERNEL);
 	if (!flowtable)
@@ -7126,16 +7130,16 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	return err;
 }
 
-static int nf_tables_delflowtable(struct net *net, struct sock *nlsk,
-				  struct sk_buff *skb,
-				  const struct nlmsghdr *nlh,
-				  const struct nlattr * const nla[],
-				  struct netlink_ext_ack *extack)
+static int nf_tables_delflowtable(struct sk_buff *skb,
+				  const struct nfnl_info *info,
+				  const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_next(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_next(info->net);
 	int family = nfmsg->nfgen_family;
 	struct nft_flowtable *flowtable;
+	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_table *table;
 	struct nft_ctx ctx;
@@ -7165,7 +7169,7 @@ static int nf_tables_delflowtable(struct net *net, struct sock *nlsk,
 		return PTR_ERR(flowtable);
 	}
 
-	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	if (nla[NFTA_FLOWTABLE_HOOK])
 		return nft_delflowtable_hook(&ctx, flowtable);
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7920f6c4ff69..e62c5af4b631 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -469,10 +469,17 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		{
 			int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
+			struct nfnl_net *nfnlnet = nfnl_pernet(net);
 			u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
 			struct nlattr *cda[NFNL_MAX_ATTR_COUNT + 1];
 			struct nlattr *attr = (void *)nlh + min_len;
 			int attrlen = nlh->nlmsg_len - min_len;
+			struct nfnl_info info = {
+				.net	= net,
+				.sk	= nfnlnet->nfnl,
+				.nlh	= nlh,
+				.extack	= &extack,
+			};
 
 			/* Sanity-check NFTA_MAX_ATTR */
 			if (ss->cb[cb_id].attr_count > NFNL_MAX_ATTR_COUNT) {
@@ -488,11 +495,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 				goto ack;
 
 			if (nc->call_batch) {
-				struct nfnl_net *nfnlnet = nfnl_pernet(net);
-
-				err = nc->call_batch(net, nfnlnet->nfnl, skb, nlh,
-						     (const struct nlattr **)cda,
-						     &extack);
+				err = nc->call_batch(skb, &info,
+						     (const struct nlattr **)cda);
 			}
 
 			/* The lock was released to autoload some module, we
-- 
2.30.2

