Return-Path: <netdev+bounces-12000-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 265C3735A55
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B35B1C20403
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9057A12B86;
	Mon, 19 Jun 2023 14:58:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEC612B73
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:58:47 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CA911AE;
	Mon, 19 Jun 2023 07:58:44 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 04/14] netfilter: nf_tables: drop map element references from preparation phase
Date: Mon, 19 Jun 2023 16:57:55 +0200
Message-Id: <20230619145805.303940-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230619145805.303940-1-pablo@netfilter.org>
References: <20230619145805.303940-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

set .destroy callback releases the references to other objects in maps.
This is very late and it results in spurious EBUSY errors. Drop refcount
from the preparation phase instead, update set backend not to drop
reference counter from set .destroy path.

Exceptions: NFT_TRANS_PREPARE_ERROR does not require to drop the
reference counter because the transaction abort path releases the map
references for each element since the set is unbound. The abort path
also deals with releasing reference counter for new elements added to
unbound sets.

Fixes: 591054469b3e ("netfilter: nf_tables: revisit chain/object refcounting from elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   5 +-
 net/netfilter/nf_tables_api.c     | 147 ++++++++++++++++++++++++++----
 net/netfilter/nft_set_bitmap.c    |   5 +-
 net/netfilter/nft_set_hash.c      |  23 ++++-
 net/netfilter/nft_set_pipapo.c    |  14 ++-
 net/netfilter/nft_set_rbtree.c    |   5 +-
 6 files changed, 167 insertions(+), 32 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index de2b0130c151..f84b6daea5c4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -472,7 +472,8 @@ struct nft_set_ops {
 	int				(*init)(const struct nft_set *set,
 						const struct nft_set_desc *desc,
 						const struct nlattr * const nla[]);
-	void				(*destroy)(const struct nft_set *set);
+	void				(*destroy)(const struct nft_ctx *ctx,
+						   const struct nft_set *set);
 	void				(*gc_init)(const struct nft_set *set);
 
 	unsigned int			elemsize;
@@ -809,6 +810,8 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_expr *expr_array[]);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr);
+void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
+				const struct nft_set *set, void *elem);
 
 /**
  *	struct nft_set_gc_batch_head - nf_tables set garbage collection batch
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f8afefc8294f..e2493f83c48e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -559,6 +559,58 @@ static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 	return __nft_trans_set_add(ctx, msg_type, set, NULL);
 }
 
+static void nft_setelem_data_deactivate(const struct net *net,
+					const struct nft_set *set,
+					struct nft_set_elem *elem);
+
+static int nft_mapelem_deactivate(const struct nft_ctx *ctx,
+				  struct nft_set *set,
+				  const struct nft_set_iter *iter,
+				  struct nft_set_elem *elem)
+{
+	nft_setelem_data_deactivate(ctx->net, set, elem);
+
+	return 0;
+}
+
+struct nft_set_elem_catchall {
+	struct list_head	list;
+	struct rcu_head		rcu;
+	void			*elem;
+};
+
+static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
+					struct nft_set *set)
+{
+	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
+
+	list_for_each_entry(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask))
+			continue;
+
+		elem.priv = catchall->elem;
+		nft_setelem_data_deactivate(ctx->net, set, &elem);
+		break;
+	}
+}
+
+static void nft_map_deactivate(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	struct nft_set_iter iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+		.fn		= nft_mapelem_deactivate,
+	};
+
+	set->ops->walk(ctx, set, &iter);
+	WARN_ON_ONCE(iter.err);
+
+	nft_map_catchall_deactivate(ctx, set);
+}
+
 static int nft_delset(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	int err;
@@ -567,6 +619,9 @@ static int nft_delset(const struct nft_ctx *ctx, struct nft_set *set)
 	if (err < 0)
 		return err;
 
+	if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+		nft_map_deactivate(ctx, set);
+
 	nft_deactivate_next(ctx->net, set);
 	ctx->table->use--;
 
@@ -3659,12 +3714,6 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
-struct nft_set_elem_catchall {
-	struct list_head	list;
-	struct rcu_head		rcu;
-	void			*elem;
-};
-
 int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	u8 genmask = nft_genmask_next(ctx->net);
@@ -4997,7 +5046,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	for (i = 0; i < set->num_exprs; i++)
 		nft_expr_destroy(&ctx, set->exprs[i]);
 err_set_destroy:
-	ops->destroy(set);
+	ops->destroy(&ctx, set);
 err_set_init:
 	kfree(set->name);
 err_set_name:
@@ -5012,7 +5061,7 @@ static void nft_set_catchall_destroy(const struct nft_ctx *ctx,
 
 	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
 		list_del_rcu(&catchall->list);
-		nft_set_elem_destroy(set, catchall->elem, true);
+		nf_tables_set_elem_destroy(ctx, set, catchall->elem);
 		kfree_rcu(catchall, rcu);
 	}
 }
@@ -5027,7 +5076,7 @@ static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 	for (i = 0; i < set->num_exprs; i++)
 		nft_expr_destroy(ctx, set->exprs[i]);
 
-	set->ops->destroy(set);
+	set->ops->destroy(ctx, set);
 	nft_set_catchall_destroy(ctx, set);
 	kfree(set->name);
 	kvfree(set);
@@ -5192,10 +5241,60 @@ static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	}
 }
 
+static void nft_setelem_data_activate(const struct net *net,
+				      const struct nft_set *set,
+				      struct nft_set_elem *elem);
+
+static int nft_mapelem_activate(const struct nft_ctx *ctx,
+				struct nft_set *set,
+				const struct nft_set_iter *iter,
+				struct nft_set_elem *elem)
+{
+	nft_setelem_data_activate(ctx->net, set, elem);
+
+	return 0;
+}
+
+static void nft_map_catchall_activate(const struct nft_ctx *ctx,
+				      struct nft_set *set)
+{
+	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
+
+	list_for_each_entry(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask))
+			continue;
+
+		elem.priv = catchall->elem;
+		nft_setelem_data_activate(ctx->net, set, &elem);
+		break;
+	}
+}
+
+static void nft_map_activate(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	struct nft_set_iter iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+		.fn		= nft_mapelem_activate,
+	};
+
+	set->ops->walk(ctx, set, &iter);
+	WARN_ON_ONCE(iter.err);
+
+	nft_map_catchall_activate(ctx, set);
+}
+
 void nf_tables_activate_set(const struct nft_ctx *ctx, struct nft_set *set)
 {
-	if (nft_set_is_anonymous(set))
+	if (nft_set_is_anonymous(set)) {
+		if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+			nft_map_activate(ctx, set);
+
 		nft_clear(ctx->net, set);
+	}
 
 	set->use++;
 }
@@ -5214,13 +5313,20 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 		set->use--;
 		break;
 	case NFT_TRANS_PREPARE:
-		if (nft_set_is_anonymous(set))
-			nft_deactivate_next(ctx->net, set);
+		if (nft_set_is_anonymous(set)) {
+			if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+				nft_map_deactivate(ctx, set);
 
+			nft_deactivate_next(ctx->net, set);
+		}
 		set->use--;
 		return;
 	case NFT_TRANS_ABORT:
 	case NFT_TRANS_RELEASE:
+		if (nft_set_is_anonymous(set) &&
+		    set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+			nft_map_deactivate(ctx, set);
+
 		set->use--;
 		fallthrough;
 	default:
@@ -5973,6 +6079,7 @@ static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 		__nft_set_elem_expr_destroy(ctx, expr);
 }
 
+/* Drop references and destroy. Called from gc, dynset and abort path. */
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr)
 {
@@ -5994,11 +6101,11 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 }
 EXPORT_SYMBOL_GPL(nft_set_elem_destroy);
 
