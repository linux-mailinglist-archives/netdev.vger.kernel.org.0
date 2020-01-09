Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D48A136121
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbgAITdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:33:19 -0500
Received: from mga05.intel.com ([192.55.52.43]:37095 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730495AbgAITdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 14:33:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 11:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="223970940"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2020 11:33:14 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     valex@mellanox.com, jiri@resnulli.us,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 3/3] netdevsim: support triggering snapshot through devlink
Date:   Thu,  9 Jan 2020 11:33:11 -0800
Message-Id: <20200109193311.1352330-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109193311.1352330-1-jacob.e.keller@intel.com>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the trigger_snapshot callback for the dummy devlink region.
This enables the region snapshot to be requested directly through the
devlink API instead of using debugfs as an out-of-band mechanism for
triggering the snapshot.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/netdevsim/dev.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 2af97eeb7ba1..4ed9c8d8de7c 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -38,30 +38,46 @@ static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
 
-static ssize_t nsim_dev_take_snapshot_write(struct file *file,
-					    const char __user *data,
-					    size_t count, loff_t *ppos)
+static int nsim_dev_trigger_snapshot(struct devlink *devlink,
+				     struct devlink_region *region,
+				     struct netlink_ext_ack *extack)
 {
-	struct nsim_dev *nsim_dev = file->private_data;
 	void *dummy_data;
 	int err;
 	u32 id;
 
 	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
-	if (!dummy_data)
+	if (!dummy_data) {
+		NL_SET_ERR_MSG(extack, "Out of memory");
 		return -ENOMEM;
+	}
 
 	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
 
-	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
-	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
-					     dummy_data, id, kfree);
+	id = devlink_region_snapshot_id_get(devlink);
+	err = devlink_region_snapshot_create(region, dummy_data, id, kfree);
 	if (err) {
-		pr_err("Failed to create region snapshot\n");
+		NL_SET_ERR_MSG(extack, "Failed to create region snapshot");
 		kfree(dummy_data);
 		return err;
 	}
 
+	return (0);
+
+}
+
+static ssize_t nsim_dev_take_snapshot_write(struct file *file,
+					    const char __user *data,
+					    size_t count, loff_t *ppos)
+{
+	struct nsim_dev *nsim_dev = file->private_data;
+	int err;
+
+	err = nsim_dev_trigger_snapshot(priv_to_devlink(nsim_dev),
+					nsim_dev->dummy_region, NULL);
+	if (err)
+		return err;
+
 	return count;
 }
 
@@ -249,7 +265,7 @@ static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
 		devlink_region_create(devlink, "dummy",
 				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
 				      NSIM_DEV_DUMMY_REGION_SIZE,
-				      NULL);
+				      nsim_dev_trigger_snapshot);
 	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
 }
 
-- 
2.25.0.rc1

