Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2236811608
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfEBJGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:47592 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbfEBJG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615368"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: Add reg_idx variable in ice_q_vector structure
Date:   Thu,  2 May 2019 02:06:17 -0700
Message-Id: <20190502090620.21281-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Every time we want to re-enable interrupts and/or write to a register
that requires an interrupt vector's hardware index we do the following:

vsi->hw_base_vector + q_vector->v_idx

This is a wasteful operation, especially in the hot path. Fix this by
adding a u16 reg_idx member to the ice_q_vector structure and make the
necessary changes to make this work.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  3 +-
 drivers/net/ethernet/intel/ice/ice_lib.c  | 84 ++++++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_main.c | 13 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c |  2 +-
 4 files changed, 76 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 878a75182d6d..d66aad49bfd4 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -297,6 +297,7 @@ struct ice_q_vector {
 	struct ice_vsi *vsi;
 
 	u16 v_idx;			/* index in the vsi->q_vector array. */
+	u16 reg_idx;
 	u8 num_ring_rx;			/* total number of Rx rings in vector */
 	u8 num_ring_tx;			/* total number of Tx rings in vector */
 	u8 itr_countdown;		/* when 0 should adjust adaptive ITR */
@@ -403,7 +404,7 @@ static inline void
 ice_irq_dynamic_ena(struct ice_hw *hw, struct ice_vsi *vsi,
 		    struct ice_q_vector *q_vector)
 {
-	u32 vector = (vsi && q_vector) ? vsi->hw_base_vector + q_vector->v_idx :
+	u32 vector = (vsi && q_vector) ? q_vector->reg_idx :
 				((struct ice_pf *)hw->back)->hw_oicr_idx;
 	int itr = ICE_ITR_NONE;
 	u32 val;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 6d9571c8826d..399905396134 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1805,13 +1805,12 @@ static void ice_cfg_itr_gran(struct ice_hw *hw)
  * ice_cfg_itr - configure the initial interrupt throttle values
  * @hw: pointer to the HW structure
  * @q_vector: interrupt vector that's being configured
- * @vector: HW vector index to apply the interrupt throttling to
  *
  * Configure interrupt throttling values for the ring containers that are
  * associated with the interrupt vector passed in.
  */
 static void
-ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector, u16 vector)
+ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector)
 {
 	ice_cfg_itr_gran(hw);
 
@@ -1825,7 +1824,7 @@ ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector, u16 vector)
 		rc->target_itr = ITR_TO_REG(rc->itr_setting);
 		rc->next_update = jiffies + 1;
 		rc->current_itr = rc->target_itr;
-		wr32(hw, GLINT_ITR(rc->itr_idx, vector),
+		wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
 		     ITR_REG_ALIGN(rc->current_itr) >> ICE_ITR_GRAN_S);
 	}
 
@@ -1839,7 +1838,7 @@ ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector, u16 vector)
 		rc->target_itr = ITR_TO_REG(rc->itr_setting);
 		rc->next_update = jiffies + 1;
 		rc->current_itr = rc->target_itr;
-		wr32(hw, GLINT_ITR(rc->itr_idx, vector),
+		wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
 		     ITR_REG_ALIGN(rc->current_itr) >> ICE_ITR_GRAN_S);
 	}
 }
