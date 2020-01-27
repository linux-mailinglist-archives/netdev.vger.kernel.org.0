Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669CD14A505
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgA0N07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:26:59 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37326 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729113AbgA0N06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:26:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00RDQ4xT006895;
        Mon, 27 Jan 2020 05:26:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=K7WrJM57Qxlp++Uraf/fEURBOmbi+y5l2GEFsTC9Sg0=;
 b=fFfNEt8r2Dv7GZff1kXbr/EfGHvEqVPFz8FvUpU/Y+ctT1wMufxQUhWtqpgabIbYGmO0
 FRER3XXZraVfPcr3bhhzr7YfcCYpePwOcZPu7x89eXHEtrMmXphw35X4v0D0cIFgLGTA
 HzZ1Lr0Qa4rEeAubrZwVmkdJjQr4FcPeJ6bh0lIh/uZzAr50eNSu8Dmk0oz/gkC8AXWP
 TA9bClTP4rI62NZisT43O+Wu2DuPATHuGUsjiA4aP7HB4wiaMcc9uJb0etBFiBUndzft
 m5PeplymsktwxiefCoVzZsghNzBdVeJcwTkR5tGsOIrQZlajWwBdBj7dFdTs7z9a3SLL KQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xrkwufdva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jan 2020 05:26:54 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jan
 2020 05:26:53 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Jan 2020 05:26:53 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 58F763F703F;
        Mon, 27 Jan 2020 05:26:51 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v3 net-next 11/13] qed: Debug feature: ilt and mdump
