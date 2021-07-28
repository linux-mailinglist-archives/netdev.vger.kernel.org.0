Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5CE3D88E1
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhG1Hd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232691AbhG1Hd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 03:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8B260F91;
        Wed, 28 Jul 2021 07:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627457636;
        bh=qEIP9EMMooCYDvfOHXR2wOSBTARlE2P1jy8qqISxB2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmXxfkp1sycdMXR1RejISQ9xtB82lfxh2gPIVXv3an8KntsTCTuSQuhdnxFd1NQ0g
         w9VuoSKEx5Ty7BuV9zUMkqui8HukXPW/LUIKfwlZNfQWUTl/ihiCwSvP0aysTsBSxN
         q0RtcwLxDNZp+U4E77QePEAHsmHY9QKr5ztqUZQ2UfRYzgzgqKp93alReEzJJJOrSL
         m+8KFXms2rpkb3d6M1uCGcq/pjc21CV3KE+sUlEp5/NU68Z3A1mIyZGuodKtiZwE2Q
         rbGO8aFZslVBZxxEOEoYzWOGS0ocs9U5SxuvxMCnQ3y7C4GcBwv2jJMoGmdnMOMKr+
         1bl1aWWJPVQ9Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH net-next v1 2/3] net/mlx5: Don't rely on always true registered field
Date:   Wed, 28 Jul 2021 10:33:46 +0300
Message-Id: <0cb2984846c406fc6485a212282e92f549b77fda.1627456849.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627456849.git.leonro@nvidia.com>
References: <cover.1627456849.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devlink is an integral part of mlx5 driver and all flows ensure that
devlink_*_register() will success. That makes the ->registered check
an obsolete.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c | 10 +++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 11 ++---------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index bc33eaada3b9..86e079310ac3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -55,19 +55,15 @@ void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv)
 {
 	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
 
-	if (dl_port->registered)
-		devlink_port_unregister(dl_port);
+	devlink_port_unregister(dl_port);
 }
 
 struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct devlink_port *port;
 
 	if (!netif_device_present(dev))
 		return NULL;
-	port = mlx5e_devlink_get_dl_port(priv);
-	if (port->registered)
-		return port;
-	return NULL;
+
+	return mlx5e_devlink_get_dl_port(priv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 308ccace48d0..adcca0b3b7bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4933,7 +4933,6 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 			  struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct devlink_port *dl_port;
 	int err;
 
 	mlx5e_build_nic_params(priv, &priv->xsk, netdev->mtu);
@@ -4949,19 +4948,13 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 
-	dl_port = mlx5e_devlink_get_dl_port(priv);
-	if (dl_port->registered)
-		mlx5e_health_create_reporters(priv);
-
+	mlx5e_health_create_reporters(priv);
 	return 0;
 }
 
 static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
-	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
-
-	if (dl_port->registered)
-		mlx5e_health_destroy_reporters(priv);
+	mlx5e_health_destroy_reporters(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 }
-- 
2.31.1

