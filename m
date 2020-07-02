Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2E82116DA
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 01:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgGAXyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 19:54:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:5613 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgGAXyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 19:54:35 -0400
IronPort-SDR: 2WnhIDUFpiBilbcpo+fJ+21bkNkPu00ZCghWRR+6AvG7C3yXm7ufuUafXE35LSfD7lXrCsl6xL
 MFvhR5SYlzlA==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126365942"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="126365942"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 16:53:31 -0700
IronPort-SDR: NSumD9ElIqPfo4RolpdTN7IUH3TvAz1YimLetC5vWQYHlmWiFBi3kJ++U2t/SHvCM4jm35EYHF
 5x5FoWpDtp6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="481785443"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jul 2020 16:53:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 2/3] ice: avoid unnecessary single-member variable-length structs
Date:   Wed,  1 Jul 2020 16:53:25 -0700
Message-Id: <20200701235326.3176037-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701235326.3176037-1-anthony.l.nguyen@intel.com>
References: <20200701235326.3176037-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

There are a number of structures that consist of a one-element array as the
only struct member.  Some of those are unused so remove them. Others are
used to index into a buffer/array consisting of a variable number of a
different data or structure type.  Those are unnecessary since we can use
simple pointer arithmetic or index directly into the buffer to access
individual elements of the buffer/array.

Additional code cleanups were done near areas affected by this change.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 39 +-----------
 drivers/net/ethernet/intel/ice/ice_common.c   | 29 ++++-----
 drivers/net/ethernet/intel/ice/ice_common.h   |  2 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |  4 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    | 61 ++++++++-----------
 drivers/net/ethernet/intel/ice/ice_sched.h    |  2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 14 ++---
 7 files changed, 51 insertions(+), 100 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 92f82f2a8af4..a55dc1594daa 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -215,13 +215,6 @@ struct ice_aqc_get_sw_cfg_resp_elem {
 #define ICE_AQC_GET_SW_CONF_RESP_IS_VF		BIT(15)
 };
 
