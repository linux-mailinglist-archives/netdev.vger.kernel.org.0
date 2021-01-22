Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA5930112D
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbhAVXv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:51:56 -0500
Received: from mga05.intel.com ([192.55.52.43]:55260 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbhAVXvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:51:04 -0500
IronPort-SDR: UuyweaqGXAZSU9DmbTbAN6FhoqI3+tVX9/bZQGwRwAsouG4EkZh5p7jV9mcviPrr6kngg2YGk+
 mBr+GZI5fp7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="264346857"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="264346857"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:08 -0800
IronPort-SDR: Nu2v3lcglTEJTpdfpbhuou1t8I2hGKezHDrIW1B53bzD0Q96bfxlIKszt3dvUejfR6/cWiImcE
 resJASgjaN7g==
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="574869409"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.251.4.95])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:06 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH 03/22] ice: Implement iidc operations
Date:   Fri, 22 Jan 2021 17:48:08 -0600
Message-Id: <20210122234827.1353-4-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210122234827.1353-1-shiraz.saleem@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Add implementations for supporting iidc operations which the peer calls
for device operation such as registration, allocation of queues, and event
notifications.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h             |   1 +
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h  |  32 +
 drivers/net/ethernet/intel/ice/ice_common.c      | 200 +++++
 drivers/net/ethernet/intel/ice/ice_common.h      |   9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c     |  27 +
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h  |   3 +-
 drivers/net/ethernet/intel/ice/ice_idc.c         | 923 +++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h     |  50 ++
 drivers/net/ethernet/intel/ice/ice_lib.c         |  16 +
 drivers/net/ethernet/intel/ice/ice_main.c        |  63 +-
 drivers/net/ethernet/intel/ice/ice_sched.c       |  69 +-
 drivers/net/ethernet/intel/ice/ice_switch.c      |  27 +
 drivers/net/ethernet/intel/ice/ice_switch.h      |   4 +
 drivers/net/ethernet/intel/ice/ice_type.h        |   3 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |  34 +
 15 files changed, 1441 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 22c2ed1..b79ffdc 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -322,6 +322,7 @@ struct ice_vsi {
 	u16 req_rxq;			 /* User requested Rx queues */
 	u16 num_rx_desc;
 	u16 num_tx_desc;
+	u16 qset_handle[ICE_MAX_TRAFFIC_CLASS];
 	struct ice_tc_cfg tc_cfg;
 	struct bpf_prog *xdp_prog;
 	struct ice_ring **xdp_rings;	 /* XDP ring array */
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index b7c1637..b78c9ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1689,6 +1689,36 @@ struct ice_aqc_dis_txq_item {
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
+/* This is the descriptor of each qset entry for the Add Tx RDMA Queue Set
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
@@ -1883,6 +1913,7 @@ struct ice_aq_desc {
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
index ff68d25..e1c5aabc 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3576,6 +3576,54 @@ enum ice_status
 	return status;
 }
 
+/**
+ * ice_aq_add_rdma_qsets
+ * @hw: pointer to the hardware structure
+ * @num_qset_grps: Number of RDMA Qset groups
+ * @qset_list: list of qset groups to be added
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
@@ -4074,6 +4122,158 @@ enum ice_status
 }
 
 /**
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
+ * @rdma_qset: pointer to RDMA qset
+ * @num_qsets: number of RDMA qsets
+ * @qset_teid: pointer to qset node teids
+ *
+ * This function adds RDMA qset
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
+ * @count: number of RDMA qsets to free
+ * @qset_teid: TEID of qset node
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
+/**
  * ice_replay_pre_init - replay pre initialization
  * @hw: pointer to the HW struct
  *
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 3ebb973..d75d4c8 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -147,6 +147,15 @@ enum ice_status
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
index 00e8741..ab13c35 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -227,6 +227,30 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
 }
 
 /**
+ * ice_peer_prep_tc_change - Pre-notify RDMA Peer in blocking call of TC change
+ * @peer_obj_int: ptr to peer device internal struct
+ * @data: ptr to opaque data
+ */
+static int
+ice_peer_prep_tc_change(struct ice_peer_obj_int *peer_obj_int,
+			void __always_unused *data)
+{
+	struct iidc_peer_obj *peer_obj;
+
+	peer_obj = ice_get_peer_obj(peer_obj_int);
+	if (!ice_validate_peer_obj(peer_obj))
+		return 0;
+
+	if (!test_bit(ICE_PEER_OBJ_STATE_OPENED, peer_obj_int->state))
+		return 0;
+
+	if (peer_obj->peer_ops && peer_obj->peer_ops->prep_tc_change)
+		peer_obj->peer_ops->prep_tc_change(peer_obj);
+
+	return 0;
+}
+
+/**
  * ice_dcb_bwchk - check if ETS bandwidth input parameters are correct
  * @pf: pointer to the PF struct
  * @dcbcfg: pointer to DCB config structure
@@ -313,6 +337,9 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 		goto free_cfg;
 	}
 
+	/* Notify capable peers about impending change to TCs */
+	ice_for_each_peer(pf, NULL, ice_peer_prep_tc_change);
+
 	/* avoid race conditions by holding the lock while disabling and
 	 * re-enabling the VSI
 	 */
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 90abc86..b6379d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -107,8 +107,6 @@
 #define VPGEN_VFRSTAT_VFRD_M			BIT(0)
 #define VPGEN_VFRTRIG(_VF)			(0x00090000 + ((_VF) * 4))
 #define VPGEN_VFRTRIG_VFSWR_M			BIT(0)
-#define PFHMC_ERRORDATA				0x00520500
-#define PFHMC_ERRORINFO				0x00520400
 #define GLINT_CTL				0x0016CC54
 #define GLINT_CTL_DIS_AUTOMASK_M		BIT(0)
 #define GLINT_CTL_ITR_GRAN_200_S		16
@@ -156,6 +154,7 @@
 #define PFINT_OICR_GRST_M			BIT(20)
 #define PFINT_OICR_PCI_EXCEPTION_M		BIT(21)
 #define PFINT_OICR_HMC_ERR_M			BIT(26)
+#define PFINT_OICR_PE_PUSH_M			BIT(27)
 #define PFINT_OICR_PE_CRITERR_M			BIT(28)
 #define PFINT_OICR_VFLR_M			BIT(29)
 #define PFINT_OICR_SWINT_M			BIT(31)
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index aec0951..e7dd958 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -9,6 +9,24 @@
 static struct peer_obj_id ice_peers[] = ASSIGN_PEER_INFO;
 
 /**
+ * ice_is_vsi_state_nominal
+ * @vsi: pointer to the VSI struct
+ *
+ * returns true if VSI state is nominal, false otherwise
+ */
+static bool ice_is_vsi_state_nominal(struct ice_vsi *vsi)
+{
+	if (!vsi)
+		return false;
+
+	if (test_bit(__ICE_DOWN, vsi->state) ||
+	    test_bit(__ICE_NEEDS_RESTART, vsi->state))
+		return false;
+
+	return true;
+}
+
+/**
  * ice_peer_state_change - manage state machine for peer
  * @peer_obj: pointer to peer's configuration
  * @new_state: the state requested to transition into
@@ -140,6 +158,8 @@
 				       peer_obj->state)) {
 			set_bit(ICE_PEER_OBJ_STATE_REMOVED, peer_obj->state);
 			dev_dbg(dev, "state from _OPENED/_CLOSED to _REMOVED\n");
+			/* Clear registration for events when peer removed */
+			bitmap_zero(peer_obj->events, ICE_PEER_OBJ_STATE_NBITS);
 		}
 		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_OPENING,
 				       peer_obj->state)) {
@@ -156,6 +176,166 @@
 }
 
 /**
+ * ice_peer_close - close a peer object
+ * @peer_obj_int: peer object to close
+ * @data: pointer to opaque data
+ *
+ * This function will also set the state bit for the peer to CLOSED. This
+ * function is meant to be called from a ice_for_each_peer().
+ */
+int ice_peer_close(struct ice_peer_obj_int *peer_obj_int, void *data)
+{
+	enum iidc_close_reason reason = *(enum iidc_close_reason *)(data);
+	struct iidc_peer_obj *peer_obj;
+	struct ice_pf *pf;
+	int i;
+
+	peer_obj = ice_get_peer_obj(peer_obj_int);
+	/* return 0 so ice_for_each_peer will continue closing other peers */
+	if (!ice_validate_peer_obj(peer_obj))
+		return 0;
+	pf = pci_get_drvdata(peer_obj->pdev);
+
+	if (test_bit(__ICE_DOWN, pf->state) ||
+	    test_bit(__ICE_SUSPENDED, pf->state) ||
+	    test_bit(__ICE_NEEDS_RESTART, pf->state))
+		return 0;
+
+	mutex_lock(&peer_obj_int->peer_obj_state_mutex);
+
+	/* no peer driver, already closed, closing or opening nothing to do */
+	if (test_bit(ICE_PEER_OBJ_STATE_CLOSED, peer_obj_int->state) ||
+	    test_bit(ICE_PEER_OBJ_STATE_CLOSING, peer_obj_int->state) ||
+	    test_bit(ICE_PEER_OBJ_STATE_OPENING, peer_obj_int->state) ||
+	    test_bit(ICE_PEER_OBJ_STATE_PROBED, peer_obj_int->state) ||
+	    test_bit(ICE_PEER_OBJ_STATE_REMOVED, peer_obj_int->state))
+		goto peer_close_out;
+
+	/* Set the peer state to CLOSING */
+	ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_CLOSING, true);
+
+	for (i = 0; i < IIDC_EVENT_NBITS; i++)
+		bitmap_zero(peer_obj_int->current_events[i].type,
+			    IIDC_EVENT_NBITS);
+
+	if (peer_obj->peer_ops && peer_obj->peer_ops->close)
+		peer_obj->peer_ops->close(peer_obj, reason);
+
+	/* Set the peer state to CLOSED */
+	ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_CLOSED, true);
+
+peer_close_out:
+	mutex_unlock(&peer_obj_int->peer_obj_state_mutex);
+
+	return 0;
+}
+
+/**
+ * ice_close_peer_for_reset - queue work to close peer for reset
+ * @peer_obj_int: pointer peer object internal struct
+ * @data: pointer to opaque data used for reset type
+ */
+int ice_close_peer_for_reset(struct ice_peer_obj_int *peer_obj_int, void *data)
+{
+	struct iidc_peer_obj *peer_obj;
+	enum ice_reset_req reset;
+
+	peer_obj = ice_get_peer_obj(peer_obj_int);
+	if (!ice_validate_peer_obj(peer_obj) ||
+	    (!test_bit(ICE_PEER_OBJ_STATE_OPENED, peer_obj_int->state) &&
+	     !test_bit(ICE_PEER_OBJ_STATE_PREPPED, peer_obj_int->state)))
+		return 0;
+
+	reset = *(enum ice_reset_req *)data;
+
+	switch (reset) {
+	case ICE_RESET_EMPR:
+		peer_obj_int->rst_type = IIDC_REASON_EMPR_REQ;
+		break;
+	case ICE_RESET_GLOBR:
+		peer_obj_int->rst_type = IIDC_REASON_GLOBR_REQ;
+		break;
+	case ICE_RESET_CORER:
+		peer_obj_int->rst_type = IIDC_REASON_CORER_REQ;
+		break;
+	case ICE_RESET_PFR:
+		peer_obj_int->rst_type = IIDC_REASON_PFR_REQ;
+		break;
+	default:
+		/* reset type is invalid */
+		return 1;
+	}
+	queue_work(peer_obj_int->ice_peer_wq, &peer_obj_int->peer_close_task);
+	return 0;
+}
+
+/**
+ * ice_check_peer_drv_for_events - check peer_drv for events to report
+ * @peer_obj: peer object to report to
+ */
+static void ice_check_peer_drv_for_events(struct iidc_peer_obj *peer_obj)
+{
+	const struct iidc_peer_ops *p_ops = peer_obj->peer_ops;
+	struct ice_peer_obj_int *peer_obj_int;
+	struct ice_peer_drv_int *peer_drv_int;
+	int i;
+
+	peer_obj_int = peer_to_ice_obj_int(peer_obj);
+	if (!peer_obj_int)
+		return;
+	peer_drv_int = peer_obj_int->peer_drv_int;
+
+	for_each_set_bit(i, peer_obj_int->events, IIDC_EVENT_NBITS) {
+		struct iidc_event *curr = &peer_drv_int->current_events[i];
+
+		if (!bitmap_empty(curr->type, IIDC_EVENT_NBITS) &&
+		    p_ops->event_handler)
+			p_ops->event_handler(peer_obj, curr);
+	}
+}
+
+/**
+ * ice_check_peer_for_events - check peer_objs for events new peer reg'd for
+ * @src_peer_int: peer to check for events
+ * @data: ptr to opaque data, to be used for the peer struct that opened
+ *
+ * This function is to be called when a peer object is opened.
+ *
+ * Since a new peer opening would have missed any events that would
+ * have happened before its opening, we need to walk the peers and see
+ * if any of them have events that the new peer cares about
+ *
+ * This function is meant to be called by a ice_for_each_peer.
+ */
+static int
+ice_check_peer_for_events(struct ice_peer_obj_int *src_peer_int, void *data)
+{
+	struct iidc_peer_obj *new_peer = (struct iidc_peer_obj *)data;
+	const struct iidc_peer_ops *p_ops = new_peer->peer_ops;
+	struct ice_peer_obj_int *new_peer_int;
+	struct iidc_peer_obj *src_peer;
+	unsigned long i;
+
+	src_peer = ice_get_peer_obj(src_peer_int);
+	if (!ice_validate_peer_obj(new_peer) ||
+	    !ice_validate_peer_obj(src_peer))
+		return 0;
+
+	new_peer_int = peer_to_ice_obj_int(new_peer);
+
+	for_each_set_bit(i, new_peer_int->events, IIDC_EVENT_NBITS) {
+		struct iidc_event *curr = &src_peer_int->current_events[i];
+
+		if (!bitmap_empty(curr->type, IIDC_EVENT_NBITS) &&
+		    new_peer->peer_obj_id != src_peer->peer_obj_id &&
+		    p_ops->event_handler)
+			p_ops->event_handler(new_peer, curr);
+	}
+
+	return 0;
+}
+
+/**
  * ice_for_each_peer - iterate across and call function for each peer obj
  * @pf: pointer to private board struct
  * @data: data to pass to function on each call
@@ -186,6 +366,108 @@
 }
 
 /**
+ * ice_finish_init_peer_obj - complete peer object initialization
+ * @peer_obj_int: ptr to peer object internal struct
+ * @data: ptr to opaque data
+ *
+ * This function completes remaining initialization of peer objects
+ */
+int
+ice_finish_init_peer_obj(struct ice_peer_obj_int *peer_obj_int,
+			 void __always_unused *data)
+{
+	struct iidc_peer_obj *peer_obj;
+	struct iidc_peer_drv *peer_drv;
+	struct device *dev;
+	struct ice_pf *pf;
+	int ret = 0;
+
+	peer_obj = ice_get_peer_obj(peer_obj_int);
+	/* peer_obj will not always be populated at the time of this check */
+	if (!ice_validate_peer_obj(peer_obj))
+		return ret;
+
+	peer_drv = peer_obj->peer_drv;
+	pf = pci_get_drvdata(peer_obj->pdev);
+	dev = ice_pf_to_dev(pf);
+	/* There will be several assessments of the peer_obj's state in this
+	 * chunk of logic.  We need to hold the peer_obj_int's state mutex
+	 * for the entire part so that the flow progresses without another
+	 * context changing things mid-flow
+	 */
+	mutex_lock(&peer_obj_int->peer_obj_state_mutex);
+
+	if (!peer_obj->peer_ops->open) {
+		dev_err(dev, "peer_ops:open not defined in peer obj\n");
+		goto init_unlock;
+	}
+
+	if (!peer_obj->peer_ops->close) {
+		dev_err(dev, "peer_ops:close not defined in peer obj\n");
+		goto init_unlock;
+	}
+
+	/* Peer driver expected to set driver_id during registration */
+	if (!peer_drv->driver_id) {
+		dev_err(dev, "Peer driver did not set driver_id\n");
+		goto init_unlock;
+	}
+
+	if ((test_bit(ICE_PEER_OBJ_STATE_CLOSED, peer_obj_int->state) ||
+	     test_bit(ICE_PEER_OBJ_STATE_PROBED, peer_obj_int->state)) &&
+	    ice_pf_state_is_nominal(pf)) {
+		/* If the RTNL is locked, we defer opening the peer
+		 * until the next time this function is called by the
+		 * service task.
+		 */
+		if (rtnl_is_locked())
+			goto init_unlock;
+		ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_OPENING,
+				      true);
+		ret = peer_obj->peer_ops->open(peer_obj);
+		if (ret == -EAGAIN) {
+			dev_err(dev, "Peer %d failed to open\n",
+				peer_obj->peer_obj_id);
+			ice_peer_state_change(peer_obj_int,
+					      ICE_PEER_OBJ_STATE_PROBED, true);
+			goto init_unlock;
+		} else if (ret) {
+			ice_peer_state_change(peer_obj_int,
+					      ICE_PEER_OBJ_STATE_REMOVED, true);
+			peer_obj->peer_ops = NULL;
+			goto init_unlock;
+		}
+
+		ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_OPENED,
+				      true);
+		ret = ice_for_each_peer(pf, peer_obj,
+					ice_check_peer_for_events);
+		ice_check_peer_drv_for_events(peer_obj);
+	}
+
+	if (test_bit(ICE_PEER_OBJ_STATE_PREPPED, peer_obj_int->state)) {
+		enum iidc_close_reason reason = IIDC_REASON_CORER_REQ;
+		int i;
+
+		ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_CLOSING,
+				      true);
+		for (i = 0; i < IIDC_EVENT_NBITS; i++)
+			bitmap_zero(peer_obj_int->current_events[i].type,
+				    IIDC_EVENT_NBITS);
+
+		peer_obj->peer_ops->close(peer_obj, reason);
+
+		ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_CLOSED,
+				      true);
+	}
+
+init_unlock:
+	mutex_unlock(&peer_obj_int->peer_obj_state_mutex);
+
+	return ret;
+}
+
+/**
  * ice_unreg_peer_obj - unregister specified peer object
  * @peer_obj_int: ptr to peer object internal
  * @data: ptr to opaque data
@@ -208,6 +490,8 @@
 		if (peer_obj_int->peer_prep_task.func)
 			cancel_work_sync(&peer_obj_int->peer_prep_task);
 
+		if (peer_obj_int->peer_close_task.func)
+			cancel_work_sync(&peer_obj_int->peer_close_task);
 		destroy_workqueue(peer_obj_int->ice_peer_wq);
 	}
 
@@ -282,6 +566,567 @@ void __maybe_unused ice_peer_refresh_msix(struct ice_pf *pf)
 }
 
 /**
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
+ * ice_peer_alloc_rdma_qsets - Allocate Leaf Nodes for RDMA Qset
+ * @peer_obj: peer that is requesting the Leaf Nodes
+ * @res: Resources to be allocated
+ * @partial_acceptable: If partial allocation is acceptable to the peer
+ *
+ * This function allocates Leaf Nodes for given RDMA Qset resources
+ * for the peer object.
+ */
+static int
+ice_peer_alloc_rdma_qsets(struct iidc_peer_obj *peer_obj, struct iidc_res *res,
+			  int __always_unused partial_acceptable)
+{
+	u16 max_rdmaqs[ICE_MAX_TRAFFIC_CLASS];
+	enum ice_status status;
+	struct ice_vsi *vsi;
+	struct device *dev;
+	struct ice_pf *pf;
+	int i, ret = 0;
+	u32 *qset_teid;
+	u16 *qs_handle;
+
+	if (!ice_validate_peer_obj(peer_obj) || !res)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_obj->pdev);
+	dev = ice_pf_to_dev(pf);
+
+	if (!test_bit(ICE_FLAG_IWARP_ENA, pf->flags))
+		return -EINVAL;
+
+	if (res->cnt_req > ICE_MAX_TXQ_PER_TXQG)
+		return -EINVAL;
+
+	qset_teid = kcalloc(res->cnt_req, sizeof(*qset_teid), GFP_KERNEL);
+	if (!qset_teid)
+		return -ENOMEM;
+
+	qs_handle = kcalloc(res->cnt_req, sizeof(*qs_handle), GFP_KERNEL);
+	if (!qs_handle) {
+		kfree(qset_teid);
+		return -ENOMEM;
+	}
+
+	ice_for_each_traffic_class(i)
+		max_rdmaqs[i] = 0;
+
+	for (i = 0; i < res->cnt_req; i++) {
+		struct iidc_rdma_qset_params *qset;
+
+		qset = &res->res[i].res.qsets;
+		if (qset->vsi_id != peer_obj->pf_vsi_num) {
+			dev_err(dev, "RDMA QSet invalid VSI requested\n");
+			ret = -EINVAL;
+			goto out;
+		}
+		max_rdmaqs[qset->tc]++;
+		qs_handle[i] = qset->qs_handle;
+	}
+
+	vsi = ice_find_vsi(pf, peer_obj->pf_vsi_num);
+	if (!vsi) {
+		dev_err(dev, "RDMA QSet invalid VSI\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	status = ice_cfg_vsi_rdma(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
+				  max_rdmaqs);
+	if (status) {
+		dev_err(dev, "Failed VSI RDMA qset config\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < res->cnt_req; i++) {
+		struct iidc_rdma_qset_params *qset;
+
+		qset = &res->res[i].res.qsets;
+		status = ice_ena_vsi_rdma_qset(vsi->port_info, vsi->idx,
+					       qset->tc, &qs_handle[i], 1,
+					       &qset_teid[i]);
+		if (status) {
+			dev_err(dev, "Failed VSI RDMA qset enable\n");
+			ret = -EINVAL;
+			goto out;
+		}
+		vsi->qset_handle[qset->tc] = qset->qs_handle;
+		qset->teid = qset_teid[i];
+	}
+
+out:
+	kfree(qset_teid);
+	kfree(qs_handle);
+	return ret;
+}
+
+/**
+ * ice_peer_free_rdma_qsets - Free leaf nodes for RDMA Qset
+ * @peer_obj: peer that requested qsets to be freed
+ * @res: Resource to be freed
+ */
+static int
+ice_peer_free_rdma_qsets(struct iidc_peer_obj *peer_obj, struct iidc_res *res)
+{
+	enum ice_status status;
+	int count, i, ret = 0;
+	struct ice_vsi *vsi;
+	struct device *dev;
+	struct ice_pf *pf;
+	u16 vsi_id;
+	u32 *teid;
+	u16 *q_id;
+
+	if (!ice_validate_peer_obj(peer_obj) || !res)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_obj->pdev);
+	dev = ice_pf_to_dev(pf);
+
+	count = res->res_allocated;
+	if (count > ICE_MAX_TXQ_PER_TXQG)
+		return -EINVAL;
+
+	teid = kcalloc(count, sizeof(*teid), GFP_KERNEL);
+	if (!teid)
+		return -ENOMEM;
+
+	q_id = kcalloc(count, sizeof(*q_id), GFP_KERNEL);
+	if (!q_id) {
+		kfree(teid);
+		return -ENOMEM;
+	}
+
+	vsi_id = res->res[0].res.qsets.vsi_id;
+	vsi = ice_find_vsi(pf, vsi_id);
+	if (!vsi) {
+		dev_err(dev, "RDMA Invalid VSI\n");
+		ret = -EINVAL;
+		goto rdma_free_out;
+	}
+
+	for (i = 0; i < count; i++) {
+		struct iidc_rdma_qset_params *qset;
+
+		qset = &res->res[i].res.qsets;
+		if (qset->vsi_id != vsi_id) {
+			dev_err(dev, "RDMA Invalid VSI ID\n");
+			ret = -EINVAL;
+			goto rdma_free_out;
+		}
+		q_id[i] = qset->qs_handle;
+		teid[i] = qset->teid;
+
+		vsi->qset_handle[qset->tc] = 0;
+	}
+
+	status = ice_dis_vsi_rdma_qset(vsi->port_info, count, teid, q_id);
+	if (status)
+		ret = -EINVAL;
+
+rdma_free_out:
+	kfree(teid);
+	kfree(q_id);
+
+	return ret;
+}
+
+/**
+ * ice_peer_alloc_res - Allocate requested resources for peer objects
+ * @peer_obj: peer that is requesting resources
+ * @res: Resources to be allocated
+ * @partial_acceptable: If partial allocation is acceptable to the peer
+ *
+ * This function allocates requested resources for the peer object.
+ */
+static int
+ice_peer_alloc_res(struct iidc_peer_obj *peer_obj, struct iidc_res *res,
+		   int partial_acceptable)
+{
+	struct ice_pf *pf;
+	int ret;
+
+	if (!ice_validate_peer_obj(peer_obj) || !res)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_obj->pdev);
+	if (!ice_pf_state_is_nominal(pf))
+		return -EBUSY;
+
+	switch (res->res_type) {
+	case IIDC_RDMA_QSETS_TXSCHED:
+		ret = ice_peer_alloc_rdma_qsets(peer_obj, res,
+						partial_acceptable);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * ice_peer_free_res - Free given resources
+ * @peer_obj: peer that is requesting freeing of resources
+ * @res: Resources to be freed
+ *
+ * Free/Release resources allocated to given peer objects.
+ */
+static int
+ice_peer_free_res(struct iidc_peer_obj *peer_obj, struct iidc_res *res)
+{
+	int ret;
+
+	if (!ice_validate_peer_obj(peer_obj) || !res)
+		return -EINVAL;
+
+	switch (res->res_type) {
+	case IIDC_RDMA_QSETS_TXSCHED:
+		ret = ice_peer_free_rdma_qsets(peer_obj, res);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * ice_peer_reg_for_notif - register a peer to receive specific notifications
+ * @peer_obj: peer that is registering for event notifications
+ * @events: mask of event types peer is registering for
+ */
+static void
+ice_peer_reg_for_notif(struct iidc_peer_obj *peer_obj,
+		       struct iidc_event *events)
+{
+	struct ice_peer_obj_int *peer_obj_int;
+	struct ice_pf *pf;
+
+	if (!ice_validate_peer_obj(peer_obj) || !events)
+		return;
+
+	peer_obj_int = peer_to_ice_obj_int(peer_obj);
+	pf = pci_get_drvdata(peer_obj->pdev);
+
+	bitmap_or(peer_obj_int->events, peer_obj_int->events, events->type,
+		  IIDC_EVENT_NBITS);
+
+	/* Check to see if any events happened previous to peer registering */
+	ice_for_each_peer(pf, peer_obj, ice_check_peer_for_events);
+	ice_check_peer_drv_for_events(peer_obj);
+}
+
+/**
+ * ice_peer_unreg_for_notif - unreg a peer from receiving certain notifications
+ * @peer_obj: peer that is unregistering from event notifications
+ * @events: mask of event types peer is unregistering for
+ */
+static void
+ice_peer_unreg_for_notif(struct iidc_peer_obj *peer_obj,
+			 struct iidc_event *events)
+{
+	struct ice_peer_obj_int *peer_obj_int;
+
+	if (!ice_validate_peer_obj(peer_obj) || !events)
+		return;
+
+	peer_obj_int = peer_to_ice_obj_int(peer_obj);
+
+	bitmap_andnot(peer_obj_int->events, peer_obj_int->events, events->type,
+		      IIDC_EVENT_NBITS);
+}
+
+/**
+ * ice_peer_check_for_reg - check to see if any peers are reg'd for event
+ * @peer_obj_int: ptr to peer object internal struct
+ * @data: ptr to opaque data, to be used for ice_event to report
+ *
+ * This function is to be called by ice_for_each_peer to handle an
+ * event reported by a peer or the ice driver.
+ */
+int ice_peer_check_for_reg(struct ice_peer_obj_int *peer_obj_int, void *data)
+{
+	struct iidc_event *event = (struct iidc_event *)data;
+	DECLARE_BITMAP(comp_events, IIDC_EVENT_NBITS);
+	struct iidc_peer_obj *peer_obj;
+	bool check = true;
+
+	peer_obj = ice_get_peer_obj(peer_obj_int);
+
+	if (!ice_validate_peer_obj(peer_obj) || !data)
+	/* If invalid obj, in this case return 0 instead of error
+	 * because caller ignores this return value
+	 */
+		return 0;
+
+	if (event->reporter)
+		check = event->reporter->peer_obj_id != peer_obj->peer_obj_id;
+
+	if (bitmap_and(comp_events, event->type, peer_obj_int->events,
+		       IIDC_EVENT_NBITS) &&
+	    (test_bit(ICE_PEER_OBJ_STATE_OPENED, peer_obj_int->state) ||
+	     test_bit(ICE_PEER_OBJ_STATE_PREP_RST, peer_obj_int->state) ||
+	     test_bit(ICE_PEER_OBJ_STATE_PREPPED, peer_obj_int->state)) &&
+	    check &&
+	    peer_obj->peer_ops->event_handler)
+		peer_obj->peer_ops->event_handler(peer_obj, event);
+
+	return 0;
+}
+
+/**
+ * ice_peer_unregister - request to unregister peer
+ * @peer_obj: peer object
+ *
+ * This function triggers close/remove on peer_obj allowing peer
+ * to unregister.
+ */
+static int ice_peer_unregister(struct iidc_peer_obj *peer_obj)
+{
+	enum iidc_close_reason reason = IIDC_REASON_PEER_DRV_UNREG;
+	struct ice_peer_obj_int *peer_obj_int;
+	struct ice_pf *pf;
+	int ret;
+
+	if (!ice_validate_peer_obj(peer_obj))
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_obj->pdev);
+	if (ice_is_reset_in_progress(pf->state))
+		return -EBUSY;
+
+	peer_obj_int = peer_to_ice_obj_int(peer_obj);
+
+	ret = ice_peer_close(peer_obj_int, &reason);
+	if (ret)
+		return ret;
+
+	switch (peer_obj->peer_obj_id) {
+	case IIDC_PEER_RDMA_ID:
+		pf->rdma_peer = NULL;
+		break;
+	default:
+		break;
+	}
+
+	peer_obj->peer_ops = NULL;
+
+	ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_REMOVED, false);
+	return 0;
+}
+
+/**
+ * ice_peer_register - Called by peer to open communication with LAN
+ * @peer_obj: ptr to peer object
+ *
+ * registering peer is expected to populate the ice_peerdrv->name field
+ * before calling this function.
+ */
+static int ice_peer_register(struct iidc_peer_obj *peer_obj)
+{
+	struct ice_peer_drv_int *peer_drv_int;
+	struct ice_peer_obj_int *peer_obj_int;
+	struct iidc_peer_drv *peer_drv;
+
+	if (!peer_obj) {
+		pr_err("Failed to reg peer_obj: peer_obj ptr NULL\n");
+		return -EINVAL;
+	}
+
+	if (!peer_obj->pdev) {
+		pr_err("Failed to reg peer_obj: peer_obj pdev NULL\n");
+		return -EINVAL;
+	}
+
+	if (!peer_obj->peer_ops || !peer_obj->ops) {
+		pr_err("Failed to reg peer_obj: peer_obj peer_ops/ops NULL\n");
+		return -EINVAL;
+	}
+
+	peer_drv = peer_obj->peer_drv;
+	if (!peer_drv) {
+		pr_err("Failed to reg peer_obj: peer drv NULL\n");
+		return -EINVAL;
+	}
+
+	peer_obj_int = peer_to_ice_obj_int(peer_obj);
+	peer_drv_int = peer_obj_int->peer_drv_int;
+	if (!peer_drv_int) {
+		pr_err("Failed to match peer_drv_int to peer_obj\n");
+		return -EINVAL;
+	}
+
+	peer_drv_int->peer_drv = peer_drv;
+
+	ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_PROBED, false);
+
+	return 0;
+}
+
+/**
+ * ice_peer_request_reset - accept request from peer to perform a reset
+ * @peer_obj: peer object that is requesting a reset
+ * @reset_type: type of reset the peer is requesting
+ */
+static int
+ice_peer_request_reset(struct iidc_peer_obj *peer_obj, enum iidc_peer_reset_type reset_type)
+{
+	enum ice_reset_req reset;
+	struct ice_pf *pf;
+
+	if (!ice_validate_peer_obj(peer_obj))
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_obj->pdev);
+
+	switch (reset_type) {
+	case IIDC_PEER_PFR:
+		reset = ICE_RESET_PFR;
+		break;
+	case IIDC_PEER_CORER:
+		reset = ICE_RESET_CORER;
+		break;
+	case IIDC_PEER_GLOBR:
+		reset = ICE_RESET_GLOBR;
+		break;
+	default:
+		dev_err(ice_pf_to_dev(pf), "incorrect reset request from peer\n");
+		return -EINVAL;
+	}
+
+	return ice_schedule_reset(pf, reset);
+}
+
+/**
+ * ice_peer_is_vsi_ready - query if VSI in nominal state
+ * @peer_obj: pointer to iidc_peer_obj struct
+ */
+static int ice_peer_is_vsi_ready(struct iidc_peer_obj *peer_obj)
+{
+	struct ice_netdev_priv *np;
+	struct ice_vsi *vsi;
+
+	/* If the peer_obj or associated values are not valid, then return
+	 * 0 as there is no ready port associated with the values passed in
+	 * as parameters.
+	 */
+
+	if (!peer_obj || !peer_obj->pdev || !pci_get_drvdata(peer_obj->pdev) ||
+	    !peer_to_ice_obj_int(peer_obj))
+		return 0;
+
+	if (!peer_obj->netdev)
+		return 0;
+
+	np = netdev_priv(peer_obj->netdev);
+	vsi = np->vsi;
+
+	return ice_is_vsi_state_nominal(vsi);
+}
+
+/**
+ * ice_peer_update_vsi_filter - update main VSI filters for RDMA
+ * @peer_obj: pointer to RDMA peer object
+ * @filter: selection of filters to enable or disable
+ * @enable: bool whether to enable or disable filters
+ */
+static int
+ice_peer_update_vsi_filter(struct iidc_peer_obj *peer_obj,
+			   enum iidc_rdma_filter __maybe_unused filter,
+			   bool enable)
+{
+	enum ice_status status;
+	struct ice_vsi *vsi;
+	struct ice_pf *pf;
+
+	if (!ice_validate_peer_obj(peer_obj))
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_obj->pdev);
+
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi)
+		return -EINVAL;
+
+	status = ice_cfg_iwarp_fltr(&pf->hw, vsi->idx, enable);
+	if (status) {
+		dev_err(ice_pf_to_dev(pf), "Failed to  %sable iWARP filtering\n",
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
+
+/**
+ * ice_peer_vc_send - send a virt channel message from a peer
+ * @peer_obj: pointer to a peer object
+ * @vf_id: the absolute VF ID of recipient of message
+ * @msg: pointer to message contents
+ * @len: len of message
+ */
+static int
+ice_peer_vc_send(struct iidc_peer_obj *peer_obj, u32 vf_id, u8 *msg, u16 len)
+{
+	enum ice_status status;
+	struct ice_pf *pf;
+	int err = 0;
+
+	if (!ice_validate_peer_obj(peer_obj))
+		return -EINVAL;
+	if (!msg || !len)
+		return -ENOMEM;
+
+	pf = pci_get_drvdata(peer_obj->pdev);
+	if (len > ICE_AQ_MAX_BUF_LEN)
+		return -EINVAL;
+
+	switch (peer_obj->peer_drv->driver_id) {
+	case IIDC_PEER_RDMA_DRIVER:
+		if (vf_id >= pf->num_alloc_vfs)
+			return -ENODEV;
+
+		/* VIRTCHNL_OP_IWARP is being used for RoCEv2 msg also */
+		status = ice_aq_send_msg_to_vf(&pf->hw, vf_id, VIRTCHNL_OP_IWARP,
+					       0, msg, len, NULL);
+		if (status)
+			err = -EBADMSG;
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	if (err)
+		dev_err(ice_pf_to_dev(pf),
+			"Unable to send msg to VF, error %d\n", err);
+	return err;
+}
+
+/**
  * ice_reserve_peer_qvector - Reserve vector resources for peer drivers
  * @pf: board private structure to initialize
  */
@@ -300,6 +1145,49 @@ static int ice_reserve_peer_qvector(struct ice_pf *pf)
 }
 
 /**
+ * ice_peer_close_task - call peer's close asynchronously
+ * @work: pointer to work_struct contained by the peer_obj_int struct
+ *
+ * This method (asynchronous) of calling a peer's close function is
+ * meant to be used in the reset path.
+ */
+static void ice_peer_close_task(struct work_struct *work)
+{
+	struct ice_peer_obj_int *peer_obj_int;
+	struct iidc_peer_obj *peer_obj;
+
+	peer_obj_int = container_of(work, struct ice_peer_obj_int, peer_close_task);
+
+	peer_obj = ice_get_peer_obj(peer_obj_int);
+	if (!peer_obj || !peer_obj->peer_ops)
+		return;
+
+	/* If this peer_obj is going to close, we do not want any state changes
+	 * to happen until after we successfully finish or abort the close.
+	 * Grab the peer_obj_state_mutex to protect this flow
+	 */
+	mutex_lock(&peer_obj_int->peer_obj_state_mutex);
+
+	/* Only allow a close to go to the peer if they are in a state
+	 * to accept it. The last state of PREP_RST is a special case
+	 * that will not normally happen, but it is up to the peer
+	 * to handle it correctly.
+	 */
+	if (test_bit(ICE_PEER_OBJ_STATE_OPENED, peer_obj_int->state) ||
+	    test_bit(ICE_PEER_OBJ_STATE_PREPPED, peer_obj_int->state) ||
+	    test_bit(ICE_PEER_OBJ_STATE_PREP_RST, peer_obj_int->state)) {
+		ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_CLOSING, true);
+
+		if (peer_obj->peer_ops->close)
+			peer_obj->peer_ops->close(peer_obj, peer_obj_int->rst_type);
+
+		ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_CLOSED, true);
+	}
+
+	mutex_unlock(&peer_obj_int->peer_obj_state_mutex);
+}
+
+/**
  * ice_peer_update_vsi - update the pf_vsi info in peer_obj struct
  * @peer_obj_int: pointer to peer_obj internal struct
  * @data: opaque pointer - VSI to be updated
@@ -317,6 +1205,20 @@ int ice_peer_update_vsi(struct ice_peer_obj_int *peer_obj_int, void *data)
 	return 0;
 }
 
+/* Initialize the ice_ops struct, which is used in 'ice_init_peer_devices' */
+static const struct iidc_ops ops = {
+	.alloc_res			= ice_peer_alloc_res,
+	.free_res			= ice_peer_free_res,
+	.is_vsi_ready			= ice_peer_is_vsi_ready,
+	.reg_for_notification		= ice_peer_reg_for_notif,
+	.unreg_for_notification		= ice_peer_unreg_for_notif,
+	.request_reset			= ice_peer_request_reset,
+	.peer_register			= ice_peer_register,
+	.peer_unregister		= ice_peer_unregister,
+	.update_vsi_filter		= ice_peer_update_vsi_filter,
+	.vc_send			= ice_peer_vc_send,
+};
+
 /**
  * ice_init_peer_devices - initializes peer objects and aux devices
  * @pf: ptr to ice_pf
@@ -325,6 +1227,7 @@ int ice_peer_update_vsi(struct ice_peer_obj_int *peer_obj_int, void *data)
  */
 int ice_init_peer_devices(struct ice_pf *pf)
 {
+	struct ice_port_info *port_info = pf->hw.port_info;
 	struct ice_vsi *vsi = ice_get_main_vsi(pf);
 	struct pci_dev *pdev = pf->pdev;
 	struct device *dev = &pdev->dev;
@@ -366,6 +1269,11 @@ int ice_init_peer_devices(struct ice_pf *pf)
 		pf->peers[i] = peer_obj_int;
 		peer_obj_int->peer_drv_int = peer_drv_int;
 
+		/* Initialize driver values */
+		for (j = 0; j < IIDC_EVENT_NBITS; j++)
+			bitmap_zero(peer_drv_int->current_events[j].type,
+				    IIDC_EVENT_NBITS);
+
 		mutex_init(&peer_obj_int->peer_obj_state_mutex);
 
 		peer_obj = ice_get_peer_obj(peer_obj_int);
@@ -374,6 +1282,8 @@ int ice_init_peer_devices(struct ice_pf *pf)
 		peer_obj->peer_obj_id = ice_peers[i].id;
 		peer_obj->pf_vsi_num = vsi->vsi_num;
 		peer_obj->netdev = vsi->netdev;
+		peer_obj->initial_mtu = vsi->netdev->mtu;
+		ether_addr_copy(peer_obj->lan_addr, port_info->mac.lan_addr);
 
 		peer_obj_int->ice_peer_wq =
 			alloc_ordered_workqueue("ice_peer_wq_%d", WQ_UNBOUND,
@@ -383,8 +1293,19 @@ int ice_init_peer_devices(struct ice_pf *pf)
 			kfree(peer_drv_int);
 			return -ENOMEM;
 		}
+		INIT_WORK(&peer_obj_int->peer_close_task, ice_peer_close_task);
 
 		peer_obj->pdev = pdev;
+		peer_obj->ari_ena = pci_ari_enabled(pdev->bus);
+		peer_obj->bus_num = PCI_BUS_NUM(pdev->devfn);
+		if (!peer_obj->ari_ena) {
+			peer_obj->dev_num = PCI_SLOT(pdev->devfn);
+			peer_obj->fn_num = PCI_FUNC(pdev->devfn);
+		} else {
+			peer_obj->dev_num = 0;
+			peer_obj->fn_num = pdev->devfn & 0xff;
+		}
+
 		qos_info = &peer_obj->initial_qos_info;
 
 		/* setup qos_info fields with defaults */
@@ -400,6 +1321,8 @@ int ice_init_peer_devices(struct ice_pf *pf)
 
 		/* for DCB, override the qos_info defaults. */
 		ice_setup_dcb_qos_info(pf, qos_info);
+		/* Initialize ice_ops */
+		peer_obj->ops = &ops;
 
 		/* make sure peer specific resources such as msix_count and
 		 * msix_entries are initialized
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
index de5cc46..d54a901 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc_int.h
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -22,12 +22,24 @@ enum ice_peer_obj_state {
 
 struct ice_peer_drv_int {
 	struct iidc_peer_drv *peer_drv;
+
+	/* if this peer_obj is the originator of an event, these are the
+	 * most recent events of each type
+	 */
+	struct iidc_event current_events[IIDC_EVENT_NBITS];
 };
 
 struct ice_peer_obj_int {
 	struct iidc_peer_obj peer_obj;
 	struct ice_peer_drv_int *peer_drv_int; /* driver private structure */
 
+	/* if this peer_obj is the originator of an event, these are the
+	 * most recent events of each type
+	 */
+	struct iidc_event current_events[IIDC_EVENT_NBITS];
+	/* Events a peer has registered to be notified about */
+	DECLARE_BITMAP(events, IIDC_EVENT_NBITS);
+
 	/* States associated with peer_obj */
 	DECLARE_BITMAP(state, ICE_PEER_OBJ_STATE_NBITS);
 	struct mutex peer_obj_state_mutex; /* peer_obj state mutex */
@@ -36,11 +48,18 @@ struct ice_peer_obj_int {
 	struct workqueue_struct *ice_peer_wq;
 
 	struct work_struct peer_prep_task;
+	struct work_struct peer_close_task;
 
 	enum iidc_close_reason rst_type;
 };
 
 static inline struct
+ice_peer_obj_int *peer_to_ice_obj_int(struct iidc_peer_obj *peer_obj)
+{
+	return container_of(peer_obj, struct ice_peer_obj_int, peer_obj);
+}
+
+static inline struct
 iidc_peer_obj *ice_get_peer_obj(struct ice_peer_obj_int *peer_obj_int)
 {
 	if (peer_obj_int)
@@ -49,6 +68,37 @@ iidc_peer_obj *ice_get_peer_obj(struct ice_peer_obj_int *peer_obj_int)
 	return NULL;
 }
 
+static inline bool ice_validate_peer_obj(struct iidc_peer_obj *peer_obj)
+{
+	struct ice_peer_obj_int *peer_obj_int;
+	struct ice_pf *pf;
+
+	if (!peer_obj || !peer_obj->pdev)
+		return false;
+
+	if (!peer_obj->peer_ops)
+		return false;
+
+	pf = pci_get_drvdata(peer_obj->pdev);
+	if (!pf)
+		return false;
+
+	peer_obj_int = peer_to_ice_obj_int(peer_obj);
+	if (!peer_obj_int)
+		return false;
+
+	if (test_bit(ICE_PEER_OBJ_STATE_REMOVED, peer_obj_int->state) ||
+	    test_bit(ICE_PEER_OBJ_STATE_INIT, peer_obj_int->state))
+		return false;
+
+	return true;
+}
+
 int ice_peer_update_vsi(struct ice_peer_obj_int *peer_obj_int, void *data);
+int ice_close_peer_for_reset(struct ice_peer_obj_int *peer_obj_int, void *data);
 int ice_unroll_peer(struct ice_peer_obj_int *peer_obj_int, void *data);
+int ice_peer_close(struct ice_peer_obj_int *peer_obj_int, void *data);
+int ice_peer_check_for_reg(struct ice_peer_obj_int *peer_obj_int, void *data);
+int
+ice_finish_init_peer_obj(struct ice_peer_obj_int *peer_obj_int, void *data);
 #endif /* !_ICE_IDC_INT_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index e52d300..0f59a8f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2469,6 +2469,22 @@ void ice_vsi_free_rx_rings(struct ice_vsi *vsi)
  */
 void ice_vsi_close(struct ice_vsi *vsi)
 {
+	if (!ice_is_safe_mode(vsi->back) && vsi->type == ICE_VSI_PF) {
+		enum iidc_close_reason reason = IIDC_REASON_INTERFACE_DOWN;
+		int ret;
+
+		if (test_bit(__ICE_PFR_REQ, vsi->back->state))
+			reason = IIDC_REASON_PFR_REQ;
+		if (test_bit(__ICE_CORER_REQ, vsi->back->state))
+			reason = IIDC_REASON_CORER_REQ;
+		if (test_bit(__ICE_GLOBR_REQ, vsi->back->state))
+			reason = IIDC_REASON_GLOBR_REQ;
+
+		ret = ice_for_each_peer(vsi->back, &reason, ice_peer_close);
+		if (ret)
+			dev_dbg(ice_pf_to_dev(vsi->back), "Peer device did not implement close function\n");
+	}
+
 	if (!test_and_set_bit(__ICE_DOWN, vsi->state))
 		ice_down(vsi);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b04147f..873db5a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -543,6 +543,9 @@ static void ice_reset_subtask(struct ice_pf *pf)
 		/* return if no valid reset type requested */
 		if (reset_type == ICE_RESET_INVAL)
 			return;
+		if (ice_is_peer_ena(pf))
+			ice_for_each_peer(pf, &reset_type,
+					  ice_close_peer_for_reset);
 		ice_prepare_for_reset(pf);
 
 		/* make sure we are ready to rebuild */
@@ -2061,6 +2064,9 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
+	/* Invoke remaining initialization of peer_objs */
+	ice_for_each_peer(pf, NULL, ice_finish_init_peer_obj);
+
 	ice_process_vflr_event(pf);
 	ice_clean_mailboxq_subtask(pf);
 	ice_sync_arfs_fltrs(pf);
@@ -2592,6 +2598,7 @@ static void ice_ena_misc_vector(struct ice_pf *pf)
 	       PFINT_OICR_PCI_EXCEPTION_M |
 	       PFINT_OICR_VFLR_M |
 	       PFINT_OICR_HMC_ERR_M |
+	       PFINT_OICR_PE_PUSH_M |
 	       PFINT_OICR_PE_CRITERR_M);
 
 	wr32(hw, PFINT_OICR_ENA, val);
@@ -2690,11 +2697,20 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		}
 	}
 
