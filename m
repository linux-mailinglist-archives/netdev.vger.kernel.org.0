Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D00714E5C6
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgA3W73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:29 -0500
Received: from mga12.intel.com ([192.55.52.136]:51510 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727639AbgA3W7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187813"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:23 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 11/15] ice: add board identifier info to devlink .info_get
Date:   Thu, 30 Jan 2020 14:59:06 -0800
Message-Id: <20200130225913.1671982-12-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export a unique board identifier using "board.id" for devlink's
.info_get command.

Obtain this by reading the NVM for the PBA identification string.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c  |  66 ----------
 drivers/net/ethernet/intel/ice/ice_common.h  |   3 -
 drivers/net/ethernet/intel/ice/ice_devlink.c |  14 ++
 drivers/net/ethernet/intel/ice/ice_nvm.c     | 127 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_nvm.h     |   5 +
 drivers/net/ethernet/intel/ice/ice_type.h    |   1 +
 6 files changed, 147 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 0207e28c2682..8928c3907596 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -966,72 +966,6 @@ enum ice_status ice_reset(struct ice_hw *hw, enum ice_reset_req req)
 	return ice_check_reset(hw);
 }
 
-/**
- * ice_get_pfa_module_tlv - Reads sub module TLV from NVM PFA
- * @hw: pointer to hardware structure
- * @module_tlv: pointer to module TLV to return
- * @module_tlv_len: pointer to module TLV length to return
- * @module_type: module type requested
- *
- * Finds the requested sub module TLV type from the Preserved Field
- * Area (PFA) and returns the TLV pointer and length. The caller can
- * use these to read the variable length TLV value.
- */
-enum ice_status
-ice_get_pfa_module_tlv(struct ice_hw *hw, u16 *module_tlv, u16 *module_tlv_len,
-		       u16 module_type)
-{
-	enum ice_status status;
-	u16 pfa_len, pfa_ptr;
-	u16 next_tlv;
-
-	status = ice_read_sr_word(hw, ICE_SR_PFA_PTR, &pfa_ptr);
-	if (status) {
-		ice_debug(hw, ICE_DBG_INIT, "Preserved Field Array pointer.\n");
-		return status;
-	}
-	status = ice_read_sr_word(hw, pfa_ptr, &pfa_len);
-	if (status) {
-		ice_debug(hw, ICE_DBG_INIT, "Failed to read PFA length.\n");
-		return status;
-	}
-	/* Starting with first TLV after PFA length, iterate through the list
-	 * of TLVs to find the requested one.
-	 */
-	next_tlv = pfa_ptr + 1;
-	while (next_tlv < pfa_ptr + pfa_len) {
-		u16 tlv_sub_module_type;
-		u16 tlv_len;
-
-		/* Read TLV type */
-		status = ice_read_sr_word(hw, next_tlv, &tlv_sub_module_type);
-		if (status) {
-			ice_debug(hw, ICE_DBG_INIT, "Failed to read TLV type.\n");
-			break;
-		}
-		/* Read TLV length */
-		status = ice_read_sr_word(hw, next_tlv + 1, &tlv_len);
-		if (status) {
-			ice_debug(hw, ICE_DBG_INIT, "Failed to read TLV length.\n");
-			break;
-		}
-		if (tlv_sub_module_type == module_type) {
-			if (tlv_len) {
-				*module_tlv = next_tlv;
-				*module_tlv_len = tlv_len;
-				return 0;
-			}
-			return ICE_ERR_INVAL_SIZE;
-		}
-		/* Check next TLV, i.e. current TLV pointer + length + 2 words
-		 * (for current TLV's type and length)
-		 */
-		next_tlv = next_tlv + tlv_len + 2;
-	}
-	/* Module does not exist */
-	return ICE_ERR_DOES_NOT_EXIST;
-}
-
 /**
  * ice_copy_rxq_ctx_to_hw
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 045913cd7428..6d5d18665c7e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -15,9 +15,6 @@ enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw);
 
 enum ice_status ice_init_hw(struct ice_hw *hw);
 void ice_deinit_hw(struct ice_hw *hw);
-enum ice_status
-ice_get_pfa_module_tlv(struct ice_hw *hw, u16 *module_tlv, u16 *module_tlv_len,
-		       u16 module_type);
 enum ice_status ice_check_reset(struct ice_hw *hw);
 enum ice_status ice_reset(struct ice_hw *hw, enum ice_reset_req req);
 enum ice_status ice_create_all_ctrlq(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 493c2c2986f2..3a98f241ccee 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -23,6 +23,7 @@ static int ice_devlink_info_get(struct devlink *devlink,
 	u8 oem_ver, oem_patch, nvm_ver_hi, nvm_ver_lo;
 	struct ice_pf *pf = devlink_priv(devlink);
 	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
 	u16 oem_build;
 	char buf[32]; /* TODO: size this properly */
 	int err;
@@ -44,6 +45,19 @@ static int ice_devlink_info_get(struct devlink *devlink,
 		return err;
 	}
 
+	status = ice_read_pba_string(hw, buf, sizeof(buf));
+	if (status) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to obtain PBA string");
+		return -EIO;
+	}
+
+	/* board.id (DEVLINK_INFO_VERSION_GENERIC_BOARD_ID) */
+	err = devlink_info_version_fixed_put(req, "board.id", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set board identifier");
+		return err;
+	}
+
 	/* fw (match exact output of ethtool -i firmware-version) */
 	err = devlink_info_version_running_put(req,
 					       DEVLINK_INFO_VERSION_GENERIC_FW,
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index ff9ccb17be25..ac7b3b9faeae 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -186,6 +186,133 @@ enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
 	return status;
 }
 
