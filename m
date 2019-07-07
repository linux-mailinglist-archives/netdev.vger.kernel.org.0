Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8B6614BE
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGGLx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58843 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726358AbfGGLx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:26 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJLq031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 03/16] net/mlx5e: Set tx reporter only on successful creation
Date:   Sun,  7 Jul 2019 14:52:55 +0300
Message-Id: <1562500388-16847-4-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When failing to create tx reporter, don't set the reporter's pointer.
Creating a reporter is not mandatory for driver load, avoid
garbage/error pointer.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/reporter_tx.c  | 19 +++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     |  2 +-
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index b2bc8d8ca80e..259811811e06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -117,7 +117,7 @@ static int mlx5_tx_health_report(struct devlink_health_reporter *tx_reporter,
 				 char *err_str,
 				 struct mlx5e_tx_err_ctx *err_ctx)
 {
-	if (IS_ERR_OR_NULL(tx_reporter)) {
+	if (!tx_reporter) {
 		netdev_err(err_ctx->sq->channel->netdev, err_str);
 		return err_ctx->recover(err_ctx->sq);
 	}
@@ -291,23 +291,26 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 
 int mlx5e_tx_reporter_create(struct mlx5e_priv *priv)
 {
+	struct devlink_health_reporter *reporter;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct devlink *devlink = priv_to_devlink(mdev);
 
-	priv->tx_reporter =
+	reporter =
 		devlink_health_reporter_create(devlink, &mlx5_tx_reporter_ops,
 					       MLX5_REPORTER_TX_GRACEFUL_PERIOD,
 					       true, priv);
-	if (IS_ERR(priv->tx_reporter))
-		netdev_warn(priv->netdev,
-			    "Failed to create tx reporter, err = %ld\n",
-			    PTR_ERR(priv->tx_reporter));
-	return PTR_ERR_OR_ZERO(priv->tx_reporter);
+	if (IS_ERR(reporter))
+		netdev_warn(priv->netdev, "Failed to create tx reporter, err = %ld\n",
+			    PTR_ERR(reporter));
+	else
+		priv->tx_reporter = reporter;
+
+	return PTR_ERR_OR_ZERO(reporter);
 }
 
 void mlx5e_tx_reporter_destroy(struct mlx5e_priv *priv)
 {
-	if (IS_ERR_OR_NULL(priv->tx_reporter))
+	if (!priv->tx_reporter)
 		return;
 
 	devlink_health_reporter_destroy(priv->tx_reporter);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 83194d56434d..c5f11a05c34b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2320,7 +2320,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 			goto err_close_channels;
 	}
 
-	if (!IS_ERR_OR_NULL(priv->tx_reporter))
+	if (priv->tx_reporter)
 		devlink_health_reporter_state_update(priv->tx_reporter,
 						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
 
-- 
1.8.3.1

