Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67EDF7E485
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388965AbfHAUv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:51:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:8390 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbfHAUvy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 16:51:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 13:51:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="163734565"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2019 13:51:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Czeslaw Zagorski <czeslawx.zagorski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 9/9] i40e: Remove unicast log when VF is leaving multicast mode.
Date:   Thu,  1 Aug 2019 13:51:49 -0700
Message-Id: <20190801205149.4114-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
References: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
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
index 618781b3b7ac..7bc4e397d56d 100644
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

