Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F190A346E08
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 01:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhCXADz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 20:03:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:37587 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234348AbhCXADX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 20:03:23 -0400
IronPort-SDR: +JQsI1A++1kn6f+VV68XCJ0W5PsIx1NSiOimM99Tw/aqZeSJWj3RiUMbjTkjyGVy4o1PocS3CQ
 +GTizE/tbrzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="170556548"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="170556548"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 17:03:23 -0700
IronPort-SDR: 4tAJpTYCCWUVZ3a4o46Nt7TrQ9uvZ8JgrfPCAY4dIJmKBCzcR6PL5tnxuFVjp1i+bXmq7m4btb
 nfczmqDYKAvg==
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381542194"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.103.207])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 17:03:21 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v2 03/23] ice: Implement iidc operations
Date:   Tue, 23 Mar 2021 18:59:47 -0500
Message-Id: <20210324000007.1450-4-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210324000007.1450-1-shiraz.saleem@intel.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Add implementations for supporting iidc operations for device operation
such as allocation of resources and event notifications.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h             |   1 +
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h  |  32 ++
 drivers/net/ethernet/intel/ice/ice_common.c      | 200 +++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h      |   9 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c     |  25 +-
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h  |   3 +-
 drivers/net/ethernet/intel/ice/ice_idc.c         | 439 +++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h     |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c        |  50 ++-
 drivers/net/ethernet/intel/ice/ice_sched.c       |  69 +++-
 drivers/net/ethernet/intel/ice/ice_switch.c      |  27 ++
 drivers/net/ethernet/intel/ice/ice_switch.h      |   4 +
 drivers/net/ethernet/intel/ice/ice_type.h        |   3 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |  34 ++
 14 files changed, 876 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index ebd2159..561f8fd 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -327,6 +327,7 @@ struct ice_vsi {
 	u16 req_rxq;			 /* User requested Rx queues */
 	u16 num_rx_desc;
 	u16 num_tx_desc;
+	u16 qset_handle[ICE_MAX_TRAFFIC_CLASS];
 	struct ice_tc_cfg tc_cfg;
 	struct bpf_prog *xdp_prog;
 	struct ice_ring **xdp_rings;	 /* XDP ring array */
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 81735e5..8a07bed 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1684,6 +1684,36 @@ struct ice_aqc_dis_txq_item {
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
@@ -1879,6 +1909,7 @@ struct ice_aq_desc {
 		struct ice_aqc_get_set_rss_key get_set_rss_key;
 		struct ice_aqc_add_txqs add_txqs;
 		struct ice_aqc_dis_txqs dis_txqs;
+		struct ice_aqc_add_rdma_qset add_rdma_qset;
 		struct ice_aqc_add_get_update_free_vsi vsi_cmd;
 		struct ice_aqc_add_update_free_vsi_resp add_update_free_vsi_res;
 		struct ice_aqc_fw_logging fw_logging;
@@ -2027,6 +2058,7 @@ enum ice_adminq_opc {
 	/* Tx queue handling commands/events */
 	ice_aqc_opc_add_txqs				= 0x0C30,
 	ice_aqc_opc_dis_txqs				= 0x0C31,
+	ice_aqc_opc_add_rdma_qset			= 0x0C33,
 
 	/* package commands */
 	ice_aqc_opc_download_pkg			= 0x0C40,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index d7b15c3..b98c3c5 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3577,6 +3577,54 @@ enum ice_status
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
@@ -4075,6 +4123,158 @@ enum ice_status
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
index baf4064..fbd9421 100644
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
index 3aebfa8..ce04445 100644
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
 
+	/* Notify aux drivers about impending change to TCs */
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	set_bit(IIDC_EVENT_BEFORE_TC_CHANGE, event->type);
+	ice_send_event_to_auxs(pf, event);
+	kfree(event);
+
 	/* avoid race conditions by holding the lock while disabling and
 	 * re-enabling the VSI
 	 */
@@ -676,9 +686,22 @@ void ice_pf_dcb_recfg(struct ice_pf *pf)
 		if (vsi->type == ICE_VSI_PF)
 			ice_dcbnl_set_all(vsi);
 	}
+	/* Notify the aux drivers that TC change is finished */
 	rcdi = ice_find_cdev_info_by_id(pf, IIDC_RDMA_ID);
-	if (rcdi)
+	if (rcdi) {
+		struct iidc_event *event;
+
 		ice_setup_dcb_qos_info(pf, &rcdi->qos_info);
+
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (!event)
+			return;
+
+		set_bit(IIDC_EVENT_AFTER_TC_CHANGE, event->type);
+		event->info.port_qos = rcdi->qos_info;
+		ice_send_event_to_auxs(pf, event);
+		kfree(event);
+	}
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 093a181..b544290 100644
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
@@ -159,6 +157,7 @@
 #define PFINT_OICR_GRST_M			BIT(20)
 #define PFINT_OICR_PCI_EXCEPTION_M		BIT(21)
 #define PFINT_OICR_HMC_ERR_M			BIT(26)
+#define PFINT_OICR_PE_PUSH_M			BIT(27)
 #define PFINT_OICR_PE_CRITERR_M			BIT(28)
 #define PFINT_OICR_VFLR_M			BIT(29)
 #define PFINT_OICR_SWINT_M			BIT(31)
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index ef54cf7..916c356 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -11,6 +11,34 @@
 static struct cdev_info_id ice_cdev_ids[] = ASSIGN_IIDC_INFO;
 
 /**
+ * ice_get_auxiliary_ops - retrieve iidc_auxiliary_ops struct
+ * @cdev_info: pointer to iidc_core_dev_info struct
+ *
+ * This function has to be called with a device_lock on the
+ * cdev_info->adev.dev to avoid race conditions.
+ */
+struct iidc_auxiliary_ops *
+ice_get_auxiliary_ops(struct iidc_core_dev_info *cdev_info)
+{
+	struct iidc_auxiliary_drv *iadrv;
+	struct auxiliary_device *adev;
+
+	if (!cdev_info)
+		return NULL;
+
+	adev = cdev_info->adev;
+	if (!adev || !adev->dev.driver)
+		return NULL;
+
+	iadrv = container_of(adev->dev.driver, struct iidc_auxiliary_drv,
+			     adrv.driver);
+	if (!iadrv)
+		return NULL;
+
+	return iadrv->ops;
+}
+
+/**
  * ice_for_each_aux - iterate across and call function for each aux driver
  * @pf: pointer to private board struct
  * @data: data to pass to function on each call
@@ -41,6 +69,40 @@
 }
 
 /**
+ * ice_send_event_to_aux - send event to a specific aux driver
+ * @cdev_info: pointer to iidc_core_dev_info struct for this aux
+ * @data: opaque pointer used to pass event struct
+ *
+ * This function is only meant to be called through a ice_for_each_aux call
+ */
+static int
+ice_send_event_to_aux(struct iidc_core_dev_info *cdev_info, void *data)
+{
+	struct iidc_event *event = data;
+	struct iidc_auxiliary_ops *ops;
+
+	device_lock(&cdev_info->adev->dev);
+	ops = ice_get_auxiliary_ops(cdev_info);
+	if (ops && ops->event_handler)
+		ops->event_handler(cdev_info, event);
+	device_unlock(&cdev_info->adev->dev);
+
+	return 0;
+}
+
+/**
+ * ice_send_event_to_auxs - send event to all auxiliary drivers
+ * @pf: pointer to pf struct
+ * @event: pointer to iidc_event to propagate
+ *
+ * event struct to be populated by caller
+ */
+int ice_send_event_to_auxs(struct ice_pf *pf, struct iidc_event *event)
+{
+	return ice_for_each_aux(pf, event, ice_send_event_to_aux);
+}
+
+/**
  * ice_unroll_cdev_info - destroy cdev_info resources
  * @cdev_info: ptr to cdev_info struct
  * @data: ptr to opaque data
@@ -90,6 +152,371 @@ void ice_cdev_info_refresh_msix(struct ice_pf *pf)
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
+ * ice_alloc_rdma_qsets - Allocate Leaf Nodes for RDMA Qset
+ * @cdev_info: aux driver that is requesting the Leaf Nodes
+ * @res: Resources to be allocated
+ * @partial_acceptable: If partial allocation is acceptable
+ *
+ * This function allocates Leaf Nodes for given RDMA Qset resources
+ * for the aux object.
+ */
+static int
+ice_alloc_rdma_qsets(struct iidc_core_dev_info *cdev_info,
+		     struct iidc_res *res,
+		     int __always_unused partial_acceptable)
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
+	if (!cdev_info || !res)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(cdev_info->pdev);
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
+		if (qset->vport_id != cdev_info->vport_id) {
+			dev_err(dev, "RDMA QSet invalid VSI requested\n");
+			ret = -EINVAL;
+			goto out;
+		}
+		max_rdmaqs[qset->tc]++;
+		qs_handle[i] = qset->qs_handle;
+	}
+
+	vsi = ice_find_vsi(pf, cdev_info->vport_id);
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
+ * ice_free_rdma_qsets - Free leaf nodes for RDMA Qset
+ * @cdev_info: aux driver that requested qsets to be freed
+ * @res: Resource to be freed
+ */
+static int
+ice_free_rdma_qsets(struct iidc_core_dev_info *cdev_info, struct iidc_res *res)
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
+	if (!cdev_info || !res)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(cdev_info->pdev);
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
+	vsi_id = res->res[0].res.qsets.vport_id;
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
+		if (qset->vport_id != vsi_id) {
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
+ * ice_cdev_info_alloc_res - Allocate requested resources for aux objects
+ * @cdev_info: struct for aux driver that is requesting resources
+ * @res: Resources to be allocated
+ * @partial_acceptable: If partial allocation is acceptable
+ *
+ * This function allocates requested resources for the aux object.
+ */
+static int
+ice_cdev_info_alloc_res(struct iidc_core_dev_info *cdev_info,
+			struct iidc_res *res, int partial_acceptable)
+{
+	struct ice_pf *pf;
+	int ret;
+
+	if (!cdev_info || !res)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(cdev_info->pdev);
+	if (!ice_pf_state_is_nominal(pf))
+		return -EBUSY;
+
+	switch (res->res_type) {
+	case IIDC_RDMA_QSETS_TXSCHED:
+		ret = ice_alloc_rdma_qsets(cdev_info, res, partial_acceptable);
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
+ * ice_cdev_info_free_res - Free given resources
+ * @cdev_info: struct for aux driver that is requesting freeing of resources
+ * @res: Resources to be freed
+ *
+ * Free/Release resources allocated to given aux objects.
+ */
+static int
+ice_cdev_info_free_res(struct iidc_core_dev_info *cdev_info,
+		       struct iidc_res *res)
+{
+	int ret;
+
+	if (!cdev_info || !res)
+		return -EINVAL;
+
+	switch (res->res_type) {
+	case IIDC_RDMA_QSETS_TXSCHED:
+		ret = ice_free_rdma_qsets(cdev_info, res);
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
+ * ice_cdev_info_request_reset - accept request from aux driver to perform a reset
+ * @cdev_info: struct for aux driver that is requesting a reset
+ * @reset_type: type of reset the aux driver is requesting
+ */
+static int
+ice_cdev_info_request_reset(struct iidc_core_dev_info *cdev_info,
+			    enum iidc_reset_type reset_type)
+{
+	enum ice_reset_req reset;
+	struct ice_pf *pf;
+
+	if (!cdev_info)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(cdev_info->pdev);
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
+		dev_err(ice_pf_to_dev(pf), "incorrect reset request from aux driver\n");
+		return -EINVAL;
+	}
+
+	return ice_schedule_reset(pf, reset);
+}
+
+/**
+ * ice_cdev_info_update_vsi_filter - update main VSI filters for RDMA
+ * @cdev_info: pointer to struct for aux device updating filters
+ * @vsi_id: VSI HW idx to update filter on
+ * @enable: bool whether to enable or disable filters
+ */
+static int
+ice_cdev_info_update_vsi_filter(struct iidc_core_dev_info *cdev_info,
+				u16 vsi_id, bool enable)
+{
+	enum ice_status status;
+	struct ice_vsi *vsi;
+	struct ice_pf *pf;
+
+	if (!cdev_info)
+		return -EINVAL;
+
+	pf = pci_get_drvdata(cdev_info->pdev);
+
+	vsi = ice_find_vsi(pf, vsi_id);
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
+ * ice_cdev_info_vc_send - send a virt channel message from an aux driver
+ * @cdev_info: pointer to cdev_info struct for aux driver
+ * @vf_id: the absolute VF ID of recipient of message
+ * @msg: pointer to message contents
+ * @len: len of message
+ */
+static int
+ice_cdev_info_vc_send(struct iidc_core_dev_info *cdev_info, u32 vf_id, u8 *msg,
+		      u16 len)
+{
+	enum ice_status status;
+	struct ice_pf *pf;
+
+	if (!cdev_info)
+		return -EINVAL;
+	if (!msg || !len)
+		return -ENOMEM;
+
+	pf = pci_get_drvdata(cdev_info->pdev);
+	if (len > ICE_AQ_MAX_BUF_LEN)
+		return -EINVAL;
+
+	if (ice_is_reset_in_progress(pf->state))
+		return -EBUSY;
+
+	switch (cdev_info->cdev_info_id) {
+	case IIDC_RDMA_ID:
+		if (vf_id >= pf->num_alloc_vfs)
+			return -ENODEV;
+
+		/* VIRTCHNL_OP_IWARP is being used for RoCEv2 msg also */
+		status = ice_aq_send_msg_to_vf(&pf->hw, vf_id, VIRTCHNL_OP_IWARP,
+					       0, msg, len, NULL);
+		break;
+	default:
+		dev_err(ice_pf_to_dev(pf), "aux driver (%i) not supported!",
+			cdev_info->cdev_info_id);
+		return -ENODEV;
+	}
+
+	if (status)
+		dev_err(ice_pf_to_dev(pf), "Unable to send msg to VF, error %s\n",
+			ice_stat_str(status));
+	return ice_status_to_errno(status);
+}
+
+/**
  * ice_reserve_cdev_info_qvector - Reserve vector resources for aux drivers
  * @pf: board private structure to initialize
  */
@@ -146,6 +573,16 @@ int ice_cdev_info_update_vsi(struct iidc_core_dev_info *cdev_info, void *data)
 	return 0;
 }
 
+/* Initialize the ice_ops struct, which is used in 'ice_init_aux_devices' */
+static const struct iidc_core_ops ops = {
+	.alloc_res			= ice_cdev_info_alloc_res,
+	.free_res			= ice_cdev_info_free_res,
+	.request_reset			= ice_cdev_info_request_reset,
+	.update_vport_filter		= ice_cdev_info_update_vsi_filter,
+	.vc_send			= ice_cdev_info_vc_send,
+
+};
+
 /**
  * ice_init_aux_devices - initializes cdev_info objects and aux devices
  * @pf: ptr to ice_pf
@@ -208,6 +645,8 @@ int ice_init_aux_devices(struct ice_pf *pf)
 
 		/* for DCB, override the qos_info defaults. */
 		ice_setup_dcb_qos_info(pf, qos_info);
+		/* Initialize ice_ops */
+		cdev_info->ops = &ops;
 
 		/* make sure aux specific resources such as msix_count and
 		 * msix_entries are initialized
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
index 67b63c6..ce100ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc_int.h
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -9,6 +9,9 @@
 
 struct ice_pf;
 
+int ice_send_event_to_auxs(struct ice_pf *pf, struct iidc_event *event);
+struct iidc_auxiliary_ops *
+ice_get_auxiliary_ops(struct iidc_core_dev_info *cdev_info);
 int ice_cdev_info_update_vsi(struct iidc_core_dev_info *cdev_info, void *data);
 int ice_unroll_cdev_info(struct iidc_core_dev_info *cdev_info, void *data);
 struct iidc_core_dev_info *
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f569d58..2913770 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2607,6 +2607,7 @@ static void ice_ena_misc_vector(struct ice_pf *pf)
 	       PFINT_OICR_PCI_EXCEPTION_M |
 	       PFINT_OICR_VFLR_M |
 	       PFINT_OICR_HMC_ERR_M |
+	       PFINT_OICR_PE_PUSH_M |
 	       PFINT_OICR_PE_CRITERR_M);
 
 	wr32(hw, PFINT_OICR_ENA, val);
@@ -2677,8 +2678,6 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 
 		/* If a reset cycle isn't already in progress, we set a bit in
 		 * pf->state so that the service task can start a reset/rebuild.
-		 * We also make note of which reset happened so that peer
-		 * devices/drivers can be informed.
 		 */
 		if (!test_and_set_bit(__ICE_RESET_OICR_RECV, pf->state)) {
 			if (reset == ICE_RESET_CORER)
@@ -2705,11 +2704,19 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
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
+			/* report the entire OICR value to aux driver */
+			event->info.reg = oicr;
+			ice_send_event_to_auxs(pf, event);
+			kfree(event);
+		}
 	}
 
 	/* Report any remaining unexpected interrupts */
@@ -2719,8 +2726,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		/* If a critical error is pending there is no choice but to
 		 * reset the device.
 		 */
-		if (oicr & (PFINT_OICR_PE_CRITERR_M |
-			    PFINT_OICR_PCI_EXCEPTION_M |
+		if (oicr & (PFINT_OICR_PCI_EXCEPTION_M |
 			    PFINT_OICR_ECC_ERR_M)) {
 			set_bit(__ICE_PFR_REQ, pf->state);
 			ice_service_task_schedule(pf);
@@ -4454,10 +4460,11 @@ static void ice_remove(struct pci_dev *pdev)
 		ice_free_vfs(pf);
 	}
 
-	set_bit(__ICE_DOWN, pf->state);
 	ice_service_task_stop(pf);
 
 	ice_aq_cancel_waiting_tasks(pf);
+	ice_for_each_aux(pf, NULL, ice_unroll_cdev_info);
+	set_bit(__ICE_DOWN, pf->state);
 
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 	ice_deinit_lag(pf);
@@ -6224,7 +6231,9 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	struct iidc_event *event;
 	u8 count = 0;
+	int err = 0;
 
 	if (new_mtu == (int)netdev->mtu) {
 		netdev_warn(netdev, "MTU is already %u\n", netdev->mtu);
@@ -6257,27 +6266,38 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EBUSY;
 	}
 
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	set_bit(IIDC_EVENT_BEFORE_MTU_CHANGE, event->type);
+	ice_send_event_to_auxs(pf, event);
+	clear_bit(IIDC_EVENT_BEFORE_MTU_CHANGE, event->type);
+
 	netdev->mtu = (unsigned int)new_mtu;
 
 	/* if VSI is up, bring it down and then back up */
 	if (!test_and_set_bit(__ICE_DOWN, vsi->state)) {
-		int err;
-
 		err = ice_down(vsi);
 		if (err) {
 			netdev_err(netdev, "change MTU if_down err %d\n", err);
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
 
 	netdev_dbg(netdev, "changed MTU to %d\n", new_mtu);
-	return 0;
+free_event:
+	set_bit(IIDC_EVENT_AFTER_MTU_CHANGE, event->type);
+	ice_send_event_to_auxs(pf, event);
+	kfree(event);
+
+	return err;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 2403cb3..c30e7d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -596,6 +596,50 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
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
@@ -1749,13 +1793,22 @@ struct ice_sched_node *
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
@@ -1770,7 +1823,10 @@ struct ice_sched_node *
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
@@ -1836,6 +1892,7 @@ enum ice_status
 		 * recreate the child nodes all the time in these cases.
 		 */
 		vsi_ctx->sched.max_lanq[tc] = 0;
+		vsi_ctx->sched.max_rdmaq[tc] = 0;
 	}
 
 	/* update the VSI child nodes */
@@ -1965,6 +2022,8 @@ static bool ice_sched_is_leaf_node_present(struct ice_sched_node *node)
 		}
 		if (owner == ICE_SCHED_NODE_OWNER_LAN)
 			vsi_ctx->sched.max_lanq[i] = 0;
+		else
+			vsi_ctx->sched.max_rdmaq[i] = 0;
 	}
 	status = 0;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 67c965a..ebb8453 100644
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
index 4eaab60..0b77358 100644
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
@@ -423,6 +424,7 @@ struct ice_sched_node {
 	u8 tc_num;
 	u8 owner;
 #define ICE_SCHED_NODE_OWNER_LAN	0
+#define ICE_SCHED_NODE_OWNER_RDMA	2
 };
 
 /* Access Macros for Tx Sched Elements data */
@@ -494,6 +496,7 @@ struct ice_sched_vsi_info {
 	struct ice_sched_node *ag_node[ICE_MAX_TRAFFIC_CLASS];
 	struct list_head list_entry;
 	u16 max_lanq[ICE_MAX_TRAFFIC_CLASS];
+	u16 max_rdmaq[ICE_MAX_TRAFFIC_CLASS];
 };
 
 /* driver defines the policy */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 1f38a8d..fa70abb 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3680,6 +3680,37 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
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
+	struct iidc_core_dev_info *rcdi;
+	struct iidc_auxiliary_ops *ops;
+	int ret = 0;
+
+	rcdi = ice_find_cdev_info_by_id(vf->pf, IIDC_RDMA_ID);
+	if (!rcdi) {
+		pr_err("VF attempted to send message to invalid RDMA driver\n");
+		return -EIO;
+	}
+
+	device_lock(&rcdi->adev->dev);
+	ops = ice_get_auxiliary_ops(rcdi);
+	if (ops && ops->vc_receive)
+		ret = ops->vc_receive(rcdi, vf->vf_id, msg, len);
+	device_unlock(&rcdi->adev->dev);
+	if (ret)
+		pr_err("Failed to send message to RDMA driver, error %d\n", ret);
+
+	return ret;
+}
+
+/**
  * ice_vf_init_vlan_stripping - enable/disable VLAN stripping on initialization
  * @vf: VF to enable/disable VLAN stripping for on initialization
  *
@@ -3816,6 +3847,9 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
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

