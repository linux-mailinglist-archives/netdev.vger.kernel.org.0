Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F893A4656
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhFKQTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:19:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:16328 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231173AbhFKQTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:19:38 -0400
IronPort-SDR: iOSOEqYTLQfxPgLIN8laAB+9DhfIQy0VpRl+QDlAtSKRxslYRlUNt5jzfy9MSW3iEGsxtshqAQ
 oPO5RO31FT/g==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="269404869"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="269404869"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 09:17:26 -0700
IronPort-SDR: RHQUc//raAdU6SzoWM11dlqlvpPE0Gku1mesuepwbrnm7U9wkL/emLdafQysXbocIYPJxf6pOM
 Qt0+m0Utvp3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="620423478"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2021 09:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 2/8] ice: process 1588 PTP capabilities during initialization
Date:   Fri, 11 Jun 2021 09:19:54 -0700
Message-Id: <20210611162000.2438023-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The device firmware reports PTP clock capabilities to each PF during
initialization. This includes various information for both the overall
device and the individual function, including

For functions:
* whether this function has timesync enabled
* whether this function owns one of the 2 possible clock timers, and
  which one
* which timer the function is associated with
* the clock frequency, if the device supports multiple clock frequencies
* The GPIO pin association for the timer owned by this PF, if any

For the device:
* Which PF owns timer 0, if any
* Which PF owns timer 1, if any
* whether timer 0 is enabled
* whether timer 1 is enabled

Extract the bits from the capabilities information reported by firmware
and store them in the device and function capability structures.o

This information will be used in a future change to have the function
driver enable PTP hardware clock support.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c   | 99 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_type.h     | 51 ++++++++++
 3 files changed, 151 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 272d1600268e..f10c1b8555a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -108,6 +108,7 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_TXQS				0x0042
 #define ICE_AQC_CAPS_MSIX				0x0043
 #define ICE_AQC_CAPS_FD					0x0045
+#define ICE_AQC_CAPS_1588				0x0046
 #define ICE_AQC_CAPS_MAX_MTU				0x0047
 #define ICE_AQC_CAPS_NVM_VER				0x0048
 #define ICE_AQC_CAPS_PENDING_NVM_VER			0x0049
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 298e654583bd..e9eb48bd4b1e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2092,6 +2092,48 @@ ice_parse_vsi_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p,
 		  func_p->guar_num_vsi);
 }
 
