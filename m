Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788CC191CE8
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgCXWfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:35:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:54988 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbgCXWfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 18:35:00 -0400
IronPort-SDR: 3xjy8ACJvuHz3s8NXF9XvLEGYojeXAPgZd8axkwkNmmajXwy9RW9Fs/idXBFMMozKoEgrlcuDR
 CDQd65p4CSOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 15:35:00 -0700
IronPort-SDR: UFl7cGoACukdOS4za7or5bIqVHHPugv/dkQfj8hCnWcTqLj/4/bwVC9d/mqA63lMWu/fPqXS/3
 q1KUbBohmd8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="238363135"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga007.fm.intel.com with ESMTP; 24 Mar 2020 15:35:00 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH 02/10] devlink: convert snapshot destructor callback to region op
Date:   Tue, 24 Mar 2020 15:34:37 -0700
Message-Id: <20200324223445.2077900-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324223445.2077900-1-jacob.e.keller@intel.com>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It does not makes sense that two snapshots for a given region would use
different destructors. Simplify snapshot creation by adding
a .destructor op for regions.

This operation will replace the data_destructor for the snapshot
creation, and makes snapshot creation easier.

Noticed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c |  6 ++++--
 drivers/net/netdevsim/dev.c                 |  3 ++-
 include/net/devlink.h                       |  7 +++----
 net/core/devlink.c                          | 11 +++++------
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index cc2bf596c74b..c3f90c0f9554 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -43,10 +43,12 @@ static const char * const region_fw_health_str = "fw-health";
 
 static const struct devlink_region_ops region_cr_space_ops = {
 	.name = region_cr_space_str,
+	.destructor = &kvfree,
 };
 
 static const struct devlink_region_ops region_fw_health_ops = {
 	.name = region_fw_health_str,
+	.destructor = &kvfree,
 };
 
 /* Set to true in case cr enable bit was set to true before crdump */
@@ -107,7 +109,7 @@ static void mlx4_crdump_collect_crspace(struct mlx4_dev *dev,
 					readl(cr_space + offset);
 
 		err = devlink_region_snapshot_create(crdump->region_crspace,
-						     crspace_data, id, &kvfree);
+						     crspace_data, id);
 		if (err) {
 			kvfree(crspace_data);
 			mlx4_warn(dev, "crdump: devlink create %s snapshot id %d err %d\n",
@@ -146,7 +148,7 @@ static void mlx4_crdump_collect_fw_health(struct mlx4_dev *dev,
 					readl(health_buf_start + offset);
 
 		err = devlink_region_snapshot_create(crdump->region_fw_health,
-						     health_data, id, &kvfree);
+						     health_data, id);
 		if (err) {
 			kvfree(health_data);
 			mlx4_warn(dev, "crdump: devlink create %s snapshot id %d err %d\n",
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 47a8f8c570c4..f7621ccb7b88 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -56,7 +56,7 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 
 	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
 	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
-					     dummy_data, id, kfree);
+					     dummy_data, id);
 	if (err) {
 		pr_err("Failed to create region snapshot\n");
 		kfree(dummy_data);
@@ -342,6 +342,7 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
 
 static const struct devlink_region_ops dummy_region_ops = {
 	.name = "dummy",
+	.destructor = &kfree,
 };
 
 static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 85db5dd5184d..8869ad75b965 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -496,14 +496,14 @@ enum devlink_param_generic_id {
 struct devlink_region;
 struct devlink_info_req;
 
-typedef void devlink_snapshot_data_dest_t(const void *data);
-
 /**
  * struct devlink_region_ops - Region operations
  * @name: region name
+ * @destructor: callback used to free snapshot memory when deleting
  */
 struct devlink_region_ops {
 	const char *name;
+	void (*destructor)(const void *data);
 };
 
 struct devlink_fmsg;
@@ -978,8 +978,7 @@ devlink_region_create(struct devlink *devlink,
 void devlink_region_destroy(struct devlink_region *region);
 u32 devlink_region_snapshot_id_get(struct devlink *devlink);
 int devlink_region_snapshot_create(struct devlink_region *region,
-				   u8 *data, u32 snapshot_id,
-				   devlink_snapshot_data_dest_t *data_destructor);
+				   u8 *data, u32 snapshot_id);
 int devlink_info_serial_number_put(struct devlink_info_req *req,
 				   const char *sn);
 int devlink_info_driver_name_put(struct devlink_info_req *req,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ca5362530567..84d74fbcff62 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -354,7 +354,6 @@ struct devlink_region {
 struct devlink_snapshot {
 	struct list_head list;
 	struct devlink_region *region;
-	devlink_snapshot_data_dest_t *data_destructor;
 	u8 *data;
 	u32 id;
 };
@@ -3775,7 +3774,7 @@ static void devlink_region_snapshot_del(struct devlink_region *region,
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
 	region->cur_snapshots--;
 	list_del(&snapshot->list);
-	(*snapshot->data_destructor)(snapshot->data);
+	region->ops->destructor(snapshot->data);
 	kfree(snapshot);
 }
 
@@ -7659,6 +7658,9 @@ devlink_region_create(struct devlink *devlink,
 	struct devlink_region *region;
 	int err = 0;
 
+	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
+		return ERR_PTR(-EINVAL);
+
 	mutex_lock(&devlink->lock);
 
 	if (devlink_region_get_by_name(devlink, ops->name)) {
@@ -7745,11 +7747,9 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
  *	@region: devlink region of the snapshot
  *	@data: snapshot data
  *	@snapshot_id: snapshot id to be created
- *	@data_destructor: pointer to destructor function to free data
  */
 int devlink_region_snapshot_create(struct devlink_region *region,
-				   u8 *data, u32 snapshot_id,
-				   devlink_snapshot_data_dest_t *data_destructor)
+				   u8 *data, u32 snapshot_id)
 {
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot;
@@ -7777,7 +7777,6 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 	snapshot->id = snapshot_id;
 	snapshot->region = region;
 	snapshot->data = data;
-	snapshot->data_destructor = data_destructor;
 
 	list_add_tail(&snapshot->list, &region->snapshot_list);
 
-- 
2.24.1

