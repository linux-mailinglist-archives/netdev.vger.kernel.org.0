Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3C722BA55
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgGWXrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:32 -0400
Received: from mga05.intel.com ([192.55.52.43]:43317 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgGWXr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:26 -0400
IronPort-SDR: BEmAiDc1Z/i+1Gt2R1fy5RMgdKocpYTvSjvA9W+TsjEc+QqRCoC8fVfbb7keqjNYqNcSEKFhkW
 wruB9inuurkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235515428"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235515428"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:25 -0700
IronPort-SDR: xME4FerNon5cLfhJyHlslUiIV2qn3g6jL+5mvxvVcWpll0XmIgva3dqXESMP+7h6clGidhGniV
 WYzUs8bILD4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742284"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 02/15] ice: split ice_parse_caps into separate functions
Date:   Thu, 23 Jul 2020 16:47:07 -0700
Message-Id: <20200723234720.1547308-3-anthony.l.nguyen@intel.com>
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

The ice_parse_caps function is used to convert the capability block data
coming from firmware into a structured format used by other parts of the
code.

The current implementation directly updates the hw->func_caps and
hw->dev_caps structures. It is directly called from within
ice_aq_discover_caps. This causes the discover_caps function to have the
side effect of modifying the HW capability structures, which is not
intuitive.

Split this function into ice_parse_dev_caps and ice_parse_func_caps.
These functions will take a pointer to the dev_caps and func_caps
respectively. Also create an ice_parse_common_caps for sharing the
capability logic that is common to device and function.

Doing so enables a future refactor to allow reading and parsing
capabilities into a local caps structure instead of modifying the
members of the HW structure directly.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 548 ++++++++++++++------
 1 file changed, 378 insertions(+), 170 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 37ea042ece13..c32b9100eec3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1617,204 +1617,412 @@ static u32 ice_get_num_per_func(struct ice_hw *hw, u32 max)
 }
 
 /**
- * ice_parse_caps - parse function/device capabilities
+ * ice_parse_common_caps - parse common device/function capabilities
  * @hw: pointer to the HW struct
- * @buf: pointer to a buffer containing function/device capability records
- * @cap_count: number of capability records in the list
- * @opc: type of capabilities list to parse
+ * @caps: pointer to common capabilities structure
+ * @elem: the capability element to parse
+ * @prefix: message prefix for tracing capabilities
  *
- * Helper function to parse function(0x000a)/device(0x000b) capabilities list.
+ * Given a capability element, extract relevant details into the common
+ * capability structure.
+ *
+ * Returns: true if the capability matches one of the common capability ids,
+ * false otherwise.
+ */
+static bool
+ice_parse_common_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps,
+		      struct ice_aqc_list_caps_elem *elem, const char *prefix)
+{
+	u32 logical_id = le32_to_cpu(elem->logical_id);
+	u32 phys_id = le32_to_cpu(elem->phys_id);
+	u32 number = le32_to_cpu(elem->number);
+	u16 cap = le16_to_cpu(elem->cap);
+	bool found = true;
+
+	switch (cap) {
+	case ICE_AQC_CAPS_VALID_FUNCTIONS:
+		caps->valid_functions = number;
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: valid_functions (bitmap) = %d\n", prefix,
+			  caps->valid_functions);
+		break;
+	case ICE_AQC_CAPS_SRIOV:
+		caps->sr_iov_1_1 = (number == 1);
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: sr_iov_1_1 = %d\n", prefix,
+			  caps->sr_iov_1_1);
+		break;
+	case ICE_AQC_CAPS_DCB:
+		caps->dcb = (number == 1);
+		caps->active_tc_bitmap = logical_id;
+		caps->maxtc = phys_id;
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: dcb = %d\n", prefix, caps->dcb);
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: active_tc_bitmap = %d\n", prefix,
+			  caps->active_tc_bitmap);
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: maxtc = %d\n", prefix, caps->maxtc);
+		break;
+	case ICE_AQC_CAPS_RSS:
+		caps->rss_table_size = number;
+		caps->rss_table_entry_width = logical_id;
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: rss_table_size = %d\n", prefix,
+			  caps->rss_table_size);
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: rss_table_entry_width = %d\n", prefix,
+			  caps->rss_table_entry_width);
+		break;
+	case ICE_AQC_CAPS_RXQS:
+		caps->num_rxq = number;
+		caps->rxq_first_id = phys_id;
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: num_rxq = %d\n", prefix,
+			  caps->num_rxq);
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: rxq_first_id = %d\n", prefix,
+			  caps->rxq_first_id);
+		break;
+	case ICE_AQC_CAPS_TXQS:
+		caps->num_txq = number;
+		caps->txq_first_id = phys_id;
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: num_txq = %d\n", prefix,
+			  caps->num_txq);
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: txq_first_id = %d\n", prefix,
+			  caps->txq_first_id);
+		break;
+	case ICE_AQC_CAPS_MSIX:
+		caps->num_msix_vectors = number;
+		caps->msix_vector_first_id = phys_id;
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: num_msix_vectors = %d\n", prefix,
+			  caps->num_msix_vectors);
+		ice_debug(hw, ICE_DBG_INIT,
+			  "%s: msix_vector_first_id = %d\n", prefix,
+			  caps->msix_vector_first_id);
+		break;
+	case ICE_AQC_CAPS_MAX_MTU:
+		caps->max_mtu = number;
+		ice_debug(hw, ICE_DBG_INIT, "%s: max_mtu = %d\n",
+			  prefix, caps->max_mtu);
+		break;
+	default:
+		/* Not one of the recognized common capabilities */
+		found = false;
+	}
+
+	return found;
+}
+
+/**
+ * ice_recalc_port_limited_caps - Recalculate port limited capabilities
+ * @hw: pointer to the HW structure
+ * @caps: pointer to capabilities structure to fix
+ *
+ * Re-calculate the capabilities that are dependent on the number of physical
+ * ports; i.e. some features are not supported or function differently on
+ * devices with more than 4 ports.
  */
 static void
-ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
-	       enum ice_adminq_opc opc)
+ice_recalc_port_limited_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps)
+{
+	/* This assumes device capabilities are always scanned before function
+	 * capabilities during the initialization flow.
+	 */
+	if (hw->dev_caps.num_funcs > 4) {
+		/* Max 4 TCs per port */
+		caps->maxtc = 4;
+		ice_debug(hw, ICE_DBG_INIT,
+			  "reducing maxtc to %d (based on #ports)\n",
+			  caps->maxtc);
+	}
+}
+
+/**
+ * ice_parse_vf_func_caps - Parse ICE_AQC_CAPS_VF function caps
+ * @hw: pointer to the HW struct
+ * @func_p: pointer to function capabilities structure
+ * @cap: pointer to the capability element to parse
+ *
+ * Extract function capabilities for ICE_AQC_CAPS_VF.
+ */
+static void
+ice_parse_vf_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p,
+		       struct ice_aqc_list_caps_elem *cap)
+{
+	u32 logical_id = le32_to_cpu(cap->logical_id);
+	u32 number = le32_to_cpu(cap->number);
+
+	func_p->num_allocd_vfs = number;
+	func_p->vf_base_id = logical_id;
+	ice_debug(hw, ICE_DBG_INIT, "func caps: num_allocd_vfs = %d\n",
+		  func_p->num_allocd_vfs);
+	ice_debug(hw, ICE_DBG_INIT, "func caps: vf_base_id = %d\n",
+		  func_p->vf_base_id);
+}
+
+/**
+ * ice_parse_vsi_func_caps - Parse ICE_AQC_CAPS_VSI function caps
+ * @hw: pointer to the HW struct
+ * @func_p: pointer to function capabilities structure
+ * @cap: pointer to the capability element to parse
+ *
+ * Extract function capabilities for ICE_AQC_CAPS_VSI.
+ */
+static void
+ice_parse_vsi_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p,
+			struct ice_aqc_list_caps_elem *cap)
+{
+	func_p->guar_num_vsi = ice_get_num_per_func(hw, ICE_MAX_VSI);
+	ice_debug(hw, ICE_DBG_INIT, "func caps: guar_num_vsi (fw) = %d\n",
+		  le32_to_cpu(cap->number));
+	ice_debug(hw, ICE_DBG_INIT, "func caps: guar_num_vsi = %d\n",
+		  func_p->guar_num_vsi);
+}
+
+/**
+ * ice_parse_fdir_func_caps - Parse ICE_AQC_CAPS_FD function caps
+ * @hw: pointer to the HW struct
+ * @func_p: pointer to function capabilities structure
+ *
+ * Extract function capabilities for ICE_AQC_CAPS_FD.
+ */
+static void
+ice_parse_fdir_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p)
+{
+	u32 reg_val, val;
+
+	reg_val = rd32(hw, GLQF_FD_SIZE);
+	val = (reg_val & GLQF_FD_SIZE_FD_GSIZE_M) >>
+		GLQF_FD_SIZE_FD_GSIZE_S;
+	func_p->fd_fltr_guar =
+		ice_get_num_per_func(hw, val);
+	val = (reg_val & GLQF_FD_SIZE_FD_BSIZE_M) >>
+		GLQF_FD_SIZE_FD_BSIZE_S;
+	func_p->fd_fltr_best_effort = val;
+
+	ice_debug(hw, ICE_DBG_INIT,
+		  "func caps: fd_fltr_guar = %d\n",
+		  func_p->fd_fltr_guar);
+	ice_debug(hw, ICE_DBG_INIT,
+		  "func caps: fd_fltr_best_effort = %d\n",
+		  func_p->fd_fltr_best_effort);
+}
+
+/**
+ * ice_parse_func_caps - Parse function capabilities
+ * @hw: pointer to the HW struct
+ * @func_p: pointer to function capabilities structure
+ * @buf: buffer containing the function capability records
+ * @cap_count: the number of capabilities
+ *
+ * Helper function to parse function (0x000A) capabilities list. For
+ * capabilities shared between device and function, this relies on
+ * ice_parse_common_caps.
+ *
+ * Loop through the list of provided capabilities and extract the relevant
+ * data into the function capabilities structured.
+ */
+static void
+ice_parse_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p,
+		    void *buf, u32 cap_count)
 {
 	struct ice_aqc_list_caps_elem *cap_resp;
-	struct ice_hw_func_caps *func_p = NULL;
-	struct ice_hw_dev_caps *dev_p = NULL;
-	struct ice_hw_common_caps *caps;
-	char const *prefix;
 	u32 i;
 
-	if (!buf)
-		return;
-
 	cap_resp = (struct ice_aqc_list_caps_elem *)buf;
 
-	if (opc == ice_aqc_opc_list_dev_caps) {
-		dev_p = &hw->dev_caps;
-		caps = &dev_p->common_cap;
-		prefix = "dev cap";
-	} else if (opc == ice_aqc_opc_list_func_caps) {
-		func_p = &hw->func_caps;
-		caps = &func_p->common_cap;
-		prefix = "func cap";
-	} else {
-		ice_debug(hw, ICE_DBG_INIT, "wrong opcode\n");
-		return;
-	}
+	memset(func_p, 0, sizeof(*func_p));
 
-	for (i = 0; caps && i < cap_count; i++, cap_resp++) {
-		u32 logical_id = le32_to_cpu(cap_resp->logical_id);
-		u32 phys_id = le32_to_cpu(cap_resp->phys_id);
-		u32 number = le32_to_cpu(cap_resp->number);
-		u16 cap = le16_to_cpu(cap_resp->cap);
+	for (i = 0; i < cap_count; i++) {
+		u16 cap = le16_to_cpu(cap_resp[i].cap);
+		bool found;
 
-		switch (cap) {
-		case ICE_AQC_CAPS_VALID_FUNCTIONS:
-			caps->valid_functions = number;
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: valid_functions (bitmap) = %d\n", prefix,
-				  caps->valid_functions);
+		found = ice_parse_common_caps(hw, &func_p->common_cap,
+					      &cap_resp[i], "func caps");
 
-			/* store func count for resource management purposes */
-			if (dev_p)
-				dev_p->num_funcs = hweight32(number);
-			break;
-		case ICE_AQC_CAPS_SRIOV:
-			caps->sr_iov_1_1 = (number == 1);
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: sr_iov_1_1 = %d\n", prefix,
-				  caps->sr_iov_1_1);
-			break;
+		switch (cap) {
 		case ICE_AQC_CAPS_VF:
-			if (dev_p) {
-				dev_p->num_vfs_exposed = number;
-				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: num_vfs_exposed = %d\n", prefix,
-					  dev_p->num_vfs_exposed);
-			} else if (func_p) {
-				func_p->num_allocd_vfs = number;
-				func_p->vf_base_id = logical_id;
-				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: num_allocd_vfs = %d\n", prefix,
-					  func_p->num_allocd_vfs);
-				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: vf_base_id = %d\n", prefix,
-					  func_p->vf_base_id);
-			}
+			ice_parse_vf_func_caps(hw, func_p, &cap_resp[i]);
 			break;
 		case ICE_AQC_CAPS_VSI:
