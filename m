Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAA0672126
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjARPYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjARPXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:50 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD30111E93
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:24 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bk15so26554076ejb.9
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=odPPuqhbkSzx9BlQTBtjL2BqDQLkQZtr7pY/M4AKmrs=;
        b=gwub6lj5ti4DuWeVQKuJ4NtFekIQJgFSiD9gJHWt3MUP4ytimCQw7dlidE2JCb/Xiy
         2QS7b3JlrKmomhiXecuW/SjyLWgOaWJf0zeff8Ea6DVCcmEOZ/4TLKwfACHGwKdXXY4p
         MNdKAqD0LgluXpSRaDoBCT0jp1AsO93EBpWJjEqurHRCN19Sr8Yu7j0C6GbhrsFHxbFJ
         NsT3y/EnIpFSpXd16DiaP5MwLE9BpnfWfGo6E2LXAlMO+s42ee8rdYQlfE5RVLfxrsR0
         OP62sWLEObboAyIKww1EQTK72mlOI4UJ/KInrL4GWYa/gMAymKkvvYYePj994Ex8631h
         u1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=odPPuqhbkSzx9BlQTBtjL2BqDQLkQZtr7pY/M4AKmrs=;
        b=BRQc5BoijMjPn8h0jJq/mz/ov9XvPWJfzXiPktI7IwuB4wKwwHnD+blTvcOMh3+5DP
         4HhHQlygvA1evVaZ77ehXlvy5dPemEw8gCYusbW0WiXR8oQA37xN3BmVaKGZg1KBXyt9
         2CBBjRYvzuX+1YesJquJYOmd3CgAWC/LC7yq+i2uGeIqqTRIouTkwcxNenaf+ZtTL5/V
         Paf7caErvInSipwhw/fxn6LMIxVf88bKTgphdThF9D29lqSxal+SSqDcHYfB1IIaBKqr
         wA3Ysa8cZ9VVQEsdGumdihFbDu4qzFLput2f2l6FqRtad35RD0j1z1lTDsoBEpBTrH2l
         xubw==
X-Gm-Message-State: AFqh2kqqaa7uclXyklix/W3dHClJyb1nVPfcKkTHqkePVYMlJDySYMEU
        OuuB+TL7D2AYgWuUiYtDszER2Gspju+MzUOXBqC85A==
X-Google-Smtp-Source: AMrXdXtkpLOlV/HS4q4oVlUN/CETEzHsL6yTTB/9pxz1NvZ45hFp2+l0IsNKTgN49cmINAW/C36c8w==
X-Received: by 2002:a17:907:8b97:b0:84d:39ba:368b with SMTP id tb23-20020a1709078b9700b0084d39ba368bmr8667447ejc.75.1674055283288;
        Wed, 18 Jan 2023 07:21:23 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id m24-20020a1709066d1800b0084d4b8f5889sm11940110ejr.102.2023.01.18.07.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:22 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 03/12] net/mlx5e: Create separate devlink instance for ethernet auxiliary device
Date:   Wed, 18 Jan 2023 16:21:06 +0100
Message-Id: <20230118152115.1113149-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118152115.1113149-1-jiri@resnulli.us>
References: <20230118152115.1113149-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The fact that devlink instance lock is held over mlx5 auxiliary devices
probe and remove routines brought a need to conditionally take devlink
instance lock there. The code is checking a MLX5E_LOCKED_FLOW flag
in mlx5 priv struct.

This is racy and may lead to access devlink objects without holding
instance lock or deadlock.

To avoid this, the only lock-wise sane solution is to make the
devlink entities created by the auxiliary device independent on
the original pci devlink instance. Create devlink instance for the
auxiliary device and put the uplink port instance there alongside with
the port health reporters.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v4->v5:
- new patch
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 ++
 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 44 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |  5 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 25 ++++++++---
 4 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 82573ac722d1..da58322cbc3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -971,6 +971,10 @@ struct mlx5e_priv {
 	struct dentry             *dfs_root;
 };
 
+struct mlx5e_dev {
+	struct mlx5e_priv *priv;
+};
+
 struct mlx5e_rx_handlers {
 	mlx5e_fp_handle_rx_cqe handle_rx_cqe;
 	mlx5e_fp_handle_rx_cqe handle_rx_cqe_mpwqe;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index 83adaabf59f5..03ad3b61dfc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -4,6 +4,29 @@
 #include "en/devlink.h"
 #include "eswitch.h"
 
+static const struct devlink_ops mlx5e_devlink_ops = {
+};
+
+struct mlx5e_dev *mlx5e_create_devlink(struct device *dev)
+{
+	struct mlx5e_dev *mlx5e_dev;
+	struct devlink *devlink;
+
+	devlink = devlink_alloc(&mlx5e_devlink_ops, sizeof(*mlx5e_dev), dev);
+	if (!devlink)
+		return ERR_PTR(-ENOMEM);
+	devlink_register(devlink);
+	return devlink_priv(devlink);
+}
+
+void mlx5e_destroy_devlink(struct mlx5e_dev *mlx5e_dev)
+{
+	struct devlink *devlink = priv_to_devlink(mlx5e_dev);
+
+	devlink_unregister(devlink);
+	devlink_free(devlink);
+}
+
 static void
 mlx5e_devlink_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_item_id *ppid)
 {
@@ -14,14 +37,14 @@ mlx5e_devlink_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_i
 	memcpy(ppid->id, &parent_id, sizeof(parent_id));
 }
 
