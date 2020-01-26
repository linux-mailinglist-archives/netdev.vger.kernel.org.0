Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B09B314996C
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 07:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgAZGHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 01:07:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:18151 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgAZGHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 01:07:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 22:07:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,364,1574150400"; 
   d="scan'208";a="230947206"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2020 22:07:40 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Henry Tieman <henry.w.tieman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/8] ice: Allocate flow profile
Date:   Sat, 25 Jan 2020 22:07:31 -0800
Message-Id: <20200126060737.3238027-3-jeffrey.t.kirsher@intel.com>
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

Create an extraction sequence based on the packet header protocols to be
programmed and allocate a flow profile for the extraction sequence.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   6 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  75 +++
 drivers/net/ethernet/intel/ice/ice_common.h   |   6 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 216 ++++++++
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   3 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |  15 +
 drivers/net/ethernet/intel/ice/ice_flow.c     | 490 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_flow.h     |  23 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |   8 +
 .../ethernet/intel/ice/ice_protocol_type.h    |  24 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |  36 --
 drivers/net/ethernet/intel/ice/ice_type.h     |   2 +
 12 files changed, 864 insertions(+), 40 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_protocol_type.h

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 5421fc413f94..ad15a772b609 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -232,6 +232,12 @@ struct ice_aqc_get_sw_cfg_resp {
  */
 #define ICE_AQC_RES_TYPE_VSI_LIST_REP			0x03
 #define ICE_AQC_RES_TYPE_VSI_LIST_PRUNE			0x04
+#define ICE_AQC_RES_TYPE_HASH_PROF_BLDR_PROFID		0x60
+
+#define ICE_AQC_RES_TYPE_FLAG_SCAN_BOTTOM		BIT(12)
+#define ICE_AQC_RES_TYPE_FLAG_IGNORE_INDEX		BIT(13)
+
+#define ICE_AQC_RES_TYPE_FLAG_DEDICATED			0x00
 
 /* Allocate Resources command (indirect 0x0208)
  * Free Resources command (indirect 0x0209)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index dd9af9c63755..8f86962fd052 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1497,6 +1497,81 @@ void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res)
 	}
 }
 
+/**
+ * ice_aq_alloc_free_res - command to allocate/free resources
+ * @hw: pointer to the HW struct
+ * @num_entries: number of resource entries in buffer
+ * @buf: Indirect buffer to hold data parameters and response
+ * @buf_size: size of buffer for indirect commands
+ * @opc: pass in the command opcode
+ * @cd: pointer to command details structure or NULL
+ *
+ * Helper function to allocate/free resources using the admin queue commands
+ */
+enum ice_status
+ice_aq_alloc_free_res(struct ice_hw *hw, u16 num_entries,
+		      struct ice_aqc_alloc_free_res_elem *buf, u16 buf_size,
+		      enum ice_adminq_opc opc, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_alloc_free_res_cmd *cmd;
+	struct ice_aq_desc desc;
+
+	cmd = &desc.params.sw_res_ctrl;
+
+	if (!buf)
+		return ICE_ERR_PARAM;
+
+	if (buf_size < (num_entries * sizeof(buf->elem[0])))
+		return ICE_ERR_PARAM;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, opc);
+
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	cmd->num_entries = cpu_to_le16(num_entries);
+
+	return ice_aq_send_cmd(hw, &desc, buf, buf_size, cd);
+}
+
+/**
+ * ice_alloc_hw_res - allocate resource
+ * @hw: pointer to the HW struct
+ * @type: type of resource
+ * @num: number of resources to allocate
+ * @btm: allocate from bottom
+ * @res: pointer to array that will receive the resources
+ */
+enum ice_status
+ice_alloc_hw_res(struct ice_hw *hw, u16 type, u16 num, bool btm, u16 *res)
+{
+	struct ice_aqc_alloc_free_res_elem *buf;
+	enum ice_status status;
+	u16 buf_len;
+
+	buf_len = struct_size(buf, elem, num - 1);
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return ICE_ERR_NO_MEMORY;
+
+	/* Prepare buffer to allocate resource. */
+	buf->num_elems = cpu_to_le16(num);
+	buf->res_type = cpu_to_le16(type | ICE_AQC_RES_TYPE_FLAG_DEDICATED |
+				    ICE_AQC_RES_TYPE_FLAG_IGNORE_INDEX);
+	if (btm)
+		buf->res_type |= cpu_to_le16(ICE_AQC_RES_TYPE_FLAG_SCAN_BOTTOM);
+
+	status = ice_aq_alloc_free_res(hw, 1, buf, buf_len,
+				       ice_aqc_opc_alloc_res, NULL);
+	if (status)
+		goto ice_alloc_res_exit;
+
+	memcpy(res, buf->elem, sizeof(buf->elem) * num);
+
+ice_alloc_res_exit:
+	kfree(buf);
+	return status;
+}
+
 /**
  * ice_get_num_per_func - determine number of resources per PF
  * @hw: pointer to the HW structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index b22aa561e253..81e8ac925b9c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -34,10 +34,16 @@ enum ice_status
 ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
 		enum ice_aq_res_access_type access, u32 timeout);
 void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res);
+enum ice_status
+ice_alloc_hw_res(struct ice_hw *hw, u16 type, u16 num, bool btm, u16 *res);
 enum ice_status ice_init_nvm(struct ice_hw *hw);
 enum ice_status
 ice_read_sr_buf(struct ice_hw *hw, u16 offset, u16 *words, u16 *data);
 enum ice_status
+ice_aq_alloc_free_res(struct ice_hw *hw, u16 num_entries,
+		      struct ice_aqc_alloc_free_res_elem *buf, u16 buf_size,
+		      enum ice_adminq_opc opc, struct ice_sq_cd *cd);
+enum ice_status
 ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		struct ice_aq_desc *desc, void *buf, u16 buf_size,
 		struct ice_sq_cd *cd);
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index f37eb536e7b7..5c09d3105b8b 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1118,6 +1118,117 @@ ice_vsig_add_mv_vsi(struct ice_hw *hw, enum ice_block blk, u16 vsi, u16 vsig)
 	return 0;
 }
 
+/**
+ * ice_find_prof_id - find profile ID for a given field vector
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @fv: field vector to search for
+ * @prof_id: receives the profile ID
+ */
+static enum ice_status
+ice_find_prof_id(struct ice_hw *hw, enum ice_block blk,
+		 struct ice_fv_word *fv, u8 *prof_id)
+{
+	struct ice_es *es = &hw->blk[blk].es;
+	u16 off, i;
+
+	for (i = 0; i < es->count; i++) {
+		off = i * es->fvw;
+
+		if (memcmp(&es->t[off], fv, es->fvw * sizeof(*fv)))
+			continue;
+
+		*prof_id = i;
+		return 0;
+	}
+
+	return ICE_ERR_DOES_NOT_EXIST;
+}
+
+/**
+ * ice_prof_id_rsrc_type - get profile ID resource type for a block type
+ * @blk: the block type
+ * @rsrc_type: pointer to variable to receive the resource type
+ */
+static bool ice_prof_id_rsrc_type(enum ice_block blk, u16 *rsrc_type)
+{
+	switch (blk) {
+	case ICE_BLK_RSS:
+		*rsrc_type = ICE_AQC_RES_TYPE_HASH_PROF_BLDR_PROFID;
+		break;
+	default:
+		return false;
+	}
+	return true;
+}
+
+/**
+ * ice_alloc_prof_id - allocate profile ID
+ * @hw: pointer to the HW struct
+ * @blk: the block to allocate the profile ID for
+ * @prof_id: pointer to variable to receive the profile ID
+ *
+ * This function allocates a new profile ID, which also corresponds to a Field
+ * Vector (Extraction Sequence) entry.
+ */
+static enum ice_status
+ice_alloc_prof_id(struct ice_hw *hw, enum ice_block blk, u8 *prof_id)
+{
+	enum ice_status status;
+	u16 res_type;
+	u16 get_prof;
+
+	if (!ice_prof_id_rsrc_type(blk, &res_type))
+		return ICE_ERR_PARAM;
+
+	status = ice_alloc_hw_res(hw, res_type, 1, false, &get_prof);
+	if (!status)
+		*prof_id = (u8)get_prof;
+
+	return status;
+}
+
+/**
+ * ice_prof_inc_ref - increment reference count for profile
+ * @hw: pointer to the HW struct
+ * @blk: the block from which to free the profile ID
+ * @prof_id: the profile ID for which to increment the reference count
+ */
+static enum ice_status
+ice_prof_inc_ref(struct ice_hw *hw, enum ice_block blk, u8 prof_id)
+{
+	if (prof_id > hw->blk[blk].es.count)
+		return ICE_ERR_PARAM;
+
+	hw->blk[blk].es.ref_count[prof_id]++;
+
+	return 0;
+}
+
+/**
+ * ice_write_es - write an extraction sequence to hardware
+ * @hw: pointer to the HW struct
+ * @blk: the block in which to write the extraction sequence
+ * @prof_id: the profile ID to write
+ * @fv: pointer to the extraction sequence to write - NULL to clear extraction
+ */
+static void
+ice_write_es(struct ice_hw *hw, enum ice_block blk, u8 prof_id,
+	     struct ice_fv_word *fv)
+{
+	u16 off;
+
+	off = prof_id * hw->blk[blk].es.fvw;
+	if (!fv) {
+		memset(&hw->blk[blk].es.t[off], 0,
+		       hw->blk[blk].es.fvw * sizeof(*fv));
+		hw->blk[blk].es.written[prof_id] = false;
+	} else {
+		memcpy(&hw->blk[blk].es.t[off], fv,
+		       hw->blk[blk].es.fvw * sizeof(*fv));
+	}
+}
+
 /* Block / table section IDs */
 static const u32 ice_blk_sids[ICE_BLK_COUNT][ICE_SID_OFF_COUNT] = {
 	/* SWITCH */
@@ -1576,3 +1687,108 @@ enum ice_status ice_init_hw_tbls(struct ice_hw *hw)
 	ice_free_hw_tbls(hw);
 	return ICE_ERR_NO_MEMORY;
 }
