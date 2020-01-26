Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272B6149969
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 07:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgAZGHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 01:07:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:18151 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgAZGHl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 01:07:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 22:07:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,364,1574150400"; 
   d="scan'208";a="230947203"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2020 22:07:40 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Henry Tieman <henry.w.tieman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 1/8] ice: Enable writing hardware filtering tables
Date:   Sat, 25 Jan 2020 22:07:30 -0800
Message-Id: <20200126060737.3238027-2-jeffrey.t.kirsher@intel.com>
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

Enable the driver to write the filtering hardware tables to allow for
changing of RSS rules. Upon loading of DDP package, a minimal configuration
should be written to hardware.

Introduce and initialize structures for storing configuration and make
the top level calls to configure the RSS tables to initial values. A packet
segment will be created but nothing is written to hardware yet.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   3 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   6 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  31 ++-
 drivers/net/ethernet/intel/ice/ice_flow.c     | 250 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_flow.h     | 114 ++++++++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  87 +++++-
 drivers/net/ethernet/intel/ice/ice_type.h     |   4 +
 7 files changed, 491 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_flow.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_flow.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 7cb829132d28..59544b0fc086 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -17,7 +17,8 @@ ice-y := ice_main.o	\
 	 ice_lib.o	\
 	 ice_txrx_lib.o	\
 	 ice_txrx.o	\
-	 ice_flex_pipe.o	\
+	 ice_flex_pipe.o \
+	 ice_flow.o	\
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index a03b4fdc01e6..dd9af9c63755 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4,6 +4,7 @@
 #include "ice_common.h"
 #include "ice_sched.h"
 #include "ice_adminq_cmd.h"
+#include "ice_flow.h"
 
 #define ICE_PF_RESET_WAIT_COUNT	200
 
@@ -3406,7 +3407,10 @@ enum ice_status ice_replay_vsi(struct ice_hw *hw, u16 vsi_handle)
 		if (status)
 			return status;
 	}
-
+	/* Replay per VSI all RSS configurations */
+	status = ice_replay_rss_cfg(hw, vsi_handle);
+	if (status)
+		return status;
 	/* Replay per VSI all filters */
 	status = ice_replay_vsi_all_fltr(hw, vsi_handle);
 	return status;
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index cbd53b586c36..f37eb536e7b7 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -3,6 +3,7 @@
 
 #include "ice_common.h"
 #include "ice_flex_pipe.h"
+#include "ice_flow.h"
 
 /**
  * ice_pkg_val_buf
@@ -1379,11 +1380,18 @@ void ice_fill_blk_tbls(struct ice_hw *hw)
  */
 void ice_free_hw_tbls(struct ice_hw *hw)
 {
+	struct ice_rss_cfg *r, *rt;
 	u8 i;
 
 	for (i = 0; i < ICE_BLK_COUNT; i++) {
-		hw->blk[i].is_list_init = false;
+		if (hw->blk[i].is_list_init) {
+			struct ice_es *es = &hw->blk[i].es;
 
+			mutex_destroy(&es->prof_map_lock);
+			mutex_destroy(&hw->fl_profs_locks[i]);
+
+			hw->blk[i].is_list_init = false;
+		}
 		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt1.ptypes);
 		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt1.ptg_tbl);
 		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].xlt1.t);
@@ -1397,9 +1405,25 @@ void ice_free_hw_tbls(struct ice_hw *hw)
 		devm_kfree(ice_hw_to_dev(hw), hw->blk[i].es.written);
 	}
 
+	list_for_each_entry_safe(r, rt, &hw->rss_list_head, l_entry) {
+		list_del(&r->l_entry);
+		devm_kfree(ice_hw_to_dev(hw), r);
+	}
+	mutex_destroy(&hw->rss_locks);
 	memset(hw->blk, 0, sizeof(hw->blk));
 }
 
