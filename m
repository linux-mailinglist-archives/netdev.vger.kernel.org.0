Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2484D2B2703
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKMVew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:34:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:18350 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgKMVei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:38 -0500
IronPort-SDR: Bb0PN4ppfidhDb+5HaB3iM7IZYo3P+0M4NsRGfXzHfUBJF29UXSKuq3Hcvam+oc4LLrw7Avl3w
 Gmd3GNrygypw==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232152340"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232152340"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:34:37 -0800
IronPort-SDR: 9ykqs0LWqaZooMgoboTV8yBICLajD9BFf1qB6Q5jrFK+FPE2CNUE08gdCJ4sfpf+R3Gt3VMUjr
 /KWCO+wMeB9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="366861581"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Nov 2020 13:34:36 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.neti, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Harikumar Bokkena <harikumarx.bokkena@intel.com>
Subject: [net-next v2 01/15] ice: cleanup stack hog
Date:   Fri, 13 Nov 2020 13:33:53 -0800
Message-Id: <20201113213407.2131340-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
References: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

In ice_flow_add_prof_sync(), struct ice_flow_prof_params has recently
grown in size hogging stack space when allocated there.  Hogging stack
space should be avoided.  Change allocation to be on the heap when needed.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Harikumar Bokkena <harikumarx.bokkena@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.c | 44 +++++++++++++----------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index eadc85aee389..2a92071bd7d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -708,37 +708,42 @@ ice_flow_add_prof_sync(struct ice_hw *hw, enum ice_block blk,
 		       struct ice_flow_seg_info *segs, u8 segs_cnt,
 		       struct ice_flow_prof **prof)
 {
-	struct ice_flow_prof_params params;
+	struct ice_flow_prof_params *params;
 	enum ice_status status;
 	u8 i;
 
 	if (!prof)
 		return ICE_ERR_BAD_PTR;
 
-	memset(&params, 0, sizeof(params));
-	params.prof = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*params.prof),
-				   GFP_KERNEL);
-	if (!params.prof)
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params)
 		return ICE_ERR_NO_MEMORY;
 
+	params->prof = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*params->prof),
+				    GFP_KERNEL);
+	if (!params->prof) {
+		status = ICE_ERR_NO_MEMORY;
+		goto free_params;
+	}
+
 	/* initialize extraction sequence to all invalid (0xff) */
 	for (i = 0; i < ICE_MAX_FV_WORDS; i++) {
-		params.es[i].prot_id = ICE_PROT_INVALID;
-		params.es[i].off = ICE_FV_OFFSET_INVAL;
+		params->es[i].prot_id = ICE_PROT_INVALID;
+		params->es[i].off = ICE_FV_OFFSET_INVAL;
 	}
 
-	params.blk = blk;
-	params.prof->id = prof_id;
-	params.prof->dir = dir;
-	params.prof->segs_cnt = segs_cnt;
+	params->blk = blk;
+	params->prof->id = prof_id;
+	params->prof->dir = dir;
+	params->prof->segs_cnt = segs_cnt;
 
 	/* Make a copy of the segments that need to be persistent in the flow
 	 * profile instance
 	 */
 	for (i = 0; i < segs_cnt; i++)
-		memcpy(&params.prof->segs[i], &segs[i], sizeof(*segs));
+		memcpy(&params->prof->segs[i], &segs[i], sizeof(*segs));
 
-	status = ice_flow_proc_segs(hw, &params);
+	status = ice_flow_proc_segs(hw, params);
 	if (status) {
 		ice_debug(hw, ICE_DBG_FLOW,
 			  "Error processing a flow's packet segments\n");
@@ -746,19 +751,22 @@ ice_flow_add_prof_sync(struct ice_hw *hw, enum ice_block blk,
 	}
 
 	/* Add a HW profile for this flow profile */
-	status = ice_add_prof(hw, blk, prof_id, (u8 *)params.ptypes, params.es);
+	status = ice_add_prof(hw, blk, prof_id, (u8 *)params->ptypes,
+			      params->es);
 	if (status) {
 		ice_debug(hw, ICE_DBG_FLOW, "Error adding a HW flow profile\n");
 		goto out;
 	}
 
-	INIT_LIST_HEAD(&params.prof->entries);
-	mutex_init(&params.prof->entries_lock);
-	*prof = params.prof;
+	INIT_LIST_HEAD(&params->prof->entries);
+	mutex_init(&params->prof->entries_lock);
+	*prof = params->prof;
 
 out:
 	if (status)
-		devm_kfree(ice_hw_to_dev(hw), params.prof);
+		devm_kfree(ice_hw_to_dev(hw), params->prof);
+free_params:
+	kfree(params);
 
 	return status;
 }
-- 
2.26.2

