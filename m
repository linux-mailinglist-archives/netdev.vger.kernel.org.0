Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4114577858
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 23:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiGQVf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 17:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiGQVfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 17:35:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27DD10FC9
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 14:35:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 502D2CE1141
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 21:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AF9C341C0;
        Sun, 17 Jul 2022 21:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658093749;
        bh=Za08jaWNDGRSdIv36f6br2cdWiPgpLBNk+exXUrsy9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXDBIl86BsjMW1FtO+zARaH7phouDi2R8QI5cbgtMY1WlnNabN3dqPki4A1US7IXV
         9bMpRPxbiqT/4LPNq4wWyGTDdj1K/lC2pr6s96GEVJEY72cWiVfFV+bnIITt/+hmlU
         qg5l12dNegYX/8nAezcinoMY9oUQmAbQZH8lt0HJqhWSix/VbO18rEk3oJkHQyGOWQ
         k9WPyFkVV1vH+zkzH9wsFi/5YgJVpdkBPGH3jBS6wcILX2hzqUbskaCA4C07nD2p2u
         DX0nXfymVJOjQsU/bl9UzWhobSMPuf6vsA7LghnnwYWPA1mVCk/BF6zMUjd3RnkBJk
         AwACJJs5EfvWw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 08/14] net/mlx5e: HTB, hide and dynamically allocate mlx5e_htb structure
Date:   Sun, 17 Jul 2022 14:33:46 -0700
Message-Id: <20220717213352.89838-9-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220717213352.89838-1-saeed@kernel.org>
References: <20220717213352.89838-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Move structure mlx5e_htb from the main driver include file "en.h" to be
hidden in qos.c where the qos functionality is implemented, forward
declare it for the rest of the driver and allocate it dynamically upon
user demand only.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  8 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 87 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 +-
 3 files changed, 70 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d2ed27575097..b07228f69b91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -899,12 +899,8 @@ struct mlx5e_scratchpad {
 	cpumask_var_t cpumask;
 };
 
-struct mlx5e_htb {
-	DECLARE_HASHTABLE(qos_tc2node, order_base_2(MLX5E_QOS_MAX_LEAF_NODES));
-	DECLARE_BITMAP(qos_used_qids, MLX5E_QOS_MAX_LEAF_NODES);
-};
-
 struct mlx5e_trap;
