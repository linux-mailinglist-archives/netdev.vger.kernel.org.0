Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E601946AA
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgCZShk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:37:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:43777 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbgCZShj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 14:37:39 -0400
IronPort-SDR: yn6dVZISom3Zi7BxMbpRoFS6wLlCm85qHkuysXLfvY3pKjwh9oTY4VDhmrMJAVkRG8d1b45IxC
 o8rLrTZ9zuaA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 11:37:24 -0700
IronPort-SDR: JK9Ge80zClu0jPUeNZtdKwqQRGDKNaE55aS7x8ETBj7JAlZxbeCn9ufiic4h/BD/tP/8y5ggQk
 L4knz5b4uWPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="358241655"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 11:37:24 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next v3 10/11] netdevsim: support taking immediate snapshot via devlink
Date:   Thu, 26 Mar 2020 11:37:17 -0700
Message-Id: <20200326183718.2384349-11-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326183718.2384349-1-jacob.e.keller@intel.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
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
Changes since v1
* remove selftests for creating a region without a snapshot id, as this
  functionality has been removed.
* Ran the selftests to ensure they pass now

Changes since v2
* Moved devlink variable assignment

 drivers/net/netdevsim/dev.c                   | 28 +++++++++++++++----
 .../drivers/net/netdevsim/devlink.sh          | 10 +++++++
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f4f6539f1e17..2b727a7001f6 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -39,23 +39,38 @@ static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
 
+static int
+nsim_dev_take_snapshot(struct devlink *devlink, struct netlink_ext_ack *extack,
+		       u8 **data)
+{
+	void *dummy_data;
+
+	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
+	if (!dummy_data)
+		return -ENOMEM;
+
+	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
+
+	*data = dummy_data;
+
+	return 0;
+}
+
 static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 					    const char __user *data,
 					    size_t count, loff_t *ppos)
 {
 	struct nsim_dev *nsim_dev = file->private_data;
 	struct devlink *devlink;
-	void *dummy_data;
+	u8 *dummy_data;
 	int err;
 	u32 id;
 
 	devlink = priv_to_devlink(nsim_dev);
 
-	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
-	if (!dummy_data)
-		return -ENOMEM;
-
-	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
+	err = nsim_dev_take_snapshot(devlink, NULL, &dummy_data);
+	if (err)
+		return err;
 
 	err = devlink_region_snapshot_id_get(devlink, &id);
 	if (err) {
@@ -351,6 +366,7 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
 static const struct devlink_region_ops dummy_region_ops = {
 	.name = "dummy",
 	.destructor = &kfree,
+	.snapshot = nsim_dev_take_snapshot,
 };
 
 static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 025a84c2ab5a..32cb2a159c70 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -141,6 +141,16 @@ regions_test()
 
 	check_region_snapshot_count dummy post-first-delete 2
 
+	devlink region new $DL_HANDLE/dummy snapshot 25
+	check_err $? "Failed to create a new snapshot with id 25"
+
+	check_region_snapshot_count dummy post-first-request 3
+
+	devlink region del $DL_HANDLE/dummy snapshot 25
+	check_err $? "Failed to delete snapshot with id 25"
+
+	check_region_snapshot_count dummy post-second-delete 2
+
 	log_test "regions test"
 }
 
-- 
2.24.1

