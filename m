Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A5C35FEDF
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhDOA3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:27420 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231486AbhDOA2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:49 -0400
IronPort-SDR: B/k5WSI62LodqL3HFk/lijFk+D/As0Uhe3t01pL9SM/k3IKwUroU4I62DtICfm+DP3+pOvrGIH
 EhLhJWoQlbzw==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262235"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262235"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:26 -0700
IronPort-SDR: m26cpwSTNUBvcLTtR972hMS3XcTpCuSNCZG0ysJ9nDPt+PGtGcrBBYmc12eJRnutil3M9Ret29
 IfpqxvCtgSQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379506"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 04/15] ice: refactor interrupt moderation writes
Date:   Wed, 14 Apr 2021 17:30:02 -0700
Message-Id: <20210415003013.19717-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Introduce several new helpers for writing ITR and GLINT_RATE
registers, and refactor the code calling them.  This resulted
in removal of several duplicate functions and rolled a bunch
of simple code back into the calling routines.

In particular this removes some code that was doing both
a store and a set in a helper function, which seems better
done as separate tasks in the caller (and generally takes
less lines of code even with a tiny bit of repetition).

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c    |  22 +--
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  17 +-
 drivers/net/ethernet/intel/ice/ice_lib.c     | 171 ++++++++++---------
 drivers/net/ethernet/intel/ice/ice_lib.h     |   3 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c     |   3 -
 5 files changed, 112 insertions(+), 104 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index be26775a7dfe..21eb5d447d31 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -740,25 +740,13 @@ void ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector)
 {
 	ice_cfg_itr_gran(hw);
 
-	if (q_vector->num_ring_rx) {
-		struct ice_ring_container *rc = &q_vector->rx;
-
-		rc->target_itr = ITR_TO_REG(rc->itr_setting);
-		rc->next_update = jiffies + 1;
-		rc->current_itr = rc->target_itr;
-		wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
-		     ITR_REG_ALIGN(rc->current_itr) >> ICE_ITR_GRAN_S);
-	}
+	if (q_vector->num_ring_rx)
+		ice_write_itr(&q_vector->rx, q_vector->rx.itr_setting);
 
-	if (q_vector->num_ring_tx) {
-		struct ice_ring_container *rc = &q_vector->tx;
+	if (q_vector->num_ring_tx)
+		ice_write_itr(&q_vector->tx, q_vector->tx.itr_setting);
 
-		rc->target_itr = ITR_TO_REG(rc->itr_setting);
-		rc->next_update = jiffies + 1;
-		rc->current_itr = rc->target_itr;
-		wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
-		     ITR_REG_ALIGN(rc->current_itr) >> ICE_ITR_GRAN_S);
-	}
+	ice_write_intrl(q_vector, q_vector->intrl);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index f2bc8f1e86cc..e273560d9e6e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3636,9 +3636,8 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 		}
 		if (ec->rx_coalesce_usecs_high != rc->ring->q_vector->intrl) {
 			rc->ring->q_vector->intrl = ec->rx_coalesce_usecs_high;
-			wr32(&pf->hw, GLINT_RATE(rc->ring->q_vector->reg_idx),
-			     ice_intrl_usec_to_reg(ec->rx_coalesce_usecs_high,
-						   pf->hw.intrl_gran));
+			ice_write_intrl(rc->ring->q_vector,
+					ec->rx_coalesce_usecs_high);
 		}
 
 		use_adaptive_coalesce = ec->use_adaptive_rx_coalesce;
@@ -3672,10 +3671,15 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 	if (use_adaptive_coalesce) {
 		rc->itr_setting |= ICE_ITR_DYNAMIC;
 	} else {
-		/* save the user set usecs */
+		/* store user facing value how it was set */
 		rc->itr_setting = coalesce_usecs;
-		/* device ITR granularity is in 2 usec increments */
-		rc->target_itr = ITR_REG_ALIGN(rc->itr_setting);
+		/* write the change to the register */
+		ice_write_itr(rc, coalesce_usecs);
+		/* force writes to take effect immediately, the flush shouldn't
+		 * be done in the functions above because the intent is for
+		 * them to do lazy writes.
+		 */
+		ice_flush(&pf->hw);
 	}
 
 	return 0;
@@ -3793,7 +3797,6 @@ __ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 		return -EINVAL;
 
 set_complete:
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 40a9b034d73b..bb47376386f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1773,7 +1773,7 @@ int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
  * This function converts a decimal interrupt rate limit in usecs to the format
  * expected by firmware.
  */
-u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran)
+static u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran)
 {
 	u32 val = intrl / gran;
 
@@ -1782,6 +1782,58 @@ u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran)
 	return 0;
 }
 
