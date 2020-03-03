Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F9F177886
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgCCOND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:13:03 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34900 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728849AbgCCOND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:13:03 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Mar 2020 16:12:58 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 023ECqq5022152;
        Tue, 3 Mar 2020 16:12:56 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     parav@mellanox.com, jiri@mellanox.com, moshe@mellanox.com,
        vladyslavt@mellanox.com, saeedm@mellanox.com, leon@kernel.org
Subject: [PATCH net-next 2/2] net/mlx5e: Use devlink virtual flavour for VF devlink port
Date:   Tue,  3 Mar 2020 08:12:43 -0600
Message-Id: <20200303141243.7608-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200303141243.7608-1-parav@mellanox.com>
References: <20200303141243.7608-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use newly introduce 'virtual' port flavour for devlink
port of PCI VF devlink device in non-representors mode.

While at it, remove recently introduced empty lines at end of the file.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 39 +++++++++++--------
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |  7 ++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  6 +--
 4 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a516dfab6d53..02b91aa896b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -880,7 +880,7 @@ struct mlx5e_priv {
 #endif
 	struct devlink_health_reporter *tx_reporter;
 	struct devlink_health_reporter *rx_reporter;
-	struct devlink_port             dl_phy_port;
+	struct devlink_port            dl_port;
 	struct mlx5e_xsk           xsk;
 #if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
 	struct mlx5e_hv_vhca_stats_agent stats_agent;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index 1a87a3fc6b44..e38495e4aa42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -3,36 +3,43 @@
 
 #include "en/devlink.h"
 
-int mlx5e_devlink_phy_port_register(struct net_device *dev)
+int mlx5e_devlink_port_register(struct net_device *netdev)
 {
+	struct mlx5_core_dev *dev;
 	struct mlx5e_priv *priv;
 	struct devlink *devlink;
 	int err;
 
-	priv = netdev_priv(dev);
-	devlink = priv_to_devlink(priv->mdev);
-
-	devlink_port_attrs_set(&priv->dl_phy_port,
-			       DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       PCI_FUNC(priv->mdev->pdev->devfn),
-			       false, 0,
-			       NULL, 0);
-	err = devlink_port_register(devlink, &priv->dl_phy_port, 1);
+	priv = netdev_priv(netdev);
+	dev = priv->mdev;
+
+	if (mlx5_core_is_pf(dev))
+		devlink_port_attrs_set(&priv->dl_port,
+				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
+				       PCI_FUNC(dev->pdev->devfn),
+				       false, 0,
+				       NULL, 0);
+	else
+		devlink_port_attrs_set(&priv->dl_port,
+				       DEVLINK_PORT_FLAVOUR_VIRTUAL,
+				       0, false, 0, NULL, 0);
+
+	devlink = priv_to_devlink(dev);
+	err = devlink_port_register(devlink, &priv->dl_port, 1);
 	if (err)
 		return err;
-	devlink_port_type_eth_set(&priv->dl_phy_port, dev);
+	devlink_port_type_eth_set(&priv->dl_port, netdev);
 	return 0;
 }
 
-void mlx5e_devlink_phy_port_unregister(struct mlx5e_priv *priv)
+void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv)
 {
-	devlink_port_unregister(&priv->dl_phy_port);
+	devlink_port_unregister(&priv->dl_port);
 }
 
-struct devlink_port *mlx5e_get_devlink_phy_port(struct net_device *dev)
+struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
-	return &priv->dl_phy_port;
+	return &priv->dl_port;
 }
-
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
index b8cd63b88688..3e5393a0901f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -7,9 +7,8 @@
 #include <net/devlink.h>
 #include "en.h"
 
-int mlx5e_devlink_phy_port_register(struct net_device *dev);
-void mlx5e_devlink_phy_port_unregister(struct mlx5e_priv *priv);
-struct devlink_port *mlx5e_get_devlink_phy_port(struct net_device *dev);
+int mlx5e_devlink_port_register(struct net_device *dev);
+void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv);
+struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev);
 
 #endif
-
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8236f655a737..f9c928afec89 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4606,7 +4606,7 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_set_vf_link_state   = mlx5e_set_vf_link_state,
 	.ndo_get_vf_stats        = mlx5e_get_vf_stats,
 #endif
-	.ndo_get_devlink_port    = mlx5e_get_devlink_phy_port,
+	.ndo_get_devlink_port    = mlx5e_get_devlink_port,
 };
 
 static int mlx5e_check_required_hca_cap(struct mlx5_core_dev *mdev)
@@ -5473,7 +5473,7 @@ static void *mlx5e_add(struct mlx5_core_dev *mdev)
 		goto err_detach;
 	}
 
-	err = mlx5e_devlink_phy_port_register(netdev);
+	err = mlx5e_devlink_port_register(netdev);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_devlink_phy_port_register failed, %d\n", err);
 		goto err_unregister_netdev;
@@ -5507,7 +5507,7 @@ static void mlx5e_remove(struct mlx5_core_dev *mdev, void *vpriv)
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_delete_app(priv);
 #endif
-	mlx5e_devlink_phy_port_unregister(priv);
+	mlx5e_devlink_port_unregister(priv);
 	unregister_netdev(priv->netdev);
 	mlx5e_detach(mdev, vpriv);
 	mlx5e_destroy_netdev(priv);
-- 
2.19.2

