Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22D8362817
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238434AbhDPSzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236328AbhDPSzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A154B613BB;
        Fri, 16 Apr 2021 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599284;
        bh=dPgeC6UpDA9k/xAWh5ZjVOZpC5ois/ukNOKYkrM/trQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XV8Lild0o0PZK8AcdEMHzzUwDv/2KUCK99i/fBjQI+Z5XLYJ9ByGJjRh48WUCY4kP
         jPB2AqohRwP3B09foS68YC9VeRW5ivodYARAn3yKnKvyWHfc19IqLWCq6h2cKyM1mB
         gESGBxBqkHNrq+LPzW0GFX++WqkyMdCSFBpndgHE6C67Ab1J2ndsn782ueKn9YKKYH
         uZvPkSmrXJZP18R1AJ3qgov8Ec7rVmqM1q4ZHFT5kYO3XM4Q9QCGDuGpaUxARvXHor
         gSHztXGhPeUvdfit7PNUK9rCUcwGXG/UGIzQTFUQoNbcu64Xy9rXwHXy9/bZLUqtmo
         2cVwvHWP+4YxQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/14] net/mlx5e: Refactor on-the-fly configuration changes
Date:   Fri, 16 Apr 2021 11:54:24 -0700
Message-Id: <20210416185430.62584-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

This commit extends mlx5e_safe_switch_channels() to support on-the-fly
configuration changes, when the channels are open, but don't need to be
recreated. Such flows exist when a parameter being changed doesn't
affect how the queues are created, or when the queues can be modified
while remaining active.

Before this commit, such flows were handled as special cases on the
caller site. This commit adds this functionality to
mlx5e_safe_switch_channels(), allowing the caller to pass a boolean
indicating whether it's required to recreate the channels or it's
allowed to skip it. The logic of switching channel parameters is now
completely encapsulated into mlx5e_safe_switch_channels().

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    |  12 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  24 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 151 +++++++-----------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |   2 +-
 5 files changed, 78 insertions(+), 113 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 28a68eef8ae6..d9ed20a4db53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1021,7 +1021,7 @@ int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv);
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
 			       mlx5e_fp_preactivate preactivate,
-			       void *context);
+			       void *context, bool reset);
 int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv);
 int mlx5e_num_channels_changed(struct mlx5e_priv *priv);
 int mlx5e_num_channels_changed_ctx(struct mlx5e_priv *priv, void *context);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 9d4d83159603..0b0273fac6e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1150,7 +1150,8 @@ static int mlx5e_update_trust_state_hw(struct mlx5e_priv *priv, void *context)
 static int mlx5e_set_trust_state(struct mlx5e_priv *priv, u8 trust_state)
 {
 	struct mlx5e_channels new_channels = {};
-	int err = 0;
+	bool reset = true;
+	int err;
 
 	mutex_lock(&priv->state_lock);
 
@@ -1160,16 +1161,13 @@ static int mlx5e_set_trust_state(struct mlx5e_priv *priv, u8 trust_state)
 
 	/* Skip if tx_min_inline is the same */
 	if (new_channels.params.tx_min_inline_mode ==
-	    priv->channels.params.tx_min_inline_mode) {
-		err = mlx5e_update_trust_state_hw(priv, &trust_state);
-		goto out;
-	}
+	    priv->channels.params.tx_min_inline_mode)
+		reset = false;
 
 	err = mlx5e_safe_switch_channels(priv, &new_channels,
 					 mlx5e_update_trust_state_hw,
-					 &trust_state);
+					 &trust_state, reset);
 
-out:
 	mutex_unlock(&priv->state_lock);
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 6a15666f106f..82994175aded 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -373,7 +373,7 @@ int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *priv,
 	if (err)
 		goto unlock;
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
 
 unlock:
 	mutex_unlock(&priv->state_lock);
@@ -466,7 +466,7 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	/* Switch to new channels, set new parameters and close old ones */
 	err = mlx5e_safe_switch_channels(priv, &new_channels,
-					 mlx5e_num_channels_changed_ctx, NULL);
+					 mlx5e_num_channels_changed_ctx, NULL, true);
 
 	if (arfs_enabled) {
 		int err2 = mlx5e_arfs_enable(priv);
@@ -563,6 +563,7 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_channels new_channels = {};
 	bool reset_rx, reset_tx;
+	bool reset = true;
 	int err = 0;
 
 	if (!MLX5_CAP_GEN(mdev, cq_moderation))
@@ -619,13 +620,11 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 			mlx5e_set_priv_channels_rx_coalesce(priv, coal);
 		if (!coal->use_adaptive_tx_coalesce)
 			mlx5e_set_priv_channels_tx_coalesce(priv, coal);
-		priv->channels.params = new_channels.params;
-		goto out;
+		reset = false;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, reset);
 
-out:
 	mutex_unlock(&priv->state_lock);
 	return err;
 }
@@ -1869,7 +1868,7 @@ static int set_pflag_cqe_based_moder(struct net_device *netdev, bool enable,
 	else
 		mlx5e_set_tx_cq_mode_params(&new_channels.params, cq_period_mode);
 
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
 }
 
 static int set_pflag_tx_cqe_based_moder(struct net_device *netdev, bool enable)
