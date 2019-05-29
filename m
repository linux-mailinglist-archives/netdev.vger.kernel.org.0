Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7882E4B8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfE2Srv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:47:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:64227 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbfE2Srt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:46 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:46 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] ice: Add a helper to trigger software interrupt
Date:   Wed, 29 May 2019 11:47:54 -0700
Message-Id: <20190529184754.12693-16-jeffrey.t.kirsher@intel.com>
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

Add a new function ice_trigger_sw_intr to trigger interrupts.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 24 +++++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_lib.h  |  2 ++
 drivers/net/ethernet/intel/ice/ice_main.c | 14 +++++--------
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 74008d748f3a..8db9427d863f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2018,6 +2018,19 @@ int ice_vsi_stop_rx_rings(struct ice_vsi *vsi)
 	return ice_vsi_ctrl_rx_rings(vsi, false);
 }
 
+/**
+ * ice_trigger_sw_intr - trigger a software interrupt
+ * @hw: pointer to the HW structure
+ * @q_vector: interrupt vector to trigger the software interrupt for
+ */
+void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector *q_vector)
+{
+	wr32(hw, GLINT_DYN_CTL(q_vector->reg_idx),
+	     (ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S) |
+	     GLINT_DYN_CTL_SWINT_TRIG_M |
+	     GLINT_DYN_CTL_INTENA_M);
+}
+
 /**
  * ice_vsi_stop_tx_rings - Disable Tx rings
  * @vsi: the VSI being configured
@@ -2065,6 +2078,8 @@ ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 			break;
 
 		for (i = 0; i < vsi->tc_cfg.tc_info[tc].qcount_tx; i++) {
+			struct ice_q_vector *q_vector;
+
 			if (!rings || !rings[q_idx]) {
 				err = -EINVAL;
 				goto err_out;
@@ -2085,13 +2100,10 @@ ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 			/* trigger a software interrupt for the vector
 			 * associated to the queue to schedule NAPI handler
 			 */
-			if (rings[q_idx]->q_vector) {
-				int reg_idx = rings[i]->q_vector->reg_idx;
+			q_vector = rings[i]->q_vector;
+			if (q_vector)
+				ice_trigger_sw_intr(hw, q_vector);
 
-				wr32(hw, GLINT_DYN_CTL(reg_idx),
-				     GLINT_DYN_CTL_SWINT_TRIG_M |
-				     GLINT_DYN_CTL_INTENA_MSK_M);
-			}
 			q_idx++;
 		}
 		status = ice_dis_vsi_txq(vsi->port_info, vsi->idx, tc,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index a91d3553cc89..3605b7ca9120 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -64,6 +64,8 @@ bool ice_is_reset_in_progress(unsigned long *state);
 
 void ice_vsi_free_q_vectors(struct ice_vsi *vsi);
 
+void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector *q_vector);
+
 void ice_vsi_put_qs(struct ice_vsi *vsi);
 
 #ifdef CONFIG_DCB
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 95ac79bfd92a..0bcc8402a5ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -61,9 +61,10 @@ static u32 ice_get_tx_pending(struct ice_ring *ring)
 static void ice_check_for_hang_subtask(struct ice_pf *pf)
 {
 	struct ice_vsi *vsi = NULL;
+	struct ice_hw *hw;
 	unsigned int i;
-	u32 v, v_idx;
 	int packets;
+	u32 v;
 
 	ice_for_each_vsi(pf, v)
 		if (pf->vsi[v] && pf->vsi[v]->type == ICE_VSI_PF) {
@@ -77,12 +78,12 @@ static void ice_check_for_hang_subtask(struct ice_pf *pf)
 	if (!(vsi->netdev && netif_carrier_ok(vsi->netdev)))
 		return;
 
+	hw = &vsi->back->hw;
+
 	for (i = 0; i < vsi->num_txq; i++) {
 		struct ice_ring *tx_ring = vsi->tx_rings[i];
 
 		if (tx_ring && tx_ring->desc) {
-			int itr = ICE_ITR_NONE;
-
 			/* If packet counter has not changed the queue is
 			 * likely stalled, so force an interrupt for this
 			 * queue.
@@ -93,12 +94,7 @@ static void ice_check_for_hang_subtask(struct ice_pf *pf)
 			packets = tx_ring->stats.pkts & INT_MAX;
 			if (tx_ring->tx_stats.prev_pkt == packets) {
 				/* Trigger sw interrupt to revive the queue */
-				v_idx = tx_ring->q_vector->v_idx;
-				wr32(&vsi->back->hw,
-				     GLINT_DYN_CTL(vsi->base_vector + v_idx),
-				     (itr << GLINT_DYN_CTL_ITR_INDX_S) |
-				     GLINT_DYN_CTL_SWINT_TRIG_M |
-				     GLINT_DYN_CTL_INTENA_MSK_M);
+				ice_trigger_sw_intr(hw, tx_ring->q_vector);
 				continue;
 			}
 
-- 
2.21.0

