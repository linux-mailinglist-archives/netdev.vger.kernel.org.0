Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AC53082A5
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhA2Aqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:46:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:27154 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhA2Aoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:44:44 -0500
IronPort-SDR: 79vYb7Fk7HX9yho6l+zFGCRnV+DOt4ATRF7IwmJ4/zwxjiSOwQvauYPRDsNKbBmBUP0v82LhuK
 GexeKzC4cawQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="167438968"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="167438968"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 16:42:52 -0800
IronPort-SDR: dRN2iTZtb44Ecw+BEjsLr3hk4YNt6LtVWUHLx9RohEzIftWOfXzg0IAtSZc/jKh15S5b8LLe4F
 9imyzSYEJUNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="430778703"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2021 16:42:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 08/15] ice: allow reading inactive flash security revision
Date:   Thu, 28 Jan 2021 16:43:25 -0800
Message-Id: <20210129004332.3004826-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Modify ice_get_nvm_srev and ice_get_orom_srev to take the
ice_flash_bank enumeration that specifies whether to read from the
active or the inactive flash module. Rename and refactor the
ice_read_active_nvm_module and ice_read_active_orom_module functions to
take the bank enum value as well.

With this change, ice_get_nvm_srev and ice_get_orom_srev will be usable
in a future change to implement reading the version data for a pending
flash image.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 36 +++++++++++++-----------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 0e949114359c..88a9e17744f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -348,8 +348,9 @@ ice_read_flash_module(struct ice_hw *hw, enum ice_bank_select bank, u16 module,
 }
 
 /**
- * ice_read_active_nvm_module - Read from the active main NVM module
+ * ice_read_nvm_module - Read from the active main NVM module
  * @hw: pointer to the HW structure
+ * @bank: whether to read from active or inactive NVM module
  * @offset: offset into the NVM module to read, in words
  * @data: storage for returned word value
  *
@@ -357,15 +358,15 @@ ice_read_flash_module(struct ice_hw *hw, enum ice_bank_select bank, u16 module,
  * header at the start of the NVM module.
  */
 static enum ice_status
-ice_read_active_nvm_module(struct ice_hw *hw, u32 offset, u16 *data)
+ice_read_nvm_module(struct ice_hw *hw, enum ice_bank_select bank, u32 offset, u16 *data)
 {
-	return ice_read_flash_module(hw, ICE_ACTIVE_FLASH_BANK,
-				     ICE_SR_1ST_NVM_BANK_PTR, offset, data);
+	return ice_read_flash_module(hw, bank, ICE_SR_1ST_NVM_BANK_PTR, offset, data);
 }
 
 /**
- * ice_read_active_orom_module - Read from the active Option ROM module
+ * ice_read_orom_module - Read from the active Option ROM module
  * @hw: pointer to the HW structure
+ * @bank: whether to read from active or inactive OROM module
  * @offset: offset into the OROM module to read, in words
  * @data: storage for returned word value
  *
@@ -374,10 +375,9 @@ ice_read_active_nvm_module(struct ice_hw *hw, u32 offset, u16 *data)
  * module instead of at the beginning.
  */
 static enum ice_status
-ice_read_active_orom_module(struct ice_hw *hw, u32 offset, u16 *data)
+ice_read_orom_module(struct ice_hw *hw, enum ice_bank_select bank, u32 offset, u16 *data)
 {
-	return ice_read_flash_module(hw, ICE_ACTIVE_FLASH_BANK,
-				     ICE_SR_1ST_OROM_BANK_PTR, offset, data);
+	return ice_read_flash_module(hw, bank, ICE_SR_1ST_OROM_BANK_PTR, offset, data);
 }
 
 /**
@@ -529,21 +529,22 @@ ice_read_pba_string(struct ice_hw *hw, u8 *pba_num, u32 pba_num_size)
 /**
  * ice_get_nvm_srev - Read the security revision from the NVM CSS header
  * @hw: pointer to the HW struct
+ * @bank: whether to read from the active or inactive flash bank
  * @srev: storage for security revision
  *
  * Read the security revision out of the CSS header of the active NVM module
  * bank.
  */
