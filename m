Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7629B19372D
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgCZDwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:52:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:29078 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbgCZDwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:52:16 -0400
IronPort-SDR: zEVELhQ7p9TgpyDQpXf90WY17K3mpQyjeOT/lJIlDELc6NyZqasDvKxRgdyILRMvSTfKQHVcBS
 elAZ78rWSNvA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 20:52:14 -0700
IronPort-SDR: J4d/QIZqUEJT9ihgvApT5xjVcCVhb4XEOzz4g63uylrTV27ji5FWbt5lV2lefmmXoJa3vXvADw
 T1sltJ1ht2Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="271028115"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 25 Mar 2020 20:52:13 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v2 07/11] devlink: report error once U32_MAX snapshot ids have been used
Date:   Wed, 25 Mar 2020 20:51:53 -0700
Message-Id: <20200326035157.2211090-8-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326035157.2211090-1-jacob.e.keller@intel.com>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink_snapshot_id_get() function returns a snapshot id. The
snapshot id is a u32, so there is no way to indicate an error code.

Indeed, the two current callers of devlink_snapshot_id_get() assume that
a negative value is an error.

A future change is going to possibly add additional cases where this
function could fail. Refactor the function to return the snapshot id in
an argument, so that it can return zero or an error value.

This ensures that snapshot ids cannot be confused with error values, and
aids in the future refactor of snapshot id allocation management.

Because there is no current way to release previously used snapshot ids,
add a simple check ensuring that an error is reported in case the
snapshot_id would over flow.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
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
index f7621ccb7b88..b851fe63a75d 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -54,7 +54,11 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 
 	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
 
-	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
+	err = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev), &id);
+	if (err)
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

