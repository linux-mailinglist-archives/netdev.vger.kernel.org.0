Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F9E2B2712
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgKMVfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:35:09 -0500
Received: from mga06.intel.com ([134.134.136.31]:18348 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgKMVeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:50 -0500
IronPort-SDR: mVwVCJjxRCAOL1JVM0F1F0ZTwXTz7jUaw44aR7mXAG81kW3vV0KJg6J0ad8+CUaVaiAdAxdvmL
 QL1QMtL8qh9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232152344"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232152344"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:34:37 -0800
IronPort-SDR: VrVFHiLDvLvk8j9FJWLBmiCnkqZuIKdtRAUsoAgbhXwoOxVRcoEW680bW1DeRMKZhN+nmUed0Q
 qo4FTppBbbwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="366861590"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Nov 2020 13:34:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.neti, kuba@kernel.org
Cc:     Real Valiquette <real.valiquette@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Chinh Cao <chinh.t.cao@intel.com>,
        Harikumar Bokkena <harikumarx.bokkena@intel.com>
Subject: [net-next v2 03/15] ice: initialize ACL table
Date:   Fri, 13 Nov 2020 13:33:55 -0800
Message-Id: <20201113213407.2131340-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
References: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Real Valiquette <real.valiquette@intel.com>

ACL filtering can be utilized to expand support of ntuple rules by allowing
mask values to be specified for redirect to queue or drop.

Implement support for specifying the 'm' value of ethtool ntuple command
for currently supported fields (src-ip, dst-ip, src-port, and dst-port).

For example:

ethtool -N eth0 flow-type tcp4 dst-port 8880 m 0x00ff action 10
or
ethtool -N eth0 flow-type tcp4 src-ip 192.168.0.55 m 0.0.0.255 action -1

At this time the following flow-types support mask values: tcp4, udp4,
sctp4, and ip4.

Begin implementation of ACL filters by setting up structures, AdminQ
commands, and allocation of the ACL table in the hardware.

Co-developed-by: Chinh Cao <chinh.t.cao@intel.com>
Signed-off-by: Chinh Cao <chinh.t.cao@intel.com>
Signed-off-by: Real Valiquette <real.valiquette@intel.com>
Co-developed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Harikumar Bokkena  <harikumarx.bokkena@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   2 +
 drivers/net/ethernet/intel/ice/ice.h          |   4 +
 drivers/net/ethernet/intel/ice/ice_acl.c      | 153 +++++++++
 drivers/net/ethernet/intel/ice/ice_acl.h      | 125 +++++++
 drivers/net/ethernet/intel/ice/ice_acl_ctrl.c | 311 ++++++++++++++++++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 215 +++++++++++-
 drivers/net/ethernet/intel/ice/ice_flow.h     |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  50 +++
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 9 files changed, 863 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl_ctrl.c

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 6da4f43f2348..0747976622cf 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -20,6 +20,8 @@ ice-y := ice_main.o	\
 	 ice_fltr.o	\
 	 ice_fdir.o	\
 	 ice_ethtool_fdir.o \
+	 ice_acl.o	\
+	 ice_acl_ctrl.o	\
 	 ice_flex_pipe.o \
 	 ice_flow.o	\
 	 ice_devlink.o	\
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 59d3862bb7d8..0ff1d71a1d88 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -49,6 +49,7 @@
 #include "ice_dcb.h"
 #include "ice_switch.h"
 #include "ice_common.h"
+#include "ice_flow.h"
 #include "ice_sched.h"
 #include "ice_virtchnl_pf.h"
 #include "ice_sriov.h"
@@ -100,6 +101,9 @@
 #define ICE_TX_CTX_DESC(R, i) (&(((struct ice_tx_ctx_desc *)((R)->desc))[i]))
 #define ICE_TX_FDIRDESC(R, i) (&(((struct ice_fltr_desc *)((R)->desc))[i]))
 
+#define ICE_ACL_ENTIRE_SLICE	1
+#define ICE_ACL_HALF_SLICE	2
+
 /* Macro for each VSI in a PF */
 #define ice_for_each_vsi(pf, i) \
 	for ((i) = 0; (i) < (pf)->num_alloc_vsi; (i)++)
diff --git a/drivers/net/ethernet/intel/ice/ice_acl.c b/drivers/net/ethernet/intel/ice/ice_acl.c
new file mode 100644
index 000000000000..30e2dca5d86b
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_acl.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2020, Intel Corporation. */
+
+#include "ice_acl.h"
+
+/**
+ * ice_aq_alloc_acl_tbl - allocate ACL table
+ * @hw: pointer to the HW struct
+ * @tbl: pointer to ice_acl_alloc_tbl struct
+ * @cd: pointer to command details structure or NULL
+ *
+ * Allocate ACL table (indirect 0x0C10)
+ */
+enum ice_status
+ice_aq_alloc_acl_tbl(struct ice_hw *hw, struct ice_acl_alloc_tbl *tbl,
+		     struct ice_sq_cd *cd)
+{
+	struct ice_aqc_acl_alloc_table *cmd;
+	struct ice_aq_desc desc;
+
+	if (!tbl->act_pairs_per_entry)
+		return ICE_ERR_PARAM;
+
+	if (tbl->act_pairs_per_entry > ICE_AQC_MAX_ACTION_MEMORIES)
+		return ICE_ERR_MAX_LIMIT;
+
+	/* If this is concurrent table, then buffer shall be valid and
+	 * contain DependentAllocIDs, 'num_dependent_alloc_ids' should be valid
+	 * and within limit
+	 */
+	if (tbl->concurr) {
+		if (!tbl->num_dependent_alloc_ids)
+			return ICE_ERR_PARAM;
+		if (tbl->num_dependent_alloc_ids >
+		    ICE_AQC_MAX_CONCURRENT_ACL_TBL)
+			return ICE_ERR_INVAL_SIZE;
+	}
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_alloc_acl_tbl);
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	cmd = &desc.params.alloc_table;
+	cmd->table_width = cpu_to_le16(tbl->width * BITS_PER_BYTE);
+	cmd->table_depth = cpu_to_le16(tbl->depth);
+	cmd->act_pairs_per_entry = tbl->act_pairs_per_entry;
+	if (tbl->concurr)
+		cmd->table_type = tbl->num_dependent_alloc_ids;
+
+	return ice_aq_send_cmd(hw, &desc, &tbl->buf, sizeof(tbl->buf), cd);
+}
+
+/**
+ * ice_aq_dealloc_acl_tbl - deallocate ACL table
+ * @hw: pointer to the HW struct
+ * @alloc_id: allocation ID of the table being released
+ * @buf: address of indirect data buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Deallocate ACL table (indirect 0x0C11)
+ *
+ * NOTE: This command has no buffer format for command itself but response
+ * format is 'struct ice_aqc_acl_generic', pass ptr to that struct
+ * as 'buf' and its size as 'buf_size'
+ */
+enum ice_status
+ice_aq_dealloc_acl_tbl(struct ice_hw *hw, u16 alloc_id,
+		       struct ice_aqc_acl_generic *buf, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_acl_tbl_actpair *cmd;
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_dealloc_acl_tbl);
+	cmd = &desc.params.tbl_actpair;
+	cmd->alloc_id = cpu_to_le16(alloc_id);
+
+	return ice_aq_send_cmd(hw, &desc, buf, sizeof(*buf), cd);
+}
+
+static enum ice_status
+ice_aq_acl_entry(struct ice_hw *hw, u16 opcode, u8 tcam_idx, u16 entry_idx,
+		 struct ice_aqc_acl_data *buf, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_acl_entry *cmd;
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, opcode);
+
+	if (opcode == ice_aqc_opc_program_acl_entry)
+		desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	cmd = &desc.params.program_query_entry;
+	cmd->tcam_index = tcam_idx;
+	cmd->entry_index = cpu_to_le16(entry_idx);
+
+	return ice_aq_send_cmd(hw, &desc, buf, sizeof(*buf), cd);
+}
+
+/**
+ * ice_aq_program_acl_entry - program ACL entry
+ * @hw: pointer to the HW struct
+ * @tcam_idx: Updated TCAM block index
+ * @entry_idx: updated entry index
+ * @buf: address of indirect data buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Program ACL entry (direct 0x0C20)
+ */
+enum ice_status
+ice_aq_program_acl_entry(struct ice_hw *hw, u8 tcam_idx, u16 entry_idx,
+			 struct ice_aqc_acl_data *buf, struct ice_sq_cd *cd)
+{
+	return ice_aq_acl_entry(hw, ice_aqc_opc_program_acl_entry, tcam_idx,
+				entry_idx, buf, cd);
+}
+
+/* Helper function to program/query ACL action pair */
+static enum ice_status
+ice_aq_actpair_p_q(struct ice_hw *hw, u16 opcode, u8 act_mem_idx,
+		   u16 act_entry_idx, struct ice_aqc_actpair *buf,
+		   struct ice_sq_cd *cd)
+{
+	struct ice_aqc_acl_actpair *cmd;
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, opcode);
+
+	if (opcode == ice_aqc_opc_program_acl_actpair)
+		desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	cmd = &desc.params.program_query_actpair;
+	cmd->act_mem_index = act_mem_idx;
+	cmd->act_entry_index = cpu_to_le16(act_entry_idx);
+
+	return ice_aq_send_cmd(hw, &desc, buf, sizeof(*buf), cd);
+}
+
+/**
+ * ice_aq_program_actpair - program ACL actionpair
+ * @hw: pointer to the HW struct
+ * @act_mem_idx: action memory index to program/update/query
+ * @act_entry_idx: the entry index in action memory to be programmed/updated
+ * @buf: address of indirect data buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Program action entries (indirect 0x0C1C)
+ */
+enum ice_status
+ice_aq_program_actpair(struct ice_hw *hw, u8 act_mem_idx, u16 act_entry_idx,
+		       struct ice_aqc_actpair *buf, struct ice_sq_cd *cd)
+{
+	return ice_aq_actpair_p_q(hw, ice_aqc_opc_program_acl_actpair,
+				  act_mem_idx, act_entry_idx, buf, cd);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_acl.h b/drivers/net/ethernet/intel/ice/ice_acl.h
new file mode 100644
index 000000000000..5d39ef59ed5a
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_acl.h
@@ -0,0 +1,125 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018-2020, Intel Corporation. */
+
+#ifndef _ICE_ACL_H_
+#define _ICE_ACL_H_
+
+#include "ice_common.h"
+
+struct ice_acl_tbl_params {
+	u16 width;	/* Select/match bytes */
+	u16 depth;	/* Number of entries */
+
+#define ICE_ACL_TBL_MAX_DEP_TBLS	15
+	u16 dep_tbls[ICE_ACL_TBL_MAX_DEP_TBLS];
+
+	u8 entry_act_pairs;	/* Action pairs per entry */
+	u8 concurr;		/* Concurrent table lookup enable */
+};
+
+struct ice_acl_act_mem {
+	u8 act_mem;
+#define ICE_ACL_ACT_PAIR_MEM_INVAL	0xff
+	u8 member_of_tcam;
+};
+
+struct ice_acl_tbl {
+	/* TCAM configuration */
+	u8 first_tcam;	/* Index of the first TCAM block */
+	u8 last_tcam;	/* Index of the last TCAM block */
+	/* Index of the first entry in the first TCAM */
+	u16 first_entry;
+	/* Index of the last entry in the last TCAM */
+	u16 last_entry;
+
+	/* List of active scenarios */
+	struct list_head scens;
+
+	struct ice_acl_tbl_params info;
+	struct ice_acl_act_mem act_mems[ICE_AQC_MAX_ACTION_MEMORIES];
+
+	/* Keep track of available 64-entry chunks in TCAMs */
+	DECLARE_BITMAP(avail, ICE_AQC_ACL_ALLOC_UNITS);
+
+	u16 id;
+};
+
+enum ice_acl_entry_prio {
+	ICE_ACL_PRIO_LOW = 0,
+	ICE_ACL_PRIO_NORMAL,
+	ICE_ACL_PRIO_HIGH,
+	ICE_ACL_MAX_PRIO
+};
+
+/* Scenario structure
+ * A scenario is a logical partition within an ACL table. It can span more
+ * than one TCAM in cascade mode to support select/mask key widths larger.
+ * than the width of a TCAM. It can also span more than one TCAM in stacked
+ * mode to support larger number of entries than what a TCAM can hold. It is
+ * used to select values from selection bases (field vectors holding extract
+ * protocol header fields) to form lookup keys, and to associate action memory
+ * banks to the TCAMs used.
+ */
+struct ice_acl_scen {
+	struct list_head list_entry;
+	/* If nth bit of act_mem_bitmap is set, then nth action memory will
+	 * participate in this scenario
+	 */
+	DECLARE_BITMAP(act_mem_bitmap, ICE_AQC_MAX_ACTION_MEMORIES);
+	u16 first_idx[ICE_ACL_MAX_PRIO];
+	u16 last_idx[ICE_ACL_MAX_PRIO];
+
+	u16 id;
+	u16 start;	/* Number of entry from the start of the parent table */
+#define ICE_ACL_SCEN_MIN_WIDTH	0x3
+	u16 width;	/* Number of select/mask bytes */
+	u16 num_entry;	/* Number of scenario entry */
+	u16 end;	/* Last addressable entry from start of table */
+	u8 eff_width;	/* Available width in bytes to match */
+#define ICE_ACL_SCEN_PKT_DIR_IDX_IN_TCAM	0x2
+#define ICE_ACL_SCEN_PID_IDX_IN_TCAM		0x3
+#define ICE_ACL_SCEN_RNG_CHK_IDX_IN_TCAM	0x4
+	u8 pid_idx;	/* Byte index used to match profile ID */
+	u8 rng_chk_idx;	/* Byte index used to match range checkers result */
+	u8 pkt_dir_idx;	/* Byte index used to match packet direction */
+};
+
+/* This structure represents input fields needed to allocate ACL table */
+struct ice_acl_alloc_tbl {
+	/* Table's width in number of bytes matched */
+	u16 width;
+	/* Table's depth in number of entries. */
+	u16 depth;
+	u8 num_dependent_alloc_ids;	/* number of depdendent alloc IDs */
+	u8 concurr;			/* true for concurrent table type */
+
+	/* Amount of action pairs per table entry. Minimal valid
+	 * value for this field is 1 (e.g. single pair of actions)
+	 */
+	u8 act_pairs_per_entry;
+	union {
+		struct ice_aqc_acl_alloc_table_data data_buf;
+		struct ice_aqc_acl_generic resp_buf;
+	} buf;
+};
+
+enum ice_status
+ice_acl_create_tbl(struct ice_hw *hw, struct ice_acl_tbl_params *params);
+enum ice_status ice_acl_destroy_tbl(struct ice_hw *hw);
+enum ice_status
+ice_aq_alloc_acl_tbl(struct ice_hw *hw, struct ice_acl_alloc_tbl *tbl,
+		     struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_dealloc_acl_tbl(struct ice_hw *hw, u16 alloc_id,
+		       struct ice_aqc_acl_generic *buf, struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_program_acl_entry(struct ice_hw *hw, u8 tcam_idx, u16 entry_idx,
+			 struct ice_aqc_acl_data *buf, struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_program_actpair(struct ice_hw *hw, u8 act_mem_idx, u16 act_entry_idx,
+		       struct ice_aqc_actpair *buf, struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_alloc_acl_scen(struct ice_hw *hw, u16 *scen_id,
+		      struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd);
+
+#endif /* _ICE_ACL_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c b/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
new file mode 100644
index 000000000000..f8f9aff91c60
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2020, Intel Corporation. */
+
+#include "ice_acl.h"
+
+/* Determine the TCAM index of entry 'e' within the ACL table */
+#define ICE_ACL_TBL_TCAM_IDX(e) ((e) / ICE_AQC_ACL_TCAM_DEPTH)
+
+/**
+ * ice_acl_init_tbl
+ * @hw: pointer to the hardware structure
+ *
+ * Initialize the ACL table by invalidating TCAM entries and action pairs.
+ */
+static enum ice_status ice_acl_init_tbl(struct ice_hw *hw)
+{
+	struct ice_aqc_actpair act_buf;
+	struct ice_aqc_acl_data buf;
+	enum ice_status status = 0;
+	struct ice_acl_tbl *tbl;
+	u8 tcam_idx, i;
+	u16 idx;
+
+	tbl = hw->acl_tbl;
+	if (!tbl)
+		return ICE_ERR_CFG;
+
+	memset(&buf, 0, sizeof(buf));
+	memset(&act_buf, 0, sizeof(act_buf));
+
+	tcam_idx = tbl->first_tcam;
+	idx = tbl->first_entry;
+	while (tcam_idx < tbl->last_tcam ||
+	       (tcam_idx == tbl->last_tcam && idx <= tbl->last_entry)) {
+		/* Use the same value for entry_key and entry_key_inv since
+		 * we are initializing the fields to 0
+		 */
+		status = ice_aq_program_acl_entry(hw, tcam_idx, idx, &buf,
+						  NULL);
+		if (status)
+			return status;
+
+		if (++idx > tbl->last_entry) {
+			tcam_idx++;
+			idx = tbl->first_entry;
+		}
+	}
+
+	for (i = 0; i < ICE_AQC_MAX_ACTION_MEMORIES; i++) {
+		u16 act_entry_idx, start, end;
+
+		if (tbl->act_mems[i].act_mem == ICE_ACL_ACT_PAIR_MEM_INVAL)
+			continue;
+
+		start = tbl->first_entry;
+		end = tbl->last_entry;
+
+		for (act_entry_idx = start; act_entry_idx <= end;
+		     act_entry_idx++) {
+			/* Invalidate all allocated action pairs */
+			status = ice_aq_program_actpair(hw, i, act_entry_idx,
+							&act_buf, NULL);
+			if (status)
+				return status;
+		}
+	}
+
+	return status;
+}
+
+/**
+ * ice_acl_assign_act_mems_to_tcam
+ * @tbl: pointer to ACL table structure
+ * @cur_tcam: Index of current TCAM. Value = 0 to (ICE_AQC_ACL_SLICES - 1)
+ * @cur_mem_idx: Index of current action memory bank. Value = 0 to
+ *		 (ICE_AQC_MAX_ACTION_MEMORIES - 1)
+ * @num_mem: Number of action memory banks for this TCAM
+ *
+ * Assign "num_mem" valid action memory banks from "curr_mem_idx" to
+ * "curr_tcam" TCAM.
+ */
+static void
+ice_acl_assign_act_mems_to_tcam(struct ice_acl_tbl *tbl, u8 cur_tcam,
+				u8 *cur_mem_idx, u8 num_mem)
+{
+	u8 mem_cnt;
+
+	for (mem_cnt = 0;
+	     *cur_mem_idx < ICE_AQC_MAX_ACTION_MEMORIES && mem_cnt < num_mem;
+	     (*cur_mem_idx)++) {
+		struct ice_acl_act_mem *p_mem = &tbl->act_mems[*cur_mem_idx];
+
+		if (p_mem->act_mem == ICE_ACL_ACT_PAIR_MEM_INVAL)
+			continue;
+
+		p_mem->member_of_tcam = cur_tcam;
+
+		mem_cnt++;
+	}
+}
+
+/**
+ * ice_acl_divide_act_mems_to_tcams
+ * @tbl: pointer to ACL table structure
+ *
+ * Figure out how to divide given action memory banks to given TCAMs. This
+ * division is for SW book keeping. In the time when scenario is created,
+ * an action memory bank can be used for different TCAM.
+ *
+ * For example, given that we have 2x2 ACL table with each table entry has
+ * 2 action memory pairs. As the result, we will have 4 TCAMs (T1,T2,T3,T4)
+ * and 4 action memory banks (A1,A2,A3,A4)
+ *	[T1 - T2] { A1 - A2 }
+ *	[T3 - T4] { A3 - A4 }
+ * In the time when we need to create a scenario, for example, 2x1 scenario,
+ * we will use [T3,T4] in a cascaded layout. As it is a requirement that all
+ * action memory banks in a cascaded TCAM's row will need to associate with
+ * the last TCAM. Thus, we will associate action memory banks [A3] and [A4]
+ * for TCAM [T4].
+ * For SW book-keeping purpose, we will keep theoretical maps between TCAM
+ * [Tn] to action memory bank [An].
+ */
+static void ice_acl_divide_act_mems_to_tcams(struct ice_acl_tbl *tbl)
+{
+	u16 num_cscd, stack_level, stack_idx, min_act_mem;
+	u8 tcam_idx = tbl->first_tcam;
+	u16 max_idx_to_get_extra;
+	u8 mem_idx = 0;
+
+	/* Determine number of stacked TCAMs */
+	stack_level = DIV_ROUND_UP(tbl->info.depth, ICE_AQC_ACL_TCAM_DEPTH);
+
+	/* Determine number of cascaded TCAMs */
+	num_cscd = DIV_ROUND_UP(tbl->info.width, ICE_AQC_ACL_KEY_WIDTH_BYTES);
+
+	/* In a line of cascaded TCAM, given the number of action memory
+	 * banks per ACL table entry, we want to fairly divide these action
+	 * memory banks between these TCAMs.
+	 *
+	 * For example, there are 3 TCAMs (TCAM 3,4,5) in a line of
+	 * cascaded TCAM, and there are 7 act_mems for each ACL table entry.
+	 * The result is:
+	 *	[TCAM_3 will have 3 act_mems]
+	 *	[TCAM_4 will have 2 act_mems]
+	 *	[TCAM_5 will have 2 act_mems]
+	 */
+	min_act_mem = tbl->info.entry_act_pairs / num_cscd;
+	max_idx_to_get_extra = tbl->info.entry_act_pairs % num_cscd;
+
+	for (stack_idx = 0; stack_idx < stack_level; stack_idx++) {
+		u16 i;
+
+		for (i = 0; i < num_cscd; i++) {
+			u8 total_act_mem = min_act_mem;
+
+			if (i < max_idx_to_get_extra)
+				total_act_mem++;
+
+			ice_acl_assign_act_mems_to_tcam(tbl, tcam_idx,
+							&mem_idx,
+							total_act_mem);
+
+			tcam_idx++;
+		}
+	}
+}
+
+/**
+ * ice_acl_create_tbl
+ * @hw: pointer to the HW struct
+ * @params: parameters for the table to be created
+ *
+ * Create a LEM table for ACL usage. We are currently starting with some fixed
+ * values for the size of the table, but this will need to grow as more flow
+ * entries are added by the user level.
+ */
+enum ice_status
+ice_acl_create_tbl(struct ice_hw *hw, struct ice_acl_tbl_params *params)
+{
+	u16 width, depth, first_e, last_e, i;
+	struct ice_aqc_acl_generic *resp_buf;
+	struct ice_acl_alloc_tbl tbl_alloc;
+	struct ice_acl_tbl *tbl;
+	enum ice_status status;
+
+	if (hw->acl_tbl)
+		return ICE_ERR_ALREADY_EXISTS;
+
+	if (!params)
+		return ICE_ERR_PARAM;
+
+	/* round up the width to the next TCAM width boundary. */
+	width = roundup(params->width, (u16)ICE_AQC_ACL_KEY_WIDTH_BYTES);
+	/* depth should be provided in chunk (64 entry) increments */
+	depth = ALIGN(params->depth, ICE_ACL_ENTRY_ALLOC_UNIT);
+
+	if (params->entry_act_pairs < width / ICE_AQC_ACL_KEY_WIDTH_BYTES) {
+		params->entry_act_pairs = width / ICE_AQC_ACL_KEY_WIDTH_BYTES;
+
+		if (params->entry_act_pairs > ICE_AQC_TBL_MAX_ACTION_PAIRS)
+			params->entry_act_pairs = ICE_AQC_TBL_MAX_ACTION_PAIRS;
+	}
+
+	/* Validate that width*depth will not exceed the TCAM limit */
+	if ((DIV_ROUND_UP(depth, ICE_AQC_ACL_TCAM_DEPTH) *
+	     (width / ICE_AQC_ACL_KEY_WIDTH_BYTES)) > ICE_AQC_ACL_SLICES)
+		return ICE_ERR_MAX_LIMIT;
+
+	memset(&tbl_alloc, 0, sizeof(tbl_alloc));
+	tbl_alloc.width = width;
+	tbl_alloc.depth = depth;
+	tbl_alloc.act_pairs_per_entry = params->entry_act_pairs;
+	tbl_alloc.concurr = params->concurr;
+	/* Set dependent_alloc_id only for concurrent table type */
+	if (params->concurr) {
+		tbl_alloc.num_dependent_alloc_ids =
+			ICE_AQC_MAX_CONCURRENT_ACL_TBL;
+
+		for (i = 0; i < ICE_AQC_MAX_CONCURRENT_ACL_TBL; i++)
+			tbl_alloc.buf.data_buf.alloc_ids[i] =
+				cpu_to_le16(params->dep_tbls[i]);
+	}
+
+	/* call the AQ command to create the ACL table with these values */
+	status = ice_aq_alloc_acl_tbl(hw, &tbl_alloc, NULL);
+	if (status) {
+		if (le16_to_cpu(tbl_alloc.buf.resp_buf.alloc_id) <
+		    ICE_AQC_ALLOC_ID_LESS_THAN_4K)
+			ice_debug(hw, ICE_DBG_ACL, "Alloc ACL table failed. Unavailable resource.\n");
+		else
+			ice_debug(hw, ICE_DBG_ACL, "AQ allocation of ACL failed with error. status: %d\n",
+				  status);
+		return status;
+	}
+
+	tbl = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*tbl), GFP_KERNEL);
+	if (!tbl)
+		return ICE_ERR_NO_MEMORY;
+
+	resp_buf = &tbl_alloc.buf.resp_buf;
+
+	/* Retrieve information of the allocated table */
+	tbl->id = le16_to_cpu(resp_buf->alloc_id);
+	tbl->first_tcam = resp_buf->ops.table.first_tcam;
+	tbl->last_tcam = resp_buf->ops.table.last_tcam;
+	tbl->first_entry = le16_to_cpu(resp_buf->first_entry);
+	tbl->last_entry = le16_to_cpu(resp_buf->last_entry);
+
+	tbl->info = *params;
+	tbl->info.width = width;
+	tbl->info.depth = depth;
+	hw->acl_tbl = tbl;
+
+	for (i = 0; i < ICE_AQC_MAX_ACTION_MEMORIES; i++)
+		tbl->act_mems[i].act_mem = resp_buf->act_mem[i];
+
+	/* Figure out which TCAMs that these newly allocated action memories
+	 * belong to.
+	 */
+	ice_acl_divide_act_mems_to_tcams(tbl);
+
+	/* Initialize the resources allocated by invalidating all TCAM entries
+	 * and all the action pairs
+	 */
+	status = ice_acl_init_tbl(hw);
+	if (status) {
+		devm_kfree(ice_hw_to_dev(hw), tbl);
+		hw->acl_tbl = NULL;
+		ice_debug(hw, ICE_DBG_ACL, "Initialization of TCAM entries failed. status: %d\n",
+			  status);
+		return status;
+	}
+
+	first_e = (tbl->first_tcam * ICE_AQC_MAX_TCAM_ALLOC_UNITS) +
+		(tbl->first_entry / ICE_ACL_ENTRY_ALLOC_UNIT);
+	last_e = (tbl->last_tcam * ICE_AQC_MAX_TCAM_ALLOC_UNITS) +
+		(tbl->last_entry / ICE_ACL_ENTRY_ALLOC_UNIT);
+
+	/* Indicate available entries in the table */
+	bitmap_set(tbl->avail, first_e, last_e - first_e + 1);
+
+	INIT_LIST_HEAD(&tbl->scens);
+
+	return 0;
+}
+
+/**
+ * ice_acl_destroy_tbl - Destroy a previously created LEM table for ACL
+ * @hw: pointer to the HW struct
+ */
+enum ice_status ice_acl_destroy_tbl(struct ice_hw *hw)
+{
+	struct ice_aqc_acl_generic resp_buf;
+	enum ice_status status;
+
+	if (!hw->acl_tbl)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	/* call the AQ command to destroy the ACL table */
+	status = ice_aq_dealloc_acl_tbl(hw, hw->acl_tbl->id, &resp_buf, NULL);
+	if (status) {
+		ice_debug(hw, ICE_DBG_ACL, "AQ de-allocation of ACL failed. status: %d\n",
+			  status);
+		return status;
+	}
+
+	devm_kfree(ice_hw_to_dev(hw), hw->acl_tbl);
+	hw->acl_tbl = NULL;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index b06fbe99d8e9..688a2069482d 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -327,6 +327,7 @@ struct ice_aqc_vsi_props {
 #define ICE_AQ_VSI_PROP_RXQ_MAP_VALID		BIT(6)
 #define ICE_AQ_VSI_PROP_Q_OPT_VALID		BIT(7)
 #define ICE_AQ_VSI_PROP_OUTER_UP_VALID		BIT(8)
+#define ICE_AQ_VSI_PROP_ACL_VALID		BIT(10)
 #define ICE_AQ_VSI_PROP_FLOW_DIR_VALID		BIT(11)
 #define ICE_AQ_VSI_PROP_PASID_VALID		BIT(12)
 	/* switch section */
@@ -442,8 +443,12 @@ struct ice_aqc_vsi_props {
 	u8 q_opt_reserved[3];
 	/* outer up section */
 	__le32 outer_up_table; /* same structure and defines as ingress tbl */
-	/* section 10 */
-	__le16 sect_10_reserved;
+	/* ACL section */
+	__le16 acl_def_act;
+#define ICE_AQ_VSI_ACL_DEF_RX_PROF_S	0
+#define ICE_AQ_VSI_ACL_DEF_RX_PROF_M	(0xF << ICE_AQ_VSI_ACL_DEF_RX_PROF_S)
+#define ICE_AQ_VSI_ACL_DEF_RX_TABLE_S	4
+#define ICE_AQ_VSI_ACL_DEF_RX_TABLE_M	(0xF << ICE_AQ_VSI_ACL_DEF_RX_TABLE_S)
 	/* flow director section */
 	__le16 fd_options;
 #define ICE_AQ_VSI_FD_ENABLE		BIT(0)
@@ -1612,6 +1617,200 @@ struct ice_aqc_get_set_rss_lut {
 	__le32 addr_low;
 };
 
+/* Allocate ACL table (indirect 0x0C10) */
+#define ICE_AQC_ACL_KEY_WIDTH_BYTES	5
+#define ICE_AQC_ACL_TCAM_DEPTH		512
+#define ICE_ACL_ENTRY_ALLOC_UNIT	64
+#define ICE_AQC_MAX_CONCURRENT_ACL_TBL	15
+#define ICE_AQC_MAX_ACTION_MEMORIES	20
+#define ICE_AQC_ACL_SLICES		16
+#define ICE_AQC_ALLOC_ID_LESS_THAN_4K	0x1000
+/* The ACL block supports up to 8 actions per a single output. */
+#define ICE_AQC_TBL_MAX_ACTION_PAIRS	4
+
+#define ICE_AQC_MAX_TCAM_ALLOC_UNITS	(ICE_AQC_ACL_TCAM_DEPTH / \
+					 ICE_ACL_ENTRY_ALLOC_UNIT)
+#define ICE_AQC_ACL_ALLOC_UNITS		(ICE_AQC_ACL_SLICES * \
+					 ICE_AQC_MAX_TCAM_ALLOC_UNITS)
+
+struct ice_aqc_acl_alloc_table {
+	__le16 table_width;
+	__le16 table_depth;
+	u8 act_pairs_per_entry;
+	u8 table_type;
+	__le16 reserved;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* Allocate ACL table command buffer format */
+struct ice_aqc_acl_alloc_table_data {
+	/* Dependent table AllocIDs. Each word in this 15 word array specifies
+	 * a dependent table AllocID according to the amount specified in the
+	 * "table_type" field. All unused words shall be set to 0xFFFF
+	 */
+#define ICE_AQC_CONCURR_ID_INVALID	0xffff
+	__le16 alloc_ids[ICE_AQC_MAX_CONCURRENT_ACL_TBL];
+};
+
+/* Deallocate ACL table (indirect 0x0C11) */
+
+/* Following structure is common and used in case of deallocation
+ * of ACL table and action-pair
+ */
+struct ice_aqc_acl_tbl_actpair {
+	/* Alloc ID of the table being released */
+	__le16 alloc_id;
+	u8 reserved[6];
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* This response structure is same in case of alloc/dealloc table,
+ * alloc/dealloc action-pair
+ */
+struct ice_aqc_acl_generic {
+	/* if alloc_id is below 0x1000 then allocation failed due to
+	 * unavailable resources, else this is set by FW to identify
+	 * table allocation
+	 */
+	__le16 alloc_id;
+
+	union {
+		/* to be used only in case of alloc/dealloc table */
+		struct {
+			/* Index of the first TCAM block, otherwise set to 0xFF
+			 * for a failed allocation
+			 */
+			u8 first_tcam;
+			/* Index of the last TCAM block. This index shall be
+			 * set to the value of first_tcam for single TCAM block
+			 * allocation, otherwise set to 0xFF for a failed
+			 * allocation
+			 */
+			u8 last_tcam;
+		} table;
+		/* reserved in case of alloc/dealloc action-pair */
+		struct {
+			__le16 reserved;
+		} act_pair;
+	} ops;
+
+	/* index of first entry (in both TCAM and action memories),
+	 * otherwise set to 0xFF for a failed allocation
+	 */
+	__le16 first_entry;
+	/* index of last entry (in both TCAM and action memories),
+	 * otherwise set to 0xFF for a failed allocation
+	 */
+	__le16 last_entry;
+
+	/* Each act_mem element specifies the order of the memory
+	 * otherwise 0xFF
+	 */
+	u8 act_mem[ICE_AQC_MAX_ACTION_MEMORIES];
+};
+
+/* Update ACL scenario (direct 0x0C1B)
+ * Query ACL scenario (direct 0x0C23)
+ */
+struct ice_aqc_acl_update_query_scen {
+	__le16 scen_id;
+	u8 reserved[6];
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* Input buffer format in case allocate/update ACL scenario and same format
+ * is used for response buffer in case of query ACL scenario.
+ * NOTE: de-allocate ACL scenario is direct command and doesn't require
+ * "buffer", hence no buffer format.
+ */
+struct ice_aqc_acl_scen {
+	struct {
+		/* Byte [x] selection for the TCAM key. This value must be set
+		 * to 0x0 for unused TCAM.
+		 * Only Bit 6..0 is used in each byte and MSB is reserved
+		 */
+#define ICE_AQC_ACL_BYTE_SEL_BASE		0x20
+#define ICE_AQC_ACL_BYTE_SEL_BASE_PID		0x3E
+#define ICE_AQC_ACL_BYTE_SEL_BASE_PKT_DIR	ICE_AQC_ACL_BYTE_SEL_BASE
+#define ICE_AQC_ACL_BYTE_SEL_BASE_RNG_CHK	0x3F
+		u8 tcam_select[5];
+		/* TCAM Block entry masking. This value should be set to 0x0 for
+		 * unused TCAM
+		 */
+		u8 chnk_msk;
+		/* Bit 0 : masks TCAM entries 0-63
+		 * Bit 1 : masks TCAM entries 64-127
+		 * Bit 2 to 7 : follow the pattern of bit 0 and 1
+		 */
+#define ICE_AQC_ACL_ALLOC_SCE_START_CMP		BIT(0)
+#define ICE_AQC_ACL_ALLOC_SCE_START_SET		BIT(1)
+		u8 start_cmp_set;
+	} tcam_cfg[ICE_AQC_ACL_SLICES];
+
+	/* Each byte, Bit 6..0: Action memory association to a TCAM block,
+	 * otherwise it shall be set to 0x0 for disabled memory action.
+	 * Bit 7 : Action memory enable for this scenario
+	 */
+#define ICE_AQC_ACL_SCE_ACT_MEM_EN		BIT(7)
+	u8 act_mem_cfg[ICE_AQC_MAX_ACTION_MEMORIES];
+};
+
+/* Program ACL actionpair (indirect 0x0C1C) */
+struct ice_aqc_acl_actpair {
+	/* action mem index to program/update */
+	u8 act_mem_index;
+	u8 reserved;
+	/* The entry index in action memory to be programmed/updated */
+	__le16 act_entry_index;
+	__le32 reserved2;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* Input buffer format for program/query action-pair admin command */
+struct ice_acl_act_entry {
+	/* Action priority, values must be between 0..7 */
+	u8 prio;
+	/* Action meta-data identifier. This field should be set to 0x0
+	 * for a NOP action
+	 */
+	u8 mdid;
+	/* Action value */
+	__le16 value;
+};
+
+#define ICE_ACL_NUM_ACT_PER_ACT_PAIR 2
+struct ice_aqc_actpair {
+	struct ice_acl_act_entry act[ICE_ACL_NUM_ACT_PER_ACT_PAIR];
+};
+
+/* Program ACL entry (indirect 0x0C20) */
+struct ice_aqc_acl_entry {
+	u8 tcam_index; /* Updated TCAM block index */
+	u8 reserved;
+	__le16 entry_index; /* Updated entry index */
+	__le32 reserved2;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* Input buffer format in case of program ACL entry and response buffer format
+ * in case of query ACL entry
+ */
+struct ice_aqc_acl_data {
+	/* Entry key and entry key invert are 40 bits wide.
+	 * Byte 0..4 : entry key and Byte 5..7 are reserved
+	 * Byte 8..12: entry key invert and Byte 13..15 are reserved
+	 */
+	struct {
+		u8 val[5];
+		u8 reserved[3];
+	} entry_key, entry_key_invert;
+};
+
 /* Add Tx LAN Queues (indirect 0x0C30) */
 struct ice_aqc_add_txqs {
 	u8 num_qgrps;
@@ -1880,6 +2079,11 @@ struct ice_aq_desc {
 		struct ice_aqc_lldp_stop_start_specific_agent lldp_agent_ctrl;
 		struct ice_aqc_get_set_rss_lut get_set_rss_lut;
 		struct ice_aqc_get_set_rss_key get_set_rss_key;
+		struct ice_aqc_acl_alloc_table alloc_table;
+		struct ice_aqc_acl_tbl_actpair tbl_actpair;
+		struct ice_aqc_acl_update_query_scen update_query_scen;
+		struct ice_aqc_acl_entry program_query_entry;
+		struct ice_aqc_acl_actpair program_query_actpair;
 		struct ice_aqc_add_txqs add_txqs;
 		struct ice_aqc_dis_txqs dis_txqs;
 		struct ice_aqc_add_get_update_free_vsi vsi_cmd;
@@ -2024,6 +2228,13 @@ enum ice_adminq_opc {
 	ice_aqc_opc_set_rss_lut				= 0x0B03,
 	ice_aqc_opc_get_rss_key				= 0x0B04,
 	ice_aqc_opc_get_rss_lut				= 0x0B05,
+	/* ACL commands */
+	ice_aqc_opc_alloc_acl_tbl			= 0x0C10,
+	ice_aqc_opc_dealloc_acl_tbl			= 0x0C11,
+	ice_aqc_opc_update_acl_scen			= 0x0C1B,
+	ice_aqc_opc_program_acl_actpair			= 0x0C1C,
+	ice_aqc_opc_program_acl_entry			= 0x0C20,
+	ice_aqc_opc_query_acl_scen			= 0x0C23,
 
 	/* Tx queue handling commands/events */
 	ice_aqc_opc_add_txqs				= 0x0C30,
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 829f90b1e998..875e8b8f1c84 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -4,6 +4,8 @@
 #ifndef _ICE_FLOW_H_
 #define _ICE_FLOW_H_
 
+#include "ice_acl.h"
+
 #define ICE_FLOW_ENTRY_HANDLE_INVAL	0
 #define ICE_FLOW_FLD_OFF_INVAL		0xffff
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2dea4d0e9415..a49751f6951a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3822,6 +3822,48 @@ static enum ice_status ice_send_version(struct ice_pf *pf)
 	return ice_aq_send_driver_ver(&pf->hw, &dv, NULL);
 }
 
+/**
+ * ice_init_acl - Initializes the ACL block
+ * @pf: ptr to PF device
+ *
+ * returns 0 on success, negative on error
+ */
+static int ice_init_acl(struct ice_pf *pf)
+{
+	struct ice_acl_tbl_params params;
+	struct ice_hw *hw = &pf->hw;
+	int divider;
+
+	/* Creates a single ACL table that consist of src_ip(4 byte),
+	 * dest_ip(4 byte), src_port(2 byte) and dst_port(2 byte) for a total
+	 * of 12 bytes (96 bits), hence 120 bit wide keys, i.e. 3 TCAM slices.
+	 * If the given hardware card contains less than 8 PFs (ports) then
+	 * each PF will have its own TCAM slices. For 8 PFs, a given slice will
+	 * be shared by 2 different PFs.
+	 */
+	if (hw->dev_caps.num_funcs < 8)
+		divider = ICE_ACL_ENTIRE_SLICE;
+	else
+		divider = ICE_ACL_HALF_SLICE;
+
+	memset(&params, 0, sizeof(params));
+	params.width = ICE_AQC_ACL_KEY_WIDTH_BYTES * 3;
+	params.depth = ICE_AQC_ACL_TCAM_DEPTH / divider;
+	params.entry_act_pairs = 1;
+	params.concurr = false;
+
+	return ice_status_to_errno(ice_acl_create_tbl(hw, &params));
+}
+
+/**
+ * ice_deinit_acl - Unroll the initialization of the ACL block
+ * @pf: ptr to PF device
+ */
+static void ice_deinit_acl(struct ice_pf *pf)
+{
+	ice_acl_destroy_tbl(&pf->hw);
+}
+
 /**
  * ice_init_fdir - Initialize flow director VSI and configuration
  * @pf: pointer to the PF instance
@@ -4231,6 +4273,12 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	/* Note: Flow director init failure is non-fatal to load */
 	if (ice_init_fdir(pf))
 		dev_err(dev, "could not initialize flow director\n");
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
+		/* Note: ACL init failure is non-fatal to load */
+		err = ice_init_acl(pf);
+		if (err)
+			dev_err(dev, "Failed to initialize ACL: %d\n", err);
+	}
 
 	/* Note: DCB init failure is non-fatal to load */
 	if (ice_init_pf_dcb(pf, false)) {
@@ -4361,6 +4409,8 @@ static void ice_remove(struct pci_dev *pdev)
 
 	ice_aq_cancel_waiting_tasks(pf);
 
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags))
+		ice_deinit_acl(pf);
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 	if (!ice_is_safe_mode(pf))
 		ice_remove_arfs(pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 2226a291a394..a1600c7e8b17 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -47,6 +47,7 @@ static inline u32 ice_round_to_num(u32 N, u32 R)
 #define ICE_DBG_SCHED		BIT_ULL(14)
 #define ICE_DBG_PKG		BIT_ULL(16)
 #define ICE_DBG_RES		BIT_ULL(17)
+#define ICE_DBG_ACL		BIT_ULL(18)
 #define ICE_DBG_AQ_MSG		BIT_ULL(24)
 #define ICE_DBG_AQ_DESC		BIT_ULL(25)
 #define ICE_DBG_AQ_DESC_BUF	BIT_ULL(26)
@@ -679,6 +680,8 @@ struct ice_hw {
 	struct udp_tunnel_nic_shared udp_tunnel_shared;
 	struct udp_tunnel_nic_info udp_tunnel_nic;
 
+	struct ice_acl_tbl *acl_tbl;
+
 	/* HW block tables */
 	struct ice_blk_info blk[ICE_BLK_COUNT];
 	struct mutex fl_profs_locks[ICE_BLK_COUNT];	/* lock fltr profiles */
-- 
2.26.2

