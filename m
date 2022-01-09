Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E71488D32
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbiAIXRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:18 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42172 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbiAIXRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:06 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0468B64693;
        Mon, 10 Jan 2022 00:14:14 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 25/32] netfilter: nf_tables: add rule blob layout
Date:   Mon, 10 Jan 2022 00:16:33 +0100
Message-Id: <20220109231640.104123-26-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a blob layout per chain to represent the ruleset in the
packet datapath.

	size (unsigned long)
	struct nft_rule_dp
	  struct nft_expr
	  ...
        struct nft_rule_dp
          struct nft_expr
          ...
        struct nft_rule_dp (is_last=1)

The new structure nft_rule_dp represents the rule in a more compact way
(smaller memory footprint) compared to the control-plane nft_rule
structure.

The ruleset blob is a read-only data structure. The first field contains
the blob size, then the rules containing expressions. There is a trailing
rule which is used by the tracing infrastructure which is equivalent to
the NULL rule marker in the previous representation. The blob size field
does not include the size of this trailing rule marker.

The ruleset blob is generated from the commit path.

This patch reuses the infrastructure available since 0cbc06b3faba
("netfilter: nf_tables: remove synchronize_rcu in commit phase") to
build the array of rules per chain.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  22 ++++-
 net/netfilter/nf_tables_api.c     | 149 ++++++++++++++++++++----------
 net/netfilter/nf_tables_core.c    |  41 +++++---
 net/netfilter/nf_tables_trace.c   |   2 +-
 4 files changed, 147 insertions(+), 67 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a0d9e0b47ab8..5a046b01bdab 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -974,6 +974,20 @@ static inline void nft_set_elem_update_expr(const struct nft_set_ext *ext,
 
 #define NFT_CHAIN_POLICY_UNSET		U8_MAX
 
+struct nft_rule_dp {
+	u64				is_last:1,
+					dlen:12,
+					handle:42;	/* for tracing */
+	unsigned char			data[]
+		__attribute__((aligned(__alignof__(struct nft_expr))));
+};
+
+struct nft_rule_blob {
+	unsigned long			size;
+	unsigned char			data[]
+		__attribute__((aligned(__alignof__(struct nft_rule_dp))));
+};
+
 /**
  *	struct nft_chain - nf_tables chain
  *
@@ -987,8 +1001,8 @@ static inline void nft_set_elem_update_expr(const struct nft_set_ext *ext,
  *	@name: name of the chain
  */
 struct nft_chain {
-	struct nft_rule			*__rcu *rules_gen_0;
-	struct nft_rule			*__rcu *rules_gen_1;
+	struct nft_rule_blob		__rcu *blob_gen_0;
+	struct nft_rule_blob		__rcu *blob_gen_1;
 	struct list_head		rules;
 	struct list_head		list;
 	struct rhlist_head		rhlhead;
@@ -1003,7 +1017,7 @@ struct nft_chain {
 	u8				*udata;
 
 	/* Only used during control plane commit phase: */
-	struct nft_rule			**rules_next;
+	struct nft_rule_blob		*blob_next;
 };
 
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
@@ -1321,7 +1335,7 @@ struct nft_traceinfo {
 	const struct nft_pktinfo	*pkt;
 	const struct nft_base_chain	*basechain;
 	const struct nft_chain		*chain;
-	const struct nft_rule		*rule;
+	const struct nft_rule_dp	*rule;
 	const struct nft_verdict	*verdict;
 	enum nft_trace_types		type;
 	bool				packet_dumped;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c0851fec11d4..2317429ea35e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1747,16 +1747,16 @@ static void nft_chain_stats_replace(struct nft_trans *trans)
 
 static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 {
-	struct nft_rule **g0 = rcu_dereference_raw(chain->rules_gen_0);
-	struct nft_rule **g1 = rcu_dereference_raw(chain->rules_gen_1);
+	struct nft_rule_blob *g0 = rcu_dereference_raw(chain->blob_gen_0);
+	struct nft_rule_blob *g1 = rcu_dereference_raw(chain->blob_gen_1);
 
 	if (g0 != g1)
 		kvfree(g1);
 	kvfree(g0);
 
 	/* should be NULL either via abort or via successful commit */
-	WARN_ON_ONCE(chain->rules_next);
-	kvfree(chain->rules_next);
+	WARN_ON_ONCE(chain->blob_next);
+	kvfree(chain->blob_next);
 }
 
 void nf_tables_chain_destroy(struct nft_ctx *ctx)
@@ -2002,23 +2002,39 @@ static void nft_chain_release_hook(struct nft_chain_hook *hook)
 
 struct nft_rules_old {
 	struct rcu_head h;
-	struct nft_rule **start;
+	struct nft_rule_blob *blob;
 };
 
-static struct nft_rule **nf_tables_chain_alloc_rules(const struct nft_chain *chain,
-						     unsigned int alloc)
+static void nft_last_rule(struct nft_rule_blob *blob, const void *ptr)
 {
-	if (alloc > INT_MAX)
+	struct nft_rule_dp *prule;
+
+	prule = (struct nft_rule_dp *)ptr;
+	prule->is_last = 1;
+	ptr += offsetof(struct nft_rule_dp, data);
+	/* blob size does not include the trailer rule */
+}
+
+static struct nft_rule_blob *nf_tables_chain_alloc_rules(unsigned int size)
+{
+	struct nft_rule_blob *blob;
+
+	/* size must include room for the last rule */
+	if (size < offsetof(struct nft_rule_dp, data))
+		return NULL;
+
+	size += sizeof(struct nft_rule_blob) + sizeof(struct nft_rules_old);
+	if (size > INT_MAX)
 		return NULL;
 
-	alloc += 1;	/* NULL, ends rules */
-	if (sizeof(struct nft_rule *) > INT_MAX / alloc)
+	blob = kvmalloc(size, GFP_KERNEL);
+	if (!blob)
 		return NULL;
 
-	alloc *= sizeof(struct nft_rule *);
-	alloc += sizeof(struct nft_rules_old);
+	blob->size = 0;
+	nft_last_rule(blob, blob->data);
 
-	return kvmalloc(alloc, GFP_KERNEL);
+	return blob;
 }
 
 static void nft_basechain_hook_init(struct nf_hook_ops *ops, u8 family,
@@ -2091,9 +2107,10 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	struct nft_stats __percpu *stats;
 	struct net *net = ctx->net;
 	char name[NFT_NAME_MAXLEN];
+	struct nft_rule_blob *blob;
 	struct nft_trans *trans;
 	struct nft_chain *chain;
-	struct nft_rule **rules;
+	unsigned int data_size;
 	int err;
 
 	if (table->use == UINT_MAX)
@@ -2178,15 +2195,15 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		chain->udlen = nla_len(nla[NFTA_CHAIN_USERDATA]);
 	}
 
-	rules = nf_tables_chain_alloc_rules(chain, 0);
-	if (!rules) {
+	data_size = offsetof(struct nft_rule_dp, data);	/* last rule */
+	blob = nf_tables_chain_alloc_rules(data_size);
+	if (!blob) {
 		err = -ENOMEM;
 		goto err_destroy_chain;
 	}
 
-	*rules = NULL;
-	rcu_assign_pointer(chain->rules_gen_0, rules);
-	rcu_assign_pointer(chain->rules_gen_1, rules);
+	RCU_INIT_POINTER(chain->blob_gen_0, blob);
+	RCU_INIT_POINTER(chain->blob_gen_1, blob);
 
 	err = nf_tables_register_hook(net, table, chain);
 	if (err < 0)
@@ -8241,32 +8258,72 @@ EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
+	const struct nft_expr *expr, *last;
+	unsigned int size, data_size;
+	void *data, *data_boundary;
+	struct nft_rule_dp *prule;
 	struct nft_rule *rule;
-	unsigned int alloc = 0;
 	int i;
 
 	/* already handled or inactive chain? */
-	if (chain->rules_next || !nft_is_active_next(net, chain))
+	if (chain->blob_next || !nft_is_active_next(net, chain))
 		return 0;
 
 	rule = list_entry(&chain->rules, struct nft_rule, list);
 	i = 0;
 
 	list_for_each_entry_continue(rule, &chain->rules, list) {
-		if (nft_is_active_next(net, rule))
-			alloc++;
+		if (nft_is_active_next(net, rule)) {
+			data_size += sizeof(*prule) + rule->dlen;
+			if (data_size > INT_MAX)
+				return -ENOMEM;
+		}
 	}
+	data_size += offsetof(struct nft_rule_dp, data);	/* last rule */
 
-	chain->rules_next = nf_tables_chain_alloc_rules(chain, alloc);
-	if (!chain->rules_next)
+	chain->blob_next = nf_tables_chain_alloc_rules(data_size);
+	if (!chain->blob_next)
 		return -ENOMEM;
 
+	data = (void *)chain->blob_next->data;
+	data_boundary = data + data_size;
+	size = 0;
+
 	list_for_each_entry_continue(rule, &chain->rules, list) {
-		if (nft_is_active_next(net, rule))
-			chain->rules_next[i++] = rule;
+		if (!nft_is_active_next(net, rule))
+			continue;
+
+		prule = (struct nft_rule_dp *)data;
+		data += offsetof(struct nft_rule_dp, data);
+		if (WARN_ON_ONCE(data > data_boundary))
+			return -ENOMEM;
+
+		nft_rule_for_each_expr(expr, last, rule) {
+			if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
+				return -ENOMEM;
+
+			memcpy(data + size, expr, expr->ops->size);
+			size += expr->ops->size;
+		}
+		if (WARN_ON_ONCE(size >= 1 << 12))
+			return -ENOMEM;
+
+		prule->handle = rule->handle;
+		prule->dlen = size;
+		prule->is_last = 0;
+
+		data += size;
+		size = 0;
+		chain->blob_next->size += (unsigned long)(data - (void *)prule);
 	}
 
-	chain->rules_next[i] = NULL;
+	prule = (struct nft_rule_dp *)data;
+	data += offsetof(struct nft_rule_dp, data);
+	if (WARN_ON_ONCE(data > data_boundary))
+		return -ENOMEM;
+
+	nft_last_rule(chain->blob_next, prule);
+
 	return 0;
 }
 
@@ -8280,8 +8337,8 @@ static void nf_tables_commit_chain_prepare_cancel(struct net *net)
 
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
 		    trans->msg_type == NFT_MSG_DELRULE) {
-			kvfree(chain->rules_next);
-			chain->rules_next = NULL;
+			kvfree(chain->blob_next);
+			chain->blob_next = NULL;
 		}
 	}
 }
