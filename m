Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AD034E028
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhC3E2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230286AbhC3E1t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1572A6196A;
        Tue, 30 Mar 2021 04:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078469;
        bh=BgR4xYjyP8nB49VsSTHy+36BMhAVadCBOp2gq/D6fqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLLmC1/dHvbfgJO4lwuQBLVBJd7/g3Ol059yi9+G9C+wEZ/8RsTmIwrM9ypyhOZJM
         TAU074pga6o3/bJfxdyPpgobDBRAo+vmrE4vDHWVl/bEUMLgw2WfKlWVyr3ilI2BPg
         B5sy0Q+513vVob9lDNgNOg8/wFEySxB4vODRPs2TuehsmWI89xLFpH+uDdbDZLrZns
         HJt7b+tD8NVx05mH6rfkt3RdwBOe6Wq9FmwDjoGi7SCh5v39UhYMc5PTHEl9l3jhfg
         /ddrMC3ueTbrhHHVkYePoNLwP5HMgS711MC4ggaiylp/R3D2pPOEbIQTtmmHKrH89I
         0No4zqHLg0gIg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/12] net/mlx5e: Allow coexistence of CQE compression and HW TS PTP
Date:   Mon, 29 Mar 2021 21:27:40 -0700
Message-Id: <20210330042741.198601-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Update setting HW time-stamp to allow coexistence with CQE compression.
Turn on RX PTP indication and try to reopen the channels. On success,
coexistence with CQE compression is enabled. Otherwise, fall-back to
turning off CQE compression.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  3 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 43 +++++++++++++------
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f31b5ccc27d0..2ad12ee9d100 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -269,6 +269,7 @@ struct mlx5e_params {
 	struct mlx5e_xsk *xsk;
 	unsigned int sw_mtu;
 	int hard_mtu;
+	bool ptp_rx;
 };
 
 enum {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 995a0947b2d5..72e7dd6d78c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -579,6 +579,9 @@ static int mlx5e_ptp_set_state(struct mlx5e_ptp *c, struct mlx5e_params *params)
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_TX_PORT_TS))
 		__set_bit(MLX5E_PTP_STATE_TX, c->state);
 
+	if (params->ptp_rx)
+		__set_bit(MLX5E_PTP_STATE_RX, c->state);
+
 	return bitmap_empty(c->state, MLX5E_PTP_STATE_NUM_STATES) ? -EINVAL : 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7cf12342afe6..c6227725733a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2087,7 +2087,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 			goto err_close_channels;
 	}
 
-	if (MLX5E_GET_PFLAG(&chs->params, MLX5E_PFLAG_TX_PORT_TS)) {
+	if (MLX5E_GET_PFLAG(&chs->params, MLX5E_PFLAG_TX_PORT_TS) || chs->params.ptp_rx) {
 		err = mlx5e_ptp_open(priv, &chs->params, chs->c[0]->lag_port, &chs->ptp);
 		if (err)
 			goto err_close_channels;
@@ -2688,6 +2688,8 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	nch = priv->channels.params.num_channels;
 	ntc = priv->channels.params.num_tc;
 	num_rxqs = nch * priv->profile->rq_groups;
+	if (priv->channels.params.ptp_rx)
+		num_rxqs++;
 
 	mlx5e_netdev_set_tcs(netdev, nch, ntc);
 
@@ -3968,9 +3970,18 @@ static int mlx5e_change_nic_mtu(struct net_device *netdev, int new_mtu)
 	return mlx5e_change_mtu(netdev, new_mtu, mlx5e_set_dev_port_mtu_ctx);
 }
 
+static int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx)
+{
+	bool set  = *(bool *)ctx;
+
+	return mlx5e_ptp_rx_manage_fs(priv, set);
+}
+
 int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 {
+	struct mlx5e_channels new_channels = {};
 	struct hwtstamp_config config;
+	bool rx_cqe_compress_def;
 	int err;
 
 	if (!MLX5_CAP_GEN(priv->mdev, device_frequency_khz) ||
@@ -3990,11 +4001,13 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 	}
 
 	mutex_lock(&priv->state_lock);
+	new_channels.params = priv->channels.params;
+	rx_cqe_compress_def = priv->channels.params.rx_cqe_compress_def;
+
 	/* RX HW timestamp */
 	switch (config.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
-		/* Reset CQE compression to Admin default */
-		mlx5e_modify_rx_cqe_compression_locked(priv, priv->channels.params.rx_cqe_compress_def);
+		new_channels.params.ptp_rx = false;
 		break;
 	case HWTSTAMP_FILTER_ALL:
 	case HWTSTAMP_FILTER_SOME:
@@ -4011,15 +4024,7 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
 	case HWTSTAMP_FILTER_NTP_ALL:
-		/* Disable CQE compression */
-		if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS))
-			netdev_warn(priv->netdev, "Disabling RX cqe compression\n");
-		err = mlx5e_modify_rx_cqe_compression_locked(priv, false);
-		if (err) {
-			netdev_err(priv->netdev, "Failed disabling cqe compression err=%d\n", err);
-			mutex_unlock(&priv->state_lock);
-			return err;
-		}
+		new_channels.params.ptp_rx = rx_cqe_compress_def;
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
 		break;
 	default:
@@ -4027,6 +4032,20 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 		return -ERANGE;
 	}
 
+	if (new_channels.params.ptp_rx == priv->channels.params.ptp_rx)
+		goto out;
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		priv->channels.params = new_channels.params;
+		goto out;
+	}
+	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_ptp_rx_manage_fs_ctx,
+					 &new_channels.params.ptp_rx);
+	if (err) {
+		mutex_unlock(&priv->state_lock);
+		return err;
+	}
+out:
 	memcpy(&priv->tstamp, &config, sizeof(config));
 	mutex_unlock(&priv->state_lock);
 
-- 
2.30.2