Date:   Mon, 27 Jan 2020 15:26:17 +0200
Message-ID: <20200127132619.27144-12-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200127132619.27144-1-michal.kalderon@marvell.com>
References: <20200127132619.27144-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-27_02:2020-01-24,2020-01-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Part of the FW drop includes new debug capabilities implemented in the
qed_debug file. This patch dumps additional information during ethtool -d
for better debugging. The data dumped is the ilt (internal logical table)
and information gathered by the management firmware incase there was a
crash and driver was not able to extract the information (mdump).

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h       |   1 +
 drivers/net/ethernet/qlogic/qed/qed_cxt.c   | 357 +++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_cxt.h   | 130 +++++++
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 521 +++++++++++++++++++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_debug.h |   4 +
 drivers/net/ethernet/qlogic/qed/qed_hsi.h   |  18 +
 drivers/net/ethernet/qlogic/qed/qed_mcp.c   |   3 +
 include/linux/qed/qed_if.h                  |   1 +
 8 files changed, 821 insertions(+), 214 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index fedb1ab0b223..a6dc40681a32 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -877,6 +877,7 @@ struct qed_dev {
 	struct qed_cb_ll2_info		*ll2;
 	u8				ll2_mac_address[ETH_ALEN];
 #endif
+	bool disable_ilt_dump;
 	DECLARE_HASHTABLE(connections, 10);
 	const struct firmware		*firmware;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 5ebafbc379db..fbfff2b1dc93 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -50,12 +50,6 @@
 #include "qed_reg_addr.h"
 #include "qed_sriov.h"
 
-/* Max number of connection types in HW (DQ/CDU etc.) */
-#define MAX_CONN_TYPES		PROTOCOLID_COMMON
-#define NUM_TASK_TYPES		2
-#define NUM_TASK_PF_SEGMENTS	4
-#define NUM_TASK_VF_SEGMENTS	1
-
 /* QM constants */
 #define QM_PQ_ELEMENT_SIZE	4 /* in bytes */
 
@@ -123,126 +117,6 @@ struct src_ent {
 /* Alignment is inherent to the type1_task_context structure */
 #define TYPE1_TASK_CXT_SIZE(p_hwfn) sizeof(union type1_task_context)
 
-/* PF per protocl configuration object */
-#define TASK_SEGMENTS   (NUM_TASK_PF_SEGMENTS + NUM_TASK_VF_SEGMENTS)
-#define TASK_SEGMENT_VF (NUM_TASK_PF_SEGMENTS)
-
-struct qed_tid_seg {
-	u32 count;
-	u8 type;
-	bool has_fl_mem;
-};
-
-struct qed_conn_type_cfg {
-	u32 cid_count;
-	u32 cids_per_vf;
-	struct qed_tid_seg tid_seg[TASK_SEGMENTS];
-};
-
-/* ILT Client configuration, Per connection type (protocol) resources. */
-#define ILT_CLI_PF_BLOCKS	(1 + NUM_TASK_PF_SEGMENTS * 2)
-#define ILT_CLI_VF_BLOCKS       (1 + NUM_TASK_VF_SEGMENTS * 2)
-#define CDUC_BLK		(0)
-#define SRQ_BLK                 (0)
-#define CDUT_SEG_BLK(n)         (1 + (u8)(n))
-#define CDUT_FL_SEG_BLK(n, X)   (1 + (n) + NUM_TASK_ ## X ## _SEGMENTS)
-
-enum ilt_clients {
-	ILT_CLI_CDUC,
-	ILT_CLI_CDUT,
-	ILT_CLI_QM,
-	ILT_CLI_TM,
-	ILT_CLI_SRC,
-	ILT_CLI_TSDM,
-	ILT_CLI_MAX
-};
-
-struct ilt_cfg_pair {
-	u32 reg;
-	u32 val;
-};
-
-struct qed_ilt_cli_blk {
-	u32 total_size; /* 0 means not active */
-	u32 real_size_in_page;
-	u32 start_line;
-	u32 dynamic_line_cnt;
-};
-
-struct qed_ilt_client_cfg {
-	bool active;
-
-	/* ILT boundaries */
-	struct ilt_cfg_pair first;
-	struct ilt_cfg_pair last;
-	struct ilt_cfg_pair p_size;
-
-	/* ILT client blocks for PF */
-	struct qed_ilt_cli_blk pf_blks[ILT_CLI_PF_BLOCKS];
-	u32 pf_total_lines;
-
-	/* ILT client blocks for VFs */
-	struct qed_ilt_cli_blk vf_blks[ILT_CLI_VF_BLOCKS];
-	u32 vf_total_lines;
-};
-
-/* Per Path -
- *      ILT shadow table
- *      Protocol acquired CID lists
- *      PF start line in ILT
- */
-struct qed_dma_mem {
-	dma_addr_t p_phys;
-	void *p_virt;
-	size_t size;
-};
-
-struct qed_cid_acquired_map {
-	u32		start_cid;
-	u32		max_count;
-	unsigned long	*cid_map;
-};
-
-struct qed_cxt_mngr {
-	/* Per protocl configuration */
-	struct qed_conn_type_cfg	conn_cfg[MAX_CONN_TYPES];
-
-	/* computed ILT structure */
-	struct qed_ilt_client_cfg	clients[ILT_CLI_MAX];
-
-	/* Task type sizes */
-	u32 task_type_size[NUM_TASK_TYPES];
-
-	/* total number of VFs for this hwfn -
-	 * ALL VFs are symmetric in terms of HW resources
-	 */
-	u32				vf_count;
-
-	/* Acquired CIDs */
-	struct qed_cid_acquired_map	acquired[MAX_CONN_TYPES];
-
-	struct qed_cid_acquired_map
-	acquired_vf[MAX_CONN_TYPES][MAX_NUM_VFS];
-
-	/* ILT  shadow table */
-	struct qed_dma_mem		*ilt_shadow;
-	u32				pf_start_line;
-
-	/* Mutex for a dynamic ILT allocation */
-	struct mutex mutex;
-
-	/* SRC T2 */
-	struct qed_dma_mem *t2;
-	u32 t2_num_pages;
-	u64 first_free;
-	u64 last_free;
-
-	/* total number of SRQ's for this hwfn */
-	u32 srq_count;
-
-	/* Maximal number of L2 steering filters */
-	u32 arfs_count;
-};
 static bool src_proto(enum protocol_type type)
 {
 	return type == PROTOCOLID_ISCSI ||
@@ -880,30 +754,60 @@ u32 qed_cxt_cfg_ilt_compute_excess(struct qed_hwfn *p_hwfn, u32 used_lines)
 
 static void qed_cxt_src_t2_free(struct qed_hwfn *p_hwfn)
 {
-	struct qed_cxt_mngr *p_mngr = p_hwfn->p_cxt_mngr;
+	struct qed_src_t2 *p_t2 = &p_hwfn->p_cxt_mngr->src_t2;
 	u32 i;
 
-	if (!p_mngr->t2)
+	if (!p_t2 || !p_t2->dma_mem)
 		return;
 
-	for (i = 0; i < p_mngr->t2_num_pages; i++)
-		if (p_mngr->t2[i].p_virt)
+	for (i = 0; i < p_t2->num_pages; i++)
+		if (p_t2->dma_mem[i].virt_addr)
 			dma_free_coherent(&p_hwfn->cdev->pdev->dev,
-					  p_mngr->t2[i].size,
-					  p_mngr->t2[i].p_virt,
-					  p_mngr->t2[i].p_phys);
+					  p_t2->dma_mem[i].size,
+					  p_t2->dma_mem[i].virt_addr,
+					  p_t2->dma_mem[i].phys_addr);
+
+	kfree(p_t2->dma_mem);
+	p_t2->dma_mem = NULL;
+}
+
+static int
+qed_cxt_t2_alloc_pages(struct qed_hwfn *p_hwfn,
+		       struct qed_src_t2 *p_t2, u32 total_size, u32 page_size)
+{
+	void **p_virt;
+	u32 size, i;
+
+	if (!p_t2 || !p_t2->dma_mem)
+		return -EINVAL;
 
-	kfree(p_mngr->t2);
-	p_mngr->t2 = NULL;
+	for (i = 0; i < p_t2->num_pages; i++) {
+		size = min_t(u32, total_size, page_size);
+		p_virt = &p_t2->dma_mem[i].virt_addr;
+
+		*p_virt = dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+					     size,
+					     &p_t2->dma_mem[i].phys_addr,
+					     GFP_KERNEL);
+		if (!p_t2->dma_mem[i].virt_addr)
+			return -ENOMEM;
+
+		memset(*p_virt, 0, size);
+		p_t2->dma_mem[i].size = size;
+		total_size -= size;
+	}
+
+	return 0;
 }
 
 static int qed_cxt_src_t2_alloc(struct qed_hwfn *p_hwfn)
 {
 	struct qed_cxt_mngr *p_mngr = p_hwfn->p_cxt_mngr;
 	u32 conn_num, total_size, ent_per_page, psz, i;
+	struct phys_mem_desc *p_t2_last_page;
 	struct qed_ilt_client_cfg *p_src;
 	struct qed_src_iids src_iids;
-	struct qed_dma_mem *p_t2;
+	struct qed_src_t2 *p_t2;
 	int rc;
 
 	memset(&src_iids, 0, sizeof(src_iids));
@@ -921,49 +825,39 @@ static int qed_cxt_src_t2_alloc(struct qed_hwfn *p_hwfn)
 
 	/* use the same page size as the SRC ILT client */
 	psz = ILT_PAGE_IN_BYTES(p_src->p_size.val);
-	p_mngr->t2_num_pages = DIV_ROUND_UP(total_size, psz);
+	p_t2 = &p_mngr->src_t2;
+	p_t2->num_pages = DIV_ROUND_UP(total_size, psz);
 
 	/* allocate t2 */
-	p_mngr->t2 = kcalloc(p_mngr->t2_num_pages, sizeof(struct qed_dma_mem),
-			     GFP_KERNEL);
-	if (!p_mngr->t2) {
+	p_t2->dma_mem = kcalloc(p_t2->num_pages, sizeof(struct phys_mem_desc),
+				GFP_KERNEL);
+	if (!p_t2->dma_mem) {
+		DP_NOTICE(p_hwfn, "Failed to allocate t2 table\n");
 		rc = -ENOMEM;
 		goto t2_fail;
 	}
 
-	/* allocate t2 pages */
-	for (i = 0; i < p_mngr->t2_num_pages; i++) {
-		u32 size = min_t(u32, total_size, psz);
-		void **p_virt = &p_mngr->t2[i].p_virt;
-
-		*p_virt = dma_alloc_coherent(&p_hwfn->cdev->pdev->dev, size,
-					     &p_mngr->t2[i].p_phys,
-					     GFP_KERNEL);
-		if (!p_mngr->t2[i].p_virt) {
-			rc = -ENOMEM;
-			goto t2_fail;
-		}
-		p_mngr->t2[i].size = size;
-		total_size -= size;
-	}
+	rc = qed_cxt_t2_alloc_pages(p_hwfn, p_t2, total_size, psz);
+	if (rc)
+		goto t2_fail;
 
 	/* Set the t2 pointers */
 
 	/* entries per page - must be a power of two */
 	ent_per_page = psz / sizeof(struct src_ent);
 
-	p_mngr->first_free = (u64) p_mngr->t2[0].p_phys;
+	p_t2->first_free = (u64)p_t2->dma_mem[0].phys_addr;
 
-	p_t2 = &p_mngr->t2[(conn_num - 1) / ent_per_page];
-	p_mngr->last_free = (u64) p_t2->p_phys +
+	p_t2_last_page = &p_t2->dma_mem[(conn_num - 1) / ent_per_page];
+	p_t2->last_free = (u64)p_t2_last_page->phys_addr +
 	    ((conn_num - 1) & (ent_per_page - 1)) * sizeof(struct src_ent);
 
-	for (i = 0; i < p_mngr->t2_num_pages; i++) {
+	for (i = 0; i < p_t2->num_pages; i++) {
 		u32 ent_num = min_t(u32,
 				    ent_per_page,
 				    conn_num);
-		struct src_ent *entries = p_mngr->t2[i].p_virt;
-		u64 p_ent_phys = (u64) p_mngr->t2[i].p_phys, val;
+		struct src_ent *entries = p_t2->dma_mem[i].virt_addr;
+		u64 p_ent_phys = (u64)p_t2->dma_mem[i].phys_addr, val;
 		u32 j;
 
 		for (j = 0; j < ent_num - 1; j++) {
@@ -971,8 +865,8 @@ static int qed_cxt_src_t2_alloc(struct qed_hwfn *p_hwfn)
 			entries[j].next = cpu_to_be64(val);
 		}
 
-		if (i < p_mngr->t2_num_pages - 1)
-			val = (u64) p_mngr->t2[i + 1].p_phys;
+		if (i < p_t2->num_pages - 1)
+			val = (u64)p_t2->dma_mem[i + 1].phys_addr;
 		else
 			val = 0;
 		entries[j].next = cpu_to_be64(val);
@@ -988,7 +882,7 @@ static int qed_cxt_src_t2_alloc(struct qed_hwfn *p_hwfn)
 }
 
 #define for_each_ilt_valid_client(pos, clients)	\
-	for (pos = 0; pos < ILT_CLI_MAX; pos++)	\
+	for (pos = 0; pos < MAX_ILT_CLIENTS; pos++)	\
 		if (!clients[pos].active) {	\
 			continue;		\
 		} else				\
@@ -1014,13 +908,13 @@ static void qed_ilt_shadow_free(struct qed_hwfn *p_hwfn)
 	ilt_size = qed_cxt_ilt_shadow_size(p_cli);
 
 	for (i = 0; p_mngr->ilt_shadow && i < ilt_size; i++) {
-		struct qed_dma_mem *p_dma = &p_mngr->ilt_shadow[i];
+		struct phys_mem_desc *p_dma = &p_mngr->ilt_shadow[i];
 
-		if (p_dma->p_virt)
+		if (p_dma->virt_addr)
 			dma_free_coherent(&p_hwfn->cdev->pdev->dev,
-					  p_dma->size, p_dma->p_virt,
-					  p_dma->p_phys);
-		p_dma->p_virt = NULL;
+					  p_dma->size, p_dma->virt_addr,
+					  p_dma->phys_addr);
+		p_dma->virt_addr = NULL;
 	}
 	kfree(p_mngr->ilt_shadow);
 }
@@ -1030,7 +924,7 @@ static int qed_ilt_blk_alloc(struct qed_hwfn *p_hwfn,
 			     enum ilt_clients ilt_client,
 			     u32 start_line_offset)
 {
-	struct qed_dma_mem *ilt_shadow = p_hwfn->p_cxt_mngr->ilt_shadow;
+	struct phys_mem_desc *ilt_shadow = p_hwfn->p_cxt_mngr->ilt_shadow;
 	u32 lines, line, sz_left, lines_to_skip = 0;
 
 	/* Special handling for RoCE that supports dynamic allocation */
@@ -1059,8 +953,8 @@ static int qed_ilt_blk_alloc(struct qed_hwfn *p_hwfn,
 		if (!p_virt)
 			return -ENOMEM;
 
-		ilt_shadow[line].p_phys = p_phys;
-		ilt_shadow[line].p_virt = p_virt;
+		ilt_shadow[line].phys_addr = p_phys;
+		ilt_shadow[line].virt_addr = p_virt;
 		ilt_shadow[line].size = size;
 
 		DP_VERBOSE(p_hwfn, QED_MSG_ILT,
@@ -1083,7 +977,7 @@ static int qed_ilt_shadow_alloc(struct qed_hwfn *p_hwfn)
 	int rc;
 
 	size = qed_cxt_ilt_shadow_size(clients);
-	p_mngr->ilt_shadow = kcalloc(size, sizeof(struct qed_dma_mem),
+	p_mngr->ilt_shadow = kcalloc(size, sizeof(struct phys_mem_desc),
 				     GFP_KERNEL);
 	if (!p_mngr->ilt_shadow) {
 		rc = -ENOMEM;
@@ -1092,7 +986,7 @@ static int qed_ilt_shadow_alloc(struct qed_hwfn *p_hwfn)
 
 	DP_VERBOSE(p_hwfn, QED_MSG_ILT,
 		   "Allocated 0x%x bytes for ilt shadow\n",
-		   (u32)(size * sizeof(struct qed_dma_mem)));
+		   (u32)(size * sizeof(struct phys_mem_desc)));
 
 	for_each_ilt_valid_client(i, clients) {
 		for (j = 0; j < ILT_CLI_PF_BLOCKS; j++) {
@@ -1238,15 +1132,20 @@ int qed_cxt_mngr_alloc(struct qed_hwfn *p_hwfn)
 	clients[ILT_CLI_TSDM].last.reg = ILT_CFG_REG(TSDM, LAST_ILT);
 	clients[ILT_CLI_TSDM].p_size.reg = ILT_CFG_REG(TSDM, P_SIZE);
 	/* default ILT page size for all clients is 64K */
-	for (i = 0; i < ILT_CLI_MAX; i++)
+	for (i = 0; i < MAX_ILT_CLIENTS; i++)
 		p_mngr->clients[i].p_size.val = ILT_DEFAULT_HW_P_SIZE;
 
+	p_mngr->conn_ctx_size = CONN_CXT_SIZE(p_hwfn);
+
 	/* Initialize task sizes */
 	p_mngr->task_type_size[0] = TYPE0_TASK_CXT_SIZE(p_hwfn);
 	p_mngr->task_type_size[1] = TYPE1_TASK_CXT_SIZE(p_hwfn);
 
-	if (p_hwfn->cdev->p_iov_info)
+	if (p_hwfn->cdev->p_iov_info) {
 		p_mngr->vf_count = p_hwfn->cdev->p_iov_info->total_vfs;
+		p_mngr->first_vf_in_pf =
+			p_hwfn->cdev->p_iov_info->first_vf_in_pf;
+	}
 	/* Initialize the dynamic ILT allocation mutex */
 	mutex_init(&p_mngr->mutex);
 
@@ -1673,7 +1572,7 @@ static void qed_ilt_init_pf(struct qed_hwfn *p_hwfn)
 {
 	struct qed_ilt_client_cfg *clients;
 	struct qed_cxt_mngr *p_mngr;
-	struct qed_dma_mem *p_shdw;
+	struct phys_mem_desc *p_shdw;
 	u32 line, rt_offst, i;
 
 	qed_ilt_bounds_init(p_hwfn);
@@ -1698,15 +1597,15 @@ static void qed_ilt_init_pf(struct qed_hwfn *p_hwfn)
 			/** p_virt could be NULL incase of dynamic
 			 *  allocation
 			 */
-			if (p_shdw[line].p_virt) {
+			if (p_shdw[line].virt_addr) {
 				SET_FIELD(ilt_hw_entry, ILT_ENTRY_VALID, 1ULL);
 				SET_FIELD(ilt_hw_entry, ILT_ENTRY_PHY_ADDR,
-					  (p_shdw[line].p_phys >> 12));
+					  (p_shdw[line].phys_addr >> 12));
 
 				DP_VERBOSE(p_hwfn, QED_MSG_ILT,
 					   "Setting RT[0x%08x] from ILT[0x%08x] [Client is %d] to Physical addr: 0x%llx\n",
 					   rt_offst, line, i,
-					   (u64)(p_shdw[line].p_phys >> 12));
+					   (u64)(p_shdw[line].phys_addr >> 12));
 			}
 
 			STORE_RT_REG_AGG(p_hwfn, rt_offst, ilt_hw_entry);
@@ -2049,10 +1948,10 @@ int qed_cxt_get_cid_info(struct qed_hwfn *p_hwfn, struct qed_cxt_info *p_info)
 	line = p_info->iid / cxts_per_p;
 
 	/* Make sure context is allocated (dynamic allocation) */
-	if (!p_mngr->ilt_shadow[line].p_virt)
+	if (!p_mngr->ilt_shadow[line].virt_addr)
 		return -EINVAL;
 
-	p_info->p_cxt = p_mngr->ilt_shadow[line].p_virt +
+	p_info->p_cxt = p_mngr->ilt_shadow[line].virt_addr +
 			p_info->iid % cxts_per_p * conn_cxt_size;
 
 	DP_VERBOSE(p_hwfn, (QED_MSG_ILT | QED_MSG_CXT),
@@ -2233,7 +2132,7 @@ int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_hwfn,
 	for (i = 0; i < total_lines; i++) {
 		shadow_line = i + p_fl_seg->start_line -
 		    p_hwfn->p_cxt_mngr->pf_start_line;
-		p_info->blocks[i] = p_mngr->ilt_shadow[shadow_line].p_virt;
+		p_info->blocks[i] = p_mngr->ilt_shadow[shadow_line].virt_addr;
 	}
 	p_info->waste = ILT_PAGE_IN_BYTES(p_cli->p_size.val) -
 	    p_fl_seg->real_size_in_page;
@@ -2295,7 +2194,7 @@ qed_cxt_dynamic_ilt_alloc(struct qed_hwfn *p_hwfn,
 
 	mutex_lock(&p_hwfn->p_cxt_mngr->mutex);
 
-	if (p_hwfn->p_cxt_mngr->ilt_shadow[shadow_line].p_virt)
+	if (p_hwfn->p_cxt_mngr->ilt_shadow[shadow_line].virt_addr)
 		goto out0;
 
 	p_ptt = qed_ptt_acquire(p_hwfn);
@@ -2333,8 +2232,8 @@ qed_cxt_dynamic_ilt_alloc(struct qed_hwfn *p_hwfn,
 		}
 	}
 
-	p_hwfn->p_cxt_mngr->ilt_shadow[shadow_line].p_virt = p_virt;
-	p_hwfn->p_cxt_mngr->ilt_shadow[shadow_line].p_phys = p_phys;
+	p_hwfn->p_cxt_mngr->ilt_shadow[shadow_line].virt_addr = p_virt;
+	p_hwfn->p_cxt_mngr->ilt_shadow[shadow_line].phys_addr = p_phys;
 	p_hwfn->p_cxt_mngr->ilt_shadow[shadow_line].size =
 	    p_blk->real_size_in_page;
 
@@ -2344,9 +2243,9 @@ qed_cxt_dynamic_ilt_alloc(struct qed_hwfn *p_hwfn,
 
 	ilt_hw_entry = 0;
 	SET_FIELD(ilt_hw_entry, ILT_ENTRY_VALID, 1ULL);
-	SET_FIELD(ilt_hw_entry,
-		  ILT_ENTRY_PHY_ADDR,
-		  (p_hwfn->p_cxt_mngr->ilt_shadow[shadow_line].p_phys >> 12));
+	SET_FIELD(ilt_hw_entry, ILT_ENTRY_PHY_ADDR,
+		  (p_hwfn->p_cxt_mngr->ilt_shadow[shadow_line].phys_addr
+		   >> 12));
 
 	/* Write via DMAE since the PSWRQ2_REG_ILT_MEMORY line is a wide-bus */
 	qed_dmae_host2grc(p_hwfn, p_ptt, (u64) (uintptr_t)&ilt_hw_entry,
@@ -2433,16 +2332,16 @@ qed_cxt_free_ilt_range(struct qed_hwfn *p_hwfn,
 	}
 
 	for (i = shadow_start_line; i < shadow_end_line; i++) {
-		if (!p_hwfn->p_cxt_mngr->ilt_shadow[i].p_virt)
+		if (!p_hwfn->p_cxt_mngr->ilt_shadow[i].virt_addr)
 			continue;
 
 		dma_free_coherent(&p_hwfn->cdev->pdev->dev,
 				  p_hwfn->p_cxt_mngr->ilt_shadow[i].size,
-				  p_hwfn->p_cxt_mngr->ilt_shadow[i].p_virt,
-				  p_hwfn->p_cxt_mngr->ilt_shadow[i].p_phys);
+				  p_hwfn->p_cxt_mngr->ilt_shadow[i].virt_addr,
+				  p_hwfn->p_cxt_mngr->ilt_shadow[i].phys_addr);
 
-		p_hwfn->p_cxt_mngr->ilt_shadow[i].p_virt = NULL;
-		p_hwfn->p_cxt_mngr->ilt_shadow[i].p_phys = 0;
+		p_hwfn->p_cxt_mngr->ilt_shadow[i].virt_addr = NULL;
+		p_hwfn->p_cxt_mngr->ilt_shadow[i].phys_addr = 0;
 		p_hwfn->p_cxt_mngr->ilt_shadow[i].size = 0;
 
 		/* compute absolute offset */
@@ -2546,8 +2445,76 @@ int qed_cxt_get_task_ctx(struct qed_hwfn *p_hwfn,
 
 	ilt_idx = tid / num_tids_per_block + p_seg->start_line -
 		  p_mngr->pf_start_line;
-	*pp_task_ctx = (u8 *)p_mngr->ilt_shadow[ilt_idx].p_virt +
+	*pp_task_ctx = (u8 *)p_mngr->ilt_shadow[ilt_idx].virt_addr +
 		       (tid % num_tids_per_block) * tid_size;
 
 	return 0;
 }
+
+static u16 qed_blk_calculate_pages(struct qed_ilt_cli_blk *p_blk)
+{
+	if (p_blk->real_size_in_page == 0)
+		return 0;
+
+	return DIV_ROUND_UP(p_blk->total_size, p_blk->real_size_in_page);
+}
+
+u16 qed_get_cdut_num_pf_init_pages(struct qed_hwfn *p_hwfn)
+{
+	struct qed_ilt_client_cfg *p_cli;
+	struct qed_ilt_cli_blk *p_blk;
+	u16 i, pages = 0;
+
+	p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_CDUT];
+	for (i = 0; i < NUM_TASK_PF_SEGMENTS; i++) {
+		p_blk = &p_cli->pf_blks[CDUT_FL_SEG_BLK(i, PF)];
+		pages += qed_blk_calculate_pages(p_blk);
+	}
+
+	return pages;
+}
+
+u16 qed_get_cdut_num_vf_init_pages(struct qed_hwfn *p_hwfn)
+{
+	struct qed_ilt_client_cfg *p_cli;
+	struct qed_ilt_cli_blk *p_blk;
+	u16 i, pages = 0;
+
+	p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_CDUT];
+	for (i = 0; i < NUM_TASK_VF_SEGMENTS; i++) {
+		p_blk = &p_cli->vf_blks[CDUT_FL_SEG_BLK(i, VF)];
+		pages += qed_blk_calculate_pages(p_blk);
+	}
+
+	return pages;
+}
+
+u16 qed_get_cdut_num_pf_work_pages(struct qed_hwfn *p_hwfn)
+{
+	struct qed_ilt_client_cfg *p_cli;
+	struct qed_ilt_cli_blk *p_blk;
+	u16 i, pages = 0;
+
+	p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_CDUT];
+	for (i = 0; i < NUM_TASK_PF_SEGMENTS; i++) {
+		p_blk = &p_cli->pf_blks[CDUT_SEG_BLK(i)];
+		pages += qed_blk_calculate_pages(p_blk);
+	}
+
+	return pages;
+}
+
+u16 qed_get_cdut_num_vf_work_pages(struct qed_hwfn *p_hwfn)
+{
+	struct qed_ilt_client_cfg *p_cli;
+	struct qed_ilt_cli_blk *p_blk;
+	u16 pages = 0, i;
+
+	p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_CDUT];
+	for (i = 0; i < NUM_TASK_VF_SEGMENTS; i++) {
+		p_blk = &p_cli->vf_blks[CDUT_SEG_BLK(i)];
+		pages += qed_blk_calculate_pages(p_blk);
+	}
+
+	return pages;
+}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.h b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
index 758a8b4c0de8..c4e815f6cabd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
@@ -242,4 +242,134 @@ int qed_cxt_free_proto_ilt(struct qed_hwfn *p_hwfn, enum protocol_type proto);
 #define QED_CTX_FL_MEM 1
 int qed_cxt_get_task_ctx(struct qed_hwfn *p_hwfn,
 			 u32 tid, u8 ctx_type, void **task_ctx);
+
+/* Max number of connection types in HW (DQ/CDU etc.) */
+#define MAX_CONN_TYPES          PROTOCOLID_COMMON
+#define NUM_TASK_TYPES          2
+#define NUM_TASK_PF_SEGMENTS    4
+#define NUM_TASK_VF_SEGMENTS    1
+
+/* PF per protocl configuration object */
+#define TASK_SEGMENTS   (NUM_TASK_PF_SEGMENTS + NUM_TASK_VF_SEGMENTS)
+#define TASK_SEGMENT_VF (NUM_TASK_PF_SEGMENTS)
+
+struct qed_tid_seg {
+	u32 count;
+	u8 type;
+	bool has_fl_mem;
+};
+
+struct qed_conn_type_cfg {
+	u32 cid_count;
+	u32 cids_per_vf;
+	struct qed_tid_seg tid_seg[TASK_SEGMENTS];
+};
+
+/* ILT Client configuration,
+ * Per connection type (protocol) resources (cids, tis, vf cids etc.)
+ * 1 - for connection context (CDUC) and for each task context we need two
+ * values, for regular task context and for force load memory
+ */
+#define ILT_CLI_PF_BLOCKS       (1 + NUM_TASK_PF_SEGMENTS * 2)
+#define ILT_CLI_VF_BLOCKS       (1 + NUM_TASK_VF_SEGMENTS * 2)
+#define CDUC_BLK                (0)
+#define SRQ_BLK                 (0)
+#define CDUT_SEG_BLK(n)         (1 + (u8)(n))
+#define CDUT_FL_SEG_BLK(n, X)   (1 + (n) + NUM_TASK_ ## X ## _SEGMENTS)
+
+struct ilt_cfg_pair {
+	u32 reg;
+	u32 val;
+};
+
+struct qed_ilt_cli_blk {
+	u32 total_size;		/* 0 means not active */
+	u32 real_size_in_page;
+	u32 start_line;
+	u32 dynamic_line_offset;
+	u32 dynamic_line_cnt;
+};
+
+struct qed_ilt_client_cfg {
+	bool active;
+
+	/* ILT boundaries */
+	struct ilt_cfg_pair first;
+	struct ilt_cfg_pair last;
+	struct ilt_cfg_pair p_size;
+
+	/* ILT client blocks for PF */
+	struct qed_ilt_cli_blk pf_blks[ILT_CLI_PF_BLOCKS];
+	u32 pf_total_lines;
+
+	/* ILT client blocks for VFs */
+	struct qed_ilt_cli_blk vf_blks[ILT_CLI_VF_BLOCKS];
+	u32 vf_total_lines;
+};
+
+struct qed_cid_acquired_map {
+	u32		start_cid;
+	u32		max_count;
+	unsigned long	*cid_map;
+};
+
+struct qed_src_t2 {
+	struct phys_mem_desc *dma_mem;
+	u32 num_pages;
+	u64 first_free;
+	u64 last_free;
+};
+
+struct qed_cxt_mngr {
+	/* Per protocl configuration */
+	struct qed_conn_type_cfg	conn_cfg[MAX_CONN_TYPES];
+
+	/* computed ILT structure */
+	struct qed_ilt_client_cfg	clients[MAX_ILT_CLIENTS];
+
+	/* Task type sizes */
+	u32 task_type_size[NUM_TASK_TYPES];
+
+	/* total number of VFs for this hwfn -
+	 * ALL VFs are symmetric in terms of HW resources
+	 */
+	u32 vf_count;
+	u32 first_vf_in_pf;
+
+	/* Acquired CIDs */
+	struct qed_cid_acquired_map	acquired[MAX_CONN_TYPES];
+
+	struct qed_cid_acquired_map
+	acquired_vf[MAX_CONN_TYPES][MAX_NUM_VFS];
+
+	/* ILT  shadow table */
+	struct phys_mem_desc *ilt_shadow;
+	u32 ilt_shadow_size;
+	u32 pf_start_line;
+
+	/* Mutex for a dynamic ILT allocation */
+	struct mutex mutex;
+
+	/* SRC T2 */
+	struct qed_src_t2 src_t2;
+	u32 t2_num_pages;
+	u64 first_free;
+	u64 last_free;
+
+	/* total number of SRQ's for this hwfn */
+	u32 srq_count;
+
+	/* Maximal number of L2 steering filters */
+	u32 arfs_count;
+
+	u8 task_type_id;
+	u16 task_ctx_size;
+	u16 conn_ctx_size;
+};
+
+u16 qed_get_cdut_num_pf_init_pages(struct qed_hwfn *p_hwfn);
+u16 qed_get_cdut_num_vf_init_pages(struct qed_hwfn *p_hwfn);
+u16 qed_get_cdut_num_pf_work_pages(struct qed_hwfn *p_hwfn);
+u16 qed_get_cdut_num_vf_work_pages(struct qed_hwfn *p_hwfn);
+
 #endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 859caa6c1a1f..17a9b30e6c62 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -7,6 +7,7 @@
 #include <linux/vmalloc.h>
 #include <linux/crc32.h>
 #include "qed.h"
+#include "qed_cxt.h"
 #include "qed_hsi.h"
 #include "qed_hw.h"
 #include "qed_mcp.h"
@@ -183,6 +184,7 @@ enum platform_ids {
 /* Chip constant definitions */
 struct chip_defs {
 	const char *name;
+	u32 num_ilt_pages;
 };
 
 /* Platform constant definitions */
@@ -380,6 +382,9 @@ struct split_type_defs {
 #define IDLE_CHK_RESULT_REG_HDR_DWORDS \
 	BYTES_TO_DWORDS(sizeof(struct dbg_idle_chk_result_reg_hdr))
 
+#define PAGE_MEM_DESC_SIZE_DWORDS \
+	BYTES_TO_DWORDS(sizeof(struct phys_mem_desc))
+
 #define IDLE_CHK_MAX_ENTRIES_SIZE	32
 
 /* The sizes and offsets below are specified in bits */
@@ -464,9 +469,8 @@ static struct dbg_array s_dbg_arrays[MAX_BIN_DBG_BUFFER_TYPE] = { {NULL} };
 
 /* Chip constant definitions array */
 static struct chip_defs s_chip_defs[MAX_CHIP_IDS] = {
-	{"bb"},
-	{"ah"},
-	{"reserved"},
+	{"bb", PSWRQ2_REG_ILT_MEMORY_SIZE_BB / 2},
+	{"ah", PSWRQ2_REG_ILT_MEMORY_SIZE_K2 / 2}
 };
 
 /* Storm constant definitions array */
@@ -1627,7 +1631,22 @@ static struct grc_param_defs s_grc_param_defs[] = {
 	{{0, 0, 0}, 0, 1, false, false, 0, 0},
 
 	/* DBG_GRC_PARAM_NO_FW_VER */
-	{{0, 0, 0}, 0, 1, false, false, 0, 0}
+	{{0, 0, 0}, 0, 1, false, false, 0, 0},
+
+	/* DBG_GRC_PARAM_RESERVED3 */
+	{{0, 0, 0}, 0, 1, false, false, 0, 0},
+
+	/* DBG_GRC_PARAM_DUMP_MCP_HW_DUMP */
+	{{0, 1, 1}, 0, 1, false, false, 0, 0},
+
+	/* DBG_GRC_PARAM_DUMP_ILT_CDUC */
+	{{1, 1, 1}, 0, 1, false, false, 0, 0},
+
+	/* DBG_GRC_PARAM_DUMP_ILT_CDUT */
+	{{1, 1, 1}, 0, 1, false, false, 0, 0},
+
+	/* DBG_GRC_PARAM_DUMP_CAU_EXT */
+	{{0, 0, 0}, 0, 1, false, false, 0, 1}
 };
 
 static struct rss_mem_defs s_rss_mem_defs[] = {
@@ -4992,16 +5011,18 @@ static enum dbg_status qed_protection_override_dump(struct qed_hwfn *p_hwfn,
 	override_window_dwords =
 		qed_rd(p_hwfn, p_ptt, GRC_REG_NUMBER_VALID_OVERRIDE_WINDOW) *
 		PROTECTION_OVERRIDE_ELEMENT_DWORDS;
-	addr = BYTES_TO_DWORDS(GRC_REG_PROTECTION_OVERRIDE_WINDOW);
-	offset += qed_grc_dump_addr_range(p_hwfn,
-					  p_ptt,
-					  dump_buf + offset,
-					  true,
-					  addr,
-					  override_window_dwords,
-					  true, SPLIT_TYPE_NONE, 0);
-	qed_dump_num_param(dump_buf + size_param_offset, dump, "size",
-			   override_window_dwords);
+	if (override_window_dwords) {
+		addr = BYTES_TO_DWORDS(GRC_REG_PROTECTION_OVERRIDE_WINDOW);
+		offset += qed_grc_dump_addr_range(p_hwfn,
+						  p_ptt,
+						  dump_buf + offset,
+						  true,
+						  addr,
+						  override_window_dwords,
+						  true, SPLIT_TYPE_NONE, 0);
+		qed_dump_num_param(dump_buf + size_param_offset, dump, "size",
+				   override_window_dwords);
+	}
 out:
 	/* Dump last section */
 	offset += qed_dump_last_section(dump_buf, offset, dump);
@@ -5088,6 +5109,348 @@ static u32 qed_fw_asserts_dump(struct qed_hwfn *p_hwfn,
 	return offset;
 }
 
+/* Dumps the specified ILT pages to the specified buffer.
+ * Returns the dumped size in dwords.
+ */
+static u32 qed_ilt_dump_pages_range(u32 *dump_buf,
+				    bool dump,
+				    u32 start_page_id,
+				    u32 num_pages,
+				    struct phys_mem_desc *ilt_pages,
+				    bool dump_page_ids)
+{
+	u32 page_id, end_page_id, offset = 0;
+
+	if (num_pages == 0)
+		return offset;
+
+	end_page_id = start_page_id + num_pages - 1;
+
+	for (page_id = start_page_id; page_id <= end_page_id; page_id++) {
+		struct phys_mem_desc *mem_desc = &ilt_pages[page_id];
+
+		/**
+		 *
+		 * if (page_id >= ->p_cxt_mngr->ilt_shadow_size)
+		 *     break;
+		 */
+
+		if (!ilt_pages[page_id].virt_addr)
+			continue;
+
+		if (dump_page_ids) {
+			/* Copy page ID to dump buffer */
+			if (dump)
+				*(dump_buf + offset) = page_id;
+			offset++;
+		} else {
+			/* Copy page memory to dump buffer */
+			if (dump)
+				memcpy(dump_buf + offset,
+				       mem_desc->virt_addr, mem_desc->size);
+			offset += BYTES_TO_DWORDS(mem_desc->size);
+		}
+	}
+
+	return offset;
+}
+
+/* Dumps a section containing the dumped ILT pages.
+ * Returns the dumped size in dwords.
+ */
+static u32 qed_ilt_dump_pages_section(struct qed_hwfn *p_hwfn,
+				      u32 *dump_buf,
+				      bool dump,
+				      u32 valid_conn_pf_pages,
+				      u32 valid_conn_vf_pages,
+				      struct phys_mem_desc *ilt_pages,
+				      bool dump_page_ids)
+{
+	struct qed_ilt_client_cfg *clients = p_hwfn->p_cxt_mngr->clients;
+	u32 pf_start_line, start_page_id, offset = 0;
+	u32 cdut_pf_init_pages, cdut_vf_init_pages;
+	u32 cdut_pf_work_pages, cdut_vf_work_pages;
+	u32 base_data_offset, size_param_offset;
+	u32 cdut_pf_pages, cdut_vf_pages;
+	const char *section_name;
+	u8 i;
+
+	section_name = dump_page_ids ? "ilt_page_ids" : "ilt_page_mem";
+	cdut_pf_init_pages = qed_get_cdut_num_pf_init_pages(p_hwfn);
+	cdut_vf_init_pages = qed_get_cdut_num_vf_init_pages(p_hwfn);
+	cdut_pf_work_pages = qed_get_cdut_num_pf_work_pages(p_hwfn);
+	cdut_vf_work_pages = qed_get_cdut_num_vf_work_pages(p_hwfn);
+	cdut_pf_pages = cdut_pf_init_pages + cdut_pf_work_pages;
+	cdut_vf_pages = cdut_vf_init_pages + cdut_vf_work_pages;
+	pf_start_line = p_hwfn->p_cxt_mngr->pf_start_line;
+
+	offset +=
+	    qed_dump_section_hdr(dump_buf + offset, dump, section_name, 1);
+
+	/* Dump size parameter (0 for now, overwritten with real size later) */
+	size_param_offset = offset;
+	offset += qed_dump_num_param(dump_buf + offset, dump, "size", 0);
+	base_data_offset = offset;
+
+	/* CDUC pages are ordered as follows:
+	 * - PF pages - valid section (included in PF connection type mapping)
+	 * - PF pages - invalid section (not dumped)
+	 * - For each VF in the PF:
+	 *   - VF pages - valid section (included in VF connection type mapping)
+	 *   - VF pages - invalid section (not dumped)
+	 */
+	if (qed_grc_get_param(p_hwfn, DBG_GRC_PARAM_DUMP_ILT_CDUC)) {
+		/* Dump connection PF pages */
+		start_page_id = clients[ILT_CLI_CDUC].first.val - pf_start_line;
+		offset += qed_ilt_dump_pages_range(dump_buf + offset,
+						   dump,
+						   start_page_id,
+						   valid_conn_pf_pages,
+						   ilt_pages, dump_page_ids);
+
+		/* Dump connection VF pages */
+		start_page_id += clients[ILT_CLI_CDUC].pf_total_lines;
+		for (i = 0; i < p_hwfn->p_cxt_mngr->vf_count;
+		     i++, start_page_id += clients[ILT_CLI_CDUC].vf_total_lines)
+			offset += qed_ilt_dump_pages_range(dump_buf + offset,
+							   dump,
+							   start_page_id,
+							   valid_conn_vf_pages,
+							   ilt_pages,
+							   dump_page_ids);
+	}
+
+	/* CDUT pages are ordered as follows:
+	 * - PF init pages (not dumped)
+	 * - PF work pages
+	 * - For each VF in the PF:
+	 *   - VF init pages (not dumped)
+	 *   - VF work pages
+	 */
+	if (qed_grc_get_param(p_hwfn, DBG_GRC_PARAM_DUMP_ILT_CDUT)) {
+		/* Dump task PF pages */
+		start_page_id = clients[ILT_CLI_CDUT].first.val +
+		    cdut_pf_init_pages - pf_start_line;
+		offset += qed_ilt_dump_pages_range(dump_buf + offset,
+						   dump,
+						   start_page_id,
+						   cdut_pf_work_pages,
+						   ilt_pages, dump_page_ids);
+
+		/* Dump task VF pages */
+		start_page_id = clients[ILT_CLI_CDUT].first.val +
+		    cdut_pf_pages + cdut_vf_init_pages - pf_start_line;
+		for (i = 0; i < p_hwfn->p_cxt_mngr->vf_count;
+		     i++, start_page_id += cdut_vf_pages)
+			offset += qed_ilt_dump_pages_range(dump_buf + offset,
+							   dump,
+							   start_page_id,
+							   cdut_vf_work_pages,
+							   ilt_pages,
+							   dump_page_ids);
+	}
+
+	/* Overwrite size param */
+	if (dump)
+		qed_dump_num_param(dump_buf + size_param_offset,
+				   dump, "size", offset - base_data_offset);
+
+	return offset;
+}
+
+/* Performs ILT Dump to the specified buffer.
+ * Returns the dumped size in dwords.
+ */
+static u32 qed_ilt_dump(struct qed_hwfn *p_hwfn,
+			struct qed_ptt *p_ptt, u32 *dump_buf, bool dump)
+{
+	struct qed_ilt_client_cfg *clients = p_hwfn->p_cxt_mngr->clients;
+	u32 valid_conn_vf_cids, valid_conn_vf_pages, offset = 0;
+	u32 valid_conn_pf_cids, valid_conn_pf_pages, num_pages;
+	u32 num_cids_per_page, conn_ctx_size;
+	u32 cduc_page_size, cdut_page_size;
+	struct phys_mem_desc *ilt_pages;
+	u8 conn_type;
+
+	cduc_page_size = 1 <<
+	    (clients[ILT_CLI_CDUC].p_size.val + PXP_ILT_PAGE_SIZE_NUM_BITS_MIN);
+	cdut_page_size = 1 <<
+	    (clients[ILT_CLI_CDUT].p_size.val + PXP_ILT_PAGE_SIZE_NUM_BITS_MIN);
+	conn_ctx_size = p_hwfn->p_cxt_mngr->conn_ctx_size;
+	num_cids_per_page = (int)(cduc_page_size / conn_ctx_size);
+	ilt_pages = p_hwfn->p_cxt_mngr->ilt_shadow;
+
+	/* Dump global params - 22 must match number of params below */
+	offset += qed_dump_common_global_params(p_hwfn, p_ptt,
+						dump_buf + offset, dump, 22);
+	offset += qed_dump_str_param(dump_buf + offset,
+				     dump, "dump-type", "ilt-dump");
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cduc-page-size", cduc_page_size);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cduc-first-page-id",
+				     clients[ILT_CLI_CDUC].first.val);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cduc-last-page-id",
+				     clients[ILT_CLI_CDUC].last.val);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cduc-num-pf-pages",
+				     clients
+				     [ILT_CLI_CDUC].pf_total_lines);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cduc-num-vf-pages",
+				     clients
+				     [ILT_CLI_CDUC].vf_total_lines);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "max-conn-ctx-size",
+				     conn_ctx_size);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cdut-page-size", cdut_page_size);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cdut-first-page-id",
+				     clients[ILT_CLI_CDUT].first.val);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cdut-last-page-id",
+				     clients[ILT_CLI_CDUT].last.val);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cdut-num-pf-init-pages",
+				     qed_get_cdut_num_pf_init_pages(p_hwfn));
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cdut-num-vf-init-pages",
+				     qed_get_cdut_num_vf_init_pages(p_hwfn));
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cdut-num-pf-work-pages",
+				     qed_get_cdut_num_pf_work_pages(p_hwfn));
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "cdut-num-vf-work-pages",
+				     qed_get_cdut_num_vf_work_pages(p_hwfn));
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "max-task-ctx-size",
+				     p_hwfn->p_cxt_mngr->task_ctx_size);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "task-type-id",
+				     p_hwfn->p_cxt_mngr->task_type_id);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "first-vf-id-in-pf",
+				     p_hwfn->p_cxt_mngr->first_vf_in_pf);
+	offset += /* 18 */ qed_dump_num_param(dump_buf + offset,
+					      dump,
+					      "num-vfs-in-pf",
+					      p_hwfn->p_cxt_mngr->vf_count);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "ptr-size-bytes", sizeof(void *));
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "pf-start-line",
+				     p_hwfn->p_cxt_mngr->pf_start_line);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "page-mem-desc-size-dwords",
+				     PAGE_MEM_DESC_SIZE_DWORDS);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "ilt-shadow-size",
+				     p_hwfn->p_cxt_mngr->ilt_shadow_size);
+	/* Additional/Less parameters require matching of number in call to
+	 * dump_common_global_params()
+	 */
+
+	/* Dump section containing number of PF CIDs per connection type */
+	offset += qed_dump_section_hdr(dump_buf + offset,
+				       dump, "num_pf_cids_per_conn_type", 1);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump, "size", NUM_OF_CONNECTION_TYPES_E4);
+	for (conn_type = 0, valid_conn_pf_cids = 0;
+	     conn_type < NUM_OF_CONNECTION_TYPES_E4; conn_type++, offset++) {
+		u32 num_pf_cids =
+		    p_hwfn->p_cxt_mngr->conn_cfg[conn_type].cid_count;
+
+		if (dump)
+			*(dump_buf + offset) = num_pf_cids;
+		valid_conn_pf_cids += num_pf_cids;
+	}
+
+	/* Dump section containing number of VF CIDs per connection type */
+	offset += qed_dump_section_hdr(dump_buf + offset,
+				       dump, "num_vf_cids_per_conn_type", 1);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump, "size", NUM_OF_CONNECTION_TYPES_E4);
+	for (conn_type = 0, valid_conn_vf_cids = 0;
+	     conn_type < NUM_OF_CONNECTION_TYPES_E4; conn_type++, offset++) {
+		u32 num_vf_cids =
+		    p_hwfn->p_cxt_mngr->conn_cfg[conn_type].cids_per_vf;
+
+		if (dump)
+			*(dump_buf + offset) = num_vf_cids;
+		valid_conn_vf_cids += num_vf_cids;
+	}
+
+	/* Dump section containing physical memory descs for each ILT page */
+	num_pages = p_hwfn->p_cxt_mngr->ilt_shadow_size;
+	offset += qed_dump_section_hdr(dump_buf + offset,
+				       dump, "ilt_page_desc", 1);
+	offset += qed_dump_num_param(dump_buf + offset,
+				     dump,
+				     "size",
+				     num_pages * PAGE_MEM_DESC_SIZE_DWORDS);
+
+	/* Copy memory descriptors to dump buffer */
+	if (dump) {
+		u32 page_id;
+
+		for (page_id = 0; page_id < num_pages;
+		     page_id++, offset += PAGE_MEM_DESC_SIZE_DWORDS)
+			memcpy(dump_buf + offset,
+			       &ilt_pages[page_id],
+			       DWORDS_TO_BYTES(PAGE_MEM_DESC_SIZE_DWORDS));
+	} else {
+		offset += num_pages * PAGE_MEM_DESC_SIZE_DWORDS;
+	}
+
+	valid_conn_pf_pages = DIV_ROUND_UP(valid_conn_pf_cids,
+					   num_cids_per_page);
+	valid_conn_vf_pages = DIV_ROUND_UP(valid_conn_vf_cids,
+					   num_cids_per_page);
+
+	/* Dump ILT pages IDs */
+	offset += qed_ilt_dump_pages_section(p_hwfn,
+					     dump_buf + offset,
+					     dump,
+					     valid_conn_pf_pages,
+					     valid_conn_vf_pages,
+					     ilt_pages, true);
+
+	/* Dump ILT pages memory */
+	offset += qed_ilt_dump_pages_section(p_hwfn,
+					     dump_buf + offset,
+					     dump,
+					     valid_conn_pf_pages,
+					     valid_conn_vf_pages,
+					     ilt_pages, false);
+
+	/* Dump last section */
+	offset += qed_dump_last_section(dump_buf, offset, dump);
+
+	return offset;
+}
+
 /***************************** Public Functions *******************************/
 
 enum dbg_status qed_dbg_set_bin_ptr(const u8 * const bin_ptr)