-/* The response buffer is as follows. Note that the length of the
- * elements array varies with the length of the command response.
- */
-struct ice_aqc_get_sw_cfg_resp {
-	struct ice_aqc_get_sw_cfg_resp_elem elements[1];
-};
-
 /* These resource type defines are used for all switch resource
  * commands where a resource type is required, such as:
  * Get Resource Allocation command (indirect 0x0204)
@@ -695,14 +688,6 @@ struct ice_aqc_sched_elem_cmd {
 	__le32 addr_low;
 };
 
-/* This is the buffer for:
- * Suspend Nodes (indirect 0x0409)
- * Resume Nodes (indirect 0x040A)
- */
-struct ice_aqc_suspend_resume_elem {
-	__le32 teid[1];
-};
-
 struct ice_aqc_elem_info_bw {
 	__le16 bw_profile_idx;
 	__le16 bw_alloc;
@@ -756,14 +741,6 @@ struct ice_aqc_add_elem {
 	struct ice_aqc_txsched_elem_data generic[1];
 };
 
-struct ice_aqc_conf_elem {
-	struct ice_aqc_txsched_elem_data generic[1];
-};
-
-struct ice_aqc_get_elem {
-	struct ice_aqc_txsched_elem_data generic[1];
-};
-
 struct ice_aqc_get_topo_elem {
 	struct ice_aqc_txsched_topo_grp_info_hdr hdr;
 	struct ice_aqc_txsched_elem_data
@@ -835,10 +812,6 @@ struct ice_aqc_rl_profile_elem {
 	__le16 rl_encode;
 };
 
-struct ice_aqc_rl_profile_generic_elem {
-	struct ice_aqc_rl_profile_elem generic[1];
-};
-
 /* Query Scheduler Resource Allocation (indirect 0x0412)
  * This indirect command retrieves the scheduler resources allocated by
  * EMP Firmware to the given PF.
@@ -1584,10 +1557,6 @@ struct ice_aqc_dis_txq_item {
 			(1 << ICE_AQC_Q_DIS_BUF_ELEM_TYPE_S)
 };
 
-struct ice_aqc_dis_txq {
-	struct ice_aqc_dis_txq_item qgrps[1];
-};
-
 /* Configure Firmware Logging Command (indirect 0xFF09)
  * Logging Information Read Response (indirect 0xFF10)
  * Note: The 0xFF10 command has no input parameters.
@@ -1636,12 +1605,7 @@ enum ice_aqc_fw_logging_mod {
 	ICE_AQC_FW_LOG_ID_MAX,
 };
 
-/* This is the buffer for both of the logging commands.
- * The entry array size depends on the datalen parameter in the descriptor.
- * There will be a total of datalen / 2 entries.
- */
-struct ice_aqc_fw_logging_data {
-	__le16 entry[1];
+/* Defines for both above FW logging command/response buffers */
 #define ICE_AQC_FW_LOG_ID_S		0
 #define ICE_AQC_FW_LOG_ID_M		(0xFFF << ICE_AQC_FW_LOG_ID_S)
 
@@ -1654,7 +1618,6 @@ struct ice_aqc_fw_logging_data {
 #define ICE_AQC_FW_LOG_INIT_EN		BIT(13)	/* Used by command */
 #define ICE_AQC_FW_LOG_FLOW_EN		BIT(14)	/* Used by command */
 #define ICE_AQC_FW_LOG_ERR_EN		BIT(15)	/* Used by command */
-};
 
 /* Get/Clear FW Log (indirect 0xFF11) */
 struct ice_aqc_get_clear_fw_log {
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index e3cb7bd1ecab..622ab1f0e18f 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -440,30 +440,24 @@ static void ice_cleanup_fltr_mgmt_struct(struct ice_hw *hw)
 	devm_kfree(ice_hw_to_dev(hw), sw);
 }
 
-#define ICE_FW_LOG_DESC_SIZE(n)	(sizeof(struct ice_aqc_fw_logging_data) + \
-	(((n) - 1) * sizeof(((struct ice_aqc_fw_logging_data *)0)->entry)))
-#define ICE_FW_LOG_DESC_SIZE_MAX	\
-	ICE_FW_LOG_DESC_SIZE(ICE_AQC_FW_LOG_ID_MAX)
-
 /**
  * ice_get_fw_log_cfg - get FW logging configuration
  * @hw: pointer to the HW struct
  */
 static enum ice_status ice_get_fw_log_cfg(struct ice_hw *hw)
 {
-	struct ice_aqc_fw_logging_data *config;
 	struct ice_aq_desc desc;
 	enum ice_status status;
+	__le16 *config;
 	u16 size;
 
-	size = ICE_FW_LOG_DESC_SIZE_MAX;
+	size = sizeof(*config) * ICE_AQC_FW_LOG_ID_MAX;
 	config = devm_kzalloc(ice_hw_to_dev(hw), size, GFP_KERNEL);
 	if (!config)
 		return ICE_ERR_NO_MEMORY;
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_fw_logging_info);
 
-	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_BUF);
 	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
 
 	status = ice_aq_send_cmd(hw, &desc, config, size, NULL);
@@ -474,7 +468,7 @@ static enum ice_status ice_get_fw_log_cfg(struct ice_hw *hw)
 		for (i = 0; i < ICE_AQC_FW_LOG_ID_MAX; i++) {
 			u16 v, m, flgs;
 
-			v = le16_to_cpu(config->entry[i]);
+			v = le16_to_cpu(config[i]);
 			m = (v & ICE_AQC_FW_LOG_ID_M) >> ICE_AQC_FW_LOG_ID_S;
 			flgs = (v & ICE_AQC_FW_LOG_EN_M) >> ICE_AQC_FW_LOG_EN_S;
 
@@ -526,11 +520,11 @@ static enum ice_status ice_get_fw_log_cfg(struct ice_hw *hw)
  */
 static enum ice_status ice_cfg_fw_log(struct ice_hw *hw, bool enable)
 {
-	struct ice_aqc_fw_logging_data *data = NULL;
 	struct ice_aqc_fw_logging *cmd;
 	enum ice_status status = 0;
 	u16 i, chgs = 0, len = 0;
 	struct ice_aq_desc desc;
+	__le16 *data = NULL;
 	u8 actv_evnts = 0;
 	void *buf = NULL;
 
@@ -571,8 +565,9 @@ static enum ice_status ice_cfg_fw_log(struct ice_hw *hw, bool enable)
 				continue;
 
 			if (!data) {
-				data = devm_kzalloc(ice_hw_to_dev(hw),
-						    ICE_FW_LOG_DESC_SIZE_MAX,
+				data = devm_kcalloc(ice_hw_to_dev(hw),
+						    sizeof(*data),
+						    ICE_AQC_FW_LOG_ID_MAX,
 						    GFP_KERNEL);
 				if (!data)
 					return ICE_ERR_NO_MEMORY;
@@ -580,7 +575,7 @@ static enum ice_status ice_cfg_fw_log(struct ice_hw *hw, bool enable)
 
 			val = i << ICE_AQC_FW_LOG_ID_S;
 			val |= hw->fw_log.evnts[i].cfg << ICE_AQC_FW_LOG_EN_S;
-			data->entry[chgs++] = cpu_to_le16(val);
+			data[chgs++] = cpu_to_le16(val);
 		}
 
 		/* Only enable FW logging if at least one module is specified.
@@ -599,7 +594,7 @@ static enum ice_status ice_cfg_fw_log(struct ice_hw *hw, bool enable)
 				cmd->log_ctrl |= ICE_AQC_FW_LOG_UART_EN;
 
 			buf = data;
-			len = ICE_FW_LOG_DESC_SIZE(chgs);
+			len = sizeof(*data) * chgs;
 			desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
 		}
 	}
@@ -629,7 +624,7 @@ static enum ice_status ice_cfg_fw_log(struct ice_hw *hw, bool enable)
 				continue;
 			}
 
-			v = le16_to_cpu(data->entry[i]);
+			v = le16_to_cpu(data[i]);
 			m = (v & ICE_AQC_FW_LOG_ID_M) >> ICE_AQC_FW_LOG_ID_S;
 			hw->fw_log.evnts[m].cur = hw->fw_log.evnts[m].cfg;
 		}
@@ -3690,14 +3685,14 @@ ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
  */
 enum ice_status
 ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
-		     struct ice_aqc_get_elem *buf)
+		     struct ice_aqc_txsched_elem_data *buf)
 {
 	u16 buf_size, num_elem_ret = 0;
 	enum ice_status status;
 
 	buf_size = sizeof(*buf);
 	memset(buf, 0, buf_size);
-	buf->generic[0].node_teid = cpu_to_le32(node_teid);
+	buf->node_teid = cpu_to_le32(node_teid);
 	status = ice_aq_query_sched_elems(hw, 1, buf, buf_size, &num_elem_ret,
 					  NULL);
 	if (status || num_elem_ret != 1)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index e72529e9f022..d1238f43e872 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -155,5 +155,5 @@ ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
 enum ice_status
 ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
-		     struct ice_aqc_get_elem *buf);
+		     struct ice_aqc_txsched_elem_data *buf);
 #endif /* _ICE_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index adb8dab765c8..2cecc9d08005 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -1362,7 +1362,7 @@ ice_update_port_tc_tree_cfg(struct ice_port_info *pi,
 			    struct ice_aqc_port_ets_elem *buf)
 {
 	struct ice_sched_node *node, *tc_node;
-	struct ice_aqc_get_elem elem;
+	struct ice_aqc_txsched_elem_data elem;
 	enum ice_status status = 0;
 	u32 teid1, teid2;
 	u8 i, j;
@@ -1404,7 +1404,7 @@ ice_update_port_tc_tree_cfg(struct ice_port_info *pi,
 		/* new TC */
 		status = ice_sched_query_elem(pi->hw, teid2, &elem);
 		if (!status)
-			status = ice_sched_add_node(pi, 1, &elem.generic[0]);
+			status = ice_sched_add_node(pi, 1, &elem);
 		if (status)
 			break;
 		/* update the TC number */
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 0475134295e4..294257b4d138 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -129,7 +129,7 @@ ice_aqc_send_sched_elem_cmd(struct ice_hw *hw, enum ice_adminq_opc cmd_opc,
  */
 enum ice_status
 ice_aq_query_sched_elems(struct ice_hw *hw, u16 elems_req,
-			 struct ice_aqc_get_elem *buf, u16 buf_size,
+			 struct ice_aqc_txsched_elem_data *buf, u16 buf_size,
 			 u16 *elems_ret, struct ice_sq_cd *cd)
 {
 	return ice_aqc_send_sched_elem_cmd(hw, ice_aqc_opc_get_sched_elems,
@@ -149,8 +149,8 @@ enum ice_status
 ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 		   struct ice_aqc_txsched_elem_data *info)
 {
+	struct ice_aqc_txsched_elem_data elem;
 	struct ice_sched_node *parent;
-	struct ice_aqc_get_elem elem;
 	struct ice_sched_node *node;
 	enum ice_status status;
 	struct ice_hw *hw;
@@ -195,7 +195,7 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 	node->parent = parent;
 	node->tx_sched_layer = layer;
 	parent->children[parent->num_children++] = node;
-	memcpy(&node->info, &elem.generic[0], sizeof(node->info));
+	node->info = elem;
 	return 0;
 }
 
@@ -423,7 +423,7 @@ ice_aq_add_sched_elems(struct ice_hw *hw, u16 grps_req,
  */
 static enum ice_status
 ice_aq_cfg_sched_elems(struct ice_hw *hw, u16 elems_req,
-		       struct ice_aqc_conf_elem *buf, u16 buf_size,
+		       struct ice_aqc_txsched_elem_data *buf, u16 buf_size,
 		       u16 *elems_cfgd, struct ice_sq_cd *cd)
 {
 	return ice_aqc_send_sched_elem_cmd(hw, ice_aqc_opc_cfg_sched_elems,
@@ -443,8 +443,7 @@ ice_aq_cfg_sched_elems(struct ice_hw *hw, u16 elems_req,
  * Suspend scheduling elements (0x0409)
  */
 static enum ice_status
-ice_aq_suspend_sched_elems(struct ice_hw *hw, u16 elems_req,
-			   struct ice_aqc_suspend_resume_elem *buf,
+ice_aq_suspend_sched_elems(struct ice_hw *hw, u16 elems_req, __le32 *buf,
 			   u16 buf_size, u16 *elems_ret, struct ice_sq_cd *cd)
 {
 	return ice_aqc_send_sched_elem_cmd(hw, ice_aqc_opc_suspend_sched_elems,
@@ -464,8 +463,7 @@ ice_aq_suspend_sched_elems(struct ice_hw *hw, u16 elems_req,
  * resume scheduling elements (0x040A)
  */
 static enum ice_status
-ice_aq_resume_sched_elems(struct ice_hw *hw, u16 elems_req,
-			  struct ice_aqc_suspend_resume_elem *buf,
+ice_aq_resume_sched_elems(struct ice_hw *hw, u16 elems_req, __le32 *buf,
 			  u16 buf_size, u16 *elems_ret, struct ice_sq_cd *cd)
 {
 	return ice_aqc_send_sched_elem_cmd(hw, ice_aqc_opc_resume_sched_elems,
@@ -506,9 +504,9 @@ static enum ice_status
 ice_sched_suspend_resume_elems(struct ice_hw *hw, u8 num_nodes, u32 *node_teids,
 			       bool suspend)
 {
-	struct ice_aqc_suspend_resume_elem *buf;
 	u16 i, buf_size, num_elem_ret = 0;
 	enum ice_status status;
+	__le32 *buf;
 
 	buf_size = sizeof(*buf) * num_nodes;
 	buf = devm_kzalloc(ice_hw_to_dev(hw), buf_size, GFP_KERNEL);
@@ -516,7 +514,7 @@ ice_sched_suspend_resume_elems(struct ice_hw *hw, u8 num_nodes, u32 *node_teids,
 		return ICE_ERR_NO_MEMORY;
 
 	for (i = 0; i < num_nodes; i++)
-		buf->teid[i] = cpu_to_le32(node_teids[i]);
+		buf[i] = cpu_to_le32(node_teids[i]);
 
 	if (suspend)
 		status = ice_aq_suspend_sched_elems(hw, num_nodes, buf,
@@ -591,7 +589,7 @@ ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
  */
 static enum ice_status
 ice_aq_rl_profile(struct ice_hw *hw, enum ice_adminq_opc opcode,
-		  u16 num_profiles, struct ice_aqc_rl_profile_generic_elem *buf,
+		  u16 num_profiles, struct ice_aqc_rl_profile_elem *buf,
 		  u16 buf_size, u16 *num_processed, struct ice_sq_cd *cd)
 {
 	struct ice_aqc_rl_profile *cmd;
@@ -622,13 +620,11 @@ ice_aq_rl_profile(struct ice_hw *hw, enum ice_adminq_opc opcode,
  */
 static enum ice_status
 ice_aq_add_rl_profile(struct ice_hw *hw, u16 num_profiles,
-		      struct ice_aqc_rl_profile_generic_elem *buf,
-		      u16 buf_size, u16 *num_profiles_added,
-		      struct ice_sq_cd *cd)
+		      struct ice_aqc_rl_profile_elem *buf, u16 buf_size,
+		      u16 *num_profiles_added, struct ice_sq_cd *cd)
 {
-	return ice_aq_rl_profile(hw, ice_aqc_opc_add_rl_profiles,
-				 num_profiles, buf,
-				 buf_size, num_profiles_added, cd);
+	return ice_aq_rl_profile(hw, ice_aqc_opc_add_rl_profiles, num_profiles,
+				 buf, buf_size, num_profiles_added, cd);
 }
 
 /**
@@ -644,13 +640,12 @@ ice_aq_add_rl_profile(struct ice_hw *hw, u16 num_profiles,
  */
 static enum ice_status
 ice_aq_remove_rl_profile(struct ice_hw *hw, u16 num_profiles,
-			 struct ice_aqc_rl_profile_generic_elem *buf,
-			 u16 buf_size, u16 *num_profiles_removed,
-			 struct ice_sq_cd *cd)
+			 struct ice_aqc_rl_profile_elem *buf, u16 buf_size,
+			 u16 *num_profiles_removed, struct ice_sq_cd *cd)
 {
 	return ice_aq_rl_profile(hw, ice_aqc_opc_remove_rl_profiles,
-				 num_profiles, buf,
-				 buf_size, num_profiles_removed, cd);
+				 num_profiles, buf, buf_size,
+				 num_profiles_removed, cd);
 }
 
 /**
@@ -666,7 +661,7 @@ static enum ice_status
 ice_sched_del_rl_profile(struct ice_hw *hw,
 			 struct ice_aqc_rl_profile_info *rl_info)
 {
-	struct ice_aqc_rl_profile_generic_elem *buf;
+	struct ice_aqc_rl_profile_elem *buf;
 	u16 num_profiles_removed;
 	enum ice_status status;
 	u16 num_profiles = 1;
@@ -675,8 +670,7 @@ ice_sched_del_rl_profile(struct ice_hw *hw,
 		return ICE_ERR_IN_USE;
 
 	/* Safe to remove profile ID */
-	buf = (struct ice_aqc_rl_profile_generic_elem *)
-		&rl_info->profile;
+	buf = &rl_info->profile;
 	status = ice_aq_remove_rl_profile(hw, num_profiles, buf, sizeof(*buf),
 					  &num_profiles_removed, NULL);
 	if (status || num_profiles_removed != num_profiles)
@@ -1867,7 +1861,7 @@ static void ice_sched_rm_unused_rl_prof(struct ice_port_info *pi)
  * @node: pointer to node
  * @info: node info to update
  *
- * It updates the HW DB, and local SW DB of node. It updates the scheduling
+ * Update the HW DB, and local SW DB of node. Update the scheduling
  * parameters of node from argument info data buffer (Info->data buf) and
  * returns success or error on config sched element failure. The caller
  * needs to hold scheduler lock.
@@ -1876,18 +1870,18 @@ static enum ice_status
 ice_sched_update_elem(struct ice_hw *hw, struct ice_sched_node *node,
 		      struct ice_aqc_txsched_elem_data *info)
 {
-	struct ice_aqc_conf_elem buf;
+	struct ice_aqc_txsched_elem_data buf;
 	enum ice_status status;
 	u16 elem_cfgd = 0;
 	u16 num_elems = 1;
 
-	buf.generic[0] = *info;
+	buf = *info;
 	/* Parent TEID is reserved field in this aq call */
-	buf.generic[0].parent_teid = 0;
+	buf.parent_teid = 0;
 	/* Element type is reserved field in this aq call */
-	buf.generic[0].data.elem_type = 0;
+	buf.data.elem_type = 0;
 	/* Flags is reserved field in this aq call */
-	buf.generic[0].data.flags = 0;
+	buf.data.flags = 0;
 
 	/* Update HW DB */
 	/* Configure element node */
@@ -2131,9 +2125,9 @@ static struct ice_aqc_rl_profile_info *
 ice_sched_add_rl_profile(struct ice_port_info *pi,
 			 enum ice_rl_type rl_type, u32 bw, u8 layer_num)
 {
-	struct ice_aqc_rl_profile_generic_elem *buf;
 	struct ice_aqc_rl_profile_info *rl_prof_elem;
 	u16 profiles_added = 0, num_profiles = 1;
+	struct ice_aqc_rl_profile_elem *buf;
 	enum ice_status status;
 	struct ice_hw *hw;
 	u8 profile_type;
@@ -2182,8 +2176,7 @@ ice_sched_add_rl_profile(struct ice_port_info *pi,
 	rl_prof_elem->profile.max_burst_size = cpu_to_le16(hw->max_burst_size);
 
 	/* Create new entry in HW DB */
-	buf = (struct ice_aqc_rl_profile_generic_elem *)
-		&rl_prof_elem->profile;
+	buf = &rl_prof_elem->profile;
 	status = ice_aq_add_rl_profile(hw, num_profiles, buf, sizeof(*buf),
 				       &profiles_added, NULL);
 	if (status || profiles_added != num_profiles)
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.h b/drivers/net/ethernet/intel/ice/ice_sched.h
index f0593cfb6521..0e55ae0d446f 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.h
+++ b/drivers/net/ethernet/intel/ice/ice_sched.h
@@ -56,7 +56,7 @@ struct ice_sched_agg_info {
 /* FW AQ command calls */
 enum ice_status
 ice_aq_query_sched_elems(struct ice_hw *hw, u16 elems_req,
-			 struct ice_aqc_get_elem *buf, u16 buf_size,
+			 struct ice_aqc_txsched_elem_data *buf, u16 buf_size,
 			 u16 *elems_ret, struct ice_sq_cd *cd);
 enum ice_status ice_sched_init_port(struct ice_port_info *pi);
 enum ice_status ice_sched_query_res_alloc(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index ff7d16ac693e..0414be3f47dd 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -87,7 +87,7 @@ enum ice_status ice_init_def_sw_recp(struct ice_hw *hw)
  * @num_elems: pointer to number of elements
  * @cd: pointer to command details structure or NULL
  *
- * Get switch configuration (0x0200) to be placed in 'buff'.
+ * Get switch configuration (0x0200) to be placed in buf.
  * This admin command returns information such as initial VSI/port number
  * and switch ID it belongs to.
  *
@@ -104,13 +104,13 @@ enum ice_status ice_init_def_sw_recp(struct ice_hw *hw)
  * parsing the response buffer.
  */
 static enum ice_status
-ice_aq_get_sw_cfg(struct ice_hw *hw, struct ice_aqc_get_sw_cfg_resp *buf,
+ice_aq_get_sw_cfg(struct ice_hw *hw, struct ice_aqc_get_sw_cfg_resp_elem *buf,
 		  u16 buf_size, u16 *req_desc, u16 *num_elems,
 		  struct ice_sq_cd *cd)
 {
 	struct ice_aqc_get_sw_cfg *cmd;
-	enum ice_status status;
 	struct ice_aq_desc desc;
+	enum ice_status status;
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_sw_cfg);
 	cmd = &desc.params.get_sw_conf;
@@ -550,7 +550,7 @@ ice_init_port_info(struct ice_port_info *pi, u16 vsi_port_num, u8 type,
  */
 enum ice_status ice_get_initial_sw_cfg(struct ice_hw *hw)
 {
-	struct ice_aqc_get_sw_cfg_resp *rbuf;
+	struct ice_aqc_get_sw_cfg_resp_elem *rbuf;
 	enum ice_status status;
 	u16 req_desc = 0;
 	u16 num_elems;
@@ -568,19 +568,19 @@ enum ice_status ice_get_initial_sw_cfg(struct ice_hw *hw)
 	 * writing a non-zero value in req_desc
 	 */
 	do {
+		struct ice_aqc_get_sw_cfg_resp_elem *ele;
+
 		status = ice_aq_get_sw_cfg(hw, rbuf, ICE_SW_CFG_MAX_BUF_LEN,
 					   &req_desc, &num_elems, NULL);
 
 		if (status)
 			break;
 
-		for (i = 0; i < num_elems; i++) {
-			struct ice_aqc_get_sw_cfg_resp_elem *ele;
+		for (i = 0, ele = rbuf; i < num_elems; i++, ele++) {
 			u16 pf_vf_num, swid, vsi_port_num;
 			bool is_vf = false;
 			u8 res_type;
 
-			ele = rbuf[i].elements;
 			vsi_port_num = le16_to_cpu(ele->vsi_port_num) &
 				ICE_AQC_GET_SW_CONF_RESP_VSI_PORT_NUM_M;
 
-- 
2.26.2

