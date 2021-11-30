Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFE14630D7
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhK3KTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhK3KTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 05:19:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C68BC061574;
        Tue, 30 Nov 2021 02:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 431E4CE1839;
        Tue, 30 Nov 2021 10:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7416C53FC1;
        Tue, 30 Nov 2021 10:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638267385;
        bh=1zbVNs7CGxoHO8YD8XYILaoPM51VGGD2L2TYbSAciqA=;
        h=From:To:Cc:Subject:Date:From;
        b=UWzPJDA6mpu7o6HMD6I/cVweOkdtnkqMXZh22gcuYOaEORIXzwVTEMzRLawJfc241
         JY/k5Xzjh1augYyj/Z89BfC9+nhtaXoXl0PRauREMofz1RUNx+DVdCARn212T2TX2g
         cydX3k31ZdrRGsckzbjrLQKRUexsXcVuqZj0BMAdxmcQIRexyZNaLkeQK+Kql10xCe
         rXxFG9gWAYW66wxQ7mP67eI1xllMt4zpBaB86uQzNCPBLql8K3L2n6wQpLUEgvKjA0
         FFnGPPiLFgE/hcGPX7aypdZgPCr0RN3mbpUj5/Hy4NdSfaa+wPPyT0eJ4jdMwpiW8o
         L8zN9poGVtFvw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2] devlink: Simplify devlink resources unregister call
Date:   Tue, 30 Nov 2021 12:16:20 +0200
Message-Id: <b5b984a05fd069ff3b01683440f5461a64e44512.1638267154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The devlink_resources_unregister() used second parameter as an
entry point for the recursive removal of devlink resources. None
of the callers outside of devlink core needed to use this field,
so let's remove it.

As part of this removal, the "struct devlink_resource" was moved
from .h to .c file as it is not possible to use in any place in
the code except devlink.c.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
v2:
 * Extended commit message and fixed typo.
v1: https://lore.kernel.org/all/e8684abc2c8ced4e35026e8fa85fe29447ef60b6.1638103213.git.leonro@nvidia.com
 * Sent as standalone change
 * Moved struct recource from .h to .c file
 * Added missing descriptions fields in struct resource
v0: https://lore.kernel.org/all/cover.1637173517.git.leonro@nvidia.com
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  8 +--
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 +-
 drivers/net/netdevsim/dev.c                   |  4 +-
 include/net/devlink.h                         | 30 +--------
 net/core/devlink.c                            | 63 ++++++++++++++-----
 net/dsa/dsa.c                                 |  2 +-
 6 files changed, 58 insertions(+), 53 deletions(-)

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
index 24157bb59881..f1ed7660b0b5 100644
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
index e3c88fabd700..043fcec8b0aa 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -361,33 +361,6 @@ devlink_resource_size_params_init(struct devlink_resource_size_params *size_para
 
 typedef u64 devlink_resource_occ_get_t(void *priv);
 
-/**
- * struct devlink_resource - devlink resource
- * @name: name of the resource
- * @id: id, per devlink instance
- * @size: size of the resource
- * @size_new: updated size of the resource, reload is needed
- * @size_valid: valid in case the total size of the resource is valid
- *              including its children
- * @parent: parent resource
- * @size_params: size parameters
- * @list: parent list
- * @resource_list: list of child resources
- */
-struct devlink_resource {
-	const char *name;
-	u64 id;
-	u64 size;
-	u64 size_new;
-	bool size_valid;
-	struct devlink_resource *parent;
-	struct devlink_resource_size_params size_params;
-	struct list_head list;
-	struct list_head resource_list;
-	devlink_resource_occ_get_t *occ_get;
-	void *occ_get_priv;
-};
-
 #define DEVLINK_RESOURCE_ID_PARENT_TOP 0
 
 #define DEVLINK_RESOURCE_GENERIC_NAME_PORTS "physical_ports"
@@ -1571,8 +1544,7 @@ int devlink_resource_register(struct devlink *devlink,
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
index fd21022145a3..db3b52110cf2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -69,6 +69,35 @@ struct devlink {
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
+/**
+ * struct devlink_resource - devlink resource
+ * @name: name of the resource
+ * @id: id, per devlink instance
+ * @size: size of the resource
+ * @size_new: updated size of the resource, reload is needed
+ * @size_valid: valid in case the total size of the resource is valid
+ *              including its children
+ * @parent: parent resource
+ * @size_params: size parameters
+ * @list: parent list
+ * @resource_list: list of child resources
+ * @occ_get: occupancy getter callback
+ * @occ_get_priv: occupancy getter callback priv
+ */
+struct devlink_resource {
+	const char *name;
+	u64 id;
+	u64 size;
+	u64 size_new;
+	bool size_valid;
+	struct devlink_resource *parent;
+	struct devlink_resource_size_params size_params;
+	struct list_head list;
+	struct list_head resource_list;
+	devlink_resource_occ_get_t *occ_get;
+	void *occ_get_priv;
+};
+
 void *devlink_priv(struct devlink *devlink)
 {
 	return &devlink->priv;
@@ -9908,34 +9937,38 @@ int devlink_resource_register(struct devlink *devlink,
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