@@ -5554,6 +5917,50 @@ enum dbg_status qed_dbg_fw_asserts_dump(struct qed_hwfn *p_hwfn,
 	return DBG_STATUS_OK;
 }
 
+static enum dbg_status qed_dbg_ilt_get_dump_buf_size(struct qed_hwfn *p_hwfn,
+						     struct qed_ptt *p_ptt,
+						     u32 *buf_size)
+{
+	enum dbg_status status = qed_dbg_dev_init(p_hwfn, p_ptt);
+
+	*buf_size = 0;
+
+	if (status != DBG_STATUS_OK)
+		return status;
+
+	*buf_size = qed_ilt_dump(p_hwfn, p_ptt, NULL, false);
+
+	return DBG_STATUS_OK;
+}
+
+static enum dbg_status qed_dbg_ilt_dump(struct qed_hwfn *p_hwfn,
+					struct qed_ptt *p_ptt,
+					u32 *dump_buf,
+					u32 buf_size_in_dwords,
+					u32 *num_dumped_dwords)
+{
+	u32 needed_buf_size_in_dwords;
+	enum dbg_status status;
+
+	*num_dumped_dwords = 0;
+
+	status = qed_dbg_ilt_get_dump_buf_size(p_hwfn,
+					       p_ptt,
+					       &needed_buf_size_in_dwords);
+	if (status != DBG_STATUS_OK)
+		return status;
+
+	if (buf_size_in_dwords < needed_buf_size_in_dwords)
+		return DBG_STATUS_DUMP_BUF_TOO_SMALL;
+
+	*num_dumped_dwords = qed_ilt_dump(p_hwfn, p_ptt, dump_buf, true);
+
+	/* Reveret GRC params to their default */
+	qed_dbg_grc_set_params_default(p_hwfn);
+
+	return DBG_STATUS_OK;
+}
+
 enum dbg_status qed_dbg_read_attn(struct qed_hwfn *p_hwfn,
 				  struct qed_ptt *p_ptt,
 				  enum block_id block_id,
@@ -7763,7 +8170,10 @@ static struct {
 		    qed_dbg_fw_asserts_get_dump_buf_size,
 		    qed_dbg_fw_asserts_dump,
 		    qed_print_fw_asserts_results,
-		    qed_get_fw_asserts_results_buf_size},};
+		    qed_get_fw_asserts_results_buf_size}, {
+	"ilt",
+		    qed_dbg_ilt_get_dump_buf_size,
+		    qed_dbg_ilt_dump, NULL, NULL},};
 
 static void qed_dbg_print_feature(u8 *p_text_buf, u32 text_size)
 {
@@ -7846,6 +8256,8 @@ static enum dbg_status format_feature(struct qed_hwfn *p_hwfn,
 	return rc;
 }
 
+#define MAX_DBG_FEATURE_SIZE_DWORDS	0x3FFFFFFF
+
 /* Generic function for performing the dump of a debug feature. */
 static enum dbg_status qed_dbg_dump(struct qed_hwfn *p_hwfn,
 				    struct qed_ptt *p_ptt,
@@ -8021,6 +8433,16 @@ int qed_dbg_fw_asserts_size(struct qed_dev *cdev)
 	return qed_dbg_feature_size(cdev, DBG_FEATURE_FW_ASSERTS);
 }
 
+int qed_dbg_ilt(struct qed_dev *cdev, void *buffer, u32 *num_dumped_bytes)
+{
+	return qed_dbg_feature(cdev, buffer, DBG_FEATURE_ILT, num_dumped_bytes);
+}
+
+int qed_dbg_ilt_size(struct qed_dev *cdev)
+{
+	return qed_dbg_feature_size(cdev, DBG_FEATURE_ILT);
+}
+
 int qed_dbg_mcp_trace(struct qed_dev *cdev, void *buffer,
 		      u32 *num_dumped_bytes)
 {
@@ -8037,9 +8459,17 @@ int qed_dbg_mcp_trace_size(struct qed_dev *cdev)
  * feature buffer.
  */
 #define REGDUMP_HEADER_SIZE			sizeof(u32)
+#define REGDUMP_HEADER_SIZE_SHIFT		0
+#define REGDUMP_HEADER_SIZE_MASK		0xffffff
 #define REGDUMP_HEADER_FEATURE_SHIFT		24
-#define REGDUMP_HEADER_ENGINE_SHIFT		31
+#define REGDUMP_HEADER_FEATURE_MASK		0x3f
 #define REGDUMP_HEADER_OMIT_ENGINE_SHIFT	30
+#define REGDUMP_HEADER_OMIT_ENGINE_MASK		0x1
+#define REGDUMP_HEADER_ENGINE_SHIFT		31
+#define REGDUMP_HEADER_ENGINE_MASK		0x1
+#define REGDUMP_MAX_SIZE			0x1000000
+#define ILT_DUMP_MAX_SIZE			(1024 * 1024 * 15)
+
 enum debug_print_features {
 	OLD_MODE = 0,
 	IDLE_CHK = 1,
@@ -8053,6 +8483,8 @@ enum debug_print_features {
 	NVM_CFG1 = 9,
 	DEFAULT_CFG = 10,
 	NVM_META = 11,
+	MDUMP = 12,
+	ILT_DUMP = 13,
 };
 
 static u32 qed_calc_regdump_header(enum debug_print_features feature,
@@ -8166,8 +8598,23 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 			       rc);
 		}
 
-		for (i = 0; i < MAX_DBG_GRC_PARAMS; i++)
-			dev_data->grc.param_val[i] = grc_params[i];
+		feature_size = qed_dbg_ilt_size(cdev);
+		if (!cdev->disable_ilt_dump &&
+		    feature_size < ILT_DUMP_MAX_SIZE) {
+			rc = qed_dbg_ilt(cdev, (u8 *)buffer + offset +
+					 REGDUMP_HEADER_SIZE, &feature_size);
+			if (!rc) {
+				*(u32 *)((u8 *)buffer + offset) =
+				    qed_calc_regdump_header(ILT_DUMP,
+							    cur_engine,
+							    feature_size,
+							    omit_engine);
+				offset += feature_size + REGDUMP_HEADER_SIZE;
+			} else {
+				DP_ERR(cdev, "qed_dbg_ilt failed. rc = %d\n",
+				       rc);
+			}
+		}
 
 		/* GRC dump - must be last because when mcp stuck it will
 		 * clutter idle_chk, reg_fifo, ...
@@ -8243,6 +8690,21 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		       QED_NVM_IMAGE_NVM_META, "QED_NVM_IMAGE_NVM_META", rc);
 	}
 
+	/* nvm mdump */
+	rc = qed_dbg_nvm_image(cdev, (u8 *)buffer + offset +
+			       REGDUMP_HEADER_SIZE, &feature_size,
+			       QED_NVM_IMAGE_MDUMP);
+	if (!rc) {
+		*(u32 *)((u8 *)buffer + offset) =
+			qed_calc_regdump_header(MDUMP, cur_engine,
+						feature_size, omit_engine);
+		offset += (feature_size + REGDUMP_HEADER_SIZE);
+	} else if (rc != -ENOENT) {
+		DP_ERR(cdev,
+		       "qed_dbg_nvm_image failed for image %d (%s), rc = %d\n",
+		       QED_NVM_IMAGE_MDUMP, "QED_NVM_IMAGE_MDUMP", rc);
+	}
+
 	return 0;
 }
 
@@ -8250,7 +8712,7 @@ int qed_dbg_all_data_size(struct qed_dev *cdev)
 {
 	struct qed_hwfn *p_hwfn =
 		&cdev->hwfns[cdev->dbg_params.engine_for_debug];
-	u32 regs_len = 0, image_len = 0;
+	u32 regs_len = 0, image_len = 0, ilt_len = 0, total_ilt_len = 0;
 	u8 cur_engine, org_engine;
 
 	org_engine = qed_get_debug_engine(cdev);
@@ -8267,6 +8729,12 @@ int qed_dbg_all_data_size(struct qed_dev *cdev)
 			    REGDUMP_HEADER_SIZE +
 			    qed_dbg_protection_override_size(cdev) +
 			    REGDUMP_HEADER_SIZE + qed_dbg_fw_asserts_size(cdev);
+
+		ilt_len = REGDUMP_HEADER_SIZE + qed_dbg_ilt_size(cdev);
+		if (ilt_len < ILT_DUMP_MAX_SIZE) {
+			total_ilt_len += ilt_len;
+			regs_len += ilt_len;
+		}
 	}
 
 	qed_set_debug_engine(cdev, org_engine);
@@ -8282,6 +8750,17 @@ int qed_dbg_all_data_size(struct qed_dev *cdev)
 	qed_dbg_nvm_image_length(p_hwfn, QED_NVM_IMAGE_NVM_META, &image_len);
 	if (image_len)
 		regs_len += REGDUMP_HEADER_SIZE + image_len;
+	qed_dbg_nvm_image_length(p_hwfn, QED_NVM_IMAGE_MDUMP, &image_len);
+	if (image_len)
+		regs_len += REGDUMP_HEADER_SIZE + image_len;
+
+	if (regs_len > REGDUMP_MAX_SIZE) {
+		DP_VERBOSE(cdev, QED_MSG_DEBUG,
+			   "Dump exceeds max size 0x%x, disable ILT dump\n",
+			   REGDUMP_MAX_SIZE);
+		cdev->disable_ilt_dump = true;
+		regs_len -= total_ilt_len;
+	}
 
 	return regs_len;
 }
