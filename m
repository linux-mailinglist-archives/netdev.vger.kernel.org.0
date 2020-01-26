Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9C2114996D
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 07:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgAZGHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 01:07:48 -0500
Received: from mga14.intel.com ([192.55.52.115]:18151 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727642AbgAZGHn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 01:07:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 22:07:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,364,1574150400"; 
   d="scan'208";a="230947216"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2020 22:07:40 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Henry Tieman <henry.w.tieman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 5/8] ice: Optimize table usage
Date:   Sat, 25 Jan 2020 22:07:34 -0800
Message-Id: <20200126060737.3238027-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200126060737.3238027-1-jeffrey.t.kirsher@intel.com>
References: <20200126060737.3238027-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

Attempt to optimize TCAM entries and reduce table resource usage by
searching for profiles that can be reused. Provide resource cleanup
of both hardware and software structures.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 394 ++++++++++++++++++
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   4 +
 drivers/net/ethernet/intel/ice/ice_flow.c     | 338 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_flow.h     |  10 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  28 +-
 5 files changed, 773 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 6dca611b408a..99208946224c 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1921,6 +1921,26 @@ ice_alloc_prof_id(struct ice_hw *hw, enum ice_block blk, u8 *prof_id)
 	return status;
 }
 
+/**
+ * ice_free_prof_id - free profile ID
+ * @hw: pointer to the HW struct
+ * @blk: the block from which to free the profile ID
+ * @prof_id: the profile ID to free
+ *
+ * This function frees a profile ID, which also corresponds to a Field Vector.
+ */
+static enum ice_status
+ice_free_prof_id(struct ice_hw *hw, enum ice_block blk, u8 prof_id)
+{
+	u16 tmp_prof_id = (u16)prof_id;
+	u16 res_type;
+
+	if (!ice_prof_id_rsrc_type(blk, &res_type))
+		return ICE_ERR_PARAM;
+
+	return ice_free_hw_res(hw, res_type, 1, &tmp_prof_id);
+}
+
 /**
  * ice_prof_inc_ref - increment reference count for profile
  * @hw: pointer to the HW struct
@@ -1962,6 +1982,28 @@ ice_write_es(struct ice_hw *hw, enum ice_block blk, u8 prof_id,
 	}
 }
 
+/**
+ * ice_prof_dec_ref - decrement reference count for profile
+ * @hw: pointer to the HW struct
+ * @blk: the block from which to free the profile ID
+ * @prof_id: the profile ID for which to decrement the reference count
+ */
+static enum ice_status
+ice_prof_dec_ref(struct ice_hw *hw, enum ice_block blk, u8 prof_id)
+{
+	if (prof_id > hw->blk[blk].es.count)
+		return ICE_ERR_PARAM;
+
+	if (hw->blk[blk].es.ref_count[prof_id] > 0) {
+		if (!--hw->blk[blk].es.ref_count[prof_id]) {
+			ice_write_es(hw, blk, prof_id, NULL);
+			return ice_free_prof_id(hw, blk, prof_id);
+		}
+	}
+
+	return 0;
+}
+
 /* Block / table section IDs */
 static const u32 ice_blk_sids[ICE_BLK_COUNT][ICE_SID_OFF_COUNT] = {
 	/* SWITCH */
@@ -2218,6 +2260,64 @@ void ice_fill_blk_tbls(struct ice_hw *hw)
 	ice_init_sw_db(hw);
 }
 
