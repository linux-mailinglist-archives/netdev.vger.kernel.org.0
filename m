Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2676A6EB576
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbjDUXDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbjDUXCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:02:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FE5330DA;
        Fri, 21 Apr 2023 16:02:27 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 18/20] netfilter: nf_tables: support for adding new devices to an existing netdev chain
Date:   Sat, 22 Apr 2023 01:02:09 +0200
Message-Id: <20230421230211.214635-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421230211.214635-1-pablo@netfilter.org>
References: <20230421230211.214635-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows users to add devices to an existing netdev chain.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   6 +
 net/netfilter/nf_tables_api.c     | 217 +++++++++++++++++++-----------
 2 files changed, 142 insertions(+), 81 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 58a4d217faaf..3ed21d2d5659 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1609,6 +1609,8 @@ struct nft_trans_chain {
 	struct nft_stats __percpu	*stats;
 	u8				policy;
 	u32				chain_id;
+	struct nft_base_chain		*basechain;
+	struct list_head		hook_list;
 };
 
 #define nft_trans_chain_update(trans)	\
@@ -1621,6 +1623,10 @@ struct nft_trans_chain {
 	(((struct nft_trans_chain *)trans->data)->policy)
 #define nft_trans_chain_id(trans)	\
 	(((struct nft_trans_chain *)trans->data)->chain_id)
+#define nft_trans_basechain(trans)	\
+	(((struct nft_trans_chain *)trans->data)->basechain)
+#define nft_trans_chain_hooks(trans)	\
+	(((struct nft_trans_chain *)trans->data)->hook_list)
 
 struct nft_trans_table {
 	bool				update;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 77975b4b0fdc..f8d8cace0c7d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1582,7 +1582,8 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 }
 
 static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
-				   const struct nft_base_chain *basechain)
+				   const struct nft_base_chain *basechain,
+				   const struct list_head *hook_list)
 {
 	const struct nf_hook_ops *ops = &basechain->ops;
 	struct nft_hook *hook, *first = NULL;
@@ -1599,7 +1600,11 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 
 	if (nft_base_chain_netdev(family, ops->hooknum)) {
 		nest_devs = nla_nest_start_noflag(skb, NFTA_HOOK_DEVS);
-		list_for_each_entry(hook, &basechain->hook_list, list) {
+
+		if (!hook_list)
+			hook_list = &basechain->hook_list;
+
+		list_for_each_entry(hook, hook_list, list) {
 			if (!first)
 				first = hook;
 
@@ -1624,7 +1629,8 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 				     u32 portid, u32 seq, int event, u32 flags,
 				     int family, const struct nft_table *table,
-				     const struct nft_chain *chain)
+				     const struct nft_chain *chain,
+				     const struct list_head *hook_list)
 {
 	struct nlmsghdr *nlh;
 
@@ -1649,7 +1655,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
 
-		if (nft_dump_basechain_hook(skb, family, basechain))
+		if (nft_dump_basechain_hook(skb, family, basechain, hook_list))
 			goto nla_put_failure;
 
 		if (nla_put_be32(skb, NFTA_CHAIN_POLICY,
@@ -1684,7 +1690,8 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
-static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
+static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event,
+				   const struct list_head *hook_list)
 {
 	struct nftables_pernet *nft_net;
 	struct sk_buff *skb;
@@ -1704,7 +1711,7 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 
 	err = nf_tables_fill_chain_info(skb, ctx->net, ctx->portid, ctx->seq,
 					event, flags, ctx->family, ctx->table,
-					ctx->chain);
+					ctx->chain, hook_list);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -1750,7 +1757,7 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 						      NFT_MSG_NEWCHAIN,
 						      NLM_F_MULTI,
 						      table->family, table,
-						      chain) < 0)
+						      chain, NULL) < 0)
 				goto done;
 
 			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
