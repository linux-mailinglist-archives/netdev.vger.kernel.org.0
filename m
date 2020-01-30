Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDDE14E5C0
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 23:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgA3W71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:51507 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727585AbgA3W7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187774"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:21 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 04/15] netdevsim: support taking immediate snapshot via devlink
Date:   Thu, 30 Jan 2020 14:58:59 -0800
Message-Id: <20200130225913.1671982-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the .snapshot region operation for the dummy data region. This
enables a region snapshot to be taken upon request via the new
DEVLINK_CMD_REGION_SNAPSHOT command.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/netdevsim/dev.c                   | 38 +++++++++++++++----
 .../drivers/net/netdevsim/devlink.sh          |  5 +++
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d521b7bfe007..924cd328037f 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -38,24 +38,47 @@ static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
 
+static int nsim_dev_take_snapshot(struct devlink *devlink,
+				  struct netlink_ext_ack *extack,
+				  u8 **data,
+				  devlink_snapshot_data_dest_t **destructor)
+{
+	void *dummy_data;
+
+	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
+	if (!dummy_data) {
+		NL_SET_ERR_MSG(extack, "Out of memory");
+		return -ENOMEM;
+	}
+
+	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
+
+	*data = dummy_data;
+	*destructor = kfree;
+
+	return 0;
+}
+
 static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 					    const char __user *data,
 					    size_t count, loff_t *ppos)
 {
 	struct nsim_dev *nsim_dev = file->private_data;
-	void *dummy_data;
+	devlink_snapshot_data_dest_t *destructor;
+	u8 *dummy_data;
 	int err;
 	u32 id;
 
-	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
-	if (!dummy_data)
-		return -ENOMEM;
-
-	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
+	err = nsim_dev_take_snapshot(priv_to_devlink(nsim_dev), NULL,
+				     &dummy_data, &destructor);
+	if (err) {
+		pr_err("Failed to capture region snapshot\n");
+		return err;
+	}
 
 	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
 	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
-					     dummy_data, id, kfree);
+					     dummy_data, id, destructor);
 	if (err) {
 		pr_err("Failed to create region snapshot\n");
 		kfree(dummy_data);
@@ -244,6 +267,7 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
 
 static const struct devlink_region_ops dummy_region_ops = {
 	.name = "dummy",
+	.snapshot = nsim_dev_take_snapshot,
 };
 
 static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 025a84c2ab5a..e7827a092478 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -141,6 +141,11 @@ regions_test()
 
 	check_region_snapshot_count dummy post-first-delete 2
 
+	devlink region snapshot $DL_HANDLE/dummy
+	check_err $? "Failed to request a snapshot"
+
+	check_region_snapshot_count dummy post-request 3
+
 	log_test "regions test"
 }
 
-- 
2.25.0.rc1

