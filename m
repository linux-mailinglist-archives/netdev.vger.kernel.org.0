Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C658A2116FC
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 01:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgGAX5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 19:57:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:5619 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgGAX5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 19:57:42 -0400
IronPort-SDR: giWPs2u+GxuYQegET4DHrto15UDyL+OnW64QRbNl2esAU8Dj6IgNmI4ZA6whe5Lp/dQfjCsSlG
 5p5W0VGVnFnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126365943"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="126365943"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 16:53:31 -0700
IronPort-SDR: r9Pq2GwAFNRzS21H2I7jCTm8cQx+/NgTpG9bQ/f21/UoEGlGl33QhwVrNX61fkEyPgR7NgiDix
 MxQHrd/BHTig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="481785445"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jul 2020 16:53:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 3/3] ice: replace single-element array used for C struct hack
Date:   Wed,  1 Jul 2020 16:53:26 -0700
Message-Id: <20200701235326.3176037-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701235326.3176037-1-anthony.l.nguyen@intel.com>
References: <20200701235326.3176037-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Convert the pre-C90-extension "C struct hack" method (using a single-
element array at the end of a structure for implementing variable-length
types) to the preferred use of C99 flexible array member.

Additional code cleanups were done near areas affected by this change.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 23 +++---
 drivers/net/ethernet/intel/ice/ice_base.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_common.c   | 74 ++++++++++---------
 drivers/net/ethernet/intel/ice/ice_dcb.h      |  4 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 35 +++++----
 .../net/ethernet/intel/ice/ice_flex_type.h    | 39 +++++-----
 drivers/net/ethernet/intel/ice/ice_lib.c      |  2 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |  4 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 36 ++++-----
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  6 +-
 10 files changed, 111 insertions(+), 114 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index a55dc1594daa..99c39249613a 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -267,7 +267,7 @@ struct ice_aqc_alloc_free_res_elem {
 #define ICE_AQC_RES_TYPE_VSI_PRUNE_LIST_M	\
 				(0xF << ICE_AQC_RES_TYPE_VSI_PRUNE_LIST_S)
 	__le16 num_elems;
-	struct ice_aqc_res_elem elem[1];
+	struct ice_aqc_res_elem elem[];
 };
 
 /* Add VSI (indirect 0x0210)
@@ -561,8 +561,8 @@ struct ice_sw_rule_lkup_rx_tx {
 	 * lookup-type
 	 */
 	__le16 hdr_len;
-	u8 hdr[1];
-} __packed;
+	u8 hdr[];
+};
 
 /* Add/Update/Remove large action command/response entry
  * "index" is returned as part of a response to a successful Add command, and
@@ -571,7 +571,6 @@ struct ice_sw_rule_lkup_rx_tx {
 struct ice_sw_rule_lg_act {
 	__le16 index; /* Index in large action table */
 	__le16 size;
-	__le32 act[1]; /* array of size for actions */
 	/* Max number of large actions */
 #define ICE_MAX_LG_ACT	4
 	/* Bit 0:1 - Action type */
@@ -622,6 +621,7 @@ struct ice_sw_rule_lg_act {
 #define ICE_LG_ACT_STAT_COUNT		0x7
 #define ICE_LG_ACT_STAT_COUNT_S		3
 #define ICE_LG_ACT_STAT_COUNT_M		(0x7F << ICE_LG_ACT_STAT_COUNT_S)
+	__le32 act[]; /* array of size for actions */
 };
 
 /* Add/Update/Remove VSI list command/response entry
@@ -631,7 +631,7 @@ struct ice_sw_rule_lg_act {
 struct ice_sw_rule_vsi_list {
 	__le16 index; /* Index of VSI/Prune list */
 	__le16 number_vsi;
-	__le16 vsi[1]; /* Array of number_vsi VSI numbers */
+	__le16 vsi[]; /* Array of number_vsi VSI numbers */
 };
 
 /* Query VSI list command/response entry */
