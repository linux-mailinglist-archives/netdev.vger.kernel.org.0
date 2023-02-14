Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77C669707F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbjBNWOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbjBNWOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:14:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF9E303F7
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:14:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21043B81F59
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 22:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC78C433A1;
        Tue, 14 Feb 2023 22:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676412855;
        bh=RyOp9YIM0y1h9eieseRmiH2/udpMI8cNP57rqmznNuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/xSElqUuS3d+rDM3xu/lOS5r/BzsQbhATBLzcSbAiY4e/we7byoWEG1Lpmyp1HNM
         CVNocEyGb/Sz7Iua8dJ7nddzNI+a9ptIYwqgCRzhYMeViGuIafbXiv5GDHHeAXCODI
         Ls4DKmyiuROB82iX8+xVYkX0f1jrzh80NNpBkl2ygAo0hePI1zMtKX3LxOuXflOSyL
         zqO6JOCXsnRedaiAZ40jZu6WkLcqWU+Zs+HfTbwLPJ+btRXeNJA9s3ZPMJ+dE/yuKf
         zC7LueDdGqk+lKkAutmVC2hrrKmnG3GcLk78wWc2JXkCKVK5xtyMXYm/ZVgLMWN6zH
         5G6rZz9/V16hg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [net-next V2 09/15] net/mlx5e: Pass mdev to mlx5e_devlink_port_register()
Date:   Tue, 14 Feb 2023 14:12:33 -0800
Message-Id: <20230214221239.159033-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214221239.159033-1-saeed@kernel.org>
References: <20230214221239.159033-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of accessing priv->mdev, pass mdev pointer to
mlx5e_devlink_port_register() and access it directly.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c  | 15 ++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en/devlink.h  |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index 03ad3b61dfc7..68502c742311 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -38,7 +38,8 @@ mlx5e_devlink_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_i
 }
 
 int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
-				struct mlx5e_priv *priv)
+				struct mlx5e_priv *priv,
+				struct mlx5_core_dev *mdev)
 {
 	struct devlink *devlink = priv_to_devlink(mlx5e_dev);
 	struct devlink_port_attrs attrs = {};
@@ -46,19 +47,19 @@ int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
 	struct devlink_port *dl_port;
 	unsigned int dl_port_index;
 
-	if (mlx5_core_is_pf(priv->mdev)) {
+	if (mlx5_core_is_pf(mdev)) {
 		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-		attrs.phys.port_number = mlx5_get_dev_index(priv->mdev);
-		if (MLX5_ESWITCH_MANAGER(priv->mdev)) {
-			mlx5e_devlink_get_port_parent_id(priv->mdev, &ppid);
+		attrs.phys.port_number = mlx5_get_dev_index(mdev);
+		if (MLX5_ESWITCH_MANAGER(mdev)) {
+			mlx5e_devlink_get_port_parent_id(mdev, &ppid);
 			memcpy(attrs.switch_id.id, ppid.id, ppid.id_len);
 			attrs.switch_id.id_len = ppid.id_len;
 		}
-		dl_port_index = mlx5_esw_vport_to_devlink_port_index(priv->mdev,
+		dl_port_index = mlx5_esw_vport_to_devlink_port_index(mdev,
 								     MLX5_VPORT_UPLINK);
 	} else {
 		attrs.flavour = DEVLINK_PORT_FLAVOUR_VIRTUAL;
-		dl_port_index = mlx5_esw_vport_to_devlink_port_index(priv->mdev, 0);
+		dl_port_index = mlx5_esw_vport_to_devlink_port_index(mdev, 0);
 	}
 
 	dl_port = mlx5e_devlink_get_dl_port(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
index 19b1d8e9634e..d1088c8de0d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -10,7 +10,8 @@
 struct mlx5e_dev *mlx5e_create_devlink(struct device *dev);
 void mlx5e_destroy_devlink(struct mlx5e_dev *mlx5e_dev);
 int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
-				struct mlx5e_priv *priv);
+				struct mlx5e_priv *priv,
+				struct mlx5_core_dev *mdev);
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv);
 
 static inline struct devlink_port *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ec81d935262f..9b5b266b22b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5921,7 +5921,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	priv->dfs_root = debugfs_create_dir("nic",
 					    mlx5_debugfs_get_dev_root(priv->mdev));
 
-	err = mlx5e_devlink_port_register(mlx5e_dev, priv);
+	err = mlx5e_devlink_port_register(mlx5e_dev, priv, mdev);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
 		goto err_destroy_netdev;
-- 
2.39.1

