Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DB2106AA
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfEAJ6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:58:37 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34320 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbfEAJ6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:58:37 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x419v8j7015954;
        Wed, 1 May 2019 02:58:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ZqX906kULotQSOTojzRLpyaSKazL6rnoTczrJebUNOw=;
 b=I+PuU2Y+Z+nBUmrcXTcNPPrqKDcWTxuT2bf+y+jqeG6EByoo9DW7BbMw6pAJ6sMKWFl/
 q164BjWSnLH93IgwVRwbtNm6z/PZ0M6udq49yClWPMdKOOijs+DWlp7BW7d0lEvA7EOk
 fxYuotxJgs06iBBR/YdmEBm0+x8PBM9oRqTGMDINp+dAg1ONb9miGjmLsBTFp0YnTujE
 n3UNG9t6z2re4pPIjlGk+tv9h0A0l0nfDcyzoSB0wX+vlZqGGeVYTf5ln+fJpFHgi9St
 zOnrYflwadC5WjSX5MJV4xAG67hJ7w8Og4w8Vcp7cAJiXyLdWdNkGitBxdIyLtbT47Yb fA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2s6xgchwa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 02:58:32 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 1 May
 2019 02:58:31 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 1 May 2019 02:58:30 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 00A7E3F7043;
        Wed,  1 May 2019 02:58:28 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <jgg@ziepe.ca>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH net-next 01/10] qed: Modify api for performing a dmae to another PF
