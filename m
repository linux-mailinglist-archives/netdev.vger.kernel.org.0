Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C112E4BF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfE2SsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:48:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:40834 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbfE2Srq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:45 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/15] ice: Check all VFs for MDD activity, don't disable
Date:   Wed, 29 May 2019 11:47:48 -0700
Message-Id: <20190529184754.12693-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
References: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

Don't use the mdd_detected variable as an exit condition for this loop;
the first VF to NOT have an MDD event will cause the loop to terminate.

Instead just look at all of the VFs, but don't disable them. This
prevents proper release of resources if the VFs are rebooted or the VF
driver reloaded. Instead, just log a message and call out repeat
offenders.

To make it clear what we are doing, use a differently-named variable in
the loop.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6fc4d8176d14..59971f6224f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1161,16 +1161,16 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		}
 	}
 
-	/* see if one of the VFs needs to be reset */
-	for (i = 0; i < pf->num_alloc_vfs && mdd_detected; i++) {
+	/* check to see if one of the VFs caused the MDD */
+	for (i = 0; i < pf->num_alloc_vfs; i++) {
 		struct ice_vf *vf = &pf->vf[i];
 
-		mdd_detected = false;
+		bool vf_mdd_detected = false;
 
 		reg = rd32(hw, VP_MDET_TX_PQM(i));
 		if (reg & VP_MDET_TX_PQM_VALID_M) {
 			wr32(hw, VP_MDET_TX_PQM(i), 0xFFFF);
-			mdd_detected = true;
+			vf_mdd_detected = true;
 			dev_info(&pf->pdev->dev, "TX driver issue detected on VF %d\n",
 				 i);
 		}
@@ -1178,7 +1178,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		reg = rd32(hw, VP_MDET_TX_TCLAN(i));
 		if (reg & VP_MDET_TX_TCLAN_VALID_M) {
 			wr32(hw, VP_MDET_TX_TCLAN(i), 0xFFFF);
-			mdd_detected = true;
+			vf_mdd_detected = true;
 			dev_info(&pf->pdev->dev, "TX driver issue detected on VF %d\n",
 				 i);
 		}
@@ -1186,7 +1186,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		reg = rd32(hw, VP_MDET_TX_TDPU(i));
 		if (reg & VP_MDET_TX_TDPU_VALID_M) {
 			wr32(hw, VP_MDET_TX_TDPU(i), 0xFFFF);
-			mdd_detected = true;
+			vf_mdd_detected = true;
 			dev_info(&pf->pdev->dev, "TX driver issue detected on VF %d\n",
 				 i);
 		}
@@ -1194,19 +1194,18 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		reg = rd32(hw, VP_MDET_RX(i));
 		if (reg & VP_MDET_RX_VALID_M) {
 			wr32(hw, VP_MDET_RX(i), 0xFFFF);
-			mdd_detected = true;
+			vf_mdd_detected = true;
 			dev_info(&pf->pdev->dev, "RX driver issue detected on VF %d\n",
 				 i);
 		}
 
-		if (mdd_detected) {
+		if (vf_mdd_detected) {
 			vf->num_mdd_events++;
-			dev_info(&pf->pdev->dev,
-				 "Use PF Control I/F to re-enable the VF\n");
-			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
+			if (vf->num_mdd_events > 1)
+				dev_info(&pf->pdev->dev, "VF %d has had %llu MDD events since last boot\n",
+					 i, vf->num_mdd_events);
 		}
 	}
-
 }
 
 /**
-- 
2.21.0