+/**
+ * ice_parse_1588_func_caps - Parse ICE_AQC_CAPS_1588 function caps
+ * @hw: pointer to the HW struct
+ * @func_p: pointer to function capabilities structure
+ * @cap: pointer to the capability element to parse
+ *
+ * Extract function capabilities for ICE_AQC_CAPS_1588.
+ */
+static void
+ice_parse_1588_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p,
+			 struct ice_aqc_list_caps_elem *cap)
+{
+	struct ice_ts_func_info *info = &func_p->ts_func_info;
+	u32 number = le32_to_cpu(cap->number);
+
+	info->ena = ((number & ICE_TS_FUNC_ENA_M) != 0);
+	func_p->common_cap.ieee_1588 = info->ena;
+
+	info->src_tmr_owned = ((number & ICE_TS_SRC_TMR_OWND_M) != 0);
+	info->tmr_ena = ((number & ICE_TS_TMR_ENA_M) != 0);
+	info->tmr_index_owned = ((number & ICE_TS_TMR_IDX_OWND_M) != 0);
+	info->tmr_index_assoc = ((number & ICE_TS_TMR_IDX_ASSOC_M) != 0);
+
+	info->clk_freq = (number & ICE_TS_CLK_FREQ_M) >> ICE_TS_CLK_FREQ_S;
+	info->clk_src = ((number & ICE_TS_CLK_SRC_M) != 0);
+
+	ice_debug(hw, ICE_DBG_INIT, "func caps: ieee_1588 = %u\n",
+		  func_p->common_cap.ieee_1588);
+	ice_debug(hw, ICE_DBG_INIT, "func caps: src_tmr_owned = %u\n",
+		  info->src_tmr_owned);
+	ice_debug(hw, ICE_DBG_INIT, "func caps: tmr_ena = %u\n",
+		  info->tmr_ena);
+	ice_debug(hw, ICE_DBG_INIT, "func caps: tmr_index_owned = %u\n",
+		  info->tmr_index_owned);
+	ice_debug(hw, ICE_DBG_INIT, "func caps: tmr_index_assoc = %u\n",
+		  info->tmr_index_assoc);
+	ice_debug(hw, ICE_DBG_INIT, "func caps: clk_freq = %u\n",
+		  info->clk_freq);
+	ice_debug(hw, ICE_DBG_INIT, "func caps: clk_src = %u\n",
+		  info->clk_src);
+}
+
 /**
  * ice_parse_fdir_func_caps - Parse ICE_AQC_CAPS_FD function caps
  * @hw: pointer to the HW struct
@@ -2158,6 +2200,9 @@ ice_parse_func_caps(struct ice_hw *hw, struct ice_hw_func_caps *func_p,
 		case ICE_AQC_CAPS_VSI:
 			ice_parse_vsi_func_caps(hw, func_p, &cap_resp[i]);
 			break;
+		case ICE_AQC_CAPS_1588:
+			ice_parse_1588_func_caps(hw, func_p, &cap_resp[i]);
+			break;
 		case ICE_AQC_CAPS_FD:
 			ice_parse_fdir_func_caps(hw, func_p);
 			break;
@@ -2230,6 +2275,57 @@ ice_parse_vsi_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
 		  dev_p->num_vsi_allocd_to_host);
 }
 
+/**
+ * ice_parse_1588_dev_caps - Parse ICE_AQC_CAPS_1588 device caps
+ * @hw: pointer to the HW struct
+ * @dev_p: pointer to device capabilities structure
+ * @cap: capability element to parse
+ *
+ * Parse ICE_AQC_CAPS_1588 for device capabilities.
+ */
+static void
+ice_parse_1588_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
+			struct ice_aqc_list_caps_elem *cap)
+{
+	struct ice_ts_dev_info *info = &dev_p->ts_dev_info;
+	u32 logical_id = le32_to_cpu(cap->logical_id);
+	u32 phys_id = le32_to_cpu(cap->phys_id);
+	u32 number = le32_to_cpu(cap->number);
+
+	info->ena = ((number & ICE_TS_DEV_ENA_M) != 0);
+	dev_p->common_cap.ieee_1588 = info->ena;
+
+	info->tmr0_owner = number & ICE_TS_TMR0_OWNR_M;
+	info->tmr0_owned = ((number & ICE_TS_TMR0_OWND_M) != 0);
+	info->tmr0_ena = ((number & ICE_TS_TMR0_ENA_M) != 0);
+
+	info->tmr1_owner = (number & ICE_TS_TMR1_OWNR_M) >> ICE_TS_TMR1_OWNR_S;
+	info->tmr1_owned = ((number & ICE_TS_TMR1_OWND_M) != 0);
+	info->tmr1_ena = ((number & ICE_TS_TMR1_ENA_M) != 0);
+
+	info->ena_ports = logical_id;
+	info->tmr_own_map = phys_id;
+
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: ieee_1588 = %u\n",
+		  dev_p->common_cap.ieee_1588);
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: tmr0_owner = %u\n",
+		  info->tmr0_owner);
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: tmr0_owned = %u\n",
+		  info->tmr0_owned);
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: tmr0_ena = %u\n",
+		  info->tmr0_ena);
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: tmr1_owner = %u\n",
+		  info->tmr1_owner);
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: tmr1_owned = %u\n",
+		  info->tmr1_owned);
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: tmr1_ena = %u\n",
+		  info->tmr1_ena);
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: ieee_1588 ena_ports = %u\n",
+		  info->ena_ports);
+	ice_debug(hw, ICE_DBG_INIT, "dev caps: tmr_own_map = %u\n",
+		  info->tmr_own_map);
+}
+
 /**
  * ice_parse_fdir_dev_caps - Parse ICE_AQC_CAPS_FD device caps
  * @hw: pointer to the HW struct
@@ -2291,6 +2387,9 @@ ice_parse_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
 		case ICE_AQC_CAPS_VSI:
 			ice_parse_vsi_dev_caps(hw, dev_p, &cap_resp[i]);
 			break;
+		case ICE_AQC_CAPS_1588:
+			ice_parse_1588_dev_caps(hw, dev_p, &cap_resp[i]);
+			break;
 		case  ICE_AQC_CAPS_FD:
 			ice_parse_fdir_dev_caps(hw, dev_p, &cap_resp[i]);
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 4a40e2b3732a..0e5d8d52728b 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -265,6 +265,7 @@ struct ice_hw_common_caps {
 	u8 rss_table_entry_width;	/* RSS Entry width in bits */
 
 	u8 dcb;