-static enum ice_status ice_get_nvm_srev(struct ice_hw *hw, u32 *srev)
+static enum ice_status ice_get_nvm_srev(struct ice_hw *hw, enum ice_bank_select bank, u32 *srev)
 {
 	enum ice_status status;
 	u16 srev_l, srev_h;
 
-	status = ice_read_active_nvm_module(hw, ICE_NVM_CSS_SREV_L, &srev_l);
+	status = ice_read_nvm_module(hw, bank, ICE_NVM_CSS_SREV_L, &srev_l);
 	if (status)
 		return status;
 
-	status = ice_read_active_nvm_module(hw, ICE_NVM_CSS_SREV_H, &srev_h);
+	status = ice_read_nvm_module(hw, bank, ICE_NVM_CSS_SREV_H, &srev_h);
 	if (status)
 		return status;
 
@@ -587,7 +588,7 @@ ice_get_nvm_ver_info(struct ice_hw *hw, struct ice_nvm_info *nvm)
 
 	nvm->eetrack = (eetrack_hi << 16) | eetrack_lo;
 
-	status = ice_get_nvm_srev(hw, &nvm->srev);
+	status = ice_get_nvm_srev(hw, ICE_ACTIVE_FLASH_BANK, &nvm->srev);
 	if (status)
 		ice_debug(hw, ICE_DBG_NVM, "Failed to read NVM security revision.\n");
 
@@ -597,12 +598,13 @@ ice_get_nvm_ver_info(struct ice_hw *hw, struct ice_nvm_info *nvm)
 /**
  * ice_get_orom_srev - Read the security revision from the OROM CSS header
  * @hw: pointer to the HW struct
+ * @bank: whether to read from active or inactive flash module
  * @srev: storage for security revision
  *
  * Read the security revision out of the CSS header of the active OROM module
  * bank.
  */
-static enum ice_status ice_get_orom_srev(struct ice_hw *hw, u32 *srev)
+static enum ice_status ice_get_orom_srev(struct ice_hw *hw, enum ice_bank_select bank, u32 *srev)
 {
 	enum ice_status status;
 	u16 srev_l, srev_h;
@@ -615,16 +617,16 @@ static enum ice_status ice_get_orom_srev(struct ice_hw *hw, u32 *srev)
 	}
 
 	/* calculate how far into the Option ROM the CSS header starts. Note
-	 * that ice_read_active_orom_module takes a word offset so we need to
+	 * that ice_read_orom_module takes a word offset so we need to
 	 * divide by 2 here.
 	 */
 	css_start = (hw->flash.banks.orom_size - ICE_NVM_OROM_TRAILER_LENGTH) / 2;
 
-	status = ice_read_active_orom_module(hw, css_start + ICE_NVM_CSS_SREV_L, &srev_l);
+	status = ice_read_orom_module(hw, bank, css_start + ICE_NVM_CSS_SREV_L, &srev_l);
 	if (status)
 		return status;
 
-	status = ice_read_active_orom_module(hw, css_start + ICE_NVM_CSS_SREV_H, &srev_h);
+	status = ice_read_orom_module(hw, bank, css_start + ICE_NVM_CSS_SREV_H, &srev_h);
 	if (status)
 		return status;
 
@@ -685,7 +687,7 @@ ice_get_orom_ver_info(struct ice_hw *hw, struct ice_orom_info *orom)
 	orom->build = (u16)((combo_ver & ICE_OROM_VER_BUILD_MASK) >>
 			    ICE_OROM_VER_BUILD_SHIFT);
 
-	status = ice_get_orom_srev(hw, &orom->srev);
+	status = ice_get_orom_srev(hw, ICE_ACTIVE_FLASH_BANK, &orom->srev);
 	if (status)
 		ice_debug(hw, ICE_DBG_NVM, "Failed to read Option ROM security revision.\n");
 
-- 
2.26.2

