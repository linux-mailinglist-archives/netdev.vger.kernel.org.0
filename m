Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D31414661D
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgAWK7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:59:11 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53434 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729058AbgAWK7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:59:10 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NAux3O021434;
        Thu, 23 Jan 2020 02:59:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=hOBnMSVOTrofEzNMJlWAxTdqQlkPi9Rc6vaII6o+Waw=;
 b=wLPdby2gyDG46a5euQs/4KJ4I2olY8eVT3I6vqhBwcZtIN9qJNgjd9uGS80ohtg+qfI4
 2xUDzJBPz7H0yguxLdYCnaDUgsqDzR2QOw211GDOpMBBZ7SKBMMX/eixgzKcMsfAgF3D
 iWBPVjxjJyeO3C2Zuquwsml0AGGXTW9Pg/+/Z0iMBf8T7mTNVJ5KSjzOyCo+jbQ6NKt9
 e+aVt/T/M1wSK5VyizI4m5GSpwNBnnonYcG9mEpZjZqwJyG+AwmDwBQl37OesXrAqxnd
 pT4hSy0nMpWIsyFtdGtYnkRrSVgm6AnnuK14FjFib7COKEDQ3z2esmQVQHcqKXxolkqN Sg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xq4x4h2yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jan 2020 02:59:08 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jan
 2020 02:59:07 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Jan 2020 02:59:06 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 4872F3F7040;
        Thu, 23 Jan 2020 02:59:05 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 10/13] qed: FW 8.42.2.0 Add fw overlay feature
Date:   Thu, 23 Jan 2020 12:58:33 +0200
Message-ID: <20200123105836.15090-11-michal.kalderon@marvell.com>
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

This feature enables the FW to page out FW code when required

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h              |   3 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  18 ++-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h          |  58 +++++++++
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    | 141 +++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c     |   5 +
 5 files changed, 224 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index cfbfe7441ecb..fedb1ab0b223 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -462,6 +462,8 @@ struct qed_fw_data {
 	const u8		*modes_tree_buf;
 	union init_op		*init_ops;
 	const u32		*arr_data;
+	const u32		*fw_overlays;
+	u32			fw_overlays_len;
 	u32			init_ops_size;
 };
 