+struct mlx5e_htb;
 
 struct mlx5e_priv {
 	/* priv data path fields - start */
@@ -975,7 +971,7 @@ struct mlx5e_priv {
 	struct mlx5e_hv_vhca_stats_agent stats_agent;
 #endif
 	struct mlx5e_scratchpad    scratchpad;
-	struct mlx5e_htb           htb;
+	struct mlx5e_htb          *htb;
 	struct mlx5e_mqprio_rl    *mqprio_rl;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 6136cad397dd..3848f06ac516 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -9,6 +9,11 @@
 
 #define BYTES_IN_MBIT 125000
 
+struct mlx5e_htb {
+	DECLARE_HASHTABLE(qos_tc2node, order_base_2(MLX5E_QOS_MAX_LEAF_NODES));
+	DECLARE_BITMAP(qos_used_qids, MLX5E_QOS_MAX_LEAF_NODES);
+};
+
 int mlx5e_qos_bytes_rate_check(struct mlx5_core_dev *mdev, u64 nbytes)
 {
 	if (nbytes < BYTES_IN_MBIT) {
@@ -31,8 +36,9 @@ int mlx5e_qos_max_leaf_nodes(struct mlx5_core_dev *mdev)
 
 int mlx5e_qos_cur_leaf_nodes(struct mlx5e_priv *priv)
 {
-	int last = find_last_bit(priv->htb.qos_used_qids, mlx5e_qos_max_leaf_nodes(priv->mdev));
+	int last;
 
+	last = find_last_bit(priv->htb->qos_used_qids, mlx5e_qos_max_leaf_nodes(priv->mdev));
 	return last == mlx5e_qos_max_leaf_nodes(priv->mdev) ? 0 : last + 1;
 }
 
@@ -44,7 +50,7 @@ static int mlx5e_find_unused_qos_qid(struct mlx5e_priv *priv)
 	int res;
 
 	WARN_ONCE(!mutex_is_locked(&priv->state_lock), "%s: state_lock is not held\n", __func__);
-	res = find_first_zero_bit(priv->htb.qos_used_qids, size);
+	res = find_first_zero_bit(priv->htb->qos_used_qids, size);
 
 	return res == size ? -ENOSPC : res;
 }
@@ -76,10 +82,10 @@ mlx5e_sw_node_create_leaf(struct mlx5e_priv *priv, u16 classid, u16 qid,
 	node->parent = parent;
 
 	node->qid = qid;
-	__set_bit(qid, priv->htb.qos_used_qids);
+	__set_bit(qid, priv->htb->qos_used_qids);
 
 	node->classid = classid;
-	hash_add_rcu(priv->htb.qos_tc2node, &node->hnode, classid);
+	hash_add_rcu(priv->htb->qos_tc2node, &node->hnode, classid);
 
 	mlx5e_update_tx_netdev_queues(priv);
 
@@ -96,7 +102,7 @@ static struct mlx5e_qos_node *mlx5e_sw_node_create_root(struct mlx5e_priv *priv)
 
 	node->qid = MLX5E_QOS_QID_INNER;
 	node->classid = MLX5E_HTB_CLASSID_ROOT;
-	hash_add_rcu(priv->htb.qos_tc2node, &node->hnode, node->classid);
+	hash_add_rcu(priv->htb->qos_tc2node, &node->hnode, node->classid);
 
 	return node;
 }
@@ -105,7 +111,7 @@ static struct mlx5e_qos_node *mlx5e_sw_node_find(struct mlx5e_priv *priv, u32 cl
 {
 	struct mlx5e_qos_node *node = NULL;
 
-	hash_for_each_possible(priv->htb.qos_tc2node, node, hnode, classid) {
+	hash_for_each_possible(priv->htb->qos_tc2node, node, hnode, classid) {
 		if (node->classid == classid)
 			break;
 	}
@@ -117,7 +123,7 @@ static struct mlx5e_qos_node *mlx5e_sw_node_find_rcu(struct mlx5e_priv *priv, u3
 {
 	struct mlx5e_qos_node *node = NULL;
 
-	hash_for_each_possible_rcu(priv->htb.qos_tc2node, node, hnode, classid) {
+	hash_for_each_possible_rcu(priv->htb->qos_tc2node, node, hnode, classid) {
 		if (node->classid == classid)
 			break;
 	}
@@ -129,7 +135,7 @@ static void mlx5e_sw_node_delete(struct mlx5e_priv *priv, struct mlx5e_qos_node
 {
 	hash_del_rcu(&node->hnode);
 	if (node->qid != MLX5E_QOS_QID_INNER) {
-		__clear_bit(node->qid, priv->htb.qos_used_qids);
+		__clear_bit(node->qid, priv->htb->qos_used_qids);
 		mlx5e_update_tx_netdev_queues(priv);
 	}
 	/* Make sure this qid is no longer selected by mlx5e_select_queue, so
@@ -424,7 +430,7 @@ int mlx5e_qos_open_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
 	if (err)
 		return err;
 
-	hash_for_each(priv->htb.qos_tc2node, bkt, node, hnode) {
+	hash_for_each(priv->htb->qos_tc2node, bkt, node, hnode) {
 		if (node->qid == MLX5E_QOS_QID_INNER)
 			continue;
 		err = mlx5e_open_qos_sq(priv, chs, node);
@@ -442,7 +448,7 @@ void mlx5e_qos_activate_queues(struct mlx5e_priv *priv)
 	struct mlx5e_qos_node *node = NULL;
 	int bkt;
 
-	hash_for_each(priv->htb.qos_tc2node, bkt, node, hnode) {
+	hash_for_each(priv->htb->qos_tc2node, bkt, node, hnode) {
 		if (node->qid == MLX5E_QOS_QID_INNER)
 			continue;
 		mlx5e_activate_qos_sq(priv, node);
@@ -495,12 +501,6 @@ mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
 
 	qos_dbg(priv->mdev, "TC_HTB_CREATE handle %04x:, default :%04x\n", htb_maj_id, htb_defcls);
 
-	if (!mlx5_qos_is_supported(priv->mdev)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Missing QoS capabilities. Try disabling SRIOV or use a supported device.");
-		return -EOPNOTSUPP;
-	}
-
 	mlx5e_selq_prepare_htb(&priv->selq, htb_maj_id, htb_defcls);
 
 	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
@@ -749,7 +749,7 @@ static struct mlx5e_qos_node *mlx5e_sw_node_find_by_qid(struct mlx5e_priv *priv,
 	struct mlx5e_qos_node *node = NULL;
 	int bkt;
 
-	hash_for_each(priv->htb.qos_tc2node, bkt, node, hnode)
+	hash_for_each(priv->htb->qos_tc2node, bkt, node, hnode)
 		if (node->qid == qid)
 			break;
 
@@ -837,7 +837,7 @@ static int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 *classid,
 
 	/* Stop traffic to the old queue. */
 	WRITE_ONCE(node->qid, MLX5E_QOS_QID_INNER);
-	__clear_bit(moved_qid, priv->htb.qos_used_qids);
+	__clear_bit(moved_qid, priv->htb->qos_used_qids);
 
 	if (opened) {
 		txq = netdev_get_tx_queue(priv->netdev,
@@ -849,7 +849,7 @@ static int mlx5e_htb_leaf_del(struct mlx5e_priv *priv, u16 *classid,
 	/* Prevent packets from the old class from getting into the new one. */
 	mlx5e_reset_qdisc(priv->netdev, moved_qid);
 
-	__set_bit(qid, priv->htb.qos_used_qids);
+	__set_bit(qid, priv->htb->qos_used_qids);
 	WRITE_ONCE(node->qid, qid);
 
 	if (test_bit(MLX5E_STATE_OPENED, &priv->state)) {
@@ -960,7 +960,7 @@ mlx5e_qos_update_children(struct mlx5e_priv *priv, struct mlx5e_qos_node *node,
 	int err = 0;
 	int bkt;
 
-	hash_for_each(priv->htb.qos_tc2node, bkt, child, hnode) {
+	hash_for_each(priv->htb->qos_tc2node, bkt, child, hnode) {
 		u32 old_bw_share = child->bw_share;
 		int err_one;
 
@@ -1027,16 +1027,57 @@ mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ceil,
 }
 
 /* HTB API */
+
+static struct mlx5e_htb *mlx5e_htb_alloc(void)
+{
+	return kvzalloc(sizeof(struct mlx5e_htb), GFP_KERNEL);
+}
+
+static void mlx5e_htb_free(struct mlx5e_htb *htb)
+{
+	kvfree(htb);
+}
+
+static int mlx5e_htb_init(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb)
+{
+	hash_init(priv->htb->qos_tc2node);
+
+	return mlx5e_htb_root_add(priv, htb->parent_classid, htb->classid, htb->extack);
+}
+
+static void mlx5e_htb_cleanup(struct mlx5e_priv *priv)
+{
+	mlx5e_htb_root_del(priv);
+}
+
 int mlx5e_htb_setup_tc(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb)
 {
 	int res;
 
+	if (!priv->htb && htb->command != TC_HTB_CREATE)
+		return -EINVAL;
+
 	switch (htb->command) {
 	case TC_HTB_CREATE:
-		return mlx5e_htb_root_add(priv, htb->parent_classid, htb->classid,
-					  htb->extack);
+		if (!mlx5_qos_is_supported(priv->mdev)) {
+			NL_SET_ERR_MSG_MOD(htb->extack,
+					   "Missing QoS capabilities. Try disabling SRIOV or use a supported device.");
+			return -EOPNOTSUPP;
+		}
+		priv->htb = mlx5e_htb_alloc();
+		if (!priv->htb)
+			return -ENOMEM;
+		res = mlx5e_htb_init(priv, htb);
+		if (res) {
+			mlx5e_htb_free(priv->htb);
+			priv->htb = NULL;
+		}
+		return res;
 	case TC_HTB_DESTROY:
-		return mlx5e_htb_root_del(priv);
+		mlx5e_htb_cleanup(priv);
+		mlx5e_htb_free(priv->htb);
+		priv->htb = NULL;
+		return 0;
 	case TC_HTB_LEAF_ALLOC_QUEUE:
 		res = mlx5e_htb_leaf_alloc_queue(priv, htb->classid, htb->parent_classid,
 						 htb->rate, htb->ceil, htb->extack);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fed24b5a0bae..127aaa1c1d19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2572,9 +2572,11 @@ static int mlx5e_netdev_set_tcs(struct net_device *netdev, u16 nch, u8 ntc,
 
 int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv)
 {
-	int qos_queues, nch, ntc, num_txqs, err;
+	int nch, ntc, num_txqs, err;
+	int qos_queues = 0;
 
-	qos_queues = mlx5e_qos_cur_leaf_nodes(priv);
+	if (priv->htb)
+		qos_queues = mlx5e_qos_cur_leaf_nodes(priv);
 
 	nch = priv->channels.params.num_channels;
 	ntc = mlx5e_get_dcb_num_tc(&priv->channels.params);
@@ -5315,7 +5317,6 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free_cpumask;
 
-	hash_init(priv->htb.qos_tc2node);
 	INIT_WORK(&priv->update_carrier_work, mlx5e_update_carrier_work);
 	INIT_WORK(&priv->set_rx_mode_work, mlx5e_set_rx_mode_work);
 	INIT_WORK(&priv->tx_timeout_work, mlx5e_tx_timeout_work);
-- 
2.36.1

