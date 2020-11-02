Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B1C2A367D
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgKBWYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:24:18 -0500
Received: from mga05.intel.com ([192.55.52.43]:16120 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgKBWYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:24:17 -0500
IronPort-SDR: QkptuEf/mqPFqnnHQJdPBzHt3M58zXvOQzdV3Ukeu8REosxMn+Q2CwUqfkjgU+zw+6JgjDW9p/
 0bdGMONnFgAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="253670958"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="253670958"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 14:24:16 -0800
IronPort-SDR: wpX5meI+vXbiIgl0Yw0AuATWb+AWPGL+7DUHaY0/YDuoeZQWTgNnWaycfd56usZkFAtG2gDbjB
 Hv8d1jR5SVug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="305591759"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2020 14:24:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Harikumar Bokkena <harikumarx.bokkena@intel.com>
Subject: [net-next 01/15] ice: cleanup stack hog
Date:   Mon,  2 Nov 2020 14:23:24 -0800
Message-Id: <20201102222338.1442081-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
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

