Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C254191CEE
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgCXWfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:35:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:54988 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbgCXWfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 18:35:19 -0400
IronPort-SDR: 64zferEmZDpcDRES+j99X3TQ9dnQ6kAYb5oMjMYRAp93XkiJUrWthAYAFuUynwL9nWUK27J1uG
 VcfCcXrthCqw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 15:35:19 -0700
IronPort-SDR: xZrFo/rJszK9hy2o6MhCX4DtBaxIxQ+cWnsG1rr/9tXDyzixJSUTTdxiK9LUMLp+L3aZQ4WXTv
 TqH9sKfzzQqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="238363204"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga007.fm.intel.com with ESMTP; 24 Mar 2020 15:35:18 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH] devlink: track snapshot id usage count using an xarray
Date:   Tue, 24 Mar 2020 15:34:42 -0700
Message-Id: <20200324223445.2077900-8-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324223445.2077900-1-jacob.e.keller@intel.com>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each snapshot created for a devlink region must have an id. These ids
are supposed to be unique per "event" that caused the snapshot to be
created. Drivers call devlink_region_snapshot_id_get to obtain a new id
to use for a new event trigger. The id values are tracked per devlink,
so that the same id number can be used if a triggering event creates
multiple snapshots on different regions.

There is no mechanism for snapshot ids to ever be reused. Introduce an
xarray to store the count of how many snapshots are using a given id,
replacing the snapshot_id field previously used for picking the next id.

The devlink_region_snapshot_id_get() function will use xa_alloc to
insert a zero value at an available slot between 0 and INT_MAX.

The new __devlink_snapshot_id_increment() and
__devlink_snapshot_id_decrement() functions will be used to track how
many snapshots currently use an id.

By tracking the total number of snapshots using a given id, it is
possible for the decrement() function to erase the id from the xarray
when it is not in use.

With this method, a snapshot id can become reused again once all
snapshots that referred to it have been deleted via
DEVLINK_CMD_REGION_DEL.

This work also paves the way to introduce a mechanism for userspace to
request a snapshot.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/net/devlink.h |   3 +-
 net/core/devlink.c    | 119 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 118 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index df9f6ddf6c66..c366777c4f5c 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -18,6 +18,7 @@
 #include <net/net_namespace.h>
 #include <net/flow_offload.h>
 #include <uapi/linux/devlink.h>
+#include <linux/xarray.h>
 
 struct devlink_ops;
 
@@ -29,13 +30,13 @@ struct devlink {
 	struct list_head resource_list;
 	struct list_head param_list;
 	struct list_head region_list;
-	u32 snapshot_id;
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* protects reporter_list */
 	struct devlink_dpipe_headers *dpipe_headers;
 	struct list_head trap_list;
 	struct list_head trap_group_list;
 	const struct devlink_ops *ops;
+	struct xarray snapshot_ids;
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 62a8566e9851..b3698228a6ed 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3768,21 +3768,115 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	nlmsg_free(msg);
 }
 
