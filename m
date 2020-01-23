Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935F0146616
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAWK7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:59:03 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60996 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbgAWK7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:59:01 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NAuoNS005434;
        Thu, 23 Jan 2020 02:58:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=gDu7KcqiGexp16hOS/xYf8HRsKMOOw7uxAxTckSmwtc=;
 b=PDgcLgYrNA/n2n10OGpJ/v+UyL78vwgabGAjpTCSKAcnjXhcwxcVh/43+YD/bwW6S4cc
 vFBeqqynG/5Y+hrrGlqlyFFZ2zNbe2mtm36k4WxF8w4iztahXIJnIPfz0EGTuHQAATMT
 OxTqoL477uKPI7hOy6gAEGay1Dh0n+3H5TUu/9SsDnFv/IXMTAOcBti1fG+WK9lBh2KX
 jILE4uGlc11/NTjhnh7m2jVZ+3IxwcCFQVv0vNBZ/bhbQ/VTPYywyJ3RIFuCjvHCm3Ui
 gwW39G2cFoaenJyLFwOFuxPXP8aO1iq87UG9z/M5QqomKbEhMauhMqhHncbd033/jtcb gw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xm2dtbd37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jan 2020 02:58:57 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jan
 2020 02:58:55 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Jan 2020 02:58:55 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id AB97D3F7040;
        Thu, 23 Jan 2020 02:58:53 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 05/13] qed: Use dmae to write to widebus registers in fw_funcs
