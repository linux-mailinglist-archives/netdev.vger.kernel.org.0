Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D908814E5C3
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgA3W7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:22 -0500
Received: from mga12.intel.com ([192.55.52.136]:51507 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgA3W7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187765"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:20 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 02/15] devlink: add functions to take snapshot while locked
Date:   Thu, 30 Jan 2020 14:58:57 -0800
Message-Id: <20200130225913.1671982-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A future change is going to add a new devlink command to request
a snapshot on demand. This function will want to call the
devlink_region_snapshot_id_get and devlink_region_snapshot_create
functions while already holding the devlink instance lock.

Extract the logic of these two functions into static functions with the
_locked postfix. Modify the original functions to be implemented in
terms of the new locked functions.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 95 +++++++++++++++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 34 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d1f7bfbf81da..faf4f4c5c539 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3761,6 +3761,63 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	nlmsg_free(msg);
 }
 
+/**
+ *	devlink_region_snapshot_id_get_locked - get snapshot ID
+ *
+ *	Returns a new snapshot id. Must be called while holding the
+ *	devlink instance lock.
+ */
+static u32 devlink_region_snapshot_id_get_locked(struct devlink *devlink)
+{
+	return ++devlink->snapshot_id;
+}
+
+/**
+ *	devlink_region_snapshot_create_locked - create a new snapshot
+ *	This will add a new snapshot of a region. The snapshot
+ *	will be stored on the region struct and can be accessed
+ *	from devlink. This is useful for future	analyses of snapshots.
+ *	Multiple snapshots can be created on a region.
+ *	The @snapshot_id should be obtained using the getter function.
+ *
+ *	Must be called only while holding the devlink instance lock.
+ *
+ *	@region: devlink region of the snapshot
+ *	@data: snapshot data
+ *	@snapshot_id: snapshot id to be created
+ *	@destructor: pointer to destructor function to free data
+ */
+static int
+devlink_region_snapshot_create_locked(struct devlink_region *region,
+				      u8 *data, u32 snapshot_id,
+				      devlink_snapshot_data_dest_t *destructor)
+{
+	struct devlink_snapshot *snapshot;
+
+	/* check if region can hold one more snapshot */
+	if (region->cur_snapshots == region->max_snapshots)
+		return -ENOMEM;
+
+	if (devlink_region_snapshot_get_by_id(region, snapshot_id))
+		return -EEXIST;
+
+	snapshot = kzalloc(sizeof(*snapshot), GFP_KERNEL);
+	if (!snapshot)
+		return -ENOMEM;
+
+	snapshot->id = snapshot_id;
+	snapshot->region = region;
+	snapshot->data = data;
+	snapshot->data_destructor = destructor;
+
+	list_add_tail(&snapshot->list, &region->snapshot_list);
+
+	region->cur_snapshots++;
+
+	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_NEW);
+	return 0;
+}
+
 static void devlink_region_snapshot_del(struct devlink_region *region,
 					struct devlink_snapshot *snapshot)
 {
@@ -7611,7 +7668,7 @@ u32 devlink_region_snapshot_id_get(struct devlink *devlink)
 	u32 id;
 
 	mutex_lock(&devlink->lock);
-	id = ++devlink->snapshot_id;
+	id = devlink_region_snapshot_id_get_locked(devlink);
 	mutex_unlock(&devlink->lock);
 
 	return id;
@@ -7622,7 +7679,7 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
  *	devlink_region_snapshot_create - create a new snapshot
  *	This will add a new snapshot of a region. The snapshot
  *	will be stored on the region struct and can be accessed
- *	from devlink. This is useful for future	analyses of snapshots.
+ *	from devlink. This is useful for future analyses of snapshots.
  *	Multiple snapshots can be created on a region.
  *	The @snapshot_id should be obtained using the getter function.
  *
@@ -7636,43 +7693,13 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 				   devlink_snapshot_data_dest_t *data_destructor)
 {
 	struct devlink *devlink = region->devlink;
-	struct devlink_snapshot *snapshot;
 	int err;
 
 	mutex_lock(&devlink->lock);
-
-	/* check if region can hold one more snapshot */
-	if (region->cur_snapshots == region->max_snapshots) {
-		err = -ENOMEM;
-		goto unlock;
-	}
-
-	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
-		err = -EEXIST;
-		goto unlock;
-	}
-
-	snapshot = kzalloc(sizeof(*snapshot), GFP_KERNEL);
-	if (!snapshot) {
-		err = -ENOMEM;
-		goto unlock;
-	}
-
-	snapshot->id = snapshot_id;
-	snapshot->region = region;
-	snapshot->data = data;
-	snapshot->data_destructor = data_destructor;
-
-	list_add_tail(&snapshot->list, &region->snapshot_list);
-
-	region->cur_snapshots++;
-
-	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_NEW);
+	err = devlink_region_snapshot_create_locked(region, data, snapshot_id,
+						    data_destructor);
 	mutex_unlock(&devlink->lock);
-	return 0;
 
-unlock:
-	mutex_unlock(&devlink->lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_create);
-- 
2.25.0.rc1

