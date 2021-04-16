Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4BD362818
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbhDPSzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236350AbhDPSzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345FA613C5;
        Fri, 16 Apr 2021 18:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599284;
        bh=XAO7OuStdEjwV8EVEykog9HwSGkGonQVrCVNr0t6nJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tA4A90XsxNM60Sp8dSnECcRzisr84Lr2CYS3cvcd0wXriQjTJvPzdMcg39lY0DQ0V
         K6ET0cLEdK9DugrEfk3+Zxw7AEKW5FTMAwRNyW5uhqQV+tkdkDiBiHoceaoScQSIN4
         pTDAQSfRyX/YELacDfsuWHIIjYrjKkAEgrLh2ScRG7RK/SWkbzjyn8KsBXb8mdVqj6
         lJiXon/p8XexdQ65NDLQI1CrDlpyzjO2Fe8Wj9C9stDwzT+Kx++hl4zBktk0jl5qVh
         c6+EPNSmIveCKvp/DFKwpXv5pT/XWJUXxlp6jf2xjNUJf8SsM6fIDmgRjF9t1rQ5wY
         BYCuqjJ2OwcDg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/14] net/mlx5e: Cleanup safe switch channels API by passing params
Date:   Fri, 16 Apr 2021 11:54:25 -0700
Message-Id: <20210416185430.62584-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

mlx5e_safe_switch_channels accepts new_chs as a parameter and opens new
channels in place, then copying them to priv->channels. It requires all
the callers to allocate space for this temporary storage of the new
channels.

This commit cleans up the API by replacing new_chs with new_params, a
meaningful subset of new_chs to be filled by the caller. The temporary
space for the new channels is allocated inside mlx5e_safe_switch_params
(a new name for mlx5e_safe_switch_channels). An extra copy of params is
made, but since it's control flow, it's not critical.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  8 +-
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    | 15 ++-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 98 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 99 +++++++++----------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 10 +-
 5 files changed, 114 insertions(+), 116 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d9ed20a4db53..b636d63358d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1018,10 +1018,10 @@ int fn##_ctx(struct mlx5e_priv *priv, void *context) \
 	return fn(priv); \
 }
 int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv);
