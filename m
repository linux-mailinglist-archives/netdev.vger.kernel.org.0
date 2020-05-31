Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA661E97A2
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgEaMgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:12466 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728111AbgEaMgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:25 -0400
IronPort-SDR: 8FONKlX/sV+bVcCm9eyfHz1m+846JwJZWBjbvCUxf7t+gtWss13uW+/2oyjEwWtJmYUJVxl0zt
 t9IMAU+8QGUQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:23 -0700
IronPort-SDR: em5oT8wws7oY8TKsB+kPoXvN5FPBDQHSZY8ULm4xNQtuV+V2fDfmEd31JDVX88OQexxRATK9Hb
 BPg1yVxDIzwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345436"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/14] ice: Always clear QRXFLXP_CNTXT before writing new value
Date:   Sun, 31 May 2020 05:36:12 -0700
Message-Id: <20200531123619.2887469-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Always clear the previous value in QRXFLXP_CNTXT before writing a new
value. This will make it so re-used queues will not accidentally take the
previously configured settings.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 33 ++++++++---------------
 drivers/net/ethernet/intel/ice/ice_lib.c  | 26 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h  |  3 +++
 3 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index a174911d8994..d620d26d42ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -3,6 +3,7 @@
 
 #include <net/xdp_sock_drv.h>
 #include "ice_base.h"
+#include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
 /**
@@ -288,7 +289,6 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	u32 rxdid = ICE_RXDID_FLEX_NIC;
 	struct ice_rlan_ctx rlan_ctx;
 	struct ice_hw *hw;
-	u32 regval;
 	u16 pf_q;
 	int err;
 
@@ -385,27 +385,16 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	/* Rx queue threshold in units of 64 */
 	rlan_ctx.lrxqthresh = 1;
 
-	 /* Enable Flexible Descriptors in the queue context which
-	  * allows this driver to select a specific receive descriptor format
-	  */
-	regval = rd32(hw, QRXFLXP_CNTXT(pf_q));
-	if (vsi->type != ICE_VSI_VF) {
-		regval |= (rxdid << QRXFLXP_CNTXT_RXDID_IDX_S) &
-			QRXFLXP_CNTXT_RXDID_IDX_M;
-
-		/* increasing context priority to pick up profile ID;
-		 * default is 0x01; setting to 0x03 to ensure profile
-		 * is programming if prev context is of same priority
-		 */
-		regval |= (0x03 << QRXFLXP_CNTXT_RXDID_PRIO_S) &
-			QRXFLXP_CNTXT_RXDID_PRIO_M;
-
-	} else {
-		regval &= ~(QRXFLXP_CNTXT_RXDID_IDX_M |
-			    QRXFLXP_CNTXT_RXDID_PRIO_M |
-			    QRXFLXP_CNTXT_TS_M);
-	}
-	wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
+	/* Enable Flexible Descriptors in the queue context which
+	 * allows this driver to select a specific receive descriptor format
+	 * increasing context priority to pick up profile ID; default is 0x01;
+	 * setting to 0x03 to ensure profile is programming if prev context is
+	 * of same priority
+	 */
+	if (vsi->type != ICE_VSI_VF)
+		ice_write_qrxflxp_cntxt(hw, pf_q, rxdid, 0x3);
+	else
+		ice_write_qrxflxp_cntxt(hw, pf_q, ICE_RXDID_LEGACY_1, 0x3);
 
 	/* Absolute queue number out of 2K needs to be passed */
 	err = ice_write_rxq_ctx(hw, &rlan_ctx, pf_q);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 89e8e4f7f56f..ecc04a696e50 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1595,6 +1595,32 @@ void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_write_qrxflxp_cntxt - write/configure QRXFLXP_CNTXT register
+ * @hw: HW pointer
+ * @pf_q: index of the Rx queue in the PF's queue space
+ * @rxdid: flexible descriptor RXDID
+ * @prio: priority for the RXDID for this queue
+ */
+void
+ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio)
+{
+	int regval = rd32(hw, QRXFLXP_CNTXT(pf_q));
+
+	/* clear any previous values */
+	regval &= ~(QRXFLXP_CNTXT_RXDID_IDX_M |
+		    QRXFLXP_CNTXT_RXDID_PRIO_M |
+		    QRXFLXP_CNTXT_TS_M);
+
+	regval |= (rxdid << QRXFLXP_CNTXT_RXDID_IDX_S) &
+		QRXFLXP_CNTXT_RXDID_IDX_M;
+
+	regval |= (prio << QRXFLXP_CNTXT_RXDID_PRIO_S) &
+		QRXFLXP_CNTXT_RXDID_PRIO_M;
+
+	wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
+}
+
 /**
  * ice_vsi_cfg_rxqs - Configure the VSI for Rx
  * @vsi: the VSI being configured
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 076e635e0c9f..d80e6afa4511 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -74,6 +74,9 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi);
 
 bool ice_is_reset_in_progress(unsigned long *state);
 
+void
+ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio);
+
 void ice_vsi_put_qs(struct ice_vsi *vsi);
 
 void ice_vsi_dis_irq(struct ice_vsi *vsi);
-- 
2.26.2

