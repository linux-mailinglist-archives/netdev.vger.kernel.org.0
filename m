Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF7C165227
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgBSWHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:07:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:51315 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgBSWG7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:06:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824806"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dan Nowlin <dan.nowlin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/13] ice: Fix for TCAM entry management
Date:   Wed, 19 Feb 2020 14:06:42 -0800
Message-Id: <20200219220652.2255171-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Nowlin <dan.nowlin@intel.com>

Order intermediate VSIG list correct in order to correctly match existing
VSIG lists.

When overriding pre-existing TCAM entries, properly delete the existing
entry and remove it from the change/update list.

Signed-off-by: Dan Nowlin <dan.nowlin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 65 +++++++++++++++----
 1 file changed, 51 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 99208946224c..42bac3ec5526 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -3470,6 +3470,24 @@ ice_move_vsi(struct ice_hw *hw, enum ice_block blk, u16 vsi, u16 vsig,
 	return 0;
 }
 
+/**
+ * ice_rem_chg_tcam_ent - remove a specific TCAM entry from change list
+ * @hw: pointer to the HW struct
+ * @idx: the index of the TCAM entry to remove
+ * @chg: the list of change structures to search
+ */
+static void
+ice_rem_chg_tcam_ent(struct ice_hw *hw, u16 idx, struct list_head *chg)
+{
+	struct ice_chs_chg *pos, *tmp;
+
+	list_for_each_entry_safe(tmp, pos, chg, list_entry)
+		if (tmp->type == ICE_TCAM_ADD && tmp->tcam_idx == idx) {
+			list_del(&tmp->list_entry);
+			devm_kfree(ice_hw_to_dev(hw), tmp);
+		}
+}
+
 /**
  * ice_prof_tcam_ena_dis - add enable or disable TCAM change
  * @hw: pointer to the HW struct
@@ -3489,14 +3507,19 @@ ice_prof_tcam_ena_dis(struct ice_hw *hw, enum ice_block blk, bool enable,
 	enum ice_status status;
 	struct ice_chs_chg *p;
 
-	/* Default: enable means change the low flag bit to don't care */
-	u8 dc_msk[ICE_TCAM_KEY_VAL_SZ] = { 0x01, 0x00, 0x00, 0x00, 0x00 };
+	u8 vl_msk[ICE_TCAM_KEY_VAL_SZ] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+	u8 dc_msk[ICE_TCAM_KEY_VAL_SZ] = { 0xFF, 0xFF, 0x00, 0x00, 0x00 };
 	u8 nm_msk[ICE_TCAM_KEY_VAL_SZ] = { 0x00, 0x00, 0x00, 0x00, 0x00 };
-	u8 vl_msk[ICE_TCAM_KEY_VAL_SZ] = { 0x01, 0x00, 0x00, 0x00, 0x00 };
 
 	/* if disabling, free the TCAM */
 	if (!enable) {
-		status = ice_free_tcam_ent(hw, blk, tcam->tcam_idx);
+		status = ice_rel_tcam_idx(hw, blk, tcam->tcam_idx);
+
+		/* if we have already created a change for this TCAM entry, then
+		 * we need to remove that entry, in order to prevent writing to
+		 * a TCAM entry we no longer will have ownership of.
+		 */
+		ice_rem_chg_tcam_ent(hw, tcam->tcam_idx, chg);
 		tcam->tcam_idx = 0;
 		tcam->in_use = 0;
 		return status;
@@ -3612,11 +3635,12 @@ ice_adj_prof_priorities(struct ice_hw *hw, enum ice_block blk, u16 vsig,
  * @blk: hardware block
  * @vsig: the VSIG to which this profile is to be added
  * @hdl: the profile handle indicating the profile to add
+ * @rev: true to add entries to the end of the list
  * @chg: the change list
  */
 static enum ice_status
 ice_add_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl,
-		     struct list_head *chg)
+		     bool rev, struct list_head *chg)
 {
 	/* Masks that ignore flags */
 	u8 vl_msk[ICE_TCAM_KEY_VAL_SZ] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
@@ -3625,7 +3649,7 @@ ice_add_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl,
 	struct ice_prof_map *map;
 	struct ice_vsig_prof *t;
 	struct ice_chs_chg *p;
-	u16 i;
+	u16 vsig_idx, i;
 
 	/* Get the details on the profile specified by the handle ID */
 	map = ice_search_prof_id(hw, blk, hdl);
@@ -3687,8 +3711,13 @@ ice_add_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl,
 	}
 
 	/* add profile to VSIG */
