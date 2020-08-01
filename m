Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF9D235345
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgHAQS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:19614 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbgHAQSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:12 -0400
IronPort-SDR: mwwLSSxu2qIHiT/cxfx1zIxh8LrKEdoymLuUs1kuyecsce5lTEubWU6UuTe+mXcbeY40C7Xagy
 IWm3tMEiLFAg==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810863"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810863"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:08 -0700
IronPort-SDR: R/aPeMoiTb7O6eMfzZ8j3+yIGSX0AKECI101eKgmpREEF50o5PXHfxWckzJmAZW4kH10p1XZPO
 nbA4yliaD8rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457726"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Victor Raj <victor.raj@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 13/14] ice: adjust profile ID map locks
Date:   Sat,  1 Aug 2020 09:18:01 -0700
Message-Id: <20200801161802.867645-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victor Raj <victor.raj@intel.com>

The profile ID map lock should be held till the caller completes
all references of that profile entries.

The current code releases the lock right after the match search.
This caused a driver issue when the profile map entries were
referenced after it was freed in other thread after the lock was
released earlier.

Signed-off-by: Victor Raj <victor.raj@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 90 +++++++++----------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 5ceba009db16..2691dac0e159 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -3878,16 +3878,16 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 }
 
 /**
- * ice_search_prof_id_low - Search for a profile tracking ID low level
+ * ice_search_prof_id - Search for a profile tracking ID
  * @hw: pointer to the HW struct
  * @blk: hardware block
  * @id: profile tracking ID
  *
- * This will search for a profile tracking ID which was previously added. This
- * version assumes that the caller has already acquired the prof map lock.
+ * This will search for a profile tracking ID which was previously added.
+ * The profile map lock should be held before calling this function.
  */
 static struct ice_prof_map *
-ice_search_prof_id_low(struct ice_hw *hw, enum ice_block blk, u64 id)
+ice_search_prof_id(struct ice_hw *hw, enum ice_block blk, u64 id)
 {
 	struct ice_prof_map *entry = NULL;
 	struct ice_prof_map *map;
@@ -3901,26 +3901,6 @@ ice_search_prof_id_low(struct ice_hw *hw, enum ice_block blk, u64 id)
 	return entry;
 }
 
-/**
- * ice_search_prof_id - Search for a profile tracking ID
- * @hw: pointer to the HW struct
- * @blk: hardware block
- * @id: profile tracking ID
- *
- * This will search for a profile tracking ID which was previously added.
- */
-static struct ice_prof_map *
-ice_search_prof_id(struct ice_hw *hw, enum ice_block blk, u64 id)
-{
-	struct ice_prof_map *entry;
-
-	mutex_lock(&hw->blk[blk].es.prof_map_lock);
-	entry = ice_search_prof_id_low(hw, blk, id);
-	mutex_unlock(&hw->blk[blk].es.prof_map_lock);
-
-	return entry;
-}
-
 /**
  * ice_vsig_prof_id_count - count profiles in a VSIG
  * @hw: pointer to the HW struct
@@ -4137,7 +4117,7 @@ enum ice_status ice_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 id)
 
 	mutex_lock(&hw->blk[blk].es.prof_map_lock);
 
-	pmap = ice_search_prof_id_low(hw, blk, id);
+	pmap = ice_search_prof_id(hw, blk, id);
 	if (!pmap) {
 		status = ICE_ERR_DOES_NOT_EXIST;
 		goto err_ice_rem_prof;
@@ -4170,22 +4150,28 @@ static enum ice_status
 ice_get_prof(struct ice_hw *hw, enum ice_block blk, u64 hdl,
 	     struct list_head *chg)
 {
+	enum ice_status status = 0;
 	struct ice_prof_map *map;
 	struct ice_chs_chg *p;
 	u16 i;
 
+	mutex_lock(&hw->blk[blk].es.prof_map_lock);
 	/* Get the details on the profile specified by the handle ID */
 	map = ice_search_prof_id(hw, blk, hdl);
-	if (!map)
-		return ICE_ERR_DOES_NOT_EXIST;
+	if (!map) {
+		status = ICE_ERR_DOES_NOT_EXIST;
+		goto err_ice_get_prof;
+	}
 
 	for (i = 0; i < map->ptg_cnt; i++)
 		if (!hw->blk[blk].es.written[map->prof_id]) {
 			/* add ES to change list */
 			p = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*p),
 					 GFP_KERNEL);
-			if (!p)
+			if (!p) {
+				status = ICE_ERR_NO_MEMORY;
 				goto err_ice_get_prof;
+			}
 
 			p->type = ICE_PTG_ES_ADD;
 			p->ptype = 0;
