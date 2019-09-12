Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053DAB1594
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 22:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfILUuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 16:50:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:59558 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbfILUuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 16:50:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 13:50:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="197345140"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 12 Sep 2019 13:50:04 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 4/6] ice: Initialize DDP package structures
Date:   Thu, 12 Sep 2019 13:50:00 -0700
Message-Id: <20190912205002.12159-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
References: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

Add functions to initialize, parse, and clean structures representing
the DDP package.

Upon completion of package download, read and store the DDP package
contents to these structures.  This configuration is used to
identify the default behavior and later used to update the HW table
entries.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   |   5 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 945 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   3 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |   2 +
 4 files changed, 953 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 20956643036c..91472e049231 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -882,7 +882,9 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 
 	ice_init_flex_flds(hw, ICE_RXDID_FLEX_NIC);
 	ice_init_flex_flds(hw, ICE_RXDID_FLEX_NIC_2);
-
+	status = ice_init_hw_tbls(hw);
+	if (status)
+		goto err_unroll_fltr_mgmt_struct;
 	return 0;
 
 err_unroll_fltr_mgmt_struct:
@@ -911,6 +913,7 @@ void ice_deinit_hw(struct ice_hw *hw)
 	ice_sched_cleanup_all(hw);
 	ice_sched_clear_agg(hw);
 	ice_free_seg(hw);
+	ice_free_hw_tbls(hw);
 
 	if (hw->port_info) {
 		devm_kfree(ice_hw_to_dev(hw), hw->port_info);
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 4e965dc5eb93..cc8922bd61b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -4,6 +4,33 @@
 #include "ice_common.h"
 #include "ice_flex_pipe.h"
 
+static void ice_fill_blk_tbls(struct ice_hw *hw);
+
+/**
+ * ice_pkg_val_buf
+ * @buf: pointer to the ice buffer
+ *
+ * This helper function validates a buffer's header.
+ */
+static struct ice_buf_hdr *ice_pkg_val_buf(struct ice_buf *buf)
+{
+	struct ice_buf_hdr *hdr;
+	u16 section_count;
+	u16 data_end;
+
+	hdr = (struct ice_buf_hdr *)buf->buf;
+	/* verify data */
+	section_count = le16_to_cpu(hdr->section_count);
+	if (section_count < ICE_MIN_S_COUNT || section_count > ICE_MAX_S_COUNT)
+		return NULL;
+
+	data_end = le16_to_cpu(hdr->data_end);
+	if (data_end < ICE_MIN_S_DATA_END || data_end > ICE_MAX_S_DATA_END)
+		return NULL;
+
+	return hdr;
+}
+
 /**
  * ice_find_buf_table
  * @ice_seg: pointer to the ice segment
@@ -22,6 +49,117 @@ static struct ice_buf_table *ice_find_buf_table(struct ice_seg *ice_seg)
 		(nvms->vers + le32_to_cpu(nvms->table_count));
 }
 
+/**
+ * ice_pkg_enum_buf
+ * @ice_seg: pointer to the ice segment (or NULL on subsequent calls)
+ * @state: pointer to the enum state
+ *
+ * This function will enumerate all the buffers in the ice segment. The first
+ * call is made with the ice_seg parameter non-NULL; on subsequent calls,
+ * ice_seg is set to NULL which continues the enumeration. When the function
+ * returns a NULL pointer, then the end of the buffers has been reached, or an
+ * unexpected value has been detected (for example an invalid section count or
+ * an invalid buffer end value).
+ */
+static struct ice_buf_hdr *
+ice_pkg_enum_buf(struct ice_seg *ice_seg, struct ice_pkg_enum *state)
+{
+	if (ice_seg) {
+		state->buf_table = ice_find_buf_table(ice_seg);
+		if (!state->buf_table)
+			return NULL;
+
+		state->buf_idx = 0;
+		return ice_pkg_val_buf(state->buf_table->buf_array);
+	}
+
+	if (++state->buf_idx < le32_to_cpu(state->buf_table->buf_count))
+		return ice_pkg_val_buf(state->buf_table->buf_array +
+				       state->buf_idx);
+	else
+		return NULL;
+}
+
+/**
+ * ice_pkg_advance_sect
+ * @ice_seg: pointer to the ice segment (or NULL on subsequent calls)
+ * @state: pointer to the enum state
+ *
+ * This helper function will advance the section within the ice segment,
+ * also advancing the buffer if needed.
+ */
+static bool
+ice_pkg_advance_sect(struct ice_seg *ice_seg, struct ice_pkg_enum *state)
+{
+	if (!ice_seg && !state->buf)
+		return false;
+
+	if (!ice_seg && state->buf)
+		if (++state->sect_idx < le16_to_cpu(state->buf->section_count))
+			return true;
+
+	state->buf = ice_pkg_enum_buf(ice_seg, state);
+	if (!state->buf)
+		return false;
+
+	/* start of new buffer, reset section index */
+	state->sect_idx = 0;
+	return true;
+}
+
+/**
+ * ice_pkg_enum_section
+ * @ice_seg: pointer to the ice segment (or NULL on subsequent calls)
+ * @state: pointer to the enum state
+ * @sect_type: section type to enumerate
+ *
+ * This function will enumerate all the sections of a particular type in the
+ * ice segment. The first call is made with the ice_seg parameter non-NULL;
+ * on subsequent calls, ice_seg is set to NULL which continues the enumeration.
+ * When the function returns a NULL pointer, then the end of the matching
+ * sections has been reached.
+ */
+static void *
+ice_pkg_enum_section(struct ice_seg *ice_seg, struct ice_pkg_enum *state,
+		     u32 sect_type)
+{
+	u16 offset, size;
+
+	if (ice_seg)
+		state->type = sect_type;
+
+	if (!ice_pkg_advance_sect(ice_seg, state))
+		return NULL;
+
+	/* scan for next matching section */
+	while (state->buf->section_entry[state->sect_idx].type !=
+	       cpu_to_le32(state->type))
+		if (!ice_pkg_advance_sect(NULL, state))
+			return NULL;
+
+	/* validate section */
+	offset = le16_to_cpu(state->buf->section_entry[state->sect_idx].offset);
+	if (offset < ICE_MIN_S_OFF || offset > ICE_MAX_S_OFF)
+		return NULL;
+
+	size = le16_to_cpu(state->buf->section_entry[state->sect_idx].size);
+	if (size < ICE_MIN_S_SZ || size > ICE_MAX_S_SZ)
+		return NULL;
+
+	/* make sure the section fits in the buffer */
+	if (offset + size > ICE_PKG_BUF_SIZE)
+		return NULL;
+
+	state->sect_type =
+		le32_to_cpu(state->buf->section_entry[state->sect_idx].type);
+
+	/* calc pointer to this section */
+	state->sect = ((u8 *)state->buf) +
+		le16_to_cpu(state->buf->section_entry[state->sect_idx].offset);
+
+	return state->sect;
+}
+
 /**
  * ice_acquire_global_cfg_lock
  * @hw: pointer to the HW structure
@@ -458,6 +596,21 @@ void ice_free_seg(struct ice_hw *hw)
 	hw->seg = NULL;
 }
 
+/**
+ * ice_init_pkg_regs - initialize additional package registers
+ * @hw: pointer to the hardware structure
+ */
+static void ice_init_pkg_regs(struct ice_hw *hw)
+{
+#define ICE_SW_BLK_INP_MASK_L 0xFFFFFFFF
+#define ICE_SW_BLK_INP_MASK_H 0x0000FFFF
+#define ICE_SW_BLK_IDX	0
+
+	/* setup Switch block input mask, which is 48-bits in two parts */
+	wr32(hw, GL_PREEXT_L2_PMASK0(ICE_SW_BLK_IDX), ICE_SW_BLK_INP_MASK_L);
+	wr32(hw, GL_PREEXT_L2_PMASK1(ICE_SW_BLK_IDX), ICE_SW_BLK_INP_MASK_H);
+}
+
 /**
  * ice_chk_pkg_version - check package version for compatibility with driver
  * @pkg_ver: pointer to a version structure to check
@@ -554,9 +707,18 @@ enum ice_status ice_init_pkg(struct ice_hw *hw, u8 *buf, u32 len)
 			status = ice_chk_pkg_version(&hw->active_pkg_ver);
 	}
 
-	if (status)
+	if (!status) {
+		hw->seg = seg;
+		/* on successful package download update other required
+		 * registers to support the package and fill HW tables
+		 * with package content.
+		 */
+		ice_init_pkg_regs(hw);
+		ice_fill_blk_tbls(hw);
+	} else {
 		ice_debug(hw, ICE_DBG_INIT, "package load failed, %d\n",
 			  status);
+	}
 
 	return status;
 }
