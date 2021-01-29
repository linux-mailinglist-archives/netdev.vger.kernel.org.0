Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31132308298
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhA2An4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:43:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:27157 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231483AbhA2Anu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:43:50 -0500
IronPort-SDR: VqMOfEmtMO139uE7Pfkt34IkQydO5RFmeuHA1JonzesIB7GqLYXocx6FAmTCjeZYbR9o1725NR
 vVLx3ZxIhwMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="167438963"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="167438963"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 16:42:51 -0800
IronPort-SDR: f9CQpAM8wMKRLWDI2wFi3EIYBAKkg+El4z3MsxvYGy8SjVWzdSzUswUwbwvBzOab2QfkesNWut
 Lu9/F5V/X1Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="430778688"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2021 16:42:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 03/15] ice: read security revision to ice_nvm_info and ice_orom_info
Date:   Thu, 28 Jan 2021 16:43:20 -0800
Message-Id: <20210129004332.3004826-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The main NVM module and the Option ROM module contain a security
revision in their CSS header. This security revision is used to
determine whether or not the signed module should be loaded at bootup.
If the module security revision is lower than the associated minimum
security revision, it will not be loaded.

The CSS header does not have a module id associated with it, and thus
requires flat NVM reads in order to access it. To do this, take
advantage of the cached bank information. Introduce a new
"ice_read_flash_module" function that takes the module and bank to read.
Implement both ice_read_active_nvm_module and
ice_read_active_orom_module. These functions will use the cached values
to determine the active bank and calculate the appropriate offset.

Using these new access functions, extract the security revision for both
the main NVM bank and the Option ROM into the associated info structure.

Add the security revisions to the devlink info output. Report the main
NVM bank security revision as "fw.mgmt.srev". Report the Option ROM
security revision as "fw.undi.srev".

A future patch will add the associated minimum security revisions as
devlink flash parameters.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 Documentation/networking/devlink/ice.rst     |   9 +
 drivers/net/ethernet/intel/ice/ice_devlink.c |  20 +++
 drivers/net/ethernet/intel/ice/ice_nvm.c     | 172 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_type.h    |   9 +
 4 files changed, 210 insertions(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index a432dc419fa4..78707970ee62 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -38,6 +38,11 @@ The ``ice`` driver reports the following versions
       - running
       - 0x305d955f
       - Unique identifier of the source for the management firmware.
+    * - ``fw.mgmt.srev``
+      - running
+      - 2
+      - Security revision of the management firmware and associated NVM
+        contents.
     * - ``fw.undi``
       - running
       - 1.2581.0
@@ -48,6 +53,10 @@ The ``ice`` driver reports the following versions
         non-breaking changes and reset to 1 when the major version is
         incremented. The patch version is normally 0 but is incremented when
         a fix is delivered as a patch against an older base Option ROM.
+    * - ``fw.undi.srev``
+      - running
+      - 2
+      - Security revision of the Option ROM containing the UEFI driver.
     * - ``fw.psid.api``
       - running
       - 0.80
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 44b64524b1b8..4b08bf6dd0b0 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -56,6 +56,15 @@ static int ice_info_fw_build(struct ice_pf *pf, char *buf, size_t len)
 	return 0;
 }
 
+static int ice_info_fw_srev(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_nvm_info *nvm = &pf->hw.flash.nvm;
+
+	snprintf(buf, len, "%u", nvm->srev);
+
+	return 0;
+}
+
 static int ice_info_orom_ver(struct ice_pf *pf, char *buf, size_t len)
 {
 	struct ice_orom_info *orom = &pf->hw.flash.orom;
@@ -65,6 +74,15 @@ static int ice_info_orom_ver(struct ice_pf *pf, char *buf, size_t len)
 	return 0;
 }
 
+static int ice_info_orom_srev(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_orom_info *orom = &pf->hw.flash.orom;
+
+	snprintf(buf, len, "%u", orom->srev);
+
+	return 0;
+}
+
 static int ice_info_nvm_ver(struct ice_pf *pf, char *buf, size_t len)
 {
 	struct ice_nvm_info *nvm = &pf->hw.flash.nvm;
@@ -148,7 +166,9 @@ static const struct ice_devlink_version {
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, ice_info_fw_mgmt),
 	running("fw.mgmt.api", ice_info_fw_api),
 	running("fw.mgmt.build", ice_info_fw_build),
+	running("fw.mgmt.srev", ice_info_fw_srev),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_UNDI, ice_info_orom_ver),
+	running("fw.undi.srev", ice_info_orom_srev),
 	running("fw.psid.api", ice_info_nvm_ver),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID, ice_info_eetrack),
 	running("fw.app.name", ice_info_ddp_pkg_name),
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 308344045397..21eef3d037d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -233,6 +233,105 @@ void ice_release_nvm(struct ice_hw *hw)
 	ice_release_res(hw, ICE_NVM_RES_ID);
 }
 
