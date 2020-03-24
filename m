Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02DAE191CE7
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgCXWe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:34:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:54988 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbgCXWe5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 18:34:57 -0400
IronPort-SDR: zLYqPhS+B8Q64QbsI/GpwHeUj4m/bwOfYgFbzv10W7n/pM1dM5GBGJLXpXdDc3AmdiIhEHEWqD
 AnYx+VP2yvCw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 15:34:57 -0700
IronPort-SDR: fNlpOP8wLeHNafzsKRbTvS1gLj/2e+SfY9NnpxpqjfF5JD2t+YUPUyxnZCSGuP4l2HRNvN+mrJ
 hnKgjsmdjD9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="238363123"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga007.fm.intel.com with ESMTP; 24 Mar 2020 15:34:56 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH 01/10] devlink: prepare to support region operations
Date:   Tue, 24 Mar 2020 15:34:36 -0700
Message-Id: <20200324223445.2077900-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324223445.2077900-1-jacob.e.keller@intel.com>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the devlink region code in preparation for adding new operations
on regions.

Create a devlink_region_ops structure, and move the name pointer from
within the devlink_region structure into the ops structure (similar to
the devlink_health_reporter_ops).

This prepares the regions to enable support of additional operations in
the future such as requesting snapshots, or accessing the region
directly without a snapshot.

In order to re-use the constant strings in the mlx4 driver their
declaration must be changed to 'const char * const' to ensure the
compiler realizes that both the data and the pointer cannot change.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c | 16 +++++++++++----
 drivers/net/netdevsim/dev.c                 |  6 +++++-
 include/net/devlink.h                       | 16 +++++++++++----
 net/core/devlink.c                          | 22 ++++++++++-----------
 4 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index 64ed725aec28..cc2bf596c74b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -38,8 +38,16 @@
 #define CR_ENABLE_BIT_OFFSET		0xF3F04
 #define MAX_NUM_OF_DUMPS_TO_STORE	(8)
 
-static const char *region_cr_space_str = "cr-space";
-static const char *region_fw_health_str = "fw-health";
+static const char * const region_cr_space_str = "cr-space";
+static const char * const region_fw_health_str = "fw-health";
+
+static const struct devlink_region_ops region_cr_space_ops = {
+	.name = region_cr_space_str,
+};
+
+static const struct devlink_region_ops region_fw_health_ops = {
+	.name = region_fw_health_str,
+};
 
 /* Set to true in case cr enable bit was set to true before crdump */
 static bool crdump_enbale_bit_set;
@@ -205,7 +213,7 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
 	/* Create cr-space region */
 	crdump->region_crspace =
 		devlink_region_create(devlink,
-				      region_cr_space_str,
+				      &region_cr_space_ops,
 				      MAX_NUM_OF_DUMPS_TO_STORE,
 				      pci_resource_len(pdev, 0));
 	if (IS_ERR(crdump->region_crspace))
@@ -216,7 +224,7 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
 	/* Create fw-health region */
 	crdump->region_fw_health =
 		devlink_region_create(devlink,
-				      region_fw_health_str,
+				      &region_fw_health_ops,
 				      MAX_NUM_OF_DUMPS_TO_STORE,
 				      HEALTH_BUFFER_SIZE);
 	if (IS_ERR(crdump->region_fw_health))
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 7bfd0622cef1..47a8f8c570c4 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -340,11 +340,15 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
 
 #define NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX 16
 
+static const struct devlink_region_ops dummy_region_ops = {
+	.name = "dummy",
+};
+
 static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
 				      struct devlink *devlink)
 {
 	nsim_dev->dummy_region =
-		devlink_region_create(devlink, "dummy",
+		devlink_region_create(devlink, &dummy_region_ops,
 				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
 				      NSIM_DEV_DUMMY_REGION_SIZE);
 	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 37230e23b5b0..85db5dd5184d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -498,6 +498,14 @@ struct devlink_info_req;
 
 typedef void devlink_snapshot_data_dest_t(const void *data);
 
+/**
+ * struct devlink_region_ops - Region operations
+ * @name: region name
+ */
+struct devlink_region_ops {
+	const char *name;
+};
+
 struct devlink_fmsg;
 struct devlink_health_reporter;
 
@@ -963,10 +971,10 @@ void devlink_port_param_value_changed(struct devlink_port *devlink_port,
 				      u32 param_id);
 void devlink_param_value_str_fill(union devlink_param_value *dst_val,
 				  const char *src);
-struct devlink_region *devlink_region_create(struct devlink *devlink,
-					     const char *region_name,
-					     u32 region_max_snapshots,
-					     u64 region_size);
+struct devlink_region *
+devlink_region_create(struct devlink *devlink,
+		      const struct devlink_region_ops *ops,
+		      u32 region_max_snapshots, u64 region_size);
 void devlink_region_destroy(struct devlink_region *region);
 u32 devlink_region_snapshot_id_get(struct devlink *devlink);
 int devlink_region_snapshot_create(struct devlink_region *region,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 73bb8fbe3393..ca5362530567 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -344,7 +344,7 @@ devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
 struct devlink_region {
 	struct devlink *devlink;
 	struct list_head list;
-	const char *name;
+	const struct devlink_region_ops *ops;
 	struct list_head snapshot_list;
 	u32 max_snapshots;
 	u32 cur_snapshots;
@@ -365,7 +365,7 @@ devlink_region_get_by_name(struct devlink *devlink, const char *region_name)
 	struct devlink_region *region;
 
 	list_for_each_entry(region, &devlink->region_list, list)
-		if (!strcmp(region->name, region_name))
+		if (!strcmp(region->ops->name, region_name))
 			return region;
 
 	return NULL;
@@ -3695,7 +3695,7 @@ static int devlink_nl_region_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
-	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->name);
+	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->ops->name);
 	if (err)
 		goto nla_put_failure;
 
@@ -3741,7 +3741,7 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 		goto out_cancel_msg;
 
 	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME,
-			     region->name);
+			     region->ops->name);
 	if (err)
 		goto out_cancel_msg;
 
@@ -7647,21 +7647,21 @@ EXPORT_SYMBOL_GPL(devlink_param_value_str_fill);
  *	devlink_region_create - create a new address region
  *
  *	@devlink: devlink
- *	@region_name: region name
+ *	@ops: region operations and name
  *	@region_max_snapshots: Maximum supported number of snapshots for region
  *	@region_size: size of region
  */
-struct devlink_region *devlink_region_create(struct devlink *devlink,
-					     const char *region_name,
-					     u32 region_max_snapshots,
-					     u64 region_size)
+struct devlink_region *
+devlink_region_create(struct devlink *devlink,
+		      const struct devlink_region_ops *ops,
+		      u32 region_max_snapshots, u64 region_size)
 {
 	struct devlink_region *region;
 	int err = 0;
 
 	mutex_lock(&devlink->lock);
 
-	if (devlink_region_get_by_name(devlink, region_name)) {
+	if (devlink_region_get_by_name(devlink, ops->name)) {
 		err = -EEXIST;
 		goto unlock;
 	}
@@ -7674,7 +7674,7 @@ struct devlink_region *devlink_region_create(struct devlink *devlink,
 
 	region->devlink = devlink;
 	region->max_snapshots = region_max_snapshots;
-	region->name = region_name;
+	region->ops = ops;
 	region->size = region_size;
 	INIT_LIST_HEAD(&region->snapshot_list);
 	list_add_tail(&region->list, &devlink->region_list);
-- 
2.24.1

