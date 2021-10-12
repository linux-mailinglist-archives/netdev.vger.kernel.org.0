Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A563C42A53E
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbhJLNSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236748AbhJLNR4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F665610E5;
        Tue, 12 Oct 2021 13:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634044555;
        bh=GsK24v4DaItRGSON6mRP1tIYJpNKsAU7DJ64UmSCRAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKD4038cu0AxzCZEXfL8bHrRnj/qH2H/8cTEhCSyJG3vRYXGlneOkIFhszHCq8pGn
         Kq2/3xs7lVkm/5p2EBkF7QV4lhcWoL4A2AHoKPs0pl4Oo0BGTNFAVN5khc6aU1IAMK
         Osn5GV2LZl/JiZJDf6Fp6TZbxsMeisx8GUCcvB8Do0//knHTg7YrympNPzWxYiWGKT
         OoWBtX5qI4kvAt0jG0tlN6UfFOQbe/aIPNNs6cDqGOhp+h4AzKPHUKc+xMUduzVay2
         uUQ/pDlk8sqnFtM6cfY979ZZdJYJVdQ9pZyfTj8z7CT8g34zYLSghuLtIAH1BlXvq0
         uQm1PWhXRXn/g==
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
Subject: [PATCH net-next v4 6/6] devlink: Delete reload enable/disable interface
Date:   Tue, 12 Oct 2021 16:15:26 +0300
Message-Id: <be6fb00e6b80fa25c474eb3c31312fb920b17b57.1634044267.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634044267.git.leonro@nvidia.com>
References: <cover.1634044267.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Commit a0c76345e3d3 ("devlink: disallow reload operation during device
cleanup") added devlink_reload_{enable,disable}() APIs to prevent reload
operation from racing with device probe/dismantle.

After recent changes to move devlink_register() to the end of device
probe and devlink_unregister() to the beginning of device dismantle,
these races can no longer happen. Reload operations will be denied if
the devlink instance is unregistered and devlink_unregister() will block
until all in-flight operations are done.

Therefore, remove these devlink_reload_{enable,disable}() APIs.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  3 --
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  3 --
 drivers/net/ethernet/mellanox/mlx4/main.c     |  2 -
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 --
 .../mellanox/mlx5/core/sf/dev/driver.c        |  5 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  7 +--
 drivers/net/netdevsim/dev.c                   |  3 --
 include/net/devlink.h                         |  2 -
 net/core/devlink.c                            | 47 ++-----------------
 9 files changed, 6 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 438fe62fea4d..4c441e6a5082 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -121,7 +121,6 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 }
 
@@ -129,8 +128,6 @@ void hclge_devlink_uninit(struct hclge_dev *hdev)
 {
 	struct devlink *devlink = hdev->devlink;
 
-	devlink_reload_disable(devlink);
-
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index 519f4108422e..fdc19868b818 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -123,7 +123,6 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 }
 
