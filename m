Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A6E96BC1
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbfHTVux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:50:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:28768 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730949AbfHTVuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 17:50:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 14:50:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="scan'208";a="183330513"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 20 Aug 2019 14:50:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 05/14] ice: Set WB_ON_ITR when we don't re-enable interrupts
Date:   Tue, 20 Aug 2019 14:50:39 -0700
Message-Id: <20190820215048.14377-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
References: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when busy polling is enabled we aren't setting/enabling
WB_ON_ITR in the driver. This doesn't break the driver, but it does
cause issues. If we don't enable WB_ON_ITR mode we will still get
write-backs from hardware during polling when a cache line has been
filled, but if a cache line is not filled we will not get the
write-back because WB_ON_ITR is not set. Fix this by enabling
WB_ON_ITR in the driver when interrupts are disabled.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  3 ++
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 54 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 13 +++++
 3 files changed, 70 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 87652d722a30..6f78ff5534af 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -127,8 +127,11 @@
 #define GLINT_DYN_CTL_CLEARPBA_M		BIT(1)
 #define GLINT_DYN_CTL_SWINT_TRIG_M		BIT(2)
 #define GLINT_DYN_CTL_ITR_INDX_S		3
+#define GLINT_DYN_CTL_ITR_INDX_M		ICE_M(0x3, 3)
 #define GLINT_DYN_CTL_INTERVAL_S		5
+#define GLINT_DYN_CTL_INTERVAL_M		ICE_M(0xFFF, 5)
 #define GLINT_DYN_CTL_SW_ITR_INDX_M		ICE_M(0x3, 25)
+#define GLINT_DYN_CTL_WB_ON_ITR_M		BIT(30)
 #define GLINT_DYN_CTL_INTENA_MSK_M		BIT(31)
 #define GLINT_ITR(_i, _INT)			(0x00154000 + ((_i) * 8192 + (_INT) * 4))
 #define GLINT_RATE(_INT)			(0x0015A000 + ((_INT) * 4))
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 837d6ae2f33b..c88e0701e1d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1355,6 +1355,23 @@ ice_update_ena_itr(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
 	struct ice_ring_container *rx = &q_vector->rx;
 	u32 itr_val;
 
+	/* when exiting WB_ON_ITR lets set a low ITR value and trigger
+	 * interrupts to expire right away in case we have more work ready to go
+	 * already
+	 */
+	if (q_vector->itr_countdown == ICE_IN_WB_ON_ITR_MODE) {
+		itr_val = ice_buildreg_itr(rx->itr_idx, ICE_WB_ON_ITR_USECS);
+		wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx), itr_val);
+		/* set target back to last user set value */
+		rx->target_itr = rx->itr_setting;
+		/* set current to what we just wrote and dynamic if needed */
+		rx->current_itr = ICE_WB_ON_ITR_USECS |
+			(rx->itr_setting & ICE_ITR_DYNAMIC);
+		/* allow normal interrupt flow to start */
+		q_vector->itr_countdown = 0;
+		return;
+	}
+
 	/* This will do nothing if dynamic updates are not enabled */
 	ice_update_itr(q_vector, tx);
 	ice_update_itr(q_vector, rx);
@@ -1399,6 +1416,41 @@ ice_update_ena_itr(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
 		     itr_val);
 }
 
+/**
+ * ice_set_wb_on_itr - set WB_ON_ITR for this q_vector
+ * @vsi: pointer to the VSI structure
+ * @q_vector: q_vector to set WB_ON_ITR on
+ *
+ * We need to tell hardware to write-back completed descriptors even when
+ * interrupts are disabled. Descriptors will be written back on cache line
+ * boundaries without WB_ON_ITR enabled, but if we don't enable WB_ON_ITR
+ * descriptors may not be written back if they don't fill a cache line until the
+ * next interrupt.
+ *
+ * This sets the write-back frequency to 2 microseconds as that is the minimum
+ * value that's not 0 due to ITR granularity. Also, set the INTENA_MSK bit to
+ * make sure hardware knows we aren't meddling with the INTENA_M bit.
+ */
+static void
+ice_set_wb_on_itr(struct ice_vsi *vsi, struct ice_q_vector *q_vector)
+{
+	/* already in WB_ON_ITR mode no need to change it */
+	if (q_vector->itr_countdown == ICE_IN_WB_ON_ITR_MODE)
+		return;
+
+	if (q_vector->num_ring_rx)
+		wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx),
+		     ICE_GLINT_DYN_CTL_WB_ON_ITR(ICE_WB_ON_ITR_USECS,
+						 ICE_RX_ITR));
+
+	if (q_vector->num_ring_tx)
+		wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx),
+		     ICE_GLINT_DYN_CTL_WB_ON_ITR(ICE_WB_ON_ITR_USECS,
+						 ICE_TX_ITR));
+
+	q_vector->itr_countdown = ICE_IN_WB_ON_ITR_MODE;
+}
+
 /**
  * ice_napi_poll - NAPI polling Rx/Tx cleanup routine
  * @napi: napi struct with our devices info in it
@@ -1459,6 +1511,8 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	 */
 	if (likely(napi_complete_done(napi, work_done)))
 		ice_update_ena_itr(vsi, q_vector);
+	else
+		ice_set_wb_on_itr(vsi, q_vector);
 
 	return min_t(int, work_done, budget - 1);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ec76aba347b9..94a9280193e2 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -144,6 +144,19 @@ enum ice_rx_dtype {
 #define ICE_DFLT_INTRL	0
 #define ICE_MAX_INTRL	236
 
+#define ICE_WB_ON_ITR_USECS	2
+#define ICE_IN_WB_ON_ITR_MODE	255
+/* Sets WB_ON_ITR and assumes INTENA bit is already cleared, which allows
+ * setting the MSK_M bit to tell hardware to ignore the INTENA_M bit. Also,
+ * set the write-back latency to the usecs passed in.
+ */
+#define ICE_GLINT_DYN_CTL_WB_ON_ITR(usecs, itr_idx)	\
+	((((usecs) << (GLINT_DYN_CTL_INTERVAL_S - ICE_ITR_GRAN_S)) & \
+	  GLINT_DYN_CTL_INTERVAL_M) | \
+	 (((itr_idx) << GLINT_DYN_CTL_ITR_INDX_S) & \
+	  GLINT_DYN_CTL_ITR_INDX_M) | GLINT_DYN_CTL_INTENA_MSK_M | \
+	 GLINT_DYN_CTL_WB_ON_ITR_M)
+
 /* Legacy or Advanced Mode Queue */
 #define ICE_TX_ADVANCED	0
 #define ICE_TX_LEGACY	1
-- 
2.21.0

