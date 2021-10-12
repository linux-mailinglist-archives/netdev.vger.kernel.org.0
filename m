Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1483642A53C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbhJLNRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236701AbhJLNRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:17:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB42610F8;
        Tue, 12 Oct 2021 13:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634044543;
        bh=d9a/3AtwS1QcEFBd6cckdXRMlHhS1v1D7EGzY1lEO00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=np1bvmRJ4a/DnvE9V/sKgX9QGS9aqA7zS+LDm9niuTdyb2vxMkZWjJ/8ehEdfBMdv
         wJ087+qDLsayqfpOl5RDZkGqfkVXARF9XGj+NhTRz52s44+wFBNeZn+LAkN4OzwF4d
         GE/qVBe+Nvkczpq/vQG29OdLcOnlqdSg8Ha7DsYkTj8/ISGb5Ttmz8cvUMfrqfFjqA
         rDbPsDfy3gzegBEzdT048FxPilxrF27R8wwykXMjtlC5+XxtrNtzI2I1o8hG3EyEYz
         G5nd24Z1+c6d0rTpc4UUD5Qt+KY47VZSPrfztSYxDTWXT0cZSkKaqY7D1J/1wPjqCa
         gBXcmxEorMTOw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v4 4/6] devlink: Allow control devlink ops behavior through feature mask
Date:   Tue, 12 Oct 2021 16:15:24 +0300
Message-Id: <873de92f82eef03a12915a14117ddda8f68d0da8.1634044267.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634044267.git.leonro@nvidia.com>
References: <cover.1634044267.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Introduce new devlink call to set feature mask to control devlink
behavior during device initialization phase after devlink_alloc()
is already called.

This allows us to set reload ops based on device property which
is not known at the beginning of driver initialization.

For the sake of simplicity, this API lacks any type of locking and
needs to be called before devlink_register() to make sure that no
parallel access to the ops is possible at this stage.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  1 +
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  1 +
 drivers/net/ethernet/mellanox/mlx4/main.c     |  1 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  1 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  1 +
 drivers/net/netdevsim/dev.c                   |  1 +
 include/net/devlink.h                         |  6 +++++
 net/core/devlink.c                            | 24 +++++++++++++++++--
 8 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 59b0ae7d59e0..438fe62fea4d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -119,6 +119,7 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
+	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index d60cc9426f70..519f4108422e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -121,6 +121,7 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
+	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 9541f3a920c8..05e850a40b36 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4025,6 +4025,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_params_unregister;
 
 	pci_save_state(pdev);
+	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index b9a6cea03951..fa98b7b95990 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -813,6 +813,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
+	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	return 0;
 
 traps_reg_err:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 9e831e8b607a..0f1567149a54 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2008,6 +2008,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	}
 
 	if (!reload) {
+		devlink_set_features(devlink, DEVLINK_F_RELOAD);
 		devlink_register(devlink);
 		devlink_reload_enable(devlink);
 	}
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index cb6645012a30..520c019dbad5 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1511,6 +1511,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 		goto err_psample_exit;
 
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
+	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7f44ad14e5ed..287f18b88293 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1186,6 +1186,11 @@ enum devlink_trap_group_generic_id {
 		.min_burst = _min_burst,				      \
 	}
 
+enum {
+	/* device supports reload operations */
+	DEVLINK_F_RELOAD = 1UL << 0,
+};
+
 struct devlink_ops {
 	/**
 	 * @supported_flash_update_params:
@@ -1503,6 +1508,7 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
 {
 	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
 }
+void devlink_set_features(struct devlink *devlink, u64 features);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_reload_enable(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 276e1e421eb4..1931caa0ce1e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -54,6 +54,7 @@ struct devlink {
 	struct list_head trap_group_list;
 	struct list_head trap_policer_list;
 	const struct devlink_ops *ops;
+	u64 features;
 	struct xarray snapshot_ids;
 	struct devlink_dev_stats stats;
 	struct device *dev;
@@ -4032,7 +4033,7 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	struct net *curr_net;
 	int err;
 
-	if (!devlink->reload_enabled)
+	if (!devlink->reload_enabled || !(devlink->features & DEVLINK_F_RELOAD))
 		return -EOPNOTSUPP;
 
 	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
@@ -8985,6 +8986,25 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
 	return true;
 }
 
+/**
+ *	devlink_set_features - Set devlink supported features
+ *
+ *	@devlink: devlink
+ *	@features: devlink support features
+ *
+ *	This interface allows us to set reload ops separatelly from
+ *	the devlink_alloc.
+ */
+void devlink_set_features(struct devlink *devlink, u64 features)
+{
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
+	WARN_ON(features & DEVLINK_F_RELOAD &&
+		!devlink_reload_supported(devlink->ops));
+	devlink->features = features;
+}
+EXPORT_SYMBOL_GPL(devlink_set_features);
+
 /**
  *	devlink_alloc_ns - Allocate new devlink instance resources
  *	in specific namespace
@@ -9155,7 +9175,7 @@ void devlink_unregister(struct devlink *devlink)
 	wait_for_completion(&devlink->comp);
 
 	mutex_lock(&devlink_mutex);
-	WARN_ON(devlink_reload_supported(devlink->ops) &&
+	WARN_ON(devlink->features & DEVLINK_F_RELOAD &&
 		devlink->reload_enabled);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-- 
2.31.1