@@ -1899,12 +1898,11 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 	if (priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE)
 		new_channels.params.ptp_rx = new_val;
 
-
 	if (new_channels.params.ptp_rx == priv->channels.params.ptp_rx)
-		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
 	else
 		err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_ptp_rx_manage_fs_ctx,
-						 &new_channels.params.ptp_rx);
+						 &new_channels.params.ptp_rx, true);
 	if (err)
 		return err;
 
@@ -1955,7 +1953,7 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
 	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_RX_STRIDING_RQ, enable);
 	mlx5e_set_rq_type(mdev, &new_channels.params);
 
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
 }
 
 static int set_pflag_rx_no_csum_complete(struct net_device *netdev, bool enable)
@@ -1993,7 +1991,7 @@ static int set_pflag_tx_mpwqe_common(struct net_device *netdev, u32 flag, bool e
 
 	MLX5E_SET_PFLAG(&new_channels.params, flag, enable);
 
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
 }
 
 static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
@@ -2034,7 +2032,7 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 	 */
 
 	err = mlx5e_safe_switch_channels(priv, &new_channels,
-					 mlx5e_num_channels_changed_ctx, NULL);
+					 mlx5e_num_channels_changed_ctx, NULL, true);
 	if (!err)
 		priv->tx_ptp_opened = true;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0e5539afc3a0..7686d4997696 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2844,6 +2844,29 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 	mlx5e_deactivate_channels(&priv->channels);
 }
 
+static int mlx5e_switch_priv_params(struct mlx5e_priv *priv,
+				    struct mlx5e_params *new_params,
+				    mlx5e_fp_preactivate preactivate,
+				    void *context)
+{
+	struct mlx5e_params old_params;
+
+	old_params = priv->channels.params;
+	priv->channels.params = *new_params;
+
+	if (preactivate) {
+		int err;
+
+		err = preactivate(priv, context);
+		if (err) {
+			priv->channels.params = old_params;
+			return err;
+		}
+	}
+
+	return 0;
+}
+
 static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 				      struct mlx5e_channels *new_chs,
 				      mlx5e_fp_preactivate preactivate,
@@ -2852,16 +2875,12 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 	struct net_device *netdev = priv->netdev;
 	struct mlx5e_channels old_chs;
 	int carrier_ok;
-	bool opened;
 	int err = 0;
 
-	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
-	if (opened) {
-		carrier_ok = netif_carrier_ok(netdev);
-		netif_carrier_off(netdev);
+	carrier_ok = netif_carrier_ok(netdev);
+	netif_carrier_off(netdev);
 
-		mlx5e_deactivate_priv_channels(priv);
-	}
+	mlx5e_deactivate_priv_channels(priv);
 
 	old_chs = priv->channels;
 	priv->channels = *new_chs;
@@ -2877,19 +2896,15 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 		}
 	}
 
-	if (opened) {
-		mlx5e_close_channels(&old_chs);
-		priv->profile->update_rx(priv);
-	}
+	mlx5e_close_channels(&old_chs);
+	priv->profile->update_rx(priv);
 
 out:
-	if (opened) {
-		mlx5e_activate_priv_channels(priv);
+	mlx5e_activate_priv_channels(priv);
 
-		/* return carrier back if needed */
-		if (carrier_ok)
-			netif_carrier_on(netdev);
-	}
+	/* return carrier back if needed */
+	if (carrier_ok)
+		netif_carrier_on(netdev);
 
 	return err;
 }
@@ -2897,27 +2912,19 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
 			       mlx5e_fp_preactivate preactivate,
-			       void *context)
+			       void *context, bool reset)
 {
-	bool opened;
 	int err;
 
-	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
-
-	if (opened) {
-		err = mlx5e_open_channels(priv, new_chs);
-		if (err)
-			return err;
-	}
+	reset &= test_bit(MLX5E_STATE_OPENED, &priv->state);
+	if (!reset)
+		return mlx5e_switch_priv_params(priv, &new_chs->params, preactivate, context);
 
+	err = mlx5e_open_channels(priv, new_chs);
+	if (err)
+		return err;
 	err = mlx5e_switch_priv_channels(priv, new_chs, preactivate, context);
 	if (err)
-		goto err_close;
-
-	return 0;
-
-err_close:
-	if (opened)
 		mlx5e_close_channels(new_chs);
 
 	return err;
@@ -2928,7 +2935,7 @@ int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv)
 	struct mlx5e_channels new_channels = {};
 
 	new_channels.params = priv->channels.params;
-	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
 }
 
 void mlx5e_timestamp_init(struct mlx5e_priv *priv)
@@ -3408,7 +3415,7 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 	new_channels.params.num_tc = tc ? tc : 1;
 
 	err = mlx5e_safe_switch_channels(priv, &new_channels,
-					 mlx5e_num_channels_changed_ctx, NULL);
+					 mlx5e_num_channels_changed_ctx, NULL, true);
 
 out:
 	priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
