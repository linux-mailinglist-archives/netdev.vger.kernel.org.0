Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BE813C4E
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfEDXyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:54:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:32555 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfEDXya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 19:54:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 16:49:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="139994644"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2019 16:49:29 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] ice: Fix for allowing too many MDD events on VF
Date:   Sat,  4 May 2019 16:49:16 -0700
Message-Id: <20190504234929.3005-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
References: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Disable VF if any malicious device driver (MDD) event is detected by
hardware. Track vf->num_mdd_events for information about VF MDD events.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6b27be93bdf5..2352b4129a62 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1185,10 +1185,12 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 	for (i = 0; i < pf->num_alloc_vfs && mdd_detected; i++) {
 		struct ice_vf *vf = &pf->vf[i];
 
+		mdd_detected = false;
+
 		reg = rd32(hw, VP_MDET_TX_PQM(i));
 		if (reg & VP_MDET_TX_PQM_VALID_M) {
 			wr32(hw, VP_MDET_TX_PQM(i), 0xFFFF);
-			vf->num_mdd_events++;
+			mdd_detected = true;
 			dev_info(&pf->pdev->dev, "TX driver issue detected on VF %d\n",
 				 i);
 		}
@@ -1196,7 +1198,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		reg = rd32(hw, VP_MDET_TX_TCLAN(i));
 		if (reg & VP_MDET_TX_TCLAN_VALID_M) {
 			wr32(hw, VP_MDET_TX_TCLAN(i), 0xFFFF);
-			vf->num_mdd_events++;
+			mdd_detected = true;
 			dev_info(&pf->pdev->dev, "TX driver issue detected on VF %d\n",
 				 i);
 		}
@@ -1204,7 +1206,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		reg = rd32(hw, VP_MDET_TX_TDPU(i));
 		if (reg & VP_MDET_TX_TDPU_VALID_M) {
 			wr32(hw, VP_MDET_TX_TDPU(i), 0xFFFF);
-			vf->num_mdd_events++;
+			mdd_detected = true;
 			dev_info(&pf->pdev->dev, "TX driver issue detected on VF %d\n",
 				 i);
 		}
@@ -1212,14 +1214,13 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		reg = rd32(hw, VP_MDET_RX(i));
 		if (reg & VP_MDET_RX_VALID_M) {
 			wr32(hw, VP_MDET_RX(i), 0xFFFF);
-			vf->num_mdd_events++;
+			mdd_detected = true;
 			dev_info(&pf->pdev->dev, "RX driver issue detected on VF %d\n",
 				 i);
 		}
 
-		if (vf->num_mdd_events > ICE_DFLT_NUM_MDD_EVENTS_ALLOWED) {
-			dev_info(&pf->pdev->dev,
-				 "Too many MDD events on VF %d, disabled\n", i);
+		if (mdd_detected) {
+			vf->num_mdd_events++;
 			dev_info(&pf->pdev->dev,
 				 "Use PF Control I/F to re-enable the VF\n");
 			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
-- 
2.20.1