@@ -1804,7 +1811,7 @@ static int nf_tables_getchain(struct sk_buff *skb, const struct nfnl_info *info,
 
 	err = nf_tables_fill_chain_info(skb2, net, NETLINK_CB(skb).portid,
 					info->nlh->nlmsg_seq, NFT_MSG_NEWCHAIN,
-					0, family, table, chain);
+					0, family, table, chain, NULL);
 	if (err < 0)
 		goto err_fill_chain_info;
 
@@ -2048,9 +2055,10 @@ static int nft_chain_parse_netdev(struct net *net,
 }
 
 static int nft_chain_parse_hook(struct net *net,
+				struct nft_base_chain *basechain,
 				const struct nlattr * const nla[],
 				struct nft_chain_hook *hook, u8 family,
-				struct netlink_ext_ack *extack, bool autoload)
+				struct netlink_ext_ack *extack)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
@@ -2066,31 +2074,46 @@ static int nft_chain_parse_hook(struct net *net,
 	if (err < 0)
 		return err;
 
-	if (ha[NFTA_HOOK_HOOKNUM] == NULL ||
-	    ha[NFTA_HOOK_PRIORITY] == NULL)
-		return -EINVAL;
+	if (!basechain) {
+		if (!ha[NFTA_HOOK_HOOKNUM] ||
+		    !ha[NFTA_HOOK_PRIORITY])
+			return -EINVAL;
 
-	hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
-	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
+		hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
+		hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
-	type = __nft_chain_type_get(family, NFT_CHAIN_T_DEFAULT);
-	if (!type)
-		return -EOPNOTSUPP;
+		type = __nft_chain_type_get(family, NFT_CHAIN_T_DEFAULT);
+		if (!type)
+			return -EOPNOTSUPP;
 
-	if (nla[NFTA_CHAIN_TYPE]) {
-		type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
-						   family, autoload);
-		if (IS_ERR(type)) {
-			NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
-			return PTR_ERR(type);
+		if (nla[NFTA_CHAIN_TYPE]) {
+			type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
+							   family, true);
+			if (IS_ERR(type)) {
+				NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
+				return PTR_ERR(type);
+			}
 		}
-	}
-	if (hook->num >= NFT_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
-		return -EOPNOTSUPP;
+		if (hook->num >= NFT_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
+			return -EOPNOTSUPP;
 
-	if (type->type == NFT_CHAIN_T_NAT &&
-	    hook->priority <= NF_IP_PRI_CONNTRACK)
-		return -EOPNOTSUPP;
+		if (type->type == NFT_CHAIN_T_NAT &&
+		    hook->priority <= NF_IP_PRI_CONNTRACK)
+			return -EOPNOTSUPP;
+	} else {
+		if (ha[NFTA_HOOK_HOOKNUM]) {
+			hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
+			if (hook->num != basechain->ops.hooknum)
+				return -EOPNOTSUPP;
+		}
+		if (ha[NFTA_HOOK_PRIORITY]) {
+			hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
+			if (hook->priority != basechain->ops.priority)
+				return -EOPNOTSUPP;
+		}
+
+		type = basechain->type;
+	}
 
 	if (!try_module_get(type->owner)) {
 		if (nla[NFTA_CHAIN_TYPE])
@@ -2184,12 +2207,8 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 		list_splice_init(&hook->list, &basechain->hook_list);
 		list_for_each_entry(h, &basechain->hook_list, list)
 			nft_basechain_hook_init(&h->ops, family, hook, chain);
-
-		basechain->ops.hooknum	= hook->num;
-		basechain->ops.priority	= hook->priority;
-	} else {
-		nft_basechain_hook_init(&basechain->ops, family, hook, chain);
 	}
+	nft_basechain_hook_init(&basechain->ops, family, hook, chain);
 
 	chain->flags |= NFT_CHAIN_BASE | flags;
 	basechain->policy = NF_ACCEPT;
@@ -2239,13 +2258,13 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	if (nla[NFTA_CHAIN_HOOK]) {
 		struct nft_stats __percpu *stats = NULL;
-		struct nft_chain_hook hook;
+		struct nft_chain_hook hook = {};
 
 		if (flags & NFT_CHAIN_BINDING)
 			return -EOPNOTSUPP;
 
-		err = nft_chain_parse_hook(net, nla, &hook, family, extack,
-					   true);
+		err = nft_chain_parse_hook(net, NULL, nla, &hook, family,
+					   extack);
 		if (err < 0)
 			return err;
 
@@ -2359,65 +2378,57 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	return err;
 }
 
-static bool nft_hook_list_equal(struct list_head *hook_list1,
-				struct list_head *hook_list2)
-{
-	struct nft_hook *hook;
-	int n = 0, m = 0;
-
-	n = 0;
-	list_for_each_entry(hook, hook_list2, list) {
-		if (!nft_hook_list_find(hook_list1, hook))
-			return false;
-
-		n++;
-	}
-	list_for_each_entry(hook, hook_list1, list)
-		m++;
-
-	return n == m;
-}
-
 static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			      u32 flags, const struct nlattr *attr,
 			      struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
+	struct nft_base_chain *basechain = NULL;
 	struct nft_table *table = ctx->table;
 	struct nft_chain *chain = ctx->chain;
-	struct nft_base_chain *basechain;
+	struct nft_chain_hook hook = {};
 	struct nft_stats *stats = NULL;
-	struct nft_chain_hook hook;
+	struct nft_hook *h, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
+	bool unregister = false;
 	int err;
 
 	if (chain->flags ^ flags)
 		return -EOPNOTSUPP;
 
+	INIT_LIST_HEAD(&hook.list);
+
 	if (nla[NFTA_CHAIN_HOOK]) {
 		if (!nft_is_base_chain(chain)) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return -EEXIST;
 		}
-		err = nft_chain_parse_hook(ctx->net, nla, &hook, ctx->family,
-					   extack, false);
+
+		basechain = nft_base_chain(chain);
+		err = nft_chain_parse_hook(ctx->net, basechain, nla, &hook,
+					   ctx->family, extack);
 		if (err < 0)
 			return err;
 
-		basechain = nft_base_chain(chain);
 		if (basechain->type != hook.type) {
 			nft_chain_release_hook(&hook);
 			NL_SET_BAD_ATTR(extack, attr);
 			return -EEXIST;
 		}
 
-		if (nft_base_chain_netdev(ctx->family, hook.num)) {
-			if (!nft_hook_list_equal(&basechain->hook_list,
-						 &hook.list)) {
-				nft_chain_release_hook(&hook);
-				NL_SET_BAD_ATTR(extack, attr);
-				return -EEXIST;
+		if (nft_base_chain_netdev(ctx->family, basechain->ops.hooknum)) {
+			list_for_each_entry_safe(h, next, &hook.list, list) {
+				h->ops.pf	= basechain->ops.pf;
+				h->ops.hooknum	= basechain->ops.hooknum;
+				h->ops.priority	= basechain->ops.priority;
+				h->ops.priv	= basechain->ops.priv;
+				h->ops.hook	= basechain->ops.hook;
+
+				if (nft_hook_list_find(&basechain->hook_list, h)) {
+					list_del(&h->list);
+					kfree(h);
+				}
 			}
 		} else {
 			ops = &basechain->ops;
@@ -2428,7 +2439,6 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 				return -EEXIST;
 			}
 		}
-		nft_chain_release_hook(&hook);
 	}
 
 	if (nla[NFTA_CHAIN_HANDLE] &&
@@ -2439,24 +2449,43 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 					  nla[NFTA_CHAIN_NAME], genmask);
 		if (!IS_ERR(chain2)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_NAME]);
-			return -EEXIST;
+			err = -EEXIST;
+			goto err_hooks;
 		}
 	}
 
 	if (nla[NFTA_CHAIN_COUNTERS]) {
-		if (!nft_is_base_chain(chain))
-			return -EOPNOTSUPP;
+		if (!nft_is_base_chain(chain)) {
+			err = -EOPNOTSUPP;
+			goto err_hooks;
+		}
 
 		stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-		if (IS_ERR(stats))
-			return PTR_ERR(stats);
+		if (IS_ERR(stats)) {
+			err = PTR_ERR(stats);
+			goto err_hooks;
+		}
 	}
 
