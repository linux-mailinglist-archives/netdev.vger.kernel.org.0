Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF911DF54A
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387697AbgEWGs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:48:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387677AbgEWGsz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:48:55 -0400
IronPort-SDR: tOEC0Mz7VnaVIyWMyRN3jbeWFWpSCqvRrXUZbQ2J8Ufn8GM84inkojGOoWg8RIq63vf1o0MUVp
 UMg2jGAu6SDg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:50 -0700
IronPort-SDR: HteqG7V0Ee6no2QAdzDhZTZkMT+EC1NJTNvcLsbQh2kMSWVB11qP4RYRKwbfl/fC2f0mIEf7tS
 EBh6T5AlaH0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966890"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Henry Tieman <henry.w.tieman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/16] ice: Enable flex-bytes support
Date:   Fri, 22 May 2020 23:48:37 -0700
Message-Id: <20200523064847.3972158-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

Flex-bytes allows for packet matching based on an offset and value. This
is supported via the ethtool user-def option.  It is specified by providing
an offset followed by a 2 byte match value. Offset is measured from the
start of the MAC address.

The following restrictions apply to flex-bytes. The specified offset must
be an even number and be smaller than 0x1fe.

Example usage:

ethtool -N eth0 flow-type tcp4 src-ip 192.168.0.55 dst-ip 172.16.0.55 \
src-port 12 dst-port 13 user-def 0x10ffff action 32

Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  88 +++++++++-
 drivers/net/ethernet/intel/ice/ice_fdir.c     |   3 +
 drivers/net/ethernet/intel/ice/ice_fdir.h     |  13 ++
 drivers/net/ethernet/intel/ice/ice_flow.c     | 150 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_flow.h     |  12 ++
 .../ethernet/intel/ice/ice_protocol_type.h    |   1 +
 6 files changed, 265 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index aa85d5ad2477..f240c062860b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -92,6 +92,19 @@ static enum ice_fltr_ptype ice_ethtool_flow_to_fltr(int eth)
 	}
 }
 
+/**
+ * ice_is_mask_valid - check mask field set
+ * @mask: full mask to check
+ * @field: field for which mask should be valid
+ *
+ * If the mask is fully set return true. If it is not valid for field return
+ * false.
+ */
+static bool ice_is_mask_valid(u64 mask, u64 field)
+{
+	return (mask & field) == field;
+}
+
 /**
  * ice_get_ethtool_fdir_entry - fill ethtool structure with fdir filter data
  * @hw: hardware structure that contains filter list
@@ -335,6 +348,53 @@ void ice_fdir_release_flows(struct ice_hw *hw)
 		ice_fdir_erase_flow_from_hw(hw, ICE_BLK_FD, flow);
 }
 
+/**
+ * ice_parse_rx_flow_user_data - deconstruct user-defined data
+ * @fsp: pointer to ethtool Rx flow specification
+ * @data: pointer to userdef data structure for storage
+ *
+ * Returns 0 on success, negative error value on failure
+ */
+static int
+ice_parse_rx_flow_user_data(struct ethtool_rx_flow_spec *fsp,
+			    struct ice_rx_flow_userdef *data)
+{
+	u64 value, mask;
+
+	memset(data, 0, sizeof(*data));
+	if (!(fsp->flow_type & FLOW_EXT))
+		return 0;
+
+	value = be64_to_cpu(*((__force __be64 *)fsp->h_ext.data));
+	mask = be64_to_cpu(*((__force __be64 *)fsp->m_ext.data));
+	if (!mask)
+		return 0;
+
+#define ICE_USERDEF_FLEX_WORD_M	GENMASK_ULL(15, 0)
+#define ICE_USERDEF_FLEX_OFFS_S	16
+#define ICE_USERDEF_FLEX_OFFS_M	GENMASK_ULL(31, ICE_USERDEF_FLEX_OFFS_S)
+#define ICE_USERDEF_FLEX_FLTR_M	GENMASK_ULL(31, 0)
+
+	/* 0x1fe is the maximum value for offsets stored in the internal
+	 * filtering tables.
+	 */
+#define ICE_USERDEF_FLEX_MAX_OFFS_VAL 0x1fe
+
+	if (!ice_is_mask_valid(mask, ICE_USERDEF_FLEX_FLTR_M) ||
+	    value > ICE_USERDEF_FLEX_FLTR_M)
+		return -EINVAL;
+
+	data->flex_word = value & ICE_USERDEF_FLEX_WORD_M;
+	data->flex_offset = (value & ICE_USERDEF_FLEX_OFFS_M) >>
+			     ICE_USERDEF_FLEX_OFFS_S;
+	if (data->flex_offset > ICE_USERDEF_FLEX_MAX_OFFS_VAL)
+		return -EINVAL;
+
+	data->flex_fltr = true;
+
+	return 0;
+}
+
 /**
  * ice_fdir_num_avail_fltr - return the number of unused flow director filters
  * @hw: pointer to hardware structure
@@ -936,11 +996,13 @@ ice_set_fdir_ip6_usr_seg(struct ice_flow_seg_info *seg,
  * ice_cfg_fdir_xtrct_seq - Configure extraction sequence for the given filter
  * @pf: PF structure
  * @fsp: pointer to ethtool Rx flow specification
+ * @user: user defined data from flow specification
  *
  * Returns 0 on success.
  */
 static int