@@ -738,7 +738,7 @@ struct ice_aqc_txsched_topo_grp_info_hdr {
 
 struct ice_aqc_add_elem {
 	struct ice_aqc_txsched_topo_grp_info_hdr hdr;
-	struct ice_aqc_txsched_elem_data generic[1];
+	struct ice_aqc_txsched_elem_data generic[];
 };
 
 struct ice_aqc_get_topo_elem {
@@ -749,7 +749,7 @@ struct ice_aqc_get_topo_elem {
 
 struct ice_aqc_delete_elem {
 	struct ice_aqc_txsched_topo_grp_info_hdr hdr;
-	__le32 teid[1];
+	__le32 teid[];
 };
 
 /* Query Port ETS (indirect 0x040E)
@@ -1510,7 +1510,7 @@ struct ice_aqc_add_tx_qgrp {
 	__le32 parent_teid;
 	u8 num_txqs;
 	u8 rsvd[3];
-	struct ice_aqc_add_txqs_perq txqs[1];
+	struct ice_aqc_add_txqs_perq txqs[];
 };
 
 /* Disable Tx LAN Queues (indirect 0x0C31) */
@@ -1548,14 +1548,13 @@ struct ice_aqc_dis_txq_item {
 	u8 num_qs;
 	u8 rsvd;
 	/* The length of the q_id array varies according to num_qs */
-	__le16 q_id[1];
-	/* This only applies from F8 onward */
 #define ICE_AQC_Q_DIS_BUF_ELEM_TYPE_S		15
 #define ICE_AQC_Q_DIS_BUF_ELEM_TYPE_LAN_Q	\
 			(0 << ICE_AQC_Q_DIS_BUF_ELEM_TYPE_S)
 #define ICE_AQC_Q_DIS_BUF_ELEM_TYPE_RDMA_QSET	\
 			(1 << ICE_AQC_Q_DIS_BUF_ELEM_TYPE_S)
-};
+	__le16 q_id[];
+} __packed;
 
 /* Configure Firmware Logging Command (indirect 0xFF09)
  * Logging Information Read Response (indirect 0xFF10)
@@ -1679,7 +1678,7 @@ struct ice_aqc_get_pkg_info {
 /* Get Package Info List response buffer format (0x0C43) */
 struct ice_aqc_get_pkg_info_resp {
 	__le32 count;
-	struct ice_aqc_get_pkg_info pkg_info[1];
+	struct ice_aqc_get_pkg_info pkg_info[];
 };
 
 /* Lan Queue Overflow Event (direct, 0x1001) */
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index d620d26d42ed..87008476d8fe 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -635,10 +635,10 @@ int
 ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
 		struct ice_aqc_add_tx_qgrp *qg_buf)
 {
+	u8 buf_len = struct_size(qg_buf, txqs, 1);
 	struct ice_tlan_ctx tlan_ctx = { 0 };
 	struct ice_aqc_add_txqs_perq *txq;
 	struct ice_pf *pf = vsi->back;
-	u8 buf_len = sizeof(*qg_buf);
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
 	u16 pf_q;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 622ab1f0e18f..57fd815c41bc 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1536,7 +1536,7 @@ ice_alloc_hw_res(struct ice_hw *hw, u16 type, u16 num, bool btm, u16 *res)
 	enum ice_status status;
 	u16 buf_len;
 
-	buf_len = struct_size(buf, elem, num - 1);
+	buf_len = struct_size(buf, elem, num);
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		return ICE_ERR_NO_MEMORY;
@@ -1553,7 +1553,7 @@ ice_alloc_hw_res(struct ice_hw *hw, u16 type, u16 num, bool btm, u16 *res)
 	if (status)
 		goto ice_alloc_res_exit;
 
-	memcpy(res, buf->elem, sizeof(buf->elem) * num);
+	memcpy(res, buf->elem, sizeof(*buf->elem) * num);
 
 ice_alloc_res_exit:
 	kfree(buf);
@@ -1574,7 +1574,7 @@ ice_free_hw_res(struct ice_hw *hw, u16 type, u16 num, u16 *res)
 	enum ice_status status;
 	u16 buf_len;
 
-	buf_len = struct_size(buf, elem, num - 1);
+	buf_len = struct_size(buf, elem, num);
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		return ICE_ERR_NO_MEMORY;
@@ -1582,7 +1582,7 @@ ice_free_hw_res(struct ice_hw *hw, u16 type, u16 num, u16 *res)
 	/* Prepare buffer to free resource. */
 	buf->num_elems = cpu_to_le16(num);
 	buf->res_type = cpu_to_le16(type);
-	memcpy(buf->elem, res, sizeof(buf->elem) * num);
+	memcpy(buf->elem, res, sizeof(*buf->elem) * num);
 
 	status = ice_aq_alloc_free_res(hw, num, buf, buf_len,
 				       ice_aqc_opc_free_res, NULL);
@@ -2922,10 +2922,10 @@ ice_aq_add_lan_txq(struct ice_hw *hw, u8 num_qgrps,
 		   struct ice_aqc_add_tx_qgrp *qg_list, u16 buf_size,
 		   struct ice_sq_cd *cd)
 {
-	u16 i, sum_header_size, sum_q_size = 0;
 	struct ice_aqc_add_tx_qgrp *list;
 	struct ice_aqc_add_txqs *cmd;
 	struct ice_aq_desc desc;
+	u16 i, sum_size = 0;
 
 	cmd = &desc.params.add_txqs;
 
@@ -2937,18 +2937,13 @@ ice_aq_add_lan_txq(struct ice_hw *hw, u8 num_qgrps,
 	if (num_qgrps > ICE_LAN_TXQ_MAX_QGRPS)
 		return ICE_ERR_PARAM;
 
-	sum_header_size = num_qgrps *
-		(sizeof(*qg_list) - sizeof(*qg_list->txqs));
-
-	list = qg_list;
-	for (i = 0; i < num_qgrps; i++) {
-		struct ice_aqc_add_txqs_perq *q = list->txqs;
-
-		sum_q_size += list->num_txqs * sizeof(*q);
-		list = (struct ice_aqc_add_tx_qgrp *)(q + list->num_txqs);
+	for (i = 0, list = qg_list; i < num_qgrps; i++) {
+		sum_size += struct_size(list, txqs, list->num_txqs);
+		list = (struct ice_aqc_add_tx_qgrp *)(list->txqs +
+						      list->num_txqs);
 	}
 
-	if (buf_size != (sum_header_size + sum_q_size))
+	if (buf_size != sum_size)
 		return ICE_ERR_PARAM;
 
 	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
@@ -2976,6 +2971,7 @@ ice_aq_dis_lan_txq(struct ice_hw *hw, u8 num_qgrps,
 		   enum ice_disq_rst_src rst_src, u16 vmvf_num,
 		   struct ice_sq_cd *cd)
 {
+	struct ice_aqc_dis_txq_item *item;
 	struct ice_aqc_dis_txqs *cmd;
 	struct ice_aq_desc desc;
 	enum ice_status status;
@@ -3025,16 +3021,16 @@ ice_aq_dis_lan_txq(struct ice_hw *hw, u8 num_qgrps,
 	 */
 	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
 
-	for (i = 0; i < num_qgrps; ++i) {
-		/* Calculate the size taken up by the queue IDs in this group */
-		sz += qg_list[i].num_qs * sizeof(qg_list[i].q_id);
-
-		/* Add the size of the group header */
-		sz += sizeof(qg_list[i]) - sizeof(qg_list[i].q_id);
+	for (i = 0, item = qg_list; i < num_qgrps; i++) {
+		u16 item_size = struct_size(item, q_id, item->num_qs);
 
 		/* If the num of queues is even, add 2 bytes of padding */
-		if ((qg_list[i].num_qs % 2) == 0)
-			sz += 2;
+		if ((item->num_qs % 2) == 0)
+			item_size += 2;
+
+		sz += item_size;
+
+		item = (struct ice_aqc_dis_txq_item *)((u8 *)item + item_size);
 	}
 
 	if (buf_size != sz)
@@ -3423,24 +3419,32 @@ ice_dis_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_queues,
 		struct ice_sq_cd *cd)
 {
 	enum ice_status status = ICE_ERR_DOES_NOT_EXIST;
-	struct ice_aqc_dis_txq_item qg_list;
+	struct ice_aqc_dis_txq_item *qg_list;
 	struct ice_q_ctx *q_ctx;
-	u16 i;
+	struct ice_hw *hw;
+	u16 i, buf_size;
 
 	if (!pi || pi->port_state != ICE_SCHED_PORT_STATE_READY)
 		return ICE_ERR_CFG;
 
+	hw = pi->hw;
+
 	if (!num_queues) {
 		/* if queue is disabled already yet the disable queue command
 		 * has to be sent to complete the VF reset, then call
 		 * ice_aq_dis_lan_txq without any queue information
 		 */
 		if (rst_src)
-			return ice_aq_dis_lan_txq(pi->hw, 0, NULL, 0, rst_src,
+			return ice_aq_dis_lan_txq(hw, 0, NULL, 0, rst_src,
 						  vmvf_num, NULL);
 		return ICE_ERR_CFG;
 	}
 
+	buf_size = struct_size(qg_list, q_id, 1);
+	qg_list = kzalloc(buf_size, GFP_KERNEL);
+	if (!qg_list)
+		return ICE_ERR_NO_MEMORY;
+
 	mutex_lock(&pi->sched_lock);
 
 	for (i = 0; i < num_queues; i++) {
@@ -3449,23 +3453,22 @@ ice_dis_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_queues,
 		node = ice_sched_find_node_by_teid(pi->root, q_teids[i]);
 		if (!node)
 			continue;
-		q_ctx = ice_get_lan_q_ctx(pi->hw, vsi_handle, tc, q_handles[i]);
+		q_ctx = ice_get_lan_q_ctx(hw, vsi_handle, tc, q_handles[i]);
 		if (!q_ctx) {
-			ice_debug(pi->hw, ICE_DBG_SCHED, "invalid queue handle%d\n",
+			ice_debug(hw, ICE_DBG_SCHED, "invalid queue handle%d\n",
 				  q_handles[i]);
 			continue;
 		}
 		if (q_ctx->q_handle != q_handles[i]) {
-			ice_debug(pi->hw, ICE_DBG_SCHED, "Err:handles %d %d\n",
+			ice_debug(hw, ICE_DBG_SCHED, "Err:handles %d %d\n",
 				  q_ctx->q_handle, q_handles[i]);
 			continue;
 		}
-		qg_list.parent_teid = node->info.parent_teid;
-		qg_list.num_qs = 1;
-		qg_list.q_id[0] = cpu_to_le16(q_ids[i]);
-		status = ice_aq_dis_lan_txq(pi->hw, 1, &qg_list,
-					    sizeof(qg_list), rst_src, vmvf_num,
-					    cd);
+		qg_list->parent_teid = node->info.parent_teid;
+		qg_list->num_qs = 1;
+		qg_list->q_id[0] = cpu_to_le16(q_ids[i]);
+		status = ice_aq_dis_lan_txq(hw, 1, qg_list, buf_size, rst_src,
+					    vmvf_num, cd);
 
 		if (status)
 			break;
@@ -3473,6 +3476,7 @@ ice_dis_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u8 num_queues,
 		q_ctx->q_handle = ICE_INVAL_Q_HANDLE;
 	}
 	mutex_unlock(&pi->sched_lock);
+	kfree(qg_list);
 	return status;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.h b/drivers/net/ethernet/intel/ice/ice_dcb.h
index ee138f9bdc7c..d7e5e6178a21 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.h
@@ -87,7 +87,7 @@
 struct ice_lldp_org_tlv {
 	__be16 typelen;
 	__be32 ouisubtype;
-	u8 tlvinfo[1];
+	u8 tlvinfo[];
 } __packed;
 
 struct ice_cee_tlv_hdr {
@@ -109,7 +109,7 @@ struct ice_cee_feat_tlv {
 #define ICE_CEE_FEAT_TLV_WILLING_M	0x40
 #define ICE_CEE_FEAT_TLV_ERR_M		0x20
 	u8 subtype;
-	u8 tlvinfo[1];
+	u8 tlvinfo[];
 };
 
 struct ice_cee_app_prio {
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 4420fc02f7e7..3c217e51b27e 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1121,8 +1121,7 @@ static enum ice_status ice_get_pkg_info(struct ice_hw *hw)
 	u16 size;
 	u32 i;
 
-	size = sizeof(*pkg_info) + (sizeof(pkg_info->pkg_info[0]) *
-				    (ICE_PKG_CNT - 1));
+	size = struct_size(pkg_info, pkg_info, ICE_PKG_CNT);
 	pkg_info = kzalloc(size, GFP_KERNEL);
 	if (!pkg_info)
 		return ICE_ERR_NO_MEMORY;
@@ -1180,7 +1179,7 @@ static enum ice_status ice_verify_pkg(struct ice_pkg_hdr *pkg, u32 len)
 	u32 seg_count;
 	u32 i;
 
-	if (len < sizeof(*pkg))
+	if (len < struct_size(pkg, seg_offset, 1))
 		return ICE_ERR_BUF_TOO_SHORT;
 
 	if (pkg->pkg_format_ver.major != ICE_PKG_FMT_VER_MAJ ||
@@ -1195,7 +1194,7 @@ static enum ice_status ice_verify_pkg(struct ice_pkg_hdr *pkg, u32 len)
 		return ICE_ERR_CFG;
 
 	/* make sure segment array fits in package length */
-	if (len < sizeof(*pkg) + ((seg_count - 1) * sizeof(pkg->seg_offset)))
+	if (len < struct_size(pkg, seg_offset, seg_count))
 		return ICE_ERR_BUF_TOO_SHORT;
 
 	/* all segments must fit within length */
@@ -1300,7 +1299,7 @@ ice_chk_pkg_compat(struct ice_hw *hw, struct ice_pkg_hdr *ospkg,
 	}
 
 	/* Check if FW is compatible with the OS package */
-	size = struct_size(pkg, pkg_info, ICE_PKG_CNT - 1);
+	size = struct_size(pkg, pkg_info, ICE_PKG_CNT);
 	pkg = kzalloc(size, GFP_KERNEL);
 	if (!pkg)
 		return ICE_ERR_NO_MEMORY;
@@ -1764,13 +1763,13 @@ ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port)
 		goto ice_create_tunnel_err;
 
 	sect_rx = ice_pkg_buf_alloc_section(bld, ICE_SID_RXPARSER_BOOST_TCAM,
-					    sizeof(*sect_rx));
+					    struct_size(sect_rx, tcam, 1));
 	if (!sect_rx)
 		goto ice_create_tunnel_err;
 	sect_rx->count = cpu_to_le16(1);
 
 	sect_tx = ice_pkg_buf_alloc_section(bld, ICE_SID_TXPARSER_BOOST_TCAM,
-					    sizeof(*sect_tx));
+					    struct_size(sect_tx, tcam, 1));
 	if (!sect_tx)
 		goto ice_create_tunnel_err;
 	sect_tx->count = cpu_to_le16(1);
@@ -1847,7 +1846,7 @@ enum ice_status ice_destroy_tunnel(struct ice_hw *hw, u16 port, bool all)
 	}
 
 	/* size of section - there is at least one entry */
-	size = struct_size(sect_rx, tcam, count - 1);
+	size = struct_size(sect_rx, tcam, count);
 
 	bld = ice_pkg_buf_alloc(hw);
 	if (!bld) {
@@ -3324,10 +3323,10 @@ ice_prof_bld_es(struct ice_hw *hw, enum ice_block blk,
 			u32 id;
 
 			id = ice_sect_id(blk, ICE_VEC_TBL);
-			p = (struct ice_pkg_es *)
-				ice_pkg_buf_alloc_section(bld, id, sizeof(*p) +
-							  vec_size -
-							  sizeof(p->es[0]));
+			p = ice_pkg_buf_alloc_section(bld, id,
+						      struct_size(p, es, 1) +
+						      vec_size -
+						      sizeof(p->es[0]));
 
 			if (!p)
 				return ICE_ERR_MAX_LIMIT;
@@ -3360,8 +3359,8 @@ ice_prof_bld_tcam(struct ice_hw *hw, enum ice_block blk,
 			u32 id;
 
 			id = ice_sect_id(blk, ICE_PROF_TCAM);
-			p = (struct ice_prof_id_section *)
-				ice_pkg_buf_alloc_section(bld, id, sizeof(*p));
+			p = ice_pkg_buf_alloc_section(bld, id,
+						      struct_size(p, entry, 1));
 
 			if (!p)
 				return ICE_ERR_MAX_LIMIT;
@@ -3396,8 +3395,8 @@ ice_prof_bld_xlt1(enum ice_block blk, struct ice_buf_build *bld,
 			u32 id;
 
 			id = ice_sect_id(blk, ICE_XLT1);
-			p = (struct ice_xlt1_section *)
-				ice_pkg_buf_alloc_section(bld, id, sizeof(*p));
+			p = ice_pkg_buf_alloc_section(bld, id,
+						      struct_size(p, value, 1));
 
 			if (!p)
 				return ICE_ERR_MAX_LIMIT;
@@ -3431,8 +3430,8 @@ ice_prof_bld_xlt2(enum ice_block blk, struct ice_buf_build *bld,
 		case ICE_VSI_MOVE:
 		case ICE_VSIG_REM:
 			id = ice_sect_id(blk, ICE_XLT2);
-			p = (struct ice_xlt2_section *)
-				ice_pkg_buf_alloc_section(bld, id, sizeof(*p));
+			p = ice_pkg_buf_alloc_section(bld, id,
+						      struct_size(p, value, 1));
 
 			if (!p)
 				return ICE_ERR_MAX_LIMIT;
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index a6f391eac8ff..c1c99a267a98 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -22,7 +22,7 @@ struct ice_fv {
 struct ice_pkg_hdr {
 	struct ice_pkg_ver pkg_format_ver;
 	__le32 seg_count;
-	__le32 seg_offset[1];
+	__le32 seg_offset[];
 };
 
 /* generic segment */
@@ -53,12 +53,12 @@ struct ice_device_id_entry {
 struct ice_seg {
 	struct ice_generic_seg_hdr hdr;
 	__le32 device_table_count;
-	struct ice_device_id_entry device_table[1];
+	struct ice_device_id_entry device_table[];
 };
 
 struct ice_nvm_table {
 	__le32 table_count;
-	__le32 vers[1];
+	__le32 vers[];
 };
 
 struct ice_buf {
@@ -68,7 +68,7 @@ struct ice_buf {
 
 struct ice_buf_table {
 	__le32 buf_count;
-	struct ice_buf buf_array[1];
+	struct ice_buf buf_array[];
 };
 
 /* global metadata specific segment */
@@ -101,11 +101,12 @@ struct ice_section_entry {
 struct ice_buf_hdr {
 	__le16 section_count;
 	__le16 data_end;
-	struct ice_section_entry section_entry[1];
+	struct ice_section_entry section_entry[];
 };
 
 #define ICE_MAX_ENTRIES_IN_BUF(hd_sz, ent_sz) ((ICE_PKG_BUF_SIZE - \
-	sizeof(struct ice_buf_hdr) - (hd_sz)) / (ent_sz))
+	struct_size((struct ice_buf_hdr *)0, section_entry, 1) - (hd_sz)) /\
+	(ent_sz))
 
 /* ice package section IDs */
 #define ICE_SID_XLT0_SW			10
@@ -198,17 +199,17 @@ struct ice_label {
 
 struct ice_label_section {
 	__le16 count;
-	struct ice_label label[1];
+	struct ice_label label[];
 };
 
 #define ICE_MAX_LABELS_IN_BUF ICE_MAX_ENTRIES_IN_BUF( \
-	sizeof(struct ice_label_section) - sizeof(struct ice_label), \
-	sizeof(struct ice_label))
+	struct_size((struct ice_label_section *)0, label, 1) - \
+	sizeof(struct ice_label), sizeof(struct ice_label))
 
 struct ice_sw_fv_section {
 	__le16 count;
 	__le16 base_offset;
-	struct ice_fv fv[1];
+	struct ice_fv fv[];
 };
 
 /* The BOOST TCAM stores the match packet header in reverse order, meaning
@@ -245,30 +246,30 @@ struct ice_boost_tcam_entry {
 struct ice_boost_tcam_section {
 	__le16 count;
 	__le16 reserved;
-	struct ice_boost_tcam_entry tcam[1];
+	struct ice_boost_tcam_entry tcam[];
 };
 
 #define ICE_MAX_BST_TCAMS_IN_BUF ICE_MAX_ENTRIES_IN_BUF( \
-	sizeof(struct ice_boost_tcam_section) - \
+	struct_size((struct ice_boost_tcam_section *)0, tcam, 1) - \
 	sizeof(struct ice_boost_tcam_entry), \
 	sizeof(struct ice_boost_tcam_entry))
 
 struct ice_xlt1_section {
 	__le16 count;
 	__le16 offset;
-	u8 value[1];
-} __packed;
+	u8 value[];
+};
 
 struct ice_xlt2_section {
 	__le16 count;
 	__le16 offset;
-	__le16 value[1];
+	__le16 value[];
 };
 
 struct ice_prof_redir_section {
 	__le16 count;
 	__le16 offset;
-	u8 redir_value[1];
+	u8 redir_value[];
 };
 
 /* package buffer building */
@@ -327,7 +328,7 @@ struct ice_tunnel_table {
 struct ice_pkg_es {
 	__le16 count;
 	__le16 offset;
-	struct ice_fv_word es[1];
+	struct ice_fv_word es[];
 };
 
 struct ice_es {
@@ -461,8 +462,8 @@ struct ice_prof_tcam_entry {
 
 struct ice_prof_id_section {
 	__le16 count;
-	struct ice_prof_tcam_entry entry[1];
-} __packed;
+	struct ice_prof_tcam_entry entry[];
+};
 
 struct ice_prof_tcam {
 	u32 sid;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 2e3a39cea2c0..8a4c7b8b95df 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1667,7 +1667,7 @@ ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings)
 	u16 q_idx = 0;
 	int err = 0;
 
-	qg_buf = kzalloc(sizeof(*qg_buf), GFP_KERNEL);
+	qg_buf = kzalloc(struct_size(qg_buf, txqs, 1), GFP_KERNEL);
 	if (!qg_buf)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 294257b4d138..1c29cfa1cf33 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -238,7 +238,7 @@ ice_sched_remove_elems(struct ice_hw *hw, struct ice_sched_node *parent,
 	enum ice_status status;
 	u16 buf_size;
 
-	buf_size = sizeof(*buf) + sizeof(u32) * (num_nodes - 1);
+	buf_size = struct_size(buf, teid, num_nodes);
 	buf = devm_kzalloc(ice_hw_to_dev(hw), buf_size, GFP_KERNEL);
 	if (!buf)
 		return ICE_ERR_NO_MEMORY;
@@ -825,7 +825,7 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 	size_t buf_size;
 	u32 teid;
 
-	buf_size = struct_size(buf, generic, num_nodes - 1);
+	buf_size = struct_size(buf, generic, num_nodes);
 	buf = devm_kzalloc(ice_hw_to_dev(hw), buf_size, GFP_KERNEL);
 	if (!buf)
 		return ICE_ERR_NO_MEMORY;
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 0414be3f47dd..ccbe1cc64295 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -29,25 +29,17 @@ static const u8 dummy_eth_header[DUMMY_ETH_HDR_LEN] = { 0x2, 0, 0, 0, 0, 0,
 							0x81, 0, 0, 0};
 
 #define ICE_SW_RULE_RX_TX_ETH_HDR_SIZE \
-	(sizeof(struct ice_aqc_sw_rules_elem) - \
-	 sizeof(((struct ice_aqc_sw_rules_elem *)0)->pdata) + \
-	 sizeof(struct ice_sw_rule_lkup_rx_tx) + DUMMY_ETH_HDR_LEN - 1)
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr) + \
+	 (DUMMY_ETH_HDR_LEN * \
+	  sizeof(((struct ice_sw_rule_lkup_rx_tx *)0)->hdr[0])))
 #define ICE_SW_RULE_RX_TX_NO_HDR_SIZE \
-	(sizeof(struct ice_aqc_sw_rules_elem) - \
-	 sizeof(((struct ice_aqc_sw_rules_elem *)0)->pdata) + \
-	 sizeof(struct ice_sw_rule_lkup_rx_tx) - 1)
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr))
 #define ICE_SW_RULE_LG_ACT_SIZE(n) \
-	(sizeof(struct ice_aqc_sw_rules_elem) - \
-	 sizeof(((struct ice_aqc_sw_rules_elem *)0)->pdata) + \
-	 sizeof(struct ice_sw_rule_lg_act) - \
-	 sizeof(((struct ice_sw_rule_lg_act *)0)->act) + \
-	 ((n) * sizeof(((struct ice_sw_rule_lg_act *)0)->act)))
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lg_act.act) + \
+	 ((n) * sizeof(((struct ice_sw_rule_lg_act *)0)->act[0])))
 #define ICE_SW_RULE_VSI_LIST_SIZE(n) \
-	(sizeof(struct ice_aqc_sw_rules_elem) - \
-	 sizeof(((struct ice_aqc_sw_rules_elem *)0)->pdata) + \
-	 sizeof(struct ice_sw_rule_vsi_list) - \
-	 sizeof(((struct ice_sw_rule_vsi_list *)0)->vsi) + \
-	 ((n) * sizeof(((struct ice_sw_rule_vsi_list *)0)->vsi)))
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.vsi_list.vsi) + \
+	 ((n) * sizeof(((struct ice_sw_rule_vsi_list *)0)->vsi[0])))
 
 /**
  * ice_init_def_sw_recp - initialize the recipe book keeping tables
@@ -449,7 +441,7 @@ ice_aq_alloc_free_vsi_list(struct ice_hw *hw, u16 *vsi_list_id,
 	enum ice_status status;
 	u16 buf_len;
 
-	buf_len = sizeof(*sw_buf);
+	buf_len = struct_size(sw_buf, elem, 1);
 	sw_buf = devm_kzalloc(ice_hw_to_dev(hw), buf_len, GFP_KERNEL);
 	if (!sw_buf)
 		return ICE_ERR_NO_MEMORY;
@@ -856,8 +848,7 @@ ice_add_marker_act(struct ice_hw *hw, struct ice_fltr_mgmt_list_entry *m_ent,
 		m_ent->fltr_info.fwd_id.hw_vsi_id;
 
 	act = ICE_LG_ACT_VSI_FORWARDING | ICE_LG_ACT_VALID_BIT;
-	act |= (id << ICE_LG_ACT_VSI_LIST_ID_S) &
-		ICE_LG_ACT_VSI_LIST_ID_M;
+	act |= (id << ICE_LG_ACT_VSI_LIST_ID_S) & ICE_LG_ACT_VSI_LIST_ID_M;
 	if (m_ent->vsi_count > 1)
 		act |= ICE_LG_ACT_VSI_LIST;
 	lg_act->pdata.lg_act.act[0] = cpu_to_le32(act);
@@ -2037,7 +2028,8 @@ ice_cfg_dflt_vsi(struct ice_hw *hw, u16 vsi_handle, bool set, u8 direction)
 	hw_vsi_id = ice_get_hw_vsi_num(hw, vsi_handle);
 
 	s_rule_size = set ? ICE_SW_RULE_RX_TX_ETH_HDR_SIZE :
-			    ICE_SW_RULE_RX_TX_NO_HDR_SIZE;
+		ICE_SW_RULE_RX_TX_NO_HDR_SIZE;
+
 	s_rule = devm_kzalloc(ice_hw_to_dev(hw), s_rule_size, GFP_KERNEL);
 	if (!s_rule)
 		return ICE_ERR_NO_MEMORY;
@@ -2691,7 +2683,7 @@ ice_alloc_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
 	u16 buf_len;
 
 	/* Allocate resource */
-	buf_len = sizeof(*buf);
+	buf_len = struct_size(buf, elem, 1);
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		return ICE_ERR_NO_MEMORY;
@@ -2729,7 +2721,7 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
 	u16 buf_len;
 
 	/* Free resource */
-	buf_len = sizeof(*buf);
+	buf_len = struct_size(buf, elem, 1);
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		return ICE_ERR_NO_MEMORY;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index b6f928c9e9c9..6badfd62dc63 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -206,12 +206,14 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 	struct ice_aqc_add_tx_qgrp *qg_buf;
 	struct ice_ring *tx_ring, *rx_ring;
 	struct ice_q_vector *q_vector;
+	u16 size;
 	int err;
 
 	if (q_idx >= vsi->num_rxq || q_idx >= vsi->num_txq)
 		return -EINVAL;
 
-	qg_buf = kzalloc(sizeof(*qg_buf), GFP_KERNEL);
+	size = struct_size(qg_buf, txqs, 1);
+	qg_buf = kzalloc(size, GFP_KERNEL);
 	if (!qg_buf)
 		return -ENOMEM;
 
@@ -228,7 +230,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 	if (ice_is_xdp_ena_vsi(vsi)) {
 		struct ice_ring *xdp_ring = vsi->xdp_rings[q_idx];
 
-		memset(qg_buf, 0, sizeof(*qg_buf));
+		memset(qg_buf, 0, size);
 		qg_buf->num_txqs = 1;
 		err = ice_vsi_cfg_txq(vsi, xdp_ring, qg_buf);
 		if (err)
-- 
2.26.2

