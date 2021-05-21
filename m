Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D0038CD21
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbhEUSVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:21:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:33075 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238532AbhEUSVn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 14:21:43 -0400
IronPort-SDR: l5ydXpCIktMEAc3S7lXt9e7tWaeTklQ+onHTqZ6EcqDH4ahz8l8MG0XrCtzqcAdFqJPe2VQoTI
 MBPdWS0PnXSg==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="262760038"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="262760038"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 11:19:58 -0700
IronPort-SDR: ibTyl9LIGBnaef0IDYz16ewkYe+PKf7KYHlmVH5/ZkJ/CJM+J9sxCvLf6lPb13IFSXLIwOlmxi
 hKTJeHNIAaWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="545488379"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 21 May 2021 11:19:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, dledford@redhat.com,
        jgg@mellanox.com
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, anthony.l.nguyen@intel.com,
        shiraz.saleem@intel.com
Subject: [PATCH net-next v1 3/6] ice: Implement iidc operations
Date:   Fri, 21 May 2021 11:22:02 -0700
Message-Id: <20210521182205.3823642-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210521182205.3823642-1-anthony.l.nguyen@intel.com>
References: <20210521182205.3823642-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Add implementations for supporting iidc operations for device operation
such as allocation of resources and event notifications.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   8 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  32 +++
 drivers/net/ethernet/intel/ice/ice_common.c   | 200 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  19 ++
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   3 +-
 drivers/net/ethernet/intel/ice/ice_idc.c      | 229 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  14 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |  47 ++--
 drivers/net/ethernet/intel/ice/ice_sched.c    |  69 +++++-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  27 +++
 drivers/net/ethernet/intel/ice/ice_switch.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 13 files changed, 640 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 64e3633493c1..225f8a55eb3f 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -55,6 +55,7 @@
 #include "ice_switch.h"
 #include "ice_common.h"
 #include "ice_sched.h"
+#include "ice_idc_int.h"
 #include "ice_virtchnl_pf.h"
 #include "ice_sriov.h"
 #include "ice_fdir.h"