+/**
+ * ice_free_prof_map - free profile map
+ * @hw: pointer to the hardware structure
+ * @blk_idx: HW block index
+ */
+static void ice_free_prof_map(struct ice_hw *hw, u8 blk_idx)
+{
+	struct ice_es *es = &hw->blk[blk_idx].es;
+	struct ice_prof_map *del, *tmp;
+
+	mutex_lock(&es->prof_map_lock);
+	list_for_each_entry_safe(del, tmp, &es->prof_map, list) {
+		list_del(&del->list);
+		devm_kfree(ice_hw_to_dev(hw), del);
+	}
+	INIT_LIST_HEAD(&es->prof_map);
+	mutex_unlock(&es->prof_map_lock);
+}
+
+/**
+ * ice_free_flow_profs - free flow profile entries
+ * @hw: pointer to the hardware structure
+ * @blk_idx: HW block index
+ */
+static void ice_free_flow_profs(struct ice_hw *hw, u8 blk_idx)
+{
+	struct ice_flow_prof *p, *tmp;
+
+	mutex_lock(&hw->fl_profs_locks[blk_idx]);
+	list_for_each_entry_safe(p, tmp, &hw->fl_profs[blk_idx], l_entry) {
+		list_del(&p->l_entry);
+		devm_kfree(ice_hw_to_dev(hw), p);
+	}
+	mutex_unlock(&hw->fl_profs_locks[blk_idx]);
+
+	/* if driver is in reset and tables are being cleared
+	 * re-initialize the flow profile list heads
+	 */
+	INIT_LIST_HEAD(&hw->fl_profs[blk_idx]);
+}
+
+/**
+ * ice_free_vsig_tbl - free complete VSIG table entries
+ * @hw: pointer to the hardware structure
+ * @blk: the HW block on which to free the VSIG table entries
+ */
+static void ice_free_vsig_tbl(struct ice_hw *hw, enum ice_block blk)
+{
+	u16 i;
+
+	if (!hw->blk[blk].xlt2.vsig_tbl)
+		return;
+
+	for (i = 1; i < ICE_MAX_VSIGS; i++)
+		if (hw->blk[blk].xlt2.vsig_tbl[i].in_use)
+			ice_vsig_free(hw, blk, i);
+}
+
 /**
  * ice_free_hw_tbls - free hardware table memory
  * @hw: pointer to the hardware structure
@@ -2231,11 +2331,15 @@ void ice_free_hw_tbls(struct ice_hw *hw)
 		if (hw->blk[i].is_list_init) {
 			struct ice_es *es = &hw->blk[i].es;
 
+			ice_free_prof_map(hw, i);
 			mutex_destroy(&es->prof_map_lock);
+
+			ice_free_flow_profs(hw, i);
 			mutex_destroy(&hw->fl_profs_locks[i]);
 
 			hw->blk[i].is_list_init = false;
 		}
+		ice_free_vsig_tbl(hw, (enum ice_block)i);
 		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt1.ptypes);
 		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt1.ptg_tbl);
 		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt1.t);
@@ -2283,6 +2387,13 @@ void ice_clear_hw_tbls(struct ice_hw *hw)
 		struct ice_xlt2 *xlt2 = &hw->blk[i].xlt2;
 		struct ice_es *es = &hw->blk[i].es;
 
+		if (hw->blk[i].is_list_init) {
+			ice_free_prof_map(hw, i);
+			ice_free_flow_profs(hw, i);
+		}
+
+		ice_free_vsig_tbl(hw, (enum ice_block)i);
+
 		memset(xlt1->ptypes, 0, xlt1->count * sizeof(*xlt1->ptypes));
 		memset(xlt1->ptg_tbl, 0,
 		       ICE_MAX_PTGS * sizeof(*xlt1->ptg_tbl));
@@ -2956,6 +3067,25 @@ ice_search_prof_id(struct ice_hw *hw, enum ice_block blk, u64 id)
 	return entry;
 }
 
+/**
+ * ice_vsig_prof_id_count - count profiles in a VSIG
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsig: VSIG to remove the profile from
+ */
+static u16
+ice_vsig_prof_id_count(struct ice_hw *hw, enum ice_block blk, u16 vsig)
+{
+	u16 idx = vsig & ICE_VSIG_IDX_M, count = 0;
+	struct ice_vsig_prof *p;
+
+	list_for_each_entry(p, &hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst,
+			    list)
+		count++;
+
+	return count;
+}
+
 /**
  * ice_rel_tcam_idx - release a TCAM index
  * @hw: pointer to the HW struct
@@ -3064,6 +3194,117 @@ ice_rem_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig,
 	return ice_vsig_free(hw, blk, vsig);
 }
 
+/**
+ * ice_rem_prof_id_vsig - remove a specific profile from a VSIG
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsig: VSIG to remove the profile from
+ * @hdl: profile handle indicating which profile to remove
+ * @chg: list to receive a record of changes
+ */
+static enum ice_status
+ice_rem_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl,
+		     struct list_head *chg)
+{
+	u16 idx = vsig & ICE_VSIG_IDX_M;
+	struct ice_vsig_prof *p, *t;
+	enum ice_status status;
+
+	list_for_each_entry_safe(p, t,
+				 &hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst,
+				 list)
+		if (p->profile_cookie == hdl) {
+			if (ice_vsig_prof_id_count(hw, blk, vsig) == 1)
+				/* this is the last profile, remove the VSIG */
+				return ice_rem_vsig(hw, blk, vsig, chg);
+
+			status = ice_rem_prof_id(hw, blk, p);
+			if (!status) {
+				list_del(&p->list);
+				devm_kfree(ice_hw_to_dev(hw), p);
+			}
+			return status;
+		}
+
+	return ICE_ERR_DOES_NOT_EXIST;
+}
+
+/**
+ * ice_rem_flow_all - remove all flows with a particular profile
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @id: profile tracking ID
+ */
+static enum ice_status
+ice_rem_flow_all(struct ice_hw *hw, enum ice_block blk, u64 id)
+{
+	struct ice_chs_chg *del, *tmp;
+	enum ice_status status;
+	struct list_head chg;
+	u16 i;
+
+	INIT_LIST_HEAD(&chg);
+
+	for (i = 1; i < ICE_MAX_VSIGS; i++)
+		if (hw->blk[blk].xlt2.vsig_tbl[i].in_use) {
+			if (ice_has_prof_vsig(hw, blk, i, id)) {
+				status = ice_rem_prof_id_vsig(hw, blk, i, id,
+							      &chg);
+				if (status)
+					goto err_ice_rem_flow_all;
+			}
+		}
+
+	status = ice_upd_prof_hw(hw, blk, &chg);
+
+err_ice_rem_flow_all:
+	list_for_each_entry_safe(del, tmp, &chg, list_entry) {
+		list_del(&del->list_entry);
+		devm_kfree(ice_hw_to_dev(hw), del);
+	}
+
+	return status;
+}
+
+/**
+ * ice_rem_prof - remove profile
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @id: profile tracking ID
+ *
+ * This will remove the profile specified by the ID parameter, which was
+ * previously created through ice_add_prof. If any existing entries
+ * are associated with this profile, they will be removed as well.
+ */
+enum ice_status ice_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 id)
+{
+	struct ice_prof_map *pmap;
+	enum ice_status status;
+
+	mutex_lock(&hw->blk[blk].es.prof_map_lock);
+
+	pmap = ice_search_prof_id_low(hw, blk, id);
+	if (!pmap) {
+		status = ICE_ERR_DOES_NOT_EXIST;
+		goto err_ice_rem_prof;
+	}
+
+	/* remove all flows with this profile */
+	status = ice_rem_flow_all(hw, blk, pmap->profile_cookie);
+	if (status)
+		goto err_ice_rem_prof;
+
+	/* dereference profile, and possibly remove */
+	ice_prof_dec_ref(hw, blk, pmap->prof_id);
+
+	list_del(&pmap->list);
+	devm_kfree(ice_hw_to_dev(hw), pmap);
+
+err_ice_rem_prof:
+	mutex_unlock(&hw->blk[blk].es.prof_map_lock);
+	return status;
+}
+
 /**
  * ice_get_prof - get profile
  * @hw: pointer to the HW struct
@@ -3714,3 +3955,156 @@ ice_add_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl)
 
 	return status;
 }
+
+/**
+ * ice_rem_prof_from_list - remove a profile from list
+ * @hw: pointer to the HW struct
+ * @lst: list to remove the profile from
+ * @hdl: the profile handle indicating the profile to remove
+ */
+static enum ice_status
+ice_rem_prof_from_list(struct ice_hw *hw, struct list_head *lst, u64 hdl)
+{
+	struct ice_vsig_prof *ent, *tmp;
+
+	list_for_each_entry_safe(ent, tmp, lst, list)
+		if (ent->profile_cookie == hdl) {
+			list_del(&ent->list);
+			devm_kfree(ice_hw_to_dev(hw), ent);
+			return 0;
+		}
+
+	return ICE_ERR_DOES_NOT_EXIST;
+}
+
+/**
+ * ice_rem_prof_id_flow - remove flow
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsi: the VSI from which to remove the profile specified by ID
+ * @hdl: profile tracking handle
+ *
+ * Calling this function will update the hardware tables to remove the
+ * profile indicated by the ID parameter for the VSIs specified in the VSI
+ * array. Once successfully called, the flow will be disabled.
+ */
+enum ice_status
+ice_rem_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl)
+{
+	struct ice_vsig_prof *tmp1, *del1;
+	struct ice_chs_chg *tmp, *del;
+	struct list_head chg, copy;
+	enum ice_status status;
+	u16 vsig;
+
+	INIT_LIST_HEAD(&copy);
+	INIT_LIST_HEAD(&chg);
+
+	/* determine if VSI is already part of a VSIG */
+	status = ice_vsig_find_vsi(hw, blk, vsi, &vsig);
+	if (!status && vsig) {
+		bool last_profile;
+		bool only_vsi;
+		u16 ref;
+
+		/* found in VSIG */
+		last_profile = ice_vsig_prof_id_count(hw, blk, vsig) == 1;
+		status = ice_vsig_get_ref(hw, blk, vsig, &ref);
+		if (status)
+			goto err_ice_rem_prof_id_flow;
+		only_vsi = (ref == 1);
+
+		if (only_vsi) {
+			/* If the original VSIG only contains one reference,
+			 * which will be the requesting VSI, then the VSI is not
+			 * sharing entries and we can simply remove the specific
+			 * characteristics from the VSIG.
+			 */
+
+			if (last_profile) {
+				/* If there are no profiles left for this VSIG,
+				 * then simply remove the the VSIG.
+				 */
+				status = ice_rem_vsig(hw, blk, vsig, &chg);
+				if (status)
+					goto err_ice_rem_prof_id_flow;
+			} else {
+				status = ice_rem_prof_id_vsig(hw, blk, vsig,
+							      hdl, &chg);
+				if (status)
+					goto err_ice_rem_prof_id_flow;
+
+				/* Adjust priorities */
+				status = ice_adj_prof_priorities(hw, blk, vsig,
+								 &chg);
+				if (status)
+					goto err_ice_rem_prof_id_flow;
+			}
+
+		} else {
+			/* Make a copy of the VSIG's list of Profiles */
+			status = ice_get_profs_vsig(hw, blk, vsig, &copy);
+			if (status)
+				goto err_ice_rem_prof_id_flow;
+
+			/* Remove specified profile entry from the list */
+			status = ice_rem_prof_from_list(hw, &copy, hdl);
+			if (status)
+				goto err_ice_rem_prof_id_flow;
+
+			if (list_empty(&copy)) {
+				status = ice_move_vsi(hw, blk, vsi,
+						      ICE_DEFAULT_VSIG, &chg);
+				if (status)
+					goto err_ice_rem_prof_id_flow;
+
+			} else if (!ice_find_dup_props_vsig(hw, blk, &copy,
+							    &vsig)) {
+				/* found an exact match */
+				/* add or move VSI to the VSIG that matches */
+				/* Search for a VSIG with a matching profile
+				 * list
+				 */
+
+				/* Found match, move VSI to the matching VSIG */
+				status = ice_move_vsi(hw, blk, vsi, vsig, &chg);
+				if (status)
+					goto err_ice_rem_prof_id_flow;
+			} else {
+				/* since no existing VSIG supports this
+				 * characteristic pattern, we need to create a
+				 * new VSIG and TCAM entries
+				 */
+				status = ice_create_vsig_from_lst(hw, blk, vsi,
+								  &copy, &chg);
+				if (status)
+					goto err_ice_rem_prof_id_flow;
+
+				/* Adjust priorities */
+				status = ice_adj_prof_priorities(hw, blk, vsig,
+								 &chg);
+				if (status)
+					goto err_ice_rem_prof_id_flow;
+			}
+		}
+	} else {
+		status = ICE_ERR_DOES_NOT_EXIST;
+	}
+
+	/* update hardware tables */
+	if (!status)
+		status = ice_upd_prof_hw(hw, blk, &chg);
+
+err_ice_rem_prof_id_flow:
+	list_for_each_entry_safe(del, tmp, &chg, list_entry) {
+		list_del(&del->list_entry);
+		devm_kfree(ice_hw_to_dev(hw), del);
+	}
+
+	list_for_each_entry_safe(del1, tmp1, &copy, list) {
+		list_del(&del1->list);
+		devm_kfree(ice_hw_to_dev(hw), del1);
+	}
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index 33e4510da24c..c7b5e1a6ea2b 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -23,6 +23,8 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 	     struct ice_fv_word *es);
 enum ice_status
 ice_add_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl);
