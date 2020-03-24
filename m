Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0670E191CED
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgCXWfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:35:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:54988 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbgCXWfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 18:35:16 -0400
IronPort-SDR: KNepQk2j0/xTXx3L+g5uklZoCQ6LgA3hVEcWqIOh8lKkBOl6yAnqo3bHqqrkB1NGEc1anDq1Ep
 7KTNttczoFPg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 15:35:16 -0700
IronPort-SDR: ijd9ZTV/a9iE8wc3c784okHKSRCIYCUlOn9/JI3XUGDoK/3zX8Kj4X9sUfP8CTrHB9q0MBHXe4
 cbfxHd4XCh3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="238363195"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga007.fm.intel.com with ESMTP; 24 Mar 2020 15:35:16 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH 06/10] devlink: convert snapshot id getter to return an error
Date:   Tue, 24 Mar 2020 15:34:41 -0700
Message-Id: <20200324223445.2077900-7-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324223445.2077900-1-jacob.e.keller@intel.com>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the devlink_snapshot_id_get function to return a signed value,
enabling reporting an error on failure.

This enables easily refactoring how IDs are generated and kept track of
in the future. For now, just report ENOSPC once INT_MAX snapshot ids
have been returned.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c | 10 +++++++---
 drivers/net/netdevsim/dev.c                 |  7 +++++--
 include/net/devlink.h                       |  2 +-
 net/core/devlink.c                          | 16 +++++++++++-----
 4 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index c3f90c0f9554..723a66efdf32 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -169,7 +169,7 @@ int mlx4_crdump_collect(struct mlx4_dev *dev)
 	struct pci_dev *pdev = dev->persist->pdev;
 	unsigned long cr_res_size;
 	u8 __iomem *cr_space;
-	u32 id;
+	int id;
 
 	if (!dev->caps.health_buffer_addrs) {
 		mlx4_info(dev, "crdump: FW doesn't support health buffer access, skipping\n");
@@ -189,10 +189,14 @@ int mlx4_crdump_collect(struct mlx4_dev *dev)
 		return -ENODEV;
 	}
 
-	crdump_enable_crspace_access(dev, cr_space);
-
 	/* Get the available snapshot ID for the dumps */
 	id = devlink_region_snapshot_id_get(devlink);
+	if (id < 0) {
+		mlx4_err(dev, "crdump: devlink get snapshot id err %d\n", id);
+		return id;
+	}
+
+	crdump_enable_crspace_access(dev, cr_space);
 
 	/* Try to capture dumps */
 	mlx4_crdump_collect_crspace(dev, cr_space, id);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f7621ccb7b88..f9420b77e5fd 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -45,8 +45,7 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 {
 	struct nsim_dev *nsim_dev = file->private_data;
 	void *dummy_data;
-	int err;
-	u32 id;
+	int err, id;
 
 	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
 	if (!dummy_data)
@@ -55,6 +54,10 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
 
 	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
+	if (id < 0) {
+		pr_err("Failed to get snapshot id\n");
+		return id;
+	}
 	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
 					     dummy_data, id);
 	if (err) {
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8869ad75b965..df9f6ddf6c66 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -976,7 +976,7 @@ devlink_region_create(struct devlink *devlink,
 		      const struct devlink_region_ops *ops,
 		      u32 region_max_snapshots, u64 region_size);
 void devlink_region_destroy(struct devlink_region *region);
-u32 devlink_region_snapshot_id_get(struct devlink *devlink);
+int devlink_region_snapshot_id_get(struct devlink *devlink);
 int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id);
 int devlink_info_serial_number_put(struct devlink_info_req *req,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6dc14eb2a5f7..62a8566e9851 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3772,12 +3772,16 @@ static void devlink_nl_region_notify(struct devlink_region *region,
  *	__devlink_region_snapshot_id_get - get snapshot ID
  *	@devlink: devlink instance
  *
- *	Returns a new snapshot id. Must be called while holding the
- *	devlink instance lock.
+ *	Returns a new snapshot id or a negative error code on failure. Must be
+ *	called while holding the devlink instance lock.
  */
-static u32 __devlink_region_snapshot_id_get(struct devlink *devlink)
+static int __devlink_region_snapshot_id_get(struct devlink *devlink)
 {
 	lockdep_assert_held(&devlink->lock);
+
+	if (devlink->snapshot_id >= INT_MAX)
+		return -ENOSPC;
+
 	return ++devlink->snapshot_id;
 }
 
@@ -7781,11 +7785,13 @@ EXPORT_SYMBOL_GPL(devlink_region_destroy);
  *	Driver should use the same id for multiple snapshots taken
  *	on multiple regions at the same time/by the same trigger.
  *
+ *	Returns a positive id or a negative error code on failure.
+ *
  *	@devlink: devlink
  */
-u32 devlink_region_snapshot_id_get(struct devlink *devlink)
+int devlink_region_snapshot_id_get(struct devlink *devlink)
 {
-	u32 id;
+	int id;
 
 	mutex_lock(&devlink->lock);
 	id = __devlink_region_snapshot_id_get(devlink);
-- 
2.24.1

