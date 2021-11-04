Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9D644503D
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 09:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhKDIaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 04:30:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:57728 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhKDIaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 04:30:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="218857395"
X-IronPort-AV: E=Sophos;i="5.87,208,1631602800"; 
   d="scan'208";a="218857395"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 01:27:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,208,1631602800"; 
   d="scan'208";a="501438382"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by orsmga008.jf.intel.com with ESMTP; 04 Nov 2021 01:27:32 -0700
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com
Subject: [PATCH net-next 1/6] ice: add support detecting features based on netlist
Date:   Thu,  4 Nov 2021 09:12:26 +0100
Message-Id: <20211104081231.1982753-2-maciej.machnikowski@intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20211104081231.1982753-1-maciej.machnikowski@intel.com>
References: <20211104081231.1982753-1-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new functions to check netlist of a given board for:
- Recovered Clock device,
- Clock Generation Unit,
- Clock Multiplexer,

Initialize feature bits depending on detected components.

Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   7 +-
 drivers/net/ethernet/intel/ice/ice_common.c   | 123 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |   9 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      |   6 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |   1 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 7 files changed, 147 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index bf4ecd9a517c..3dc4caa41565 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -186,6 +186,8 @@
 
 enum ice_feature {
 	ICE_F_DSCP,
+	ICE_F_CGU,
+	ICE_F_PHY_RCLK,
 	ICE_F_SMA_CTRL,
 	ICE_F_MAX
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 4eef3488d86f..339c2a86f680 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1297,6 +1297,8 @@ struct ice_aqc_link_topo_params {
 #define ICE_AQC_LINK_TOPO_NODE_TYPE_CAGE	6
 #define ICE_AQC_LINK_TOPO_NODE_TYPE_MEZZ	7
 #define ICE_AQC_LINK_TOPO_NODE_TYPE_ID_EEPROM	8
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL	9
+#define ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_MUX	10
 #define ICE_AQC_LINK_TOPO_NODE_CTX_S		4
 #define ICE_AQC_LINK_TOPO_NODE_CTX_M		\
 				(0xF << ICE_AQC_LINK_TOPO_NODE_CTX_S)
@@ -1333,7 +1335,10 @@ struct ice_aqc_link_topo_addr {
 struct ice_aqc_get_link_topo {
 	struct ice_aqc_link_topo_addr addr;
 	u8 node_part_num;
-#define ICE_AQC_GET_LINK_TOPO_NODE_NR_PCA9575	0x21
+#define ICE_AQC_GET_LINK_TOPO_NODE_NR_PCA9575		0x21
+#define ICE_ACQ_GET_LINK_TOPO_NODE_NR_ZL30632_80032	0x24
+#define ICE_ACQ_GET_LINK_TOPO_NODE_NR_PKVL		0x31
+#define ICE_ACQ_GET_LINK_TOPO_NODE_NR_GEN_CLK_MUX	0x47
 	u8 rsvd[9];
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index b3066d0fea8b..35903b282885 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -274,6 +274,79 @@ ice_aq_get_link_topo_handle(struct ice_port_info *pi, u8 node_type,
 	return ice_aq_send_cmd(pi->hw, &desc, NULL, 0, cd);
 }
 
+/**
+ * ice_aq_get_netlist_node
+ * @hw: pointer to the hw struct
+ * @cmd: get_link_topo AQ structure
+ * @node_part_number: output node part number if node found
+ * @node_handle: output node handle parameter if node found
+ */
+enum ice_status
+ice_aq_get_netlist_node(struct ice_hw *hw, struct ice_aqc_get_link_topo *cmd,
+			u8 *node_part_number, u16 *node_handle)
+{
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_link_topo);
+	desc.params.get_link_topo = *cmd;
+
+	if (ice_aq_send_cmd(hw, &desc, NULL, 0, NULL))
+		return ICE_ERR_NOT_SUPPORTED;
+
+	if (node_handle)
+		*node_handle =
+			le16_to_cpu(desc.params.get_link_topo.addr.handle);
+	if (node_part_number)
+		*node_part_number = desc.params.get_link_topo.node_part_num;
+
+	return ICE_SUCCESS;
+}
+
+#define MAX_NETLIST_SIZE 10
+/**
+ * ice_find_netlist_node
+ * @hw: pointer to the hw struct
+ * @node_type_ctx: type of netlist node to look for
+ * @node_part_number: node part number to look for
+ * @node_handle: output parameter if node found - optional
+ *
+ * Find and return the node handle for a given node type and part number in the
+ * netlist. When found ICE_SUCCESS is returned, ICE_ERR_DOES_NOT_EXIST
+ * otherwise. If @node_handle provided, it would be set to found node handle.
+ */
+enum ice_status
+ice_find_netlist_node(struct ice_hw *hw, u8 node_type_ctx, u8 node_part_number,
+		      u16 *node_handle)
+{
+	struct ice_aqc_get_link_topo cmd;
+	u8 rec_node_part_number;
+	enum ice_status status;
+	u16 rec_node_handle;
+	u8 idx;
+
+	for (idx = 0; idx < MAX_NETLIST_SIZE; idx++) {
+		memset(&cmd, 0, sizeof(cmd));
+
+		cmd.addr.topo_params.node_type_ctx =
+			(node_type_ctx << ICE_AQC_LINK_TOPO_NODE_TYPE_S);
+		cmd.addr.topo_params.index = idx;
+
+		status = ice_aq_get_netlist_node(hw, &cmd,
+						 &rec_node_part_number,
+						 &rec_node_handle);
+		if (status)
+			return status;
+
+		if (rec_node_part_number == node_part_number) {
+			if (node_handle)
+				*node_handle = rec_node_handle;
+			return ICE_SUCCESS;
+		}
+	}
+
+	return ICE_ERR_DOES_NOT_EXIST;
+}
+
 /**
  * ice_is_media_cage_present
  * @pi: port information structure
@@ -5083,3 +5156,53 @@ bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw)
 	}
 	return false;
 }
+
+/**
+ * ice_is_phy_rclk_present_e810t
+ * @hw: pointer to the hw struct
+ *
+ * Check if the PHY Recovered Clock device is present in the netlist
+ */
+bool ice_is_phy_rclk_present_e810t(struct ice_hw *hw)
+{
+	if (ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL,
+				  ICE_ACQ_GET_LINK_TOPO_NODE_NR_PKVL, NULL))
+		return false;
+
+	return true;
+}
+
+/**
+ * ice_is_cgu_present_e810t
+ * @hw: pointer to the hw struct
+ *
+ * Check if the Clock Generation Unit (CGU) device is present in the netlist
+ */
+bool ice_is_cgu_present_e810t(struct ice_hw *hw)
+{
+	if (!ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL,
+				   ICE_ACQ_GET_LINK_TOPO_NODE_NR_ZL30632_80032,
+				   NULL)) {
+		hw->cgu_part_number =
+			ICE_ACQ_GET_LINK_TOPO_NODE_NR_ZL30632_80032;
+		return true;
+	}
+	return false;
+}
+
+/**
+ * ice_is_clock_mux_present_e810t
+ * @hw: pointer to the hw struct
+ *
+ * Check if the Clock Multiplexer device is present in the netlist
+ */
+bool ice_is_clock_mux_present_e810t(struct ice_hw *hw)
+{
+	if (ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_MUX,
+				  ICE_ACQ_GET_LINK_TOPO_NODE_NR_GEN_CLK_MUX,
+				  NULL))
+		return false;
+
+	return true;
+}
+
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 65c1b3244264..b20a5c085246 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -89,6 +89,12 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 		    struct ice_aqc_get_phy_caps_data *caps,
 		    struct ice_sq_cd *cd);
 enum ice_status
