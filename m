Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA65E226A
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388952AbfJWSY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:24:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:64568 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387998AbfJWSY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 14:24:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 11:24:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="202075925"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Oct 2019 11:24:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sylwia Wnuczko <sylwia.wnuczko@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/11] i40e: Fix for persistent lldp support
Date:   Wed, 23 Oct 2019 11:24:16 -0700
Message-Id: <20191023182426.13233-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
References: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwia Wnuczko <sylwia.wnuczko@intel.com>

This patch fixes function to read NVM module data and uses it to
read current LLDP agent configuration from NVM API version 1.8.

Signed-off-by: Sylwia Wnuczko <sylwia.wnuczko@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_dcb.c    |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.h    |  3 +
 drivers/net/ethernet/intel/i40e/i40e_nvm.c    | 61 ++++++++++---------
 .../net/ethernet/intel/i40e/i40e_prototype.h  | 10 +--
 4 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_dcb.c b/drivers/net/ethernet/intel/i40e/i40e_dcb.c
index 200a1cb3b536..9de503c5f99b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_dcb.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_dcb.c
@@ -889,7 +889,9 @@ i40e_status i40e_init_dcb(struct i40e_hw *hw, bool enable_mib_change)
 
 		ret = i40e_read_nvm_module_data(hw,
 						I40E_SR_EMP_SR_SETTINGS_PTR,
-						offset, 1,
+						offset,
+						I40E_LLDP_CURRENT_STATUS_OFFSET,
+						I40E_LLDP_CURRENT_STATUS_SIZE,
 						&lldp_cfg.adminstatus);
 	} else {
 		ret = i40e_read_lldp_cfg(hw, &lldp_cfg);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_dcb.h b/drivers/net/ethernet/intel/i40e/i40e_dcb.h
index 2a80c5daa376..ba86ad833bee 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_dcb.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_dcb.h
@@ -32,6 +32,9 @@
 #define I40E_CEE_MAX_FEAT_TYPE		3
 #define I40E_LLDP_CURRENT_STATUS_XL710_OFFSET	0x2B
 #define I40E_LLDP_CURRENT_STATUS_X722_OFFSET	0x31
+#define I40E_LLDP_CURRENT_STATUS_OFFSET		1
+#define I40E_LLDP_CURRENT_STATUS_SIZE		1
+
 /* Defines for LLDP TLV header */
 #define I40E_LLDP_TLV_LEN_SHIFT		0
 #define I40E_LLDP_TLV_LEN_MASK		(0x01FF << I40E_LLDP_TLV_LEN_SHIFT)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_nvm.c b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
index e4d8d20baf3b..7164f4ad8120 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_nvm.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
@@ -323,20 +323,24 @@ i40e_status i40e_read_nvm_word(struct i40e_hw *hw, u16 offset,
 
 /**
  * i40e_read_nvm_module_data - Reads NVM Buffer to specified memory location
- * @hw: pointer to the HW structure
+ * @hw: Pointer to the HW structure
  * @module_ptr: Pointer to module in words with respect to NVM beginning
- * @offset: offset in words from module start
+ * @module_offset: Offset in words from module start
+ * @data_offset: Offset in words from reading data area start
  * @words_data_size: Words to read from NVM
  * @data_ptr: Pointer to memory location where resulting buffer will be stored
  **/
-i40e_status i40e_read_nvm_module_data(struct i40e_hw *hw,
-				      u8 module_ptr, u16 offset,
-				      u16 words_data_size,
-				      u16 *data_ptr)
+enum i40e_status_code i40e_read_nvm_module_data(struct i40e_hw *hw,
+						u8 module_ptr,
+						u16 module_offset,
+						u16 data_offset,
+						u16 words_data_size,
+						u16 *data_ptr)
 {
 	i40e_status status;
+	u16 specific_ptr = 0;
 	u16 ptr_value = 0;
-	u32 flat_offset;
+	u32 offset = 0;
 
 	if (module_ptr != 0) {
 		status = i40e_read_nvm_word(hw, module_ptr, &ptr_value);
@@ -352,36 +356,35 @@ i40e_status i40e_read_nvm_module_data(struct i40e_hw *hw,
 
 	/* Pointer not initialized */
 	if (ptr_value == I40E_NVM_INVALID_PTR_VAL ||
-	    ptr_value == I40E_NVM_INVALID_VAL)
+	    ptr_value == I40E_NVM_INVALID_VAL) {
+		i40e_debug(hw, I40E_DEBUG_ALL, "Pointer not initialized.\n");
 		return I40E_ERR_BAD_PTR;
+	}
 
 	/* Check whether the module is in SR mapped area or outside */
 	if (ptr_value & I40E_PTR_TYPE) {
 		/* Pointer points outside of the Shared RAM mapped area */
-		ptr_value &= ~I40E_PTR_TYPE;
+		i40e_debug(hw, I40E_DEBUG_ALL,
+			   "Reading nvm data failed. Pointer points outside of the Shared RAM mapped area.\n");
 
-		/* PtrValue in 4kB units, need to convert to words */
-		ptr_value /= 2;
-		flat_offset = ((u32)ptr_value * 0x1000) + (u32)offset;
-		status = i40e_acquire_nvm(hw, I40E_RESOURCE_READ);
-		if (!status) {
-			status = i40e_aq_read_nvm(hw, 0, 2 * flat_offset,
-						  2 * words_data_size,
-						  data_ptr, true, NULL);
-			i40e_release_nvm(hw);
-			if (status) {
-				i40e_debug(hw, I40E_DEBUG_ALL,
-					   "Reading nvm aq failed.Error code: %d.\n",
-					   status);
-				return I40E_ERR_NVM;
-			}
-		} else {
-			return I40E_ERR_NVM;
-		}
+		return I40E_ERR_PARAM;
 	} else {
 		/* Read from the Shadow RAM */
-		status = i40e_read_nvm_buffer(hw, ptr_value + offset,
-					      &words_data_size, data_ptr);
+
+		status = i40e_read_nvm_word(hw, ptr_value + module_offset,
+					    &specific_ptr);
+		if (status) {
+			i40e_debug(hw, I40E_DEBUG_ALL,
+				   "Reading nvm word failed.Error code: %d.\n",
+				   status);
+			return I40E_ERR_NVM;
+		}
+
+		offset = ptr_value + module_offset + specific_ptr +
+			data_offset;
+
+		status = i40e_read_nvm_buffer(hw, offset, &words_data_size,
+					      data_ptr);
 		if (status) {
 			i40e_debug(hw, I40E_DEBUG_ALL,
 				   "Reading nvm buffer failed.Error code: %d.\n",
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index 5250441bf75b..7effe5010e32 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -315,10 +315,12 @@ i40e_status i40e_acquire_nvm(struct i40e_hw *hw,
 void i40e_release_nvm(struct i40e_hw *hw);
 i40e_status i40e_read_nvm_word(struct i40e_hw *hw, u16 offset,
 					 u16 *data);
-i40e_status i40e_read_nvm_module_data(struct i40e_hw *hw,
-				      u8 module_ptr, u16 offset,
-				      u16 words_data_size,
-				      u16 *data_ptr);
+enum i40e_status_code i40e_read_nvm_module_data(struct i40e_hw *hw,
+						u8 module_ptr,
+						u16 module_offset,
+						u16 data_offset,
+						u16 words_data_size,
+						u16 *data_ptr);
 i40e_status i40e_read_nvm_buffer(struct i40e_hw *hw, u16 offset,
 				 u16 *words, u16 *data);
 i40e_status i40e_update_nvm_checksum(struct i40e_hw *hw);
-- 
2.21.0