-			if (dev_p) {
-				dev_p->num_vsi_allocd_to_host = number;
-				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: num_vsi_allocd_to_host = %d\n",
-					  prefix,
-					  dev_p->num_vsi_allocd_to_host);
-			} else if (func_p) {
-				func_p->guar_num_vsi =
-					ice_get_num_per_func(hw, ICE_MAX_VSI);
-				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: guar_num_vsi (fw) = %d\n",
-					  prefix, number);
-				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: guar_num_vsi = %d\n",
-					  prefix, func_p->guar_num_vsi);
-			}
+			ice_parse_vsi_func_caps(hw, func_p, &cap_resp[i]);
 			break;
-		case ICE_AQC_CAPS_DCB:
-			caps->dcb = (number == 1);
-			caps->active_tc_bitmap = logical_id;
-			caps->maxtc = phys_id;
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: dcb = %d\n", prefix, caps->dcb);
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: active_tc_bitmap = %d\n", prefix,
-				  caps->active_tc_bitmap);
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: maxtc = %d\n", prefix, caps->maxtc);
-			break;
-		case ICE_AQC_CAPS_RSS:
-			caps->rss_table_size = number;
-			caps->rss_table_entry_width = logical_id;
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: rss_table_size = %d\n", prefix,
-				  caps->rss_table_size);
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: rss_table_entry_width = %d\n", prefix,
-				  caps->rss_table_entry_width);
+		case ICE_AQC_CAPS_FD:
+			ice_parse_fdir_func_caps(hw, func_p);
 			break;
