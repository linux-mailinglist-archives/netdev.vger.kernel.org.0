Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA0847612C
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344060AbhLOSzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:55:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:57382 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344068AbhLOSzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:55:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639594512; x=1671130512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lr7Xj3tz8v/1r05wFOIhXJ2ydmnUZEzdLvcnaHCteSk=;
  b=EHplQZ8gPF+/WnvFOjMbq00et9E0muJVOrQdDgfo7RdbhB+wbw1/+FtT
   pF9DSd89a5LzZA/MfvK0oqyH+SPgEtoUQ8wPTRinuf52eoQMl5/5r6Pex
   LHhMsZ84TrOFN2AV/q3o9TUypZx4wwbb89b9Un9GmimDYzu2EQKX/vgDI
   qMDDSl+ZAgH1kqx1j8inDvqn72lwoqblMbAclYLPZ9+lmEwi8/NEHEZtO
   O1+L2u33QtksopDwxjg6KGya+cbhXNLlFa9nUJj/yMTR/7rI9sXW2qSEN
   PZoYqL7GBLB5OD/0NkIDeiRuyOKeIqS1zWdxaQUfC6PBDTtsIlGoy9YgG
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="239533298"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="239533298"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 10:54:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465729935"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 10:54:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/9] ice: move and rename ice_check_for_pending_update
Date:   Wed, 15 Dec 2021 10:53:48 -0800
Message-Id: <20211215185355.3249738-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
References: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_devlink_flash_update function performs a few checks and then
calls ice_flash_pldm_image. One of these checks is to call
ice_check_for_pending_update. This function checks if the device has
a pending update, and cancels it if so. This is necessary to allow
a new flash update to proceed.

We want to refactor the ice code to eliminate ice_devlink_flash_update,
moving its checks into ice_flash_pldm_image.

To do this, ice_check_for_pending_update will become static, and only
called by ice_flash_pldm_image. To make this change easier to review,
first just move the function up within the ice_fw_update.c file.

While at it, note that the function has a misleading name. Its primary
action is to cancel a pending update. Using the verb "check" does not
imply this. Rename it to ice_cancel_pending_update.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   2 +-
 .../net/ethernet/intel/ice/ice_fw_update.c    | 148 +++++++++---------
 .../net/ethernet/intel/ice/ice_fw_update.h    |   4 +-
 3 files changed, 77 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index d4173905fcab..de9003cd89d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -411,7 +411,7 @@ ice_devlink_flash_update(struct devlink *devlink,
 		return -EOPNOTSUPP;
 	}
 
-	err = ice_check_for_pending_update(pf, NULL, extack);
+	err = ice_cancel_pending_update(pf, NULL, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index ccdfd2f030d8..489766e6ca6b 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -642,87 +642,18 @@ static const struct pldmfw_ops ice_fwu_ops = {
 };
 
 /**
- * ice_flash_pldm_image - Write a PLDM-formatted firmware image to the device
- * @pf: private device driver structure
- * @fw: firmware object pointing to the relevant firmware file
- * @preservation: preservation level to request from firmware
- * @extack: netlink extended ACK structure
- *
- * Parse the data for a given firmware file, verifying that it is a valid PLDM
- * formatted image that matches this device.
- *
- * Extract the device record Package Data and Component Tables and send them
- * to the firmware. Extract and write the flash data for each of the three
- * main flash components, "fw.mgmt", "fw.undi", and "fw.netlist". Notify
- * firmware once the data is written to the inactive banks.
- *
- * Returns: zero on success or a negative error code on failure.
- */
-int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
-			 u8 preservation, struct netlink_ext_ack *extack)
-{
-	struct device *dev = ice_pf_to_dev(pf);
-	struct ice_hw *hw = &pf->hw;
-	struct ice_fwu_priv priv;
-	int err;
-
-	switch (preservation) {
-	case ICE_AQC_NVM_PRESERVE_ALL:
-	case ICE_AQC_NVM_PRESERVE_SELECTED:
-	case ICE_AQC_NVM_NO_PRESERVATION:
-	case ICE_AQC_NVM_FACTORY_DEFAULT:
-		break;
-	default:
-		WARN(1, "Unexpected preservation level request %u", preservation);
-		return -EINVAL;
-	}
-
-	memset(&priv, 0, sizeof(priv));
-
-	priv.context.ops = &ice_fwu_ops;
-	priv.context.dev = dev;
-	priv.extack = extack;
-	priv.pf = pf;
-	priv.activate_flags = preservation;
-
-	err = ice_acquire_nvm(hw, ICE_RES_WRITE);
-	if (err) {
-		dev_err(dev, "Failed to acquire device flash lock, err %d aq_err %s\n",
-			err, ice_aq_str(hw->adminq.sq_last_status));
-		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire device flash lock");
-		return err;
-	}
-
-	err = pldmfw_flash_image(&priv.context, fw);
-	if (err == -ENOENT) {
-		dev_err(dev, "Firmware image has no record matching this device\n");
-		NL_SET_ERR_MSG_MOD(extack, "Firmware image has no record matching this device");
-	} else if (err) {
-		/* Do not set a generic extended ACK message here. A more
-		 * specific message may already have been set by one of our
-		 * ops.
-		 */
-		dev_err(dev, "Failed to flash PLDM image, err %d", err);
-	}
-
-	ice_release_nvm(hw);
-
-	return err;
-}
-
-/**
- * ice_check_for_pending_update - Check for a pending flash update
+ * ice_cancel_pending_update - Cancel any pending update for a component
  * @pf: the PF driver structure
  * @component: if not NULL, the name of the component being updated
  * @extack: Netlink extended ACK structure
  *
- * Check whether the device already has a pending flash update. If such an
- * update is found, cancel it so that the requested update may proceed.
+ * Cancel any pending update for the specified component. If component is
+ * NULL, all device updates will be canceled.
  *
  * Returns: zero on success, or a negative error code on failure.
  */