@@ -606,3 +768,784 @@ enum ice_status ice_copy_and_init_pkg(struct ice_hw *hw, const u8 *buf, u32 len)
 
 	return status;
 }
+
+/* PTG Management */
+
+/**
+ * ice_ptg_find_ptype - Search for packet type group using packet type (ptype)
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @ptype: the ptype to search for
+ * @ptg: pointer to variable that receives the PTG
+ *
+ * This function will search the PTGs for a particular ptype, returning the
+ * PTG ID that contains it through the PTG parameter, with the value of
+ * ICE_DEFAULT_PTG (0) meaning it is part the default PTG.
+ */
+static enum ice_status
+ice_ptg_find_ptype(struct ice_hw *hw, enum ice_block blk, u16 ptype, u8 *ptg)
+{
+	if (ptype >= ICE_XLT1_CNT || !ptg)
+		return ICE_ERR_PARAM;
+
+	*ptg = hw->blk[blk].xlt1.ptypes[ptype].ptg;
+	return 0;
+}
+
+/**
+ * ice_ptg_alloc_val - Allocates a new packet type group ID by value
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @ptg: the PTG to allocate
+ *
+ * This function allocates a given packet type group ID specified by the PTG
+ * parameter.
+ */
+static void ice_ptg_alloc_val(struct ice_hw *hw, enum ice_block blk, u8 ptg)
+{
+	hw->blk[blk].xlt1.ptg_tbl[ptg].in_use = true;
+}
+
+/**
+ * ice_ptg_remove_ptype - Removes ptype from a particular packet type group
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @ptype: the ptype to remove
+ * @ptg: the PTG to remove the ptype from
+ *
+ * This function will remove the ptype from the specific PTG, and move it to
+ * the default PTG (ICE_DEFAULT_PTG).
+ */
+static enum ice_status
+ice_ptg_remove_ptype(struct ice_hw *hw, enum ice_block blk, u16 ptype, u8 ptg)
+{
+	struct ice_ptg_ptype **ch;
+	struct ice_ptg_ptype *p;
+
+	if (ptype > ICE_XLT1_CNT - 1)
+		return ICE_ERR_PARAM;
+
+	if (!hw->blk[blk].xlt1.ptg_tbl[ptg].in_use)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	/* Should not happen if .in_use is set, bad config */
+	if (!hw->blk[blk].xlt1.ptg_tbl[ptg].first_ptype)
+		return ICE_ERR_CFG;
+
+	/* find the ptype within this PTG, and bypass the link over it */
+	p = hw->blk[blk].xlt1.ptg_tbl[ptg].first_ptype;
+	ch = &hw->blk[blk].xlt1.ptg_tbl[ptg].first_ptype;
+	while (p) {
+		if (ptype == (p - hw->blk[blk].xlt1.ptypes)) {
+			*ch = p->next_ptype;
+			break;
+		}
+
+		ch = &p->next_ptype;
+		p = p->next_ptype;
+	}
+
+	hw->blk[blk].xlt1.ptypes[ptype].ptg = ICE_DEFAULT_PTG;
+	hw->blk[blk].xlt1.ptypes[ptype].next_ptype = NULL;
+
+	return 0;
+}
+
+/**
+ * ice_ptg_add_mv_ptype - Adds/moves ptype to a particular packet type group
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @ptype: the ptype to add or move
+ * @ptg: the PTG to add or move the ptype to
+ *
+ * This function will either add or move a ptype to a particular PTG depending
+ * on if the ptype is already part of another group. Note that using a
+ * a destination PTG ID of ICE_DEFAULT_PTG (0) will move the ptype to the
+ * default PTG.
+ */
+static enum ice_status
+ice_ptg_add_mv_ptype(struct ice_hw *hw, enum ice_block blk, u16 ptype, u8 ptg)
+{
+	enum ice_status status;
+	u8 original_ptg;
+
+	if (ptype > ICE_XLT1_CNT - 1)
+		return ICE_ERR_PARAM;
+
+	if (!hw->blk[blk].xlt1.ptg_tbl[ptg].in_use && ptg != ICE_DEFAULT_PTG)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	status = ice_ptg_find_ptype(hw, blk, ptype, &original_ptg);
+	if (status)
+		return status;
+
+	/* Is ptype already in the correct PTG? */
+	if (original_ptg == ptg)
+		return 0;
+
+	/* Remove from original PTG and move back to the default PTG */
+	if (original_ptg != ICE_DEFAULT_PTG)
+		ice_ptg_remove_ptype(hw, blk, ptype, original_ptg);
+
+	/* Moving to default PTG? Then we're done with this request */
+	if (ptg == ICE_DEFAULT_PTG)
+		return 0;
+
+	/* Add ptype to PTG at beginning of list */
+	hw->blk[blk].xlt1.ptypes[ptype].next_ptype =
+		hw->blk[blk].xlt1.ptg_tbl[ptg].first_ptype;
+	hw->blk[blk].xlt1.ptg_tbl[ptg].first_ptype =
+		&hw->blk[blk].xlt1.ptypes[ptype];
+
+	hw->blk[blk].xlt1.ptypes[ptype].ptg = ptg;
+	hw->blk[blk].xlt1.t[ptype] = ptg;
+
+	return 0;
+}
+
+/* Block / table size info */
+struct ice_blk_size_details {
+	u16 xlt1;			/* # XLT1 entries */
+	u16 xlt2;			/* # XLT2 entries */
+	u16 prof_tcam;			/* # profile ID TCAM entries */
+	u16 prof_id;			/* # profile IDs */
+	u8 prof_cdid_bits;		/* # CDID one-hot bits used in key */
+	u16 prof_redir;			/* # profile redirection entries */
+	u16 es;				/* # extraction sequence entries */
+	u16 fvw;			/* # field vector words */
+	u8 overwrite;			/* overwrite existing entries allowed */
+	u8 reverse;			/* reverse FV order */
+};
+
+static const struct ice_blk_size_details blk_sizes[ICE_BLK_COUNT] = {
+	/**
+	 * Table Definitions
+	 * XLT1 - Number of entries in XLT1 table
+	 * XLT2 - Number of entries in XLT2 table
+	 * TCAM - Number of entries Profile ID TCAM table
+	 * CDID - Control Domain ID of the hardware block
+	 * PRED - Number of entries in the Profile Redirection Table
+	 * FV   - Number of entries in the Field Vector
+	 * FVW  - Width (in WORDs) of the Field Vector
+	 * OVR  - Overwrite existing table entries
+	 * REV  - Reverse FV
+	 */
+	/*          XLT1        , XLT2        ,TCAM, PID,CDID,PRED,   FV, FVW */
+	/*          Overwrite   , Reverse FV */
+	/* SW  */ { ICE_XLT1_CNT, ICE_XLT2_CNT, 512, 256,   0,  256, 256,  48,
+		    false, false },
+	/* ACL */ { ICE_XLT1_CNT, ICE_XLT2_CNT, 512, 128,   0,  128, 128,  32,
+		    false, false },
+	/* FD  */ { ICE_XLT1_CNT, ICE_XLT2_CNT, 512, 128,   0,  128, 128,  24,
+		    false, true  },
+	/* RSS */ { ICE_XLT1_CNT, ICE_XLT2_CNT, 512, 128,   0,  128, 128,  24,
+		    true,  true  },
+	/* PE  */ { ICE_XLT1_CNT, ICE_XLT2_CNT,  64,  32,   0,   32,  32,  24,
+		    false, false },
+};
+
+enum ice_sid_all {
+	ICE_SID_XLT1_OFF = 0,
+	ICE_SID_XLT2_OFF,
+	ICE_SID_PR_OFF,
+	ICE_SID_PR_REDIR_OFF,
+	ICE_SID_ES_OFF,
+	ICE_SID_OFF_COUNT,
+};
+
+/* VSIG Management */
+
+/**
+ * ice_vsig_find_vsi - find a VSIG that contains a specified VSI
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @vsi: VSI of interest
+ * @vsig: pointer to receive the VSI group
+ *
+ * This function will lookup the VSI entry in the XLT2 list and return
+ * the VSI group its associated with.
+ */
+static enum ice_status
+ice_vsig_find_vsi(struct ice_hw *hw, enum ice_block blk, u16 vsi, u16 *vsig)
+{
+	if (!vsig || vsi >= ICE_MAX_VSI)
+		return ICE_ERR_PARAM;
+
+	/* As long as there's a default or valid VSIG associated with the input
+	 * VSI, the functions returns a success. Any handling of VSIG will be
+	 * done by the following add, update or remove functions.
+	 */
+	*vsig = hw->blk[blk].xlt2.vsis[vsi].vsig;
+
+	return 0;
+}
+
+/**
+ * ice_vsig_alloc_val - allocate a new VSIG by value
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @vsig: the VSIG to allocate
+ *
+ * This function will allocate a given VSIG specified by the VSIG parameter.
+ */
+static u16 ice_vsig_alloc_val(struct ice_hw *hw, enum ice_block blk, u16 vsig)
+{
+	u16 idx = vsig & ICE_VSIG_IDX_M;
+
+	if (!hw->blk[blk].xlt2.vsig_tbl[idx].in_use) {
+		INIT_LIST_HEAD(&hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst);
+		hw->blk[blk].xlt2.vsig_tbl[idx].in_use = true;
+	}
+
+	return ICE_VSIG_VALUE(idx, hw->pf_id);
+}
+
+/**
+ * ice_vsig_remove_vsi - remove VSI from VSIG
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @vsi: VSI to remove
+ * @vsig: VSI group to remove from
+ *
+ * The function will remove the input VSI from its VSI group and move it
+ * to the DEFAULT_VSIG.
+ */
+static enum ice_status
+ice_vsig_remove_vsi(struct ice_hw *hw, enum ice_block blk, u16 vsi, u16 vsig)
+{
+	struct ice_vsig_vsi **vsi_head, *vsi_cur, *vsi_tgt;
+	u16 idx;
+
+	idx = vsig & ICE_VSIG_IDX_M;
+
+	if (vsi >= ICE_MAX_VSI || idx >= ICE_MAX_VSIGS)
+		return ICE_ERR_PARAM;
+
+	if (!hw->blk[blk].xlt2.vsig_tbl[idx].in_use)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	/* entry already in default VSIG, don't have to remove */
+	if (idx == ICE_DEFAULT_VSIG)
+		return 0;
+
+	vsi_head = &hw->blk[blk].xlt2.vsig_tbl[idx].first_vsi;
+	if (!(*vsi_head))
+		return ICE_ERR_CFG;
+
+	vsi_tgt = &hw->blk[blk].xlt2.vsis[vsi];
+	vsi_cur = (*vsi_head);
+
+	/* iterate the VSI list, skip over the entry to be removed */
+	while (vsi_cur) {
+		if (vsi_tgt == vsi_cur) {
+			(*vsi_head) = vsi_cur->next_vsi;
+			break;
+		}
+		vsi_head = &vsi_cur->next_vsi;
+		vsi_cur = vsi_cur->next_vsi;
+	}
+
+	/* verify if VSI was removed from group list */
+	if (!vsi_cur)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	vsi_cur->vsig = ICE_DEFAULT_VSIG;
+	vsi_cur->changed = 1;
+	vsi_cur->next_vsi = NULL;
+
+	return 0;
+}
+
+/**
+ * ice_vsig_add_mv_vsi - add or move a VSI to a VSI group
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @vsi: VSI to move
+ * @vsig: destination VSI group
+ *
+ * This function will move or add the input VSI to the target VSIG.
+ * The function will find the original VSIG the VSI belongs to and
+ * move the entry to the DEFAULT_VSIG, update the original VSIG and
+ * then move entry to the new VSIG.
+ */
+static enum ice_status
+ice_vsig_add_mv_vsi(struct ice_hw *hw, enum ice_block blk, u16 vsi, u16 vsig)
+{
+	struct ice_vsig_vsi *tmp;
+	enum ice_status status;
+	u16 orig_vsig, idx;
+
+	idx = vsig & ICE_VSIG_IDX_M;
+
+	if (vsi >= ICE_MAX_VSI || idx >= ICE_MAX_VSIGS)
+		return ICE_ERR_PARAM;
+
+	/* if VSIG not in use and VSIG is not default type this VSIG
+	 * doesn't exist.
+	 */
+	if (!hw->blk[blk].xlt2.vsig_tbl[idx].in_use &&
+	    vsig != ICE_DEFAULT_VSIG)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	status = ice_vsig_find_vsi(hw, blk, vsi, &orig_vsig);
+	if (status)
+		return status;
+
+	/* no update required if vsigs match */
+	if (orig_vsig == vsig)
+		return 0;
+
+	if (orig_vsig != ICE_DEFAULT_VSIG) {
+		/* remove entry from orig_vsig and add to default VSIG */
+		status = ice_vsig_remove_vsi(hw, blk, vsi, orig_vsig);
+		if (status)
+			return status;
+	}
+
+	if (idx == ICE_DEFAULT_VSIG)
+		return 0;
+
+	/* Create VSI entry and add VSIG and prop_mask values */
+	hw->blk[blk].xlt2.vsis[vsi].vsig = vsig;
+	hw->blk[blk].xlt2.vsis[vsi].changed = 1;
+
+	/* Add new entry to the head of the VSIG list */
+	tmp = hw->blk[blk].xlt2.vsig_tbl[idx].first_vsi;
+	hw->blk[blk].xlt2.vsig_tbl[idx].first_vsi =
+		&hw->blk[blk].xlt2.vsis[vsi];
+	hw->blk[blk].xlt2.vsis[vsi].next_vsi = tmp;
+	hw->blk[blk].xlt2.t[vsi] = vsig;
+
+	return 0;
+}
+
+/* Block / table section IDs */
+static const u32 ice_blk_sids[ICE_BLK_COUNT][ICE_SID_OFF_COUNT] = {
+	/* SWITCH */
+	{	ICE_SID_XLT1_SW,
+		ICE_SID_XLT2_SW,
+		ICE_SID_PROFID_TCAM_SW,
+		ICE_SID_PROFID_REDIR_SW,
+		ICE_SID_FLD_VEC_SW
+	},
+
+	/* ACL */
+	{	ICE_SID_XLT1_ACL,
+		ICE_SID_XLT2_ACL,
+		ICE_SID_PROFID_TCAM_ACL,
+		ICE_SID_PROFID_REDIR_ACL,
+		ICE_SID_FLD_VEC_ACL
+	},
+
+	/* FD */
+	{	ICE_SID_XLT1_FD,
+		ICE_SID_XLT2_FD,
+		ICE_SID_PROFID_TCAM_FD,
+		ICE_SID_PROFID_REDIR_FD,
+		ICE_SID_FLD_VEC_FD
+	},
+
+	/* RSS */
+	{	ICE_SID_XLT1_RSS,
+		ICE_SID_XLT2_RSS,
+		ICE_SID_PROFID_TCAM_RSS,
+		ICE_SID_PROFID_REDIR_RSS,
+		ICE_SID_FLD_VEC_RSS
+	},
+
+	/* PE */
+	{	ICE_SID_XLT1_PE,
+		ICE_SID_XLT2_PE,
+		ICE_SID_PROFID_TCAM_PE,
+		ICE_SID_PROFID_REDIR_PE,
+		ICE_SID_FLD_VEC_PE
+	}
+};
+
+/**
+ * ice_init_sw_xlt1_db - init software XLT1 database from HW tables
+ * @hw: pointer to the hardware structure
+ * @blk: the HW block to initialize
+ */
+static void ice_init_sw_xlt1_db(struct ice_hw *hw, enum ice_block blk)
+{
+	u16 pt;
+
+	for (pt = 0; pt < hw->blk[blk].xlt1.count; pt++) {
+		u8 ptg;
+
+		ptg = hw->blk[blk].xlt1.t[pt];
+		if (ptg != ICE_DEFAULT_PTG) {
+			ice_ptg_alloc_val(hw, blk, ptg);
+			ice_ptg_add_mv_ptype(hw, blk, pt, ptg);
+		}
+	}
+}
+
+/**
+ * ice_init_sw_xlt2_db - init software XLT2 database from HW tables
+ * @hw: pointer to the hardware structure
+ * @blk: the HW block to initialize
+ */
+static void ice_init_sw_xlt2_db(struct ice_hw *hw, enum ice_block blk)
+{
+	u16 vsi;
+
+	for (vsi = 0; vsi < hw->blk[blk].xlt2.count; vsi++) {
+		u16 vsig;
+
+		vsig = hw->blk[blk].xlt2.t[vsi];
+		if (vsig) {
+			ice_vsig_alloc_val(hw, blk, vsig);
+			ice_vsig_add_mv_vsi(hw, blk, vsi, vsig);
+			/* no changes at this time, since this has been
+			 * initialized from the original package
+			 */
+			hw->blk[blk].xlt2.vsis[vsi].changed = 0;
+		}
+	}
+}
+
+/**
+ * ice_init_sw_db - init software database from HW tables
+ * @hw: pointer to the hardware structure
+ */
+static void ice_init_sw_db(struct ice_hw *hw)
+{
+	u16 i;
+
+	for (i = 0; i < ICE_BLK_COUNT; i++) {
+		ice_init_sw_xlt1_db(hw, (enum ice_block)i);
+		ice_init_sw_xlt2_db(hw, (enum ice_block)i);
+	}
+}
+
+/**
+ * ice_fill_tbl - Reads content of a single table type into database
+ * @hw: pointer to the hardware structure
+ * @block_id: Block ID of the table to copy
+ * @sid: Section ID of the table to copy
+ *
+ * Will attempt to read the entire content of a given table of a single block
+ * into the driver database. We assume that the buffer will always
+ * be as large or larger than the data contained in the package. If
+ * this condition is not met, there is most likely an error in the package
+ * contents.
+ */
+static void ice_fill_tbl(struct ice_hw *hw, enum ice_block block_id, u32 sid)
+{
+	u32 dst_len, sect_len, offset = 0;
+	struct ice_prof_redir_section *pr;
+	struct ice_prof_id_section *pid;
+	struct ice_xlt1_section *xlt1;
+	struct ice_xlt2_section *xlt2;
+	struct ice_sw_fv_section *es;
+	struct ice_pkg_enum state;
+	u8 *src, *dst;
+	void *sect;
+
+	/* if the HW segment pointer is null then the first iteration of
+	 * ice_pkg_enum_section() will fail. In this case the HW tables will
+	 * not be filled and return success.
+	 */
+	if (!hw->seg) {
+		ice_debug(hw, ICE_DBG_PKG, "hw->seg is NULL, tables are not filled\n");
+		return;
+	}
+
+	memset(&state, 0, sizeof(state));
+
+	sect = ice_pkg_enum_section(hw->seg, &state, sid);
+
+	while (sect) {
+		switch (sid) {
+		case ICE_SID_XLT1_SW:
+		case ICE_SID_XLT1_FD:
+		case ICE_SID_XLT1_RSS:
+		case ICE_SID_XLT1_ACL:
+		case ICE_SID_XLT1_PE:
+			xlt1 = (struct ice_xlt1_section *)sect;
+			src = xlt1->value;
+			sect_len = le16_to_cpu(xlt1->count) *
+				sizeof(*hw->blk[block_id].xlt1.t);
+			dst = hw->blk[block_id].xlt1.t;
+			dst_len = hw->blk[block_id].xlt1.count *
+				sizeof(*hw->blk[block_id].xlt1.t);
+			break;
+		case ICE_SID_XLT2_SW:
+		case ICE_SID_XLT2_FD:
+		case ICE_SID_XLT2_RSS:
+		case ICE_SID_XLT2_ACL:
+		case ICE_SID_XLT2_PE:
+			xlt2 = (struct ice_xlt2_section *)sect;
+			src = (__force u8 *)xlt2->value;
+			sect_len = le16_to_cpu(xlt2->count) *
+				sizeof(*hw->blk[block_id].xlt2.t);
+			dst = (u8 *)hw->blk[block_id].xlt2.t;
+			dst_len = hw->blk[block_id].xlt2.count *
+				sizeof(*hw->blk[block_id].xlt2.t);
+			break;
+		case ICE_SID_PROFID_TCAM_SW:
+		case ICE_SID_PROFID_TCAM_FD:
+		case ICE_SID_PROFID_TCAM_RSS:
+		case ICE_SID_PROFID_TCAM_ACL:
+		case ICE_SID_PROFID_TCAM_PE:
+			pid = (struct ice_prof_id_section *)sect;
+			src = (u8 *)pid->entry;
+			sect_len = le16_to_cpu(pid->count) *
+				sizeof(*hw->blk[block_id].prof.t);
+			dst = (u8 *)hw->blk[block_id].prof.t;
+			dst_len = hw->blk[block_id].prof.count *
+				sizeof(*hw->blk[block_id].prof.t);
+			break;
+		case ICE_SID_PROFID_REDIR_SW:
+		case ICE_SID_PROFID_REDIR_FD:
+		case ICE_SID_PROFID_REDIR_RSS:
+		case ICE_SID_PROFID_REDIR_ACL:
+		case ICE_SID_PROFID_REDIR_PE:
+			pr = (struct ice_prof_redir_section *)sect;
+			src = pr->redir_value;
+			sect_len = le16_to_cpu(pr->count) *
+				sizeof(*hw->blk[block_id].prof_redir.t);
+			dst = hw->blk[block_id].prof_redir.t;
+			dst_len = hw->blk[block_id].prof_redir.count *
+				sizeof(*hw->blk[block_id].prof_redir.t);
+			break;
+		case ICE_SID_FLD_VEC_SW:
+		case ICE_SID_FLD_VEC_FD:
+		case ICE_SID_FLD_VEC_RSS:
+		case ICE_SID_FLD_VEC_ACL:
+		case ICE_SID_FLD_VEC_PE:
+			es = (struct ice_sw_fv_section *)sect;
+			src = (u8 *)es->fv;
+			sect_len = (u32)(le16_to_cpu(es->count) *
+					 hw->blk[block_id].es.fvw) *
+				sizeof(*hw->blk[block_id].es.t);
+			dst = (u8 *)hw->blk[block_id].es.t;
+			dst_len = (u32)(hw->blk[block_id].es.count *
+					hw->blk[block_id].es.fvw) *
+				sizeof(*hw->blk[block_id].es.t);
+			break;
+		default:
+			return;
+		}
+
+		/* if the section offset exceeds destination length, terminate
+		 * table fill.
+		 */
+		if (offset > dst_len)
+			return;
+
+		/* if the sum of section size and offset exceed destination size
+		 * then we are out of bounds of the HW table size for that PF.
+		 * Changing section length to fill the remaining table space
+		 * of that PF.
+		 */
+		if ((offset + sect_len) > dst_len)
+			sect_len = dst_len - offset;
+
+		memcpy(dst + offset, src, sect_len);
+		offset += sect_len;
+		sect = ice_pkg_enum_section(NULL, &state, sid);
+	}
+}
+
+/**
+ * ice_fill_blk_tbls - Read package context for tables
+ * @hw: pointer to the hardware structure
+ *
+ * Reads the current package contents and populates the driver
+ * database with the data iteratively for all advanced feature
+ * blocks. Assume that the HW tables have been allocated.
+ */
+static void ice_fill_blk_tbls(struct ice_hw *hw)
+{
+	u8 i;
+
+	for (i = 0; i < ICE_BLK_COUNT; i++) {
+		enum ice_block blk_id = (enum ice_block)i;
+
+		ice_fill_tbl(hw, blk_id, hw->blk[blk_id].xlt1.sid);
+		ice_fill_tbl(hw, blk_id, hw->blk[blk_id].xlt2.sid);
+		ice_fill_tbl(hw, blk_id, hw->blk[blk_id].prof.sid);
+		ice_fill_tbl(hw, blk_id, hw->blk[blk_id].prof_redir.sid);
+		ice_fill_tbl(hw, blk_id, hw->blk[blk_id].es.sid);
+	}
+
+	ice_init_sw_db(hw);
+}
+
+/**
+ * ice_free_hw_tbls - free hardware table memory
+ * @hw: pointer to the hardware structure
+ */
+void ice_free_hw_tbls(struct ice_hw *hw)
+{
+	u8 i;
+
+	for (i = 0; i < ICE_BLK_COUNT; i++) {
+		hw->blk[i].is_list_init = false;
+
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt1.ptypes);
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt1.ptg_tbl);
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt1.t);
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt2.t);
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt2.vsig_tbl);
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt2.vsis);
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].prof.t);
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].prof_redir.t);
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].es.t);
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].es.ref_count);
+		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].es.written);
+	}
+
+	memset(hw->blk, 0, sizeof(hw->blk));
+}
+
+/**
+ * ice_clear_hw_tbls - clear HW tables and flow profiles
+ * @hw: pointer to the hardware structure
+ */
+void ice_clear_hw_tbls(struct ice_hw *hw)
+{
+	u8 i;
+
+	for (i = 0; i < ICE_BLK_COUNT; i++) {
+		struct ice_prof_redir *prof_redir = &hw->blk[i].prof_redir;
+		struct ice_prof_tcam *prof = &hw->blk[i].prof;
+		struct ice_xlt1 *xlt1 = &hw->blk[i].xlt1;
+		struct ice_xlt2 *xlt2 = &hw->blk[i].xlt2;
+		struct ice_es *es = &hw->blk[i].es;
+
+		memset(xlt1->ptypes, 0, xlt1->count * sizeof(*xlt1->ptypes));
+		memset(xlt1->ptg_tbl, 0,
+		       ICE_MAX_PTGS * sizeof(*xlt1->ptg_tbl));
+		memset(xlt1->t, 0, xlt1->count * sizeof(*xlt1->t));
+
+		memset(xlt2->vsis, 0, xlt2->count * sizeof(*xlt2->vsis));
+		memset(xlt2->vsig_tbl, 0,
+		       xlt2->count * sizeof(*xlt2->vsig_tbl));
+		memset(xlt2->t, 0, xlt2->count * sizeof(*xlt2->t));
+
+		memset(prof->t, 0, prof->count * sizeof(*prof->t));
+		memset(prof_redir->t, 0,
+		       prof_redir->count * sizeof(*prof_redir->t));
+
+		memset(es->t, 0, es->count * sizeof(*es->t));
+		memset(es->ref_count, 0, es->count * sizeof(*es->ref_count));
+		memset(es->written, 0, es->count * sizeof(*es->written));
+	}
+}
+
+/**
+ * ice_init_hw_tbls - init hardware table memory
+ * @hw: pointer to the hardware structure
+ */
+enum ice_status ice_init_hw_tbls(struct ice_hw *hw)
+{
+	u8 i;
+
+	for (i = 0; i < ICE_BLK_COUNT; i++) {
+		struct ice_prof_redir *prof_redir = &hw->blk[i].prof_redir;
+		struct ice_prof_tcam *prof = &hw->blk[i].prof;
+		struct ice_xlt1 *xlt1 = &hw->blk[i].xlt1;
+		struct ice_xlt2 *xlt2 = &hw->blk[i].xlt2;
+		struct ice_es *es = &hw->blk[i].es;
+		u16 j;
+
+		if (hw->blk[i].is_list_init)
+			continue;
+
+		hw->blk[i].is_list_init = true;
+
+		hw->blk[i].overwrite = blk_sizes[i].overwrite;
+		es->reverse = blk_sizes[i].reverse;
+
+		xlt1->sid = ice_blk_sids[i][ICE_SID_XLT1_OFF];
+		xlt1->count = blk_sizes[i].xlt1;
+
+		xlt1->ptypes = devm_kcalloc(ice_hw_to_dev(hw), xlt1->count,
+					    sizeof(*xlt1->ptypes), GFP_KERNEL);
+
+		if (!xlt1->ptypes)
+			goto err;
+
+		xlt1->ptg_tbl = devm_kcalloc(ice_hw_to_dev(hw), ICE_MAX_PTGS,
+					     sizeof(*xlt1->ptg_tbl),
+					     GFP_KERNEL);
+
+		if (!xlt1->ptg_tbl)
+			goto err;
+
+		xlt1->t = devm_kcalloc(ice_hw_to_dev(hw), xlt1->count,
+				       sizeof(*xlt1->t), GFP_KERNEL);
+		if (!xlt1->t)
+			goto err;
+
+		xlt2->sid = ice_blk_sids[i][ICE_SID_XLT2_OFF];
+		xlt2->count = blk_sizes[i].xlt2;
+
+		xlt2->vsis = devm_kcalloc(ice_hw_to_dev(hw), xlt2->count,
+					  sizeof(*xlt2->vsis), GFP_KERNEL);
+
+		if (!xlt2->vsis)
+			goto err;
+
+		xlt2->vsig_tbl = devm_kcalloc(ice_hw_to_dev(hw), xlt2->count,
+					      sizeof(*xlt2->vsig_tbl),
+					      GFP_KERNEL);
+		if (!xlt2->vsig_tbl)
+			goto err;
+
+		for (j = 0; j < xlt2->count; j++)
+			INIT_LIST_HEAD(&xlt2->vsig_tbl[j].prop_lst);
+
+		xlt2->t = devm_kcalloc(ice_hw_to_dev(hw), xlt2->count,
+				       sizeof(*xlt2->t), GFP_KERNEL);
+		if (!xlt2->t)
+			goto err;
+
+		prof->sid = ice_blk_sids[i][ICE_SID_PR_OFF];
+		prof->count = blk_sizes[i].prof_tcam;
+		prof->max_prof_id = blk_sizes[i].prof_id;
+		prof->cdid_bits = blk_sizes[i].prof_cdid_bits;
+		prof->t = devm_kcalloc(ice_hw_to_dev(hw), prof->count,
+				       sizeof(*prof->t), GFP_KERNEL);
+
+		if (!prof->t)
+			goto err;
+
+		prof_redir->sid = ice_blk_sids[i][ICE_SID_PR_REDIR_OFF];
+		prof_redir->count = blk_sizes[i].prof_redir;
+		prof_redir->t = devm_kcalloc(ice_hw_to_dev(hw),
+					     prof_redir->count,
+					     sizeof(*prof_redir->t),
+					     GFP_KERNEL);
+
+		if (!prof_redir->t)
+			goto err;
+
+		es->sid = ice_blk_sids[i][ICE_SID_ES_OFF];
+		es->count = blk_sizes[i].es;
+		es->fvw = blk_sizes[i].fvw;
+		es->t = devm_kcalloc(ice_hw_to_dev(hw),
+				     (u32)(es->count * es->fvw),
+				     sizeof(*es->t), GFP_KERNEL);
+		if (!es->t)
+			goto err;
+
+		es->ref_count = devm_kcalloc(ice_hw_to_dev(hw), es->count,
+					     sizeof(*es->ref_count),
+					     GFP_KERNEL);
+
+		es->written = devm_kcalloc(ice_hw_to_dev(hw), es->count,
+					   sizeof(*es->written), GFP_KERNEL);
+		if (!es->ref_count)
+			goto err;
+	}
+	return 0;
+
+err:
+	ice_free_hw_tbls(hw);
+	return ICE_ERR_NO_MEMORY;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index 3843c462bc42..9edf1e7589c7 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -21,5 +21,8 @@
 enum ice_status ice_init_pkg(struct ice_hw *hw, u8 *buff, u32 len);
 enum ice_status
 ice_copy_and_init_pkg(struct ice_hw *hw, const u8 *buf, u32 len);
+enum ice_status ice_init_hw_tbls(struct ice_hw *hw);
 void ice_free_seg(struct ice_hw *hw);
+void ice_clear_hw_tbls(struct ice_hw *hw);
+void ice_free_hw_tbls(struct ice_hw *hw);
 #endif /* _ICE_FLEX_PIPE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index b7fb90594faf..5d5a7eaffa30 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -294,6 +294,7 @@ struct ice_vsig_vsi {
 };
 
 #define ICE_XLT1_CNT	1024
+#define ICE_MAX_PTGS	256
 
 /* XLT1 Table */
 struct ice_xlt1 {
@@ -304,6 +305,7 @@ struct ice_xlt1 {
 	u16 count;
 };
 
+#define ICE_XLT2_CNT	768
 #define ICE_MAX_VSIGS	768
 
 /* VSIG bit layout:
-- 
2.21.0

