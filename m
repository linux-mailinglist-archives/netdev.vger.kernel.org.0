Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300241946AD
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgCZShq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:37:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:43777 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbgCZShh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 14:37:37 -0400
IronPort-SDR: d4D4Wv1As44fDbfCpOVpvDKbWG6YnQxvL9SFCWczSsNOEKJD8+NEcoppBtTQg89oKfLvZhhPJj
 dZ8PN6dSGPgA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 11:37:24 -0700
IronPort-SDR: yVcqPjrxvR6lp2VxHR6NIVA8ShVj9XHYkSmFEw3+iyog9yA+sA1nFoKDffF+210WpHdpoiHKb4
 w8JGCk74fmSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="358241645"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 11:37:24 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next v3 08/11] devlink: track snapshot id usage count using an xarray
Date:   Thu, 26 Mar 2020 11:37:15 -0700
Message-Id: <20200326183718.2384349-9-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326183718.2384349-1-jacob.e.keller@intel.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
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
insert an initial value of 1 value at an available slot between 0 and
U32_MAX.

The new __devlink_snapshot_id_increment() and
__devlink_snapshot_id_decrement() functions will be used to track how
many snapshots currently use an id.

Drivers must now call devlink_snapshot_id_put() in order to release
their reference of the snapshot id after adding region snapshots.

By tracking the total number of snapshots using a given id, it is
possible for the decrement() function to erase the id from the xarray
when it is not in use.

With this method, a snapshot id can become reused again once all
snapshots that referred to it have been deleted via
DEVLINK_CMD_REGION_DEL, and the driver has finished adding snapshots.

This work also paves the way to introduce a mechanism for userspace to
request a snapshot.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changes since RFC:
* Rewrote to use xarray directly, instead of IDR

Changes since v1:
* Add a new devlink_region_snapshot_id_put, and have the
  devlink_region_snapshot_id_get start the xarray usage count at 1. This
  fixes a race condition where the driver might create two snapshots using
  the id, but the first one is freed before the second one is created.
  Additionally it resolves an issue where the snapshot id could be locked
  forever if the driver does not create a snapshot due to an error.
* Add WARN_ON to checks in __devlink_snapshot_id_increment
* Remove "if (err) return err" constructions that occur just after a return
  0, as a direct return can be used instead.
* Rename goto labels to indicate the cause of failure instead of the action
  taken to clean up.
* Set XA_FLAGS_ALLOC so that xa_alloc can actually be used properly
* Remove the unnecessary locking around xa_destroy

Changes since v2:
* Move devlink variable assignment
* Remove a comment about placement of devlink_region_snapshot_id_put
* Renamed label to use "err_" prefix

 drivers/net/ethernet/mellanox/mlx4/crdump.c |   3 +
 drivers/net/netdevsim/dev.c                 |   6 +-
 include/net/devlink.h                       |   4 +-
 net/core/devlink.c                          | 130 +++++++++++++++++++-
 4 files changed, 135 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index 792951f6df0d..2700628f1689 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -203,6 +203,9 @@ int mlx4_crdump_collect(struct mlx4_dev *dev)
 	mlx4_crdump_collect_crspace(dev, cr_space, id);
 	mlx4_crdump_collect_fw_health(dev, cr_space, id);
 
+	/* Release reference on the snapshot id */
+	devlink_region_snapshot_id_put(devlink, id);
+
 	crdump_disable_crspace_access(dev, cr_space);
 
 	iounmap(cr_space);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 609005f2ac85..f4f6539f1e17 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -44,23 +44,27 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 					    size_t count, loff_t *ppos)
 {
 	struct nsim_dev *nsim_dev = file->private_data;
+	struct devlink *devlink;
 	void *dummy_data;
 	int err;
 	u32 id;
 
+	devlink = priv_to_devlink(nsim_dev);
+
 	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
 	if (!dummy_data)
 		return -ENOMEM;
 
 	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
 
-	err = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev), &id);
+	err = devlink_region_snapshot_id_get(devlink, &id);
 	if (err) {
 		pr_err("Failed to get snapshot id\n");
 		return err;
 	}
 	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
 					     dummy_data, id);
