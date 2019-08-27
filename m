Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701059F066
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbfH0Qiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:38:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:10373 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbfH0Qig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876356"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Peng Huang <peng.huang@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/15] ice: add support for virtchnl_queue_select.[tx|rx]_queues bitmap
Date:   Tue, 27 Aug 2019 09:38:28 -0700
Message-Id: <20190827163832.8362-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

The VF driver can call VIRTCHNL_OP_[ENABLE|DISABLE]_QUEUES separately
for each queue. Add support for virtchnl_queue_select.[tx|rx]_queues
bitmap which is used to indicate which queues to enable and disable.

Add tracing of VF Tx/Rx per queue enable state to avoid enabling enabled
queues and disabling disabled queues. Add total queues enabled count and
clear ICE_VF_STATE_QS_ENA when count is zero.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Peng Huang <peng.huang@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c      |  15 +-
 drivers/net/ethernet/intel/ice/ice_lib.h      |  10 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 243 +++++++++++++-----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  12 +-
 5 files changed, 207 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index cfd6723de857..fb866be84088 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -196,7 +196,10 @@ static int ice_pf_rxq_wait(struct ice_pf *pf, int pf_q, bool ena)
  * @ena: start or stop the Rx rings
  * @rxq_idx: Rx queue index
  */
-static int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
+#ifndef CONFIG_PCI_IOV
+static
+#endif /* !CONFIG_PCI_IOV */
+int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx)
 {
 	int pf_q = vsi->rxq_map[rxq_idx];
 	struct ice_pf *pf = vsi->back;
@@ -2105,7 +2108,10 @@ void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector *q_vector)
  * @ring: Tx ring to be stopped
  * @txq_meta: Meta data of Tx ring to be stopped
  */
-static int
+#ifndef CONFIG_PCI_IOV
+static
+#endif /* !CONFIG_PCI_IOV */
+int
 ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 		     u16 rel_vmvf_num, struct ice_ring *ring,
 		     struct ice_txq_meta *txq_meta)
@@ -2165,7 +2171,10 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
  * Set up a helper struct that will contain all the necessary fields that
  * are needed for stopping Tx queue
  */
-static void
+#ifndef CONFIG_PCI_IOV
+static
+#endif /* !CONFIG_PCI_IOV */
+void
 ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_ring *ring,
 		  struct ice_txq_meta *txq_meta)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 33074b8b7557..7faf8db844f6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -39,6 +39,16 @@ ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx);
 
 void
 ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq, u16 msix_idx, u16 itr_idx);
+
+int
+ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
+		     u16 rel_vmvf_num, struct ice_ring *ring,
+		     struct ice_txq_meta *txq_meta);
+
+void ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_ring *ring,
+		       struct ice_txq_meta *txq_meta);
+
+int ice_vsi_ctrl_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx);
 #endif /* CONFIG_PCI_IOV */
 
 int ice_vsi_add_vlan(struct ice_vsi *vsi, u16 vid);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0398c86226f0..e47aab6d998d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -489,7 +489,7 @@ ice_prepare_for_reset(struct ice_pf *pf)
 
 	/* Disable VFs until reset is completed */
 	for (i = 0; i < pf->num_alloc_vfs; i++)
