Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E06321275C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgGBPJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:09:19 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39758 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730073AbgGBPJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:09:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 2 Jul 2020 18:09:10 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 062F9AS6020276;
        Thu, 2 Jul 2020 18:09:10 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 062F9A5g015417;
        Thu, 2 Jul 2020 18:09:10 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 062F99nL015416;
        Thu, 2 Jul 2020 18:09:09 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH net-next 7/7] net/mlx5e: Move devlink-health rx and tx reporters to devlink port
Date:   Thu,  2 Jul 2020 18:08:13 +0300
Message-Id: <1593702493-15323-8-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1593702493-15323-1-git-send-email-moshe@mellanox.com>
References: <1593702493-15323-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Utilize new devlink-health port reporters API to move rx and tx
reporters from device to port.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c |  9 +++------
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 13 ++++---------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index c209579..35df79d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -565,13 +565,10 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
 
 int mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
 {
-	struct devlink *devlink = priv_to_devlink(priv->mdev);
 	struct devlink_health_reporter *reporter;
 
-	reporter = devlink_health_reporter_create(devlink,
-						  &mlx5_rx_reporter_ops,
-						  MLX5E_REPORTER_RX_GRACEFUL_PERIOD,
-						  priv);
+	reporter = devlink_port_health_reporter_create(&priv->dl_port, &mlx5_rx_reporter_ops,
+						       MLX5E_REPORTER_RX_GRACEFUL_PERIOD, priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev, "Failed to create rx reporter, err = %ld\n",
 			    PTR_ERR(reporter));
@@ -586,5 +583,5 @@ void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv)
 	if (!priv->rx_reporter)
 		return;
 
-	devlink_health_reporter_destroy(priv->rx_reporter);
+	devlink_port_health_reporter_destroy(priv->rx_reporter);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 9805fc0..917aef9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -409,14 +409,9 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 int mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 {
 	struct devlink_health_reporter *reporter;
-	struct mlx5_core_dev *mdev = priv->mdev;
-	struct devlink *devlink;
-
-	devlink = priv_to_devlink(mdev);
-	reporter =
-		devlink_health_reporter_create(devlink, &mlx5_tx_reporter_ops,
-					       MLX5_REPORTER_TX_GRACEFUL_PERIOD,
-					       priv);
+
+	reporter = devlink_port_health_reporter_create(&priv->dl_port, &mlx5_tx_reporter_ops,
+						       MLX5_REPORTER_TX_GRACEFUL_PERIOD, priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev,
 			    "Failed to create tx reporter, err = %ld\n",
@@ -432,5 +427,5 @@ void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv)
 	if (!priv->tx_reporter)
 		return;
 
-	devlink_health_reporter_destroy(priv->tx_reporter);
+	devlink_port_health_reporter_destroy(priv->tx_reporter);
 }
-- 
1.8.3.1

