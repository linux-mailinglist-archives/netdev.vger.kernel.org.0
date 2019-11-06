Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4ED2F1F19
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732565AbfKFTiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:38:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:25883 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729036AbfKFTiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 14:38:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 11:37:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="402473266"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2019 11:37:58 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 03/14] ice: Update Boot Configuration Section read of NVM
Date:   Wed,  6 Nov 2019 11:37:45 -0800
Message-Id: <20191106193756.23819-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
References: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>

The Boot Configuration Section Block has been moved to the Preserved Field
Area (PFA) of NVM. Update the NVM reads that involves Boot Configuration
Section.

Signed-off-by: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 66 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h |  3 +
 drivers/net/ethernet/intel/ice/ice_nvm.c    | 51 +++++++++++++---
 drivers/net/ethernet/intel/ice/ice_nvm.h    |  1 +
 drivers/net/ethernet/intel/ice/ice_type.h   |  3 +
 5 files changed, 115 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index b41bf475b36f..9972929053aa 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1066,6 +1066,72 @@ enum ice_status ice_reset(struct ice_hw *hw, enum ice_reset_req req)
 	return ice_check_reset(hw);
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
 /**
  * ice_copy_rxq_ctx_to_hw
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index ae9718c8736c..44b1f86e2979 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -17,6 +17,9 @@ void
 ice_debug_cq(struct ice_hw *hw, u32 mask, void *desc, void *buf, u16 buf_len);
 enum ice_status ice_init_hw(struct ice_hw *hw);
 void ice_deinit_hw(struct ice_hw *hw);
+enum ice_status
+ice_get_pfa_module_tlv(struct ice_hw *hw, u16 *module_tlv, u16 *module_tlv_len,
+		       u16 module_type);
 enum ice_status ice_check_reset(struct ice_hw *hw);
 enum ice_status ice_reset(struct ice_hw *hw, enum ice_reset_req req);
 enum ice_status ice_create_all_ctrlq(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index bd19ce9b5bfd..28e1972e2bc9 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -168,8 +168,7 @@ void ice_release_nvm(struct ice_hw *hw)
  *
  * Reads one 16 bit word from the Shadow RAM using the ice_read_sr_word_aq.
  */
-static enum
-ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
+enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
 {
 	enum ice_status status;
 
@@ -191,9 +190,10 @@ ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data)
  */
 enum ice_status ice_init_nvm(struct ice_hw *hw)
 {
+	u16 oem_hi, oem_lo, boot_cfg_tlv, boot_cfg_tlv_len;
 	struct ice_nvm_info *nvm = &hw->nvm;
 	u16 eetrack_lo, eetrack_hi;
-	enum ice_status status = 0;
+	enum ice_status status;
 	u32 fla, gens_stat;
 	u8 sr_size;
 
@@ -210,15 +210,15 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 	fla = rd32(hw, GLNVM_FLA);
 	if (fla & GLNVM_FLA_LOCKED_M) { /* Normal programming mode */
 		nvm->blank_nvm_mode = false;
-	} else { /* Blank programming mode */
+	} else {
+		/* Blank programming mode */
 		nvm->blank_nvm_mode = true;
-		status = ICE_ERR_NVM_BLANK_MODE;
 		ice_debug(hw, ICE_DBG_NVM,
 			  "NVM init error: unsupported blank mode.\n");
-		return status;
+		return ICE_ERR_NVM_BLANK_MODE;
 	}
 
-	status = ice_read_sr_word(hw, ICE_SR_NVM_DEV_STARTER_VER, &hw->nvm.ver);
+	status = ice_read_sr_word(hw, ICE_SR_NVM_DEV_STARTER_VER, &nvm->ver);
 	if (status) {
 		ice_debug(hw, ICE_DBG_INIT,
 			  "Failed to read DEV starter version.\n");
@@ -236,9 +236,42 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 		return status;
 	}
 
-	hw->nvm.eetrack = (eetrack_hi << 16) | eetrack_lo;
+	nvm->eetrack = (eetrack_hi << 16) | eetrack_lo;
 
-	return status;
+	status = ice_get_pfa_module_tlv(hw, &boot_cfg_tlv, &boot_cfg_tlv_len,
+					ICE_SR_BOOT_CFG_PTR);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Failed to read Boot Configuration Block TLV.\n");
+		return status;
+	}
+
+	/* Boot Configuration Block must have length at least 2 words
+	 * (Combo Image Version High and Combo Image Version Low)
+	 */
+	if (boot_cfg_tlv_len < 2) {
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Invalid Boot Configuration Block TLV size.\n");
+		return ICE_ERR_INVAL_SIZE;
+	}
+
+	status = ice_read_sr_word(hw, (boot_cfg_tlv + ICE_NVM_OEM_VER_OFF),
+				  &oem_hi);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read OEM_VER hi.\n");
+		return status;
+	}
+
+	status = ice_read_sr_word(hw, (boot_cfg_tlv + ICE_NVM_OEM_VER_OFF + 1),
+				  &oem_lo);
+	if (status) {
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read OEM_VER lo.\n");
+		return status;
+	}
+
+	nvm->oem_ver = ((u32)oem_hi << 16) | oem_lo;
+
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index 75d167b7ebe3..b6dd6226e81c 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -76,4 +76,5 @@ ice_aq_read_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset, u16 length,
 		void *data, bool last_command, bool read_shadow_ram,
 		struct ice_sq_cd *cd);
 enum ice_status ice_init_nvm(struct ice_hw *hw);
+enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data);
 #endif /* _ICE_NVM_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 6667d17a4206..08fe3e5e72d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -555,6 +555,8 @@ struct ice_hw_port_stats {
 };
 
 /* Checksum and Shadow RAM pointers */
+#define ICE_SR_BOOT_CFG_PTR		0x132
+#define ICE_NVM_OEM_VER_OFF		0x02
 #define ICE_SR_NVM_DEV_STARTER_VER	0x18
 #define ICE_SR_NVM_EETRACK_LO		0x2D
 #define ICE_SR_NVM_EETRACK_HI		0x2E
@@ -568,6 +570,7 @@ struct ice_hw_port_stats {
 #define ICE_OEM_VER_BUILD_MASK		(0xffff << ICE_OEM_VER_BUILD_SHIFT)
 #define ICE_OEM_VER_SHIFT		24
 #define ICE_OEM_VER_MASK		(0xff << ICE_OEM_VER_SHIFT)
+#define ICE_SR_PFA_PTR			0x40
 #define ICE_SR_SECTOR_SIZE_IN_WORDS	0x800
 #define ICE_SR_WORDS_IN_1KB		512
 
-- 
2.21.0

