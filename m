Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CE41160E
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfEBJGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:47592 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfEBJGX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615330"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] ice: Create framework for VSI queue context
Date:   Thu,  2 May 2019 02:06:06 -0700
Message-Id: <20190502090620.21281-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

This patch introduces a framework to store queue specific information
in VSI queue contexts. Currently VSI queue context (represented by
struct ice_q_ctx) only has q_handle as a member. In future patches,
this structure will be updated to hold queue specific information.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 62 +++++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h   | 11 ++-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 99 +++++++++++--------
 drivers/net/ethernet/intel/ice/ice_sched.c    | 54 +++++++++-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 22 +++++
 drivers/net/ethernet/intel/ice/ice_switch.h   |  9 ++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  4 +-
 7 files changed, 205 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2937c6be1aee..dce07882f7e1 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2790,11 +2790,36 @@ ice_set_ctx(u8 *src_ctx, u8 *dest_ctx, const struct ice_ctx_ele *ce_info)
 	return 0;
 }
 
+/**
+ * ice_get_lan_q_ctx - get the LAN queue context for the given VSI and TC
+ * @hw: pointer to the HW struct
+ * @vsi_handle: software VSI handle
+ * @tc: TC number
+ * @q_handle: software queue handle
+ */
+static struct ice_q_ctx *
+ice_get_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 q_handle)
+{
+	struct ice_vsi_ctx *vsi;
+	struct ice_q_ctx *q_ctx;
+
+	vsi = ice_get_vsi_ctx(hw, vsi_handle);
+	if (!vsi)
+		return NULL;
+	if (q_handle >= vsi->num_lan_q_entries[tc])
+		return NULL;
+	if (!vsi->lan_q_ctx[tc])
+		return NULL;
+	q_ctx = vsi->lan_q_ctx[tc];
+	return &q_ctx[q_handle];
+}
+
 /**
  * ice_ena_vsi_txq
  * @pi: port information structure
  * @vsi_handle: software VSI handle
  * @tc: TC number
+ * @q_handle: software queue handle
  * @num_qgrps: Number of added queue groups
  * @buf: list of queue groups to be added
  * @buf_size: size of buffer for indirect command
@@ -2803,12 +2828,13 @@ ice_set_ctx(u8 *src_ctx, u8 *dest_ctx, const struct ice_ctx_ele *ce_info)
  * This function adds one LAN queue
  */
 enum ice_status
-ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_qgrps,
-		struct ice_aqc_add_tx_qgrp *buf, u16 buf_size,
+ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 q_handle,
+		u8 num_qgrps, struct ice_aqc_add_tx_qgrp *buf, u16 buf_size,
 		struct ice_sq_cd *cd)
 {
 	struct ice_aqc_txsched_elem_data node = { 0 };
 	struct ice_sched_node *parent;
+	struct ice_q_ctx *q_ctx;
 	enum ice_status status;
 	struct ice_hw *hw;
 
@@ -2825,6 +2851,14 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_qgrps,
 
 	mutex_lock(&pi->sched_lock);
 
+	q_ctx = ice_get_lan_q_ctx(hw, vsi_handle, tc, q_handle);
+	if (!q_ctx) {
+		ice_debug(hw, ICE_DBG_SCHED, "Enaq: invalid queue handle %d\n",
+			  q_handle);
+		status = ICE_ERR_PARAM;
+		goto ena_txq_exit;
+	}
+
 	/* find a parent node */
 	parent = ice_sched_get_free_qparent(pi, vsi_handle, tc,
 					    ICE_SCHED_NODE_OWNER_LAN);
@@ -2851,7 +2885,7 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_qgrps,
 	/* add the LAN queue */
 	status = ice_aq_add_lan_txq(hw, num_qgrps, buf, buf_size, cd);
 	if (status) {
-		ice_debug(hw, ICE_DBG_SCHED, "enable Q %d failed %d\n",
+		ice_debug(hw, ICE_DBG_SCHED, "enable queue %d failed %d\n",
 			  le16_to_cpu(buf->txqs[0].txq_id),
 			  hw->adminq.sq_last_status);
 		goto ena_txq_exit;
@@ -2859,6 +2893,7 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_qgrps,
 
 	node.node_teid = buf->txqs[0].q_teid;
 	node.data.elem_type = ICE_AQC_ELEM_TYPE_LEAF;
+	q_ctx->q_handle = q_handle;
 
 	/* add a leaf node into schduler tree queue layer */
 	status = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1, &node);
@@ -2871,7 +2906,10 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_qgrps,
 /**
  * ice_dis_vsi_txq
  * @pi: port information structure
+ * @vsi_handle: software VSI handle
+ * @tc: TC number
  * @num_queues: number of queues
+ * @q_handles: pointer to software queue handle array
  * @q_ids: pointer to the q_id array
  * @q_teids: pointer to queue node teids
  * @rst_src: if called due to reset, specifies the reset source
@@ -2881,12 +2919,14 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_qgrps,
  * This function removes queues and their corresponding nodes in SW DB
  */
 enum ice_status
-ice_dis_vsi_txq(struct ice_port_info *pi, u8 num_queues, u16 *q_ids,
-		u32 *q_teids, enum ice_disq_rst_src rst_src, u16 vmvf_num,
+ice_dis_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_queues,
+		u16 *q_handles, u16 *q_ids, u32 *q_teids,
+		enum ice_disq_rst_src rst_src, u16 vmvf_num,
 		struct ice_sq_cd *cd)
 {
 	enum ice_status status = ICE_ERR_DOES_NOT_EXIST;
 	struct ice_aqc_dis_txq_item qg_list;
+	struct ice_q_ctx *q_ctx;
 	u16 i;
 
 	if (!pi || pi->port_state != ICE_SCHED_PORT_STATE_READY)
@@ -2909,6 +2949,17 @@ ice_dis_vsi_txq(struct ice_port_info *pi, u8 num_queues, u16 *q_ids,
 		node = ice_sched_find_node_by_teid(pi->root, q_teids[i]);
 		if (!node)
 			continue;
+		q_ctx = ice_get_lan_q_ctx(pi->hw, vsi_handle, tc, q_handles[i]);
+		if (!q_ctx) {
+			ice_debug(pi->hw, ICE_DBG_SCHED, "invalid queue handle%d\n",
+				  q_handles[i]);
+			continue;
+		}
+		if (q_ctx->q_handle != q_handles[i]) {
+			ice_debug(pi->hw, ICE_DBG_SCHED, "Err:handles %d %d\n",
+				  q_ctx->q_handle, q_handles[i]);
+			continue;
+		}
 		qg_list.parent_teid = node->info.parent_teid;
 		qg_list.num_qs = 1;
 		qg_list.q_id[0] = cpu_to_le16(q_ids[i]);
@@ -2919,6 +2970,7 @@ ice_dis_vsi_txq(struct ice_port_info *pi, u8 num_queues, u16 *q_ids,
 		if (status)
 			break;
 		ice_free_sched_node(pi, node);
+		q_ctx->q_handle = ICE_INVAL_Q_HANDLE;
 	}
 	mutex_unlock(&pi->sched_lock);
 	return status;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index faefc45e4a1e..f1ddebf45231 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -99,15 +99,16 @@ ice_aq_set_port_id_led(struct ice_port_info *pi, bool is_orig_mode,
 		       struct ice_sq_cd *cd);
 
 enum ice_status
-ice_dis_vsi_txq(struct ice_port_info *pi, u8 num_queues, u16 *q_ids,
-		u32 *q_teids, enum ice_disq_rst_src rst_src, u16 vmvf_num,
-		struct ice_sq_cd *cmd_details);
+ice_dis_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_queues,
+		u16 *q_handle, u16 *q_ids, u32 *q_teids,
+		enum ice_disq_rst_src rst_src, u16 vmvf_num,
+		struct ice_sq_cd *cd);
 enum ice_status
 ice_cfg_vsi_lan(struct ice_port_info *pi, u16 vsi_handle, u8 tc_bitmap,
 		u16 *max_lanqs);
 enum ice_status
-ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_qgrps,
-		struct ice_aqc_add_tx_qgrp *buf, u16 buf_size,
+ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 q_handle,
+		u8 num_qgrps, struct ice_aqc_add_tx_qgrp *buf, u16 buf_size,
 		struct ice_sq_cd *cd);
 enum ice_status ice_replay_vsi(struct ice_hw *hw, u16 vsi_handle);
 void ice_replay_post(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index f31129e4e9cf..fa8ebd8a10ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1715,8 +1715,8 @@ ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings, int offset)
 			rings[q_idx]->tail =
 				pf->hw.hw_addr + QTX_COMM_DBELL(pf_q);
 			status = ice_ena_vsi_txq(vsi->port_info, vsi->idx, tc,
-						 num_q_grps, qg_buf, buf_len,
-						 NULL);
+						 i, num_q_grps, qg_buf,
+						 buf_len, NULL);
 			if (status) {
 				dev_err(&vsi->back->pdev->dev,
 					"Failed to set LAN Tx queue context, error: %d\n",
@@ -2033,10 +2033,10 @@ ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 {
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
+	int tc, q_idx = 0, err = 0;
+	u16 *q_ids, *q_handles, i;
 	enum ice_status status;
 	u32 *q_teids, val;
-	u16 *q_ids, i;
-	int err = 0;
 
 	if (vsi->num_txq > ICE_LAN_TXQ_MAX_QDIS)
 		return -EINVAL;
@@ -2053,50 +2053,71 @@ ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 		goto err_alloc_q_ids;
 	}
 
-	/* set up the Tx queue list to be disabled */
-	ice_for_each_txq(vsi, i) {
-		u16 v_idx;
+	q_handles = devm_kcalloc(&pf->pdev->dev, vsi->num_txq,
+				 sizeof(*q_handles), GFP_KERNEL);
+	if (!q_handles) {
+		err = -ENOMEM;
+		goto err_alloc_q_handles;
+	}
 
-		if (!rings || !rings[i] || !rings[i]->q_vector) {
-			err = -EINVAL;
-			goto err_out;
-		}
+	/* set up the Tx queue list to be disabled for each enabled TC */
+	ice_for_each_traffic_class(tc) {
+		if (!(vsi->tc_cfg.ena_tc & BIT(tc)))
+			break;
+
+		for (i = 0; i < vsi->tc_cfg.tc_info[tc].qcount_tx; i++) {
+			u16 v_idx;
+
+			if (!rings || !rings[i] || !rings[i]->q_vector) {
+				err = -EINVAL;
+				goto err_out;
+			}
 
-		q_ids[i] = vsi->txq_map[i + offset];
-		q_teids[i] = rings[i]->txq_teid;
+			q_ids[i] = vsi->txq_map[q_idx + offset];
+			q_teids[i] = rings[q_idx]->txq_teid;
+			q_handles[i] = i;
 
-		/* clear cause_ena bit for disabled queues */
-		val = rd32(hw, QINT_TQCTL(rings[i]->reg_idx));
-		val &= ~QINT_TQCTL_CAUSE_ENA_M;
-		wr32(hw, QINT_TQCTL(rings[i]->reg_idx), val);
+			/* clear cause_ena bit for disabled queues */
+			val = rd32(hw, QINT_TQCTL(rings[i]->reg_idx));
+			val &= ~QINT_TQCTL_CAUSE_ENA_M;
+			wr32(hw, QINT_TQCTL(rings[i]->reg_idx), val);
 
-		/* software is expected to wait for 100 ns */
-		ndelay(100);
+			/* software is expected to wait for 100 ns */
+			ndelay(100);
 
-		/* trigger a software interrupt for the vector associated to
-		 * the queue to schedule NAPI handler
+			/* trigger a software interrupt for the vector
+			 * associated to the queue to schedule NAPI handler
+			 */
+			v_idx = rings[i]->q_vector->v_idx;
+			wr32(hw, GLINT_DYN_CTL(vsi->hw_base_vector + v_idx),
+			     GLINT_DYN_CTL_SWINT_TRIG_M |
+			     GLINT_DYN_CTL_INTENA_MSK_M);
+			q_idx++;
+		}
+		status = ice_dis_vsi_txq(vsi->port_info, vsi->idx, tc,
+					 vsi->num_txq, q_handles, q_ids,
+					 q_teids, rst_src, rel_vmvf_num, NULL);
+
+		/* if the disable queue command was exercised during an active
+		 * reset flow, ICE_ERR_RESET_ONGOING is returned. This is not
+		 * an error as the reset operation disables queues at the
+		 * hardware level anyway.
 		 */
-		v_idx = rings[i]->q_vector->v_idx;
-		wr32(hw, GLINT_DYN_CTL(vsi->hw_base_vector + v_idx),
-		     GLINT_DYN_CTL_SWINT_TRIG_M | GLINT_DYN_CTL_INTENA_MSK_M);
-	}
-	status = ice_dis_vsi_txq(vsi->port_info, vsi->num_txq, q_ids, q_teids,
-				 rst_src, rel_vmvf_num, NULL);
-	/* if the disable queue command was exercised during an active reset
-	 * flow, ICE_ERR_RESET_ONGOING is returned. This is not an error as
-	 * the reset operation disables queues at the hardware level anyway.
-	 */
-	if (status == ICE_ERR_RESET_ONGOING) {
-		dev_info(&pf->pdev->dev,
-			 "Reset in progress. LAN Tx queues already disabled\n");
-	} else if (status) {
-		dev_err(&pf->pdev->dev,
-			"Failed to disable LAN Tx queues, error: %d\n",
-			status);
-		err = -ENODEV;
+		if (status == ICE_ERR_RESET_ONGOING) {
+			dev_dbg(&pf->pdev->dev,
+				"Reset in progress. LAN Tx queues already disabled\n");
+		} else if (status) {
+			dev_err(&pf->pdev->dev,
+				"Failed to disable LAN Tx queues, error: %d\n",
+				status);
+			err = -ENODEV;
+		}
 	}
 
 err_out:
+	devm_kfree(&pf->pdev->dev, q_handles);
+
+err_alloc_q_handles:
 	devm_kfree(&pf->pdev->dev, q_ids);
 
 err_alloc_q_ids:
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 124feaf0e730..8d49f83be7a5 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -532,6 +532,50 @@ ice_sched_suspend_resume_elems(struct ice_hw *hw, u8 num_nodes, u32 *node_teids,
 	return status;
 }
 
+/**
+ * ice_alloc_lan_q_ctx - allocate LAN queue contexts for the given VSI and TC
+ * @hw: pointer to the HW struct
+ * @vsi_handle: VSI handle
+ * @tc: TC number
+ * @new_numqs: number of queues
+ */
+static enum ice_status
+ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
+{
+	struct ice_vsi_ctx *vsi_ctx;
+	struct ice_q_ctx *q_ctx;
+
+	vsi_ctx = ice_get_vsi_ctx(hw, vsi_handle);
+	if (!vsi_ctx)
+		return ICE_ERR_PARAM;
+	/* allocate LAN queue contexts */
+	if (!vsi_ctx->lan_q_ctx[tc]) {
+		vsi_ctx->lan_q_ctx[tc] = devm_kcalloc(ice_hw_to_dev(hw),
+						      new_numqs,
+						      sizeof(*q_ctx),
+						      GFP_KERNEL);
+		if (!vsi_ctx->lan_q_ctx[tc])
+			return ICE_ERR_NO_MEMORY;
+		vsi_ctx->num_lan_q_entries[tc] = new_numqs;
+		return 0;
+	}
+	/* num queues are increased, update the queue contexts */
+	if (new_numqs > vsi_ctx->num_lan_q_entries[tc]) {
+		u16 prev_num = vsi_ctx->num_lan_q_entries[tc];
+
+		q_ctx = devm_kcalloc(ice_hw_to_dev(hw), new_numqs,
+				     sizeof(*q_ctx), GFP_KERNEL);
+		if (!q_ctx)
+			return ICE_ERR_NO_MEMORY;
+		memcpy(q_ctx, vsi_ctx->lan_q_ctx[tc],
+		       prev_num * sizeof(*q_ctx));
+		devm_kfree(ice_hw_to_dev(hw), vsi_ctx->lan_q_ctx[tc]);
+		vsi_ctx->lan_q_ctx[tc] = q_ctx;
+		vsi_ctx->num_lan_q_entries[tc] = new_numqs;
+	}
+	return 0;
+}
+
 /**
  * ice_sched_clear_agg - clears the aggregator related information
  * @hw: pointer to the hardware structure
@@ -1403,14 +1447,14 @@ ice_sched_update_vsi_child_nodes(struct ice_port_info *pi, u16 vsi_handle,
 	if (!vsi_ctx)
 		return ICE_ERR_PARAM;
 
-	if (owner == ICE_SCHED_NODE_OWNER_LAN)
-		prev_numqs = vsi_ctx->sched.max_lanq[tc];
-	else
-		return ICE_ERR_PARAM;
-
+	prev_numqs = vsi_ctx->sched.max_lanq[tc];
 	/* num queues are not changed or less than the previous number */
 	if (new_numqs <= prev_numqs)
 		return status;
+	status = ice_alloc_lan_q_ctx(hw, vsi_handle, tc, new_numqs);
+	if (status)
+		return status;
+
 	if (new_numqs)
 		ice_sched_calc_vsi_child_nodes(hw, new_numqs, new_num_nodes);
 	/* Keep the max number of queue configuration all the time. Update the
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index ad6bb0fce5d1..81f44939c859 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -328,6 +328,27 @@ ice_save_vsi_ctx(struct ice_hw *hw, u16 vsi_handle, struct ice_vsi_ctx *vsi)
 	hw->vsi_ctx[vsi_handle] = vsi;
 }
 
+/**
+ * ice_clear_vsi_q_ctx - clear VSI queue contexts for all TCs
+ * @hw: pointer to the HW struct
+ * @vsi_handle: VSI handle
+ */
+static void ice_clear_vsi_q_ctx(struct ice_hw *hw, u16 vsi_handle)
+{
+	struct ice_vsi_ctx *vsi;
+	u8 i;
+
+	vsi = ice_get_vsi_ctx(hw, vsi_handle);
+	if (!vsi)
+		return;
+	ice_for_each_traffic_class(i) {
+		if (vsi->lan_q_ctx[i]) {
+			devm_kfree(ice_hw_to_dev(hw), vsi->lan_q_ctx[i]);
+			vsi->lan_q_ctx[i] = NULL;
+		}
+	}
+}
+
 /**
  * ice_clear_vsi_ctx - clear the VSI context entry
  * @hw: pointer to the HW struct
@@ -341,6 +362,7 @@ static void ice_clear_vsi_ctx(struct ice_hw *hw, u16 vsi_handle)
 
 	vsi = ice_get_vsi_ctx(hw, vsi_handle);
 	if (vsi) {
+		ice_clear_vsi_q_ctx(hw, vsi_handle);
 		devm_kfree(ice_hw_to_dev(hw), vsi);
 		hw->vsi_ctx[vsi_handle] = NULL;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 64a2fecfce20..88eb4be4d5a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -9,6 +9,13 @@
 #define ICE_SW_CFG_MAX_BUF_LEN 2048
 #define ICE_DFLT_VSI_INVAL 0xff
 #define ICE_VSI_INVAL_ID 0xffff
+#define ICE_INVAL_Q_HANDLE 0xFFFF
+#define ICE_INVAL_Q_HANDLE 0xFFFF
+
+/* VSI queue context structure */
+struct ice_q_ctx {
+	u16  q_handle;
+};
 
 /* VSI context structure for add/get/update/free operations */
 struct ice_vsi_ctx {
@@ -20,6 +27,8 @@ struct ice_vsi_ctx {
 	struct ice_sched_vsi_info sched;
 	u8 alloc_from_pool;
 	u8 vf_num;
+	u16 num_lan_q_entries[ICE_MAX_TRAFFIC_CLASS];
+	struct ice_q_ctx *lan_q_ctx[ICE_MAX_TRAFFIC_CLASS];
 };
 
 enum ice_sw_fwd_act_type {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index e562ea15b79b..789b6f10b381 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -996,8 +996,8 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 		/* Call Disable LAN Tx queue AQ call even when queues are not
 		 * enabled. This is needed for successful completiom of VFR
 		 */
-		ice_dis_vsi_txq(vsi->port_info, 0, NULL, NULL, ICE_VF_RESET,
-				vf->vf_id, NULL);
+		ice_dis_vsi_txq(vsi->port_info, vsi->idx, 0, 0, NULL, NULL,
+				NULL, ICE_VF_RESET, vf->vf_id, NULL);
 	}
 
 	hw = &pf->hw;
-- 
2.20.1

