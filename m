Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E734B21B504
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGJM0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:26:32 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51800 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727899AbgGJMZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:25:55 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 10 Jul 2020 15:25:49 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06ACPnIQ012404;
        Fri, 10 Jul 2020 15:25:49 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 06ACPnhw003380;
        Fri, 10 Jul 2020 15:25:49 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 06ACPnBx003379;
        Fri, 10 Jul 2020 15:25:49 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH net-next v3 6/7] net/mlx5e: Move devlink port register and unregister calls
Date:   Fri, 10 Jul 2020 15:25:12 +0300
Message-Id: <1594383913-3295-7-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1594383913-3295-1-git-send-email-moshe@mellanox.com>
References: <1594383913-3295-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Register devlink ports upon NIC init. TX and RX health reporters handle
errors which may occur early on at driver initialization. And because
these reporters are to be moved to port context, they require devlink
ports to be already registered.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b04c857..e054726 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5086,6 +5086,9 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 	mlx5e_build_nic_netdev(netdev);
+	err = mlx5e_devlink_port_register(priv);
+	if (err)
+		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
 	mlx5e_health_create_reporters(priv);
 
 	return 0;
@@ -5094,6 +5097,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
 	mlx5e_health_destroy_reporters(priv);
+	mlx5e_devlink_port_unregister(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 	mlx5e_netdev_cleanup(priv->netdev, priv);
@@ -5526,16 +5530,10 @@ static void *mlx5e_add(struct mlx5_core_dev *mdev)
 		goto err_destroy_netdev;
 	}
 
-	err = mlx5e_devlink_port_register(priv);
-	if (err) {
-		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
-		goto err_detach;
-	}
-
 	err = register_netdev(netdev);
 	if (err) {
 		mlx5_core_err(mdev, "register_netdev failed, %d\n", err);
-		goto err_devlink_port_unregister;
+		goto err_detach;
 	}
 
 	mlx5e_devlink_port_type_eth_set(priv);
@@ -5543,8 +5541,6 @@ static void *mlx5e_add(struct mlx5_core_dev *mdev)
 	mlx5e_dcbnl_init_app(priv);
 	return priv;
 
-err_devlink_port_unregister:
-	mlx5e_devlink_port_unregister(priv);
 err_detach:
 	mlx5e_detach(mdev, priv);
 err_destroy_netdev:
@@ -5565,7 +5561,6 @@ static void mlx5e_remove(struct mlx5_core_dev *mdev, void *vpriv)
 	priv = vpriv;
 	mlx5e_dcbnl_delete_app(priv);
 	unregister_netdev(priv->netdev);
-	mlx5e_devlink_port_unregister(priv);
 	mlx5e_detach(mdev, vpriv);
 	mlx5e_destroy_netdev(priv);
 }
-- 
1.8.3.1