@@ -1851,17 +1850,17 @@ ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector, u16 vector)
 void ice_vsi_cfg_msix(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
-	u16 vector = vsi->hw_base_vector;
 	struct ice_hw *hw = &pf->hw;
 	u32 txq = 0, rxq = 0;
 	int i, q;
 
-	for (i = 0; i < vsi->num_q_vectors; i++, vector++) {
+	for (i = 0; i < vsi->num_q_vectors; i++) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
+		u16 reg_idx = q_vector->reg_idx;
 
-		ice_cfg_itr(hw, q_vector, vector);
+		ice_cfg_itr(hw, q_vector);
 
-		wr32(hw, GLINT_RATE(vector),
+		wr32(hw, GLINT_RATE(reg_idx),
 		     ice_intrl_usec_to_reg(q_vector->intrl, hw->intrl_gran));
 
 		/* Both Transmit Queue Interrupt Cause Control register
@@ -1886,7 +1885,7 @@ void ice_vsi_cfg_msix(struct ice_vsi *vsi)
 			else
 				val = QINT_TQCTL_CAUSE_ENA_M |
 				      (itr_idx << QINT_TQCTL_ITR_INDX_S)  |
-				      (vector << QINT_TQCTL_MSIX_INDX_S);
+				      (reg_idx << QINT_TQCTL_MSIX_INDX_S);
 			wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), val);
 			txq++;
 		}
@@ -1902,7 +1901,7 @@ void ice_vsi_cfg_msix(struct ice_vsi *vsi)
 			else
 				val = QINT_RQCTL_CAUSE_ENA_M |
 				      (itr_idx << QINT_RQCTL_ITR_INDX_S)  |
-				      (vector << QINT_RQCTL_MSIX_INDX_S);
+				      (reg_idx << QINT_RQCTL_MSIX_INDX_S);
 			wr32(hw, QINT_RQCTL(vsi->rxq_map[rxq]), val);
 			rxq++;
 		}
@@ -2065,8 +2064,6 @@ ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 			break;
 
 		for (i = 0; i < vsi->tc_cfg.tc_info[tc].qcount_tx; i++) {
-			u16 v_idx;
-
 			if (!rings || !rings[q_idx] ||
 			    !rings[q_idx]->q_vector) {
 				err = -EINVAL;
@@ -2088,8 +2085,7 @@ ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 			/* trigger a software interrupt for the vector
 			 * associated to the queue to schedule NAPI handler
 			 */
-			v_idx = rings[i]->q_vector->v_idx;
-			wr32(hw, GLINT_DYN_CTL(vsi->hw_base_vector + v_idx),
+			wr32(hw, GLINT_DYN_CTL(rings[i]->q_vector->reg_idx),
 			     GLINT_DYN_CTL_SWINT_TRIG_M |
 			     GLINT_DYN_CTL_INTENA_MSK_M);
 			q_idx++;
@@ -2208,6 +2204,44 @@ static void ice_vsi_set_tc_cfg(struct ice_vsi *vsi)
 	vsi->tc_cfg.numtc = ice_dcb_get_num_tc(cfg);
 }
 
+/**
+ * ice_vsi_set_q_vectors_reg_idx - set the HW register index for all q_vectors
+ * @vsi: VSI to set the q_vectors register index on
+ */
+static int
+ice_vsi_set_q_vectors_reg_idx(struct ice_vsi *vsi)
+{
+	u16 i;
+
+	if (!vsi || !vsi->q_vectors)
+		return -EINVAL;
+
+	ice_for_each_q_vector(vsi, i) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[i];
+
+		if (!q_vector) {
+			dev_err(&vsi->back->pdev->dev,
+				"Failed to set reg_idx on q_vector %d VSI %d\n",
+				i, vsi->vsi_num);
+			goto clear_reg_idx;
+		}
+
+		q_vector->reg_idx = q_vector->v_idx + vsi->hw_base_vector;
+	}
+
+	return 0;
+
+clear_reg_idx:
+	ice_for_each_q_vector(vsi, i) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[i];
+
+		if (q_vector)
+			q_vector->reg_idx = 0;
+	}
+
+	return -EINVAL;
+}
+
 /**
  * ice_vsi_setup - Set up a VSI by a given type
  * @pf: board private structure
@@ -2273,6 +2307,10 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		if (ret)
 			goto unroll_alloc_q_vector;
 
+		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
+		if (ret)
+			goto unroll_vector_base;
+
 		ret = ice_vsi_alloc_rings(vsi);
 		if (ret)
 			goto unroll_vector_base;
@@ -2311,6 +2349,10 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		} else {
 			vsi->hw_base_vector = pf->vf[vf_id].first_vector_idx;
 		}
+		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
+		if (ret)
+			goto unroll_vector_base;
+
 		pf->q_left_tx -= vsi->alloc_txq;
 		pf->q_left_rx -= vsi->alloc_rxq;
 		break;
@@ -2623,11 +2665,11 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
 
 	/* disable each interrupt */
 	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags)) {
-		for (i = vsi->hw_base_vector;
-		     i < (vsi->num_q_vectors + vsi->hw_base_vector); i++)
-			wr32(hw, GLINT_DYN_CTL(i), 0);
+		ice_for_each_q_vector(vsi, i)
+			wr32(hw, GLINT_DYN_CTL(vsi->q_vectors[i]->reg_idx), 0);
 
 		ice_flush(hw);
+
 		ice_for_each_q_vector(vsi, i)
 			synchronize_irq(pf->msix_entries[i + base].vector);
 	}
