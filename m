Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760C8362816
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbhDPSzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236324AbhDPSzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ADAB613C1;
        Fri, 16 Apr 2021 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599283;
        bh=n9O2lHlBhi2TKSRr0lJc36Dz0wQ/J8X7PDsmS5QtuD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBaPVvjtbDwJDznlnOJeKNPODnbCADrNJ7/B4EfJs0UbTNPs6KMjIf4HVV3LAvRnx
         EEbMPTQbEIRfqHzhXacwyszHe7TjIc698UPLmtO/8GkEBiwCjXhBW4ehElf0mv9E9M
         lvRjw8SxsbvLtu2OYny/Oj3L/e8xxPFhlONm/so25DzCUDDC1tQ1phd5UrRknoDYOu
         3lKM8KEpZYP8Y64FLidZhk2e5FooRsILHffiQkykYpN6/DpzdAk8yUbujDLXAFeImS
         BygYTF+JNULLHgOcJShHyTsemcM5FgTuasy/J3/lpY8ki8MVlkjcYYveaZFMnwyJSu
         czpvkhn8BVhlw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/14] net/mlx5e: Use mlx5e_safe_switch_channels when channels are closed
Date:   Fri, 16 Apr 2021 11:54:23 -0700
Message-Id: <20210416185430.62584-8-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

This commit uses new functionality of mlx5e_safe_switch_channels
introduced by the previous commit to reduce the amount of repeating
similar code all over the driver.

It's very common in mlx5e to call mlx5e_safe_switch_channels when the
channels are open, but assign parameters and run hardware commands
manually when the channels are closed.

After the previous commit it's no longer needed to do such manual things
every time, so this commit removes unneeded code and relies on the new
functionality of mlx5e_safe_switch_channels. Some of the places are
refactored and simplified, where more complex flows are used to change
configuration on the fly, without recreating the channels (the logic is
rewritten in a more robust way, with a reset required by default and a
list of exceptions).

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  3 +
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    | 23 ++-----
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 65 +++----------------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 65 ++++++-------------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 11 +---
 5 files changed, 40 insertions(+), 127 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 72e7dd6d78c0..d907c1acd4d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -792,6 +792,9 @@ int mlx5e_ptp_rx_manage_fs(struct mlx5e_priv *priv, bool set)
 	if (!priv->profile->rx_ptp_support)
 		return 0;
 
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
 	if (set) {
 		if (!c || !test_bit(MLX5E_PTP_STATE_RX, c->state)) {
 			netdev_WARN_ONCE(priv->netdev, "Don't try to add PTP RX-FS rules");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index f23c67575073..9d4d83159603 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1150,8 +1150,6 @@ static int mlx5e_update_trust_state_hw(struct mlx5e_priv *priv, void *context)
 static int mlx5e_set_trust_state(struct mlx5e_priv *priv, u8 trust_state)
 {
 	struct mlx5e_channels new_channels = {};
-	bool reset_channels = true;
-	bool opened;
 	int err = 0;
 
 	mutex_lock(&priv->state_lock);
@@ -1160,25 +1158,18 @@ static int mlx5e_set_trust_state(struct mlx5e_priv *priv, u8 trust_state)
 	mlx5e_params_calc_trust_tx_min_inline_mode(priv->mdev, &new_channels.params,
 						   trust_state);
 
-	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
-	if (!opened)
-		reset_channels = false;
-
 	/* Skip if tx_min_inline is the same */
 	if (new_channels.params.tx_min_inline_mode ==
-	    priv->channels.params.tx_min_inline_mode)
-		reset_channels = false;
-
-	if (reset_channels) {
-		err = mlx5e_safe_switch_channels(priv, &new_channels,
-						 mlx5e_update_trust_state_hw,
-						 &trust_state);
-	} else {
+	    priv->channels.params.tx_min_inline_mode) {
 		err = mlx5e_update_trust_state_hw(priv, &trust_state);
-		if (!err && !opened)
-			priv->channels.params = new_channels.params;
+		goto out;
 	}
 
+	err = mlx5e_safe_switch_channels(priv, &new_channels,
+					 mlx5e_update_trust_state_hw,
+					 &trust_state);
+
+out:
 	mutex_unlock(&priv->state_lock);
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index f17690cbeeea..6a15666f106f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -373,11 +373,6 @@ int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *priv,
 	if (err)
 		goto unlock;
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
-		goto unlock;
-	}
-
 	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 
 unlock:
@@ -425,6 +420,7 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 	unsigned int count = ch->combined_count;
 	struct mlx5e_channels new_channels = {};
 	bool arfs_enabled;
+	bool opened;
 	int err = 0;
 
 	if (!count) {
@@ -462,19 +458,9 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 	new_channels.params = *cur_params;
 	new_channels.params.num_channels = count;
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		struct mlx5e_params old_params;
-
-		old_params = *cur_params;
-		*cur_params = new_channels.params;
-		err = mlx5e_num_channels_changed(priv);
-		if (err)
-			*cur_params = old_params;
+	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
 
-		goto out;
-	}
-
-	arfs_enabled = priv->netdev->features & NETIF_F_NTUPLE;
+	arfs_enabled = opened && (priv->netdev->features & NETIF_F_NTUPLE);
 	if (arfs_enabled)
 		mlx5e_arfs_disable(priv);
 
@@ -625,12 +611,10 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 		mlx5e_reset_tx_moderation(&new_channels.params, mode);
 	}
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
-		goto out;
-	}
-
-	if (!reset_rx && !reset_tx) {
+	/* If DIM state hasn't changed, it's possible to modify interrupt
+	 * moderation parameters on the fly, even if the channels are open.
+	 */
+	if (!reset_rx && !reset_tx && test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		if (!coal->use_adaptive_rx_coalesce)
 			mlx5e_set_priv_channels_rx_coalesce(priv, coal);
 		if (!coal->use_adaptive_tx_coalesce)
@@ -1885,11 +1869,6 @@ static int set_pflag_cqe_based_moder(struct net_device *netdev, bool enable,
 	else
 		mlx5e_set_tx_cq_mode_params(&new_channels.params, cq_period_mode);
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
-		return 0;
-	}
-
 	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 }
 
@@ -1920,10 +1899,6 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 	if (priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE)
 		new_channels.params.ptp_rx = new_val;
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
-		return 0;
-	}
 
 	if (new_channels.params.ptp_rx == priv->channels.params.ptp_rx)
 		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
