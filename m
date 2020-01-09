Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E9A1360C0
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388667AbgAITIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:08:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:22128 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730193AbgAITIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 14:08:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 11:08:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="371388510"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga004.jf.intel.com with ESMTP; 09 Jan 2020 11:08:23 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     valex@mellanox.com, jiri@resnulli.us,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 1/2] devlink: correct misspelling of snapshot
Date:   Thu,  9 Jan 2020 11:08:20 -0800
Message-Id: <20200109190821.1335579-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function to obtain a unique snapshot id was mistakenly typo'd as
devlink_region_shapshot_id_get. Fix this typo by renaming the function
and all of its users.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c | 2 +-
 drivers/net/netdevsim/dev.c                 | 2 +-
 include/net/devlink.h                       | 2 +-
 net/core/devlink.c                          | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index eaf08f7ad128..64ed725aec28 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -182,7 +182,7 @@ int mlx4_crdump_collect(struct mlx4_dev *dev)
 	crdump_enable_crspace_access(dev, cr_space);
 
 	/* Get the available snapshot ID for the dumps */
-	id = devlink_region_shapshot_id_get(devlink);
+	id = devlink_region_snapshot_id_get(devlink);
 
 	/* Try to capture dumps */
 	mlx4_crdump_collect_crspace(dev, cr_space, id);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 059711edfc61..4b39aba2e9c4 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -53,7 +53,7 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 
 	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
 
-	id = devlink_region_shapshot_id_get(priv_to_devlink(nsim_dev));
+	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
 	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
 					     dummy_data, id, kfree);
 	if (err) {
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 47f87b2fcf63..38b4acb93f74 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -938,7 +938,7 @@ struct devlink_region *devlink_region_create(struct devlink *devlink,
 					     u32 region_max_snapshots,
 					     u64 region_size);
 void devlink_region_destroy(struct devlink_region *region);
-u32 devlink_region_shapshot_id_get(struct devlink *devlink);
+u32 devlink_region_snapshot_id_get(struct devlink *devlink);
 int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id,
 				   devlink_snapshot_data_dest_t *data_destructor);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4c63c9a4c09e..b6fc67dbd612 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7563,7 +7563,7 @@ void devlink_region_destroy(struct devlink_region *region)
 EXPORT_SYMBOL_GPL(devlink_region_destroy);
 
 /**
- *	devlink_region_shapshot_id_get - get snapshot ID
+ *	devlink_region_snapshot_id_get - get snapshot ID
  *
  *	This callback should be called when adding a new snapshot,
  *	Driver should use the same id for multiple snapshots taken
@@ -7571,7 +7571,7 @@ EXPORT_SYMBOL_GPL(devlink_region_destroy);
  *
  *	@devlink: devlink
  */
-u32 devlink_region_shapshot_id_get(struct devlink *devlink)
+u32 devlink_region_snapshot_id_get(struct devlink *devlink)
 {
 	u32 id;
 
@@ -7581,7 +7581,7 @@ u32 devlink_region_shapshot_id_get(struct devlink *devlink)
 
 	return id;
 }
-EXPORT_SYMBOL_GPL(devlink_region_shapshot_id_get);
+EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
 
 /**
  *	devlink_region_snapshot_create - create a new snapshot
-- 
2.25.0.rc1

