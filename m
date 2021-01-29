Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E518E3082A7
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhA2Ar0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:47:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:27200 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhA2ApV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:45:21 -0500
IronPort-SDR: a6sF3ToCST6wIbk0U5Ao6krM34iWYXHJt4HaDuv3edoMh9ukO9gHtEg2JUVBYbRMu3e5ipwZq2
 EjLUmdyP7TXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="167438969"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="167438969"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 16:42:52 -0800
IronPort-SDR: WteDlSfu1KUyilJsel5ZkWuq2tcSmD/4auXCOdoVhrffdzG8UYBYnMuRuAe2EESEwF1WD5VWDd
 i5r2U50ErnmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="430778706"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2021 16:42:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 09/15] ice: allow reading arbitrary size data with read_flash_module
Date:   Thu, 28 Jan 2021 16:43:26 -0800
Message-Id: <20210129004332.3004826-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Refactor ice_read_flash_module so that it takes a size and a length
value, rather than always reading in 2-byte increments. The
ice_read_nvm_module and ice_read_orom_module wrapper functions will
still read a u16 with the byte-swapping enabled.

This will be used in a future change to implement reading of the CIVD
data from the Option ROM module.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 34 ++++++++++++++++--------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 88a9e17744f3..ff99815402d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -306,10 +306,11 @@ static u32 ice_get_flash_bank_offset(struct ice_hw *hw, enum ice_bank_select ban
  * @hw: pointer to the HW structure
  * @bank: which bank of the module to read
  * @module: the module to read
- * @offset: the offset into the module in words
+ * @offset: the offset into the module in bytes
  * @data: storage for the word read from the flash
+ * @length: bytes of data to read
  *
- * Read a word from the specified flash module. The bank parameter indicates
+ * Read data from the specified flash module. The bank parameter indicates
  * whether or not to read from the active bank or the inactive bank of that
  * module.
  *
@@ -319,11 +320,9 @@ static u32 ice_get_flash_bank_offset(struct ice_hw *hw, enum ice_bank_select ban
  */
 static enum ice_status
 ice_read_flash_module(struct ice_hw *hw, enum ice_bank_select bank, u16 module,
-		      u32 offset, u16 *data)
+		      u32 offset, u8 *data, u32 length)
 {
-	u32 bytes = sizeof(u16);
 	enum ice_status status;
-	__le16 data_local;
 	u32 start;
 
 	start = ice_get_flash_bank_offset(hw, bank, module);
@@ -337,10 +336,7 @@ ice_read_flash_module(struct ice_hw *hw, enum ice_bank_select bank, u16 module,
 	if (status)
 		return status;
 
-	status = ice_read_flat_nvm(hw, start + offset * sizeof(u16), &bytes,
-				   (__force u8 *)&data_local, false);
-	if (!status)
-		*data = le16_to_cpu(data_local);
+	status = ice_read_flat_nvm(hw, start + offset, &length, data, false);
 
 	ice_release_nvm(hw);
 
@@ -360,7 +356,15 @@ ice_read_flash_module(struct ice_hw *hw, enum ice_bank_select bank, u16 module,
 static enum ice_status
 ice_read_nvm_module(struct ice_hw *hw, enum ice_bank_select bank, u32 offset, u16 *data)
 {
-	return ice_read_flash_module(hw, bank, ICE_SR_1ST_NVM_BANK_PTR, offset, data);
+	enum ice_status status;
+	__le16 data_local;
+
+	status = ice_read_flash_module(hw, bank, ICE_SR_1ST_NVM_BANK_PTR, offset * sizeof(u16),
+				       (__force u8 *)&data_local, sizeof(u16));
+	if (!status)
+		*data = le16_to_cpu(data_local);
+
+	return status;
 }
 
 /**
@@ -377,7 +381,15 @@ ice_read_nvm_module(struct ice_hw *hw, enum ice_bank_select bank, u32 offset, u1
 static enum ice_status
 ice_read_orom_module(struct ice_hw *hw, enum ice_bank_select bank, u32 offset, u16 *data)
 {
-	return ice_read_flash_module(hw, bank, ICE_SR_1ST_OROM_BANK_PTR, offset, data);
+	enum ice_status status;
+	__le16 data_local;
+
+	status = ice_read_flash_module(hw, bank, ICE_SR_1ST_OROM_BANK_PTR, offset * sizeof(u16),
+				       (__force u8 *)&data_local, sizeof(u16));
+	if (!status)
+		*data = le16_to_cpu(data_local);
+
+	return status;
 }
 
 /**
-- 
2.26.2

