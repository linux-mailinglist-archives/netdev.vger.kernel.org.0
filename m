Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1663553C2
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344201AbhDFMXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:23:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34436 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343992AbhDFMWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:06 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B7B2363E60;
        Tue,  6 Apr 2021 14:21:37 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 24/28] netfilter: nf_tables: use net_generic infra for transaction data
Date:   Tue,  6 Apr 2021 14:21:29 +0200
Message-Id: <20210406122133.1644-25-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This moves all nf_tables pernet data from struct net to a net_generic
extension, with the exception of the gencursor.

The latter is used in the data path and also outside of the nf_tables
core. All others are only used from the configuration plane.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  11 ++
 net/netfilter/nf_tables_api.c     | 313 +++++++++++++++++++-----------
 net/netfilter/nf_tables_offload.c |  30 +--
 net/netfilter/nft_chain_filter.c  |  11 +-
 net/netfilter/nft_dynset.c        |   6 +-
 5 files changed, 243 insertions(+), 128 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8fefa112ae89..f0f7a3c5da6a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1567,4 +1567,15 @@ __printf(2, 3) int nft_request_module(struct net *net, const char *fmt, ...);
 #else
 static inline int nft_request_module(struct net *net, const char *fmt, ...) { return -ENOENT; }
 #endif
+
+struct nftables_pernet {
+	struct list_head	tables;
+	struct list_head	commit_list;
+	struct list_head	module_list;
+	struct list_head	notify_list;
+	struct mutex		commit_mutex;
+	unsigned int		base_seq;
+	u8			validate_state;
+};
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a24de59e6c69..1b881a84bd01 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -21,10 +21,13 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/net_namespace.h>
+#include <net/netns/generic.h>
 #include <net/sock.h>
 
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
 
+unsigned int nf_tables_net_id __read_mostly;
+
 static LIST_HEAD(nf_tables_expressions);
 static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
@@ -103,7 +106,9 @@ static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
 
 static void nft_validate_state_update(struct net *net, u8 new_validate_state)
 {
-	switch (net->nft.validate_state) {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+
+	switch (nft_net->validate_state) {
 	case NFT_VALIDATE_SKIP:
 		WARN_ON_ONCE(new_validate_state == NFT_VALIDATE_DO);
 		break;
@@ -114,7 +119,7 @@ static void nft_validate_state_update(struct net *net, u8 new_validate_state)
 			return;
 	}
 
-	net->nft.validate_state = new_validate_state;
+	nft_net->validate_state = new_validate_state;
 }
 static void nf_tables_trans_destroy_work(struct work_struct *w);
 static DECLARE_WORK(trans_destroy_work, nf_tables_trans_destroy_work);
@@ -169,13 +174,15 @@ static void nft_trans_destroy(struct nft_trans *trans)
 
 static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
 {
+	struct nftables_pernet *nft_net;
 	struct net *net = ctx->net;
 	struct nft_trans *trans;
 
 	if (!nft_set_is_anonymous(set))
 		return;
 
-	list_for_each_entry_reverse(trans, &net->nft.commit_list, list) {
+	nft_net = net_generic(net, nf_tables_net_id);
+	list_for_each_entry_reverse(trans, &nft_net->commit_list, list) {
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWSET:
 			if (nft_trans_set(trans) == set)
@@ -269,6 +276,14 @@ static void nf_tables_unregister_hook(struct net *net,
 		nf_unregister_net_hook(net, &basechain->ops);
 }
 
+static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *trans)
+{
+	struct nftables_pernet *nft_net;
+
+	nft_net = net_generic(net, nf_tables_net_id);
+	list_add_tail(&trans->list, &nft_net->commit_list);
+}
+
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
 {
 	struct nft_trans *trans;
@@ -280,7 +295,7 @@ static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
 	if (msg_type == NFT_MSG_NEWTABLE)
 		nft_activate_next(ctx->net, ctx->table);
 
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 	return 0;
 }
 
@@ -313,7 +328,7 @@ static struct nft_trans *nft_trans_chain_add(struct nft_ctx *ctx, int msg_type)
 		}
 	}
 
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 	return trans;
 }
 
@@ -386,7 +401,7 @@ static struct nft_trans *nft_trans_rule_add(struct nft_ctx *ctx, int msg_type,
 			ntohl(nla_get_be32(ctx->nla[NFTA_RULE_ID]));
 	}
 	nft_trans_rule(trans) = rule;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return trans;
 }
@@ -452,7 +467,7 @@ static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 		nft_activate_next(ctx->net, set);
 	}
 	nft_trans_set(trans) = set;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 }
@@ -484,7 +499,7 @@ static int nft_trans_obj_add(struct nft_ctx *ctx, int msg_type,
 		nft_activate_next(ctx->net, obj);
 
 	nft_trans_obj(trans) = obj;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 }
@@ -517,7 +532,7 @@ static int nft_trans_flowtable_add(struct nft_ctx *ctx, int msg_type,
 		nft_activate_next(ctx->net, flowtable);
 
 	nft_trans_flowtable(trans) = flowtable;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 }