+ice_aq_get_netlist_node(struct ice_hw *hw, struct ice_aqc_get_link_topo *cmd,
+			u8 *node_part_number, u16 *node_handle);
+enum ice_status
+ice_find_netlist_node(struct ice_hw *hw, u8 node_type_ctx, u8 node_part_number,
+		      u16 *node_handle);
+enum ice_status
 ice_aq_list_caps(struct ice_hw *hw, void *buf, u16 buf_size, u32 *cap_count,
 		 enum ice_adminq_opc opc, struct ice_sq_cd *cd);
 enum ice_status
@@ -206,4 +212,7 @@ bool ice_fw_supports_lldp_fltr_ctrl(struct ice_hw *hw);
 enum ice_status
 ice_lldp_fltr_add_remove(struct ice_hw *hw, u16 vsi_num, bool add);
 bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw);
+bool ice_is_phy_rclk_present_e810t(struct ice_hw *hw);
+bool ice_is_cgu_present_e810t(struct ice_hw *hw);
+bool ice_is_clock_mux_present_e810t(struct ice_hw *hw);
 #endif /* _ICE_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 40562600a8cf..2422215b7937 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4183,8 +4183,12 @@ void ice_init_feature_support(struct ice_pf *pf)
 	case ICE_DEV_ID_E810C_QSFP:
 	case ICE_DEV_ID_E810C_SFP:
 		ice_set_feature_support(pf, ICE_F_DSCP);
-		if (ice_is_e810t(&pf->hw))
+		if (ice_is_clock_mux_present_e810t(&pf->hw))
 			ice_set_feature_support(pf, ICE_F_SMA_CTRL);
+		if (ice_is_phy_rclk_present_e810t(&pf->hw))
+			ice_set_feature_support(pf, ICE_F_PHY_RCLK);
+		if (ice_is_cgu_present_e810t(&pf->hw))
+			ice_set_feature_support(pf, ICE_F_CGU);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 29f947c0cd2e..aa257db36765 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -800,3 +800,4 @@ bool ice_is_pca9575_present(struct ice_hw *hw)
 
 	return !status && handle;
 }
+
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 9e0c2923c62e..a9dc16641bd4 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -920,6 +920,7 @@ struct ice_hw {
 	struct list_head rss_list_head;
 	struct ice_mbx_snapshot mbx_snapshot;
 	u16 io_expander_handle;
+	u8 cgu_part_number;
 };
 
 /* Statistics collected by each port, VSI, VEB, and S-channel */
-- 
2.26.3

