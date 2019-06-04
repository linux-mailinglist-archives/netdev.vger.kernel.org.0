Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F43491B
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfFDNku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:40:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40093 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbfFDNku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:40:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so11042893wre.7
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zm+97/YOBDSHADkBxIh+YSWqMLd2rn4TP6YwVjEbBDs=;
        b=IqVQDnRX7D038ezA8YK9hXrEm5Mkzg6pmmOMGwbnczuiprDmQkF7L4Ci/5/QrPDfl5
         K1fLgAtdOnKy/oen4V8371p3DT29ztPOtHVJyuvfUk3Nwaxhltm+PHmandKEWuYgoYUQ
         AONSfPeM/2dH6JT98nrBbMJQOgrorpDjWyxgpeWGP5NRNRuVw5Op8czTkNguCSrl0Gn/
         w+7UG2oawIzFsmGgHH3FsuzqHtligtNJcTZq8fbaYTIudmM2GkoYZfurVdN2rvZAC1G2
         2Y9JTE3uwVPnep04fLufuAbJ/AkCWzjXmWRZix/e6M7ntFhRP9Cp1FQTaQ9EUFEMFXpR
         Bn+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zm+97/YOBDSHADkBxIh+YSWqMLd2rn4TP6YwVjEbBDs=;
        b=Ou6lAHVMJ8uisuw8dfqlHFqTvxwZZIqaI2Ls60KtKrmFSxCDnz5NwJLaF6qKS1pqiL
         sGXgkdrgfyrE/akcz82h/9efQxpPmh/Bm5WI0lNH8GAdXiNbIkJgA7CNSw0PkEdApOgE
         CmQVHTnAKNvs5ZrmjSI8QX5rqjBzBcWs3ICfmz8G9Ws/fUbpEZnQSnZ/zFdqt57Bi68o
         qlPNtH63ucyo5U1MGRFW4J0eW0rdP2vXPmGYHtow9ZufQ6FqrFhp210nj8mrjBWpjluI
         vMJyLi47NpUMvr5+4GZoAVRkyKmtCOEdirvwA0N+I7F0zCkPVzCJty9aOhcVa6YyOini
         DIAA==
X-Gm-Message-State: APjAAAW5oGqPRQ40+yzXANue41N/4RTVV6GJpC8d+KaZu0fIo/lGhxgj
        oNNyMH2rizYyfZrSjxE6hfJd/m+WW2AFYVuX
X-Google-Smtp-Source: APXvYqwMQ3W61dp+jI6Gf89hC0z5A7MoBeJ4ey5r3YYKp/rmW58jvtRhFKTGKfcwgH7T9fVZm5q4wA==
X-Received: by 2002:adf:e34e:: with SMTP id n14mr1195024wrj.169.1559655647853;
        Tue, 04 Jun 2019 06:40:47 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id o6sm12245578wmc.15.2019.06.04.06.40.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:40:47 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 2/8] mlx5: Move firmware flash implementation to devlink
Date:   Tue,  4 Jun 2019 15:40:38 +0200
Message-Id: <20190604134044.2613-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Benefit from the devlink flash update implementation and ethtool
fallback to it and move firmware flash implementation there.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 --
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 35 -------------------
 .../mellanox/mlx5/core/ipoib/ethtool.c        |  9 -----
 .../net/ethernet/mellanox/mlx5/core/main.c    | 20 +++++++++++
 4 files changed, 20 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 3a183d690e23..4e417dfe4ee5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1074,8 +1074,6 @@ u32 mlx5e_ethtool_get_rxfh_key_size(struct mlx5e_priv *priv);
 u32 mlx5e_ethtool_get_rxfh_indir_size(struct mlx5e_priv *priv);
 int mlx5e_ethtool_get_ts_info(struct mlx5e_priv *priv,
 			      struct ethtool_ts_info *info);
-int mlx5e_ethtool_flash_device(struct mlx5e_priv *priv,
-			       struct ethtool_flash *flash);
 void mlx5e_ethtool_get_pauseparam(struct mlx5e_priv *priv,
 				  struct ethtool_pauseparam *pauseparam);
 int mlx5e_ethtool_set_pauseparam(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index dd764e0471f2..ea59097dd4f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1867,40 +1867,6 @@ static u32 mlx5e_get_priv_flags(struct net_device *netdev)
 	return priv->channels.params.pflags;
 }
 