+
+/**
+ * ice_add_prof - add profile
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @id: profile tracking ID
+ * @ptypes: array of bitmaps indicating ptypes (ICE_FLOW_PTYPE_MAX bits)
+ * @es: extraction sequence (length of array is determined by the block)
+ *
+ * This function registers a profile, which matches a set of PTGs with a
+ * particular extraction sequence. While the hardware profile is allocated
+ * it will not be written until the first call to ice_add_flow that specifies
+ * the ID value used here.
+ */
+enum ice_status
+ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
+	     struct ice_fv_word *es)
+{
+	u32 bytes = DIV_ROUND_UP(ICE_FLOW_PTYPE_MAX, BITS_PER_BYTE);
+	DECLARE_BITMAP(ptgs_used, ICE_XLT1_CNT);
+	struct ice_prof_map *prof;
+	enum ice_status status;
+	u32 byte = 0;
+	u8 prof_id;
+
+	bitmap_zero(ptgs_used, ICE_XLT1_CNT);
+
+	mutex_lock(&hw->blk[blk].es.prof_map_lock);
+
+	/* search for existing profile */
+	status = ice_find_prof_id(hw, blk, es, &prof_id);
+	if (status) {
+		/* allocate profile ID */
+		status = ice_alloc_prof_id(hw, blk, &prof_id);
+		if (status)
+			goto err_ice_add_prof;
+
+		/* and write new es */
+		ice_write_es(hw, blk, prof_id, es);
+	}
+
+	ice_prof_inc_ref(hw, blk, prof_id);
+
+	/* add profile info */
+	prof = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*prof), GFP_KERNEL);
+	if (!prof)
+		goto err_ice_add_prof;
+
+	prof->profile_cookie = id;
+	prof->prof_id = prof_id;
+	prof->ptg_cnt = 0;
+	prof->context = 0;
+
+	/* build list of ptgs */
+	while (bytes && prof->ptg_cnt < ICE_MAX_PTG_PER_PROFILE) {
+		u32 bit;
+
+		if (!ptypes[byte]) {
+			bytes--;
+			byte++;
+			continue;
+		}
+
+		/* Examine 8 bits per byte */
+		for_each_set_bit(bit, (unsigned long *)&ptypes[byte],
+				 BITS_PER_BYTE) {
+			u16 ptype;
+			u8 ptg;
+			u8 m;
+
+			ptype = byte * BITS_PER_BYTE + bit;
+
+			/* The package should place all ptypes in a non-zero
+			 * PTG, so the following call should never fail.
+			 */
+			if (ice_ptg_find_ptype(hw, blk, ptype, &ptg))
+				continue;
+
+			/* If PTG is already added, skip and continue */
+			if (test_bit(ptg, ptgs_used))
+				continue;
+
+			set_bit(ptg, ptgs_used);
+			prof->ptg[prof->ptg_cnt] = ptg;
+
+			if (++prof->ptg_cnt >= ICE_MAX_PTG_PER_PROFILE)
+				break;
+
+			/* nothing left in byte, then exit */
+			m = ~((1 << (bit + 1)) - 1);
+			if (!(ptypes[byte] & m))
+				break;
+		}
+
+		bytes--;
+		byte++;
+	}
+
+	list_add(&prof->list, &hw->blk[blk].es.prof_map);
+	status = 0;
+
+err_ice_add_prof:
+	mutex_unlock(&hw->blk[blk].es.prof_map_lock);
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index 37eb282742d1..8cb7d7f09e0b 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -18,6 +18,9 @@
 
 #define ICE_PKG_CNT 4
 