@@ -1980,11 +1955,6 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
 	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_RX_STRIDING_RQ, enable);
 	mlx5e_set_rq_type(mdev, &new_channels.params);
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
-		return 0;
-	}
-
 	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 }
 
@@ -2015,7 +1985,6 @@ static int set_pflag_tx_mpwqe_common(struct net_device *netdev, u32 flag, bool e
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_channels new_channels = {};
-	int err;
 
 	if (enable && !MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe))
 		return -EOPNOTSUPP;
@@ -2024,13 +1993,7 @@ static int set_pflag_tx_mpwqe_common(struct net_device *netdev, u32 flag, bool e
 
 	MLX5E_SET_PFLAG(&new_channels.params, flag, enable);
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
-		return 0;
-	}
-
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
-	return err;
+	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
 }
 
 static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
@@ -2070,20 +2033,8 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 	 * has the same log_sq_size.
 	 */
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		struct mlx5e_params old_params;
-
-		old_params = priv->channels.params;
-		priv->channels.params = new_channels.params;
-		err = mlx5e_num_channels_changed(priv);
-		if (err)
-			priv->channels.params = old_params;
-		goto out;
-	}
-
 	err = mlx5e_safe_switch_channels(priv, &new_channels,
 					 mlx5e_num_channels_changed_ctx, NULL);
-out:
 	if (!err)
 		priv->tx_ptp_opened = true;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cb88d7239db6..0e5539afc3a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3407,18 +3407,6 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 	new_channels.params = priv->channels.params;
 	new_channels.params.num_tc = tc ? tc : 1;
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		struct mlx5e_params old_params;
-
-		old_params = priv->channels.params;
-		priv->channels.params = new_channels.params;
-		err = mlx5e_num_channels_changed(priv);
-		if (err)
-			priv->channels.params = old_params;
-
-		goto out;
-	}
-
 	err = mlx5e_safe_switch_channels(priv, &new_channels,
 					 mlx5e_num_channels_changed_ctx, NULL);
 
@@ -3647,8 +3635,8 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_channels new_channels = {};
 	struct mlx5e_params *cur_params;
+	bool skip_reset = false;
 	int err = 0;
-	bool reset;
 
 	mutex_lock(&priv->state_lock);
 
@@ -3666,18 +3654,16 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 		goto out;
 	}
 
-	reset = test_bit(MLX5E_STATE_OPENED, &priv->state);
-
 	new_channels.params = *cur_params;
 	new_channels.params.lro_en = enable;
 