@@ -206,9 +207,9 @@ enum ice_pf_state {
 	ICE_NEEDS_RESTART,
 	ICE_PREPARED_FOR_RESET,	/* set by driver when prepared */
 	ICE_RESET_OICR_RECV,		/* set by driver after rcv reset OICR */
-	ICE_PFR_REQ,			/* set by driver and peers */
-	ICE_CORER_REQ,		/* set by driver and peers */
-	ICE_GLOBR_REQ,		/* set by driver and peers */
+	ICE_PFR_REQ,		/* set by driver */
+	ICE_CORER_REQ,		/* set by driver */
+	ICE_GLOBR_REQ,		/* set by driver */
 	ICE_CORER_RECV,		/* set by OICR handler */
 	ICE_GLOBR_RECV,		/* set by OICR handler */
 	ICE_EMPR_RECV,		/* set by OICR handler */
@@ -335,6 +336,7 @@ struct ice_vsi {
 	u16 req_rxq;			 /* User requested Rx queues */
 	u16 num_rx_desc;
 	u16 num_tx_desc;
+	u16 qset_handle[ICE_MAX_TRAFFIC_CLASS];
 	struct ice_tc_cfg tc_cfg;
 	struct bpf_prog *xdp_prog;
 	struct ice_ring **xdp_rings;	 /* XDP ring array */
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index cba6933a7a0e..ff11a618bef7 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1685,6 +1685,36 @@ struct ice_aqc_dis_txq_item {
 	__le16 q_id[];
 } __packed;
 
+/* Add Tx RDMA Queue Set (indirect 0x0C33) */
+struct ice_aqc_add_rdma_qset {
+	u8 num_qset_grps;
+	u8 reserved[7];
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* This is the descriptor of each Qset entry for the Add Tx RDMA Queue Set
+ * command (0x0C33). Only used within struct ice_aqc_add_rdma_qset.
+ */
+struct ice_aqc_add_tx_rdma_qset_entry {
+	__le16 tx_qset_id;
+	u8 rsvd[2];
+	__le32 qset_teid;
+	struct ice_aqc_txsched_elem info;
+};
+
+/* The format of the command buffer for Add Tx RDMA Queue Set(0x0C33)
+ * is an array of the following structs. Please note that the length of
+ * each struct ice_aqc_add_rdma_qset is variable due to the variable
+ * number of queues in each group!
+ */
+struct ice_aqc_add_rdma_qset_data {
+	__le32 parent_teid;
+	__le16 num_qsets;
+	u8 rsvd[2];
+	struct ice_aqc_add_tx_rdma_qset_entry rdma_qsets[];
+};
+
 /* Configure Firmware Logging Command (indirect 0xFF09)
  * Logging Information Read Response (indirect 0xFF10)
  * Note: The 0xFF10 command has no input parameters.
@@ -1881,6 +1911,7 @@ struct ice_aq_desc {
 		struct ice_aqc_get_set_rss_key get_set_rss_key;
 		struct ice_aqc_add_txqs add_txqs;
 		struct ice_aqc_dis_txqs dis_txqs;
+		struct ice_aqc_add_rdma_qset add_rdma_qset;
 		struct ice_aqc_add_get_update_free_vsi vsi_cmd;
 		struct ice_aqc_add_update_free_vsi_resp add_update_free_vsi_res;
 		struct ice_aqc_fw_logging fw_logging;
@@ -2029,6 +2060,7 @@ enum ice_adminq_opc {
 	/* Tx queue handling commands/events */
 	ice_aqc_opc_add_txqs				= 0x0C30,
 	ice_aqc_opc_dis_txqs				= 0x0C31,
+	ice_aqc_opc_add_rdma_qset			= 0x0C33,
 
 	/* package commands */
 	ice_aqc_opc_download_pkg			= 0x0C40,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 6d649e5d1a19..b9ee44942be3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3650,6 +3650,54 @@ ice_aq_dis_lan_txq(struct ice_hw *hw, u8 num_qgrps,
 	return status;
 }
 
+/**
+ * ice_aq_add_rdma_qsets
+ * @hw: pointer to the hardware structure
+ * @num_qset_grps: Number of RDMA Qset groups
+ * @qset_list: list of Qset groups to be added
+ * @buf_size: size of buffer for indirect command
+ * @cd: pointer to command details structure or NULL
+ *
+ * Add Tx RDMA Qsets (0x0C33)
+ */
+static enum ice_status
+ice_aq_add_rdma_qsets(struct ice_hw *hw, u8 num_qset_grps,
+		      struct ice_aqc_add_rdma_qset_data *qset_list,
+		      u16 buf_size, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_add_rdma_qset_data *list;
+	struct ice_aqc_add_rdma_qset *cmd;
+	struct ice_aq_desc desc;
+	u16 i, sum_size = 0;
+
+	cmd = &desc.params.add_rdma_qset;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_add_rdma_qset);
+
+	if (!qset_list)
+		return ICE_ERR_PARAM;
+
+	if (num_qset_grps > ICE_LAN_TXQ_MAX_QGRPS)
+		return ICE_ERR_PARAM;
+
+	for (i = 0, list = qset_list; i < num_qset_grps; i++) {
+		u16 num_qsets = le16_to_cpu(list->num_qsets);
+
+		sum_size += struct_size(list, rdma_qsets, num_qsets);
+		list = (struct ice_aqc_add_rdma_qset_data *)(list->rdma_qsets +
+							     num_qsets);
+	}
+
+	if (buf_size != sum_size)
+		return ICE_ERR_PARAM;
+
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	cmd->num_qset_grps = num_qset_grps;
+
+	return ice_aq_send_cmd(hw, &desc, qset_list, buf_size, cd);
+}
+
 /* End of FW Admin Queue command wrappers */
 
 /**
@@ -4147,6 +4195,158 @@ ice_cfg_vsi_lan(struct ice_port_info *pi, u16 vsi_handle, u8 tc_bitmap,
 			      ICE_SCHED_NODE_OWNER_LAN);
 }
 
+/**
+ * ice_cfg_vsi_rdma - configure the VSI RDMA queues
+ * @pi: port information structure
+ * @vsi_handle: software VSI handle
+ * @tc_bitmap: TC bitmap
+ * @max_rdmaqs: max RDMA queues array per TC
+ *
+ * This function adds/updates the VSI RDMA queues per TC.
+ */
+enum ice_status
+ice_cfg_vsi_rdma(struct ice_port_info *pi, u16 vsi_handle, u16 tc_bitmap,
+		 u16 *max_rdmaqs)
+{
+	return ice_cfg_vsi_qs(pi, vsi_handle, tc_bitmap, max_rdmaqs,
+			      ICE_SCHED_NODE_OWNER_RDMA);
+}
+
+/**
+ * ice_ena_vsi_rdma_qset
+ * @pi: port information structure
+ * @vsi_handle: software VSI handle
+ * @tc: TC number
+ * @rdma_qset: pointer to RDMA Qset
+ * @num_qsets: number of RDMA Qsets
+ * @qset_teid: pointer to Qset node TEIDs
+ *
+ * This function adds RDMA Qset
+ */
+enum ice_status
+ice_ena_vsi_rdma_qset(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
+		      u16 *rdma_qset, u16 num_qsets, u32 *qset_teid)
+{
+	struct ice_aqc_txsched_elem_data node = { 0 };
+	struct ice_aqc_add_rdma_qset_data *buf;
+	struct ice_sched_node *parent;
+	enum ice_status status;
+	struct ice_hw *hw;
+	u16 i, buf_size;
+
+	if (!pi || pi->port_state != ICE_SCHED_PORT_STATE_READY)
+		return ICE_ERR_CFG;
+	hw = pi->hw;
+
+	if (!ice_is_vsi_valid(hw, vsi_handle))
+		return ICE_ERR_PARAM;
+
+	buf_size = struct_size(buf, rdma_qsets, num_qsets);
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return ICE_ERR_NO_MEMORY;
+	mutex_lock(&pi->sched_lock);
+
+	parent = ice_sched_get_free_qparent(pi, vsi_handle, tc,
+					    ICE_SCHED_NODE_OWNER_RDMA);
+	if (!parent) {
+		status = ICE_ERR_PARAM;
+		goto rdma_error_exit;
+	}
+	buf->parent_teid = parent->info.node_teid;
+	node.parent_teid = parent->info.node_teid;
+
+	buf->num_qsets = cpu_to_le16(num_qsets);
+	for (i = 0; i < num_qsets; i++) {
+		buf->rdma_qsets[i].tx_qset_id = cpu_to_le16(rdma_qset[i]);
+		buf->rdma_qsets[i].info.valid_sections =
+			ICE_AQC_ELEM_VALID_GENERIC | ICE_AQC_ELEM_VALID_CIR |
+			ICE_AQC_ELEM_VALID_EIR;
+		buf->rdma_qsets[i].info.generic = 0;
+		buf->rdma_qsets[i].info.cir_bw.bw_profile_idx =
+			cpu_to_le16(ICE_SCHED_DFLT_RL_PROF_ID);
+		buf->rdma_qsets[i].info.cir_bw.bw_alloc =
+			cpu_to_le16(ICE_SCHED_DFLT_BW_WT);
+		buf->rdma_qsets[i].info.eir_bw.bw_profile_idx =
+			cpu_to_le16(ICE_SCHED_DFLT_RL_PROF_ID);
+		buf->rdma_qsets[i].info.eir_bw.bw_alloc =
+			cpu_to_le16(ICE_SCHED_DFLT_BW_WT);
+	}
+	status = ice_aq_add_rdma_qsets(hw, 1, buf, buf_size, NULL);
+	if (status) {
+		ice_debug(hw, ICE_DBG_RDMA, "add RDMA qset failed\n");
+		goto rdma_error_exit;
+	}
+	node.data.elem_type = ICE_AQC_ELEM_TYPE_LEAF;
+	for (i = 0; i < num_qsets; i++) {
+		node.node_teid = buf->rdma_qsets[i].qset_teid;
+		status = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1,
+					    &node);
+		if (status)
+			break;
+		qset_teid[i] = le32_to_cpu(node.node_teid);
+	}
+rdma_error_exit:
+	mutex_unlock(&pi->sched_lock);
+	kfree(buf);
+	return status;
+}
+
+/**
+ * ice_dis_vsi_rdma_qset - free RDMA resources
+ * @pi: port_info struct
+ * @count: number of RDMA Qsets to free
+ * @qset_teid: TEID of Qset node
+ * @q_id: list of queue IDs being disabled
+ */
+enum ice_status
+ice_dis_vsi_rdma_qset(struct ice_port_info *pi, u16 count, u32 *qset_teid,
+		      u16 *q_id)
+{
+	struct ice_aqc_dis_txq_item *qg_list;
+	enum ice_status status = 0;
+	struct ice_hw *hw;
+	u16 qg_size;
+	int i;
+
+	if (!pi || pi->port_state != ICE_SCHED_PORT_STATE_READY)
+		return ICE_ERR_CFG;
+
+	hw = pi->hw;
+
+	qg_size = struct_size(qg_list, q_id, 1);
+	qg_list = kzalloc(qg_size, GFP_KERNEL);
+	if (!qg_list)
+		return ICE_ERR_NO_MEMORY;
+
+	mutex_lock(&pi->sched_lock);
+
+	for (i = 0; i < count; i++) {
+		struct ice_sched_node *node;
+
+		node = ice_sched_find_node_by_teid(pi->root, qset_teid[i]);
+		if (!node)
+			continue;
+
+		qg_list->parent_teid = node->info.parent_teid;
+		qg_list->num_qs = 1;
+		qg_list->q_id[0] =
+			cpu_to_le16(q_id[i] |
+				    ICE_AQC_Q_DIS_BUF_ELEM_TYPE_RDMA_QSET);
+
+		status = ice_aq_dis_lan_txq(hw, 1, qg_list, qg_size,
+					    ICE_NO_RESET, 0, NULL);
+		if (status)
+			break;
+
+		ice_free_sched_node(pi, node);
+	}
+
+	mutex_unlock(&pi->sched_lock);
+	kfree(qg_list);
+	return status;
+}
+
 /**
  * ice_replay_pre_init - replay pre initialization
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 7a9d2dfb21a2..48d2cd280658 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -148,6 +148,15 @@ ice_aq_sff_eeprom(struct ice_hw *hw, u16 lport, u8 bus_addr,
 		  bool write, struct ice_sq_cd *cd);
 
 enum ice_status
+ice_cfg_vsi_rdma(struct ice_port_info *pi, u16 vsi_handle, u16 tc_bitmap,
+		 u16 *max_rdmaqs);
+enum ice_status
+ice_ena_vsi_rdma_qset(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
+		      u16 *rdma_qset, u16 num_qsets, u32 *qset_teid);
+enum ice_status
+ice_dis_vsi_rdma_qset(struct ice_port_info *pi, u16 count, u32 *qset_teid,
+		      u16 *q_id);
+enum ice_status
 ice_dis_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_queues,
 		u16 *q_handle, u16 *q_ids, u32 *q_teids,
 		enum ice_disq_rst_src rst_src, u16 vmvf_num,
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index df02cffdf209..857dc62da7a8 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -275,6 +275,7 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	struct ice_dcbx_cfg *old_cfg, *curr_cfg;
 	struct device *dev = ice_pf_to_dev(pf);
 	int ret = ICE_DCB_NO_HW_CHG;
+	struct iidc_event *event;
 	struct ice_vsi *pf_vsi;
 
 	curr_cfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
@@ -313,6 +314,15 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 		goto free_cfg;
 	}
 
+	/* Notify AUX drivers about impending change to TCs */
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	set_bit(IIDC_EVENT_BEFORE_TC_CHANGE, event->type);
+	ice_send_event_to_aux(pf, event);
+	kfree(event);
+
 	/* avoid race conditions by holding the lock while disabling and
 	 * re-enabling the VSI
 	 */
@@ -640,6 +650,7 @@ static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
 void ice_pf_dcb_recfg(struct ice_pf *pf)
 {
 	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
+	struct iidc_event *event;
 	u8 tc_map = 0;
 	int v, ret;
 
@@ -675,6 +686,14 @@ void ice_pf_dcb_recfg(struct ice_pf *pf)
 		if (vsi->type == ICE_VSI_PF)
 			ice_dcbnl_set_all(vsi);
 	}
+	/* Notify the AUX drivers that TC change is finished */
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return;
+
+	set_bit(IIDC_EVENT_AFTER_TC_CHANGE, event->type);
+	ice_send_event_to_aux(pf, event);
+	kfree(event);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index de38a0fc9665..65b18b3e2bcc 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -110,8 +110,6 @@
 #define VPGEN_VFRSTAT_VFRD_M			BIT(0)
 #define VPGEN_VFRTRIG(_VF)			(0x00090000 + ((_VF) * 4))
 #define VPGEN_VFRTRIG_VFSWR_M			BIT(0)
-#define PFHMC_ERRORDATA				0x00520500
-#define PFHMC_ERRORINFO				0x00520400
 #define GLINT_CTL				0x0016CC54
 #define GLINT_CTL_DIS_AUTOMASK_M		BIT(0)
 #define GLINT_CTL_ITR_GRAN_200_S		16
@@ -160,6 +158,7 @@
 #define PFINT_OICR_GRST_M			BIT(20)
 #define PFINT_OICR_PCI_EXCEPTION_M		BIT(21)
 #define PFINT_OICR_HMC_ERR_M			BIT(26)
+#define PFINT_OICR_PE_PUSH_M			BIT(27)
 #define PFINT_OICR_PE_CRITERR_M			BIT(28)
 #define PFINT_OICR_VFLR_M			BIT(29)
 #define PFINT_OICR_SWINT_M			BIT(31)
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index c419c9cb316d..ffca0d57c13b 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -6,6 +6,235 @@
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
+/**
+ * ice_get_auxiliary_drv - retrieve iidc_auxiliary_drv struct
+ * @pf: pointer to PF struct
+ *
+ * This function has to be called with a device_lock on the
+ * pf->adev.dev to avoid race conditions.
+ */
+static struct iidc_auxiliary_drv *ice_get_auxiliary_drv(struct ice_pf *pf)
+{
+	struct auxiliary_device *adev;
+
+	adev = pf->adev;
+	if (!adev || !adev->dev.driver)
+		return NULL;
+
+	return container_of(adev->dev.driver, struct iidc_auxiliary_drv,
+			    adrv.driver);
+}
+
+/**
+ * ice_send_event_to_aux - send event to RDMA AUX driver
+ * @pf: pointer to PF struct
+ * @event: event struct
+ */
+void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
+{
+	struct iidc_auxiliary_drv *iadrv;
+
+	if (!pf->adev)
+		return;
+
+	device_lock(&pf->adev->dev);
+	iadrv = ice_get_auxiliary_drv(pf);
+	if (iadrv && iadrv->event_handler)
+		iadrv->event_handler(pf, event);
+	device_unlock(&pf->adev->dev);
+}
+
+/**
+ * ice_find_vsi - Find the VSI from VSI ID
+ * @pf: The PF pointer to search in
+ * @vsi_num: The VSI ID to search for
+ */
+static struct ice_vsi *ice_find_vsi(struct ice_pf *pf, u16 vsi_num)
+{
+	int i;
+
+	ice_for_each_vsi(pf, i)
+		if (pf->vsi[i] && pf->vsi[i]->vsi_num == vsi_num)
+			return  pf->vsi[i];
+	return NULL;
+}
+
+/**
+ * ice_add_rdma_qset - Add Leaf Node for RDMA Qset
+ * @pf: PF struct
+ * @qset: Resource to be allocated
+ */
+int ice_add_rdma_qset(struct ice_pf *pf, struct iidc_rdma_qset_params *qset)
+{
+	u16 max_rdmaqs[ICE_MAX_TRAFFIC_CLASS];
+	enum ice_status status;
+	struct ice_vsi *vsi;
+	struct device *dev;
+	u32 qset_teid;
+	u16 qs_handle;
+	int i;
+
+	if (WARN_ON(!pf || !qset))
+		return -EINVAL;
+
+	dev = ice_pf_to_dev(pf);
+
+	if (!test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
+		return -EINVAL;
+
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi) {
+		dev_err(dev, "RDMA QSet invalid VSI\n");
+		return -EINVAL;
+	}
+
+	ice_for_each_traffic_class(i)
+		max_rdmaqs[i] = 0;
+
+	max_rdmaqs[qset->tc]++;
+	qs_handle = qset->qs_handle;
+
+	status = ice_cfg_vsi_rdma(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
+				  max_rdmaqs);
+	if (status) {
+		dev_err(dev, "Failed VSI RDMA Qset config\n");
+		return -EINVAL;
+	}
+
+	status = ice_ena_vsi_rdma_qset(vsi->port_info, vsi->idx, qset->tc,
+				       &qs_handle, 1, &qset_teid);
+	if (status) {
+		dev_err(dev, "Failed VSI RDMA Qset enable\n");
+		return -EINVAL;
+	}
+	vsi->qset_handle[qset->tc] = qset->qs_handle;
+	qset->teid = qset_teid;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ice_add_rdma_qset);
+
+/**
+ * ice_del_rdma_qset - Delete leaf node for RDMA Qset
+ * @pf: PF struct
+ * @qset: Resource to be freed
+ */
+int ice_del_rdma_qset(struct ice_pf *pf, struct iidc_rdma_qset_params *qset)
+{
+	enum ice_status status;
+	struct ice_vsi *vsi;
+	u32 teid;
+	u16 q_id;
+
+	if (WARN_ON(!pf || !qset))
+		return -EINVAL;
+
+	vsi = ice_find_vsi(pf, qset->vport_id);
+	if (!vsi) {
+		dev_err(ice_pf_to_dev(pf), "RDMA Invalid VSI\n");
+		return -EINVAL;
+	}
+
+	q_id = qset->qs_handle;
+	teid = qset->teid;
+
+	vsi->qset_handle[qset->tc] = 0;
+
+	status = ice_dis_vsi_rdma_qset(vsi->port_info, 1, &teid, &q_id);
+	if (status)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ice_del_rdma_qset);
+
+/**
+ * ice_rdma_request_reset - accept request from RDMA to perform a reset
+ * @pf: struct for PF
+ * @reset_type: type of reset
+ */
+int ice_rdma_request_reset(struct ice_pf *pf, enum iidc_reset_type reset_type)
+{
+	enum ice_reset_req reset;
+
+	if (WARN_ON(!pf))
+		return -EINVAL;
+
+	switch (reset_type) {
+	case IIDC_PFR:
+		reset = ICE_RESET_PFR;
+		break;
+	case IIDC_CORER:
+		reset = ICE_RESET_CORER;
+		break;
+	case IIDC_GLOBR:
+		reset = ICE_RESET_GLOBR;
+		break;
+	default:
+		dev_err(ice_pf_to_dev(pf), "incorrect reset request\n");
+		return -EINVAL;
+	}
+
+	return ice_schedule_reset(pf, reset);
+}
+EXPORT_SYMBOL_GPL(ice_rdma_request_reset);
+
+/**
+ * ice_rdma_update_vsi_filter - update main VSI filters for RDMA
+ * @pf: pointer to struct for PF
+ * @vsi_id: VSI HW idx to update filter on
+ * @enable: bool whether to enable or disable filters
+ */
+int ice_rdma_update_vsi_filter(struct ice_pf *pf, u16 vsi_id, bool enable)
+{
+	enum ice_status status;
+	struct ice_vsi *vsi;
+
+	if (WARN_ON(!pf))
+		return -EINVAL;
+
+	vsi = ice_find_vsi(pf, vsi_id);
+	if (!vsi)
+		return -EINVAL;
+
+	status = ice_cfg_rdma_fltr(&pf->hw, vsi->idx, enable);
+	if (status) {
+		dev_err(ice_pf_to_dev(pf), "Failed to  %sable RDMA filtering\n",
+			enable ? "en" : "dis");
+	} else {
+		if (enable)
+			vsi->info.q_opt_flags |= ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
+		else
+			vsi->info.q_opt_flags &= ~ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
+	}
+
+	return ice_status_to_errno(status);
+}
+EXPORT_SYMBOL_GPL(ice_rdma_update_vsi_filter);
+
+/**
+ * ice_get_qos_params - parse QoS params for RDMA consumption
+ * @pf: pointer to PF struct
+ * @qos: set of QoS values
+ */
+void ice_get_qos_params(struct ice_pf *pf, struct iidc_qos_params *qos)
+{
+	struct ice_dcbx_cfg *dcbx_cfg;
+	unsigned int i;
+	u32 up2tc;
+
+	dcbx_cfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
+	up2tc = rd32(&pf->hw, PRTDCB_TUP2TC);
+
+	qos->num_tc = ice_dcb_get_num_tc(dcbx_cfg);
+	for (i = 0; i < IIDC_MAX_USER_PRIORITY; i++)
+		qos->up2tc[i] = (up2tc >> (i * 3)) & 0x7;
+
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
+		qos->tc_info[i].rel_bw = dcbx_cfg->etscfg.tcbwtable[i];
+}
+EXPORT_SYMBOL_GPL(ice_get_qos_params);
+
 /**
  * ice_reserve_rdma_qvector - Reserve vector resources for RDMA driver
  * @pf: board private structure to initialize
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
new file mode 100644
index 000000000000..b7796b8aecbd
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021, Intel Corporation. */
+
+#ifndef _ICE_IDC_INT_H_
+#define _ICE_IDC_INT_H_
+
+#include <linux/net/intel/iidc.h>
+#include "ice.h"
+
+struct ice_pf;
+
+void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event);
+
+#endif /* !_ICE_IDC_INT_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e307317e819a..9d4570b862aa 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2610,6 +2610,7 @@ static void ice_ena_misc_vector(struct ice_pf *pf)
 	       PFINT_OICR_PCI_EXCEPTION_M |
 	       PFINT_OICR_VFLR_M |
 	       PFINT_OICR_HMC_ERR_M |
