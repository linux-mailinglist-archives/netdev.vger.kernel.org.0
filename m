Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B472426814
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239873AbhJHKnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:43:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:45104 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhJHKnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 06:43:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="213622803"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="213622803"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:41:54 -0700
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="478934488"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.138])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:41:54 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kubakici@wp.pl>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next 2/4] ice: move ice_devlink_flash_update and merge with ice_flash_pldm_image
Date:   Fri,  8 Oct 2021 03:41:13 -0700
Message-Id: <20211008104115.1327240-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
In-Reply-To: <20211008104115.1327240-1-jacob.e.keller@intel.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ice_devlink_flash_update function performs a few upfront checks and
then calls ice_flash_pldm_image.

Most if these checks make more sense in the context of code within
ice_flash_pldm_image. Merge ice_devlink_flash_update and
ice_flash_pldm_image into one function, placing it in ice_fw_update.c

Since this is still the entry point for devlink, call the function
ice_devlink_flash_update instead of ice_flash_pldm_image. This leaves a
single function which handles the devlink parameters and then initiates
a PLDM update.

When merging the calls to ice_cancel_pending_update function, notice
that both it and the main flash update process take the NVM hardware
semaphore. We can eliminate the call to get the semaphore from
ice_cancel_pending_update by placing the check after we acquire the
semaphore during ice_flash_pldm_image.

With this change, the ice_devlink_flash_update function in
ice_fw_update.c becomes the main entry point for flash update. It
elimintes some unnecessary boiler plate code between the two previous
functions. The ultimate motivation for this is that it eases supporting
a dry run with the PLDM library in a future change.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 50 -------------
 .../net/ethernet/intel/ice/ice_fw_update.c    | 71 ++++++++++---------
 .../net/ethernet/intel/ice/ice_fw_update.h    |  7 +-
 3 files changed, 41 insertions(+), 87 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index a11a1563b653..f023e862dbf1 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -371,56 +371,6 @@ static int ice_devlink_info_get(struct devlink *devlink,
 	return err;
 }
 
