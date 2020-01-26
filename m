Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5AB14996B
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 07:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgAZGHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 01:07:44 -0500
Received: from mga14.intel.com ([192.55.52.115]:18152 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbgAZGHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 01:07:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 22:07:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,364,1574150400"; 
   d="scan'208";a="230947210"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2020 22:07:40 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Henry Tieman <henry.w.tieman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 3/8] ice: Populate TCAM filter software structures
Date:   Sat, 25 Jan 2020 22:07:32 -0800
Message-Id: <20200126060737.3238027-4-jeffrey.t.kirsher@intel.com>
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

Store the TCAM entry with the profile data and the VSI group in the
respective SW structures. This will be subsequently used to write out
the tables to hardware.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |    1 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   33 +
 drivers/net/ethernet/intel/ice/ice_common.h   |    2 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 1318 +++++++++++++++++
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |    2 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |   51 +
 drivers/net/ethernet/intel/ice/ice_flow.c     |   61 +-
 drivers/net/ethernet/intel/ice/ice_status.h   |    1 +
 8 files changed, 1459 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index ad15a772b609..9967973a7c42 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -233,6 +233,7 @@ struct ice_aqc_get_sw_cfg_resp {
 #define ICE_AQC_RES_TYPE_VSI_LIST_REP			0x03
 #define ICE_AQC_RES_TYPE_VSI_LIST_PRUNE			0x04
 #define ICE_AQC_RES_TYPE_HASH_PROF_BLDR_PROFID		0x60
+#define ICE_AQC_RES_TYPE_HASH_PROF_BLDR_TCAM		0x61
 
 #define ICE_AQC_RES_TYPE_FLAG_SCAN_BOTTOM		BIT(12)
 #define ICE_AQC_RES_TYPE_FLAG_IGNORE_INDEX		BIT(13)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 8f86962fd052..0207e28c2682 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1572,6 +1572,39 @@ ice_alloc_hw_res(struct ice_hw *hw, u16 type, u16 num, bool btm, u16 *res)
 	return status;
 }
 
