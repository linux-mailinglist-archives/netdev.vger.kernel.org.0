Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453A21946A7
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgCZShg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:37:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:43777 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727446AbgCZShf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 14:37:35 -0400
IronPort-SDR: u6REnX8sVJrjlUz4T4t3r/YkAVqxFRjGi4ZA0WIa2VCNst2L74MGapUoQuj5eLxDkRzQEkkh/G
 zls4EiS7p66Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 11:37:23 -0700
IronPort-SDR: OTwNpUc2IEfdggVBe0B7IB6ZiRZ3tPc7twfTxPXpj40NBjPv4QT25j1M4mBcz9DnBiMW/d6JaP
 YrKS/v93xliQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="358241616"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 11:37:22 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v3 04/11] devlink: add function to take snapshot while locked
Date:   Thu, 26 Mar 2020 11:37:11 -0700
Message-Id: <20200326183718.2384349-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326183718.2384349-1-jacob.e.keller@intel.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
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
Changes since v1:
* Picked up Jakub's Reviewed-by

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