-int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
-			       struct mlx5e_channels *new_chs,
-			       mlx5e_fp_preactivate preactivate,
-			       void *context, bool reset);
+int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
+			     struct mlx5e_params *new_params,
+			     mlx5e_fp_preactivate preactivate,
+			     void *context, bool reset);
 int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv);
 int mlx5e_num_channels_changed(struct mlx5e_priv *priv);
 int mlx5e_num_channels_changed_ctx(struct mlx5e_priv *priv, void *context);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 0b0273fac6e3..a4c8d8d00d5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1149,24 +1149,23 @@ static int mlx5e_update_trust_state_hw(struct mlx5e_priv *priv, void *context)
 
 static int mlx5e_set_trust_state(struct mlx5e_priv *priv, u8 trust_state)
 {
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	bool reset = true;
 	int err;
 
 	mutex_lock(&priv->state_lock);
 
-	new_channels.params = priv->channels.params;
-	mlx5e_params_calc_trust_tx_min_inline_mode(priv->mdev, &new_channels.params,
+	new_params = priv->channels.params;
+	mlx5e_params_calc_trust_tx_min_inline_mode(priv->mdev, &new_params,
 						   trust_state);
 
 	/* Skip if tx_min_inline is the same */
-	if (new_channels.params.tx_min_inline_mode ==
-	    priv->channels.params.tx_min_inline_mode)
+	if (new_params.tx_min_inline_mode == priv->channels.params.tx_min_inline_mode)
 		reset = false;
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels,
-					 mlx5e_update_trust_state_hw,
-					 &trust_state, reset);
+	err = mlx5e_safe_switch_params(priv, &new_params,
+				       mlx5e_update_trust_state_hw,
+				       &trust_state, reset);
 
 	mutex_unlock(&priv->state_lock);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 82994175aded..ef4a330c4cfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -326,7 +326,7 @@ static void mlx5e_get_ringparam(struct net_device *dev,
 int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *priv,
 				struct ethtool_ringparam *param)
 {
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	u8 log_rq_size;
 	u8 log_sq_size;
 	int err = 0;
@@ -365,15 +365,15 @@ int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *priv,
 
 	mutex_lock(&priv->state_lock);
 
-	new_channels.params = priv->channels.params;
-	new_channels.params.log_rq_mtu_frames = log_rq_size;
-	new_channels.params.log_sq_size = log_sq_size;
+	new_params = priv->channels.params;
+	new_params.log_rq_mtu_frames = log_rq_size;
+	new_params.log_sq_size = log_sq_size;
 
-	err = mlx5e_validate_params(priv->mdev, &new_channels.params);
+	err = mlx5e_validate_params(priv->mdev, &new_params);
 	if (err)
 		goto unlock;
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
+	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
 
 unlock:
 	mutex_unlock(&priv->state_lock);
@@ -418,7 +418,7 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 {
 	struct mlx5e_params *cur_params = &priv->channels.params;
 	unsigned int count = ch->combined_count;
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	bool arfs_enabled;
 	bool opened;
 	int err = 0;
@@ -455,8 +455,8 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 		goto out;
 	}
 
-	new_channels.params = *cur_params;
-	new_channels.params.num_channels = count;
+	new_params = *cur_params;
+	new_params.num_channels = count;
 
 	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
 
@@ -465,8 +465,8 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 		mlx5e_arfs_disable(priv);
 
 	/* Switch to new channels, set new parameters and close old ones */
-	err = mlx5e_safe_switch_channels(priv, &new_channels,
-					 mlx5e_num_channels_changed_ctx, NULL, true);
+	err = mlx5e_safe_switch_params(priv, &new_params,
+				       mlx5e_num_channels_changed_ctx, NULL, true);
 
 	if (arfs_enabled) {
 		int err2 = mlx5e_arfs_enable(priv);
@@ -561,7 +561,7 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 {
 	struct dim_cq_moder *rx_moder, *tx_moder;
 	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	bool reset_rx, reset_tx;
 	bool reset = true;
 	int err = 0;
@@ -584,32 +584,32 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 	}
 
 	mutex_lock(&priv->state_lock);
-	new_channels.params = priv->channels.params;
+	new_params = priv->channels.params;
 
-	rx_moder          = &new_channels.params.rx_cq_moderation;
+	rx_moder          = &new_params.rx_cq_moderation;
 	rx_moder->usec    = coal->rx_coalesce_usecs;
 	rx_moder->pkts    = coal->rx_max_coalesced_frames;
-	new_channels.params.rx_dim_enabled = !!coal->use_adaptive_rx_coalesce;
+	new_params.rx_dim_enabled = !!coal->use_adaptive_rx_coalesce;
 
-	tx_moder          = &new_channels.params.tx_cq_moderation;
+	tx_moder          = &new_params.tx_cq_moderation;
 	tx_moder->usec    = coal->tx_coalesce_usecs;
 	tx_moder->pkts    = coal->tx_max_coalesced_frames;
-	new_channels.params.tx_dim_enabled = !!coal->use_adaptive_tx_coalesce;
+	new_params.tx_dim_enabled = !!coal->use_adaptive_tx_coalesce;
 
 	reset_rx = !!coal->use_adaptive_rx_coalesce != priv->channels.params.rx_dim_enabled;
 	reset_tx = !!coal->use_adaptive_tx_coalesce != priv->channels.params.tx_dim_enabled;
 
 	if (reset_rx) {
-		u8 mode = MLX5E_GET_PFLAG(&new_channels.params,
+		u8 mode = MLX5E_GET_PFLAG(&new_params,
 					  MLX5E_PFLAG_RX_CQE_BASED_MODER);
 
-		mlx5e_reset_rx_moderation(&new_channels.params, mode);
+		mlx5e_reset_rx_moderation(&new_params, mode);
 	}
 	if (reset_tx) {
-		u8 mode = MLX5E_GET_PFLAG(&new_channels.params,
+		u8 mode = MLX5E_GET_PFLAG(&new_params,
 					  MLX5E_PFLAG_TX_CQE_BASED_MODER);
 
-		mlx5e_reset_tx_moderation(&new_channels.params, mode);
+		mlx5e_reset_tx_moderation(&new_params, mode);
 	}
 
 	/* If DIM state hasn't changed, it's possible to modify interrupt
@@ -623,7 +623,7 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 		reset = false;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, reset);
+	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, reset);
 
 	mutex_unlock(&priv->state_lock);
 	return err;
@@ -1843,7 +1843,7 @@ static int set_pflag_cqe_based_moder(struct net_device *netdev, bool enable,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	bool mode_changed;
 	u8 cq_period_mode, current_cq_period_mode;
 
@@ -1862,13 +1862,13 @@ static int set_pflag_cqe_based_moder(struct net_device *netdev, bool enable,
 	if (!mode_changed)
 		return 0;
 
-	new_channels.params = priv->channels.params;
+	new_params = priv->channels.params;
 	if (is_rx_cq)
-		mlx5e_set_rx_cq_mode_params(&new_channels.params, cq_period_mode);
+		mlx5e_set_rx_cq_mode_params(&new_params, cq_period_mode);
 	else
-		mlx5e_set_tx_cq_mode_params(&new_channels.params, cq_period_mode);
+		mlx5e_set_tx_cq_mode_params(&new_params, cq_period_mode);
 
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
+	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
 }
 
 static int set_pflag_tx_cqe_based_moder(struct net_device *netdev, bool enable)
@@ -1884,7 +1884,7 @@ static int set_pflag_rx_cqe_based_moder(struct net_device *netdev, bool enable)
 int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val)
 {
 	bool curr_val = MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS);
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	int err = 0;
 
 	if (!MLX5_CAP_GEN(priv->mdev, cqe_compression))
@@ -1893,16 +1893,16 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 	if (curr_val == new_val)
 		return 0;
 
-	new_channels.params = priv->channels.params;
-	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS, new_val);
+	new_params = priv->channels.params;
+	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_CQE_COMPRESS, new_val);
 	if (priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE)
-		new_channels.params.ptp_rx = new_val;
+		new_params.ptp_rx = new_val;
 
-	if (new_channels.params.ptp_rx == priv->channels.params.ptp_rx)
-		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
+	if (new_params.ptp_rx == priv->channels.params.ptp_rx)
+		err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
 	else
-		err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_ptp_rx_manage_fs_ctx,
-						 &new_channels.params.ptp_rx, true);
+		err = mlx5e_safe_switch_params(priv, &new_params, mlx5e_ptp_rx_manage_fs_ctx,
+					       &new_params.ptp_rx, true);
 	if (err)
 		return err;
 
@@ -1936,7 +1936,7 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 
 	if (enable) {
 		if (!mlx5e_check_fragmented_striding_rq_cap(mdev))
@@ -1948,12 +1948,12 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
 		return -EINVAL;
 	}
 
-	new_channels.params = priv->channels.params;
+	new_params = priv->channels.params;
 
-	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_RX_STRIDING_RQ, enable);
-	mlx5e_set_rq_type(mdev, &new_channels.params);
+	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_STRIDING_RQ, enable);
+	mlx5e_set_rq_type(mdev, &new_params);
 
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
+	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
 }
 
 static int set_pflag_rx_no_csum_complete(struct net_device *netdev, bool enable)
@@ -1982,16 +1982,16 @@ static int set_pflag_tx_mpwqe_common(struct net_device *netdev, u32 flag, bool e
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 
 	if (enable && !MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe))
 		return -EOPNOTSUPP;
 
-	new_channels.params = priv->channels.params;
+	new_params = priv->channels.params;
 
-	MLX5E_SET_PFLAG(&new_channels.params, flag, enable);
+	MLX5E_SET_PFLAG(&new_params, flag, enable);
 
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
+	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
 }
 
 static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
@@ -2008,7 +2008,7 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	int err;
 
 	if (!MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn))
@@ -2024,15 +2024,15 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 		return -EINVAL;
 	}
 
-	new_channels.params = priv->channels.params;
-	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_TX_PORT_TS, enable);
+	new_params = priv->channels.params;
+	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_TX_PORT_TS, enable);
 	/* No need to verify SQ stop room as
 	 * ptpsq.txqsq.stop_room <= generic_sq->stop_room, and both
 	 * has the same log_sq_size.
 	 */
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels,
-					 mlx5e_num_channels_changed_ctx, NULL, true);
+	err = mlx5e_safe_switch_params(priv, &new_params,
+				       mlx5e_num_channels_changed_ctx, NULL, true);
 	if (!err)
 		priv->tx_ptp_opened = true;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7686d4997696..feb347e81448 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2909,33 +2909,32 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 	return err;
 }
 
-int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
-			       struct mlx5e_channels *new_chs,
-			       mlx5e_fp_preactivate preactivate,
-			       void *context, bool reset)
+int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
+			     struct mlx5e_params *params,
+			     mlx5e_fp_preactivate preactivate,
+			     void *context, bool reset)
 {
+	struct mlx5e_channels new_chs = {};
 	int err;
 
 	reset &= test_bit(MLX5E_STATE_OPENED, &priv->state);
 	if (!reset)
-		return mlx5e_switch_priv_params(priv, &new_chs->params, preactivate, context);
+		return mlx5e_switch_priv_params(priv, params, preactivate, context);
 
-	err = mlx5e_open_channels(priv, new_chs);
+	new_chs.params = *params;
+	err = mlx5e_open_channels(priv, &new_chs);
 	if (err)
 		return err;
-	err = mlx5e_switch_priv_channels(priv, new_chs, preactivate, context);
+	err = mlx5e_switch_priv_channels(priv, &new_chs, preactivate, context);
 	if (err)
-		mlx5e_close_channels(new_chs);
+		mlx5e_close_channels(&new_chs);
 
 	return err;
 }
 
 int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv)
 {
-	struct mlx5e_channels new_channels = {};
-
-	new_channels.params = priv->channels.params;
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
+	return mlx5e_safe_switch_params(priv, &priv->channels.params, NULL, NULL, true);
 }
 
 void mlx5e_timestamp_init(struct mlx5e_priv *priv)
