Return-Path: <netdev+bounces-9342-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63BF0728918
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8FD91C21023
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEBED2D270;
	Thu,  8 Jun 2023 19:57:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ACC1F187
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 19:57:19 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 202D72D52;
	Thu,  8 Jun 2023 12:57:17 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 1/3] netfilter: nf_tables: integrate pipapo into commit protocol
Date: Thu,  8 Jun 2023 21:57:04 +0200
Message-Id: <20230608195706.4429-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230608195706.4429-1-pablo@netfilter.org>
References: <20230608195706.4429-1-pablo@netfilter.org>
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

The pipapo set backend follows copy-on-update approach, maintaining one
clone of the existing datastructure that is being updated. The clone
and current datastructures are swapped via rcu from the commit step.

The existing integration with the commit protocol is flawed because
there is no operation to clean up the clone if the transaction is
aborted. Moreover, the datastructure swap happens on set element
activation.

This patch adds two new operations for sets: commit and abort, these new
operations are invoked from the commit and abort steps, after the
transactions have been digested, and it updates the pipapo set backend
to use it.

This patch adds a new ->pending_update field to sets to maintain a list
of sets that require this new commit and abort operations.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++-
 net/netfilter/nf_tables_api.c     | 56 +++++++++++++++++++++++++++++++
 net/netfilter/nft_set_pipapo.c    | 55 +++++++++++++++++++++---------
 3 files changed, 99 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2e24ea1d744c..83db182decc8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -462,7 +462,8 @@ struct nft_set_ops {
 					       const struct nft_set *set,
 					       const struct nft_set_elem *elem,
 					       unsigned int flags);
-
+	void				(*commit)(const struct nft_set *set);
+	void				(*abort)(const struct nft_set *set);
 	u64				(*privsize)(const struct nlattr * const nla[],
 						    const struct nft_set_desc *desc);
 	bool				(*estimate)(const struct nft_set_desc *desc,
@@ -557,6 +558,7 @@ struct nft_set {
 	u16				policy;
 	u16				udlen;
 	unsigned char			*udata;
+	struct list_head		pending_update;
 	/* runtime data below here */
 	const struct nft_set_ops	*ops ____cacheline_aligned;
 	u16				flags:14,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0519d45ede6b..3bb0800b3849 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4919,6 +4919,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 
 	set->num_exprs = num_exprs;
 	set->handle = nf_tables_alloc_handle(table);
+	INIT_LIST_HEAD(&set->pending_update);
 
 	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
 	if (err < 0)
@@ -9275,10 +9276,25 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
 	}
 }
 
+static void nft_set_commit_update(struct list_head *set_update_list)
+{
+	struct nft_set *set, *next;
+
+	list_for_each_entry_safe(set, next, set_update_list, pending_update) {
+		list_del_init(&set->pending_update);
+
+		if (!set->ops->commit)
+			continue;
+
+		set->ops->commit(set);
+	}
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
+	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
@@ -9453,6 +9469,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_setelem_notify(&trans->ctx, te->set,
 						 &te->elem,
 						 NFT_MSG_NEWSETELEM);
+			if (te->set->ops->commit &&
+			    list_empty(&te->set->pending_update)) {
+				list_add_tail(&te->set->pending_update,
+					      &set_update_list);
+			}
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELSETELEM:
@@ -9467,6 +9488,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				atomic_dec(&te->set->nelems);
 				te->set->ndeact--;
 			}
+			if (te->set->ops->commit &&
+			    list_empty(&te->set->pending_update)) {
+				list_add_tail(&te->set->pending_update,
+					      &set_update_list);
+			}
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
@@ -9529,6 +9555,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
+	nft_set_commit_update(&set_update_list);
+
 	nft_commit_notify(net, NETLINK_CB(skb).portid);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 	nf_tables_commit_audit_log(&adl, nft_net->base_seq);
@@ -9588,10 +9616,25 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
+static void nft_set_abort_update(struct list_head *set_update_list)
+{
+	struct nft_set *set, *next;
+
+	list_for_each_entry_safe(set, next, set_update_list, pending_update) {
+		list_del_init(&set->pending_update);
+
+		if (!set->ops->abort)
+			continue;
+
+		set->ops->abort(set);
+	}
+}
+
 static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
+	LIST_HEAD(set_update_list);
 	struct nft_trans_elem *te;
 
 	if (action == NFNL_ABORT_VALIDATE &&
@@ -9701,6 +9744,12 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_setelem_remove(net, te->set, &te->elem);
 			if (!nft_setelem_is_catchall(te->set, &te->elem))
 				atomic_dec(&te->set->nelems);
+
+			if (te->set->ops->abort &&
+			    list_empty(&te->set->pending_update)) {
+				list_add_tail(&te->set->pending_update,
+					      &set_update_list);
+			}
 			break;
 		case NFT_MSG_DELSETELEM:
 		case NFT_MSG_DESTROYSETELEM:
@@ -9711,6 +9760,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			if (!nft_setelem_is_catchall(te->set, &te->elem))
 				te->set->ndeact--;
 
+			if (te->set->ops->abort &&
+			    list_empty(&te->set->pending_update)) {
+				list_add_tail(&te->set->pending_update,
+					      &set_update_list);
+			}
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWOBJ:
@@ -9753,6 +9807,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		}
 	}
 
