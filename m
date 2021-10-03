Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F0142034C
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 20:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhJCSOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 14:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231442AbhJCSOQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 14:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C3C761A38;
        Sun,  3 Oct 2021 18:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633284749;
        bh=kmvqg5Sh9xOemSfm/3IvxuS1vadjnBCVVd+/5Nkwtn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufRTQEcGZP0BVyT/adr4nvPP4mx13Dl0nZZWtRQ+eT8sXfD04J/35YUuo7KVr9t2p
         EkkLZZSRDn1UPzu8EBDNBqPULmPzKv75EFoyI3HzIv/sdV4F8VzmrKF+qbXRMMMWzO
         FWNGjq8LRcqEnnzyHFcg5EERMTKZfmdxPW5rTmFed8MctI3t1go6/aeeSteB9kVoH+
         SXyUQ0RbseGP4HjXPxGvGh03MnbmmQ4mgaPQ6uDUXpLCtfJMEllJBirgMx+jDDPlAK
         ojFzIemli6oFlxQNQQnbY6A+7UfO8Dgl4nVlzW25/23YBzMGOp1aIbq1L3Ze97Y0/W
         mlfZGycVuxaWw==
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
Subject: [PATCH net-next v2 5/5] devlink: Delete reload enable/disable interface
Date:   Sun,  3 Oct 2021 21:12:06 +0300
Message-Id: <06ebba9e115d421118b16ac4efda61c2e08f4d50.1633284302.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633284302.git.leonro@nvidia.com>
References: <cover.1633284302.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

After changes to allow dynamically set the reload_up/_down callbacks,
we ensure that properly supported devlink ops are not accessible before
devlink_register, which is last command in the initialization sequence.

It makes devlink_reload_enable/_disable not relevant anymore and can be
safely deleted.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  3 --
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  3 --
 drivers/net/ethernet/mellanox/mlx4/main.c     |  2 -
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 --
 .../mellanox/mlx5/core/sf/dev/driver.c        |  5 +--
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 10 ++---
 drivers/net/netdevsim/dev.c                   |  3 --
 include/net/devlink.h                         |  2 -
 net/core/devlink.c                            | 43 +------------------
 9 files changed, 5 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 59b0ae7d59e0..c394c393421e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -120,7 +120,6 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	hdev->devlink = devlink;
 
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 }
 
@@ -128,8 +127,6 @@ void hclge_devlink_uninit(struct hclge_dev *hdev)
 {
 	struct devlink *devlink = hdev->devlink;
 
-	devlink_reload_disable(devlink);
-
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index d60cc9426f70..d67c151e024b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -122,7 +122,6 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 	hdev->devlink = devlink;
 
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 }
 
@@ -130,8 +129,6 @@ void hclgevf_devlink_uninit(struct hclgevf_dev *hdev)
 {
 	struct devlink *devlink = hdev->devlink;
 
-	devlink_reload_disable(devlink);
-
 	devlink_unregister(devlink);
 
 	devlink_free(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 9541f3a920c8..8b410800f049 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4026,7 +4026,6 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_save_state(pdev);
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 
 err_params_unregister:
@@ -4135,7 +4134,6 @@ static void mlx4_remove_one(struct pci_dev *pdev)
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
index 9e831e8b607a..895b3ba88e45 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2007,11 +2007,8 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 			goto err_driver_init;
 	}
 
-	if (!reload) {
+	if (!reload)
 		devlink_register(devlink);
-		devlink_reload_enable(devlink);
-	}
-
 	return 0;
 
 err_driver_init:
@@ -2075,10 +2072,9 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
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
index cb6645012a30..09e48fb232a9 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1512,7 +1512,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	devlink_register(devlink);
-	devlink_reload_enable(devlink);
 	return 0;
 
 err_psample_exit:
@@ -1566,9 +1565,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
-	devlink_reload_disable(devlink);
 	devlink_unregister(devlink);
-
 	nsim_dev_reload_destroy(nsim_dev);
 
 	nsim_bpf_dev_exit(nsim_dev);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 320146d95fb8..23355fd92553 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1523,8 +1523,6 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
 void devlink_set_ops(struct devlink *devlink, const struct devlink_ops *ops);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
-void devlink_reload_enable(struct devlink *devlink);
-void devlink_reload_disable(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 25c2aa2b35cd..b45bdba9775d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -62,8 +62,7 @@ struct devlink {
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
 
-	if (!devlink->reload_enabled)
-		return -EOPNOTSUPP;
-
 	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
 	       sizeof(remote_reload_stats));
 
@@ -9245,49 +9241,12 @@ void devlink_unregister(struct devlink *devlink)
 	wait_for_completion(&devlink->comp);
 
 	mutex_lock(&devlink_mutex);
-	WARN_ON(devlink_reload_supported(&devlink->ops) &&
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

