Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E2618DEA3
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 09:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgCUIKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 04:10:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:33283 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbgCUIKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 04:10:35 -0400
IronPort-SDR: 3ElIq1K6j4lrGwB/FL0buS6NoI3KUu2Fp6exKTpZew1LhD9lkod6eq+tsNT1Wm+PX59KL8Z8mt
 lELtQcCSr10A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 01:10:31 -0700
IronPort-SDR: TB390WN0ObCWHISbtvwy2Xck2QEFDQ5k9vOcNmdP4abBuOwhjPBTbW+00rVQzZTwG6PtUqjIfN
 D9WOBMWD2mtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,287,1580803200"; 
   d="scan'208";a="234737958"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2020 01:10:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 4/9] ice: discover and store size of available flash
Date:   Sat, 21 Mar 2020 01:10:23 -0700
Message-Id: <20200321081028.2763550-5-jeffrey.t.kirsher@intel.com>
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

When reading from the NVM using a flat address, it is useful to know the
upper bound on the size of the flash contents. This value is not stored
within the NVM.

We can determine the size by performing a bisection between upper and
lower bounds. It is known that the size cannot exceed 16 MB (offset of
0xFFFFFF).

Use a while loop to bisect the upper and lower bounds by reading one
byte at a time. On a failed read, lower the maximum bound. On
a successful read, increase the lower bound.

Save this as the flash_size in the ice_nvm_info structure that contains
data related to the NVM.

The size will be used in a future patch for implementing full NVM read
via ethtool's GEEPROM command.

The maximum possible size for the flash is bounded by the size limit for
the NVM AdminQ commands. Add a new macro, ICE_AQC_NVM_MAX_OFFSET, which
can be used to represent this upper bound.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  2 +
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 62 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_type.h     |  1 +
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 33017d37ea33..2381b4014ed6 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1232,6 +1232,7 @@ struct ice_aqc_sff_eeprom {
  * NVM Update commands (indirect 0x0703)
  */
 struct ice_aqc_nvm {
+#define ICE_AQC_NVM_MAX_OFFSET		0xFFFFFF
 	__le16 offset_low;
 	u8 offset_high;
 	u8 cmd_flags;
@@ -1766,6 +1767,7 @@ enum ice_aq_err {
 	ICE_AQ_RC_ENOMEM	= 9,  /* Out of memory */
 	ICE_AQ_RC_EBUSY		= 12, /* Device or resource busy */
 	ICE_AQ_RC_EEXIST	= 13, /* Object already exists */
+	ICE_AQ_RC_EINVAL	= 14, /* Invalid argument */
 	ICE_AQ_RC_ENOSPC	= 16, /* No space left or allocation failure */
 	ICE_AQ_RC_ENOSYS	= 17, /* Function not implemented */
 	ICE_AQ_RC_ENOSEC	= 24, /* Missing security manifest */
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index ef68fa989a57..4cdce0370963 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -26,8 +26,7 @@ ice_aq_read_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset, u16 length,
 
 	cmd = &desc.params.nvm;
 
-	/* In offset the highest byte must be zeroed. */
-	if (offset & 0xFF000000)
+	if (offset > ICE_AQC_NVM_MAX_OFFSET)
 		return ICE_ERR_PARAM;
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_read);
@@ -363,6 +362,58 @@ static enum ice_status ice_get_orom_ver_info(struct ice_hw *hw)
 	return 0;
 }
 
+/**
+ * ice_discover_flash_size - Discover the available flash size.
+ * @hw: pointer to the HW struct
+ *
+ * The device flash could be up to 16MB in size. However, it is possible that
+ * the actual size is smaller. Use bisection to determine the accessible size
+ * of flash memory.
+ */
+static enum ice_status ice_discover_flash_size(struct ice_hw *hw)
+{
+	u32 min_size = 0, max_size = ICE_AQC_NVM_MAX_OFFSET + 1;
+	enum ice_status status;
+
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (status)
+		return status;
+
+	while ((max_size - min_size) > 1) {
+		u32 offset = (max_size + min_size) / 2;
+		u32 len = 1;
+		u8 data;
+
+		status = ice_read_flat_nvm(hw, offset, &len, &data, false);
+		if (status == ICE_ERR_AQ_ERROR &&
+		    hw->adminq.sq_last_status == ICE_AQ_RC_EINVAL) {
+			ice_debug(hw, ICE_DBG_NVM,
+				  "%s: New upper bound of %u bytes\n",
+				  __func__, offset);
+			status = 0;
+			max_size = offset;
+		} else if (!status) {
+			ice_debug(hw, ICE_DBG_NVM,
+				  "%s: New lower bound of %u bytes\n",
+				  __func__, offset);
+			min_size = offset;
+		} else {
+			/* an unexpected error occurred */
+			goto err_read_flat_nvm;
+		}
+	}
+
+	ice_debug(hw, ICE_DBG_NVM,
+		  "Predicted flash size is %u bytes\n", max_size);
+
+	hw->nvm.flash_size = max_size;
+
+err_read_flat_nvm:
+	ice_release_nvm(hw);
+
+	return status;
+}
+
 /**
  * ice_init_nvm - initializes NVM setting
  * @hw: pointer to the HW struct
@@ -421,6 +472,13 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 
 	nvm->eetrack = (eetrack_hi << 16) | eetrack_lo;
 
+	status = ice_discover_flash_size(hw);
+	if (status) {
+		ice_debug(hw, ICE_DBG_NVM,
+			  "NVM init error: failed to discover flash size.\n");
+		return status;
+	}
+
 	switch (hw->device_id) {
 	/* the following devices do not have boot_cfg_tlv yet */
 	case ICE_DEV_ID_E823C_BACKPLANE:
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 5bc94217778e..b6a20670e915 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -251,6 +251,7 @@ struct ice_nvm_info {
 	struct ice_orom_info orom;	/* Option ROM version info */
 	u32 eetrack;			/* NVM data version */
 	u16 sr_words;			/* Shadow RAM size in words */
+	u32 flash_size;			/* Size of available flash in bytes */
 	u8 major_ver;			/* major version of NVM package */
 	u8 minor_ver;			/* minor version of dev starter */
 	u8 blank_nvm_mode;        /* is NVM empty (no FW present) */
-- 
2.25.1