@@ -8290,38 +8347,34 @@ static void __nf_tables_commit_chain_free_rules_old(struct rcu_head *h)
 {
 	struct nft_rules_old *o = container_of(h, struct nft_rules_old, h);
 
-	kvfree(o->start);
+	kvfree(o->blob);
 }
 
-static void nf_tables_commit_chain_free_rules_old(struct nft_rule **rules)
+static void nf_tables_commit_chain_free_rules_old(struct nft_rule_blob *blob)
 {
-	struct nft_rule **r = rules;
 	struct nft_rules_old *old;
 
-	while (*r)
-		r++;
-
-	r++;	/* rcu_head is after end marker */
-	old = (void *) r;
-	old->start = rules;
+	/* rcu_head is after end marker */
+	old = (void *)blob + sizeof(*blob) + blob->size;
+	old->blob = blob;
 
 	call_rcu(&old->h, __nf_tables_commit_chain_free_rules_old);
 }
 
 static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 {
-	struct nft_rule **g0, **g1;
+	struct nft_rule_blob *g0, *g1;
 	bool next_genbit;
 
 	next_genbit = nft_gencursor_next(net);
 
-	g0 = rcu_dereference_protected(chain->rules_gen_0,
+	g0 = rcu_dereference_protected(chain->blob_gen_0,
 				       lockdep_commit_lock_is_held(net));
-	g1 = rcu_dereference_protected(chain->rules_gen_1,
+	g1 = rcu_dereference_protected(chain->blob_gen_1,
 				       lockdep_commit_lock_is_held(net));
 
 	/* No changes to this chain? */
-	if (chain->rules_next == NULL) {
+	if (chain->blob_next == NULL) {
 		/* chain had no change in last or next generation */
 		if (g0 == g1)
 			return;
@@ -8330,10 +8383,10 @@ static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 		 * one uses same rules as current generation.
 		 */
 		if (next_genbit) {
-			rcu_assign_pointer(chain->rules_gen_1, g0);
+			rcu_assign_pointer(chain->blob_gen_1, g0);
 			nf_tables_commit_chain_free_rules_old(g1);
 		} else {
-			rcu_assign_pointer(chain->rules_gen_0, g1);
+			rcu_assign_pointer(chain->blob_gen_0, g1);
 			nf_tables_commit_chain_free_rules_old(g0);
 		}
 
@@ -8341,11 +8394,11 @@ static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 	}
 
 	if (next_genbit)
-		rcu_assign_pointer(chain->rules_gen_1, chain->rules_next);
+		rcu_assign_pointer(chain->blob_gen_1, chain->blob_next);
 	else
-		rcu_assign_pointer(chain->rules_gen_0, chain->rules_next);
+		rcu_assign_pointer(chain->blob_gen_0, chain->blob_next);
 
-	chain->rules_next = NULL;
+	chain->blob_next = NULL;
 
 	if (g0 == g1)
 		return;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index df5eda7c7554..36e73f9828c5 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -38,7 +38,7 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 
 static inline void nft_trace_packet(struct nft_traceinfo *info,
 				    const struct nft_chain *chain,
-				    const struct nft_rule *rule,
+				    const struct nft_rule_dp *rule,
 				    enum nft_trace_types type)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
@@ -88,7 +88,7 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 
 static inline void nft_trace_verdict(struct nft_traceinfo *info,
 				     const struct nft_chain *chain,
-				     const struct nft_rule *rule,
+				     const struct nft_rule_dp *rule,
 				     const struct nft_regs *regs)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
@@ -153,8 +153,9 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 }
 
 struct nft_jumpstack {
-	const struct nft_chain	*chain;
-	struct nft_rule	*const *rules;
+	const struct nft_chain *chain;
+	const struct nft_rule_dp *rule;
+	const struct nft_rule_dp *last_rule;
 };
 
 static void expr_call_ops_eval(const struct nft_expr *expr,
@@ -183,18 +184,28 @@ static void expr_call_ops_eval(const struct nft_expr *expr,
 	expr->ops->eval(expr, regs, pkt);
 }
 
+#define nft_rule_expr_first(rule)	(struct nft_expr *)&rule->data[0]
+#define nft_rule_expr_next(expr)	((void *)expr) + expr->ops->size
+#define nft_rule_expr_last(rule)	(struct nft_expr *)&rule->data[rule->dlen]
+#define nft_rule_next(rule)		(void *)rule + sizeof(*rule) + rule->dlen
+
+#define nft_rule_dp_for_each_expr(expr, last, rule) \
+        for ((expr) = nft_rule_expr_first(rule), (last) = nft_rule_expr_last(rule); \
+             (expr) != (last); \
+             (expr) = nft_rule_expr_next(expr))
+
 unsigned int
 nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 {
 	const struct nft_chain *chain = priv, *basechain = chain;
+	const struct nft_rule_dp *rule, *last_rule;
 	const struct net *net = nft_net(pkt);
-	struct nft_rule *const *rules;
-	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
 	struct nft_regs regs;
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
 	bool genbit = READ_ONCE(net->nft.gencursor);
+	struct nft_rule_blob *blob;
 	struct nft_traceinfo info;
 
 	info.trace = false;
@@ -202,16 +213,16 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		nft_trace_init(&info, pkt, &regs.verdict, basechain);
 do_chain:
 	if (genbit)
-		rules = rcu_dereference(chain->rules_gen_1);
+		blob = rcu_dereference(chain->blob_gen_1);
 	else
-		rules = rcu_dereference(chain->rules_gen_0);
+		blob = rcu_dereference(chain->blob_gen_0);
 
+	rule = (struct nft_rule_dp *)blob->data;
+	last_rule = (void *)blob->data + blob->size;
 next_rule:
-	rule = *rules;
 	regs.verdict.code = NFT_CONTINUE;
-	for (; *rules ; rules++) {
-		rule = *rules;
-		nft_rule_for_each_expr(expr, last, rule) {
+	for (; rule < last_rule; rule = nft_rule_next(rule)) {
+		nft_rule_dp_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
 			else if (expr->ops == &nft_bitwise_fast_ops)
@@ -251,7 +262,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		if (WARN_ON_ONCE(stackptr >= NFT_JUMP_STACK_SIZE))
 			return NF_DROP;
 		jumpstack[stackptr].chain = chain;
-		jumpstack[stackptr].rules = rules + 1;
+		jumpstack[stackptr].rule = nft_rule_next(rule);
+		jumpstack[stackptr].last_rule = last_rule;
 		stackptr++;
 		fallthrough;
 	case NFT_GOTO:
@@ -267,7 +279,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	if (stackptr > 0) {
 		stackptr--;
 		chain = jumpstack[stackptr].chain;
-		rules = jumpstack[stackptr].rules;
+		rule = jumpstack[stackptr].rule;
+		last_rule = jumpstack[stackptr].last_rule;
 		goto next_rule;
 	}
 
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 84a7dea46efa..5041725423c2 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -142,7 +142,7 @@ static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 static int nf_trace_fill_rule_info(struct sk_buff *nlskb,
 				   const struct nft_traceinfo *info)
 {
-	if (!info->rule)
+	if (!info->rule || info->rule->is_last)
 		return 0;
 
 	/* a continue verdict with ->type == RETURN means that this is
-- 
2.30.2

