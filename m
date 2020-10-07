Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6594828664E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgJGRzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:55:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:18444 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgJGRzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:55:01 -0400
IronPort-SDR: ycZNgvfX6gzJWsIGbJ+cCEmJlXjsq1ne10jWEVrlJknhnAtjOZK6XPH+zmI6e67Ew8t4hdpuFM
 0Dyd6DONsFwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="144957656"
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="144957656"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:59 -0700
IronPort-SDR: VEk2MvfPsAIyXQkGNYKWpm9BPQZbgiVAp39r6JJjbKohkEEe7yMDooGYKsfmzrTcWgr7ghk2fr
 U3Fv4Ssv5teA==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="518935793"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Brijesh Behera <brijeshx.behera@intel.com>
Subject: [net-next 6/8] ice: add additional debug logging for firmware update
Date:   Wed,  7 Oct 2020 10:54:45 -0700
Message-Id: <20201007175447.647867-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
References: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

While debugging a recent failure to update the flash of an ice device,
I found it helpful to add additional logging which helped determine the
root cause of the problem being a timeout issue.

Add some extra dev_dbg() logging messages which can be enabled using the
dynamic debug facility, including one for ice_aq_wait_for_event that
will use jiffies to capture a rough estimate of how long we waited for
the completion of a firmware command.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Brijesh Behera <brijeshx.behera@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  2 ++
 .../net/ethernet/intel/ice/ice_fw_update.c    | 28 +++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_main.c     |  9 ++++++
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 2985555ad4b3..511da59bd6f2 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -283,6 +283,8 @@ ice_devlink_flash_update(struct devlink *devlink,
 		return err;
 	}
 
+	dev_dbg(dev, "Beginning flash update with file '%s'\n", params->file_name);
+
 	devlink_flash_update_begin_notify(devlink);
 	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
 	err = ice_flash_pldm_image(pf, fw, preservation, extack);
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 382decb9ae91..8f81b95e679c 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -43,6 +43,8 @@ ice_send_package_data(struct pldmfw *context, const u8 *data, u16 length)
 	enum ice_status status;
 	u8 *package_data;
 
+	dev_dbg(dev, "Sending PLDM record package data to firmware\n");
+
 	package_data = kmemdup(data, length, GFP_KERNEL);
 	if (!package_data)
 		return -ENOMEM;
