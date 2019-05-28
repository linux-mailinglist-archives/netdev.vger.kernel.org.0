Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A63B2C5B1
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfE1Lsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:48:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50466 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbfE1Lsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:48:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id f204so2576654wme.0
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8MdLvVGbc73dXdliijtD2+ZfQny/qiSnNWd52ToFvVI=;
        b=Usrdnoy3O1rn13ARmGAf0hhKoJk0eYQhicakldtOE53B2feq/TVogbqjLjLhcFc8ue
         6lXar2jMcR4JKcMfxWPFuUJqlRZn32vYDigSIyre0xeXN0H1rZAJ2Zc2TIT+98ZZeAW6
         UCKAOVioy7e/5i6JCnm82MGWZeTAEse5jreTYdqgZ6nYCYMFzQ0oTIwGBjb+HHVgRYXX
         7CoL9Wq2wmcKTr8LJuTlt1mek6HYwgN8EvL7mNgepPL7ViZlgBDPIUU87cJMQ9ub6EZc
         tmmeRD4Ap0e4Tcah7wyAihRAz/M+dSRT+J8rzRTY5Vw2TtfZcG4IcpFfzIolcsVt8a/q
         yfUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8MdLvVGbc73dXdliijtD2+ZfQny/qiSnNWd52ToFvVI=;
        b=VeHfrUX4ZTPN/aCeUgpOR8vhVZ36s+UO+khsL2PJrDKZ99VUJp3VlhBubxOUFJEIPo
         xrQsHznydXqI2l//3V2lsELL2RIr38hi95sZPzAbanLKLnae911xKNeGWLF52BzKZKbk
         nWUynN5d6+frFaUI1vPg5Z3Qn4K5JtN0b7/Wx4o2HlrloEEyDoz15Z5IADOQCoglpyPG
         dF+pY3OyxatcCXMir2mpNaR/RFd4guYpb74XN4WR0crTR1qEu0FahxlJZz+yyfNPWqXd
         l5g2uxgh//mpH82qVUndsX1PMZKh8G//M/LRp5L4KCoTlFrx2bN5xW8vu9IOgURT87Ta
         WAOg==
X-Gm-Message-State: APjAAAW2FXHHE0oAR+W1IXywNkffL15UpH/HUTU4JIkDpscqfxE3VWzP
        Zpt4lzt2FzruKVP8MtrYcaMYeTWU5kY=
X-Google-Smtp-Source: APXvYqwZsnwL6Rzj9c+JgSS82bAX/ZXNSg2vkU6YWOnjj9Mkp75wqOP8s3xNjkgf7hnPyXjLCE5JDw==
X-Received: by 2002:a1c:7314:: with SMTP id d20mr2901298wmb.53.1559044129037;
        Tue, 28 May 2019 04:48:49 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id f10sm27740312wrg.24.2019.05.28.04.48.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 04:48:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v2 2/7] mlx5: Move firmware flash implementation to devlink
Date:   Tue, 28 May 2019 13:48:41 +0200
Message-Id: <20190528114846.1983-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190528114846.1983-1-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
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
index 61fa1d162d28..36acd0267a13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1210,6 +1210,25 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
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
@@ -1219,6 +1238,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.eswitch_encap_mode_set = mlx5_devlink_eswitch_encap_mode_set,
 	.eswitch_encap_mode_get = mlx5_devlink_eswitch_encap_mode_get,
 #endif
+	.flash_update = mlx5_devlink_flash_update,
 };
 
 static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
-- 
2.17.2