-int mlx5e_ethtool_flash_device(struct mlx5e_priv *priv,
-			       struct ethtool_flash *flash)
-{
-	struct mlx5_core_dev *mdev = priv->mdev;
-	struct net_device *dev = priv->netdev;
-	const struct firmware *fw;
-	int err;
-
-	if (flash->region != ETHTOOL_FLASH_ALL_REGIONS)
-		return -EOPNOTSUPP;
-
-	err = request_firmware_direct(&fw, flash->data, &dev->dev);
-	if (err)
-		return err;
-
-	dev_hold(dev);
-	rtnl_unlock();
-
-	err = mlx5_firmware_flash(mdev, fw);
-	release_firmware(fw);
-
-	rtnl_lock();
-	dev_put(dev);
-	return err;
-}
-
-static int mlx5e_flash_device(struct net_device *dev,
-			      struct ethtool_flash *flash)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
-	return mlx5e_ethtool_flash_device(priv, flash);
-}
-
 #ifndef CONFIG_MLX5_EN_RXNFC
 /* When CONFIG_MLX5_EN_RXNFC=n we only support ETHTOOL_GRXRINGS
  * otherwise this function will be defined from en_fs_ethtool.c
@@ -1939,7 +1905,6 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 #ifdef CONFIG_MLX5_EN_RXNFC
 	.set_rxnfc         = mlx5e_set_rxnfc,
 #endif
-	.flash_device      = mlx5e_flash_device,
 	.get_tunable       = mlx5e_get_tunable,
 	.set_tunable       = mlx5e_set_tunable,
 	.get_pauseparam    = mlx5e_get_pauseparam,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 90cb50fe17fd..ebd81f6b556e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -122,14 +122,6 @@ static int mlx5i_get_ts_info(struct net_device *netdev,
 	return mlx5e_ethtool_get_ts_info(priv, info);
 }
 
-static int mlx5i_flash_device(struct net_device *netdev,
-			      struct ethtool_flash *flash)
-{
-	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
-
-	return mlx5e_ethtool_flash_device(priv, flash);
-}
-
 enum mlx5_ptys_width {
 	MLX5_PTYS_WIDTH_1X	= 1 << 0,
 	MLX5_PTYS_WIDTH_2X	= 1 << 1,
@@ -241,7 +233,6 @@ const struct ethtool_ops mlx5i_ethtool_ops = {
 	.get_ethtool_stats  = mlx5i_get_ethtool_stats,
 	.get_ringparam      = mlx5i_get_ringparam,
 	.set_ringparam      = mlx5i_set_ringparam,
-	.flash_device       = mlx5i_flash_device,
 	.get_channels       = mlx5i_get_channels,
 	.set_channels       = mlx5i_set_channels,
 	.get_coalesce       = mlx5i_get_coalesce,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index b27f9537256c..2fc2162901de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1214,6 +1214,25 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 	return err;
 }
 
+static int mlx5_devlink_flash_update(struct devlink *devlink,
+				     const char *file_name,
+				     const char *component,
+				     struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	const struct firmware *fw;
+	int err;
+
+	if (component)
+		return -EOPNOTSUPP;
+
+	err = request_firmware_direct(&fw, file_name, &dev->pdev->dev);
+	if (err)
+		return err;
+
+	return mlx5_firmware_flash(dev, fw);
+}
+
 static const struct devlink_ops mlx5_devlink_ops = {
 #ifdef CONFIG_MLX5_ESWITCH
 	.eswitch_mode_set = mlx5_devlink_eswitch_mode_set,
@@ -1223,6 +1242,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.eswitch_encap_mode_set = mlx5_devlink_eswitch_encap_mode_set,
 	.eswitch_encap_mode_get = mlx5_devlink_eswitch_encap_mode_get,
 #endif
+	.flash_update = mlx5_devlink_flash_update,
 };
 
 static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
-- 
2.17.2

