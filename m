Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0AD15FA56
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgBNXWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:31 -0500
Received: from mga17.intel.com ([192.55.52.151]:1652 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbgBNXW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629287"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:26 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 07/22] ice: add board identifier info to devlink .info_get
Date:   Fri, 14 Feb 2020 15:22:06 -0800
Message-Id: <20200214232223.3442651-8-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
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
 Documentation/networking/devlink/ice.rst     |   4 +
 drivers/net/ethernet/intel/ice/ice_common.c  |  66 ----------
 drivers/net/ethernet/intel/ice/ice_common.h  |   3 -
 drivers/net/ethernet/intel/ice/ice_devlink.c |  15 +++
 drivers/net/ethernet/intel/ice/ice_nvm.c     | 125 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_nvm.h     |   5 +
 drivers/net/ethernet/intel/ice/ice_type.h    |   1 +
 7 files changed, 150 insertions(+), 69 deletions(-)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 5545e708f18f..10ec6c1900b0 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -19,6 +19,10 @@ The ``ice`` driver reports the following versions
       - Type
       - Example
       - Description
+    * - ``board.id``
+      - fixed
+      - K65390-000
+      - The Product Board Assembly (PBA) identifier of the board.
     * - ``fw.mgmt``
       - running
       - 1.16.10
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index a74532520112..2ecf8bec795b 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -958,72 +958,6 @@ enum ice_status ice_reset(struct ice_hw *hw, enum ice_reset_req req)
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
index 0f9aa1986cab..8903e0aa42c5 100644
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
index f834025d58aa..1f755b98d785 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -23,6 +23,7 @@ static int ice_devlink_info_get(struct devlink *devlink,
 	u8 orom_maj, orom_patch, nvm_ver_hi, nvm_ver_lo;
 	struct ice_pf *pf = devlink_priv(devlink);
 	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
 	u16 orom_min;
 	char buf[32];
 	int err;
@@ -36,6 +37,20 @@ static int ice_devlink_info_get(struct devlink *devlink,
 		return err;
 	}
 
+	status = ice_read_pba_string(hw, buf, sizeof(buf));
+	if (status) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to obtain PBA string");
+		return -EIO;
+	}
+
+	err = devlink_info_version_fixed_put(req,
+					     DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
+					     buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set board identifier");
+		return err;
+	}
+
 	snprintf(buf, sizeof(buf), "%u.%u.%u", hw->fw_maj_ver, hw->fw_min_ver,
 		 hw->fw_patch);
 	err = devlink_info_version_running_put(req,
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 7d5f2a6296c9..d964311bdd66 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -186,6 +186,131 @@ enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
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
+		ice_debug(hw, ICE_DBG_INIT, "Buffer too small for PBA data.\n");
+		return ICE_ERR_PARAM;
+	}
+
+	for (i = 0; i < pba_size; i++) {
+		status = ice_read_sr_word(hw, (pba_tlv + 2 + 1) + i, &pba_word);
+		if (status) {
+			ice_debug(hw, ICE_DBG_INIT, "Failed to read PBA Block word %d.\n", i);
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
index 1d9420cd53b1..12e0aa061260 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -627,6 +627,7 @@ struct ice_hw_port_stats {
 /* Checksum and Shadow RAM pointers */
 #define ICE_SR_BOOT_CFG_PTR		0x132
 #define ICE_NVM_OROM_VER_OFF		0x02
+#define ICE_SR_PBA_BLOCK_PTR		0x16
 #define ICE_SR_NVM_DEV_STARTER_VER	0x18
 #define ICE_SR_NVM_EETRACK_LO		0x2D
 #define ICE_SR_NVM_EETRACK_HI		0x2E
-- 
2.25.0.368.g28a2d05eebfb

