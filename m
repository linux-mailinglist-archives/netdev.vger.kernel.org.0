Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373864CC7B7
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 22:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbiCCVPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiCCVP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:15:27 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D430C4ECF4
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 13:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646342081; x=1677878081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IA2NQeg0Tp+Evn2NQdoR2buUg5E+446ee4aTfHYp4Q0=;
  b=ThxzcOmT2hGrPwf2oEf/Hrs2qtMJ61CAgiUcDuFoVa6Xp60omOhdA4xj
   Qgta5hsD/kHB6NC4YbWm0m7r7rZQ1VaUZX+p78xuo7eEo1dNOtbdecwEZ
   LGRB1F78DXFib0LVSepHfyXZs56pDbXxMWxWAp/4+6hGhxFLlQQcv9kTs
   L7Vdom0kHI89Vzf6LW184pjjzIWfEiuXwJhSZr6vSCxjRinhS5x05K9iG
   Ub8oRsVZegRBguuN81sZcifYrTErroFQU3J+WsehgVhrW8GyQJRlcsgW9
   MiD/kAJ4KDfzSiZyUX9eiX83lMJJYeb1DoETb3nadr7HFaTjcyFxbXwZ6
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="340245711"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="340245711"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 13:14:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="640347698"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 13:14:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 04/11] ice: move clear_malvf call in ice_free_vfs
Date:   Thu,  3 Mar 2022 13:14:42 -0800
Message-Id: <20220303211449.899956-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
References: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_mbx_clear_malvf function is used to clear the indication and
count of how many times a VF was detected as malicious. During
ice_free_vfs, we use this function to ensure that all removed VFs are
reset to a clean state.

The call currently is done at the end of ice_free_vfs() using a tmp
value to iterate over all of the entries in the bitmap.

This separate iteration using tmp is problematic for a planned refactor
of the VF array data structure. To avoid this, lets move the call
slightly higher into the function inside the loop where we teardown all
of the VFs. This avoids one use of the tmp value used for iteration.
We'll fix the other user in a future change.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 9ee2b3ebe486..d46f7579c650 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -536,6 +536,12 @@ void ice_free_vfs(struct ice_pf *pf)
 			ice_free_vf_res(vf);
 		}
 
+		/* clear malicious info since the VF is getting released */
+		if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->malvfs,
+					ICE_MAX_VF_COUNT, vf->vf_id))
+			dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
+				vf->vf_id);
+
 		mutex_unlock(&vf->cfg_lock);
 
 		mutex_destroy(&vf->cfg_lock);
@@ -566,13 +572,6 @@ void ice_free_vfs(struct ice_pf *pf)
 		}
 	}
 
-	/* clear malicious info if the VFs are getting released */
-	for (i = 0; i < tmp; i++)
-		if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->malvfs,
-					ICE_MAX_VF_COUNT, i))
-			dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
-				i);
-
 	clear_bit(ICE_VF_DIS, pf->state);
 	clear_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
 }
-- 
2.31.1

