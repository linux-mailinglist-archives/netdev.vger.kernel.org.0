Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CC53650C3
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbhDTDVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229701AbhDTDVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60A2D61360;
        Tue, 20 Apr 2021 03:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888834;
        bh=JOJvgEnkuejZnX4v6elkGWBA9TCNJ0zGUu5E+ZVSvJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2q1U/P9T8+e20G2dQ+TKq3pJRrdwU1OQRo/RezVoyKhWgvsr86BtFa4XpKLcHpkZ
         2p3kCMyUK1qWOP/UrwYZZTCreTpODvYW5mlWDqilq+9sStctEeFjkASuSkUUYRm1Og
         pwQRWtH/n/ARw/t3IsjmqfKfiWbWXSOLydgcVjKLY+q9PqvrIbqbVrLC8QFY6Ot+1M
         Kusdg5tUyuOBgrJODq388ktIplfl+prBYUjLQJ1UfD2eA+10sJ15zbOO6AiE7kWvZo
         jcNPPXTr+t0Trp5aZTw/WQf5cEVkGFliyinYW2YH/Olszaikt09I+uHc+gIQ2miHgu
         ZMbkja2fvzZRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Fix possible non-initialized struct usage
Date:   Mon, 19 Apr 2021 20:20:05 -0700
Message-Id: <20210420032018.58639-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

If mlx5e_devlink_port_register() fails, driver may try to register
devlink health TX and RX reporters on non-registered devlink port.

Instead, create health reporters only if mlx5e_devlink_port_register()
does not fail. And destroy reporters only if devlink_port is registered.

Also, change mlx5e_get_devlink_port() behavior and return NULL in case
port is not registered to replicate devlink's wrapper when ndo is not
implemented.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c |  9 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 10 ++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index 765f3064689d..0dd7615e5931 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -55,12 +55,17 @@ void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv)
 {
 	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
 
-	devlink_port_unregister(dl_port);
+	if (dl_port->registered)
+		devlink_port_unregister(dl_port);
 }
 
 struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct devlink_port *port;
 
-	return mlx5e_devlink_get_dl_port(priv);
+	port = mlx5e_devlink_get_dl_port(priv);
+	if (port->registered)
+		return port;
+	return NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index feb347e81448..bc2d37d2806f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4886,6 +4886,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 			  struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct devlink_port *dl_port;
 	int err;
 
 	mlx5e_build_nic_params(priv, &priv->xsk, netdev->mtu);
@@ -4901,14 +4902,19 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 
-	mlx5e_health_create_reporters(priv);
+	dl_port = mlx5e_devlink_get_dl_port(priv);
+	if (dl_port->registered)
+		mlx5e_health_create_reporters(priv);
 
 	return 0;
 }
 
 static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
-	mlx5e_health_destroy_reporters(priv);
+	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
+
+	if (dl_port->registered)
+		mlx5e_health_destroy_reporters(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 }
-- 
2.30.2

