Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5833282519
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfHESzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:55:06 -0400
Received: from mga06.intel.com ([134.134.136.31]:43665 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbfHESzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 14:55:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 11:55:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="373801253"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 05 Aug 2019 11:55:02 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Czeslaw Zagorski <czeslawx.zagorski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 8/8] i40e: Remove unicast log when VF is leaving multicast mode.
Date:   Mon,  5 Aug 2019 11:54:59 -0700
Message-Id: <20190805185459.12846-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
References: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Czeslaw Zagorski <czeslawx.zagorski@intel.com>

This patch removes unicast log when VF is leaving multicast mode.
Added check of vf->vf_states &
I40E_VF_STATE_MC_PROMISC/I40E_VF_STATE_UC_PROMISC.
Without this commit, leaving multicast mode logs "unset unicast"
in dmsg.

Signed-off-by: Czeslaw Zagorski <czeslawx.zagorski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 39 ++++++++++---------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 6d0289e60e01..4601f9e4e998 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2043,30 +2043,33 @@ static int i40e_vc_config_promiscuous_mode_msg(struct i40e_vf *vf, u8 *msg)
 		alluni = true;
 	aq_ret = i40e_config_vf_promiscuous_mode(vf, info->vsi_id, allmulti,
 						 alluni);
-	if (!aq_ret) {
-		if (allmulti) {
+	if (aq_ret)
+		goto err_out;
+
+	if (allmulti) {
+		if (!test_and_set_bit(I40E_VF_STATE_MC_PROMISC,
+				      &vf->vf_states))
 			dev_info(&pf->pdev->dev,
 				 "VF %d successfully set multicast promiscuous mode\n",
 				 vf->vf_id);
-			set_bit(I40E_VF_STATE_MC_PROMISC, &vf->vf_states);
-		} else {
-			dev_info(&pf->pdev->dev,
-				 "VF %d successfully unset multicast promiscuous mode\n",
-				 vf->vf_id);
-			clear_bit(I40E_VF_STATE_MC_PROMISC, &vf->vf_states);
-		}
-		if (alluni) {
+	} else if (test_and_clear_bit(I40E_VF_STATE_MC_PROMISC,
+				      &vf->vf_states))
+		dev_info(&pf->pdev->dev,
+			 "VF %d successfully unset multicast promiscuous mode\n",
+			 vf->vf_id);
+
+	if (alluni) {
+		if (!test_and_set_bit(I40E_VF_STATE_UC_PROMISC,
+				      &vf->vf_states))
 			dev_info(&pf->pdev->dev,
 				 "VF %d successfully set unicast promiscuous mode\n",
 				 vf->vf_id);
-			set_bit(I40E_VF_STATE_UC_PROMISC, &vf->vf_states);
-		} else {
-			dev_info(&pf->pdev->dev,
-				 "VF %d successfully unset unicast promiscuous mode\n",
-				 vf->vf_id);
-			clear_bit(I40E_VF_STATE_UC_PROMISC, &vf->vf_states);
-		}
-	}
+	} else if (test_and_clear_bit(I40E_VF_STATE_UC_PROMISC,
+				      &vf->vf_states))
+		dev_info(&pf->pdev->dev,
+			 "VF %d successfully unset unicast promiscuous mode\n",
+			 vf->vf_id);
+
 err_out:
 	/* send the response to the VF */
 	return i40e_vc_send_resp_to_vf(vf,
-- 
2.21.0