+	u8 ieee_1588;
 	u8 rdma;
 
 	bool nvm_update_pending_nvm;
@@ -277,6 +278,54 @@ struct ice_hw_common_caps {
 #define ICE_NVM_MGMT_UNIFIED_UPD_SUPPORT	BIT(3)
 };
 
+/* IEEE 1588 TIME_SYNC specific info */
+/* Function specific definitions */
+#define ICE_TS_FUNC_ENA_M		BIT(0)
+#define ICE_TS_SRC_TMR_OWND_M		BIT(1)
+#define ICE_TS_TMR_ENA_M		BIT(2)
+#define ICE_TS_TMR_IDX_OWND_S		4
+#define ICE_TS_TMR_IDX_OWND_M		BIT(4)
+#define ICE_TS_CLK_FREQ_S		16
+#define ICE_TS_CLK_FREQ_M		ICE_M(0x7, ICE_TS_CLK_FREQ_S)
+#define ICE_TS_CLK_SRC_S		20
+#define ICE_TS_CLK_SRC_M		BIT(20)
+#define ICE_TS_TMR_IDX_ASSOC_S		24
+#define ICE_TS_TMR_IDX_ASSOC_M		BIT(24)
+
+struct ice_ts_func_info {
+	/* Function specific info */
+	u32 clk_freq;
+	u8 clk_src;
+	u8 tmr_index_assoc;
+	u8 ena;
+	u8 tmr_index_owned;
+	u8 src_tmr_owned;
+	u8 tmr_ena;
+};
+
+/* Device specific definitions */
+#define ICE_TS_TMR0_OWNR_M		0x7
+#define ICE_TS_TMR0_OWND_M		BIT(3)
+#define ICE_TS_TMR1_OWNR_S		4
+#define ICE_TS_TMR1_OWNR_M		ICE_M(0x7, ICE_TS_TMR1_OWNR_S)
+#define ICE_TS_TMR1_OWND_M		BIT(7)
+#define ICE_TS_DEV_ENA_M		BIT(24)
+#define ICE_TS_TMR0_ENA_M		BIT(25)
+#define ICE_TS_TMR1_ENA_M		BIT(26)
+
+struct ice_ts_dev_info {
+	/* Device specific info */
+	u32 ena_ports;
+	u32 tmr_own_map;
+	u32 tmr0_owner;
+	u32 tmr1_owner;
+	u8 tmr0_owned;
+	u8 tmr1_owned;
+	u8 ena;
+	u8 tmr0_ena;
+	u8 tmr1_ena;
+};
+
 /* Function specific capabilities */
 struct ice_hw_func_caps {
 	struct ice_hw_common_caps common_cap;
@@ -285,6 +334,7 @@ struct ice_hw_func_caps {
 	u32 guar_num_vsi;
 	u32 fd_fltr_guar;		/* Number of filters guaranteed */
 	u32 fd_fltr_best_effort;	/* Number of best effort filters */
+	struct ice_ts_func_info ts_func_info;
 };
 
 /* Device wide capabilities */
@@ -293,6 +343,7 @@ struct ice_hw_dev_caps {
 	u32 num_vfs_exposed;		/* Total number of VFs exposed */
 	u32 num_vsi_allocd_to_host;	/* Excluding EMP VSI */
 	u32 num_flow_director_fltr;	/* Number of FD filters available */
+	struct ice_ts_dev_info ts_dev_info;
 	u32 num_funcs;
 };
 
-- 
2.26.2