+	       PFINT_OICR_PE_PUSH_M |
 	       PFINT_OICR_PE_CRITERR_M);
 
 	wr32(hw, PFINT_OICR_ENA, val);
@@ -2680,8 +2681,6 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 
 		/* If a reset cycle isn't already in progress, we set a bit in
 		 * pf->state so that the service task can start a reset/rebuild.
-		 * We also make note of which reset happened so that peer
-		 * devices/drivers can be informed.
 		 */
 		if (!test_and_set_bit(ICE_RESET_OICR_RECV, pf->state)) {
 			if (reset == ICE_RESET_CORER)
@@ -2708,11 +2707,19 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		}
 	}
 
-	if (oicr & PFINT_OICR_HMC_ERR_M) {
-		ena_mask &= ~PFINT_OICR_HMC_ERR_M;
-		dev_dbg(dev, "HMC Error interrupt - info 0x%x, data 0x%x\n",
-			rd32(hw, PFHMC_ERRORINFO),
-			rd32(hw, PFHMC_ERRORDATA));
+#define ICE_AUX_CRIT_ERR (PFINT_OICR_PE_CRITERR_M | PFINT_OICR_HMC_ERR_M | PFINT_OICR_PE_PUSH_M)
+	if (oicr & ICE_AUX_CRIT_ERR) {
+		struct iidc_event *event;
+
+		ena_mask &= ~ICE_AUX_CRIT_ERR;
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (event) {
+			set_bit(IIDC_EVENT_CRIT_ERR, event->type);
+			/* report the entire OICR value to AUX driver */
+			event->reg = oicr;
+			ice_send_event_to_aux(pf, event);
+			kfree(event);
+		}
 	}
 
 	/* Report any remaining unexpected interrupts */
@@ -2722,8 +2729,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		/* If a critical error is pending there is no choice but to
 		 * reset the device.
 		 */
-		if (oicr & (PFINT_OICR_PE_CRITERR_M |
-			    PFINT_OICR_PCI_EXCEPTION_M |
+		if (oicr & (PFINT_OICR_PCI_EXCEPTION_M |
 			    PFINT_OICR_ECC_ERR_M)) {
 			set_bit(ICE_PFR_REQ, pf->state);
 			ice_service_task_schedule(pf);
@@ -6318,7 +6324,9 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct iidc_event *event;
 	u8 count = 0;
+	int err = 0;
 
 	if (new_mtu == (int)netdev->mtu) {
 		netdev_warn(netdev, "MTU is already %u\n", netdev->mtu);
@@ -6351,27 +6359,38 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EBUSY;
 	}
 
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	set_bit(IIDC_EVENT_BEFORE_MTU_CHANGE, event->type);
+	ice_send_event_to_aux(pf, event);
+	clear_bit(IIDC_EVENT_BEFORE_MTU_CHANGE, event->type);
+
 	netdev->mtu = (unsigned int)new_mtu;
 
 	/* if VSI is up, bring it down and then back up */
 	if (!test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
-		int err;
-
 		err = ice_down(vsi);
 		if (err) {
 			netdev_err(netdev, "change MTU if_down err %d\n", err);
-			return err;
+			goto event_after;
 		}
 
 		err = ice_up(vsi);
 		if (err) {
 			netdev_err(netdev, "change MTU if_up err %d\n", err);
-			return err;
+			goto event_after;
 		}
 	}
 
 	netdev_dbg(netdev, "changed MTU to %d\n", new_mtu);
-	return 0;
+event_after:
+	set_bit(IIDC_EVENT_AFTER_MTU_CHANGE, event->type);
+	ice_send_event_to_aux(pf, event);
+	kfree(event);
+
+	return err;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 2f097637e405..a17e24e54cf3 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -595,6 +595,50 @@ ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
 	return 0;
 }
 
+/**
+ * ice_alloc_rdma_q_ctx - allocate RDMA queue contexts for the given VSI and TC
+ * @hw: pointer to the HW struct
+ * @vsi_handle: VSI handle
+ * @tc: TC number
+ * @new_numqs: number of queues
+ */
+static enum ice_status
+ice_alloc_rdma_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
+{
+	struct ice_vsi_ctx *vsi_ctx;
+	struct ice_q_ctx *q_ctx;
+
+	vsi_ctx = ice_get_vsi_ctx(hw, vsi_handle);
+	if (!vsi_ctx)
+		return ICE_ERR_PARAM;
+	/* allocate RDMA queue contexts */
+	if (!vsi_ctx->rdma_q_ctx[tc]) {
+		vsi_ctx->rdma_q_ctx[tc] = devm_kcalloc(ice_hw_to_dev(hw),
+						       new_numqs,
+						       sizeof(*q_ctx),
+						       GFP_KERNEL);
+		if (!vsi_ctx->rdma_q_ctx[tc])
+			return ICE_ERR_NO_MEMORY;
+		vsi_ctx->num_rdma_q_entries[tc] = new_numqs;
+		return 0;
+	}
+	/* num queues are increased, update the queue contexts */
+	if (new_numqs > vsi_ctx->num_rdma_q_entries[tc]) {
+		u16 prev_num = vsi_ctx->num_rdma_q_entries[tc];
+
+		q_ctx = devm_kcalloc(ice_hw_to_dev(hw), new_numqs,
+				     sizeof(*q_ctx), GFP_KERNEL);
+		if (!q_ctx)
+			return ICE_ERR_NO_MEMORY;
+		memcpy(q_ctx, vsi_ctx->rdma_q_ctx[tc],
+		       prev_num * sizeof(*q_ctx));
+		devm_kfree(ice_hw_to_dev(hw), vsi_ctx->rdma_q_ctx[tc]);
+		vsi_ctx->rdma_q_ctx[tc] = q_ctx;
+		vsi_ctx->num_rdma_q_entries[tc] = new_numqs;
+	}
+	return 0;
+}
+
 /**
  * ice_aq_rl_profile - performs a rate limiting task
  * @hw: pointer to the HW struct
@@ -1774,13 +1818,22 @@ ice_sched_update_vsi_child_nodes(struct ice_port_info *pi, u16 vsi_handle,
 	if (!vsi_ctx)
 		return ICE_ERR_PARAM;
 
-	prev_numqs = vsi_ctx->sched.max_lanq[tc];
+	if (owner == ICE_SCHED_NODE_OWNER_LAN)
+		prev_numqs = vsi_ctx->sched.max_lanq[tc];
+	else
+		prev_numqs = vsi_ctx->sched.max_rdmaq[tc];
 	/* num queues are not changed or less than the previous number */
 	if (new_numqs <= prev_numqs)
 		return status;
-	status = ice_alloc_lan_q_ctx(hw, vsi_handle, tc, new_numqs);
-	if (status)
-		return status;
+	if (owner == ICE_SCHED_NODE_OWNER_LAN) {
+		status = ice_alloc_lan_q_ctx(hw, vsi_handle, tc, new_numqs);
+		if (status)
+			return status;
+	} else {
+		status = ice_alloc_rdma_q_ctx(hw, vsi_handle, tc, new_numqs);
+		if (status)
+			return status;
+	}
 
 	if (new_numqs)
 		ice_sched_calc_vsi_child_nodes(hw, new_numqs, new_num_nodes);
@@ -1795,7 +1848,10 @@ ice_sched_update_vsi_child_nodes(struct ice_port_info *pi, u16 vsi_handle,
 					       new_num_nodes, owner);
 	if (status)
 		return status;
-	vsi_ctx->sched.max_lanq[tc] = new_numqs;
+	if (owner == ICE_SCHED_NODE_OWNER_LAN)
+		vsi_ctx->sched.max_lanq[tc] = new_numqs;
+	else
+		vsi_ctx->sched.max_rdmaq[tc] = new_numqs;
 
 	return 0;
 }
@@ -1861,6 +1917,7 @@ ice_sched_cfg_vsi(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 maxqs,
 		 * recreate the child nodes all the time in these cases.
 		 */
 		vsi_ctx->sched.max_lanq[tc] = 0;
+		vsi_ctx->sched.max_rdmaq[tc] = 0;
 	}
 
 	/* update the VSI child nodes */
@@ -1990,6 +2047,8 @@ ice_sched_rm_vsi_cfg(struct ice_port_info *pi, u16 vsi_handle, u8 owner)
 		}
 		if (owner == ICE_SCHED_NODE_OWNER_LAN)
 			vsi_ctx->sched.max_lanq[i] = 0;
+		else
+			vsi_ctx->sched.max_rdmaq[i] = 0;
 	}
 	status = 0;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 357d3073d814..53de13ccedc9 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -302,6 +302,10 @@ static void ice_clear_vsi_q_ctx(struct ice_hw *hw, u16 vsi_handle)
 			devm_kfree(ice_hw_to_dev(hw), vsi->lan_q_ctx[i]);
 			vsi->lan_q_ctx[i] = NULL;
 		}