+/**
+ * ice_get_pfa_module_tlv - Reads sub module TLV from NVM PFA
+ * @hw: pointer to hardware structure
+ * @module_tlv: pointer to module TLV to return
+ * @module_tlv_len: pointer to module TLV length to return
+ * @module_type: module type requested
+ *
+ * Finds the requested sub module TLV type from the Preserved Field
+ * Area (PFA) and returns the TLV pointer and length. The caller can
+ * use these to read the variable length TLV value.
+ */
+enum ice_status
+ice_get_pfa_module_tlv(struct ice_hw *hw, u16 *module_tlv, u16 *module_tlv_len,
+		       u16 module_type)
+{
+	enum ice_status status;
+	u16 pfa_len, pfa_ptr;
+	u16 next_tlv;
+
+	status = ice_read_sr_word(hw, ICE_SR_PFA_PTR, &pfa_ptr);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT, "Preserved Field Array pointer.\n");
+		return status;
+	}
+	status = ice_read_sr_word(hw, pfa_ptr, &pfa_len);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read PFA length.\n");
+		return status;
+	}
+	/* Starting with first TLV after PFA length, iterate through the list
+	 * of TLVs to find the requested one.
+	 */
+	next_tlv = pfa_ptr + 1;
+	while (next_tlv < pfa_ptr + pfa_len) {
+		u16 tlv_sub_module_type;
+		u16 tlv_len;
+
+		/* Read TLV type */
+		status = ice_read_sr_word(hw, next_tlv, &tlv_sub_module_type);
+		if (status) {
+			ice_debug(hw, ICE_DBG_INIT, "Failed to read TLV type.\n");
+			break;
+		}
+		/* Read TLV length */
+		status = ice_read_sr_word(hw, next_tlv + 1, &tlv_len);
+		if (status) {
+			ice_debug(hw, ICE_DBG_INIT, "Failed to read TLV length.\n");
+			break;
+		}
+		if (tlv_sub_module_type == module_type) {
+			if (tlv_len) {
+				*module_tlv = next_tlv;
+				*module_tlv_len = tlv_len;
+				return 0;
+			}
+			return ICE_ERR_INVAL_SIZE;
+		}
+		/* Check next TLV, i.e. current TLV pointer + length + 2 words
+		 * (for current TLV's type and length)
+		 */
+		next_tlv = next_tlv + tlv_len + 2;
+	}
+	/* Module does not exist */
+	return ICE_ERR_DOES_NOT_EXIST;
+}
+
+/**
+ * ice_read_pba_string - Reads part number string from NVM
+ * @hw: pointer to hardware structure
+ * @pba_num: stores the part number string from the NVM
+ * @pba_num_size: part number string buffer length
+ *
+ * Reads the part number string from the NVM.
+ */
+enum ice_status
+ice_read_pba_string(struct ice_hw *hw, u8 *pba_num, u32 pba_num_size)
+{
+	u16 pba_tlv, pba_tlv_len;
+	enum ice_status status;
+	u16 pba_word, pba_size;
+	u16 i;
+
+	status = ice_get_pfa_module_tlv(hw, &pba_tlv, &pba_tlv_len,
+					ICE_SR_PBA_BLOCK_PTR);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read PBA Block TLV.\n");
+		return status;
+	}
+
+	/* pba_size is the next word */
+	status = ice_read_sr_word(hw, (pba_tlv + 2), &pba_size);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read PBA Section size.\n");
+		return status;
+	}
+
+	if (pba_tlv_len < pba_size) {
+		ice_debug(hw, ICE_DBG_INIT, "Invalid PBA Block TLV size.\n");
+		return ICE_ERR_INVAL_SIZE;
+	}
+
+	/* Subtract one to get PBA word count (PBA Size word is included in
+	 * total size)
+	 */
+	pba_size--;
+	if (pba_num_size < (((u32)pba_size * 2) + 1)) {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Buffer too small for PBA data.\n");
+		return ICE_ERR_PARAM;
+	}
+
+	for (i = 0; i < pba_size; i++) {
+		status = ice_read_sr_word(hw, (pba_tlv + 2 + 1) + i, &pba_word);
+		if (status) {
+			ice_debug(hw, ICE_DBG_INIT,
+				  "Failed to read PBA Block word %d.\n", i);
+			return status;
+		}
+
+		pba_num[(i * 2)] = (pba_word >> 8) & 0xFF;
+		pba_num[(i * 2) + 1] = pba_word & 0xFF;
+	}
+	pba_num[(pba_size * 2)] = '\0';
+
+	return status;
+}
+
 /**
  * ice_init_nvm - initializes NVM setting
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index 7375f6b96919..999f273ba6ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -10,6 +10,11 @@ void ice_release_nvm(struct ice_hw *hw);
 enum ice_status
 ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
 		  bool read_shadow_ram);
+enum ice_status
+ice_get_pfa_module_tlv(struct ice_hw *hw, u16 *module_tlv, u16 *module_tlv_len,
+		       u16 module_type);
+enum ice_status
+ice_read_pba_string(struct ice_hw *hw, u8 *pba_num, u32 pba_num_size);
 enum ice_status ice_init_nvm(struct ice_hw *hw);
 enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data);
 #endif /* _ICE_NVM_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index b361ffabb0ca..f65c53ea335b 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -627,6 +627,7 @@ struct ice_hw_port_stats {
 /* Checksum and Shadow RAM pointers */
 #define ICE_SR_BOOT_CFG_PTR		0x132
 #define ICE_NVM_OEM_VER_OFF		0x02
+#define ICE_SR_PBA_BLOCK_PTR		0x16
 #define ICE_SR_NVM_DEV_STARTER_VER	0x18
 #define ICE_SR_NVM_EETRACK_LO		0x2D
 #define ICE_SR_NVM_EETRACK_HI		0x2E
-- 
2.25.0.rc1