-/**
- * ice_devlink_flash_update - Update firmware stored in flash on the device
- * @devlink: pointer to devlink associated with device to update
- * @params: flash update parameters
- * @extack: netlink extended ACK structure
- *
- * Perform a device flash update. The bulk of the update logic is contained
- * within the ice_flash_pldm_image function.
- *
- * Returns: zero on success, or an error code on failure.
- */
-static int
-ice_devlink_flash_update(struct devlink *devlink,
-			 struct devlink_flash_update_params *params,
-			 struct netlink_ext_ack *extack)
-{
-	struct ice_pf *pf = devlink_priv(devlink);
-	struct ice_hw *hw = &pf->hw;
-	u8 preservation;
-	int err;
-
-	if (!params->overwrite_mask) {
-		/* preserve all settings and identifiers */
-		preservation = ICE_AQC_NVM_PRESERVE_ALL;
-	} else if (params->overwrite_mask == DEVLINK_FLASH_OVERWRITE_SETTINGS) {
-		/* overwrite settings, but preserve the vital device identifiers */
-		preservation = ICE_AQC_NVM_PRESERVE_SELECTED;
-	} else if (params->overwrite_mask == (DEVLINK_FLASH_OVERWRITE_SETTINGS |
-					      DEVLINK_FLASH_OVERWRITE_IDENTIFIERS)) {
-		/* overwrite both settings and identifiers, preserve nothing */
-		preservation = ICE_AQC_NVM_NO_PRESERVATION;
-	} else {
-		NL_SET_ERR_MSG_MOD(extack, "Requested overwrite mask is not supported");
-		return -EOPNOTSUPP;
-	}
-
-	if (!hw->dev_caps.common_cap.nvm_unified_update) {
-		NL_SET_ERR_MSG_MOD(extack, "Current firmware does not support unified update");
-		return -EOPNOTSUPP;
-	}
-
-	err = ice_cancel_pending_update(pf, NULL, extack);
-	if (err)
-		return err;
-
-	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
-
-	return ice_flash_pldm_image(pf, params->fw, preservation, extack);
-}
-
 static const struct devlink_ops ice_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.info_get = ice_devlink_info_get,
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index ae1360d8554e..436f71a8e8aa 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -658,8 +658,9 @@ static const struct pldmfw_ops ice_fwu_ops = {
  *
  * Returns: zero on success, or a negative error code on failure.
  */
-int ice_cancel_pending_update(struct ice_pf *pf, const char *component,
-			      struct netlink_ext_ack *extack)
+static int
+ice_cancel_pending_update(struct ice_pf *pf, const char *component,
+			  struct netlink_ext_ack *extack)
 {
 	struct devlink *devlink = priv_to_devlink(pf);
 	struct device *dev = ice_pf_to_dev(pf);
@@ -667,7 +668,6 @@ int ice_cancel_pending_update(struct ice_pf *pf, const char *component,
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
 	u8 pending = 0;
-	int err;
 
 	dev_caps = kzalloc(sizeof(*dev_caps), GFP_KERNEL);
 	if (!dev_caps)
@@ -727,28 +727,14 @@ int ice_cancel_pending_update(struct ice_pf *pf, const char *component,
 					   "Canceling previous pending update",
 					   component, 0, 0);
 
-	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
-	if (status) {
-		dev_err(dev, "Failed to acquire device flash lock, err %s aq_err %s\n",
-			ice_stat_str(status),
-			ice_aq_str(hw->adminq.sq_last_status));
-		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire device flash lock");
-		return -EIO;
-	}
-
 	pending |= ICE_AQC_NVM_REVERT_LAST_ACTIV;
-	err = ice_switch_flash_banks(pf, pending, extack);
-
-	ice_release_nvm(hw);
-
-	return err;
+	return ice_switch_flash_banks(pf, pending, extack);
 }
 
 /**
- * ice_flash_pldm_image - Write a PLDM-formatted firmware image to the device
- * @pf: private device driver structure
- * @fw: firmware object pointing to the relevant firmware file
- * @preservation: preservation level to request from firmware
+ * ice_devlink_flash_update - Write a firmware image to the device
+ * @devlink: pointer to devlink associated with the device to update
+ * @params: devlink flash update parameters
  * @extack: netlink extended ACK structure
  *
  * Parse the data for a given firmware file, verifying that it is a valid PLDM
@@ -761,24 +747,36 @@ int ice_cancel_pending_update(struct ice_pf *pf, const char *component,
  *
  * Returns: zero on success or a negative error code on failure.
  */
-int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
-			 u8 preservation, struct netlink_ext_ack *extack)
+int ice_devlink_flash_update(struct devlink *devlink,
+			     struct devlink_flash_update_params *params,
+			     struct netlink_ext_ack *extack)
 {
+	struct ice_pf *pf = devlink_priv(devlink);
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	struct ice_fwu_priv priv;
 	enum ice_status status;
+	u8 preservation;
 	int err;
 
-	switch (preservation) {
-	case ICE_AQC_NVM_PRESERVE_ALL:
-	case ICE_AQC_NVM_PRESERVE_SELECTED:
-	case ICE_AQC_NVM_NO_PRESERVATION:
-	case ICE_AQC_NVM_FACTORY_DEFAULT:
-		break;
-	default:
-		WARN(1, "Unexpected preservation level request %u", preservation);
-		return -EINVAL;
+	if (!params->overwrite_mask) {
+		/* preserve all settings and identifiers */
+		preservation = ICE_AQC_NVM_PRESERVE_ALL;
+	} else if (params->overwrite_mask == DEVLINK_FLASH_OVERWRITE_SETTINGS) {
+		/* overwrite settings, but preserve the vital device identifiers */
+		preservation = ICE_AQC_NVM_PRESERVE_SELECTED;
+	} else if (params->overwrite_mask == (DEVLINK_FLASH_OVERWRITE_SETTINGS |
+					      DEVLINK_FLASH_OVERWRITE_IDENTIFIERS)) {
+		/* overwrite both settings and identifiers, preserve nothing */
+		preservation = ICE_AQC_NVM_NO_PRESERVATION;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Requested overwrite mask is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!hw->dev_caps.common_cap.nvm_unified_update) {
+		NL_SET_ERR_MSG_MOD(extack, "Current firmware does not support unified update");
+		return -EOPNOTSUPP;
 	}
 
 	memset(&priv, 0, sizeof(priv));
@@ -789,6 +787,8 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 	priv.pf = pf;
 	priv.activate_flags = preservation;
 
+	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
+
 	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
 	if (status) {
 		dev_err(dev, "Failed to acquire device flash lock, err %s aq_err %s\n",
@@ -798,7 +798,11 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 		return -EIO;
 	}
 
-	err = pldmfw_flash_image(&priv.context, fw);
+	err = ice_cancel_pending_update(pf, NULL, extack);
+	if (err)
+		goto out_release_nvm;
+
+	err = pldmfw_flash_image(&priv.context, params->fw);
 	if (err == -ENOENT) {
 		dev_err(dev, "Firmware image has no record matching this device\n");
 		NL_SET_ERR_MSG_MOD(extack, "Firmware image has no record matching this device");
@@ -810,6 +814,7 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 		dev_err(dev, "Failed to flash PLDM image, err %d", err);
 	}
 
+out_release_nvm:
 	ice_release_nvm(hw);
 
 	return err;
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.h b/drivers/net/ethernet/intel/ice/ice_fw_update.h
index 1f84ef18bfd1..be6d222124f2 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.h
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.h
@@ -4,9 +4,8 @@
 #ifndef _ICE_FW_UPDATE_H_
 #define _ICE_FW_UPDATE_H_
 
-int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
-			 u8 preservation, struct netlink_ext_ack *extack);
-int ice_cancel_pending_update(struct ice_pf *pf, const char *component,
-			      struct netlink_ext_ack *extack);
+int ice_devlink_flash_update(struct devlink *devlink,
+			     struct devlink_flash_update_params *params,
+			     struct netlink_ext_ack *extack);
 
 #endif
-- 
2.31.1.331.gb0c09ab8796f

