Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB031179DD
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfLIWug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:50:36 -0500
Received: from mga12.intel.com ([192.55.52.136]:33714 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfLIWtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 17:49:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 14:49:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="237912289"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 09 Dec 2019 14:49:38 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH v3 03/20] ice: Implement peer communications
Date:   Mon,  9 Dec 2019 14:49:18 -0800
Message-Id: <20191209224935.1780117-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Set and implement operations for the peer device and peer driver to
communicate with each other, via iidc_ops and iidc_peer_ops, to request
resources and manage event notification.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  32 +
 drivers/net/ethernet/intel/ice/ice_common.c   | 188 ++++
 drivers/net/ethernet/intel/ice/ice_common.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  34 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 879 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  45 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  39 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  45 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |  69 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  27 +
 drivers/net/ethernet/intel/ice/ice_switch.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  25 -
 15 files changed, 1364 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 1f09e9b53106..dc341ab1bd71 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -292,6 +292,7 @@ struct ice_vsi {
 	u16 req_rxq;			 /* User requested Rx queues */
 	u16 num_rx_desc;
 	u16 num_tx_desc;
+	u16 qset_handle[ICE_MAX_TRAFFIC_CLASS];
 	struct ice_tc_cfg tc_cfg;
 	struct bpf_prog *xdp_prog;
 	struct ice_ring **xdp_rings;	 /* XDP ring array */
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index d413980f0370..2fe53f530517 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1526,6 +1526,36 @@ struct ice_aqc_dis_txq {
 	struct ice_aqc_dis_txq_item qgrps[1];
 };
 
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
+	struct ice_aqc_add_tx_rdma_qset_entry rdma_qsets[1];
+};
+
 /* Configure Firmware Logging Command (indirect 0xFF09)
  * Logging Information Read Response (indirect 0xFF10)
  * Note: The 0xFF10 command has no input parameters.
@@ -1714,6 +1744,7 @@ struct ice_aq_desc {
 		struct ice_aqc_get_set_rss_key get_set_rss_key;
 		struct ice_aqc_add_txqs add_txqs;
 		struct ice_aqc_dis_txqs dis_txqs;
+		struct ice_aqc_add_rdma_qset add_rdma_qset;
 		struct ice_aqc_add_get_update_free_vsi vsi_cmd;
 		struct ice_aqc_add_update_free_vsi_resp add_update_free_vsi_res;
 		struct ice_aqc_fw_logging fw_logging;
@@ -1847,6 +1878,7 @@ enum ice_adminq_opc {
 	/* Tx queue handling commands/events */
 	ice_aqc_opc_add_txqs				= 0x0C30,
 	ice_aqc_opc_dis_txqs				= 0x0C31,
