Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E37B311B18
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 05:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhBFErG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 23:47:06 -0500
Received: from mga18.intel.com ([134.134.136.126]:21610 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231463AbhBFEpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 23:45:24 -0500
IronPort-SDR: mehYuofzDqhM4uRN5HzoUdQ4MK5HuqfgSO7e4Cp9/KxV/AHcP4PfnCtnkv8ovfS9kBjCebmcK/
 a8BS+B5TPkvw==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="169194692"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="169194692"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 20:40:12 -0800
IronPort-SDR: GKUND6gNCuoIzn//Wh1ZyrUh7Q73Yq6hWOx/m7+FC5gLo/YCMcUpKxqM8doAsTefyMIuwevO6T
 SldvBIY6zziA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434751052"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 05 Feb 2021 20:40:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next v2 05/11] ice: introduce function for reading from flash modules
Date:   Fri,  5 Feb 2021 20:40:55 -0800
Message-Id: <20210206044101.636242-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
References: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When reading from the flash memory of the device, the ice driver has two
interfaces available to it. First, it can use a mediated interface via
firmware that allows specifying a module ID. This allows reading from
specific modules of the active flash bank.

The second interface available is to perform flat reads. This allows
complete access to the entire flash. However, using it requires the
software to handle calculating module location and interpret pointer
addresses.

While most data required is accessible through the convenient first
interface, certain flash contents are not. This includes the CSS header
information associated with the Option ROM and NVM banks, as well as any
access to the "inactive" banks used as scratch space for performing
flash updates.

In order to access all of the relevant flash contents, software must use
the flat reads. Rather than forcing all flows to perform flat read
calculations, introduce a new abstraction for reading from the flash:
ice_read_flash_module. This function provides an abstraction for reading
from either the active or inactive flash bank at the requested module.
This interface is very similar to the abstraction provided via firmware,
but allows access to additional modules, as well as providing
a mechanism to request access to both flash banks.

At first glance, it might make sense for this abstraction to allow
specifying precisely which bank (1st or 2nd) the caller wishes to read.
This is simpler to implement but more difficult to use. In practice,
most callers only know whether they want the active bank, or the
inactive bank. Rather than force callers to determine for themselves
which bank to read from, implement ice_read_flash_module in terms of
"active" vs "inactive". This significantly simplifies the implementation
at the caller level and is a more useful abstraction over the flash
contents.

Make use of this new interface to refactor reading of the main NVM
version information. Instead of using the firmware's mediated ShadowRAM
function, use the ice_read_flash_module abstraction.

To do this, notice that most reads of the NVM are going to be in 2-byte
word chunks. To simplify using ice_read_flash_module for this case,
ice_read_nvm_module is introduced. This is a simple wrapper around
ice_read_flash_module which takes the correct pointer address for the
NVM bank, and forces the 2-byte word format onto the caller.

When reading the NVM versions, some fields are read from the Shadow RAM.
The Shadow RAM is the first 64KB of flash memory, and is populated
during device load. Most fields are copied from a section within the
active NVM bank. In order to read this data from both the active and
inactive NVM banks, we need to read not from the first 64KB of flash,
but instead from the correct offset into the NVM bank. Introduce
ice_read_nvm_sr_copy for this purpose. This function wraps around
ice_read_nvm_module and has the same interface as the ice_read_sr_word,
with the exception of allowing the caller to specify whether to read the
active or inactive flash bank.

With this change, it is now trivial to refactor ice_get_nvm_ver_info to
read using the software mediated ice_read_flash_module interface instead
of relying on the firmware mediated interface. This will be used in the
following change to implement support for stored versions in the devlink
info report.

Additionally, the overall ice_read_flash_module interface will be used
and extended to support all three major flash banks, and additionally to
support reading the flash image security revision information.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c  | 162 +++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_type.h |  22 +++
 2 files changed, 179 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 0649923d6e2f..2434b7a4626b 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -233,6 +233,156 @@ void ice_release_nvm(struct ice_hw *hw)
 	ice_release_res(hw, ICE_NVM_RES_ID);
 }
 
