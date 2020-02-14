Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA07C15FA53
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgBNXWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:35 -0500
Received: from mga06.intel.com ([134.134.136.31]:30964 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgBNXWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629314"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:28 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 15/22] netdevsim: support taking immediate snapshot via devlink
Date:   Fri, 14 Feb 2020 15:22:14 -0800
Message-Id: <20200214232223.3442651-16-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
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
 drivers/net/netdevsim/dev.c                   | 27 +++++++++++++++----
 .../drivers/net/netdevsim/devlink.sh          | 15 +++++++++++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e30bd94c3d52..a54b03d49c89 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -38,13 +38,11 @@ static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
 
-static ssize_t nsim_dev_take_snapshot_write(struct file *file,
-					    const char __user *data,
-					    size_t count, loff_t *ppos)
+static int
+nsim_dev_take_snapshot(struct devlink *devlink, struct netlink_ext_ack *extack,
+		       u8 **data)
 {
-	struct nsim_dev *nsim_dev = file->private_data;
 	void *dummy_data;
-	int err, id;
 
 	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
 	if (!dummy_data)
@@ -52,6 +50,24 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 
 	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
 
+	*data = dummy_data;
+
+	return 0;
+}
+
+static ssize_t nsim_dev_take_snapshot_write(struct file *file,
+					    const char __user *data,
+					    size_t count, loff_t *ppos)
+{
+	struct nsim_dev *nsim_dev = file->private_data;
+	u8 *dummy_data;
+	int err, id;
+
+	err = nsim_dev_take_snapshot(priv_to_devlink(nsim_dev), NULL,
+				     &dummy_data);
+	if (err)
+		return err;
+
 	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
 	if (id < 0) {
 		pr_err("Failed to get snapshot id\n");
@@ -251,6 +267,7 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
 static const struct devlink_region_ops dummy_region_ops = {
 	.name = "dummy",
 	.destructor = &kfree,
+	.snapshot = nsim_dev_take_snapshot,
 };
 
 static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 025a84c2ab5a..f23383fd108c 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -141,6 +141,21 @@ regions_test()
 
 	check_region_snapshot_count dummy post-first-delete 2
 
+	devlink region new $DL_HANDLE/dummy
+	check_err $? "Failed to create a new a snapshot"
+
+	check_region_snapshot_count dummy post-request 3
+
+	devlink region new $DL_HANDLE/dummy snapshot 25
+	check_err $? "Failed to create a new snapshot with id 25"
+
+	check_region_snapshot_count dummy post-request 4
+
+	devlink region del $DL_HANDLE/dummy snapshot 25
+	check_err $? "Failed to delete snapshot with id 25"
+
+	check_region_snapshot_count dummy post-request 3
+
 	log_test "regions test"
 }
 
-- 
2.25.0.368.g28a2d05eebfb