+	ice_aqc_opc_add_rdma_qset			= 0x0C33,
 
 	/* package commands */
 	ice_aqc_opc_download_pkg			= 0x0C40,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 42ecb0d7063c..28958c0a762a 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3009,6 +3009,59 @@ ice_aq_dis_lan_txq(struct ice_hw *hw, u8 num_qgrps,
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
+	u16 i, sum_header_size, sum_q_size = 0;
+	struct ice_aqc_add_rdma_qset *cmd;
+	struct ice_aq_desc desc;
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
+	sum_header_size = num_qset_grps *
+		(sizeof(*qset_list) - sizeof(*qset_list->rdma_qsets));
+
+	list = qset_list;
+	for (i = 0; i < num_qset_grps; i++) {
+		struct ice_aqc_add_tx_rdma_qset_entry *qset = list->rdma_qsets;
+		u16 num_qsets = le16_to_cpu(list->num_qsets);
+
+		sum_q_size += num_qsets * sizeof(*qset);
+		list = (struct ice_aqc_add_rdma_qset_data *)
+			(qset + num_qsets);
+	}
+
+	if (buf_size != (sum_header_size + sum_q_size))
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
@@ -3480,6 +3533,141 @@ ice_cfg_vsi_lan(struct ice_port_info *pi, u16 vsi_handle, u8 tc_bitmap,
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
+ice_cfg_vsi_rdma(struct ice_port_info *pi, u16 vsi_handle, u8 tc_bitmap,
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
+	buf_size = sizeof(*buf) + sizeof(*buf->rdma_qsets) * (num_qsets - 1);
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
+						ICE_AQC_ELEM_VALID_GENERIC;
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
+	struct ice_aqc_dis_txq_item qg_list;
+	enum ice_status status = 0;
+	u16 qg_size;
+	int i;
+
+	if (!pi || pi->port_state != ICE_SCHED_PORT_STATE_READY)
+		return ICE_ERR_CFG;
+
+	qg_size = sizeof(qg_list);
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
+		qg_list.parent_teid = node->info.parent_teid;
+		qg_list.num_qs = 1;
+		qg_list.q_id[0] =
+			cpu_to_le16(q_id[i] |
+				    ICE_AQC_Q_DIS_BUF_ELEM_TYPE_RDMA_QSET);
+
+		status = ice_aq_dis_lan_txq(pi->hw, 1, &qg_list, qg_size,
+					    ICE_NO_RESET, 0, NULL);
+		if (status)
+			break;
+
+		ice_free_sched_node(pi, node);
+	}
+
+	mutex_unlock(&pi->sched_lock);
+	return status;
+}
+
 /**
  * ice_replay_pre_init - replay pre initialization
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index b22aa561e253..a6beebff1379 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -125,6 +125,15 @@ ice_aq_sff_eeprom(struct ice_hw *hw, u16 lport, u8 bus_addr,
 		  bool write, struct ice_sq_cd *cd);
 
 enum ice_status
+ice_cfg_vsi_rdma(struct ice_port_info *pi, u16 vsi_handle, u8 tc_bitmap,
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
index ec03038ea2ba..f950deef524b 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -148,6 +148,27 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_peer_prep_tc_change - Pre-notify RDMA Peer in blocking call of TC change
+ * @peer_dev_int: ptr to peer device internal struct
+ * @data: ptr to opaque data
+ */
+static int
+ice_peer_prep_tc_change(struct ice_peer_dev_int *peer_dev_int,
+			void __always_unused *data)
+{
+	struct iidc_peer_dev *peer_dev;
+
+	peer_dev = ice_get_peer_dev(peer_dev_int);
+	if (!ice_validate_peer_dev(peer_dev))
+		return 0;
+
+	if (peer_dev->peer_ops && peer_dev->peer_ops->prep_tc_change)
+		peer_dev->peer_ops->prep_tc_change(peer_dev);
+
+	return 0;
+}
+
 /**
  * ice_pf_dcb_cfg - Apply new DCB configuration
  * @pf: pointer to the PF struct
@@ -182,6 +203,9 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 		return ret;
 	}
 
+	/* Notify capable peers about impending change to TCs */
+	ice_for_each_peer(pf, NULL, ice_peer_prep_tc_change);
+
 	/* Store old config in case FW config fails */
 	old_cfg = kmemdup(curr_cfg, sizeof(*old_cfg), GFP_KERNEL);
 	if (!old_cfg)
@@ -536,6 +560,7 @@ static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
 void ice_pf_dcb_recfg(struct ice_pf *pf)
 {
 	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->local_dcbx_cfg;
+	struct iidc_event *event;
 	u8 tc_map = 0;
 	int v, ret;
 
@@ -571,6 +596,15 @@ void ice_pf_dcb_recfg(struct ice_pf *pf)
 		if (vsi->type == ICE_VSI_PF)
 			ice_dcbnl_set_all(vsi);
 	}
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return;
+
+	set_bit(IIDC_EVENT_TC_CHANGE, event->type);
+	event->reporter = NULL;
+	ice_setup_dcb_qos_info(pf, &event->info.port_qos);
+	ice_for_each_peer(pf, event, ice_peer_check_for_reg);
+	kfree(event);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 54783ae6511c..ca78c4e1f125 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -144,6 +144,60 @@ ice_peer_state_change(struct ice_peer_dev_int *peer_dev, long new_state,
 		mutex_unlock(&peer_dev->peer_dev_state_mutex);
 }
 
+/**
+ * ice_peer_close - close a peer device
+ * @peer_dev_int: device to close
+ * @data: pointer to opaque data
+ *
+ * This function will also set the state bit for the peer to CLOSED. This
+ * function is meant to be called from a ice_for_each_peer().
+ */
+int ice_peer_close(struct ice_peer_dev_int *peer_dev_int, void *data)
+{
+	enum iidc_close_reason reason = *(enum iidc_close_reason *)(data);
+	struct iidc_peer_dev *peer_dev;
+	struct ice_pf *pf;
+	int i;
+
+	peer_dev = ice_get_peer_dev(peer_dev_int);
+	/* return 0 so ice_for_each_peer will continue closing other peers */
+	if (!ice_validate_peer_dev(peer_dev))
+		return 0;
+	pf = pci_get_drvdata(peer_dev->pdev);
+
+	if (test_bit(__ICE_DOWN, pf->state) ||
+	    test_bit(__ICE_SUSPENDED, pf->state) ||
+	    test_bit(__ICE_NEEDS_RESTART, pf->state))
+		return 0;
+
+	mutex_lock(&peer_dev_int->peer_dev_state_mutex);
+
+	/* no peer driver, already closed, closing or opening nothing to do */
+	if (test_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev_int->state) ||
+	    test_bit(ICE_PEER_DEV_STATE_CLOSING, peer_dev_int->state) ||
+	    test_bit(ICE_PEER_DEV_STATE_OPENING, peer_dev_int->state) ||
+	    test_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev_int->state))
+		goto peer_close_out;
+
+	/* Set the peer state to CLOSING */
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_CLOSING, true);
+
+	for (i = 0; i < IIDC_EVENT_NBITS; i++)
+		bitmap_zero(peer_dev_int->current_events[i].type,
+			    IIDC_EVENT_NBITS);
+
+	if (peer_dev->peer_ops && peer_dev->peer_ops->close)
+		peer_dev->peer_ops->close(peer_dev, reason);
+
+	/* Set the peer state to CLOSED */
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_CLOSED, true);
+
+peer_close_out:
+	mutex_unlock(&peer_dev_int->peer_dev_state_mutex);
+
+	return 0;
+}
+
 /**
  * ice_peer_update_vsi - update the pf_vsi info in peer_dev struct
  * @peer_dev_int: pointer to peer dev internal struct
@@ -162,6 +216,106 @@ int ice_peer_update_vsi(struct ice_peer_dev_int *peer_dev_int, void *data)
 	return 0;
 }
 
+/**
+ * ice_close_peer_for_reset - queue work to close peer for reset
+ * @peer_dev_int: pointer peer dev internal struct
+ * @data: pointer to opaque data used for reset type
+ */
+int ice_close_peer_for_reset(struct ice_peer_dev_int *peer_dev_int, void *data)
+{
+	struct iidc_peer_dev *peer_dev;
+	enum ice_reset_req reset;
+
+	peer_dev = ice_get_peer_dev(peer_dev_int);
+	if (!ice_validate_peer_dev(peer_dev))
+		return 0;
+
+	reset = *(enum ice_reset_req *)data;
+
+	switch (reset) {
+	case ICE_RESET_GLOBR:
+		peer_dev_int->rst_type = IIDC_REASON_GLOBR_REQ;
+		break;
+	case ICE_RESET_CORER:
+		peer_dev_int->rst_type = IIDC_REASON_CORER_REQ;
+		break;
+	case ICE_RESET_PFR:
+		peer_dev_int->rst_type = IIDC_REASON_PFR_REQ;
+		break;
+	default:
+		/* reset type is invalid */
+		return 1;
+	}
+	queue_work(peer_dev_int->ice_peer_wq, &peer_dev_int->peer_close_task);
+	return 0;
+}
+
+/**
+ * ice_check_peer_drv_for_events - check peer_drv for events to report
+ * @peer_dev: peer device to report to
+ */
+static void ice_check_peer_drv_for_events(struct iidc_peer_dev *peer_dev)
+{
+	const struct iidc_peer_ops *p_ops = peer_dev->peer_ops;
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_drv_int *peer_drv_int;
+	int i;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return;
+	peer_drv_int = peer_dev_int->peer_drv_int;
+
+	for_each_set_bit(i, peer_dev_int->events, IIDC_EVENT_NBITS) {
+		struct iidc_event *curr = &peer_drv_int->current_events[i];
+
+		if (!bitmap_empty(curr->type, IIDC_EVENT_NBITS) &&
+		    p_ops->event_handler)
+			p_ops->event_handler(peer_dev, curr);
+	}
+}
+
+/**
+ * ice_check_peer_for_events - check peer_devs for events new peer reg'd for
+ * @src_peer_int: peer to check for events
+ * @data: ptr to opaque data, to be used for the peer struct that opened
+ *
+ * This function is to be called when a peer device is opened.
+ *
+ * Since a new peer opening would have missed any events that would
+ * have happened before its opening, we need to walk the peers and see
+ * if any of them have events that the new peer cares about
+ *
+ * This function is meant to be called by a device_for_each_child.
+ */
+static int
+ice_check_peer_for_events(struct ice_peer_dev_int *src_peer_int, void *data)
+{
+	struct iidc_peer_dev *new_peer = (struct iidc_peer_dev *)data;
+	const struct iidc_peer_ops *p_ops = new_peer->peer_ops;
+	struct ice_peer_dev_int *new_peer_int;
+	struct iidc_peer_dev *src_peer;
+	int i;
+
+	src_peer = ice_get_peer_dev(src_peer_int);
+	if (!ice_validate_peer_dev(new_peer) ||
+	    !ice_validate_peer_dev(src_peer))
+		return 0;
+
+	new_peer_int = peer_to_ice_dev_int(new_peer);
+
+	for_each_set_bit(i, new_peer_int->events, IIDC_EVENT_NBITS) {
+		struct iidc_event *curr = &src_peer_int->current_events[i];
+
+		if (!bitmap_empty(curr->type, IIDC_EVENT_NBITS) &&
+		    new_peer->peer_dev_id != src_peer->peer_dev_id &&
+		    p_ops->event_handler)
+			p_ops->event_handler(new_peer, curr);
+	}
+
+	return 0;
+}
+
 /**
  * ice_for_each_peer - iterate across and call function for each peer dev
  * @pf: pointer to private board struct
@@ -192,6 +346,92 @@ ice_for_each_peer(struct ice_pf *pf, void *data,
 	return 0;
 }
 
+/**
+ * ice_finish_init_peer_device - complete peer device initialization
+ * @peer_dev_int: ptr to peer device internal struct
+ * @data: ptr to opaque data
+ *
+ * This function completes remaining initialization of peer_devices
+ */
+int
+ice_finish_init_peer_device(struct ice_peer_dev_int *peer_dev_int,
+			    void __always_unused *data)
+{
+	struct iidc_peer_dev *peer_dev;
+	struct iidc_peer_drv *peer_drv;
+	struct device *dev;
+	struct ice_pf *pf;
+	int ret = 0;
+
+	peer_dev = ice_get_peer_dev(peer_dev_int);
+	/* peer_dev will not always be populated at the time of this check */
+	if (!ice_validate_peer_dev(peer_dev))
+		return ret;
+
+	peer_drv = peer_dev->peer_drv;
+	pf = pci_get_drvdata(peer_dev->pdev);
+	dev = ice_pf_to_dev(pf);
+	/* There will be several assessments of the peer_dev's state in this
+	 * chunk of logic.  We need to hold the peer_dev_int's state mutex
+	 * for the entire part so that the flow progresses without another
+	 * context changing things mid-flow
+	 */
+	mutex_lock(&peer_dev_int->peer_dev_state_mutex);
+
+	if (!peer_dev->peer_ops) {
+		dev_err(dev, "peer_ops not defined on peer dev\n");
+		goto init_unlock;
+	}
+
+	if (!peer_dev->peer_ops->open) {
+		dev_err(dev, "peer_ops:open not defined on peer dev\n");
+		goto init_unlock;
+	}
+
+	if (!peer_dev->peer_ops->close) {
+		dev_err(dev, "peer_ops:close not defined on peer dev\n");
+		goto init_unlock;
+	}
+
+	/* Peer driver expected to set driver_id during registration */
+	if (!peer_drv->driver_id) {
+		dev_err(dev, "Peer driver did not set driver_id\n");
+		goto init_unlock;
+	}
+
+	if ((test_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev_int->state) ||
+	     test_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev_int->state)) &&
+	    ice_pf_state_is_nominal(pf)) {
+		/* If the RTNL is locked, we defer opening the peer
+		 * until the next time this function is called by the
+		 * service task.
+		 */
+		if (rtnl_is_locked())
+			goto init_unlock;
+		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_OPENING,
+				      true);
+		ret = peer_dev->peer_ops->open(peer_dev);
+		if (ret) {
+			dev_err(dev, "Peer %d failed to open\n",
+				peer_dev->peer_dev_id);
+			ice_peer_state_change(peer_dev_int,
+					      ICE_PEER_DEV_STATE_PROBED, true);
+			goto init_unlock;
+		}
+
+		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_OPENED,
+				      true);
+		ret = ice_for_each_peer(pf, peer_dev,
+					ice_check_peer_for_events);
+		ice_check_peer_drv_for_events(peer_dev);
+	}
+
+init_unlock:
+	mutex_unlock(&peer_dev_int->peer_dev_state_mutex);
+
+	return ret;
+}
+
 /**
  * ice_unreg_peer_device - unregister specified device
  * @peer_dev_int: ptr to peer device internal
@@ -274,6 +514,607 @@ ice_unroll_peer(struct ice_peer_dev_int *peer_dev_int,
 	return 0;
 }
 
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
+ * ice_peer_alloc_rdma_qsets - Allocate Leaf Nodes for RDMA Qset
+ * @peer_dev: peer that is requesting the Leaf Nodes
+ * @res: Resources to be allocated
+ * @partial_acceptable: If partial allocation is acceptable to the peer
+ *
+ * This function allocates Leaf Nodes for given RDMA Qset resources
+ * for the peer device.
+ */
+static int
+ice_peer_alloc_rdma_qsets(struct iidc_peer_dev *peer_dev, struct iidc_res *res,
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
+	if (!ice_validate_peer_dev(peer_dev) || !res)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	dev = ice_pf_to_dev(pf);
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
+		if (qset->vsi_id != peer_dev->pf_vsi_num) {
+			dev_err(dev, "RDMA QSet invalid VSI requested\n");
+			ret = -EINVAL;
+			goto out;
+		}
+		max_rdmaqs[qset->tc]++;
+		qs_handle[i] = qset->qs_handle;
+	}
+
+	vsi = ice_find_vsi(pf, peer_dev->pf_vsi_num);
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
+ * @peer_dev: peer that requested qsets to be freed
+ * @res: Resource to be freed
+ */
+static int
+ice_peer_free_rdma_qsets(struct iidc_peer_dev *peer_dev, struct iidc_res *res)
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
+	if (!ice_validate_peer_dev(peer_dev) || !res)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
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
+ * ice_peer_alloc_res - Allocate requested resources for peer device
+ * @peer_dev: peer that is requesting resources
+ * @res: Resources to be allocated
+ * @partial_acceptable: If partial allocation is acceptable to the peer
+ *
+ * This function allocates requested resources for the peer device.
+ */
+static int
+ice_peer_alloc_res(struct iidc_peer_dev *peer_dev, struct iidc_res *res,
+		   int partial_acceptable)
+{
+	struct ice_pf *pf;
+	int ret;
+
+	if (!ice_validate_peer_dev(peer_dev) || !res)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (!ice_pf_state_is_nominal(pf))
+		return -EBUSY;
+
+	switch (res->res_type) {
+	case IIDC_RDMA_QSETS_TXSCHED:
+		ret = ice_peer_alloc_rdma_qsets(peer_dev, res,
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
+ * @peer_dev: peer that is requesting freeing of resources
+ * @res: Resources to be freed
+ *
+ * Free/Release resources allocated to given peer device.
+ */
+static int
+ice_peer_free_res(struct iidc_peer_dev *peer_dev, struct iidc_res *res)
+{
+	int ret;
+
+	if (!ice_validate_peer_dev(peer_dev) || !res)
+		return -EINVAL;
+
+	switch (res->res_type) {
+	case IIDC_RDMA_QSETS_TXSCHED:
+		ret = ice_peer_free_rdma_qsets(peer_dev, res);
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
+ * @peer_dev: peer that is registering for event notifications
+ * @events: mask of event types peer is registering for
+ */
+static void
+ice_peer_reg_for_notif(struct iidc_peer_dev *peer_dev,
+		       struct iidc_event *events)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_pf *pf;
+
+	if (!ice_validate_peer_dev(peer_dev) || !events)
+		return;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	pf = pci_get_drvdata(peer_dev->pdev);
+
+	bitmap_or(peer_dev_int->events, peer_dev_int->events, events->type,
+		  IIDC_EVENT_NBITS);
+
+	/* Check to see if any events happened previous to peer registering */
+	ice_for_each_peer(pf, peer_dev, ice_check_peer_for_events);
+	ice_check_peer_drv_for_events(peer_dev);
+}
+
+/**
+ * ice_peer_unreg_for_notif - unreg a peer from receiving certain notifications
+ * @peer_dev: peer that is unregistering from event notifications
+ * @events: mask of event types peer is unregistering for
+ */
+static void
+ice_peer_unreg_for_notif(struct iidc_peer_dev *peer_dev,
+			 struct iidc_event *events)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+
+	if (!ice_validate_peer_dev(peer_dev) || !events)
+		return;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+
+	bitmap_andnot(peer_dev_int->events, peer_dev_int->events, events->type,
+		      IIDC_EVENT_NBITS);
+}
+
+/**
+ * ice_peer_check_for_reg - check to see if any peers are reg'd for event
+ * @peer_dev_int: ptr to peer device internal struct
+ * @data: ptr to opaque data, to be used for ice_event to report
+ *
+ * This function is to be called by device_for_each_child to handle an
+ * event reported by a peer or the ice driver.
+ */
+int ice_peer_check_for_reg(struct ice_peer_dev_int *peer_dev_int, void *data)
+{
+	struct iidc_event *event = (struct iidc_event *)data;
+	DECLARE_BITMAP(comp_events, IIDC_EVENT_NBITS);
+	struct iidc_peer_dev *peer_dev;
+	bool check = true;
+
+	peer_dev = ice_get_peer_dev(peer_dev_int);
+
+	if (!ice_validate_peer_dev(peer_dev) || !data)
+	/* If invalid dev, in this case return 0 instead of error
+	 * because caller ignores this return value
+	 */
+		return 0;
+
+	if (event->reporter)
+		check = event->reporter->peer_dev_id != peer_dev->peer_dev_id;
+
+	if (bitmap_and(comp_events, event->type, peer_dev_int->events,
+		       IIDC_EVENT_NBITS) &&
+	    (test_bit(ICE_PEER_DEV_STATE_OPENED, peer_dev_int->state) ||
+	     test_bit(ICE_PEER_DEV_STATE_PREP_RST, peer_dev_int->state) ||
+	     test_bit(ICE_PEER_DEV_STATE_PREPPED, peer_dev_int->state)) &&
+	    check &&
+	    peer_dev->peer_ops->event_handler)
+		peer_dev->peer_ops->event_handler(peer_dev, event);
+
+	return 0;
+}
+
+/**
+ * ice_peer_report_state_change - accept report of a peer state change
+ * @peer_dev: peer that is sending notification about state change
+ * @event: ice_event holding info on what the state change is
+ *
+ * We also need to parse the list of peers to see if anyone is registered
+ * for notifications about this state change event, and if so, notify them.
+ */
+static void
+ice_peer_report_state_change(struct iidc_peer_dev *peer_dev,
+			     struct iidc_event *event)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_drv_int *peer_drv_int;
+	int e_type, drv_event = 0;
+	struct ice_pf *pf;
+
+	if (!ice_validate_peer_dev(peer_dev) || !event)
+		return;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	peer_drv_int = peer_dev_int->peer_drv_int;
+
+	e_type = find_first_bit(event->type, IIDC_EVENT_NBITS);
+	if (!e_type)
+		return;
+
+	switch (e_type) {
+	/* Check for peer_drv events */
+	case IIDC_EVENT_MBX_CHANGE:
+		drv_event = 1;
+		if (event->info.mbx_rdy)
+			set_bit(ICE_PEER_DRV_STATE_MBX_RDY,
+				peer_drv_int->state);
+		else
+			clear_bit(ICE_PEER_DRV_STATE_MBX_RDY,
+				  peer_drv_int->state);
+		break;
+
+	/* Check for peer_dev events */
+	case IIDC_EVENT_API_CHANGE:
+		if (event->info.api_rdy)
+			set_bit(ICE_PEER_DEV_STATE_API_RDY,
+				peer_dev_int->state);
+		else
+			clear_bit(ICE_PEER_DEV_STATE_API_RDY,
+				  peer_dev_int->state);
+		break;
+
+	default:
+		return;
+	}
+
+	/* store the event and state to notify any new peers opening */
+	if (drv_event)
+		memcpy(&peer_drv_int->current_events[e_type], event,
+		       sizeof(*event));
+	else
+		memcpy(&peer_dev_int->current_events[e_type], event,
+		       sizeof(*event));
+
+	ice_for_each_peer(pf, event, ice_peer_check_for_reg);
+}
+
+/**
+ * ice_peer_unregister - request to unregister peer
+ * @peer_dev: peer device
+ *
+ * This function triggers close/remove on peer_dev allowing peer
+ * to unregister.
+ */
+static int ice_peer_unregister(struct iidc_peer_dev *peer_dev)
+{
+	enum iidc_close_reason reason = IIDC_REASON_PEER_DEV_UNINIT;
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_pf *pf;
+	int ret;
+
+	if (!ice_validate_peer_dev(peer_dev))
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (ice_is_reset_in_progress(pf->state))
+		return -EBUSY;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+
+	ret = ice_peer_close(peer_dev_int, &reason);
+	if (ret)
+		return ret;
+
+	peer_dev->peer_ops = NULL;
+
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_REMOVED, false);
+
+	module_put(THIS_MODULE);
+
+	return 0;
+}
+
+/**
+ * ice_peer_register - Called by peer to open communication with LAN
+ * @peer_dev: ptr to peer device
+ *
+ * registering peer is expected to populate the ice_peerdrv->name field
+ * before calling this function.
+ */
+static int ice_peer_register(struct iidc_peer_dev *peer_dev)
+{
+	struct ice_peer_drv_int *peer_drv_int;
+	struct ice_peer_dev_int *peer_dev_int;
+	struct iidc_peer_drv *peer_drv;
+
+	if (!peer_dev) {
+		pr_err("Failed to reg peer dev: peer_dev ptr NULL\n");
+		return -EINVAL;
+	}
+
+	if (!peer_dev->pdev) {
+		pr_err("Failed to reg peer dev: peer dev pdev NULL\n");
+		return -EINVAL;
+	}
+
+	if (!peer_dev->peer_ops || !peer_dev->ops) {
+		pr_err("Failed to reg peer dev: peer dev peer_ops/ops NULL\n");
+		return -EINVAL;
+	}
+
+	peer_drv = peer_dev->peer_drv;
+	if (!peer_drv) {
+		pr_err("Failed to reg peer dev: peer drv NULL\n");
+		return -EINVAL;
+	}
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	peer_drv_int = peer_dev_int->peer_drv_int;
+	if (!peer_drv_int) {
+		pr_err("Failed to match peer_drv_int to peer_dev\n");
+		return -EINVAL;
+	}
+
+	peer_drv_int->peer_drv = peer_drv;
+
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_PROBED, false);
+
+	if (!try_module_get(THIS_MODULE)) {
+		pr_err("Failed to increment module use count\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_peer_request_reset - accept request from peer to perform a reset
+ * @peer_dev: peer device that is request a reset
+ * @reset_type: type of reset the peer is requesting
+ */
+static int
+ice_peer_request_reset(struct iidc_peer_dev *peer_dev,
+		       enum iidc_peer_reset_type reset_type)
+{
+	enum ice_reset_req reset;
+	struct ice_pf *pf;
+
+	if (!ice_validate_peer_dev(peer_dev))
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
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
+ * @peer_dev: pointer to iidc_peer_dev struct
+ */
+static int ice_peer_is_vsi_ready(struct iidc_peer_dev *peer_dev)
+{
+	DECLARE_BITMAP(check_bits, __ICE_STATE_NBITS) = { 0 };
+	struct ice_netdev_priv *np;
+	struct ice_vsi *vsi;
+
+	/* If the peer_dev or associated values are not valid, then return
+	 * 0 as there is no ready port associated with the values passed in
+	 * as parameters.
+	 */
+
+	if (!ice_validate_peer_dev(peer_dev))
+		return 0;
+
+	if (!peer_dev->netdev)
+		return 0;
+
+	np = netdev_priv(peer_dev->netdev);
+	vsi = np->vsi;
+	if (!vsi)
+		return 0;
+
+	bitmap_set(check_bits, 0, __ICE_STATE_NOMINAL_CHECK_BITS);
+	if (bitmap_intersects(vsi->state, check_bits, __ICE_STATE_NBITS))
+		return 0;
+
+	return 1;
+}
+
+/**
+ * ice_peer_update_vsi_filter - update main VSI filters for RDMA
+ * @peer_dev: pointer to RDMA peer device
+ * @filter: selection of filters to enable or disable
+ * @enable: bool whether to enable or disable filters
+ */
+static int
+ice_peer_update_vsi_filter(struct iidc_peer_dev *peer_dev,
+			   enum iidc_rdma_filter __always_unused filter,
+			   bool enable)
+{
+	struct ice_vsi *vsi;
+	struct ice_pf *pf;
+	int ret;
+
+	if (!ice_validate_peer_dev(peer_dev))
+		return -EINVAL;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi)
+		return -EINVAL;
+
+	ret = ice_cfg_iwarp_fltr(&pf->hw, vsi->idx, enable);
+
+	if (ret) {
+		dev_err(ice_pf_to_dev(pf), "Failed to  %sable iWARP filtering\n",
+			enable ? "en" : "dis");
+	} else {
+		if (enable)
+			vsi->info.q_opt_flags |= ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
+		else
+			vsi->info.q_opt_flags &= ~ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
+	}
+
+	return ret;
+}
+
+/* Initialize the ice_ops struct, which is used in 'ice_init_peer_devices' */
+static const struct iidc_ops ops = {
+	.alloc_res			= ice_peer_alloc_res,
+	.free_res			= ice_peer_free_res,
+	.is_vsi_ready			= ice_peer_is_vsi_ready,
+	.reg_for_notification		= ice_peer_reg_for_notif,
+	.unreg_for_notification		= ice_peer_unreg_for_notif,
+	.notify_state_change		= ice_peer_report_state_change,
+	.request_reset			= ice_peer_request_reset,
+	.peer_register			= ice_peer_register,
+	.peer_unregister		= ice_peer_unregister,
+	.update_vsi_filter		= ice_peer_update_vsi_filter,
+};
+
 /**
  * ice_reserve_peer_qvector - Reserve vector resources for peer drivers
  * @pf: board private structure to initialize
@@ -293,6 +1134,41 @@ static int ice_reserve_peer_qvector(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_peer_close_task - call peer's close asynchronously
+ * @work: pointer to work_struct contained by the peer_dev_int struct
+ *
+ * This method (asynchronous) of calling a peer's close function is
+ * meant to be used in the reset path.
+ */
+static void ice_peer_close_task(struct work_struct *work)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct iidc_peer_dev *peer_dev;
+
+	peer_dev_int = container_of(work, struct ice_peer_dev_int,
+				    peer_close_task);
+
+	peer_dev = ice_get_peer_dev(peer_dev_int);
+	if (!peer_dev || !peer_dev->peer_ops)
+		return;
+
+	/* If this peer_dev is going to close, we do not want any state changes
+	 * to happen until after we successfully finish or abort the close.
+	 * Grab the peer_dev_state_mutex to protect this flow
+	 */
+	mutex_lock(&peer_dev_int->peer_dev_state_mutex);
+
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_CLOSING, true);
+
+	if (peer_dev->peer_ops->close)
+		peer_dev->peer_ops->close(peer_dev, peer_dev_int->rst_type);
+
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_CLOSED, true);
+
+	mutex_unlock(&peer_dev_int->peer_dev_state_mutex);
+}
+
 /**
  * ice_init_peer_devices - initializes peer devices
  * @pf: ptr to ice_pf
@@ -356,6 +1232,7 @@ int ice_init_peer_devices(struct ice_pf *pf)
 						i);
 		if (!peer_dev_int->ice_peer_wq)
 			return -ENOMEM;
+		INIT_WORK(&peer_dev_int->peer_close_task, ice_peer_close_task);
 
 		peer_dev->pdev = pdev;
 		qos_info = &peer_dev->initial_qos_info;
@@ -373,6 +1250,8 @@ int ice_init_peer_devices(struct ice_pf *pf)
 
 		/* for DCB, override the qos_info defaults. */
 		ice_setup_dcb_qos_info(pf, qos_info);