-		case ICE_AQC_CAPS_RXQS:
-			caps->num_rxq = number;
-			caps->rxq_first_id = phys_id;
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: num_rxq = %d\n", prefix,
-				  caps->num_rxq);
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: rxq_first_id = %d\n", prefix,
-				  caps->rxq_first_id);
+		default:
+			/* Don't list common capabilities as unknown */
+			if (!found)
+				ice_debug(hw, ICE_DBG_INIT,
+					  "func caps: unknown capability[%d]: 0x%x\n",
+					  i, cap);
 			break;
-		case ICE_AQC_CAPS_TXQS:
-			caps->num_txq = number;
-			caps->txq_first_id = phys_id;
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: num_txq = %d\n", prefix,
-				  caps->num_txq);
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: txq_first_id = %d\n", prefix,
-				  caps->txq_first_id);
+		}
+	}
+
+	ice_recalc_port_limited_caps(hw, &func_p->common_cap);
+}
+
+/**
+ * ice_parse_valid_functions_cap - Parse ICE_AQC_CAPS_VALID_FUNCTIONS caps
+ * @hw: pointer to the HW struct
+ * @dev_p: pointer to device capabilities structure
+ * @cap: capability element to parse
+ *
+ * Parse ICE_AQC_CAPS_VALID_FUNCTIONS for device capabilities.
+ */
+static void
+ice_parse_valid_functions_cap(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
+			      struct ice_aqc_list_caps_elem *cap)
+{
+	u32 number = le32_to_cpu(cap->number);
+
+	dev_p->num_funcs = hweight32(number);
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: num_funcs = %d\n",
+		  dev_p->num_funcs);
+}
+
+/**
+ * ice_parse_vf_dev_caps - Parse ICE_AQC_CAPS_VF device caps
+ * @hw: pointer to the HW struct
+ * @dev_p: pointer to device capabilities structure
+ * @cap: capability element to parse
+ *
+ * Parse ICE_AQC_CAPS_VF for device capabilities.
+ */
+static void
+ice_parse_vf_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
+		      struct ice_aqc_list_caps_elem *cap)
+{
+	u32 number = le32_to_cpu(cap->number);
+
+	dev_p->num_vfs_exposed = number;
+	ice_debug(hw, ICE_DBG_INIT, "dev_caps: num_vfs_exposed = %d\n",
+		  dev_p->num_vfs_exposed);
+}
+
+/**
+ * ice_parse_vsi_dev_caps - Parse ICE_AQC_CAPS_VSI device caps
+ * @hw: pointer to the HW struct
+ * @dev_p: pointer to device capabilities structure
+ * @cap: capability element to parse
+ *
+ * Parse ICE_AQC_CAPS_VSI for device capabilities.
+ */
+static void
+ice_parse_vsi_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
+		       struct ice_aqc_list_caps_elem *cap)
+{
+	u32 number = le32_to_cpu(cap->number);
+
+	dev_p->num_vsi_allocd_to_host = number;
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: num_vsi_allocd_to_host = %d\n",
+		  dev_p->num_vsi_allocd_to_host);
+}
+
+/**
+ * ice_parse_fdir_dev_caps - Parse ICE_AQC_CAPS_FD device caps
+ * @hw: pointer to the HW struct
+ * @dev_p: pointer to device capabilities structure
+ * @cap: capability element to parse
+ *
+ * Parse ICE_AQC_CAPS_FD for device capabilities.
+ */
+static void
+ice_parse_fdir_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
+			struct ice_aqc_list_caps_elem *cap)
+{
+	u32 number = le32_to_cpu(cap->number);
+
+	dev_p->num_flow_director_fltr = number;
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: num_flow_director_fltr = %d\n",
+		  dev_p->num_flow_director_fltr);
+}
+
+/**
+ * ice_parse_dev_caps - Parse device capabilities
+ * @hw: pointer to the HW struct
+ * @dev_p: pointer to device capabilities structure
+ * @buf: buffer containing the device capability records
+ * @cap_count: the number of capabilities
+ *
+ * Helper device to parse device (0x000B) capabilities list. For
+ * capabilities shared between device and device, this relies on
+ * ice_parse_common_caps.
+ *
+ * Loop through the list of provided capabilities and extract the relevant
+ * data into the device capabilities structured.
+ */
+static void
+ice_parse_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
+		   void *buf, u32 cap_count)
+{
+	struct ice_aqc_list_caps_elem *cap_resp;
+	u32 i;
+
+	cap_resp = (struct ice_aqc_list_caps_elem *)buf;
+
+	memset(dev_p, 0, sizeof(*dev_p));
+
+	for (i = 0; i < cap_count; i++) {
+		u16 cap = le16_to_cpu(cap_resp[i].cap);
+		bool found;
+
+		found = ice_parse_common_caps(hw, &dev_p->common_cap,
+					      &cap_resp[i], "dev caps");
+
+		switch (cap) {
+		case ICE_AQC_CAPS_VALID_FUNCTIONS:
+			ice_parse_valid_functions_cap(hw, dev_p, &cap_resp[i]);
 			break;
-		case ICE_AQC_CAPS_MSIX:
-			caps->num_msix_vectors = number;
-			caps->msix_vector_first_id = phys_id;
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: num_msix_vectors = %d\n", prefix,
-				  caps->num_msix_vectors);
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: msix_vector_first_id = %d\n", prefix,
-				  caps->msix_vector_first_id);
+		case ICE_AQC_CAPS_VF:
+			ice_parse_vf_dev_caps(hw, dev_p, &cap_resp[i]);
 			break;
-		case ICE_AQC_CAPS_FD:
-			if (dev_p) {
-				dev_p->num_flow_director_fltr = number;
-				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: num_flow_director_fltr = %d\n",
-					  prefix,
-					  dev_p->num_flow_director_fltr);
-			}
-			if (func_p) {
-				u32 reg_val, val;
-
-				reg_val = rd32(hw, GLQF_FD_SIZE);
-				val = (reg_val & GLQF_FD_SIZE_FD_GSIZE_M) >>
-				      GLQF_FD_SIZE_FD_GSIZE_S;
-				func_p->fd_fltr_guar =
-				      ice_get_num_per_func(hw, val);
-				val = (reg_val & GLQF_FD_SIZE_FD_BSIZE_M) >>
-				      GLQF_FD_SIZE_FD_BSIZE_S;
-				func_p->fd_fltr_best_effort = val;
-				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: fd_fltr_guar = %d\n",
-					  prefix, func_p->fd_fltr_guar);
-				ice_debug(hw, ICE_DBG_INIT,
-					  "%s: fd_fltr_best_effort = %d\n",
-					  prefix, func_p->fd_fltr_best_effort);
-			}
+		case ICE_AQC_CAPS_VSI:
+			ice_parse_vsi_dev_caps(hw, dev_p, &cap_resp[i]);
 			break;
