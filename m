Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A874449A6A
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240413AbhKHRIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:08:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240416AbhKHRIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45FD361406;
        Mon,  8 Nov 2021 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391152;
        bh=mPr56uwSRwzh58Bhk7qD2m52Q4HgHZft5ANYg8yQ4lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0sKk9uF6EIuF50LtBNf92nykkdy0YDj4lUBHola8c/q5TaNh6bJ9rr6atMsbXDwL
         8cRzhnMTR7BClPO5AvG0/lRYgYy5uxDPeVRUiy8gNrG7FMVVIb3TbDlml4tCurd55a
         GKfNK7Z5fqY7+lP67V1NDQzRoRLLr5+BzqyP6ojglMyxu7AL1jA4hlt0C4XfSbJexD
         LYDTtJtMH6EhYtHIwzGn44jU05PUByK7xrK6GGh6XVgafHVGiGiZ/V4OqfpCsZ14RM
         +Ss3ZTtmq2v0uZ/SrGo1V065Y9+8l3BmrQwF5x4PSeQYaTripTuAwzWU+gsOK7S9Ls
         9s3EcTu7Meoow==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 03/16] devlink: Simplify devlink resources unregister call
Date:   Mon,  8 Nov 2021 19:05:25 +0200
Message-Id: <a9467de7ea02cacab016c98094d23e46bf8dca5b.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
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
index 6c906deca71c..4a8ca4896d9d 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1531,7 +1531,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
-	devlink_resources_unregister(devlink, NULL);
+	devlink_resources_unregister(devlink);
 err_devlink_free:
 	devlink_free(devlink);
 	return err;
@@ -1571,7 +1571,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev_debugfs_exit(nsim_dev);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
-	devlink_resources_unregister(devlink, NULL);
+	devlink_resources_unregister(devlink);
 	devlink_free(devlink);
 }
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1b1317d378de..a888aa13e219 100644
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
index 4df241a62a44..56a1ee65bce5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9887,34 +9887,38 @@ int devlink_resource_register(struct devlink *devlink,
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