-	if (cur_params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
+	if (cur_params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		if (mlx5e_rx_mpwqe_is_linear_skb(mdev, cur_params, NULL) ==
 		    mlx5e_rx_mpwqe_is_linear_skb(mdev, &new_channels.params, NULL))
-			reset = false;
+			skip_reset = true;
 	}
 
-	if (!reset) {
+	if (skip_reset) {
 		struct mlx5e_params old_params;
 
 		old_params = *cur_params;
@@ -3920,16 +3906,13 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_channels new_channels = {};
 	struct mlx5e_params *params;
+	bool skip_reset = false;
 	int err = 0;
-	bool reset;
 
 	mutex_lock(&priv->state_lock);
 
 	params = &priv->channels.params;
 
-	reset = !params->lro_en;
-	reset = reset && test_bit(MLX5E_STATE_OPENED, &priv->state);
-
 	new_channels.params = *params;
 	new_channels.params.sw_mtu = new_mtu;
 	err = mlx5e_validate_params(priv->mdev, &new_channels.params);
@@ -3951,21 +3934,26 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 		goto out;
 	}
 
+	if (params->lro_en)
+		skip_reset = true;
+
 	if (params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
-		bool is_linear = mlx5e_rx_mpwqe_is_linear_skb(priv->mdev,
-							      &new_channels.params,
-							      NULL);
+		bool is_linear_old = mlx5e_rx_mpwqe_is_linear_skb(priv->mdev, params, NULL);
+		bool is_linear_new = mlx5e_rx_mpwqe_is_linear_skb(priv->mdev,
+								  &new_channels.params, NULL);
 		u8 ppw_old = mlx5e_mpwqe_log_pkts_per_wqe(params, NULL);
 		u8 ppw_new = mlx5e_mpwqe_log_pkts_per_wqe(&new_channels.params, NULL);
 
-		/* If XSK is active, XSK RQs are linear. */
-		is_linear |= priv->xsk.refcnt;
-
-		/* Always reset in linear mode - hw_mtu is used in data path. */
-		reset = reset && (is_linear || (ppw_old != ppw_new));
+		/* Always reset in linear mode - hw_mtu is used in data path.
+		 * Check that the mode was non-linear and didn't change.
+		 * If XSK is active, XSK RQs are linear.
+		 */
+		if (!is_linear_old && !is_linear_new && !priv->xsk.refcnt &&
+		    ppw_old == ppw_new)
+			skip_reset = true;
 	}
 
-	if (!reset) {
+	if (skip_reset) {
 		unsigned int old_mtu = params->sw_mtu;
 
 		params->sw_mtu = new_mtu;
@@ -3976,17 +3964,13 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 				goto out;
 			}
 		}
-		netdev->mtu = params->sw_mtu;
 		goto out;
 	}
 
 	err = mlx5e_safe_switch_channels(priv, &new_channels, preactivate, NULL);
-	if (err)
-		goto out;
-
-	netdev->mtu = new_channels.params.sw_mtu;
 
 out:
+	netdev->mtu = params->sw_mtu;
 	mutex_unlock(&priv->state_lock);
 	return err;
 }
@@ -4061,10 +4045,6 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 	if (new_channels.params.ptp_rx == priv->channels.params.ptp_rx)
 		goto out;
 
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params = new_channels.params;
-		goto out;
-	}
 	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_ptp_rx_manage_fs_ctx,
 					 &new_channels.params.ptp_rx);
 	if (err) {
@@ -4449,7 +4429,7 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 		 */
 		bpf_prog_add(prog, priv->channels.num);
 
-	if (was_opened && reset) {
+	if (reset) {
 		struct mlx5e_channels new_channels = {};
 
 		new_channels.params = priv->channels.params;
@@ -4470,9 +4450,6 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
-	if (!was_opened && reset) /* change RQ type according to priv->xdp_prog */
-		mlx5e_set_rq_type(priv->mdev, &priv->channels.params);
-
 	if (!was_opened || reset)
 		goto unlock;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index b65b0cefc5b3..9555127ce7e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -482,20 +482,11 @@ static int mlx5i_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
 	struct mlx5e_channels new_channels = {};
-	struct mlx5e_params *params;
 	int err = 0;
 
 	mutex_lock(&priv->state_lock);
 
-	params = &priv->channels.params;
-
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		params->sw_mtu = new_mtu;
-		netdev->mtu = params->sw_mtu;
-		goto out;
-	}
-
-	new_channels.params = *params;
+	new_channels.params = priv->channels.params;
 	new_channels.params.sw_mtu = new_mtu;
 
 	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
-- 
2.30.2