-/* Only called from commit path, nft_setelem_data_deactivate() already deals
- * with the refcounting from the preparation phase.
+/* Destroy element. References have been already dropped in the preparation
+ * path via nft_setelem_data_deactivate().
  */
-static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
-				       const struct nft_set *set, void *elem)
+void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
+				const struct nft_set *set, void *elem)
 {
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
@@ -6631,7 +6738,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (obj)
 		obj->use--;
 err_elem_userdata:
-	nf_tables_set_elem_destroy(ctx, set, elem.priv);
+	nft_set_elem_destroy(set, elem.priv, true);
 err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_release(&elem.data.val, desc.type);
@@ -9799,6 +9906,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DESTROYSET:
 			trans->ctx.table->use++;
 			nft_clear(trans->ctx.net, nft_trans_set(trans));
+			if (nft_trans_set(trans)->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+				nft_map_activate(&trans->ctx, nft_trans_set(trans));
+
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
@@ -10568,6 +10678,9 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 	list_for_each_entry_safe(set, ns, &table->sets, list) {
 		list_del(&set->list);
 		table->use--;
+		if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+			nft_map_deactivate(&ctx, set);
+
 		nft_set_destroy(&ctx, set);
 	}
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 96081ac8d2b4..1e5e7a181e0b 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -271,13 +271,14 @@ static int nft_bitmap_init(const struct nft_set *set,
 	return 0;
 }
 
-static void nft_bitmap_destroy(const struct nft_set *set)
+static void nft_bitmap_destroy(const struct nft_ctx *ctx,
+			       const struct nft_set *set)
 {
 	struct nft_bitmap *priv = nft_set_priv(set);
 	struct nft_bitmap_elem *be, *n;
 
 	list_for_each_entry_safe(be, n, &priv->list, head)
-		nft_set_elem_destroy(set, be, true);
+		nf_tables_set_elem_destroy(ctx, set, be);
 }
 
 static bool nft_bitmap_estimate(const struct nft_set_desc *desc, u32 features,
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 76de6c8d9865..0b73cb0e752f 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -400,19 +400,31 @@ static int nft_rhash_init(const struct nft_set *set,
 	return 0;
 }
 
+struct nft_rhash_ctx {
+	const struct nft_ctx	ctx;
+	const struct nft_set	*set;
+};
+
 static void nft_rhash_elem_destroy(void *ptr, void *arg)
 {
-	nft_set_elem_destroy(arg, ptr, true);
+	struct nft_rhash_ctx *rhash_ctx = arg;
+
+	nf_tables_set_elem_destroy(&rhash_ctx->ctx, rhash_ctx->set, ptr);
 }
 
-static void nft_rhash_destroy(const struct nft_set *set)
+static void nft_rhash_destroy(const struct nft_ctx *ctx,
+			      const struct nft_set *set)
 {
 	struct nft_rhash *priv = nft_set_priv(set);
+	struct nft_rhash_ctx rhash_ctx = {
+		.ctx	= *ctx,
+		.set	= set,
+	};
 
 	cancel_delayed_work_sync(&priv->gc_work);
 	rcu_barrier();
 	rhashtable_free_and_destroy(&priv->ht, nft_rhash_elem_destroy,
-				    (void *)set);
+				    (void *)&rhash_ctx);
 }
 
 /* Number of buckets is stored in u32, so cap our result to 1U<<31 */
@@ -643,7 +655,8 @@ static int nft_hash_init(const struct nft_set *set,
 	return 0;
 }
 
-static void nft_hash_destroy(const struct nft_set *set)
+static void nft_hash_destroy(const struct nft_ctx *ctx,
+			     const struct nft_set *set)
 {
 	struct nft_hash *priv = nft_set_priv(set);
 	struct nft_hash_elem *he;
@@ -653,7 +666,7 @@ static void nft_hash_destroy(const struct nft_set *set)
 	for (i = 0; i < priv->buckets; i++) {
 		hlist_for_each_entry_safe(he, next, &priv->table[i], node) {
 			hlist_del_rcu(&he->node);
-			nft_set_elem_destroy(set, he, true);
+			nf_tables_set_elem_destroy(ctx, set, he);
 		}
 	}
 }
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 15e451dc3fc4..c867b5b772e8 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2148,10 +2148,12 @@ static int nft_pipapo_init(const struct nft_set *set,
 
 /**
  * nft_set_pipapo_match_destroy() - Destroy elements from key mapping array
+ * @ctx:	context
  * @set:	nftables API set representation
  * @m:		matching data pointing to key mapping array
  */
-static void nft_set_pipapo_match_destroy(const struct nft_set *set,
+static void nft_set_pipapo_match_destroy(const struct nft_ctx *ctx,
+					 const struct nft_set *set,
 					 struct nft_pipapo_match *m)
 {
 	struct nft_pipapo_field *f;
@@ -2168,15 +2170,17 @@ static void nft_set_pipapo_match_destroy(const struct nft_set *set,
 
 		e = f->mt[r].e;
 
-		nft_set_elem_destroy(set, e, true);
+		nf_tables_set_elem_destroy(ctx, set, e);
 	}
 }
 
 /**
  * nft_pipapo_destroy() - Free private data for set and all committed elements
+ * @ctx:	context
  * @set:	nftables API set representation
  */
-static void nft_pipapo_destroy(const struct nft_set *set)
+static void nft_pipapo_destroy(const struct nft_ctx *ctx,
+			       const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
@@ -2186,7 +2190,7 @@ static void nft_pipapo_destroy(const struct nft_set *set)
 	if (m) {
 		rcu_barrier();
 
-		nft_set_pipapo_match_destroy(set, m);
+		nft_set_pipapo_match_destroy(ctx, set, m);
 
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(m->scratch_aligned);
@@ -2203,7 +2207,7 @@ static void nft_pipapo_destroy(const struct nft_set *set)
 		m = priv->clone;
 
 		if (priv->dirty)
-			nft_set_pipapo_match_destroy(set, m);
+			nft_set_pipapo_match_destroy(ctx, set, m);
 
 #ifdef NFT_PIPAPO_ALIGN
 		free_percpu(priv->clone->scratch_aligned);
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 2f114aa10f1a..5c05c9b990fb 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -664,7 +664,8 @@ static int nft_rbtree_init(const struct nft_set *set,
 	return 0;
 }
 
-static void nft_rbtree_destroy(const struct nft_set *set)
+static void nft_rbtree_destroy(const struct nft_ctx *ctx,
+			       const struct nft_set *set)
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe;
@@ -675,7 +676,7 @@ static void nft_rbtree_destroy(const struct nft_set *set)
 	while ((node = priv->root.rb_node) != NULL) {
 		rb_erase(node, &priv->root);
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
-		nft_set_elem_destroy(set, rbe, true);
+		nf_tables_set_elem_destroy(ctx, set, rbe);
 	}
 }
 
-- 
2.30.2


