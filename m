Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09072A3676
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgKBWYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:24:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:16120 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgKBWYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:24:19 -0500
IronPort-SDR: b8vcZjcWsF2xP81QemsoTGJrs/MwMFpY73v6hpN1xj/Xc6ecW3479SoTlu5eVTlS2EUImn82ne
 mmnCFKNiOP0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="253670972"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="253670972"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 14:24:19 -0800
IronPort-SDR: G0GetADBPa6N42DJCoMlFXbV3SDJbh9tmLHIwj9YnpX2R7vQ3mGV4tgbPhU24qPFZL9IyHkzwd
 TyTDwKWqHwqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="305591781"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2020 14:24:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Real Valiquette <real.valiquette@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Chinh Cao <chinh.t.cao@intel.com>,
        Brijesh Behera <brijeshx.behera@intel.com>
Subject: [net-next 07/15] ice: program ACL entry
Date:   Mon,  2 Nov 2020 14:23:30 -0800
Message-Id: <20201102222338.1442081-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Real Valiquette <real.valiquette@intel.com>

Complete the filter programming process; set the flow entry and action into
the scenario and write it to hardware. Configure the VSI for ACL filters.

Co-developed-by: Chinh Cao <chinh.t.cao@intel.com>
Signed-off-by: Chinh Cao <chinh.t.cao@intel.com>
Signed-off-by: Real Valiquette <real.valiquette@intel.com>
Co-developed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Brijesh Behera <brijeshx.behera@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   3 +
 drivers/net/ethernet/intel/ice/ice_acl.c      |  48 ++-
 drivers/net/ethernet/intel/ice/ice_acl.h      |  23 +
 drivers/net/ethernet/intel/ice/ice_acl_ctrl.c | 260 +++++++++++
 drivers/net/ethernet/intel/ice/ice_acl_main.c |   4 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   2 +
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  58 ++-
 drivers/net/ethernet/intel/ice/ice_flow.c     | 406 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_flow.h     |   3 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  10 +-
 10 files changed, 805 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 31eea8bd92f2..fa24826c5af7 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -620,6 +620,9 @@ int ice_fdir_create_dflt_rules(struct ice_pf *pf);
 enum ice_fltr_ptype ice_ethtool_flow_to_fltr(int eth);
 int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
 			  struct ice_rq_event_info *event);
+int
+ice_ntuple_update_list_entry(struct ice_pf *pf, struct ice_fdir_fltr *input,
+			     int fltr_idx);
 int ice_open(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_acl.c b/drivers/net/ethernet/intel/ice/ice_acl.c
index 767cccc3ba67..a897dd9bfcde 100644
--- a/drivers/net/ethernet/intel/ice/ice_acl.c
+++ b/drivers/net/ethernet/intel/ice/ice_acl.c
@@ -171,7 +171,8 @@ ice_acl_prof_aq_send(struct ice_hw *hw, u16 opc, u8 prof_id,
 
 	ice_fill_dflt_direct_cmd_desc(&desc, opc);
 	desc.params.profile.profile_id = prof_id;
-	if (opc == ice_aqc_opc_program_acl_prof_extraction)
+	if (opc == ice_aqc_opc_program_acl_prof_extraction ||
+	    opc == ice_aqc_opc_program_acl_prof_ranges)
 		desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
 	return ice_aq_send_cmd(hw, &desc, buf, sizeof(*buf), cd);
 }
@@ -323,6 +324,51 @@ ice_aq_dealloc_acl_cntrs(struct ice_hw *hw, struct ice_acl_cntrs *cntrs,
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
 }
 
+/**
+ * ice_prog_acl_prof_ranges - program ACL profile ranges
+ * @hw: pointer to the HW struct
+ * @prof_id: programmed or updated profile ID
+ * @buf: pointer to input buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Program ACL profile ranges (indirect 0x0C1E)
+ */
+enum ice_status
+ice_prog_acl_prof_ranges(struct ice_hw *hw, u8 prof_id,
+			 struct ice_aqc_acl_profile_ranges *buf,
+			 struct ice_sq_cd *cd)
+{
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc,
+				      ice_aqc_opc_program_acl_prof_ranges);
+	desc.params.profile.profile_id = prof_id;
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+	return ice_aq_send_cmd(hw, &desc, buf, sizeof(*buf), cd);
+}
+
+/**
+ * ice_query_acl_prof_ranges - query ACL profile ranges
+ * @hw: pointer to the HW struct
+ * @prof_id: programmed or updated profile ID
+ * @buf: pointer to response buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Query ACL profile ranges (indirect 0x0C22)
+ */
+enum ice_status
+ice_query_acl_prof_ranges(struct ice_hw *hw, u8 prof_id,
+			  struct ice_aqc_acl_profile_ranges *buf,
+			  struct ice_sq_cd *cd)
+{
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc,
+				      ice_aqc_opc_query_acl_prof_ranges);
+	desc.params.profile.profile_id = prof_id;
+	return ice_aq_send_cmd(hw, &desc, buf, sizeof(*buf), cd);
+}
+
 /**
  * ice_aq_alloc_acl_scen - allocate ACL scenario
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_acl.h b/drivers/net/ethernet/intel/ice/ice_acl.h
index 8235d16bd162..b0bb261b28b7 100644
--- a/drivers/net/ethernet/intel/ice/ice_acl.h
+++ b/drivers/net/ethernet/intel/ice/ice_acl.h
@@ -44,6 +44,7 @@ struct ice_acl_tbl {
 	u16 id;
 };
 
+#define ICE_MAX_ACL_TCAM_ENTRY (ICE_AQC_ACL_TCAM_DEPTH * ICE_AQC_ACL_SLICES)
 enum ice_acl_entry_prio {
 	ICE_ACL_PRIO_LOW = 0,
 	ICE_ACL_PRIO_NORMAL,
@@ -66,6 +67,11 @@ struct ice_acl_scen {
 	 * participate in this scenario
 	 */
 	DECLARE_BITMAP(act_mem_bitmap, ICE_AQC_MAX_ACTION_MEMORIES);
