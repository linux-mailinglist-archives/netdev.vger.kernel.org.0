Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FE5476137
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344095AbhLOSzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:55:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:57382 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344110AbhLOSzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:55:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639594533; x=1671130533;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J36PUO7TbvSbyFA5OW6p81Xz+qt/M1p7IIM/DaKIHMI=;
  b=M9x4GQcUxFLuQq11KhKdFQYf4CcbYx0gWHVdY4FZZfD/bOehUQ9uDPhf
   2d3zc6o02Dm6LDiIc5Et9lO4BXK9CTmwG6QTcqv2i9IwF5be91MhAQNQC
   cSxGebiYtJvgI+qmw9v1FEAXKSP5o7YYxB6Vohq5ldQtMvoR3lr8DinJW
   Y/I/b6hnkdeEB7v1mrWwQ/FiW8ZAcQAhTccKSE1MVUHKJDlwXJeubViyA
   zZDjZGODRbTAo4ObD8UrPQ3SJ/FmsT3AHR9SawcK1Cutuze8lPnmYNTW7
   0tsN+SSX+kMYU0wI6IIKA8l9OkyML8ITS5FmblFDkYdHH0VMY13TRX/wt
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="239533300"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="239533300"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 10:54:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465729939"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 10:54:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/9] ice: move ice_devlink_flash_update and merge with ice_flash_pldm_image
Date:   Wed, 15 Dec 2021 10:53:49 -0800
Message-Id: <20211215185355.3249738-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
References: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_devlink_flash_update function performs a few upfront checks and
then calls ice_flash_pldm_image.

Most if these checks make more sense in the context of code within
ice_flash_pldm_image. Merge ice_devlink_flash_update and
ice_flash_pldm_image into one function, placing it in ice_fw_update.c

Since this is still the entry point for devlink, call the function
ice_devlink_flash_update instead of ice_flash_pldm_image. This leaves a
single function which handles the devlink parameters and then initiates
a PLDM update.

With this change, the ice_devlink_flash_update function in
ice_fw_update.c becomes the main entry point for flash update. It
elimintes some unnecessary boiler plate code between the two previous
functions. The ultimate motivation for this is that it eases supporting
a dry run with the PLDM library in a future change.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 50 -----------------
 .../net/ethernet/intel/ice/ice_fw_update.c    | 54 ++++++++++++-------
 .../net/ethernet/intel/ice/ice_fw_update.h    |  7 ++-
 3 files changed, 39 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index de9003cd89d4..7e463b53ea98 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -370,56 +370,6 @@ static int ice_devlink_info_get(struct devlink *devlink,
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
 	.eswitch_mode_get = ice_eswitch_mode_get,
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 489766e6ca6b..1f8e0e5d5660 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -652,8 +652,9 @@ static const struct pldmfw_ops ice_fwu_ops = {
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
@@ -737,10 +738,9 @@ int ice_cancel_pending_update(struct ice_pf *pf, const char *component,
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
@@ -753,23 +753,35 @@ int ice_cancel_pending_update(struct ice_pf *pf, const char *component,
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
@@ -780,6 +792,12 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 	priv.pf = pf;
 	priv.activate_flags = preservation;
 
+	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
+
+	err = ice_cancel_pending_update(pf, NULL, extack);
+	if (err)
+		return err;
+
 	err = ice_acquire_nvm(hw, ICE_RES_WRITE);
 	if (err) {
 		dev_err(dev, "Failed to acquire device flash lock, err %d aq_err %s\n",
@@ -788,7 +806,7 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 		return err;
 	}
 
-	err = pldmfw_flash_image(&priv.context, fw);
+	err = pldmfw_flash_image(&priv.context, params->fw);
 	if (err == -ENOENT) {
 		dev_err(dev, "Firmware image has no record matching this device\n");
 		NL_SET_ERR_MSG_MOD(extack, "Firmware image has no record matching this device");
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
2.31.1

