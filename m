Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8AD2638F7
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgIIW2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 18:28:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:30342 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgIIW1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 18:27:52 -0400
IronPort-SDR: yaXziyvQPRUkkQSZKElLnrnUi1uGDFK7Gj/1PLXTvbuDWwl9jJkBDod9yrH4fUUQQ37upYlXP9
 RO5PJPKKdOmQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="222627349"
X-IronPort-AV: E=Sophos;i="5.76,410,1592895600"; 
   d="scan'208";a="222627349"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 15:27:48 -0700
IronPort-SDR: mzuWA03al82/5rHLbkkxtRFzN6+4IQoCERTQ9XBUOTnRQoWcm++99zI2liiiyfpmDUhxoLdtuA
 18Wv7iE5dffw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,410,1592895600"; 
   d="scan'208";a="285017350"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga007.fm.intel.com with ESMTP; 09 Sep 2020 15:27:48 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v4 4/5] devlink: add support for overwrite mask to netdevsim
Date:   Wed,  9 Sep 2020 15:26:52 -0700
Message-Id: <20200909222653.32994-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.218.ge27853923b9d.dirty
In-Reply-To: <20200909222653.32994-1-jacob.e.keller@intel.com>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink interface recently gained support for a new "overwrite mask"
parameter that allows specifying how various sub-sections of a flash
component are modified when updating.

Add support for this to netdevsim, to enable easily testing the
interface. Make the allowed overwrite mask values controllable via
a debugfs parameter. This enables testing a flow where the driver
rejects an unsupportable overwrite mask.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
This patch is new in v4

 drivers/net/netdevsim/dev.c                    | 10 +++++++++-
 drivers/net/netdevsim/netdevsim.h              |  1 +
 .../selftests/drivers/net/netdevsim/devlink.sh | 18 ++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ebfc4a698809..74a869fbaa67 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -201,6 +201,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 		return PTR_ERR(nsim_dev->ports_ddir);
 	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
 			    &nsim_dev->fw_update_status);
+	debugfs_create_u32("fw_update_overwrite_mask", 0600, nsim_dev->ddir,
+			    &nsim_dev->fw_update_overwrite_mask);
 	debugfs_create_u32("max_macs", 0600, nsim_dev->ddir,
 			   &nsim_dev->max_macs);
 	debugfs_create_bool("test1", 0600, nsim_dev->ddir,
@@ -747,6 +749,9 @@ static int nsim_dev_flash_update(struct devlink *devlink,
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	int i;
 
+	if ((params->overwrite_mask & ~nsim_dev->fw_update_overwrite_mask) != 0)
+		return -EOPNOTSUPP;
+
 	if (nsim_dev->fw_update_status) {
 		devlink_flash_update_begin_notify(devlink);
 		devlink_flash_update_status_notify(devlink,
@@ -875,7 +880,8 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops nsim_dev_devlink_ops = {
-	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT,
+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
+					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
 	.info_get = nsim_dev_info_get,
@@ -990,6 +996,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
+	nsim_dev->fw_update_overwrite_mask = 0;
 
 	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
 	if (IS_ERR(nsim_dev->fib_data))
@@ -1048,6 +1055,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
+	nsim_dev->fw_update_overwrite_mask = 0;
 	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
 	nsim_dev->test1 = NSIM_DEV_TEST1_DEFAULT;
 	spin_lock_init(&nsim_dev->fa_cookie_lock);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 284f7092241d..48ba33501450 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -185,6 +185,7 @@ struct nsim_dev {
 	struct list_head port_list;
 	struct mutex port_list_lock; /* protects port list */
 	bool fw_update_status;
+	u32 fw_update_overwrite_mask;
 	u32 max_macs;
 	bool test1;
 	bool dont_allow_reload;
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 1e7541688978..40909c254365 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -26,6 +26,24 @@ fw_flash_test()
 	devlink dev flash $DL_HANDLE file dummy component fw.mgmt
 	check_err $? "Failed to flash with component attribute"
 
+	devlink dev flash $DL_HANDLE file dummy overwrite settings
+	check_fail $? "Flash with overwrite settings should be rejected"
+
+	echo "1"> $DEBUGFS_DIR/fw_update_overwrite_mask
+	check_err $? "Failed to change allowed overwrite mask"
+
+	devlink dev flash $DL_HANDLE file dummy overwrite settings
+	check_err $? "Failed to flash with settings overwrite enabled"
+
+	devlink dev flash $DL_HANDLE file dummy overwrite identifiers
+	check_fail $? "Flash with overwrite settings should be identifiers"
+
+	echo "3"> $DEBUGFS_DIR/fw_update_overwrite_mask
+	check_err $? "Failed to change allowed overwrite mask"
+
+	devlink dev flash $DL_HANDLE file dummy overwrite identifiers overwrite settings
+	check_err $? "Failed to flash with settings and identifiers overwrite enabled"
+
 	echo "n"> $DEBUGFS_DIR/fw_update_status
 	check_err $? "Failed to disable status updates"
 
-- 
2.28.0.218.ge27853923b9d.dirty