+enum ice_status
+ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
+	     struct ice_fv_word *es);
 enum ice_status ice_init_pkg(struct ice_hw *hw, u8 *buff, u32 len);
 enum ice_status
 ice_copy_and_init_pkg(struct ice_hw *hw, const u8 *buf, u32 len);
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index 5d5a7eaffa30..3005f111fb3b 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -3,6 +3,9 @@
 
 #ifndef _ICE_FLEX_TYPE_H_
 #define _ICE_FLEX_TYPE_H_
+
+#define ICE_FV_OFFSET_INVAL	0x1FF
+
 /* Extraction Sequence (Field Vector) Table */
 struct ice_fv_word {
 	u8 prot_id;
@@ -280,6 +283,17 @@ struct ice_ptg_ptype {
 	u8 ptg;
 };
 
+#define ICE_MAX_PTG_PER_PROFILE		32
+
+struct ice_prof_map {
+	struct list_head list;
+	u64 profile_cookie;
+	u64 context;
+	u8 prof_id;
+	u8 ptg_cnt;
+	u8 ptg[ICE_MAX_PTG_PER_PROFILE];
+};
+
 struct ice_vsig_entry {
 	struct list_head prop_lst;
 	struct ice_vsig_vsi *first_vsi;
@@ -371,4 +385,5 @@ struct ice_blk_info {
 	u8 is_list_init;
 };
 
+#define ICE_FLOW_PTYPE_MAX		ICE_XLT1_CNT
 #endif /* _ICE_FLEX_TYPE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 4828c64abe98..24fe04f8baa2 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -40,6 +40,457 @@ struct ice_flow_field_info ice_flds_info[ICE_FLOW_FIELD_IDX_MAX] = {
 	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_UDP, 2, sizeof(__be16)),
 };
 
