Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3434D676F
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350693AbiCKRTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350708AbiCKRTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:19:40 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EBFE33A7
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647019116; x=1678555116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=su1FUQlE8e53oIIpoDCVrJCNalkf9829lMykkCvQF74=;
  b=JiuyuS5jKmJsQFWFcxqYCTnw+3LnpX4tlhGBXbiDq0KSLDEnn8kHSM6X
   07bXNI4OqU4z+ez+eIblSTNl3ZPimRUQjQ1JUL1LSv6dQn7TwPGZKGnnh
   9GymGt57AeNa5oH9L8RP3rLT1EXGTv9IqE1LfuBWmxbDtO+nnK3ryC7J+
   tyx0YLmAo2oeTWAlzpGAXFq8EPRbP43dKKFDKj26fVekFx6c33zOO/oBF
   IYF5M9r5NcYWHL3Hy1clhyo32dESWXYqexvfAbSKII9UIiWW6s3ax0XTG
   CrBMVbPR+yxNnZsMuVguI0zcX0kFQXA5Bu1+pp7cy4ZBchOSQCpm27x8X
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="316335136"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="316335136"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 09:18:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="612215415"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 11 Mar 2022 09:18:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        marcin.szycik@linux.intel.com, wojciech.drewek@intel.com,
        jiri@resnulli.us, pablo@netfilter.org, laforge@gnumonks.org,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        osmocom-net-gprs@lists.osmocom.org,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next v11 6/7] ice: Fix FV offset searching
Date:   Fri, 11 Mar 2022 09:18:20 -0800
Message-Id: <20220311171821.3785992-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220311171821.3785992-1-anthony.l.nguyen@intel.com>
References: <20220311171821.3785992-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Checking only protocol ids while searching for correct FVs can lead to a
situation, when incorrect FV will be added to the list. Incorrect means
that FV has correct protocol id but incorrect offset.

Call ice_get_sw_fv_list with ice_prot_lkup_ext struct which contains all
protocol ids with offsets.

