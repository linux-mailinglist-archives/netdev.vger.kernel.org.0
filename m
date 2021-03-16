Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E6F33E26A
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCPXvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhCPXvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9760964F9C;
        Tue, 16 Mar 2021 23:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938681;
        bh=sLXdFxRmNcDJ85g5jYcL2k2EK2jVvesElPBD/wigtdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVaIdDwCe8T5WP5NYXE+StFBgFwrA/PSfXh3NgEPeZ6CsCg48Gswo9x1P3Ni6QUrR
         zvuEtgH99TVrcxB/M1I/U0iCWBMjC5Gnx86djxX/8dxchQmoOWQ+F2b/wbvWqaUgBI
         z6Ej8xsE5vEQIHCP8fQKRR+uU6lRJYs1AidigylYxLWBGbofO98zKJ+YkSU9kxF2FI
         nAne2e2NiFGjX47E2tTLfHVUau+OkJQztsJ3NTCZShP4ZWqnCUwEXjKbQLURhZJECW
         SrzcuB2i1JreSvxLV5pwQxGkbMuJ1/j+oySN/I+YTLGNGF5HhXwrDZfhm+Yu0PJkYp
         kWwUr3NFP0Qmg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Do not reload ethernet ports when changing eswitch mode
Date:   Tue, 16 Mar 2021 16:51:10 -0700
Message-Id: <20210316235112.72626-14-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

When switching modes between legacy and switchdev and back, do not
reload ethernet interfaces. just change the profile from nic profile
to uplink rep profile in switchdev mode.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |   1 +
 .../mellanox/mlx5/core/en/reporter_tx.c       |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   6 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 148 ++++++++++++------
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |   9 ++
 include/linux/mlx5/driver.h                   |   1 +
 8 files changed, 116 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index b051417ede67..4def64d0e669 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -58,9 +58,6 @@ static bool is_eth_supported(struct mlx5_core_dev *dev)
 	if (!IS_ENABLED(CONFIG_MLX5_CORE_EN))
 		return false;
 
-	if (is_eth_rep_supported(dev))
-		return false;
-
 	if (MLX5_CAP_GEN(dev, port_type) != MLX5_CAP_PORT_TYPE_ETH)
 		return false;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4d621d142f76..1f5bc4d91060 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1173,6 +1173,7 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv);
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv);
 int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
 				const struct mlx5e_profile *new_profile, void *new_ppriv);
+void mlx5e_netdev_attach_nic_profile(struct mlx5e_priv *priv);
 void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv);
 void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16 mtu);
 void mlx5e_build_rq_params(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index f0a419fc4adf..34b3b316b688 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -635,4 +635,5 @@ void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv)
 		return;
 
 	devlink_port_health_reporter_destroy(priv->rx_reporter);
+	priv->rx_reporter = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index db64fa2620c4..63ee3b9416de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -593,4 +593,5 @@ void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv)
 		return;
 
 	devlink_port_health_reporter_destroy(priv->tx_reporter);
+	priv->tx_reporter = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 685cf071a9de..9c08f0bd1fcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5742,6 +5742,11 @@ int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
 	return err;
 }
 
