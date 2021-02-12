Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCDD319874
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhBLDAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:00:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhBLC6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C739E64E87;
        Fri, 12 Feb 2021 02:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098648;
        bh=off2d4i+mMAyjaC5bo/I5cN6g/VL1TOSVlooj+dnGtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJfOz5IOK6ps/k4/wTFnHl0Z6bqutgpEztGawuPI1joC0mlfnsDrJM9mdfaXaIqPC
         N4JMZRZgJ2nLrqhiLHSt8bjU5AMPTlwKx1wZik5SW4pdT55cWIEu14UB1HT926GeME
         UY1mwVhjNUzena5LfoXNNv1JBZMbOe3kEYwHYadEU+UfMvOrGVINbS5dH6Vrk9lYfE
         Iz0KFBHT0/aG6rbDZhsRB3UahP/rRtJI70SQtCFrqjwr6mtmJjgd8FvgRXBRFUuk4A
         MOcYWXcFtsLGoE6f9wFmBzf6argLBfoNyxfEWxlfAoMzl0oBnkoodzy+QT2ypzq4Re
         872NxDNBv04fQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 14/15] net/mlx5e: CT: manage the lifetime of the ct entry object
Date:   Thu, 11 Feb 2021 18:56:40 -0800
Message-Id: <20210212025641.323844-15-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

The ct entry object is accessed by the ct add, del, stats and restore
methods. In addition, it is referenced from several hash tables.

The lifetime of the ct entry object was not managed which triggered race
conditions as in the following kasan dump:
[ 3374.973945] ==================================================================
[ 3374.988552] BUG: KASAN: use-after-free in memcmp+0x4c/0x98
[ 3374.999590] Read of size 1 at addr ffff00036129ea55 by task ksoftirqd/1/15
[ 3375.016415] CPU: 1 PID: 15 Comm: ksoftirqd/1 Tainted: G           O      5.4.31+ #1
[ 3375.055301] Call trace:
[ 3375.060214]  dump_backtrace+0x0/0x238
[ 3375.067580]  show_stack+0x24/0x30
[ 3375.074244]  dump_stack+0xe0/0x118
[ 3375.081085]  print_address_description.isra.9+0x74/0x3d0
[ 3375.091771]  __kasan_report+0x198/0x1e8
[ 3375.099486]  kasan_report+0xc/0x18
[ 3375.106324]  __asan_load1+0x60/0x68
[ 3375.113338]  memcmp+0x4c/0x98
[ 3375.119409]  mlx5e_tc_ct_restore_flow+0x3a4/0x6f8 [mlx5_core]
[ 3375.131073]  mlx5e_rep_tc_update_skb+0x1d4/0x2f0 [mlx5_core]
[ 3375.142553]  mlx5e_handle_rx_cqe_rep+0x198/0x308 [mlx5_core]
[ 3375.154034]  mlx5e_poll_rx_cq+0x2a0/0x1060 [mlx5_core]
[ 3375.164459]  mlx5e_napi_poll+0x1d4/0xa78 [mlx5_core]
[ 3375.174453]  net_rx_action+0x28c/0x7a8
[ 3375.182004]  __do_softirq+0x1b4/0x5d0

Manage the lifetime of the ct entry object by using synchornization
mechanisms for concurrent access.

Fixes: ac991b48d43c ("net/mlx5e: CT: Offload established flows")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 259 +++++++++++++-----
 1 file changed, 192 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 6bc6b48a56dc..24e2c0d955b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -12,6 +12,7 @@
 #include <net/flow_offload.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <linux/workqueue.h>
+#include <linux/refcount.h>
 #include <linux/xarray.h>
 
 #include "lib/fs_chains.h"
@@ -51,11 +52,11 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_flow_table *ct_nat;
 	struct mlx5_flow_table *post_ct;
 	struct mutex control_lock; /* guards parallel adds/dels */
