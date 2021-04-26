Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D19C36B7CC
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbhDZRNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:13:08 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51524 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235878AbhDZRL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id CF0326412E;
        Mon, 26 Apr 2021 19:10:36 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 17/22] netfilter: nftables: add nft_pernet() helper function
Date:   Mon, 26 Apr 2021 19:10:51 +0200
Message-Id: <20210426171056.345271-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consolidate call to net_generic(net, nf_tables_net_id) in this
wrapper function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   8 +++
 net/netfilter/nf_tables_api.c     | 112 +++++++++++++++---------------
 net/netfilter/nf_tables_offload.c |  10 ++-
 net/netfilter/nft_chain_filter.c  |   5 +-
 net/netfilter/nft_dynset.c        |   5 +-
 5 files changed, 69 insertions(+), 71 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4a75da2a2e1d..eb708b77c4a5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -13,6 +13,7 @@
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netlink.h>
 #include <net/flow_offload.h>
+#include <net/netns/generic.h>
 
 #define NFT_MAX_HOOKS	(NF_INET_INGRESS + 1)
 
@@ -1580,4 +1581,11 @@ struct nftables_pernet {
 	u8			validate_state;
 };
 
+extern unsigned int nf_tables_net_id;
+
+static inline struct nftables_pernet *nft_pernet(const struct net *net)
+{
+	return net_generic(net, nf_tables_net_id);
+}
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 357443b3c0e4..155b85553fcc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -21,7 +21,6 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/net_namespace.h>
-#include <net/netns/generic.h>
 #include <net/sock.h>
 
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
@@ -106,7 +105,7 @@ static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
 
 static void nft_validate_state_update(struct net *net, u8 new_validate_state)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	switch (nft_net->validate_state) {
 	case NFT_VALIDATE_SKIP:
@@ -181,7 +180,7 @@ static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
 	if (!nft_set_is_anonymous(set))
 		return;
 
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	list_for_each_entry_reverse(trans, &nft_net->commit_list, list) {
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWSET:
@@ -278,9 +277,8 @@ static void nf_tables_unregister_hook(struct net *net,
 
 static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *trans)
 {
-	struct nftables_pernet *nft_net;
+	struct nftables_pernet *nft_net = nft_pernet(net);
 
-	nft_net = net_generic(net, nf_tables_net_id);
 	list_add_tail(&trans->list, &nft_net->commit_list);
 }
 
@@ -566,7 +564,7 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	list_for_each_entry_rcu(table, &nft_net->tables, list,
 				lockdep_is_held(&nft_net->commit_mutex)) {
 		if (!nla_strcmp(nla, table->name) &&
@@ -590,7 +588,7 @@ static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 	struct nftables_pernet *nft_net;
 	struct nft_table *table;
 
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (be64_to_cpu(nla_get_be64(nla)) == table->handle &&
 		    nft_active_genmask(table, genmask))
@@ -655,7 +653,7 @@ __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
 	if (ret >= MODULE_NAME_LEN)
 		return 0;
 
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	list_for_each_entry(req, &nft_net->module_list, list) {
 		if (!strcmp(req->module, module_name)) {
 			if (req->done)
@@ -711,7 +709,7 @@ nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
 
 static __be16 nft_base_seq(const struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	return htons(nft_net->base_seq & 0xffff);
 }
@@ -793,7 +791,7 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 		goto err;
 	}
 
-	nft_net = net_generic(ctx->net, nf_tables_net_id);
+	nft_net = nft_pernet(ctx->net);
 	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
 	return;
 err:
@@ -811,7 +809,7 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 	int family = nfmsg->nfgen_family;
 
 	rcu_read_lock();
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	cb->seq = nft_net->base_seq;
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
@@ -1062,7 +1060,7 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 			      const struct nlattr * const nla[],
 			      struct netlink_ext_ack *extack)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
@@ -1221,9 +1219,9 @@ static int nft_flush_table(struct nft_ctx *ctx)
 
 static int nft_flush(struct nft_ctx *ctx, int family)
 {
-	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
-	struct nft_table *table, *nt;
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	const struct nlattr * const *nla = ctx->nla;
+	struct nft_table *table, *nt;
 	int err = 0;
 
 	list_for_each_entry_safe(table, nt, &nft_net->tables, list) {
@@ -1345,7 +1343,7 @@ nft_chain_lookup_byhandle(const struct nft_table *table, u64 handle, u8 genmask)
 static bool lockdep_commit_lock_is_held(const struct net *net)
 {
 #ifdef CONFIG_PROVE_LOCKING
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	return lockdep_is_held(&nft_net->commit_mutex);
 #else
@@ -1570,7 +1568,7 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 		goto err;
 	}
 
-	nft_net = net_generic(ctx->net, nf_tables_net_id);
+	nft_net = nft_pernet(ctx->net);
 	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
 	return;
 err:
@@ -1581,15 +1579,15 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 				 struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	const struct nft_table *table;
-	const struct nft_chain *chain;
 	unsigned int idx = 0, s_idx = cb->args[0];
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
+	const struct nft_table *table;
+	const struct nft_chain *chain;
 
 	rcu_read_lock();
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	cb->seq = nft_net->base_seq;
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
@@ -1908,7 +1906,7 @@ static int nft_chain_parse_hook(struct net *net,
 				struct nft_chain_hook *hook, u8 family,
 				bool autoload)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nlattr *ha[NFTA_HOOK_MAX + 1];
 	const struct nft_chain_type *type;
 	int err;
@@ -2302,7 +2300,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 	if (nla[NFTA_CHAIN_HANDLE] &&
 	    nla[NFTA_CHAIN_NAME]) {
-		struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
+		struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 		struct nft_trans *tmp;
 		char *name;
 
@@ -2338,7 +2336,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 static struct nft_chain *nft_chain_lookup_byid(const struct net *net,
 					       const struct nlattr *nla)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	u32 id = ntohl(nla_get_be32(nla));
 	struct nft_trans *trans;
 
@@ -2357,7 +2355,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 			      const struct nlattr * const nla[],
 			      struct netlink_ext_ack *extack)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
@@ -2908,7 +2906,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 				  const struct nft_rule *rule, int event)
 {
-	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	struct sk_buff *skb;
 	int err;
 
@@ -2989,7 +2987,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	struct nftables_pernet *nft_net;
 
 	rcu_read_lock();
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	cb->seq = nft_net->base_seq;
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
@@ -3223,7 +3221,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 			     const struct nlattr * const nla[],
 			     struct netlink_ext_ack *extack)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_next(net);
 	struct nft_expr_info *info = NULL;
@@ -3442,7 +3440,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nlattr *nla)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	u32 id = ntohl(nla_get_be32(nla));
 	struct nft_trans *trans;
 
@@ -3559,7 +3557,7 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 		   const struct nft_set_desc *desc,
 		   enum nft_set_policies policy)
 {
-	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	const struct nft_set_ops *ops, *bops;
 	struct nft_set_estimate est, best;
 	const struct nft_set_type *type;
@@ -3704,9 +3702,9 @@ static struct nft_set *nft_set_lookup_byhandle(const struct nft_table *table,
 static struct nft_set *nft_set_lookup_byid(const struct net *net,
 					   const struct nlattr *nla, u8 genmask)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
-	struct nft_trans *trans;
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	u32 id = ntohl(nla_get_be32(nla));
+	struct nft_trans *trans;
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
 		if (trans->msg_type == NFT_MSG_NEWSET) {
@@ -3942,7 +3940,7 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 				 const struct nft_set *set, int event,
 			         gfp_t gfp_flags)
 {
-	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	struct sk_buff *skb;
 	u32 portid = ctx->portid;
 	int err;
@@ -3980,7 +3978,7 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 		return skb->len;
 
 	rcu_read_lock();
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	cb->seq = nft_net->base_seq;
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
@@ -4833,7 +4831,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	int event;
 
 	rcu_read_lock();
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (dump_ctx->ctx.family != NFPROTO_UNSPEC &&
 		    dump_ctx->ctx.family != table->family)
@@ -5138,7 +5136,7 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
 	return;
 err:
@@ -5660,7 +5658,7 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 				const struct nlattr * const nla[],
 				struct netlink_ext_ack *extack)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	u8 genmask = nft_genmask_next(net);
 	const struct nlattr *attr;
 	struct nft_set *set;
@@ -6323,7 +6321,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 		reset = true;
 
 	rcu_read_lock();
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	cb->seq = nft_net->base_seq;
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
@@ -6473,7 +6471,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 		const struct nftables_pernet *nft_net;
 		char *buf;
 
-		nft_net = net_generic(net, nf_tables_net_id);
+		nft_net = nft_pernet(net);
 		buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
 
 		audit_log_nfcfg(buf,
@@ -6560,7 +6558,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 		    struct nft_object *obj, u32 portid, u32 seq, int event,
 		    int family, int report, gfp_t gfp)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct sk_buff *skb;
 	int err;
 	char *buf = kasprintf(gfp, "%s:%u",
@@ -7246,7 +7244,7 @@ static int nf_tables_dump_flowtable(struct sk_buff *skb,
 	const struct nft_table *table;
 
 	rcu_read_lock();
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	cb->seq = nft_net->base_seq;
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
@@ -7384,7 +7382,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 				       struct list_head *hook_list,
 				       int event)
 {
-	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	struct sk_buff *skb;
 	int err;
 
@@ -7429,7 +7427,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 				   u32 portid, u32 seq)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nlmsghdr *nlh;
 	char buf[TASK_COMM_LEN];
 	int event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWGEN);
@@ -7482,7 +7480,7 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 		return 0;
 
 	net = dev_net(dev);
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
@@ -7670,7 +7668,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 
 static int nf_tables_validate(struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_table *table;
 
 	switch (nft_net->validate_state) {
@@ -7855,7 +7853,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 
 static void nf_tables_commit_chain_prepare_cancel(struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
 
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
@@ -7967,7 +7965,7 @@ static void nft_flowtable_hooks_del(struct nft_flowtable *flowtable,
 
 static void nf_tables_module_autoload_cleanup(struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_module_request *req, *next;
 
 	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
@@ -7980,7 +7978,7 @@ static void nf_tables_module_autoload_cleanup(struct net *net)
 
 static void nf_tables_commit_release(struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans;
 
 	/* all side effects have to be made visible.
@@ -8014,7 +8012,7 @@ static void nf_tables_commit_release(struct net *net)
 
 static void nft_commit_notify(struct net *net, u32 portid)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct sk_buff *batch_skb = NULL, *nskb, *skb;
 	unsigned char *data;
 	int len;
@@ -8101,7 +8099,7 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
 
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
@@ -8322,7 +8320,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 static void nf_tables_module_autoload(struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_module_request *req, *next;
 	LIST_HEAD(module_list);
 
@@ -8370,7 +8368,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 
 static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
 	struct nft_hook *hook;
@@ -8524,7 +8522,7 @@ static void nf_tables_cleanup(struct net *net)
 static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 			   enum nfnl_abort_action action)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	int ret = __nf_tables_abort(net, action);
 
 	mutex_unlock(&nft_net->commit_mutex);
@@ -8534,7 +8532,7 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 
 static bool nf_tables_valid_genid(struct net *net, u32 genid)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	bool genid_ok;
 
 	mutex_lock(&nft_net->commit_mutex);
@@ -9096,7 +9094,7 @@ static void __nft_release_hook(struct net *net, struct nft_table *table)
 
 static void __nft_release_hooks(struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_table *table;
 
 	list_for_each_entry(table, &nft_net->tables, list) {
@@ -9156,7 +9154,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 
 static void __nft_release_tables(struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_table *table, *nt;
 
 	list_for_each_entry_safe(table, nt, &nft_net->tables, list) {
@@ -9179,7 +9177,7 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
 		return NOTIFY_DONE;
 
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
@@ -9207,7 +9205,7 @@ static struct notifier_block nft_nl_notifier = {
 
 static int __net_init nf_tables_init_net(struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	INIT_LIST_HEAD(&nft_net->tables);
 	INIT_LIST_HEAD(&nft_net->commit_list);
@@ -9227,7 +9225,7 @@ static void __net_exit nf_tables_pre_exit_net(struct net *net)
 
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	mutex_lock(&nft_net->commit_mutex);
 	if (!list_empty(&nft_net->commit_list))
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 19215e81dd66..a48c5fd53a80 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -7,8 +7,6 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/pkt_cls.h>
 
-extern unsigned int nf_tables_net_id;
-
 static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
 {
 	struct nft_flow_rule *flow;
@@ -389,7 +387,7 @@ static void nft_indr_block_cleanup(struct flow_block_cb *block_cb)
 
 	nft_flow_block_offload_init(&bo, dev_net(dev), FLOW_BLOCK_UNBIND,
 				    basechain, &extack);
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
@@ -490,7 +488,7 @@ static int nft_flow_offload_chain(struct nft_chain *chain, u8 *ppolicy,
 static void nft_flow_rule_offload_abort(struct net *net,
 					struct nft_trans *trans)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	int err = 0;
 
 	list_for_each_entry_continue_reverse(trans, &nft_net->commit_list, list) {
@@ -539,7 +537,7 @@ static void nft_flow_rule_offload_abort(struct net *net,
 
 int nft_flow_rule_offload_commit(struct net *net)
 {
-	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans;
 	int err = 0;
 	u8 policy;
@@ -663,7 +661,7 @@ static int nft_offload_netdev_event(struct notifier_block *this,
 	if (event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
-	nft_net = net_generic(net, nf_tables_net_id);
+	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
 	chain = __nft_offload_get_chain(nft_net, dev);
 	if (chain)
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 7a9aa57b195b..363bdd7044ec 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -2,7 +2,6 @@
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <net/net_namespace.h>
-#include <net/netns/generic.h>
 #include <net/netfilter/nf_tables.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
@@ -11,8 +10,6 @@
 #include <net/netfilter/nf_tables_ipv4.h>
 #include <net/netfilter/nf_tables_ipv6.h>
 
-extern unsigned int nf_tables_net_id;
-
 #ifdef CONFIG_NF_TABLES_IPV4
 static unsigned int nft_do_chain_ipv4(void *priv,
 				      struct sk_buff *skb,
@@ -369,7 +366,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
-	nft_net = net_generic(ctx.net, nf_tables_net_id);
+	nft_net = nft_pernet(ctx.net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (table->family != NFPROTO_NETDEV)
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index f9437a0dcfef..6ba3256fa844 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -11,9 +11,6 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
-#include <net/netns/generic.h>
-
-extern unsigned int nf_tables_net_id;
 
 struct nft_dynset {
 	struct nft_set			*set;
@@ -164,7 +161,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
 {
-	struct nftables_pernet *nft_net = net_generic(ctx->net, nf_tables_net_id);
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	struct nft_dynset *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set *set;
-- 
2.30.2