+/**
+ * ice_read_flash_module - Read a word from one of the main NVM modules
+ * @hw: pointer to the HW structure
+ * @bank: which bank of the module to read
+ * @module: the module to read
+ * @offset: the offset into the module in words
+ * @data: storage for the word read from the flash
+ *
+ * Read a word from the specified bank of the module. The bank must be either
+ * the 1st or 2nd bank. The word will be read using flat NVM access, and
+ * relies on the hw->flash.banks data being setup by
+ * ice_determine_active_flash_banks() during initialization.
+ */
+static enum ice_status
+ice_read_flash_module(struct ice_hw *hw, enum ice_flash_bank bank, u16 module,
+		      u32 offset, u16 *data)
+{
+	struct ice_bank_info *banks = &hw->flash.banks;
+	u32 bytes = sizeof(u16);
+	enum ice_status status;
+	__le16 data_local;
+	bool second_bank;
+	u32 start;
+
+	switch (bank) {
+	case ICE_1ST_FLASH_BANK:
+		second_bank = false;
+		break;
+	case ICE_2ND_FLASH_BANK:
+		second_bank = true;
+		break;
+	case ICE_INVALID_FLASH_BANK:
+	default:
+		ice_debug(hw, ICE_DBG_NVM, "Unexpected flash bank %u\n", bank);
+		return ICE_ERR_PARAM;
+	}
+
+	switch (module) {
+	case ICE_SR_1ST_NVM_BANK_PTR:
+		start = banks->nvm_ptr + (second_bank ? banks->nvm_size : 0);
+		break;
+	case ICE_SR_1ST_OROM_BANK_PTR:
+		start = banks->orom_ptr + (second_bank ? banks->orom_size : 0);
+		break;
+	case ICE_SR_NETLIST_BANK_PTR:
+		start = banks->netlist_ptr + (second_bank ? banks->netlist_size : 0);
+		break;
+	default:
+		ice_debug(hw, ICE_DBG_NVM, "Unexpected flash module 0x%04x\n", module);
+		return ICE_ERR_PARAM;
+	}
+
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (status)
+		return status;
+
+	status = ice_read_flat_nvm(hw, start + offset * sizeof(u16), &bytes,
+				   (__force u8 *)&data_local, false);
+	if (!status)
+		*data = le16_to_cpu(data_local);
+
+	ice_release_nvm(hw);
+
+	return status;
+}
+
+/**
+ * ice_read_active_nvm_module - Read from the active main NVM module
+ * @hw: pointer to the HW structure
+ * @offset: offset into the NVM module to read, in words
+ * @data: storage for returned word value
+ *
+ * Read the specified word from the active NVM module. This includes the CSS
+ * header at the start of the NVM module.
+ */
+static enum ice_status
+ice_read_active_nvm_module(struct ice_hw *hw, u32 offset, u16 *data)
+{
+	return ice_read_flash_module(hw, hw->flash.banks.nvm_bank,
+				     ICE_SR_1ST_NVM_BANK_PTR, offset, data);
+}
+
+/**
+ * ice_read_active_orom_module - Read from the active Option ROM module
+ * @hw: pointer to the HW structure
+ * @offset: offset into the OROM module to read, in words
+ * @data: storage for returned word value
+ *
+ * Read the specified word from the active Option ROM module of the flash.
+ * Note that unlike the NVM module, the CSS data is stored at the end of the
+ * module instead of at the beginning.
+ */
+static enum ice_status
+ice_read_active_orom_module(struct ice_hw *hw, u32 offset, u16 *data)
+{
+	return ice_read_flash_module(hw, hw->flash.banks.orom_bank,
+				     ICE_SR_1ST_OROM_BANK_PTR, offset, data);
+}
+
 /**
  * ice_read_sr_word - Reads Shadow RAM word and acquire NVM if necessary
  * @hw: pointer to the HW structure
@@ -379,6 +478,32 @@ ice_read_pba_string(struct ice_hw *hw, u8 *pba_num, u32 pba_num_size)
 	return status;
 }
 
+/**
+ * ice_get_nvm_srev - Read the security revision from the NVM CSS header
+ * @hw: pointer to the HW struct
+ * @srev: storage for security revision
+ *
+ * Read the security revision out of the CSS header of the active NVM module
+ * bank.
+ */
+static enum ice_status ice_get_nvm_srev(struct ice_hw *hw, u32 *srev)
+{
+	enum ice_status status;
+	u16 srev_l, srev_h;
+
+	status = ice_read_active_nvm_module(hw, ICE_NVM_CSS_SREV_L, &srev_l);
+	if (status)
+		return status;
+
+	status = ice_read_active_nvm_module(hw, ICE_NVM_CSS_SREV_H, &srev_h);
+	if (status)
+		return status;
+
+	*srev = srev_h << 16 | srev_l;
+
+	return 0;
+}
+
 /**
  * ice_get_nvm_ver_info - Read NVM version information
  * @hw: pointer to the HW struct
@@ -414,6 +539,49 @@ ice_get_nvm_ver_info(struct ice_hw *hw, struct ice_nvm_info *nvm)
 
 	nvm->eetrack = (eetrack_hi << 16) | eetrack_lo;
 
+	status = ice_get_nvm_srev(hw, &nvm->srev);
+	if (status)
+		ice_debug(hw, ICE_DBG_NVM, "Failed to read NVM security revision.\n");
+
+	return 0;
+}
+
+/**
+ * ice_get_orom_srev - Read the security revision from the OROM CSS header
+ * @hw: pointer to the HW struct
+ * @srev: storage for security revision
+ *
+ * Read the security revision out of the CSS header of the active OROM module
+ * bank.
+ */
+static enum ice_status ice_get_orom_srev(struct ice_hw *hw, u32 *srev)
+{
+	enum ice_status status;
+	u16 srev_l, srev_h;
+	u32 css_start;
+
+	if (hw->flash.banks.orom_size < ICE_NVM_OROM_TRAILER_LENGTH) {
+		ice_debug(hw, ICE_DBG_NVM, "Unexpected Option ROM Size of %u\n",
+			  hw->flash.banks.orom_size);
+		return ICE_ERR_CFG;
+	}
+
+	/* calculate how far into the Option ROM the CSS header starts. Note
+	 * that ice_read_active_orom_module takes a word offset so we need to
+	 * divide by 2 here.
+	 */
+	css_start = (hw->flash.banks.orom_size - ICE_NVM_OROM_TRAILER_LENGTH) / 2;
+
+	status = ice_read_active_orom_module(hw, css_start + ICE_NVM_CSS_SREV_L, &srev_l);
+	if (status)
+		return status;
+
+	status = ice_read_active_orom_module(hw, css_start + ICE_NVM_CSS_SREV_H, &srev_h);
+	if (status)
+		return status;
+
+	*srev = srev_h << 16 | srev_l;
+
 	return 0;
 }
 