-		clear_bit(ICE_VF_STATE_ENA, pf->vf[i].vf_states);
+		ice_set_vf_state_qs_dis(&pf->vf[i]);
 
 	/* disable the VSIs and their queues that are not already DOWN */
 	ice_pf_dis_all_vsi(pf, false);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index e6578d2f0876..78fd3fa8ac8b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -251,6 +251,35 @@ static int ice_sriov_free_msix_res(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_set_vf_state_qs_dis - Set VF queues state to disabled
+ * @vf: pointer to the VF structure
+ */
+void ice_set_vf_state_qs_dis(struct ice_vf *vf)
+{
+	/* Clear Rx/Tx enabled queues flag */
+	bitmap_zero(vf->txq_ena, ICE_MAX_BASE_QS_PER_VF);
+	bitmap_zero(vf->rxq_ena, ICE_MAX_BASE_QS_PER_VF);
+	vf->num_qs_ena = 0;
+	clear_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
+}
+
+/**
+ * ice_dis_vf_qs - Disable the VF queues
+ * @vf: pointer to the VF structure
+ */
+static void ice_dis_vf_qs(struct ice_vf *vf)
+{
+	struct ice_pf *pf = vf->pf;
+	struct ice_vsi *vsi;
+
+	vsi = pf->vsi[vf->lan_vsi_idx];
+
+	ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
+	ice_vsi_stop_rx_rings(vsi);
+	ice_set_vf_state_qs_dis(vf);
+}
+
 /**
  * ice_free_vfs - Free all VFs
  * @pf: pointer to the PF structure
@@ -267,19 +296,9 @@ void ice_free_vfs(struct ice_pf *pf)
 		usleep_range(1000, 2000);
 
 	/* Avoid wait time by stopping all VFs at the same time */
-	for (i = 0; i < pf->num_alloc_vfs; i++) {
-		struct ice_vsi *vsi;
-
-		if (!test_bit(ICE_VF_STATE_ENA, pf->vf[i].vf_states))
-			continue;
-
-		vsi = pf->vsi[pf->vf[i].lan_vsi_idx];
-		/* stop rings without wait time */
-		ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, i);
-		ice_vsi_stop_rx_rings(vsi);
-
-		clear_bit(ICE_VF_STATE_ENA, pf->vf[i].vf_states);
-	}
+	for (i = 0; i < pf->num_alloc_vfs; i++)
+		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[i].vf_states))
+			ice_dis_vf_qs(&pf->vf[i]);
 
 	/* Disable IOV before freeing resources. This lets any VF drivers
 	 * running in the host get themselves cleaned up before we yank
@@ -1055,17 +1074,9 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	for (v = 0; v < pf->num_alloc_vfs; v++)
 		ice_trigger_vf_reset(&pf->vf[v], is_vflr);
 
-	for (v = 0; v < pf->num_alloc_vfs; v++) {
-		struct ice_vsi *vsi;
-
-		vf = &pf->vf[v];
-		vsi = pf->vsi[vf->lan_vsi_idx];
-		if (test_bit(ICE_VF_STATE_ENA, vf->vf_states)) {
-			ice_vsi_stop_lan_tx_rings(vsi, ICE_VF_RESET, vf->vf_id);
-			ice_vsi_stop_rx_rings(vsi);
-			clear_bit(ICE_VF_STATE_ENA, vf->vf_states);
-		}
-	}
+	for (v = 0; v < pf->num_alloc_vfs; v++)
+		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[v].vf_states))
+			ice_dis_vf_qs(&pf->vf[v]);
 
 	/* HW requires some time to make sure it can flush the FIFO for a VF
 	 * when it resets it. Poll the VPGEN_VFRSTAT register for each VF in
@@ -1144,24 +1155,21 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	/* If the VFs have been disabled, this means something else is
 	 * resetting the VF, so we shouldn't continue.
 	 */
-	if (test_and_set_bit(__ICE_VF_DIS, pf->state))
+	if (test_bit(__ICE_VF_DIS, pf->state))
 		return false;
 
 	ice_trigger_vf_reset(vf, is_vflr);
 
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
-	if (test_bit(ICE_VF_STATE_ENA, vf->vf_states)) {
-		ice_vsi_stop_lan_tx_rings(vsi, ICE_VF_RESET, vf->vf_id);
-		ice_vsi_stop_rx_rings(vsi);
-		clear_bit(ICE_VF_STATE_ENA, vf->vf_states);
-	} else {
+	if (test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states))
+		ice_dis_vf_qs(vf);
+	else
 		/* Call Disable LAN Tx queue AQ call even when queues are not
-		 * enabled. This is needed for successful completiom of VFR
+		 * enabled. This is needed for successful completion of VFR
 		 */
 		ice_dis_vsi_txq(vsi->port_info, vsi->idx, 0, 0, NULL, NULL,
 				NULL, ICE_VF_RESET, vf->vf_id, NULL);
-	}
 
 	hw = &pf->hw;
 	/* poll VPGEN_VFRSTAT reg to make sure
@@ -1210,7 +1218,6 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	ice_cleanup_and_realloc_vf(vf);
 
 	ice_flush(hw);
-	clear_bit(__ICE_VF_DIS, pf->state);
 
 	return true;
 }
@@ -1717,10 +1724,12 @@ static bool ice_vc_isvalid_q_id(struct ice_vf *vf, u16 vsi_id, u8 qid)
  * @ring_len: length of ring
  *
  * check for the valid ring count, should be multiple of ICE_REQ_DESC_MULTIPLE
+ * or zero
  */
 static bool ice_vc_isvalid_ring_len(u16 ring_len)
 {
-	return (ring_len >= ICE_MIN_NUM_DESC &&
+	return ring_len == 0 ||
+	       (ring_len >= ICE_MIN_NUM_DESC &&
 		ring_len <= ICE_MAX_NUM_DESC &&
 		!(ring_len % ICE_REQ_DESC_MULTIPLE));
 }
@@ -1877,6 +1886,8 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 	    (struct virtchnl_queue_select *)msg;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
+	unsigned long q_map;
+	u16 vf_q_id;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -1909,12 +1920,48 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
 	 * Tx queue group list was configured and the context bits were
 	 * programmed using ice_vsi_cfg_txqs
 	 */
-	if (ice_vsi_start_rx_rings(vsi))
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	q_map = vqs->rx_queues;
+	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_BASE_QS_PER_VF) {
+		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
+
+		/* Skip queue if enabled */
+		if (test_bit(vf_q_id, vf->rxq_ena))
+			continue;
+
+		if (ice_vsi_ctrl_rx_ring(vsi, true, vf_q_id)) {
+			dev_err(&vsi->back->pdev->dev,
+				"Failed to enable Rx ring %d on VSI %d\n",
+				vf_q_id, vsi->vsi_num);
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
+
+		set_bit(vf_q_id, vf->rxq_ena);
+		vf->num_qs_ena++;
+	}
+
+	vsi = pf->vsi[vf->lan_vsi_idx];
+	q_map = vqs->tx_queues;
+	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_BASE_QS_PER_VF) {
+		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
+
+		/* Skip queue if enabled */
+		if (test_bit(vf_q_id, vf->txq_ena))
+			continue;
+
+		set_bit(vf_q_id, vf->txq_ena);
+		vf->num_qs_ena++;
+	}
 
 	/* Set flag to indicate that queues are enabled */
 	if (v_ret == VIRTCHNL_STATUS_SUCCESS)
