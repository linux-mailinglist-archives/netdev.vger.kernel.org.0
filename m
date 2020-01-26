Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D75149970
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 07:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgAZGHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 01:07:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:18152 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbgAZGHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 01:07:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 22:07:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,364,1574150400"; 
   d="scan'208";a="230947213"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2020 22:07:40 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Henry Tieman <henry.w.tieman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 4/8] ice: Enable writing filtering tables
Date:   Sat, 25 Jan 2020 22:07:33 -0800
Message-Id: <20200126060737.3238027-5-jeffrey.t.kirsher@intel.com>
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

Write the hardware tables based on the populated software structures.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 604 ++++++++++++++++++
 .../net/ethernet/intel/ice/ice_flex_type.h    |  46 ++
 3 files changed, 651 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 9967973a7c42..4459bc564b11 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1856,6 +1856,7 @@ enum ice_adminq_opc {
 
 	/* package commands */
 	ice_aqc_opc_download_pkg			= 0x0C40,
+	ice_aqc_opc_update_pkg				= 0x0C42,
 	ice_aqc_opc_get_pkg_info_list			= 0x0C43,
 
 	/* debug commands */
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 8c93c303a4a5..6dca611b408a 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -5,6 +5,86 @@
 #include "ice_flex_pipe.h"
 #include "ice_flow.h"
 
+static const u32 ice_sect_lkup[ICE_BLK_COUNT][ICE_SECT_COUNT] = {
+	/* SWITCH */
+	{
+		ICE_SID_XLT0_SW,
+		ICE_SID_XLT_KEY_BUILDER_SW,
+		ICE_SID_XLT1_SW,
+		ICE_SID_XLT2_SW,
+		ICE_SID_PROFID_TCAM_SW,
+		ICE_SID_PROFID_REDIR_SW,
+		ICE_SID_FLD_VEC_SW,
+		ICE_SID_CDID_KEY_BUILDER_SW,
+		ICE_SID_CDID_REDIR_SW
+	},
+
+	/* ACL */
+	{
+		ICE_SID_XLT0_ACL,
+		ICE_SID_XLT_KEY_BUILDER_ACL,
+		ICE_SID_XLT1_ACL,
+		ICE_SID_XLT2_ACL,
+		ICE_SID_PROFID_TCAM_ACL,
+		ICE_SID_PROFID_REDIR_ACL,
+		ICE_SID_FLD_VEC_ACL,
+		ICE_SID_CDID_KEY_BUILDER_ACL,
+		ICE_SID_CDID_REDIR_ACL
+	},
+
+	/* FD */
+	{
+		ICE_SID_XLT0_FD,
+		ICE_SID_XLT_KEY_BUILDER_FD,
+		ICE_SID_XLT1_FD,
+		ICE_SID_XLT2_FD,
+		ICE_SID_PROFID_TCAM_FD,
+		ICE_SID_PROFID_REDIR_FD,
+		ICE_SID_FLD_VEC_FD,
+		ICE_SID_CDID_KEY_BUILDER_FD,
+		ICE_SID_CDID_REDIR_FD
+	},
+
+	/* RSS */
+	{
+		ICE_SID_XLT0_RSS,
+		ICE_SID_XLT_KEY_BUILDER_RSS,
+		ICE_SID_XLT1_RSS,
+		ICE_SID_XLT2_RSS,
+		ICE_SID_PROFID_TCAM_RSS,
+		ICE_SID_PROFID_REDIR_RSS,
+		ICE_SID_FLD_VEC_RSS,
+		ICE_SID_CDID_KEY_BUILDER_RSS,
+		ICE_SID_CDID_REDIR_RSS
+	},
+
+	/* PE */
+	{
+		ICE_SID_XLT0_PE,
+		ICE_SID_XLT_KEY_BUILDER_PE,
+		ICE_SID_XLT1_PE,
+		ICE_SID_XLT2_PE,
+		ICE_SID_PROFID_TCAM_PE,
+		ICE_SID_PROFID_REDIR_PE,
+		ICE_SID_FLD_VEC_PE,
+		ICE_SID_CDID_KEY_BUILDER_PE,
+		ICE_SID_CDID_REDIR_PE
+	}
+};
+
+/**
+ * ice_sect_id - returns section ID
+ * @blk: block type
+ * @sect: section type
+ *
+ * This helper function returns the proper section ID given a block type and a
+ * section type.
+ */
+static u32 ice_sect_id(enum ice_block blk, enum ice_sect sect)
+{
+	return ice_sect_lkup[blk][sect];
+}
+
 /**
  * ice_pkg_val_buf
  * @buf: pointer to the ice buffer
@@ -375,6 +455,31 @@ static void ice_release_global_cfg_lock(struct ice_hw *hw)
 	ice_release_res(hw, ICE_GLOBAL_CFG_LOCK_RES_ID);
 }
 
+/**
+ * ice_acquire_change_lock
+ * @hw: pointer to the HW structure
+ * @access: access type (read or write)
+ *
+ * This function will request ownership of the change lock.
+ */
+static enum ice_status
+ice_acquire_change_lock(struct ice_hw *hw, enum ice_aq_res_access_type access)
+{
+	return ice_acquire_res(hw, ICE_CHANGE_LOCK_RES_ID, access,
+			       ICE_CHANGE_LOCK_TIMEOUT);
+}
+
+/**
+ * ice_release_change_lock
+ * @hw: pointer to the HW structure
+ *
+ * This function will release the change lock using the proper Admin Command.
+ */
+static void ice_release_change_lock(struct ice_hw *hw)
+{
+	ice_release_res(hw, ICE_CHANGE_LOCK_RES_ID);
+}
+
 /**
  * ice_aq_download_pkg
  * @hw: pointer to the hardware structure
@@ -423,6 +528,54 @@ ice_aq_download_pkg(struct ice_hw *hw, struct ice_buf_hdr *pkg_buf,
 	return status;
 }
 
+/**
+ * ice_aq_update_pkg
+ * @hw: pointer to the hardware structure
+ * @pkg_buf: the package cmd buffer
+ * @buf_size: the size of the package cmd buffer
+ * @last_buf: last buffer indicator
+ * @error_offset: returns error offset
+ * @error_info: returns error information
+ * @cd: pointer to command details structure or NULL
+ *
+ * Update Package (0x0C42)
+ */
+static enum ice_status
+ice_aq_update_pkg(struct ice_hw *hw, struct ice_buf_hdr *pkg_buf, u16 buf_size,
+		  bool last_buf, u32 *error_offset, u32 *error_info,
+		  struct ice_sq_cd *cd)
+{
+	struct ice_aqc_download_pkg *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	if (error_offset)
+		*error_offset = 0;
+	if (error_info)
+		*error_info = 0;
+
+	cmd = &desc.params.download_pkg;
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_update_pkg);
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	if (last_buf)
+		cmd->flags |= ICE_AQC_DOWNLOAD_PKG_LAST_BUF;
+
+	status = ice_aq_send_cmd(hw, &desc, pkg_buf, buf_size, cd);
+	if (status == ICE_ERR_AQ_ERROR) {
+		/* Read error from buffer only when the FW returned an error */
+		struct ice_aqc_download_pkg_resp *resp;
+
+		resp = (struct ice_aqc_download_pkg_resp *)pkg_buf;
+		if (error_offset)
+			*error_offset = le32_to_cpu(resp->error_offset);
+		if (error_info)
+			*error_info = le32_to_cpu(resp->error_info);
+	}
+
+	return status;
+}
+
 /**
  * ice_find_seg_in_pkg
  * @hw: pointer to the hardware structure
@@ -457,6 +610,44 @@ ice_find_seg_in_pkg(struct ice_hw *hw, u32 seg_type,
 	return NULL;
 }
 
+/**
+ * ice_update_pkg
+ * @hw: pointer to the hardware structure
+ * @bufs: pointer to an array of buffers
+ * @count: the number of buffers in the array
+ *
+ * Obtains change lock and updates package.
+ */
+static enum ice_status
+ice_update_pkg(struct ice_hw *hw, struct ice_buf *bufs, u32 count)
+{
+	enum ice_status status;
+	u32 offset, info, i;
+
+	status = ice_acquire_change_lock(hw, ICE_RES_WRITE);
+	if (status)
+		return status;
+
+	for (i = 0; i < count; i++) {
+		struct ice_buf_hdr *bh = (struct ice_buf_hdr *)(bufs + i);
+		bool last = ((i + 1) == count);
+
+		status = ice_aq_update_pkg(hw, bh, le16_to_cpu(bh->data_end),
+					   last, &offset, &info, NULL);
+
+		if (status) {
+			ice_debug(hw, ICE_DBG_PKG,
+				  "Update pkg failed: err %d off %d inf %d\n",
+				  status, offset, info);
+			break;
+		}
+	}
+
+	ice_release_change_lock(hw);
+
+	return status;
+}
+
 /**
  * ice_dwnld_cfg_bufs
  * @hw: pointer to the hardware structure
@@ -938,6 +1129,169 @@ enum ice_status ice_copy_and_init_pkg(struct ice_hw *hw, const u8 *buf, u32 len)
 	return status;
 }
 
+/**
+ * ice_pkg_buf_alloc
+ * @hw: pointer to the HW structure
+ *
+ * Allocates a package buffer and returns a pointer to the buffer header.
+ * Note: all package contents must be in Little Endian form.
+ */
+static struct ice_buf_build *ice_pkg_buf_alloc(struct ice_hw *hw)
+{
+	struct ice_buf_build *bld;
+	struct ice_buf_hdr *buf;
+
+	bld = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*bld), GFP_KERNEL);
+	if (!bld)
+		return NULL;
+
+	buf = (struct ice_buf_hdr *)bld;
+	buf->data_end = cpu_to_le16(offsetof(struct ice_buf_hdr,
+					     section_entry));
+	return bld;
+}
+
+/**
+ * ice_pkg_buf_free
+ * @hw: pointer to the HW structure
+ * @bld: pointer to pkg build (allocated by ice_pkg_buf_alloc())
+ *
+ * Frees a package buffer
+ */
+static void ice_pkg_buf_free(struct ice_hw *hw, struct ice_buf_build *bld)
+{
+	devm_kfree(ice_hw_to_dev(hw), bld);
+}
+
+/**
+ * ice_pkg_buf_reserve_section
+ * @bld: pointer to pkg build (allocated by ice_pkg_buf_alloc())
+ * @count: the number of sections to reserve
+ *
+ * Reserves one or more section table entries in a package buffer. This routine
+ * can be called multiple times as long as they are made before calling
+ * ice_pkg_buf_alloc_section(). Once ice_pkg_buf_alloc_section()
+ * is called once, the number of sections that can be allocated will not be able
+ * to be increased; not using all reserved sections is fine, but this will
+ * result in some wasted space in the buffer.
+ * Note: all package contents must be in Little Endian form.
+ */
+static enum ice_status
+ice_pkg_buf_reserve_section(struct ice_buf_build *bld, u16 count)
+{
+	struct ice_buf_hdr *buf;
+	u16 section_count;
+	u16 data_end;
+
+	if (!bld)
+		return ICE_ERR_PARAM;
+
+	buf = (struct ice_buf_hdr *)&bld->buf;
+
+	/* already an active section, can't increase table size */
+	section_count = le16_to_cpu(buf->section_count);
+	if (section_count > 0)
+		return ICE_ERR_CFG;
+
+	if (bld->reserved_section_table_entries + count > ICE_MAX_S_COUNT)
+		return ICE_ERR_CFG;
+	bld->reserved_section_table_entries += count;
+
+	data_end = le16_to_cpu(buf->data_end) +
+		   (count * sizeof(buf->section_entry[0]));
+	buf->data_end = cpu_to_le16(data_end);
+
+	return 0;
+}
+
+/**
+ * ice_pkg_buf_alloc_section
+ * @bld: pointer to pkg build (allocated by ice_pkg_buf_alloc())
+ * @type: the section type value
+ * @size: the size of the section to reserve (in bytes)
+ *
+ * Reserves memory in the buffer for a section's content and updates the
+ * buffers' status accordingly. This routine returns a pointer to the first
+ * byte of the section start within the buffer, which is used to fill in the
+ * section contents.
+ * Note: all package contents must be in Little Endian form.
+ */
+static void *
+ice_pkg_buf_alloc_section(struct ice_buf_build *bld, u32 type, u16 size)
+{
+	struct ice_buf_hdr *buf;
+	u16 sect_count;
+	u16 data_end;
+
+	if (!bld || !type || !size)
+		return NULL;
+
+	buf = (struct ice_buf_hdr *)&bld->buf;
+
+	/* check for enough space left in buffer */
+	data_end = le16_to_cpu(buf->data_end);
+
+	/* section start must align on 4 byte boundary */
+	data_end = ALIGN(data_end, 4);
+
+	if ((data_end + size) > ICE_MAX_S_DATA_END)
+		return NULL;
+
+	/* check for more available section table entries */
+	sect_count = le16_to_cpu(buf->section_count);
+	if (sect_count < bld->reserved_section_table_entries) {
+		void *section_ptr = ((u8 *)buf) + data_end;
+
+		buf->section_entry[sect_count].offset = cpu_to_le16(data_end);
+		buf->section_entry[sect_count].size = cpu_to_le16(size);
+		buf->section_entry[sect_count].type = cpu_to_le32(type);
+
+		data_end += size;
+		buf->data_end = cpu_to_le16(data_end);
+
+		buf->section_count = cpu_to_le16(sect_count + 1);
+		return section_ptr;
+	}
+
+	/* no free section table entries */
+	return NULL;
+}
+
+/**
+ * ice_pkg_buf_get_active_sections
+ * @bld: pointer to pkg build (allocated by ice_pkg_buf_alloc())
+ *
+ * Returns the number of active sections. Before using the package buffer
+ * in an update package command, the caller should make sure that there is at
+ * least one active section - otherwise, the buffer is not legal and should
+ * not be used.
+ * Note: all package contents must be in Little Endian form.
+ */
+static u16 ice_pkg_buf_get_active_sections(struct ice_buf_build *bld)
+{
+	struct ice_buf_hdr *buf;
+
+	if (!bld)
+		return 0;
+
+	buf = (struct ice_buf_hdr *)&bld->buf;
+	return le16_to_cpu(buf->section_count);
+}
+
+/**
+ * ice_pkg_buf
+ * @bld: pointer to pkg build (allocated by ice_pkg_buf_alloc())
+ *
+ * Return a pointer to the buffer's header
+ */
+static struct ice_buf *ice_pkg_buf(struct ice_buf_build *bld)
+{
+	if (!bld)
+		return NULL;
+
+	return &bld->buf;
+}
+
 /* PTG Management */
 
 /**
@@ -2207,6 +2561,252 @@ ice_has_prof_vsig(struct ice_hw *hw, enum ice_block blk, u16 vsig, u64 hdl)
 	return false;
 }
 
+/**
+ * ice_prof_bld_es - build profile ID extraction sequence changes
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @bld: the update package buffer build to add to
+ * @chgs: the list of changes to make in hardware
+ */
+static enum ice_status
+ice_prof_bld_es(struct ice_hw *hw, enum ice_block blk,
+		struct ice_buf_build *bld, struct list_head *chgs)
+{
+	u16 vec_size = hw->blk[blk].es.fvw * sizeof(struct ice_fv_word);
+	struct ice_chs_chg *tmp;
+
+	list_for_each_entry(tmp, chgs, list_entry)
+		if (tmp->type == ICE_PTG_ES_ADD && tmp->add_prof) {
+			u16 off = tmp->prof_id * hw->blk[blk].es.fvw;
+			struct ice_pkg_es *p;
+			u32 id;
+
+			id = ice_sect_id(blk, ICE_VEC_TBL);
+			p = (struct ice_pkg_es *)
+				ice_pkg_buf_alloc_section(bld, id, sizeof(*p) +
+							  vec_size -
+							  sizeof(p->es[0]));
+
+			if (!p)
+				return ICE_ERR_MAX_LIMIT;
+
+			p->count = cpu_to_le16(1);
+			p->offset = cpu_to_le16(tmp->prof_id);
+
+			memcpy(p->es, &hw->blk[blk].es.t[off], vec_size);
+		}
+
+	return 0;
+}
+
+/**
+ * ice_prof_bld_tcam - build profile ID TCAM changes
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @bld: the update package buffer build to add to
+ * @chgs: the list of changes to make in hardware
+ */
+static enum ice_status
+ice_prof_bld_tcam(struct ice_hw *hw, enum ice_block blk,
+		  struct ice_buf_build *bld, struct list_head *chgs)
+{
+	struct ice_chs_chg *tmp;
+
+	list_for_each_entry(tmp, chgs, list_entry)
+		if (tmp->type == ICE_TCAM_ADD && tmp->add_tcam_idx) {
+			struct ice_prof_id_section *p;
+			u32 id;
+
+			id = ice_sect_id(blk, ICE_PROF_TCAM);
+			p = (struct ice_prof_id_section *)
+				ice_pkg_buf_alloc_section(bld, id, sizeof(*p));
+
+			if (!p)
+				return ICE_ERR_MAX_LIMIT;
+
+			p->count = cpu_to_le16(1);
+			p->entry[0].addr = cpu_to_le16(tmp->tcam_idx);
+			p->entry[0].prof_id = tmp->prof_id;
+
+			memcpy(p->entry[0].key,
+			       &hw->blk[blk].prof.t[tmp->tcam_idx].key,
+			       sizeof(hw->blk[blk].prof.t->key));
+		}
+
+	return 0;
+}
+
+/**
+ * ice_prof_bld_xlt1 - build XLT1 changes
+ * @blk: hardware block
+ * @bld: the update package buffer build to add to
+ * @chgs: the list of changes to make in hardware
+ */
+static enum ice_status
+ice_prof_bld_xlt1(enum ice_block blk, struct ice_buf_build *bld,
+		  struct list_head *chgs)
+{
+	struct ice_chs_chg *tmp;
+
+	list_for_each_entry(tmp, chgs, list_entry)
+		if (tmp->type == ICE_PTG_ES_ADD && tmp->add_ptg) {
+			struct ice_xlt1_section *p;
+			u32 id;
+
+			id = ice_sect_id(blk, ICE_XLT1);
+			p = (struct ice_xlt1_section *)
+				ice_pkg_buf_alloc_section(bld, id, sizeof(*p));
+
+			if (!p)
+				return ICE_ERR_MAX_LIMIT;
+
+			p->count = cpu_to_le16(1);
+			p->offset = cpu_to_le16(tmp->ptype);
+			p->value[0] = tmp->ptg;
+		}
+
+	return 0;
+}
+
+/**
+ * ice_prof_bld_xlt2 - build XLT2 changes
+ * @blk: hardware block
+ * @bld: the update package buffer build to add to
+ * @chgs: the list of changes to make in hardware
+ */
+static enum ice_status
+ice_prof_bld_xlt2(enum ice_block blk, struct ice_buf_build *bld,
+		  struct list_head *chgs)
+{
+	struct ice_chs_chg *tmp;
+
+	list_for_each_entry(tmp, chgs, list_entry) {
+		struct ice_xlt2_section *p;
+		u32 id;
+
+		switch (tmp->type) {
+		case ICE_VSIG_ADD:
+		case ICE_VSI_MOVE:
+		case ICE_VSIG_REM:
+			id = ice_sect_id(blk, ICE_XLT2);
+			p = (struct ice_xlt2_section *)
+				ice_pkg_buf_alloc_section(bld, id, sizeof(*p));
+
+			if (!p)
+				return ICE_ERR_MAX_LIMIT;
+
+			p->count = cpu_to_le16(1);
+			p->offset = cpu_to_le16(tmp->vsi);
+			p->value[0] = cpu_to_le16(tmp->vsig);
+			break;
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ice_upd_prof_hw - update hardware using the change list
+ * @hw: pointer to the HW struct
+ * @blk: hardware block
+ * @chgs: the list of changes to make in hardware
+ */
+static enum ice_status
+ice_upd_prof_hw(struct ice_hw *hw, enum ice_block blk,
+		struct list_head *chgs)
+{
+	struct ice_buf_build *b;
+	struct ice_chs_chg *tmp;
+	enum ice_status status;
+	u16 pkg_sects;
+	u16 xlt1 = 0;
+	u16 xlt2 = 0;
+	u16 tcam = 0;
+	u16 es = 0;
+	u16 sects;
+
+	/* count number of sections we need */
+	list_for_each_entry(tmp, chgs, list_entry) {
+		switch (tmp->type) {
+		case ICE_PTG_ES_ADD:
+			if (tmp->add_ptg)
+				xlt1++;
+			if (tmp->add_prof)
+				es++;
+			break;
+		case ICE_TCAM_ADD:
+			tcam++;
+			break;
+		case ICE_VSIG_ADD:
+		case ICE_VSI_MOVE:
+		case ICE_VSIG_REM:
+			xlt2++;
+			break;
+		default:
+			break;
+		}
+	}
+	sects = xlt1 + xlt2 + tcam + es;
+
+	if (!sects)
+		return 0;
+
+	/* Build update package buffer */
+	b = ice_pkg_buf_alloc(hw);
+	if (!b)
+		return ICE_ERR_NO_MEMORY;
+
+	status = ice_pkg_buf_reserve_section(b, sects);
+	if (status)
+		goto error_tmp;
+
+	/* Preserve order of table update: ES, TCAM, PTG, VSIG */
+	if (es) {
+		status = ice_prof_bld_es(hw, blk, b, chgs);
+		if (status)
+			goto error_tmp;
+	}
+
+	if (tcam) {
+		status = ice_prof_bld_tcam(hw, blk, b, chgs);
+		if (status)
+			goto error_tmp;
+	}
+
+	if (xlt1) {
+		status = ice_prof_bld_xlt1(blk, b, chgs);
+		if (status)
+			goto error_tmp;
+	}
+
+	if (xlt2) {
+		status = ice_prof_bld_xlt2(blk, b, chgs);
+		if (status)
+			goto error_tmp;
+	}
+
+	/* After package buffer build check if the section count in buffer is
+	 * non-zero and matches the number of sections detected for package
+	 * update.
+	 */
+	pkg_sects = ice_pkg_buf_get_active_sections(b);
+	if (!pkg_sects || pkg_sects != sects) {
+		status = ICE_ERR_INVAL_SIZE;
+		goto error_tmp;
+	}
+
+	/* update package */
+	status = ice_update_pkg(hw, ice_pkg_buf(b), 1);
+	if (status == ICE_ERR_AQ_ERROR)
+		ice_debug(hw, ICE_DBG_INIT, "Unable to update HW profile\n");
+
+error_tmp:
+	ice_pkg_buf_free(hw, b);
+	return status;
+}
+
 /**
  * ice_add_prof - add profile
  * @hw: pointer to the HW struct
@@ -3097,6 +3697,10 @@ ice_add_prof_id_flow(struct ice_hw *hw, enum ice_block blk, u16 vsi, u64 hdl)
 		}
 	}
 
+	/* update hardware */
+	if (!status)
+		status = ice_upd_prof_hw(hw, blk, &chg);
+
 err_ice_add_prof_id_flow:
 	list_for_each_entry_safe(del, tmp, &chg, list_entry) {
 		list_del(&del->list_entry);
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index 9d95d51bc760..0fb3fe3ff3ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -108,37 +108,57 @@ struct ice_buf_hdr {
 	sizeof(struct ice_buf_hdr) - (hd_sz)) / (ent_sz))
 
 /* ice package section IDs */
+#define ICE_SID_XLT0_SW			10
+#define ICE_SID_XLT_KEY_BUILDER_SW	11
 #define ICE_SID_XLT1_SW			12
 #define ICE_SID_XLT2_SW			13
 #define ICE_SID_PROFID_TCAM_SW		14
 #define ICE_SID_PROFID_REDIR_SW		15
 #define ICE_SID_FLD_VEC_SW		16
+#define ICE_SID_CDID_KEY_BUILDER_SW	17
+#define ICE_SID_CDID_REDIR_SW		18
 
+#define ICE_SID_XLT0_ACL		20
+#define ICE_SID_XLT_KEY_BUILDER_ACL	21
 #define ICE_SID_XLT1_ACL		22
 #define ICE_SID_XLT2_ACL		23
 #define ICE_SID_PROFID_TCAM_ACL		24
 #define ICE_SID_PROFID_REDIR_ACL	25
 #define ICE_SID_FLD_VEC_ACL		26
+#define ICE_SID_CDID_KEY_BUILDER_ACL	27
+#define ICE_SID_CDID_REDIR_ACL		28
 
+#define ICE_SID_XLT0_FD			30
+#define ICE_SID_XLT_KEY_BUILDER_FD	31
 #define ICE_SID_XLT1_FD			32
 #define ICE_SID_XLT2_FD			33
 #define ICE_SID_PROFID_TCAM_FD		34
 #define ICE_SID_PROFID_REDIR_FD		35
 #define ICE_SID_FLD_VEC_FD		36
+#define ICE_SID_CDID_KEY_BUILDER_FD	37
+#define ICE_SID_CDID_REDIR_FD		38
 
+#define ICE_SID_XLT0_RSS		40
+#define ICE_SID_XLT_KEY_BUILDER_RSS	41
 #define ICE_SID_XLT1_RSS		42
 #define ICE_SID_XLT2_RSS		43
 #define ICE_SID_PROFID_TCAM_RSS		44
 #define ICE_SID_PROFID_REDIR_RSS	45
 #define ICE_SID_FLD_VEC_RSS		46
+#define ICE_SID_CDID_KEY_BUILDER_RSS	47
+#define ICE_SID_CDID_REDIR_RSS		48
 
 #define ICE_SID_RXPARSER_BOOST_TCAM	56
 
+#define ICE_SID_XLT0_PE			80
+#define ICE_SID_XLT_KEY_BUILDER_PE	81
 #define ICE_SID_XLT1_PE			82
 #define ICE_SID_XLT2_PE			83
 #define ICE_SID_PROFID_TCAM_PE		84
 #define ICE_SID_PROFID_REDIR_PE		85
 #define ICE_SID_FLD_VEC_PE		86
+#define ICE_SID_CDID_KEY_BUILDER_PE	87
+#define ICE_SID_CDID_REDIR_PE		88
 
 /* Label Metadata section IDs */
 #define ICE_SID_LBL_FIRST		0x80000010
@@ -155,6 +175,19 @@ enum ice_block {
 	ICE_BLK_COUNT
 };
 
+enum ice_sect {
+	ICE_XLT0 = 0,
+	ICE_XLT_KB,
+	ICE_XLT1,
+	ICE_XLT2,
+	ICE_PROF_TCAM,
+	ICE_PROF_REDIR,
+	ICE_VEC_TBL,
+	ICE_CDID_KB,
+	ICE_CDID_REDIR,
+	ICE_SECT_COUNT
+};
+
 /* package labels */
 struct ice_label {
 	__le16 value;
@@ -237,6 +270,13 @@ struct ice_prof_redir_section {
 	u8 redir_value[1];
 };
 
+/* package buffer building */
+
+struct ice_buf_build {
+	struct ice_buf buf;
+	u16 reserved_section_table_entries;
+};
+
 struct ice_pkg_enum {
 	struct ice_buf_table *buf_table;
 	u32 buf_idx;
@@ -251,6 +291,12 @@ struct ice_pkg_enum {
 	void *(*handler)(u32 sect_type, void *section, u32 index, u32 *offset);
 };
 
+struct ice_pkg_es {
+	__le16 count;
+	__le16 offset;
+	struct ice_fv_word es[1];
+};
+
 struct ice_es {
 	u32 sid;
 	u16 count;
-- 
2.24.1