-	if (oicr & PFINT_OICR_HMC_ERR_M) {
-		ena_mask &= ~PFINT_OICR_HMC_ERR_M;
-		dev_dbg(dev, "HMC Error interrupt - info 0x%x, data 0x%x\n",
-			rd32(hw, PFHMC_ERRORINFO),
-			rd32(hw, PFHMC_ERRORDATA));
+#define ICE_PEER_CRIT_ERR (PFINT_OICR_PE_CRITERR_M | PFINT_OICR_HMC_ERR_M | PFINT_OICR_PE_PUSH_M)
+	if (oicr & ICE_PEER_CRIT_ERR) {
+		struct iidc_event *event;
+
+		ena_mask &= ~ICE_PEER_CRIT_ERR;
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (event) {
+			set_bit(IIDC_EVENT_CRIT_ERR, event->type);
+			event->reporter = NULL;
+			/* report the entire OICR value to peer */
+			event->info.reg = oicr;
+			ice_for_each_peer(pf, event, ice_peer_check_for_reg);
+			kfree(event);
+		}
 	}
 
 	/* Report any remaining unexpected interrupts */
@@ -2704,8 +2720,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		/* If a critical error is pending there is no choice but to
 		 * reset the device.
 		 */
-		if (oicr & (PFINT_OICR_PE_CRITERR_M |
-			    PFINT_OICR_PCI_EXCEPTION_M |
+		if (oicr & (PFINT_OICR_PCI_EXCEPTION_M |
 			    PFINT_OICR_ECC_ERR_M)) {
 			set_bit(__ICE_PFR_REQ, pf->state);
 			ice_service_task_schedule(pf);
@@ -4399,11 +4414,18 @@ static void ice_remove(struct pci_dev *pdev)
 		ice_free_vfs(pf);
 	}
 
-	set_bit(__ICE_DOWN, pf->state);
 	ice_service_task_stop(pf);
 
 	ice_aq_cancel_waiting_tasks(pf);
 
+	if (ice_is_peer_ena(pf)) {
+		enum iidc_close_reason reason;
+
+		reason = IIDC_REASON_INTERFACE_DOWN;
+		ice_for_each_peer(pf, &reason, ice_peer_close);
+	}
+	set_bit(__ICE_DOWN, pf->state);
+
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 	if (!ice_is_safe_mode(pf))
 		ice_remove_arfs(pf);
@@ -6165,7 +6187,9 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct iidc_event *event;
 	u8 count = 0;
+	int err = 0;
 
 	if (new_mtu == (int)netdev->mtu) {
 		netdev_warn(netdev, "MTU is already %u\n", netdev->mtu);
@@ -6207,27 +6231,40 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EBUSY;
 	}
 
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
 	netdev->mtu = (unsigned int)new_mtu;
 
 	/* if VSI is up, bring it down and then back up */
 	if (!test_and_set_bit(__ICE_DOWN, vsi->state)) {
-		int err;
-
 		err = ice_down(vsi);
 		if (err) {
 			netdev_err(netdev, "change MTU if_up err %d\n", err);
-			return err;
+			goto free_event;
 		}
 
 		err = ice_up(vsi);
 		if (err) {
 			netdev_err(netdev, "change MTU if_up err %d\n", err);
-			return err;
+			goto free_event;
 		}
 	}
 
+	if (ice_is_safe_mode(pf))
+		goto out;
+
+	set_bit(IIDC_EVENT_MTU_CHANGE, event->type);
+	event->reporter = NULL;
+	event->info.mtu = (u16)new_mtu;
+	ice_for_each_peer(pf, event, ice_peer_check_for_reg);
+
+out:
 	netdev_dbg(netdev, "changed MTU to %d\n", new_mtu);
-	return 0;
+free_event:
+	kfree(event);
+	return err;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index f0912e4..a3da7a9 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -575,6 +575,50 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
 }
 
 /**
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
+/**
  * ice_aq_rl_profile - performs a rate limiting task
  * @hw: pointer to the HW struct
  * @opcode: opcode for add, query, or remove profile(s)
@@ -1636,13 +1680,22 @@ struct ice_sched_node *
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
@@ -1657,7 +1710,10 @@ struct ice_sched_node *
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
@@ -1723,6 +1779,7 @@ enum ice_status
 		 * recreate the child nodes all the time in these cases.
 		 */
 		vsi_ctx->sched.max_lanq[tc] = 0;
+		vsi_ctx->sched.max_rdmaq[tc] = 0;
 	}
 
 	/* update the VSI child nodes */
@@ -1852,6 +1909,8 @@ static bool ice_sched_is_leaf_node_present(struct ice_sched_node *node)
 		}
 		if (owner == ICE_SCHED_NODE_OWNER_LAN)
 			vsi_ctx->sched.max_lanq[i] = 0;
