Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F295453F86
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhKQEhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhKQEhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C720613A2;
        Wed, 17 Nov 2021 04:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123646;
        bh=6bTo0FeB5kZNxr3stpY/j0YKazkG71zR6qgI8gCXAMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzB86CrVcLNTOIHadifB4y02kCX8Hkyh7E39iY6bA/XqvK67v0wp7zmdcVKUXfh2G
         6KrjHaYb5ohK5M/xBYtpWtz69uuaRcyV1mYCxJSCRn9E/cNTztGDl8wKcNczzVDlg1
         sPZ1hynCE/rMPEB26QwcD1sEfrdQIDjxtUHgl6nynbAWgdO5dMpZtoP5FCySA1lTCU
         X9atR3FPLXrg8E7YAL4cN3pJgKQKCWJFNjYUVuPJgAp+D4oL1jROscAIzXS98KKDx+
         +/M2bJwVMgdwcQBVqvFnLe5/rLE2LEkfX317LT6uw/5b+FFr54edUn22liXgBiE1QA
         K/6kDXhWMG5OQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net-next v0 01/15] net/mlx5e: Support ethtool cq mode
Date:   Tue, 16 Nov 2021 20:33:43 -0800
Message-Id: <20211117043357.345072-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Add support for ethtool coalesce cq mode set and get.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  7 ++-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 49 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  4 +-
 .../mellanox/mlx5/core/ipoib/ethtool.c        |  4 +-
 4 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f0ac6b0d9653..48b12ee44b8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1148,9 +1148,12 @@ void mlx5e_ethtool_get_channels(struct mlx5e_priv *priv,
 int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 			       struct ethtool_channels *ch);
 int mlx5e_ethtool_get_coalesce(struct mlx5e_priv *priv,
-			       struct ethtool_coalesce *coal);
+			       struct ethtool_coalesce *coal,
+			       struct kernel_ethtool_coalesce *kernel_coal);
 int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
-			       struct ethtool_coalesce *coal);
+			       struct ethtool_coalesce *coal,
+			       struct kernel_ethtool_coalesce *kernel_coal,
+			       struct netlink_ext_ack *extack);
 int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
 				     struct ethtool_link_ksettings *link_ksettings);
 int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c2ea5fad48dd..45bdfcb3dcc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -511,7 +511,8 @@ static int mlx5e_set_channels(struct net_device *dev,
 }
 
 int mlx5e_ethtool_get_coalesce(struct mlx5e_priv *priv,
-			       struct ethtool_coalesce *coal)
+			       struct ethtool_coalesce *coal,
+			       struct kernel_ethtool_coalesce *kernel_coal)
 {
 	struct dim_cq_moder *rx_moder, *tx_moder;
 
@@ -528,6 +529,11 @@ int mlx5e_ethtool_get_coalesce(struct mlx5e_priv *priv,
 	coal->tx_max_coalesced_frames	= tx_moder->pkts;
 	coal->use_adaptive_tx_coalesce	= priv->channels.params.tx_dim_enabled;
 
+	kernel_coal->use_cqe_mode_rx =
+		MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_BASED_MODER);
+	kernel_coal->use_cqe_mode_tx =
+		MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_TX_CQE_BASED_MODER);
+
 	return 0;
 }
 
@@ -538,7 +544,7 @@ static int mlx5e_get_coalesce(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	return mlx5e_ethtool_get_coalesce(priv, coal);
+	return mlx5e_ethtool_get_coalesce(priv, coal, kernel_coal);
 }
 
 #define MLX5E_MAX_COAL_TIME		MLX5_MAX_CQ_PERIOD
@@ -578,14 +584,26 @@ mlx5e_set_priv_channels_rx_coalesce(struct mlx5e_priv *priv, struct ethtool_coal
 	}
 }
 
+/* convert a boolean value of cq_mode to mlx5 period mode
+ * true  : MLX5_CQ_PERIOD_MODE_START_FROM_CQE
+ * false : MLX5_CQ_PERIOD_MODE_START_FROM_EQE
+ */
+static int cqe_mode_to_period_mode(bool val)
+{
+	return val ? MLX5_CQ_PERIOD_MODE_START_FROM_CQE : MLX5_CQ_PERIOD_MODE_START_FROM_EQE;
+}
+
 int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