+	devlink_region_snapshot_id_put(devlink, id);
 	if (err) {
 		pr_err("Failed to create region snapshot\n");
 		kfree(dummy_data);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 9a46bc7fed90..fb9154060e6e 100644
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
@@ -977,6 +978,7 @@ devlink_region_create(struct devlink *devlink,
 		      u32 region_max_snapshots, u64 region_size);
 void devlink_region_destroy(struct devlink_region *region);
 int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id);
+void devlink_region_snapshot_id_put(struct devlink *devlink, u32 id);
 int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id);
 int devlink_info_serial_number_put(struct devlink_info_req *req,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 77341c65868f..b410fb126a66 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3768,6 +3768,83 @@ static void devlink_nl_region_notify(struct devlink_region *region,
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
+	void *p;
+
+	lockdep_assert_held(&devlink->lock);
+
+	p = xa_load(&devlink->snapshot_ids, id);
+	if (WARN_ON(!p))
+		return -EINVAL;
+
+	if (WARN_ON(!xa_is_value(p)))
+		return -EINVAL;
+
+	count = xa_to_value(p);
+	count++;
+
+	return xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(count),
+			       GFP_KERNEL));
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
+ *	Called when a snapshot using the given id is deleted, and when the
+ *	initial allocator of the id is finished using it.
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
@@ -3776,17 +3853,20 @@ static void devlink_nl_region_notify(struct devlink_region *region,
  *	Allocates a new snapshot id. Returns zero on success, or a negative
  *	error on failure. Must be called while holding the devlink instance
  *	lock.
+ *
+ *	Snapshot IDs are tracked using an xarray which stores the number of
+ *	users of the snapshot id.
+ *
+ *	Note that the caller of this function counts as a 'user', in order to
+ *	avoid race conditions. The caller must release its hold on the
+ *	snapshot by using devlink_region_snapshot_id_put.
  */
 static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
 	lockdep_assert_held(&devlink->lock);
 
-	if (devlink->snapshot_id >= U32_MAX)
-		return -ENOSPC;
-
-	*id = ++devlink->snapshot_id;
-
-	return 0;
+	return xa_alloc(&devlink->snapshot_ids, id, xa_mk_value(1),
+			xa_limit_32b, GFP_KERNEL);
 }
 
 /**
@@ -3809,6 +3889,7 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 {
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot;
+	int err;
 
 	lockdep_assert_held(&devlink->lock);
 
@@ -3823,6 +3904,10 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 	if (!snapshot)
 		return -ENOMEM;
 
+	err = __devlink_snapshot_id_increment(devlink, snapshot_id);
+	if (err)
+		goto err_snapshot_id_increment;
+
 	snapshot->id = snapshot_id;
 	snapshot->region = region;
 	snapshot->data = data;
@@ -3833,15 +3918,24 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 
 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_NEW);
 	return 0;
+
+err_snapshot_id_increment:
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
 
@@ -6494,6 +6588,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	if (!devlink)
 		return NULL;
 	devlink->ops = ops;
+	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
@@ -6598,6 +6693,8 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->sb_list));
 	WARN_ON(!list_empty(&devlink->port_list));
 
+	xa_destroy(&devlink->snapshot_ids);
+
 	kfree(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_free);
@@ -7789,6 +7886,9 @@ EXPORT_SYMBOL_GPL(devlink_region_destroy);
  *	Driver should use the same id for multiple snapshots taken
  *	on multiple regions at the same time/by the same trigger.
  *
+ *	The caller of this function must use devlink_region_snapshot_id_put
+ *	when finished creating regions using this id.
+ *
  *	Returns zero on success, or a negative error code on failure.
  *
  *	@devlink: devlink
@@ -7806,6 +7906,24 @@ int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
 
+/**
+ *	devlink_region_snapshot_id_put - put snapshot ID reference
+ *
+ *	This should be called by a driver after finishing creating snapshots
+ *	with an id. Doing so ensures that the ID can later be released in the
+ *	event that all snapshots using it have been destroyed.
+ *
+ *	@devlink: devlink
+ *	@id: id to release reference on
+ */
+void devlink_region_snapshot_id_put(struct devlink *devlink, u32 id)
+{
+	mutex_lock(&devlink->lock);
+	__devlink_snapshot_id_decrement(devlink, id);
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_put);
+
 /**
  *	devlink_region_snapshot_create - create a new snapshot
  *	This will add a new snapshot of a region. The snapshot
-- 
2.24.1