@@ -229,6 +231,8 @@ ice_send_component_table(struct pldmfw *context, struct pldmfw_component *compon
 	comp_tbl->cvs_len = component->version_len;
 	memcpy(comp_tbl->cvs, component->version_string, component->version_len);
 
+	dev_dbg(dev, "Sending component table to firmware:\n");
+
 	status = ice_nvm_pass_component_tbl(hw, (u8 *)comp_tbl, length,
 					    transfer_flag, &comp_response,
 					    &comp_response_code, NULL);
@@ -279,11 +283,14 @@ ice_write_one_nvm_block(struct ice_pf *pf, u16 module, u32 offset,
 
 	memset(&event, 0, sizeof(event));
 
+	dev_dbg(dev, "Writing block of %u bytes for module 0x%02x at offset %u\n",
+		block_size, module, offset);
+
 	status = ice_aq_update_nvm(hw, module, offset, block_size, block,
 				   last_cmd, 0, NULL);
 	if (status) {
-		dev_err(dev, "Failed to program flash module 0x%02x at offset %u, err %s aq_err %s\n",
-			module, offset, ice_stat_str(status),
+		dev_err(dev, "Failed to flash module 0x%02x with block of size %u at offset %u, err %s aq_err %s\n",
+			module, block_size, offset, ice_stat_str(status),
 			ice_aq_str(hw->adminq.sq_last_status));
 		NL_SET_ERR_MSG_MOD(extack, "Failed to program flash module");
 		return -EIO;
@@ -297,8 +304,8 @@ ice_write_one_nvm_block(struct ice_pf *pf, u16 module, u32 offset,
 	 */
 	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_write, 15 * HZ, &event);
 	if (err) {
-		dev_err(dev, "Timed out waiting for firmware write completion for module 0x%02x, err %d\n",
-			module, err);
+		dev_err(dev, "Timed out while trying to flash module 0x%02x with block of size %u at offset %u, err %d\n",
+			module, block_size, offset, err);
 		NL_SET_ERR_MSG_MOD(extack, "Timed out waiting for firmware");
 		return -EIO;
 	}
@@ -324,8 +331,8 @@ ice_write_one_nvm_block(struct ice_pf *pf, u16 module, u32 offset,
 	}
 
 	if (completion_retval) {
-		dev_err(dev, "Firmware failed to program flash module 0x%02x at offset %u, completion err %s\n",
-			module, offset,
+		dev_err(dev, "Firmware failed to flash module 0x%02x with block of size %u at offset %u, err %s\n",
+			module, block_size, offset,
 			ice_aq_str((enum ice_aq_err)completion_retval));
 		NL_SET_ERR_MSG_MOD(extack, "Firmware failed to program flash module");
 		return -EIO;
@@ -356,12 +363,15 @@ ice_write_nvm_module(struct ice_pf *pf, u16 module, const char *component,
 		     const u8 *image, u32 length,
 		     struct netlink_ext_ack *extack)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct devlink *devlink;
 	u32 offset = 0;
 	bool last_cmd;
 	u8 *block;
 	int err;
 
+	dev_dbg(dev, "Beginning write of flash component '%s', module 0x%02x\n", component, module);
+
 	devlink = priv_to_devlink(pf);
 
 	devlink_flash_update_status_notify(devlink, "Flashing",
@@ -394,6 +404,8 @@ ice_write_nvm_module(struct ice_pf *pf, u16 module, const char *component,
 						   component, offset, length);
 	} while (!last_cmd);
 
+	dev_dbg(dev, "Completed write of flash component '%s', module 0x%02x\n", component, module);
+
 	if (err)
 		devlink_flash_update_status_notify(devlink, "Flashing failed",
 						   component, length, length);
@@ -431,6 +443,8 @@ ice_erase_nvm_module(struct ice_pf *pf, u16 module, const char *component,
 	enum ice_status status;
 	int err;
 
+	dev_dbg(dev, "Beginning erase of flash component '%s', module 0x%02x\n", component, module);
+
 	memset(&event, 0, sizeof(event));
 
 	devlink = priv_to_devlink(pf);
@@ -476,6 +490,8 @@ ice_erase_nvm_module(struct ice_pf *pf, u16 module, const char *component,
 		goto out_notify_devlink;
 	}
 
+	dev_dbg(dev, "Completed erase of flash component '%s', module 0x%02x\n", component, module);
+
 out_notify_devlink:
 	if (err)
 		devlink_flash_update_status_notify(devlink, "Erasing failed",
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b13e965b1059..2dea4d0e9415 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1056,7 +1056,9 @@ struct ice_aq_task {
 int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
 			  struct ice_rq_event_info *event)
 {
+	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_aq_task *task;
+	unsigned long start;
 	long ret;
 	int err;
 
@@ -1073,6 +1075,8 @@ int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
 	hlist_add_head(&task->entry, &pf->aq_wait_list);
 	spin_unlock_bh(&pf->aq_wait_lock);
 
+	start = jiffies;
+
 	ret = wait_event_interruptible_timeout(pf->aq_wait_queue, task->state,
 					       timeout);
 	switch (task->state) {
@@ -1091,6 +1095,11 @@ int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
 		break;
 	}
 
+	dev_dbg(dev, "Waited %u msecs (max %u msecs) for firmware response to op 0x%04x\n",
+		jiffies_to_msecs(jiffies - start),
+		jiffies_to_msecs(timeout),
+		opcode);
+
 	spin_lock_bh(&pf->aq_wait_lock);
 	hlist_del(&task->entry);
 	spin_unlock_bh(&pf->aq_wait_lock);
-- 
2.26.2