+/**
+ * ice_init_flow_profs - init flow profile locks and list heads
+ * @hw: pointer to the hardware structure
+ * @blk_idx: HW block index
+ */
+static void ice_init_flow_profs(struct ice_hw *hw, u8 blk_idx)
+{
+	mutex_init(&hw->fl_profs_locks[blk_idx]);
+	INIT_LIST_HEAD(&hw->fl_profs[blk_idx]);
+}
+
 /**
  * ice_clear_hw_tbls - clear HW tables and flow profiles
  * @hw: pointer to the hardware structure
@@ -1443,6 +1467,8 @@ enum ice_status ice_init_hw_tbls(struct ice_hw *hw)
 {
 	u8 i;
 
+	mutex_init(&hw->rss_locks);
+	INIT_LIST_HEAD(&hw->rss_list_head);
 	for (i = 0; i < ICE_BLK_COUNT; i++) {
 		struct ice_prof_redir *prof_redir = &hw->blk[i].prof_redir;
 		struct ice_prof_tcam *prof = &hw->blk[i].prof;
@@ -1454,6 +1480,9 @@ enum ice_status ice_init_hw_tbls(struct ice_hw *hw)
 		if (hw->blk[i].is_list_init)
 			continue;
 
+		ice_init_flow_profs(hw, i);
+		mutex_init(&es->prof_map_lock);
+		INIT_LIST_HEAD(&es->prof_map);
 		hw->blk[i].is_list_init = true;
 
 		hw->blk[i].overwrite = blk_sizes[i].overwrite;
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
new file mode 100644
index 000000000000..4828c64abe98
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include "ice_common.h"
+#include "ice_flow.h"
+
+/* Describe properties of a protocol header field */
+struct ice_flow_field_info {
+	enum ice_flow_seg_hdr hdr;
+	s16 off;	/* Offset from start of a protocol header, in bits */
+	u16 size;	/* Size of fields in bits */
+};
+
+#define ICE_FLOW_FLD_INFO(_hdr, _offset_bytes, _size_bytes) { \
+	.hdr = _hdr, \
+	.off = (_offset_bytes) * BITS_PER_BYTE, \
+	.size = (_size_bytes) * BITS_PER_BYTE, \
+}
+
+/* Table containing properties of supported protocol header fields */
+static const
+struct ice_flow_field_info ice_flds_info[ICE_FLOW_FIELD_IDX_MAX] = {
+	/* IPv4 / IPv6 */
+	/* ICE_FLOW_FIELD_IDX_IPV4_SA */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_IPV4, 12, sizeof(struct in_addr)),
+	/* ICE_FLOW_FIELD_IDX_IPV4_DA */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_IPV4, 16, sizeof(struct in_addr)),
+	/* ICE_FLOW_FIELD_IDX_IPV6_SA */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_IPV6, 8, sizeof(struct in6_addr)),
+	/* ICE_FLOW_FIELD_IDX_IPV6_DA */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_IPV6, 24, sizeof(struct in6_addr)),
+	/* Transport */
+	/* ICE_FLOW_FIELD_IDX_TCP_SRC_PORT */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_TCP, 0, sizeof(__be16)),
+	/* ICE_FLOW_FIELD_IDX_TCP_DST_PORT */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_TCP, 2, sizeof(__be16)),
+	/* ICE_FLOW_FIELD_IDX_UDP_SRC_PORT */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_UDP, 0, sizeof(__be16)),
+	/* ICE_FLOW_FIELD_IDX_UDP_DST_PORT */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_UDP, 2, sizeof(__be16)),
+};
+
+/**
+ * ice_flow_set_fld_ext - specifies locations of field from entry's input buffer
+ * @seg: packet segment the field being set belongs to
+ * @fld: field to be set
+ * @type: type of the field
+ * @val_loc: if not ICE_FLOW_FLD_OFF_INVAL, location of the value to match from
+ *           entry's input buffer
+ * @mask_loc: if not ICE_FLOW_FLD_OFF_INVAL, location of mask value from entry's
+ *            input buffer
+ * @last_loc: if not ICE_FLOW_FLD_OFF_INVAL, location of last/upper value from
+ *            entry's input buffer
+ *
+ * This helper function stores information of a field being matched, including
+ * the type of the field and the locations of the value to match, the mask, and
+ * and the upper-bound value in the start of the input buffer for a flow entry.
+ * This function should only be used for fixed-size data structures.
+ *
+ * This function also opportunistically determines the protocol headers to be
+ * present based on the fields being set. Some fields cannot be used alone to
+ * determine the protocol headers present. Sometimes, fields for particular
+ * protocol headers are not matched. In those cases, the protocol headers
+ * must be explicitly set.
+ */
+static void
+ice_flow_set_fld_ext(struct ice_flow_seg_info *seg, enum ice_flow_field fld,
+		     enum ice_flow_fld_match_type type, u16 val_loc,
+		     u16 mask_loc, u16 last_loc)
+{
+	u64 bit = BIT_ULL(fld);
+
+	seg->match |= bit;
+	if (type == ICE_FLOW_FLD_TYPE_RANGE)
+		seg->range |= bit;
+
+	seg->fields[fld].type = type;
+	seg->fields[fld].src.val = val_loc;
+	seg->fields[fld].src.mask = mask_loc;
+	seg->fields[fld].src.last = last_loc;
+
+	ICE_FLOW_SET_HDRS(seg, ice_flds_info[fld].hdr);
+}
+
+/**
+ * ice_flow_set_fld - specifies locations of field from entry's input buffer
+ * @seg: packet segment the field being set belongs to
+ * @fld: field to be set
+ * @val_loc: if not ICE_FLOW_FLD_OFF_INVAL, location of the value to match from
+ *           entry's input buffer
+ * @mask_loc: if not ICE_FLOW_FLD_OFF_INVAL, location of mask value from entry's
+ *            input buffer
+ * @last_loc: if not ICE_FLOW_FLD_OFF_INVAL, location of last/upper value from
+ *            entry's input buffer
+ * @range: indicate if field being matched is to be in a range
+ *
+ * This function specifies the locations, in the form of byte offsets from the
+ * start of the input buffer for a flow entry, from where the value to match,
+ * the mask value, and upper value can be extracted. These locations are then
+ * stored in the flow profile. When adding a flow entry associated with the
+ * flow profile, these locations will be used to quickly extract the values and
+ * create the content of a match entry. This function should only be used for
+ * fixed-size data structures.
+ */
+static void
+ice_flow_set_fld(struct ice_flow_seg_info *seg, enum ice_flow_field fld,
+		 u16 val_loc, u16 mask_loc, u16 last_loc, bool range)
+{
+	enum ice_flow_fld_match_type t = range ?
+		ICE_FLOW_FLD_TYPE_RANGE : ICE_FLOW_FLD_TYPE_REG;
+
+	ice_flow_set_fld_ext(seg, fld, t, val_loc, mask_loc, last_loc);
+}
+
+#define ICE_FLOW_RSS_SEG_HDR_L3_MASKS \
+	(ICE_FLOW_SEG_HDR_IPV4 | ICE_FLOW_SEG_HDR_IPV6)
+
+#define ICE_FLOW_RSS_SEG_HDR_L4_MASKS \
+	(ICE_FLOW_SEG_HDR_TCP | ICE_FLOW_SEG_HDR_UDP | ICE_FLOW_SEG_HDR_SCTP)
+
+#define ICE_FLOW_RSS_SEG_HDR_VAL_MASKS \
+	(ICE_FLOW_RSS_SEG_HDR_L3_MASKS | \
+	 ICE_FLOW_RSS_SEG_HDR_L4_MASKS)
+
+/**
+ * ice_flow_set_rss_seg_info - setup packet segments for RSS
+ * @segs: pointer to the flow field segment(s)
+ * @hash_fields: fields to be hashed on for the segment(s)
+ * @flow_hdr: protocol header fields within a packet segment
+ *
+ * Helper function to extract fields from hash bitmap and use flow
+ * header value to set flow field segment for further use in flow
+ * profile entry or removal.
+ */
+static enum ice_status
+ice_flow_set_rss_seg_info(struct ice_flow_seg_info *segs, u64 hash_fields,
+			  u32 flow_hdr)
+{
+	u64 val;
+	u8 i;
+
+	for_each_set_bit(i, (unsigned long *)&hash_fields,
+			 ICE_FLOW_FIELD_IDX_MAX)
+		ice_flow_set_fld(segs, (enum ice_flow_field)i,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, false);
+
+	ICE_FLOW_SET_HDRS(segs, flow_hdr);
+
+	if (segs->hdrs & ~ICE_FLOW_RSS_SEG_HDR_VAL_MASKS)
+		return ICE_ERR_PARAM;
+
+	val = (u64)(segs->hdrs & ICE_FLOW_RSS_SEG_HDR_L3_MASKS);
+	if (val && !is_power_of_2(val))
+		return ICE_ERR_CFG;
+
+	val = (u64)(segs->hdrs & ICE_FLOW_RSS_SEG_HDR_L4_MASKS);
+	if (val && !is_power_of_2(val))
+		return ICE_ERR_CFG;
+
+	return 0;
+}
+
+#define ICE_RSS_OUTER_HEADERS	1
+
+/**
+ * ice_add_rss_cfg_sync - add an RSS configuration
+ * @hashed_flds: hash bit fields (ICE_FLOW_HASH_*) to configure
+ * @addl_hdrs: protocol header fields
+ * @segs_cnt: packet segment count
+ *
+ * Assumption: lock has already been acquired for RSS list
+ */
+static enum ice_status
+ice_add_rss_cfg_sync(u64 hashed_flds, u32 addl_hdrs, u8 segs_cnt)
+{
+	struct ice_flow_seg_info *segs;
+	enum ice_status status;
+
+	if (!segs_cnt || segs_cnt > ICE_FLOW_SEG_MAX)
+		return ICE_ERR_PARAM;
+
+	segs = kcalloc(segs_cnt, sizeof(*segs), GFP_KERNEL);
+	if (!segs)
+		return ICE_ERR_NO_MEMORY;
+
+	/* Construct the packet segment info from the hashed fields */
+	status = ice_flow_set_rss_seg_info(&segs[segs_cnt - 1], hashed_flds,
+					   addl_hdrs);
+
+	kfree(segs);
+	return status;
+}
+
+/**
+ * ice_add_rss_cfg - add an RSS configuration with specified hashed fields
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: software VSI handle
+ * @hashed_flds: hash bit fields (ICE_FLOW_HASH_*) to configure
+ * @addl_hdrs: protocol header fields
+ *
+ * This function will generate a flow profile based on fields associated with
+ * the input fields to hash on, the flow type and use the VSI number to add
+ * a flow entry to the profile.
+ */
+enum ice_status
+ice_add_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
+		u32 addl_hdrs)
+{
+	enum ice_status status;
+
+	if (hashed_flds == ICE_HASH_INVALID ||
+	    !ice_is_vsi_valid(hw, vsi_handle))
+		return ICE_ERR_PARAM;
+
+	mutex_lock(&hw->rss_locks);
+	status = ice_add_rss_cfg_sync(hashed_flds, addl_hdrs,
+				      ICE_RSS_OUTER_HEADERS);
+	mutex_unlock(&hw->rss_locks);
+
+	return status;
+}
+
+/**
+ * ice_replay_rss_cfg - replay RSS configurations associated with VSI
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: software VSI handle
+ */
+enum ice_status ice_replay_rss_cfg(struct ice_hw *hw, u16 vsi_handle)
+{
+	enum ice_status status = 0;
+	struct ice_rss_cfg *r;
+
+	if (!ice_is_vsi_valid(hw, vsi_handle))
+		return ICE_ERR_PARAM;
+
+	mutex_lock(&hw->rss_locks);
+	list_for_each_entry(r, &hw->rss_list_head, l_entry) {
+		if (test_bit(vsi_handle, r->vsis)) {
+			status = ice_add_rss_cfg_sync(r->hashed_flds,
+						      r->packet_hdr,
+						      ICE_RSS_OUTER_HEADERS);
+			if (status)
+				break;
+		}
+	}
+	mutex_unlock(&hw->rss_locks);
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
new file mode 100644
index 000000000000..48c0fc09d5ff
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -0,0 +1,114 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_FLOW_H_
+#define _ICE_FLOW_H_
+
+#define ICE_FLOW_FLD_OFF_INVAL		0xffff
+
+/* Generate flow hash field from flow field type(s) */
+#define ICE_FLOW_HASH_IPV4	\
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_SA) | \
+	 BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_DA))
+#define ICE_FLOW_HASH_IPV6	\
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_SA) | \
+	 BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_DA))
+#define ICE_FLOW_HASH_TCP_PORT	\
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_TCP_SRC_PORT) | \
+	 BIT_ULL(ICE_FLOW_FIELD_IDX_TCP_DST_PORT))
+#define ICE_FLOW_HASH_UDP_PORT	\
+	(BIT_ULL(ICE_FLOW_FIELD_IDX_UDP_SRC_PORT) | \
+	 BIT_ULL(ICE_FLOW_FIELD_IDX_UDP_DST_PORT))
+
+#define ICE_HASH_INVALID	0
+#define ICE_HASH_TCP_IPV4	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_TCP_PORT)
+#define ICE_HASH_TCP_IPV6	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_TCP_PORT)
+#define ICE_HASH_UDP_IPV4	(ICE_FLOW_HASH_IPV4 | ICE_FLOW_HASH_UDP_PORT)
+#define ICE_HASH_UDP_IPV6	(ICE_FLOW_HASH_IPV6 | ICE_FLOW_HASH_UDP_PORT)
+
+/* Protocol header fields within a packet segment. A segment consists of one or
+ * more protocol headers that make up a logical group of protocol headers. Each
+ * logical group of protocol headers encapsulates or is encapsulated using/by
+ * tunneling or encapsulation protocols for network virtualization such as GRE,
+ * VxLAN, etc.
+ */
+enum ice_flow_seg_hdr {
+	ICE_FLOW_SEG_HDR_NONE		= 0x00000000,
+	ICE_FLOW_SEG_HDR_IPV4		= 0x00000004,
+	ICE_FLOW_SEG_HDR_IPV6		= 0x00000008,
+	ICE_FLOW_SEG_HDR_TCP		= 0x00000040,
+	ICE_FLOW_SEG_HDR_UDP		= 0x00000080,
+	ICE_FLOW_SEG_HDR_SCTP		= 0x00000100,
+};
+
+enum ice_flow_field {
+	/* L3 */
+	ICE_FLOW_FIELD_IDX_IPV4_SA,
+	ICE_FLOW_FIELD_IDX_IPV4_DA,
+	ICE_FLOW_FIELD_IDX_IPV6_SA,
+	ICE_FLOW_FIELD_IDX_IPV6_DA,
+	/* L4 */
+	ICE_FLOW_FIELD_IDX_TCP_SRC_PORT,
+	ICE_FLOW_FIELD_IDX_TCP_DST_PORT,
+	ICE_FLOW_FIELD_IDX_UDP_SRC_PORT,
+	ICE_FLOW_FIELD_IDX_UDP_DST_PORT,
+	/* The total number of enums must not exceed 64 */
+	ICE_FLOW_FIELD_IDX_MAX
+};
+
+#define ICE_FLOW_SEG_MAX		2
+#define ICE_FLOW_SET_HDRS(seg, val)	((seg)->hdrs |= (u32)(val))
+
+struct ice_flow_seg_xtrct {
+	u8 prot_id;	/* Protocol ID of extracted header field */
+	u16 off;	/* Starting offset of the field in header in bytes */
+	u8 idx;		/* Index of FV entry used */
+	u8 disp;	/* Displacement of field in bits fr. FV entry's start */
+};
+
+enum ice_flow_fld_match_type {
+	ICE_FLOW_FLD_TYPE_REG,		/* Value, mask */
+	ICE_FLOW_FLD_TYPE_RANGE,	/* Value, mask, last (upper bound) */
+	ICE_FLOW_FLD_TYPE_PREFIX,	/* IP address, prefix, size of prefix */
+	ICE_FLOW_FLD_TYPE_SIZE,		/* Value, mask, size of match */
+};
+
+struct ice_flow_fld_loc {
+	/* Describe offsets of field information relative to the beginning of
+	 * input buffer provided when adding flow entries.
+	 */
+	u16 val;	/* Offset where the value is located */
+	u16 mask;	/* Offset where the mask/prefix value is located */
+	u16 last;	/* Length or offset where the upper value is located */
+};
+
+struct ice_flow_fld_info {
+	enum ice_flow_fld_match_type type;
+	/* Location where to retrieve data from an input buffer */
+	struct ice_flow_fld_loc src;
+	/* Location where to put the data into the final entry buffer */
+	struct ice_flow_fld_loc entry;
+	struct ice_flow_seg_xtrct xtrct;
+};
+
+struct ice_flow_seg_info {
+	u32 hdrs;	/* Bitmask indicating protocol headers present */
+	u64 match;	/* Bitmask indicating header fields to be matched */
+	u64 range;	/* Bitmask indicating header fields matched as ranges */
+
+	struct ice_flow_fld_info fields[ICE_FLOW_FIELD_IDX_MAX];
+};
+
+struct ice_rss_cfg {
+	struct list_head l_entry;
+	/* bitmap of VSIs added to the RSS entry */
+	DECLARE_BITMAP(vsis, ICE_MAX_VSI);
+	u64 hashed_flds;
+	u32 packet_hdr;
+};
+
+enum ice_status ice_replay_rss_cfg(struct ice_hw *hw, u16 vsi_handle);
+enum ice_status
+ice_add_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
+		u32 addl_hdrs);
+#endif /* _ICE_FLOW_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 4cfad81ba496..dd230c6664ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3,6 +3,7 @@
 
 #include "ice.h"
 #include "ice_base.h"
