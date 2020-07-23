Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBC922BA61
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgGWXr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:43317 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728181AbgGWXr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:28 -0400
IronPort-SDR: yiT/a87DzqisivnMr87bCdVpCWjSs+zZkWuuj7TGrlo2JcwAcIMNpJ7uG8JWI3rjpk4CEV1M8A
 Mo7RyyNN4+Sg==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235515431"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235515431"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:25 -0700
IronPort-SDR: 8pVWgFyJIuWKk6yCOkl+QIVnr5FV7ofq2/YHw5GFg/LCO6i2z5142oFVZobfyDrvVxLScd+vQM
 EJxbt9oE4Qhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742288"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 03/15] ice: split ice_discover_caps into two functions
Date:   Thu, 23 Jul 2020 16:47:08 -0700
Message-Id: <20200723234720.1547308-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Using the new ice_aq_list_caps and ice_parse_(dev|func)_caps functions,
replace ice_discover_caps with two functions that each take a pointer to
the dev_caps and func_caps structures respectively.

This makes the side effect of updating the hw->dev_caps and
hw->func_caps obvious from reading the implementation of the function.
Additionally, it opens the way for enabling reading of device
capabilities outside of the initialization flow. By passing in
a pointer, another caller will be able to read the capabilities without
modifying the HW capabilities structures.

As there are no other callers, it is safe to now remove
ice_aq_discover_caps and ice_parse_caps.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 94 +++++++++------------
 1 file changed, 39 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index c32b9100eec3..04e28090fef3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -52,7 +52,8 @@ enum ice_status ice_clear_pf_cfg(struct ice_hw *hw)
  * is returned in user specified buffer. Please interpret user specified
  * buffer as "manage_mac_read" response.
  * Response such as various MAC addresses are stored in HW struct (port.mac)
- * ice_aq_discover_caps is expected to be called before this function is called.
+ * ice_discover_dev_caps is expected to be called before this function is
+ * called.
  */
 static enum ice_status
 ice_aq_manage_mac_read(struct ice_hw *hw, void *buf, u16 buf_size,
@@ -2001,30 +2002,6 @@ ice_parse_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
 	ice_recalc_port_limited_caps(hw, &dev_p->common_cap);
 }
 
-/**
- * ice_parse_caps - parse function/device capabilities
- * @hw: pointer to the HW struct
- * @buf: pointer to a buffer containing function/device capability records
- * @cap_count: number of capability records in the list
- * @opc: type of capabilities list to parse
- *
- * Helper function to parse function(0x000a)/device(0x000b) capabilities list.
- */
-static void
-ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
-	       enum ice_adminq_opc opc)
-{
-	if (!buf)
-		return;
-
-	if (opc == ice_aqc_opc_list_dev_caps)
-		ice_parse_dev_caps(hw, &hw->dev_caps, buf, cap_count);
-	else if (opc == ice_aqc_opc_list_func_caps)
-		ice_parse_func_caps(hw, &hw->func_caps, buf, cap_count);
-	else
-		ice_debug(hw, ICE_DBG_INIT, "wrong opcode\n");
-}
-
 /**
  * ice_aq_list_caps - query function/device capabilities
  * @hw: pointer to the HW struct
@@ -2068,47 +2045,52 @@ ice_aq_list_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
 }
 
 /**
- * ice_aq_discover_caps - query function/device capabilities
- * @hw: pointer to the HW struct
- * @buf: a virtual buffer to hold the capabilities
- * @buf_size: Size of the virtual buffer
- * @cap_count: cap count needed if AQ err==ENOMEM
- * @opc: capabilities type to discover - pass in the command opcode
- * @cd: pointer to command details structure or NULL
- *
- * Get the function(0x000a)/device(0x000b) capabilities description from
- * the firmware.
+ * ice_discover_dev_caps - Read and extract device capabilities
+ * @hw: pointer to the hardware structure
+ * @dev_caps: pointer to device capabilities structure
  *
- * NOTE: this function has the side effect of updating the hw->dev_caps or
- * hw->func_caps by way of calling ice_parse_caps.
+ * Read the device capabilities and extract them into the dev_caps structure
+ * for later use.
  */
 static enum ice_status
