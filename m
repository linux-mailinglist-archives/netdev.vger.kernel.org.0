Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C992A3681
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbgKBWYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:24:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:16123 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgKBWYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:24:19 -0500
IronPort-SDR: npnp4NSX0+Q2euiFeZr8YoqdEOTXnYY/VaadJnftcbsXp4rjUeh+uR/GF3xPxfJle5zzdaCQPv
 RLhIUqmth5Wg==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="253670963"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="253670963"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 14:24:17 -0800
IronPort-SDR: X9SxcUbZvV0Y+W9whgk+z+J5MoYXU4m9NucBi+Q1XJQpNDQsea1cfLE8oQiW9rZkO37Vnx+fu1
 rFqWHM8mggtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="305591771"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2020 14:24:17 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Real Valiquette <real.valiquette@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Chinh Cao <chinh.t.cao@intel.com>,
        Brijesh Behera <brijeshx.behera@intel.com>
Subject: [net-next 04/15] ice: initialize ACL scenario
Date:   Mon,  2 Nov 2020 14:23:27 -0800
Message-Id: <20201102222338.1442081-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Real Valiquette <real.valiquette@intel.com>

Complete initialization of the ACL table by programming the table with an
initial scenario. The scenario stores the data for the filtering rules.
Adjust reporting of ntuple filters to include ACL filters.

Co-developed-by: Chinh Cao <chinh.t.cao@intel.com>
Signed-off-by: Chinh Cao <chinh.t.cao@intel.com>
Signed-off-by: Real Valiquette <real.valiquette@intel.com>
Co-developed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Brijesh Behera <brijeshx.behera@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_acl.c      | 112 ++++
 drivers/net/ethernet/intel/ice/ice_acl.h      |  11 +
 drivers/net/ethernet/intel/ice/ice_acl_ctrl.c | 574 ++++++++++++++++++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  31 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   4 +-
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  47 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c     |  15 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h     |   5 +-
 drivers/net/ethernet/intel/ice/ice_flow.h     |   7 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   9 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   2 +
 12 files changed, 799 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 0ff1d71a1d88..1008a6785e55 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -599,6 +599,7 @@ void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena);
 int ice_add_ntuple_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd);
 int ice_del_ntuple_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd);
 int ice_get_ethtool_fdir_entry(struct ice_hw *hw, struct ethtool_rxnfc *cmd);
+u32 ice_ntuple_get_max_fltr_cnt(struct ice_hw *hw);
 int
 ice_get_fdir_fltr_ids(struct ice_hw *hw, struct ethtool_rxnfc *cmd,
 		      u32 *rule_locs);
diff --git a/drivers/net/ethernet/intel/ice/ice_acl.c b/drivers/net/ethernet/intel/ice/ice_acl.c
index 30e2dca5d86b..7ff97917aca9 100644
--- a/drivers/net/ethernet/intel/ice/ice_acl.c
+++ b/drivers/net/ethernet/intel/ice/ice_acl.c
@@ -151,3 +151,115 @@ ice_aq_program_actpair(struct ice_hw *hw, u8 act_mem_idx, u16 act_entry_idx,
 	return ice_aq_actpair_p_q(hw, ice_aqc_opc_program_acl_actpair,
 				  act_mem_idx, act_entry_idx, buf, cd);
 }
