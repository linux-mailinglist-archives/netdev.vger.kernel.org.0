Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF57E1160B
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfEBJGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:47592 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfEBJG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615364"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/15] ice: Remove runtime change of PFINT_OICR_ENA register
Date:   Thu,  2 May 2019 02:06:16 -0700
Message-Id: <20190502090620.21281-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>

Runtime change of PFINT_OICR_ENA register is unnecessary.
The handlers should always clear the atomic bit for each
task as they start, because it will make sure that any late
interrupt will either 1) re-set the bit, or 2) be handled
directly in the "already running" task handler.

Signed-off-by: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c        | 13 ++-----------
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 13 +------------
 2 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a32782be7f88..8f6f2a1e67ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1096,7 +1096,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 	u32 reg;
 	int i;
 
-	if (!test_bit(__ICE_MDD_EVENT_PENDING, pf->state))
+	if (!test_and_clear_bit(__ICE_MDD_EVENT_PENDING, pf->state))
 		return;
 
 	/* find what triggered the MDD event */
@@ -1229,12 +1229,6 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		}
 	}
 
-	/* re-enable MDD interrupt cause */
-	clear_bit(__ICE_MDD_EVENT_PENDING, pf->state);
-	reg = rd32(hw, PFINT_OICR_ENA);
-	reg |= PFINT_OICR_MAL_DETECT_M;
-	wr32(hw, PFINT_OICR_ENA, reg);
-	ice_flush(hw);
 }
 
 /**
@@ -1523,7 +1517,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 			rd32(hw, PFHMC_ERRORDATA));
 	}
 
-	/* Report and mask off any remaining unexpected interrupts */
+	/* Report any remaining unexpected interrupts */
 	oicr &= ena_mask;
 	if (oicr) {
 		dev_dbg(&pf->pdev->dev, "unhandled interrupt oicr=0x%08x\n",
@@ -1537,12 +1531,9 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 			set_bit(__ICE_PFR_REQ, pf->state);
 			ice_service_task_schedule(pf);
 		}
-		ena_mask &= ~oicr;
 	}
 	ret = IRQ_HANDLED;
 
-	/* re-enable interrupt causes that are not handled during this pass */
-	wr32(hw, PFINT_OICR_ENA, ena_mask);
 	if (!test_bit(__ICE_DOWN, pf->state)) {
 		ice_service_task_schedule(pf);
 		ice_irq_dynamic_ena(hw, NULL, NULL);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index f52f0fc52f46..abc958788267 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1273,21 +1273,10 @@ void ice_process_vflr_event(struct ice_pf *pf)
 	int vf_id;
 	u32 reg;
 
-	if (!test_bit(__ICE_VFLR_EVENT_PENDING, pf->state) ||
+	if (!test_and_clear_bit(__ICE_VFLR_EVENT_PENDING, pf->state) ||
 	    !pf->num_alloc_vfs)
 		return;
 
-	/* Re-enable the VFLR interrupt cause here, before looking for which
-	 * VF got reset. Otherwise, if another VF gets a reset while the
-	 * first one is being processed, that interrupt will be lost, and
-	 * that VF will be stuck in reset forever.
-	 */
-	reg = rd32(hw, PFINT_OICR_ENA);
-	reg |= PFINT_OICR_VFLR_M;
-	wr32(hw, PFINT_OICR_ENA, reg);
-	ice_flush(hw);
-
-	clear_bit(__ICE_VFLR_EVENT_PENDING, pf->state);
 	for (vf_id = 0; vf_id < pf->num_alloc_vfs; vf_id++) {
 		struct ice_vf *vf = &pf->vf[vf_id];
 		u32 reg_idx, bit_idx;
-- 
2.20.1