+	nft_set_abort_update(&set_update_list);
+
 	synchronize_rcu();
 
 	list_for_each_entry_safe_reverse(trans, next,
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 06d46d182634..15e451dc3fc4 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1600,17 +1600,10 @@ static void pipapo_free_fields(struct nft_pipapo_match *m)
 	}
 }
 
-/**
- * pipapo_reclaim_match - RCU callback to free fields from old matching data
- * @rcu:	RCU head
- */
-static void pipapo_reclaim_match(struct rcu_head *rcu)
+static void pipapo_free_match(struct nft_pipapo_match *m)
 {
-	struct nft_pipapo_match *m;
 	int i;
 
-	m = container_of(rcu, struct nft_pipapo_match, rcu);
-
 	for_each_possible_cpu(i)
 		kfree(*per_cpu_ptr(m->scratch, i));
 
@@ -1625,7 +1618,19 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
 }
 
 /**
- * pipapo_commit() - Replace lookup data with current working copy
+ * pipapo_reclaim_match - RCU callback to free fields from old matching data
+ * @rcu:	RCU head
+ */
+static void pipapo_reclaim_match(struct rcu_head *rcu)
+{
+	struct nft_pipapo_match *m;
+
+	m = container_of(rcu, struct nft_pipapo_match, rcu);
+	pipapo_free_match(m);
+}
+
+/**
+ * nft_pipapo_commit() - Replace lookup data with current working copy
  * @set:	nftables API set representation
  *
  * While at it, check if we should perform garbage collection on the working
@@ -1635,7 +1640,7 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
  * We also need to create a new working copy for subsequent insertions and
  * deletions.
  */
-static void pipapo_commit(const struct nft_set *set)
+static void nft_pipapo_commit(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *new_clone, *old;
@@ -1660,6 +1665,26 @@ static void pipapo_commit(const struct nft_set *set)
 	priv->clone = new_clone;
 }
 
+static void nft_pipapo_abort(const struct nft_set *set)
+{
+	struct nft_pipapo *priv = nft_set_priv(set);
+	struct nft_pipapo_match *new_clone, *m;
+
+	if (!priv->dirty)
+		return;
+
+	m = rcu_dereference(priv->match);
+
+	new_clone = pipapo_clone(m);
+	if (IS_ERR(new_clone))
+		return;
+
+	priv->dirty = false;
+
+	pipapo_free_match(priv->clone);
+	priv->clone = new_clone;
+}
+
 /**
  * nft_pipapo_activate() - Mark element reference as active given key, commit
  * @net:	Network namespace
@@ -1667,8 +1692,7 @@ static void pipapo_commit(const struct nft_set *set)
  * @elem:	nftables API element representation containing key data
  *
  * On insertion, elements are added to a copy of the matching data currently
- * in use for lookups, and not directly inserted into current lookup data, so
- * we'll take care of that by calling pipapo_commit() here. Both
+ * in use for lookups, and not directly inserted into current lookup data. Both
  * nft_pipapo_insert() and nft_pipapo_activate() are called once for each
  * element, hence we can't purpose either one as a real commit operation.
  */
@@ -1684,8 +1708,6 @@ static void nft_pipapo_activate(const struct net *net,
 
 	nft_set_elem_change_active(net, set, &e->ext);
 	nft_set_elem_clear_busy(&e->ext);
-
-	pipapo_commit(set);
 }
 
 /**
@@ -1931,7 +1953,6 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 		if (i == m->field_count) {
 			priv->dirty = true;
 			pipapo_drop(m, rulemap);
-			pipapo_commit(set);
 			return;
 		}
 
@@ -2230,6 +2251,8 @@ const struct nft_set_type nft_set_pipapo_type = {
 		.init		= nft_pipapo_init,
 		.destroy	= nft_pipapo_destroy,
 		.gc_init	= nft_pipapo_gc_init,
+		.commit		= nft_pipapo_commit,
+		.abort		= nft_pipapo_abort,
 		.elemsize	= offsetof(struct nft_pipapo_elem, ext),
 	},
 };
@@ -2252,6 +2275,8 @@ const struct nft_set_type nft_set_pipapo_avx2_type = {
 		.init		= nft_pipapo_init,
 		.destroy	= nft_pipapo_destroy,
 		.gc_init	= nft_pipapo_gc_init,
+		.commit		= nft_pipapo_commit,
+		.abort		= nft_pipapo_abort,
 		.elemsize	= offsetof(struct nft_pipapo_elem, ext),
 	},
 };
-- 
2.30.2