+enum ice_status
+ice_rem_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl);
 enum ice_status ice_init_pkg(struct ice_hw *hw, u8 *buff, u32 len);
 enum ice_status
 ice_copy_and_init_pkg(struct ice_hw *hw, const u8 *buf, u32 len);
@@ -31,4 +33,6 @@ void ice_free_seg(struct ice_hw *hw);
 void ice_fill_blk_tbls(struct ice_hw *hw);
 void ice_clear_hw_tbls(struct ice_hw *hw);
 void ice_free_hw_tbls(struct ice_hw *hw);
+enum ice_status
+ice_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 id);
 #endif /* _ICE_FLEX_PIPE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 1bbf4b6ed7d2..ffce2284d8fa 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -377,6 +377,77 @@ ice_flow_proc_segs(struct ice_hw *hw, struct ice_flow_prof_params *params)
 	return status;
 }
 
+#define ICE_FLOW_FIND_PROF_CHK_FLDS	0x00000001
+#define ICE_FLOW_FIND_PROF_CHK_VSI	0x00000002
+#define ICE_FLOW_FIND_PROF_NOT_CHK_DIR	0x00000004
+
+/**
+ * ice_flow_find_prof_conds - Find a profile matching headers and conditions
+ * @hw: pointer to the HW struct
+ * @blk: classification stage
+ * @dir: flow direction
+ * @segs: array of one or more packet segments that describe the flow
+ * @segs_cnt: number of packet segments provided
+ * @vsi_handle: software VSI handle to check VSI (ICE_FLOW_FIND_PROF_CHK_VSI)
+ * @conds: additional conditions to be checked (ICE_FLOW_FIND_PROF_CHK_*)
+ */
+static struct ice_flow_prof *
+ice_flow_find_prof_conds(struct ice_hw *hw, enum ice_block blk,
+			 enum ice_flow_dir dir, struct ice_flow_seg_info *segs,
+			 u8 segs_cnt, u16 vsi_handle, u32 conds)
+{
+	struct ice_flow_prof *p, *prof = NULL;
+
+	mutex_lock(&hw->fl_profs_locks[blk]);
+	list_for_each_entry(p, &hw->fl_profs[blk], l_entry)
+		if ((p->dir == dir || conds & ICE_FLOW_FIND_PROF_NOT_CHK_DIR) &&
+		    segs_cnt && segs_cnt == p->segs_cnt) {
+			u8 i;
+
+			/* Check for profile-VSI association if specified */
+			if ((conds & ICE_FLOW_FIND_PROF_CHK_VSI) &&
+			    ice_is_vsi_valid(hw, vsi_handle) &&
+			    !test_bit(vsi_handle, p->vsis))
+				continue;
+
+			/* Protocol headers must be checked. Matched fields are
+			 * checked if specified.
+			 */
+			for (i = 0; i < segs_cnt; i++)
+				if (segs[i].hdrs != p->segs[i].hdrs ||
+				    ((conds & ICE_FLOW_FIND_PROF_CHK_FLDS) &&
+				     segs[i].match != p->segs[i].match))
+					break;
+
+			/* A match is found if all segments are matched */
+			if (i == segs_cnt) {
+				prof = p;
+				break;
+			}
+		}
+	mutex_unlock(&hw->fl_profs_locks[blk]);
+
+	return prof;
+}
+
+/**
+ * ice_flow_find_prof_id - Look up a profile with given profile ID
+ * @hw: pointer to the HW struct
+ * @blk: classification stage
+ * @prof_id: unique ID to identify this flow profile
+ */
+static struct ice_flow_prof *
+ice_flow_find_prof_id(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
+{
+	struct ice_flow_prof *p;
+
+	list_for_each_entry(p, &hw->fl_profs[blk], l_entry)
+		if (p->id == prof_id)
+			return p;
+
+	return NULL;
+}
+
 /**
  * ice_flow_add_prof_sync - Add a flow profile for packet segments and fields
  * @hw: pointer to the HW struct
@@ -450,6 +521,31 @@ ice_flow_add_prof_sync(struct ice_hw *hw, enum ice_block blk,
 	return status;
 }
 
+/**
+ * ice_flow_rem_prof_sync - remove a flow profile
+ * @hw: pointer to the hardware structure
+ * @blk: classification stage
+ * @prof: pointer to flow profile to remove
+ *
+ * Assumption: the caller has acquired the lock to the profile list
+ */
+static enum ice_status
+ice_flow_rem_prof_sync(struct ice_hw *hw, enum ice_block blk,
+		       struct ice_flow_prof *prof)
+{
+	enum ice_status status;
+
+	/* Remove all hardware profiles associated with this flow profile */
+	status = ice_rem_prof(hw, blk, prof->id);
+	if (!status) {
+		list_del(&prof->l_entry);
+		mutex_destroy(&prof->entries_lock);
+		devm_kfree(ice_hw_to_dev(hw), prof);
+	}
+
+	return status;
+}
+
 /**
  * ice_flow_assoc_prof - associate a VSI with a flow profile
  * @hw: pointer to the hardware structure
@@ -482,6 +578,38 @@ ice_flow_assoc_prof(struct ice_hw *hw, enum ice_block blk,
 	return status;
 }
 
+/**
+ * ice_flow_disassoc_prof - disassociate a VSI from a flow profile
+ * @hw: pointer to the hardware structure
+ * @blk: classification stage
+ * @prof: pointer to flow profile
+ * @vsi_handle: software VSI handle
+ *
+ * Assumption: the caller has acquired the lock to the profile list
+ * and the software VSI handle has been validated
+ */
+static enum ice_status
+ice_flow_disassoc_prof(struct ice_hw *hw, enum ice_block blk,
+		       struct ice_flow_prof *prof, u16 vsi_handle)
+{
+	enum ice_status status = 0;
+
+	if (test_bit(vsi_handle, prof->vsis)) {
+		status = ice_rem_prof_id_flow(hw, blk,
+					      ice_get_hw_vsi_num(hw,
+								 vsi_handle),
+					      prof->id);
+		if (!status)
+			clear_bit(vsi_handle, prof->vsis);
+		else
+			ice_debug(hw, ICE_DBG_FLOW,
+				  "HW profile remove failed, %d\n",
+				  status);
+	}
+
+	return status;
+}
+
 /**
  * ice_flow_add_prof - Add a flow profile for packet segments and matched fields
  * @hw: pointer to the HW struct
@@ -524,6 +652,35 @@ ice_flow_add_prof(struct ice_hw *hw, enum ice_block blk, enum ice_flow_dir dir,
 	return status;
 }
 
+/**
+ * ice_flow_rem_prof - Remove a flow profile and all entries associated with it
+ * @hw: pointer to the HW struct
+ * @blk: the block for which the flow profile is to be removed
+ * @prof_id: unique ID of the flow profile to be removed
+ */
+static enum ice_status
+ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
+{
+	struct ice_flow_prof *prof;
+	enum ice_status status;
+
+	mutex_lock(&hw->fl_profs_locks[blk]);
+
+	prof = ice_flow_find_prof_id(hw, blk, prof_id);
+	if (!prof) {
+		status = ICE_ERR_DOES_NOT_EXIST;
+		goto out;
+	}
+
+	/* prof becomes invalid after the call */
+	status = ice_flow_rem_prof_sync(hw, blk, prof);
+
+out:
+	mutex_unlock(&hw->fl_profs_locks[blk]);
+
+	return status;
+}
+
 /**
  * ice_flow_set_fld_ext - specifies locations of field from entry's input buffer
  * @seg: packet segment the field being set belongs to
@@ -645,6 +802,132 @@ ice_flow_set_rss_seg_info(struct ice_flow_seg_info *segs, u64 hash_fields,
 	return 0;
 }
 
+/**
+ * ice_rem_vsi_rss_list - remove VSI from RSS list
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: software VSI handle
+ *
+ * Remove the VSI from all RSS configurations in the list.
+ */
+void ice_rem_vsi_rss_list(struct ice_hw *hw, u16 vsi_handle)
+{
+	struct ice_rss_cfg *r, *tmp;
+
+	if (list_empty(&hw->rss_list_head))
+		return;
+
+	mutex_lock(&hw->rss_locks);
+	list_for_each_entry_safe(r, tmp, &hw->rss_list_head, l_entry)
+		if (test_and_clear_bit(vsi_handle, r->vsis))
+			if (bitmap_empty(r->vsis, ICE_MAX_VSI)) {
+				list_del(&r->l_entry);
+				devm_kfree(ice_hw_to_dev(hw), r);
+			}
+	mutex_unlock(&hw->rss_locks);
+}
+
+/**
+ * ice_rem_vsi_rss_cfg - remove RSS configurations associated with VSI
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: software VSI handle
+ *
+ * This function will iterate through all flow profiles and disassociate
+ * the VSI from that profile. If the flow profile has no VSIs it will
+ * be removed.
+ */
+enum ice_status ice_rem_vsi_rss_cfg(struct ice_hw *hw, u16 vsi_handle)
+{
+	const enum ice_block blk = ICE_BLK_RSS;
+	struct ice_flow_prof *p, *t;
+	enum ice_status status = 0;
+
+	if (!ice_is_vsi_valid(hw, vsi_handle))
+		return ICE_ERR_PARAM;
+
+	if (list_empty(&hw->fl_profs[blk]))
+		return 0;
+
+	mutex_lock(&hw->fl_profs_locks[blk]);
+	list_for_each_entry_safe(p, t, &hw->fl_profs[blk], l_entry)
+		if (test_bit(vsi_handle, p->vsis)) {
+			status = ice_flow_disassoc_prof(hw, blk, p, vsi_handle);
+			if (status)
+				break;
+
+			if (bitmap_empty(p->vsis, ICE_MAX_VSI)) {
+				status = ice_flow_rem_prof_sync(hw, blk, p);
+				if (status)
+					break;
+			}
+		}
+	mutex_unlock(&hw->fl_profs_locks[blk]);
+
+	return status;
+}
+
+/**
+ * ice_rem_rss_list - remove RSS configuration from list
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: software VSI handle
+ * @prof: pointer to flow profile
+ *
+ * Assumption: lock has already been acquired for RSS list
+ */
+static void
+ice_rem_rss_list(struct ice_hw *hw, u16 vsi_handle, struct ice_flow_prof *prof)
+{
+	struct ice_rss_cfg *r, *tmp;
+
+	/* Search for RSS hash fields associated to the VSI that match the
+	 * hash configurations associated to the flow profile. If found
+	 * remove from the RSS entry list of the VSI context and delete entry.
+	 */
+	list_for_each_entry_safe(r, tmp, &hw->rss_list_head, l_entry)
+		if (r->hashed_flds == prof->segs[prof->segs_cnt - 1].match &&
+		    r->packet_hdr == prof->segs[prof->segs_cnt - 1].hdrs) {
+			clear_bit(vsi_handle, r->vsis);
+			if (bitmap_empty(r->vsis, ICE_MAX_VSI)) {
+				list_del(&r->l_entry);
+				devm_kfree(ice_hw_to_dev(hw), r);
+			}
+			return;
+		}
+}
+
+/**
+ * ice_add_rss_list - add RSS configuration to list
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: software VSI handle
+ * @prof: pointer to flow profile
+ *
+ * Assumption: lock has already been acquired for RSS list
+ */
+static enum ice_status
+ice_add_rss_list(struct ice_hw *hw, u16 vsi_handle, struct ice_flow_prof *prof)
+{
+	struct ice_rss_cfg *r, *rss_cfg;
+
+	list_for_each_entry(r, &hw->rss_list_head, l_entry)
+		if (r->hashed_flds == prof->segs[prof->segs_cnt - 1].match &&
+		    r->packet_hdr == prof->segs[prof->segs_cnt - 1].hdrs) {
+			set_bit(vsi_handle, r->vsis);
+			return 0;
+		}
+
+	rss_cfg = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*rss_cfg),
+			       GFP_KERNEL);
+	if (!rss_cfg)
+		return ICE_ERR_NO_MEMORY;
+
+	rss_cfg->hashed_flds = prof->segs[prof->segs_cnt - 1].match;
+	rss_cfg->packet_hdr = prof->segs[prof->segs_cnt - 1].hdrs;
+	set_bit(vsi_handle, rss_cfg->vsis);
+
+	list_add_tail(&rss_cfg->l_entry, &hw->rss_list_head);
+
+	return 0;
+}
+
 #define ICE_FLOW_PROF_HASH_S	0
 #define ICE_FLOW_PROF_HASH_M	(0xFFFFFFFFULL << ICE_FLOW_PROF_HASH_S)
 #define ICE_FLOW_PROF_HDR_S	32