-	struct mutex shared_counter_lock;
 	struct mapping_ctx *zone_mapping;
 	struct mapping_ctx *labels_mapping;
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5_fs_chains *chains;
+	spinlock_t ht_lock; /* protects ft entries */
 };
 
 struct mlx5_ct_flow {
@@ -124,6 +125,10 @@ struct mlx5_ct_counter {
 	bool is_shared;
 };
 
+enum {
+	MLX5_CT_ENTRY_FLAG_VALID,
+};
+
 struct mlx5_ct_entry {
 	struct rhash_head node;
 	struct rhash_head tuple_node;
@@ -134,6 +139,12 @@ struct mlx5_ct_entry {
 	struct mlx5_ct_tuple tuple;
 	struct mlx5_ct_tuple tuple_nat;
 	struct mlx5_ct_zone_rule zone_rules[2];
+
+	struct mlx5_tc_ct_priv *ct_priv;
+	struct work_struct work;
+
+	refcount_t refcnt;
+	unsigned long flags;
 };
 
 static const struct rhashtable_params cts_ht_params = {
@@ -740,6 +751,87 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	return err;
 }
 
+static bool
+mlx5_tc_ct_entry_valid(struct mlx5_ct_entry *entry)
+{
+	return test_bit(MLX5_CT_ENTRY_FLAG_VALID, &entry->flags);
+}
+
+static struct mlx5_ct_entry *
+mlx5_tc_ct_entry_get(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_tuple *tuple)
+{
+	struct mlx5_ct_entry *entry;
+
+	entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_ht, tuple,
+				       tuples_ht_params);
+	if (entry && mlx5_tc_ct_entry_valid(entry) &&
+	    refcount_inc_not_zero(&entry->refcnt)) {
+		return entry;
+	} else if (!entry) {
+		entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_nat_ht,
+					       tuple, tuples_nat_ht_params);
+		if (entry && mlx5_tc_ct_entry_valid(entry) &&
+		    refcount_inc_not_zero(&entry->refcnt))
+			return entry;
+	}
+
+	return entry ? ERR_PTR(-EINVAL) : NULL;
+}
+
+static void mlx5_tc_ct_entry_remove_from_tuples(struct mlx5_ct_entry *entry)
+{
+	struct mlx5_tc_ct_priv *ct_priv = entry->ct_priv;
+
+	rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
+			       &entry->tuple_nat_node,
+			       tuples_nat_ht_params);
+	rhashtable_remove_fast(&ct_priv->ct_tuples_ht, &entry->tuple_node,
+			       tuples_ht_params);
+}
+
+static void mlx5_tc_ct_entry_del(struct mlx5_ct_entry *entry)
+{
+	struct mlx5_tc_ct_priv *ct_priv = entry->ct_priv;
+
+	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
+
+	spin_lock_bh(&ct_priv->ht_lock);
+	mlx5_tc_ct_entry_remove_from_tuples(entry);
+	spin_unlock_bh(&ct_priv->ht_lock);
+
+	mlx5_tc_ct_counter_put(ct_priv, entry);
+	kfree(entry);
+}
+
+static void
+mlx5_tc_ct_entry_put(struct mlx5_ct_entry *entry)
+{
+	if (!refcount_dec_and_test(&entry->refcnt))
+		return;
+
+	mlx5_tc_ct_entry_del(entry);
+}
+
+static void mlx5_tc_ct_entry_del_work(struct work_struct *work)
+{
+	struct mlx5_ct_entry *entry = container_of(work, struct mlx5_ct_entry, work);
+
+	mlx5_tc_ct_entry_del(entry);
+}
+
+static void
+__mlx5_tc_ct_entry_put(struct mlx5_ct_entry *entry)
+{
+	struct mlx5e_priv *priv;
+
+	if (!refcount_dec_and_test(&entry->refcnt))
+		return;
+
+	priv = netdev_priv(entry->ct_priv->netdev);
+	INIT_WORK(&entry->work, mlx5_tc_ct_entry_del_work);
+	queue_work(priv->wq, &entry->work);
+}
+
 static struct mlx5_ct_counter *
 mlx5_tc_ct_counter_create(struct mlx5_tc_ct_priv *ct_priv)
 {
@@ -792,16 +884,26 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	}
 
 	/* Use the same counter as the reverse direction */
