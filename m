Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0242EE6DD
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbhAGU3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:29:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbhAGU3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:29:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 230F523447;
        Thu,  7 Jan 2021 20:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051344;
        bh=6H6Xdu3tsJdaVNry45QyrE1+MYL7Qtg+GVZyYxqK29s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FsRgBrlBsavdEcL8XCvWHggFMnj2xQq/xiONfkPQjq5uFAgNGbt970m8T0Dz6Gn6x
         Z7mdiM363OiDMbCvbvrEuPys2N6v8ievjshxo498XEfp/0VewdrnqBcXU6cckrLl6L
         PY2sXkaTIf0GkgQ3WyLdYQDHtUyaiG9XoV+8jvyrbxyG6nRyEe0J4wLnf/TMNt9LkZ
         /vC0hYKQDFqxFMX3nk6HeU6tWe5fCJLqsk8EsAvsbrWY4Dy9ygy9BRxKRVjFeFtcKQ
         /uV/ufHWAEPFXH7vepZ92s8SL1/DmbNIxiI/GAIZ4Oy24LZFbhCyl7HZztO6g61SU8
         OjzpzaI3/QmZg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/11] net/mlx5e: CT: Use per flow counter when CT flow accounting is enabled
Date:   Thu,  7 Jan 2021 12:28:38 -0800
Message-Id: <20210107202845.470205-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

Connection counters may be shared for both directions when the counter
is used for connection aging purposes. However, if TC flow
accounting is enabled then a unique counter is required per direction.

Instantiate a unique counter per direction if the conntrack accounting
extension is enabled. Use a shared counter when the connection accounting
extension is disabled.

Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 77 ++++++++++++-------
 1 file changed, 49 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index e521254d886e..072363e73f1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -118,16 +118,17 @@ struct mlx5_ct_tuple {
 	u16 zone;
 };
 
