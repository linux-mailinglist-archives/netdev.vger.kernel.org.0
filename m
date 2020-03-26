Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76187193728
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgCZDwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:52:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:29077 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbgCZDwO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:52:14 -0400
IronPort-SDR: WSWI6mFRC/ZDy+zO8JW4kSjYe+hIo7gA4heyDgVpd8fDJWK9Ira7NLZ43LKG+u9uev120CGeG8
 wicR4gQXSl7w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 20:52:13 -0700
IronPort-SDR: 5vvNQOz8TvblnGeje6eRoLzukvmxVBZ7WTshsQrJqNG9zhwXUM+Ux4C6jrXvnMPDH2FTEW89F9
 lIKJ6FjfwX8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="271028103"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 25 Mar 2020 20:52:12 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [net-next v2 04/11] devlink: add function to take snapshot while locked
Date:   Wed, 25 Mar 2020 20:51:50 -0700
Message-Id: <20200326035157.2211090-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326035157.2211090-1-jacob.e.keller@intel.com>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A future change is going to add a new devlink command to request
a snapshot on demand. This function will want to call the
devlink_region_snapshot_create function while already holding the
devlink instance lock.

Extract the logic of this function into a static function prefixed by
`__` to indicate that it is an internal helper function. Modify the
original function to be implemented in terms of the new locked
function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/devlink.c | 78 ++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 31 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 73e66a779c13..620e9d07ac85 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3768,6 +3768,52 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	nlmsg_free(msg);
 }
 
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
@@ -7752,42 +7798,12 @@ int devlink_region_snapshot_create(struct devlink_region *region,
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
2.24.1