-	mutex_lock(&ct_priv->shared_counter_lock);
-	rev_entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_ht, &rev_tuple,
-					   tuples_ht_params);
-	if (rev_entry) {
-		if (refcount_inc_not_zero(&rev_entry->counter->refcount)) {
-			mutex_unlock(&ct_priv->shared_counter_lock);
-			return rev_entry->counter;
-		}
+	spin_lock_bh(&ct_priv->ht_lock);
+	rev_entry = mlx5_tc_ct_entry_get(ct_priv, &rev_tuple);
+
+	if (IS_ERR(rev_entry)) {
+		spin_unlock_bh(&ct_priv->ht_lock);
+		goto create_counter;
+	}
+
+	if (rev_entry && refcount_inc_not_zero(&rev_entry->counter->refcount)) {
+		ct_dbg("Using shared counter entry=0x%p rev=0x%p\n", entry, rev_entry);
+		shared_counter = rev_entry->counter;
+		spin_unlock_bh(&ct_priv->ht_lock);
+
+		mlx5_tc_ct_entry_put(rev_entry);
+		return shared_counter;
 	}
-	mutex_unlock(&ct_priv->shared_counter_lock);
+
+	spin_unlock_bh(&ct_priv->ht_lock);
+
+create_counter:
 
 	shared_counter = mlx5_tc_ct_counter_create(ct_priv);
 	if (IS_ERR(shared_counter)) {
@@ -866,10 +968,14 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	if (!meta_action)
 		return -EOPNOTSUPP;
 
-	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie,
-				       cts_ht_params);
-	if (entry)
-		return 0;
+	spin_lock_bh(&ct_priv->ht_lock);
+	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
+	if (entry && refcount_inc_not_zero(&entry->refcnt)) {
+		spin_unlock_bh(&ct_priv->ht_lock);
+		mlx5_tc_ct_entry_put(entry);
+		return -EEXIST;
+	}
+	spin_unlock_bh(&ct_priv->ht_lock);
 
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
@@ -878,6 +984,8 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	entry->tuple.zone = ft->zone;
 	entry->cookie = flow->cookie;
 	entry->restore_cookie = meta_action->ct_metadata.cookie;
+	refcount_set(&entry->refcnt, 2);
+	entry->ct_priv = ct_priv;
 
 	err = mlx5_tc_ct_rule_to_tuple(&entry->tuple, flow_rule);
 	if (err)
@@ -888,35 +996,40 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	if (err)
 		goto err_set;
 
-	err = rhashtable_insert_fast(&ct_priv->ct_tuples_ht,
-				     &entry->tuple_node,
-				     tuples_ht_params);
+	spin_lock_bh(&ct_priv->ht_lock);
+
+	err = rhashtable_lookup_insert_fast(&ft->ct_entries_ht, &entry->node,
+					    cts_ht_params);
+	if (err)
+		goto err_entries;
+
+	err = rhashtable_lookup_insert_fast(&ct_priv->ct_tuples_ht,
+					    &entry->tuple_node,
+					    tuples_ht_params);
 	if (err)
 		goto err_tuple;
 
 	if (memcmp(&entry->tuple, &entry->tuple_nat, sizeof(entry->tuple))) {
-		err = rhashtable_insert_fast(&ct_priv->ct_tuples_nat_ht,
-					     &entry->tuple_nat_node,
-					     tuples_nat_ht_params);
+		err = rhashtable_lookup_insert_fast(&ct_priv->ct_tuples_nat_ht,
+						    &entry->tuple_nat_node,
+						    tuples_nat_ht_params);
 		if (err)
 			goto err_tuple_nat;
 	}
+	spin_unlock_bh(&ct_priv->ht_lock);
 
 	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry,
 					 ft->zone_restore_id);
 	if (err)
 		goto err_rules;
 
-	err = rhashtable_insert_fast(&ft->ct_entries_ht, &entry->node,
-				     cts_ht_params);
-	if (err)
-		goto err_insert;
+	set_bit(MLX5_CT_ENTRY_FLAG_VALID, &entry->flags);
+	mlx5_tc_ct_entry_put(entry); /* this function reference */
 
 	return 0;
 
-err_insert:
-	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
 err_rules:
+	spin_lock_bh(&ct_priv->ht_lock);
 	if (mlx5_tc_ct_entry_has_nat(entry))
 		rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
 				       &entry->tuple_nat_node, tuples_nat_ht_params);
@@ -925,47 +1038,43 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 			       &entry->tuple_node,
 			       tuples_ht_params);
 err_tuple:
+	rhashtable_remove_fast(&ft->ct_entries_ht,
+			       &entry->node,
+			       cts_ht_params);
+err_entries:
+	spin_unlock_bh(&ct_priv->ht_lock);
 err_set:
 	kfree(entry);
-	netdev_warn(ct_priv->netdev,
-		    "Failed to offload ct entry, err: %d\n", err);
+	if (err != -EEXIST)
+		netdev_warn(ct_priv->netdev, "Failed to offload ct entry, err: %d\n", err);
 	return err;
 }
 
-static void
-mlx5_tc_ct_del_ft_entry(struct mlx5_tc_ct_priv *ct_priv,
-			struct mlx5_ct_entry *entry)
-{
-	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
-	mutex_lock(&ct_priv->shared_counter_lock);
-	if (mlx5_tc_ct_entry_has_nat(entry))
-		rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
-				       &entry->tuple_nat_node,
-				       tuples_nat_ht_params);
-	rhashtable_remove_fast(&ct_priv->ct_tuples_ht, &entry->tuple_node,
-			       tuples_ht_params);
-	mutex_unlock(&ct_priv->shared_counter_lock);
-	mlx5_tc_ct_counter_put(ct_priv, entry);
-
-}
-
 static int
 mlx5_tc_ct_block_flow_offload_del(struct mlx5_ct_ft *ft,
 				  struct flow_cls_offload *flow)
 {
+	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
 	unsigned long cookie = flow->cookie;
 	struct mlx5_ct_entry *entry;
 
-	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie,
-				       cts_ht_params);
-	if (!entry)
+	spin_lock_bh(&ct_priv->ht_lock);
+	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
+	if (!entry) {
+		spin_unlock_bh(&ct_priv->ht_lock);
 		return -ENOENT;
+	}
 