+/**
+ * __devlink_snapshot_id_increment - Increment number of snapshots using an id
+ *	@devlink: devlink instance
+ *	@id: the snapshot id
+ *
+ *	Track when a new snapshot begins using an id. Load the count for the
+ *	given id from the snapshot xarray, increment it, and store it back.
+ *
+ *	Called when a new snapshot is created with the given id.
+ *
+ *	The id *must* have been previously allocated by
+ *	devlink_region_snapshot_id_get().
+ *
+ *	Returns 0 on success, or an error on failure.
+ */
+static int __devlink_snapshot_id_increment(struct devlink *devlink, u32 id)
+{
+	unsigned long count;
+	int err;
+	void *p;
+
+	lockdep_assert_held(&devlink->lock);
+
+	p = xa_load(&devlink->snapshot_ids, id);
+	if (!p)
+		return -EEXIST;
+
+	if (!xa_is_value(p))
+		return -EINVAL;
+
+	count = xa_to_value(p);
+	count++;
+
+	err = xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(count),
+			      GFP_KERNEL));
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/**
+ * __devlink_snapshot_id_decrement - Decrease number of snapshots using an id
+ *	@devlink: devlink instance
+ *	@id: the snapshot id
+ *
+ *	Track when a snapshot is deleted and stops using an id. Load the count
+ *	for the given id from the snapshot xarray, decrement it, and store it
+ *	back.
+ *
+ *	If the count reaches zero, erase this id from the xarray, freeing it
+ *	up for future re-use by devlink_region_snapshot_id_get().
+ *
+ *	Called when a snapshot using the given id is deleted.
+ */
+static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
+{
+	unsigned long count;
+	void *p;
+
+	lockdep_assert_held(&devlink->lock);
+
+	p = xa_load(&devlink->snapshot_ids, id);
+	if (WARN_ON(!p))
+		return;
+
+	if (WARN_ON(!xa_is_value(p)))
+		return;
+
+	count = xa_to_value(p);
+
+	if (count > 1) {
+		count--;
+		xa_store(&devlink->snapshot_ids, id, xa_mk_value(count),
+			 GFP_KERNEL);
+	} else {
+		/* If this was the last user, we can erase this id */
+		xa_erase(&devlink->snapshot_ids, id);
+	}
+}
+
 /**
  *	__devlink_region_snapshot_id_get - get snapshot ID
  *	@devlink: devlink instance
  *
  *	Returns a new snapshot id or a negative error code on failure. Must be
  *	called while holding the devlink instance lock.
+ *
+ *	Snapshot IDs are tracked using an xarray which stores the number of
+ *	snapshots currently using that index.
+ *
+ *	When getting a new id, there are no existing snapshots using it yet,
+ *	so the count is initialized at zero. Use the associated increment and
+ *	decrement functions when the number of snapshots using an id changes.
  */
 static int __devlink_region_snapshot_id_get(struct devlink *devlink)
 {
+	int err;
+	u32 id;
+
 	lockdep_assert_held(&devlink->lock);
 
-	if (devlink->snapshot_id >= INT_MAX)
-		return -ENOSPC;
+	/* xa_limit_31b ensures the id will be between 0 and INT_MAX */
+	err = xa_alloc(&devlink->snapshot_ids, &id, xa_mk_value(0),
+		       xa_limit_31b, GFP_KERNEL);
+	if (err)
+		return err;
 
-	return ++devlink->snapshot_id;
+	return id;
 }
 
 /**
@@ -3805,6 +3899,7 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 {
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot;
+	int err;
 
 	lockdep_assert_held(&devlink->lock);
 
@@ -3819,6 +3914,10 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 	if (!snapshot)
 		return -ENOMEM;
 
+	err = __devlink_snapshot_id_increment(devlink, snapshot_id);
+	if (err)
+		goto err_free_snapshot;
+
 	snapshot->id = snapshot_id;
 	snapshot->region = region;
 	snapshot->data = data;
@@ -3829,15 +3928,24 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_NEW);
 	return 0;
+
+err_free_snapshot:
+	kfree(snapshot);
+	return err;
 }
 
 static void devlink_region_snapshot_del(struct devlink_region *region,
 					struct devlink_snapshot *snapshot)
 {
+	struct devlink *devlink = region->devlink;
+
+	lockdep_assert_held(&devlink->lock);
+
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
 	region->cur_snapshots--;
 	list_del(&snapshot->list);
 	region->ops->destructor(snapshot->data);
+	__devlink_snapshot_id_decrement(devlink, snapshot->id);
 	kfree(snapshot);
 }
 
@@ -6490,6 +6598,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	if (!devlink)
 		return NULL;
 	devlink->ops = ops;
+	xa_init(&devlink->snapshot_ids);
 	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
@@ -6582,6 +6691,10 @@ EXPORT_SYMBOL_GPL(devlink_reload_disable);
  */
 void devlink_free(struct devlink *devlink)
 {
+	mutex_lock(&devlink->lock);
+	xa_destroy(&devlink->snapshot_ids);
+	mutex_unlock(&devlink->lock);
+
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_group_list));
-- 
2.24.1