-		case ICE_AQC_CAPS_MAX_MTU:
-			caps->max_mtu = number;
-			ice_debug(hw, ICE_DBG_INIT, "%s: max_mtu = %d\n",
-				  prefix, caps->max_mtu);
+		case  ICE_AQC_CAPS_FD:
+			ice_parse_fdir_dev_caps(hw, dev_p, &cap_resp[i]);
 			break;
 		default:
-			ice_debug(hw, ICE_DBG_INIT,
-				  "%s: unknown capability[%d]: 0x%x\n", prefix,
-				  i, cap);
+			/* Don't list common capabilities as unknown */
+			if (!found)
+				ice_debug(hw, ICE_DBG_INIT,
+					  "dev caps: unknown capability[%d]: 0x%x\n",
+					  i, cap);
 			break;
 		}
 	}
 
-	/* Re-calculate capabilities that are dependent on the number of
-	 * physical ports; i.e. some features are not supported or function
-	 * differently on devices with more than 4 ports.
-	 */
-	if (hw->dev_caps.num_funcs > 4) {
-		/* Max 4 TCs per port */
-		caps->maxtc = 4;
-		ice_debug(hw, ICE_DBG_INIT,
-			  "%s: maxtc = %d (based on #ports)\n", prefix,
-			  caps->maxtc);
-	}
+	ice_recalc_port_limited_caps(hw, &dev_p->common_cap);
+}
+
+/**
+ * ice_parse_caps - parse function/device capabilities
+ * @hw: pointer to the HW struct
+ * @buf: pointer to a buffer containing function/device capability records
+ * @cap_count: number of capability records in the list
+ * @opc: type of capabilities list to parse
+ *
+ * Helper function to parse function(0x000a)/device(0x000b) capabilities list.
+ */
+static void
+ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
+	       enum ice_adminq_opc opc)
+{
+	if (!buf)
+		return;
+
+	if (opc == ice_aqc_opc_list_dev_caps)
+		ice_parse_dev_caps(hw, &hw->dev_caps, buf, cap_count);
+	else if (opc == ice_aqc_opc_list_func_caps)
+		ice_parse_func_caps(hw, &hw->func_caps, buf, cap_count);
+	else
+		ice_debug(hw, ICE_DBG_INIT, "wrong opcode\n");
 }
 
 /**
-- 
2.26.2