+		/* Initialize ice_ops */
+		peer_dev->ops = &ops;
 
 		/* make sure peer specific resources such as msix_count and
 		 * msix_entries are initialized
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
index bba5a925aefb..b08935b289aa 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc_int.h
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -65,8 +65,27 @@ struct ice_peer_dev_int {
 };
 
 int ice_peer_update_vsi(struct ice_peer_dev_int *peer_dev_int, void *data);
+int ice_close_peer_for_reset(struct ice_peer_dev_int *peer_dev_int, void *data);
 int ice_unroll_peer(struct ice_peer_dev_int *peer_dev_int, void *data);
 int ice_unreg_peer_device(struct ice_peer_dev_int *peer_dev_int, void *data);
+int ice_peer_close(struct ice_peer_dev_int *peer_dev_int, void *data);
+int ice_peer_check_for_reg(struct ice_peer_dev_int *peer_dev_int, void *data);
+int
+ice_finish_init_peer_device(struct ice_peer_dev_int *peer_dev_int, void *data);
+
+static inline struct
+ice_peer_dev_int *peer_to_ice_dev_int(struct iidc_peer_dev *peer_dev)
+{
+	struct iidc_virtbus_object *vobj;
+
+	if (peer_dev)
+		vobj = container_of(peer_dev, struct iidc_virtbus_object,
+				    peer_dev);
+	else
+		return NULL;
+
+	return  container_of(vobj, struct ice_peer_dev_int, vobj);
+}
 
 static inline struct
 iidc_peer_dev *ice_get_peer_dev(struct ice_peer_dev_int *peer_dev_int)
@@ -76,4 +95,30 @@ iidc_peer_dev *ice_get_peer_dev(struct ice_peer_dev_int *peer_dev_int)
 	else
 		return NULL;
 }
+
+static inline bool ice_validate_peer_dev(struct iidc_peer_dev *peer_dev)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_pf *pf;
+
+	if (!peer_dev || !peer_dev->pdev)
+		return false;
+
+	if (!peer_dev->peer_ops)
+		return false;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (!pf)
+		return false;
+
+	peer_dev_int = peer_to_ice_dev_int(peer_dev);
+	if (!peer_dev_int)
+		return false;
+
+	if (test_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev_int->state) ||
+	    test_bit(ICE_PEER_DEV_STATE_INIT, peer_dev_int->state))
+		return false;
+
+	return true;
+}
 #endif /* !_ICE_IDC_INT_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 1456eed1b3b9..f4b4a1dcd643 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1119,6 +1119,30 @@ int ice_add_mac_to_list(struct ice_vsi *vsi, struct list_head *add_list,
 	return 0;
 }
 
+/**
+ * ice_pf_state_is_nominal - checks the PF for nominal state
+ * @pf: pointer to PF to check
+ *
+ * Check the PF's state for a collection of bits that would indicate
+ * the PF is in a state that would inhibit normal operation for
+ * driver functionality.
+ *
+ * Returns true if PF is in a nominal state, false otherwise
+ */
+bool ice_pf_state_is_nominal(struct ice_pf *pf)
+{
+	DECLARE_BITMAP(check_bits, __ICE_STATE_NBITS) = { 0 };
+
+	if (!pf)
+		return false;
+
+	bitmap_set(check_bits, 0, __ICE_STATE_NOMINAL_CHECK_BITS);
+	if (bitmap_intersects(pf->state, check_bits, __ICE_STATE_NBITS))
+		return false;
+
+	return true;
+}
+
 /**
  * ice_update_eth_stats - Update VSI-specific ethernet statistics counters
  * @vsi: the VSI to be updated
@@ -2109,6 +2133,21 @@ void ice_vsi_free_rx_rings(struct ice_vsi *vsi)
  */
 void ice_vsi_close(struct ice_vsi *vsi)
 {
+	enum iidc_close_reason reason = IIDC_REASON_INTERFACE_DOWN;
+
+	if (test_bit(__ICE_CORER_REQ, vsi->back->state))
+		reason = IIDC_REASON_CORER_REQ;
+	if (test_bit(__ICE_GLOBR_REQ, vsi->back->state))
+		reason = IIDC_REASON_GLOBR_REQ;
+	if (test_bit(__ICE_PFR_REQ, vsi->back->state))
+		reason = IIDC_REASON_PFR_REQ;
+	if (!ice_is_safe_mode(vsi->back) && vsi->type == ICE_VSI_PF) {
+		int ret = ice_for_each_peer(vsi->back, &reason, ice_peer_close);
+
+		if (ret)
+			dev_dbg(ice_pf_to_dev(vsi->back), "Peer device did not implement close function\n");
+	}
+
 	if (!test_and_set_bit(__ICE_DOWN, vsi->state))
 		ice_down(vsi);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 502c05c1e84b..1cb8513fcf1f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -14,6 +14,8 @@ ice_add_mac_to_list(struct ice_vsi *vsi, struct list_head *add_list,
 
 void ice_free_fltr_list(struct device *dev, struct list_head *h);
 
+bool ice_pf_state_is_nominal(struct ice_pf *pf);
+
 void ice_update_eth_stats(struct ice_vsi *vsi);
 
 int ice_vsi_cfg_rxqs(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 950c213a8802..d8809a5c07d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -558,6 +558,9 @@ static void ice_reset_subtask(struct ice_pf *pf)
 		/* return if no valid reset type requested */
 		if (reset_type == ICE_RESET_INVAL)
 			return;
+		if (ice_is_peer_ena(pf))
+			ice_for_each_peer(pf, &reset_type,
+					  ice_close_peer_for_reset);
 		ice_prepare_for_reset(pf);
 
 		/* make sure we are ready to rebuild */
@@ -1491,6 +1494,9 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
+	/* Invoke remaining initialization of peer devices */
+	ice_for_each_peer(pf, NULL, ice_finish_init_peer_device);
+
 	ice_process_vflr_event(pf);
 	ice_clean_mailboxq_subtask(pf);
 
@@ -3441,6 +3447,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 static void ice_remove(struct pci_dev *pdev)
 {
 	struct ice_pf *pf = pci_get_drvdata(pdev);
+	enum iidc_close_reason reason;
 	int i;
 
 	if (!pf)
@@ -3452,13 +3459,20 @@ static void ice_remove(struct pci_dev *pdev)
 		msleep(100);
 	}
 
-	set_bit(__ICE_DOWN, pf->state);
 	ice_service_task_stop(pf);
+	if (ice_is_peer_ena(pf)) {
+		reason = IIDC_REASON_INTERFACE_DOWN;
+		ice_for_each_peer(pf, &reason, ice_peer_close);
+	}
+	set_bit(__ICE_DOWN, pf->state);
 
 	if (test_bit(ICE_FLAG_SRIOV_ENA, pf->flags))
 		ice_free_vfs(pf);
 	ice_vsi_release_all(pf);
-	ice_for_each_peer(pf, NULL, ice_unreg_peer_device);
+	if (ice_is_peer_ena(pf)) {
+		ice_for_each_peer(pf, NULL, ice_unreg_peer_device);
+		devm_kfree(&pdev->dev, pf->peers);
+	}
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
 		if (!pf->vsi[i])
@@ -4825,7 +4839,9 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct iidc_event *event;
 	u8 count = 0;
+	int err = 0;
 
 	if (new_mtu == netdev->mtu) {
 		netdev_warn(netdev, "MTU is already %u\n", netdev->mtu);
@@ -4867,27 +4883,40 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EBUSY;
 	}
 
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
 	netdev->mtu = new_mtu;
 
 	/* if VSI is up, bring it down and then back up */
 	if (!test_and_set_bit(__ICE_DOWN, vsi->state)) {
-		int err;
-
 		err = ice_down(vsi);
 		if (err) {
-			netdev_err(netdev, "change MTU if_up err %d\n", err);
-			return err;
+			netdev_err(netdev, "change MTU if_down err %d\n", err);
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
+	event->info.mtu = new_mtu;
+	ice_for_each_peer(pf, event, ice_peer_check_for_reg);
+
+out:
 	netdev_info(netdev, "changed MTU to %d\n", new_mtu);
-	return 0;
+free_event:
+	kfree(event);
+	return err;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index eae707ddf8e8..2f618d051b56 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -577,6 +577,50 @@ ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
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
@@ -1599,13 +1643,22 @@ ice_sched_update_vsi_child_nodes(struct ice_port_info *pi, u16 vsi_handle,
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
@@ -1620,7 +1673,10 @@ ice_sched_update_vsi_child_nodes(struct ice_port_info *pi, u16 vsi_handle,
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
@@ -1686,6 +1742,7 @@ ice_sched_cfg_vsi(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 maxqs,
 		 * recreate the child nodes all the time in these cases.
 		 */
 		vsi_ctx->sched.max_lanq[tc] = 0;
+		vsi_ctx->sched.max_rdmaq[tc] = 0;
 	}
 
 	/* update the VSI child nodes */
@@ -1817,6 +1874,8 @@ ice_sched_rm_vsi_cfg(struct ice_port_info *pi, u16 vsi_handle, u8 owner)
 		}
 		if (owner == ICE_SCHED_NODE_OWNER_LAN)
 			vsi_ctx->sched.max_lanq[i] = 0;
+		else
+			vsi_ctx->sched.max_rdmaq[i] = 0;
 	}
 	status = 0;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index b5a53f862a83..990b65aed039 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -346,6 +346,10 @@ static void ice_clear_vsi_q_ctx(struct ice_hw *hw, u16 vsi_handle)
 			devm_kfree(ice_hw_to_dev(hw), vsi->lan_q_ctx[i]);
 			vsi->lan_q_ctx[i] = NULL;
 		}
+		if (vsi->rdma_q_ctx[i]) {
+			devm_kfree(ice_hw_to_dev(hw), vsi->rdma_q_ctx[i]);
+			vsi->rdma_q_ctx[i] = NULL;
+		}
 	}
 }
 
@@ -466,6 +470,29 @@ ice_update_vsi(struct ice_hw *hw, u16 vsi_handle, struct ice_vsi_ctx *vsi_ctx,
 	return ice_aq_update_vsi(hw, vsi_ctx, cd);
 }
 
+/**
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
 /**
  * ice_aq_alloc_free_vsi_list
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index fa14b9545dab..acd2f150c30b 100644
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
@@ -220,6 +222,8 @@ void ice_remove_vsi_fltr(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status
 ice_add_vlan(struct ice_hw *hw, struct list_head *m_list);
 enum ice_status ice_remove_vlan(struct ice_hw *hw, struct list_head *v_list);
+enum ice_status
+ice_cfg_iwarp_fltr(struct ice_hw *hw, u16 vsi_handle, bool enable);
 
 /* Promisc/defport setup for VSIs */
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index e73784e093c5..060dc95b660d 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -43,6 +43,7 @@ static inline u32 ice_round_to_num(u32 N, u32 R)
 #define ICE_DBG_LAN		BIT_ULL(8)
 #define ICE_DBG_SW		BIT_ULL(13)
 #define ICE_DBG_SCHED		BIT_ULL(14)
+#define ICE_DBG_RDMA		BIT_ULL(15)
 #define ICE_DBG_PKG		BIT_ULL(16)
 #define ICE_DBG_RES		BIT_ULL(17)
 #define ICE_DBG_AQ_MSG		BIT_ULL(24)
@@ -271,6 +272,7 @@ struct ice_sched_node {
 	u8 tc_num;
 	u8 owner;
 #define ICE_SCHED_NODE_OWNER_LAN	0
+#define ICE_SCHED_NODE_OWNER_RDMA	2
 };
 
 /* Access Macros for Tx Sched Elements data */
@@ -342,6 +344,7 @@ struct ice_sched_vsi_info {
 	struct ice_sched_node *ag_node[ICE_MAX_TRAFFIC_CLASS];
 	struct list_head list_entry;
 	u16 max_lanq[ICE_MAX_TRAFFIC_CLASS];
+	u16 max_rdmaq[ICE_MAX_TRAFFIC_CLASS];
 };
 
 /* driver defines the policy */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index edb374296d1f..0004117bc192 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1420,31 +1420,6 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 	return ret;
 }
 
-/**
- * ice_pf_state_is_nominal - checks the PF for nominal state
- * @pf: pointer to PF to check
- *
- * Check the PF's state for a collection of bits that would indicate
- * the PF is in a state that would inhibit normal operation for
- * driver functionality.
- *
- * Returns true if PF is in a nominal state.
- * Returns false otherwise
- */
-static bool ice_pf_state_is_nominal(struct ice_pf *pf)
-{
-	DECLARE_BITMAP(check_bits, __ICE_STATE_NBITS) = { 0 };
-
-	if (!pf)
-		return false;
-
-	bitmap_set(check_bits, 0, __ICE_STATE_NOMINAL_CHECK_BITS);
-	if (bitmap_intersects(pf->state, check_bits, __ICE_STATE_NBITS))
-		return false;
-
-	return true;
-}
-
 /**
  * ice_pci_sriov_ena - Enable or change number of VFs
  * @pf: pointer to the PF structure
-- 
2.23.0

