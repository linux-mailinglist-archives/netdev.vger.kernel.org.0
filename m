Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE74427642C
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgIWWtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbgIWWsn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 18:48:43 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF907238D7;
        Wed, 23 Sep 2020 22:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600901322;
        bh=EEU9ZARjOL75i5S/CFW09+HXgQvDmBrWHCHu0ocSO2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwcBul2JIXVFmHtSRk4SY4ehHE7BtmD/+WeZ5uokD7/MVtiSKXbN0arTXui3S29Cx
         SFJYe0WwukAaMQBmGIpHT2I/Gun9BTWv2QxNpEhMJskyAN4/iw6xj68MZsPRLZbKt1
         wn6Gl3k0q/OenaD6Q5vRj+ovYRcoNEEi+t3FJ/NA=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Oz Shlomo <ozsh@mellanox.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 09/15] net/mlx5e: CT: Use the same counter for both directions
Date:   Wed, 23 Sep 2020 15:48:18 -0700
Message-Id: <20200923224824.67340-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923224824.67340-1-saeed@kernel.org>
References: <20200923224824.67340-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@mellanox.com>

A connection is represented by two 5-tuple entries, one for each direction.
Currently, each direction allocates its own hw counter, which is
inefficient as ct aging is managed per connection.

Share the counter that was allocated for the original direction with the
reverse direction.

Signed-off-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 94 +++++++++++++++++--
 1 file changed, 85 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 86afef459dc6..9a7bd681f8fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -51,6 +51,7 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_flow_table *ct_nat;
 	struct mlx5_flow_table *post_ct;
 	struct mutex control_lock; /* guards parallel adds/dels */
+	struct mutex shared_counter_lock;
 	struct mapping_ctx *zone_mapping;
 	struct mapping_ctx *labels_mapping;
 	enum mlx5_flow_namespace_type ns_type;
@@ -117,11 +118,16 @@ struct mlx5_ct_tuple {
 	u16 zone;
 };
 
+struct mlx5_ct_shared_counter {
+	struct mlx5_fc *counter;
+	refcount_t refcount;
+};
+
 struct mlx5_ct_entry {
 	struct rhash_head node;
 	struct rhash_head tuple_node;
 	struct rhash_head tuple_nat_node;
-	struct mlx5_fc *counter;
+	struct mlx5_ct_shared_counter *shared_counter;
 	unsigned long cookie;
 	unsigned long restore_cookie;
 	struct mlx5_ct_tuple tuple;
@@ -385,6 +391,16 @@ mlx5_tc_ct_set_tuple_match(struct mlx5e_priv *priv, struct mlx5_flow_spec *spec,
 	return 0;
 }
 
+static void
+mlx5_tc_ct_shared_counter_put(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_entry *entry)
+{
+	if (!refcount_dec_and_test(&entry->shared_counter->refcount))
+		return;
+
+	mlx5_fc_destroy(ct_priv->esw->dev, entry->shared_counter->counter);
+	kfree(entry->shared_counter);
+}
+
 static void
 mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 			  struct mlx5_ct_entry *entry,
@@ -409,7 +425,6 @@ mlx5_tc_ct_entry_del_rules(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_tc_ct_entry_del_rule(ct_priv, entry, true);
 	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
 
-	mlx5_fc_destroy(ct_priv->esw->dev, entry->counter);
 }
 
 static struct flow_action_entry *
@@ -683,7 +698,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	attr->dest_ft = ct_priv->post_ct;
 	attr->ft = nat ? ct_priv->ct_nat : ct_priv->ct;
 	attr->outer_match_level = MLX5_MATCH_L4;
-	attr->counter = entry->counter;
+	attr->counter = entry->shared_counter->counter;
 	attr->flags |= MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
 
 	mlx5_tc_ct_set_tuple_match(netdev_priv(ct_priv->netdev), spec, flow_rule);
@@ -716,18 +731,73 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	return err;
 }
 
