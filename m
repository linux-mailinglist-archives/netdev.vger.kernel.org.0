Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B1721A9C3
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 23:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGIVcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 17:32:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:49958 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgGIVcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 17:32:15 -0400
IronPort-SDR: IDDe6+cXXm1Dhc8Ydcs+eFaSGHD/MRWzOgpgd5BSJLjBoXsuteSI2f2jwO8HSgnzgCSqB2KiDD
 32EfNpXxGQrg==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="147202450"
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="147202450"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 14:26:55 -0700
IronPort-SDR: PCa1GPIrjMWx2SSLTkOzj4q7JFntsboEA7mUxfx6nrf8SArVwMSiHvTm7y1QtcjA7aEJLgi2Sb
 3RMews6hBMHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="284293656"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by orsmga006.jf.intel.com with ESMTP; 09 Jul 2020 14:26:54 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 6/6] ice: implement devlink parameters to control flash update
Date:   Thu,  9 Jul 2020 14:26:52 -0700
Message-Id: <20200709212652.2785924-7-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.27.0.353.gb9a2d1a0207f
In-Reply-To: <20200709212652.2785924-1-jacob.e.keller@intel.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flash update for the ice hardware currently supports a single fixed
configuration:

* Firmware is always asked to preserve all changeable fields
* The driver never allows downgrades
* The driver will not allow canceling a previous update that never
  completed (for example because an EMP reset never occurred)
* The driver does not attempt to trigger an EMP reset immediately.

This default mode of operation is reasonable. However, it is often
useful to allow system administrators more control over the update
process. To enable this, implement devlink parameters that allow the
system administrator to specify the desired behaviors:

* 'reset_after_flash_update'
  If enabled, the driver will request that the firmware immediately
  trigger an EMP reset when completing the device update. This will
  result in the device switching active banks immediately and
  re-initializing with the new firmware.
* 'allow_downgrade_on_flash_update'
  If enabled, the driver will attempt to update device flash even when
  firmware indicates that such an update would be a downgrade.
* 'ignore_pending_flash_update'
  If enabled, the device driver will cancel a previous pending update.
  A pending update is one where the steps to write the update to the NVM
  bank has finished, but the device never reset, as the system had not
  yet been rebooted.
* 'flash_update_preservation_level'
  The value determines the preservation mode to request from firmware,
  among the following 4 choices:
  * PRESERVE_ALL (0)
    Preserve all settings and fields in the NVM configuration
  * PRESERVE_LIMITED (1)
    Preserve only a limited set of fields, including the VPD, PCI serial
    ID, MAC address, etc. This results in permanent settings being
    reset, including changes to the port configuration, such as the
    number of physical functions created.
  * PRESERVE_FACTORY_SETTINGS (2)
    Reset all configuration fields to the factory default settings
    stored within the NVM.
  * PRESERVE_NONE (3)
    Do not perform any preservation.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/ice.rst      |  46 +++++
 drivers/net/ethernet/intel/ice/ice.h          |  20 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 175 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_fw_update.c    |  73 +++++++-
 4 files changed, 309 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 237848d56f9b..7a62eb7fac71 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -156,3 +156,49 @@ Users can request an immediate capture of a snapshot via the
     0000000000000210 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 
     $ devlink region delete pci/0000:01:00.0/device-caps snapshot 1