+	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
+	    nft_is_base_chain(chain) &&
+	    !list_empty(&hook.list)) {
+		basechain = nft_base_chain(chain);
+		ops = &basechain->ops;
+
+		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
+			err = nft_netdev_register_hooks(ctx->net, &hook.list);
+			if (err < 0)
+				goto err_hooks;
+		}
+	}
+
+	unregister = true;
 	err = -ENOMEM;
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWCHAIN,
 				sizeof(struct nft_trans_chain));
 	if (trans == NULL)
-		goto err;
+		goto err_trans;
 
 	nft_trans_chain_stats(trans) = stats;
 	nft_trans_chain_update(trans) = true;
@@ -2475,7 +2504,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		err = -ENOMEM;
 		name = nla_strdup(nla[NFTA_CHAIN_NAME], GFP_KERNEL_ACCOUNT);
 		if (!name)
-			goto err;
+			goto err_trans;
 
 		err = -EEXIST;
 		list_for_each_entry(tmp, &nft_net->commit_list, list) {
@@ -2486,18 +2515,35 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			    strcmp(name, nft_trans_chain_name(tmp)) == 0) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_NAME]);
 				kfree(name);
-				goto err;
+				goto err_trans;
 			}
 		}
 
 		nft_trans_chain_name(trans) = name;
 	}