+/**
+ * ice_free_hw_res - free allocated HW resource
+ * @hw: pointer to the HW struct
+ * @type: type of resource to free
+ * @num: number of resources
+ * @res: pointer to array that contains the resources to free
+ */
+enum ice_status
+ice_free_hw_res(struct ice_hw *hw, u16 type, u16 num, u16 *res)
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
+	/* Prepare buffer to free resource. */
+	buf->num_elems = cpu_to_le16(num);
+	buf->res_type = cpu_to_le16(type);
+	memcpy(buf->elem, res, sizeof(buf->elem) * num);
+
+	status = ice_aq_alloc_free_res(hw, num, buf, buf_len,
+				       ice_aqc_opc_free_res, NULL);
+	if (status)
+		ice_debug(hw, ICE_DBG_SW, "CQ CMD Buffer:\n");
+
+	kfree(buf);
+	return status;
+}
+
 /**
  * ice_get_num_per_func - determine number of resources per PF
  * @hw: pointer to the HW structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 81e8ac925b9c..b5c013fdaaf9 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -36,6 +36,8 @@ ice_acquire_res(struct ice_hw *hw, enum ice_aq_res_ids res,
 void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res);
 enum ice_status
 ice_alloc_hw_res(struct ice_hw *hw, u16 type, u16 num, bool btm, u16 *res);
+enum ice_status
+ice_free_hw_res(struct ice_hw *hw, u16 type, u16 num, u16 *res);
 enum ice_status ice_init_nvm(struct ice_hw *hw);
 enum ice_status
 ice_read_sr_buf(struct ice_hw *hw, u16 offset, u16 *words, u16 *data);
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 5c09d3105b8b..8c93c303a4a5 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -159,6 +159,176 @@ ice_pkg_enum_section(struct ice_seg *ice_seg, struct ice_pkg_enum *state,
 	return state->sect;
 }
 
+/* Key creation */
+
+#define ICE_DC_KEY	0x1	/* don't care */
+#define ICE_DC_KEYINV	0x1
+#define ICE_NM_KEY	0x0	/* never match */
+#define ICE_NM_KEYINV	0x0
+#define ICE_0_KEY	0x1	/* match 0 */
+#define ICE_0_KEYINV	0x0
+#define ICE_1_KEY	0x0	/* match 1 */
+#define ICE_1_KEYINV	0x1
+
+/**
+ * ice_gen_key_word - generate 16-bits of a key/mask word
+ * @val: the value
+ * @valid: valid bits mask (change only the valid bits)
+ * @dont_care: don't care mask
+ * @nvr_mtch: never match mask
+ * @key: pointer to an array of where the resulting key portion
+ * @key_inv: pointer to an array of where the resulting key invert portion
+ *
+ * This function generates 16-bits from a 8-bit value, an 8-bit don't care mask
+ * and an 8-bit never match mask. The 16-bits of output are divided into 8 bits
+ * of key and 8 bits of key invert.
+ *
+ *     '0' =    b01, always match a 0 bit
+ *     '1' =    b10, always match a 1 bit
+ *     '?' =    b11, don't care bit (always matches)
+ *     '~' =    b00, never match bit
+ *
+ * Input:
+ *          val:         b0  1  0  1  0  1
+ *          dont_care:   b0  0  1  1  0  0
+ *          never_mtch:  b0  0  0  0  1  1
+ *          ------------------------------
+ * Result:  key:        b01 10 11 11 00 00
+ */
+static enum ice_status
+ice_gen_key_word(u8 val, u8 valid, u8 dont_care, u8 nvr_mtch, u8 *key,
+		 u8 *key_inv)
+{
+	u8 in_key = *key, in_key_inv = *key_inv;
+	u8 i;
+
+	/* 'dont_care' and 'nvr_mtch' masks cannot overlap */
+	if ((dont_care ^ nvr_mtch) != (dont_care | nvr_mtch))
+		return ICE_ERR_CFG;
+
+	*key = 0;
+	*key_inv = 0;
+
+	/* encode the 8 bits into 8-bit key and 8-bit key invert */
+	for (i = 0; i < 8; i++) {
+		*key >>= 1;
+		*key_inv >>= 1;
+
+		if (!(valid & 0x1)) { /* change only valid bits */
+			*key |= (in_key & 0x1) << 7;
+			*key_inv |= (in_key_inv & 0x1) << 7;
+		} else if (dont_care & 0x1) { /* don't care bit */
+			*key |= ICE_DC_KEY << 7;
+			*key_inv |= ICE_DC_KEYINV << 7;
+		} else if (nvr_mtch & 0x1) { /* never match bit */
+			*key |= ICE_NM_KEY << 7;
+			*key_inv |= ICE_NM_KEYINV << 7;
+		} else if (val & 0x01) { /* exact 1 match */
+			*key |= ICE_1_KEY << 7;
+			*key_inv |= ICE_1_KEYINV << 7;
+		} else { /* exact 0 match */
+			*key |= ICE_0_KEY << 7;
+			*key_inv |= ICE_0_KEYINV << 7;
+		}
+
+		dont_care >>= 1;
+		nvr_mtch >>= 1;
+		valid >>= 1;
+		val >>= 1;
+		in_key >>= 1;
+		in_key_inv >>= 1;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_bits_max_set - determine if the number of bits set is within a maximum
+ * @mask: pointer to the byte array which is the mask
+ * @size: the number of bytes in the mask
+ * @max: the max number of set bits
+ *
+ * This function determines if there are at most 'max' number of bits set in an
+ * array. Returns true if the number for bits set is <= max or will return false
+ * otherwise.
+ */
+static bool ice_bits_max_set(const u8 *mask, u16 size, u16 max)
+{
+	u16 count = 0;
+	u16 i;
+
+	/* check each byte */
+	for (i = 0; i < size; i++) {
+		/* if 0, go to next byte */
+		if (!mask[i])
+			continue;
+
+		/* We know there is at least one set bit in this byte because of
+		 * the above check; if we already have found 'max' number of
+		 * bits set, then we can return failure now.
+		 */
+		if (count == max)
+			return false;
+
+		/* count the bits in this byte, checking threshold */
+		count += hweight8(mask[i]);
+		if (count > max)
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * ice_set_key - generate a variable sized key with multiples of 16-bits
+ * @key: pointer to where the key will be stored
+ * @size: the size of the complete key in bytes (must be even)
+ * @val: array of 8-bit values that makes up the value portion of the key
+ * @upd: array of 8-bit masks that determine what key portion to update
+ * @dc: array of 8-bit masks that make up the don't care mask
+ * @nm: array of 8-bit masks that make up the never match mask
+ * @off: the offset of the first byte in the key to update
+ * @len: the number of bytes in the key update
+ *
+ * This function generates a key from a value, a don't care mask and a never
+ * match mask.
+ * upd, dc, and nm are optional parameters, and can be NULL:
+ *	upd == NULL --> udp mask is all 1's (update all bits)
+ *	dc == NULL --> dc mask is all 0's (no don't care bits)
+ *	nm == NULL --> nm mask is all 0's (no never match bits)
+ */
+static enum ice_status
+ice_set_key(u8 *key, u16 size, u8 *val, u8 *upd, u8 *dc, u8 *nm, u16 off,
+	    u16 len)
+{
+	u16 half_size;
+	u16 i;
+
+	/* size must be a multiple of 2 bytes. */
+	if (size % 2)
+		return ICE_ERR_CFG;
+
+	half_size = size / 2;
+	if (off + len > half_size)
+		return ICE_ERR_CFG;
+
+	/* Make sure at most one bit is set in the never match mask. Having more
+	 * than one never match mask bit set will cause HW to consume excessive
+	 * power otherwise; this is a power management efficiency check.
+	 */
+#define ICE_NVR_MTCH_BITS_MAX	1
+	if (nm && !ice_bits_max_set(nm, len, ICE_NVR_MTCH_BITS_MAX))
+		return ICE_ERR_CFG;
+
+	for (i = 0; i < len; i++)
+		if (ice_gen_key_word(val[i], upd ? upd[i] : 0xff,
+				     dc ? dc[i] : 0, nm ? nm[i] : 0,
+				     key + off + i, key + half_size + off + i))
+			return ICE_ERR_CFG;
+
+	return 0;
+}
+
 /**
  * ice_acquire_global_cfg_lock
  * @hw: pointer to the HW structure
@@ -952,6 +1122,48 @@ enum ice_sid_all {
 	ICE_SID_OFF_COUNT,
 };
 
+/* Characteristic handling */
+
+/**
+ * ice_match_prop_lst - determine if properties of two lists match
+ * @list1: first properties list
+ * @list2: second properties list
+ *
+ * Count, cookies and the order must match in order to be considered equivalent.
+ */
+static bool
+ice_match_prop_lst(struct list_head *list1, struct list_head *list2)
+{
+	struct ice_vsig_prof *tmp1;
+	struct ice_vsig_prof *tmp2;
+	u16 chk_count = 0;
+	u16 count = 0;
+
+	/* compare counts */
+	list_for_each_entry(tmp1, list1, list)
+		count++;
+	list_for_each_entry(tmp2, list2, list)
+		chk_count++;
+	if (!count || count != chk_count)
+		return false;
+
+	tmp1 = list_first_entry(list1, struct ice_vsig_prof, list);
+	tmp2 = list_first_entry(list2, struct ice_vsig_prof, list);
+
+	/* profile cookies must compare, and in the exact same order to take
+	 * into account priority
+	 */
+	while (count--) {
+		if (tmp2->profile_cookie != tmp1->profile_cookie)
+			return false;
+
+		tmp1 = list_next_entry(tmp1, list);
+		tmp2 = list_next_entry(tmp2, list);
+	}
+
+	return true;
+}
+
 /* VSIG Management */
 
 /**
@@ -999,6 +1211,117 @@ static u16 ice_vsig_alloc_val(struct ice_hw *hw, enum ice_block blk, u16 vsig)
 	return ICE_VSIG_VALUE(idx, hw->pf_id);
 }
 
+/**
+ * ice_vsig_alloc - Finds a free entry and allocates a new VSIG
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ *
+ * This function will iterate through the VSIG list and mark the first
+ * unused entry for the new VSIG entry as used and return that value.
+ */
+static u16 ice_vsig_alloc(struct ice_hw *hw, enum ice_block blk)
+{
+	u16 i;
+
+	for (i = 1; i < ICE_MAX_VSIGS; i++)
+		if (!hw->blk[blk].xlt2.vsig_tbl[i].in_use)
+			return ice_vsig_alloc_val(hw, blk, i);
+
+	return ICE_DEFAULT_VSIG;
+}
+
+/**
+ * ice_find_dup_props_vsig - find VSI group with a specified set of properties
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @chs: characteristic list
+ * @vsig: returns the VSIG with the matching profiles, if found
+ *
+ * Each VSIG is associated with a characteristic set; i.e. all VSIs under
+ * a group have the same characteristic set. To check if there exists a VSIG
+ * which has the same characteristics as the input characteristics; this
+ * function will iterate through the XLT2 list and return the VSIG that has a
+ * matching configuration. In order to make sure that priorities are accounted
+ * for, the list must match exactly, including the order in which the
+ * characteristics are listed.
+ */
+static enum ice_status
+ice_find_dup_props_vsig(struct ice_hw *hw, enum ice_block blk,
+			struct list_head *chs, u16 *vsig)
+{
+	struct ice_xlt2 *xlt2 = &hw->blk[blk].xlt2;
+	u16 i;
+
+	for (i = 0; i < xlt2->count; i++)
+		if (xlt2->vsig_tbl[i].in_use &&
+		    ice_match_prop_lst(chs, &xlt2->vsig_tbl[i].prop_lst)) {
+			*vsig = ICE_VSIG_VALUE(i, hw->pf_id);
+			return 0;
+		}
+
+	return ICE_ERR_DOES_NOT_EXIST;
+}
+
+/**
+ * ice_vsig_free - free VSI group
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @vsig: VSIG to remove
+ *
+ * The function will remove all VSIs associated with the input VSIG and move
+ * them to the DEFAULT_VSIG and mark the VSIG available.
+ */
+static enum ice_status
+ice_vsig_free(struct ice_hw *hw, enum ice_block blk, u16 vsig)
+{
+	struct ice_vsig_prof *dtmp, *del;
+	struct ice_vsig_vsi *vsi_cur;
+	u16 idx;
+
+	idx = vsig & ICE_VSIG_IDX_M;
+	if (idx >= ICE_MAX_VSIGS)
+		return ICE_ERR_PARAM;
+
+	if (!hw->blk[blk].xlt2.vsig_tbl[idx].in_use)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	hw->blk[blk].xlt2.vsig_tbl[idx].in_use = false;
+
+	vsi_cur = hw->blk[blk].xlt2.vsig_tbl[idx].first_vsi;
+	/* If the VSIG has at least 1 VSI then iterate through the
+	 * list and remove the VSIs before deleting the group.
+	 */
+	if (vsi_cur) {
+		/* remove all vsis associated with this VSIG XLT2 entry */
+		do {
+			struct ice_vsig_vsi *tmp = vsi_cur->next_vsi;
+
+			vsi_cur->vsig = ICE_DEFAULT_VSIG;
+			vsi_cur->changed = 1;
+			vsi_cur->next_vsi = NULL;
+			vsi_cur = tmp;
+		} while (vsi_cur);
+
+		/* NULL terminate head of VSI list */
+		hw->blk[blk].xlt2.vsig_tbl[idx].first_vsi = NULL;
+	}
+
+	/* free characteristic list */
+	list_for_each_entry_safe(del, dtmp,
+				 &hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst,
+				 list) {
+		list_del(&del->list);
+		devm_kfree(ice_hw_to_dev(hw), del);
+	}
+
+	/* if VSIG characteristic list was cleared for reset
+	 * re-initialize the list head
+	 */
+	INIT_LIST_HEAD(&hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst);
+
+	return 0;
+}
+
 /**
  * ice_vsig_remove_vsi - remove VSI from VSIG
  * @hw: pointer to the hardware structure
@@ -1162,6 +1485,62 @@ static bool ice_prof_id_rsrc_type(enum ice_block blk, u16 *rsrc_type)
 	return true;
 }
 
+/**
+ * ice_tcam_ent_rsrc_type - get TCAM entry resource type for a block type
+ * @blk: the block type
+ * @rsrc_type: pointer to variable to receive the resource type
+ */
+static bool ice_tcam_ent_rsrc_type(enum ice_block blk, u16 *rsrc_type)
+{
+	switch (blk) {
+	case ICE_BLK_RSS:
+		*rsrc_type = ICE_AQC_RES_TYPE_HASH_PROF_BLDR_TCAM;
+		break;
+	default:
+		return false;
+	}
+	return true;
+}
+
+/**
+ * ice_alloc_tcam_ent - allocate hardware TCAM entry
+ * @hw: pointer to the HW struct
+ * @blk: the block to allocate the TCAM for
+ * @tcam_idx: pointer to variable to receive the TCAM entry
+ *
+ * This function allocates a new entry in a Profile ID TCAM for a specific
+ * block.
+ */
+static enum ice_status
+ice_alloc_tcam_ent(struct ice_hw *hw, enum ice_block blk, u16 *tcam_idx)
+{
+	u16 res_type;
+
+	if (!ice_tcam_ent_rsrc_type(blk, &res_type))
+		return ICE_ERR_PARAM;
+
+	return ice_alloc_hw_res(hw, res_type, 1, true, tcam_idx);
+}
+
+/**
+ * ice_free_tcam_ent - free hardware TCAM entry
+ * @hw: pointer to the HW struct
+ * @blk: the block from which to free the TCAM entry
+ * @tcam_idx: the TCAM entry to free
+ *
+ * This function frees an entry in a Profile ID TCAM for a specific block.
+ */
+static enum ice_status
+ice_free_tcam_ent(struct ice_hw *hw, enum ice_block blk, u16 tcam_idx)
+{
+	u16 res_type;
+
+	if (!ice_tcam_ent_rsrc_type(blk, &res_type))
+		return ICE_ERR_PARAM;
+
+	return ice_free_hw_res(hw, res_type, 1, &tcam_idx);
+}
+
 /**
  * ice_alloc_prof_id - allocate profile ID
  * @hw: pointer to the HW struct
@@ -1688,6 +2067,146 @@ enum ice_status ice_init_hw_tbls(struct ice_hw *hw)
 	return ICE_ERR_NO_MEMORY;
 }
 
+/**
+ * ice_prof_gen_key - generate profile ID key
+ * @hw: pointer to the HW struct
+ * @blk: the block in which to write profile ID to
+ * @ptg: packet type group (PTG) portion of key
+ * @vsig: VSIG portion of key
+ * @cdid: CDID portion of key
+ * @flags: flag portion of key
+ * @vl_msk: valid mask
+ * @dc_msk: don't care mask
+ * @nm_msk: never match mask
+ * @key: output of profile ID key
+ */
+static enum ice_status
+ice_prof_gen_key(struct ice_hw *hw, enum ice_block blk, u8 ptg, u16 vsig,
+		 u8 cdid, u16 flags, u8 vl_msk[ICE_TCAM_KEY_VAL_SZ],
+		 u8 dc_msk[ICE_TCAM_KEY_VAL_SZ], u8 nm_msk[ICE_TCAM_KEY_VAL_SZ],
+		 u8 key[ICE_TCAM_KEY_SZ])
+{
+	struct ice_prof_id_key inkey;
+
+	inkey.xlt1 = ptg;
+	inkey.xlt2_cdid = cpu_to_le16(vsig);
+	inkey.flags = cpu_to_le16(flags);
+
+	switch (hw->blk[blk].prof.cdid_bits) {
+	case 0:
+		break;
+	case 2:
+#define ICE_CD_2_M 0xC000U
+#define ICE_CD_2_S 14
+		inkey.xlt2_cdid &= ~cpu_to_le16(ICE_CD_2_M);
+		inkey.xlt2_cdid |= cpu_to_le16(BIT(cdid) << ICE_CD_2_S);
+		break;
+	case 4:
+#define ICE_CD_4_M 0xF000U
+#define ICE_CD_4_S 12
+		inkey.xlt2_cdid &= ~cpu_to_le16(ICE_CD_4_M);
+		inkey.xlt2_cdid |= cpu_to_le16(BIT(cdid) << ICE_CD_4_S);
+		break;
+	case 8:
+#define ICE_CD_8_M 0xFF00U
+#define ICE_CD_8_S 16
+		inkey.xlt2_cdid &= ~cpu_to_le16(ICE_CD_8_M);
+		inkey.xlt2_cdid |= cpu_to_le16(BIT(cdid) << ICE_CD_8_S);
+		break;
+	default:
+		ice_debug(hw, ICE_DBG_PKG, "Error in profile config\n");
+		break;
+	}
+
+	return ice_set_key(key, ICE_TCAM_KEY_SZ, (u8 *)&inkey, vl_msk, dc_msk,
+			   nm_msk, 0, ICE_TCAM_KEY_SZ / 2);
+}
+
+/**
+ * ice_tcam_write_entry - write TCAM entry
+ * @hw: pointer to the HW struct
+ * @blk: the block in which to write profile ID to
+ * @idx: the entry index to write to
+ * @prof_id: profile ID
+ * @ptg: packet type group (PTG) portion of key
+ * @vsig: VSIG portion of key
+ * @cdid: CDID portion of key
+ * @flags: flag portion of key
+ * @vl_msk: valid mask
+ * @dc_msk: don't care mask
+ * @nm_msk: never match mask
+ */
+static enum ice_status
+ice_tcam_write_entry(struct ice_hw *hw, enum ice_block blk, u16 idx,
+		     u8 prof_id, u8 ptg, u16 vsig, u8 cdid, u16 flags,
+		     u8 vl_msk[ICE_TCAM_KEY_VAL_SZ],
+		     u8 dc_msk[ICE_TCAM_KEY_VAL_SZ],
+		     u8 nm_msk[ICE_TCAM_KEY_VAL_SZ])
+{
+	struct ice_prof_tcam_entry;
+	enum ice_status status;
+
+	status = ice_prof_gen_key(hw, blk, ptg, vsig, cdid, flags, vl_msk,
+				  dc_msk, nm_msk, hw->blk[blk].prof.t[idx].key);
+	if (!status) {
+		hw->blk[blk].prof.t[idx].addr = cpu_to_le16(idx);
+		hw->blk[blk].prof.t[idx].prof_id = prof_id;
+	}
+
+	return status;
+}
+
+/**
+ * ice_vsig_get_ref - returns number of VSIs belong to a VSIG
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @vsig: VSIG to query
+ * @refs: pointer to variable to receive the reference count
+ */
+static enum ice_status
+ice_vsig_get_ref(struct ice_hw *hw, enum ice_block blk, u16 vsig, u16 *refs)
+{
+	u16 idx = vsig & ICE_VSIG_IDX_M;
+	struct ice_vsig_vsi *ptr;
+
+	*refs = 0;
+
+	if (!hw->blk[blk].xlt2.vsig_tbl[idx].in_use)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	ptr = hw->blk[blk].xlt2.vsig_tbl[idx].first_vsi;
+	while (ptr) {
+		(*refs)++;
+		ptr = ptr->next_vsi;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_has_prof_vsig - check to see if VSIG has a specific profile
+ * @hw: pointer to the hardware structure
+ * @blk: HW block
+ * @vsig: VSIG to check against
+ * @hdl: profile handle
+ */
+static bool
+ice_has_prof_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl)
+{
+	u16 idx = vsig & ICE_VSIG_IDX_M;
+	struct ice_vsig_prof *ent;
+
+	list_for_each_entry(ent, &hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst,
+			    list)
+		if (ent->profile_cookie == hdl)
+			return true;
+
+	ice_debug(hw, ICE_DBG_INIT,
+		  "Characteristic list for VSI group %d not found.\n",
+		  vsig);
+	return false;
+}
+
 /**
  * ice_add_prof - add profile
  * @hw: pointer to the HW struct
@@ -1792,3 +2311,802 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 	mutex_unlock(&hw->blk[blk].es.prof_map_lock);
 	return status;
 }
+
+/**
+ * ice_search_prof_id_low - Search for a profile tracking ID low level
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @id: profile tracking ID
+ *
+ * This will search for a profile tracking ID which was previously added. This
+ * version assumes that the caller has already acquired the prof map lock.
+ */
+static struct ice_prof_map *
+ice_search_prof_id_low(struct ice_hw *hw, enum ice_block blk, u64 id)
+{
+	struct ice_prof_map *entry = NULL;
+	struct ice_prof_map *map;
+
+	list_for_each_entry(map, &hw->blk[blk].es.prof_map, list)
+		if (map->profile_cookie == id) {
+			entry = map;
+			break;
+		}
+
+	return entry;
+}
+
+/**
+ * ice_search_prof_id - Search for a profile tracking ID
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @id: profile tracking ID
+ *
+ * This will search for a profile tracking ID which was previously added.
+ */
+static struct ice_prof_map *
+ice_search_prof_id(struct ice_hw *hw, enum ice_block blk, u64 id)
+{
+	struct ice_prof_map *entry;
+
+	mutex_lock(&hw->blk[blk].es.prof_map_lock);
+	entry = ice_search_prof_id_low(hw, blk, id);
+	mutex_unlock(&hw->blk[blk].es.prof_map_lock);
+
+	return entry;
+}
+
+/**
+ * ice_rel_tcam_idx - release a TCAM index
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @idx: the index to release
+ */
+static enum ice_status
+ice_rel_tcam_idx(struct ice_hw *hw, enum ice_block blk, u16 idx)
+{
+	/* Masks to invoke a never match entry */
+	u8 vl_msk[ICE_TCAM_KEY_VAL_SZ] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+	u8 dc_msk[ICE_TCAM_KEY_VAL_SZ] = { 0xFE, 0xFF, 0xFF, 0xFF, 0xFF };
+	u8 nm_msk[ICE_TCAM_KEY_VAL_SZ] = { 0x01, 0x00, 0x00, 0x00, 0x00 };
+	enum ice_status status;
+
+	/* write the TCAM entry */
+	status = ice_tcam_write_entry(hw, blk, idx, 0, 0, 0, 0, 0, vl_msk,
+				      dc_msk, nm_msk);
+	if (status)
+		return status;
+
+	/* release the TCAM entry */
+	status = ice_free_tcam_ent(hw, blk, idx);
+
+	return status;
+}
+
+/**
+ * ice_rem_prof_id - remove one profile from a VSIG
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @prof: pointer to profile structure to remove
+ */
+static enum ice_status
+ice_rem_prof_id(struct ice_hw *hw, enum ice_block blk,
+		struct ice_vsig_prof *prof)
+{
+	enum ice_status status;
+	u16 i;
+
+	for (i = 0; i < prof->tcam_count; i++)
+		if (prof->tcam[i].in_use) {
+			prof->tcam[i].in_use = false;
+			status = ice_rel_tcam_idx(hw, blk,
+						  prof->tcam[i].tcam_idx);
+			if (status)
+				return ICE_ERR_HW_TABLE;
+		}
+
+	return 0;
+}
+
+/**
+ * ice_rem_vsig - remove VSIG
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsig: the VSIG to remove
+ * @chg: the change list
+ */
+static enum ice_status
+ice_rem_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig,
+	     struct list_head *chg)
+{
+	u16 idx = vsig & ICE_VSIG_IDX_M;
+	struct ice_vsig_vsi *vsi_cur;
+	struct ice_vsig_prof *d, *t;
+	enum ice_status status;
+
+	/* remove TCAM entries */
+	list_for_each_entry_safe(d, t,
+				 &hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst,
+				 list) {
+		status = ice_rem_prof_id(hw, blk, d);
+		if (status)
+			return status;
+
+		list_del(&d->list);
+		devm_kfree(ice_hw_to_dev(hw), d);
+	}
+
+	/* Move all VSIS associated with this VSIG to the default VSIG */
+	vsi_cur = hw->blk[blk].xlt2.vsig_tbl[idx].first_vsi;
+	/* If the VSIG has at least 1 VSI then iterate through the list
+	 * and remove the VSIs before deleting the group.
+	 */
+	if (vsi_cur)
+		do {
+			struct ice_vsig_vsi *tmp = vsi_cur->next_vsi;
+			struct ice_chs_chg *p;
+
+			p = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*p),
+					 GFP_KERNEL);
+			if (!p)
+				return ICE_ERR_NO_MEMORY;
+
+			p->type = ICE_VSIG_REM;
+			p->orig_vsig = vsig;
+			p->vsig = ICE_DEFAULT_VSIG;
+			p->vsi = vsi_cur - hw->blk[blk].xlt2.vsis;
+
+			list_add(&p->list_entry, chg);
+
+			vsi_cur = tmp;
+		} while (vsi_cur);
+
+	return ice_vsig_free(hw, blk, vsig);
+}
+
+/**
+ * ice_get_prof - get profile
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @hdl: profile handle
+ * @chg: change list
+ */
+static enum ice_status
+ice_get_prof(struct ice_hw *hw, enum ice_block blk, u64 hdl,
+	     struct list_head *chg)
+{
+	struct ice_prof_map *map;
+	struct ice_chs_chg *p;
+	u16 i;
+
+	/* Get the details on the profile specified by the handle ID */
+	map = ice_search_prof_id(hw, blk, hdl);
+	if (!map)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	for (i = 0; i < map->ptg_cnt; i++)
+		if (!hw->blk[blk].es.written[map->prof_id]) {
+			/* add ES to change list */
+			p = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*p),
+					 GFP_KERNEL);
+			if (!p)
+				goto err_ice_get_prof;
+
+			p->type = ICE_PTG_ES_ADD;
+			p->ptype = 0;
+			p->ptg = map->ptg[i];
+			p->add_ptg = 0;
+
+			p->add_prof = 1;
+			p->prof_id = map->prof_id;
+
+			hw->blk[blk].es.written[map->prof_id] = true;
+
+			list_add(&p->list_entry, chg);
+		}
+
+	return 0;
+
+err_ice_get_prof:
+	/* let caller clean up the change list */
+	return ICE_ERR_NO_MEMORY;
+}
+
+/**
+ * ice_get_profs_vsig - get a copy of the list of profiles from a VSIG
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsig: VSIG from which to copy the list
+ * @lst: output list
+ *
+ * This routine makes a copy of the list of profiles in the specified VSIG.
+ */
+static enum ice_status
+ice_get_profs_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig,
+		   struct list_head *lst)
+{
+	struct ice_vsig_prof *ent1, *ent2;
+	u16 idx = vsig & ICE_VSIG_IDX_M;
+
+	list_for_each_entry(ent1, &hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst,
+			    list) {
+		struct ice_vsig_prof *p;
+
+		/* copy to the input list */
+		p = devm_kmemdup(ice_hw_to_dev(hw), ent1, sizeof(*p),
+				 GFP_KERNEL);
+		if (!p)
+			goto err_ice_get_profs_vsig;
+
+		list_add_tail(&p->list, lst);
+	}
+
+	return 0;
+
+err_ice_get_profs_vsig:
+	list_for_each_entry_safe(ent1, ent2, lst, list) {
+		list_del(&ent1->list);
+		devm_kfree(ice_hw_to_dev(hw), ent1);
+	}
+
+	return ICE_ERR_NO_MEMORY;
+}
+
+/**
+ * ice_add_prof_to_lst - add profile entry to a list
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @lst: the list to be added to
+ * @hdl: profile handle of entry to add
+ */
+static enum ice_status
+ice_add_prof_to_lst(struct ice_hw *hw, enum ice_block blk,
+		    struct list_head *lst, u64 hdl)
+{
+	struct ice_prof_map *map;
+	struct ice_vsig_prof *p;
+	u16 i;
+
+	map = ice_search_prof_id(hw, blk, hdl);
+	if (!map)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	p = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return ICE_ERR_NO_MEMORY;
+
+	p->profile_cookie = map->profile_cookie;
+	p->prof_id = map->prof_id;
+	p->tcam_count = map->ptg_cnt;
+
+	for (i = 0; i < map->ptg_cnt; i++) {
+		p->tcam[i].prof_id = map->prof_id;
+		p->tcam[i].tcam_idx = ICE_INVALID_TCAM;
+		p->tcam[i].ptg = map->ptg[i];
+	}
+
+	list_add(&p->list, lst);
+
+	return 0;
+}
+
+/**
+ * ice_move_vsi - move VSI to another VSIG
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsi: the VSI to move
+ * @vsig: the VSIG to move the VSI to
+ * @chg: the change list
+ */
+static enum ice_status
+ice_move_vsi(struct ice_hw *hw, enum ice_block blk, u16 vsi, u16 vsig,
+	     struct list_head *chg)
+{
+	enum ice_status status;
+	struct ice_chs_chg *p;
+	u16 orig_vsig;
+
+	p = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return ICE_ERR_NO_MEMORY;
+
+	status = ice_vsig_find_vsi(hw, blk, vsi, &orig_vsig);
+	if (!status)
+		status = ice_vsig_add_mv_vsi(hw, blk, vsi, vsig);
+
+	if (status) {
+		devm_kfree(ice_hw_to_dev(hw), p);
+		return status;
+	}
+
+	p->type = ICE_VSI_MOVE;
+	p->vsi = vsi;
+	p->orig_vsig = orig_vsig;
+	p->vsig = vsig;
+
+	list_add(&p->list_entry, chg);
+
+	return 0;
+}
+
+/**
+ * ice_prof_tcam_ena_dis - add enable or disable TCAM change
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @enable: true to enable, false to disable
+ * @vsig: the VSIG of the TCAM entry
+ * @tcam: pointer the TCAM info structure of the TCAM to disable
+ * @chg: the change list
+ *
+ * This function appends an enable or disable TCAM entry in the change log
+ */
+static enum ice_status
+ice_prof_tcam_ena_dis(struct ice_hw *hw, enum ice_block blk, bool enable,
+		      u16 vsig, struct ice_tcam_inf *tcam,
+		      struct list_head *chg)
+{
+	enum ice_status status;
+	struct ice_chs_chg *p;
+
+	/* Default: enable means change the low flag bit to don't care */
+	u8 dc_msk[ICE_TCAM_KEY_VAL_SZ] = { 0x01, 0x00, 0x00, 0x00, 0x00 };
+	u8 nm_msk[ICE_TCAM_KEY_VAL_SZ] = { 0x00, 0x00, 0x00, 0x00, 0x00 };
+	u8 vl_msk[ICE_TCAM_KEY_VAL_SZ] = { 0x01, 0x00, 0x00, 0x00, 0x00 };
+
+	/* if disabling, free the TCAM */
+	if (!enable) {
+		status = ice_free_tcam_ent(hw, blk, tcam->tcam_idx);
+		tcam->tcam_idx = 0;
+		tcam->in_use = 0;
+		return status;
+	}
+
+	/* for re-enabling, reallocate a TCAM */
+	status = ice_alloc_tcam_ent(hw, blk, &tcam->tcam_idx);
+	if (status)
+		return status;
+
+	/* add TCAM to change list */
+	p = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return ICE_ERR_NO_MEMORY;
+
+	status = ice_tcam_write_entry(hw, blk, tcam->tcam_idx, tcam->prof_id,
+				      tcam->ptg, vsig, 0, 0, vl_msk, dc_msk,
+				      nm_msk);
+	if (status)
+		goto err_ice_prof_tcam_ena_dis;
+
+	tcam->in_use = 1;
+
+	p->type = ICE_TCAM_ADD;
+	p->add_tcam_idx = true;
+	p->prof_id = tcam->prof_id;
+	p->ptg = tcam->ptg;
+	p->vsig = 0;
+	p->tcam_idx = tcam->tcam_idx;
+
+	/* log change */
+	list_add(&p->list_entry, chg);
+
+	return 0;
+
+err_ice_prof_tcam_ena_dis:
+	devm_kfree(ice_hw_to_dev(hw), p);
+	return status;
+}
+
+/**
+ * ice_adj_prof_priorities - adjust profile based on priorities
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsig: the VSIG for which to adjust profile priorities
+ * @chg: the change list
+ */
+static enum ice_status
+ice_adj_prof_priorities(struct ice_hw *hw, enum ice_block blk, u16 vsig,
+			struct list_head *chg)
+{
+	DECLARE_BITMAP(ptgs_used, ICE_XLT1_CNT);
+	struct ice_vsig_prof *t;
+	enum ice_status status;
+	u16 idx;
+
+	bitmap_zero(ptgs_used, ICE_XLT1_CNT);
+	idx = vsig & ICE_VSIG_IDX_M;
+
+	/* Priority is based on the order in which the profiles are added. The
+	 * newest added profile has highest priority and the oldest added
+	 * profile has the lowest priority. Since the profile property list for
+	 * a VSIG is sorted from newest to oldest, this code traverses the list
+	 * in order and enables the first of each PTG that it finds (that is not
+	 * already enabled); it also disables any duplicate PTGs that it finds
+	 * in the older profiles (that are currently enabled).
+	 */
+
+	list_for_each_entry(t, &hw->blk[blk].xlt2.vsig_tbl[idx].prop_lst,
+			    list) {
+		u16 i;
+
+		for (i = 0; i < t->tcam_count; i++) {
+			/* Scan the priorities from newest to oldest.
+			 * Make sure that the newest profiles take priority.
+			 */
+			if (test_bit(t->tcam[i].ptg, ptgs_used) &&
+			    t->tcam[i].in_use) {
+				/* need to mark this PTG as never match, as it
+				 * was already in use and therefore duplicate
+				 * (and lower priority)
+				 */
+				status = ice_prof_tcam_ena_dis(hw, blk, false,
+							       vsig,
+							       &t->tcam[i],
+							       chg);
+				if (status)
+					return status;
+			} else if (!test_bit(t->tcam[i].ptg, ptgs_used) &&
+				   !t->tcam[i].in_use) {
+				/* need to enable this PTG, as it in not in use
+				 * and not enabled (highest priority)
+				 */
+				status = ice_prof_tcam_ena_dis(hw, blk, true,
+							       vsig,
+							       &t->tcam[i],
+							       chg);
+				if (status)
+					return status;
+			}
+
+			/* keep track of used ptgs */
+			set_bit(t->tcam[i].ptg, ptgs_used);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ice_add_prof_id_vsig - add profile to VSIG
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsig: the VSIG to which this profile is to be added
+ * @hdl: the profile handle indicating the profile to add
+ * @chg: the change list
+ */
+static enum ice_status
+ice_add_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl,
+		     struct list_head *chg)
+{
+	/* Masks that ignore flags */
+	u8 vl_msk[ICE_TCAM_KEY_VAL_SZ] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+	u8 dc_msk[ICE_TCAM_KEY_VAL_SZ] = { 0xFF, 0xFF, 0x00, 0x00, 0x00 };
+	u8 nm_msk[ICE_TCAM_KEY_VAL_SZ] = { 0x00, 0x00, 0x00, 0x00, 0x00 };
+	struct ice_prof_map *map;
+	struct ice_vsig_prof *t;
+	struct ice_chs_chg *p;
+	u16 i;
+
+	/* Get the details on the profile specified by the handle ID */
+	map = ice_search_prof_id(hw, blk, hdl);
+	if (!map)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	/* Error, if this VSIG already has this profile */
+	if (ice_has_prof_vsig(hw, blk, vsig, hdl))
+		return ICE_ERR_ALREADY_EXISTS;
+
+	/* new VSIG profile structure */
+	t = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*t), GFP_KERNEL);
+	if (!t)
+		return ICE_ERR_NO_MEMORY;
+
+	t->profile_cookie = map->profile_cookie;
+	t->prof_id = map->prof_id;
+	t->tcam_count = map->ptg_cnt;
+
+	/* create TCAM entries */
+	for (i = 0; i < map->ptg_cnt; i++) {
+		enum ice_status status;
+		u16 tcam_idx;
+
+		/* add TCAM to change list */
+		p = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*p), GFP_KERNEL);
+		if (!p)
+			goto err_ice_add_prof_id_vsig;
+
+		/* allocate the TCAM entry index */
+		status = ice_alloc_tcam_ent(hw, blk, &tcam_idx);
+		if (status) {
+			devm_kfree(ice_hw_to_dev(hw), p);
+			goto err_ice_add_prof_id_vsig;
+		}
+
+		t->tcam[i].ptg = map->ptg[i];
+		t->tcam[i].prof_id = map->prof_id;
+		t->tcam[i].tcam_idx = tcam_idx;
+		t->tcam[i].in_use = true;
+
+		p->type = ICE_TCAM_ADD;
+		p->add_tcam_idx = true;
+		p->prof_id = t->tcam[i].prof_id;
+		p->ptg = t->tcam[i].ptg;
+		p->vsig = vsig;
+		p->tcam_idx = t->tcam[i].tcam_idx;
+
+		/* write the TCAM entry */
+		status = ice_tcam_write_entry(hw, blk, t->tcam[i].tcam_idx,
+					      t->tcam[i].prof_id,
+					      t->tcam[i].ptg, vsig, 0, 0,
+					      vl_msk, dc_msk, nm_msk);
+		if (status)
+			goto err_ice_add_prof_id_vsig;
+
+		/* log change */
+		list_add(&p->list_entry, chg);
+	}
+
+	/* add profile to VSIG */
+	list_add(&t->list,
+		 &hw->blk[blk].xlt2.vsig_tbl[(vsig & ICE_VSIG_IDX_M)].prop_lst);
+
+	return 0;
+
+err_ice_add_prof_id_vsig:
+	/* let caller clean up the change list */
+	devm_kfree(ice_hw_to_dev(hw), t);
+	return ICE_ERR_NO_MEMORY;
+}
+
+/**
+ * ice_create_prof_id_vsig - add a new VSIG with a single profile
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsi: the initial VSI that will be in VSIG
+ * @hdl: the profile handle of the profile that will be added to the VSIG
+ * @chg: the change list
+ */
+static enum ice_status
+ice_create_prof_id_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl,
+			struct list_head *chg)
+{
+	enum ice_status status;
+	struct ice_chs_chg *p;
+	u16 new_vsig;
+
+	p = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return ICE_ERR_NO_MEMORY;
+
+	new_vsig = ice_vsig_alloc(hw, blk);
+	if (!new_vsig) {
+		status = ICE_ERR_HW_TABLE;
+		goto err_ice_create_prof_id_vsig;
+	}
+
+	status = ice_move_vsi(hw, blk, vsi, new_vsig, chg);
+	if (status)
+		goto err_ice_create_prof_id_vsig;
+
+	status = ice_add_prof_id_vsig(hw, blk, new_vsig, hdl, chg);
+	if (status)
+		goto err_ice_create_prof_id_vsig;
+
+	p->type = ICE_VSIG_ADD;
+	p->vsi = vsi;
+	p->orig_vsig = ICE_DEFAULT_VSIG;
+	p->vsig = new_vsig;
+
+	list_add(&p->list_entry, chg);
+
+	return 0;
+
+err_ice_create_prof_id_vsig:
+	/* let caller clean up the change list */
+	devm_kfree(ice_hw_to_dev(hw), p);
+	return status;
+}
+
+/**
+ * ice_create_vsig_from_lst - create a new VSIG with a list of profiles
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsi: the initial VSI that will be in VSIG
+ * @lst: the list of profile that will be added to the VSIG
+ * @chg: the change list
+ */
+static enum ice_status
+ice_create_vsig_from_lst(struct ice_hw *hw, enum ice_block blk, u16 vsi,
+			 struct list_head *lst, struct list_head *chg)
+{
+	struct ice_vsig_prof *t;
+	enum ice_status status;
+	u16 vsig;
+
+	vsig = ice_vsig_alloc(hw, blk);
+	if (!vsig)
+		return ICE_ERR_HW_TABLE;
+
+	status = ice_move_vsi(hw, blk, vsi, vsig, chg);
+	if (status)
+		return status;
+
+	list_for_each_entry(t, lst, list) {
+		status = ice_add_prof_id_vsig(hw, blk, vsig, t->profile_cookie,
+					      chg);
+		if (status)
+			return status;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_find_prof_vsig - find a VSIG with a specific profile handle
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @hdl: the profile handle of the profile to search for
+ * @vsig: returns the VSIG with the matching profile
+ */
+static bool
+ice_find_prof_vsig(struct ice_hw *hw, enum ice_block blk, u64 hdl, u16 *vsig)
+{
+	struct ice_vsig_prof *t;
+	enum ice_status status;
+	struct list_head lst;
+
+	INIT_LIST_HEAD(&lst);
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
+	if (!t)
+		return false;
+
+	t->profile_cookie = hdl;
+	list_add(&t->list, &lst);
+
+	status = ice_find_dup_props_vsig(hw, blk, &lst, vsig);
+
+	list_del(&t->list);
+	kfree(t);
+
+	return !status;
+}
+
+/**
+ * ice_add_prof_id_flow - add profile flow
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @vsi: the VSI to enable with the profile specified by ID
+ * @hdl: profile handle
+ *
+ * Calling this function will update the hardware tables to enable the
+ * profile indicated by the ID parameter for the VSIs specified in the VSI
+ * array. Once successfully called, the flow will be enabled.
+ */
+enum ice_status
+ice_add_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl)
+{
+	struct ice_vsig_prof *tmp1, *del1;
+	struct ice_chs_chg *tmp, *del;
+	struct list_head union_lst;
+	enum ice_status status;
+	struct list_head chg;
+	u16 vsig;
+
+	INIT_LIST_HEAD(&union_lst);
+	INIT_LIST_HEAD(&chg);
+
+	/* Get profile */
+	status = ice_get_prof(hw, blk, hdl, &chg);
+	if (status)
+		return status;
+
+	/* determine if VSI is already part of a VSIG */
+	status = ice_vsig_find_vsi(hw, blk, vsi, &vsig);
+	if (!status && vsig) {
+		bool only_vsi;
+		u16 or_vsig;
+		u16 ref;
+
+		/* found in VSIG */
+		or_vsig = vsig;
+
+		/* make sure that there is no overlap/conflict between the new
+		 * characteristics and the existing ones; we don't support that
+		 * scenario
+		 */
+		if (ice_has_prof_vsig(hw, blk, vsig, hdl)) {
+			status = ICE_ERR_ALREADY_EXISTS;
+			goto err_ice_add_prof_id_flow;
+		}
+
+		/* last VSI in the VSIG? */
+		status = ice_vsig_get_ref(hw, blk, vsig, &ref);
+		if (status)
+			goto err_ice_add_prof_id_flow;
+		only_vsi = (ref == 1);
+
+		/* create a union of the current profiles and the one being
+		 * added
+		 */
+		status = ice_get_profs_vsig(hw, blk, vsig, &union_lst);
+		if (status)
+			goto err_ice_add_prof_id_flow;
+
+		status = ice_add_prof_to_lst(hw, blk, &union_lst, hdl);
+		if (status)
+			goto err_ice_add_prof_id_flow;
+
+		/* search for an existing VSIG with an exact charc match */
+		status = ice_find_dup_props_vsig(hw, blk, &union_lst, &vsig);
+		if (!status) {
+			/* move VSI to the VSIG that matches */
+			status = ice_move_vsi(hw, blk, vsi, vsig, &chg);
+			if (status)
+				goto err_ice_add_prof_id_flow;
+
+			/* VSI has been moved out of or_vsig. If the or_vsig had
+			 * only that VSI it is now empty and can be removed.
+			 */
+			if (only_vsi) {
+				status = ice_rem_vsig(hw, blk, or_vsig, &chg);
+				if (status)
+					goto err_ice_add_prof_id_flow;
+			}
+		} else if (only_vsi) {
+			/* If the original VSIG only contains one VSI, then it
+			 * will be the requesting VSI. In this case the VSI is
+			 * not sharing entries and we can simply add the new
+			 * profile to the VSIG.
+			 */
+			status = ice_add_prof_id_vsig(hw, blk, vsig, hdl, &chg);
+			if (status)
+				goto err_ice_add_prof_id_flow;
+
+			/* Adjust priorities */
+			status = ice_adj_prof_priorities(hw, blk, vsig, &chg);
+			if (status)
+				goto err_ice_add_prof_id_flow;
+		} else {
+			/* No match, so we need a new VSIG */
+			status = ice_create_vsig_from_lst(hw, blk, vsi,
+							  &union_lst, &chg);
+			if (status)
+				goto err_ice_add_prof_id_flow;
+
+			/* Adjust priorities */
+			status = ice_adj_prof_priorities(hw, blk, vsig, &chg);
+			if (status)
+				goto err_ice_add_prof_id_flow;
+		}
+	} else {
+		/* need to find or add a VSIG */
+		/* search for an existing VSIG with an exact charc match */
+		if (ice_find_prof_vsig(hw, blk, hdl, &vsig)) {
+			/* found an exact match */
+			/* add or move VSI to the VSIG that matches */
+			status = ice_move_vsi(hw, blk, vsi, vsig, &chg);
+			if (status)
+				goto err_ice_add_prof_id_flow;
+		} else {
+			/* we did not find an exact match */
+			/* we need to add a VSIG */
+			status = ice_create_prof_id_vsig(hw, blk, vsi, hdl,
+							 &chg);
+			if (status)
+				goto err_ice_add_prof_id_flow;
+		}
+	}
+
+err_ice_add_prof_id_flow:
+	list_for_each_entry_safe(del, tmp, &chg, list_entry) {
+		list_del(&del->list_entry);
+		devm_kfree(ice_hw_to_dev(hw), del);
+	}
+
+	list_for_each_entry_safe(del1, tmp1, &union_lst, list) {
+		list_del(&del1->list);
+		devm_kfree(ice_hw_to_dev(hw), del1);
+	}
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index 8cb7d7f09e0b..33e4510da24c 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -21,6 +21,8 @@
 enum ice_status
 ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 	     struct ice_fv_word *es);
+enum ice_status
+ice_add_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl);
 enum ice_status ice_init_pkg(struct ice_hw *hw, u8 *buff, u32 len);
 enum ice_status
 ice_copy_and_init_pkg(struct ice_hw *hw, const u8 *buf, u32 len);
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index 3005f111fb3b..9d95d51bc760 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -283,6 +283,7 @@ struct ice_ptg_ptype {
 	u8 ptg;
 };
 