@@ -8341,6 +8820,10 @@ int qed_dbg_feature_size(struct qed_dev *cdev, enum qed_dbg_features feature)
 	if (rc != DBG_STATUS_OK)
 		buf_size_dwords = 0;
 
+	/* Feature will not be dumped if it exceeds maximum size */
+	if (buf_size_dwords > MAX_DBG_FEATURE_SIZE_DWORDS)
+		buf_size_dwords = 0;
+
 	qed_ptt_release(p_hwfn, p_ptt);
 	qed_feature->buf_size = buf_size_dwords * sizeof(u32);
 	return qed_feature->buf_size;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.h b/drivers/net/ethernet/qlogic/qed/qed_debug.h
index e47e0e8d75b0..edf99d296bd1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.h
@@ -14,11 +14,13 @@ enum qed_dbg_features {
 	DBG_FEATURE_IGU_FIFO,
 	DBG_FEATURE_PROTECTION_OVERRIDE,
 	DBG_FEATURE_FW_ASSERTS,
+	DBG_FEATURE_ILT,
 	DBG_FEATURE_NUM
 };
 
 /* Forward Declaration */
 struct qed_dev;
+struct qed_hwfn;
 
 int qed_dbg_grc(struct qed_dev *cdev, void *buffer, u32 *num_dumped_bytes);
 int qed_dbg_grc_size(struct qed_dev *cdev);