+/**
+ * ice_write_intrl - write throttle rate limit to interrupt specific register
+ * @q_vector: pointer to interrupt specific structure
+ * @intrl: throttle rate limit in microseconds to write
+ */
+void ice_write_intrl(struct ice_q_vector *q_vector, u8 intrl)
+{
+	struct ice_hw *hw = &q_vector->vsi->back->hw;
+
+	wr32(hw, GLINT_RATE(q_vector->reg_idx),
+	     ice_intrl_usec_to_reg(intrl, ICE_INTRL_GRAN_ABOVE_25));
+}
+
+/**
+ * __ice_write_itr - write throttle rate to register
+ * @q_vector: pointer to interrupt data structure
+ * @rc: pointer to ring container
+ * @itr: throttle rate in microseconds to write
+ */
+static void __ice_write_itr(struct ice_q_vector *q_vector,
+			    struct ice_ring_container *rc, u16 itr)
+{
+	struct ice_hw *hw = &q_vector->vsi->back->hw;
+
+	wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
+	     ITR_REG_ALIGN(itr) >> ICE_ITR_GRAN_S);
+}
+
+/**
+ * ice_write_itr - write throttle rate to queue specific register
+ * @rc: pointer to ring container
+ * @itr: throttle rate in microseconds to write
+ *
+ * This function is resilient to having the 0x8000 bit set which
+ * is indicating that an ITR value is "DYNAMIC", and will write
+ * the correct value to the register.
+ */
+void ice_write_itr(struct ice_ring_container *rc, u16 itr)
+{
+	struct ice_q_vector *q_vector;
+
+	if (!rc->ring)
+		return;
+
+	q_vector = rc->ring->q_vector;
+
+	/* clear the "DYNAMIC" bit */
+	itr = ITR_TO_REG(itr);
+
+	__ice_write_itr(q_vector, rc, itr);
+}
+
 /**
  * ice_vsi_cfg_msix - MSIX mode Interrupt Config in the HW
  * @vsi: the VSI being configured
@@ -1802,9 +1854,6 @@ void ice_vsi_cfg_msix(struct ice_vsi *vsi)
 
 		ice_cfg_itr(hw, q_vector);
 
-		wr32(hw, GLINT_RATE(reg_idx),
-		     ice_intrl_usec_to_reg(q_vector->intrl, hw->intrl_gran));
-
 		/* Both Transmit Queue Interrupt Cause Control register
 		 * and Receive Queue Interrupt Cause control register
 		 * expects MSIX_INDX field to be the vector index
@@ -2492,11 +2541,10 @@ static void ice_vsi_release_msix(struct ice_vsi *vsi)
 
 	for (i = 0; i < vsi->num_q_vectors; i++) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
-		u16 reg_idx = q_vector->reg_idx;
 
-		wr32(hw, GLINT_ITR(ICE_IDX_ITR0, reg_idx), 0);
-		wr32(hw, GLINT_ITR(ICE_IDX_ITR1, reg_idx), 0);
+		ice_write_intrl(q_vector, 0);
 		for (q = 0; q < q_vector->num_ring_tx; q++) {
+			ice_write_itr(&q_vector->tx, 0);
 			wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), 0);
 			if (ice_is_xdp_ena_vsi(vsi)) {
 				u32 xdp_txq = txq + vsi->num_xdp_txq;
@@ -2507,6 +2555,7 @@ static void ice_vsi_release_msix(struct ice_vsi *vsi)
 		}
 
 		for (q = 0; q < q_vector->num_ring_rx; q++) {
+			ice_write_itr(&q_vector->rx, 0);
 			wr32(hw, QINT_RQCTL(vsi->rxq_map[rxq]), 0);
 			rxq++;
 		}
@@ -2843,47 +2892,6 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	return 0;
 }
 
-/**
- * ice_vsi_rebuild_update_coalesce_intrl - set interrupt rate limit for a q_vector
- * @q_vector: pointer to q_vector which is being updated
- * @stored_intrl_setting: original INTRL setting
- *
- * Set coalesce param in q_vector and update these parameters in HW.
- */
-static void
-ice_vsi_rebuild_update_coalesce_intrl(struct ice_q_vector *q_vector,
-				      u16 stored_intrl_setting)
-{
-	struct ice_hw *hw = &q_vector->vsi->back->hw;
-
-	q_vector->intrl = stored_intrl_setting;
-	wr32(hw, GLINT_RATE(q_vector->reg_idx),
-	     ice_intrl_usec_to_reg(q_vector->intrl, hw->intrl_gran));
-}
-
-/**
- * ice_vsi_rebuild_update_coalesce_itr - set coalesce for a q_vector
- * @q_vector: pointer to q_vector which is being updated
- * @rc: pointer to ring container
- * @stored_itr_setting: original ITR setting
- *
- * Set coalesce param in q_vector and update these parameters in HW.
- */
-static void
-ice_vsi_rebuild_update_coalesce_itr(struct ice_q_vector *q_vector,
-				    struct ice_ring_container *rc,
-				    u16 stored_itr_setting)
-{
-	struct ice_hw *hw = &q_vector->vsi->back->hw;
-
-	rc->itr_setting = stored_itr_setting;
-
-	/* dynamic ITR values will be updated during Tx/Rx */
-	if (!ITR_IS_DYNAMIC(rc->itr_setting))
-		wr32(hw, GLINT_ITR(rc->itr_idx, q_vector->reg_idx),
-		     ITR_REG_ALIGN(rc->itr_setting) >> ICE_ITR_GRAN_S);
-}
-
 /**
  * ice_vsi_rebuild_get_coalesce - get coalesce from all q_vectors
  * @vsi: VSI connected with q_vectors
@@ -2927,6 +2935,7 @@ static void
 ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 			     struct ice_coalesce_stored *coalesce, int size)
 {
+	struct ice_ring_container *rc;
 	int i;
 
 	if ((size && !coalesce) || !vsi)
@@ -2949,41 +2958,51 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 		 *   rings is less than are allocated (this means the number of
 		 *   rings increased from previously), then write out the
 		 *   values in the first element
+		 *
+		 *   Also, always write the ITR, even if in ITR_IS_DYNAMIC
+		 *   as there is no harm because the dynamic algorithm
+		 *   will just overwrite.
 		 */