@@ -686,6 +688,7 @@ struct qed_hwfn {
 	/* Nvm images number and attributes */
 	struct qed_nvm_image_info nvm_info;
 
+	struct phys_mem_desc *fw_overlay_mem;
 	struct qed_ptt *p_arfs_ptt;
 
 	struct qed_simd_fp_handler	simd_proto_handler[64];
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index e3e0376c13d6..df97810b09b9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -1412,6 +1412,7 @@ void qed_resc_free(struct qed_dev *cdev)
 		qed_dmae_info_free(p_hwfn);
 		qed_dcbx_info_free(p_hwfn);
 		qed_dbg_user_data_free(p_hwfn);
+		qed_fw_overlay_mem_free(p_hwfn, p_hwfn->fw_overlay_mem);
 
 		/* Destroy doorbell recovery mechanism */
 		qed_db_recovery_teardown(p_hwfn);
@@ -2893,6 +2894,8 @@ static int qed_hw_init_pf(struct qed_hwfn *p_hwfn,
 	if (rc)
 		return rc;
 
+	qed_fw_overlay_init_ram(p_hwfn, p_ptt, p_hwfn->fw_overlay_mem);
+
 	/* Pure runtime initializations - directly to the HW  */
 	qed_int_igu_init_pure_rt(p_hwfn, p_ptt, true, true);
 
@@ -3002,8 +3005,10 @@ int qed_hw_init(struct qed_dev *cdev, struct qed_hw_init_params *p_params)
 	u32 load_code, resp, param, drv_mb_param;
 	bool b_default_mtu = true;
 	struct qed_hwfn *p_hwfn;
-	int rc = 0, i;
+	const u32 *fw_overlays;
+	u32 fw_overlays_len;
 	u16 ether_type;
+	int rc = 0, i;
 
 	if ((p_params->int_mode == QED_INT_MODE_MSI) && (cdev->num_hwfns > 1)) {
 		DP_NOTICE(cdev, "MSI mode is not supported for CMT devices\n");
@@ -3104,6 +3109,17 @@ int qed_hw_init(struct qed_dev *cdev, struct qed_hw_init_params *p_params)
 		 */
 		qed_pglueb_clear_err(p_hwfn, p_hwfn->p_main_ptt);
 
+		fw_overlays = cdev->fw_data->fw_overlays;
+		fw_overlays_len = cdev->fw_data->fw_overlays_len;
+		p_hwfn->fw_overlay_mem =
+		    qed_fw_overlay_mem_alloc(p_hwfn, fw_overlays,
+					     fw_overlays_len);
+		if (!p_hwfn->fw_overlay_mem) {
+			DP_NOTICE(p_hwfn,
+				  "Failed to allocate fw overlay memory\n");
+			goto load_err;
+		}
+
 		switch (load_code) {
 		case FW_MSG_CODE_DRV_LOAD_ENGINE:
 			rc = qed_hw_init_common(p_hwfn, p_hwfn->p_main_ptt,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 2f269576d3b2..e9b88952a7ed 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -1843,6 +1843,19 @@ struct sdm_op_gen {
 #define SDM_OP_GEN_RESERVED_SHIFT	20
 };
 
+/* Physical memory descriptor */
+struct phys_mem_desc {
+	dma_addr_t phys_addr;
+	void *virt_addr;
+	u32 size;		/* In bytes */
+};
+
+/* Virtual memory descriptor */
+struct virt_mem_desc {
+	void *ptr;
+	u32 size;		/* In bytes */
+};
+
 /****************************************/
 /* Debug Tools HSI constants and macros */
 /****************************************/
@@ -2872,6 +2885,15 @@ enum bin_init_buffer_type {
 	MAX_BIN_INIT_BUFFER_TYPE
 };
 
+/* FW overlay buffer header */
+struct fw_overlay_buf_hdr {
+	u32 data;
+#define FW_OVERLAY_BUF_HDR_STORM_ID_MASK  0xFF
+#define FW_OVERLAY_BUF_HDR_STORM_ID_SHIFT 0
+#define FW_OVERLAY_BUF_HDR_BUF_SIZE_MASK  0xFFFFFF
+#define FW_OVERLAY_BUF_HDR_BUF_SIZE_SHIFT 8
+};
+
 /* init array header: raw */
 struct init_array_raw_hdr {
 	u32 data;
@@ -4346,6 +4368,42 @@ void qed_memset_task_ctx(void *p_ctx_mem, u32 ctx_size, u8 ctx_type);
 void qed_set_rdma_error_level(struct qed_hwfn *p_hwfn,
 			      struct qed_ptt *p_ptt,
 			      u8 assert_level[NUM_STORMS]);
+/**
+ * @brief qed_fw_overlay_mem_alloc - Allocates and fills the FW overlay memory.
+ *
+ * @param p_hwfn - HW device data
+ * @param fw_overlay_in_buf - the input FW overlay buffer.
+ * @param buf_size - the size of the input FW overlay buffer in bytes.
+ *		     must be aligned to dwords.
+ * @param fw_overlay_out_mem - OUT: a pointer to the allocated overlays memory.
+ *
+ * @return a pointer to the allocated overlays memory,
+ * or NULL in case of failures.
+ */
+struct phys_mem_desc *
+qed_fw_overlay_mem_alloc(struct qed_hwfn *p_hwfn,
+			 const u32 * const fw_overlay_in_buf,
+			 u32 buf_size_in_bytes);
+
+/**
+ * @brief qed_fw_overlay_init_ram - Initializes the FW overlay RAM.
+ *
+ * @param p_hwfn - HW device data.
+ * @param p_ptt - ptt window used for writing the registers.
+ * @param fw_overlay_mem - the allocated FW overlay memory.
+ */
+void qed_fw_overlay_init_ram(struct qed_hwfn *p_hwfn,
+			     struct qed_ptt *p_ptt,
+			     struct phys_mem_desc *fw_overlay_mem);
+
+/**
+ * @brief qed_fw_overlay_mem_free - Frees the FW overlay memory.
+ *
+ * @param p_hwfn - HW device data.
+ * @param fw_overlay_mem - the allocated FW overlay memory to free.
+ */
+void qed_fw_overlay_mem_free(struct qed_hwfn *p_hwfn,
+			     struct phys_mem_desc *fw_overlay_mem);
 
 /* Ystorm flow control mode. Use enum fw_flow_ctrl_mode */
 #define YSTORM_FLOW_CONTROL_MODE_OFFSET			(IRO[0].base)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index e09e6ce74705..9aacee539da1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -1583,3 +1583,144 @@ void qed_set_rdma_error_level(struct qed_hwfn *p_hwfn,
 		qed_wr(p_hwfn, p_ptt, ram_addr, assert_level[storm_id]);
 	}
 }
+
+#define PHYS_ADDR_DWORDS        DIV_ROUND_UP(sizeof(dma_addr_t), 4)
+#define OVERLAY_HDR_SIZE_DWORDS (sizeof(struct fw_overlay_buf_hdr) / 4)
+
+static u32 qed_get_overlay_addr_ram_addr(struct qed_hwfn *p_hwfn, u8 storm_id)
+{
+	switch (storm_id) {
+	case 0:
+		return TSEM_REG_FAST_MEMORY + SEM_FAST_REG_INT_RAM +
+		    TSTORM_OVERLAY_BUF_ADDR_OFFSET;
+	case 1:
+		return MSEM_REG_FAST_MEMORY + SEM_FAST_REG_INT_RAM +
+		    MSTORM_OVERLAY_BUF_ADDR_OFFSET;
+	case 2:
+		return USEM_REG_FAST_MEMORY + SEM_FAST_REG_INT_RAM +
+		    USTORM_OVERLAY_BUF_ADDR_OFFSET;
+	case 3:
+		return XSEM_REG_FAST_MEMORY + SEM_FAST_REG_INT_RAM +
+		    XSTORM_OVERLAY_BUF_ADDR_OFFSET;
+	case 4:
+		return YSEM_REG_FAST_MEMORY + SEM_FAST_REG_INT_RAM +
+		    YSTORM_OVERLAY_BUF_ADDR_OFFSET;
+	case 5:
+		return PSEM_REG_FAST_MEMORY + SEM_FAST_REG_INT_RAM +
+		    PSTORM_OVERLAY_BUF_ADDR_OFFSET;
+
+	default:
+		return 0;
+	}
+}
+
+struct phys_mem_desc *qed_fw_overlay_mem_alloc(struct qed_hwfn *p_hwfn,
+					       const u32 * const
+					       fw_overlay_in_buf,
+					       u32 buf_size_in_bytes)
+{
+	u32 buf_size = buf_size_in_bytes / sizeof(u32), buf_offset = 0;
+	struct phys_mem_desc *allocated_mem;
+
+	if (!buf_size)
+		return NULL;
+
+	allocated_mem = kcalloc(NUM_STORMS, sizeof(struct phys_mem_desc),
+				GFP_KERNEL);
+	if (!allocated_mem)
+		return NULL;
+
+	memset(allocated_mem, 0, NUM_STORMS * sizeof(struct phys_mem_desc));
+
+	/* For each Storm, set physical address in RAM */
+	while (buf_offset < buf_size) {
+		struct phys_mem_desc *storm_mem_desc;
+		struct fw_overlay_buf_hdr *hdr;
+		u32 storm_buf_size;
+		u8 storm_id;
+
+		hdr =
+		    (struct fw_overlay_buf_hdr *)&fw_overlay_in_buf[buf_offset];
+		storm_buf_size = GET_FIELD(hdr->data,
+					   FW_OVERLAY_BUF_HDR_BUF_SIZE);
+		storm_id = GET_FIELD(hdr->data, FW_OVERLAY_BUF_HDR_STORM_ID);
+		storm_mem_desc = allocated_mem + storm_id;
+		storm_mem_desc->size = storm_buf_size * sizeof(u32);
+
+		/* Allocate physical memory for Storm's overlays buffer */
+		storm_mem_desc->virt_addr =
+		    dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+				       storm_mem_desc->size,
+				       &storm_mem_desc->phys_addr, GFP_KERNEL);
+		if (!storm_mem_desc->virt_addr)
+			break;
+
+		/* Skip overlays buffer header */
+		buf_offset += OVERLAY_HDR_SIZE_DWORDS;
+
+		/* Copy Storm's overlays buffer to allocated memory */
+		memcpy(storm_mem_desc->virt_addr,
+		       &fw_overlay_in_buf[buf_offset], storm_mem_desc->size);
+
+		/* Advance to next Storm */
+		buf_offset += storm_buf_size;
+	}
+
+	/* If memory allocation has failed, free all allocated memory */
+	if (buf_offset < buf_size) {
+		qed_fw_overlay_mem_free(p_hwfn, allocated_mem);
+		return NULL;
+	}
+
+	return allocated_mem;
+}
+
+void qed_fw_overlay_init_ram(struct qed_hwfn *p_hwfn,
+			     struct qed_ptt *p_ptt,
+			     struct phys_mem_desc *fw_overlay_mem)
+{
+	u8 storm_id;
+
+	for (storm_id = 0; storm_id < NUM_STORMS; storm_id++) {
+		struct phys_mem_desc *storm_mem_desc =
+		    (struct phys_mem_desc *)fw_overlay_mem + storm_id;
+		u32 ram_addr, i;
+
+		/* Skip Storms with no FW overlays */
+		if (!storm_mem_desc->virt_addr)
+			continue;
+
+		/* Calculate overlay RAM GRC address of current PF */
+		ram_addr = qed_get_overlay_addr_ram_addr(p_hwfn, storm_id) +
+			   sizeof(dma_addr_t) * p_hwfn->rel_pf_id;
+
+		/* Write Storm's overlay physical address to RAM */
+		for (i = 0; i < PHYS_ADDR_DWORDS; i++, ram_addr += sizeof(u32))
+			qed_wr(p_hwfn, p_ptt, ram_addr,
+			       ((u32 *)&storm_mem_desc->phys_addr)[i]);
+	}
+}
+
+void qed_fw_overlay_mem_free(struct qed_hwfn *p_hwfn,
+			     struct phys_mem_desc *fw_overlay_mem)
+{
+	u8 storm_id;
+
+	if (!fw_overlay_mem)
+		return;
+
+	for (storm_id = 0; storm_id < NUM_STORMS; storm_id++) {
+		struct phys_mem_desc *storm_mem_desc =
+		    (struct phys_mem_desc *)fw_overlay_mem + storm_id;
+
+		/* Free Storm's physical memory */
+		if (storm_mem_desc->virt_addr)
+			dma_free_coherent(&p_hwfn->cdev->pdev->dev,
+					  storm_mem_desc->size,
+					  storm_mem_desc->virt_addr,
+					  storm_mem_desc->phys_addr);
+	}
+
+	/* Free allocated virtual memory */
+	kfree(fw_overlay_mem);
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
index 5ca117a8734a..36f998c89e74 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
@@ -589,5 +589,10 @@ int qed_init_fw_data(struct qed_dev *cdev, const u8 *data)
 	len = buf_hdr[BIN_BUF_INIT_CMD].length;
 	fw->init_ops_size = len / sizeof(struct init_raw_op);
 
+	offset = buf_hdr[BIN_BUF_INIT_OVERLAYS].offset;
+	fw->fw_overlays = (u32 *)(data + offset);
+	len = buf_hdr[BIN_BUF_INIT_OVERLAYS].length;
+	fw->fw_overlays_len = len;
+
 	return 0;
 }
-- 
2.14.5

