Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D922491CD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgHSA2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:28:49 -0400
Received: from mga05.intel.com ([192.55.52.43]:48102 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgHSA2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 20:28:45 -0400
IronPort-SDR: wxa48L06lziWER7c04UKf/RkJXipuaJE8ak1pUGlN0pWBvbjaz8g7VK4DxLhAkLPGw0glShCX5
 vIbEQj5TP9wQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239856131"
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="239856131"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 17:28:38 -0700
IronPort-SDR: IsOPmNPPIkdloP7aixovx5fZVOlsAckE/vsBvv+DTMxOtB5+H1kE5FyFhDkd+S55BdVKzX6tjq
 yEZNjYntpm4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="320283576"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2020 17:28:38 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v3 4/4] ice: add support for flash update overwrite mask
Date:   Tue, 18 Aug 2020 17:28:18 -0700
Message-Id: <20200819002821.2657515-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.218.ge27853923b9d.dirty
In-Reply-To: <20200819002821.2657515-1-jacob.e.keller@intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the recently added DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK
parameter in the ice flash update handler. Convert the overwrite mask
bitfield into the appropriate preservation level used by the firmware
when updating.

Because there is no equivalent preservation level for overwriting only
identifiers, this combination is rejected by the driver as not supported
with an appropriate extended ACK message.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changes since v2:
* Rewrote the commit message slightly

 Documentation/networking/devlink/ice.rst      | 31 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 19 +++++++++++-
 .../net/ethernet/intel/ice/ice_fw_update.c    | 16 ++++++++--
 .../net/ethernet/intel/ice/ice_fw_update.h    |  2 +-
 4 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 237848d56f9b..8eb50ba41f1a 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -81,6 +81,37 @@ The ``ice`` driver reports the following versions
       - 0xee16ced7
       - The first 4 bytes of the hash of the netlist module contents.
 
+Flash Update
+============
+
+The ``ice`` driver implements support for flash update using the
+``devlink-flash`` interface. It supports updating the device flash using a
+combined flash image that contains the ``fw.mgmt``, ``fw.undi``, and
+``fw.netlist`` components.
+
+.. list-table:: List of supported overwrite modes
+   :widths: 5 95
+
+   * - Bits
+     - Behavior
+   * - ``DEVLINK_FLASH_OVERWRITE_SETTINGS``
+     - Do not preserve settings stored in the flash components being
+       updated. This includes overwriting the port configuration that
+       determines the number of physical functions the device will
+       initialize with.
+   * - ``DEVLINK_FLASH_OVERWRITE_SETTINGS`` and ``DEVLINK_FLASH_OVERWRITE_IDENTIFIERS``
+     - Do not preserve either settings or identifiers. Overwrite everything
+       in the flash with the contents from the provided image, without
+       performing any preservation. This includes overwriting device
+       identifying fields such as the MAC address, VPD area, and device
+       serial number. It is expected that this combination be used with an
+       image customized for the specific device.
+
+The ice hardware does not support overwriting only identifiers while
+preserving settings, and thus ``DEVLINK_FLASH_OVERWRITE_IDENTIFIERS`` on its
+own will be rejected. If no overwrite mask is provided, the firmware will be
+instructed to preserve all settings and identifying fields when updating.
+
 Regions
 =======
 
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 4f8f9e229080..c2726932b2d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -250,8 +250,24 @@ ice_devlink_flash_update(struct devlink *devlink,
 	struct device *dev = &pf->pdev->dev;
 	struct ice_hw *hw = &pf->hw;
 	const struct firmware *fw;
+	u8 preservation;
 	int err;
 
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
 	if (!hw->dev_caps.common_cap.nvm_unified_update) {
 		NL_SET_ERR_MSG_MOD(extack, "Current firmware does not support unified update");
 		return -EOPNOTSUPP;
@@ -269,7 +285,7 @@ ice_devlink_flash_update(struct devlink *devlink,
 
 	devlink_flash_update_begin_notify(devlink);
 	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
-	err = ice_flash_pldm_image(pf, fw, extack);
+	err = ice_flash_pldm_image(pf, fw, preservation, extack);
 	devlink_flash_update_end_notify(devlink);
 
 	release_firmware(fw);
@@ -278,6 +294,7 @@ ice_devlink_flash_update(struct devlink *devlink,
 }
 
 static const struct devlink_ops ice_devlink_ops = {
+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.info_get = ice_devlink_info_get,
 	.flash_update = ice_devlink_flash_update,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index deaefe00c9c0..c81273000d88 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -630,6 +630,7 @@ static const struct pldmfw_ops ice_fwu_ops = {
  * ice_flash_pldm_image - Write a PLDM-formatted firmware image to the device
  * @pf: private device driver structure
  * @fw: firmware object pointing to the relevant firmware file
+ * @preservation: preservation level to request from firmware
  * @extack: netlink extended ACK structure
  *
  * Parse the data for a given firmware file, verifying that it is a valid PLDM
@@ -643,7 +644,7 @@ static const struct pldmfw_ops ice_fwu_ops = {
  * Returns: zero on success or a negative error code on failure.
  */
 int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
-			 struct netlink_ext_ack *extack)
+			 u8 preservation, struct netlink_ext_ack *extack)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
@@ -651,13 +652,24 @@ int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
 	enum ice_status status;
 	int err;
 
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
 	memset(&priv, 0, sizeof(priv));
 
 	priv.context.ops = &ice_fwu_ops;
 	priv.context.dev = dev;
 	priv.extack = extack;
 	priv.pf = pf;
-	priv.activate_flags = ICE_AQC_NVM_PRESERVE_ALL;
+	priv.activate_flags = preservation;
 
 	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
 	if (status) {
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.h b/drivers/net/ethernet/intel/ice/ice_fw_update.h
index 79472cc618b4..c6390f6851ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.h
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.h
@@ -5,7 +5,7 @@
 #define _ICE_FW_UPDATE_H_
 
 int ice_flash_pldm_image(struct ice_pf *pf, const struct firmware *fw,
-			 struct netlink_ext_ack *extack);
+			 u8 preservation, struct netlink_ext_ack *extack);
 int ice_check_for_pending_update(struct ice_pf *pf, const char *component,
 				 struct netlink_ext_ack *extack);
 
-- 
2.28.0.218.ge27853923b9d.dirty