Date:   Wed, 1 May 2019 12:57:13 +0300
Message-ID: <20190501095722.6902-2-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501095722.6902-1-michal.kalderon@marvell.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_04:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch modifies the dmae API to enable performing a dmae operation
to another PF. This enables sharing between the llh entries between PFs
and thus increasing the amount of filters per PF under certain
configurations.
The llh entries require using the dmae since the memory is widebus,
which requires atomicity in access.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c      |  5 +--
 drivers/net/ethernet/qlogic/qed/qed_debug.c    |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h  | 16 ++++++---
 drivers/net/ethernet/qlogic/qed/qed_hw.c       | 45 ++++++++++++++------------
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c | 11 ++++---
 drivers/net/ethernet/qlogic/qed/qed_int.c      | 12 ++++---
 drivers/net/ethernet/qlogic/qed/qed_l2.c       |  6 ++--
 drivers/net/ethernet/qlogic/qed/qed_sriov.c    |  4 ++-
 8 files changed, 62 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index e61d1d905415..52146c4c5e3b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -2351,7 +2351,8 @@ qed_cxt_dynamic_ilt_alloc(struct qed_hwfn *p_hwfn,
 
 	/* Write via DMAE since the PSWRQ2_REG_ILT_MEMORY line is a wide-bus */
 	qed_dmae_host2grc(p_hwfn, p_ptt, (u64) (uintptr_t)&ilt_hw_entry,
-			  reg_offset, sizeof(ilt_hw_entry) / sizeof(u32), 0);
+			  reg_offset, sizeof(ilt_hw_entry) / sizeof(u32),
+			  NULL /* default parameters */);
 
 	if (elem_type == QED_ELEM_CXT) {
 		u32 last_cid_allocated = (1 + (iid / elems_per_p)) *
@@ -2457,7 +2458,7 @@ qed_cxt_free_ilt_range(struct qed_hwfn *p_hwfn,
 				  (u64) (uintptr_t) &ilt_hw_entry,
 				  reg_offset,
 				  sizeof(ilt_hw_entry) / sizeof(u32),
-				  0);
+				  NULL /* default parameters */);
 	}
 
 	qed_ptt_release(p_hwfn, p_ptt);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 979f1e4bc18b..8525e6bf6ae5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -2537,7 +2537,7 @@ static u32 qed_grc_dump_addr_range(struct qed_hwfn *p_hwfn,
 	    (len >= s_platform_defs[dev_data->platform_id].dmae_thresh ||
 	     wide_bus)) {
 		if (!qed_dmae_grc2host(p_hwfn, p_ptt, DWORDS_TO_BYTES(addr),
-				       (u64)(uintptr_t)(dump_buf), len, 0))
+				       (u64)(uintptr_t)(dump_buf), len, NULL))
 			return len;
 		dev_data->use_dmae = 0;
 		DP_VERBOSE(p_hwfn,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
index e4b4e3b78e8a..35f0a586bd90 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
@@ -241,11 +241,17 @@ enum qed_dmae_address_type_t {
 #define QED_DMAE_FLAG_VF_SRC		0x00000002
 #define QED_DMAE_FLAG_VF_DST		0x00000004
 #define QED_DMAE_FLAG_COMPLETION_DST	0x00000008
+#define QED_DMAE_FLAG_PORT		0x00000010
+#define QED_DMAE_FLAG_PF_SRC		0x00000020
+#define QED_DMAE_FLAG_PF_DST		0x00000040
 
 struct qed_dmae_params {
 	u32 flags; /* consists of QED_DMAE_FLAG_* values */
 	u8 src_vfid;
 	u8 dst_vfid;
+	u8 port_id;
+	u8 src_pfid;
+	u8 dst_pfid;
 };
 
 /**
@@ -257,7 +263,7 @@ struct qed_dmae_params {
  * @param source_addr
  * @param grc_addr (dmae_data_offset)
  * @param size_in_dwords
- * @param flags (one of the flags defined above)
+ * @param p_params (default parameters will be used in case of NULL)
  */
 int
 qed_dmae_host2grc(struct qed_hwfn *p_hwfn,
@@ -265,7 +271,7 @@ qed_dmae_host2grc(struct qed_hwfn *p_hwfn,
 		  u64 source_addr,
 		  u32 grc_addr,
 		  u32 size_in_dwords,
-		  u32 flags);
+		  struct qed_dmae_params *p_params);
 
  /**
  * @brief qed_dmae_grc2host - Read data from dmae data offset
@@ -275,11 +281,11 @@ qed_dmae_host2grc(struct qed_hwfn *p_hwfn,
  * @param grc_addr (dmae_data_offset)
  * @param dest_addr
  * @param size_in_dwords
- * @param flags - one of the flags defined above
+ * @param p_params (default parameters will be used in case of NULL)
  */
 int qed_dmae_grc2host(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 		      u32 grc_addr, dma_addr_t dest_addr, u32 size_in_dwords,
-		      u32 flags);
+		      struct qed_dmae_params *p_params);
 
 /**
  * @brief qed_dmae_host2host - copy data from to source address
@@ -290,7 +296,7 @@ int qed_dmae_grc2host(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
  * @param source_addr
  * @param dest_addr
  * @param size_in_dwords
- * @param params
+ * @param p_params (default parameters will be used in case of NULL)
  */
 int qed_dmae_host2host(struct qed_hwfn *p_hwfn,
 		       struct qed_ptt *p_ptt,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.c b/drivers/net/ethernet/qlogic/qed/qed_hw.c
index 72ec1c6bdf70..87f333e77197 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.c
@@ -392,11 +392,15 @@ u32 qed_vfid_to_concrete(struct qed_hwfn *p_hwfn, u8 vfid)
 }
 
 /* DMAE */
+#define QED_DMAE_FLAGS_IS_SET(params, flag) \
+	((params) != NULL && ((params)->flags & QED_DMAE_FLAG_##flag))
+
 static void qed_dmae_opcode(struct qed_hwfn *p_hwfn,
 			    const u8 is_src_type_grc,
 			    const u8 is_dst_type_grc,
 			    struct qed_dmae_params *p_params)
 {
+	u8 src_pfid, dst_pfid, port_id;
 	u16 opcode_b = 0;
 	u32 opcode = 0;
 
@@ -407,14 +411,18 @@ static void qed_dmae_opcode(struct qed_hwfn *p_hwfn,
 	opcode |= (is_src_type_grc ? DMAE_CMD_SRC_MASK_GRC
 				   : DMAE_CMD_SRC_MASK_PCIE) <<
 		   DMAE_CMD_SRC_SHIFT;
-	opcode |= ((p_hwfn->rel_pf_id & DMAE_CMD_SRC_PF_ID_MASK) <<
+	src_pfid = QED_DMAE_FLAGS_IS_SET(p_params, PF_SRC) ?
+		   p_params->src_pfid : p_hwfn->rel_pf_id;
+	opcode |= ((src_pfid & DMAE_CMD_SRC_PF_ID_MASK) <<
 		   DMAE_CMD_SRC_PF_ID_SHIFT);
 
 	/* The destination of the DMA can be: 0-None 1-PCIe 2-GRC 3-None */
 	opcode |= (is_dst_type_grc ? DMAE_CMD_DST_MASK_GRC
 				   : DMAE_CMD_DST_MASK_PCIE) <<
 		   DMAE_CMD_DST_SHIFT;
-	opcode |= ((p_hwfn->rel_pf_id & DMAE_CMD_DST_PF_ID_MASK) <<
+	dst_pfid = QED_DMAE_FLAGS_IS_SET(p_params, PF_DST) ?
+		   p_params->dst_pfid : p_hwfn->rel_pf_id;
+	opcode |= ((dst_pfid & DMAE_CMD_DST_PF_ID_MASK) <<
 		   DMAE_CMD_DST_PF_ID_SHIFT);
 
 	/* Whether to write a completion word to the completion destination:
@@ -425,12 +433,14 @@ static void qed_dmae_opcode(struct qed_hwfn *p_hwfn,
 	opcode |= (DMAE_CMD_SRC_ADDR_RESET_MASK <<
 		   DMAE_CMD_SRC_ADDR_RESET_SHIFT);
 
-	if (p_params->flags & QED_DMAE_FLAG_COMPLETION_DST)
+	if (QED_DMAE_FLAGS_IS_SET(p_params, COMPLETION_DST))
 		opcode |= (1 << DMAE_CMD_COMP_FUNC_SHIFT);
 
 	opcode |= (DMAE_CMD_ENDIANITY << DMAE_CMD_ENDIANITY_MODE_SHIFT);
 
-	opcode |= ((p_hwfn->port_id) << DMAE_CMD_PORT_ID_SHIFT);
+	port_id = (QED_DMAE_FLAGS_IS_SET(p_params, PORT)) ?
+		   p_params->port_id : p_hwfn->port_id;
+	opcode |= (port_id << DMAE_CMD_PORT_ID_SHIFT);
 
 	/* reset source address in next go */
 	opcode |= (DMAE_CMD_SRC_ADDR_RESET_MASK <<
@@ -441,7 +451,7 @@ static void qed_dmae_opcode(struct qed_hwfn *p_hwfn,
 		   DMAE_CMD_DST_ADDR_RESET_SHIFT);
 
 	/* SRC/DST VFID: all 1's - pf, otherwise VF id */
-	if (p_params->flags & QED_DMAE_FLAG_VF_SRC) {
+	if (QED_DMAE_FLAGS_IS_SET(p_params, VF_SRC)) {
 		opcode |= 1 << DMAE_CMD_SRC_VF_ID_VALID_SHIFT;
 		opcode_b |= p_params->src_vfid << DMAE_CMD_SRC_VF_ID_SHIFT;
 	} else {
@@ -449,7 +459,7 @@ static void qed_dmae_opcode(struct qed_hwfn *p_hwfn,
 			    DMAE_CMD_SRC_VF_ID_SHIFT;
 	}
 
-	if (p_params->flags & QED_DMAE_FLAG_VF_DST) {
+	if (QED_DMAE_FLAGS_IS_SET(p_params, VF_DST)) {
 		opcode |= 1 << DMAE_CMD_DST_VF_ID_VALID_SHIFT;
 		opcode_b |= p_params->dst_vfid << DMAE_CMD_DST_VF_ID_SHIFT;
 	} else {
@@ -733,7 +743,7 @@ static int qed_dmae_execute_command(struct qed_hwfn *p_hwfn,
 	for (i = 0; i <= cnt_split; i++) {
 		offset = length_limit * i;
 
-		if (!(p_params->flags & QED_DMAE_FLAG_RW_REPL_SRC)) {
+		if (!QED_DMAE_FLAGS_IS_SET(p_params, RW_REPL_SRC)) {
 			if (src_type == QED_DMAE_ADDRESS_GRC)
 				src_addr_split = src_addr + offset;
 			else
@@ -771,14 +781,12 @@ static int qed_dmae_execute_command(struct qed_hwfn *p_hwfn,
 
 int qed_dmae_host2grc(struct qed_hwfn *p_hwfn,
 		      struct qed_ptt *p_ptt,
-		  u64 source_addr, u32 grc_addr, u32 size_in_dwords, u32 flags)
+		      u64 source_addr, u32 grc_addr, u32 size_in_dwords,
+		      struct qed_dmae_params *p_params)
 {
 	u32 grc_addr_in_dw = grc_addr / sizeof(u32);
-	struct qed_dmae_params params;
 	int rc;
 
-	memset(&params, 0, sizeof(struct qed_dmae_params));
-	params.flags = flags;
 
 	mutex_lock(&p_hwfn->dmae_info.mutex);
 
@@ -786,7 +794,7 @@ int qed_dmae_host2grc(struct qed_hwfn *p_hwfn,
 				      grc_addr_in_dw,
 				      QED_DMAE_ADDRESS_HOST_VIRT,
 				      QED_DMAE_ADDRESS_GRC,
-				      size_in_dwords, &params);
+				      size_in_dwords, p_params);
 
 	mutex_unlock(&p_hwfn->dmae_info.mutex);
 
@@ -796,21 +804,19 @@ int qed_dmae_host2grc(struct qed_hwfn *p_hwfn,
 int qed_dmae_grc2host(struct qed_hwfn *p_hwfn,
 		      struct qed_ptt *p_ptt,
 		      u32 grc_addr,
-		      dma_addr_t dest_addr, u32 size_in_dwords, u32 flags)
+		      dma_addr_t dest_addr, u32 size_in_dwords,
+		      struct qed_dmae_params *p_params)
 {
 	u32 grc_addr_in_dw = grc_addr / sizeof(u32);
-	struct qed_dmae_params params;
 	int rc;
 
-	memset(&params, 0, sizeof(struct qed_dmae_params));
-	params.flags = flags;
 
 	mutex_lock(&p_hwfn->dmae_info.mutex);
 
 	rc = qed_dmae_execute_command(p_hwfn, p_ptt, grc_addr_in_dw,
 				      dest_addr, QED_DMAE_ADDRESS_GRC,
 				      QED_DMAE_ADDRESS_HOST_VIRT,
-				      size_in_dwords, &params);
+				      size_in_dwords, p_params);
 
 	mutex_unlock(&p_hwfn->dmae_info.mutex);
 
@@ -842,7 +848,6 @@ int qed_dmae_sanity(struct qed_hwfn *p_hwfn,
 		    struct qed_ptt *p_ptt, const char *phase)
 {
 	u32 size = PAGE_SIZE / 2, val;
-	struct qed_dmae_params params;
 	int rc = 0;
 	dma_addr_t p_phys;
 	void *p_virt;
@@ -875,9 +880,9 @@ int qed_dmae_sanity(struct qed_hwfn *p_hwfn,
 		   (u64)p_phys,
 		   p_virt, (u64)(p_phys + size), (u8 *)p_virt + size, size);
 
-	memset(&params, 0, sizeof(params));
 	rc = qed_dmae_host2host(p_hwfn, p_ptt, p_phys, p_phys + size,
-				size / 4 /* size_in_dwords */, &params);
+				size / 4 /* size_in_dwords */,
+				NULL /* default parameters */);
 	if (rc) {
 		DP_NOTICE(p_hwfn,
 			  "DMAE sanity [%s]: qed_dmae_host2host() failed. rc = %d.\n",
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
index 34193c2f1699..2c6d439dcfe9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
@@ -131,7 +131,8 @@ static int qed_init_rt(struct qed_hwfn	*p_hwfn,
 
 		rc = qed_dmae_host2grc(p_hwfn, p_ptt,
 				       (uintptr_t)(p_init_val + i),
-				       addr + (i << 2), segment, 0);
+				       addr + (i << 2), segment,
+				       NULL /* default parameters */);
 		if (rc)
 			return rc;
 
@@ -194,7 +195,8 @@ static int qed_init_array_dmae(struct qed_hwfn *p_hwfn,
 	} else {
 		rc = qed_dmae_host2grc(p_hwfn, p_ptt,
 				       (uintptr_t)(buf + dmae_data_offset),
-				       addr, size, 0);
+				       addr, size,
+				       NULL /* default parameters */);
 	}
 
 	return rc;
@@ -205,6 +207,7 @@ static int qed_init_fill_dmae(struct qed_hwfn *p_hwfn,
 			      u32 addr, u32 fill, u32 fill_count)
 {
 	static u32 zero_buffer[DMAE_MAX_RW_SIZE];
+	struct qed_dmae_params params = {0};
 
 	memset(zero_buffer, 0, sizeof(u32) * DMAE_MAX_RW_SIZE);
 
@@ -214,10 +217,10 @@ static int qed_init_fill_dmae(struct qed_hwfn *p_hwfn,
 	 * 3. p_hwfb->temp_data,
 	 * 4. fill_count
 	 */
-
+	params.flags = QED_DMAE_FLAG_RW_REPL_SRC;
 	return qed_dmae_host2grc(p_hwfn, p_ptt,
 				 (uintptr_t)(&zero_buffer[0]),
-				 addr, fill_count, QED_DMAE_FLAG_RW_REPL_SRC);
+				 addr, fill_count, &params);
 }
 
 static void qed_init_fill(struct qed_hwfn *p_hwfn,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 8848d5bed6e5..41d345b4d93d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1515,10 +1515,12 @@ void qed_int_cau_conf_sb(struct qed_hwfn *p_hwfn,
 
 		qed_dmae_host2grc(p_hwfn, p_ptt, (u64)(uintptr_t)&phys_addr,
 				  CAU_REG_SB_ADDR_MEMORY +
-				  igu_sb_id * sizeof(u64), 2, 0);
+				  igu_sb_id * sizeof(u64), 2,
+				  NULL /* default parameters */);
 		qed_dmae_host2grc(p_hwfn, p_ptt, (u64)(uintptr_t)&sb_entry,
 				  CAU_REG_SB_VAR_MEMORY +
-				  igu_sb_id * sizeof(u64), 2, 0);
+				  igu_sb_id * sizeof(u64), 2,
+				  NULL /* default parameters */);
 	} else {
 		/* Initialize Status Block Address */
 		STORE_RT_REG_AGG(p_hwfn,
@@ -2375,7 +2377,8 @@ int qed_int_set_timer_res(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 
 	rc = qed_dmae_grc2host(p_hwfn, p_ptt, CAU_REG_SB_VAR_MEMORY +
 			       sb_id * sizeof(u64),
-			       (u64)(uintptr_t)&sb_entry, 2, 0);
+			       (u64)(uintptr_t)&sb_entry, 2,
+			       NULL /* default parameters */);
 	if (rc) {
 		DP_ERR(p_hwfn, "dmae_grc2host failed %d\n", rc);
 		return rc;
@@ -2389,7 +2392,8 @@ int qed_int_set_timer_res(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
 	rc = qed_dmae_host2grc(p_hwfn, p_ptt,
 			       (u64)(uintptr_t)&sb_entry,
 			       CAU_REG_SB_VAR_MEMORY +
-			       sb_id * sizeof(u64), 2, 0);
+			       sb_id * sizeof(u64), 2,
+			       NULL /* default parameters */);
 	if (rc) {
 		DP_ERR(p_hwfn, "dmae_host2grc failed %d\n", rc);
 		return rc;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 57641728df69..5439d7fcba79 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -2111,7 +2111,8 @@ int qed_get_rxq_coalesce(struct qed_hwfn *p_hwfn,
 
 	rc = qed_dmae_grc2host(p_hwfn, p_ptt, CAU_REG_SB_VAR_MEMORY +
 			       p_cid->sb_igu_id * sizeof(u64),
-			       (u64)(uintptr_t)&sb_entry, 2, 0);
+			       (u64)(uintptr_t)&sb_entry, 2,
+			       NULL /* default parameters */);
 	if (rc) {
 		DP_ERR(p_hwfn, "dmae_grc2host failed %d\n", rc);
 		return rc;
@@ -2144,7 +2145,8 @@ int qed_get_txq_coalesce(struct qed_hwfn *p_hwfn,
 
 	rc = qed_dmae_grc2host(p_hwfn, p_ptt, CAU_REG_SB_VAR_MEMORY +
 			       p_cid->sb_igu_id * sizeof(u64),
-			       (u64)(uintptr_t)&sb_entry, 2, 0);
+			       (u64)(uintptr_t)&sb_entry, 2,
+			       NULL /* default parameters */);
 	if (rc) {
 		DP_ERR(p_hwfn, "dmae_grc2host failed %d\n", rc);
 		return rc;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 2f318aaf2b05..fcb6056d7dcc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -917,10 +917,12 @@ static u8 qed_iov_alloc_vf_igu_sbs(struct qed_hwfn *p_hwfn,
 		/* Configure igu sb in CAU which were marked valid */
 		qed_init_cau_sb_entry(p_hwfn, &sb_entry,
 				      p_hwfn->rel_pf_id, vf->abs_vf_id, 1);
+
 		qed_dmae_host2grc(p_hwfn, p_ptt,
 				  (u64)(uintptr_t)&sb_entry,
 				  CAU_REG_SB_VAR_MEMORY +
-				  p_block->igu_sb_id * sizeof(u64), 2, 0);
+				  p_block->igu_sb_id * sizeof(u64), 2,
+				  NULL /* default parameters */);
 	}
 
 	vf->num_sbs = (u8) num_rx_queues;
-- 
2.14.5

