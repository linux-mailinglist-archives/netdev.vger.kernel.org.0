Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48B0418DE9F
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 09:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgCUIKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 04:10:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:33283 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbgCUIKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 04:10:34 -0400
IronPort-SDR: eWY3Ejp13UXicgUEqMdcMMyMa/XaBLAQF3cIWzJ1olvyNRrLCeLBZKPXrW1Fb3ZGoon1eW0DbA
 Y6v39HOBSVZQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 01:10:31 -0700
IronPort-SDR: VM3eGVbbSbugnS3clA0Ji1Xmu137TmTg1uFjguUJVDBireF2ODYFCmzIf3bhDQrLbgKyH51CJv
 Sf6INKgOxBFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,287,1580803200"; 
   d="scan'208";a="234737973"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2020 01:10:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 9/9] ice: add board identifier info to devlink .info_get
Date:   Sat, 21 Mar 2020 01:10:28 -0700
Message-Id: <20200321081028.2763550-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
References: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Export a unique board identifier using "board.id" for devlink's
.info_get command.

Obtain this by reading the NVM for the PBA identification string.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 Documentation/networking/devlink/ice.rst     |   4 +
 drivers/net/ethernet/intel/ice/ice_common.c  |  66 ----------
 drivers/net/ethernet/intel/ice/ice_common.h  |   3 -
 drivers/net/ethernet/intel/ice/ice_devlink.c |  16 ++-
 drivers/net/ethernet/intel/ice/ice_nvm.c     | 125 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_nvm.h     |   5 +
 drivers/net/ethernet/intel/ice/ice_type.h    |   1 +
 7 files changed, 150 insertions(+), 70 deletions(-)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 56739a51cdfe..37fbbd40a5e5 100644
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
       - 2.1.7
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 6691e45367b3..2c0d8fd3d5cd 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -934,72 +934,6 @@ enum ice_status ice_reset(struct ice_hw *hw, enum ice_reset_req req)
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
index 06fcd3b55570..8104f3d64d96 100644
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
index 410e2b531e5d..27c5034c039a 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -19,6 +19,18 @@ static int ice_info_get_dsn(struct ice_pf *pf, char *buf, size_t len)
 	return 0;
 }
 
+static int ice_info_pba(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+
+	status = ice_read_pba_string(hw, (u8 *)buf, len);
+	if (status)
+		return -EIO;
+
+	return 0;
+}
+
 static int ice_info_fw_mgmt(struct ice_pf *pf, char *buf, size_t len)
 {
 	struct ice_hw *hw = &pf->hw;
@@ -93,6 +105,7 @@ static int ice_info_ddp_pkg_version(struct ice_pf *pf, char *buf, size_t len)
 	return 0;
 }
 
+#define fixed(key, getter) { ICE_VERSION_FIXED, key, getter }
 #define running(key, getter) { ICE_VERSION_RUNNING, key, getter }
 
 enum ice_version_type {
@@ -106,6 +119,7 @@ static const struct ice_devlink_version {
 	const char *key;
 	int (*getter)(struct ice_pf *pf, char *buf, size_t len);
 } ice_devlink_versions[] = {
+	fixed(DEVLINK_INFO_VERSION_GENERIC_BOARD_ID, ice_info_pba),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, ice_info_fw_mgmt),
 	running("fw.mgmt.api", ice_info_fw_api),
 	running("fw.mgmt.build", ice_info_fw_build),
@@ -125,7 +139,7 @@ static const struct ice_devlink_version {
  * Callback for the devlink .info_get operation. Reports information about the
  * device.
  *
- * @returns zero on success or an error code on failure.
+ * Return: zero on success or an error code on failure.
  */
 static int ice_devlink_info_get(struct devlink *devlink,
 				struct devlink_info_req *req,
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 08909d1c7cce..8beb675d676b 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -185,6 +185,131 @@ enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
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
  * ice_get_orom_ver_info - Read Option ROM version information
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
index b6a20670e915..4ce5f92fca4a 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -636,6 +636,7 @@ struct ice_hw_port_stats {
 /* Checksum and Shadow RAM pointers */
 #define ICE_SR_BOOT_CFG_PTR		0x132
 #define ICE_NVM_OROM_VER_OFF		0x02
+#define ICE_SR_PBA_BLOCK_PTR		0x16
 #define ICE_SR_NVM_DEV_STARTER_VER	0x18
 #define ICE_SR_NVM_EETRACK_LO		0x2D
 #define ICE_SR_NVM_EETRACK_HI		0x2E
-- 
2.25.1