-			       struct ethtool_coalesce *coal)
+			       struct ethtool_coalesce *coal,
+			       struct kernel_ethtool_coalesce *kernel_coal,
+			       struct netlink_ext_ack *extack)
 {
 	struct dim_cq_moder *rx_moder, *tx_moder;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_params new_params;
 	bool reset_rx, reset_tx;
 	bool reset = true;
+	u8 cq_period_mode;
 	int err = 0;
 
 	if (!MLX5_CAP_GEN(mdev, cq_moderation))
@@ -605,6 +623,12 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 		return -ERANGE;
 	}
 
+	if ((kernel_coal->use_cqe_mode_rx || kernel_coal->use_cqe_mode_tx) &&
+	    !MLX5_CAP_GEN(priv->mdev, cq_period_start_from_cqe)) {
+		NL_SET_ERR_MSG_MOD(extack, "cqe_mode_rx/tx is not supported on this device");
+		return -EOPNOTSUPP;
+	}
+
 	mutex_lock(&priv->state_lock);
 	new_params = priv->channels.params;
 
@@ -621,6 +645,18 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 	reset_rx = !!coal->use_adaptive_rx_coalesce != priv->channels.params.rx_dim_enabled;
 	reset_tx = !!coal->use_adaptive_tx_coalesce != priv->channels.params.tx_dim_enabled;
 
+	cq_period_mode = cqe_mode_to_period_mode(kernel_coal->use_cqe_mode_rx);
+	if (cq_period_mode != rx_moder->cq_period_mode) {
+		mlx5e_set_rx_cq_mode_params(&new_params, cq_period_mode);
+		reset_rx = true;
+	}
+
+	cq_period_mode = cqe_mode_to_period_mode(kernel_coal->use_cqe_mode_tx);
+	if (cq_period_mode != tx_moder->cq_period_mode) {
+		mlx5e_set_tx_cq_mode_params(&new_params, cq_period_mode);
+		reset_tx = true;
+	}
+
 	if (reset_rx) {
 		u8 mode = MLX5E_GET_PFLAG(&new_params,
 					  MLX5E_PFLAG_RX_CQE_BASED_MODER);
@@ -656,9 +692,9 @@ static int mlx5e_set_coalesce(struct net_device *netdev,
 			      struct kernel_ethtool_coalesce *kernel_coal,
 			      struct netlink_ext_ack *extack)
 {
-	struct mlx5e_priv *priv    = netdev_priv(netdev);
+	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	return mlx5e_ethtool_set_coalesce(priv, coal);
+	return mlx5e_ethtool_set_coalesce(priv, coal, kernel_coal, extack);
 }
 
 static void ptys2ethtool_supported_link(struct mlx5_core_dev *mdev,
@@ -2358,7 +2394,8 @@ static void mlx5e_get_rmon_stats(struct net_device *netdev,
 const struct ethtool_ops mlx5e_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
-				     ETHTOOL_COALESCE_USE_ADAPTIVE,
+				     ETHTOOL_COALESCE_USE_ADAPTIVE |
+				     ETHTOOL_COALESCE_USE_CQE,
 	.get_drvinfo       = mlx5e_get_drvinfo,
 	.get_link          = ethtool_op_get_link,
 	.get_link_ext_state  = mlx5e_get_link_ext_state,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index e58a9ec42553..8c81aeba07db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -258,7 +258,7 @@ static int mlx5e_rep_get_coalesce(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	return mlx5e_ethtool_get_coalesce(priv, coal);
+	return mlx5e_ethtool_get_coalesce(priv, coal, kernel_coal);
 }
 
 static int mlx5e_rep_set_coalesce(struct net_device *netdev,
@@ -268,7 +268,7 @@ static int mlx5e_rep_set_coalesce(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	return mlx5e_ethtool_set_coalesce(priv, coal);
+	return mlx5e_ethtool_set_coalesce(priv, coal, kernel_coal, extack);
 }
 
 static u32 mlx5e_rep_get_rxfh_key_size(struct net_device *netdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 962d41418ce7..f23e33ac9c6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -105,7 +105,7 @@ static int mlx5i_set_coalesce(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
 
-	return mlx5e_ethtool_set_coalesce(priv, coal);
+	return mlx5e_ethtool_set_coalesce(priv, coal, kernel_coal, extack);
 }
 
 static int mlx5i_get_coalesce(struct net_device *netdev,
@@ -115,7 +115,7 @@ static int mlx5i_get_coalesce(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
 
-	return mlx5e_ethtool_get_coalesce(priv, coal);
+	return mlx5e_ethtool_get_coalesce(priv, coal, kernel_coal);
 }
 
 static int mlx5i_get_ts_info(struct net_device *netdev,
-- 
2.31.1