-	mlx5_tc_ct_del_ft_entry(ft->ct_priv, entry);
-	WARN_ON(rhashtable_remove_fast(&ft->ct_entries_ht,
-				       &entry->node,
-				       cts_ht_params));
-	kfree(entry);
+	if (!mlx5_tc_ct_entry_valid(entry)) {
+		spin_unlock_bh(&ct_priv->ht_lock);
+		return -EINVAL;
+	}
+
+	rhashtable_remove_fast(&ft->ct_entries_ht, &entry->node, cts_ht_params);
+	mlx5_tc_ct_entry_remove_from_tuples(entry);
+	spin_unlock_bh(&ct_priv->ht_lock);
+
+	mlx5_tc_ct_entry_put(entry);
 
 	return 0;
 }
@@ -974,19 +1083,30 @@ static int
 mlx5_tc_ct_block_flow_offload_stats(struct mlx5_ct_ft *ft,
 				    struct flow_cls_offload *f)
 {
+	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
 	unsigned long cookie = f->cookie;
 	struct mlx5_ct_entry *entry;
 	u64 lastuse, packets, bytes;
 
-	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie,
-				       cts_ht_params);
-	if (!entry)
+	spin_lock_bh(&ct_priv->ht_lock);
+	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
+	if (!entry) {
+		spin_unlock_bh(&ct_priv->ht_lock);
 		return -ENOENT;
+	}
+
+	if (!mlx5_tc_ct_entry_valid(entry) || !refcount_inc_not_zero(&entry->refcnt)) {
+		spin_unlock_bh(&ct_priv->ht_lock);
+		return -EINVAL;
+	}
+
+	spin_unlock_bh(&ct_priv->ht_lock);
 
 	mlx5_fc_query_cached(entry->counter->counter, &bytes, &packets, &lastuse);
 	flow_stats_update(&f->stats, bytes, packets, 0, lastuse,
 			  FLOW_ACTION_HW_STATS_DELAYED);
 
+	mlx5_tc_ct_entry_put(entry);
 	return 0;
 }
 
@@ -1478,11 +1598,9 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 static void
 mlx5_tc_ct_flush_ft_entry(void *ptr, void *arg)
 {
-	struct mlx5_tc_ct_priv *ct_priv = arg;
 	struct mlx5_ct_entry *entry = ptr;
 
-	mlx5_tc_ct_del_ft_entry(ct_priv, entry);
-	kfree(entry);
+	mlx5_tc_ct_entry_put(entry);
 }
 
 static void
@@ -1960,6 +2078,7 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 		goto err_mapping_labels;
 	}
 
+	spin_lock_init(&ct_priv->ht_lock);
 	ct_priv->ns_type = ns_type;
 	ct_priv->chains = chains;
 	ct_priv->netdev = priv->netdev;
@@ -1994,7 +2113,6 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 
 	idr_init(&ct_priv->fte_ids);
 	mutex_init(&ct_priv->control_lock);
-	mutex_init(&ct_priv->shared_counter_lock);
 	rhashtable_init(&ct_priv->zone_ht, &zone_params);
 	rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params);
 	rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params);
@@ -2037,7 +2155,6 @@ mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
 	rhashtable_destroy(&ct_priv->zone_ht);
 	mutex_destroy(&ct_priv->control_lock);
-	mutex_destroy(&ct_priv->shared_counter_lock);
 	idr_destroy(&ct_priv->fte_ids);
 	kfree(ct_priv);
 }
@@ -2059,14 +2176,22 @@ mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 	if (!mlx5_tc_ct_skb_to_tuple(skb, &tuple, zone))
 		return false;
 
-	entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_ht, &tuple,
-				       tuples_ht_params);
-	if (!entry)
-		entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_nat_ht,
-					       &tuple, tuples_nat_ht_params);
-	if (!entry)
+	spin_lock(&ct_priv->ht_lock);
+
+	entry = mlx5_tc_ct_entry_get(ct_priv, &tuple);
+	if (!entry) {
+		spin_unlock(&ct_priv->ht_lock);
+		return false;
+	}
+
+	if (IS_ERR(entry)) {
+		spin_unlock(&ct_priv->ht_lock);
 		return false;
+	}
+	spin_unlock(&ct_priv->ht_lock);
 
 	tcf_ct_flow_table_restore_skb(skb, entry->restore_cookie);
+	__mlx5_tc_ct_entry_put(entry);
+
 	return true;
 }
-- 
2.29.2