+void mlx5e_netdev_attach_nic_profile(struct mlx5e_priv *priv)
+{
+	mlx5e_netdev_change_profile(priv, &mlx5e_nic_profile, NULL);
+}
+
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv)
 {
 	struct net_device *netdev = priv->netdev;
@@ -5852,6 +5857,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	mlx5e_devlink_port_type_eth_set(priv);
 
 	mlx5e_dcbnl_init_app(priv);
+	mlx5_uplink_netdev_set(mdev, netdev);
 	return 0;
 
 err_resume:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 9533085005c3..4cc902e0d71b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -44,6 +44,7 @@
 #include "en_tc.h"
 #include "en/rep/tc.h"
 #include "en/rep/neigh.h"
+#include "en/devlink.h"
 #include "fs_core.h"
 #include "lib/mlx5.h"
 #define CREATE_TRACE_POINTS
@@ -588,26 +589,15 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 }
 
 static void mlx5e_build_rep_netdev(struct net_device *netdev,
-				   struct mlx5_core_dev *mdev,
-				   struct mlx5_eswitch_rep *rep)
+				   struct mlx5_core_dev *mdev)
 {
 	SET_NETDEV_DEV(netdev, mdev->device);
-	if (rep->vport == MLX5_VPORT_UPLINK) {
-		netdev->netdev_ops = &mlx5e_netdev_ops;
-		/* we want a persistent mac for the uplink rep */
-		mlx5_query_mac_address(mdev, netdev->dev_addr);
-		netdev->ethtool_ops = &mlx5e_ethtool_ops;
-		mlx5e_dcbnl_build_rep_netdev(netdev);
-	} else {
-		netdev->netdev_ops = &mlx5e_netdev_ops_rep;
-		eth_hw_addr_random(netdev);
-		netdev->ethtool_ops = &mlx5e_rep_ethtool_ops;
-	}
+	netdev->netdev_ops = &mlx5e_netdev_ops_rep;
+	eth_hw_addr_random(netdev);
+	netdev->ethtool_ops = &mlx5e_rep_ethtool_ops;
 
 	netdev->watchdog_timeo    = 15 * HZ;
 
-	netdev->features       |= NETIF_F_NETNS_LOCAL;
-
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	netdev->hw_features    |= NETIF_F_HW_TC;
 #endif
@@ -619,12 +609,9 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 	netdev->hw_features    |= NETIF_F_TSO6;
 	netdev->hw_features    |= NETIF_F_RXCSUM;
 
-	if (rep->vport == MLX5_VPORT_UPLINK)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
-	else
-		netdev->features |= NETIF_F_VLAN_CHALLENGED;
-
 	netdev->features |= netdev->hw_features;
+	netdev->features |= NETIF_F_VLAN_CHALLENGED;
+	netdev->features |= NETIF_F_NETNS_LOCAL;
 }
 
 static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
@@ -990,6 +977,14 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	mlx5e_dcbnl_initialize(priv);
 	mlx5e_dcbnl_init_app(priv);
 	mlx5e_rep_neigh_init(rpriv);
+
+	netdev->wanted_features |= NETIF_F_HW_TC;
+
+	rtnl_lock();
+	if (netif_running(netdev))
+		mlx5e_open(netdev);
+	netif_device_attach(netdev);
+	rtnl_unlock();
 }
 
 static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
@@ -997,6 +992,12 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
+	rtnl_lock();
+	if (netif_running(priv->netdev))
+		mlx5e_close(priv->netdev);
+	netif_device_detach(priv->netdev);
+	rtnl_unlock();
+
 	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_dcbnl_delete_app(priv);
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
@@ -1081,26 +1082,56 @@ static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
 
 /* e-Switch vport representors */
 static int
-mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
+mlx5e_vport_uplink_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
+{
+	struct mlx5e_priv *priv = netdev_priv(mlx5_uplink_netdev_get(dev));
+	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
+	struct devlink_port *dl_port;
+	int err;
+
+	rpriv->netdev = priv->netdev;
+
+	err = mlx5e_netdev_change_profile(priv, &mlx5e_uplink_rep_profile,
+					  rpriv);
+	if (err)
+		return err;
+
+	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
+	if (dl_port)
+		devlink_port_type_eth_set(dl_port, rpriv->netdev);
+
+	return 0;
+}
+
+static void
+mlx5e_vport_uplink_rep_unload(struct mlx5e_rep_priv *rpriv)
+{
+	struct net_device *netdev = rpriv->netdev;
+	struct devlink_port *dl_port;
+	struct mlx5_core_dev *dev;
+	struct mlx5e_priv *priv;
+
+	priv = netdev_priv(netdev);
+	dev = priv->mdev;
+
+	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
+	if (dl_port)
+		devlink_port_type_clear(dl_port);
+	mlx5e_netdev_attach_nic_profile(priv);
+}
+
+static int
+mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
+	struct mlx5e_rep_priv *rpriv = mlx5e_rep_to_rep_priv(rep);
 	const struct mlx5e_profile *profile;
-	struct mlx5e_rep_priv *rpriv;
 	struct devlink_port *dl_port;
 	struct net_device *netdev;
 	struct mlx5e_priv *priv;
 	unsigned int txqs, rxqs;
 	int nch, err;
 
-	rpriv = kzalloc(sizeof(*rpriv), GFP_KERNEL);
-	if (!rpriv)
-		return -ENOMEM;
-
-	/* rpriv->rep to be looked up when profile->init() is called */
-	rpriv->rep = rep;
-
-	profile = (rep->vport == MLX5_VPORT_UPLINK) ?
-		  &mlx5e_uplink_rep_profile : &mlx5e_rep_profile;
-
+	profile = &mlx5e_rep_profile;
 	nch = mlx5e_get_max_num_channels(dev);
 	txqs = nch * profile->max_tc;
 	rxqs = nch * profile->rq_groups;