Date:   Thu, 23 Jan 2020 12:58:28 +0200
Message-ID: <20200123105836.15090-6-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200123105836.15090-1-michal.kalderon@marvell.com>
References: <20200123105836.15090-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_08:2020-01-23,2020-01-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several wide-bus registers written to by the fw_funcs
that require using the dmae for atomicity. Therefore using the dmae
channel functionality was added to the fw_funcs file, since the code
is very similar to the previously used code, the structures used were
moved to qed_hsi. Due to FW conventions, the names of the flags in the
struct changed. Since this required slight modification in the places
that set the flags the code was modified to use GET/SET FIELD macros.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h      | 24 ------
 drivers/net/ethernet/qlogic/qed/qed_hsi.h          | 41 ++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_hw.c           | 67 ++++++++---------
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    | 86 ++++++++++++++++------
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c     |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        | 11 +--
 7 files changed, 142 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 249fcc3dc138..479d98e6187a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -907,7 +907,7 @@ qed_llh_access_filter(struct qed_hwfn *p_hwfn,
 	/* Filter value */
 	addr = NIG_REG_LLH_FUNC_FILTER_VALUE + 2 * filter_idx * 0x4;
 
-	params.flags = QED_DMAE_FLAG_PF_DST;
+	SET_FIELD(params.flags, QED_DMAE_PARAMS_DST_PF_VALID, 0x1);
 	params.dst_pfid = pfid;
 	rc = qed_dmae_host2grc(p_hwfn,
 			       p_ptt,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
index 47376d4d071f..eb4808b3bf67 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
@@ -230,30 +230,6 @@ enum qed_dmae_address_type_t {
 	QED_DMAE_ADDRESS_GRC
 };
 
-/* value of flags If QED_DMAE_FLAG_RW_REPL_SRC flag is set and the
- * source is a block of length DMAE_MAX_RW_SIZE and the
- * destination is larger, the source block will be duplicated as
- * many times as required to fill the destination block. This is
- * used mostly to write a zeroed buffer to destination address
- * using DMA
- */
-#define QED_DMAE_FLAG_RW_REPL_SRC	0x00000001
-#define QED_DMAE_FLAG_VF_SRC		0x00000002
-#define QED_DMAE_FLAG_VF_DST		0x00000004
-#define QED_DMAE_FLAG_COMPLETION_DST	0x00000008
-#define QED_DMAE_FLAG_PORT		0x00000010
-#define QED_DMAE_FLAG_PF_SRC		0x00000020
-#define QED_DMAE_FLAG_PF_DST		0x00000040
-
-struct qed_dmae_params {
-	u32 flags; /* consists of QED_DMAE_FLAG_* values */
-	u8 src_vfid;
-	u8 dst_vfid;
-	u8 port_id;
-	u8 src_pfid;
-	u8 dst_pfid;
-};
-
 /**
  * @brief qed_dmae_host2grc - copy data from source addr to
  * dmae registers using the given ptt
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index fb4c0de44aaa..565ab12fa87c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -1435,7 +1435,11 @@ struct dmae_cmd {
 	__le16 crc16;
 	__le16 crc16_c;
 	__le16 crc10;
-	__le16 reserved;
+	__le16 error_bit_reserved;
+#define DMAE_CMD_ERROR_BIT_MASK        0x1
+#define DMAE_CMD_ERROR_BIT_SHIFT       0
+#define DMAE_CMD_RESERVED_MASK	       0x7FFF
+#define DMAE_CMD_RESERVED_SHIFT        1
 	__le16 xsum16;
 	__le16 xsum8;
 };
@@ -1566,6 +1570,41 @@ struct e4_ystorm_core_conn_ag_ctx {
 	__le32 reg3;
 };
 
+/* DMAE parameters */
+struct qed_dmae_params {
+	__le32 flags;
+/* If QED_DMAE_PARAMS_RW_REPL_SRC flag is set and the
+ * source is a block of length DMAE_MAX_RW_SIZE and the
+ * destination is larger, the source block will be duplicated as
+ * many times as required to fill the destination block. This is
+ * used mostly to write a zeroed buffer to destination address
+ * using DMA
+ */
+#define QED_DMAE_PARAMS_RW_REPL_SRC_MASK	0x1
+#define QED_DMAE_PARAMS_RW_REPL_SRC_SHIFT	0
+#define QED_DMAE_PARAMS_SRC_VF_VALID_MASK	0x1
+#define QED_DMAE_PARAMS_SRC_VF_VALID_SHIFT	1
+#define QED_DMAE_PARAMS_DST_VF_VALID_MASK	0x1
+#define QED_DMAE_PARAMS_DST_VF_VALID_SHIFT	2
+#define QED_DMAE_PARAMS_COMPLETION_DST_MASK	0x1
+#define QED_DMAE_PARAMS_COMPLETION_DST_SHIFT	3
+#define QED_DMAE_PARAMS_PORT_VALID_MASK		0x1
+#define QED_DMAE_PARAMS_PORT_VALID_SHIFT	4
+#define QED_DMAE_PARAMS_SRC_PF_VALID_MASK	0x1
+#define QED_DMAE_PARAMS_SRC_PF_VALID_SHIFT	5
+#define QED_DMAE_PARAMS_DST_PF_VALID_MASK	0x1
+#define QED_DMAE_PARAMS_DST_PF_VALID_SHIFT	6
+#define QED_DMAE_PARAMS_RESERVED_MASK		0x1FFFFFF
+#define QED_DMAE_PARAMS_RESERVED_SHIFT		7
+	u8 src_vfid;
+	u8 dst_vfid;
+	u8 port_id;
+	u8 src_pfid;
+	u8 dst_pfid;
+	u8 reserved1;
+	__le16 reserved2;
+};
+
 /* IGU cleanup command */
 struct igu_cleanup {
 	__le32 sb_id_and_flags;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.c b/drivers/net/ethernet/qlogic/qed/qed_hw.c
index a4de9e3ef72c..4ab8cfaf63d1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.c
@@ -393,7 +393,7 @@ u32 qed_vfid_to_concrete(struct qed_hwfn *p_hwfn, u8 vfid)
 
 /* DMAE */
 #define QED_DMAE_FLAGS_IS_SET(params, flag) \
-	((params) != NULL && ((params)->flags & QED_DMAE_FLAG_##flag))
+	((params) != NULL && GET_FIELD((params)->flags, QED_DMAE_PARAMS_##flag))
 
 static void qed_dmae_opcode(struct qed_hwfn *p_hwfn,
 			    const u8 is_src_type_grc,
@@ -408,62 +408,55 @@ static void qed_dmae_opcode(struct qed_hwfn *p_hwfn,
 	 * 0- The source is the PCIe
 	 * 1- The source is the GRC.
 	 */
-	opcode |= (is_src_type_grc ? DMAE_CMD_SRC_MASK_GRC
-				   : DMAE_CMD_SRC_MASK_PCIE) <<
-		   DMAE_CMD_SRC_SHIFT;
-	src_pfid = QED_DMAE_FLAGS_IS_SET(p_params, PF_SRC) ?
-		   p_params->src_pfid : p_hwfn->rel_pf_id;
-	opcode |= ((src_pfid & DMAE_CMD_SRC_PF_ID_MASK) <<
-		   DMAE_CMD_SRC_PF_ID_SHIFT);
+	SET_FIELD(opcode, DMAE_CMD_SRC,
+		  (is_src_type_grc ? dmae_cmd_src_grc : dmae_cmd_src_pcie));
+	src_pfid = QED_DMAE_FLAGS_IS_SET(p_params, SRC_PF_VALID) ?
+	    p_params->src_pfid : p_hwfn->rel_pf_id;
+	SET_FIELD(opcode, DMAE_CMD_SRC_PF_ID, src_pfid);
 
 	/* The destination of the DMA can be: 0-None 1-PCIe 2-GRC 3-None */
-	opcode |= (is_dst_type_grc ? DMAE_CMD_DST_MASK_GRC
-				   : DMAE_CMD_DST_MASK_PCIE) <<
-		   DMAE_CMD_DST_SHIFT;
-	dst_pfid = QED_DMAE_FLAGS_IS_SET(p_params, PF_DST) ?
-		   p_params->dst_pfid : p_hwfn->rel_pf_id;
-	opcode |= ((dst_pfid & DMAE_CMD_DST_PF_ID_MASK) <<
-		   DMAE_CMD_DST_PF_ID_SHIFT);
+	SET_FIELD(opcode, DMAE_CMD_DST,
+		  (is_dst_type_grc ? dmae_cmd_dst_grc : dmae_cmd_dst_pcie));
+	dst_pfid = QED_DMAE_FLAGS_IS_SET(p_params, DST_PF_VALID) ?
+	    p_params->dst_pfid : p_hwfn->rel_pf_id;
+	SET_FIELD(opcode, DMAE_CMD_DST_PF_ID, dst_pfid);
+
 
 	/* Whether to write a completion word to the completion destination:
 	 * 0-Do not write a completion word
 	 * 1-Write the completion word
 	 */
-	opcode |= (DMAE_CMD_COMP_WORD_EN_MASK << DMAE_CMD_COMP_WORD_EN_SHIFT);
-	opcode |= (DMAE_CMD_SRC_ADDR_RESET_MASK <<
-		   DMAE_CMD_SRC_ADDR_RESET_SHIFT);
+	SET_FIELD(opcode, DMAE_CMD_COMP_WORD_EN, 1);
+	SET_FIELD(opcode, DMAE_CMD_SRC_ADDR_RESET, 1);
 
 	if (QED_DMAE_FLAGS_IS_SET(p_params, COMPLETION_DST))
-		opcode |= (1 << DMAE_CMD_COMP_FUNC_SHIFT);
+		SET_FIELD(opcode, DMAE_CMD_COMP_FUNC, 1);
 
-	opcode |= (DMAE_CMD_ENDIANITY << DMAE_CMD_ENDIANITY_MODE_SHIFT);
+	/* swapping mode 3 - big endian */
+	SET_FIELD(opcode, DMAE_CMD_ENDIANITY_MODE, DMAE_CMD_ENDIANITY);
 
-	port_id = (QED_DMAE_FLAGS_IS_SET(p_params, PORT)) ?
-		   p_params->port_id : p_hwfn->port_id;
-	opcode |= (port_id << DMAE_CMD_PORT_ID_SHIFT);
+	port_id = (QED_DMAE_FLAGS_IS_SET(p_params, PORT_VALID)) ?
+	    p_params->port_id : p_hwfn->port_id;
+	SET_FIELD(opcode, DMAE_CMD_PORT_ID, port_id);
 
 	/* reset source address in next go */
-	opcode |= (DMAE_CMD_SRC_ADDR_RESET_MASK <<
-		   DMAE_CMD_SRC_ADDR_RESET_SHIFT);
+	SET_FIELD(opcode, DMAE_CMD_SRC_ADDR_RESET, 1);
 
 	/* reset dest address in next go */
-	opcode |= (DMAE_CMD_DST_ADDR_RESET_MASK <<
-		   DMAE_CMD_DST_ADDR_RESET_SHIFT);
+	SET_FIELD(opcode, DMAE_CMD_DST_ADDR_RESET, 1);
 
 	/* SRC/DST VFID: all 1's - pf, otherwise VF id */
-	if (QED_DMAE_FLAGS_IS_SET(p_params, VF_SRC)) {
-		opcode |= 1 << DMAE_CMD_SRC_VF_ID_VALID_SHIFT;
-		opcode_b |= p_params->src_vfid << DMAE_CMD_SRC_VF_ID_SHIFT;
+	if (QED_DMAE_FLAGS_IS_SET(p_params, SRC_VF_VALID)) {
+		SET_FIELD(opcode, DMAE_CMD_SRC_VF_ID_VALID, 1);
+		SET_FIELD(opcode_b, DMAE_CMD_SRC_VF_ID, p_params->src_vfid);
 	} else {
-		opcode_b |= DMAE_CMD_SRC_VF_ID_MASK <<
-			    DMAE_CMD_SRC_VF_ID_SHIFT;
+		SET_FIELD(opcode_b, DMAE_CMD_SRC_VF_ID, 0xFF);
 	}
-
-	if (QED_DMAE_FLAGS_IS_SET(p_params, VF_DST)) {
-		opcode |= 1 << DMAE_CMD_DST_VF_ID_VALID_SHIFT;
-		opcode_b |= p_params->dst_vfid << DMAE_CMD_DST_VF_ID_SHIFT;
+	if (QED_DMAE_FLAGS_IS_SET(p_params, DST_VF_VALID)) {
+		SET_FIELD(opcode, DMAE_CMD_DST_VF_ID_VALID, 1);
+		SET_FIELD(opcode_b, DMAE_CMD_DST_VF_ID, p_params->dst_vfid);
 	} else {
-		opcode_b |= DMAE_CMD_DST_VF_ID_MASK << DMAE_CMD_DST_VF_ID_SHIFT;
+		SET_FIELD(opcode_b, DMAE_CMD_DST_VF_ID, 0xFF);
 	}
 
 	p_hwfn->dmae_info.p_dmae_cmd->opcode = cpu_to_le32(opcode);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index a816fb5411b7..e09e6ce74705 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -1022,6 +1022,56 @@ bool qed_send_qm_stop_cmd(struct qed_hwfn *p_hwfn,
 #define PRS_ETH_TUNN_OUTPUT_FORMAT     0xF4DAB910
 #define PRS_ETH_OUTPUT_FORMAT          0xFFFF4910
 
+#define ARR_REG_WR(dev, ptt, addr, arr,	arr_size) \
+	do { \
+		u32 i; \
+		\
+		for (i = 0; i < (arr_size); i++) \
+			qed_wr(dev, ptt, \
+			       ((addr) + (4 * i)), \
+			       ((u32 *)&(arr))[i]); \
+	} while (0)
+
+/**
+ * @brief qed_dmae_to_grc - is an internal function - writes from host to
+ * wide-bus registers (split registers are not supported yet)
+ *
+ * @param p_hwfn - HW device data
+ * @param p_ptt - ptt window used for writing the registers.
+ * @param p_data - pointer to source data.
+ * @param addr - Destination register address.
+ * @param len_in_dwords - data length in DWARDS (u32)
+ */
+static int qed_dmae_to_grc(struct qed_hwfn *p_hwfn,
+			   struct qed_ptt *p_ptt,
+			   u32 *p_data, u32 addr, u32 len_in_dwords)
+{
+	struct qed_dmae_params params = {};
+	int rc;
+
+	if (!p_data)
+		return -1;
+
+	/* Set DMAE params */
+	SET_FIELD(params.flags, QED_DMAE_PARAMS_COMPLETION_DST, 1);
+
+	/* Execute DMAE command */
+	rc = qed_dmae_host2grc(p_hwfn, p_ptt,
+			       (u64)(uintptr_t)(p_data),
+			       addr, len_in_dwords, &params);
+
+	/* If not read using DMAE, read using GRC */
+	if (rc) {
+		DP_VERBOSE(p_hwfn,
+			   QED_MSG_DEBUG,
+			   "Failed writing to chip using DMAE, using GRC instead\n");
+		/* write to registers using GRC */
+		ARR_REG_WR(p_hwfn, p_ptt, addr, p_data, len_in_dwords);
+	}
+
+	return len_in_dwords;
+}
+
 void qed_set_vxlan_dest_port(struct qed_hwfn *p_hwfn,
 			     struct qed_ptt *p_ptt, u16 dest_port)
 {
@@ -1206,6 +1256,8 @@ void qed_set_vxlan_no_l2_enable(struct qed_hwfn *p_hwfn,
 
 void qed_gft_disable(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt, u16 pf_id)
 {
+	struct regpair ram_line = { };
+
 	/* Disable gft search for PF */
 	qed_wr(p_hwfn, p_ptt, PRS_REG_SEARCH_GFT, 0);
 
@@ -1215,12 +1267,9 @@ void qed_gft_disable(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt, u16 pf_id)
 	qed_wr(p_hwfn, p_ptt, PRS_REG_GFT_CAM + CAM_LINE_SIZE * pf_id, 0);
 
 	/* Zero ramline */
-	qed_wr(p_hwfn,
-	       p_ptt, PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id, 0);
-	qed_wr(p_hwfn,
-	       p_ptt,
-	       PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id + REG_SIZE,
-	       0);
+	qed_dmae_to_grc(p_hwfn, p_ptt, (u32 *)&ram_line,
+			PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id,
+			sizeof(ram_line) / REG_SIZE);
 }
 
 void qed_gft_config(struct qed_hwfn *p_hwfn,
@@ -1331,24 +1380,17 @@ void qed_gft_config(struct qed_hwfn *p_hwfn,
 
 	qed_wr(p_hwfn,
 	       p_ptt, PRS_REG_SEARCH_NON_IP_AS_GFT, search_non_ip_as_gft);
-	qed_wr(p_hwfn,
-	       p_ptt,
-	       PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id,
-	       ram_line.lo);
-	qed_wr(p_hwfn,
-	       p_ptt,
-	       PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id + REG_SIZE,
-	       ram_line.hi);
+	qed_dmae_to_grc(p_hwfn, p_ptt, (u32 *)&ram_line,
+			PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id,
+			sizeof(ram_line) / REG_SIZE);
 
 	/* Set default profile so that no filter match will happen */
-	qed_wr(p_hwfn,
-	       p_ptt,
-	       PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE *
-	       PRS_GFT_CAM_LINES_NO_MATCH, 0xffffffff);
-	qed_wr(p_hwfn,
-	       p_ptt,
-	       PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE *
-	       PRS_GFT_CAM_LINES_NO_MATCH + REG_SIZE, 0x3ff);
+	ram_line.lo = 0xffffffff;
+	ram_line.hi = 0x3ff;
+	qed_dmae_to_grc(p_hwfn, p_ptt, (u32 *)&ram_line,
+			PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE *
+			PRS_GFT_CAM_LINES_NO_MATCH,
+			sizeof(ram_line) / REG_SIZE);
 
 	/* Enable gft search */
 	qed_wr(p_hwfn, p_ptt, PRS_REG_SEARCH_GFT, 1);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
index ef22a3596295..31222b3e3936 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
@@ -215,7 +215,7 @@ static int qed_init_fill_dmae(struct qed_hwfn *p_hwfn,
 	 * 3. p_hwfb->temp_data,
 	 * 4. fill_count
 	 */
-	params.flags = QED_DMAE_FLAG_RW_REPL_SRC;
+	SET_FIELD(params.flags, QED_DMAE_PARAMS_RW_REPL_SRC, 0x1);
 	return qed_dmae_host2grc(p_hwfn, p_ptt,
 				 (uintptr_t)(&zero_buffer[0]),
 				 addr, fill_count, &params);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index fe4b740de14c..66876af814c4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -352,7 +352,7 @@ static int qed_iov_post_vf_bulletin(struct qed_hwfn *p_hwfn,
 
 	/* propagate bulletin board via dmae to vm memory */
 	memset(&params, 0, sizeof(params));
-	params.flags = QED_DMAE_FLAG_VF_DST;
+	SET_FIELD(params.flags, QED_DMAE_PARAMS_DST_VF_VALID, 0x1);
 	params.dst_vfid = p_vf->abs_vf_id;
 	return qed_dmae_host2host(p_hwfn, p_ptt, p_vf->bulletin.phys,
 				  p_vf->vf_bulletin, p_vf->bulletin.size / 4,
@@ -1225,8 +1225,8 @@ static void qed_iov_send_response(struct qed_hwfn *p_hwfn,
 
 	eng_vf_id = p_vf->abs_vf_id;
 
-	memset(&params, 0, sizeof(struct qed_dmae_params));
-	params.flags = QED_DMAE_FLAG_VF_DST;
+	memset(&params, 0, sizeof(params));
+	SET_FIELD(params.flags, QED_DMAE_PARAMS_DST_VF_VALID, 0x1);
 	params.dst_vfid = eng_vf_id;
 
 	qed_dmae_host2host(p_hwfn, p_ptt, mbx->reply_phys + sizeof(u64),
@@ -4103,8 +4103,9 @@ static int qed_iov_copy_vf_msg(struct qed_hwfn *p_hwfn, struct qed_ptt *ptt,
 	if (!vf_info)
 		return -EINVAL;
 
-	memset(&params, 0, sizeof(struct qed_dmae_params));
-	params.flags = QED_DMAE_FLAG_VF_SRC | QED_DMAE_FLAG_COMPLETION_DST;
+	memset(&params, 0, sizeof(params));
+	SET_FIELD(params.flags, QED_DMAE_PARAMS_SRC_VF_VALID, 0x1);
+	SET_FIELD(params.flags, QED_DMAE_PARAMS_COMPLETION_DST, 0x1);
 	params.src_vfid = vf_info->abs_vf_id;
 
 	if (qed_dmae_host2host(p_hwfn, ptt,
-- 
2.14.5