+
+/**
+ * ice_aq_alloc_acl_scen - allocate ACL scenario
+ * @hw: pointer to the HW struct
+ * @scen_id: memory location to receive allocated scenario ID
+ * @buf: address of indirect data buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Allocate ACL scenario (indirect 0x0C14)
+ */
+enum ice_status
+ice_aq_alloc_acl_scen(struct ice_hw *hw, u16 *scen_id,
+		      struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_acl_alloc_scen *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	if (!scen_id)
+		return ICE_ERR_PARAM;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_alloc_acl_scen);
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+	cmd = &desc.params.alloc_scen;
+
+	status = ice_aq_send_cmd(hw, &desc, buf, sizeof(*buf), cd);
+	if (!status)
+		*scen_id = le16_to_cpu(cmd->ops.resp.scen_id);
+
+	return status;
+}
+
+/**
+ * ice_aq_dealloc_acl_scen - deallocate ACL scenario
+ * @hw: pointer to the HW struct
+ * @scen_id: scen_id to be deallocated (input and output field)
+ * @cd: pointer to command details structure or NULL
+ *
+ * Deallocate ACL scenario (direct 0x0C15)
+ */
+enum ice_status
+ice_aq_dealloc_acl_scen(struct ice_hw *hw, u16 scen_id, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_acl_dealloc_scen *cmd;
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_dealloc_acl_scen);
+	cmd = &desc.params.dealloc_scen;
+	cmd->scen_id = cpu_to_le16(scen_id);
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
+}
+
+/**
+ * ice_aq_update_query_scen - update or query ACL scenario
+ * @hw: pointer to the HW struct
+ * @opcode: AQ command opcode for either query or update scenario
+ * @scen_id: scen_id to be updated or queried
+ * @buf: address of indirect data buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Calls update or query ACL scenario
+ */
+static enum ice_status
+ice_aq_update_query_scen(struct ice_hw *hw, u16 opcode, u16 scen_id,
+			 struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_acl_update_query_scen *cmd;
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, opcode);
+	if (opcode == ice_aqc_opc_update_acl_scen)
+		desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+	cmd = &desc.params.update_query_scen;
+	cmd->scen_id = cpu_to_le16(scen_id);
+
+	return ice_aq_send_cmd(hw, &desc, buf, sizeof(*buf), cd);
+}
+
+/**
+ * ice_aq_update_acl_scen - update ACL scenario
+ * @hw: pointer to the HW struct
+ * @scen_id: scen_id to be updated
+ * @buf: address of indirect data buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Update ACL scenario (indirect 0x0C1B)
+ */
+enum ice_status
+ice_aq_update_acl_scen(struct ice_hw *hw, u16 scen_id,
+		       struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd)
+{
+	return ice_aq_update_query_scen(hw, ice_aqc_opc_update_acl_scen,
+					scen_id, buf, cd);
+}
+
+/**
+ * ice_aq_query_acl_scen - query ACL scenario
+ * @hw: pointer to the HW struct
+ * @scen_id: scen_id to be queried
+ * @buf: address of indirect data buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Query ACL scenario (indirect 0x0C23)
+ */
+enum ice_status
+ice_aq_query_acl_scen(struct ice_hw *hw, u16 scen_id,
+		      struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd)
+{
+	return ice_aq_update_query_scen(hw, ice_aqc_opc_query_acl_scen,
+					scen_id, buf, cd);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_acl.h b/drivers/net/ethernet/intel/ice/ice_acl.h
index 5d39ef59ed5a..9e776f3f749c 100644
--- a/drivers/net/ethernet/intel/ice/ice_acl.h
+++ b/drivers/net/ethernet/intel/ice/ice_acl.h
@@ -107,6 +107,9 @@ enum ice_status
 ice_acl_create_tbl(struct ice_hw *hw, struct ice_acl_tbl_params *params);
 enum ice_status ice_acl_destroy_tbl(struct ice_hw *hw);
 enum ice_status
+ice_acl_create_scen(struct ice_hw *hw, u16 match_width, u16 num_entries,
+		    u16 *scen_id);
+enum ice_status
 ice_aq_alloc_acl_tbl(struct ice_hw *hw, struct ice_acl_alloc_tbl *tbl,
 		     struct ice_sq_cd *cd);
 enum ice_status
@@ -121,5 +124,13 @@ ice_aq_program_actpair(struct ice_hw *hw, u8 act_mem_idx, u16 act_entry_idx,
 enum ice_status
 ice_aq_alloc_acl_scen(struct ice_hw *hw, u16 *scen_id,
 		      struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_dealloc_acl_scen(struct ice_hw *hw, u16 scen_id, struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_update_acl_scen(struct ice_hw *hw, u16 scen_id,
+		       struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_query_acl_scen(struct ice_hw *hw, u16 scen_id,
+		      struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd);
 
 #endif /* _ICE_ACL_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c b/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
index f8f9aff91c60..84a96ccf40d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
+++ b/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
@@ -6,6 +6,78 @@
 /* Determine the TCAM index of entry 'e' within the ACL table */
 #define ICE_ACL_TBL_TCAM_IDX(e) ((e) / ICE_AQC_ACL_TCAM_DEPTH)
 
+/**
+ * ice_acl_init_entry
+ * @scen: pointer to the scenario struct
+ *
+ * Initialize the scenario control structure.
+ */
+static void ice_acl_init_entry(struct ice_acl_scen *scen)
+{
+	/* low priority: start from the highest index, 25% of total entries
+	 * normal priority: start from the highest index, 50% of total entries
+	 * high priority: start from the lowest index, 25% of total entries
+	 */
+	scen->first_idx[ICE_ACL_PRIO_LOW] = scen->num_entry - 1;
+	scen->first_idx[ICE_ACL_PRIO_NORMAL] = scen->num_entry -
+		scen->num_entry / 4 - 1;
+	scen->first_idx[ICE_ACL_PRIO_HIGH] = 0;
+
+	scen->last_idx[ICE_ACL_PRIO_LOW] = scen->num_entry -
+		scen->num_entry / 4;
+	scen->last_idx[ICE_ACL_PRIO_NORMAL] = scen->num_entry / 4;
+	scen->last_idx[ICE_ACL_PRIO_HIGH] = scen->num_entry / 4 - 1;
+}
+
+/**
+ * ice_acl_tbl_calc_end_idx
+ * @start: start index of the TCAM entry of this partition
+ * @num_entries: number of entries in this partition
+ * @width: width of a partition in number of TCAMs
+ *
+ * Calculate the end entry index for a partition with starting entry index
+ * 'start', entries 'num_entries', and width 'width'.
+ */
+static u16 ice_acl_tbl_calc_end_idx(u16 start, u16 num_entries, u16 width)
+{
+	u16 end_idx, add_entries = 0;
+
+	end_idx = start + (num_entries - 1);
+
+	/* In case that our ACL partition requires cascading TCAMs */
+	if (width > 1) {
+		u16 num_stack_level;
+
+		/* Figure out the TCAM stacked level in this ACL scenario */
+		num_stack_level = (start % ICE_AQC_ACL_TCAM_DEPTH) +
+			num_entries;
+		num_stack_level = DIV_ROUND_UP(num_stack_level,
+					       ICE_AQC_ACL_TCAM_DEPTH);
+
+		/* In this case, each entries in our ACL partition span
+		 * multiple TCAMs. Thus, we will need to add
+		 * ((width - 1) * num_stack_level) TCAM's entries to
+		 * end_idx.
+		 *
+		 * For example : In our case, our scenario is 2x2:
+		 *	[TCAM 0]	[TCAM 1]
+		 *	[TCAM 2]	[TCAM 3]
+		 * Assuming that a TCAM will have 512 entries. If "start"
+		 * is 500, "num_entries" is 3 and "width" = 2, then end_idx
+		 * should be 1024 (belongs to TCAM 2).
+		 * Before going to this if statement, end_idx will have the
+		 * value of 512. If "width" is 1, then the final value of
+		 * end_idx is 512. However, in our case, width is 2, then we
+		 * will need add (2 - 1) * 1 * 512. As result, end_idx will
+		 * have the value of 1024.
+		 */
+		add_entries = (width - 1) * num_stack_level *
+			ICE_AQC_ACL_TCAM_DEPTH;
+	}
+
+	return end_idx + add_entries;
+}
+
 /**
  * ice_acl_init_tbl
  * @hw: pointer to the hardware structure
@@ -284,18 +356,520 @@ ice_acl_create_tbl(struct ice_hw *hw, struct ice_acl_tbl_params *params)
 	return 0;
 }
 
+/**
+ * ice_acl_alloc_partition - Allocate a partition from the ACL table
+ * @hw: pointer to the hardware structure
+ * @req: info of partition being allocated
+ */
+static enum ice_status
+ice_acl_alloc_partition(struct ice_hw *hw, struct ice_acl_scen *req)
+{
+	u16 start = 0, cnt = 0, off = 0;
+	u16 width, r_entries, row;
+	bool done = false;
+	int dir;
+
+	/* Determine the number of TCAMs each entry overlaps */
+	width = DIV_ROUND_UP(req->width, ICE_AQC_ACL_KEY_WIDTH_BYTES);
+
+	/* Check if we have enough TCAMs to accommodate the width */
+	if (width > hw->acl_tbl->last_tcam - hw->acl_tbl->first_tcam + 1)
+		return ICE_ERR_MAX_LIMIT;
+
+	/* Number of entries must be multiple of ICE_ACL_ENTRY_ALLOC_UNIT's */
+	r_entries = ALIGN(req->num_entry, ICE_ACL_ENTRY_ALLOC_UNIT);
+
+	/* To look for an available partition that can accommodate the request,
+	 * the process first logically arranges available TCAMs in rows such
+	 * that each row produces entries with the requested width. It then
+	 * scans the TCAMs' available bitmap, one bit at a time, and
+	 * accumulates contiguous available 64-entry chunks until there are
+	 * enough of them or when all TCAM configurations have been checked.
+	 *
+	 * For width of 1 TCAM, the scanning process starts from the top most
+	 * TCAM, and goes downward. Available bitmaps are examined from LSB
+	 * to MSB.
+	 *
+	 * For width of multiple TCAMs, the process starts from the bottom-most
+	 * row of TCAMs, and goes upward. Available bitmaps are examined from
+	 * the MSB to the LSB.
+	 *
+	 * To make sure that adjacent TCAMs can be logically arranged in the
+	 * same row, the scanning process may have multiple passes. In each
+	 * pass, the first TCAM of the bottom-most row is displaced by one
+	 * additional TCAM. The width of the row and the number of the TCAMs
+	 * available determine the number of passes. When the displacement is
+	 * more than the size of width, the TCAM row configurations will
+	 * repeat. The process will terminate when the configurations repeat.
+	 *
+	 * Available partitions can span more than one row of TCAMs.
+	 */
+	if (width == 1) {
+		row = hw->acl_tbl->first_tcam;
+		dir = 1;
+	} else {
+		/* Start with the bottom-most row, and scan for available
+		 * entries upward
+		 */
+		row = hw->acl_tbl->last_tcam + 1 - width;
+		dir = -1;
+	}
+
+	do {
+		u16 i;
+
+		/* Scan all 64-entry chunks, one chunk at a time, in the
+		 * current TCAM row
+		 */
+		for (i = 0;
+		     i < ICE_AQC_MAX_TCAM_ALLOC_UNITS && cnt < r_entries;
+		     i++) {
+			bool avail = true;
+			u16 w, p;
+
+			/* Compute the cumulative available mask across the
+			 * TCAM row to determine if the current 64-entry chunk
+			 * is available.
+			 */
+			p = dir > 0 ? i : ICE_AQC_MAX_TCAM_ALLOC_UNITS - i - 1;
+			for (w = row; w < row + width && avail; w++) {
+				u16 b;
+
+				b = (w * ICE_AQC_MAX_TCAM_ALLOC_UNITS) + p;
+				avail &= test_bit(b, hw->acl_tbl->avail);
+			}
+
+			if (!avail) {
+				cnt = 0;
+			} else {
+				/* Compute the starting index of the newly
+				 * found partition. When 'dir' is negative, the
+				 * scan processes is going upward. If so, the
+				 * starting index needs to be updated for every
+				 * available 64-entry chunk found.
+				 */
+				if (!cnt || dir < 0)
+					start = (row * ICE_AQC_ACL_TCAM_DEPTH) +
+						(p * ICE_ACL_ENTRY_ALLOC_UNIT);
+				cnt += ICE_ACL_ENTRY_ALLOC_UNIT;
+			}
+		}
+
+		if (cnt >= r_entries) {
+			req->start = start;
+			req->num_entry = r_entries;
+			req->end = ice_acl_tbl_calc_end_idx(start, r_entries,
+							    width);
+			break;
+		}
+
+		row = dir > 0 ? row + width : row - width;
+		if (row > hw->acl_tbl->last_tcam ||
+		    row < hw->acl_tbl->first_tcam) {
+			/* All rows have been checked. Increment 'off' that
+			 * will help yield a different TCAM configuration in
+			 * which adjacent TCAMs can be alternatively in the
+			 * same row.
+			 */
+			off++;
+
+			/* However, if the new 'off' value yields previously
+			 * checked configurations, then exit.
+			 */
+			if (off >= width)
+				done = true;
+			else
+				row = dir > 0 ? off :
+					hw->acl_tbl->last_tcam + 1 - off -
+					width;
+		}
+	} while (!done);
+
+	return cnt >= r_entries ? ICE_SUCCESS : ICE_ERR_MAX_LIMIT;
+}
+
+/**
+ * ice_acl_fill_tcam_select
+ * @scen_buf: Pointer to the scenario buffer that needs to be populated
+ * @scen: Pointer to the available space for the scenario
+ * @tcam_idx: Index of the TCAM used for this scenario
+ * @tcam_idx_in_cascade: Local index of the TCAM in the cascade scenario
+ *
+ * For all TCAM that participate in this scenario, fill out the tcam_select
+ * value.
+ */
+static void
+ice_acl_fill_tcam_select(struct ice_aqc_acl_scen *scen_buf,
+			 struct ice_acl_scen *scen, u16 tcam_idx,
+			 u16 tcam_idx_in_cascade)
+{
+	u16 cascade_cnt, idx;
+	u8 j;
+
+	idx = tcam_idx_in_cascade * ICE_AQC_ACL_KEY_WIDTH_BYTES;
+	cascade_cnt = DIV_ROUND_UP(scen->width, ICE_AQC_ACL_KEY_WIDTH_BYTES);
+
+	/* For each scenario, we reserved last three bytes of scenario width for
+	 * profile ID, range checker, and packet direction. Thus, the last three
+	 * bytes of the last cascaded TCAMs will have value of 1st, 31st and
+	 * 32nd byte location of BYTE selection base.
+	 *
+	 * For other bytes in the TCAMs:
+	 * For non-cascade mode (1 TCAM wide) scenario, TCAM[x]'s Select {0-1}
+	 * select indices 0-1 of the Byte Selection Base
+	 * For cascade mode, the leftmost TCAM of the first cascade row selects
+	 * indices 0-4 of the Byte Selection Base; the second TCAM in the
+	 * cascade row selects indices starting with 5-n
+	 */
+	for (j = 0; j < ICE_AQC_ACL_KEY_WIDTH_BYTES; j++) {
+		/* PKT DIR uses the 1st location of Byte Selection Base: + 1 */
+		u8 val = ICE_AQC_ACL_BYTE_SEL_BASE + 1 + idx;
+
+		if (tcam_idx_in_cascade == cascade_cnt - 1) {
+			if (j == ICE_ACL_SCEN_RNG_CHK_IDX_IN_TCAM)
+				val = ICE_AQC_ACL_BYTE_SEL_BASE_RNG_CHK;
+			else if (j == ICE_ACL_SCEN_PID_IDX_IN_TCAM)
+				val = ICE_AQC_ACL_BYTE_SEL_BASE_PID;
+			else if (j == ICE_ACL_SCEN_PKT_DIR_IDX_IN_TCAM)
+				val = ICE_AQC_ACL_BYTE_SEL_BASE_PKT_DIR;
+		}
+
+		/* In case that scenario's width is greater than the width of
+		 * the Byte selection base, we will not assign a value to the
+		 * tcam_select[j]. As a result, the tcam_select[j] will have
+		 * default value which is zero.
+		 */
+		if (val > ICE_AQC_ACL_BYTE_SEL_BASE_RNG_CHK)
+			continue;
+
+		scen_buf->tcam_cfg[tcam_idx].tcam_select[j] = val;
+
+		idx++;
+	}
+}
+
+/**
+ * ice_acl_set_scen_chnk_msk
+ * @scen_buf: Pointer to the scenario buffer that needs to be populated
+ * @scen: pointer to the available space for the scenario
+ *
+ * Set the chunk mask for the entries that will be used by this scenario
+ */
+static void
+ice_acl_set_scen_chnk_msk(struct ice_aqc_acl_scen *scen_buf,
+			  struct ice_acl_scen *scen)
+{
+	u16 tcam_idx, num_cscd, units, cnt;
+	u8 chnk_offst;
+
+	/* Determine the starting TCAM index and offset of the start entry */
+	tcam_idx = ICE_ACL_TBL_TCAM_IDX(scen->start);
+	chnk_offst = (u8)((scen->start % ICE_AQC_ACL_TCAM_DEPTH) /
+			  ICE_ACL_ENTRY_ALLOC_UNIT);
+
+	/* Entries are allocated and tracked in multiple of 64's */
+	units = scen->num_entry / ICE_ACL_ENTRY_ALLOC_UNIT;
+
+	/* Determine number of cascaded TCAMs */
+	num_cscd = scen->width / ICE_AQC_ACL_KEY_WIDTH_BYTES;
+
+	for (cnt = 0; cnt < units; cnt++) {
+		u16 i;
+
+		/* Set the corresponding bitmap of individual 64-entry
+		 * chunk spans across a cascade of 1 or more TCAMs
+		 * For each TCAM, there will be (ICE_AQC_ACL_TCAM_DEPTH
+		 * / ICE_ACL_ENTRY_ALLOC_UNIT) or 8 chunks.
+		 */
+		for (i = tcam_idx; i < tcam_idx + num_cscd; i++)
+			scen_buf->tcam_cfg[i].chnk_msk |= BIT(chnk_offst);
+
+		chnk_offst = (chnk_offst + 1) % ICE_AQC_MAX_TCAM_ALLOC_UNITS;
+		if (!chnk_offst)
+			tcam_idx += num_cscd;
+	}
+}
+
+/**
+ * ice_acl_assign_act_mem_for_scen
+ * @tbl: pointer to ACL table structure
+ * @scen: pointer to the scenario struct
+ * @scen_buf: pointer to the available space for the scenario
+ * @current_tcam_idx: theoretical index of the TCAM that we associated those
+ *		      action memory banks with, at the table creation time.
+ * @target_tcam_idx: index of the TCAM that we want to associate those action
+ *		     memory banks with.
+ */
+static void
+ice_acl_assign_act_mem_for_scen(struct ice_acl_tbl *tbl,
+				struct ice_acl_scen *scen,
+				struct ice_aqc_acl_scen *scen_buf,
+				u8 current_tcam_idx, u8 target_tcam_idx)
+{
+	u8 i;
+
+	for (i = 0; i < ICE_AQC_MAX_ACTION_MEMORIES; i++) {
+		struct ice_acl_act_mem *p_mem = &tbl->act_mems[i];
+
+		if (p_mem->act_mem == ICE_ACL_ACT_PAIR_MEM_INVAL ||
+		    p_mem->member_of_tcam != current_tcam_idx)
+			continue;
+
+		scen_buf->act_mem_cfg[i] = target_tcam_idx;
+		scen_buf->act_mem_cfg[i] |= ICE_AQC_ACL_SCE_ACT_MEM_EN;
+		set_bit(i, scen->act_mem_bitmap);
+	}
+}
+
+/**
+ * ice_acl_commit_partition - Indicate if the specified partition is active
+ * @hw: pointer to the hardware structure
+ * @scen: pointer to the scenario struct
+ * @commit: true if the partition is being commit
+ */
+static void
+ice_acl_commit_partition(struct ice_hw *hw, struct ice_acl_scen *scen,
+			 bool commit)
+{
+	u16 tcam_idx, off, num_cscd, units, cnt;
+
+	/* Determine the starting TCAM index and offset of the start entry */
+	tcam_idx = ICE_ACL_TBL_TCAM_IDX(scen->start);
+	off = (scen->start % ICE_AQC_ACL_TCAM_DEPTH) /
+		ICE_ACL_ENTRY_ALLOC_UNIT;
+
+	/* Entries are allocated and tracked in multiple of 64's */
+	units = scen->num_entry / ICE_ACL_ENTRY_ALLOC_UNIT;
+
+	/* Determine number of cascaded TCAM */
+	num_cscd = scen->width / ICE_AQC_ACL_KEY_WIDTH_BYTES;
+
+	for (cnt = 0; cnt < units; cnt++) {
+		u16 w;
+
+		/* Set/clear the corresponding bitmap of individual 64-entry
+		 * chunk spans across a row of 1 or more TCAMs
+		 */
+		for (w = 0; w < num_cscd; w++) {
+			u16 b;
+
+			b = ((tcam_idx + w) * ICE_AQC_MAX_TCAM_ALLOC_UNITS) +
+				off;
+			if (commit)
+				set_bit(b, hw->acl_tbl->avail);
+			else
+				clear_bit(b, hw->acl_tbl->avail);
+		}
+
+		off = (off + 1) % ICE_AQC_MAX_TCAM_ALLOC_UNITS;
+		if (!off)
+			tcam_idx += num_cscd;
+	}
+}
+
+/**
+ * ice_acl_create_scen
+ * @hw: pointer to the hardware structure
+ * @match_width: number of bytes to be matched in this scenario
+ * @num_entries: number of entries to be allocated for the scenario
+ * @scen_id: holds returned scenario ID if successful
+ */
+enum ice_status
+ice_acl_create_scen(struct ice_hw *hw, u16 match_width, u16 num_entries,
+		    u16 *scen_id)
+{
+	u8 cascade_cnt, first_tcam, last_tcam, i, k;
+	struct ice_aqc_acl_scen scen_buf;
+	struct ice_acl_scen *scen;
+	enum ice_status status;
+
+	if (!hw->acl_tbl)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	scen = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*scen), GFP_KERNEL);
+	if (!scen)
+		return ICE_ERR_NO_MEMORY;
+
+	scen->start = hw->acl_tbl->first_entry;
+	scen->width = ICE_AQC_ACL_KEY_WIDTH_BYTES *
+		DIV_ROUND_UP(match_width, ICE_AQC_ACL_KEY_WIDTH_BYTES);
+	scen->num_entry = num_entries;
+
+	status = ice_acl_alloc_partition(hw, scen);
+	if (status)
+		goto out;
+
+	memset(&scen_buf, 0, sizeof(scen_buf));
+
+	/* Determine the number of cascade TCAMs, given the scenario's width */
+	cascade_cnt = DIV_ROUND_UP(scen->width, ICE_AQC_ACL_KEY_WIDTH_BYTES);
+	first_tcam = ICE_ACL_TBL_TCAM_IDX(scen->start);
+	last_tcam = ICE_ACL_TBL_TCAM_IDX(scen->end);
+
+	/* For each scenario, we reserved last three bytes of scenario width for
+	 * packet direction flag, profile ID and range checker. Thus, we want to
+	 * return back to the caller the eff_width, pkt_dir_idx, rng_chk_idx and
+	 * pid_idx.
+	 */
+	scen->eff_width = cascade_cnt * ICE_AQC_ACL_KEY_WIDTH_BYTES -
+		ICE_ACL_SCEN_MIN_WIDTH;
+	scen->rng_chk_idx = (cascade_cnt - 1) * ICE_AQC_ACL_KEY_WIDTH_BYTES +
+		ICE_ACL_SCEN_RNG_CHK_IDX_IN_TCAM;
+	scen->pid_idx = (cascade_cnt - 1) * ICE_AQC_ACL_KEY_WIDTH_BYTES +
+		ICE_ACL_SCEN_PID_IDX_IN_TCAM;
+	scen->pkt_dir_idx = (cascade_cnt - 1) * ICE_AQC_ACL_KEY_WIDTH_BYTES +
+		ICE_ACL_SCEN_PKT_DIR_IDX_IN_TCAM;
+
+	/* set the chunk mask for the tcams */
+	ice_acl_set_scen_chnk_msk(&scen_buf, scen);
+
+	/* set the TCAM select and start_cmp and start_set bits */
+	k = first_tcam;
+	/* set the START_SET bit at the beginning of the stack */
+	scen_buf.tcam_cfg[k].start_cmp_set |= ICE_AQC_ACL_ALLOC_SCE_START_SET;
+	while (k <= last_tcam) {
+		u8 last_tcam_idx_cascade = cascade_cnt + k - 1;
+
+		/* set start_cmp for the first cascaded TCAM */
+		scen_buf.tcam_cfg[k].start_cmp_set |=
+			ICE_AQC_ACL_ALLOC_SCE_START_CMP;
+
+		/* cascade TCAMs up to the width of the scenario */
+		for (i = k; i < cascade_cnt + k; i++) {
+			ice_acl_fill_tcam_select(&scen_buf, scen, i, i - k);
+			ice_acl_assign_act_mem_for_scen(hw->acl_tbl, scen,
+							&scen_buf, i,
+							last_tcam_idx_cascade);
+		}
+
+		k = i;
+	}
+
+	/* We need to set the start_cmp bit for the unused TCAMs. */
+	i = 0;
+	while (i < first_tcam)
+		scen_buf.tcam_cfg[i++].start_cmp_set =
+					ICE_AQC_ACL_ALLOC_SCE_START_CMP;
+
+	i = last_tcam + 1;
+	while (i < ICE_AQC_ACL_SLICES)
+		scen_buf.tcam_cfg[i++].start_cmp_set =
+					ICE_AQC_ACL_ALLOC_SCE_START_CMP;
+
+	status = ice_aq_alloc_acl_scen(hw, scen_id, &scen_buf, NULL);
+	if (status) {
+		ice_debug(hw, ICE_DBG_ACL, "AQ allocation of ACL scenario failed. status: %d\n",
+			  status);
+		goto out;
+	}
+
+	scen->id = *scen_id;
+	ice_acl_commit_partition(hw, scen, false);
+	ice_acl_init_entry(scen);
+	list_add(&scen->list_entry, &hw->acl_tbl->scens);
+
+out:
+	if (status)
+		devm_kfree(ice_hw_to_dev(hw), scen);
+
+	return status;
+}
+
+/**
+ * ice_acl_destroy_scen - Destroy an ACL scenario
+ * @hw: pointer to the HW struct
+ * @scen_id: ID of the remove scenario
+ */
+static enum ice_status ice_acl_destroy_scen(struct ice_hw *hw, u16 scen_id)
+{
+	struct ice_acl_scen *scen, *tmp_scen;
+	struct ice_flow_prof *p, *tmp;
+	enum ice_status status;
+
+	if (!hw->acl_tbl)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	/* Remove profiles that use "scen_id" scenario */
+	list_for_each_entry_safe(p, tmp, &hw->fl_profs[ICE_BLK_ACL], l_entry)
+		if (p->cfg.scen && p->cfg.scen->id == scen_id) {
+			status = ice_flow_rem_prof(hw, ICE_BLK_ACL, p->id);
+			if (status) {
+				ice_debug(hw, ICE_DBG_ACL, "ice_flow_rem_prof failed. status: %d\n",
+					  status);
+				return status;
+			}
+		}
+
+	/* Call the AQ command to destroy the targeted scenario */
+	status = ice_aq_dealloc_acl_scen(hw, scen_id, NULL);
+	if (status) {
+		ice_debug(hw, ICE_DBG_ACL, "AQ de-allocation of scenario failed. status: %d\n",
+			  status);
+		return status;
+	}
+
+	/* Remove scenario from hw->acl_tbl->scens */
+	list_for_each_entry_safe(scen, tmp_scen, &hw->acl_tbl->scens,
+				 list_entry)
+		if (scen->id == scen_id) {
+			list_del(&scen->list_entry);
+			devm_kfree(ice_hw_to_dev(hw), scen);
+		}
+
+	return 0;
+}
+
 /**
  * ice_acl_destroy_tbl - Destroy a previously created LEM table for ACL
  * @hw: pointer to the HW struct
  */
 enum ice_status ice_acl_destroy_tbl(struct ice_hw *hw)
 {
+	struct ice_acl_scen *pos_scen, *tmp_scen;
 	struct ice_aqc_acl_generic resp_buf;
+	struct ice_aqc_acl_scen buf;
 	enum ice_status status;
+	u8 i;
 
 	if (!hw->acl_tbl)
 		return ICE_ERR_DOES_NOT_EXIST;
 
+	/* Mark all the created scenario's TCAM to stop the packet lookup and
+	 * delete them afterward
+	 */
+	list_for_each_entry_safe(pos_scen, tmp_scen, &hw->acl_tbl->scens,
+				 list_entry) {
+		status = ice_aq_query_acl_scen(hw, pos_scen->id, &buf, NULL);
+		if (status) {
+			ice_debug(hw, ICE_DBG_ACL, "ice_aq_query_acl_scen() failed. status: %d\n",
+				  status);
+			return status;
+		}
+
+		for (i = 0; i < ICE_AQC_ACL_SLICES; i++) {
+			buf.tcam_cfg[i].chnk_msk = 0;
+			buf.tcam_cfg[i].start_cmp_set =
+					ICE_AQC_ACL_ALLOC_SCE_START_CMP;
+		}
+
+		for (i = 0; i < ICE_AQC_MAX_ACTION_MEMORIES; i++)
+			buf.act_mem_cfg[i] = 0;
+
+		status = ice_aq_update_acl_scen(hw, pos_scen->id, &buf, NULL);
+		if (status) {
+			ice_debug(hw, ICE_DBG_ACL, "ice_aq_update_acl_scen() failed. status: %d\n",
+				  status);
+			return status;
+		}
+
+		status = ice_acl_destroy_scen(hw, pos_scen->id);
+		if (status) {
+			ice_debug(hw, ICE_DBG_ACL, "deletion of scenario failed. status: %d\n",
+				  status);
+			return status;
+		}
+	}
+
 	/* call the AQ command to destroy the ACL table */
 	status = ice_aq_dealloc_acl_tbl(hw, hw->acl_tbl->id, &resp_buf, NULL);
 	if (status) {
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 688a2069482d..062a90248f8f 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1711,6 +1711,33 @@ struct ice_aqc_acl_generic {
 	u8 act_mem[ICE_AQC_MAX_ACTION_MEMORIES];
 };
 
+/* Allocate ACL scenario (indirect 0x0C14). This command doesn't have separate
+ * response buffer since original command buffer gets updated with
+ * 'scen_id' in case of success
+ */
+struct ice_aqc_acl_alloc_scen {
+	union {
+		struct {
+			u8 reserved[8];
+		} cmd;
+		struct {
+			__le16 scen_id;
+			u8 reserved[6];
+		} resp;
+	} ops;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* De-allocate ACL scenario (direct 0x0C15). This command doesn't need
+ * separate response buffer since nothing to be returned as a response
+ * except status.
+ */
+struct ice_aqc_acl_dealloc_scen {
+	__le16 scen_id;
+	u8 reserved[14];
+};
+
 /* Update ACL scenario (direct 0x0C1B)
  * Query ACL scenario (direct 0x0C23)
  */
@@ -2081,6 +2108,8 @@ struct ice_aq_desc {
 		struct ice_aqc_get_set_rss_key get_set_rss_key;
 		struct ice_aqc_acl_alloc_table alloc_table;
 		struct ice_aqc_acl_tbl_actpair tbl_actpair;
+		struct ice_aqc_acl_alloc_scen alloc_scen;
+		struct ice_aqc_acl_dealloc_scen dealloc_scen;
 		struct ice_aqc_acl_update_query_scen update_query_scen;
 		struct ice_aqc_acl_entry program_query_entry;
 		struct ice_aqc_acl_actpair program_query_actpair;
@@ -2231,6 +2260,8 @@ enum ice_adminq_opc {
 	/* ACL commands */
 	ice_aqc_opc_alloc_acl_tbl			= 0x0C10,
 	ice_aqc_opc_dealloc_acl_tbl			= 0x0C11,
+	ice_aqc_opc_alloc_acl_scen			= 0x0C14,
+	ice_aqc_opc_dealloc_acl_scen			= 0x0C15,
 	ice_aqc_opc_update_acl_scen			= 0x0C1B,
 	ice_aqc_opc_program_acl_actpair			= 0x0C1C,
 	ice_aqc_opc_program_acl_entry			= 0x0C20,
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 363377fe90ee..f53a6722c146 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2689,8 +2689,8 @@ ice_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 		break;
 	case ETHTOOL_GRXCLSRLCNT:
 		cmd->rule_cnt = hw->fdir_active_fltr;
-		/* report total rule count */
-		cmd->data = ice_get_fdir_cnt_all(hw);
+		/* report max rule count */
+		cmd->data = ice_ntuple_get_max_fltr_cnt(hw);
 		ret = 0;
 		break;
 	case ETHTOOL_GRXCLSRULE:
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index f3d2199a2b42..6869357624ab 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -219,6 +219,22 @@ int ice_get_ethtool_fdir_entry(struct ice_hw *hw, struct ethtool_rxnfc *cmd)
 	return ret;
 }
 
+/**
+ * ice_ntuple_get_max_fltr_cnt - return the maximum number of allowed filters
+ * @hw: hardware structure containing filter information
+ */
+u32 ice_ntuple_get_max_fltr_cnt(struct ice_hw *hw)
+{
+	int acl_cnt;
+
+	if (hw->dev_caps.num_funcs < 8)
+		acl_cnt = ICE_AQC_ACL_TCAM_DEPTH / ICE_ACL_ENTIRE_SLICE;
+	else
+		acl_cnt = ICE_AQC_ACL_TCAM_DEPTH / ICE_ACL_HALF_SLICE;
+
+	return ice_get_fdir_cnt_all(hw) + acl_cnt;
+}
+
 /**
  * ice_get_fdir_fltr_ids - fill buffer with filter IDs of active filters
  * @hw: hardware structure containing the filter list
@@ -235,8 +251,8 @@ ice_get_fdir_fltr_ids(struct ice_hw *hw, struct ethtool_rxnfc *cmd,
 	unsigned int cnt = 0;
 	int val = 0;
 
-	/* report total rule count */
-	cmd->data = ice_get_fdir_cnt_all(hw);
+	/* report max rule count */
+	cmd->data = ice_ntuple_get_max_fltr_cnt(hw);
 
 	mutex_lock(&hw->fdir_fltr_lock);
 
@@ -265,6 +281,9 @@ ice_get_fdir_fltr_ids(struct ice_hw *hw, struct ethtool_rxnfc *cmd,
 static struct ice_fd_hw_prof *
 ice_fdir_get_hw_prof(struct ice_hw *hw, enum ice_block blk, int flow)
 {
+	if (blk == ICE_BLK_ACL && hw->acl_prof)
+		return hw->acl_prof[flow];
+
 	if (blk == ICE_BLK_FD && hw->fdir_prof)
 		return hw->fdir_prof[flow];
 
@@ -1345,11 +1364,12 @@ void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena)
 	if (!test_and_clear_bit(ICE_FLAG_FD_ENA, pf->flags))
 		goto release_lock;
 	list_for_each_entry_safe(f_rule, tmp, &hw->fdir_list_head, fltr_node) {
-		/* ignore return value */
-		ice_fdir_write_all_fltr(pf, f_rule, false);
-		ice_fdir_update_cntrs(hw, f_rule->flow_type, false);
+		if (!f_rule->acl_fltr)
+			ice_fdir_write_all_fltr(pf, f_rule, false);
+		ice_fdir_update_cntrs(hw, f_rule->flow_type, f_rule->acl_fltr,
+				      false);
 		list_del(&f_rule->fltr_node);
-		devm_kfree(ice_hw_to_dev(hw), f_rule);
+		devm_kfree(ice_pf_to_dev(pf), f_rule);
 	}
 
 	if (hw->fdir_prof)
@@ -1358,6 +1378,12 @@ void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena)
 			if (hw->fdir_prof[flow])
 				ice_fdir_rem_flow(hw, ICE_BLK_FD, flow);
 
+	if (hw->acl_prof)
+		for (flow = ICE_FLTR_PTYPE_NONF_NONE; flow < ICE_FLTR_PTYPE_MAX;
+		     flow++)
+			if (hw->acl_prof[flow])
+				ice_fdir_rem_flow(hw, ICE_BLK_ACL, flow);
+
 release_lock:
 	mutex_unlock(&hw->fdir_fltr_lock);
 }
@@ -1412,7 +1438,8 @@ ice_ntuple_update_list_entry(struct ice_pf *pf, struct ice_fdir_fltr *input,
 		err = ice_fdir_write_all_fltr(pf, old_fltr, false);
 		if (err)
 			return err;
-		ice_fdir_update_cntrs(hw, old_fltr->flow_type, false);
+		ice_fdir_update_cntrs(hw, old_fltr->flow_type,
+				      false, false);
 		if (!input && !hw->fdir_fltr_cnt[old_fltr->flow_type])
 			/* we just deleted the last filter of flow_type so we
 			 * should also delete the HW filter info.
@@ -1424,7 +1451,7 @@ ice_ntuple_update_list_entry(struct ice_pf *pf, struct ice_fdir_fltr *input,
 	if (!input)
 		return err;
 	ice_fdir_list_add_fltr(hw, input);
-	ice_fdir_update_cntrs(hw, input->flow_type, true);
+	ice_fdir_update_cntrs(hw, input->flow_type, input->acl_fltr, true);
 	return 0;
 }
 
@@ -1640,7 +1667,7 @@ int ice_add_ntuple_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 	if (ret)
 		return ret;
 
-	if (fsp->location >= ice_get_fdir_cnt_all(hw)) {
+	if (fsp->location >= ice_ntuple_get_max_fltr_cnt(hw)) {
 		dev_err(dev, "Failed to add filter.  The maximum number of flow director filters has been reached.\n");
 		return -ENOSPC;
 	}
@@ -1683,7 +1710,7 @@ int ice_add_ntuple_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 	goto release_lock;
 
 remove_sw_rule:
-	ice_fdir_update_cntrs(hw, input->flow_type, false);
+	ice_fdir_update_cntrs(hw, input->flow_type, false, false);
 	list_del(&input->fltr_node);
 release_lock:
 	mutex_unlock(&hw->fdir_fltr_lock);
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
index 59c0c6a0f8c5..6e9d1e6f4159 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -718,20 +718,25 @@ void ice_fdir_list_add_fltr(struct ice_hw *hw, struct ice_fdir_fltr *fltr)
  * ice_fdir_update_cntrs - increment / decrement filter counter
  * @hw: pointer to hardware structure
  * @flow: filter flow type
+ * @acl_fltr: true indicates an ACL filter
  * @add: true implies filters added
  */
 void
-ice_fdir_update_cntrs(struct ice_hw *hw, enum ice_fltr_ptype flow, bool add)
+ice_fdir_update_cntrs(struct ice_hw *hw, enum ice_fltr_ptype flow,
+		      bool acl_fltr, bool add)
 {
 	int incr;
 
 	incr = add ? 1 : -1;
 	hw->fdir_active_fltr += incr;
-
-	if (flow == ICE_FLTR_PTYPE_NONF_NONE || flow >= ICE_FLTR_PTYPE_MAX)
+	if (flow == ICE_FLTR_PTYPE_NONF_NONE || flow >= ICE_FLTR_PTYPE_MAX) {
 		ice_debug(hw, ICE_DBG_SW, "Unknown filter type %d\n", flow);
-	else
-		hw->fdir_fltr_cnt[flow] += incr;
+	} else {
+		if (acl_fltr)
+			hw->acl_fltr_cnt[flow] += incr;
+		else
+			hw->fdir_fltr_cnt[flow] += incr;
+	}
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.h b/drivers/net/ethernet/intel/ice/ice_fdir.h
index 1c587766daab..5cc89d91ec39 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -132,6 +132,8 @@ struct ice_fdir_fltr {
 	u8 fltr_status;
 	u16 cnt_index;
 	u32 fltr_id;
+	/* Set to true for an ACL filter */
+	bool acl_fltr;
 };
 
 /* Dummy packet filter definition structure */
@@ -161,6 +163,7 @@ bool ice_fdir_has_frag(enum ice_fltr_ptype flow);
 struct ice_fdir_fltr *
 ice_fdir_find_fltr_by_idx(struct ice_hw *hw, u32 fltr_idx);
 void
-ice_fdir_update_cntrs(struct ice_hw *hw, enum ice_fltr_ptype flow, bool add);
+ice_fdir_update_cntrs(struct ice_hw *hw, enum ice_fltr_ptype flow,
+		      bool acl_fltr, bool add);
 void ice_fdir_list_add_fltr(struct ice_hw *hw, struct ice_fdir_fltr *input);
 #endif /* _ICE_FDIR_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 875e8b8f1c84..00109262f152 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -214,6 +214,13 @@ struct ice_flow_prof {
 
 	/* software VSI handles referenced by this flow profile */
 	DECLARE_BITMAP(vsis, ICE_MAX_VSI);
+
+	union {
+		/* struct sw_recipe */
+		struct ice_acl_scen *scen;
+		/* struct fd */
+		u32 data;
+	} cfg;
 };
 
 struct ice_rss_cfg {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a49751f6951a..67bab35d590b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3832,7 +3832,9 @@ static int ice_init_acl(struct ice_pf *pf)
 {
 	struct ice_acl_tbl_params params;
 	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
 	int divider;
+	u16 scen_id;
 
 	/* Creates a single ACL table that consist of src_ip(4 byte),
 	 * dest_ip(4 byte), src_port(2 byte) and dst_port(2 byte) for a total
@@ -3852,7 +3854,12 @@ static int ice_init_acl(struct ice_pf *pf)
 	params.entry_act_pairs = 1;
 	params.concurr = false;
 
-	return ice_status_to_errno(ice_acl_create_tbl(hw, &params));
+	status = ice_acl_create_tbl(hw, &params);
+	if (status)
+		return ice_status_to_errno(status);
+
+	return ice_status_to_errno(ice_acl_create_scen(hw, params.width,
+						       params.depth, &scen_id));
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index a1600c7e8b17..f5e42ba9a286 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -681,6 +681,8 @@ struct ice_hw {
 	struct udp_tunnel_nic_info udp_tunnel_nic;
 
 	struct ice_acl_tbl *acl_tbl;
+	struct ice_fd_hw_prof **acl_prof;
+	u16 acl_fltr_cnt[ICE_FLTR_PTYPE_MAX];
 
 	/* HW block tables */
 	struct ice_blk_info blk[ICE_BLK_COUNT];
-- 
2.26.2