-ice_cfg_fdir_xtrct_seq(struct ice_pf *pf, struct ethtool_rx_flow_spec *fsp)
+ice_cfg_fdir_xtrct_seq(struct ice_pf *pf, struct ethtool_rx_flow_spec *fsp,
+		       struct ice_rx_flow_userdef *user)
 {
 	struct ice_flow_seg_info *seg, *tun_seg;
 	struct device *dev = ice_pf_to_dev(pf);
@@ -1008,6 +1070,18 @@ ice_cfg_fdir_xtrct_seq(struct ice_pf *pf, struct ethtool_rx_flow_spec *fsp)
 	/* tunnel segments are shifted up one. */
 	memcpy(&tun_seg[1], seg, sizeof(*seg));
 
+	if (user && user->flex_fltr) {
+		perfect_filter = false;
+		ice_flow_add_fld_raw(seg, user->flex_offset,
+				     ICE_FLTR_PRGM_FLEX_WORD_SIZE,
+				     ICE_FLOW_FLD_OFF_INVAL,
+				     ICE_FLOW_FLD_OFF_INVAL);
+		ice_flow_add_fld_raw(&tun_seg[1], user->flex_offset,
+				     ICE_FLTR_PRGM_FLEX_WORD_SIZE,
+				     ICE_FLOW_FLD_OFF_INVAL,
+				     ICE_FLOW_FLD_OFF_INVAL);
+	}
+
 	/* add filter for outer headers */
 	fltr_idx = ice_ethtool_flow_to_fltr(fsp->flow_type & ~FLOW_EXT);
 	ret = ice_fdir_set_hw_fltr_rule(pf, seg, fltr_idx,
@@ -1433,6 +1507,7 @@ ice_set_fdir_input_set(struct ice_vsi *vsi, struct ethtool_rx_flow_spec *fsp,
  */
 int ice_add_fdir_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 {
+	struct ice_rx_flow_userdef userdata;
 	struct ethtool_rx_flow_spec *fsp;
 	struct ice_fdir_fltr *input;
 	struct device *dev;
@@ -1460,10 +1535,13 @@ int ice_add_fdir_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 
 	fsp = (struct ethtool_rx_flow_spec *)&cmd->fs;
 
+	if (ice_parse_rx_flow_user_data(fsp, &userdata))
+		return -EINVAL;
+
 	if (fsp->flow_type & FLOW_MAC_EXT)
 		return -EINVAL;
 
-	ret = ice_cfg_fdir_xtrct_seq(pf, fsp);
+	ret = ice_cfg_fdir_xtrct_seq(pf, fsp, &userdata);
 	if (ret)
 		return ret;
 
@@ -1495,6 +1573,12 @@ int ice_add_fdir_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 		goto release_lock;
 	}
 
+	if (userdata.flex_fltr) {
+		input->flex_fltr = true;
+		input->flex_word = cpu_to_be16(userdata.flex_word);
+		input->flex_offset = userdata.flex_offset;
+	}
+
 	/* input struct is added to the HW filter list */
 	ice_fdir_update_list_entry(pf, input, fsp->location);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
index d50cc6e9086e..6834df14332f 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -650,6 +650,9 @@ ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
 		return ICE_ERR_PARAM;
 	}
 
+	if (input->flex_fltr)
+		ice_pkt_insert_u16(loc, input->flex_offset, input->flex_word);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.h b/drivers/net/ethernet/intel/ice/ice_fdir.h
index 977dcbc1400d..1c587766daab 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -68,6 +68,14 @@ struct ice_fd_fltr_desc_ctx {
 	u8 fdid_mdid;
 };
 
+#define ICE_FLTR_PRGM_FLEX_WORD_SIZE	sizeof(__be16)
+
+struct ice_rx_flow_userdef {
+	u16 flex_word;
+	u16 flex_offset;
+	u16 flex_fltr;
+};
+
 struct ice_fdir_v4 {
 	__be32 dst_ip;
 	__be32 src_ip;
@@ -112,6 +120,11 @@ struct ice_fdir_fltr {
 	struct ice_fdir_extra ext_data;
 	struct ice_fdir_extra ext_mask;
 
+	/* flex byte filter data */
+	__be16 flex_word;
+	u16 flex_offset;
+	u16 flex_fltr;
+
 	/* filter control */
 	u16 q_index;
 	u16 dest_vsi;
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index f4b6c3933564..d74e5290677f 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -193,6 +193,40 @@ ice_flow_val_hdrs(struct ice_flow_seg_info *segs, u8 segs_cnt)
 	return 0;
 }
 
+/* Sizes of fixed known protocol headers without header options */
+#define ICE_FLOW_PROT_HDR_SZ_MAC	14
+#define ICE_FLOW_PROT_HDR_SZ_IPV4	20
+#define ICE_FLOW_PROT_HDR_SZ_IPV6	40
+#define ICE_FLOW_PROT_HDR_SZ_TCP	20
+#define ICE_FLOW_PROT_HDR_SZ_UDP	8
+#define ICE_FLOW_PROT_HDR_SZ_SCTP	12
+
+/**
+ * ice_flow_calc_seg_sz - calculates size of a packet segment based on headers
+ * @params: information about the flow to be processed
+ * @seg: index of packet segment whose header size is to be determined
+ */
+static u16 ice_flow_calc_seg_sz(struct ice_flow_prof_params *params, u8 seg)
+{
+	u16 sz = ICE_FLOW_PROT_HDR_SZ_MAC;
+
+	/* L3 headers */
+	if (params->prof->segs[seg].hdrs & ICE_FLOW_SEG_HDR_IPV4)
+		sz += ICE_FLOW_PROT_HDR_SZ_IPV4;
+	else if (params->prof->segs[seg].hdrs & ICE_FLOW_SEG_HDR_IPV6)
+		sz += ICE_FLOW_PROT_HDR_SZ_IPV6;
+
+	/* L4 headers */
+	if (params->prof->segs[seg].hdrs & ICE_FLOW_SEG_HDR_TCP)
+		sz += ICE_FLOW_PROT_HDR_SZ_TCP;
+	else if (params->prof->segs[seg].hdrs & ICE_FLOW_SEG_HDR_UDP)
+		sz += ICE_FLOW_PROT_HDR_SZ_UDP;
+	else if (params->prof->segs[seg].hdrs & ICE_FLOW_SEG_HDR_SCTP)
+		sz += ICE_FLOW_PROT_HDR_SZ_SCTP;
+
+	return sz;
+}
+
 /**
  * ice_flow_proc_seg_hdrs - process protocol headers present in pkt segments
  * @params: information about the flow to be processed
@@ -347,6 +381,81 @@ ice_flow_xtract_fld(struct ice_hw *hw, struct ice_flow_prof_params *params,
 	return 0;
 }
 
+/**
+ * ice_flow_xtract_raws - Create extract sequence entries for raw bytes
+ * @hw: pointer to the HW struct
+ * @params: information about the flow to be processed
+ * @seg: index of packet segment whose raw fields are to be be extracted
+ */
+static enum ice_status
+ice_flow_xtract_raws(struct ice_hw *hw, struct ice_flow_prof_params *params,
+		     u8 seg)
+{
+	u16 fv_words;
+	u16 hdrs_sz;
+	u8 i;
+
+	if (!params->prof->segs[seg].raws_cnt)
+		return 0;
+
+	if (params->prof->segs[seg].raws_cnt >
+	    ARRAY_SIZE(params->prof->segs[seg].raws))
+		return ICE_ERR_MAX_LIMIT;
+
+	/* Offsets within the segment headers are not supported */
+	hdrs_sz = ice_flow_calc_seg_sz(params, seg);
+	if (!hdrs_sz)
+		return ICE_ERR_PARAM;
+
+	fv_words = hw->blk[params->blk].es.fvw;
+
+	for (i = 0; i < params->prof->segs[seg].raws_cnt; i++) {
+		struct ice_flow_seg_fld_raw *raw;
+		u16 off, cnt, j;
+
+		raw = &params->prof->segs[seg].raws[i];
+
+		/* Storing extraction information */
+		raw->info.xtrct.prot_id = ICE_PROT_MAC_OF_OR_S;
+		raw->info.xtrct.off = (raw->off / ICE_FLOW_FV_EXTRACT_SZ) *
+			ICE_FLOW_FV_EXTRACT_SZ;
+		raw->info.xtrct.disp = (raw->off % ICE_FLOW_FV_EXTRACT_SZ) *
+			BITS_PER_BYTE;
+		raw->info.xtrct.idx = params->es_cnt;
+
+		/* Determine the number of field vector entries this raw field
+		 * consumes.
+		 */
+		cnt = DIV_ROUND_UP(raw->info.xtrct.disp +
+				   (raw->info.src.last * BITS_PER_BYTE),
+				   (ICE_FLOW_FV_EXTRACT_SZ * BITS_PER_BYTE));
+		off = raw->info.xtrct.off;
+		for (j = 0; j < cnt; j++) {
+			u16 idx;
+
+			/* Make sure the number of extraction sequence required
+			 * does not exceed the block's capability
+			 */
+			if (params->es_cnt >= hw->blk[params->blk].es.count ||
+			    params->es_cnt >= ICE_MAX_FV_WORDS)
+				return ICE_ERR_MAX_LIMIT;
+
+			/* some blocks require a reversed field vector layout */
+			if (hw->blk[params->blk].es.reverse)
+				idx = fv_words - params->es_cnt - 1;
+			else
+				idx = params->es_cnt;
+
+			params->es[idx].prot_id = raw->info.xtrct.prot_id;
+			params->es[idx].off = off;
+			params->es_cnt++;
+			off += ICE_FLOW_FV_EXTRACT_SZ;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * ice_flow_create_xtrct_seq - Create an extraction sequence for given segments
  * @hw: pointer to the HW struct
@@ -373,6 +482,11 @@ ice_flow_create_xtrct_seq(struct ice_hw *hw,
 			if (status)
 				return status;
 		}
+
+		/* Process raw matching bytes */
+		status = ice_flow_xtract_raws(hw, params, i);
+		if (status)
+			return status;
 	}
 
 	return status;
@@ -943,6 +1057,42 @@ ice_flow_set_fld(struct ice_flow_seg_info *seg, enum ice_flow_field fld,
 	ice_flow_set_fld_ext(seg, fld, t, val_loc, mask_loc, last_loc);
 }
 
+/**
+ * ice_flow_add_fld_raw - sets locations of a raw field from entry's input buf
+ * @seg: packet segment the field being set belongs to
+ * @off: offset of the raw field from the beginning of the segment in bytes
+ * @len: length of the raw pattern to be matched
+ * @val_loc: location of the value to match from entry's input buffer
+ * @mask_loc: location of mask value from entry's input buffer
+ *
+ * This function specifies the offset of the raw field to be match from the
+ * beginning of the specified packet segment, and the locations, in the form of
+ * byte offsets from the start of the input buffer for a flow entry, from where
+ * the value to match and the mask value to be extracted. These locations are
+ * then stored in the flow profile. When adding flow entries to the associated
+ * flow profile, these locations can be used to quickly extract the values to
+ * create the content of a match entry. This function should only be used for
+ * fixed-size data structures.
+ */
+void
+ice_flow_add_fld_raw(struct ice_flow_seg_info *seg, u16 off, u8 len,
+		     u16 val_loc, u16 mask_loc)
+{
+	if (seg->raws_cnt < ICE_FLOW_SEG_RAW_FLD_MAX) {
+		seg->raws[seg->raws_cnt].off = off;
+		seg->raws[seg->raws_cnt].info.type = ICE_FLOW_FLD_TYPE_SIZE;
+		seg->raws[seg->raws_cnt].info.src.val = val_loc;
+		seg->raws[seg->raws_cnt].info.src.mask = mask_loc;
+		/* The "last" field is used to store the length of the field */
+		seg->raws[seg->raws_cnt].info.src.last = len;
+	}
+
+	/* Overflows of "raws" will be handled as an error condition later in
+	 * the flow when this information is processed.
+	 */
+	seg->raws_cnt++;
+}
+
 #define ICE_FLOW_RSS_SEG_HDR_L3_MASKS \
 	(ICE_FLOW_SEG_HDR_IPV4 | ICE_FLOW_SEG_HDR_IPV6)
 
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 3c784c3b5db2..3913da2116d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -128,6 +128,7 @@ enum ice_flow_priority {
 };
 
 #define ICE_FLOW_SEG_MAX		2
+#define ICE_FLOW_SEG_RAW_FLD_MAX	2
 #define ICE_FLOW_FV_EXTRACT_SZ		2
 
 #define ICE_FLOW_SET_HDRS(seg, val)	((seg)->hdrs |= (u32)(val))
@@ -164,12 +165,20 @@ struct ice_flow_fld_info {
 	struct ice_flow_seg_xtrct xtrct;
 };
 
+struct ice_flow_seg_fld_raw {
+	struct ice_flow_fld_info info;
+	u16 off;	/* Offset from the start of the segment */
+};
+
 struct ice_flow_seg_info {
 	u32 hdrs;	/* Bitmask indicating protocol headers present */
 	u64 match;	/* Bitmask indicating header fields to be matched */
 	u64 range;	/* Bitmask indicating header fields matched as ranges */
 
 	struct ice_flow_fld_info fields[ICE_FLOW_FIELD_IDX_MAX];
+
+	u8 raws_cnt;	/* Number of raw fields to be matched */
+	struct ice_flow_seg_fld_raw raws[ICE_FLOW_SEG_RAW_FLD_MAX];
 };
 
 /* This structure describes a flow entry, and is tracked only in this file */
@@ -228,6 +237,9 @@ ice_flow_rem_entry(struct ice_hw *hw, enum ice_block blk, u64 entry_h);
 void
 ice_flow_set_fld(struct ice_flow_seg_info *seg, enum ice_flow_field fld,
 		 u16 val_loc, u16 mask_loc, u16 last_loc, bool range);
+void
+ice_flow_add_fld_raw(struct ice_flow_seg_info *seg, u16 off, u8 len,
+		     u16 val_loc, u16 mask_loc);
 void ice_rem_vsi_rss_list(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status ice_replay_rss_cfg(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index babe4a485fd6..7f4c1ec1eff2 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -12,6 +12,7 @@
  */
 enum ice_prot_id {
 	ICE_PROT_ID_INVAL	= 0,
+	ICE_PROT_MAC_OF_OR_S	= 1,
 	ICE_PROT_IPV4_OF_OR_S	= 32,
 	ICE_PROT_IPV4_IL	= 33,
 	ICE_PROT_IPV6_OF_OR_S	= 40,
-- 
2.26.2

