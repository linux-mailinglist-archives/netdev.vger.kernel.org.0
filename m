Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6EFAAAD0E
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391654AbfIEUeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:45332 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388090AbfIEUeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136539"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/16] ice: clean up arguments
Date:   Thu,  5 Sep 2019 13:33:54 -0700
Message-Id: <20190905203406.4152-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

There are a couple of functions that don't need two arguments
passed in when the second argument already had access to
the pointer pointed to by the first.

Remove the unnecessary arguments.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 43 +++++++++++------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 5bf5c179a738..4fe1b332e67e 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -95,17 +95,16 @@ void ice_free_tx_ring(struct ice_ring *tx_ring)
 
 /**
  * ice_clean_tx_irq - Reclaim resources after transmit completes
- * @vsi: the VSI we care about
  * @tx_ring: Tx ring to clean
  * @napi_budget: Used to determine if we are in netpoll
  *
  * Returns true if there's any budget left (e.g. the clean is finished)
  */
-static bool
-ice_clean_tx_irq(struct ice_vsi *vsi, struct ice_ring *tx_ring, int napi_budget)
+static bool ice_clean_tx_irq(struct ice_ring *tx_ring, int napi_budget)
 {
 	unsigned int total_bytes = 0, total_pkts = 0;
-	unsigned int budget = vsi->work_lmt;
+	unsigned int budget = ICE_DFLT_IRQ_WORK;
+	struct ice_vsi *vsi = tx_ring->vsi;
 	s16 i = tx_ring->next_to_clean;
 	struct ice_tx_desc *tx_desc;
 	struct ice_tx_buf *tx_buf;
@@ -114,6 +113,8 @@ ice_clean_tx_irq(struct ice_vsi *vsi, struct ice_ring *tx_ring, int napi_budget)
 	tx_desc = ICE_TX_DESC(tx_ring, i);
 	i -= tx_ring->count;
 
+	prefetch(&vsi->state);
+
 	do {
 		struct ice_tx_desc *eop_desc = tx_buf->next_to_watch;
 
@@ -206,7 +207,7 @@ ice_clean_tx_irq(struct ice_vsi *vsi, struct ice_ring *tx_ring, int napi_budget)
 		smp_mb();
 		if (__netif_subqueue_stopped(tx_ring->netdev,
 					     tx_ring->q_index) &&
-		   !test_bit(__ICE_DOWN, vsi->state)) {
+		    !test_bit(__ICE_DOWN, vsi->state)) {
 			netif_wake_subqueue(tx_ring->netdev,
 					    tx_ring->q_index);
 			++tx_ring->tx_stats.restart_q;
@@ -879,7 +880,7 @@ ice_rx_hash(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
 
 /**
  * ice_rx_csum - Indicate in skb if checksum is good
- * @vsi: the VSI we care about
+ * @ring: the ring we care about
  * @skb: skb currently being received and modified
  * @rx_desc: the receive descriptor
  * @ptype: the packet type decoded by hardware
@@ -887,7 +888,7 @@ ice_rx_hash(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
  * skb->protocol must be set before this function is called
  */
 static void
-ice_rx_csum(struct ice_vsi *vsi, struct sk_buff *skb,
+ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
 	    union ice_32b_rx_flex_desc *rx_desc, u8 ptype)
 {
 	struct ice_rx_ptype_decoded decoded;
@@ -904,7 +905,7 @@ ice_rx_csum(struct ice_vsi *vsi, struct sk_buff *skb,
 	skb_checksum_none_assert(skb);
 
 	/* check if Rx checksum is enabled */
-	if (!(vsi->netdev->features & NETIF_F_RXCSUM))
+	if (!(ring->netdev->features & NETIF_F_RXCSUM))
 		return;
 
 	/* check if HW has decoded the packet and checksum */
@@ -944,7 +945,7 @@ ice_rx_csum(struct ice_vsi *vsi, struct sk_buff *skb,
 	return;
 
 checksum_fail:
-	vsi->back->hw_csum_rx_error++;
+	ring->vsi->back->hw_csum_rx_error++;
 }
 
 /**
@@ -968,7 +969,7 @@ ice_process_skb_fields(struct ice_ring *rx_ring,
 	/* modifies the skb - consumes the enet header */
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
 
-	ice_rx_csum(rx_ring->vsi, skb, rx_desc, ptype);
+	ice_rx_csum(rx_ring, skb, rx_desc, ptype);
 }
 
 /**
@@ -1354,14 +1355,13 @@ static u32 ice_buildreg_itr(u16 itr_idx, u16 itr)
 
 /**
  * ice_update_ena_itr - Update ITR and re-enable MSIX interrupt
- * @vsi: the VSI associated with the q_vector
  * @q_vector: q_vector for which ITR is being updated and interrupt enabled
  */
-static void
-ice_update_ena_itr(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
+static void ice_update_ena_itr(struct ice_q_vector *q_vector)
 {
 	struct ice_ring_container *tx = &q_vector->tx;
 	struct ice_ring_container *rx = &q_vector->rx;
+	struct ice_vsi *vsi = q_vector->vsi;
 	u32 itr_val;
 
 	/* when exiting WB_ON_ITR lets set a low ITR value and trigger
@@ -1419,15 +1419,14 @@ ice_update_ena_itr(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
 			q_vector->itr_countdown--;
 	}
 
-	if (!test_bit(__ICE_DOWN, vsi->state))
-		wr32(&vsi->back->hw,
+	if (!test_bit(__ICE_DOWN, q_vector->vsi->state))
+		wr32(&q_vector->vsi->back->hw,
 		     GLINT_DYN_CTL(q_vector->reg_idx),
 		     itr_val);
 }
 
 /**
  * ice_set_wb_on_itr - set WB_ON_ITR for this q_vector
- * @vsi: pointer to the VSI structure
  * @q_vector: q_vector to set WB_ON_ITR on
  *
  * We need to tell hardware to write-back completed descriptors even when
@@ -1440,9 +1439,10 @@ ice_update_ena_itr(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
  * value that's not 0 due to ITR granularity. Also, set the INTENA_MSK bit to
  * make sure hardware knows we aren't meddling with the INTENA_M bit.
  */
-static void
-ice_set_wb_on_itr(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
+static void ice_set_wb_on_itr(struct ice_q_vector *q_vector)
 {
+	struct ice_vsi *vsi = q_vector->vsi;
+
 	/* already in WB_ON_ITR mode no need to change it */
 	if (q_vector->itr_countdown == ICE_IN_WB_ON_ITR_MODE)
 		return;
@@ -1473,7 +1473,6 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct ice_q_vector *q_vector =
 				container_of(napi, struct ice_q_vector, napi);
-	struct ice_vsi *vsi = q_vector->vsi;
 	bool clean_complete = true;
 	struct ice_ring *ring;
 	int budget_per_ring;
@@ -1483,7 +1482,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	 * budget and be more aggressive about cleaning up the Tx descriptors.
 	 */
 	ice_for_each_ring(ring, q_vector->tx)
-		if (!ice_clean_tx_irq(vsi, ring, budget))
+		if (!ice_clean_tx_irq(ring, budget))
 			clean_complete = false;
 
 	/* Handle case where we are called by netpoll with a budget of 0 */
@@ -1519,9 +1518,9 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	 * poll us due to busy-polling
 	 */
 	if (likely(napi_complete_done(napi, work_done)))
-		ice_update_ena_itr(vsi, q_vector);
+		ice_update_ena_itr(q_vector);
 	else
-		ice_set_wb_on_itr(vsi, q_vector);
+		ice_set_wb_on_itr(q_vector);
 
 	return min_t(int, work_done, budget - 1);
 }
-- 
2.21.0