+static struct mlx5_ct_shared_counter *
+mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
+			      struct mlx5_ct_entry *entry)
+{
+	struct mlx5_ct_tuple rev_tuple = entry->tuple;
+	struct mlx5_ct_shared_counter *shared_counter;
+	struct mlx5_eswitch *esw = ct_priv->esw;
+	struct mlx5_ct_entry *rev_entry;
+	__be16 tmp_port;
+
+	/* get the reversed tuple */
+	tmp_port = rev_tuple.port.src;
+	rev_tuple.port.src = rev_tuple.port.dst;
+	rev_tuple.port.dst = tmp_port;
+
+	if (rev_tuple.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		__be32 tmp_addr = rev_tuple.ip.src_v4;
+
+		rev_tuple.ip.src_v4 = rev_tuple.ip.dst_v4;
+		rev_tuple.ip.dst_v4 = tmp_addr;
+	} else if (rev_tuple.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		struct in6_addr tmp_addr = rev_tuple.ip.src_v6;
+
+		rev_tuple.ip.src_v6 = rev_tuple.ip.dst_v6;
+		rev_tuple.ip.dst_v6 = tmp_addr;
+	} else {
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	/* Use the same counter as the reverse direction */
+	mutex_lock(&ct_priv->shared_counter_lock);
+	rev_entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_ht, &rev_tuple,
+					   tuples_ht_params);
+	if (rev_entry) {
+		if (refcount_inc_not_zero(&rev_entry->shared_counter->refcount)) {
+			mutex_unlock(&ct_priv->shared_counter_lock);
+			return rev_entry->shared_counter;
+		}
+	}
+	mutex_unlock(&ct_priv->shared_counter_lock);
+
+	shared_counter = kzalloc(sizeof(*shared_counter), GFP_KERNEL);
+	if (!shared_counter)
+		return ERR_PTR(-ENOMEM);
+
+	shared_counter->counter = mlx5_fc_create(esw->dev, true);
+	if (IS_ERR(shared_counter->counter)) {
+		ct_dbg("Failed to create counter for ct entry");
+		kfree(shared_counter);
+		return ERR_PTR(PTR_ERR(shared_counter->counter));
+	}
+
+	refcount_set(&shared_counter->refcount, 1);
+	return shared_counter;
+}
+
 static int
 mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
 			   struct flow_rule *flow_rule,
 			   struct mlx5_ct_entry *entry,
 			   u8 zone_restore_id)
 {
-	struct mlx5_eswitch *esw = ct_priv->esw;
 	int err;
 
-	entry->counter = mlx5_fc_create(esw->dev, true);
-	if (IS_ERR(entry->counter)) {
-		err = PTR_ERR(entry->counter);
+	entry->shared_counter = mlx5_tc_ct_shared_counter_get(ct_priv, entry);
+	if (IS_ERR(entry->shared_counter)) {
+		err = PTR_ERR(entry->shared_counter);
 		ct_dbg("Failed to create counter for ct entry");
 		return err;
 	}
@@ -747,7 +817,7 @@ mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
 err_nat:
 	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
 err_orig:
-	mlx5_fc_destroy(esw->dev, entry->counter);
+	mlx5_tc_ct_shared_counter_put(ct_priv, entry);
 	return err;
 }
 
@@ -837,12 +907,16 @@ mlx5_tc_ct_del_ft_entry(struct mlx5_tc_ct_priv *ct_priv,
 			struct mlx5_ct_entry *entry)
 {
 	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
+	mutex_lock(&ct_priv->shared_counter_lock);
 	if (entry->tuple_node.next)
 		rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
 				       &entry->tuple_nat_node,
 				       tuples_nat_ht_params);
 	rhashtable_remove_fast(&ct_priv->ct_tuples_ht, &entry->tuple_node,
 			       tuples_ht_params);
+	mutex_unlock(&ct_priv->shared_counter_lock);
+	mlx5_tc_ct_shared_counter_put(ct_priv, entry);
+
 }
 
 static int
@@ -879,7 +953,7 @@ mlx5_tc_ct_block_flow_offload_stats(struct mlx5_ct_ft *ft,
 	if (!entry)
 		return -ENOENT;
 
-	mlx5_fc_query_cached(entry->counter, &bytes, &packets, &lastuse);
+	mlx5_fc_query_cached(entry->shared_counter->counter, &bytes, &packets, &lastuse);
 	flow_stats_update(&f->stats, bytes, packets, 0, lastuse,
 			  FLOW_ACTION_HW_STATS_DELAYED);
 
@@ -1892,6 +1966,7 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 
 	idr_init(&ct_priv->fte_ids);
 	mutex_init(&ct_priv->control_lock);
+	mutex_init(&ct_priv->shared_counter_lock);
 	rhashtable_init(&ct_priv->zone_ht, &zone_params);
 	rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params);
 	rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params);
@@ -1934,6 +2009,7 @@ mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
 	rhashtable_destroy(&ct_priv->zone_ht);
 	mutex_destroy(&ct_priv->control_lock);
+	mutex_destroy(&ct_priv->shared_counter_lock);
 	idr_destroy(&ct_priv->fte_ids);
 	kfree(ct_priv);
 }
-- 
2.26.2