-		set_bit(ICE_VF_STATE_ENA, vf->vf_states);
+		set_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
 
 error_param:
 	/* send the response to the VF */
@@ -1937,9 +1984,11 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 	    (struct virtchnl_queue_select *)msg;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
+	unsigned long q_map;
+	u16 vf_q_id;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) &&
-	    !test_bit(ICE_VF_STATE_ENA, vf->vf_states)) {
+	    !test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
@@ -1966,23 +2015,69 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if (ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id)) {
-		dev_err(&vsi->back->pdev->dev,
-			"Failed to stop tx rings on VSI %d\n",
-			vsi->vsi_num);
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (vqs->tx_queues) {
+		q_map = vqs->tx_queues;
+
+		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_BASE_QS_PER_VF) {
+			struct ice_ring *ring = vsi->tx_rings[vf_q_id];
+			struct ice_txq_meta txq_meta = { 0 };
+
+			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
+
+			/* Skip queue if not enabled */
+			if (!test_bit(vf_q_id, vf->txq_ena))
+				continue;
+
+			ice_fill_txq_meta(vsi, ring, &txq_meta);
+
+			if (ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, vf->vf_id,
+						 ring, &txq_meta)) {
+				dev_err(&vsi->back->pdev->dev,
+					"Failed to stop Tx ring %d on VSI %d\n",
+					vf_q_id, vsi->vsi_num);
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
+
+			/* Clear enabled queues flag */
+			clear_bit(vf_q_id, vf->txq_ena);
+			vf->num_qs_ena--;
+		}
 	}
 
-	if (ice_vsi_stop_rx_rings(vsi)) {
-		dev_err(&vsi->back->pdev->dev,
-			"Failed to stop rx rings on VSI %d\n",
-			vsi->vsi_num);
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+	if (vqs->rx_queues) {
+		q_map = vqs->rx_queues;
+
+		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_BASE_QS_PER_VF) {
+			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
+
+			/* Skip queue if not enabled */
+			if (!test_bit(vf_q_id, vf->rxq_ena))
+				continue;
+
+			if (ice_vsi_ctrl_rx_ring(vsi, false, vf_q_id)) {
+				dev_err(&vsi->back->pdev->dev,
+					"Failed to stop Rx ring %d on VSI %d\n",
+					vf_q_id, vsi->vsi_num);
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
+
+			/* Clear enabled queues flag */
+			clear_bit(vf_q_id, vf->rxq_ena);
+			vf->num_qs_ena--;
+		}
 	}
 
 	/* Clear enabled queues flag */
-	if (v_ret == VIRTCHNL_STATUS_SUCCESS)
-		clear_bit(ICE_VF_STATE_ENA, vf->vf_states);
+	if (v_ret == VIRTCHNL_STATUS_SUCCESS && !vf->num_qs_ena)
+		clear_bit(ICE_VF_STATE_QS_ENA, vf->vf_states);
 
 error_param:
 	/* send the response to the VF */
@@ -2106,6 +2201,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 	struct virtchnl_vsi_queue_config_info *qci =
 	    (struct virtchnl_vsi_queue_config_info *)msg;
 	struct virtchnl_queue_pair_info *qpi;
+	u16 num_rxq = 0, num_txq = 0;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 	int i;
@@ -2148,33 +2244,44 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			goto error_param;
 		}
 		/* copy Tx queue info from VF into VSI */
