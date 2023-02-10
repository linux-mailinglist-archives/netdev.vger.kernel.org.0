Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9166929FE
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbjBJWTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbjBJWS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:18:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0D77FEF2
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 871D6B82600
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3ACC433EF;
        Fri, 10 Feb 2023 22:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067518;
        bh=Wv4N/PxLSeqfTfAe0sYYlXva41XjobiuslsGTUBfgz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bg3KrugPoM0sFH2vLnAuQcRw/ZOYEEZKiukldYiKhE/en9P9rWduvZZD8rAgebQzg
         Bhqp3uCFLDmlN9oFKpbKuGlEnr+C0GaiIWGDAImwZyr5IYVKwaCoAsr8Uj4LU3AFy5
         kqm3lXaseKSvF953Qym8CmW3vGn1GV5TPP/KAXUqrQnLPHiXCeBL/d5mrZItIIpp0S
         reSiqjUwAVFExvUe19lMleZjBEtkAQ/ugSj/sXJOLoA+X//9D+s1I96mrDMSEdFJVV
         t6k8Mylv9w7K5uCNbILJeD3/UZqteSsSHZqQZL0NCE+cFwTEK5rVR1Yc+xKLIMz3LR
         7klGANDo9J/YA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Move dl_port to struct mlx5e_dev
Date:   Fri, 10 Feb 2023 14:18:17 -0800
Message-Id: <20230210221821.271571-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210221821.271571-1-saeed@kernel.org>
References: <20230210221821.271571-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

No need to have dl_port which is tightly coupled with mlx5e code
in mlx5 core code. Move it to struct mlx5e_dev and loose
mlx5e_devlink_get_dl_port() helper.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c  | 15 +++++----------
 .../net/ethernet/mellanox/mlx5/core/en/devlink.h  |  9 +--------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  8 ++++----
 include/linux/mlx5/driver.h                       |  1 -
 5 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 125c7cb7d839..88460b7796e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -975,6 +975,7 @@ struct mlx5e_priv {
 
 struct mlx5e_dev {
 	struct mlx5e_priv *priv;
+	struct devlink_port dl_port;
 };
 
 struct mlx5e_rx_handlers {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index 68502c742311..724de9e06c54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -38,13 +38,11 @@ mlx5e_devlink_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_i
 }
 
 int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
-				struct mlx5e_priv *priv,
 				struct mlx5_core_dev *mdev)
 {
 	struct devlink *devlink = priv_to_devlink(mlx5e_dev);
 	struct devlink_port_attrs attrs = {};
 	struct netdev_phys_item_id ppid = {};
-	struct devlink_port *dl_port;
 	unsigned int dl_port_index;
 
 	if (mlx5_core_is_pf(mdev)) {
@@ -62,16 +60,13 @@ int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
 		dl_port_index = mlx5_esw_vport_to_devlink_port_index(mdev, 0);
 	}
 
-	dl_port = mlx5e_devlink_get_dl_port(priv);
-	memset(dl_port, 0, sizeof(*dl_port));
-	devlink_port_attrs_set(dl_port, &attrs);
+	devlink_port_attrs_set(&mlx5e_dev->dl_port, &attrs);
 
-	return devlink_port_register(devlink, dl_port, dl_port_index);
+	return devlink_port_register(devlink, &mlx5e_dev->dl_port,
+				     dl_port_index);
 }
 
-void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv)
+void mlx5e_devlink_port_unregister(struct mlx5e_dev *mlx5e_dev)
 {
-	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
-
-	devlink_port_unregister(dl_port);
+	devlink_port_unregister(&mlx5e_dev->dl_port);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
index d1088c8de0d3..c31d1d97b8c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -10,14 +10,7 @@
 struct mlx5e_dev *mlx5e_create_devlink(struct device *dev);
 void mlx5e_destroy_devlink(struct mlx5e_dev *mlx5e_dev);
 int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
-				struct mlx5e_priv *priv,
 				struct mlx5_core_dev *mdev);
-void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv);
-
-static inline struct devlink_port *
-mlx5e_devlink_get_dl_port(struct mlx5e_priv *priv)
-{
-	return &priv->mdev->mlx5e_res.dl_port;
-}
+void mlx5e_devlink_port_unregister(struct mlx5e_dev *mlx5e_dev);
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 18b2fe658d20..432d32f5dc65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5910,12 +5910,12 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	priv->dfs_root = debugfs_create_dir("nic",
 					    mlx5_debugfs_get_dev_root(priv->mdev));
 
-	err = mlx5e_devlink_port_register(mlx5e_dev, priv, mdev);
+	err = mlx5e_devlink_port_register(mlx5e_dev, mdev);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
 		goto err_destroy_netdev;
 	}
-	SET_NETDEV_DEVLINK_PORT(netdev, mlx5e_devlink_get_dl_port(priv));
+	SET_NETDEV_DEVLINK_PORT(netdev, &mlx5e_dev->dl_port);
 
 	err = profile->init(mdev, netdev);
 	if (err) {
@@ -5945,7 +5945,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 err_profile_cleanup:
 	profile->cleanup(priv);
 err_devlink_cleanup:
-	mlx5e_devlink_port_unregister(priv);
+	mlx5e_devlink_port_unregister(mlx5e_dev);
 err_destroy_netdev:
 	debugfs_remove_recursive(priv->dfs_root);
 	mlx5e_destroy_netdev(priv);
@@ -5965,7 +5965,7 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	unregister_netdev(priv->netdev);
 	mlx5e_suspend(adev, state);
 	priv->profile->cleanup(priv);
-	mlx5e_devlink_port_unregister(priv);
+	mlx5e_devlink_port_unregister(mlx5e_dev);
 	debugfs_remove_recursive(priv->dfs_root);
 	mlx5e_destroy_netdev(priv);
 	mlx5e_destroy_devlink(mlx5e_dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index c9259350cdfc..a170c8565779 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -679,7 +679,6 @@ struct mlx5e_resources {
 		u32			   mkey;
 		struct mlx5_sq_bfreg       bfreg;
 	} hw_objs;
-	struct devlink_port dl_port;
 	struct net_device *uplink_netdev;
 	struct mutex uplink_netdev_lock;
 	struct mlx5_crypto_dek_priv *dek_priv;
-- 
2.39.1