-int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
+int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
+				struct mlx5e_priv *priv)
 {
-	struct devlink *devlink = priv_to_devlink(priv->mdev);
+	struct devlink *devlink = priv_to_devlink(mlx5e_dev);
 	struct devlink_port_attrs attrs = {};
 	struct netdev_phys_item_id ppid = {};
 	struct devlink_port *dl_port;
 	unsigned int dl_port_index;
-	int ret;
 
 	if (mlx5_core_is_pf(priv->mdev)) {
 		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
@@ -42,23 +65,12 @@ int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 	memset(dl_port, 0, sizeof(*dl_port));
 	devlink_port_attrs_set(dl_port, &attrs);
 
-	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
-		devl_lock(devlink);
-	ret = devl_port_register(devlink, dl_port, dl_port_index);
-	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
-		devl_unlock(devlink);
-
-	return ret;
+	return devlink_port_register(devlink, dl_port, dl_port_index);
 }
 
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv)
 {
 	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
-	struct devlink *devlink = priv_to_devlink(priv->mdev);
 
-	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
-		devl_lock(devlink);
-	devl_port_unregister(dl_port);
-	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
-		devl_unlock(devlink);
+	devlink_port_unregister(dl_port);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
index 4f238d4fff55..19b1d8e9634e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -7,7 +7,10 @@
 #include <net/devlink.h>
 #include "en.h"
 
-int mlx5e_devlink_port_register(struct mlx5e_priv *priv);
+struct mlx5e_dev *mlx5e_create_devlink(struct device *dev);
+void mlx5e_destroy_devlink(struct mlx5e_dev *mlx5e_dev);
+int mlx5e_devlink_port_register(struct mlx5e_dev *mlx5e_dev,
+				struct mlx5e_priv *priv);
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv);
 
 static inline struct devlink_port *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6bb0fdaa5efa..1e0afaa31dd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5876,7 +5876,8 @@ void mlx5e_destroy_netdev(struct mlx5e_priv *priv)
 static int mlx5e_resume(struct auxiliary_device *adev)
 {
 	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
-	struct mlx5e_priv *priv = auxiliary_get_drvdata(adev);
+	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
+	struct mlx5e_priv *priv = mlx5e_dev->priv;
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = edev->mdev;
 	int err;
@@ -5899,7 +5900,8 @@ static int mlx5e_resume(struct auxiliary_device *adev)
 
 static int mlx5e_suspend(struct auxiliary_device *adev, pm_message_t state)
 {
-	struct mlx5e_priv *priv = auxiliary_get_drvdata(adev);
+	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
+	struct mlx5e_priv *priv = mlx5e_dev->priv;
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
@@ -5917,21 +5919,28 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
 	const struct mlx5e_profile *profile = &mlx5e_nic_profile;
 	struct mlx5_core_dev *mdev = edev->mdev;
+	struct mlx5e_dev *mlx5e_dev;
 	struct net_device *netdev;
 	pm_message_t state = {};
 	struct mlx5e_priv *priv;
 	int err;
 
+	mlx5e_dev = mlx5e_create_devlink(&adev->dev);
+	if (IS_ERR(mlx5e_dev))
+		return PTR_ERR(mlx5e_dev);
+	auxiliary_set_drvdata(adev, mlx5e_dev);
+
 	netdev = mlx5e_create_netdev(mdev, profile);
 	if (!netdev) {
 		mlx5_core_err(mdev, "mlx5e_create_netdev failed\n");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_devlink_unregister;
 	}
 
 	mlx5e_build_nic_netdev(netdev);
 
 	priv = netdev_priv(netdev);
-	auxiliary_set_drvdata(adev, priv);
+	mlx5e_dev->priv = priv;
 
 	priv->profile = profile;
 	priv->ppriv = NULL;
@@ -5939,7 +5948,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	priv->dfs_root = debugfs_create_dir("nic",
 					    mlx5_debugfs_get_dev_root(priv->mdev));
 
-	err = mlx5e_devlink_port_register(priv);
+	err = mlx5e_devlink_port_register(mlx5e_dev, priv);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
 		goto err_destroy_netdev;
@@ -5978,12 +5987,15 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 err_destroy_netdev:
 	debugfs_remove_recursive(priv->dfs_root);
 	mlx5e_destroy_netdev(priv);
+err_devlink_unregister:
+	mlx5e_destroy_devlink(mlx5e_dev);
 	return err;
 }
 
 static void mlx5e_remove(struct auxiliary_device *adev)
 {
-	struct mlx5e_priv *priv = auxiliary_get_drvdata(adev);
+	struct mlx5e_dev *mlx5e_dev = auxiliary_get_drvdata(adev);
+	struct mlx5e_priv *priv = mlx5e_dev->priv;
 	pm_message_t state = {};
 
 	mlx5e_dcbnl_delete_app(priv);
@@ -5993,6 +6005,7 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	mlx5e_devlink_port_unregister(priv);
 	debugfs_remove_recursive(priv->dfs_root);
 	mlx5e_destroy_netdev(priv);
+	mlx5e_destroy_devlink(mlx5e_dev);
 }
 
 static const struct auxiliary_device_id mlx5e_id_table[] = {
-- 
2.39.0