@@ -37,6 +39,8 @@ int qed_dbg_protection_override_size(struct qed_dev *cdev);
 int qed_dbg_fw_asserts(struct qed_dev *cdev, void *buffer,
 		       u32 *num_dumped_bytes);
 int qed_dbg_fw_asserts_size(struct qed_dev *cdev);
+int qed_dbg_ilt(struct qed_dev *cdev, void *buffer, u32 *num_dumped_bytes);
+int qed_dbg_ilt_size(struct qed_dev *cdev);
 int qed_dbg_mcp_trace(struct qed_dev *cdev, void *buffer,
 		      u32 *num_dumped_bytes);
 int qed_dbg_mcp_trace_size(struct qed_dev *cdev);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 67c048415d3b..e7e3f7b31ee0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -2575,6 +2575,11 @@ enum dbg_grc_params {
 	DBG_GRC_PARAM_DUMP_PHY,
 	DBG_GRC_PARAM_NO_MCP,
 	DBG_GRC_PARAM_NO_FW_VER,
+	DBG_GRC_PARAM_RESERVED3,
+	DBG_GRC_PARAM_DUMP_MCP_HW_DUMP,
+	DBG_GRC_PARAM_DUMP_ILT_CDUC,
+	DBG_GRC_PARAM_DUMP_ILT_CDUT,
+	DBG_GRC_PARAM_DUMP_CAU_EXT,
 	MAX_DBG_GRC_PARAMS
 };
 
