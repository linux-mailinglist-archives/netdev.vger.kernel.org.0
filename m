Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B515FA51
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgBNXWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:41449 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728211AbgBNXWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629300"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:27 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 11/22] devlink: add functions to take snapshot while locked
Date:   Fri, 14 Feb 2020 15:22:10 -0800
Message-Id: <20200214232223.3442651-12-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
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

Extract the logic of these two functions into static functions prefixed
by `__` to indicate they are internal helper functions. Modify the
original functions to be implemented in terms of the new locked
functions.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 93 ++++++++++++++++++++++++++++++----------------
 1 file changed, 61 insertions(+), 32 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index fef93f48028c..0e94887713f4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3760,6 +3760,65 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	nlmsg_free(msg);
 }
 
+/**
+ *	__devlink_region_snapshot_id_get - get snapshot ID
+ *	@devlink: devlink instance
+ *
+ *	Returns a new snapshot id. Must be called while holding the
+ *	devlink instance lock.
+ */
+static u32 __devlink_region_snapshot_id_get(struct devlink *devlink)
+{
+	lockdep_assert_held(&devlink->lock);
+	return ++devlink->snapshot_id;
+}
+
+/**
+ *	__devlink_region_snapshot_create - create a new snapshot
+ *	This will add a new snapshot of a region. The snapshot
+ *	will be stored on the region struct and can be accessed
+ *	from devlink. This is useful for future analyses of snapshots.
+ *	Multiple snapshots can be created on a region.
+ *	The @snapshot_id should be obtained using the getter function.
+ *
+ *	Must be called only while holding the devlink instance lock.
+ *
+ *	@region: devlink region of the snapshot
+ *	@data: snapshot data
+ *	@snapshot_id: snapshot id to be created
+ */
+static int
+__devlink_region_snapshot_create(struct devlink_region *region,
+				 u8 *data, u32 snapshot_id)
+{
+	struct devlink *devlink = region->devlink;
+	struct devlink_snapshot *snapshot;
+
+	lockdep_assert_held(&devlink->lock);
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
@@ -7618,7 +7677,7 @@ u32 devlink_region_snapshot_id_get(struct devlink *devlink)
 	u32 id;
 
 	mutex_lock(&devlink->lock);
-	id = ++devlink->snapshot_id;
+	id = __devlink_region_snapshot_id_get(devlink);
 	mutex_unlock(&devlink->lock);
 
 	return id;
@@ -7641,42 +7700,12 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id)
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
-
-	list_add_tail(&snapshot->list, &region->snapshot_list);
-
-	region->cur_snapshots++;
-
-	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_NEW);
+	err = __devlink_region_snapshot_create(region, data, snapshot_id);
 	mutex_unlock(&devlink->lock);
-	return 0;
 
-unlock:
-	mutex_unlock(&devlink->lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_create);
-- 
2.25.0.368.g28a2d05eebfb

