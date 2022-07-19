Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025DD57A84E
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbiGSUfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239310AbiGSUfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE9825C5B
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02CEA6196F
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D85C341C6;
        Tue, 19 Jul 2022 20:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262938;
        bh=n0Zjc1auJ1VNXnnCG2dIbCz1U+DR5dDwc6tglA5AUPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uleQ7MWJ/cumiK7BE840tkCOTar6Tsz1wiJARHgo6+43DwLGenSz13Wan45p7o+p2
         FULeAQ042UWVRuuPIMC0DcnPSL0V8hJ8qgtdI8I1TZAGw2POmq7CZ+AYNgLuo7Ldff
         h+Cmge3cjwFyJAZy3GL55x1D1tFY3qkxKiK5dDJ+ypDsknfr2iAbZmTO9Aer5+5MWL
         y7kgR3CQop8bdHx6n0KOr4D2MQJQkQ11yYvwLQFiP22kOAURXM/0ut7IoHaWXb4yfk
         liZ+K3XrddiApnaMFwHPal4U9vmEOxXS3QZPcgUtOuBUjN9icWQ8WzyGocXXTiJhvy
         g9oj1PtK5m0Iw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next V2 04/13] net/mlx5e: HTB, move ids to selq_params struct
Date:   Tue, 19 Jul 2022 13:35:20 -0700
Message-Id: <20220719203529.51151-5-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719203529.51151-1-saeed@kernel.org>
References: <20220719203529.51151-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

HTB id fields are needed for selecting queue. Moving them to the
selq_params struct will simplify synchronization between control flow
and mlx5e_select_queues and will keep the IDs in the hot cacheline of
mlx5e_selq_params.

Replace mlx5e_selq_prepare() with separate functions that change subsets
of parameters, while keeping the rest.

This also will be useful to hide mlx5e_htb structure from the rest of the
driver in a later patch in this series.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 -
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 23 +++------
 .../net/ethernet/mellanox/mlx5/core/en/selq.c | 48 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en/selq.h |  4 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 15 +++---
 6 files changed, 62 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 5c88c3896b96..1222156e222b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -904,8 +904,6 @@ struct mlx5e_htb {
 	DECLARE_BITMAP(qos_used_qids, MLX5E_QOS_MAX_LEAF_NODES);
 	struct mlx5e_sq_stats **qos_sq_stats;
 	u16 max_qos_sqs;
-	u16 maj_id;
-	u16 defcls;
 };
 
 struct mlx5e_trap;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index c37f346b5a3b..75df55850954 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -144,9 +144,9 @@ static void mlx5e_sw_node_delete(struct mlx5e_priv *priv, struct mlx5e_qos_node
 static u16 mlx5e_qid_from_qos(struct mlx5e_channels *chs, u16 qid)
 {
 	/* These channel params are safe to access from the datapath, because:
-	 * 1. This function is called only after checking priv->htb.maj_id != 0,
+	 * 1. This function is called only after checking selq->htb_maj_id != 0,
 	 *    and the number of queues can't change while HTB offload is active.
-	 * 2. When priv->htb.maj_id becomes 0, synchronize_rcu waits for
+	 * 2. When selq->htb_maj_id becomes 0, synchronize_rcu waits for
 	 *    mlx5e_select_queue to finish while holding priv->state_lock,
 	 *    preventing other code from changing the number of queues.
 	 */
@@ -417,7 +417,7 @@ int mlx5e_qos_open_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
 	struct mlx5e_qos_node *node = NULL;
 	int bkt, err;
 
-	if (!priv->htb.maj_id)
+	if (!mlx5e_selq_is_htb_enabled(&priv->selq))
 		return 0;
 
 	err = mlx5e_qos_alloc_queues(priv, chs);
@@ -501,10 +501,10 @@ mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
 		return -EOPNOTSUPP;
 	}
 
+	mlx5e_selq_prepare_htb(&priv->selq, htb_maj_id, htb_defcls);
+
 	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
 	if (opened) {
-		mlx5e_selq_prepare(&priv->selq, &priv->channels.params, true);
-
 		err = mlx5e_qos_alloc_queues(priv, &priv->channels);
 		if (err)
 			goto err_cancel_selq;
@@ -522,14 +522,7 @@ mlx5e_htb_root_add(struct mlx5e_priv *priv, u16 htb_maj_id, u16 htb_defcls,
 		goto err_sw_node_delete;
 	}
 
-	WRITE_ONCE(priv->htb.defcls, htb_defcls);
-	/* Order maj_id after defcls - pairs with
-	 * mlx5e_select_queue/mlx5e_select_htb_queues.
-	 */
-	smp_store_release(&priv->htb.maj_id, htb_maj_id);
-
-	if (opened)
-		mlx5e_selq_apply(&priv->selq);
+	mlx5e_selq_apply(&priv->selq);
 
 	return 0;
 
@@ -556,11 +549,9 @@ static int mlx5e_htb_root_del(struct mlx5e_priv *priv)
 	 */
 	synchronize_net();
 
-	mlx5e_selq_prepare(&priv->selq, &priv->channels.params, false);
+	mlx5e_selq_prepare_htb(&priv->selq, 0, 0);
 	mlx5e_selq_apply(&priv->selq);
 
-	WRITE_ONCE(priv->htb.maj_id, 0);
-
 	root = mlx5e_sw_node_find(priv, MLX5E_HTB_CLASSID_ROOT);
 	if (!root) {
 		qos_err(priv->mdev, "Failed to find the root node in the QoS tree\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index d98a277eb7f8..0e1d84ef82b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -19,6 +19,8 @@ struct mlx5e_selq_params {
 			bool is_ptp : 1;
 		};
 	};
+	u16 htb_maj_id;
+	u16 htb_defcls;
 };
 
 int mlx5e_selq_init(struct mlx5e_selq *selq, struct mutex *state_lock)
@@ -44,6 +46,8 @@ int mlx5e_selq_init(struct mlx5e_selq *selq, struct mutex *state_lock)
 		.num_tcs = 1,
 		.is_htb = false,
 		.is_ptp = false,
+		.htb_maj_id = 0,
+		.htb_defcls = 0,
 	};
 	rcu_assign_pointer(selq->active, init_params);
 