@@ -3392,7 +3391,7 @@ static int mlx5e_modify_channels_vsd(struct mlx5e_channels *chs, bool vsd)
 static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 				 struct tc_mqprio_qopt *mqprio)
 {
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	u8 tc = mqprio->num_tc;
 	int err = 0;
 
@@ -3411,11 +3410,11 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 		goto out;
 	}
 
-	new_channels.params = priv->channels.params;
-	new_channels.params.num_tc = tc ? tc : 1;
+	new_params = priv->channels.params;
+	new_params.num_tc = tc ? tc : 1;
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels,
-					 mlx5e_num_channels_changed_ctx, NULL, true);
+	err = mlx5e_safe_switch_params(priv, &new_params,
+				       mlx5e_num_channels_changed_ctx, NULL, true);
 
 out:
 	priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
@@ -3640,8 +3639,8 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5e_channels new_channels = {};
 	struct mlx5e_params *cur_params;
+	struct mlx5e_params new_params;
 	bool reset = true;
 	int err = 0;
 
@@ -3661,17 +3660,17 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 		goto out;
 	}
 
-	new_channels.params = *cur_params;
-	new_channels.params.lro_en = enable;
+	new_params = *cur_params;
+	new_params.lro_en = enable;
 
 	if (cur_params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		if (mlx5e_rx_mpwqe_is_linear_skb(mdev, cur_params, NULL) ==
-		    mlx5e_rx_mpwqe_is_linear_skb(mdev, &new_channels.params, NULL))
+		    mlx5e_rx_mpwqe_is_linear_skb(mdev, &new_params, NULL))
 			reset = false;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels,