@@ -3635,7 +3642,7 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_channels new_channels = {};
 	struct mlx5e_params *cur_params;
-	bool skip_reset = false;
+	bool reset = true;
 	int err = 0;
 
 	mutex_lock(&priv->state_lock);
@@ -3660,22 +3667,11 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 	if (cur_params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		if (mlx5e_rx_mpwqe_is_linear_skb(mdev, cur_params, NULL) ==
 		    mlx5e_rx_mpwqe_is_linear_skb(mdev, &new_channels.params, NULL))
-			skip_reset = true;
-	}
-
-	if (skip_reset) {
-		struct mlx5e_params old_params;
-
-		old_params = *cur_params;
-		*cur_params = new_channels.params;
-		err = mlx5e_modify_tirs_lro(priv);
-		if (err)
-			*cur_params = old_params;
-		goto out;
+			reset = false;
 	}
 
 	err = mlx5e_safe_switch_channels(priv, &new_channels,
-					 mlx5e_modify_tirs_lro_ctx, NULL);
+					 mlx5e_modify_tirs_lro_ctx, NULL, reset);
 out:
 	mutex_unlock(&priv->state_lock);
 	return err;
@@ -3906,7 +3902,7 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_channels new_channels = {};
 	struct mlx5e_params *params;
-	bool skip_reset = false;
+	bool reset = true;
 	int err = 0;
 
 	mutex_lock(&priv->state_lock);
@@ -3935,7 +3931,7 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 	}
 
 	if (params->lro_en)
-		skip_reset = true;
+		reset = false;
 
 	if (params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		bool is_linear_old = mlx5e_rx_mpwqe_is_linear_skb(priv->mdev, params, NULL);
@@ -3950,24 +3946,10 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 		 */
 		if (!is_linear_old && !is_linear_new && !priv->xsk.refcnt &&
 		    ppw_old == ppw_new)
-			skip_reset = true;
-	}
-
-	if (skip_reset) {
-		unsigned int old_mtu = params->sw_mtu;
-
-		params->sw_mtu = new_mtu;
-		if (preactivate) {
-			err = preactivate(priv, NULL);
-			if (err) {
-				params->sw_mtu = old_mtu;
-				goto out;
-			}
-		}
-		goto out;
+			reset = false;
 	}
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, preactivate, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, preactivate, NULL, reset);
 
 out:
 	netdev->mtu = params->sw_mtu;
@@ -4046,7 +4028,7 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 		goto out;
 
 	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_ptp_rx_manage_fs_ctx,
-					 &new_channels.params.ptp_rx);
+					 &new_channels.params.ptp_rx, true);
 	if (err) {
 		mutex_unlock(&priv->state_lock);
 		return err;
@@ -4406,9 +4388,10 @@ static void mlx5e_rq_replace_xdp_prog(struct mlx5e_rq *rq, struct bpf_prog *prog
 static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_channels new_channels = {};
 	struct bpf_prog *old_prog;
-	bool reset, was_opened;
 	int err = 0;
+	bool reset;
 	int i;
 
 	mutex_lock(&priv->state_lock);
@@ -4419,43 +4402,29 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 			goto unlock;
 	}
 
-	was_opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
 	/* no need for full reset when exchanging programs */
 	reset = (!priv->channels.params.xdp_prog || !prog);
 
-	if (was_opened && !reset)
-		/* num_channels is invariant here, so we can take the
-		 * batched reference right upfront.
-		 */
-		bpf_prog_add(prog, priv->channels.num);
-
-	if (reset) {
-		struct mlx5e_channels new_channels = {};
-
-		new_channels.params = priv->channels.params;
-		new_channels.params.xdp_prog = prog;
+	new_channels.params = priv->channels.params;
+	new_channels.params.xdp_prog = prog;
+	if (reset)
 		mlx5e_set_rq_type(priv->mdev, &new_channels.params);
-		old_prog = priv->channels.params.xdp_prog;
+	old_prog = priv->channels.params.xdp_prog;
 
-		err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
-		if (err)
-			goto unlock;
-	} else {
-		/* exchange programs, extra prog reference we got from caller
-		 * as long as we don't fail from this point onwards.
-		 */
-		old_prog = xchg(&priv->channels.params.xdp_prog, prog);
-	}
+	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, reset);
+	if (err)
+		goto unlock;
 
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
-	if (!was_opened || reset)
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
 		goto unlock;
 
 	/* exchanging programs w/o reset, we update ref counts on behalf
 	 * of the channels RQs here.
 	 */
+	bpf_prog_add(prog, priv->channels.num);
 	for (i = 0; i < priv->channels.num; i++) {
 		struct mlx5e_channel *c = priv->channels.c[i];
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 9555127ce7e7..df409111ef3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -489,7 +489,7 @@ static int mlx5i_change_mtu(struct net_device *netdev, int new_mtu)
 	new_channels.params = priv->channels.params;
 	new_channels.params.sw_mtu = new_mtu;
 
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL, true);
 	if (err)
 		goto out;
 
-- 
2.30.2