@@ -64,21 +68,50 @@ void mlx5e_selq_cleanup(struct mlx5e_selq *selq)
 	selq->standby = NULL;
 }
 
-void mlx5e_selq_prepare(struct mlx5e_selq *selq, struct mlx5e_params *params, bool htb)
+void mlx5e_selq_prepare_params(struct mlx5e_selq *selq, struct mlx5e_params *params)
 {
+	struct mlx5e_selq_params *selq_active;
+
 	lockdep_assert_held(selq->state_lock);
 	WARN_ON_ONCE(selq->is_prepared);
 
 	selq->is_prepared = true;
 
+	selq_active = rcu_dereference_protected(selq->active,
+						lockdep_is_held(selq->state_lock));
+	*selq->standby = *selq_active;
 	selq->standby->num_channels = params->num_channels;
 	selq->standby->num_tcs = mlx5e_get_dcb_num_tc(params);
 	selq->standby->num_regular_queues =
 		selq->standby->num_channels * selq->standby->num_tcs;
-	selq->standby->is_htb = htb;
 	selq->standby->is_ptp = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_TX_PORT_TS);
 }
 
+bool mlx5e_selq_is_htb_enabled(struct mlx5e_selq *selq)
+{
+	struct mlx5e_selq_params *selq_active =
+		rcu_dereference_protected(selq->active, lockdep_is_held(selq->state_lock));
+
+	return selq_active->htb_maj_id;
+}
+
+void mlx5e_selq_prepare_htb(struct mlx5e_selq *selq, u16 htb_maj_id, u16 htb_defcls)
+{
+	struct mlx5e_selq_params *selq_active;
+
+	lockdep_assert_held(selq->state_lock);
+	WARN_ON_ONCE(selq->is_prepared);
+
+	selq->is_prepared = true;
+
+	selq_active = rcu_dereference_protected(selq->active,
+						lockdep_is_held(selq->state_lock));
+	*selq->standby = *selq_active;
+	selq->standby->is_htb = htb_maj_id;
+	selq->standby->htb_maj_id = htb_maj_id;
+	selq->standby->htb_defcls = htb_defcls;
+}
+
 void mlx5e_selq_apply(struct mlx5e_selq *selq)
 {
 	struct mlx5e_selq_params *old_params;
@@ -137,15 +170,16 @@ static u16 mlx5e_select_ptpsq(struct net_device *dev, struct sk_buff *skb,
 	return selq->num_regular_queues + up;
 }
 
-static int mlx5e_select_htb_queue(struct mlx5e_priv *priv, struct sk_buff *skb)
+static int mlx5e_select_htb_queue(struct mlx5e_priv *priv, struct sk_buff *skb,
+				  struct mlx5e_selq_params *selq)
 {
 	u16 classid;
 
 	/* Order maj_id before defcls - pairs with mlx5e_htb_root_add. */
-	if ((TC_H_MAJ(skb->priority) >> 16) == smp_load_acquire(&priv->htb.maj_id))
+	if ((TC_H_MAJ(skb->priority) >> 16) == selq->htb_maj_id)
 		classid = TC_H_MIN(skb->priority);
 	else
-		classid = READ_ONCE(priv->htb.defcls);
+		classid = selq->htb_defcls;
 
 	if (!classid)
 		return 0;
@@ -187,10 +221,10 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 			up * selq->num_channels;
 	}
 
-	if (unlikely(selq->is_htb)) {
+	if (unlikely(selq->htb_maj_id)) {
 		/* num_tcs == 1, shortcut for PTP */
 
-		txq_ix = mlx5e_select_htb_queue(priv, skb);
+		txq_ix = mlx5e_select_htb_queue(priv, skb, selq);
 		if (txq_ix > 0)
 			return txq_ix;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
index 6c070141d8f1..fd590f80e4d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
@@ -21,7 +21,9 @@ struct sk_buff;
 
 int mlx5e_selq_init(struct mlx5e_selq *selq, struct mutex *state_lock);
 void mlx5e_selq_cleanup(struct mlx5e_selq *selq);
-void mlx5e_selq_prepare(struct mlx5e_selq *selq, struct mlx5e_params *params, bool htb);
+void mlx5e_selq_prepare_params(struct mlx5e_selq *selq, struct mlx5e_params *params);
+void mlx5e_selq_prepare_htb(struct mlx5e_selq *selq, u16 htb_maj_id, u16 htb_defcls);
+bool mlx5e_selq_is_htb_enabled(struct mlx5e_selq *selq);
 void mlx5e_selq_apply(struct mlx5e_selq *selq);
 void mlx5e_selq_cancel(struct mlx5e_selq *selq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 820912eb7bcf..b811207fe5ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -459,7 +459,7 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 	 * because the numeration of the QoS SQs will change, while per-queue
 	 * qdiscs are attached.
 	 */
-	if (priv->htb.maj_id) {
+	if (mlx5e_selq_is_htb_enabled(&priv->selq)) {
 		err = -EINVAL;
 		netdev_err(priv->netdev, "%s: HTB offload is active, cannot change the number of channels\n",
 			   __func__);
@@ -2075,7 +2075,7 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 	 * the numeration of the QoS SQs will change, while per-queue qdiscs are
 	 * attached.
 	 */
-	if (priv->htb.maj_id) {
+	if (mlx5e_selq_is_htb_enabled(&priv->selq)) {
 		netdev_err(priv->netdev, "%s: HTB offload is active, cannot change the PTP state\n",
 			   __func__);
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d4b39351a223..700bca033769 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2839,7 +2839,7 @@ int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
 
 	new_chs.params = *params;
 
-	mlx5e_selq_prepare(&priv->selq, &new_chs.params, !!priv->htb.maj_id);
+	mlx5e_selq_prepare_params(&priv->selq, &new_chs.params);
 
 	err = mlx5e_open_channels(priv, &new_chs);
 	if (err)
@@ -2895,7 +2895,7 @@ int mlx5e_open_locked(struct net_device *netdev)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	int err;
 
-	mlx5e_selq_prepare(&priv->selq, &priv->channels.params, !!priv->htb.maj_id);
+	mlx5e_selq_prepare_params(&priv->selq, &priv->channels.params);
 
 	set_bit(MLX5E_STATE_OPENED, &priv->state);
 
@@ -3406,7 +3406,7 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 	/* MQPRIO is another toplevel qdisc that can't be attached
 	 * simultaneously with the offloaded HTB.
 	 */
-	if (WARN_ON(priv->htb.maj_id))
+	if (WARN_ON(mlx5e_selq_is_htb_enabled(&priv->selq)))
 		return -EINVAL;
 
 	switch (mqprio->mode) {
@@ -3672,6 +3672,7 @@ static int set_feature_cvlan_filter(struct net_device *netdev, bool enable)
 static int set_feature_hw_tc(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	int err = 0;
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	if (!enable && mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD))) {
@@ -3681,12 +3682,14 @@ static int set_feature_hw_tc(struct net_device *netdev, bool enable)
 	}
 #endif
 
-	if (!enable && priv->htb.maj_id) {
+	mutex_lock(&priv->state_lock);
+	if (!enable && mlx5e_selq_is_htb_enabled(&priv->selq)) {
 		netdev_err(netdev, "Active HTB offload, can't turn hw_tc_offload off\n");
-		return -EINVAL;
+		err = -EINVAL;
 	}
+	mutex_unlock(&priv->state_lock);
 
-	return 0;
+	return err;
 }
 
 static int set_feature_rx_all(struct net_device *netdev, bool enable)
-- 
2.36.1