@@ -696,6 +979,52 @@ ice_add_rss_cfg_sync(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
 	if (status)
 		goto exit;
 
+	/* Search for a flow profile that has matching headers, hash fields
+	 * and has the input VSI associated to it. If found, no further
+	 * operations required and exit.
+	 */
+	prof = ice_flow_find_prof_conds(hw, blk, ICE_FLOW_RX, segs, segs_cnt,
+					vsi_handle,
+					ICE_FLOW_FIND_PROF_CHK_FLDS |
+					ICE_FLOW_FIND_PROF_CHK_VSI);
+	if (prof)
+		goto exit;
+
+	/* Check if a flow profile exists with the same protocol headers and
+	 * associated with the input VSI. If so disassociate the VSI from
+	 * this profile. The VSI will be added to a new profile created with
+	 * the protocol header and new hash field configuration.
+	 */
+	prof = ice_flow_find_prof_conds(hw, blk, ICE_FLOW_RX, segs, segs_cnt,
+					vsi_handle, ICE_FLOW_FIND_PROF_CHK_VSI);
+	if (prof) {
+		status = ice_flow_disassoc_prof(hw, blk, prof, vsi_handle);
+		if (!status)
+			ice_rem_rss_list(hw, vsi_handle, prof);
+		else
+			goto exit;
+
+		/* Remove profile if it has no VSIs associated */
+		if (bitmap_empty(prof->vsis, ICE_MAX_VSI)) {
+			status = ice_flow_rem_prof(hw, blk, prof->id);
+			if (status)
+				goto exit;
+		}
+	}
+
+	/* Search for a profile that has same match fields only. If this
+	 * exists then associate the VSI to this profile.
+	 */
+	prof = ice_flow_find_prof_conds(hw, blk, ICE_FLOW_RX, segs, segs_cnt,
+					vsi_handle,
+					ICE_FLOW_FIND_PROF_CHK_FLDS);
+	if (prof) {
+		status = ice_flow_assoc_prof(hw, blk, prof, vsi_handle);
+		if (!status)
+			status = ice_add_rss_list(hw, vsi_handle, prof);
+		goto exit;
+	}
+
 	/* Create a new flow profile with generated profile and packet
 	 * segment information.
 	 */
@@ -708,6 +1037,15 @@ ice_add_rss_cfg_sync(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
 		goto exit;
 
 	status = ice_flow_assoc_prof(hw, blk, prof, vsi_handle);
+	/* If association to a new flow profile failed then this profile can
+	 * be removed.
+	 */
+	if (status) {
+		ice_flow_rem_prof(hw, blk, prof->id);
+		goto exit;
+	}
+
+	status = ice_add_rss_list(hw, vsi_handle, prof);
 
 exit:
 	kfree(segs);
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 05b0dab4793c..38669b077209 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -4,6 +4,7 @@
 #ifndef _ICE_FLOW_H_
 #define _ICE_FLOW_H_
 
+#define ICE_FLOW_ENTRY_HANDLE_INVAL	0
 #define ICE_FLOW_FLD_OFF_INVAL		0xffff
 
 /* Generate flow hash field from flow field type(s) */
@@ -60,6 +61,12 @@ enum ice_flow_dir {
 	ICE_FLOW_RX		= 0x02,
 };
 
+enum ice_flow_priority {
+	ICE_FLOW_PRIO_LOW,
+	ICE_FLOW_PRIO_NORMAL,
+	ICE_FLOW_PRIO_HIGH
+};
+
 #define ICE_FLOW_SEG_MAX		2
 #define ICE_FLOW_FV_EXTRACT_SZ		2
 
@@ -130,7 +137,10 @@ struct ice_rss_cfg {
 	u32 packet_hdr;
 };
 
+enum ice_status ice_flow_rem_entry(struct ice_hw *hw, u64 entry_h);
+void ice_rem_vsi_rss_list(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status ice_replay_rss_cfg(struct ice_hw *hw, u16 vsi_handle);
+enum ice_status ice_rem_vsi_rss_cfg(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status
 ice_add_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
 		u32 addl_hdrs);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index dd230c6664ee..caa3edd5d3d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -494,7 +494,28 @@ bool ice_is_safe_mode(struct ice_pf *pf)
 }
 
 /**
- * ice_rss_clean - Delete RSS related VSI structures that hold user inputs
+ * ice_vsi_clean_rss_flow_fld - Delete RSS configuration
+ * @vsi: the VSI being cleaned up
+ *
+ * This function deletes RSS input set for all flows that were configured
+ * for this VSI
+ */
+static void ice_vsi_clean_rss_flow_fld(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	enum ice_status status;
+
+	if (ice_is_safe_mode(pf))
+		return;
+
+	status = ice_rem_vsi_rss_cfg(&pf->hw, vsi->idx);
+	if (status)
+		dev_dbg(ice_pf_to_dev(pf), "ice_rem_vsi_rss_cfg failed for vsi = %d, error = %d\n",
+			vsi->vsi_num, status);
+}
+
+/**
+ * ice_rss_clean - Delete RSS related VSI structures and configuration
  * @vsi: the VSI being removed
  */
 static void ice_rss_clean(struct ice_vsi *vsi)
@@ -508,6 +529,11 @@ static void ice_rss_clean(struct ice_vsi *vsi)
 		devm_kfree(dev, vsi->rss_hkey_user);
 	if (vsi->rss_lut_user)
 		devm_kfree(dev, vsi->rss_lut_user);
+
+	ice_vsi_clean_rss_flow_fld(vsi);
+	/* remove RSS replay list */
+	if (!ice_is_safe_mode(pf))
+		ice_rem_vsi_rss_list(&pf->hw, vsi->idx);
 }
 
 /**
-- 
2.24.1