@@ -4200,11 +4186,10 @@ ice_get_prof(struct ice_hw *hw, enum ice_block blk, u64 hdl,
 			list_add(&p->list_entry, chg);
 		}
 
-	return 0;
-
 err_ice_get_prof:
+	mutex_unlock(&hw->blk[blk].es.prof_map_lock);
 	/* let caller clean up the change list */
-	return ICE_ERR_NO_MEMORY;
+	return status;
 }
 
 /**
@@ -4258,17 +4243,23 @@ static enum ice_status
 ice_add_prof_to_lst(struct ice_hw *hw, enum ice_block blk,
 		    struct list_head *lst, u64 hdl)
 {
+	enum ice_status status = 0;
 	struct ice_prof_map *map;
 	struct ice_vsig_prof *p;
 	u16 i;
 
+	mutex_lock(&hw->blk[blk].es.prof_map_lock);
 	map = ice_search_prof_id(hw, blk, hdl);
-	if (!map)
-		return ICE_ERR_DOES_NOT_EXIST;
+	if (!map) {
+		status = ICE_ERR_DOES_NOT_EXIST;
+		goto err_ice_add_prof_to_lst;
+	}
 
 	p = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*p), GFP_KERNEL);
-	if (!p)
-		return ICE_ERR_NO_MEMORY;
+	if (!p) {
+		status = ICE_ERR_NO_MEMORY;
+		goto err_ice_add_prof_to_lst;
+	}
 
 	p->profile_cookie = map->profile_cookie;
 	p->prof_id = map->prof_id;
@@ -4282,7 +4273,9 @@ ice_add_prof_to_lst(struct ice_hw *hw, enum ice_block blk,
 
 	list_add(&p->list, lst);
 
-	return 0;
+err_ice_add_prof_to_lst:
+	mutex_unlock(&hw->blk[blk].es.prof_map_lock);
+	return status;
 }
 
 /**
@@ -4500,16 +4493,12 @@ ice_add_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl,
 	u8 vl_msk[ICE_TCAM_KEY_VAL_SZ] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 	u8 dc_msk[ICE_TCAM_KEY_VAL_SZ] = { 0xFF, 0xFF, 0x00, 0x00, 0x00 };
 	u8 nm_msk[ICE_TCAM_KEY_VAL_SZ] = { 0x00, 0x00, 0x00, 0x00, 0x00 };
+	enum ice_status status = 0;
 	struct ice_prof_map *map;
 	struct ice_vsig_prof *t;
 	struct ice_chs_chg *p;
 	u16 vsig_idx, i;
 
-	/* Get the details on the profile specified by the handle ID */
-	map = ice_search_prof_id(hw, blk, hdl);
-	if (!map)
-		return ICE_ERR_DOES_NOT_EXIST;
-
 	/* Error, if this VSIG already has this profile */
 	if (ice_has_prof_vsig(hw, blk, vsig, hdl))
 		return ICE_ERR_ALREADY_EXISTS;
@@ -4519,19 +4508,28 @@ ice_add_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl,
 	if (!t)
 		return ICE_ERR_NO_MEMORY;
 
+	mutex_lock(&hw->blk[blk].es.prof_map_lock);
+	/* Get the details on the profile specified by the handle ID */
+	map = ice_search_prof_id(hw, blk, hdl);
+	if (!map) {
+		status = ICE_ERR_DOES_NOT_EXIST;
+		goto err_ice_add_prof_id_vsig;
+	}
+
 	t->profile_cookie = map->profile_cookie;
 	t->prof_id = map->prof_id;
 	t->tcam_count = map->ptg_cnt;
 
 	/* create TCAM entries */
 	for (i = 0; i < map->ptg_cnt; i++) {
-		enum ice_status status;
 		u16 tcam_idx;
 
 		/* add TCAM to change list */
 		p = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*p), GFP_KERNEL);
-		if (!p)
+		if (!p) {
+			status = ICE_ERR_NO_MEMORY;
 			goto err_ice_add_prof_id_vsig;
+		}
 
 		/* allocate the TCAM entry index */
 		status = ice_alloc_tcam_ent(hw, blk, &tcam_idx);
@@ -4575,12 +4573,14 @@ ice_add_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl,
 		list_add(&t->list,
 			 &hw->blk[blk].xlt2.vsig_tbl[vsig_idx].prop_lst);
 
-	return 0;
+	mutex_unlock(&hw->blk[blk].es.prof_map_lock);
+	return status;
 
 err_ice_add_prof_id_vsig:
+	mutex_unlock(&hw->blk[blk].es.prof_map_lock);
 	/* let caller clean up the change list */
 	devm_kfree(ice_hw_to_dev(hw), t);
-	return ICE_ERR_NO_MEMORY;
+	return status;
 }
 
 /**
-- 
2.26.2