@@ -2780,6 +2822,10 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 		if (ret)
 			goto err_vectors;
 
+		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
+		if (ret)
+			goto err_vectors;
+
 		ret = ice_vsi_alloc_rings(vsi);
 		if (ret)
 			goto err_vectors;
@@ -2801,6 +2847,10 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 		if (ret)
 			goto err_vectors;
 
+		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
+		if (ret)
+			goto err_vectors;
+
 		ret = ice_vsi_alloc_rings(vsi);
 		if (ret)
 			goto err_vectors;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8f6f2a1e67ed..51af6b9a7ea2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1592,23 +1592,23 @@ static void ice_free_irq_msix_misc(struct ice_pf *pf)
 /**
  * ice_ena_ctrlq_interrupts - enable control queue interrupts
  * @hw: pointer to HW structure
- * @v_idx: HW vector index to associate the control queue interrupts with
+ * @reg_idx: HW vector index to associate the control queue interrupts with
  */
-static void ice_ena_ctrlq_interrupts(struct ice_hw *hw, u16 v_idx)
+static void ice_ena_ctrlq_interrupts(struct ice_hw *hw, u16 reg_idx)
 {
 	u32 val;
 
-	val = ((v_idx & PFINT_OICR_CTL_MSIX_INDX_M) |
+	val = ((reg_idx & PFINT_OICR_CTL_MSIX_INDX_M) |
 	       PFINT_OICR_CTL_CAUSE_ENA_M);
 	wr32(hw, PFINT_OICR_CTL, val);
 
 	/* enable Admin queue Interrupt causes */
-	val = ((v_idx & PFINT_FW_CTL_MSIX_INDX_M) |
+	val = ((reg_idx & PFINT_FW_CTL_MSIX_INDX_M) |
 	       PFINT_FW_CTL_CAUSE_ENA_M);
 	wr32(hw, PFINT_FW_CTL, val);
 
 	/* enable Mailbox queue Interrupt causes */
-	val = ((v_idx & PFINT_MBX_CTL_MSIX_INDX_M) |
+	val = ((reg_idx & PFINT_MBX_CTL_MSIX_INDX_M) |
 	       PFINT_MBX_CTL_CAUSE_ENA_M);
 	wr32(hw, PFINT_MBX_CTL, val);
 
@@ -4214,8 +4214,7 @@ static void ice_tx_timeout(struct net_device *netdev)
 		/* Read interrupt register */
 		if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
 			val = rd32(hw,
-				   GLINT_DYN_CTL(tx_ring->q_vector->v_idx +
-						 tx_ring->vsi->hw_base_vector));
+				   GLINT_DYN_CTL(tx_ring->q_vector->reg_idx));
 
 		netdev_info(netdev, "tx_timeout: VSI_num: %d, Q %d, NTC: 0x%x, HW_HEAD: 0x%x, NTU: 0x%x, INT: 0x%x\n",
 			    vsi->vsi_num, hung_queue, tx_ring->next_to_clean,
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 259f118c7d8b..e5af775a3fd9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1391,7 +1391,7 @@ ice_update_ena_itr(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
 
 	if (!test_bit(__ICE_DOWN, vsi->state))
 		wr32(&vsi->back->hw,
-		     GLINT_DYN_CTL(vsi->hw_base_vector + q_vector->v_idx),
+		     GLINT_DYN_CTL(q_vector->reg_idx),
 		     itr_val);
 }
 
-- 
2.20.1

