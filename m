Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48152E4B7
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfE2Sru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:47:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:40834 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfE2Srq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:45 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] ice: Refactor interrupt tracking
Date:   Wed, 29 May 2019 11:47:47 -0700
Message-Id: <20190529184754.12693-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
References: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we have two MSI-x (IRQ) trackers, one for OS requested MSI-x
entries (sw_irq_tracker) and one for hardware MSI-x vectors
(hw_irq_tracker). Generally the sw_irq_tracker has less entries than the
hw_irq_tracker because the hw_irq_tracker has entries equal to the max
allowed MSI-x per PF and the sw_irq_tracker is mainly the minimum (non
SR-IOV portion of the vectors, kernel granted IRQs). All of the non
SR-IOV portions of the driver (i.e. LAN queues, RDMA queues, OICR, etc.)
take at least one of each type of tracker resource. SR-IOV only grabs
entries from the hw_irq_tracker. There are a few issues with this approach
that can be seen when doing any kind of device reconfiguration (i.e.
ethtool -L, SR-IOV, etc.). One of them being, any time the driver creates
an ice_q_vector and associates it to a LAN queue pair it will grab and
use one entry from the hw_irq_tracker and one from the sw_irq_tracker.
If the indices on these does not match it will cause a Tx timeout, which
will cause a reset and then the indices will match up again and traffic
will resume. The mismatched indices come from the trackers not being the
same size and/or the search_hint in the two trackers not being equal.
Another reason for the refactor is the co-existence of features with
SR-IOV. If SR-IOV is enabled and the interrupts are taken from the end
of the sw_irq_tracker then other features can no longer use this space
because the hardware has now given the remaining interrupts to SR-IOV.

This patch reworks how we track MSI-x vectors by removing the
hw_irq_tracker completely and instead MSI-x resources needed for SR-IOV
are determined all at once instead of per VF. This can be done because
when creating VFs we know how many are wanted and how many MSI-x vectors
each VF needs. This also allows us to start using MSI-x resources from
the end of the PF's allowed MSI-x vectors so we are less likely to use
entries needed for other features (i.e. RDMA, L2 Offload, etc).

This patch also reworks the ice_res_tracker structure by removing the
search_hint and adding a new member - "end". Instead of having a
search_hint we will always search from 0. The new member, "end", will be
used to manipulate the end of the ice_res_tracker (specifically
sw_irq_tracker) during runtime based on MSI-x vectors needed by SR-IOV.
In the normal case, the end of ice_res_tracker will be equal to the
ice_res_tracker's num_entries.

The sriov_base_vector member was added to the PF structure. It is used
to represent the starting MSI-x index of all the needed MSI-x vectors
for all SR-IOV VFs. Depending on how many MSI-x are needed, SR-IOV may
have to take resources from the sw_irq_tracker. This is done by setting
the sw_irq_tracker->end equal to the pf->sriov_base_vector. When all
SR-IOV VFs are removed then the sw_irq_tracker->end is reset back to
sw_irq_tracker->num_entries. The sriov_base_vector, along with the VF's
number of MSI-x (pf->num_vf_msix), vf_id, and the base MSI-x index on
the PF (pf->hw.func_caps.common_cap.msix_vector_first_id), is used to
calculate the first HW absolute MSI-x index for each VF, which is used
to write to the VPINT_ALLOC[_PCI] and GLINT_VECT2FUNC registers to
program the VFs MSI-x PCI configuration bits. Also, the sriov_base_vector
is used along with VF's num_vf_msix, vf_id, and q_vector->v_idx to
determine the MSI-x register index (used for writing to GLINT_DYN_CTL)
within the PF's space.