@@ -131,8 +130,6 @@ void hclgevf_devlink_uninit(struct hclgevf_dev *hdev)
 {
 	struct devlink *devlink = hdev->devlink;
 
-	devlink_reload_disable(devlink);
-
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 05e850a40b36..b187c210d4d6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4027,7 +4027,6 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_save_state(pdev);
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 
 err_params_unregister:
@@ -4136,7 +4135,6 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(priv);
 	int active_vfs = 0;
 
-	devlink_reload_disable(devlink);
 	devlink_unregister(devlink);
 
 	if (mlx4_is_slave(dev))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5893fdd5aedb..65313448a47c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1538,8 +1538,6 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_save_state(pdev);
 	devlink_register(devlink);
-	if (!mlx5_core_is_mp_slave(dev))
-		devlink_reload_enable(devlink);
 	return 0;
 
 err_init_one:
@@ -1559,7 +1557,6 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
-	devlink_reload_disable(devlink);
 	devlink_unregister(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 3cf272fa2164..7b4783ce213e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -47,7 +47,6 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		goto init_one_err;
 	}
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 
 init_one_err:
@@ -62,10 +61,8 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 {
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
-	struct devlink *devlink;
+	struct devlink *devlink = priv_to_devlink(sf_dev->mdev);
 
-	devlink = priv_to_devlink(sf_dev->mdev);
-	devlink_reload_disable(devlink);
 	devlink_unregister(devlink);
 	mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 0f1567149a54..3fd3812b8f31 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2010,9 +2010,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (!reload) {
 		devlink_set_features(devlink, DEVLINK_F_RELOAD);
 		devlink_register(devlink);
-		devlink_reload_enable(devlink);
 	}
-
 	return 0;
 
 err_driver_init:
@@ -2076,10 +2074,9 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
-	if (!reload) {
-		devlink_reload_disable(devlink);
+	if (!reload)
 		devlink_unregister(devlink);
-	}
+
 	if (devlink_is_reload_failed(devlink)) {
 		if (!reload)
 			/* Only the parts that were not de-initialized in the
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 520c019dbad5..9661aca35703 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1513,7 +1513,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 
 err_psample_exit:
@@ -1567,9 +1566,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
-	devlink_reload_disable(devlink);
 	devlink_unregister(devlink);
-
 	nsim_dev_reload_destroy(nsim_dev);
 
 	nsim_bpf_dev_exit(nsim_dev);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 287f18b88293..da3ceeb8b87b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1511,8 +1511,6 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
 void devlink_set_features(struct devlink *devlink, u64 features);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
-void devlink_reload_enable(struct devlink *devlink);
-void devlink_reload_disable(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 1931caa0ce1e..3ce6147a2fe8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -63,8 +63,7 @@ struct devlink {
 	 * port, sb, dpipe, resource, params, region, traps and more.
 	 */
 	struct mutex lock;
-	u8 reload_failed:1,
-	   reload_enabled:1;
+	u8 reload_failed:1;
 	refcount_t refcount;
 	struct completion comp;
 	char priv[0] __aligned(NETDEV_ALIGN);
@@ -4033,9 +4032,6 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	struct net *curr_net;
 	int err;
 
-	if (!devlink->reload_enabled || !(devlink->features & DEVLINK_F_RELOAD))
-		return -EOPNOTSUPP;
-
 	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
 	       sizeof(remote_reload_stats));
 
@@ -4103,7 +4099,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	u32 actions_performed;
 	int err;
 
-	if (!devlink_reload_supported(devlink->ops))
+	if (!(devlink->features & DEVLINK_F_RELOAD))
 		return -EOPNOTSUPP;
 
 	err = devlink_resources_validate(devlink, NULL, info);
@@ -9175,49 +9171,12 @@ void devlink_unregister(struct devlink *devlink)
 	wait_for_completion(&devlink->comp);
 
 	mutex_lock(&devlink_mutex);
-	WARN_ON(devlink->features & DEVLINK_F_RELOAD &&
-		devlink->reload_enabled);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
-/**
- *	devlink_reload_enable - Enable reload of devlink instance
- *
- *	@devlink: devlink
- *
- *	Should be called at end of device initialization
- *	process when reload operation is supported.
- */
-void devlink_reload_enable(struct devlink *devlink)
-{
-	mutex_lock(&devlink_mutex);
-	devlink->reload_enabled = true;
-	mutex_unlock(&devlink_mutex);
-}
-EXPORT_SYMBOL_GPL(devlink_reload_enable);
-
-/**
- *	devlink_reload_disable - Disable reload of devlink instance
- *
- *	@devlink: devlink
- *
- *	Should be called at the beginning of device cleanup
- *	process when reload operation is supported.
- */
-void devlink_reload_disable(struct devlink *devlink)
-{
-	mutex_lock(&devlink_mutex);
-	/* Mutex is taken which ensures that no reload operation is in
-	 * progress while setting up forbidded flag.
-	 */
-	devlink->reload_enabled = false;
-	mutex_unlock(&devlink_mutex);
-}
-EXPORT_SYMBOL_GPL(devlink_reload_disable);
-
 /**
  *	devlink_free - Free devlink instance resources
  *
@@ -11554,7 +11513,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 		if (!net_eq(devlink_net(devlink), net))
 			goto retry;
 
-		WARN_ON(!devlink_reload_supported(devlink->ops));
+		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 				     DEVLINK_RELOAD_LIMIT_UNSPEC,
-- 
2.31.1

