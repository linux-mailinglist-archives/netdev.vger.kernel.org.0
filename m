Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4117426815
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239931AbhJHKny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:43:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:45104 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239650AbhJHKnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 06:43:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="213622802"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="213622802"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:41:54 -0700
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="478934484"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.138])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:41:54 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kubakici@wp.pl>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next 1/4] ice: move and rename ice_check_for_pending_update
Date:   Fri,  8 Oct 2021 03:41:12 -0700
Message-Id: <20211008104115.1327240-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
In-Reply-To: <20211008104115.1327240-1-jacob.e.keller@intel.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   2 +-
 .../net/ethernet/intel/ice/ice_fw_update.c    | 152 +++++++++---------
 .../net/ethernet/intel/ice/ice_fw_update.h    |   4 +-
 3 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index cae1cd97a1ef..a11a1563b653 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -412,7 +412,7 @@ ice_devlink_flash_update(struct devlink *devlink,
 		return -EOPNOTSUPP;
 	}
 
-	err = ice_check_for_pending_update(pf, NULL, extack);
+	err = ice_cancel_pending_update(pf, NULL, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index f8601d5b0b19..ae1360d8554e 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -648,89 +648,18 @@ static const struct pldmfw_ops ice_fwu_ops = {
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
-	enum ice_status status;
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
-	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
-	if (status) {
-		dev_err(dev, "Failed to acquire device flash lock, err %s aq_err %s\n",
-			ice_stat_str(status),
-			ice_aq_str(hw->adminq.sq_last_status));
-		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire device flash lock");
-		return -EIO;
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
@@ -814,3 +743,74 @@ int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
 
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
+	enum ice_status status;
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
+	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
+	if (status) {
+		dev_err(dev, "Failed to acquire device flash lock, err %s aq_err %s\n",
+			ice_stat_str(status),
+			ice_aq_str(hw->adminq.sq_last_status));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to acquire device flash lock");
+		return -EIO;
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
2.31.1.331.gb0c09ab8796f

