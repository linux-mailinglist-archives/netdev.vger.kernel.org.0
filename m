Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF75215AEC
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgGFPja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:39:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37514 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729499AbgGFPj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:39:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066Fa1kJ025408;
        Mon, 6 Jul 2020 08:39:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=TkXwX20Djb7EhEcfSGjq02+eYsUcek8jEM2PtZ2nABw=;
 b=N9WlOU7e5eNBUorZ8qILCgwt0d1UIeJbCifc0yb0wX2ZJub4byJFT4bpGEh33X/tKcU9
 X36Q3ElDbhXuWEruRQ1ZmIG0DOvdPJ97xFisQFiKVYjNy1K0EV8DULBWxp4rb4vt2fTk
 qg/zjQV8HqSipqZr6lAUkxzJuuur+AvLeifilREk5zk8JzQJWi/NwKgneB41xv3CrKof
 QpMFiQ//uLMa+VMUZOThIzlRQkqLMIAt+cCXfO/oSx+BHf0RohxT8PeClNflmiiSH4hP
 gFpeh2e2Fq3DxpleaI3GutPgF48s9GdD7RBL1pe8vJGAQDot/KXVlDYfUdatjSKFXesa tg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 322q4pqm80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:39:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:39:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 08:39:16 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 3B85A3F703F;
        Mon,  6 Jul 2020 08:39:12 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 7/9] net: qed: sanitize BE/LE data processing
Date:   Mon, 6 Jul 2020 18:38:19 +0300
Message-ID: <20200706153821.786-8-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706153821.786-1-alobakin@marvell.com>
References: <20200706153821.786-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code assumes that both host and device operates in Little Endian
in lots of places. While this is true for x86 platform, this doesn't mean
we should not care about this.

This commit addresses all parts of the code that were pointed out by sparse
checker. All operations with restricted (__be*/__le*) types are now
protected with explicit from/to CPU conversions, even if they're noops on
common setups.

I'm sure there are more such places, but this implies a deeper code
investigation, and is a subject for future works.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     |  11 +-
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c    |  27 ++-
 drivers/net/ethernet/qlogic/qed/qed_debug.c   |  49 +++--
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c    |  54 +++---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |  48 ++---
 .../ethernet/qlogic/qed/qed_init_fw_funcs.c   |  93 ++++-----
 drivers/net/ethernet/qlogic/qed/qed_int.c     |  74 ++++----
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c   |  43 +++--
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c   | 132 ++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_l2.c      |  22 ++-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     |   9 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  12 +-
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c    |  52 +++---
 drivers/net/ethernet/qlogic/qed/qed_rdma.h    |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_roce.c    | 176 +++++++-----------
 drivers/net/ethernet/qlogic/qed/qed_sp.h      |   2 +-
 .../net/ethernet/qlogic/qed/qed_sp_commands.c |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   |   4 +-
 include/linux/qed/qed_if.h                    |  15 +-
 20 files changed, 434 insertions(+), 399 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 3a62358b9749..5362dc18b6c2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -73,8 +73,8 @@ union type1_task_context {
 };
 
 struct src_ent {
-	u8				opaque[56];
-	u64				next;
+	__u8				opaque[56];
+	__be64				next;
 };
 
 #define CDUT_SEG_ALIGNMET		3 /* in 4k chunks */