+
+Parameters
+==========
+
+The ``ice`` driver implements the following driver-specific parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``reset_after_flash_update``
+     - Boolean
+     - runtime
+     - If set to true, the driver will request that firmware trigger an EMP
+       reset after completing a flash update. This causes the device to
+       immediately re-initialize with the new flash contents.
+   * - ``allow_downgrade_on_flash_update``
+     - Boolean
+     - runtime
+     - If set to true, the driver will attempt to perform a flash update
+       even if the firmware indicates that the upgrade is a downgrade to a
+       previous version of the firmware.
+   * - ``ignore_pending_flash_update``
+     - Boolean
+     - runtime
+     - If set to true, the driver will attempt to cancel any previous
+       pending flash update. Such an update is one where the device never
+       reset after finishing the flash update.
+   * - ``flash_update_preservation_level``
+     - u8
+     - runtime
+     - Controls the flash update preservation policy requested by the
+       driver.
+        - ``ICE_FLASH_UPDATE_PRESERVE_ALL`` (0)
+          Preserve all settings and fields in the current NVM configuration,
+          carrying them forward to the new version.
+        - ``ICE_FLASH_UPDATE_PRESERVE_LIMITED`` (1)
+          Preserve only a limited set of fields including the VPD, PCI
+          serial ID, and MAC address.
+        - ``ICE_FLASH_UPDATE_PRESERVE_FACTORY_SETTINGS`` (2)
+          Restore all configuration fields to the factory default settings.
+        - ``ICE_FLASH_UPDATE_PRESERVE_NONE`` (3)
+          Do not perform any preservation.
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 152b1f71045c..7b5c72dd98ae 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -374,6 +374,25 @@ enum ice_pf_flags {
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
+enum ice_flash_update_preservation {
+	/* Preserve all settings and fields */
+	ICE_FLASH_UPDATE_PRESERVE_ALL = 0,
+	/* Preserve limited fields, such as VPD, PCI serial ID, MACs, etc */
+	ICE_FLASH_UPDATE_PRESERVE_LIMITED,
+	/* Return all fields to factory settings */
+	ICE_FLASH_UPDATE_PRESERVE_FACTORY_SETTINGS,
+	/* Do not perform any preservation */
+	ICE_FLASH_UPDATE_PRESERVE_NONE,
+};
+
+struct ice_devlink_flash_params {
+	u8 reset_after_update : 1;
+	u8 allow_downgrade : 1;
+	u8 ignore_pending_update : 1;
+
+	enum ice_flash_update_preservation preservation_level;
+};
+
 struct ice_pf {
 	struct pci_dev *pdev;
 
@@ -382,6 +401,7 @@ struct ice_pf {
 
 	struct devlink_region *nvm_region;
 	struct devlink_region *devcaps_region;
+	struct ice_devlink_flash_params flash_params;
 
 	/* OS reserved IRQ details */
 	struct msix_entry *msix_entries;
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index a6080bfb78dd..1f9cdd06bb86 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -230,6 +230,165 @@ static int ice_devlink_info_get(struct devlink *devlink,
 	return 0;
 }
 
+enum ice_devlink_param_id {
+	ICE_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	ICE_DEVLINK_PARAM_ID_RESET_AFTER_FLASH_UPDATE,
+	ICE_DEVLINK_PARAM_ID_ALLOW_DOWNGRADE_ON_FLASH_UPDATE,
+	ICE_DEVLINK_PARAM_ID_IGNORE_PENDING_FLASH_UPDATE,
+	ICE_DEVLINK_PARAM_ID_FLASH_UPDATE_PRESERVATION_LEVEL,
+};
+
+/**
+ * ice_devlink_flash_param_get - Get a flash update parameter value
+ * @devlink: pointer to the devlink instance
+ * @id: the parameter id to get
+ * @ctx: context to return the parameter value
+ *
+ * Reads the value of the given parameter and reports it back via the provided
+ * context.
+ *
+ * Used to get the devlink parameters which control specific driver
+ * behaviors during the .flash_update command.
+ *
+ * Returns: zero on success, or an error code on failure.
+ */
+static int ice_devlink_flash_param_get(struct devlink *devlink, u32 id,
+				       struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct ice_devlink_flash_params *params;
+
+	params = &pf->flash_params;
+
+	switch (id) {
+	case ICE_DEVLINK_PARAM_ID_RESET_AFTER_FLASH_UPDATE:
+		ctx->val.vbool = params->reset_after_update;
+		break;
+	case ICE_DEVLINK_PARAM_ID_ALLOW_DOWNGRADE_ON_FLASH_UPDATE:
+		ctx->val.vbool = params->allow_downgrade;
+		break;
+	case ICE_DEVLINK_PARAM_ID_IGNORE_PENDING_FLASH_UPDATE:
+		ctx->val.vbool = params->ignore_pending_update;
+		break;
+	case ICE_DEVLINK_PARAM_ID_FLASH_UPDATE_PRESERVATION_LEVEL:
+		ctx->val.vu8 = params->preservation_level;
+		break;
+	default:
+		WARN(1, "parameter ID %u is not a flash update parameter", id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_devlink_flash_param_set - Set a flash update parameter value
+ * @devlink: pointer to the devlink instance
+ * @id: the parameter ID to set
+ * @ctx: context to return the parameter value
+ *
+ * Reads the value of the given parameter and reports it back via the provided
+ * context.
+ *
+ * Used to set the devlink parameters which control specific driver
+ * behaviors during the .flash_update command.
+ *
+ * Returns: zero on success, or an error code on failure.
+ */
+static int ice_devlink_flash_param_set(struct devlink *devlink, u32 id,
+				       struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct ice_devlink_flash_params *params;
+
+	params = &pf->flash_params;
+
+	switch (id) {
+	case ICE_DEVLINK_PARAM_ID_RESET_AFTER_FLASH_UPDATE:
+		params->reset_after_update = ctx->val.vbool;
+		break;
+	case ICE_DEVLINK_PARAM_ID_ALLOW_DOWNGRADE_ON_FLASH_UPDATE:
+		params->allow_downgrade = ctx->val.vbool;
+		break;
+	case ICE_DEVLINK_PARAM_ID_IGNORE_PENDING_FLASH_UPDATE:
+		params->ignore_pending_update = ctx->val.vbool;
+		break;
+	case ICE_DEVLINK_PARAM_ID_FLASH_UPDATE_PRESERVATION_LEVEL:
+		params->preservation_level =
+			(enum ice_flash_update_preservation)ctx->val.vu8;
+		break;
+	default:
+		WARN(1, "parameter ID %u is not a flash update parameter", id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_devlink_flash_preservation_validate - Validate preservation level
+ * @devlink: unused pointer to devlink instance
+ * @id: the parameter ID to validate
+ * @val: value to validate
+ * @extack: netlink extended ACK structure
+ *
+ * Validate that the value for "flash_update_preservation_level" is within the
+ * valid range.
+ *
+ * Returns: zero if the value is valid, -ERANGE if it is out of range, and
+ * -EINVAL if this function is called with the wrong id.
+ */
+static int
+ice_devlink_flash_preservation_validate(struct devlink __always_unused *devlink,
+					u32 id, union devlink_param_value val,
+					struct netlink_ext_ack *extack)
+{
+	if (WARN_ON(id != ICE_DEVLINK_PARAM_ID_FLASH_UPDATE_PRESERVATION_LEVEL))
+		return -EINVAL;
+
+	switch (val.vu8) {
+	case ICE_FLASH_UPDATE_PRESERVE_ALL:
+	case ICE_FLASH_UPDATE_PRESERVE_LIMITED:
+	case ICE_FLASH_UPDATE_PRESERVE_FACTORY_SETTINGS:
+	case ICE_FLASH_UPDATE_PRESERVE_NONE:
+		return 0;
+	}
+
+	return -ERANGE;
+}
+
+/* devlink parameters for the ice driver */
+static const struct devlink_param ice_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(ICE_DEVLINK_PARAM_ID_RESET_AFTER_FLASH_UPDATE,
+			     "reset_after_flash_update",
+			     DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     ice_devlink_flash_param_get,
+			     ice_devlink_flash_param_set,
+			     NULL),
+	DEVLINK_PARAM_DRIVER(ICE_DEVLINK_PARAM_ID_ALLOW_DOWNGRADE_ON_FLASH_UPDATE,
+			     "allow_downgrade_on_flash_update",
+			     DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     ice_devlink_flash_param_get,
+			     ice_devlink_flash_param_set,
+			     NULL),
+	DEVLINK_PARAM_DRIVER(ICE_DEVLINK_PARAM_ID_IGNORE_PENDING_FLASH_UPDATE,
+			     "ignore_pending_flash_update",
+			     DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     ice_devlink_flash_param_get,
+			     ice_devlink_flash_param_set,
+			     NULL),
+	DEVLINK_PARAM_DRIVER(ICE_DEVLINK_PARAM_ID_FLASH_UPDATE_PRESERVATION_LEVEL,
+			     "flash_update_preservation_level",
+			     DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     ice_devlink_flash_param_get,
+			     ice_devlink_flash_param_set,
+			     ice_devlink_flash_preservation_validate),
+};
+
 /**
  * ice_devlink_flash_update - Update firmware stored in flash on the device
  * @devlink: pointer to devlink associated with device to update
@@ -337,6 +496,15 @@ int ice_devlink_register(struct ice_pf *pf)
 		return err;
 	}
 
+	err = devlink_params_register(devlink, ice_devlink_params,
+				      ARRAY_SIZE(ice_devlink_params));
+	if (err) {
+		dev_err(dev, "devlink params registration failed: %d\n", err);
+		return err;
+	}
+
+	devlink_params_publish(devlink);
+
 	return 0;
 }
 
@@ -348,7 +516,12 @@ int ice_devlink_register(struct ice_pf *pf)
  */
 void ice_devlink_unregister(struct ice_pf *pf)
 {
-	devlink_unregister(priv_to_devlink(pf));
+	struct devlink *devlink = priv_to_devlink(pf);
+
+	devlink_params_unpublish(devlink);
+	devlink_params_unregister(devlink, ice_devlink_params,
+				  ARRAY_SIZE(ice_devlink_params));
+	devlink_unregister(devlink);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 717be16ec073..7b106e687e04 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -107,6 +107,11 @@ ice_check_component_response(struct ice_pf *pf, u16 id, u8 response, u8 code,
 		/* firmware indicated this update is good to proceed */
 		return 0;
 	case ICE_AQ_NVM_PASS_COMP_CAN_MAY_BE_UPDATEABLE:
+		if (pf->flash_params.allow_downgrade) {
+			dev_warn(dev, "allow_downgrade_on_flash_update set, ignoring firmware recommendation that this update may not be necessary\n");
+			return 0;
+		}
+
 		dev_info(dev, "firmware recommends not updating %s\n",
 			 component);
 		break;
@@ -610,6 +615,22 @@ static int ice_finalize_update(struct pldmfw *context)
 	if (err)
 		return err;
 
+	/* If requested, perform an immediate EMP reset */
+	if (pf->flash_params.reset_after_update) {
+		struct device *dev = ice_pf_to_dev(pf);
+		struct ice_hw *hw = &pf->hw;
+		enum ice_status status;
+
+		status = ice_aq_nvm_update_empr(hw);
+		if (status) {
+			dev_err(dev, "Failed to trigger immediate device reset, err %s aq_err %s\n",
+				ice_stat_str(status),
+				ice_aq_str(hw->adminq.sq_last_status));
+			NL_SET_ERR_MSG_MOD(extack, "Failed to trigger immediate device reset");
+			return -EIO;
+		}
+	}
+
 	return 0;
 }
 
@@ -650,7 +671,24 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 	priv.context.dev = dev;
 	priv.extack = extack;
 	priv.pf = pf;
-	priv.activate_flags = ICE_AQC_NVM_PRESERVE_ALL;
+
+	/* Determine the preservation mode, used when activating the NVM banks
+	 * at the end of the update.
+	 */
+	switch (pf->flash_params.preservation_level) {
+	case ICE_FLASH_UPDATE_PRESERVE_ALL:
+		priv.activate_flags = ICE_AQC_NVM_PRESERVE_ALL;
+		break;
+	case ICE_FLASH_UPDATE_PRESERVE_LIMITED:
+		priv.activate_flags = ICE_AQC_NVM_PRESERVE_SELECTED;
+		break;
+	case ICE_FLASH_UPDATE_PRESERVE_FACTORY_SETTINGS:
+		priv.activate_flags = ICE_AQC_NVM_FACTORY_DEFAULT;
+		break;
+	case ICE_FLASH_UPDATE_PRESERVE_NONE:
+		priv.activate_flags = ICE_AQC_NVM_NO_PRESERVATION;
+		break;
+	}
 
 	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
 	if (status) {
@@ -689,11 +727,13 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
 				 struct netlink_ext_ack *extack)
 {
+	struct devlink *devlink = priv_to_devlink(pf);
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw_dev_caps *dev_caps;
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
 	u8 pending = 0;
+	int err;
 
 	dev_caps = kzalloc(sizeof(*dev_caps), GFP_KERNEL);
 	if (!dev_caps)
@@ -746,7 +786,32 @@ int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
 	if (!pending)
 		return 0;
 
-	dev_err(dev, "Flash update request rejected due to previous pending update\n");
-	NL_SET_ERR_MSG_MOD(extack, "The device already has a pending update");
-	return -EALREADY;
+	if (!pf->flash_params.ignore_pending_update) {
+		dev_err(dev, "Flash update request rejected due to previous pending update\n");
+		NL_SET_ERR_MSG_MOD(extack, "The device already has a pending update");
+		return -EALREADY;
+	}
+
+	/* In order to allow overwriting a previous pending update, notify
+	 * firmware to cancel that update by issuing the appropriate command.
+	 */
+	devlink_flash_update_status_notify(devlink,
+					   "Canceling previous pending update",
+					   component, 0, 0);
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
+	pending |= ICE_AQC_NVM_REVERT_LAST_ACTIV;
+	err = ice_switch_flash_banks(pf, pending, extack);
+
+	ice_release_nvm(hw);
+
+	return err;
 }
-- 
2.27.0.353.gb9a2d1a0207f

