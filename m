Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DA9191CF0
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgCXWfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:35:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:54988 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbgCXWfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 18:35:24 -0400
IronPort-SDR: xssjhaV20Tv53rKlmpd/UMCd6/cERclM/mJiw/nHlVGo334CI+VP71Nx4JKKlJ3A7k62JmmoKj
 5DYYO06cbIKg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 15:35:23 -0700
IronPort-SDR: wtPG5tY3u80JttoEKmdb3tXek0+QIOiuGspfkAPLFR3sniCfrrXgDrK6Q4Uv7ZPJoSBtQhRCRb
 sVGRgS0DUrPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="238363216"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga007.fm.intel.com with ESMTP; 24 Mar 2020 15:35:23 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 09/10] netdevsim: support taking immediate snapshot via devlink
Date:   Tue, 24 Mar 2020 15:34:44 -0700
Message-Id: <20200324223445.2077900-10-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324223445.2077900-1-jacob.e.keller@intel.com>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
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
index f9420b77e5fd..876efe71efff 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -39,13 +39,11 @@ static struct dentry *nsim_dev_ddir;
 
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
@@ -53,6 +51,24 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
 
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
@@ -346,6 +362,7 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
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
2.24.1

