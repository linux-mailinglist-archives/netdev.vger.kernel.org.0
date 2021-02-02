Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440BE30B818
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhBBGzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:55:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232206AbhBBGzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:55:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A072064EE3;
        Tue,  2 Feb 2021 06:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248912;
        bh=hJ3jlKO4/evgRnO/1UTkBAj8bKkrEAL2Yur2LfNf0Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ao7k1YvQu712o2UppScAgp7r5izJtev6HA4N7BCr6LA55mqelRVbNZ/q5KHD7NAh9
         G8Rb1wMIaJmjA6hlQVX1/MF7uiEXqOWuPRqGjcIKjA9qLLRyNx0AyI5JBkAPwKt0zG
         HsWgSweUHtCTQg5Fz0nihpkWLT9cHDRKQEUYzx9QmRkSZOwHMgggpYeIRlBOwsGciE
         InX8jXBWRSWO0Xk5e4kqaGyd9GphmDNB8GDf647AsnObIabhnCTfPVqPCmx4jp6l50
         K1y2kFZJYmYa9kWDEtP9dR2M/BPiVAKfeAIxQ6wA1R3lNnLK8X7GPB1CBskthWg/Ce
         goOxa+/3cD6Dg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 02/14] net/mxl5e: Add change profile method
Date:   Mon,  1 Feb 2021 22:54:45 -0800
Message-Id: <20210202065457.613312-3-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Port nic netdevice will be used as uplink representor in downstream
patches. Add change profile method to allow changing a mlx5e netdevice
profile dynamically.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  7 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 68 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 +-
 3 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index bf5de1e79134..fa461cfd6410 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1154,9 +1154,10 @@ int mlx5e_ethtool_set_pauseparam(struct mlx5e_priv *priv,
 				 struct ethtool_pauseparam *pauseparam);
 
 /* mlx5e generic netdev management API */
-static inline unsigned int mlx5e_calc_max_nch(struct mlx5e_priv *priv)
+static inline unsigned int
+mlx5e_calc_max_nch(struct mlx5e_priv *priv, const struct mlx5e_profile *profile)
 {
-	return priv->netdev->num_rx_queues / max_t(u8, priv->profile->rq_groups, 1);
+	return priv->netdev->num_rx_queues / max_t(u8, profile->rq_groups, 1);
 }
 
 int mlx5e_netdev_init(struct net_device *netdev,
@@ -1168,6 +1169,8 @@ mlx5e_create_netdev(struct mlx5_core_dev *mdev, unsigned int txqs, unsigned int
 int mlx5e_attach_netdev(struct mlx5e_priv *priv);
 void mlx5e_detach_netdev(struct mlx5e_priv *priv);
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv);
+int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
+				const struct mlx5e_profile *new_profile, void *new_ppriv);
 void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv);
 void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16 mtu);
 void mlx5e_build_rq_params(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 260ced27014d..91f23871ded5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4936,7 +4936,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 rx_cq_period_mode;
 
-	priv->max_nch = mlx5e_calc_max_nch(priv);
+	priv->max_nch = mlx5e_calc_max_nch(priv, priv->profile);
 
 	params->sw_mtu = mtu;
 	params->hard_mtu = MLX5E_ETH_HARD_MTU;
@@ -5461,6 +5461,8 @@ int mlx5e_netdev_init(struct net_device *netdev,
 		      struct mlx5e_priv *priv,
 		      struct mlx5_core_dev *mdev)
 {
+	memset(priv, 0, sizeof(*priv));
+
 	/* priv init */
 	priv->mdev        = mdev;
 	priv->netdev      = netdev;
@@ -5615,6 +5617,70 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 	cancel_work_sync(&priv->update_stats_work);
 }
 
+static int
+mlx5e_netdev_attach_profile(struct mlx5e_priv *priv,
+			    const struct mlx5e_profile *new_profile, void *new_ppriv)
+{
+	struct net_device *netdev = priv->netdev;
+	struct mlx5_core_dev *mdev = priv->mdev;
+	int err;
+
+	err = mlx5e_netdev_init(netdev, priv, mdev);
+	if (err) {
+		mlx5_core_err(mdev, "mlx5e_netdev_init failed, err=%d\n", err);
+		return err;
+	}
+	priv->profile = new_profile;
+	priv->ppriv = new_ppriv;
+	err = new_profile->init(priv->mdev, priv->netdev);
+	if (err)
+		return err;
+	err = mlx5e_attach_netdev(priv);
+	if (err)
+		new_profile->cleanup(priv);
+	return err;
+}
+
+int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
+				const struct mlx5e_profile *new_profile, void *new_ppriv)
+{
+	unsigned int new_max_nch = mlx5e_calc_max_nch(priv, new_profile);
+	const struct mlx5e_profile *orig_profile = priv->profile;
+	void *orig_ppriv = priv->ppriv;
+	int err, rollback_err;
+
+	/* sanity */
+	if (new_max_nch != priv->max_nch) {
+		netdev_warn(priv->netdev,
+			    "%s: Replacing profile with different max channles\n",
+			    __func__);
+		return -EINVAL;
+	}
+
+	/* cleanup old profile */
+	mlx5e_detach_netdev(priv);
+	priv->profile->cleanup(priv);
+	mlx5e_netdev_cleanup(priv->netdev, priv);
+
+	err = mlx5e_netdev_attach_profile(priv, new_profile, new_ppriv);
+	if (err) { /* roll back to original profile */
+		netdev_warn(priv->netdev, "%s: new profile init failed, %d\n",
+			    __func__, err);
+		goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	rollback_err = mlx5e_netdev_attach_profile(priv, orig_profile, orig_ppriv);
+	if (rollback_err) {
+		netdev_err(priv->netdev,
+			   "%s: failed to rollback to orig profile, %d\n",
+			   __func__, rollback_err);
+	}
+	return err;
+}
+
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv)
 {
 	struct net_device *netdev = priv->netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index d94d2ff9d312..c8a0f4c88d4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -684,7 +684,7 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 					 MLX5_CQ_PERIOD_MODE_START_FROM_CQE :
 					 MLX5_CQ_PERIOD_MODE_START_FROM_EQE;
 
-	priv->max_nch = mlx5e_calc_max_nch(priv);
+	priv->max_nch = mlx5e_calc_max_nch(priv, priv->profile);
 	params = &priv->channels.params;
 
 	params->num_channels = MLX5E_REP_PARAMS_DEF_NUM_CHANNELS;
-- 
2.29.2