+/**
+ * ice_get_flash_bank_offset - Get offset into requested flash bank
+ * @hw: pointer to the HW structure
+ * @bank: whether to read from the active or inactive flash bank
+ * @module: the module to read from
+ *
+ * Based on the module, lookup the module offset from the beginning of the
+ * flash.
+ *
+ * Returns the flash offset. Note that a value of zero is invalid and must be
+ * treated as an error.
+ */
+static u32 ice_get_flash_bank_offset(struct ice_hw *hw, enum ice_bank_select bank, u16 module)
+{
+	struct ice_bank_info *banks = &hw->flash.banks;
+	enum ice_flash_bank active_bank;
+	bool second_bank_active;
+	u32 offset, size;
+
+	switch (module) {
+	case ICE_SR_1ST_NVM_BANK_PTR:
+		offset = banks->nvm_ptr;
+		size = banks->nvm_size;
+		active_bank = banks->nvm_bank;
+		break;
+	case ICE_SR_1ST_OROM_BANK_PTR:
+		offset = banks->orom_ptr;
+		size = banks->orom_size;
+		active_bank = banks->orom_bank;
+		break;
+	case ICE_SR_NETLIST_BANK_PTR:
+		offset = banks->netlist_ptr;
+		size = banks->netlist_size;
+		active_bank = banks->netlist_bank;
+		break;
+	default:
+		ice_debug(hw, ICE_DBG_NVM, "Unexpected value for flash module: 0x%04x\n", module);
+		return 0;
+	}
+
+	switch (active_bank) {
+	case ICE_1ST_FLASH_BANK:
+		second_bank_active = false;
+		break;
+	case ICE_2ND_FLASH_BANK:
+		second_bank_active = true;
+		break;
+	default:
+		ice_debug(hw, ICE_DBG_NVM, "Unexpected value for active flash bank: %u\n",
+			  active_bank);
+		return 0;
+	}
+
+	/* The second flash bank is stored immediately following the first
+	 * bank. Based on whether the 1st or 2nd bank is active, and whether
+	 * we want the active or inactive bank, calculate the desired offset.
+	 */
+	switch (bank) {
+	case ICE_ACTIVE_FLASH_BANK:
+		return offset + (second_bank_active ? size : 0);
+	case ICE_INACTIVE_FLASH_BANK:
+		return offset + (second_bank_active ? 0 : size);
+	}
+
+	ice_debug(hw, ICE_DBG_NVM, "Unexpected value for flash bank selection: %u\n", bank);
+	return 0;
+}
+
+/**
+ * ice_read_flash_module - Read a word from one of the main NVM modules
+ * @hw: pointer to the HW structure
+ * @bank: which bank of the module to read
+ * @module: the module to read
+ * @offset: the offset into the module in bytes
+ * @data: storage for the word read from the flash
+ * @length: bytes of data to read
+ *
+ * Read data from the specified flash module. The bank parameter indicates
+ * whether or not to read from the active bank or the inactive bank of that
+ * module.
+ *
+ * The word will be read using flat NVM access, and relies on the
+ * hw->flash.banks data being setup by ice_determine_active_flash_banks()
+ * during initialization.
+ */
+static enum ice_status
+ice_read_flash_module(struct ice_hw *hw, enum ice_bank_select bank, u16 module,
+		      u32 offset, u8 *data, u32 length)
+{
+	enum ice_status status;
+	u32 start;
+
+	start = ice_get_flash_bank_offset(hw, bank, module);
+	if (!start) {
+		ice_debug(hw, ICE_DBG_NVM, "Unable to calculate flash bank offset for module 0x%04x\n",
+			  module);
+		return ICE_ERR_PARAM;
+	}
+
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (status)
+		return status;
+
+	status = ice_read_flat_nvm(hw, start + offset, &length, data, false);
+
+	ice_release_nvm(hw);
+
+	return status;
+}
+
+/**
+ * ice_read_nvm_module - Read from the active main NVM module
+ * @hw: pointer to the HW structure
+ * @bank: whether to read from active or inactive NVM module
+ * @offset: offset into the NVM module to read, in words
+ * @data: storage for returned word value
+ *
+ * Read the specified word from the active NVM module. This includes the CSS
+ * header at the start of the NVM module.
+ */
+static enum ice_status
+ice_read_nvm_module(struct ice_hw *hw, enum ice_bank_select bank, u32 offset, u16 *data)
+{
+	enum ice_status status;
+	__le16 data_local;
+
+	status = ice_read_flash_module(hw, bank, ICE_SR_1ST_NVM_BANK_PTR, offset * sizeof(u16),
+				       (__force u8 *)&data_local, sizeof(u16));
+	if (!status)
+		*data = le16_to_cpu(data_local);
+
+	return status;
+}
+
+/**
+ * ice_read_nvm_sr_copy - Read a word from the Shadow RAM copy in the NVM bank
+ * @hw: pointer to the HW structure
+ * @bank: whether to read from the active or inactive NVM module
+ * @offset: offset into the Shadow RAM copy to read, in words
+ * @data: storage for returned word value
+ *
+ * Read the specified word from the copy of the Shadow RAM found in the
+ * specified NVM module.
+ */
+static enum ice_status
+ice_read_nvm_sr_copy(struct ice_hw *hw, enum ice_bank_select bank, u32 offset, u16 *data)
+{
+	return ice_read_nvm_module(hw, bank, ICE_NVM_SR_COPY_WORD_OFFSET + offset, data);
+}
+
 /**
  * ice_read_sr_word - Reads Shadow RAM word and acquire NVM if necessary
  * @hw: pointer to the HW structure
@@ -382,31 +532,33 @@ ice_read_pba_string(struct ice_hw *hw, u8 *pba_num, u32 pba_num_size)
 /**
  * ice_get_nvm_ver_info - Read NVM version information
  * @hw: pointer to the HW struct
+ * @bank: whether to read from the active or inactive flash bank
  * @nvm: pointer to NVM info structure
  *
  * Read the NVM EETRACK ID and map version of the main NVM image bank, filling
  * in the NVM info structure.
  */
 static enum ice_status