-	list_add(&t->list,
-		 &hw->blk[blk].xlt2.vsig_tbl[(vsig & ICE_VSIG_IDX_M)].prop_lst);
+	vsig_idx = vsig & ICE_VSIG_IDX_M;
+	if (rev)
+		list_add_tail(&t->list,
+			      &hw->blk[blk].xlt2.vsig_tbl[vsig_idx].prop_lst);
+	else
+		list_add(&t->list,
+			 &hw->blk[blk].xlt2.vsig_tbl[vsig_idx].prop_lst);
 
 	return 0;
 
@@ -3728,7 +3757,7 @@ ice_create_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl,
 	if (status)
 		goto err_ice_create_prof_id_vsig;
 
-	status = ice_add_prof_id_vsig(hw, blk, new_vsig, hdl, chg);
+	status = ice_add_prof_id_vsig(hw, blk, new_vsig, hdl, false, chg);
 	if (status)
 		goto err_ice_create_prof_id_vsig;
 
@@ -3753,11 +3782,13 @@ ice_create_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl,
  * @blk: hardware block
  * @vsi: the initial VSI that will be in VSIG
  * @lst: the list of profile that will be added to the VSIG
+ * @new_vsig: return of new VSIG
  * @chg: the change list
  */
 static enum ice_status
 ice_create_vsig_from_lst(struct ice_hw *hw, enum ice_block blk, u16 vsi,
-			 struct list_head *lst, struct list_head *chg)
+			 struct list_head *lst, u16 *new_vsig,
+			 struct list_head *chg)
 {
 	struct ice_vsig_prof *t;
 	enum ice_status status;
@@ -3772,12 +3803,15 @@ ice_create_vsig_from_lst(struct ice_hw *hw, enum ice_block blk, u16 vsi,
 		return status;
 
 	list_for_each_entry(t, lst, list) {
+		/* Reverse the order here since we are copying the list */
 		status = ice_add_prof_id_vsig(hw, blk, vsig, t->profile_cookie,
-					      chg);
+					      true, chg);
 		if (status)
 			return status;
 	}
 
+	*new_vsig = vsig;
+
 	return 0;
 }
 
@@ -3899,7 +3933,8 @@ ice_add_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl)
 			 * not sharing entries and we can simply add the new
 			 * profile to the VSIG.
 			 */
-			status = ice_add_prof_id_vsig(hw, blk, vsig, hdl, &chg);
+			status = ice_add_prof_id_vsig(hw, blk, vsig, hdl, false,
+						      &chg);
 			if (status)
 				goto err_ice_add_prof_id_flow;
 
@@ -3910,7 +3945,8 @@ ice_add_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl)
 		} else {
 			/* No match, so we need a new VSIG */
 			status = ice_create_vsig_from_lst(hw, blk, vsi,
-							  &union_lst, &chg);
+							  &union_lst, &vsig,
+							  &chg);
 			if (status)
 				goto err_ice_add_prof_id_flow;
 
@@ -4076,7 +4112,8 @@ ice_rem_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl)
 				 * new VSIG and TCAM entries
 				 */
 				status = ice_create_vsig_from_lst(hw, blk, vsi,
-								  &copy, &chg);
+								  &copy, &vsig,
+								  &chg);
 				if (status)
 					goto err_ice_rem_prof_id_flow;
 
-- 
2.24.1