-int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
-				 struct netlink_ext_ack *extack)
+int ice_cancel_pending_update(struct ice_pf *pf, const char *component,
+			      struct netlink_ext_ack *extack)
 {
 	struct devlink *devlink = priv_to_devlink(pf);
 	struct device *dev = ice_pf_to_dev(pf);
@@ -804,3 +735,72 @@ int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
 
 	return err;
 }
+
+/**
+ * ice_flash_pldm_image - Write a PLDM-formatted firmware image to the device
+ * @pf: private device driver structure
+ * @fw: firmware object pointing to the relevant firmware file
+ * @preservation: preservation level to request from firmware
+ * @extack: netlink extended ACK structure
+ *
+ * Parse the data for a given firmware file, verifying that it is a valid PLDM
+ * formatted image that matches this device.
+ *
+ * Extract the device record Package Data and Component Tables and send them
+ * to the firmware. Extract and write the flash data for each of the three
+ * main flash components, "fw.mgmt", "fw.undi", and "fw.netlist". Notify
+ * firmware once the data is written to the inactive banks.
+ *
+ * Returns: zero on success or a negative error code on failure.
+ */
+int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
+			 u8 preservation, struct netlink_ext_ack *extack)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	struct ice_fwu_priv priv;
+	int err;
+
+	switch (preservation) {
+	case ICE_AQC_NVM_PRESERVE_ALL:
+	case ICE_AQC_NVM_PRESERVE_SELECTED:
+	case ICE_AQC_NVM_NO_PRESERVATION:
+	case ICE_AQC_NVM_FACTORY_DEFAULT:
+		break;
+	default:
+		WARN(1, "Unexpected preservation level request %u", preservation);
+		return -EINVAL;
+	}
+
+	memset(&priv, 0, sizeof(priv));
+
+	priv.context.ops = &ice_fwu_ops;
+	priv.context.dev = dev;
+	priv.extack = extack;
+	priv.pf = pf;
+	priv.activate_flags = preservation;
+
+	err = ice_acquire_nvm(hw, ICE_RES_WRITE);
+	if (err) {
+		dev_err(dev, "Failed to acquire device flash lock, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire device flash lock");
+		return err;
+	}
+
+	err = pldmfw_flash_image(&priv.context, fw);
+	if (err == -ENOENT) {
+		dev_err(dev, "Firmware image has no record matching this device\n");
+		NL_SET_ERR_MSG_MOD(extack, "Firmware image has no record matching this device");
+	} else if (err) {
+		/* Do not set a generic extended ACK message here. A more
+		 * specific message may already have been set by one of our
+		 * ops.
+		 */
+		dev_err(dev, "Failed to flash PLDM image, err %d", err);
+	}
+
+	ice_release_nvm(hw);
+
+	return err;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.h b/drivers/net/ethernet/intel/ice/ice_fw_update.h
index c6390f6851ff..1f84ef18bfd1 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.h
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.h
@@ -6,7 +6,7 @@
 
 int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 			 u8 preservation, struct netlink_ext_ack *extack);
-int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
-				 struct netlink_ext_ack *extack);
+int ice_cancel_pending_update(struct ice_pf *pf, const char *component,
+			      struct netlink_ext_ack *extack);
 
 #endif
-- 
2.31.1