-ice_get_nvm_ver_info(struct ice_hw *hw, struct ice_nvm_info *nvm)
+ice_get_nvm_ver_info(struct ice_hw *hw, enum ice_bank_select bank, struct ice_nvm_info *nvm)
 {
 	u16 eetrack_lo, eetrack_hi, ver;
 	enum ice_status status;
 
-	status = ice_read_sr_word(hw, ICE_SR_NVM_DEV_STARTER_VER, &ver);
+	status = ice_read_nvm_sr_copy(hw, bank, ICE_SR_NVM_DEV_STARTER_VER, &ver);
 	if (status) {
 		ice_debug(hw, ICE_DBG_NVM, "Failed to read DEV starter version.\n");
 		return status;
 	}
+
 	nvm->major = (ver & ICE_NVM_VER_HI_MASK) >> ICE_NVM_VER_HI_SHIFT;
 	nvm->minor = (ver & ICE_NVM_VER_LO_MASK) >> ICE_NVM_VER_LO_SHIFT;
 
-	status = ice_read_sr_word(hw, ICE_SR_NVM_EETRACK_LO, &eetrack_lo);
+	status = ice_read_nvm_sr_copy(hw, bank, ICE_SR_NVM_EETRACK_LO, &eetrack_lo);
 	if (status) {
 		ice_debug(hw, ICE_DBG_NVM, "Failed to read EETRACK lo.\n");
 		return status;
 	}
-	status = ice_read_sr_word(hw, ICE_SR_NVM_EETRACK_HI, &eetrack_hi);
+	status = ice_read_nvm_sr_copy(hw, bank, ICE_SR_NVM_EETRACK_HI, &eetrack_hi);
 	if (status) {
 		ice_debug(hw, ICE_DBG_NVM, "Failed to read EETRACK hi.\n");
 		return status;
@@ -794,7 +946,7 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 		return status;
 	}
 
-	status = ice_get_nvm_ver_info(hw, &flash->nvm);
+	status = ice_get_nvm_ver_info(hw, ICE_ACTIVE_FLASH_BANK, &flash->nvm);
 	if (status) {
 		ice_debug(hw, ICE_DBG_INIT, "Failed to read NVM info.\n");
 		return status;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index bc3be64cf3d9..f414cac159f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -339,6 +339,15 @@ enum ice_flash_bank {
 	ICE_2ND_FLASH_BANK,
 };
 
+/* Enumeration of which flash bank is desired to read from, either the active
+ * bank or the inactive bank. Used to abstract 1st and 2nd bank notion from
+ * code which just wants to read the active or inactive flash bank.
+ */
+enum ice_bank_select {
+	ICE_ACTIVE_FLASH_BANK,
+	ICE_INACTIVE_FLASH_BANK,
+};
+
 /* information for accessing NVM, OROM, and Netlist flash banks */
 struct ice_bank_info {
 	u32 nvm_ptr;				/* Pointer to 1st NVM bank */
@@ -820,6 +829,19 @@ struct ice_hw_port_stats {
 #define ICE_SR_NETLIST_BANK_SIZE	0x47
 #define ICE_SR_SECTOR_SIZE_IN_WORDS	0x800
 
+/* CSS Header words */
+#define ICE_NVM_CSS_SREV_L			0x14
+#define ICE_NVM_CSS_SREV_H			0x15
+
+/* Length of CSS header section in words */
+#define ICE_CSS_HEADER_LENGTH			330
+
+/* Offset of Shadow RAM copy in the NVM bank area. */
+#define ICE_NVM_SR_COPY_WORD_OFFSET		roundup(ICE_CSS_HEADER_LENGTH, 32)
+
+/* Size in bytes of Option ROM trailer */
+#define ICE_NVM_OROM_TRAILER_LENGTH		(2 * ICE_CSS_HEADER_LENGTH)
+
 /* Auxiliary field, mask, and shift definition for Shadow RAM and NVM Flash */
 #define ICE_SR_CTRL_WORD_1_S		0x06
 #define ICE_SR_CTRL_WORD_1_M		(0x03 << ICE_SR_CTRL_WORD_1_S)
-- 
2.26.2

