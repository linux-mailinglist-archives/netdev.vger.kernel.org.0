Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A112697D9
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbfGONth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731746AbfGONtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:49:36 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C64122081C;
        Mon, 15 Jul 2019 13:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198575;
        bh=QdGPfrNeNbkaP1KQzi0uqJbMx7P9OghW+bjOn6JK0rI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOO/BiIAZuauiXtoD+eE+Q3SQOybSD3TQt3R9uHjmkfBBHmQKldShFX9JHR0QhMro
         u9LlICizCUNK0/KGDWs4zgxtnLBl/ymf3KZxkf+wQYtajqoRPRLbdU4AkKyotKaCTE
         I8OlSxCgb9uCFrIExq46wVeKP8KvLpEWp2B2KIEU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 049/249] ice: Check all VFs for MDD activity, don't disable
Date:   Mon, 15 Jul 2019 09:43:34 -0400
Message-Id: <20190715134655.4076-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

[ Upstream commit 23c0112246b454e408fb0579b3f9089353d4d327 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index dbf3d39ad8b1..1c803106e301 100644
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
2.20.1

