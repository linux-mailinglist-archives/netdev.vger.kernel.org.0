Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D160EAB2
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbfD2TOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:14:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:61541 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729196AbfD2TOI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:14:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 12:14:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="341867029"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2019 12:14:07 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Carolyn Wyborny <carolyn.wyborny@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/12] i40e: change behavior on PF in response to MDD event
Date:   Mon, 29 Apr 2019 12:16:19 -0700
Message-Id: <20190429191628.31212-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carolyn Wyborny <carolyn.wyborny@intel.com>

TX MDD events reported on the PF are the result of the
PF misconfiguring a descriptor and not because of "bad actions"
by anything else.  No need to reset now because if it
results in a Tx hang, the Tx hang check will take care of it.

Signed-off-by: Carolyn Wyborny <carolyn.wyborny@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b52a9d5644b8..3e15df1d5f52 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -9696,7 +9696,6 @@ static void i40e_handle_mdd_event(struct i40e_pf *pf)
 {
 	struct i40e_hw *hw = &pf->hw;
 	bool mdd_detected = false;
-	bool pf_mdd_detected = false;
 	struct i40e_vf *vf;
 	u32 reg;
 	int i;
@@ -9742,19 +9741,12 @@ static void i40e_handle_mdd_event(struct i40e_pf *pf)
 		reg = rd32(hw, I40E_PF_MDET_TX);
 		if (reg & I40E_PF_MDET_TX_VALID_MASK) {
 			wr32(hw, I40E_PF_MDET_TX, 0xFFFF);
-			dev_info(&pf->pdev->dev, "TX driver issue detected, PF reset issued\n");
-			pf_mdd_detected = true;
+			dev_dbg(&pf->pdev->dev, "TX driver issue detected on PF\n");
 		}
 		reg = rd32(hw, I40E_PF_MDET_RX);
 		if (reg & I40E_PF_MDET_RX_VALID_MASK) {
 			wr32(hw, I40E_PF_MDET_RX, 0xFFFF);
-			dev_info(&pf->pdev->dev, "RX driver issue detected, PF reset issued\n");
-			pf_mdd_detected = true;
-		}
-		/* Queue belongs to the PF, initiate a reset */
-		if (pf_mdd_detected) {
-			set_bit(__I40E_PF_RESET_REQUESTED, pf->state);
-			i40e_service_event_schedule(pf);
+			dev_dbg(&pf->pdev->dev, "RX driver issue detected on PF\n");
 		}
 	}
 
-- 
2.20.1

