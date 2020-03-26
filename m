Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E931946A8
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgCZShi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:37:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:43782 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgCZShg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 14:37:36 -0400
IronPort-SDR: NBSVcXP/k+ZjTa6AdryL9sXMxqYfNFwPWPGESOEUDuvO7WHs/tqZPlvtjP/IQzOe2G5nSzxnWN
 3+zC+0a0Vc7A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 11:37:24 -0700
IronPort-SDR: yA7zKV6Ats899XqPsOXmvO0KtofcjVcxGwjUzVnUm7kAbpw6geo3CHMSyZZ51cp9aDaaUZfNki
 C5jL/o0q8oiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="358241637"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 11:37:23 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v3 07/11] devlink: report error once U32_MAX snapshot ids have been used
Date:   Thu, 26 Mar 2020 11:37:14 -0700
Message-Id: <20200326183718.2384349-8-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326183718.2384349-1-jacob.e.keller@intel.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink_snapshot_id_get() function returns a snapshot id. The
snapshot id is a u32, so there is no way to indicate an error code.

A future change is going to possibly add additional cases where this
function could fail. Refactor the function to return the snapshot id in
an argument, so that it can return zero or an error value.

This ensures that snapshot ids cannot be confused with error values, and
aids in the future refactor of snapshot id allocation management.

Because there is no current way to release previously used snapshot ids,
add a simple check ensuring that an error is reported in case the
snapshot_id would over flow.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
Changes since RFC:
* Picked up Jiri's Reviewed-by

Changes since v1:
* Refactored this patch to return the id in an argument, instead of
  conflating id and error in the return value of the function.
* Allow up to U32_MAX instead of INT_MAX
* Removed Jiri's Reviewed-by, since this is a complete re-write

Changes since v2:
* Fix commit message to avoid incorrect statement about checking snapshot
  ids. This referred to a previous version of the code which has been
  removed.
* Fixed a build failure due to forgetting a '{' bracket which got lost in a
  rebase conflict.
* Picked up Jiri's Reviewed-by again

 drivers/net/ethernet/mellanox/mlx4/crdump.c | 11 ++++++---
 drivers/net/netdevsim/dev.c                 |  6 ++++-
 include/net/devlink.h                       |  2 +-
 net/core/devlink.c                          | 27 +++++++++++++++------
 4 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index c3f90c0f9554..792951f6df0d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -169,6 +169,7 @@ int mlx4_crdump_collect(struct mlx4_dev *dev)
 	struct pci_dev *pdev = dev->persist->pdev;
 	unsigned long cr_res_size;
 	u8 __iomem *cr_space;
+	int err;
 	u32 id;
 
 	if (!dev->caps.health_buffer_addrs) {
@@ -189,10 +190,14 @@ int mlx4_crdump_collect(struct mlx4_dev *dev)
 		return -ENODEV;
 	}
 
-	crdump_enable_crspace_access(dev, cr_space);
-
 	/* Get the available snapshot ID for the dumps */
-	id = devlink_region_snapshot_id_get(devlink);
+	err = devlink_region_snapshot_id_get(devlink, &id);
+	if (err) {
+		mlx4_err(dev, "crdump: devlink get snapshot id err %d\n", err);
+		return err;
+	}
+
+	crdump_enable_crspace_access(dev, cr_space);
 
 	/* Try to capture dumps */
 	mlx4_crdump_collect_crspace(dev, cr_space, id);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f7621ccb7b88..609005f2ac85 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -54,7 +54,11 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 
 	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
 
-	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
+	err = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev), &id);
+	if (err) {
+		pr_err("Failed to get snapshot id\n");
+		return err;
+	}
 	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
 					     dummy_data, id);
 	if (err) {
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8869ad75b965..9a46bc7fed90 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -976,7 +976,7 @@ devlink_region_create(struct devlink *devlink,
 		      const struct devlink_region_ops *ops,
 		      u32 region_max_snapshots, u64 region_size);
 void devlink_region_destroy(struct devlink_region *region);
-u32 devlink_region_snapshot_id_get(struct devlink *devlink);
+int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id);
 int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id);
 int devlink_info_serial_number_put(struct devlink_info_req *req,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 457b8303ae59..77341c65868f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3771,14 +3771,22 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 /**
  *	__devlink_region_snapshot_id_get - get snapshot ID
  *	@devlink: devlink instance
+ *	@id: storage to return snapshot id
  *
- *	Returns a new snapshot id. Must be called while holding the
- *	devlink instance lock.
+ *	Allocates a new snapshot id. Returns zero on success, or a negative
+ *	error on failure. Must be called while holding the devlink instance
+ *	lock.
  */
-static u32 __devlink_region_snapshot_id_get(struct devlink *devlink)
+static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
 	lockdep_assert_held(&devlink->lock);
-	return ++devlink->snapshot_id;
+
+	if (devlink->snapshot_id >= U32_MAX)
+		return -ENOSPC;
+
+	*id = ++devlink->snapshot_id;
+
+	return 0;
 }
 
 /**
@@ -7781,17 +7789,20 @@ EXPORT_SYMBOL_GPL(devlink_region_destroy);
  *	Driver should use the same id for multiple snapshots taken
  *	on multiple regions at the same time/by the same trigger.
  *
+ *	Returns zero on success, or a negative error code on failure.
+ *
  *	@devlink: devlink
+ *	@id: storage to return id
  */
-u32 devlink_region_snapshot_id_get(struct devlink *devlink)
+int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
-	u32 id;
+	int err;
 
 	mutex_lock(&devlink->lock);
-	id = __devlink_region_snapshot_id_get(devlink);
+	err = __devlink_region_snapshot_id_get(devlink, id);
 	mutex_unlock(&devlink->lock);
 
-	return id;
+	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
 
-- 
2.24.1