-		vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
-		vsi->tx_rings[i]->count = qpi->txq.ring_len;
-		/* copy Rx queue info from VF into VSI */
-		vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
-		vsi->rx_rings[i]->count = qpi->rxq.ring_len;
-		if (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
-		    qpi->rxq.databuffer_size < 1024) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
+		if (qpi->txq.ring_len > 0) {
+			num_txq++;
+			vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
+			vsi->tx_rings[i]->count = qpi->txq.ring_len;
 		}
-		vsi->rx_buf_len = qpi->rxq.databuffer_size;
-		if (qpi->rxq.max_pkt_size >= (16 * 1024) ||
-		    qpi->rxq.max_pkt_size < 64) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
+
+		/* copy Rx queue info from VF into VSI */
+		if (qpi->rxq.ring_len > 0) {
+			num_rxq++;
+			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
+			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
+
+			if (qpi->rxq.databuffer_size != 0 &&
+			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
+			     qpi->rxq.databuffer_size < 1024)) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
+			vsi->rx_buf_len = qpi->rxq.databuffer_size;
+			vsi->rx_rings[i]->rx_buf_len = vsi->rx_buf_len;
+			if (qpi->rxq.max_pkt_size >= (16 * 1024) ||
+			    qpi->rxq.max_pkt_size < 64) {
+				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+				goto error_param;
+			}
 		}
+
 		vsi->max_frame = qpi->rxq.max_pkt_size;
 	}
 
 	/* VF can request to configure less than allocated queues
 	 * or default allocated queues. So update the VSI with new number
 	 */
-	vsi->num_txq = qci->num_queue_pairs;
-	vsi->num_rxq = qci->num_queue_pairs;
+	vsi->num_txq = num_txq;
+	vsi->num_rxq = num_rxq;
 	/* All queues of VF VSI are in TC 0 */
-	vsi->tc_cfg.tc_info[0].qcount_tx = qci->num_queue_pairs;
-	vsi->tc_cfg.tc_info[0].qcount_rx = qci->num_queue_pairs;
+	vsi->tc_cfg.tc_info[0].qcount_tx = num_txq;
+	vsi->tc_cfg.tc_info[0].qcount_rx = num_rxq;
 
 	if (ice_vsi_cfg_lan_txqs(vsi) || ice_vsi_cfg_rxqs(vsi))
 		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 13f45f37d75e..0d9880c8bba3 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -41,9 +41,9 @@
 
 /* Specific VF states */
 enum ice_vf_states {
-	ICE_VF_STATE_INIT = 0,
-	ICE_VF_STATE_ACTIVE,
-	ICE_VF_STATE_ENA,
+	ICE_VF_STATE_INIT = 0,		/* PF is initializing VF */
+	ICE_VF_STATE_ACTIVE,		/* VF resources are allocated for use */
+	ICE_VF_STATE_QS_ENA,		/* VF queue(s) enabled */
 	ICE_VF_STATE_DIS,
 	ICE_VF_STATE_MC_PROMISC,
 	ICE_VF_STATE_UC_PROMISC,
@@ -68,6 +68,8 @@ struct ice_vf {
 	struct virtchnl_version_info vf_ver;
 	u32 driver_caps;		/* reported by VF driver */
 	struct virtchnl_ether_addr dflt_lan_addr;
+	DECLARE_BITMAP(txq_ena, ICE_MAX_BASE_QS_PER_VF);
+	DECLARE_BITMAP(rxq_ena, ICE_MAX_BASE_QS_PER_VF);
 	u16 port_vlan_id;
 	u8 pf_set_mac:1;		/* VF MAC address set by VMM admin */
 	u8 trusted:1;
@@ -90,6 +92,7 @@ struct ice_vf {
 	u16 num_mac;
 	u16 num_vlan;
 	u16 num_vf_qs;			/* num of queue configured per VF */
+	u16 num_qs_ena;			/* total num of Tx/Rx queue enabled */
 };
 
 #ifdef CONFIG_PCI_IOV
@@ -116,12 +119,15 @@ int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state);
 int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena);
 
 int ice_calc_vf_reg_idx(struct ice_vf *vf, struct ice_q_vector *q_vector);
+
+void ice_set_vf_state_qs_dis(struct ice_vf *vf);
 #else /* CONFIG_PCI_IOV */
 #define ice_process_vflr_event(pf) do {} while (0)
 #define ice_free_vfs(pf) do {} while (0)
 #define ice_vc_process_vf_msg(pf, event) do {} while (0)
 #define ice_vc_notify_link_state(pf) do {} while (0)
 #define ice_vc_notify_reset(pf) do {} while (0)
+#define ice_set_vf_state_qs_dis(vf) do {} while (0)
 
 static inline bool
 ice_reset_all_vfs(struct ice_pf __always_unused *pf,
-- 
2.21.0