-					 mlx5e_modify_tirs_lro_ctx, NULL, reset);
+	err = mlx5e_safe_switch_params(priv, &new_params,
+				       mlx5e_modify_tirs_lro_ctx, NULL, reset);
 out:
 	mutex_unlock(&priv->state_lock);
 	return err;
@@ -3900,7 +3899,7 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 		     mlx5e_fp_preactivate preactivate)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	struct mlx5e_params *params;
 	bool reset = true;
 	int err = 0;
@@ -3909,14 +3908,14 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 
 	params = &priv->channels.params;
 
-	new_channels.params = *params;
-	new_channels.params.sw_mtu = new_mtu;
-	err = mlx5e_validate_params(priv->mdev, &new_channels.params);
+	new_params = *params;
+	new_params.sw_mtu = new_mtu;
+	err = mlx5e_validate_params(priv->mdev, &new_params);
 	if (err)
 		goto out;
 
 	if (params->xdp_prog &&
-	    !mlx5e_rx_is_linear_skb(&new_channels.params, NULL)) {
+	    !mlx5e_rx_is_linear_skb(&new_params, NULL)) {
 		netdev_err(netdev, "MTU(%d) > %d is not allowed while XDP enabled\n",
 			   new_mtu, mlx5e_xdp_max_mtu(params, NULL));
 		err = -EINVAL;
@@ -3925,7 +3924,7 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 
 	if (priv->xsk.refcnt &&
 	    !mlx5e_xsk_validate_mtu(netdev, &priv->channels,
-				    &new_channels.params, priv->mdev)) {
+				    &new_params, priv->mdev)) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -3936,9 +3935,9 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 	if (params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		bool is_linear_old = mlx5e_rx_mpwqe_is_linear_skb(priv->mdev, params, NULL);
 		bool is_linear_new = mlx5e_rx_mpwqe_is_linear_skb(priv->mdev,
-								  &new_channels.params, NULL);
+								  &new_params, NULL);
 		u8 ppw_old = mlx5e_mpwqe_log_pkts_per_wqe(params, NULL);
