Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E683135F5
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 01:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfECXJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 19:09:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:40730 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfECXJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 19:09:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 16:09:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,427,1549958400"; 
   d="scan'208";a="136660073"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 03 May 2019 16:09:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Carolyn Wyborny <carolyn.wyborny@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 01/11] i40e: Fix for allowing too many MDD events on VF
Date:   Fri,  3 May 2019 16:09:29 -0700
Message-Id: <20190503230939.6739-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
References: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carolyn Wyborny <carolyn.wyborny@intel.com>

This patch changes the driver behavior when detecting a VF MDD event.
It now disables the VF after one event, which indicates a hw detected
problem in the VF.  Before this change, the PF would allow a couple of
events before doing the reset.

Signed-off-by: Carolyn Wyborny <carolyn.wyborny@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 65c2b9d2652b..b52a9d5644b8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -9767,6 +9767,9 @@ static void i40e_handle_mdd_event(struct i40e_pf *pf)
 			vf->num_mdd_events++;
 			dev_info(&pf->pdev->dev, "TX driver issue detected on VF %d\n",
 				 i);
+			dev_info(&pf->pdev->dev,
+				 "Use PF Control I/F to re-enable the VF\n");
+			set_bit(I40E_VF_STATE_DISABLED, &vf->vf_states);
 		}
 
 		reg = rd32(hw, I40E_VP_MDET_RX(i));
@@ -9775,11 +9778,6 @@ static void i40e_handle_mdd_event(struct i40e_pf *pf)
 			vf->num_mdd_events++;
 			dev_info(&pf->pdev->dev, "RX driver issue detected on VF %d\n",
 				 i);
-		}
-
-		if (vf->num_mdd_events > I40E_DEFAULT_NUM_MDD_EVENTS_ALLOWED) {
-			dev_info(&pf->pdev->dev,
-				 "Too many MDD events on VF %d, disabled\n", i);
 			dev_info(&pf->pdev->dev,
 				 "Use PF Control I/F to re-enable the VF\n");
 			set_bit(I40E_VF_STATE_DISABLED, &vf->vf_states);
-- 
2.20.1