+		else
+			vsi_ctx->sched.max_rdmaq[i] = 0;
 	}
 	status = 0;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index c336121..def8cf6 100644
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
 
@@ -423,6 +427,29 @@ enum ice_status
 }
 
 /**
+ * ice_cfg_iwarp_fltr - enable/disable iWARP filtering on VSI
+ * @hw: pointer to HW struct
+ * @vsi_handle: VSI SW index
+ * @enable: boolean for enable/disable
+ */
+enum ice_status
+ice_cfg_iwarp_fltr(struct ice_hw *hw, u16 vsi_handle, bool enable)
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
+/**
  * ice_aq_alloc_free_vsi_list
  * @hw: pointer to the HW struct
  * @vsi_list_id: VSI list ID returned or used for lookup
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 8b4f9d3..6821cf7 100644
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
+ice_cfg_iwarp_fltr(struct ice_hw *hw, u16 vsi_handle, bool enable);
 void ice_remove_vsi_fltr(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status
 ice_add_vlan(struct ice_hw *hw, struct list_head *m_list);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index c112ba0..ef742e8 100644
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
@@ -381,6 +382,7 @@ struct ice_sched_node {
 	u8 tc_num;
 	u8 owner;
 #define ICE_SCHED_NODE_OWNER_LAN	0
+#define ICE_SCHED_NODE_OWNER_RDMA	2
 };
 
 /* Access Macros for Tx Sched Elements data */
