Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B72E314582
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhBIBS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:18:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:36361 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229879AbhBIBRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:17:42 -0500
IronPort-SDR: j6y5a6Pl9fGNH9OM1mYXXvuZfQy2EuQ28xNR3387g73ngsveKeLEbK8O60tVlQxxdn9t15w+hN
 +q71e7zY5k4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245879735"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="245879735"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 17:15:48 -0800
IronPort-SDR: JfXLjy6ucYzbisSBk/ghXW6TWJA5t1bWsLhdhugF6AQgLigZVZQffS/gTJGi6fJs35O++KjpZu
 tbCRBvrOrAfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="487669614"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2021 17:15:47 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Brett Creeley <brett.creeley@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 07/12] ice: fix writeback enable logic
Date:   Mon,  8 Feb 2021 17:16:31 -0800
Message-Id: <20210209011636.1989093-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
References: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The writeback enable logic was incorrectly implemented (due to
misunderstanding what the side effects of the implementation would be
during polling).

Fix this logic issue, while implementing a new feature allowing the user
to control the writeback frequency using the knobs for controlling
interrupt throttling that we already have.  Basically if you leave
adaptive interrupts enabled, the writeback frequency will be varied even
if busy_polling or if napi-poll is in use.  If the interrupt rates are
set to a fixed value by ethtool -C and adaptive is off, the driver will
allow the user-set interrupt rate to guide how frequently the hardware
will complete descriptors to the driver.

Effectively the user will get a control over the hardware efficiency,
allowing the choice between immediate interrupts or delayed up to a
maximum of the interrupt rate, even when interrupts are disabled
during polling.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Co-developed-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 59 ++++++++++-------------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  1 -
 2 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 8ca63c6a6ba4..c7c9901f1bf7 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1497,22 +1497,11 @@ static void ice_update_ena_itr(struct ice_q_vector *q_vector)
 	struct ice_vsi *vsi = q_vector->vsi;
 	u32 itr_val;
 
-	/* when exiting WB_ON_ITR lets set a low ITR value and trigger
-	 * interrupts to expire right away in case we have more work ready to go
-	 * already
+	/* when exiting WB_ON_ITR just reset the countdown and let ITR
+	 * resume it's normal "interrupts-enabled" path
 	 */
-	if (q_vector->itr_countdown == ICE_IN_WB_ON_ITR_MODE) {
-		itr_val = ice_buildreg_itr(rx->itr_idx, ICE_WB_ON_ITR_USECS);
-		wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx), itr_val);
-		/* set target back to last user set value */
-		rx->target_itr = rx->itr_setting;
-		/* set current to what we just wrote and dynamic if needed */
-		rx->current_itr = ICE_WB_ON_ITR_USECS |
-			(rx->itr_setting & ICE_ITR_DYNAMIC);
-		/* allow normal interrupt flow to start */
+	if (q_vector->itr_countdown == ICE_IN_WB_ON_ITR_MODE)
 		q_vector->itr_countdown = 0;
-		return;
-	}
 
 	/* This will do nothing if dynamic updates are not enabled */
 	ice_update_itr(q_vector, tx);
@@ -1552,10 +1541,8 @@ static void ice_update_ena_itr(struct ice_q_vector *q_vector)
 			q_vector->itr_countdown--;
 	}
 
-	if (!test_bit(__ICE_DOWN, q_vector->vsi->state))
-		wr32(&q_vector->vsi->back->hw,
-		     GLINT_DYN_CTL(q_vector->reg_idx),
-		     itr_val);
+	if (!test_bit(__ICE_DOWN, vsi->state))
+		wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx), itr_val);
 }
 
 /**
@@ -1565,30 +1552,29 @@ static void ice_update_ena_itr(struct ice_q_vector *q_vector)
  * We need to tell hardware to write-back completed descriptors even when
  * interrupts are disabled. Descriptors will be written back on cache line
  * boundaries without WB_ON_ITR enabled, but if we don't enable WB_ON_ITR
- * descriptors may not be written back if they don't fill a cache line until the
- * next interrupt.
+ * descriptors may not be written back if they don't fill a cache line until
+ * the next interrupt.
  *
- * This sets the write-back frequency to 2 microseconds as that is the minimum
- * value that's not 0 due to ITR granularity. Also, set the INTENA_MSK bit to
- * make sure hardware knows we aren't meddling with the INTENA_M bit.
+ * This sets the write-back frequency to whatever was set previously for the
+ * ITR indices. Also, set the INTENA_MSK bit to make sure hardware knows we
+ * aren't meddling with the INTENA_M bit.
  */
 static void ice_set_wb_on_itr(struct ice_q_vector *q_vector)
 {
 	struct ice_vsi *vsi = q_vector->vsi;
 
-	/* already in WB_ON_ITR mode no need to change it */
+	/* already in wb_on_itr mode no need to change it */
 	if (q_vector->itr_countdown == ICE_IN_WB_ON_ITR_MODE)
 		return;
 
-	if (q_vector->num_ring_rx)
-		wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx),
-		     ICE_GLINT_DYN_CTL_WB_ON_ITR(ICE_WB_ON_ITR_USECS,
-						 ICE_RX_ITR));
-
-	if (q_vector->num_ring_tx)
-		wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx),
-		     ICE_GLINT_DYN_CTL_WB_ON_ITR(ICE_WB_ON_ITR_USECS,
-						 ICE_TX_ITR));
+	/* use previously set ITR values for all of the ITR indices by
+	 * specifying ICE_ITR_NONE, which will vary in adaptive (AIM) mode and
+	 * be static in non-adaptive mode (user configured)
+	 */
+	wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx),
+	     ((ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S) &
+	      GLINT_DYN_CTL_ITR_INDX_M) | GLINT_DYN_CTL_INTENA_MSK_M |
+	     GLINT_DYN_CTL_WB_ON_ITR_M);
 
 	q_vector->itr_countdown = ICE_IN_WB_ON_ITR_MODE;
 }
@@ -1655,8 +1641,13 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	}
 
 	/* If work not completed, return budget and polling will return */
-	if (!clean_complete)
+	if (!clean_complete) {
+		/* Set the writeback on ITR so partial completions of
+		 * cache-lines will still continue even if we're polling.
+		 */
+		ice_set_wb_on_itr(q_vector);
 		return budget;
+	}
 
 	/* Exit the polling mode, but don't re-enable interrupts if stack might
 	 * poll us due to busy-polling
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ff1a1cbd078e..db56a0c8bfe1 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -240,7 +240,6 @@ enum ice_rx_dtype {
 #define ICE_DFLT_INTRL	0
 #define ICE_MAX_INTRL	236
 
-#define ICE_WB_ON_ITR_USECS	2
 #define ICE_IN_WB_ON_ITR_MODE	255
 /* Sets WB_ON_ITR and assumes INTENA bit is already cleared, which allows
  * setting the MSK_M bit to tell hardware to ignore the INTENA_M bit. Also,
-- 
2.26.2