+
+	/* If nth bit of entry_bitmap is set, then nth entry will
+	 * be available in this scenario
+	 */
+	DECLARE_BITMAP(entry_bitmap, ICE_MAX_ACL_TCAM_ENTRY);
 	u16 first_idx[ICE_ACL_MAX_PRIO];
 	u16 last_idx[ICE_ACL_MAX_PRIO];
 
@@ -151,6 +157,14 @@ enum ice_status
 ice_aq_dealloc_acl_cntrs(struct ice_hw *hw, struct ice_acl_cntrs *cntrs,
 			 struct ice_sq_cd *cd);
 enum ice_status
+ice_prog_acl_prof_ranges(struct ice_hw *hw, u8 prof_id,
+			 struct ice_aqc_acl_profile_ranges *buf,
+			 struct ice_sq_cd *cd);
+enum ice_status
+ice_query_acl_prof_ranges(struct ice_hw *hw, u8 prof_id,
+			  struct ice_aqc_acl_profile_ranges *buf,
+			  struct ice_sq_cd *cd);
+enum ice_status
 ice_aq_alloc_acl_scen(struct ice_hw *hw, u16 *scen_id,
 		      struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd);
 enum ice_status
@@ -161,5 +175,14 @@ ice_aq_update_acl_scen(struct ice_hw *hw, u16 scen_id,
 enum ice_status
 ice_aq_query_acl_scen(struct ice_hw *hw, u16 scen_id,
 		      struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd);
+enum ice_status
+ice_acl_add_entry(struct ice_hw *hw, struct ice_acl_scen *scen,
+		  enum ice_acl_entry_prio prio, u8 *keys, u8 *inverts,
+		  struct ice_acl_act_entry *acts, u8 acts_cnt, u16 *entry_idx);
+enum ice_status
+ice_acl_prog_act(struct ice_hw *hw, struct ice_acl_scen *scen,
+		 struct ice_acl_act_entry *acts, u8 acts_cnt, u16 entry_idx);
+enum ice_status
+ice_acl_rem_entry(struct ice_hw *hw, struct ice_acl_scen *scen, u16 entry_idx);
 
 #endif /* _ICE_ACL_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c b/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
index 84a96ccf40d5..b345c0d5b710 100644
--- a/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
+++ b/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
@@ -6,6 +6,11 @@
 /* Determine the TCAM index of entry 'e' within the ACL table */
 #define ICE_ACL_TBL_TCAM_IDX(e) ((e) / ICE_AQC_ACL_TCAM_DEPTH)
 
+/* Determine the entry index within the TCAM */
+#define ICE_ACL_TBL_TCAM_ENTRY_IDX(e) ((e) % ICE_AQC_ACL_TCAM_DEPTH)
+
+#define ICE_ACL_SCEN_ENTRY_INVAL 0xFFFF
+
 /**
  * ice_acl_init_entry
  * @scen: pointer to the scenario struct
@@ -29,6 +34,56 @@ static void ice_acl_init_entry(struct ice_acl_scen *scen)
 	scen->last_idx[ICE_ACL_PRIO_HIGH] = scen->num_entry / 4 - 1;
 }
 
+/**
+ * ice_acl_scen_assign_entry_idx
+ * @scen: pointer to the scenario struct
+ * @prio: the priority of the flow entry being allocated
+ *
+ * To find the index of an available entry in scenario
+ *
+ * Returns ICE_ACL_SCEN_ENTRY_INVAL if fails
+ * Returns index on success
+ */
+static u16
+ice_acl_scen_assign_entry_idx(struct ice_acl_scen *scen,
+			      enum ice_acl_entry_prio prio)
+{
+	u16 first_idx, last_idx, i;
+	s8 step;
+
+	if (prio >= ICE_ACL_MAX_PRIO)
+		return ICE_ACL_SCEN_ENTRY_INVAL;
+
+	first_idx = scen->first_idx[prio];
+	last_idx = scen->last_idx[prio];
+	step = first_idx <= last_idx ? 1 : -1;
+
+	for (i = first_idx; i != last_idx + step; i += step)
+		if (!test_and_set_bit(i, scen->entry_bitmap))
+			return i;
+
+	return ICE_ACL_SCEN_ENTRY_INVAL;
+}
+
+/**
+ * ice_acl_scen_free_entry_idx
+ * @scen: pointer to the scenario struct
+ * @idx: the index of the flow entry being de-allocated
+ *
+ * To mark an entry available in scenario
+ */
+static enum ice_status
+ice_acl_scen_free_entry_idx(struct ice_acl_scen *scen, u16 idx)
+{
+	if (idx >= scen->num_entry)
+		return ICE_ERR_MAX_LIMIT;
+
+	if (!test_and_clear_bit(idx, scen->entry_bitmap))
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	return 0;
+}
+
 /**
  * ice_acl_tbl_calc_end_idx
  * @start: start index of the TCAM entry of this partition
@@ -883,3 +938,208 @@ enum ice_status ice_acl_destroy_tbl(struct ice_hw *hw)
 
 	return 0;
 }
+
+/**
+ * ice_acl_add_entry - Add a flow entry to an ACL scenario
+ * @hw: pointer to the HW struct
+ * @scen: scenario to add the entry to
+ * @prio: priority level of the entry being added
+ * @keys: buffer of the value of the key to be programmed to the ACL entry
+ * @inverts: buffer of the value of the key inverts to be programmed
+ * @acts: pointer to a buffer containing formatted actions
+ * @acts_cnt: indicates the number of actions stored in "acts"
+ * @entry_idx: returned scenario relative index of the added flow entry
+ *
+ * Given an ACL table and a scenario, to add the specified key and key invert
+ * to an available entry in the specified scenario.
+ * The "keys" and "inverts" buffers must be of the size which is the same as
+ * the scenario's width
+ */
+enum ice_status
+ice_acl_add_entry(struct ice_hw *hw, struct ice_acl_scen *scen,
+		  enum ice_acl_entry_prio prio, u8 *keys, u8 *inverts,
+		  struct ice_acl_act_entry *acts, u8 acts_cnt, u16 *entry_idx)
+{
+	u8 i, entry_tcam, num_cscd, offset;
+	struct ice_aqc_acl_data buf;
+	enum ice_status status = 0;
+	u16 idx;
+
+	if (!scen)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	*entry_idx = ice_acl_scen_assign_entry_idx(scen, prio);
+	if (*entry_idx >= scen->num_entry) {
+		*entry_idx = 0;
+		return ICE_ERR_MAX_LIMIT;
+	}
+
+	/* Determine number of cascaded TCAMs */
+	num_cscd = DIV_ROUND_UP(scen->width, ICE_AQC_ACL_KEY_WIDTH_BYTES);
+
+	entry_tcam = ICE_ACL_TBL_TCAM_IDX(scen->start);
+	idx = ICE_ACL_TBL_TCAM_ENTRY_IDX(scen->start + *entry_idx);
+
+	memset(&buf, 0, sizeof(buf));
+	for (i = 0; i < num_cscd; i++) {
+		/* If the key spans more than one TCAM in the case of cascaded
+		 * TCAMs, the key and key inverts need to be properly split
+		 * among TCAMs.E.g.bytes 0 - 4 go to an index in the first TCAM
+		 * and bytes 5 - 9 go to the same index in the next TCAM, etc.
+		 * If the entry spans more than one TCAM in a cascaded TCAM
+		 * mode, the programming of the entries in the TCAMs must be in
+		 * reversed order - the TCAM entry of the rightmost TCAM should
+		 * be programmed first; the TCAM entry of the leftmost TCAM
+		 * should be programmed last.
+		 */
+		offset = num_cscd - i - 1;
+		memcpy(&buf.entry_key.val,
+		       &keys[offset * sizeof(buf.entry_key.val)],
+		       sizeof(buf.entry_key.val));
+		memcpy(&buf.entry_key_invert.val,
+		       &inverts[offset * sizeof(buf.entry_key_invert.val)],
+		       sizeof(buf.entry_key_invert.val));
+		status = ice_aq_program_acl_entry(hw, entry_tcam + offset, idx,
+						  &buf, NULL);
+		if (status) {
+			ice_debug(hw, ICE_DBG_ACL, "aq program acl entry failed status: %d\n",
+				  status);
+			goto out;
+		}
+	}
+
+	/* Program the action memory */
+	status = ice_acl_prog_act(hw, scen, acts, acts_cnt, *entry_idx);
+
+out:
+	if (status) {
+		ice_acl_rem_entry(hw, scen, *entry_idx);
+		*entry_idx = 0;
+	}
+
+	return status;
+}
+
+/**
+ * ice_acl_prog_act - Program a scenario's action memory
+ * @hw: pointer to the HW struct
+ * @scen: scenario to add the entry to
+ * @acts: pointer to a buffer containing formatted actions
+ * @acts_cnt: indicates the number of actions stored in "acts"
+ * @entry_idx: scenario relative index of the added flow entry
+ *
+ * Program a scenario's action memory
+ */
+enum ice_status
+ice_acl_prog_act(struct ice_hw *hw, struct ice_acl_scen *scen,
+		 struct ice_acl_act_entry *acts, u8 acts_cnt,
+		 u16 entry_idx)
+{
+	u8 entry_tcam, num_cscd, i, actx_idx = 0;
+	struct ice_aqc_actpair act_buf;
+	enum ice_status status = 0;
+	u16 idx;
+
+	if (entry_idx >= scen->num_entry)
+		return ICE_ERR_MAX_LIMIT;
+
+	memset(&act_buf, 0, sizeof(act_buf));
+
+	/* Determine number of cascaded TCAMs */
+	num_cscd = DIV_ROUND_UP(scen->width, ICE_AQC_ACL_KEY_WIDTH_BYTES);
+
+	entry_tcam = ICE_ACL_TBL_TCAM_IDX(scen->start);
+	idx = ICE_ACL_TBL_TCAM_ENTRY_IDX(scen->start + entry_idx);
+
+	for_each_set_bit(i, scen->act_mem_bitmap, ICE_AQC_MAX_ACTION_MEMORIES) {
+		struct ice_acl_act_mem *mem = &hw->acl_tbl->act_mems[i];
+
+		if (actx_idx >= acts_cnt)
+			break;
+		if (mem->member_of_tcam >= entry_tcam &&
+		    mem->member_of_tcam < entry_tcam + num_cscd) {
+			memcpy(&act_buf.act[0], &acts[actx_idx],
+			       sizeof(struct ice_acl_act_entry));
+
+			if (++actx_idx < acts_cnt) {
+				memcpy(&act_buf.act[1], &acts[actx_idx],
+				       sizeof(struct ice_acl_act_entry));
+			}
+
+			status = ice_aq_program_actpair(hw, i, idx, &act_buf,
+							NULL);
+			if (status) {
+				ice_debug(hw, ICE_DBG_ACL, "program actpair failed status: %d\n",
+					  status);
+				break;
+			}
+			actx_idx++;
+		}
+	}
+
+	if (!status && actx_idx < acts_cnt)
+		status = ICE_ERR_MAX_LIMIT;
+
+	return status;
+}
+
+/**
+ * ice_acl_rem_entry - Remove a flow entry from an ACL scenario
+ * @hw: pointer to the HW struct
+ * @scen: scenario to remove the entry from
+ * @entry_idx: the scenario-relative index of the flow entry being removed
+ */
+enum ice_status
+ice_acl_rem_entry(struct ice_hw *hw, struct ice_acl_scen *scen, u16 entry_idx)
+{
+	struct ice_aqc_actpair act_buf;
+	struct ice_aqc_acl_data buf;
+	u8 entry_tcam, num_cscd, i;
+	enum ice_status status = 0;
+	u16 idx;
+
+	if (!scen)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	if (entry_idx >= scen->num_entry)
+		return ICE_ERR_MAX_LIMIT;
+
+	if (!test_bit(entry_idx, scen->entry_bitmap))
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	/* Determine number of cascaded TCAMs */
+	num_cscd = DIV_ROUND_UP(scen->width, ICE_AQC_ACL_KEY_WIDTH_BYTES);
+
+	entry_tcam = ICE_ACL_TBL_TCAM_IDX(scen->start);
+	idx = ICE_ACL_TBL_TCAM_ENTRY_IDX(scen->start + entry_idx);
+
+	/* invalidate the flow entry */
+	memset(&buf, 0, sizeof(buf));
+	for (i = 0; i < num_cscd; i++) {
+		status = ice_aq_program_acl_entry(hw, entry_tcam + i, idx, &buf,
+						  NULL);
+		if (status)
+			ice_debug(hw, ICE_DBG_ACL, "AQ program ACL entry failed status: %d\n",
+				  status);
+	}
+
+	memset(&act_buf, 0, sizeof(act_buf));
+
+	for_each_set_bit(i, scen->act_mem_bitmap, ICE_AQC_MAX_ACTION_MEMORIES) {
+		struct ice_acl_act_mem *mem = &hw->acl_tbl->act_mems[i];
+
+		if (mem->member_of_tcam >= entry_tcam &&
+		    mem->member_of_tcam < entry_tcam + num_cscd) {
+			/* Invalidate allocated action pairs */
+			status = ice_aq_program_actpair(hw, i, idx, &act_buf,
+							NULL);
+			if (status)
+				ice_debug(hw, ICE_DBG_ACL, "program actpair failed status: %d\n",
+					  status);
+		}
+	}
+
+	ice_acl_scen_free_entry_idx(scen, entry_idx);
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_acl_main.c b/drivers/net/ethernet/intel/ice/ice_acl_main.c
index 3b56194ab3fc..c5d6c26ddbb1 100644
--- a/drivers/net/ethernet/intel/ice/ice_acl_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_acl_main.c
@@ -315,6 +315,10 @@ int ice_acl_add_rule_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 		hw_prof->entry_h[hw_prof->cnt++][0] = entry_h;
 	}
 
+	input->acl_fltr = true;
+	/* input struct is added to the HW filter list */
+	ice_ntuple_update_list_entry(pf, input, fsp->location);
+
 	return 0;
 
 free_input:
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 5449c5f6e10c..ddaf8df23480 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -2415,8 +2415,10 @@ enum ice_adminq_opc {
 	ice_aqc_opc_update_acl_scen			= 0x0C1B,
 	ice_aqc_opc_program_acl_actpair			= 0x0C1C,
 	ice_aqc_opc_program_acl_prof_extraction		= 0x0C1D,
+	ice_aqc_opc_program_acl_prof_ranges		= 0x0C1E,
 	ice_aqc_opc_program_acl_entry			= 0x0C20,
 	ice_aqc_opc_query_acl_prof			= 0x0C21,
+	ice_aqc_opc_query_acl_prof_ranges		= 0x0C22,
 	ice_aqc_opc_query_acl_scen			= 0x0C23,
 
 	/* Tx queue handling commands/events */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index dd495f6a4adf..98261e7e7b85 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -1482,6 +1482,22 @@ void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena)
 	mutex_unlock(&hw->fdir_fltr_lock);
 }
 
