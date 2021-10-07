Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193CB424D86
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 08:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbhJGG5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 02:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231279AbhJGG5b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 02:57:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C6F96137F;
        Thu,  7 Oct 2021 06:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633589738;
        bh=76SAqnJZ5aZHOwgF+ZjzuqzGyVsQ6RgE0y/W0OPLNfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2Q+qCtOvAUEnIvk13t9z9zlk00s5qbv+nmfxvHjmFw2QUjWnIQVfNY9UJqZrCwrk
         /Ct9nhLBxPEsWQjsnewGm7qo43UTDPUmrrypVSzkYHygblPCh4tuhqca3tb0MdRdzu
         q0sT06Bb0yV0C/mCHv4abfNHv6p0Mp/EjoN9mYljl33pFGFvkstntoE3QsuoCjIR+L
         KpBXjKcde9tj8xS4i2qAULpO/Ph3SsRZ+5eGMaqYQFYkzRdxCTgoEUjBHGCTwDloLW
         3M7dS6qGydbgWKlopoHpEj9U2tjUDLZ4scCODR5NrHhmBEGG8j33v7xWNZeHX2JBZD
         4sUN2ifdW68sQ==
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
Subject: [PATCH net-next v3 5/5] devlink: Delete reload enable/disable interface
Date:   Thu,  7 Oct 2021 09:55:19 +0300
Message-Id: <73feb4a17448ffc8c0a9f61b181ad9b862673c08.1633589385.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633589385.git.leonro@nvidia.com>
References: <cover.1633589385.git.leonro@nvidia.com>
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
 .../mellanox/mlx5/core/sf/dev/driver.c        |  5 +--
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  7 +--
 drivers/net/netdevsim/dev.c                   |  3 --
 include/net/devlink.h                         |  2 -
 net/core/devlink.c                            | 43 +------------------
 9 files changed, 4 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 27b485427c5d..b3fa96d526c6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -124,7 +124,6 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 
 	devlink_set_reload_ops(devlink, &hclge_devlink_reload_ops);
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 }
 
@@ -132,8 +131,6 @@ void hclge_devlink_uninit(struct hclge_dev *hdev)
 {
 	struct devlink *devlink = hdev->devlink;
 
-	devlink_reload_disable(devlink);
-
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index 77545f841246..8552105d2fef 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -126,7 +126,6 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 
 	devlink_set_reload_ops(devlink, &hclgevf_devlink_reload_ops);
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 }
 
@@ -134,8 +133,6 @@ void hclgevf_devlink_uninit(struct hclgevf_dev *hdev)
 {
 	struct devlink *devlink = hdev->devlink;
 
-	devlink_reload_disable(devlink);
-
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 4c0846727888..8dbb5f5d9ae9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4030,7 +4030,6 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_save_state(pdev);
 	devlink_set_reload_ops(devlink, &mlx4_devlink_reload_ops);
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 
 err_params_unregister:
@@ -4139,7 +4138,6 @@ static void mlx4_remove_one(struct pci_dev *pdev)
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
index c42ab675a1d6..ac5894a53632 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2013,9 +2013,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (!reload) {
 		devlink_set_reload_ops(devlink, &mlxsw_devlink_reload_ops);
 		devlink_register(devlink);
-		devlink_reload_enable(devlink);
 	}
-
 	return 0;
 
 err_driver_init:
@@ -2079,10 +2077,9 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
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
index a7a09d49a402..e38c727e07fb 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1516,7 +1516,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	devlink_set_reload_ops(devlink, &nsim_dev_devlink_reload_ops);
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 
 err_psample_exit:
@@ -1570,9 +1569,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
-	devlink_reload_disable(devlink);
 	devlink_unregister(devlink);
-
 	nsim_dev_reload_destroy(nsim_dev);
 
 	nsim_bpf_dev_exit(nsim_dev);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 568343cc45f5..8657fe83772c 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1529,8 +1529,6 @@ void devlink_set_reload_ops(struct devlink *devlink,
 			    const struct devlink_reload_ops *ops);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
-void devlink_reload_enable(struct devlink *devlink);
-void devlink_reload_disable(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b0596a9065e2..7f36e371d845 100644
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
@@ -4037,9 +4036,6 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	struct net *curr_net;
 	int err;
 
-	if (!devlink->reload_enabled)
-		return -EOPNOTSUPP;
-
 	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
 	       sizeof(remote_reload_stats));
 
@@ -9179,49 +9175,12 @@ void devlink_unregister(struct devlink *devlink)
 	wait_for_completion(&devlink->comp);
 
 	mutex_lock(&devlink_mutex);
-	WARN_ON(devlink_reload_supported(devlink->reload_ops) &&
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
-- 
2.31.1