-ice_aq_discover_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
-		     enum ice_adminq_opc opc, struct ice_sq_cd *cd)
+ice_discover_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_caps)
 {
-	u32 local_cap_count = 0;
 	enum ice_status status;
+	u32 cap_count = 0;
+	void *cbuf;
 
-	status = ice_aq_list_caps(hw, buf, buf_size, &local_cap_count,
-				  opc, cd);
+	cbuf = kzalloc(ICE_AQ_MAX_BUF_LEN, GFP_KERNEL);
+	if (!cbuf)
+		return ICE_ERR_NO_MEMORY;
+
+	/* Although the driver doesn't know the number of capabilities the
+	 * device will return, we can simply send a 4KB buffer, the maximum
+	 * possible size that firmware can return.
+	 */
+	cap_count = ICE_AQ_MAX_BUF_LEN / sizeof(struct ice_aqc_list_caps_elem);
+
+	status = ice_aq_list_caps(hw, cbuf, ICE_AQ_MAX_BUF_LEN, &cap_count,
+				  ice_aqc_opc_list_dev_caps, NULL);
 	if (!status)
-		ice_parse_caps(hw, buf, local_cap_count, opc);
-	else if (hw->adminq.sq_last_status == ICE_AQ_RC_ENOMEM)
-		*cap_count = local_cap_count;
+		ice_parse_dev_caps(hw, dev_caps, cbuf, cap_count);
+	kfree(cbuf);
 
 	return status;
 }
 
 /**
- * ice_discover_caps - get info about the HW
+ * ice_discover_func_caps - Read and extract function capabilities
  * @hw: pointer to the hardware structure
- * @opc: capabilities type to discover - pass in the command opcode
+ * @func_caps: pointer to function capabilities structure
+ *
+ * Read the function capabilities and extract them into the func_caps structure
+ * for later use.
  */
 static enum ice_status
-ice_discover_caps(struct ice_hw *hw, enum ice_adminq_opc opc)
+ice_discover_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_caps)
 {
 	enum ice_status status;
-	u32 cap_count;
+	u32 cap_count = 0;
 	void *cbuf;
 
 	cbuf = kzalloc(ICE_AQ_MAX_BUF_LEN, GFP_KERNEL);
@@ -2121,8 +2103,10 @@ ice_discover_caps(struct ice_hw *hw, enum ice_adminq_opc opc)
 	 */
 	cap_count = ICE_AQ_MAX_BUF_LEN / sizeof(struct ice_aqc_list_caps_elem);
 
-	status = ice_aq_discover_caps(hw, cbuf, ICE_AQ_MAX_BUF_LEN, &cap_count,
-				      opc, NULL);
+	status = ice_aq_list_caps(hw, cbuf, ICE_AQ_MAX_BUF_LEN, &cap_count,
+				  ice_aqc_opc_list_func_caps, NULL);
+	if (!status)
+		ice_parse_func_caps(hw, func_caps, cbuf, cap_count);
 	kfree(cbuf);
 
 	return status;
@@ -2200,11 +2184,11 @@ enum ice_status ice_get_caps(struct ice_hw *hw)
 {
 	enum ice_status status;
 
-	status = ice_discover_caps(hw, ice_aqc_opc_list_dev_caps);
-	if (!status)
-		status = ice_discover_caps(hw, ice_aqc_opc_list_func_caps);
+	status = ice_discover_dev_caps(hw, &hw->dev_caps);
+	if (status)
+		return status;
 
-	return status;
+	return ice_discover_func_caps(hw, &hw->func_caps);
 }
 
 /**
-- 
2.26.2