+/* Bitmaps indicating relevant packet types for a particular protocol header
+ *
+ * Packet types for packets with an Outer/First/Single IPv4 header
+ */
+static const u32 ice_ptypes_ipv4_ofos[] = {
+	0x1DC00000, 0x04000800, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with an Innermost/Last IPv4 header */
+static const u32 ice_ptypes_ipv4_il[] = {
+	0xE0000000, 0xB807700E, 0x80000003, 0xE01DC03B,
+	0x0000000E, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with an Outer/First/Single IPv6 header */
+static const u32 ice_ptypes_ipv6_ofos[] = {
+	0x00000000, 0x00000000, 0x77000000, 0x10002000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with an Innermost/Last IPv6 header */
+static const u32 ice_ptypes_ipv6_il[] = {
+	0x00000000, 0x03B80770, 0x000001DC, 0x0EE00000,
+	0x00000770, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* UDP Packet types for non-tunneled packets or tunneled
+ * packets with inner UDP.
+ */
+static const u32 ice_ptypes_udp_il[] = {
+	0x81000000, 0x20204040, 0x04000010, 0x80810102,
+	0x00000040, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with an Innermost/Last TCP header */
+static const u32 ice_ptypes_tcp_il[] = {
+	0x04000000, 0x80810102, 0x10000040, 0x02040408,
+	0x00000102, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with an Innermost/Last SCTP header */
+static const u32 ice_ptypes_sctp_il[] = {
+	0x08000000, 0x01020204, 0x20000081, 0x04080810,
+	0x00000204, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Manage parameters and info. used during the creation of a flow profile */
+struct ice_flow_prof_params {
+	enum ice_block blk;
+	u16 entry_length; /* # of bytes formatted entry will require */
+	u8 es_cnt;
+	struct ice_flow_prof *prof;
+
+	/* For ACL, the es[0] will have the data of ICE_RX_MDID_PKT_FLAGS_15_0
+	 * This will give us the direction flags.
+	 */
+	struct ice_fv_word es[ICE_MAX_FV_WORDS];
+	DECLARE_BITMAP(ptypes, ICE_FLOW_PTYPE_MAX);
+};
+
+#define ICE_FLOW_SEG_HDRS_L3_MASK	\
+	(ICE_FLOW_SEG_HDR_IPV4 | ICE_FLOW_SEG_HDR_IPV6)
+#define ICE_FLOW_SEG_HDRS_L4_MASK	\
+	(ICE_FLOW_SEG_HDR_TCP | ICE_FLOW_SEG_HDR_UDP | ICE_FLOW_SEG_HDR_SCTP)
+
+/**
+ * ice_flow_val_hdrs - validates packet segments for valid protocol headers
+ * @segs: array of one or more packet segments that describe the flow
+ * @segs_cnt: number of packet segments provided
+ */
+static enum ice_status
+ice_flow_val_hdrs(struct ice_flow_seg_info *segs, u8 segs_cnt)
+{
+	u8 i;
+
+	for (i = 0; i < segs_cnt; i++) {
+		/* Multiple L3 headers */
+		if (segs[i].hdrs & ICE_FLOW_SEG_HDRS_L3_MASK &&
+		    !is_power_of_2(segs[i].hdrs & ICE_FLOW_SEG_HDRS_L3_MASK))
+			return ICE_ERR_PARAM;
+
+		/* Multiple L4 headers */
+		if (segs[i].hdrs & ICE_FLOW_SEG_HDRS_L4_MASK &&
+		    !is_power_of_2(segs[i].hdrs & ICE_FLOW_SEG_HDRS_L4_MASK))
+			return ICE_ERR_PARAM;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_flow_proc_seg_hdrs - process protocol headers present in pkt segments
+ * @params: information about the flow to be processed
+ *
+ * This function identifies the packet types associated with the protocol
+ * headers being present in packet segments of the specified flow profile.
+ */
+static enum ice_status
+ice_flow_proc_seg_hdrs(struct ice_flow_prof_params *params)
+{
+	struct ice_flow_prof *prof;
+	u8 i;
+
+	memset(params->ptypes, 0xff, sizeof(params->ptypes));
+
+	prof = params->prof;
+
+	for (i = 0; i < params->prof->segs_cnt; i++) {
+		const unsigned long *src;
+		u32 hdrs;
+
+		hdrs = prof->segs[i].hdrs;
+
+		if (hdrs & ICE_FLOW_SEG_HDR_IPV4) {
+			src = !i ? (const unsigned long *)ice_ptypes_ipv4_ofos :
+				(const unsigned long *)ice_ptypes_ipv4_il;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_IPV6) {
+			src = !i ? (const unsigned long *)ice_ptypes_ipv6_ofos :
+				(const unsigned long *)ice_ptypes_ipv6_il;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		}
+
+		if (hdrs & ICE_FLOW_SEG_HDR_UDP) {
+			src = (const unsigned long *)ice_ptypes_udp_il;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_TCP) {
+			bitmap_and(params->ptypes, params->ptypes,
+				   (const unsigned long *)ice_ptypes_tcp_il,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_SCTP) {
+			src = (const unsigned long *)ice_ptypes_sctp_il;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ice_flow_xtract_fld - Create an extraction sequence entry for the given field
+ * @hw: pointer to the HW struct
+ * @params: information about the flow to be processed
+ * @seg: packet segment index of the field to be extracted
+ * @fld: ID of field to be extracted
+ *
+ * This function determines the protocol ID, offset, and size of the given
+ * field. It then allocates one or more extraction sequence entries for the
+ * given field, and fill the entries with protocol ID and offset information.
+ */
+static enum ice_status
+ice_flow_xtract_fld(struct ice_hw *hw, struct ice_flow_prof_params *params,
+		    u8 seg, enum ice_flow_field fld)
+{
+	enum ice_prot_id prot_id = ICE_PROT_ID_INVAL;
+	u8 fv_words = hw->blk[params->blk].es.fvw;
+	struct ice_flow_fld_info *flds;
+	u16 cnt, ese_bits, i;
+	u16 off;
+
+	flds = params->prof->segs[seg].fields;
+
+	switch (fld) {
+	case ICE_FLOW_FIELD_IDX_IPV4_SA:
+	case ICE_FLOW_FIELD_IDX_IPV4_DA:
+		prot_id = seg == 0 ? ICE_PROT_IPV4_OF_OR_S : ICE_PROT_IPV4_IL;
+		break;
+	case ICE_FLOW_FIELD_IDX_IPV6_SA:
+	case ICE_FLOW_FIELD_IDX_IPV6_DA:
+		prot_id = seg == 0 ? ICE_PROT_IPV6_OF_OR_S : ICE_PROT_IPV6_IL;
+		break;
+	case ICE_FLOW_FIELD_IDX_TCP_SRC_PORT:
+	case ICE_FLOW_FIELD_IDX_TCP_DST_PORT:
+		prot_id = ICE_PROT_TCP_IL;
+		break;
+	case ICE_FLOW_FIELD_IDX_UDP_SRC_PORT:
+	case ICE_FLOW_FIELD_IDX_UDP_DST_PORT:
+		prot_id = ICE_PROT_UDP_IL_OR_S;
+		break;
+	default:
+		return ICE_ERR_NOT_IMPL;
+	}
+
+	/* Each extraction sequence entry is a word in size, and extracts a
+	 * word-aligned offset from a protocol header.
+	 */
+	ese_bits = ICE_FLOW_FV_EXTRACT_SZ * BITS_PER_BYTE;
+
+	flds[fld].xtrct.prot_id = prot_id;
+	flds[fld].xtrct.off = (ice_flds_info[fld].off / ese_bits) *
+		ICE_FLOW_FV_EXTRACT_SZ;
+	flds[fld].xtrct.disp = (u8)(ice_flds_info[fld].off % ese_bits);
+	flds[fld].xtrct.idx = params->es_cnt;
+
+	/* Adjust the next field-entry index after accommodating the number of
+	 * entries this field consumes
+	 */
+	cnt = DIV_ROUND_UP(flds[fld].xtrct.disp + ice_flds_info[fld].size,
+			   ese_bits);
+
+	/* Fill in the extraction sequence entries needed for this field */
+	off = flds[fld].xtrct.off;
+	for (i = 0; i < cnt; i++) {
+		u8 idx;
+
+		/* Make sure the number of extraction sequence required
+		 * does not exceed the block's capability
+		 */
+		if (params->es_cnt >= fv_words)
+			return ICE_ERR_MAX_LIMIT;
+
+		/* some blocks require a reversed field vector layout */
+		if (hw->blk[params->blk].es.reverse)
+			idx = fv_words - params->es_cnt - 1;
+		else
+			idx = params->es_cnt;
+
+		params->es[idx].prot_id = prot_id;
+		params->es[idx].off = off;
+		params->es_cnt++;
+
+		off += ICE_FLOW_FV_EXTRACT_SZ;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_flow_create_xtrct_seq - Create an extraction sequence for given segments
+ * @hw: pointer to the HW struct
+ * @params: information about the flow to be processed
+ *
+ * This function iterates through all matched fields in the given segments, and
+ * creates an extraction sequence for the fields.
+ */
+static enum ice_status
+ice_flow_create_xtrct_seq(struct ice_hw *hw,
+			  struct ice_flow_prof_params *params)
+{
+	struct ice_flow_prof *prof = params->prof;
+	enum ice_status status = 0;
+	u8 i;
+
+	for (i = 0; i < prof->segs_cnt; i++) {
+		u8 j;
+
+		for_each_set_bit(j, (unsigned long *)&prof->segs[i].match,
+				 ICE_FLOW_FIELD_IDX_MAX) {
+			status = ice_flow_xtract_fld(hw, params, i,
+						     (enum ice_flow_field)j);
+			if (status)
+				return status;
+		}
+	}
+
+	return status;
+}
+
+/**
+ * ice_flow_proc_segs - process all packet segments associated with a profile
+ * @hw: pointer to the HW struct
+ * @params: information about the flow to be processed
+ */
+static enum ice_status
+ice_flow_proc_segs(struct ice_hw *hw, struct ice_flow_prof_params *params)
+{
+	enum ice_status status;
+
+	status = ice_flow_proc_seg_hdrs(params);
+	if (status)
+		return status;
+
+	status = ice_flow_create_xtrct_seq(hw, params);
+	if (status)
+		return status;
+
+	switch (params->blk) {
+	case ICE_BLK_RSS:
+		/* Only header information is provided for RSS configuration.
+		 * No further processing is needed.
+		 */
+		status = 0;
+		break;
+	default:
+		return ICE_ERR_NOT_IMPL;
+	}
+
+	return status;
+}
+
+/**
+ * ice_flow_add_prof_sync - Add a flow profile for packet segments and fields
+ * @hw: pointer to the HW struct
+ * @blk: classification stage
+ * @dir: flow direction
+ * @prof_id: unique ID to identify this flow profile
+ * @segs: array of one or more packet segments that describe the flow
+ * @segs_cnt: number of packet segments provided
+ * @prof: stores the returned flow profile added
+ *
+ * Assumption: the caller has acquired the lock to the profile list
+ */
+static enum ice_status
+ice_flow_add_prof_sync(struct ice_hw *hw, enum ice_block blk,
+		       enum ice_flow_dir dir, u64 prof_id,
+		       struct ice_flow_seg_info *segs, u8 segs_cnt,
+		       struct ice_flow_prof **prof)
+{
+	struct ice_flow_prof_params params;
+	enum ice_status status;
+	u8 i;
+
+	if (!prof)
+		return ICE_ERR_BAD_PTR;
+
+	memset(&params, 0, sizeof(params));
+	params.prof = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*params.prof),
+				   GFP_KERNEL);
+	if (!params.prof)
+		return ICE_ERR_NO_MEMORY;
+
+	/* initialize extraction sequence to all invalid (0xff) */
+	for (i = 0; i < ICE_MAX_FV_WORDS; i++) {
+		params.es[i].prot_id = ICE_PROT_INVALID;
+		params.es[i].off = ICE_FV_OFFSET_INVAL;
+	}
+
+	params.blk = blk;
+	params.prof->id = prof_id;
+	params.prof->dir = dir;
+	params.prof->segs_cnt = segs_cnt;
+
+	/* Make a copy of the segments that need to be persistent in the flow
+	 * profile instance
+	 */
+	for (i = 0; i < segs_cnt; i++)
+		memcpy(&params.prof->segs[i], &segs[i], sizeof(*segs));
+
+	status = ice_flow_proc_segs(hw, &params);
+	if (status) {
+		ice_debug(hw, ICE_DBG_FLOW,
+			  "Error processing a flow's packet segments\n");
+		goto out;
+	}
+
+	/* Add a HW profile for this flow profile */
+	status = ice_add_prof(hw, blk, prof_id, (u8 *)params.ptypes, params.es);
+	if (status) {
+		ice_debug(hw, ICE_DBG_FLOW, "Error adding a HW flow profile\n");
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&params.prof->entries);
+	mutex_init(&params.prof->entries_lock);
+	*prof = params.prof;
+
+out:
+	if (status)
+		devm_kfree(ice_hw_to_dev(hw), params.prof);
+
+	return status;
+}
+
+/**
+ * ice_flow_add_prof - Add a flow profile for packet segments and matched fields
+ * @hw: pointer to the HW struct
+ * @blk: classification stage
+ * @dir: flow direction
+ * @prof_id: unique ID to identify this flow profile
+ * @segs: array of one or more packet segments that describe the flow
+ * @segs_cnt: number of packet segments provided
+ */
+static enum ice_status
+ice_flow_add_prof(struct ice_hw *hw, enum ice_block blk, enum ice_flow_dir dir,
+		  u64 prof_id, struct ice_flow_seg_info *segs, u8 segs_cnt)
+{
+	struct ice_flow_prof *prof = NULL;
+	enum ice_status status;
+
+	if (segs_cnt > ICE_FLOW_SEG_MAX)
+		return ICE_ERR_MAX_LIMIT;
+
+	if (!segs_cnt)
+		return ICE_ERR_PARAM;
+
+	if (!segs)
+		return ICE_ERR_BAD_PTR;
+
+	status = ice_flow_val_hdrs(segs, segs_cnt);
+	if (status)
+		return status;
+
+	mutex_lock(&hw->fl_profs_locks[blk]);
+
+	status = ice_flow_add_prof_sync(hw, blk, dir, prof_id, segs, segs_cnt,
+					&prof);
+	if (!status)
+		list_add(&prof->l_entry, &hw->fl_profs[blk]);
+
+	mutex_unlock(&hw->fl_profs_locks[blk]);
+
+	return status;
+}
+
 /**
  * ice_flow_set_fld_ext - specifies locations of field from entry's input buffer
  * @seg: packet segment the field being set belongs to
@@ -161,10 +612,28 @@ ice_flow_set_rss_seg_info(struct ice_flow_seg_info *segs, u64 hash_fields,
 	return 0;
 }
 
+#define ICE_FLOW_PROF_HASH_S	0
+#define ICE_FLOW_PROF_HASH_M	(0xFFFFFFFFULL << ICE_FLOW_PROF_HASH_S)
+#define ICE_FLOW_PROF_HDR_S	32
+#define ICE_FLOW_PROF_HDR_M	(0x3FFFFFFFULL << ICE_FLOW_PROF_HDR_S)
+#define ICE_FLOW_PROF_ENCAP_S	63
+#define ICE_FLOW_PROF_ENCAP_M	(BIT_ULL(ICE_FLOW_PROF_ENCAP_S))
+
 #define ICE_RSS_OUTER_HEADERS	1
 
+/* Flow profile ID format:
+ * [0:31] - Packet match fields
+ * [32:62] - Protocol header
+ * [63] - Encapsulation flag, 0 if non-tunneled, 1 if tunneled
+ */
+#define ICE_FLOW_GEN_PROFID(hash, hdr, segs_cnt) \
+	(u64)(((u64)(hash) & ICE_FLOW_PROF_HASH_M) | \
+	      (((u64)(hdr) << ICE_FLOW_PROF_HDR_S) & ICE_FLOW_PROF_HDR_M) | \
+	      ((u8)((segs_cnt) - 1) ? ICE_FLOW_PROF_ENCAP_M : 0))
+
 /**
  * ice_add_rss_cfg_sync - add an RSS configuration
+ * @hw: pointer to the hardware structure
  * @hashed_flds: hash bit fields (ICE_FLOW_HASH_*) to configure
  * @addl_hdrs: protocol header fields
  * @segs_cnt: packet segment count
@@ -172,7 +641,8 @@ ice_flow_set_rss_seg_info(struct ice_flow_seg_info *segs, u64 hash_fields,
  * Assumption: lock has already been acquired for RSS list
  */
 static enum ice_status
-ice_add_rss_cfg_sync(u64 hashed_flds, u32 addl_hdrs, u8 segs_cnt)
+ice_add_rss_cfg_sync(struct ice_hw *hw, u64 hashed_flds, u32 addl_hdrs,
+		     u8 segs_cnt)
 {
 	struct ice_flow_seg_info *segs;
 	enum ice_status status;
@@ -187,7 +657,19 @@ ice_add_rss_cfg_sync(u64 hashed_flds, u32 addl_hdrs, u8 segs_cnt)
 	/* Construct the packet segment info from the hashed fields */
 	status = ice_flow_set_rss_seg_info(&segs[segs_cnt - 1], hashed_flds,
 					   addl_hdrs);
-
+	if (status)
+		goto exit;
+
+	/* Create a new flow profile with generated profile and packet
+	 * segment information.
+	 */
+	status = ice_flow_add_prof(hw, ICE_BLK_RSS, ICE_FLOW_RX,
+				   ICE_FLOW_GEN_PROFID(hashed_flds,
+						       segs[segs_cnt - 1].hdrs,
+						       segs_cnt),
+				   segs, segs_cnt);
+
+exit:
 	kfree(segs);
 	return status;
 }
@@ -214,7 +696,7 @@ ice_add_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
 		return ICE_ERR_PARAM;
 
 	mutex_lock(&hw->rss_locks);
-	status = ice_add_rss_cfg_sync(hashed_flds, addl_hdrs,
+	status = ice_add_rss_cfg_sync(hw, hashed_flds, addl_hdrs,
 				      ICE_RSS_OUTER_HEADERS);
 	mutex_unlock(&hw->rss_locks);
 
@@ -237,7 +719,7 @@ enum ice_status ice_replay_rss_cfg(struct ice_hw *hw, u16 vsi_handle)
 	mutex_lock(&hw->rss_locks);
 	list_for_each_entry(r, &hw->rss_list_head, l_entry) {
 		if (test_bit(vsi_handle, r->vsis)) {
-			status = ice_add_rss_cfg_sync(r->hashed_flds,
+			status = ice_add_rss_cfg_sync(hw, r->hashed_flds,
 						      r->packet_hdr,
 						      ICE_RSS_OUTER_HEADERS);
 			if (status)
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 48c0fc09d5ff..05b0dab4793c 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -56,7 +56,13 @@ enum ice_flow_field {
 	ICE_FLOW_FIELD_IDX_MAX
 };
 
+enum ice_flow_dir {
+	ICE_FLOW_RX		= 0x02,
+};
+
 #define ICE_FLOW_SEG_MAX		2
+#define ICE_FLOW_FV_EXTRACT_SZ		2
+
 #define ICE_FLOW_SET_HDRS(seg, val)	((seg)->hdrs |= (u32)(val))
 
 struct ice_flow_seg_xtrct {
@@ -99,6 +105,23 @@ struct ice_flow_seg_info {
 	struct ice_flow_fld_info fields[ICE_FLOW_FIELD_IDX_MAX];
 };
 
+struct ice_flow_prof {
+	struct list_head l_entry;
+
+	u64 id;
+	enum ice_flow_dir dir;
+	u8 segs_cnt;
+
+	/* Keep track of flow entries associated with this flow profile */
+	struct mutex entries_lock;
+	struct list_head entries;
+
+	struct ice_flow_seg_info segs[ICE_FLOW_SEG_MAX];
+
+	/* software VSI handles referenced by this flow profile */
+	DECLARE_BITMAP(vsis, ICE_MAX_VSI);
+};
+
 struct ice_rss_cfg {
 	struct list_head l_entry;
 	/* bitmap of VSIs added to the RSS entry */
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 0997d352709b..878e125d8b42 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -199,6 +199,14 @@ enum ice_rxdid {
 /* Receive Flex Descriptor Rx opcode values */
 #define ICE_RX_OPC_MDID		0x01
 
+/* Receive Descriptor MDID values that access packet flags */
+enum ice_flex_mdid_pkt_flags {
+	ICE_RX_MDID_PKT_FLAGS_15_0	= 20,
+	ICE_RX_MDID_PKT_FLAGS_31_16,
+	ICE_RX_MDID_PKT_FLAGS_47_32,
+	ICE_RX_MDID_PKT_FLAGS_63_48,
+};
+
 /* Receive Descriptor MDID values */
 enum ice_flex_rx_mdid {
 	ICE_RX_MDID_FLOW_ID_LOWER	= 5,
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
new file mode 100644
index 000000000000..97db46ce7a21
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_PROTOCOL_TYPE_H_
+#define _ICE_PROTOCOL_TYPE_H_
+/* Decoders for ice_prot_id:
+ * - F: First
+ * - I: Inner
+ * - L: Last
+ * - O: Outer
+ * - S: Single
+ */
+enum ice_prot_id {
+	ICE_PROT_ID_INVAL	= 0,
+	ICE_PROT_IPV4_OF_OR_S	= 32,
+	ICE_PROT_IPV4_IL	= 33,
+	ICE_PROT_IPV6_OF_OR_S	= 40,
+	ICE_PROT_IPV6_IL	= 41,
+	ICE_PROT_TCP_IL		= 49,
+	ICE_PROT_UDP_IL_OR_S	= 53,
+	ICE_PROT_META_ID	= 255, /* when offset == metadata */
+	ICE_PROT_INVALID	= 255  /* when offset == ICE_FV_OFFSET_INVAL */
+};
+#endif /* _ICE_PROTOCOL_TYPE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index b5a53f862a83..431266081a80 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -49,42 +49,6 @@ static const u8 dummy_eth_header[DUMMY_ETH_HDR_LEN] = { 0x2, 0, 0, 0, 0, 0,
 	 sizeof(((struct ice_sw_rule_vsi_list *)0)->vsi) + \
 	 ((n) * sizeof(((struct ice_sw_rule_vsi_list *)0)->vsi)))
 
-/**
- * ice_aq_alloc_free_res - command to allocate/free resources
- * @hw: pointer to the HW struct
- * @num_entries: number of resource entries in buffer
- * @buf: Indirect buffer to hold data parameters and response
- * @buf_size: size of buffer for indirect commands
- * @opc: pass in the command opcode
- * @cd: pointer to command details structure or NULL
- *
- * Helper function to allocate/free resources using the admin queue commands
- */
-static enum ice_status
-ice_aq_alloc_free_res(struct ice_hw *hw, u16 num_entries,
-		      struct ice_aqc_alloc_free_res_elem *buf, u16 buf_size,
-		      enum ice_adminq_opc opc, struct ice_sq_cd *cd)
-{
-	struct ice_aqc_alloc_free_res_cmd *cmd;
-	struct ice_aq_desc desc;
-
-	cmd = &desc.params.sw_res_ctrl;
-
-	if (!buf)
-		return ICE_ERR_PARAM;
-
-	if (buf_size < (num_entries * sizeof(buf->elem[0])))
-		return ICE_ERR_PARAM;
-
-	ice_fill_dflt_direct_cmd_desc(&desc, opc);
-
-	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
-
-	cmd->num_entries = cpu_to_le16(num_entries);
-
-	return ice_aq_send_cmd(hw, &desc, buf, buf_size, cd);
-}
-
 /**
  * ice_init_def_sw_recp - initialize the recipe book keeping tables
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index ac38af105f90..b361ffabb0ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -13,6 +13,7 @@
 #include "ice_controlq.h"
 #include "ice_lan_tx_rx.h"
 #include "ice_flex_type.h"
+#include "ice_protocol_type.h"
 
 static inline bool ice_is_tc_ena(unsigned long bitmap, u8 tc)
 {
@@ -41,6 +42,7 @@ static inline u32 ice_round_to_num(u32 N, u32 R)
 #define ICE_DBG_QCTX		BIT_ULL(6)
 #define ICE_DBG_NVM		BIT_ULL(7)
 #define ICE_DBG_LAN		BIT_ULL(8)
+#define ICE_DBG_FLOW		BIT_ULL(9)
 #define ICE_DBG_SW		BIT_ULL(13)
 #define ICE_DBG_SCHED		BIT_ULL(14)
 #define ICE_DBG_PKG		BIT_ULL(16)
-- 
2.24.1