@@ -452,6 +454,7 @@ struct ice_sched_vsi_info {
 	struct ice_sched_node *ag_node[ICE_MAX_TRAFFIC_CLASS];
 	struct list_head list_entry;
 	u16 max_lanq[ICE_MAX_TRAFFIC_CLASS];
+	u16 max_rdmaq[ICE_MAX_TRAFFIC_CLASS];
 };
 
 /* driver defines the policy */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index ec7f6c6..5d70f76 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3603,6 +3603,37 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
 }
 
 /**
+ * ice_vc_rdma_msg - send msg to RDMA PF from VF
+ * @vf: pointer to VF info
+ * @msg: pointer to msg buffer
+ * @len: length of the message
+ *
+ * This function is called indirectly from the AQ clean function.
+ */
+static int ice_vc_rdma_msg(struct ice_vf *vf, u8 *msg, u16 len)
+{
+	struct iidc_peer_obj *rdma_peer;
+	int ret;
+
+	rdma_peer = vf->pf->rdma_peer;
+	if (!rdma_peer) {
+		pr_err("Invalid RDMA peer attempted to send message to peer\n");
+		return -EIO;
+	}
+
+	if (!rdma_peer->peer_ops || !rdma_peer->peer_ops->vc_receive) {
+		pr_err("Incomplete RMDA peer attempting to send msg\n");
+		return -EINVAL;
+	}
+
+	ret = rdma_peer->peer_ops->vc_receive(rdma_peer, vf->vf_id, msg, len);
+	if (ret)
+		pr_err("Failed to send message to RDMA peer, error %d\n", ret);
+
+	return ret;
+}
+
+/**
  * ice_vf_init_vlan_stripping - enable/disable VLAN stripping on initialization
  * @vf: VF to enable/disable VLAN stripping for on initialization
  *
@@ -3739,6 +3770,9 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
 		err = ice_vc_dis_vlan_stripping(vf);
 		break;
+	case VIRTCHNL_OP_IWARP:
+		err = ice_vc_rdma_msg(vf, msg, msglen);
+		break;
 	case VIRTCHNL_OP_UNKNOWN:
 	default:
 		dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
-- 
1.8.3.1