@@ -545,13 +560,15 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 					  const struct nlattr *nla,
 					  u8 family, u8 genmask, u32 nlpid)
 {
+	struct nftables_pernet *nft_net;
 	struct nft_table *table;
 
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list,
-				lockdep_is_held(&net->nft.commit_mutex)) {
+	nft_net = net_generic(net, nf_tables_net_id);
+	list_for_each_entry_rcu(table, &nft_net->tables, list,
+				lockdep_is_held(&nft_net->commit_mutex)) {
 		if (!nla_strcmp(nla, table->name) &&
 		    table->family == family &&
 		    nft_active_genmask(table, genmask)) {
@@ -570,9 +587,11 @@ static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 						   const struct nlattr *nla,
 						   u8 genmask)
 {
+	struct nftables_pernet *nft_net;
 	struct nft_table *table;
 
-	list_for_each_entry(table, &net->nft.tables, list) {
+	nft_net = net_generic(net, nf_tables_net_id);
+	list_for_each_entry(table, &nft_net->tables, list) {
 		if (be64_to_cpu(nla_get_be64(nla)) == table->handle &&
 		    nft_active_genmask(table, genmask))
 			return table;
@@ -625,6 +644,7 @@ __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
 				      ...)
 {
 	char module_name[MODULE_NAME_LEN];
+	struct nftables_pernet *nft_net;
 	struct nft_module_request *req;
 	va_list args;
 	int ret;
@@ -635,7 +655,8 @@ __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
 	if (ret >= MODULE_NAME_LEN)
 		return 0;
 
-	list_for_each_entry(req, &net->nft.module_list, list) {
+	nft_net = net_generic(net, nf_tables_net_id);
+	list_for_each_entry(req, &nft_net->module_list, list) {
 		if (!strcmp(req->module, module_name)) {
 			if (req->done)
 				return 0;
@@ -651,7 +672,7 @@ __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
 
 	req->done = false;
 	strlcpy(req->module, module_name, MODULE_NAME_LEN);
-	list_add_tail(&req->list, &net->nft.module_list);
+	list_add_tail(&req->list, &nft_net->module_list);
 
 	return -EAGAIN;
 }
@@ -690,7 +711,9 @@ nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
 
 static __be16 nft_base_seq(const struct net *net)
 {
-	return htons(net->nft.base_seq & 0xffff);
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+
+	return htons(nft_net->base_seq & 0xffff);
 }
 
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
@@ -751,6 +774,7 @@ static void nft_notify_enqueue(struct sk_buff *skb, bool report,
 
 static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 {
+	struct nftables_pernet *nft_net;
 	struct sk_buff *skb;
 	int err;
 
@@ -769,7 +793,8 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
+	nft_net = net_generic(ctx->net, nf_tables_net_id);
+	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -779,15 +804,17 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 				 struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	struct nftables_pernet *nft_net;
 	const struct nft_table *table;
 	unsigned int idx = 0, s_idx = cb->args[0];
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 
 	rcu_read_lock();
-	cb->seq = net->nft.base_seq;
+	nft_net = net_generic(net, nf_tables_net_id);
+	cb->seq = nft_net->base_seq;
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
@@ -972,7 +999,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
 	nft_trans_table_flags(trans) = flags;
 	nft_trans_table_update(trans) = true;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 	return 0;
 err:
 	nft_trans_destroy(trans);
@@ -1035,6 +1062,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 			      const struct nlattr * const nla[],
 			      struct netlink_ext_ack *extack)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
@@ -1044,7 +1072,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	u32 flags = 0;
 	int err;
 
-	lockdep_assert_held(&net->nft.commit_mutex);
+	lockdep_assert_held(&nft_net->commit_mutex);
 	attr = nla[NFTA_TABLE_NAME];
 	table = nft_table_lookup(net, attr, family, genmask,
 				 NETLINK_CB(skb).portid);
@@ -1105,7 +1133,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		goto err_trans;
 
-	list_add_tail_rcu(&table->list, &net->nft.tables);
+	list_add_tail_rcu(&table->list, &nft_net->tables);
 	return 0;
 err_trans:
 	rhltable_destroy(&table->chains_ht);
@@ -1193,11 +1221,12 @@ static int nft_flush_table(struct nft_ctx *ctx)
 
 static int nft_flush(struct nft_ctx *ctx, int family)
 {
+	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
 	struct nft_table *table, *nt;
 	const struct nlattr * const *nla = ctx->nla;
 	int err = 0;
 
-	list_for_each_entry_safe(table, nt, &ctx->net->nft.tables, list) {
+	list_for_each_entry_safe(table, nt, &nft_net->tables, list) {
 		if (family != AF_UNSPEC && table->family != family)
 			continue;
 
@@ -1316,7 +1345,9 @@ nft_chain_lookup_byhandle(const struct nft_table *table, u64 handle, u8 genmask)
 static bool lockdep_commit_lock_is_held(const struct net *net)
 {
 #ifdef CONFIG_PROVE_LOCKING
-	return lockdep_is_held(&net->nft.commit_mutex);
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+
+	return lockdep_is_held(&nft_net->commit_mutex);
 #else
 	return true;
 #endif
@@ -1519,6 +1550,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 
 static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 {
+	struct nftables_pernet *nft_net;
 	struct sk_buff *skb;
 	int err;
 
@@ -1538,7 +1570,8 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
+	nft_net = net_generic(ctx->net, nf_tables_net_id);
+	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -1553,11 +1586,13 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 	unsigned int idx = 0, s_idx = cb->args[0];
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
+	struct nftables_pernet *nft_net;
 
 	rcu_read_lock();
-	cb->seq = net->nft.base_seq;
+	nft_net = net_generic(net, nf_tables_net_id);
+	cb->seq = nft_net->base_seq;
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
@@ -1873,11 +1908,12 @@ static int nft_chain_parse_hook(struct net *net,
 				struct nft_chain_hook *hook, u8 family,
 				bool autoload)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
 	const struct nft_chain_type *type;
 	int err;
 
-	lockdep_assert_held(&net->nft.commit_mutex);
+	lockdep_assert_held(&nft_net->commit_mutex);
 	lockdep_nfnl_nft_mutex_not_held();
 
 	err = nla_parse_nested_deprecated(ha, NFTA_HOOK_MAX,
@@ -2266,6 +2302,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 	if (nla[NFTA_CHAIN_HANDLE] &&
 	    nla[NFTA_CHAIN_NAME]) {
+		struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
 		struct nft_trans *tmp;
 		char *name;
 
@@ -2275,7 +2312,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			goto err;
 
 		err = -EEXIST;
-		list_for_each_entry(tmp, &ctx->net->nft.commit_list, list) {
+		list_for_each_entry(tmp, &nft_net->commit_list, list) {
 			if (tmp->msg_type == NFT_MSG_NEWCHAIN &&
 			    tmp->ctx.table == table &&
 			    nft_trans_chain_update(tmp) &&
@@ -2289,7 +2326,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 		nft_trans_chain_name(trans) = name;
 	}
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 err:
@@ -2301,10 +2338,11 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 static struct nft_chain *nft_chain_lookup_byid(const struct net *net,
 					       const struct nlattr *nla)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	u32 id = ntohl(nla_get_be32(nla));
 	struct nft_trans *trans;
 
-	list_for_each_entry(trans, &net->nft.commit_list, list) {
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
 		struct nft_chain *chain = trans->ctx.chain;
 
 		if (trans->msg_type == NFT_MSG_NEWCHAIN &&
@@ -2319,6 +2357,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 			      const struct nlattr * const nla[],
 			      struct netlink_ext_ack *extack)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
@@ -2330,7 +2369,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 	u64 handle = 0;
 	u32 flags = 0;
 
-	lockdep_assert_held(&net->nft.commit_mutex);
+	lockdep_assert_held(&nft_net->commit_mutex);
 
 	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask,
 				 NETLINK_CB(skb).portid);
@@ -2866,6 +2905,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 				  const struct nft_rule *rule, int event)
 {
+	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
 	struct sk_buff *skb;
 	int err;
 
@@ -2885,7 +2925,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
+	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -2943,11 +2983,13 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	unsigned int idx = 0;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
+	struct nftables_pernet *nft_net;
 
 	rcu_read_lock();
-	cb->seq = net->nft.base_seq;
+	nft_net = net_generic(net, nf_tables_net_id);
+	cb->seq = nft_net->base_seq;
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
@@ -3178,6 +3220,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 			     const struct nlattr * const nla[],
 			     struct netlink_ext_ack *extack)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
 	struct nft_expr_info *info = NULL;
@@ -3195,7 +3238,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	int err, rem;
 	u64 handle, pos_handle;
 
-	lockdep_assert_held(&net->nft.commit_mutex);
+	lockdep_assert_held(&nft_net->commit_mutex);
 
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask,
 				 NETLINK_CB(skb).portid);
@@ -3367,7 +3410,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	kvfree(info);
 	chain->use++;
 
-	if (net->nft.validate_state == NFT_VALIDATE_DO)
+	if (nft_net->validate_state == NFT_VALIDATE_DO)
 		return nft_table_validate(net, table);
 
 	if (chain->flags & NFT_CHAIN_HW_OFFLOAD) {
@@ -3396,10 +3439,11 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nlattr *nla)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	u32 id = ntohl(nla_get_be32(nla));
 	struct nft_trans *trans;
 
-	list_for_each_entry(trans, &net->nft.commit_list, list) {
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
 		struct nft_rule *rule = nft_trans_rule(trans);
 
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
@@ -3512,13 +3556,14 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 		   const struct nft_set_desc *desc,
 		   enum nft_set_policies policy)
 {
+	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
 	const struct nft_set_ops *ops, *bops;
 	struct nft_set_estimate est, best;
 	const struct nft_set_type *type;
 	u32 flags = 0;
 	int i;
 
-	lockdep_assert_held(&ctx->net->nft.commit_mutex);
+	lockdep_assert_held(&nft_net->commit_mutex);
 	lockdep_nfnl_nft_mutex_not_held();
 
 	if (nla[NFTA_SET_FLAGS] != NULL)
@@ -3656,10 +3701,11 @@ static struct nft_set *nft_set_lookup_byhandle(const struct nft_table *table,
 static struct nft_set *nft_set_lookup_byid(const struct net *net,
 					   const struct nlattr *nla, u8 genmask)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_trans *trans;
 	u32 id = ntohl(nla_get_be32(nla));
 
-	list_for_each_entry(trans, &net->nft.commit_list, list) {
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
 		if (trans->msg_type == NFT_MSG_NEWSET) {
 			struct nft_set *set = nft_trans_set(trans);
 
@@ -3893,6 +3939,7 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 				 const struct nft_set *set, int event,
 			         gfp_t gfp_flags)
 {
+	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
 	struct sk_buff *skb;
 	u32 portid = ctx->portid;
 	int err;
@@ -3911,7 +3958,7 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
+	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -3924,14 +3971,16 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nft_table *table, *cur_table = (struct nft_table *)cb->args[2];
 	struct net *net = sock_net(skb->sk);
 	struct nft_ctx *ctx = cb->data, ctx_set;
+	struct nftables_pernet *nft_net;
 
 	if (cb->args[1])
 		return skb->len;
 
 	rcu_read_lock();
-	cb->seq = net->nft.base_seq;
+	nft_net = net_generic(net, nf_tables_net_id);
+	cb->seq = nft_net->base_seq;
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (ctx->family != NFPROTO_UNSPEC &&
 		    ctx->family != table->family)
 			continue;
@@ -4770,6 +4819,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
 	struct net *net = sock_net(skb->sk);
+	struct nftables_pernet *nft_net;
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_set_dump_args args;
@@ -4780,7 +4830,8 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	int event;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	nft_net = net_generic(net, nf_tables_net_id);
+	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (dump_ctx->ctx.family != NFPROTO_UNSPEC &&
 		    dump_ctx->ctx.family != table->family)
 			continue;
@@ -5064,6 +5115,7 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 				     const struct nft_set_elem *elem,
 				     int event, u16 flags)
 {
+	struct nftables_pernet *nft_net;
 	struct net *net = ctx->net;
 	u32 portid = ctx->portid;
 	struct sk_buff *skb;
@@ -5083,7 +5135,8 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
+	nft_net = net_generic(net, nf_tables_net_id);
+	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -5551,7 +5604,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	nft_trans_elem(trans) = elem;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 	return 0;
 
 err_set_full:
@@ -5582,6 +5635,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 				const struct nlattr * const nla[],
 				struct netlink_ext_ack *extack)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	u8 genmask = nft_genmask_next(net);
 	const struct nlattr *attr;
 	struct nft_set *set;
@@ -5610,7 +5664,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 			return err;
 	}
 
-	if (net->nft.validate_state == NFT_VALIDATE_DO)
+	if (nft_net->validate_state == NFT_VALIDATE_DO)
 		return nft_table_validate(net, ctx.table);
 
 	return 0;
@@ -5746,7 +5800,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_set_elem_deactivate(ctx->net, set, &elem);
 
 	nft_trans_elem(trans) = elem;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 	return 0;
 
 fail_ops:
@@ -5780,7 +5834,7 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 	nft_set_elem_deactivate(ctx->net, set, elem);
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem(trans) = *elem;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 err1:
@@ -6074,7 +6128,7 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	nft_trans_obj(trans) = obj;
 	nft_trans_obj_update(trans) = true;
 	nft_trans_obj_newobj(trans) = newobj;
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 
@@ -6236,6 +6290,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nft_obj_filter *filter = cb->data;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
+	struct nftables_pernet *nft_net;
 	struct nft_object *obj;
 	bool reset = false;
 
@@ -6243,9 +6298,10 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 		reset = true;
 
 	rcu_read_lock();
-	cb->seq = net->nft.base_seq;
+	nft_net = net_generic(net, nf_tables_net_id);
+	cb->seq = nft_net->base_seq;
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
@@ -6268,7 +6324,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				char *buf = kasprintf(GFP_ATOMIC,
 						      "%s:%u",
 						      table->name,
-						      net->nft.base_seq);
+						      nft_net->base_seq);
 
 				audit_log_nfcfg(buf,
 						family,
@@ -6389,8 +6445,11 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 		reset = true;
 
 	if (reset) {
-		char *buf = kasprintf(GFP_ATOMIC, "%s:%u",
-				      table->name, net->nft.base_seq);
+		const struct nftables_pernet *nft_net;
+		char *buf;
+
+		nft_net = net_generic(net, nf_tables_net_id);
+		buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
 
 		audit_log_nfcfg(buf,
 				family,
@@ -6476,10 +6535,11 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 		    struct nft_object *obj, u32 portid, u32 seq, int event,
 		    int family, int report, gfp_t gfp)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct sk_buff *skb;
 	int err;
 	char *buf = kasprintf(gfp, "%s:%u",
-			      table->name, net->nft.base_seq);
+			      table->name, nft_net->base_seq);
 
 	audit_log_nfcfg(buf,
 			family,
@@ -6505,7 +6565,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, report, &net->nft.notify_list);
+	nft_notify_enqueue(skb, report, &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -6837,7 +6897,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
 	list_splice(&flowtable_hook.list, &nft_trans_flowtable_hooks(trans));
 
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 
@@ -7025,7 +7085,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
 	nft_flowtable_hook_release(&flowtable_hook);
 
-	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 
@@ -7157,12 +7217,14 @@ static int nf_tables_dump_flowtable(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nft_flowtable *flowtable;
+	struct nftables_pernet *nft_net;
 	const struct nft_table *table;
 
 	rcu_read_lock();
-	cb->seq = net->nft.base_seq;
+	nft_net = net_generic(net, nf_tables_net_id);
+	cb->seq = nft_net->base_seq;
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
 			continue;
 
@@ -7297,6 +7359,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 				       struct list_head *hook_list,
 				       int event)
 {
+	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
 	struct sk_buff *skb;
 	int err;
 
@@ -7316,7 +7379,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_notify_enqueue(skb, ctx->report, &ctx->net->nft.notify_list);
+	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
 	return;
 err:
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
@@ -7341,6 +7404,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 				   u32 portid, u32 seq)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nlmsghdr *nlh;
 	char buf[TASK_COMM_LEN];
 	int event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWGEN);
@@ -7350,7 +7414,7 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 	if (!nlh)
 		goto nla_put_failure;
 
-	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)) ||
+	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(nft_net->base_seq)) ||
 	    nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||
 	    nla_put_string(skb, NFTA_GEN_PROC_NAME, get_task_comm(buf, current)))
 		goto nla_put_failure;
@@ -7385,6 +7449,7 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct nft_flowtable *flowtable;
+	struct nftables_pernet *nft_net;
 	struct nft_table *table;
 	struct net *net;
 
@@ -7392,13 +7457,14 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 		return 0;
 
 	net = dev_net(dev);
-	mutex_lock(&net->nft.commit_mutex);
-	list_for_each_entry(table, &net->nft.tables, list) {
+	nft_net = net_generic(net, nf_tables_net_id);
+	mutex_lock(&nft_net->commit_mutex);
+	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
 			nft_flowtable_event(event, dev, flowtable);
 		}
 	}
-	mutex_unlock(&net->nft.commit_mutex);
+	mutex_unlock(&nft_net->commit_mutex);
 
 	return NOTIFY_DONE;
 }
@@ -7579,16 +7645,17 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 
 static int nf_tables_validate(struct net *net)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_table *table;
 
-	switch (net->nft.validate_state) {
+	switch (nft_net->validate_state) {
 	case NFT_VALIDATE_SKIP:
 		break;
 	case NFT_VALIDATE_NEED:
 		nft_validate_state_update(net, NFT_VALIDATE_DO);
 		fallthrough;
 	case NFT_VALIDATE_DO:
-		list_for_each_entry(table, &net->nft.tables, list) {
+		list_for_each_entry(table, &nft_net->tables, list) {
 			if (nft_table_validate(net, table) < 0)
 				return -EAGAIN;
 		}
@@ -7763,9 +7830,10 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 
 static void nf_tables_commit_chain_prepare_cancel(struct net *net)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_trans *trans, *next;
 
-	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		struct nft_chain *chain = trans->ctx.chain;
 
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
@@ -7874,10 +7942,11 @@ static void nft_flowtable_hooks_del(struct nft_flowtable *flowtable,
 
 static void nf_tables_module_autoload_cleanup(struct net *net)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_module_request *req, *next;
 
-	WARN_ON_ONCE(!list_empty(&net->nft.commit_list));
-	list_for_each_entry_safe(req, next, &net->nft.module_list, list) {
+	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+	list_for_each_entry_safe(req, next, &nft_net->module_list, list) {
 		WARN_ON_ONCE(!req->done);
 		list_del(&req->list);
 		kfree(req);
@@ -7886,6 +7955,7 @@ static void nf_tables_module_autoload_cleanup(struct net *net)
 
 static void nf_tables_commit_release(struct net *net)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_trans *trans;
 
 	/* all side effects have to be made visible.
@@ -7895,35 +7965,36 @@ static void nf_tables_commit_release(struct net *net)
 	 * Memory reclaim happens asynchronously from work queue
 	 * to prevent expensive synchronize_rcu() in commit phase.
 	 */
-	if (list_empty(&net->nft.commit_list)) {
+	if (list_empty(&nft_net->commit_list)) {
 		nf_tables_module_autoload_cleanup(net);
-		mutex_unlock(&net->nft.commit_mutex);
+		mutex_unlock(&nft_net->commit_mutex);
 		return;
 	}
 
-	trans = list_last_entry(&net->nft.commit_list,
+	trans = list_last_entry(&nft_net->commit_list,
 				struct nft_trans, list);
 	get_net(trans->ctx.net);
 	WARN_ON_ONCE(trans->put_net);
 
 	trans->put_net = true;
 	spin_lock(&nf_tables_destroy_list_lock);
-	list_splice_tail_init(&net->nft.commit_list, &nf_tables_destroy_list);
+	list_splice_tail_init(&nft_net->commit_list, &nf_tables_destroy_list);
 	spin_unlock(&nf_tables_destroy_list_lock);
 
 	nf_tables_module_autoload_cleanup(net);
 	schedule_work(&trans_destroy_work);
 
-	mutex_unlock(&net->nft.commit_mutex);
+	mutex_unlock(&nft_net->commit_mutex);
 }
 
 static void nft_commit_notify(struct net *net, u32 portid)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct sk_buff *batch_skb = NULL, *nskb, *skb;
 	unsigned char *data;
 	int len;
 
-	list_for_each_entry_safe(skb, nskb, &net->nft.notify_list, list) {
+	list_for_each_entry_safe(skb, nskb, &nft_net->notify_list, list) {
 		if (!batch_skb) {
 new_batch:
 			batch_skb = skb;
@@ -7949,7 +8020,7 @@ static void nft_commit_notify(struct net *net, u32 portid)
 			       NFT_CB(batch_skb).report, GFP_KERNEL);
 	}
 
-	WARN_ON_ONCE(!list_empty(&net->nft.notify_list));
+	WARN_ON_ONCE(!list_empty(&nft_net->notify_list));
 }
 
 static int nf_tables_commit_audit_alloc(struct list_head *adl,
@@ -8005,6 +8076,7 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
 
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
@@ -8012,8 +8084,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	LIST_HEAD(adl);
 	int err;
 
-	if (list_empty(&net->nft.commit_list)) {
-		mutex_unlock(&net->nft.commit_mutex);
+	if (list_empty(&nft_net->commit_list)) {
+		mutex_unlock(&nft_net->commit_mutex);
 		return 0;
 	}
 
@@ -8026,7 +8098,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return err;
 
 	/* 1.  Allocate space for next generation rules_gen_X[] */
-	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		int ret;
 
 		ret = nf_tables_commit_audit_alloc(&adl, trans->ctx.table);
@@ -8047,7 +8119,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	}
 
 	/* step 2.  Make rules_gen_X visible to packet path */
-	list_for_each_entry(table, &net->nft.tables, list) {
+	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(chain, &table->chains, list)
 			nf_tables_commit_chain(net, chain);
 	}
@@ -8056,12 +8128,13 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	 * Bump generation counter, invalidate any dump in progress.
 	 * Cannot fail after this point.
 	 */
-	while (++net->nft.base_seq == 0);
+	while (++nft_net->base_seq == 0)
+		;
 
 	/* step 3. Start new generation, rules_gen_X now in use. */
 	net->nft.gencursor = nft_gencursor_next(net);
 
-	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		nf_tables_commit_audit_collect(&adl, trans->ctx.table,
 					       trans->msg_type);
 		switch (trans->msg_type) {
@@ -8216,7 +8289,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
-	nf_tables_commit_audit_log(&adl, net->nft.base_seq);
+	nf_tables_commit_audit_log(&adl, nft_net->base_seq);
 	nf_tables_commit_release(net);
 
 	return 0;
@@ -8224,17 +8297,18 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 static void nf_tables_module_autoload(struct net *net)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_module_request *req, *next;
 	LIST_HEAD(module_list);
 
-	list_splice_init(&net->nft.module_list, &module_list);
-	mutex_unlock(&net->nft.commit_mutex);
+	list_splice_init(&nft_net->module_list, &module_list);
+	mutex_unlock(&nft_net->commit_mutex);
 	list_for_each_entry_safe(req, next, &module_list, list) {
 		request_module("%s", req->module);
 		req->done = true;
 	}
-	mutex_lock(&net->nft.commit_mutex);
-	list_splice(&module_list, &net->nft.module_list);
+	mutex_lock(&nft_net->commit_mutex);
+	list_splice(&module_list, &nft_net->module_list);
 }
 
 static void nf_tables_abort_release(struct nft_trans *trans)
@@ -8271,6 +8345,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 
 static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
 	struct nft_hook *hook;
@@ -8279,7 +8354,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	    nf_tables_validate(net) < 0)
 		return -EAGAIN;
 
-	list_for_each_entry_safe_reverse(trans, next, &net->nft.commit_list,
+	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
@@ -8403,7 +8478,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	synchronize_rcu();
 
 	list_for_each_entry_safe_reverse(trans, next,
-					 &net->nft.commit_list, list) {
+					 &nft_net->commit_list, list) {
 		list_del(&trans->list);
 		nf_tables_abort_release(trans);
 	}
@@ -8424,22 +8499,24 @@ static void nf_tables_cleanup(struct net *net)
 static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 			   enum nfnl_abort_action action)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	int ret = __nf_tables_abort(net, action);
 
-	mutex_unlock(&net->nft.commit_mutex);
+	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
 }
 
 static bool nf_tables_valid_genid(struct net *net, u32 genid)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	bool genid_ok;
 
-	mutex_lock(&net->nft.commit_mutex);
+	mutex_lock(&nft_net->commit_mutex);
 
-	genid_ok = genid == 0 || net->nft.base_seq == genid;
+	genid_ok = genid == 0 || nft_net->base_seq == genid;
 	if (!genid_ok)
-		mutex_unlock(&net->nft.commit_mutex);
+		mutex_unlock(&nft_net->commit_mutex);
 
 	/* else, commit mutex has to be released by commit or abort function */
 	return genid_ok;
@@ -8994,9 +9071,10 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 
 static void __nft_release_hooks(struct net *net)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_table *table;
 
-	list_for_each_entry(table, &net->nft.tables, list) {
+	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table))
 			continue;
 
@@ -9053,9 +9131,10 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 
 static void __nft_release_tables(struct net *net)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_table *table, *nt;
 
-	list_for_each_entry_safe(table, nt, &net->nft.tables, list) {
+	list_for_each_entry_safe(table, nt, &nft_net->tables, list) {
 		if (nft_table_has_owner(table))
 			continue;
 
@@ -9066,6 +9145,7 @@ static void __nft_release_tables(struct net *net)
 static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 			    void *ptr)
 {
+	struct nftables_pernet *nft_net;
 	struct netlink_notify *n = ptr;
 	struct nft_table *table, *nt;
 	struct net *net = n->net;
@@ -9074,8 +9154,9 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
 		return NOTIFY_DONE;
 
-	mutex_lock(&net->nft.commit_mutex);
-	list_for_each_entry(table, &net->nft.tables, list) {
+	nft_net = net_generic(net, nf_tables_net_id);
+	mutex_lock(&nft_net->commit_mutex);
+	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
 		    n->portid == table->nlpid) {
 			__nft_release_hook(net, table);
@@ -9084,13 +9165,13 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 	}
 	if (release) {
 		synchronize_rcu();
-		list_for_each_entry_safe(table, nt, &net->nft.tables, list) {
+		list_for_each_entry_safe(table, nt, &nft_net->tables, list) {
 			if (nft_table_has_owner(table) &&
 			    n->portid == table->nlpid)
 				__nft_release_table(net, table);
 		}
 	}
-	mutex_unlock(&net->nft.commit_mutex);
+	mutex_unlock(&nft_net->commit_mutex);
 
 	return NOTIFY_DONE;
 }
@@ -9101,13 +9182,15 @@ static struct notifier_block nft_nl_notifier = {
 
 static int __net_init nf_tables_init_net(struct net *net)
 {
-	INIT_LIST_HEAD(&net->nft.tables);
-	INIT_LIST_HEAD(&net->nft.commit_list);
-	INIT_LIST_HEAD(&net->nft.module_list);
-	INIT_LIST_HEAD(&net->nft.notify_list);
-	mutex_init(&net->nft.commit_mutex);
-	net->nft.base_seq = 1;
-	net->nft.validate_state = NFT_VALIDATE_SKIP;
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+
+	INIT_LIST_HEAD(&nft_net->tables);
+	INIT_LIST_HEAD(&nft_net->commit_list);
+	INIT_LIST_HEAD(&nft_net->module_list);
+	INIT_LIST_HEAD(&nft_net->notify_list);
+	mutex_init(&nft_net->commit_mutex);
+	nft_net->base_seq = 1;
+	nft_net->validate_state = NFT_VALIDATE_SKIP;
 
 	return 0;
 }
@@ -9119,20 +9202,24 @@ static void __net_exit nf_tables_pre_exit_net(struct net *net)
 
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
-	mutex_lock(&net->nft.commit_mutex);
-	if (!list_empty(&net->nft.commit_list))
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+
+	mutex_lock(&nft_net->commit_mutex);
+	if (!list_empty(&nft_net->commit_list))
 		__nf_tables_abort(net, NFNL_ABORT_NONE);
 	__nft_release_tables(net);
-	mutex_unlock(&net->nft.commit_mutex);
-	WARN_ON_ONCE(!list_empty(&net->nft.tables));
-	WARN_ON_ONCE(!list_empty(&net->nft.module_list));
-	WARN_ON_ONCE(!list_empty(&net->nft.notify_list));
+	mutex_unlock(&nft_net->commit_mutex);
+	WARN_ON_ONCE(!list_empty(&nft_net->tables));
+	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
+	WARN_ON_ONCE(!list_empty(&nft_net->notify_list));
 }
 
 static struct pernet_operations nf_tables_net_ops = {
 	.init		= nf_tables_init_net,
 	.pre_exit	= nf_tables_pre_exit_net,
 	.exit		= nf_tables_exit_net,
+	.id		= &nf_tables_net_id,
+	.size		= sizeof(struct nftables_pernet),
 };
 
 static int __init nf_tables_module_init(void)
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9ae14270c543..43b56eff3b04 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -7,6 +7,8 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/pkt_cls.h>
 
+extern unsigned int nf_tables_net_id;
+
 static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
 {
 	struct nft_flow_rule *flow;
@@ -307,16 +309,18 @@ static void nft_indr_block_cleanup(struct flow_block_cb *block_cb)
 	struct nft_base_chain *basechain = block_cb->indr.data;
 	struct net_device *dev = block_cb->indr.dev;
 	struct netlink_ext_ack extack = {};
+	struct nftables_pernet *nft_net;
 	struct net *net = dev_net(dev);
 	struct flow_block_offload bo;
 
 	nft_flow_block_offload_init(&bo, dev_net(dev), FLOW_BLOCK_UNBIND,
 				    basechain, &extack);
-	mutex_lock(&net->nft.commit_mutex);
+	nft_net = net_generic(net, nf_tables_net_id);
+	mutex_lock(&nft_net->commit_mutex);
 	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
 	nft_flow_offload_unbind(&bo, basechain);
-	mutex_unlock(&net->nft.commit_mutex);
+	mutex_unlock(&nft_net->commit_mutex);
 }
 
 static int nft_indr_block_offload_cmd(struct nft_base_chain *basechain,
@@ -412,9 +416,10 @@ static int nft_flow_offload_chain(struct nft_chain *chain, u8 *ppolicy,
 static void nft_flow_rule_offload_abort(struct net *net,
 					struct nft_trans *trans)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	int err = 0;
 
-	list_for_each_entry_continue_reverse(trans, &net->nft.commit_list, list) {
+	list_for_each_entry_continue_reverse(trans, &nft_net->commit_list, list) {
 		if (trans->ctx.family != NFPROTO_NETDEV)
 			continue;
 
@@ -460,11 +465,12 @@ static void nft_flow_rule_offload_abort(struct net *net,
 
 int nft_flow_rule_offload_commit(struct net *net)
 {
+	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
 	struct nft_trans *trans;
 	int err = 0;
 	u8 policy;
 
-	list_for_each_entry(trans, &net->nft.commit_list, list) {
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
 		if (trans->ctx.family != NFPROTO_NETDEV)
 			continue;
 
@@ -516,7 +522,7 @@ int nft_flow_rule_offload_commit(struct net *net)
 		}
 	}
 
-	list_for_each_entry(trans, &net->nft.commit_list, list) {
+	list_for_each_entry(trans, &nft_net->commit_list, list) {
 		if (trans->ctx.family != NFPROTO_NETDEV)
 			continue;
 
@@ -536,15 +542,15 @@ int nft_flow_rule_offload_commit(struct net *net)
 	return err;
 }
 
-static struct nft_chain *__nft_offload_get_chain(struct net_device *dev)
+static struct nft_chain *__nft_offload_get_chain(const struct nftables_pernet *nft_net,
+						 struct net_device *dev)
 {
 	struct nft_base_chain *basechain;
-	struct net *net = dev_net(dev);
 	struct nft_hook *hook, *found;
 	const struct nft_table *table;
 	struct nft_chain *chain;
 
-	list_for_each_entry(table, &net->nft.tables, list) {
+	list_for_each_entry(table, &nft_net->tables, list) {
 		if (table->family != NFPROTO_NETDEV)
 			continue;
 
@@ -576,19 +582,21 @@ static int nft_offload_netdev_event(struct notifier_block *this,
 				    unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct nftables_pernet *nft_net;
 	struct net *net = dev_net(dev);
 	struct nft_chain *chain;
 
 	if (event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
-	mutex_lock(&net->nft.commit_mutex);
-	chain = __nft_offload_get_chain(dev);
+	nft_net = net_generic(net, nf_tables_net_id);
+	mutex_lock(&nft_net->commit_mutex);
+	chain = __nft_offload_get_chain(nft_net, dev);
 	if (chain)
 		nft_flow_block_chain(nft_base_chain(chain), dev,
 				     FLOW_BLOCK_UNBIND);
 
-	mutex_unlock(&net->nft.commit_mutex);
+	mutex_unlock(&nft_net->commit_mutex);
 
 	return NOTIFY_DONE;
 }
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index ff8528ad3dc6..7a9aa57b195b 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <net/net_namespace.h>
+#include <net/netns/generic.h>
 #include <net/netfilter/nf_tables.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
@@ -10,6 +11,8 @@
 #include <net/netfilter/nf_tables_ipv4.h>
 #include <net/netfilter/nf_tables_ipv6.h>
 
+extern unsigned int nf_tables_net_id;
+
 #ifdef CONFIG_NF_TABLES_IPV4
 static unsigned int nft_do_chain_ipv4(void *priv,
 				      struct sk_buff *skb,
@@ -355,6 +358,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct nftables_pernet *nft_net;
 	struct nft_table *table;
 	struct nft_chain *chain, *nr;
 	struct nft_ctx ctx = {
@@ -365,8 +369,9 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
-	mutex_lock(&ctx.net->nft.commit_mutex);
-	list_for_each_entry(table, &ctx.net->nft.tables, list) {
+	nft_net = net_generic(ctx.net, nf_tables_net_id);
+	mutex_lock(&nft_net->commit_mutex);
+	list_for_each_entry(table, &nft_net->tables, list) {
 		if (table->family != NFPROTO_NETDEV)
 			continue;
 
@@ -380,7 +385,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 			nft_netdev_event(event, dev, &ctx);
 		}
 	}
-	mutex_unlock(&ctx.net->nft.commit_mutex);
+	mutex_unlock(&nft_net->commit_mutex);
 
 	return NOTIFY_DONE;
 }
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index d44a70c11b3f..f9437a0dcfef 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -11,6 +11,9 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
+#include <net/netns/generic.h>
+
+extern unsigned int nf_tables_net_id;
 
 struct nft_dynset {
 	struct nft_set			*set;
@@ -161,13 +164,14 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
 {
+	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
 	struct nft_dynset *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set *set;
 	u64 timeout;
 	int err, i;
 
-	lockdep_assert_held(&ctx->net->nft.commit_mutex);
+	lockdep_assert_held(&nft_net->commit_mutex);
 
 	if (tb[NFTA_DYNSET_SET_NAME] == NULL ||
 	    tb[NFTA_DYNSET_OP] == NULL ||
-- 
2.30.2

