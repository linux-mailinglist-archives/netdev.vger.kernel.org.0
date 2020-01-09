Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDB8136122
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbgAITdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:33:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:37095 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730434AbgAITdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 14:33:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 11:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="223970932"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2020 11:33:14 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     valex@mellanox.com, jiri@resnulli.us,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 1/3] devlink: add callback to trigger region snapshots
Date:   Thu,  9 Jan 2020 11:33:08 -0800
Message-Id: <20200109193311.1352330-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109193311.1352330-1-jacob.e.keller@intel.com>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a trigger_snapshot parameter to the devlink_region_create function.
This is a function pointer that will be used to enable devlink API to
request a snapshot of a region.

Passing NULL is acceptable to indicate the region does not support
triggered snapshots.

Future commits will introduce the new devlink command and modify
netdevsim as an example of how the trigger will work.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c |  4 ++--
 drivers/net/netdevsim/dev.c                 |  3 ++-
 include/net/devlink.h                       | 12 ++++++++----
 net/core/devlink.c                          | 11 +++++++----
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index 64ed725aec28..4b1373414b0b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -207,7 +207,7 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
 		devlink_region_create(devlink,
 				      region_cr_space_str,
 				      MAX_NUM_OF_DUMPS_TO_STORE,
-				      pci_resource_len(pdev, 0));
+				      pci_resource_len(pdev, 0), NULL);
 	if (IS_ERR(crdump->region_crspace))
 		mlx4_warn(dev, "crdump: create devlink region %s err %ld\n",
 			  region_cr_space_str,
@@ -218,7 +218,7 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
 		devlink_region_create(devlink,
 				      region_fw_health_str,
 				      MAX_NUM_OF_DUMPS_TO_STORE,
-				      HEALTH_BUFFER_SIZE);
+				      HEALTH_BUFFER_SIZE, NULL);
 	if (IS_ERR(crdump->region_fw_health))
 		mlx4_warn(dev, "crdump: create devlink region %s err %ld\n",
 			  region_fw_health_str,
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 4b39aba2e9c4..2af97eeb7ba1 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -248,7 +248,8 @@ static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
 	nsim_dev->dummy_region =
 		devlink_region_create(devlink, "dummy",
 				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
-				      NSIM_DEV_DUMMY_REGION_SIZE);
+				      NSIM_DEV_DUMMY_REGION_SIZE,
+				      NULL);
 	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
 }
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 38b4acb93f74..f93b1a07c9f2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -491,6 +491,10 @@ struct devlink_info_req;
 
 typedef void devlink_snapshot_data_dest_t(const void *data);
 
+typedef int devlink_trigger_snapshot_t(struct devlink *devlink,
+				       struct devlink_region *region,
+				       struct netlink_ext_ack *extack);
+
 struct devlink_fmsg;
 struct devlink_health_reporter;
 
@@ -933,10 +937,10 @@ void devlink_port_param_value_changed(struct devlink_port *devlink_port,
 				      u32 param_id);
 void devlink_param_value_str_fill(union devlink_param_value *dst_val,
 				  const char *src);
-struct devlink_region *devlink_region_create(struct devlink *devlink,
-					     const char *region_name,
-					     u32 region_max_snapshots,
-					     u64 region_size);
+struct devlink_region *
+devlink_region_create(struct devlink *devlink, const char *region_name,
+		      u32 region_max_snapshots, u64 region_size,
+		      devlink_trigger_snapshot_t *trigger_snapshot);
 void devlink_region_destroy(struct devlink_region *region);
 u32 devlink_region_snapshot_id_get(struct devlink *devlink);
 int devlink_region_snapshot_create(struct devlink_region *region,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b6fc67dbd612..e54600afdaf0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -349,6 +349,7 @@ struct devlink_region {
 	u32 max_snapshots;
 	u32 cur_snapshots;
 	u64 size;
+	devlink_trigger_snapshot_t *trigger_snapshot;
 };
 
 struct devlink_snapshot {
@@ -7499,11 +7500,12 @@ EXPORT_SYMBOL_GPL(devlink_param_value_str_fill);
  *	@region_name: region name
  *	@region_max_snapshots: Maximum supported number of snapshots for region
  *	@region_size: size of region
+ *	@trigger_snapshot: function to trigger creation of snapshot
  */
-struct devlink_region *devlink_region_create(struct devlink *devlink,
-					     const char *region_name,
-					     u32 region_max_snapshots,
-					     u64 region_size)
+struct devlink_region *
+devlink_region_create(struct devlink *devlink, const char *region_name,
+		      u32 region_max_snapshots, u64 region_size,
+		      devlink_trigger_snapshot_t *trigger_snapshot)
 {
 	struct devlink_region *region;
 	int err = 0;
@@ -7525,6 +7527,7 @@ struct devlink_region *devlink_region_create(struct devlink *devlink,
 	region->max_snapshots = region_max_snapshots;
 	region->name = region_name;
 	region->size = region_size;
+	region->trigger_snapshot = trigger_snapshot;
 	INIT_LIST_HEAD(&region->snapshot_list);
 	list_add_tail(&region->list, &devlink->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
-- 
2.25.0.rc1