-		if (i < vsi->alloc_rxq && coalesce[i].rx_valid)
-			ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
-							    &vsi->q_vectors[i]->rx,
-							    coalesce[i].itr_rx);
-		else if (i < vsi->alloc_rxq)
-			ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
-							    &vsi->q_vectors[i]->rx,
-							    coalesce[0].itr_rx);
-
-		if (i < vsi->alloc_txq && coalesce[i].tx_valid)
-			ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
-							    &vsi->q_vectors[i]->tx,
-							    coalesce[i].itr_tx);
-		else if (i < vsi->alloc_txq)
-			ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
-							    &vsi->q_vectors[i]->tx,
-							    coalesce[0].itr_tx);
-
-		ice_vsi_rebuild_update_coalesce_intrl(vsi->q_vectors[i],
-						      coalesce[i].intrl);
+		if (i < vsi->alloc_rxq && coalesce[i].rx_valid) {
+			rc = &vsi->q_vectors[i]->rx;
+			rc->itr_setting = coalesce[i].itr_rx;
+			ice_write_itr(rc, rc->itr_setting);
+		} else if (i < vsi->alloc_rxq) {
+			rc = &vsi->q_vectors[i]->rx;
+			rc->itr_setting = coalesce[0].itr_rx;
+			ice_write_itr(rc, rc->itr_setting);
+		}
+
+		if (i < vsi->alloc_txq && coalesce[i].tx_valid) {
+			rc = &vsi->q_vectors[i]->tx;
+			rc->itr_setting = coalesce[i].itr_tx;
+			ice_write_itr(rc, rc->itr_setting);
+		} else if (i < vsi->alloc_txq) {
+			rc = &vsi->q_vectors[i]->tx;
+			rc->itr_setting = coalesce[0].itr_tx;
+			ice_write_itr(rc, rc->itr_setting);
+		}
+
+		vsi->q_vectors[i]->intrl = coalesce[i].intrl;
+		ice_write_intrl(vsi->q_vectors[i], coalesce[i].intrl);
 	}
 
 	/* the number of queue vectors increased so write whatever is in
 	 * the first element
 	 */
 	for (; i < vsi->num_q_vectors; i++) {
-		ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
-						    &vsi->q_vectors[i]->tx,
-						    coalesce[0].itr_tx);
-		ice_vsi_rebuild_update_coalesce_itr(vsi->q_vectors[i],
-						    &vsi->q_vectors[i]->rx,
-						    coalesce[0].itr_rx);
-		ice_vsi_rebuild_update_coalesce_intrl(vsi->q_vectors[i],
-						      coalesce[0].intrl);
+		/* transmit */
+		rc = &vsi->q_vectors[i]->tx;
+		rc->itr_setting = coalesce[0].itr_tx;
+		ice_write_itr(rc, rc->itr_setting);
+
+		/* receive */
+		rc = &vsi->q_vectors[i]->rx;
+		rc->itr_setting = coalesce[0].itr_rx;
+		ice_write_itr(rc, rc->itr_setting);
+
+		vsi->q_vectors[i]->intrl = coalesce[0].intrl;
+		ice_write_intrl(vsi->q_vectors[i], coalesce[0].intrl);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 462c3ab7abad..f48c5ccb8036 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -95,7 +95,8 @@ void ice_vsi_cfg_frame_size(struct ice_vsi *vsi);
 
 int ice_status_to_errno(enum ice_status err);
 
-u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran);
+void ice_write_intrl(struct ice_q_vector *q_vector, u8 intrl);
+void ice_write_itr(struct ice_ring_container *rc, u16 itr);
 
 enum ice_status
 ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index b881b650af98..faa7b8d96adb 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -108,9 +108,6 @@ ice_qvec_cfg_msix(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
 
 	ice_cfg_itr(hw, q_vector);
 
-	wr32(hw, GLINT_RATE(reg_idx),
-	     ice_intrl_usec_to_reg(q_vector->intrl, hw->intrl_gran));
-
 	ice_for_each_ring(ring, q_vector->tx)
 		ice_cfg_txq_interrupt(vsi, ring->reg_idx, reg_idx,
 				      q_vector->tx.itr_idx);
-- 
2.26.2