-struct mlx5_ct_shared_counter {
+struct mlx5_ct_counter {
 	struct mlx5_fc *counter;
 	refcount_t refcount;
+	bool is_shared;
 };
 
 struct mlx5_ct_entry {
 	struct rhash_head node;
 	struct rhash_head tuple_node;
 	struct rhash_head tuple_nat_node;
-	struct mlx5_ct_shared_counter *shared_counter;
+	struct mlx5_ct_counter *counter;
 	unsigned long cookie;
 	unsigned long restore_cookie;
 	struct mlx5_ct_tuple tuple;
@@ -394,13 +395,14 @@ mlx5_tc_ct_set_tuple_match(struct mlx5e_priv *priv, struct mlx5_flow_spec *spec,
 }
 
 static void
-mlx5_tc_ct_shared_counter_put(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_entry *entry)
+mlx5_tc_ct_counter_put(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_entry *entry)
 {
-	if (!refcount_dec_and_test(&entry->shared_counter->refcount))
+	if (entry->counter->is_shared &&
+	    !refcount_dec_and_test(&entry->counter->refcount))
 		return;
 
-	mlx5_fc_destroy(ct_priv->dev, entry->shared_counter->counter);
-	kfree(entry->shared_counter);
+	mlx5_fc_destroy(ct_priv->dev, entry->counter->counter);
+	kfree(entry->counter);
 }
 
 static void
@@ -699,7 +701,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	attr->dest_ft = ct_priv->post_ct;
 	attr->ft = nat ? ct_priv->ct_nat : ct_priv->ct;
 	attr->outer_match_level = MLX5_MATCH_L4;
-	attr->counter = entry->shared_counter->counter;
+	attr->counter = entry->counter->counter;
 	attr->flags |= MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
 
 	mlx5_tc_ct_set_tuple_match(netdev_priv(ct_priv->netdev), spec, flow_rule);
@@ -732,13 +734,34 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	return err;
 }
 
-static struct mlx5_ct_shared_counter *
+static struct mlx5_ct_counter *
+mlx5_tc_ct_counter_create(struct mlx5_tc_ct_priv *ct_priv)
+{
+	struct mlx5_ct_counter *counter;
+	int ret;
+
+	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
+	if (!counter)
+		return ERR_PTR(-ENOMEM);
+
+	counter->is_shared = false;
+	counter->counter = mlx5_fc_create(ct_priv->dev, true);
+	if (IS_ERR(counter->counter)) {
+		ct_dbg("Failed to create counter for ct entry");
+		ret = PTR_ERR(counter->counter);
+		kfree(counter);
+		return ERR_PTR(ret);
+	}
+
+	return counter;
+}
+
+static struct mlx5_ct_counter *
 mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 			      struct mlx5_ct_entry *entry)
 {
 	struct mlx5_ct_tuple rev_tuple = entry->tuple;
-	struct mlx5_ct_shared_counter *shared_counter;
-	struct mlx5_core_dev *dev = ct_priv->dev;
+	struct mlx5_ct_counter *shared_counter;
 	struct mlx5_ct_entry *rev_entry;
 	__be16 tmp_port;
 	int ret;
@@ -767,25 +790,20 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	rev_entry = rhashtable_lookup_fast(&ct_priv->ct_tuples_ht, &rev_tuple,
 					   tuples_ht_params);
 	if (rev_entry) {
-		if (refcount_inc_not_zero(&rev_entry->shared_counter->refcount)) {
+		if (refcount_inc_not_zero(&rev_entry->counter->refcount)) {
 			mutex_unlock(&ct_priv->shared_counter_lock);
-			return rev_entry->shared_counter;
+			return rev_entry->counter;
 		}
 	}
 	mutex_unlock(&ct_priv->shared_counter_lock);
 
-	shared_counter = kzalloc(sizeof(*shared_counter), GFP_KERNEL);
-	if (!shared_counter)
-		return ERR_PTR(-ENOMEM);
-
-	shared_counter->counter = mlx5_fc_create(dev, true);
-	if (IS_ERR(shared_counter->counter)) {
-		ct_dbg("Failed to create counter for ct entry");
-		ret = PTR_ERR(shared_counter->counter);
-		kfree(shared_counter);
+	shared_counter = mlx5_tc_ct_counter_create(ct_priv);
+	if (IS_ERR(shared_counter)) {
+		ret = PTR_ERR(shared_counter);
 		return ERR_PTR(ret);
 	}
 
+	shared_counter->is_shared = true;
 	refcount_set(&shared_counter->refcount, 1);
 	return shared_counter;
 }
@@ -798,10 +816,13 @@ mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
 {
 	int err;
 
-	entry->shared_counter = mlx5_tc_ct_shared_counter_get(ct_priv, entry);
-	if (IS_ERR(entry->shared_counter)) {
-		err = PTR_ERR(entry->shared_counter);
-		ct_dbg("Failed to create counter for ct entry");
+	if (nf_ct_acct_enabled(dev_net(ct_priv->netdev)))
+		entry->counter = mlx5_tc_ct_counter_create(ct_priv);
+	else
+		entry->counter = mlx5_tc_ct_shared_counter_get(ct_priv, entry);
+
+	if (IS_ERR(entry->counter)) {
+		err = PTR_ERR(entry->counter);
 		return err;
 	}
 
@@ -820,7 +841,7 @@ mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
 err_nat:
 	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
 err_orig:
-	mlx5_tc_ct_shared_counter_put(ct_priv, entry);
+	mlx5_tc_ct_counter_put(ct_priv, entry);
 	return err;
 }
 
@@ -918,7 +939,7 @@ mlx5_tc_ct_del_ft_entry(struct mlx5_tc_ct_priv *ct_priv,
 	rhashtable_remove_fast(&ct_priv->ct_tuples_ht, &entry->tuple_node,
 			       tuples_ht_params);
 	mutex_unlock(&ct_priv->shared_counter_lock);
-	mlx5_tc_ct_shared_counter_put(ct_priv, entry);
+	mlx5_tc_ct_counter_put(ct_priv, entry);
 
 }
 
@@ -956,7 +977,7 @@ mlx5_tc_ct_block_flow_offload_stats(struct mlx5_ct_ft *ft,
 	if (!entry)
 		return -ENOENT;
 
-	mlx5_fc_query_cached(entry->shared_counter->counter, &bytes, &packets, &lastuse);
+	mlx5_fc_query_cached(entry->counter->counter, &bytes, &packets, &lastuse);
 	flow_stats_update(&f->stats, bytes, packets, 0, lastuse,
 			  FLOW_ACTION_HW_STATS_DELAYED);
 
-- 
2.26.2