+#define ICE_MAX_TCAM_PER_PROFILE	32
 #define ICE_MAX_PTG_PER_PROFILE		32
 
 struct ice_prof_map {
@@ -294,6 +295,23 @@ struct ice_prof_map {
 	u8 ptg[ICE_MAX_PTG_PER_PROFILE];
 };
 
+#define ICE_INVALID_TCAM	0xFFFF
+
+struct ice_tcam_inf {
+	u16 tcam_idx;
+	u8 ptg;
+	u8 prof_id;
+	u8 in_use;
+};
+
+struct ice_vsig_prof {
+	struct list_head list;
+	u64 profile_cookie;
+	u8 prof_id;
+	u8 tcam_count;
+	struct ice_tcam_inf tcam[ICE_MAX_TCAM_PER_PROFILE];
+};
+
 struct ice_vsig_entry {
 	struct list_head prop_lst;
 	struct ice_vsig_vsi *first_vsi;
@@ -343,6 +361,13 @@ struct ice_xlt2 {
 	u16 count;
 };
 
+/* Profile ID Management */
+struct ice_prof_id_key {
+	__le16 flags;
+	u8 xlt1;
+	__le16 xlt2_cdid;
+} __packed;
+
 /* Keys are made up of two values, each one-half the size of the key.
  * For TCAM, the entire key is 80 bits wide (or 2, 40-bit wide values)
  */
@@ -385,5 +410,31 @@ struct ice_blk_info {
 	u8 is_list_init;
 };
 
+enum ice_chg_type {
+	ICE_TCAM_NONE = 0,
+	ICE_PTG_ES_ADD,
+	ICE_TCAM_ADD,
+	ICE_VSIG_ADD,
+	ICE_VSIG_REM,
+	ICE_VSI_MOVE,
+};
+
+struct ice_chs_chg {
+	struct list_head list_entry;
+	enum ice_chg_type type;
+
+	u8 add_ptg;
+	u8 add_vsig;
+	u8 add_tcam_idx;
+	u8 add_prof;
+	u16 ptype;
+	u8 ptg;
+	u8 prof_id;
+	u16 vsi;
+	u16 vsig;
+	u16 orig_vsig;
+	u16 tcam_idx;
+};
+
 #define ICE_FLOW_PTYPE_MAX		ICE_XLT1_CNT
 #endif /* _ICE_FLEX_TYPE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 24fe04f8baa2..1bbf4b6ed7d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -450,6 +450,38 @@ ice_flow_add_prof_sync(struct ice_hw *hw, enum ice_block blk,
 	return status;
 }
 
+/**
+ * ice_flow_assoc_prof - associate a VSI with a flow profile
+ * @hw: pointer to the hardware structure
+ * @blk: classification stage
+ * @prof: pointer to flow profile
+ * @vsi_handle: software VSI handle
+ *
+ * Assumption: the caller has acquired the lock to the profile list
+ * and the software VSI handle has been validated
+ */
+static enum ice_status
+ice_flow_assoc_prof(struct ice_hw *hw, enum ice_block blk,
+		    struct ice_flow_prof *prof, u16 vsi_handle)
+{
+	enum ice_status status = 0;
+
+	if (!test_bit(vsi_handle, prof->vsis)) {
+		status = ice_add_prof_id_flow(hw, blk,
+					      ice_get_hw_vsi_num(hw,
+								 vsi_handle),
+					      prof->id);
+		if (!status)
+			set_bit(vsi_handle, prof->vsis);
+		else
+			ice_debug(hw, ICE_DBG_FLOW,
+				  "HW profile add failed, %d\n",
+				  status);
+	}
+
+	return status;
+}
+
 /**
  * ice_flow_add_prof - Add a flow profile for packet segments and matched fields
  * @hw: pointer to the HW struct
@@ -458,12 +490,13 @@ ice_flow_add_prof_sync(struct ice_hw *hw, enum ice_block blk,
  * @prof_id: unique ID to identify this flow profile
  * @segs: array of one or more packet segments that describe the flow
  * @segs_cnt: number of packet segments provided
+ * @prof: stores the returned flow profile added
  */
 static enum ice_status
 ice_flow_add_prof(struct ice_hw *hw, enum ice_block blk, enum ice_flow_dir dir,
-		  u64 prof_id, struct ice_flow_seg_info *segs, u8 segs_cnt)
+		  u64 prof_id, struct ice_flow_seg_info *segs, u8 segs_cnt,
+		  struct ice_flow_prof **prof)
 {
-	struct ice_flow_prof *prof = NULL;
 	enum ice_status status;
 
 	if (segs_cnt > ICE_FLOW_SEG_MAX)
@@ -482,9 +515,9 @@ ice_flow_add_prof(struct ice_hw *hw, enum ice_block blk, enum ice_flow_dir dir,
 	mutex_lock(&hw->fl_profs_locks[blk]);
 
 	status = ice_flow_add_prof_sync(hw, blk, dir, prof_id, segs, segs_cnt,
-					&prof);
+					prof);
 	if (!status)
-		list_add(&prof->l_entry, &hw->fl_profs[blk]);
+		list_add(&(*prof)->l_entry, &hw->fl_profs[blk]);
 
 	mutex_unlock(&hw->fl_profs_locks[blk]);
 
@@ -634,6 +667,7 @@ ice_flow_set_rss_seg_info(struct ice_flow_seg_info *segs, u64 hash_fields,
 /**
  * ice_add_rss_cfg_sync - add an RSS configuration
  * @hw: pointer to the hardware structure
+ * @vsi_handle: software VSI handle
  * @hashed_flds: hash bit fields (ICE_FLOW_HASH_*) to configure
  * @addl_hdrs: protocol header fields
  * @segs_cnt: packet segment count
@@ -641,9 +675,11 @@ ice_flow_set_rss_seg_info(struct ice_flow_seg_info *segs, u64 hash_fields,
  * Assumption: lock has already been acquired for RSS list
  */
 static enum ice_status
-ice_add_rss_cfg_sync(struct ice_hw *hw, u64 hashed_flds, u32 addl_hdrs,
-		     u8 segs_cnt)
+ice_add_rss_cfg_sync(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
+		     u32 addl_hdrs, u8 segs_cnt)
 {
+	const enum ice_block blk = ICE_BLK_RSS;
+	struct ice_flow_prof *prof = NULL;
 	struct ice_flow_seg_info *segs;
 	enum ice_status status;
 
@@ -663,11 +699,15 @@ ice_add_rss_cfg_sync(struct ice_hw *hw, u64 hashed_flds, u32 addl_hdrs,
 	/* Create a new flow profile with generated profile and packet
 	 * segment information.
 	 */
-	status = ice_flow_add_prof(hw, ICE_BLK_RSS, ICE_FLOW_RX,
+	status = ice_flow_add_prof(hw, blk, ICE_FLOW_RX,
 				   ICE_FLOW_GEN_PROFID(hashed_flds,
 						       segs[segs_cnt - 1].hdrs,
 						       segs_cnt),
-				   segs, segs_cnt);
+				   segs, segs_cnt, &prof);
+	if (status)
+		goto exit;
+
+	status = ice_flow_assoc_prof(hw, blk, prof, vsi_handle);
 
 exit:
 	kfree(segs);
@@ -696,7 +736,7 @@ ice_add_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
 		return ICE_ERR_PARAM;
 
 	mutex_lock(&hw->rss_locks);
-	status = ice_add_rss_cfg_sync(hw, hashed_flds, addl_hdrs,
+	status = ice_add_rss_cfg_sync(hw, vsi_handle, hashed_flds, addl_hdrs,
 				      ICE_RSS_OUTER_HEADERS);
 	mutex_unlock(&hw->rss_locks);
 
@@ -719,7 +759,8 @@ enum ice_status ice_replay_rss_cfg(struct ice_hw *hw, u16 vsi_handle)
 	mutex_lock(&hw->rss_locks);
 	list_for_each_entry(r, &hw->rss_list_head, l_entry) {
 		if (test_bit(vsi_handle, r->vsis)) {
-			status = ice_add_rss_cfg_sync(hw, r->hashed_flds,
+			status = ice_add_rss_cfg_sync(hw, vsi_handle,
+						      r->hashed_flds,
 						      r->packet_hdr,
 						      ICE_RSS_OUTER_HEADERS);
 			if (status)
diff --git a/drivers/net/ethernet/intel/ice/ice_status.h b/drivers/net/ethernet/intel/ice/ice_status.h
index c01597885629..a9a8bc3aca42 100644
--- a/drivers/net/ethernet/intel/ice/ice_status.h
+++ b/drivers/net/ethernet/intel/ice/ice_status.h
@@ -26,6 +26,7 @@ enum ice_status {
 	ICE_ERR_IN_USE				= -16,
 	ICE_ERR_MAX_LIMIT			= -17,
 	ICE_ERR_RESET_ONGOING			= -18,
+	ICE_ERR_HW_TABLE			= -19,
 	ICE_ERR_NVM_CHECKSUM			= -51,
 	ICE_ERR_BUF_TOO_SHORT			= -52,
 	ICE_ERR_NVM_BLANK_MODE			= -53,
-- 
2.24.1