+#include "ice_flow.h"
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
@@ -1086,6 +1087,88 @@ static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 	return err;
 }
 
+/**
+ * ice_vsi_set_rss_flow_fld - Sets RSS input set for different flows
+ * @vsi: VSI to be configured
+ *
+ * This function will only be called after successful download package call
+ * during initialization of PF. Since the downloaded package will erase the
+ * RSS section, this function will configure RSS input sets for different
+ * flow types. The last profile added has the highest priority, therefore 2
+ * tuple profiles (i.e. IPv4 src/dst) are added before 4 tuple profiles
+ * (i.e. IPv4 src/dst TCP src/dst port).
+ */
+static void ice_vsi_set_rss_flow_fld(struct ice_vsi *vsi)
+{
+	u16 vsi_handle = vsi->idx, vsi_num = vsi->vsi_num;
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	struct device *dev;
+
+	dev = ice_pf_to_dev(pf);
+	if (ice_is_safe_mode(pf)) {
+		dev_dbg(dev, "Advanced RSS disabled. Package download failed, vsi num = %d\n",
+			vsi_num);
+		return;
+	}
+	/* configure RSS for IPv4 with input set IP src/dst */
+	status = ice_add_rss_cfg(hw, vsi_handle, ICE_FLOW_HASH_IPV4,
+				 ICE_FLOW_SEG_HDR_IPV4);
+	if (status)
+		dev_dbg(dev, "ice_add_rss_cfg failed for ipv4 flow, vsi = %d, error = %d\n",
+			vsi_num, status);
+
+	/* configure RSS for IPv6 with input set IPv6 src/dst */
+	status = ice_add_rss_cfg(hw, vsi_handle, ICE_FLOW_HASH_IPV6,
+				 ICE_FLOW_SEG_HDR_IPV6);
+	if (status)
+		dev_dbg(dev, "ice_add_rss_cfg failed for ipv6 flow, vsi = %d, error = %d\n",
+			vsi_num, status);
+
+	/* configure RSS for tcp4 with input set IP src/dst, TCP src/dst */
+	status = ice_add_rss_cfg(hw, vsi_handle, ICE_HASH_TCP_IPV4,
+				 ICE_FLOW_SEG_HDR_TCP | ICE_FLOW_SEG_HDR_IPV4);
+	if (status)
+		dev_dbg(dev, "ice_add_rss_cfg failed for tcp4 flow, vsi = %d, error = %d\n",
+			vsi_num, status);
+
+	/* configure RSS for udp4 with input set IP src/dst, UDP src/dst */
+	status = ice_add_rss_cfg(hw, vsi_handle, ICE_HASH_UDP_IPV4,
+				 ICE_FLOW_SEG_HDR_UDP | ICE_FLOW_SEG_HDR_IPV4);
+	if (status)
+		dev_dbg(dev, "ice_add_rss_cfg failed for udp4 flow, vsi = %d, error = %d\n",
+			vsi_num, status);
+
+	/* configure RSS for sctp4 with input set IP src/dst */
+	status = ice_add_rss_cfg(hw, vsi_handle, ICE_FLOW_HASH_IPV4,
+				 ICE_FLOW_SEG_HDR_SCTP | ICE_FLOW_SEG_HDR_IPV4);
+	if (status)
+		dev_dbg(dev, "ice_add_rss_cfg failed for sctp4 flow, vsi = %d, error = %d\n",
+			vsi_num, status);
+
+	/* configure RSS for tcp6 with input set IPv6 src/dst, TCP src/dst */
+	status = ice_add_rss_cfg(hw, vsi_handle, ICE_HASH_TCP_IPV6,
+				 ICE_FLOW_SEG_HDR_TCP | ICE_FLOW_SEG_HDR_IPV6);
+	if (status)
+		dev_dbg(dev, "ice_add_rss_cfg failed for tcp6 flow, vsi = %d, error = %d\n",
+			vsi_num, status);
+
+	/* configure RSS for udp6 with input set IPv6 src/dst, UDP src/dst */
+	status = ice_add_rss_cfg(hw, vsi_handle, ICE_HASH_UDP_IPV6,
+				 ICE_FLOW_SEG_HDR_UDP | ICE_FLOW_SEG_HDR_IPV6);
+	if (status)
+		dev_dbg(dev, "ice_add_rss_cfg failed for udp6 flow, vsi = %d, error = %d\n",
+			vsi_num, status);
+
+	/* configure RSS for sctp6 with input set IPv6 src/dst */
+	status = ice_add_rss_cfg(hw, vsi_handle, ICE_FLOW_HASH_IPV6,
+				 ICE_FLOW_SEG_HDR_SCTP | ICE_FLOW_SEG_HDR_IPV6);
+	if (status)
+		dev_dbg(dev, "ice_add_rss_cfg failed for sctp6 flow, vsi = %d, error = %d\n",
+			vsi_num, status);
+}
+
 /**
  * ice_add_mac_to_list - Add a MAC address filter entry to the list
  * @vsi: the VSI to be forwarded to
@@ -1901,8 +1984,10 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		 * receive traffic on first queue. Hence no need to capture
 		 * return value
 		 */
-		if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
+		if (test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
 			ice_vsi_cfg_rss_lut_key(vsi);
+			ice_vsi_set_rss_flow_fld(vsi);
+		}
 		break;
 	case ICE_VSI_VF:
 		/* VF driver will take care of creating netdev for this type and
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index c4854a987130..ac38af105f90 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -559,6 +559,10 @@ struct ice_hw {
 
 	/* HW block tables */
 	struct ice_blk_info blk[ICE_BLK_COUNT];
+	struct mutex fl_profs_locks[ICE_BLK_COUNT];	/* lock fltr profiles */
+	struct list_head fl_profs[ICE_BLK_COUNT];
+	struct mutex rss_locks;	/* protect RSS configuration */
+	struct list_head rss_list_head;
 };
 
 /* Statistics collected by each port, VSI, VEB, and S-channel */
-- 
2.24.1

