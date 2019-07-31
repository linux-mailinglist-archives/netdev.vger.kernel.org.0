Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A407CEED
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbfGaUmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:42:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:2714 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729606AbfGaUlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901027"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/16] ice: Only bump Rx tail and release buffers once per napi_poll
Date:   Wed, 31 Jul 2019 13:41:39 -0700
Message-Id: <20190731204147.8582-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we bump the Rx tail and release/give buffers to hardware every
16 descriptors. This causes us to bump Rx tail up to 4 times per
napi_poll call. Also we are always bumping tail on an odd index and this
is a problem because hardware ignores the lower 3 bits in the QRX_TAIL
register. This is making it so hardware sees tail bumps only every 8
descriptors. Instead lets only bump Rx tail once per napi_poll if
the value aligns with hardware's expectations of the lower 3 bits being
cleared. Also only release/give Rx buffers once per napi_poll call.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 42 +++++++++++++++--------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index dd7392f293bf..0c459305c12f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -377,18 +377,28 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring)
  */
 static void ice_release_rx_desc(struct ice_ring *rx_ring, u32 val)
 {
+	u16 prev_ntu = rx_ring->next_to_use;
+
 	rx_ring->next_to_use = val;
 
 	/* update next to alloc since we have filled the ring */
 	rx_ring->next_to_alloc = val;
 
-	/* Force memory writes to complete before letting h/w
-	 * know there are new descriptors to fetch. (Only
-	 * applicable for weak-ordered memory model archs,
-	 * such as IA-64).
+	/* QRX_TAIL will be updated with any tail value, but hardware ignores
+	 * the lower 3 bits. This makes it so we only bump tail on meaningful
+	 * boundaries. Also, this allows us to bump tail on intervals of 8 up to
+	 * the budget depending on the current traffic load.
 	 */
-	wmb();
-	writel(val, rx_ring->tail);
+	val &= ~0x7;
+	if (prev_ntu != val) {
+		/* Force memory writes to complete before letting h/w
+		 * know there are new descriptors to fetch. (Only
+		 * applicable for weak-ordered memory model archs,
+		 * such as IA-64).
+		 */
+		wmb();
+		writel(val, rx_ring->tail);
+	}
 }
 
 /**
@@ -445,7 +455,13 @@ ice_alloc_mapped_page(struct ice_ring *rx_ring, struct ice_rx_buf *bi)
  * @rx_ring: ring to place buffers on
  * @cleaned_count: number of buffers to replace
  *
- * Returns false if all allocations were successful, true if any fail
+ * Returns false if all allocations were successful, true if any fail. Returning
+ * true signals to the caller that we didn't replace cleaned_count buffers and
+ * there is more work to do.
+ *
+ * First, try to clean "cleaned_count" Rx buffers. Then refill the cleaned Rx
+ * buffers. Then bump tail at most one time. Grouping like this lets us avoid
+ * multiple tail writes per call.
  */
 bool ice_alloc_rx_bufs(struct ice_ring *rx_ring, u16 cleaned_count)
 {
@@ -990,7 +1006,7 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
-	bool failure = false;
+	bool failure;
 
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
@@ -1002,13 +1018,6 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		u16 vlan_tag = 0;
 		u8 rx_ptype;
 
-		/* return some buffers to hardware, one at a time is too slow */
-		if (cleaned_count >= ICE_RX_BUF_WRITE) {
-			failure = failure ||
-				  ice_alloc_rx_bufs(rx_ring, cleaned_count);
-			cleaned_count = 0;
-		}
-
 		/* get the Rx desc from Rx ring based on 'next_to_clean' */
 		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
 
@@ -1085,6 +1094,9 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		total_rx_pkts++;
 	}
 
+	/* return up to cleaned_count buffers to hardware */
+	failure = ice_alloc_rx_bufs(rx_ring, cleaned_count);
+
 	/* update queue and vector specific stats */
 	u64_stats_update_begin(&rx_ring->syncp);
 	rx_ring->stats.pkts += total_rx_pkts;
-- 
2.21.0

