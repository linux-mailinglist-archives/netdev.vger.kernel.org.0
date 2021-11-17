Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF041454D1C
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbhKQS3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:29:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240019AbhKQS3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 13:29:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA27461A62;
        Wed, 17 Nov 2021 18:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637173596;
        bh=cTwcL7Q1aISIEWW27EcvXwtKYIYVbjSDJAPhiOQrv3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmeNigGn2DCXsh2P+cdrK9YlI+5btbCu2NuMazv6QzJTvQT8Bx+wUek4RWd4f/MTz
         oBEIjQZdtrTeQSmQOL6Uwb0/XxMoDxcdkvtc21I/DFhnWrjz0oZTz4CWcFyduqwZQs
         T5l7DMG3YMU+/jg1dhnW2n4TuAbowgu83zOiwHfjsyqX4zMfF4AXT3H9IjQ5vZIkRj
         90ljwF8wsjslwjKOi56Mlv+Q7kIOD6Vh5tKsQGSCrG2PKJPtT1t2bZIV8UM9Mr/eMm
         /JAbg91YdQf/FNs5epVv/ZyoqnjNGZQXrOZL7sP8AyrywkQaiOWKAR2D3n1mPWe/FG
         eFvkEMLcqb+ew==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Aya Levin <ayal@mellanox.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, drivers@pensando.io,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 3/6] devlink: Simplify devlink resources unregister call
Date:   Wed, 17 Nov 2021 20:26:19 +0200
Message-Id: <deb5fde9834de3910297a77993d8b92059e3d1b7.1637173517.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637173517.git.leonro@nvidia.com>
References: <cover.1637173517.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The devlink_resources_unregister() used second parameter as an
entry point for the recursive removal of devlink resources. None
of external to devlink users needed to use this field, so lat's
remove it.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  8 ++---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 +--
 drivers/net/netdevsim/dev.c                   |  4 +--
 include/net/devlink.h                         |  3 +-
 net/core/devlink.c                            | 34 +++++++++++--------
 net/dsa/dsa.c                                 |  2 +-
 6 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 3fd3812b8f31..0d1f08bbf631 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -160,7 +160,7 @@ static void mlxsw_ports_fini(struct mlxsw_core *mlxsw_core, bool reload)
 
 	devlink_resource_occ_get_unregister(devlink, MLXSW_CORE_RESOURCE_PORTS);
 	if (!reload)
-		devlink_resources_unregister(priv_to_devlink(mlxsw_core), NULL);
+		devlink_resources_unregister(priv_to_devlink(mlxsw_core));
 
 	kfree(mlxsw_core->ports);
 }
@@ -2033,7 +2033,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	mlxsw_ports_fini(mlxsw_core, reload);
 err_ports_init:
 	if (!reload)
-		devlink_resources_unregister(devlink, NULL);
+		devlink_resources_unregister(devlink);
 err_register_resources:
 	mlxsw_bus->fini(bus_priv);
 err_bus_init:
@@ -2099,7 +2099,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	kfree(mlxsw_core->lag.mapping);
 	mlxsw_ports_fini(mlxsw_core, reload);
 	if (!reload)
-		devlink_resources_unregister(devlink, NULL);
+		devlink_resources_unregister(devlink);
 	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
 	if (!reload)
 		devlink_free(devlink);
@@ -2108,7 +2108,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 
 reload_fail_deinit:
 	mlxsw_core_params_unregister(mlxsw_core);
-	devlink_resources_unregister(devlink, NULL);
+	devlink_resources_unregister(devlink);
 	devlink_free(devlink);
 }
 EXPORT_SYMBOL(mlxsw_core_bus_device_unregister);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5925db386b1b..6a5887aacbc0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3336,7 +3336,7 @@ static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 err_policer_resources_register:
 err_resources_counter_register:
 err_resources_span_register:
-	devlink_resources_unregister(priv_to_devlink(mlxsw_core), NULL);
+	devlink_resources_unregister(priv_to_devlink(mlxsw_core));
 	return err;
 }
 
@@ -3370,7 +3370,7 @@ static int mlxsw_sp2_resources_register(struct mlxsw_core *mlxsw_core)
 err_policer_resources_register:
 err_resources_counter_register:
 err_resources_span_register:
-	devlink_resources_unregister(priv_to_devlink(mlxsw_core), NULL);
+	devlink_resources_unregister(priv_to_devlink(mlxsw_core));
 	return err;
 }
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 54345c096a16..08d7b465a0de 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1622,7 +1622,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
-	devlink_resources_unregister(devlink, NULL);
+	devlink_resources_unregister(devlink);
 err_vfc_free:
 	kfree(nsim_dev->vfconfigs);
 err_devlink_free:
@@ -1668,7 +1668,7 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev_debugfs_exit(nsim_dev);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
-	devlink_resources_unregister(devlink, NULL);
+	devlink_resources_unregister(devlink);
 	kfree(nsim_dev->vfconfigs);
 	devlink_free(devlink);
 	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index aab3d007c577..f919545f5781 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1567,8 +1567,7 @@ int devlink_resource_register(struct devlink *devlink,
 			      u64 resource_id,
 			      u64 parent_resource_id,
 			      const struct devlink_resource_size_params *size_params);
-void devlink_resources_unregister(struct devlink *devlink,
-				  struct devlink_resource *resource);
+void devlink_resources_unregister(struct devlink *devlink);
 int devlink_resource_size_get(struct devlink *devlink,
 			      u64 resource_id,
 			      u64 *p_resource_size);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index dcc09c62f3e5..af94015b7424 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9889,34 +9889,38 @@ int devlink_resource_register(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_resource_register);
 
+static void devlink_resource_unregister(struct devlink *devlink,
+					struct devlink_resource *resource)
+{
+	struct devlink_resource *tmp, *child_resource;
+
+	list_for_each_entry_safe(child_resource, tmp, &resource->resource_list,
+				 list) {
+		devlink_resource_unregister(devlink, child_resource);
+		list_del(&child_resource->list);
+		kfree(child_resource);
+	}
+}
+
 /**
  *	devlink_resources_unregister - free all resources
  *
  *	@devlink: devlink
- *	@resource: resource
  */
-void devlink_resources_unregister(struct devlink *devlink,
-				  struct devlink_resource *resource)
+void devlink_resources_unregister(struct devlink *devlink)
 {
 	struct devlink_resource *tmp, *child_resource;
-	struct list_head *resource_list;
-
-	if (resource)
-		resource_list = &resource->resource_list;
-	else
-		resource_list = &devlink->resource_list;
 
-	if (!resource)
-		mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->lock);
 
-	list_for_each_entry_safe(child_resource, tmp, resource_list, list) {
-		devlink_resources_unregister(devlink, child_resource);
+	list_for_each_entry_safe(child_resource, tmp, &devlink->resource_list,
+				 list) {
+		devlink_resource_unregister(devlink, child_resource);
 		list_del(&child_resource->list);
 		kfree(child_resource);
 	}
 
-	if (!resource)
-		mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devlink_resources_unregister);
 
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index ea5169e671ae..d9d0d227092c 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -406,7 +406,7 @@ EXPORT_SYMBOL_GPL(dsa_devlink_resource_register);
 
 void dsa_devlink_resources_unregister(struct dsa_switch *ds)
 {
-	devlink_resources_unregister(ds->devlink, NULL);
+	devlink_resources_unregister(ds->devlink);
 }
 EXPORT_SYMBOL_GPL(dsa_devlink_resources_unregister);
 
-- 
2.33.1