@@ -2695,6 +2700,19 @@ struct dbg_tools_data {
 	u32 num_regs_read;
 };
 
+/* ILT Clients */
+enum ilt_clients {
+	ILT_CLI_CDUC,
+	ILT_CLI_CDUT,
+	ILT_CLI_QM,
+	ILT_CLI_TM,
+	ILT_CLI_SRC,
+	ILT_CLI_TSDM,
+	ILT_CLI_RGFS,
+	ILT_CLI_TGFS,
+	MAX_ILT_CLIENTS
+};
+
 /********************************/
 /* HSI Init Functions constants */
 /********************************/
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index af981ff5595e..280527cc0578 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3167,6 +3167,9 @@ qed_mcp_get_nvm_image_att(struct qed_hwfn *p_hwfn,
 	case QED_NVM_IMAGE_FCOE_CFG:
 		type = NVM_TYPE_FCOE_CFG;
 		break;
+	case QED_NVM_IMAGE_MDUMP:
+		type = NVM_TYPE_MDUMP;
+		break;
 	case QED_NVM_IMAGE_NVM_CFG1:
 		type = NVM_TYPE_NVM_CFG1;
 		break;
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 9bcb2f419004..1b27c22d39af 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -159,6 +159,7 @@ struct qed_dcbx_get {
 enum qed_nvm_images {
 	QED_NVM_IMAGE_ISCSI_CFG,
 	QED_NVM_IMAGE_FCOE_CFG,
+	QED_NVM_IMAGE_MDUMP,
 	QED_NVM_IMAGE_NVM_CFG1,
 	QED_NVM_IMAGE_DEFAULT_CFG,
 	QED_NVM_IMAGE_NVM_META,
-- 
2.14.5