With this modification allocating and collecting protocol ids list is
not longer needed.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 22 +++++------
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |  2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 39 +------------------
 3 files changed, 12 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 38fe0a7e6975..c9bb338789ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1871,20 +1871,19 @@ ice_get_sw_fv_bitmap(struct ice_hw *hw, enum ice_prof_type req_profs,
 /**
  * ice_get_sw_fv_list
  * @hw: pointer to the HW structure
- * @prot_ids: field vector to search for with a given protocol ID
- * @ids_cnt: lookup/protocol count
+ * @lkups: list of protocol types
  * @bm: bitmap of field vectors to consider
  * @fv_list: Head of a list
  *
  * Finds all the field vector entries from switch block that contain
- * a given protocol ID and returns a list of structures of type
+ * a given protocol ID and offset and returns a list of structures of type
  * "ice_sw_fv_list_entry". Every structure in the list has a field vector
  * definition and profile ID information
  * NOTE: The caller of the function is responsible for freeing the memory
  * allocated for every list entry.
  */
 int
-ice_get_sw_fv_list(struct ice_hw *hw, u8 *prot_ids, u16 ids_cnt,
+ice_get_sw_fv_list(struct ice_hw *hw, struct ice_prot_lkup_ext *lkups,
 		   unsigned long *bm, struct list_head *fv_list)
 {
 	struct ice_sw_fv_list_entry *fvl;
@@ -1896,7 +1895,7 @@ ice_get_sw_fv_list(struct ice_hw *hw, u8 *prot_ids, u16 ids_cnt,
 
 	memset(&state, 0, sizeof(state));
 
-	if (!ids_cnt || !hw->seg)
+	if (!lkups->n_val_words || !hw->seg)
 		return -EINVAL;
 
 	ice_seg = hw->seg;
@@ -1915,20 +1914,17 @@ ice_get_sw_fv_list(struct ice_hw *hw, u8 *prot_ids, u16 ids_cnt,
 		if (!test_bit((u16)offset, bm))
 			continue;
 
-		for (i = 0; i < ids_cnt; i++) {
+		for (i = 0; i < lkups->n_val_words; i++) {
 			int j;
 
-			/* This code assumes that if a switch field vector line
-			 * has a matching protocol, then this line will contain
-			 * the entries necessary to represent every field in
-			 * that protocol header.
-			 */
 			for (j = 0; j < hw->blk[ICE_BLK_SW].es.fvw; j++)
-				if (fv->ew[j].prot_id == prot_ids[i])
+				if (fv->ew[j].prot_id ==
+				    lkups->fv_words[i].prot_id &&
+				    fv->ew[j].off == lkups->fv_words[i].off)
 					break;
 			if (j >= hw->blk[ICE_BLK_SW].es.fvw)
 				break;
-			if (i + 1 == ids_cnt) {
+			if (i + 1 == lkups->n_val_words) {
 				fvl = devm_kzalloc(ice_hw_to_dev(hw),
 						   sizeof(*fvl), GFP_KERNEL);
 				if (!fvl)
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index 2fd5312494c7..9c530c86703e 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -87,7 +87,7 @@ ice_get_sw_fv_bitmap(struct ice_hw *hw, enum ice_prof_type type,
 void
 ice_init_prof_result_bm(struct ice_hw *hw);
 int
-ice_get_sw_fv_list(struct ice_hw *hw, u8 *prot_ids, u16 ids_cnt,
+ice_get_sw_fv_list(struct ice_hw *hw, struct ice_prot_lkup_ext *lkups,
 		   unsigned long *bm, struct list_head *fv_list);
 int
 ice_pkg_buf_unreserve_section(struct ice_buf_build *bld, u16 count);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index d98aa35c0337..1f83bb3d73bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4734,41 +4734,6 @@ ice_create_recipe_group(struct ice_hw *hw, struct ice_sw_recipe *rm,
 	return status;
 }
 
-/**
- * ice_get_fv - get field vectors/extraction sequences for spec. lookup types
- * @hw: pointer to hardware structure
- * @lkups: lookup elements or match criteria for the advanced recipe, one
- *	   structure per protocol header
- * @lkups_cnt: number of protocols
- * @bm: bitmap of field vectors to consider
- * @fv_list: pointer to a list that holds the returned field vectors
- */
-static int
-ice_get_fv(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
-	   unsigned long *bm, struct list_head *fv_list)
-{
-	u8 *prot_ids;
-	int status;
-	u16 i;
-
-	prot_ids = kcalloc(lkups_cnt, sizeof(*prot_ids), GFP_KERNEL);
-	if (!prot_ids)
-		return -ENOMEM;
-
-	for (i = 0; i < lkups_cnt; i++)
-		if (!ice_prot_type_to_id(lkups[i].type, &prot_ids[i])) {
-			status = -EIO;
-			goto free_mem;
-		}
-
-	/* Find field vectors that include all specified protocol types */
-	status = ice_get_sw_fv_list(hw, prot_ids, lkups_cnt, bm, fv_list);
-
-free_mem:
-	kfree(prot_ids);
-	return status;
-}
-
 /**
  * ice_tun_type_match_word - determine if tun type needs a match mask
  * @tun_type: tunnel type
@@ -4917,11 +4882,11 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 
 	/* Get bitmap of field vectors (profiles) that are compatible with the
 	 * rule request; only these will be searched in the subsequent call to
-	 * ice_get_fv.
+	 * ice_get_sw_fv_list.
 	 */
 	ice_get_compat_fv_bitmap(hw, rinfo, fv_bitmap);
 
-	status = ice_get_fv(hw, lkups, lkups_cnt, fv_bitmap, &rm->fv_list);
+	status = ice_get_sw_fv_list(hw, lkup_exts, fv_bitmap, &rm->fv_list);
 	if (status)
 		goto err_unroll;
 
-- 
2.31.1