+/**
+ * ice_del_acl_ethtool - Deletes an ACL rule entry.
+ * @hw: pointer to HW instance
+ * @fltr: filter structure
+ *
+ * returns 0 on success and negative value on error
+ */
+static int
+ice_del_acl_ethtool(struct ice_hw *hw, struct ice_fdir_fltr *fltr)
+{
+	u64 entry;
+
+	entry = ice_flow_find_entry(hw, ICE_BLK_ACL, fltr->fltr_id);
+	return ice_status_to_errno(ice_flow_rem_entry(hw, ICE_BLK_ACL, entry));
+}
+
 /**
  * ice_fdir_do_rem_flow - delete flow and possibly add perfect flow
  * @pf: PF structure
@@ -1515,7 +1531,7 @@ ice_fdir_do_rem_flow(struct ice_pf *pf, enum ice_fltr_ptype flow_type)
  *
  * returns 0 on success and negative on errors
  */
-static int
+int
 ice_ntuple_update_list_entry(struct ice_pf *pf, struct ice_fdir_fltr *input,
 			     int fltr_idx)
 {
@@ -1529,18 +1545,40 @@ ice_ntuple_update_list_entry(struct ice_pf *pf, struct ice_fdir_fltr *input,
 
 	old_fltr = ice_fdir_find_fltr_by_idx(hw, fltr_idx);
 	if (old_fltr) {
-		err = ice_fdir_write_all_fltr(pf, old_fltr, false);
-		if (err)
-			return err;
-		ice_fdir_update_cntrs(hw, old_fltr->flow_type,
-				      false, false);
-		if (!input && !hw->fdir_fltr_cnt[old_fltr->flow_type])
-			/* we just deleted the last filter of flow_type so we
-			 * should also delete the HW filter info.
+		if (!old_fltr->acl_fltr) {
+			/* FD filter */
+			err = ice_fdir_write_all_fltr(pf, old_fltr, false);
+			if (err)
+				return err;
+		} else {
+			/* ACL filter - if the input buffer is present
+			 * then this is an update and we don't want to
+			 * delete the filter from the HW. we've already
+			 * written the change to the HW at this point, so
+			 * just update the SW structures to make sure
+			 * everything is hunky-dory. if no input then this
+			 * is a delete so we should delete the filter from
+			 * the HW and clean up our SW structures.
 			 */
+			if (!input) {
+				err = ice_del_acl_ethtool(hw, old_fltr);
+				if (err)
+					return err;
+			}
+		}
+		ice_fdir_update_cntrs(hw, old_fltr->flow_type,
+				      old_fltr->acl_fltr, false);
+		/* Also delete the HW filter info if we have just deleted the
+		 * last filter of flow_type.
+		 */
+		if (!old_fltr->acl_fltr && !input &&
+		    !hw->fdir_fltr_cnt[old_fltr->flow_type])
 			ice_fdir_do_rem_flow(pf, old_fltr->flow_type);
+		else if (old_fltr->acl_fltr && !input &&
+			 !hw->acl_fltr_cnt[old_fltr->flow_type])
+			ice_fdir_rem_flow(hw, ICE_BLK_ACL, old_fltr->flow_type);
 		list_del(&old_fltr->fltr_node);
-		devm_kfree(ice_hw_to_dev(hw), old_fltr);
+		devm_kfree(ice_pf_to_dev(pf), old_fltr);
 	}
 	if (!input)
 		return err;
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 7ea94a627c5d..bff0ca02f8c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -1002,6 +1002,16 @@ ice_flow_rem_entry_sync(struct ice_hw *hw, enum ice_block blk,
 		return ICE_ERR_BAD_PTR;
 
 	if (blk == ICE_BLK_ACL) {
+		enum ice_status status;
+
+		if (!entry->prof)
+			return ICE_ERR_BAD_PTR;
+
+		status = ice_acl_rem_entry(hw, entry->prof->cfg.scen,
+					   entry->scen_entry_idx);
+		if (status)
+			return status;
+
 		/* Checks if we need to release an ACL counter. */
 		if (entry->acts_cnt && entry->acts)
 			ice_flow_acl_free_act_cntr(hw, entry->acts,
@@ -1126,10 +1136,36 @@ ice_flow_rem_prof_sync(struct ice_hw *hw, enum ice_block blk,
 	}
 
 	if (blk == ICE_BLK_ACL) {
+		struct ice_aqc_acl_profile_ranges query_rng_buf;
+		struct ice_aqc_acl_prof_generic_frmt buf;
+		u8 prof_id = 0;
+
 		/* Disassociate the scenario from the profile for the PF */
 		status = ice_flow_acl_disassoc_scen(hw, prof);
 		if (status)
 			return status;
+
+		/* Clear the range-checker if the profile ID is no longer
+		 * used by any PF
+		 */
+		status = ice_flow_acl_is_prof_in_use(hw, prof, &buf);
+		if (status && status != ICE_ERR_IN_USE) {
+			return status;
+		} else if (!status) {
+			/* Clear the range-checker value for profile ID */
+			memset(&query_rng_buf, 0,
+			       sizeof(struct ice_aqc_acl_profile_ranges));
+
+			status = ice_flow_get_hw_prof(hw, blk, prof->id,
+						      &prof_id);
+			if (status)
+				return status;
+
+			status = ice_prog_acl_prof_ranges(hw, prof_id,
+							  &query_rng_buf, NULL);
+			if (status)
+				return status;
+		}
 	}
 
 	/* Remove all hardware profiles associated with this flow profile */
@@ -1366,6 +1402,44 @@ ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
 	return status;
 }
 
+/**
+ * ice_flow_find_entry - look for a flow entry using its unique ID
+ * @hw: pointer to the HW struct
+ * @blk: classification stage
+ * @entry_id: unique ID to identify this flow entry
+ *
+ * This function looks for the flow entry with the specified unique ID in all
+ * flow profiles of the specified classification stage. If the entry is found,
+ * and it returns the handle to the flow entry. Otherwise, it returns
+ * ICE_FLOW_ENTRY_ID_INVAL.
+ */
+u64 ice_flow_find_entry(struct ice_hw *hw, enum ice_block blk, u64 entry_id)
+{
+	struct ice_flow_entry *found = NULL;
+	struct ice_flow_prof *p;
+
+	mutex_lock(&hw->fl_profs_locks[blk]);
+
+	list_for_each_entry(p, &hw->fl_profs[blk], l_entry) {
+		struct ice_flow_entry *e;
+
+		mutex_lock(&p->entries_lock);
+		list_for_each_entry(e, &p->entries, l_entry)
+			if (e->id == entry_id) {
+				found = e;
+				break;
+			}
+		mutex_unlock(&p->entries_lock);
+
+		if (found)
+			break;
+	}
+
+	mutex_unlock(&hw->fl_profs_locks[blk]);
+
+	return found ? ICE_FLOW_ENTRY_HNDL(found) : ICE_FLOW_ENTRY_HANDLE_INVAL;
+}
+
 /**
  * ice_flow_acl_check_actions - Checks the ACL rule's actions
  * @hw: pointer to the hardware structure
@@ -1701,6 +1775,333 @@ ice_flow_acl_frmt_entry(struct ice_hw *hw, struct ice_flow_prof *prof,
 
 	return status;
 }
+
+/**
+ * ice_flow_acl_find_scen_entry_cond - Find an ACL scenario entry that matches
+ *				       the compared data.
+ * @prof: pointer to flow profile
+ * @e: pointer to the comparing flow entry
+ * @do_chg_action: decide if we want to change the ACL action
+ * @do_add_entry: decide if we want to add the new ACL entry
+ * @do_rem_entry: decide if we want to remove the current ACL entry
+ *
+ * Find an ACL scenario entry that matches the compared data. In the same time,
+ * this function also figure out:
+ * a/ If we want to change the ACL action
+ * b/ If we want to add the new ACL entry
+ * c/ If we want to remove the current ACL entry
+ */
+static struct ice_flow_entry *
+ice_flow_acl_find_scen_entry_cond(struct ice_flow_prof *prof,
+				  struct ice_flow_entry *e, bool *do_chg_action,
+				  bool *do_add_entry, bool *do_rem_entry)
+{
+	struct ice_flow_entry *p, *return_entry = NULL;
+	u8 i, j;
+
+	/* Check if:
+	 * a/ There exists an entry with same matching data, but different
+	 *    priority, then we remove this existing ACL entry. Then, we
+	 *    will add the new entry to the ACL scenario.
+	 * b/ There exists an entry with same matching data, priority, and
+	 *    result action, then we do nothing
+	 * c/ There exists an entry with same matching data, priority, but
+	 *    different, action, then do only change the action's entry.
+	 * d/ Else, we add this new entry to the ACL scenario.
+	 */
+	*do_chg_action = false;
+	*do_add_entry = true;
+	*do_rem_entry = false;
+	list_for_each_entry(p, &prof->entries, l_entry) {
+		if (memcmp(p->entry, e->entry, p->entry_sz))
+			continue;
+
+		/* From this point, we have the same matching_data. */
+		*do_add_entry = false;
+		return_entry = p;
+
+		if (p->priority != e->priority) {
+			/* matching data && !priority */
+			*do_add_entry = true;
+			*do_rem_entry = true;
+			break;
+		}
+
+		/* From this point, we will have matching_data && priority */
+		if (p->acts_cnt != e->acts_cnt)
+			*do_chg_action = true;
+		for (i = 0; i < p->acts_cnt; i++) {
+			bool found_not_match = false;
+
+			for (j = 0; j < e->acts_cnt; j++)
+				if (memcmp(&p->acts[i], &e->acts[j],
+					   sizeof(struct ice_flow_action))) {
+					found_not_match = true;
+					break;
+				}
+
+			if (found_not_match) {
+				*do_chg_action = true;
+				break;
+			}
+		}
+
+		/* (do_chg_action = true) means :
+		 *    matching_data && priority && !result_action
+		 * (do_chg_action = false) means :
+		 *    matching_data && priority && result_action
+		 */
+		break;
+	}
+
+	return return_entry;
+}
+
+/**
+ * ice_flow_acl_convert_to_acl_prio - Convert to ACL priority
+ * @p: flow priority
+ */
+static enum ice_acl_entry_prio
+ice_flow_acl_convert_to_acl_prio(enum ice_flow_priority p)
+{
+	enum ice_acl_entry_prio acl_prio;
+
+	switch (p) {
+	case ICE_FLOW_PRIO_LOW:
+		acl_prio = ICE_ACL_PRIO_LOW;
+		break;
+	case ICE_FLOW_PRIO_NORMAL:
+		acl_prio = ICE_ACL_PRIO_NORMAL;
+		break;
+	case ICE_FLOW_PRIO_HIGH:
+		acl_prio = ICE_ACL_PRIO_HIGH;
+		break;
+	default:
+		acl_prio = ICE_ACL_PRIO_NORMAL;
+		break;
+	}
+
+	return acl_prio;
+}
+
+/**
+ * ice_flow_acl_union_rng_chk - Perform union operation between two
+ *                              range-range checker buffers
+ * @dst_buf: pointer to destination range checker buffer
+ * @src_buf: pointer to source range checker buffer
+ *
+ * For this function, we do the union between dst_buf and src_buf
+ * range checker buffer, and we will save the result back to dst_buf
+ */
+static enum ice_status
+ice_flow_acl_union_rng_chk(struct ice_aqc_acl_profile_ranges *dst_buf,
+			   struct ice_aqc_acl_profile_ranges *src_buf)
+{
+	u8 i, j;
+
+	if (!dst_buf || !src_buf)
+		return ICE_ERR_BAD_PTR;
+
+	for (i = 0; i < ICE_AQC_ACL_PROF_RANGES_NUM_CFG; i++) {
+		struct ice_acl_rng_data *cfg_data = NULL, *in_data;
+		bool will_populate = false;
+
+		in_data = &src_buf->checker_cfg[i];
+
+		if (!in_data->mask)
+			break;
+
+		for (j = 0; j < ICE_AQC_ACL_PROF_RANGES_NUM_CFG; j++) {
+			cfg_data = &dst_buf->checker_cfg[j];
+
+			if (!cfg_data->mask ||
+			    !memcmp(cfg_data, in_data,
+				    sizeof(struct ice_acl_rng_data))) {
+				will_populate = true;
+				break;
+			}
+		}
+
+		if (will_populate) {
+			memcpy(cfg_data, in_data,
+			       sizeof(struct ice_acl_rng_data));
+		} else {
+			/* No available slot left to program range checker */
+			return ICE_ERR_MAX_LIMIT;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ice_flow_acl_add_scen_entry_sync - Add entry to ACL scenario sync
+ * @hw: pointer to the hardware structure
+ * @prof: pointer to flow profile
+ * @entry: double pointer to the flow entry
+ *
+ * For this function, we will look at the current added entries in the
+ * corresponding ACL scenario. Then, we will perform matching logic to
+ * see if we want to add/modify/do nothing with this new entry.
+ */
+static enum ice_status
+ice_flow_acl_add_scen_entry_sync(struct ice_hw *hw, struct ice_flow_prof *prof,
+				 struct ice_flow_entry **entry)
+{
+	bool do_add_entry, do_rem_entry, do_chg_action, do_chg_rng_chk;
+	struct ice_aqc_acl_profile_ranges query_rng_buf, cfg_rng_buf;
+	struct ice_acl_act_entry *acts = NULL;
+	struct ice_flow_entry *exist;
+	enum ice_status status = 0;
+	struct ice_flow_entry *e;
+	u8 i;
+
+	if (!entry || !(*entry) || !prof)
+		return ICE_ERR_BAD_PTR;
+
+	e = *entry;
+
+	do_chg_rng_chk = false;
+	if (e->range_buf) {
+		u8 prof_id = 0;
+
+		status = ice_flow_get_hw_prof(hw, ICE_BLK_ACL, prof->id,
+					      &prof_id);
+		if (status)
+			return status;
+
+		/* Query the current range-checker value in FW */
+		status = ice_query_acl_prof_ranges(hw, prof_id, &query_rng_buf,
+						   NULL);
+		if (status)
+			return status;
+		memcpy(&cfg_rng_buf, &query_rng_buf,
+		       sizeof(struct ice_aqc_acl_profile_ranges));
+
+		/* Generate the new range-checker value */
+		status = ice_flow_acl_union_rng_chk(&cfg_rng_buf, e->range_buf);
+		if (status)
+			return status;
+
+		/* Reconfigure the range check if the buffer is changed. */
+		do_chg_rng_chk = false;
+		if (memcmp(&query_rng_buf, &cfg_rng_buf,
+			   sizeof(struct ice_aqc_acl_profile_ranges))) {
+			status = ice_prog_acl_prof_ranges(hw, prof_id,
+							  &cfg_rng_buf, NULL);
+			if (status)
+				return status;
+
+			do_chg_rng_chk = true;
+		}
+	}
+
+	/* Figure out if we want to (change the ACL action) and/or
+	 * (Add the new ACL entry) and/or (Remove the current ACL entry)
+	 */
+	exist = ice_flow_acl_find_scen_entry_cond(prof, e, &do_chg_action,
+						  &do_add_entry, &do_rem_entry);
+
+	if (do_rem_entry) {
+		status = ice_flow_rem_entry_sync(hw, ICE_BLK_ACL, exist);
+		if (status)
+			return status;
+	}
+
+	/* Prepare the result action buffer */
+	acts = kcalloc(e->entry_sz, sizeof(struct ice_acl_act_entry),
+		       GFP_KERNEL);
+	if (!acts)
+		return ICE_ERR_NO_MEMORY;
+
+	for (i = 0; i < e->acts_cnt; i++)
+		memcpy(&acts[i], &e->acts[i].data.acl_act,
+		       sizeof(struct ice_acl_act_entry));
+
+	if (do_add_entry) {
+		enum ice_acl_entry_prio prio;
+		u8 *keys, *inverts;
+		u16 entry_idx;
+
+		keys = (u8 *)e->entry;
+		inverts = keys + (e->entry_sz / 2);
+		prio = ice_flow_acl_convert_to_acl_prio(e->priority);
+
+		status = ice_acl_add_entry(hw, prof->cfg.scen, prio, keys,
+					   inverts, acts, e->acts_cnt,
+					   &entry_idx);
+		if (status)
+			goto out;
+
+		e->scen_entry_idx = entry_idx;
+		list_add(&e->l_entry, &prof->entries);
+	} else {
+		if (do_chg_action) {
+			/* For the action memory info, update the SW's copy of
+			 * exist entry with e's action memory info
+			 */
+			devm_kfree(ice_hw_to_dev(hw), exist->acts);
+			exist->acts_cnt = e->acts_cnt;
+			exist->acts = devm_kcalloc(ice_hw_to_dev(hw),
+						   exist->acts_cnt,
+						   sizeof(struct ice_flow_action),
+						   GFP_KERNEL);
+			if (!exist->acts) {
+				status = ICE_ERR_NO_MEMORY;
+				goto out;
+			}
+
+			memcpy(exist->acts, e->acts,
+			       sizeof(struct ice_flow_action) * e->acts_cnt);
+
+			status = ice_acl_prog_act(hw, prof->cfg.scen, acts,
+						  e->acts_cnt,
+						  exist->scen_entry_idx);
+			if (status)
+				goto out;
+		}
+
+		if (do_chg_rng_chk) {
+			/* In this case, we want to update the range checker
+			 * information of the exist entry
+			 */
+			status = ice_flow_acl_union_rng_chk(exist->range_buf,
+							    e->range_buf);
+			if (status)
+				goto out;
+		}
+
+		/* As we don't add the new entry to our SW DB, deallocate its
+		 * memories, and return the exist entry to the caller
+		 */
+		ice_dealloc_flow_entry(hw, e);
+		*entry = exist;
+	}
+out:
+	kfree(acts);
+
+	return status;
+}
+
+/**
+ * ice_flow_acl_add_scen_entry - Add entry to ACL scenario
+ * @hw: pointer to the hardware structure
+ * @prof: pointer to flow profile
+ * @e: double pointer to the flow entry
+ */
+static enum ice_status
+ice_flow_acl_add_scen_entry(struct ice_hw *hw, struct ice_flow_prof *prof,
+			    struct ice_flow_entry **e)
+{
+	enum ice_status status;
+
+	mutex_lock(&prof->entries_lock);
+	status = ice_flow_acl_add_scen_entry_sync(hw, prof, e);
+	mutex_unlock(&prof->entries_lock);
+
+	return status;
+}
+
 /**
  * ice_flow_add_entry - Add a flow entry
  * @hw: pointer to the HW struct
@@ -1770,6 +2171,11 @@ ice_flow_add_entry(struct ice_hw *hw, enum ice_block blk, u64 prof_id,
 						 acts_cnt);
 		if (status)
 			goto out;
+
+		status = ice_flow_acl_add_scen_entry(hw, prof, &e);
+		if (status)
+			goto out;
+
 		break;
 	default:
 		status = ICE_ERR_NOT_IMPL;
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index ba3ceaf30b93..31c690051e05 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -198,6 +198,8 @@ struct ice_flow_entry {
 	enum ice_flow_priority priority;
 	u16 vsi_handle;
 	u16 entry_sz;
+	/* Entry index in the ACL's scenario */
+	u16 scen_entry_idx;
 #define ICE_FLOW_ACL_MAX_NUM_ACT	2
 	u8 acts_cnt;
 };
@@ -260,6 +262,7 @@ ice_flow_add_prof(struct ice_hw *hw, enum ice_block blk, enum ice_flow_dir dir,
 		  struct ice_flow_prof **prof);
 enum ice_status
 ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id);
+u64 ice_flow_find_entry(struct ice_hw *hw, enum ice_block blk, u64 entry_id);
 enum ice_status
 ice_flow_add_entry(struct ice_hw *hw, enum ice_block blk, u64 prof_id,
 		   u64 entry_id, u16 vsi, enum ice_flow_priority prio,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 3df67486d42d..df38fa8a0c7c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -855,7 +855,7 @@ static void ice_set_fd_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
 	if (vsi->type != ICE_VSI_PF && vsi->type != ICE_VSI_CTRL)
 		return;
 
-	val = ICE_AQ_VSI_PROP_FLOW_DIR_VALID;
+	val = ICE_AQ_VSI_PROP_FLOW_DIR_VALID | ICE_AQ_VSI_PROP_ACL_VALID;
 	ctxt->info.valid_sections |= cpu_to_le16(val);
 	dflt_q = 0;
 	dflt_q_group = 0;
@@ -885,6 +885,14 @@ static void ice_set_fd_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
 	val |= ((dflt_q_prio << ICE_AQ_VSI_FD_DEF_PRIORITY_S) &
 		ICE_AQ_VSI_FD_DEF_PRIORITY_M);
 	ctxt->info.fd_report_opt = cpu_to_le16(val);
+
+#define ICE_ACL_RX_PROF_MISS_CNTR ((2 << ICE_AQ_VSI_ACL_DEF_RX_PROF_S) & \
+				   ICE_AQ_VSI_ACL_DEF_RX_PROF_M)
+#define ICE_ACL_RX_TBL_MISS_CNTR ((3 << ICE_AQ_VSI_ACL_DEF_RX_TABLE_S) & \
+				  ICE_AQ_VSI_ACL_DEF_RX_TABLE_M)
+
+	val = ICE_ACL_RX_PROF_MISS_CNTR | ICE_ACL_RX_TBL_MISS_CNTR;
+	ctxt->info.acl_def_act = cpu_to_le16(val);
 }
 
 /**
-- 
2.26.2