+
+	nft_trans_basechain(trans) = basechain;
+	INIT_LIST_HEAD(&nft_trans_chain_hooks(trans));
+	list_splice(&hook.list, &nft_trans_chain_hooks(trans));
+
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
-err:
+
+err_trans:
 	free_percpu(stats);
 	kfree(trans);
+err_hooks:
+	if (nla[NFTA_CHAIN_HOOK]) {
+		list_for_each_entry_safe(h, next, &hook.list, list) {
+			if (unregister)
+				nf_unregister_net_hook(ctx->net, &h->ops);
+			list_del(&h->list);
+			kfree_rcu(h, rcu);
+		}
+		module_put(hook.type->owner);
+	}
+
 	return err;
 }
 
@@ -9244,19 +9290,22 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
 				nft_chain_commit_update(trans);
-				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
+				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN,
+						       &nft_trans_chain_hooks(trans));
+				list_splice(&nft_trans_chain_hooks(trans),
+					    &nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(trans);
 				nft_clear(net, trans->ctx.chain);
-				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN);
+				nf_tables_chain_notify(&trans->ctx, NFT_MSG_NEWCHAIN, NULL);
 				nft_trans_destroy(trans);
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
 		case NFT_MSG_DESTROYCHAIN:
 			nft_chain_del(trans->ctx.chain);
-			nf_tables_chain_notify(&trans->ctx, trans->msg_type);
+			nf_tables_chain_notify(&trans->ctx, trans->msg_type, NULL);
 			nf_tables_unregister_hook(trans->ctx.net,
 						  trans->ctx.table,
 						  trans->ctx.chain);
@@ -9423,7 +9472,10 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
-		nf_tables_chain_destroy(&trans->ctx);
+		if (nft_trans_chain_update(trans))
+			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
+		else
+			nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -9486,6 +9538,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
+				nft_netdev_unregister_hooks(net,
+							    &nft_trans_chain_hooks(trans),
+							    true);
 				free_percpu(nft_trans_chain_stats(trans));
 				kfree(nft_trans_chain_name(trans));
 				nft_trans_destroy(trans);
-- 
2.30.2