-		u8 ppw_new = mlx5e_mpwqe_log_pkts_per_wqe(&new_channels.params, NULL);
+		u8 ppw_new = mlx5e_mpwqe_log_pkts_per_wqe(&new_params, NULL);
 
 		/* Always reset in linear mode - hw_mtu is used in data path.
 		 * Check that the mode was non-linear and didn't change.
@@ -3949,7 +3948,7 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 			reset = false;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, preactivate, NULL, reset);
+	err = mlx5e_safe_switch_params(priv, &new_params, preactivate, NULL, reset);
 
 out:
 	netdev->mtu = params->sw_mtu;
@@ -3971,7 +3970,7 @@ int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx)
 
 int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 {
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	struct hwtstamp_config config;
 	bool rx_cqe_compress_def;
 	int err;
@@ -3993,13 +3992,13 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 	}
 
 	mutex_lock(&priv->state_lock);
-	new_channels.params = priv->channels.params;
+	new_params = priv->channels.params;
 	rx_cqe_compress_def = priv->channels.params.rx_cqe_compress_def;
 
 	/* RX HW timestamp */
 	switch (config.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
-		new_channels.params.ptp_rx = false;
+		new_params.ptp_rx = false;
 		break;
 	case HWTSTAMP_FILTER_ALL:
 	case HWTSTAMP_FILTER_SOME:
@@ -4016,7 +4015,7 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
 	case HWTSTAMP_FILTER_NTP_ALL:
-		new_channels.params.ptp_rx = rx_cqe_compress_def;
+		new_params.ptp_rx = rx_cqe_compress_def;
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
 		break;
 	default:
@@ -4024,11 +4023,11 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 		return -ERANGE;
 	}
 
