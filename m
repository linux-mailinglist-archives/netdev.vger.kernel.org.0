Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D822D3023A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfE3Sui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:38 -0400
Received: from mga04.intel.com ([192.55.52.120]:30427 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbfE3Sug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:35 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: Add support for virtchnl_vector_map.[rxq|txq]_map
Date:   Thu, 30 May 2019 11:50:33 -0700
Message-Id: <20190530185045.3886-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Add support for virtchnl_vector_map.[rxq|txq]_map to use bitmap to
associate indicated queues with the specified vector. This support is
needed since the Windows AVF driver calls VIRTCHNL_OP_CONFIG_IRQ_MAP for
each vector and used the bitmap to indicate the associated queues.

Updated ice_vc_dis_qs_msg to not subtract one from
virtchnl_irq_map_info.num_vectors, and changed the VSI vector index to
the vector id. This change supports the Windows AVF driver which maps
one vector at a time and sets num_vectors to one. Using vectors_id to
index the vector array .

Add check for vector_id zero, and return VIRTCHNL_STATUS_ERR_PARAM
if vector_id is zero and there are rings associated with that vector.
Vector_id zero is for the OICR.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c      | 108 ++++++++++++------
 drivers/net/ethernet/intel/ice/ice_lib.h      |   8 ++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  43 +++++--
 3 files changed, 115 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 230f733817d0..a21b817642ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -321,10 +321,10 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 		vsi->alloc_rxq = vf->num_vf_qs;
 		/* pf->num_vf_msix includes (VF miscellaneous vector +
 		 * data queue interrupts). Since vsi->num_q_vectors is number
-		 * of queues vectors, subtract 1 from the original vector
-		 * count
+		 * of queues vectors, subtract 1 (ICE_NONQ_VECS_VF) from the
+		 * original vector count
 		 */
-		vsi->num_q_vectors = pf->num_vf_msix - 1;
+		vsi->num_q_vectors = pf->num_vf_msix - ICE_NONQ_VECS_VF;
 		break;
 	case ICE_VSI_LB:
 		vsi->alloc_txq = 1;
@@ -1835,9 +1835,74 @@ ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector)
 	}
 }
 
+/**
+ * ice_cfg_txq_interrupt - configure interrupt on Tx queue
+ * @vsi: the VSI being configured
+ * @txq: Tx queue being mapped to MSI-X vector
+ * @msix_idx: MSI-X vector index within the function
+ * @itr_idx: ITR index of the interrupt cause
+ *
+ * Configure interrupt on Tx queue by associating Tx queue to MSI-X vector
+ * within the function space.
+ */
+#ifdef CONFIG_PCI_IOV
+void
+ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx)
+#else
+static void
+ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx)
+#endif /* CONFIG_PCI_IOV */
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	u32 val;
+
+	itr_idx = (itr_idx << QINT_TQCTL_ITR_INDX_S) & QINT_TQCTL_ITR_INDX_M;
+
+	val = QINT_TQCTL_CAUSE_ENA_M | itr_idx |
+	      ((msix_idx << QINT_TQCTL_MSIX_INDX_S) & QINT_TQCTL_MSIX_INDX_M);
+
+	wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), val);
+}
+
+/**
+ * ice_cfg_rxq_interrupt - configure interrupt on Rx queue
+ * @vsi: the VSI being configured
+ * @rxq: Rx queue being mapped to MSI-X vector
+ * @msix_idx: MSI-X vector index within the function
+ * @itr_idx: ITR index of the interrupt cause
+ *
+ * Configure interrupt on Rx queue by associating Rx queue to MSI-X vector
+ * within the function space.
+ */
+#ifdef CONFIG_PCI_IOV
+void
+ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq, u16 msix_idx, u16 itr_idx)
+#else
+static void
+ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq, u16 msix_idx, u16 itr_idx)
+#endif /* CONFIG_PCI_IOV */
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	u32 val;
+
+	itr_idx = (itr_idx << QINT_RQCTL_ITR_INDX_S) & QINT_RQCTL_ITR_INDX_M;
+
+	val = QINT_RQCTL_CAUSE_ENA_M | itr_idx |
+	      ((msix_idx << QINT_RQCTL_MSIX_INDX_S) & QINT_RQCTL_MSIX_INDX_M);
+
+	wr32(hw, QINT_RQCTL(vsi->rxq_map[rxq]), val);
+
+	ice_flush(hw);
+}
+
 /**
  * ice_vsi_cfg_msix - MSIX mode Interrupt Config in the HW
  * @vsi: the VSI being configured
+ *
+ * This configures MSIX mode interrupts for the PF VSI, and should not be used
+ * for the VF VSI.
  */
 void ice_vsi_cfg_msix(struct ice_vsi *vsi)
 {
@@ -1850,8 +1915,7 @@ void ice_vsi_cfg_msix(struct ice_vsi *vsi)
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
 		u16 reg_idx = q_vector->reg_idx;
 
-		if (vsi->type != ICE_VSI_VF)
-			ice_cfg_itr(hw, q_vector);
+		ice_cfg_itr(hw, q_vector);
 
 		wr32(hw, GLINT_RATE(reg_idx),
 		     ice_intrl_usec_to_reg(q_vector->intrl, hw->intrl_gran));
@@ -1868,43 +1932,17 @@ void ice_vsi_cfg_msix(struct ice_vsi *vsi)
 		 * tracked for this PF.
 		 */
 		for (q = 0; q < q_vector->num_ring_tx; q++) {
-			int itr_idx = (q_vector->tx.itr_idx <<
-				       QINT_TQCTL_ITR_INDX_S) &
-				QINT_TQCTL_ITR_INDX_M;
-			u32 val;
-
-			if (vsi->type == ICE_VSI_VF)
-				val = QINT_TQCTL_CAUSE_ENA_M | itr_idx |
-				      (((i + 1) << QINT_TQCTL_MSIX_INDX_S) &
-				       QINT_TQCTL_MSIX_INDX_M);
-			else
-				val = QINT_TQCTL_CAUSE_ENA_M | itr_idx |
-				      ((reg_idx << QINT_TQCTL_MSIX_INDX_S) &
-				       QINT_TQCTL_MSIX_INDX_M);
-			wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), val);
+			ice_cfg_txq_interrupt(vsi, txq, reg_idx,
+					      q_vector->tx.itr_idx);
 			txq++;
 		}
 
 		for (q = 0; q < q_vector->num_ring_rx; q++) {
-			int itr_idx = (q_vector->rx.itr_idx <<
-				       QINT_RQCTL_ITR_INDX_S) &
-				QINT_RQCTL_ITR_INDX_M;
-			u32 val;
-
-			if (vsi->type == ICE_VSI_VF)
-				val = QINT_RQCTL_CAUSE_ENA_M | itr_idx |
-					(((i + 1) << QINT_RQCTL_MSIX_INDX_S) &
-					 QINT_RQCTL_MSIX_INDX_M);
-			else
-				val = QINT_RQCTL_CAUSE_ENA_M | itr_idx |
-					((reg_idx << QINT_RQCTL_MSIX_INDX_S) &
-					 QINT_RQCTL_MSIX_INDX_M);
-			wr32(hw, QINT_RQCTL(vsi->rxq_map[rxq]), val);
+			ice_cfg_rxq_interrupt(vsi, rxq, reg_idx,
+					      q_vector->rx.itr_idx);
 			rxq++;
 		}
 	}