@@ -1109,21 +1140,11 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		mlx5_core_warn(dev,
 			       "Failed to create representor netdev for vport %d\n",
 			       rep->vport);
-		kfree(rpriv);
 		return -EINVAL;
 	}
 
-	mlx5e_build_rep_netdev(netdev, dev, rep);
-
+	mlx5e_build_rep_netdev(netdev, dev);
 	rpriv->netdev = netdev;
-	rep->rep_data[REP_ETH].priv = rpriv;
-	INIT_LIST_HEAD(&rpriv->vport_sqs_list);
-
-	if (rep->vport == MLX5_VPORT_UPLINK) {
-		err = mlx5e_create_mdev_resources(dev);
-		if (err)
-			goto err_destroy_netdev;
-	}
 
 	priv = netdev_priv(netdev);
 	priv->profile = profile;
@@ -1131,7 +1152,7 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	err = profile->init(dev, netdev);
 	if (err) {
 		netdev_warn(netdev, "rep profile init failed, %d\n", err);
-		goto err_destroy_mdev_resources;
+		goto err_destroy_netdev;
 	}
 
 	err = mlx5e_attach_netdev(netdev_priv(netdev));
@@ -1161,13 +1182,34 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 err_cleanup_profile:
 	priv->profile->cleanup(priv);
 
-err_destroy_mdev_resources:
-	if (rep->vport == MLX5_VPORT_UPLINK)
-		mlx5e_destroy_mdev_resources(dev);
-
 err_destroy_netdev:
 	mlx5e_destroy_netdev(netdev_priv(netdev));
-	kfree(rpriv);
+	return err;
+}
+
+static int
+mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
+{
+	struct mlx5e_rep_priv *rpriv;
+	int err;
+
+	rpriv = kzalloc(sizeof(*rpriv), GFP_KERNEL);
+	if (!rpriv)
+		return -ENOMEM;
+
+	/* rpriv->rep to be looked up when profile->init() is called */
+	rpriv->rep = rep;
+	rep->rep_data[REP_ETH].priv = rpriv;
+	INIT_LIST_HEAD(&rpriv->vport_sqs_list);
+
+	if (rep->vport == MLX5_VPORT_UPLINK)
+		err = mlx5e_vport_uplink_rep_load(dev, rep);
+	else
+		err = mlx5e_vport_vf_rep_load(dev, rep);
+
+	if (err)
+		kfree(rpriv);
+
 	return err;
 }
 
@@ -1181,15 +1223,19 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	struct devlink_port *dl_port;
 	void *ppriv = priv->ppriv;
 
+	if (rep->vport == MLX5_VPORT_UPLINK) {
+		mlx5e_vport_uplink_rep_unload(rpriv);
+		goto free_ppriv;
+	}
+
 	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
 	if (dl_port)
 		devlink_port_type_clear(dl_port);
 	unregister_netdev(netdev);
 	mlx5e_detach_netdev(priv);
 	priv->profile->cleanup(priv);
-	if (rep->vport == MLX5_VPORT_UPLINK)
-		mlx5e_destroy_mdev_resources(priv->mdev);
 	mlx5e_destroy_netdev(priv);
+free_ppriv:
 	kfree(ppriv); /* mlx5e_rep_priv */
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index d046db7bb047..2f536c5d30b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -95,4 +95,13 @@ static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 	return devlink_net(priv_to_devlink(dev));
 }
 
+static inline void mlx5_uplink_netdev_set(struct mlx5_core_dev *mdev, struct net_device *netdev)
+{
+	mdev->mlx5e_res.uplink_netdev = netdev;
+}
+
+static inline struct net_device *mlx5_uplink_netdev_get(struct mlx5_core_dev *mdev)
+{
+	return mdev->mlx5e_res.uplink_netdev;
+}
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f1d0340e46a7..23bb01d7c9b9 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -651,6 +651,7 @@ struct mlx5e_resources {
 		struct mlx5_sq_bfreg       bfreg;
 	} hw_objs;
 	struct devlink_port dl_port;
+	struct net_device *uplink_netdev;
 };
 
 enum mlx5_sw_icm_type {
-- 
2.30.2