Interrupt changes removed any references to hw_base_vector, hw_oicr_idx,
and hw_irq_tracker. Only sw_base_vector, sw_oicr_idx, and sw_irq_tracker
variables remain. Change all of these by removing the "sw_" prefix to
help avoid confusion with these variables and their use.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  21 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   5 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 179 +++++------------
 drivers/net/ethernet/intel/ice/ice_main.c     |  82 +++-----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 186 ++++++++++++++++--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   8 +
 6 files changed, 263 insertions(+), 218 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 5c5b9e3e9e5c..c1e4dd7357b4 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -167,7 +167,7 @@ struct ice_tc_cfg {
 
 struct ice_res_tracker {
 	u16 num_entries;
-	u16 search_hint;
+	u16 end;
 	u16 list[1];
 };
 
@@ -252,8 +252,7 @@ struct ice_vsi {
 	u32 rx_buf_failed;
 	u32 rx_page_failed;
 	int num_q_vectors;
-	int sw_base_vector;		/* Irq base for OS reserved vectors */
-	int hw_base_vector;		/* HW (absolute) index of a vector */
+	int base_vector;		/* IRQ base for OS reserved vectors */
 	enum ice_vsi_type type;
 	u16 vsi_num;			/* HW (absolute) index of this VSI */
 	u16 idx;			/* software index in pf->vsi[] */
@@ -348,10 +347,12 @@ struct ice_pf {
 
 	/* OS reserved IRQ details */
 	struct msix_entry *msix_entries;
-	struct ice_res_tracker *sw_irq_tracker;
-
-	/* HW reserved Interrupts for this PF */
-	struct ice_res_tracker *hw_irq_tracker;
+	struct ice_res_tracker *irq_tracker;
+	/* First MSIX vector used by SR-IOV VFs. Calculated by subtracting the
+	 * number of MSIX vectors needed for all SR-IOV VFs from the number of
+	 * MSIX vectors allowed on this PF.
+	 */
+	u16 sriov_base_vector;
 
 	struct ice_vsi **vsi;		/* VSIs created by the driver */
 	struct ice_sw *first_sw;	/* first switch created by firmware */
@@ -373,10 +374,8 @@ struct ice_pf {
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	u32 msg_enable;
 	u32 hw_csum_rx_error;
-	u32 sw_oicr_idx;	/* Other interrupt cause SW vector index */
+	u32 oicr_idx;		/* Other interrupt cause MSIX vector index */
 	u32 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
-	u32 hw_oicr_idx;	/* Other interrupt cause vector HW index */
-	u32 num_avail_hw_msix;	/* remaining HW MSIX vectors left unclaimed */
 	u32 num_lan_msix;	/* Total MSIX vectors for base driver */
 	u16 num_lan_tx;		/* num LAN Tx queues setup */
 	u16 num_lan_rx;		/* num LAN Rx queues setup */
@@ -418,7 +417,7 @@ ice_irq_dynamic_ena(struct ice_hw *hw, struct ice_vsi *vsi,
 		    struct ice_q_vector *q_vector)
 {
 	u32 vector = (vsi && q_vector) ? q_vector->reg_idx :
-				((struct ice_pf *)hw->back)->hw_oicr_idx;
+				((struct ice_pf *)hw->back)->oicr_idx;
 	int itr = ICE_ITR_NONE;
 	u32 val;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 9dd628e20091..77c98b121e62 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -772,7 +772,7 @@ static u64 ice_intr_test(struct net_device *netdev)
 
 	netdev_info(netdev, "interrupt test\n");
 
-	wr32(&pf->hw, GLINT_DYN_CTL(pf->sw_oicr_idx),
+	wr32(&pf->hw, GLINT_DYN_CTL(pf->oicr_idx),
 	     GLINT_DYN_CTL_SW_ITR_INDX_M |
 	     GLINT_DYN_CTL_INTENA_MSK_M |
 	     GLINT_DYN_CTL_SWINT_TRIG_M);
@@ -2987,8 +2987,7 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 
 		if (ec->rx_coalesce_usecs_high != rc->ring->q_vector->intrl) {
 			rc->ring->q_vector->intrl = ec->rx_coalesce_usecs_high;
-			wr32(&pf->hw, GLINT_RATE(vsi->hw_base_vector +
-						 rc->ring->q_vector->v_idx),
+			wr32(&pf->hw, GLINT_RATE(rc->ring->q_vector->reg_idx),
 			     ice_intrl_usec_to_reg(ec->rx_coalesce_usecs_high,
 						   pf->hw.intrl_gran));
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 95323ee49e58..515b154547c5 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1168,61 +1168,32 @@ static int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
 static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
-	int num_q_vectors = 0;
+	u16 num_q_vectors;
 
-	if (vsi->sw_base_vector || vsi->hw_base_vector) {
-		dev_dbg(&pf->pdev->dev, "VSI %d has non-zero HW base vector %d or SW base vector %d\n",
-			vsi->vsi_num, vsi->hw_base_vector, vsi->sw_base_vector);
+	/* SRIOV doesn't grab irq_tracker entries for each VSI */
+	if (vsi->type == ICE_VSI_VF)
+		return 0;
+
+	if (vsi->base_vector) {
+		dev_dbg(&pf->pdev->dev, "VSI %d has non-zero base vector %d\n",
+			vsi->vsi_num, vsi->base_vector);
 		return -EEXIST;
 	}
 
 	if (!test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
 		return -ENOENT;
 
-	switch (vsi->type) {
-	case ICE_VSI_PF:
-		num_q_vectors = vsi->num_q_vectors;
-		/* reserve slots from OS requested IRQs */
-		vsi->sw_base_vector = ice_get_res(pf, pf->sw_irq_tracker,
-						  num_q_vectors, vsi->idx);
-		if (vsi->sw_base_vector < 0) {
-			dev_err(&pf->pdev->dev,
-				"Failed to get tracking for %d SW vectors for VSI %d, err=%d\n",
-				num_q_vectors, vsi->vsi_num,
-				vsi->sw_base_vector);
-			return -ENOENT;
-		}
-		pf->num_avail_sw_msix -= num_q_vectors;
-
-		/* reserve slots from HW interrupts */
-		vsi->hw_base_vector = ice_get_res(pf, pf->hw_irq_tracker,
-						  num_q_vectors, vsi->idx);
-		break;
-	case ICE_VSI_VF:
-		/* take VF misc vector and data vectors into account */
-		num_q_vectors = pf->num_vf_msix;
-		/* For VF VSI, reserve slots only from HW interrupts */
-		vsi->hw_base_vector = ice_get_res(pf, pf->hw_irq_tracker,
-						  num_q_vectors, vsi->idx);
-		break;
-	default:
-		dev_warn(&pf->pdev->dev, "Unknown VSI type %d\n", vsi->type);
-		break;
-	}
-
-	if (vsi->hw_base_vector < 0) {
+	num_q_vectors = vsi->num_q_vectors;
+	/* reserve slots from OS requested IRQs */
+	vsi->base_vector = ice_get_res(pf, pf->irq_tracker, num_q_vectors,
+				       vsi->idx);
+	if (vsi->base_vector < 0) {
 		dev_err(&pf->pdev->dev,
-			"Failed to get tracking for %d HW vectors for VSI %d, err=%d\n",
-			num_q_vectors, vsi->vsi_num, vsi->hw_base_vector);
-		if (vsi->type != ICE_VSI_VF) {
-			ice_free_res(pf->sw_irq_tracker,
-				     vsi->sw_base_vector, vsi->idx);
-			pf->num_avail_sw_msix += num_q_vectors;
-		}
+			"Failed to get tracking for %d vectors for VSI %d, err=%d\n",
+			num_q_vectors, vsi->vsi_num, vsi->base_vector);
 		return -ENOENT;
 	}
-
-	pf->num_avail_hw_msix -= num_q_vectors;
+	pf->num_avail_sw_msix -= num_q_vectors;
 
 	return 0;
 }
@@ -2261,7 +2232,14 @@ ice_vsi_set_q_vectors_reg_idx(struct ice_vsi *vsi)
 			goto clear_reg_idx;
 		}
 
-		q_vector->reg_idx = q_vector->v_idx + vsi->hw_base_vector;
+		if (vsi->type == ICE_VSI_VF) {
+			struct ice_vf *vf = &vsi->back->vf[vsi->vf_id];
+
+			q_vector->reg_idx = ice_calc_vf_reg_idx(vf, q_vector);
+		} else {
+			q_vector->reg_idx =
+				q_vector->v_idx + vsi->base_vector;
+		}
 	}
 
 	return 0;
@@ -2416,17 +2394,6 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		if (ret)
 			goto unroll_alloc_q_vector;
 
-		/* Setup Vector base only during VF init phase or when VF asks
-		 * for more vectors than assigned number. In all other cases,
-		 * assign hw_base_vector to the value given earlier.
-		 */
-		if (test_bit(ICE_VF_STATE_CFG_INTR, pf->vf[vf_id].vf_states)) {
-			ret = ice_vsi_setup_vector_base(vsi);
-			if (ret)
-				goto unroll_vector_base;
-		} else {
-			vsi->hw_base_vector = pf->vf[vf_id].first_vector_idx;
-		}
 		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
 		if (ret)
 			goto unroll_vector_base;
@@ -2470,11 +2437,8 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 
 unroll_vector_base:
 	/* reclaim SW interrupts back to the common pool */
-	ice_free_res(pf->sw_irq_tracker, vsi->sw_base_vector, vsi->idx);
+	ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
 	pf->num_avail_sw_msix += vsi->num_q_vectors;
-	/* reclaim HW interrupt back to the common pool */
-	ice_free_res(pf->hw_irq_tracker, vsi->hw_base_vector, vsi->idx);
-	pf->num_avail_hw_msix += vsi->num_q_vectors;
 unroll_alloc_q_vector:
 	ice_vsi_free_q_vectors(vsi);
 unroll_vsi_init:
@@ -2495,17 +2459,17 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 static void ice_vsi_release_msix(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
-	u16 vector = vsi->hw_base_vector;
 	struct ice_hw *hw = &pf->hw;
 	u32 txq = 0;
 	u32 rxq = 0;
 	int i, q;
 
-	for (i = 0; i < vsi->num_q_vectors; i++, vector++) {
+	for (i = 0; i < vsi->num_q_vectors; i++) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
+		u16 reg_idx = q_vector->reg_idx;
 
-		wr32(hw, GLINT_ITR(ICE_IDX_ITR0, vector), 0);
-		wr32(hw, GLINT_ITR(ICE_IDX_ITR1, vector), 0);
+		wr32(hw, GLINT_ITR(ICE_IDX_ITR0, reg_idx), 0);
+		wr32(hw, GLINT_ITR(ICE_IDX_ITR1, reg_idx), 0);
 		for (q = 0; q < q_vector->num_ring_tx; q++) {
 			wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), 0);
 			txq++;
@@ -2527,7 +2491,7 @@ static void ice_vsi_release_msix(struct ice_vsi *vsi)
 void ice_vsi_free_irq(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
-	int base = vsi->sw_base_vector;
+	int base = vsi->base_vector;
 
 	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags)) {
 		int i;
@@ -2623,11 +2587,11 @@ int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id)
 	int count = 0;
 	int i;
 
-	if (!res || index >= res->num_entries)
+	if (!res || index >= res->end)
 		return -EINVAL;
 
 	id |= ICE_RES_VALID_BIT;
-	for (i = index; i < res->num_entries && res->list[i] == id; i++) {
+	for (i = index; i < res->end && res->list[i] == id; i++) {
 		res->list[i] = 0;
 		count++;
 	}
@@ -2645,10 +2609,9 @@ int ice_free_res(struct ice_res_tracker *res, u16 index, u16 id)
  */
 static int ice_search_res(struct ice_res_tracker *res, u16 needed, u16 id)
 {
-	int start = res->search_hint;
-	int end = start;
+	int start = 0, end = 0;
 
-	if ((start + needed) > res->num_entries)
+	if (needed > res->end)
 		return -ENOMEM;
 
 	id |= ICE_RES_VALID_BIT;
@@ -2657,7 +2620,7 @@ static int ice_search_res(struct ice_res_tracker *res, u16 needed, u16 id)
 		/* skip already allocated entries */
 		if (res->list[end++] & ICE_RES_VALID_BIT) {
 			start = end;
-			if ((start + needed) > res->num_entries)
+			if ((start + needed) > res->end)
 				break;
 		}
 
@@ -2668,13 +2631,9 @@ static int ice_search_res(struct ice_res_tracker *res, u16 needed, u16 id)
 			while (i != end)
 				res->list[i++] = id;
 
-			if (end == res->num_entries)
-				end = 0;
-
-			res->search_hint = end;
 			return start;
 		}
-	} while (1);
+	} while (end < res->end);
 
 	return -ENOMEM;
 }
@@ -2686,16 +2645,11 @@ static int ice_search_res(struct ice_res_tracker *res, u16 needed, u16 id)
  * @needed: size of the block needed
  * @id: identifier to track owner
  *
- * Returns the base item index of the block, or -ENOMEM for error
- * The search_hint trick and lack of advanced fit-finding only works
- * because we're highly likely to have all the same sized requests.
- * Linear search time and any fragmentation should be minimal.
+ * Returns the base item index of the block, or negative for error
  */
 int
 ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id)
 {
-	int ret;
-
 	if (!res || !pf)
 		return -EINVAL;
 
@@ -2706,16 +2660,7 @@ ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id)
 		return -EINVAL;
 	}
 
-	/* search based on search_hint */
-	ret = ice_search_res(res, needed, id);
-
-	if (ret < 0) {
-		/* previous search failed. Reset search hint and try again */
-		res->search_hint = 0;
-		ret = ice_search_res(res, needed, id);
-	}
-
-	return ret;
+	return ice_search_res(res, needed, id);
 }
 
 /**
@@ -2724,7 +2669,7 @@ ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id)
  */
 void ice_vsi_dis_irq(struct ice_vsi *vsi)
 {
-	int base = vsi->sw_base_vector;
+	int base = vsi->base_vector;
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	u32 val;
@@ -2777,15 +2722,12 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
  */
 int ice_vsi_release(struct ice_vsi *vsi)
 {
-	struct ice_vf *vf = NULL;
 	struct ice_pf *pf;
 
 	if (!vsi->back)
 		return -ENODEV;
 	pf = vsi->back;
 
-	if (vsi->type == ICE_VSI_VF)
-		vf = &pf->vf[vsi->vf_id];
 	/* do not unregister while driver is in the reset recovery pending
 	 * state. Since reset/rebuild happens through PF service task workqueue,
 	 * it's not a good idea to unregister netdev that is associated to the
@@ -2803,21 +2745,15 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		ice_vsi_dis_irq(vsi);
 	ice_vsi_close(vsi);
 
-	/* reclaim interrupt vectors back to PF */
+	/* SR-IOV determines needed MSIX resources all at once instead of per
+	 * VSI since when VFs are spawned we know how many VFs there are and how
+	 * many interrupts each VF needs. SR-IOV MSIX resources are also
+	 * cleared in the same manner.
+	 */
 	if (vsi->type != ICE_VSI_VF) {
 		/* reclaim SW interrupts back to the common pool */
-		ice_free_res(pf->sw_irq_tracker, vsi->sw_base_vector, vsi->idx);
+		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
 		pf->num_avail_sw_msix += vsi->num_q_vectors;
-		/* reclaim HW interrupts back to the common pool */
-		ice_free_res(pf->hw_irq_tracker, vsi->hw_base_vector, vsi->idx);
-		pf->num_avail_hw_msix += vsi->num_q_vectors;
-	} else if (test_bit(ICE_VF_STATE_CFG_INTR, vf->vf_states)) {
-		/* Reclaim VF resources back only while freeing all VFs or
-		 * vector reassignment is requested
-		 */
-		ice_free_res(pf->hw_irq_tracker, vf->first_vector_idx,
-			     vsi->idx);
-		pf->num_avail_hw_msix += pf->num_vf_msix;
 	}
 
 	if (vsi->type == ICE_VSI_PF)
@@ -2873,24 +2809,17 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	ice_vsi_free_q_vectors(vsi);
 
+	/* SR-IOV determines needed MSIX resources all at once instead of per
+	 * VSI since when VFs are spawned we know how many VFs there are and how
+	 * many interrupts each VF needs. SR-IOV MSIX resources are also
+	 * cleared in the same manner.
+	 */
 	if (vsi->type != ICE_VSI_VF) {
 		/* reclaim SW interrupts back to the common pool */
-		ice_free_res(pf->sw_irq_tracker, vsi->sw_base_vector, vsi->idx);
+		ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
 		pf->num_avail_sw_msix += vsi->num_q_vectors;
-		vsi->sw_base_vector = 0;
-		/* reclaim HW interrupts back to the common pool */
-		ice_free_res(pf->hw_irq_tracker, vsi->hw_base_vector,
-			     vsi->idx);
-		pf->num_avail_hw_msix += vsi->num_q_vectors;
-	} else {
-		/* Reclaim VF resources back to the common pool for reset and
-		 * and rebuild, with vector reassignment
-		 */
-		ice_free_res(pf->hw_irq_tracker, vf->first_vector_idx,
-			     vsi->idx);
-		pf->num_avail_hw_msix += pf->num_vf_msix;
+		vsi->base_vector = 0;
 	}
-	vsi->hw_base_vector = 0;
 
 	ice_vsi_clear_rings(vsi);
 	ice_vsi_free_arrays(vsi);
@@ -2916,10 +2845,6 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 		if (ret)
 			goto err_rings;
 
-		ret = ice_vsi_setup_vector_base(vsi);
-		if (ret)
-			goto err_vectors;
-
 		ret = ice_vsi_set_q_vectors_reg_idx(vsi);
 		if (ret)
 			goto err_vectors;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4ca2d7a8d172..6fc4d8176d14 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -95,7 +95,7 @@ static void ice_check_for_hang_subtask(struct ice_pf *pf)
 				/* Trigger sw interrupt to revive the queue */
 				v_idx = tx_ring->q_vector->v_idx;
 				wr32(&vsi->back->hw,
-				     GLINT_DYN_CTL(vsi->hw_base_vector + v_idx),
+				     GLINT_DYN_CTL(vsi->base_vector + v_idx),
 				     (itr << GLINT_DYN_CTL_ITR_INDX_S) |
 				     GLINT_DYN_CTL_SWINT_TRIG_M |
 				     GLINT_DYN_CTL_INTENA_MSK_M);
@@ -1327,7 +1327,7 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 {
 	int q_vectors = vsi->num_q_vectors;
 	struct ice_pf *pf = vsi->back;
-	int base = vsi->sw_base_vector;
+	int base = vsi->base_vector;
 	int rx_int_idx = 0;
 	int tx_int_idx = 0;
 	int vector, err;
@@ -1408,7 +1408,7 @@ static void ice_ena_misc_vector(struct ice_pf *pf)
 	wr32(hw, PFINT_OICR_ENA, val);
 
 	/* SW_ITR_IDX = 0, but don't change INTENA */
-	wr32(hw, GLINT_DYN_CTL(pf->hw_oicr_idx),
+	wr32(hw, GLINT_DYN_CTL(pf->oicr_idx),
 	     GLINT_DYN_CTL_SW_ITR_INDX_M | GLINT_DYN_CTL_INTENA_MSK_M);
 }
 
@@ -1561,15 +1561,13 @@ static void ice_free_irq_msix_misc(struct ice_pf *pf)
 	ice_flush(hw);
 
 	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags) && pf->msix_entries) {
-		synchronize_irq(pf->msix_entries[pf->sw_oicr_idx].vector);
+		synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
 		devm_free_irq(&pf->pdev->dev,
-			      pf->msix_entries[pf->sw_oicr_idx].vector, pf);
+			      pf->msix_entries[pf->oicr_idx].vector, pf);
 	}
 
 	pf->num_avail_sw_msix += 1;
-	ice_free_res(pf->sw_irq_tracker, pf->sw_oicr_idx, ICE_RES_MISC_VEC_ID);
-	pf->num_avail_hw_msix += 1;
-	ice_free_res(pf->hw_irq_tracker, pf->hw_oicr_idx, ICE_RES_MISC_VEC_ID);
+	ice_free_res(pf->irq_tracker, pf->oicr_idx, ICE_RES_MISC_VEC_ID);
 }
 
 /**
@@ -1623,43 +1621,31 @@ static int ice_req_irq_msix_misc(struct ice_pf *pf)
 	if (ice_is_reset_in_progress(pf->state))
 		goto skip_req_irq;
 
-	/* reserve one vector in sw_irq_tracker for misc interrupts */
-	oicr_idx = ice_get_res(pf, pf->sw_irq_tracker, 1, ICE_RES_MISC_VEC_ID);
+	/* reserve one vector in irq_tracker for misc interrupts */
+	oicr_idx = ice_get_res(pf, pf->irq_tracker, 1, ICE_RES_MISC_VEC_ID);
 	if (oicr_idx < 0)
 		return oicr_idx;
 
 	pf->num_avail_sw_msix -= 1;
-	pf->sw_oicr_idx = oicr_idx;
-
-	/* reserve one vector in hw_irq_tracker for misc interrupts */
-	oicr_idx = ice_get_res(pf, pf->hw_irq_tracker, 1, ICE_RES_MISC_VEC_ID);
-	if (oicr_idx < 0) {
-		ice_free_res(pf->sw_irq_tracker, 1, ICE_RES_MISC_VEC_ID);
-		pf->num_avail_sw_msix += 1;
-		return oicr_idx;
-	}
-	pf->num_avail_hw_msix -= 1;
-	pf->hw_oicr_idx = oicr_idx;
+	pf->oicr_idx = oicr_idx;
 
 	err = devm_request_irq(&pf->pdev->dev,
-			       pf->msix_entries[pf->sw_oicr_idx].vector,
+			       pf->msix_entries[pf->oicr_idx].vector,
 			       ice_misc_intr, 0, pf->int_name, pf);
 	if (err) {
 		dev_err(&pf->pdev->dev,
 			"devm_request_irq for %s failed: %d\n",
 			pf->int_name, err);
-		ice_free_res(pf->sw_irq_tracker, 1, ICE_RES_MISC_VEC_ID);
+		ice_free_res(pf->irq_tracker, 1, ICE_RES_MISC_VEC_ID);
 		pf->num_avail_sw_msix += 1;
-		ice_free_res(pf->hw_irq_tracker, 1, ICE_RES_MISC_VEC_ID);
-		pf->num_avail_hw_msix += 1;
 		return err;
 	}
 
 skip_req_irq:
 	ice_ena_misc_vector(pf);
 
-	ice_ena_ctrlq_interrupts(hw, pf->hw_oicr_idx);
-	wr32(hw, GLINT_ITR(ICE_RX_ITR, pf->hw_oicr_idx),
+	ice_ena_ctrlq_interrupts(hw, pf->oicr_idx);
+	wr32(hw, GLINT_ITR(ICE_RX_ITR, pf->oicr_idx),
 	     ITR_REG_ALIGN(ICE_ITR_8K) >> ICE_ITR_GRAN_S);
 
 	ice_flush(hw);
@@ -2168,14 +2154,9 @@ static void ice_clear_interrupt_scheme(struct ice_pf *pf)
 	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
 		ice_dis_msix(pf);
 
-	if (pf->sw_irq_tracker) {
-		devm_kfree(&pf->pdev->dev, pf->sw_irq_tracker);
-		pf->sw_irq_tracker = NULL;
-	}
-
-	if (pf->hw_irq_tracker) {
-		devm_kfree(&pf->pdev->dev, pf->hw_irq_tracker);
-		pf->hw_irq_tracker = NULL;
+	if (pf->irq_tracker) {
+		devm_kfree(&pf->pdev->dev, pf->irq_tracker);
+		pf->irq_tracker = NULL;
 	}
 }
 
@@ -2185,7 +2166,7 @@ static void ice_clear_interrupt_scheme(struct ice_pf *pf)
  */
 static int ice_init_interrupt_scheme(struct ice_pf *pf)
 {
-	int vectors = 0, hw_vectors = 0;
+	int vectors;
 
 	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
 		vectors = ice_ena_msix_range(pf);
@@ -2196,31 +2177,18 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
 		return vectors;
 
 	/* set up vector assignment tracking */
-	pf->sw_irq_tracker =
-		devm_kzalloc(&pf->pdev->dev, sizeof(*pf->sw_irq_tracker) +
+	pf->irq_tracker =
+		devm_kzalloc(&pf->pdev->dev, sizeof(*pf->irq_tracker) +
 			     (sizeof(u16) * vectors), GFP_KERNEL);
-	if (!pf->sw_irq_tracker) {
+	if (!pf->irq_tracker) {
 		ice_dis_msix(pf);
 		return -ENOMEM;
 	}
 
 	/* populate SW interrupts pool with number of OS granted IRQs. */
 	pf->num_avail_sw_msix = vectors;
-	pf->sw_irq_tracker->num_entries = vectors;
-
-	/* set up HW vector assignment tracking */
-	hw_vectors = pf->hw.func_caps.common_cap.num_msix_vectors;
-	pf->hw_irq_tracker =
-		devm_kzalloc(&pf->pdev->dev, sizeof(*pf->hw_irq_tracker) +
-			     (sizeof(u16) * hw_vectors), GFP_KERNEL);
-	if (!pf->hw_irq_tracker) {
-		ice_clear_interrupt_scheme(pf);
-		return -ENOMEM;
-	}
-
-	/* populate HW interrupts pool with number of HW supported irqs. */
-	pf->num_avail_hw_msix = hw_vectors;
-	pf->hw_irq_tracker->num_entries = hw_vectors;
+	pf->irq_tracker->num_entries = vectors;
+	pf->irq_tracker->end = pf->irq_tracker->num_entries;
 
 	return 0;
 }
@@ -3794,12 +3762,6 @@ static void ice_rebuild(struct ice_pf *pf)
 
 	ice_dcb_rebuild(pf);
 
-	/* reset search_hint of irq_trackers to 0 since interrupts are
-	 * reclaimed and could be allocated from beginning during VSI rebuild
-	 */
-	pf->sw_irq_tracker->search_hint = 0;
-	pf->hw_irq_tracker->search_hint = 0;
-
 	err = ice_vsi_rebuild_all(pf);
 	if (err) {
 		dev_err(dev, "ice_vsi_rebuild_all failed\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index fd19ab53653d..0f79cf0e4ee8 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -205,8 +205,7 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
 	wr32(hw, VPINT_ALLOC(vf->vf_id), 0);
 	wr32(hw, VPINT_ALLOC_PCI(vf->vf_id), 0);
 
-	first = vf->first_vector_idx +
-		hw->func_caps.common_cap.msix_vector_first_id;
+	first = vf->first_vector_idx;
 	last = first + pf->num_vf_msix - 1;
 	for (v = first; v <= last; v++) {
 		u32 reg;
@@ -231,6 +230,42 @@ static void ice_dis_vf_mappings(struct ice_vf *vf)
 			"Scattered mode for VF Rx queues is not yet implemented\n");
 }
 
+/**
+ * ice_sriov_free_msix_res - Reset/free any used MSIX resources
+ * @pf: pointer to the PF structure
+ *
+ * If MSIX entries from the pf->irq_tracker were needed then we need to
+ * reset the irq_tracker->end and give back the entries we needed to
+ * num_avail_sw_msix.
+ *
+ * If no MSIX entries were taken from the pf->irq_tracker then just clear
+ * the pf->sriov_base_vector.
+ *
+ * Returns 0 on success, and -EINVAL on error.
+ */
+static int ice_sriov_free_msix_res(struct ice_pf *pf)
+{
+	struct ice_res_tracker *res;
+
+	if (!pf)
+		return -EINVAL;
+
+	res = pf->irq_tracker;
+	if (!res)
+		return -EINVAL;
+
+	/* give back irq_tracker resources used */
+	if (pf->sriov_base_vector < res->num_entries) {
+		res->end = res->num_entries;
+		pf->num_avail_sw_msix +=
+			res->num_entries - pf->sriov_base_vector;
+	}
+
+	pf->sriov_base_vector = 0;
+
+	return 0;
+}
+
 /**
  * ice_free_vfs - Free all VFs
  * @pf: pointer to the PF structure
@@ -288,6 +323,10 @@ void ice_free_vfs(struct ice_pf *pf)
 		}
 	}
 
+	if (ice_sriov_free_msix_res(pf))
+		dev_err(&pf->pdev->dev,
+			"Failed to free MSIX resources used by SR-IOV\n");
+
 	devm_kfree(&pf->pdev->dev, pf->vf);
 	pf->vf = NULL;
 
@@ -456,6 +495,22 @@ ice_vf_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi, u16 vf_id)
 	return ice_vsi_setup(pf, pi, ICE_VSI_VF, vf_id);
 }
 
+/**
+ * ice_calc_vf_first_vector_idx - Calculate absolute MSIX vector index in HW
+ * @pf: pointer to PF structure
+ * @vf: pointer to VF that the first MSIX vector index is being calculated for
+ *
+ * This returns the first MSIX vector index in HW that is used by this VF and
+ * this will always be the OICR index in the AVF driver so any functionality
+ * using vf->first_vector_idx for queue configuration will have to increment by
+ * 1 to avoid meddling with the OICR index.
+ */
+static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ice_vf *vf)
+{
+	return pf->hw.func_caps.common_cap.msix_vector_first_id +
+		pf->sriov_base_vector + vf->vf_id * pf->num_vf_msix;
+}
+
 /**
  * ice_alloc_vsi_res - Setup VF VSI and its resources
  * @vf: pointer to the VF structure
@@ -470,6 +525,9 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	struct ice_vsi *vsi;
 	int status = 0;
 
+	/* first vector index is the VFs OICR index */
+	vf->first_vector_idx = ice_calc_vf_first_vector_idx(pf, vf);
+
 	vsi = ice_vf_vsi_setup(pf, pf->hw.port_info, vf->vf_id);
 
 	if (!vsi) {
@@ -480,14 +538,6 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	vf->lan_vsi_idx = vsi->idx;
 	vf->lan_vsi_num = vsi->vsi_num;
 
-	/* first vector index is the VFs OICR index */
-	vf->first_vector_idx = vsi->hw_base_vector;
-	/* Since hw_base_vector holds the vector where data queue interrupts
-	 * starts, increment by 1 since VFs allocated vectors include OICR intr
-	 * as well.
-	 */
-	vsi->hw_base_vector += 1;
-
 	/* Check if port VLAN exist before, and restore it accordingly */
 	if (vf->port_vlan_id) {
 		ice_vsi_manage_pvid(vsi, vf->port_vlan_id, true);
@@ -580,8 +630,7 @@ static void ice_ena_vf_mappings(struct ice_vf *vf)
 
 	hw = &pf->hw;
 	vsi = pf->vsi[vf->lan_vsi_idx];
-	first = vf->first_vector_idx +
-		hw->func_caps.common_cap.msix_vector_first_id;
+	first = vf->first_vector_idx;
 	last = (first + pf->num_vf_msix) - 1;
 	abs_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
 
@@ -686,6 +735,97 @@ ice_determine_res(struct ice_pf *pf, u16 avail_res, u16 max_res, u16 min_res)
 	return 0;
 }
 
+/**
+ * ice_calc_vf_reg_idx - Calculate the VF's register index in the PF space
+ * @vf: VF to calculate the register index for
+ * @q_vector: a q_vector associated to the VF
+ */
+int ice_calc_vf_reg_idx(struct ice_vf *vf, struct ice_q_vector *q_vector)
+{
+	struct ice_pf *pf;
+
+	if (!vf || !q_vector)
+		return -EINVAL;
+
+	pf = vf->pf;
+
+	/* always add one to account for the OICR being the first MSIX */
+	return pf->sriov_base_vector + pf->num_vf_msix * vf->vf_id +
+		q_vector->v_idx + 1;
+}
+
+/**
+ * ice_get_max_valid_res_idx - Get the max valid resource index
+ * @res: pointer to the resource to find the max valid index for
+ *
+ * Start from the end of the ice_res_tracker and return right when we find the
+ * first res->list entry with the ICE_RES_VALID_BIT set. This function is only
+ * valid for SR-IOV because it is the only consumer that manipulates the
+ * res->end and this is always called when res->end is set to res->num_entries.
+ */
+static int ice_get_max_valid_res_idx(struct ice_res_tracker *res)
+{
+	int i;
+
+	if (!res)
+		return -EINVAL;
+
+	for (i = res->num_entries - 1; i >= 0; i--)
+		if (res->list[i] & ICE_RES_VALID_BIT)
+			return i;
+
+	return 0;
+}
+
+/**
+ * ice_sriov_set_msix_res - Set any used MSIX resources
+ * @pf: pointer to PF structure
+ * @num_msix_needed: number of MSIX vectors needed for all SR-IOV VFs
+ *
+ * This function allows SR-IOV resources to be taken from the end of the PF's
+ * allowed HW MSIX vectors so in many cases the irq_tracker will not
+ * be needed. In these cases we just set the pf->sriov_base_vector and return
+ * success.
+ *
+ * If SR-IOV needs to use any pf->irq_tracker entries it updates the
+ * irq_tracker->end based on the first entry needed for SR-IOV. This makes it
+ * so any calls to ice_get_res() using the irq_tracker will not try to use
+ * resources at or beyond the newly set value.
+ *
+ * Return 0 on success, and -EINVAL when there are not enough MSIX vectors in
+ * in the PF's space available for SR-IOV.
+ */
+static int ice_sriov_set_msix_res(struct ice_pf *pf, u16 num_msix_needed)
+{
+	int max_valid_res_idx = ice_get_max_valid_res_idx(pf->irq_tracker);
+	u16 pf_total_msix_vectors =
+		pf->hw.func_caps.common_cap.num_msix_vectors;
+	struct ice_res_tracker *res = pf->irq_tracker;
+	int sriov_base_vector;
+
+	if (max_valid_res_idx < 0)
+		return max_valid_res_idx;
+
+	sriov_base_vector = pf_total_msix_vectors - num_msix_needed;
+
+	/* make sure we only grab irq_tracker entries from the list end and
+	 * that we have enough available MSIX vectors
+	 */
+	if (sriov_base_vector <= max_valid_res_idx)
+		return -EINVAL;
+
+	pf->sriov_base_vector = sriov_base_vector;
+
+	/* dip into irq_tracker entries and update used resources */
+	if (num_msix_needed > (pf_total_msix_vectors - res->num_entries)) {
+		pf->num_avail_sw_msix -=
+			res->num_entries - pf->sriov_base_vector;
+		res->end = pf->sriov_base_vector;
+	}
+
+	return 0;
+}
+
 /**
  * ice_check_avail_res - check if vectors and queues are available
  * @pf: pointer to the PF structure
@@ -696,11 +836,16 @@ ice_determine_res(struct ice_pf *pf, u16 avail_res, u16 max_res, u16 min_res)
  */
 static int ice_check_avail_res(struct ice_pf *pf)
 {
-	u16 num_msix, num_txq, num_rxq;
+	int max_valid_res_idx = ice_get_max_valid_res_idx(pf->irq_tracker);
+	u16 num_msix, num_txq, num_rxq, num_avail_msix;
 
-	if (!pf->num_alloc_vfs)
+	if (!pf->num_alloc_vfs || max_valid_res_idx < 0)
 		return -EINVAL;
 
+	/* add 1 to max_valid_res_idx to account for it being 0-based */
+	num_avail_msix = pf->hw.func_caps.common_cap.num_msix_vectors -
+		(max_valid_res_idx + 1);
+
 	/* Grab from HW interrupts common pool
 	 * Note: By the time the user decides it needs more vectors in a VF
 	 * its already too late since one must decide this prior to creating the
@@ -717,11 +862,11 @@ static int ice_check_avail_res(struct ice_pf *pf)
 	 * grab default interrupt vectors (5 as supported by AVF driver).
 	 */
 	if (pf->num_alloc_vfs <= 16) {
-		num_msix = ice_determine_res(pf, pf->num_avail_hw_msix,
+		num_msix = ice_determine_res(pf, num_avail_msix,
 					     ICE_MAX_INTR_PER_VF,
 					     ICE_MIN_INTR_PER_VF);
 	} else if (pf->num_alloc_vfs <= ICE_MAX_VF_COUNT) {
-		num_msix = ice_determine_res(pf, pf->num_avail_hw_msix,
+		num_msix = ice_determine_res(pf, num_avail_msix,
 					     ICE_DFLT_INTR_PER_VF,
 					     ICE_MIN_INTR_PER_VF);
 	} else {
@@ -750,6 +895,9 @@ static int ice_check_avail_res(struct ice_pf *pf)
 	if (!num_txq || !num_rxq)
 		return -EIO;
 
+	if (ice_sriov_set_msix_res(pf, num_msix * pf->num_alloc_vfs))
+		return -EINVAL;
+
 	/* since AVF driver works with only queue pairs which means, it expects
 	 * to have equal number of Rx and Tx queues, so take the minimum of
 	 * available Tx or Rx queues
@@ -938,6 +1086,10 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		vf->num_vf_qs = 0;
 	}
 
+	if (ice_sriov_free_msix_res(pf))
+		dev_err(&pf->pdev->dev,
+			"Failed to free MSIX resources used by SR-IOV\n");
+
 	if (ice_check_avail_res(pf)) {
 		dev_err(&pf->pdev->dev,
 			"Cannot allocate VF resources, try with fewer number of VFs\n");
@@ -1119,7 +1271,7 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 	int i, ret;
 
 	/* Disable global interrupt 0 so we don't try to handle the VFLR. */
-	wr32(hw, GLINT_DYN_CTL(pf->hw_oicr_idx),
+	wr32(hw, GLINT_DYN_CTL(pf->oicr_idx),
 	     ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S);
 
 	ice_flush(hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 9583ad3f6fb6..c3ca522c245a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -101,6 +101,8 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted);
 int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state);
 
 int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena);
+
+int ice_calc_vf_reg_idx(struct ice_vf *vf, struct ice_q_vector *q_vector);
 #else /* CONFIG_PCI_IOV */
 #define ice_process_vflr_event(pf) do {} while (0)
 #define ice_free_vfs(pf) do {} while (0)
@@ -166,5 +168,11 @@ ice_set_vf_link_state(struct net_device __always_unused *netdev,
 	return -EOPNOTSUPP;
 }
 
+static inline int
+ice_calc_vf_reg_idx(struct ice_vf __always_unused *vf,
+		    struct ice_q_vector __always_unused *q_vector)
+{
+	return 0;
+}
 #endif /* CONFIG_PCI_IOV */
 #endif /* _ICE_VIRTCHNL_PF_H_ */
-- 
2.21.0