-
-	ice_flush(hw);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index e223767755cb..2acae3215f5f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -19,6 +19,14 @@ int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi);
 
 void ice_vsi_cfg_msix(struct ice_vsi *vsi);
 
+#ifdef CONFIG_PCI_IOV
+void
+ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx);
+
+void
+ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq, u16 msix_idx, u16 itr_idx);
+#endif /* CONFIG_PCI_IOV */
+
 int ice_vsi_add_vlan(struct ice_vsi *vsi, u16 vid);
 
 int ice_vsi_kill_vlan(struct ice_vsi *vsi, u16 vid);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 9c6d9c95f4f6..ecbf447e558a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1955,24 +1955,33 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 	u16 vsi_id, vsi_q_id, vector_id;
 	struct virtchnl_vector_map *map;
 	struct ice_pf *pf = vf->pf;
+	u16 num_q_vectors_mapped;
 	struct ice_vsi *vsi;
 	unsigned long qmap;
-	u16 num_q_vectors;
 	int i;
 
 	irqmap_info = (struct virtchnl_irq_map_info *)msg;
-	num_q_vectors = irqmap_info->num_vectors - ICE_NONQ_VECS_VF;
+	num_q_vectors_mapped = irqmap_info->num_vectors;
+
 	vsi = pf->vsi[vf->lan_vsi_idx];
+	if (!vsi) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
 
+	/* Check to make sure number of VF vectors mapped is not greater than
+	 * number of VF vectors originally allocated, and check that
+	 * there is actually at least a single VF queue vector mapped
+	 */
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states) ||
-	    !vsi || vsi->num_q_vectors < num_q_vectors ||
-	    irqmap_info->num_vectors == 0) {
+	    pf->num_vf_msix < num_q_vectors_mapped ||
+	    !irqmap_info->num_vectors) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
 
-	for (i = 0; i < num_q_vectors; i++) {
-		struct ice_q_vector *q_vector = vsi->q_vectors[i];
+	for (i = 0; i < num_q_vectors_mapped; i++) {
+		struct ice_q_vector *q_vector;
 
 		map = &irqmap_info->vecmap[i];
 
@@ -1980,7 +1989,21 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 		vsi_id = map->vsi_id;
 		/* validate msg params */
 		if (!(vector_id < pf->hw.func_caps.common_cap
-		    .num_msix_vectors) || !ice_vc_isvalid_vsi_id(vf, vsi_id)) {
+		    .num_msix_vectors) || !ice_vc_isvalid_vsi_id(vf, vsi_id) ||
+		    (!vector_id && (map->rxq_map || map->txq_map))) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto error_param;
+		}
+
+		/* No need to map VF miscellaneous or rogue vector */
+		if (!vector_id)
+			continue;
+
+		/* Subtract non queue vector from vector_id passed by VF
+		 * to get actual number of VSI queue vector array index
+		 */
+		q_vector = vsi->q_vectors[vector_id - ICE_NONQ_VECS_VF];
+		if (!q_vector) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
@@ -1996,6 +2019,8 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 			q_vector->num_ring_rx++;
 			q_vector->rx.itr_idx = map->rxitr_idx;
 			vsi->rx_rings[vsi_q_id]->q_vector = q_vector;
+			ice_cfg_rxq_interrupt(vsi, vsi_q_id, vector_id,
+					      q_vector->rx.itr_idx);
 		}
 
 		qmap = map->txq_map;
@@ -2008,11 +2033,11 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
 			q_vector->num_ring_tx++;
 			q_vector->tx.itr_idx = map->txitr_idx;
 			vsi->tx_rings[vsi_q_id]->q_vector = q_vector;
+			ice_cfg_txq_interrupt(vsi, vsi_q_id, vector_id,
+					      q_vector->tx.itr_idx);
 		}
 	}
 
-	if (vsi)
-		ice_vsi_cfg_msix(vsi);
 error_param:
 	/* send the response to the VF */
 	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_IRQ_MAP, v_ret,
-- 
2.21.0