+		if (vsi->rdma_q_ctx[i]) {
+			devm_kfree(ice_hw_to_dev(hw), vsi->rdma_q_ctx[i]);
+			vsi->rdma_q_ctx[i] = NULL;
+		}
 	}
 }
 
@@ -422,6 +426,29 @@ ice_update_vsi(struct ice_hw *hw, u16 vsi_handle, struct ice_vsi_ctx *vsi_ctx,
 	return ice_aq_update_vsi(hw, vsi_ctx, cd);
 }
 
+/**
+ * ice_cfg_rdma_fltr - enable/disable RDMA filtering on VSI
+ * @hw: pointer to HW struct
+ * @vsi_handle: VSI SW index
+ * @enable: boolean for enable/disable
+ */
+enum ice_status
+ice_cfg_rdma_fltr(struct ice_hw *hw, u16 vsi_handle, bool enable)
+{
+	struct ice_vsi_ctx *ctx;
+
+	ctx = ice_get_vsi_ctx(hw, vsi_handle);
+	if (!ctx)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	if (enable)
+		ctx->info.q_opt_flags |= ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
+	else
+		ctx->info.q_opt_flags &= ~ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
+
+	return ice_update_vsi(hw, vsi_handle, ctx, NULL);
+}
+
 /**
  * ice_aq_alloc_free_vsi_list
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 8b4f9d35c860..8a0b715c2056 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -26,6 +26,8 @@ struct ice_vsi_ctx {
 	u8 vf_num;
 	u16 num_lan_q_entries[ICE_MAX_TRAFFIC_CLASS];
 	struct ice_q_ctx *lan_q_ctx[ICE_MAX_TRAFFIC_CLASS];
+	u16 num_rdma_q_entries[ICE_MAX_TRAFFIC_CLASS];
+	struct ice_q_ctx *rdma_q_ctx[ICE_MAX_TRAFFIC_CLASS];
 };
 
 enum ice_sw_fwd_act_type {
@@ -223,6 +225,8 @@ enum ice_status
 ice_add_eth_mac(struct ice_hw *hw, struct list_head *em_list);
 enum ice_status
 ice_remove_eth_mac(struct ice_hw *hw, struct list_head *em_list);
+enum ice_status
+ice_cfg_rdma_fltr(struct ice_hw *hw, u16 vsi_handle, bool enable);
 void ice_remove_vsi_fltr(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status
 ice_add_vlan(struct ice_hw *hw, struct list_head *m_list);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index b86ae7910a02..c580b87c76ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -45,6 +45,7 @@ static inline u32 ice_round_to_num(u32 N, u32 R)
 #define ICE_DBG_FLOW		BIT_ULL(9)
 #define ICE_DBG_SW		BIT_ULL(13)
 #define ICE_DBG_SCHED		BIT_ULL(14)
+#define ICE_DBG_RDMA		BIT_ULL(15)
 #define ICE_DBG_PKG		BIT_ULL(16)
 #define ICE_DBG_RES		BIT_ULL(17)
 #define ICE_DBG_AQ_MSG		BIT_ULL(24)
@@ -441,6 +442,7 @@ struct ice_sched_node {
 	u8 tc_num;
 	u8 owner;
 #define ICE_SCHED_NODE_OWNER_LAN	0
+#define ICE_SCHED_NODE_OWNER_RDMA	2
 };
 
 /* Access Macros for Tx Sched Elements data */
@@ -512,6 +514,7 @@ struct ice_sched_vsi_info {
 	struct ice_sched_node *ag_node[ICE_MAX_TRAFFIC_CLASS];
 	struct list_head list_entry;
 	u16 max_lanq[ICE_MAX_TRAFFIC_CLASS];
+	u16 max_rdmaq[ICE_MAX_TRAFFIC_CLASS];
 };
 
 /* driver defines the policy */
-- 
2.26.2