@@ -469,6 +637,10 @@ ice_get_orom_ver_info(struct ice_hw *hw, struct ice_orom_info *orom)
 	orom->build = (u16)((combo_ver & ICE_OROM_VER_BUILD_MASK) >>
 			    ICE_OROM_VER_BUILD_SHIFT);
 
+	status = ice_get_orom_srev(hw, &orom->srev);
+	if (status)
+		ice_debug(hw, ICE_DBG_NVM, "Failed to read Option ROM security revision.\n");
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index bc3be64cf3d9..0e0cbf90c431 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -311,11 +311,13 @@ struct ice_orom_info {
 	u8 major;			/* Major version of OROM */
 	u8 patch;			/* Patch version of OROM */
 	u16 build;			/* Build version of OROM */
+	u32 srev;			/* Security revision */
 };
 
 /* NVM version information */
 struct ice_nvm_info {
 	u32 eetrack;
+	u32 srev;
 	u8 major;
 	u8 minor;
 };
@@ -820,6 +822,13 @@ struct ice_hw_port_stats {
 #define ICE_SR_NETLIST_BANK_SIZE	0x47
 #define ICE_SR_SECTOR_SIZE_IN_WORDS	0x800
 
+/* CSS Header words */
+#define ICE_NVM_CSS_SREV_L			0x14
+#define ICE_NVM_CSS_SREV_H			0x15
+
+/* Size in bytes of Option ROM trailer */
+#define ICE_NVM_OROM_TRAILER_LENGTH		660
+
 /* Auxiliary field, mask, and shift definition for Shadow RAM and NVM Flash */
 #define ICE_SR_CTRL_WORD_1_S		0x06
 #define ICE_SR_CTRL_WORD_1_M		(0x03 << ICE_SR_CTRL_WORD_1_S)
-- 
2.26.2