-	if (new_channels.params.ptp_rx == priv->channels.params.ptp_rx)
+	if (new_params.ptp_rx == priv->channels.params.ptp_rx)
 		goto out;
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_ptp_rx_manage_fs_ctx,
-					 &new_channels.params.ptp_rx, true);
+	err = mlx5e_safe_switch_params(priv, &new_params, mlx5e_ptp_rx_manage_fs_ctx,
+				       &new_params.ptp_rx, true);
 	if (err) {
 		mutex_unlock(&priv->state_lock);
 		return err;
@@ -4346,7 +4345,7 @@ static void mlx5e_tx_timeout(struct net_device *dev, unsigned int txqueue)
 static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
 {
 	struct net_device *netdev = priv->netdev;
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 
 	if (priv->channels.params.lro_en) {
 		netdev_warn(netdev, "can't set XDP while LRO is on, disable LRO first\n");
@@ -4359,16 +4358,16 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
 		return -EINVAL;
 	}
 
-	new_channels.params = priv->channels.params;
-	new_channels.params.xdp_prog = prog;
+	new_params = priv->channels.params;
+	new_params.xdp_prog = prog;
 
 	/* No XSK params: AF_XDP can't be enabled yet at the point of setting
 	 * the XDP program.
 	 */
-	if (!mlx5e_rx_is_linear_skb(&new_channels.params, NULL)) {
+	if (!mlx5e_rx_is_linear_skb(&new_params, NULL)) {
 		netdev_warn(netdev, "XDP is not allowed with MTU(%d) > %d\n",
-			    new_channels.params.sw_mtu,
-			    mlx5e_xdp_max_mtu(&new_channels.params, NULL));
+			    new_params.sw_mtu,
+			    mlx5e_xdp_max_mtu(&new_params, NULL));
 		return -EINVAL;
 	}
 
@@ -4388,7 +4387,7 @@ static void mlx5e_rq_replace_xdp_prog(struct mlx5e_rq *rq, struct bpf_prog *prog
 static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	struct bpf_prog *old_prog;
 	int err = 0;
 	bool reset;
@@ -4405,13 +4404,13 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	/* no need for full reset when exchanging programs */
 	reset = (!priv->channels.params.xdp_prog || !prog);
 
-	new_channels.params = priv->channels.params;
-	new_channels.params.xdp_prog = prog;
+	new_params = priv->channels.params;
+	new_params.xdp_prog = prog;
 	if (reset)
-		mlx5e_set_rq_type(priv->mdev, &new_channels.params);
+		mlx5e_set_rq_type(priv->mdev, &new_params);
 	old_prog = priv->channels.params.xdp_prog;
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, reset);
+	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, reset);
 	if (err)
 		goto unlock;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index df409111ef3a..612a7f69366d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -481,19 +481,19 @@ static const struct mlx5e_profile mlx5i_nic_profile = {
 static int mlx5i_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
-	struct mlx5e_channels new_channels = {};
+	struct mlx5e_params new_params;
 	int err = 0;
 
 	mutex_lock(&priv->state_lock);
 
-	new_channels.params = priv->channels.params;
-	new_channels.params.sw_mtu = new_mtu;
+	new_params = priv->channels.params;
+	new_params.sw_mtu = new_mtu;
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
+	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
 	if (err)
 		goto out;
 
-	netdev->mtu = new_channels.params.sw_mtu;
+	netdev->mtu = new_params.sw_mtu;
 
 out:
 	mutex_unlock(&priv->state_lock);
-- 
2.30.2