@@ -2177,6 +2177,7 @@ qed_cxt_dynamic_ilt_alloc(struct qed_hwfn *p_hwfn,
 	dma_addr_t p_phys;
 	u64 ilt_hw_entry;
 	void *p_virt;
+	u32 flags1;
 	int rc = 0;
 
 	switch (elem_type) {
@@ -2255,8 +2256,10 @@ qed_cxt_dynamic_ilt_alloc(struct qed_hwfn *p_hwfn,
 			elem = (union type1_task_context *)elem_start;
 			tdif_context = &elem->roce_ctx.tdif_context;
 
-			SET_FIELD(tdif_context->flags1,
-				  TDIF_TASK_CONTEXT_REF_TAG_MASK, 0xf);
+			flags1 = le32_to_cpu(tdif_context->flags1);
+			SET_FIELD(flags1, TDIF_TASK_CONTEXT_REF_TAG_MASK, 0xf);
+			tdif_context->flags1 = cpu_to_le32(flags1);
+
 			elem_start += TYPE1_TASK_CXT_SIZE(p_hwfn);
 		}
 	}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
index 9f16a3a66007..17d5b649eb36 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -547,7 +547,8 @@ qed_dcbx_get_ets_data(struct qed_hwfn *p_hwfn,
 		      struct dcbx_ets_feature *p_ets,
 		      struct qed_dcbx_params *p_params)
 {
-	u32 bw_map[2], tsa_map[2], pri_map;
+	__be32 bw_map[2], tsa_map[2];
+	u32 pri_map;
 	int i;
 
 	p_params->ets_willing = QED_MFW_GET_FIELD(p_ets->flags,
@@ -573,11 +574,10 @@ qed_dcbx_get_ets_data(struct qed_hwfn *p_hwfn,
 	/* 8 bit tsa and bw data corresponding to each of the 8 TC's are
 	 * encoded in a type u32 array of size 2.
 	 */
-	bw_map[0] = be32_to_cpu(p_ets->tc_bw_tbl[0]);
-	bw_map[1] = be32_to_cpu(p_ets->tc_bw_tbl[1]);
-	tsa_map[0] = be32_to_cpu(p_ets->tc_tsa_tbl[0]);
-	tsa_map[1] = be32_to_cpu(p_ets->tc_tsa_tbl[1]);
+	cpu_to_be32_array(bw_map, p_ets->tc_bw_tbl, 2);
+	cpu_to_be32_array(tsa_map, p_ets->tc_tsa_tbl, 2);
 	pri_map = p_ets->pri_tc_tbl[0];
+
 	for (i = 0; i < QED_MAX_PFC_PRIORITIES; i++) {
 		p_params->ets_tc_bw_tbl[i] = ((u8 *)bw_map)[i];
 		p_params->ets_tc_tsa_tbl[i] = ((u8 *)tsa_map)[i];
@@ -1054,7 +1054,7 @@ qed_dcbx_set_ets_data(struct qed_hwfn *p_hwfn,
 		      struct dcbx_ets_feature *p_ets,
 		      struct qed_dcbx_params *p_params)
 {
-	u8 *bw_map, *tsa_map;
+	__be32 bw_map[2], tsa_map[2];
 	u32 val;
 	int i;
 
@@ -1076,22 +1076,21 @@ qed_dcbx_set_ets_data(struct qed_hwfn *p_hwfn,
 	p_ets->flags &= ~DCBX_ETS_MAX_TCS_MASK;
 	p_ets->flags |= (u32)p_params->max_ets_tc << DCBX_ETS_MAX_TCS_SHIFT;
 
-	bw_map = (u8 *)&p_ets->tc_bw_tbl[0];
-	tsa_map = (u8 *)&p_ets->tc_tsa_tbl[0];
 	p_ets->pri_tc_tbl[0] = 0;
+
 	for (i = 0; i < QED_MAX_PFC_PRIORITIES; i++) {
-		bw_map[i] = p_params->ets_tc_bw_tbl[i];
-		tsa_map[i] = p_params->ets_tc_tsa_tbl[i];
+		((u8 *)bw_map)[i] = p_params->ets_tc_bw_tbl[i];
+		((u8 *)tsa_map)[i] = p_params->ets_tc_tsa_tbl[i];
+
 		/* Copy the priority value to the corresponding 4 bits in the
 		 * traffic class table.
 		 */
 		val = (((u32)p_params->ets_pri_tc_tbl[i]) << ((7 - i) * 4));
 		p_ets->pri_tc_tbl[0] |= val;
 	}
-	for (i = 0; i < 2; i++) {
-		p_ets->tc_bw_tbl[i] = cpu_to_be32(p_ets->tc_bw_tbl[i]);
-		p_ets->tc_tsa_tbl[i] = cpu_to_be32(p_ets->tc_tsa_tbl[i]);
-	}
+
+	be32_to_cpu_array(p_ets->tc_bw_tbl, bw_map, 2);
+	be32_to_cpu_array(p_ets->tc_tsa_tbl, tsa_map, 2);
 }
 
 static void
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index f856bb9a3897..41ab23712bbd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -972,7 +972,7 @@ static void qed_read_storm_fw_info(struct qed_hwfn *p_hwfn,
 {
 	struct storm_defs *storm = &s_storm_defs[storm_id];
 	struct fw_info_location fw_info_location;
-	u32 addr, i, *dest;
+	u32 addr, i, size, *dest;
 
 	memset(&fw_info_location, 0, sizeof(fw_info_location));
 	memset(fw_info, 0, sizeof(*fw_info));
@@ -985,20 +985,29 @@ static void qed_read_storm_fw_info(struct qed_hwfn *p_hwfn,
 	    sizeof(fw_info_location);
 
 	dest = (u32 *)&fw_info_location;
+	size = BYTES_TO_DWORDS(sizeof(fw_info_location));
 
-	for (i = 0; i < BYTES_TO_DWORDS(sizeof(fw_info_location));
-	     i++, addr += BYTES_IN_DWORD)
+	for (i = 0; i < size; i++, addr += BYTES_IN_DWORD)
 		dest[i] = qed_rd(p_hwfn, p_ptt, addr);
 
+	/* qed_rq() fetches data in CPU byteorder. Swap it back to
+	 * the device's to get right structure layout.
+	 */
+	cpu_to_le32_array(dest, size);
+
 	/* Read FW version info from Storm RAM */
-	if (fw_info_location.size > 0 && fw_info_location.size <=
-	    sizeof(*fw_info)) {
-		addr = fw_info_location.grc_addr;
-		dest = (u32 *)fw_info;
-		for (i = 0; i < BYTES_TO_DWORDS(fw_info_location.size);
-		     i++, addr += BYTES_IN_DWORD)
-			dest[i] = qed_rd(p_hwfn, p_ptt, addr);
-	}
+	size = le32_to_cpu(fw_info_location.size);
+	if (!size || size > sizeof(*fw_info))
+		return;
+
+	addr = le32_to_cpu(fw_info_location.grc_addr);
+	dest = (u32 *)fw_info;
+	size = BYTES_TO_DWORDS(size);
+
+	for (i = 0; i < size; i++, addr += BYTES_IN_DWORD)
+		dest[i] = qed_rd(p_hwfn, p_ptt, addr);
+
+	cpu_to_le32_array(dest, size);
 }
 
 /* Dumps the specified string to the specified buffer.
@@ -1123,7 +1132,7 @@ static u32 qed_dump_fw_ver_param(struct qed_hwfn *p_hwfn,
 	offset += qed_dump_str_param(dump_buf + offset,
 				     dump, "fw-image", fw_img_str);
 	offset += qed_dump_num_param(dump_buf + offset, dump, "fw-timestamp",
-				     fw_info.ver.timestamp);
+				     le32_to_cpu(fw_info.ver.timestamp));
 
 	return offset;
 }
@@ -4440,9 +4449,11 @@ static u32 qed_fw_asserts_dump(struct qed_hwfn *p_hwfn,
 			continue;
 		}
 
+		addr = le16_to_cpu(asserts->section_ram_line_offset);
 		fw_asserts_section_addr = storm->sem_fast_mem_addr +
-			SEM_FAST_REG_INT_RAM +
-			RAM_LINES_TO_BYTES(asserts->section_ram_line_offset);
+					  SEM_FAST_REG_INT_RAM +
+					  RAM_LINES_TO_BYTES(addr);
+
 		next_list_idx_addr = fw_asserts_section_addr +
 			DWORDS_TO_BYTES(asserts->list_next_index_dword_offset);
 		next_list_idx = qed_rd(p_hwfn, p_ptt, next_list_idx_addr);
@@ -7650,8 +7661,7 @@ static int qed_dbg_nvm_image(struct qed_dev *cdev, void *buffer,
 {
 	struct qed_hwfn *p_hwfn =
 		&cdev->hwfns[cdev->engine_for_debug];
-	u32 len_rounded, i;
-	__be32 val;
+	u32 len_rounded;
 	int rc;
 
 	*num_dumped_bytes = 0;
@@ -7670,10 +7680,9 @@ static int qed_dbg_nvm_image(struct qed_dev *cdev, void *buffer,
 
 	/* QED_NVM_IMAGE_NVM_META image is not swapped like other images */
 	if (image_id != QED_NVM_IMAGE_NVM_META)
-		for (i = 0; i < len_rounded; i += 4) {
-			val = cpu_to_be32(*(u32 *)(buffer + i));
-			*(u32 *)(buffer + i) = val;
-		}
+		cpu_to_be32_array((__force __be32 *)buffer,
+				  (const u32 *)buffer,
+				  len_rounded / sizeof(u32));
 
 	*num_dumped_bytes = len_rounded;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_fcoe.c b/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
index a10e57bba6b9..b768f0698170 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_fcoe.c
@@ -95,7 +95,7 @@ qed_sp_fcoe_func_start(struct qed_hwfn *p_hwfn,
 	struct qed_cxt_info cxt_info;
 	u32 dummy_cid;
 	int rc = 0;
-	u16 tmp;
+	__le16 tmp;
 	u8 i;
 
 	/* Get SPQ entry */
@@ -162,17 +162,13 @@ qed_sp_fcoe_func_start(struct qed_hwfn *p_hwfn,
 	tmp = cpu_to_le16(fcoe_pf_params->cmdq_num_entries);
 	p_data->q_params.cmdq_num_entries = tmp;
 
-	tmp = fcoe_pf_params->num_cqs;
-	p_data->q_params.num_queues = (u8)tmp;
+	p_data->q_params.num_queues = fcoe_pf_params->num_cqs;
 
-	tmp = (u16)p_hwfn->hw_info.resc_start[QED_CMDQS_CQS];
-	p_data->q_params.queue_relative_offset = (u8)tmp;
+	tmp = (__force __le16)p_hwfn->hw_info.resc_start[QED_CMDQS_CQS];
+	p_data->q_params.queue_relative_offset = (__force u8)tmp;
 
 	for (i = 0; i < fcoe_pf_params->num_cqs; i++) {
-		u16 igu_sb_id;
-
-		igu_sb_id = qed_get_igu_sb_id(p_hwfn, i);
-		tmp = cpu_to_le16(igu_sb_id);
+		tmp = cpu_to_le16(qed_get_igu_sb_id(p_hwfn, i));
 		p_data->q_params.cq_cmdq_sb_num_arr[i] = tmp;
 	}
 
@@ -185,21 +181,21 @@ qed_sp_fcoe_func_start(struct qed_hwfn *p_hwfn,
 		       fcoe_pf_params->bdq_pbl_base_addr[BDQ_ID_RQ]);
 	p_data->q_params.bdq_pbl_num_entries[BDQ_ID_RQ] =
 	    fcoe_pf_params->bdq_pbl_num_entries[BDQ_ID_RQ];
-	tmp = fcoe_pf_params->bdq_xoff_threshold[BDQ_ID_RQ];
-	p_data->q_params.bdq_xoff_threshold[BDQ_ID_RQ] = cpu_to_le16(tmp);
-	tmp = fcoe_pf_params->bdq_xon_threshold[BDQ_ID_RQ];
-	p_data->q_params.bdq_xon_threshold[BDQ_ID_RQ] = cpu_to_le16(tmp);
+	tmp = cpu_to_le16(fcoe_pf_params->bdq_xoff_threshold[BDQ_ID_RQ]);
+	p_data->q_params.bdq_xoff_threshold[BDQ_ID_RQ] = tmp;
+	tmp = cpu_to_le16(fcoe_pf_params->bdq_xon_threshold[BDQ_ID_RQ]);
+	p_data->q_params.bdq_xon_threshold[BDQ_ID_RQ] = tmp;
 
 	DMA_REGPAIR_LE(p_data->q_params.bdq_pbl_base_address[BDQ_ID_IMM_DATA],
 		       fcoe_pf_params->bdq_pbl_base_addr[BDQ_ID_IMM_DATA]);
 	p_data->q_params.bdq_pbl_num_entries[BDQ_ID_IMM_DATA] =
 	    fcoe_pf_params->bdq_pbl_num_entries[BDQ_ID_IMM_DATA];
-	tmp = fcoe_pf_params->bdq_xoff_threshold[BDQ_ID_IMM_DATA];
-	p_data->q_params.bdq_xoff_threshold[BDQ_ID_IMM_DATA] = cpu_to_le16(tmp);
-	tmp = fcoe_pf_params->bdq_xon_threshold[BDQ_ID_IMM_DATA];
-	p_data->q_params.bdq_xon_threshold[BDQ_ID_IMM_DATA] = cpu_to_le16(tmp);
-	tmp = fcoe_pf_params->rq_buffer_size;
-	p_data->q_params.rq_buffer_size = cpu_to_le16(tmp);
+	tmp = cpu_to_le16(fcoe_pf_params->bdq_xoff_threshold[BDQ_ID_IMM_DATA]);
+	p_data->q_params.bdq_xoff_threshold[BDQ_ID_IMM_DATA] = tmp;
+	tmp = cpu_to_le16(fcoe_pf_params->bdq_xon_threshold[BDQ_ID_IMM_DATA]);
+	p_data->q_params.bdq_xon_threshold[BDQ_ID_IMM_DATA] = tmp;
+	tmp = cpu_to_le16(fcoe_pf_params->rq_buffer_size);
+	p_data->q_params.rq_buffer_size = tmp;
 
 	if (fcoe_pf_params->is_target) {
 		SET_FIELD(p_data->q_params.q_validity,
@@ -233,7 +229,8 @@ qed_sp_fcoe_conn_offload(struct qed_hwfn *p_hwfn,
 	struct fcoe_conn_offload_ramrod_data *p_data;
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
-	u16 physical_q0, tmp;
+	u16 physical_q0;
+	__le16 tmp;
 	int rc;
 
 	/* Get SPQ entry */
@@ -254,7 +251,7 @@ qed_sp_fcoe_conn_offload(struct qed_hwfn *p_hwfn,
 
 	/* Transmission PQ is the first of the PF */
 	physical_q0 = qed_get_cm_pq_idx(p_hwfn, PQ_FLAGS_OFLD);
-	p_conn->physical_q0 = cpu_to_le16(physical_q0);
+	p_conn->physical_q0 = physical_q0;
 	p_data->physical_q0 = cpu_to_le16(physical_q0);
 
 	p_data->conn_id = cpu_to_le16(p_conn->conn_id);
@@ -553,8 +550,8 @@ int qed_fcoe_alloc(struct qed_hwfn *p_hwfn)
 void qed_fcoe_setup(struct qed_hwfn *p_hwfn)
 {
 	struct e4_fcoe_task_context *p_task_ctx = NULL;
+	u32 i, lc;
 	int rc;
-	u32 i;
 
 	spin_lock_init(&p_hwfn->p_fcoe_info->lock);
 	for (i = 0; i < p_hwfn->pf_params.fcoe_pf_params.num_tasks; i++) {
@@ -565,10 +562,15 @@ void qed_fcoe_setup(struct qed_hwfn *p_hwfn)
 			continue;
 
 		memset(p_task_ctx, 0, sizeof(struct e4_fcoe_task_context));
-		SET_FIELD(p_task_ctx->timer_context.logical_client_0,
-			  TIMERS_CONTEXT_VALIDLC0, 1);
-		SET_FIELD(p_task_ctx->timer_context.logical_client_1,
-			  TIMERS_CONTEXT_VALIDLC1, 1);
+
+		lc = 0;
+		SET_FIELD(lc, TIMERS_CONTEXT_VALIDLC0, 1);
+		p_task_ctx->timer_context.logical_client_0 = cpu_to_le32(lc);
+
+		lc = 0;
+		SET_FIELD(lc, TIMERS_CONTEXT_VALIDLC1, 1);
+		p_task_ctx->timer_context.logical_client_1 = cpu_to_le32(lc);
+
 		SET_FIELD(p_task_ctx->tstorm_ag_context.flags0,
 			  E4_TSTORM_FCOE_TASK_AG_CTX_CONNECTION_TYPE, 1);
 	}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 71809ff97a03..6bb0bbc0013b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -2793,7 +2793,7 @@ struct fw_overlay_buf_hdr {
 
 /* init array header: raw */
 struct init_array_raw_hdr {
-	u32						data;
+	__le32						data;
 #define INIT_ARRAY_RAW_HDR_TYPE_MASK			0xF
 #define INIT_ARRAY_RAW_HDR_TYPE_SHIFT			0
 #define INIT_ARRAY_RAW_HDR_PARAMS_MASK			0xFFFFFFF
@@ -2802,7 +2802,7 @@ struct init_array_raw_hdr {
 
 /* init array header: standard */
 struct init_array_standard_hdr {
-	u32						data;
+	__le32						data;
 #define INIT_ARRAY_STANDARD_HDR_TYPE_MASK		0xF
 #define INIT_ARRAY_STANDARD_HDR_TYPE_SHIFT		0
 #define INIT_ARRAY_STANDARD_HDR_SIZE_MASK		0xFFFFFFF
@@ -2811,7 +2811,7 @@ struct init_array_standard_hdr {
 
 /* init array header: zipped */
 struct init_array_zipped_hdr {
-	u32						data;
+	__le32						data;
 #define INIT_ARRAY_ZIPPED_HDR_TYPE_MASK			0xF
 #define INIT_ARRAY_ZIPPED_HDR_TYPE_SHIFT		0
 #define INIT_ARRAY_ZIPPED_HDR_ZIPPED_SIZE_MASK		0xFFFFFFF
@@ -2820,7 +2820,7 @@ struct init_array_zipped_hdr {
 
 /* init array header: pattern */
 struct init_array_pattern_hdr {
-	u32						data;
+	__le32						data;
 #define INIT_ARRAY_PATTERN_HDR_TYPE_MASK		0xF
 #define INIT_ARRAY_PATTERN_HDR_TYPE_SHIFT		0
 #define INIT_ARRAY_PATTERN_HDR_PATTERN_SIZE_MASK	0xF
@@ -2847,48 +2847,48 @@ enum init_array_types {
 
 /* init operation: callback */
 struct init_callback_op {
-	u32						op_data;
+	__le32						op_data;
 #define INIT_CALLBACK_OP_OP_MASK			0xF
 #define INIT_CALLBACK_OP_OP_SHIFT			0
 #define INIT_CALLBACK_OP_RESERVED_MASK			0xFFFFFFF
 #define INIT_CALLBACK_OP_RESERVED_SHIFT			4
-	u16						callback_id;
-	u16						block_id;
+	__le16						callback_id;
+	__le16						block_id;
 };
 
 /* init operation: delay */
 struct init_delay_op {
-	u32						op_data;
+	__le32						op_data;
 #define INIT_DELAY_OP_OP_MASK				0xF
 #define INIT_DELAY_OP_OP_SHIFT				0
 #define INIT_DELAY_OP_RESERVED_MASK			0xFFFFFFF
 #define INIT_DELAY_OP_RESERVED_SHIFT			4
-	u32						delay;
+	__le32						delay;
 };
 
 /* init operation: if_mode */
 struct init_if_mode_op {
-	u32						op_data;
+	__le32						op_data;
 #define INIT_IF_MODE_OP_OP_MASK				0xF
 #define INIT_IF_MODE_OP_OP_SHIFT			0
 #define INIT_IF_MODE_OP_RESERVED1_MASK			0xFFF
 #define INIT_IF_MODE_OP_RESERVED1_SHIFT			4
 #define INIT_IF_MODE_OP_CMD_OFFSET_MASK			0xFFFF
 #define INIT_IF_MODE_OP_CMD_OFFSET_SHIFT		16
-	u16						reserved2;
-	u16						modes_buf_offset;
+	__le16						reserved2;
+	__le16						modes_buf_offset;
 };
 
 /* init operation: if_phase */
 struct init_if_phase_op {
-	u32						op_data;
+	__le32						op_data;
 #define INIT_IF_PHASE_OP_OP_MASK			0xF
 #define INIT_IF_PHASE_OP_OP_SHIFT			0
 #define INIT_IF_PHASE_OP_RESERVED1_MASK			0xFFF
 #define INIT_IF_PHASE_OP_RESERVED1_SHIFT		4
 #define INIT_IF_PHASE_OP_CMD_OFFSET_MASK		0xFFFF
 #define INIT_IF_PHASE_OP_CMD_OFFSET_SHIFT		16
-	u32						phase_data;
+	__le32						phase_data;
 #define INIT_IF_PHASE_OP_PHASE_MASK			0xFF
 #define INIT_IF_PHASE_OP_PHASE_SHIFT			0
 #define INIT_IF_PHASE_OP_RESERVED2_MASK			0xFF
@@ -2907,31 +2907,31 @@ enum init_mode_ops {
 
 /* init operation: raw */
 struct init_raw_op {
-	u32						op_data;
+	__le32						op_data;
 #define INIT_RAW_OP_OP_MASK				0xF
 #define INIT_RAW_OP_OP_SHIFT				0
 #define INIT_RAW_OP_PARAM1_MASK				0xFFFFFFF
 #define INIT_RAW_OP_PARAM1_SHIFT			4
-	u32						param2;
+	__le32						param2;
 };
 
 /* init array params */
 struct init_op_array_params {
-	u16						size;
-	u16						offset;
+	__le16						size;
+	__le16						offset;
 };
 
 /* Write init operation arguments */
 union init_write_args {
-	u32						inline_val;
-	u32						zeros_count;
-	u32						array_offset;
+	__le32						inline_val;
+	__le32						zeros_count;
+	__le32						array_offset;
 	struct init_op_array_params			runtime;
 };
 
 /* init operation: write */
 struct init_write_op {
-	u32						data;
+	__le32						data;
 #define INIT_WRITE_OP_OP_MASK				0xF
 #define INIT_WRITE_OP_OP_SHIFT				0
 #define INIT_WRITE_OP_SOURCE_MASK			0x7
@@ -2947,7 +2947,7 @@ struct init_write_op {
 
 /* init operation: read */
 struct init_read_op {
-	u32						op_data;
+	__le32						op_data;
 #define INIT_READ_OP_OP_MASK				0xF
 #define INIT_READ_OP_OP_SHIFT				0
 #define INIT_READ_OP_POLL_TYPE_MASK			0xF
@@ -2956,7 +2956,7 @@ struct init_read_op {
 #define INIT_READ_OP_RESERVED_SHIFT			8
 #define INIT_READ_OP_ADDRESS_MASK			0x7FFFFF
 #define INIT_READ_OP_ADDRESS_SHIFT			9
-	u32						expected_val;
+	__le32						expected_val;
 };
 
 /* Init operations union */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index 775ef5eaefd4..ea888a2c6ddb 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -159,23 +159,22 @@ static u16 task_region_offsets[1][NUM_OF_CONNECTION_TYPES_E4] = {
 #define QM_INIT_TX_PQ_MAP(p_hwfn, map, chip, pq_id, vp_pq_id, rl_valid,	      \
 			  rl_id, ext_voq, wrr)				      \
 	do {								      \
-		typeof(map) __map;					      \
+		u32 __reg = 0;						      \
 									      \
-		memset(&__map, 0, sizeof(__map));			      \
+		BUILD_BUG_ON(sizeof((map).reg) != sizeof(__reg));	      \
 									      \
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_PQ_VALID, 1);      \
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_RL_VALID,	      \
+		SET_FIELD(__reg, QM_RF_PQ_MAP_##chip##_PQ_VALID, 1);	      \
+		SET_FIELD(__reg, QM_RF_PQ_MAP_##chip##_RL_VALID,	      \
 			  !!(rl_valid));				      \
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_VP_PQ_ID,	      \
-			  (vp_pq_id));					      \
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_RL_ID, (rl_id));   \
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_VOQ, (ext_voq));   \
-		SET_FIELD(__map.reg, QM_RF_PQ_MAP_##chip##_WRR_WEIGHT_GROUP,  \
+		SET_FIELD(__reg, QM_RF_PQ_MAP_##chip##_VP_PQ_ID, (vp_pq_id)); \
+		SET_FIELD(__reg, QM_RF_PQ_MAP_##chip##_RL_ID, (rl_id));	      \
+		SET_FIELD(__reg, QM_RF_PQ_MAP_##chip##_VOQ, (ext_voq));	      \
+		SET_FIELD(__reg, QM_RF_PQ_MAP_##chip##_WRR_WEIGHT_GROUP,      \
 			  (wrr));					      \
 									      \
 		STORE_RT_REG((p_hwfn), QM_REG_TXPQMAP_RT_OFFSET + (pq_id),    \
-			     *((u32 *)&__map));				      \
-		(map) = __map;						      \
+			     __reg);					      \
+		(map).reg = cpu_to_le32(__reg);				      \
 	} while (0)
 
 #define WRITE_PQ_INFO_TO_RAM	1
@@ -1012,9 +1011,10 @@ bool qed_send_qm_stop_cmd(struct qed_hwfn *p_hwfn,
  *         input.
  */
 static int qed_dmae_to_grc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
-			   u32 *p_data, u32 addr, u32 len_in_dwords)
+			   __le32 *p_data, u32 addr, u32 len_in_dwords)
 {
 	struct qed_dmae_params params = {};
+	u32 *data_cpu;
 	int rc;
 
 	if (!p_data)
@@ -1033,8 +1033,13 @@ static int qed_dmae_to_grc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 		DP_VERBOSE(p_hwfn,
 			   QED_MSG_DEBUG,
 			   "Failed writing to chip using DMAE, using GRC instead\n");
-		/* write to registers using GRC */
-		ARR_REG_WR(p_hwfn, p_ptt, addr, p_data, len_in_dwords);
+
+		/* Swap to CPU byteorder and write to registers using GRC */
+		data_cpu = (__force u32 *)p_data;
+		le32_to_cpu_array(data_cpu, len_in_dwords);
+
+		ARR_REG_WR(p_hwfn, p_ptt, addr, data_cpu, len_in_dwords);
+		cpu_to_le32_array(data_cpu, len_in_dwords);
 	}
 
 	return len_in_dwords;
@@ -1235,7 +1240,7 @@ void qed_gft_disable(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt, u16 pf_id)
 	qed_wr(p_hwfn, p_ptt, PRS_REG_GFT_CAM + CAM_LINE_SIZE * pf_id, 0);
 
 	/* Zero ramline */
-	qed_dmae_to_grc(p_hwfn, p_ptt, (u32 *)&ram_line,
+	qed_dmae_to_grc(p_hwfn, p_ptt, &ram_line.lo,
 			PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id,
 			sizeof(ram_line) / REG_SIZE);
 }
@@ -1247,8 +1252,10 @@ void qed_gft_config(struct qed_hwfn *p_hwfn,
 		    bool udp,
 		    bool ipv4, bool ipv6, enum gft_profile_type profile_type)
 {
-	u32 reg_val, cam_line, search_non_ip_as_gft;
-	struct regpair ram_line = { };
+	struct regpair ram_line;
+	u32 search_non_ip_as_gft;
+	u32 reg_val, cam_line;
+	u32 lo = 0, hi = 0;
 
 	if (!ipv6 && !ipv4)
 		DP_NOTICE(p_hwfn,
@@ -1319,43 +1326,46 @@ void qed_gft_config(struct qed_hwfn *p_hwfn,
 	search_non_ip_as_gft = 0;
 
 	/* Tunnel type */
-	SET_FIELD(ram_line.lo, GFT_RAM_LINE_TUNNEL_DST_PORT, 1);
-	SET_FIELD(ram_line.lo, GFT_RAM_LINE_TUNNEL_OVER_IP_PROTOCOL, 1);
+	SET_FIELD(lo, GFT_RAM_LINE_TUNNEL_DST_PORT, 1);
+	SET_FIELD(lo, GFT_RAM_LINE_TUNNEL_OVER_IP_PROTOCOL, 1);
 
 	if (profile_type == GFT_PROFILE_TYPE_4_TUPLE) {
-		SET_FIELD(ram_line.hi, GFT_RAM_LINE_DST_IP, 1);
-		SET_FIELD(ram_line.hi, GFT_RAM_LINE_SRC_IP, 1);
-		SET_FIELD(ram_line.hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
-		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
-		SET_FIELD(ram_line.lo, GFT_RAM_LINE_SRC_PORT, 1);
-		SET_FIELD(ram_line.lo, GFT_RAM_LINE_DST_PORT, 1);
+		SET_FIELD(hi, GFT_RAM_LINE_DST_IP, 1);
+		SET_FIELD(hi, GFT_RAM_LINE_SRC_IP, 1);
+		SET_FIELD(hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
+		SET_FIELD(lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(lo, GFT_RAM_LINE_SRC_PORT, 1);
+		SET_FIELD(lo, GFT_RAM_LINE_DST_PORT, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_L4_DST_PORT) {
-		SET_FIELD(ram_line.hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
-		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
-		SET_FIELD(ram_line.lo, GFT_RAM_LINE_DST_PORT, 1);
+		SET_FIELD(hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
+		SET_FIELD(lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(lo, GFT_RAM_LINE_DST_PORT, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_IP_DST_ADDR) {
-		SET_FIELD(ram_line.hi, GFT_RAM_LINE_DST_IP, 1);
-		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(hi, GFT_RAM_LINE_DST_IP, 1);
+		SET_FIELD(lo, GFT_RAM_LINE_ETHERTYPE, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_IP_SRC_ADDR) {
-		SET_FIELD(ram_line.hi, GFT_RAM_LINE_SRC_IP, 1);
-		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(hi, GFT_RAM_LINE_SRC_IP, 1);
+		SET_FIELD(lo, GFT_RAM_LINE_ETHERTYPE, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_TUNNEL_TYPE) {
-		SET_FIELD(ram_line.lo, GFT_RAM_LINE_TUNNEL_ETHERTYPE, 1);
+		SET_FIELD(lo, GFT_RAM_LINE_TUNNEL_ETHERTYPE, 1);
 
 		/* Allow tunneled traffic without inner IP */
 		search_non_ip_as_gft = 1;
 	}
 
+	ram_line.lo = cpu_to_le32(lo);
+	ram_line.hi = cpu_to_le32(hi);
+
 	qed_wr(p_hwfn,
 	       p_ptt, PRS_REG_SEARCH_NON_IP_AS_GFT, search_non_ip_as_gft);
-	qed_dmae_to_grc(p_hwfn, p_ptt, (u32 *)&ram_line,
+	qed_dmae_to_grc(p_hwfn, p_ptt, &ram_line.lo,
 			PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id,
 			sizeof(ram_line) / REG_SIZE);
 
 	/* Set default profile so that no filter match will happen */
-	ram_line.lo = 0xffffffff;
-	ram_line.hi = 0x3ff;
-	qed_dmae_to_grc(p_hwfn, p_ptt, (u32 *)&ram_line,
+	ram_line.lo = cpu_to_le32(0xffffffff);
+	ram_line.hi = cpu_to_le32(0x3ff);
+	qed_dmae_to_grc(p_hwfn, p_ptt, &ram_line.lo,
 			PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE *
 			PRS_GFT_CAM_LINES_NO_MATCH,
 			sizeof(ram_line) / REG_SIZE);
@@ -1373,7 +1383,7 @@ static u8 qed_calc_cdu_validation_byte(u8 conn_type, u8 region, u32 cid)
 	u8 crc, validation_byte = 0;
 	static u8 crc8_table_valid; /* automatically initialized to 0 */
 	u32 validation_string = 0;
-	u32 data_to_crc;
+	__be32 data_to_crc;
 
 	if (!crc8_table_valid) {
 		crc8_populate_msb(cdu_crc8_table, 0x07);
@@ -1395,10 +1405,9 @@ static u8 qed_calc_cdu_validation_byte(u8 conn_type, u8 region, u32 cid)
 		validation_string |= (conn_type & 0xF);
 
 	/* Convert to big-endian and calculate CRC8 */
-	data_to_crc = be32_to_cpu(validation_string);
-
-	crc = crc8(cdu_crc8_table,
-		   (u8 *)&data_to_crc, sizeof(data_to_crc), CRC8_INIT_VALUE);
+	data_to_crc = cpu_to_be32(validation_string);
+	crc = crc8(cdu_crc8_table, (u8 *)&data_to_crc, sizeof(data_to_crc),
+		   CRC8_INIT_VALUE);
 
 	/* The validation byte [7:0] is composed:
 	 * for type A validation
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 0da38c47a8cf..9be40280eaaa 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1191,16 +1191,15 @@ static int qed_int_attentions(struct qed_hwfn *p_hwfn)
 static void qed_sb_ack_attn(struct qed_hwfn *p_hwfn,
 			    void __iomem *igu_addr, u32 ack_cons)
 {
-	struct igu_prod_cons_update igu_ack = { 0 };
+	u32 igu_ack;
 
-	igu_ack.sb_id_and_flags =
-		((ack_cons << IGU_PROD_CONS_UPDATE_SB_INDEX_SHIFT) |
-		 (1 << IGU_PROD_CONS_UPDATE_UPDATE_FLAG_SHIFT) |
-		 (IGU_INT_NOP << IGU_PROD_CONS_UPDATE_ENABLE_INT_SHIFT) |
-		 (IGU_SEG_ACCESS_ATTN <<
-		  IGU_PROD_CONS_UPDATE_SEGMENT_ACCESS_SHIFT));
+	igu_ack = ((ack_cons << IGU_PROD_CONS_UPDATE_SB_INDEX_SHIFT) |
+		   (1 << IGU_PROD_CONS_UPDATE_UPDATE_FLAG_SHIFT) |
+		   (IGU_INT_NOP << IGU_PROD_CONS_UPDATE_ENABLE_INT_SHIFT) |
+		   (IGU_SEG_ACCESS_ATTN <<
+		    IGU_PROD_CONS_UPDATE_SEGMENT_ACCESS_SHIFT));
 
-	DIRECT_REG_WR(igu_addr, igu_ack.sb_id_and_flags);
+	DIRECT_REG_WR(igu_addr, igu_ack);
 
 	/* Both segments (interrupts & acks) are written to same place address;
 	 * Need to guarantee all commands will be received (in-order) by HW.
@@ -1414,16 +1413,16 @@ void qed_init_cau_sb_entry(struct qed_hwfn *p_hwfn,
 			   u8 pf_id, u16 vf_number, u8 vf_valid)
 {
 	struct qed_dev *cdev = p_hwfn->cdev;
-	u32 cau_state;
+	u32 cau_state, params = 0, data = 0;
 	u8 timer_res;
 
 	memset(p_sb_entry, 0, sizeof(*p_sb_entry));
 
-	SET_FIELD(p_sb_entry->params, CAU_SB_ENTRY_PF_NUMBER, pf_id);
-	SET_FIELD(p_sb_entry->params, CAU_SB_ENTRY_VF_NUMBER, vf_number);
-	SET_FIELD(p_sb_entry->params, CAU_SB_ENTRY_VF_VALID, vf_valid);
-	SET_FIELD(p_sb_entry->params, CAU_SB_ENTRY_SB_TIMESET0, 0x7F);
-	SET_FIELD(p_sb_entry->params, CAU_SB_ENTRY_SB_TIMESET1, 0x7F);
+	SET_FIELD(params, CAU_SB_ENTRY_PF_NUMBER, pf_id);
+	SET_FIELD(params, CAU_SB_ENTRY_VF_NUMBER, vf_number);
+	SET_FIELD(params, CAU_SB_ENTRY_VF_VALID, vf_valid);
+	SET_FIELD(params, CAU_SB_ENTRY_SB_TIMESET0, 0x7F);
+	SET_FIELD(params, CAU_SB_ENTRY_SB_TIMESET1, 0x7F);
 
 	cau_state = CAU_HC_DISABLE_STATE;
 
@@ -1442,7 +1441,8 @@ void qed_init_cau_sb_entry(struct qed_hwfn *p_hwfn,
 		timer_res = 1;
 	else
 		timer_res = 2;
-	SET_FIELD(p_sb_entry->params, CAU_SB_ENTRY_TIMER_RES0, timer_res);
+
+	SET_FIELD(params, CAU_SB_ENTRY_TIMER_RES0, timer_res);
 
 	if (cdev->tx_coalesce_usecs <= 0x7F)
 		timer_res = 0;
@@ -1450,10 +1450,13 @@ void qed_init_cau_sb_entry(struct qed_hwfn *p_hwfn,
 		timer_res = 1;
 	else
 		timer_res = 2;
-	SET_FIELD(p_sb_entry->params, CAU_SB_ENTRY_TIMER_RES1, timer_res);
 
-	SET_FIELD(p_sb_entry->data, CAU_SB_ENTRY_STATE0, cau_state);
-	SET_FIELD(p_sb_entry->data, CAU_SB_ENTRY_STATE1, cau_state);
+	SET_FIELD(params, CAU_SB_ENTRY_TIMER_RES1, timer_res);
+	p_sb_entry->params = cpu_to_le32(params);
+
+	SET_FIELD(data, CAU_SB_ENTRY_STATE0, cau_state);
+	SET_FIELD(data, CAU_SB_ENTRY_STATE1, cau_state);
+	p_sb_entry->data = cpu_to_le32(data);
 }
 
 static void qed_int_cau_conf_pi(struct qed_hwfn *p_hwfn,
@@ -1463,31 +1466,27 @@ static void qed_int_cau_conf_pi(struct qed_hwfn *p_hwfn,
 				enum qed_coalescing_fsm coalescing_fsm,
 				u8 timeset)
 {
-	struct cau_pi_entry pi_entry;
 	u32 sb_offset, pi_offset;
+	u32 prod = 0;
 
 	if (IS_VF(p_hwfn->cdev))
 		return;
 
-	sb_offset = igu_sb_id * PIS_PER_SB_E4;
-	memset(&pi_entry, 0, sizeof(struct cau_pi_entry));
-
-	SET_FIELD(pi_entry.prod, CAU_PI_ENTRY_PI_TIMESET, timeset);
+	SET_FIELD(prod, CAU_PI_ENTRY_PI_TIMESET, timeset);
 	if (coalescing_fsm == QED_COAL_RX_STATE_MACHINE)
-		SET_FIELD(pi_entry.prod, CAU_PI_ENTRY_FSM_SEL, 0);
+		SET_FIELD(prod, CAU_PI_ENTRY_FSM_SEL, 0);
 	else
-		SET_FIELD(pi_entry.prod, CAU_PI_ENTRY_FSM_SEL, 1);
+		SET_FIELD(prod, CAU_PI_ENTRY_FSM_SEL, 1);
 
+	sb_offset = igu_sb_id * PIS_PER_SB_E4;
 	pi_offset = sb_offset + pi_index;
-	if (p_hwfn->hw_init_done) {
+
+	if (p_hwfn->hw_init_done)
 		qed_wr(p_hwfn, p_ptt,
-		       CAU_REG_PI_MEMORY + pi_offset * sizeof(u32),
-		       *((u32 *)&(pi_entry)));
-	} else {
-		STORE_RT_REG(p_hwfn,
-			     CAU_REG_PI_MEMORY_RT_OFFSET + pi_offset,
-			     *((u32 *)&(pi_entry)));
-	}
+		       CAU_REG_PI_MEMORY + pi_offset * sizeof(u32), prod);
+	else
+		STORE_RT_REG(p_hwfn, CAU_REG_PI_MEMORY_RT_OFFSET + pi_offset,
+			     prod);
 }
 
 void qed_int_cau_conf_sb(struct qed_hwfn *p_hwfn,
@@ -2356,6 +2355,7 @@ int qed_int_set_timer_res(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 			  u8 timer_res, u16 sb_id, bool tx)
 {
 	struct cau_sb_entry sb_entry;
+	u32 params;
 	int rc;
 
 	if (!p_hwfn->hw_init_done) {
@@ -2371,10 +2371,14 @@ int qed_int_set_timer_res(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 		return rc;
 	}
 
+	params = le32_to_cpu(sb_entry.params);
+
 	if (tx)
-		SET_FIELD(sb_entry.params, CAU_SB_ENTRY_TIMER_RES1, timer_res);
+		SET_FIELD(params, CAU_SB_ENTRY_TIMER_RES1, timer_res);
 	else
-		SET_FIELD(sb_entry.params, CAU_SB_ENTRY_TIMER_RES0, timer_res);
+		SET_FIELD(params, CAU_SB_ENTRY_TIMER_RES0, timer_res);
+
+	sb_entry.params = cpu_to_le32(params);
 
 	rc = qed_dmae_host2grc(p_hwfn, p_ptt,
 			       (u64)(uintptr_t)&sb_entry,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index 8abb31b63e4e..25d2c882d7ac 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -118,7 +118,7 @@ struct qed_iscsi_conn {
 };
 
 static int qed_iscsi_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
-				 u16 echo, union event_ring_data *data,
+				 __le16 echo, union event_ring_data *data,
 				 u8 fw_return_code)
 {
 	if (p_hwfn->p_iscsi_info->event_cb) {
@@ -270,6 +270,7 @@ static int qed_sp_iscsi_conn_offload(struct qed_hwfn *p_hwfn,
 	dma_addr_t xhq_pbl_addr;
 	dma_addr_t uhq_pbl_addr;
 	u16 physical_q;
+	__le16 tmp;
 	int rc = 0;
 	u32 dval;
 	u16 wval;
@@ -293,12 +294,12 @@ static int qed_sp_iscsi_conn_offload(struct qed_hwfn *p_hwfn,
 
 	/* Transmission PQ is the first of the PF */
 	physical_q = qed_get_cm_pq_idx(p_hwfn, PQ_FLAGS_OFLD);
-	p_conn->physical_q0 = cpu_to_le16(physical_q);
+	p_conn->physical_q0 = physical_q;
 	p_ramrod->iscsi.physical_q0 = cpu_to_le16(physical_q);
 
 	/* iSCSI Pure-ACK PQ */
 	physical_q = qed_get_cm_pq_idx(p_hwfn, PQ_FLAGS_ACK);
-	p_conn->physical_q1 = cpu_to_le16(physical_q);
+	p_conn->physical_q1 = physical_q;
 	p_ramrod->iscsi.physical_q1 = cpu_to_le16(physical_q);
 
 	p_ramrod->conn_id = cpu_to_le16(p_conn->conn_id);
@@ -324,14 +325,20 @@ static int qed_sp_iscsi_conn_offload(struct qed_hwfn *p_hwfn,
 		p_tcp = &p_ramrod->tcp;
 
 		p = (u16 *)p_conn->local_mac;
-		p_tcp->local_mac_addr_hi = swab16(get_unaligned(p));
-		p_tcp->local_mac_addr_mid = swab16(get_unaligned(p + 1));
-		p_tcp->local_mac_addr_lo = swab16(get_unaligned(p + 2));
+		tmp = cpu_to_le16(get_unaligned_be16(p));
+		p_tcp->local_mac_addr_hi = tmp;
+		tmp = cpu_to_le16(get_unaligned_be16(p + 1));
+		p_tcp->local_mac_addr_mid = tmp;
+		tmp = cpu_to_le16(get_unaligned_be16(p + 2));
+		p_tcp->local_mac_addr_lo = tmp;
 
 		p = (u16 *)p_conn->remote_mac;
-		p_tcp->remote_mac_addr_hi = swab16(get_unaligned(p));
-		p_tcp->remote_mac_addr_mid = swab16(get_unaligned(p + 1));
-		p_tcp->remote_mac_addr_lo = swab16(get_unaligned(p + 2));
+		tmp = cpu_to_le16(get_unaligned_be16(p));
+		p_tcp->remote_mac_addr_hi = tmp;
+		tmp = cpu_to_le16(get_unaligned_be16(p + 1));
+		p_tcp->remote_mac_addr_mid = tmp;
+		tmp = cpu_to_le16(get_unaligned_be16(p + 2));
+		p_tcp->remote_mac_addr_lo = tmp;
 
 		p_tcp->vlan_id = cpu_to_le16(p_conn->vlan_id);
 
@@ -390,14 +397,20 @@ static int qed_sp_iscsi_conn_offload(struct qed_hwfn *p_hwfn,
 		    &((struct iscsi_spe_conn_offload_option2 *)p_ramrod)->tcp;
 
 		p = (u16 *)p_conn->local_mac;
-		p_tcp2->local_mac_addr_hi = swab16(get_unaligned(p));
-		p_tcp2->local_mac_addr_mid = swab16(get_unaligned(p + 1));
-		p_tcp2->local_mac_addr_lo = swab16(get_unaligned(p + 2));
+		tmp = cpu_to_le16(get_unaligned_be16(p));
+		p_tcp2->local_mac_addr_hi = tmp;
+		tmp = cpu_to_le16(get_unaligned_be16(p + 1));
+		p_tcp2->local_mac_addr_mid = tmp;
+		tmp = cpu_to_le16(get_unaligned_be16(p + 2));
+		p_tcp2->local_mac_addr_lo = tmp;
 
 		p = (u16 *)p_conn->remote_mac;
-		p_tcp2->remote_mac_addr_hi = swab16(get_unaligned(p));
-		p_tcp2->remote_mac_addr_mid = swab16(get_unaligned(p + 1));
-		p_tcp2->remote_mac_addr_lo = swab16(get_unaligned(p + 2));
+		tmp = cpu_to_le16(get_unaligned_be16(p));
+		p_tcp2->remote_mac_addr_hi = tmp;
+		tmp = cpu_to_le16(get_unaligned_be16(p + 1));
+		p_tcp2->remote_mac_addr_mid = tmp;
+		tmp = cpu_to_le16(get_unaligned_be16(p + 2));
+		p_tcp2->remote_mac_addr_lo = tmp;
 
 		p_tcp2->vlan_id = cpu_to_le16(p_conn->vlan_id);
 		p_tcp2->flags = cpu_to_le16(p_conn->tcp_flags);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 55e73a842507..512cbef24097 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -60,7 +60,7 @@ struct mpa_v2_hdr {
 #define QED_IWARP_DEF_KA_INTERVAL	(1000)		/* 1 sec */
 
 static int qed_iwarp_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
-				 u16 echo, union event_ring_data *data,
+				 __le16 echo, union event_ring_data *data,
 				 u8 fw_return_code);
 
 /* Override devinfo with iWARP specific values */
@@ -246,14 +246,14 @@ int qed_iwarp_create_qp(struct qed_hwfn *p_hwfn,
 	SET_FIELD(p_ramrod->flags,
 		  IWARP_CREATE_QP_RAMROD_DATA_SRQ_FLG, qp->use_srq);
 
-	p_ramrod->pd = qp->pd;
-	p_ramrod->sq_num_pages = qp->sq_num_pages;
-	p_ramrod->rq_num_pages = qp->rq_num_pages;
+	p_ramrod->pd = cpu_to_le16(qp->pd);
+	p_ramrod->sq_num_pages = cpu_to_le16(qp->sq_num_pages);
+	p_ramrod->rq_num_pages = cpu_to_le16(qp->rq_num_pages);
 
 	p_ramrod->srq_id.srq_idx = cpu_to_le16(qp->srq_id);
 	p_ramrod->srq_id.opaque_fid = cpu_to_le16(p_hwfn->hw_info.opaque_fid);
-	p_ramrod->qp_handle_for_cqe.hi = cpu_to_le32(qp->qp_handle.hi);
-	p_ramrod->qp_handle_for_cqe.lo = cpu_to_le32(qp->qp_handle.lo);
+	p_ramrod->qp_handle_for_cqe.hi = qp->qp_handle.hi;
+	p_ramrod->qp_handle_for_cqe.lo = qp->qp_handle.lo;
 
 	p_ramrod->cq_cid_for_sq =
 	    cpu_to_le32((p_hwfn->hw_info.opaque_fid << 16) | qp->sq_cq_id);
@@ -288,6 +288,7 @@ static int qed_iwarp_modify_fw(struct qed_hwfn *p_hwfn, struct qed_rdma_qp *qp)
 	struct iwarp_modify_qp_ramrod_data *p_ramrod;
 	struct qed_sp_init_data init_data;
 	struct qed_spq_entry *p_ent;
+	u16 flags, trans_to_state;
 	int rc;
 
 	/* Get SPQ entry */
@@ -303,12 +304,17 @@ static int qed_iwarp_modify_fw(struct qed_hwfn *p_hwfn, struct qed_rdma_qp *qp)
 		return rc;
 
 	p_ramrod = &p_ent->ramrod.iwarp_modify_qp;
-	SET_FIELD(p_ramrod->flags, IWARP_MODIFY_QP_RAMROD_DATA_STATE_TRANS_EN,
-		  0x1);
+
+	flags = le16_to_cpu(p_ramrod->flags);
+	SET_FIELD(flags, IWARP_MODIFY_QP_RAMROD_DATA_STATE_TRANS_EN, 0x1);
+	p_ramrod->flags = cpu_to_le16(flags);
+
 	if (qp->iwarp_state == QED_IWARP_QP_STATE_CLOSING)
-		p_ramrod->transition_to_state = IWARP_MODIFY_QP_STATE_CLOSING;
+		trans_to_state = IWARP_MODIFY_QP_STATE_CLOSING;
 	else
-		p_ramrod->transition_to_state = IWARP_MODIFY_QP_STATE_ERROR;
+		trans_to_state = IWARP_MODIFY_QP_STATE_ERROR;
+
+	p_ramrod->transition_to_state = cpu_to_le16(trans_to_state);
 
 	rc = qed_spq_post(p_hwfn, p_ent, NULL);
 
@@ -621,6 +627,7 @@ qed_iwarp_tcp_offload(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 	dma_addr_t async_output_phys;
 	dma_addr_t in_pdata_phys;
 	u16 physical_q;
+	u16 flags = 0;
 	u8 tcp_flags;
 	int rc;
 	int i;
@@ -673,13 +680,14 @@ qed_iwarp_tcp_offload(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 	tcp->vlan_id = cpu_to_le16(ep->cm_info.vlan);
 
 	tcp_flags = p_hwfn->p_rdma_info->iwarp.tcp_flags;
-	tcp->flags = 0;
-	SET_FIELD(tcp->flags, TCP_OFFLOAD_PARAMS_OPT2_TS_EN,
+
+	SET_FIELD(flags, TCP_OFFLOAD_PARAMS_OPT2_TS_EN,
 		  !!(tcp_flags & QED_IWARP_TS_EN));
 
-	SET_FIELD(tcp->flags, TCP_OFFLOAD_PARAMS_OPT2_DA_EN,
+	SET_FIELD(flags, TCP_OFFLOAD_PARAMS_OPT2_DA_EN,
 		  !!(tcp_flags & QED_IWARP_DA_EN));
 
+	tcp->flags = cpu_to_le16(flags);
 	tcp->ip_version = ep->cm_info.ip_version;
 
 	for (i = 0; i < 4; i++) {
@@ -695,10 +703,10 @@ qed_iwarp_tcp_offload(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 	tcp->tos_or_tc = 0;
 
 	tcp->max_rt_time = QED_IWARP_DEF_MAX_RT_TIME;
-	tcp->cwnd = QED_IWARP_DEF_CWND_FACTOR *  tcp->mss;
+	tcp->cwnd = cpu_to_le32(QED_IWARP_DEF_CWND_FACTOR * ep->mss);
 	tcp->ka_max_probe_cnt = QED_IWARP_DEF_KA_MAX_PROBE_CNT;
-	tcp->ka_timeout = QED_IWARP_DEF_KA_TIMEOUT;
-	tcp->ka_interval = QED_IWARP_DEF_KA_INTERVAL;
+	tcp->ka_timeout = cpu_to_le32(QED_IWARP_DEF_KA_TIMEOUT);
+	tcp->ka_interval = cpu_to_le32(QED_IWARP_DEF_KA_INTERVAL);
 
 	tcp->rcv_wnd_scale = (u8)p_hwfn->p_rdma_info->iwarp.rcv_wnd_scale;
 	tcp->connect_mode = ep->connect_mode;
@@ -729,6 +737,7 @@ qed_iwarp_mpa_received(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 	union async_output *async_data;
 	u16 mpa_ord, mpa_ird;
 	u8 mpa_hdr_size = 0;
+	u16 ulp_data_len;
 	u8 mpa_rev;
 
 	async_data = &ep->ep_buffer_virt->async_output;
@@ -792,8 +801,8 @@ qed_iwarp_mpa_received(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 	/* Strip mpa v2 hdr from private data before sending to upper layer */
 	ep->cm_info.private_data = ep->ep_buffer_virt->in_pdata + mpa_hdr_size;
 
-	ep->cm_info.private_data_len = async_data->mpa_request.ulp_data_len -
-				       mpa_hdr_size;
+	ulp_data_len = le16_to_cpu(async_data->mpa_request.ulp_data_len);
+	ep->cm_info.private_data_len = ulp_data_len - mpa_hdr_size;
 
 	params.event = QED_IWARP_EVENT_MPA_REQUEST;
 	params.cm_info = &ep->cm_info;
@@ -817,6 +826,7 @@ qed_iwarp_mpa_offload(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 	dma_addr_t in_pdata_phys;
 	struct qed_rdma_qp *qp;
 	bool reject;
+	u32 val;
 	int rc;
 
 	if (!ep)
@@ -847,13 +857,15 @@ qed_iwarp_mpa_offload(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 			 offsetof(struct qed_iwarp_ep_memory, out_pdata);
 	DMA_REGPAIR_LE(common->outgoing_ulp_buffer.addr, out_pdata_phys);
 
-	common->outgoing_ulp_buffer.len = ep->cm_info.private_data_len;
+	val = ep->cm_info.private_data_len;
+	common->outgoing_ulp_buffer.len = cpu_to_le16(val);
 	common->crc_needed = p_hwfn->p_rdma_info->iwarp.crc_needed;
 
-	common->out_rq.ord = ep->cm_info.ord;
-	common->out_rq.ird = ep->cm_info.ird;
+	common->out_rq.ord = cpu_to_le32(ep->cm_info.ord);
+	common->out_rq.ird = cpu_to_le32(ep->cm_info.ird);
 
-	p_mpa_ramrod->tcp_cid = p_hwfn->hw_info.opaque_fid << 16 | ep->tcp_cid;
+	val = p_hwfn->hw_info.opaque_fid << 16 | ep->tcp_cid;
+	p_mpa_ramrod->tcp_cid = cpu_to_le32(val);
 
 	in_pdata_phys = ep->ep_buffer_phys +
 			offsetof(struct qed_iwarp_ep_memory, in_pdata);
@@ -879,7 +891,7 @@ qed_iwarp_mpa_offload(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 	}
 
 	iwarp_info = &p_hwfn->p_rdma_info->iwarp;
-	p_mpa_ramrod->rcv_wnd = iwarp_info->rcv_wnd_size;
+	p_mpa_ramrod->rcv_wnd = cpu_to_le16(iwarp_info->rcv_wnd_size);
 	p_mpa_ramrod->mode = ep->mpa_rev;
 	SET_FIELD(p_mpa_ramrod->rtr_pref,
 		  IWARP_MPA_OFFLOAD_RAMROD_DATA_RTR_SUPPORTED, ep->rtr_type);
@@ -930,6 +942,7 @@ qed_iwarp_parse_private_data(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 	union async_output *async_data;
 	u16 mpa_ird, mpa_ord;
 	u8 mpa_data_size = 0;
+	u16 ulp_data_len;
 
 	if (MPA_REV2(p_hwfn->p_rdma_info->iwarp.mpa_rev)) {
 		mpa_v2_params =
@@ -941,11 +954,12 @@ qed_iwarp_parse_private_data(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 		ep->cm_info.ird = (u8)(mpa_ord & MPA_V2_IRD_ORD_MASK);
 		ep->cm_info.ord = (u8)(mpa_ird & MPA_V2_IRD_ORD_MASK);
 	}
-	async_data = &ep->ep_buffer_virt->async_output;
 
+	async_data = &ep->ep_buffer_virt->async_output;
 	ep->cm_info.private_data = ep->ep_buffer_virt->in_pdata + mpa_data_size;
-	ep->cm_info.private_data_len = async_data->mpa_response.ulp_data_len -
-				       mpa_data_size;
+
+	ulp_data_len = le16_to_cpu(async_data->mpa_response.ulp_data_len);
+	ep->cm_info.private_data_len = ulp_data_len - mpa_data_size;
 }
 
 static void
@@ -1822,7 +1836,7 @@ qed_iwarp_mpa_classify(struct qed_hwfn *p_hwfn,
 		goto out;
 	}
 
-	mpa_len = ntohs(*((u16 *)(mpa_data)));
+	mpa_len = ntohs(*(__force __be16 *)mpa_data);
 	fpdu->fpdu_length = QED_IWARP_FPDU_LEN_WITH_PAD(mpa_len);
 
 	if (fpdu->fpdu_length <= tcp_payload_len)
@@ -1844,11 +1858,13 @@ qed_iwarp_init_fpdu(struct qed_iwarp_ll2_buff *buf,
 		    struct unaligned_opaque_data *pkt_data,
 		    u16 tcp_payload_size, u8 placement_offset)
 {
+	u16 first_mpa_offset = le16_to_cpu(pkt_data->first_mpa_offset);
+
 	fpdu->mpa_buf = buf;
 	fpdu->pkt_hdr = buf->data_phys_addr + placement_offset;
 	fpdu->pkt_hdr_size = pkt_data->tcp_payload_offset;
-	fpdu->mpa_frag = buf->data_phys_addr + pkt_data->first_mpa_offset;
-	fpdu->mpa_frag_virt = (u8 *)(buf->data) + pkt_data->first_mpa_offset;
+	fpdu->mpa_frag = buf->data_phys_addr + first_mpa_offset;
+	fpdu->mpa_frag_virt = (u8 *)(buf->data) + first_mpa_offset;
 
 	if (tcp_payload_size == 1)
 		fpdu->incomplete_bytes = QED_IWARP_INVALID_FPDU_LENGTH;
@@ -1866,6 +1882,7 @@ qed_iwarp_cp_pkt(struct qed_hwfn *p_hwfn,
 		 struct unaligned_opaque_data *pkt_data,
 		 struct qed_iwarp_ll2_buff *buf, u16 tcp_payload_size)
 {
+	u16 first_mpa_offset = le16_to_cpu(pkt_data->first_mpa_offset);
 	u8 *tmp_buf = p_hwfn->p_rdma_info->iwarp.mpa_intermediate_buf;
 	int rc;
 
@@ -1886,13 +1903,11 @@ qed_iwarp_cp_pkt(struct qed_hwfn *p_hwfn,
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA,
 		   "MPA ALIGN Copying fpdu: [%p, %d] [%p, %d]\n",
 		   fpdu->mpa_frag_virt, fpdu->mpa_frag_len,
-		   (u8 *)(buf->data) + pkt_data->first_mpa_offset,
-		   tcp_payload_size);
+		   (u8 *)(buf->data) + first_mpa_offset, tcp_payload_size);
 
 	memcpy(tmp_buf, fpdu->mpa_frag_virt, fpdu->mpa_frag_len);
 	memcpy(tmp_buf + fpdu->mpa_frag_len,
-	       (u8 *)(buf->data) + pkt_data->first_mpa_offset,
-	       tcp_payload_size);
+	       (u8 *)(buf->data) + first_mpa_offset, tcp_payload_size);
 
 	rc = qed_iwarp_recycle_pkt(p_hwfn, fpdu, fpdu->mpa_buf);
 	if (rc)
@@ -2035,6 +2050,7 @@ qed_iwarp_send_fpdu(struct qed_hwfn *p_hwfn,
 		    u16 tcp_payload_size, enum qed_iwarp_mpa_pkt_type pkt_type)
 {
 	struct qed_ll2_tx_pkt_info tx_pkt;
+	u16 first_mpa_offset;
 	u8 ll2_handle;
 	int rc;
 
@@ -2086,11 +2102,13 @@ qed_iwarp_send_fpdu(struct qed_hwfn *p_hwfn,
 	if (!fpdu->incomplete_bytes)
 		goto out;
 
+	first_mpa_offset = le16_to_cpu(curr_pkt->first_mpa_offset);
+
 	/* Set third fragment to second part of the packet */
 	rc = qed_ll2_set_fragment_of_tx_packet(p_hwfn,
 					       ll2_handle,
 					       buf->data_phys_addr +
-					       curr_pkt->first_mpa_offset,
+					       first_mpa_offset,
 					       fpdu->incomplete_bytes);
 out:
 	DP_VERBOSE(p_hwfn,
@@ -2111,12 +2129,12 @@ qed_iwarp_mpa_get_data(struct qed_hwfn *p_hwfn,
 {
 	u64 opaque_data;
 
-	opaque_data = HILO_64(opaque_data1, opaque_data0);
+	opaque_data = HILO_64(cpu_to_le32(opaque_data1),
+			      cpu_to_le32(opaque_data0));
 	*curr_pkt = *((struct unaligned_opaque_data *)&opaque_data);
 
-	curr_pkt->first_mpa_offset = curr_pkt->tcp_payload_offset +
-				     le16_to_cpu(curr_pkt->first_mpa_offset);
-	curr_pkt->cid = le32_to_cpu(curr_pkt->cid);
+	le16_add_cpu(&curr_pkt->first_mpa_offset,
+		     curr_pkt->tcp_payload_offset);
 }
 
 /* This function is called when an unaligned or incomplete MPA packet arrives
@@ -2131,18 +2149,22 @@ qed_iwarp_process_mpa_pkt(struct qed_hwfn *p_hwfn,
 	struct qed_iwarp_ll2_buff *buf = mpa_buf->ll2_buf;
 	enum qed_iwarp_mpa_pkt_type pkt_type;
 	struct qed_iwarp_fpdu *fpdu;
+	u16 cid, first_mpa_offset;
 	int rc = -EINVAL;
 	u8 *mpa_data;
 
-	fpdu = qed_iwarp_get_curr_fpdu(p_hwfn, curr_pkt->cid & 0xffff);
+	cid = le32_to_cpu(curr_pkt->cid);
+
+	fpdu = qed_iwarp_get_curr_fpdu(p_hwfn, (u16)cid);
 	if (!fpdu) { /* something corrupt with cid, post rx back */
 		DP_ERR(p_hwfn, "Invalid cid, drop and post back to rx cid=%x\n",
-		       curr_pkt->cid);
+		       cid);
 		goto err;
 	}
 
 	do {
-		mpa_data = ((u8 *)(buf->data) + curr_pkt->first_mpa_offset);
+		first_mpa_offset = le16_to_cpu(curr_pkt->first_mpa_offset);
+		mpa_data = ((u8 *)(buf->data) + first_mpa_offset);
 
 		pkt_type = qed_iwarp_mpa_classify(p_hwfn, fpdu,
 						  mpa_buf->tcp_payload_len,
@@ -2188,7 +2210,8 @@ qed_iwarp_process_mpa_pkt(struct qed_hwfn *p_hwfn,
 			}
 
 			mpa_buf->tcp_payload_len -= fpdu->fpdu_length;
-			curr_pkt->first_mpa_offset += fpdu->fpdu_length;
+			le16_add_cpu(&curr_pkt->first_mpa_offset,
+				     fpdu->fpdu_length);
 			break;
 		case QED_IWARP_MPA_PKT_UNALIGNED:
 			qed_iwarp_update_fpdu_length(p_hwfn, fpdu, mpa_data);
@@ -2227,7 +2250,9 @@ qed_iwarp_process_mpa_pkt(struct qed_hwfn *p_hwfn,
 			}
 
 			mpa_buf->tcp_payload_len -= fpdu->incomplete_bytes;
-			curr_pkt->first_mpa_offset += fpdu->incomplete_bytes;
+			le16_add_cpu(&curr_pkt->first_mpa_offset,
+				     fpdu->incomplete_bytes);
+
 			/* The framed PDU was sent - no more incomplete bytes */
 			fpdu->incomplete_bytes = 0;
 			break;
@@ -2278,6 +2303,7 @@ qed_iwarp_ll2_comp_mpa_pkt(void *cxt, struct qed_ll2_comp_rx_data *data)
 	struct qed_iwarp_ll2_mpa_buf *mpa_buf;
 	struct qed_iwarp_info *iwarp_info;
 	struct qed_hwfn *p_hwfn = cxt;
+	u16 first_mpa_offset;
 
 	iwarp_info = &p_hwfn->p_rdma_info->iwarp;
 	mpa_buf = list_first_entry(&iwarp_info->mpa_buf_list,
@@ -2291,17 +2317,21 @@ qed_iwarp_ll2_comp_mpa_pkt(void *cxt, struct qed_ll2_comp_rx_data *data)
 	qed_iwarp_mpa_get_data(p_hwfn, &mpa_buf->data,
 			       data->opaque_data_0, data->opaque_data_1);
 
+	first_mpa_offset = le16_to_cpu(mpa_buf->data.first_mpa_offset);
+
 	DP_VERBOSE(p_hwfn,
 		   QED_MSG_RDMA,
 		   "LL2 MPA CompRx payload_len:0x%x\tfirst_mpa_offset:0x%x\ttcp_payload_offset:0x%x\tflags:0x%x\tcid:0x%x\n",
-		   data->length.packet_length, mpa_buf->data.first_mpa_offset,
+		   data->length.packet_length, first_mpa_offset,
 		   mpa_buf->data.tcp_payload_offset, mpa_buf->data.flags,
 		   mpa_buf->data.cid);
 
 	mpa_buf->ll2_buf = data->cookie;
 	mpa_buf->tcp_payload_len = data->length.packet_length -
-				   mpa_buf->data.first_mpa_offset;
-	mpa_buf->data.first_mpa_offset += data->u.placement_offset;
+				   first_mpa_offset;
+
+	first_mpa_offset += data->u.placement_offset;
+	mpa_buf->data.first_mpa_offset = cpu_to_le16(first_mpa_offset);
 	mpa_buf->placement_offset = data->u.placement_offset;
 
 	list_add_tail(&mpa_buf->list_entry, &iwarp_info->mpa_buf_pending_list);
@@ -2500,14 +2530,16 @@ qed_iwarp_ll2_slowpath(void *cxt,
 	struct unaligned_opaque_data unalign_data;
 	struct qed_hwfn *p_hwfn = cxt;
 	struct qed_iwarp_fpdu *fpdu;
+	u32 cid;
 
 	qed_iwarp_mpa_get_data(p_hwfn, &unalign_data,
 			       opaque_data_0, opaque_data_1);
 
-	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "(0x%x) Flush fpdu\n",
-		   unalign_data.cid);
+	cid = le32_to_cpu(unalign_data.cid);
+
+	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "(0x%x) Flush fpdu\n", cid);
 
-	fpdu = qed_iwarp_get_curr_fpdu(p_hwfn, (u16)unalign_data.cid);
+	fpdu = qed_iwarp_get_curr_fpdu(p_hwfn, (u16)cid);
 	if (fpdu)
 		memset(fpdu, 0, sizeof(*fpdu));
 }
@@ -3010,7 +3042,7 @@ qed_iwarp_check_ep_ok(struct qed_hwfn *p_hwfn, struct qed_iwarp_ep *ep)
 }
 
 static int qed_iwarp_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
-				 u16 echo, union event_ring_data *data,
+				 __le16 echo, union event_ring_data *data,
 				 u8 fw_return_code)
 {
 	struct qed_rdma_events events = p_hwfn->p_rdma_info->events;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 41afd15f4991..4c6ac8862744 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -345,8 +345,8 @@ int qed_sp_eth_vport_start(struct qed_hwfn *p_hwfn,
 	struct eth_vport_tpa_param *tpa_param;
 	struct qed_spq_entry *p_ent =  NULL;
 	struct qed_sp_init_data init_data;
+	u16 min_size, rx_mode = 0;
 	u8 abs_vport_id = 0;
-	u16 rx_mode = 0;
 	int rc;
 
 	rc = qed_fw_vport(p_hwfn, p_params->vport_id, &abs_vport_id);
@@ -386,10 +386,12 @@ int qed_sp_eth_vport_start(struct qed_hwfn *p_hwfn,
 
 	switch (p_params->tpa_mode) {
 	case QED_TPA_MODE_GRO:
+		min_size = p_params->mtu / 2;
+
 		tpa_param->tpa_max_aggs_num = ETH_TPA_MAX_AGGS_NUM;
-		tpa_param->tpa_max_size = (u16)-1;
-		tpa_param->tpa_min_size_to_cont = p_params->mtu / 2;
-		tpa_param->tpa_min_size_to_start = p_params->mtu / 2;
+		tpa_param->tpa_max_size = cpu_to_le16(U16_MAX);
+		tpa_param->tpa_min_size_to_cont = cpu_to_le16(min_size);
+		tpa_param->tpa_min_size_to_start = cpu_to_le16(min_size);
 		tpa_param->tpa_ipv4_en_flg = 1;
 		tpa_param->tpa_ipv6_en_flg = 1;
 		tpa_param->tpa_pkt_split_flg = 1;
@@ -626,9 +628,9 @@ qed_sp_vport_update_sge_tpa(struct qed_hwfn *p_hwfn,
 	tpa->tpa_hdr_data_split_flg = param->tpa_hdr_data_split_flg;
 	tpa->tpa_gro_consistent_flg = param->tpa_gro_consistent_flg;
 	tpa->tpa_max_aggs_num = param->tpa_max_aggs_num;
-	tpa->tpa_max_size = param->tpa_max_size;
-	tpa->tpa_min_size_to_start = param->tpa_min_size_to_start;
-	tpa->tpa_min_size_to_cont = param->tpa_min_size_to_cont;
+	tpa->tpa_max_size = cpu_to_le16(param->tpa_max_size);
+	tpa->tpa_min_size_to_start = cpu_to_le16(param->tpa_min_size_to_start);
+	tpa->tpa_min_size_to_cont = cpu_to_le16(param->tpa_min_size_to_cont);
 }
 
 static void
@@ -2090,7 +2092,8 @@ int qed_get_rxq_coalesce(struct qed_hwfn *p_hwfn,
 		return rc;
 	}
 
-	timer_res = GET_FIELD(sb_entry.params, CAU_SB_ENTRY_TIMER_RES0);
+	timer_res = GET_FIELD(le32_to_cpu(sb_entry.params),
+			      CAU_SB_ENTRY_TIMER_RES0);
 
 	address = BAR0_MAP_REG_USDM_RAM +
 		  USTORM_ETH_QUEUE_ZONE_OFFSET(p_cid->abs.queue_id);
@@ -2123,7 +2126,8 @@ int qed_get_txq_coalesce(struct qed_hwfn *p_hwfn,
 		return rc;
 	}
 
-	timer_res = GET_FIELD(sb_entry.params, CAU_SB_ENTRY_TIMER_RES1);
+	timer_res = GET_FIELD(le32_to_cpu(sb_entry.params),
+			      CAU_SB_ENTRY_TIMER_RES1);
 
 	address = BAR0_MAP_REG_XSDM_RAM +
 		  XSTORM_ETH_QUEUE_ZONE_OFFSET(p_cid->abs.queue_id);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index cce6fd27c042..6f4aec339cd4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -1798,6 +1798,7 @@ qed_ll2_prepare_tx_packet_set_bd(struct qed_hwfn *p_hwfn,
 	enum core_roce_flavor_type roce_flavor;
 	enum core_tx_dest tx_dest;
 	u16 bd_data = 0, frag_idx;
+	u16 bitfield1;
 
 	roce_flavor = (pkt->qed_roce_flavor == QED_LL2_ROCE) ? CORE_ROCE
 							     : CORE_RROCE;
@@ -1829,9 +1830,11 @@ qed_ll2_prepare_tx_packet_set_bd(struct qed_hwfn *p_hwfn,
 			pkt->remove_stag = true;
 	}
 
-	SET_FIELD(start_bd->bitfield1, CORE_TX_BD_L4_HDR_OFFSET_W,
-		  cpu_to_le16(pkt->l4_hdr_offset_w));
-	SET_FIELD(start_bd->bitfield1, CORE_TX_BD_TX_DST, tx_dest);
+	bitfield1 = le16_to_cpu(start_bd->bitfield1);
+	SET_FIELD(bitfield1, CORE_TX_BD_L4_HDR_OFFSET_W, pkt->l4_hdr_offset_w);
+	SET_FIELD(bitfield1, CORE_TX_BD_TX_DST, tx_dest);
+	start_bd->bitfield1 = cpu_to_le16(bitfield1);
+
 	bd_data |= pkt->bd_flags;
 	SET_FIELD(bd_data, CORE_TX_BD_DATA_START_BD, 0x1);
 	SET_FIELD(bd_data, CORE_TX_BD_DATA_NBDS, pkt->num_of_bds);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 236013da9453..4c5f5bd91359 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1962,8 +1962,7 @@ static u32 qed_nvm_flash_image_access_crc(struct qed_dev *cdev,
 					  u32 *crc)
 {
 	u8 *buf = NULL;
-	int rc, j;
-	u32 val;
+	int rc;
 
 	/* Allocate a buffer for holding the nvram image */
 	buf = kzalloc(nvm_image->length, GFP_KERNEL);
@@ -1981,15 +1980,14 @@ static u32 qed_nvm_flash_image_access_crc(struct qed_dev *cdev,
 	/* Convert the buffer into big-endian format (excluding the
 	 * closing 4 bytes of CRC).
 	 */
-	for (j = 0; j < nvm_image->length - 4; j += 4) {
-		val = cpu_to_be32(*(u32 *)&buf[j]);
-		*(u32 *)&buf[j] = val;
-	}
+	cpu_to_be32_array((__force __be32 *)buf, (const u32 *)buf,
+			  DIV_ROUND_UP(nvm_image->length - 4, 4));
 
 	/* Calc CRC for the "actual" image buffer, i.e. not including
 	 * the last 4 CRC bytes.
 	 */
-	*crc = (~cpu_to_be32(crc32(0xffffffff, buf, nvm_image->length - 4)));
+	*crc = ~crc32(~0U, buf, nvm_image->length - 4);
+	*crc = (__force u32)cpu_to_be32p(crc);
 
 out:
 	kfree(buf);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
index 1dd01e0373ab..3e3192a3ad9b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
@@ -1276,7 +1276,7 @@ int qed_mfw_process_tlv_req(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	 */
 	for (offset = 0; offset < size; offset += sizeof(u32)) {
 		val = qed_rd(p_hwfn, p_ptt, addr + offset);
-		val = be32_to_cpu(val);
+		val = be32_to_cpu((__force __be32)val);
 		memcpy(&p_mfw_buf[offset], &val, sizeof(u32));
 	}
 
@@ -1325,7 +1325,7 @@ int qed_mfw_process_tlv_req(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	 */
 	for (offset = 0; offset < size; offset += sizeof(u32)) {
 		memcpy(&val, &p_mfw_buf[offset], sizeof(u32));
-		val = cpu_to_be32(val);
+		val = (__force u32)cpu_to_be32(val);
 		qed_wr(p_hwfn, p_ptt, addr + offset, val);
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 59d916693654..e5648ca2838b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1106,7 +1106,7 @@ static int qed_rdma_create_cq(void *rdma_cxt,
 	p_ramrod->pbl_num_pages = cpu_to_le16(params->pbl_num_pages);
 	p_ramrod->cnq_id = (u8)RESC_START(p_hwfn, QED_RDMA_CNQ_RAM) +
 			   params->cnq_id;
-	p_ramrod->int_timeout = params->int_timeout;
+	p_ramrod->int_timeout = cpu_to_le16(params->int_timeout);
 
 	/* toggle the bit for every resize or create cq for a given icid */
 	toggle_bit = qed_rdma_toggle_bit_create_resize_cq(p_hwfn, *icid);
@@ -1206,7 +1206,7 @@ err:	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
 	return rc;
 }
 
-void qed_rdma_set_fw_mac(u16 *p_fw_mac, u8 *p_qed_mac)
+void qed_rdma_set_fw_mac(__le16 *p_fw_mac, const u8 *p_qed_mac)
 {
 	p_fw_mac[0] = cpu_to_le16((p_qed_mac[0] << 8) + p_qed_mac[1]);
 	p_fw_mac[1] = cpu_to_le16((p_qed_mac[2] << 8) + p_qed_mac[3]);
@@ -1495,6 +1495,7 @@ qed_rdma_register_tid(void *rdma_cxt,
 	struct qed_spq_entry *p_ent;
 	enum rdma_tid_type tid_type;
 	u8 fw_return_code;
+	u16 flags = 0;
 	int rc;
 
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "itid = %08x\n", params->itid);
@@ -1514,54 +1515,46 @@ qed_rdma_register_tid(void *rdma_cxt,
 	if (p_hwfn->p_rdma_info->last_tid < params->itid)
 		p_hwfn->p_rdma_info->last_tid = params->itid;
 
-	p_ramrod = &p_ent->ramrod.rdma_register_tid;
-
-	p_ramrod->flags = 0;
-	SET_FIELD(p_ramrod->flags,
-		  RDMA_REGISTER_TID_RAMROD_DATA_TWO_LEVEL_PBL,
+	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_TWO_LEVEL_PBL,
 		  params->pbl_two_level);
 
-	SET_FIELD(p_ramrod->flags,
-		  RDMA_REGISTER_TID_RAMROD_DATA_ZERO_BASED, params->zbva);
+	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_ZERO_BASED,
+		  params->zbva);
 
-	SET_FIELD(p_ramrod->flags,
-		  RDMA_REGISTER_TID_RAMROD_DATA_PHY_MR, params->phy_mr);
+	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_PHY_MR, params->phy_mr);
 
 	/* Don't initialize D/C field, as it may override other bits. */
 	if (!(params->tid_type == QED_RDMA_TID_FMR) && !(params->dma_mr))
-		SET_FIELD(p_ramrod->flags,
-			  RDMA_REGISTER_TID_RAMROD_DATA_PAGE_SIZE_LOG,
+		SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_PAGE_SIZE_LOG,
 			  params->page_size_log - 12);
 
-	SET_FIELD(p_ramrod->flags,
-		  RDMA_REGISTER_TID_RAMROD_DATA_REMOTE_READ,
+	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_REMOTE_READ,
 		  params->remote_read);
 
-	SET_FIELD(p_ramrod->flags,
-		  RDMA_REGISTER_TID_RAMROD_DATA_REMOTE_WRITE,
+	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_REMOTE_WRITE,
 		  params->remote_write);
 
-	SET_FIELD(p_ramrod->flags,
-		  RDMA_REGISTER_TID_RAMROD_DATA_REMOTE_ATOMIC,
+	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_REMOTE_ATOMIC,
 		  params->remote_atomic);
 
-	SET_FIELD(p_ramrod->flags,
-		  RDMA_REGISTER_TID_RAMROD_DATA_LOCAL_WRITE,
+	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_LOCAL_WRITE,
 		  params->local_write);
 
-	SET_FIELD(p_ramrod->flags,
-		  RDMA_REGISTER_TID_RAMROD_DATA_LOCAL_READ, params->local_read);
+	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_LOCAL_READ,
+		  params->local_read);
 
-	SET_FIELD(p_ramrod->flags,
-		  RDMA_REGISTER_TID_RAMROD_DATA_ENABLE_MW_BIND,
+	SET_FIELD(flags, RDMA_REGISTER_TID_RAMROD_DATA_ENABLE_MW_BIND,
 		  params->mw_bind);
 
+	p_ramrod = &p_ent->ramrod.rdma_register_tid;
+	p_ramrod->flags = cpu_to_le16(flags);
+
 	SET_FIELD(p_ramrod->flags1,
 		  RDMA_REGISTER_TID_RAMROD_DATA_PBL_PAGE_SIZE_LOG,
 		  params->pbl_page_size_log - 12);
 
-	SET_FIELD(p_ramrod->flags2,
-		  RDMA_REGISTER_TID_RAMROD_DATA_DMA_MR, params->dma_mr);
+	SET_FIELD(p_ramrod->flags2, RDMA_REGISTER_TID_RAMROD_DATA_DMA_MR,
+		  params->dma_mr);
 
 	switch (params->tid_type) {
 	case QED_RDMA_TID_REGISTERED_MR:
@@ -1579,8 +1572,9 @@ qed_rdma_register_tid(void *rdma_cxt,
 		qed_sp_destroy_request(p_hwfn, p_ent);
 		return rc;
 	}
-	SET_FIELD(p_ramrod->flags1,
-		  RDMA_REGISTER_TID_RAMROD_DATA_TID_TYPE, tid_type);
+
+	SET_FIELD(p_ramrod->flags1, RDMA_REGISTER_TID_RAMROD_DATA_TID_TYPE,
+		  tid_type);
 
 	p_ramrod->itid = cpu_to_le32(params->itid);
 	p_ramrod->key = params->key;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.h b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
index fba43adbb68e..6a1de3a25257 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
@@ -201,7 +201,7 @@ qed_bmap_release_id(struct qed_hwfn *p_hwfn, struct qed_bmap *bmap, u32 id_num);
 int
 qed_bmap_test_id(struct qed_hwfn *p_hwfn, struct qed_bmap *bmap, u32 id_num);
 
-void qed_rdma_set_fw_mac(u16 *p_fw_mac, u8 *p_qed_mac);
+void qed_rdma_set_fw_mac(__le16 *p_fw_mac, const u8 *p_qed_mac);
 
 bool qed_rdma_allocated_qps(struct qed_hwfn *p_hwfn);
 #endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index 5433e43a1930..a1423ec0edf7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -38,7 +38,7 @@
 static void qed_roce_free_real_icid(struct qed_hwfn *p_hwfn, u16 icid);
 
 static int qed_roce_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
-				u16 echo, union event_ring_data *data,
+				__le16 echo, union event_ring_data *data,
 				u8 fw_return_code)
 {
 	struct qed_rdma_events events = p_hwfn->p_rdma_info->events;
@@ -54,7 +54,7 @@ static int qed_roce_async_event(struct qed_hwfn *p_hwfn, u8 fw_event_code,
 		qed_roce_free_real_icid(p_hwfn, icid);
 	} else if (fw_event_code == ROCE_ASYNC_EVENT_SRQ_EMPTY ||
 		   fw_event_code == ROCE_ASYNC_EVENT_SRQ_LIMIT) {
-		u16 srq_id = (u16)rdata->async_handle.lo;
+		u16 srq_id = (u16)le32_to_cpu(rdata->async_handle.lo);
 
 		events.affiliated_event(events.context, fw_event_code,
 					&srq_id);
@@ -217,9 +217,9 @@ static int qed_roce_sp_create_responder(struct qed_hwfn *p_hwfn,
 	struct roce_create_qp_resp_ramrod_data *p_ramrod;
 	u16 regular_latency_queue, low_latency_queue;
 	struct qed_sp_init_data init_data;
-	enum roce_flavor roce_flavor;
 	struct qed_spq_entry *p_ent;
 	enum protocol_type proto;
+	u32 flags = 0;
 	int rc;
 	u8 tc;
 
@@ -252,45 +252,34 @@ static int qed_roce_sp_create_responder(struct qed_hwfn *p_hwfn,
 	if (rc)
 		goto err;
 
-	p_ramrod = &p_ent->ramrod.roce_create_qp_resp;
-
-	p_ramrod->flags = 0;
-
-	roce_flavor = qed_roce_mode_to_flavor(qp->roce_mode);
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_RESP_RAMROD_DATA_ROCE_FLAVOR, roce_flavor);
+	SET_FIELD(flags, ROCE_CREATE_QP_RESP_RAMROD_DATA_ROCE_FLAVOR,
+		  qed_roce_mode_to_flavor(qp->roce_mode));
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_RESP_RAMROD_DATA_RDMA_RD_EN,
+	SET_FIELD(flags, ROCE_CREATE_QP_RESP_RAMROD_DATA_RDMA_RD_EN,
 		  qp->incoming_rdma_read_en);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_RESP_RAMROD_DATA_RDMA_WR_EN,
+	SET_FIELD(flags, ROCE_CREATE_QP_RESP_RAMROD_DATA_RDMA_WR_EN,
 		  qp->incoming_rdma_write_en);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_RESP_RAMROD_DATA_ATOMIC_EN,
+	SET_FIELD(flags, ROCE_CREATE_QP_RESP_RAMROD_DATA_ATOMIC_EN,
 		  qp->incoming_atomic_en);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_RESP_RAMROD_DATA_E2E_FLOW_CONTROL_EN,
+	SET_FIELD(flags, ROCE_CREATE_QP_RESP_RAMROD_DATA_E2E_FLOW_CONTROL_EN,
 		  qp->e2e_flow_control_en);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_RESP_RAMROD_DATA_SRQ_FLG, qp->use_srq);
+	SET_FIELD(flags, ROCE_CREATE_QP_RESP_RAMROD_DATA_SRQ_FLG, qp->use_srq);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_RESP_RAMROD_DATA_RESERVED_KEY_EN,
+	SET_FIELD(flags, ROCE_CREATE_QP_RESP_RAMROD_DATA_RESERVED_KEY_EN,
 		  qp->fmr_and_reserved_lkey);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_RESP_RAMROD_DATA_MIN_RNR_NAK_TIMER,
+	SET_FIELD(flags, ROCE_CREATE_QP_RESP_RAMROD_DATA_MIN_RNR_NAK_TIMER,
 		  qp->min_rnr_nak_timer);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_RESP_RAMROD_DATA_XRC_FLAG,
+	SET_FIELD(flags, ROCE_CREATE_QP_RESP_RAMROD_DATA_XRC_FLAG,
 		  qed_rdma_is_xrc_qp(qp));
 
+	p_ramrod = &p_ent->ramrod.roce_create_qp_resp;
+	p_ramrod->flags = cpu_to_le32(flags);
 	p_ramrod->max_ird = qp->max_rd_atomic_resp;
 	p_ramrod->traffic_class = qp->traffic_class_tos;
 	p_ramrod->hop_limit = qp->hop_limit_ttl;
@@ -305,10 +294,10 @@ static int qed_roce_sp_create_responder(struct qed_hwfn *p_hwfn,
 	DMA_REGPAIR_LE(p_ramrod->rq_pbl_addr, qp->rq_pbl_ptr);
 	DMA_REGPAIR_LE(p_ramrod->irq_pbl_addr, qp->irq_phys_addr);
 	qed_rdma_copy_gids(qp, p_ramrod->src_gid, p_ramrod->dst_gid);
-	p_ramrod->qp_handle_for_async.hi = cpu_to_le32(qp->qp_handle_async.hi);
-	p_ramrod->qp_handle_for_async.lo = cpu_to_le32(qp->qp_handle_async.lo);
-	p_ramrod->qp_handle_for_cqe.hi = cpu_to_le32(qp->qp_handle.hi);
-	p_ramrod->qp_handle_for_cqe.lo = cpu_to_le32(qp->qp_handle.lo);
+	p_ramrod->qp_handle_for_async.hi = qp->qp_handle_async.hi;
+	p_ramrod->qp_handle_for_async.lo = qp->qp_handle_async.lo;
+	p_ramrod->qp_handle_for_cqe.hi = qp->qp_handle.hi;
+	p_ramrod->qp_handle_for_cqe.lo = qp->qp_handle.lo;
 	p_ramrod->cq_cid = cpu_to_le32((p_hwfn->hw_info.opaque_fid << 16) |
 				       qp->rq_cq_id);
 	p_ramrod->xrc_domain = cpu_to_le16(qp->xrcd_id);
@@ -330,7 +319,7 @@ static int qed_roce_sp_create_responder(struct qed_hwfn *p_hwfn,
 	qed_rdma_set_fw_mac(p_ramrod->remote_mac_addr, qp->remote_mac_addr);
 	qed_rdma_set_fw_mac(p_ramrod->local_mac_addr, qp->local_mac_addr);
 
-	p_ramrod->udp_src_port = qp->udp_src_port;
+	p_ramrod->udp_src_port = cpu_to_le16(qp->udp_src_port);
 	p_ramrod->vlan_id = cpu_to_le16(qp->vlan_id);
 	p_ramrod->srq_id.srq_idx = cpu_to_le16(qp->srq_id);
 	p_ramrod->srq_id.opaque_fid = cpu_to_le16(p_hwfn->hw_info.opaque_fid);
@@ -366,9 +355,9 @@ static int qed_roce_sp_create_requester(struct qed_hwfn *p_hwfn,
 	struct roce_create_qp_req_ramrod_data *p_ramrod;
 	u16 regular_latency_queue, low_latency_queue;
 	struct qed_sp_init_data init_data;
-	enum roce_flavor roce_flavor;
 	struct qed_spq_entry *p_ent;
 	enum protocol_type proto;
+	u16 flags = 0;
 	int rc;
 	u8 tc;
 
@@ -402,34 +391,29 @@ static int qed_roce_sp_create_requester(struct qed_hwfn *p_hwfn,
 	if (rc)
 		goto err;
 
-	p_ramrod = &p_ent->ramrod.roce_create_qp_req;
-
-	p_ramrod->flags = 0;
+	SET_FIELD(flags, ROCE_CREATE_QP_REQ_RAMROD_DATA_ROCE_FLAVOR,
+		  qed_roce_mode_to_flavor(qp->roce_mode));
 
-	roce_flavor = qed_roce_mode_to_flavor(qp->roce_mode);
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_REQ_RAMROD_DATA_ROCE_FLAVOR, roce_flavor);
-
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_REQ_RAMROD_DATA_FMR_AND_RESERVED_EN,
+	SET_FIELD(flags, ROCE_CREATE_QP_REQ_RAMROD_DATA_FMR_AND_RESERVED_EN,
 		  qp->fmr_and_reserved_lkey);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_REQ_RAMROD_DATA_SIGNALED_COMP, qp->signal_all);
+	SET_FIELD(flags, ROCE_CREATE_QP_REQ_RAMROD_DATA_SIGNALED_COMP,
+		  qp->signal_all);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_REQ_RAMROD_DATA_ERR_RETRY_CNT, qp->retry_cnt);
+	SET_FIELD(flags, ROCE_CREATE_QP_REQ_RAMROD_DATA_ERR_RETRY_CNT,
+		  qp->retry_cnt);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_REQ_RAMROD_DATA_RNR_NAK_CNT,
+	SET_FIELD(flags, ROCE_CREATE_QP_REQ_RAMROD_DATA_RNR_NAK_CNT,
 		  qp->rnr_retry_cnt);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_REQ_RAMROD_DATA_XRC_FLAG,
+	SET_FIELD(flags, ROCE_CREATE_QP_REQ_RAMROD_DATA_XRC_FLAG,
 		  qed_rdma_is_xrc_qp(qp));
 
-	SET_FIELD(p_ramrod->flags2,
-		  ROCE_CREATE_QP_REQ_RAMROD_DATA_EDPM_MODE, qp->edpm_mode);
+	p_ramrod = &p_ent->ramrod.roce_create_qp_req;
+	p_ramrod->flags = cpu_to_le16(flags);
+
+	SET_FIELD(p_ramrod->flags2, ROCE_CREATE_QP_REQ_RAMROD_DATA_EDPM_MODE,
+		  qp->edpm_mode);
 
 	p_ramrod->max_ord = qp->max_rd_atomic_req;
 	p_ramrod->traffic_class = qp->traffic_class_tos;
@@ -446,10 +430,10 @@ static int qed_roce_sp_create_requester(struct qed_hwfn *p_hwfn,
 	DMA_REGPAIR_LE(p_ramrod->sq_pbl_addr, qp->sq_pbl_ptr);
 	DMA_REGPAIR_LE(p_ramrod->orq_pbl_addr, qp->orq_phys_addr);
 	qed_rdma_copy_gids(qp, p_ramrod->src_gid, p_ramrod->dst_gid);
-	p_ramrod->qp_handle_for_async.hi = cpu_to_le32(qp->qp_handle_async.hi);
-	p_ramrod->qp_handle_for_async.lo = cpu_to_le32(qp->qp_handle_async.lo);
-	p_ramrod->qp_handle_for_cqe.hi = cpu_to_le32(qp->qp_handle.hi);
-	p_ramrod->qp_handle_for_cqe.lo = cpu_to_le32(qp->qp_handle.lo);
+	p_ramrod->qp_handle_for_async.hi = qp->qp_handle_async.hi;
+	p_ramrod->qp_handle_for_async.lo = qp->qp_handle_async.lo;
+	p_ramrod->qp_handle_for_cqe.hi = qp->qp_handle.hi;
+	p_ramrod->qp_handle_for_cqe.lo = qp->qp_handle.lo;
 	p_ramrod->cq_cid =
 	    cpu_to_le32((p_hwfn->hw_info.opaque_fid << 16) | qp->sq_cq_id);
 
@@ -470,7 +454,7 @@ static int qed_roce_sp_create_requester(struct qed_hwfn *p_hwfn,
 	qed_rdma_set_fw_mac(p_ramrod->remote_mac_addr, qp->remote_mac_addr);
 	qed_rdma_set_fw_mac(p_ramrod->local_mac_addr, qp->local_mac_addr);
 
-	p_ramrod->udp_src_port = qp->udp_src_port;
+	p_ramrod->udp_src_port = cpu_to_le16(qp->udp_src_port);
 	p_ramrod->vlan_id = cpu_to_le16(qp->vlan_id);
 	p_ramrod->stats_counter_id = RESC_START(p_hwfn, QED_RDMA_STATS_QUEUE) +
 				     qp->stats_queue;
@@ -502,6 +486,7 @@ static int qed_roce_sp_modify_responder(struct qed_hwfn *p_hwfn,
 	struct roce_modify_qp_resp_ramrod_data *p_ramrod;
 	struct qed_sp_init_data init_data;
 	struct qed_spq_entry *p_ent;
+	u16 flags = 0;
 	int rc;
 
 	if (!qp->has_resp)
@@ -526,53 +511,43 @@ static int qed_roce_sp_modify_responder(struct qed_hwfn *p_hwfn,
 		return rc;
 	}
 
-	p_ramrod = &p_ent->ramrod.roce_modify_qp_resp;
-
-	p_ramrod->flags = 0;
+	SET_FIELD(flags, ROCE_MODIFY_QP_RESP_RAMROD_DATA_MOVE_TO_ERR_FLG,
+		  !!move_to_err);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_RESP_RAMROD_DATA_MOVE_TO_ERR_FLG, move_to_err);
-
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_RESP_RAMROD_DATA_RDMA_RD_EN,
+	SET_FIELD(flags, ROCE_MODIFY_QP_RESP_RAMROD_DATA_RDMA_RD_EN,
 		  qp->incoming_rdma_read_en);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_RESP_RAMROD_DATA_RDMA_WR_EN,
+	SET_FIELD(flags, ROCE_MODIFY_QP_RESP_RAMROD_DATA_RDMA_WR_EN,
 		  qp->incoming_rdma_write_en);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_RESP_RAMROD_DATA_ATOMIC_EN,
+	SET_FIELD(flags, ROCE_MODIFY_QP_RESP_RAMROD_DATA_ATOMIC_EN,
 		  qp->incoming_atomic_en);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_CREATE_QP_RESP_RAMROD_DATA_E2E_FLOW_CONTROL_EN,
+	SET_FIELD(flags, ROCE_CREATE_QP_RESP_RAMROD_DATA_E2E_FLOW_CONTROL_EN,
 		  qp->e2e_flow_control_en);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_RESP_RAMROD_DATA_RDMA_OPS_EN_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_RESP_RAMROD_DATA_RDMA_OPS_EN_FLG,
 		  GET_FIELD(modify_flags,
 			    QED_RDMA_MODIFY_QP_VALID_RDMA_OPS_EN));
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_RESP_RAMROD_DATA_P_KEY_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_RESP_RAMROD_DATA_P_KEY_FLG,
 		  GET_FIELD(modify_flags, QED_ROCE_MODIFY_QP_VALID_PKEY));
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_RESP_RAMROD_DATA_ADDRESS_VECTOR_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_RESP_RAMROD_DATA_ADDRESS_VECTOR_FLG,
 		  GET_FIELD(modify_flags,
 			    QED_ROCE_MODIFY_QP_VALID_ADDRESS_VECTOR));
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_RESP_RAMROD_DATA_MAX_IRD_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_RESP_RAMROD_DATA_MAX_IRD_FLG,
 		  GET_FIELD(modify_flags,
 			    QED_RDMA_MODIFY_QP_VALID_MAX_RD_ATOMIC_RESP));
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_RESP_RAMROD_DATA_MIN_RNR_NAK_TIMER_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_RESP_RAMROD_DATA_MIN_RNR_NAK_TIMER_FLG,
 		  GET_FIELD(modify_flags,
 			    QED_ROCE_MODIFY_QP_VALID_MIN_RNR_NAK_TIMER));
 
+	p_ramrod = &p_ent->ramrod.roce_modify_qp_resp;
+	p_ramrod->flags = cpu_to_le16(flags);
+
 	p_ramrod->fields = 0;
 	SET_FIELD(p_ramrod->fields,
 		  ROCE_MODIFY_QP_RESP_RAMROD_DATA_MIN_RNR_NAK_TIMER,
@@ -599,6 +574,7 @@ static int qed_roce_sp_modify_requester(struct qed_hwfn *p_hwfn,
 	struct roce_modify_qp_req_ramrod_data *p_ramrod;
 	struct qed_sp_init_data init_data;
 	struct qed_spq_entry *p_ent;
+	u16 flags = 0;
 	int rc;
 
 	if (!qp->has_req)
@@ -623,54 +599,44 @@ static int qed_roce_sp_modify_requester(struct qed_hwfn *p_hwfn,
 		return rc;
 	}
 
-	p_ramrod = &p_ent->ramrod.roce_modify_qp_req;
-
-	p_ramrod->flags = 0;
+	SET_FIELD(flags, ROCE_MODIFY_QP_REQ_RAMROD_DATA_MOVE_TO_ERR_FLG,
+		  !!move_to_err);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_MOVE_TO_ERR_FLG, move_to_err);
+	SET_FIELD(flags, ROCE_MODIFY_QP_REQ_RAMROD_DATA_MOVE_TO_SQD_FLG,
+		  !!move_to_sqd);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_MOVE_TO_SQD_FLG, move_to_sqd);
-
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_EN_SQD_ASYNC_NOTIFY,
+	SET_FIELD(flags, ROCE_MODIFY_QP_REQ_RAMROD_DATA_EN_SQD_ASYNC_NOTIFY,
 		  qp->sqd_async);
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_P_KEY_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_REQ_RAMROD_DATA_P_KEY_FLG,
 		  GET_FIELD(modify_flags, QED_ROCE_MODIFY_QP_VALID_PKEY));
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_ADDRESS_VECTOR_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_REQ_RAMROD_DATA_ADDRESS_VECTOR_FLG,
 		  GET_FIELD(modify_flags,
 			    QED_ROCE_MODIFY_QP_VALID_ADDRESS_VECTOR));
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_MAX_ORD_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_REQ_RAMROD_DATA_MAX_ORD_FLG,
 		  GET_FIELD(modify_flags,
 			    QED_RDMA_MODIFY_QP_VALID_MAX_RD_ATOMIC_REQ));
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_RNR_NAK_CNT_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_REQ_RAMROD_DATA_RNR_NAK_CNT_FLG,
 		  GET_FIELD(modify_flags,
 			    QED_ROCE_MODIFY_QP_VALID_RNR_RETRY_CNT));
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_ERR_RETRY_CNT_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_REQ_RAMROD_DATA_ERR_RETRY_CNT_FLG,
 		  GET_FIELD(modify_flags, QED_ROCE_MODIFY_QP_VALID_RETRY_CNT));
 
-	SET_FIELD(p_ramrod->flags,
-		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_ACK_TIMEOUT_FLG,
+	SET_FIELD(flags, ROCE_MODIFY_QP_REQ_RAMROD_DATA_ACK_TIMEOUT_FLG,
 		  GET_FIELD(modify_flags,
 			    QED_ROCE_MODIFY_QP_VALID_ACK_TIMEOUT));
 
+	p_ramrod = &p_ent->ramrod.roce_modify_qp_req;
+	p_ramrod->flags = cpu_to_le16(flags);
+
 	p_ramrod->fields = 0;
 	SET_FIELD(p_ramrod->fields,
 		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_ERR_RETRY_CNT, qp->retry_cnt);
-
-	SET_FIELD(p_ramrod->fields,
-		  ROCE_MODIFY_QP_REQ_RAMROD_DATA_RNR_NAK_CNT,
+	SET_FIELD(p_ramrod->fields, ROCE_MODIFY_QP_REQ_RAMROD_DATA_RNR_NAK_CNT,
 		  qp->rnr_retry_cnt);
 
 	p_ramrod->max_ord = qp->max_rd_atomic_req;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp.h b/drivers/net/ethernet/qlogic/qed/qed_sp.h
index f7f983a8bf44..993f1357b6fc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp.h
@@ -155,7 +155,7 @@ struct qed_consq {
 };
 
 typedef int (*qed_spq_async_comp_cb)(struct qed_hwfn *p_hwfn, u8 opcode,
-				     u16 echo, union event_ring_data *data,
+				     __le16 echo, union event_ring_data *data,
 				     u8 fw_return_code);
 
 int
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
index 71ab57bca7c9..8142f5669b26 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sp_commands.c
@@ -341,9 +341,9 @@ int qed_sp_pf_start(struct qed_hwfn *p_hwfn,
 	outer_tag_config->outer_tag.tci = cpu_to_le16(p_hwfn->hw_info.ovlan);
 
 	if (test_bit(QED_MF_8021Q_TAGGING, &p_hwfn->cdev->mf_bits)) {
-		outer_tag_config->outer_tag.tpid = ETH_P_8021Q;
+		outer_tag_config->outer_tag.tpid = cpu_to_le16(ETH_P_8021Q);
 	} else if (test_bit(QED_MF_8021AD_TAGGING, &p_hwfn->cdev->mf_bits)) {
-		outer_tag_config->outer_tag.tpid = ETH_P_8021AD;
+		outer_tag_config->outer_tag.tpid = cpu_to_le16(ETH_P_8021AD);
 		outer_tag_config->enable_stag_pri_change = 1;
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index b4e21e4792b7..aa215eeeb4df 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4005,7 +4005,7 @@ static int qed_sriov_vfpf_msg(struct qed_hwfn *p_hwfn,
 	/* List the physical address of the request so that handler
 	 * could later on copy the message from it.
 	 */
-	p_vf->vf_mbx.pending_req = (((u64)vf_msg->hi) << 32) | vf_msg->lo;
+	p_vf->vf_mbx.pending_req = HILO_64(vf_msg->hi, vf_msg->lo);
 
 	/* Mark the event and schedule the workqueue */
 	p_vf->vf_mbx.b_pending_msg = true;
@@ -4037,7 +4037,7 @@ static void qed_sriov_vfpf_malicious(struct qed_hwfn *p_hwfn,
 	}
 }
 
-static int qed_sriov_eqe_event(struct qed_hwfn *p_hwfn, u8 opcode, u16 echo,
+static int qed_sriov_eqe_event(struct qed_hwfn *p_hwfn, u8 opcode, __le16 echo,
 			       union event_ring_data *data, u8 fw_return_code)
 {
 	switch (opcode) {
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 5ca081cd2ed9..90e1060da02b 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1403,16 +1403,15 @@ static inline void qed_sb_ack(struct qed_sb_info *sb_info,
 			      enum igu_int_cmd int_cmd,
 			      u8 upd_flg)
 {
-	struct igu_prod_cons_update igu_ack = { 0 };
+	u32 igu_ack;
 
-	igu_ack.sb_id_and_flags =
-		((sb_info->sb_ack << IGU_PROD_CONS_UPDATE_SB_INDEX_SHIFT) |
-		 (upd_flg << IGU_PROD_CONS_UPDATE_UPDATE_FLAG_SHIFT) |
-		 (int_cmd << IGU_PROD_CONS_UPDATE_ENABLE_INT_SHIFT) |
-		 (IGU_SEG_ACCESS_REG <<
-		  IGU_PROD_CONS_UPDATE_SEGMENT_ACCESS_SHIFT));
+	igu_ack = ((sb_info->sb_ack << IGU_PROD_CONS_UPDATE_SB_INDEX_SHIFT) |
+		   (upd_flg << IGU_PROD_CONS_UPDATE_UPDATE_FLAG_SHIFT) |
+		   (int_cmd << IGU_PROD_CONS_UPDATE_ENABLE_INT_SHIFT) |
+		   (IGU_SEG_ACCESS_REG <<
+		    IGU_PROD_CONS_UPDATE_SEGMENT_ACCESS_SHIFT));
 
-	DIRECT_REG_WR(sb_info->igu_addr, igu_ack.sb_id_and_flags);
+	DIRECT_REG_WR(sb_info->igu_addr, igu_ack);
 
 	/* Both segments (interrupts & acks) are written to same place address;
 	 * Need to guarantee all commands will be received (in-order) by HW.
-- 
2.25.1

