Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F421DA416
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgESVvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:51:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12224 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbgESVvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 17:51:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04JLklbs002396;
        Tue, 19 May 2020 14:51:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=U0egW57fO68sE2uzyPl9EoGRXFptWX4pMQaOCxYpnbs=;
 b=rfGuGCNNzVNoMwpMN1cxYnstG7SWb5KCryndXtjFmdLerLqX3bOCTxbbYA/sjLQWa/oV
 MAFT67fYKoYQDuEjzOmgAv+yYk9vSd99jJpFl5/Ai03Tp/+Myobh0rCrt77OJ1kEeF+f
 WuuU7dwZ7HL4Z0WCeKLUEmYpJ3kmztzPLIntq4oSsyrI5eBqx3Q72e1D/gee1INzRSUJ
 C2BeelYvr3D3XZp3IoRExwwGNi6QMBItmNFXA63kk2D/4UBox+MWFGoOszXnsMd2YsB8
 xG/RKPc7gHAQy/AlSqCq1Z4UDdzS34KwjZebl5hTSSupcLJmZouSxzyy4/Dz8zF3C4sh 7w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpp5hfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 14:51:19 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 May
 2020 14:51:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 19 May 2020 14:51:17 -0700
Received: from lb-tlvb-ybason.il.qlogic.org (unknown [10.5.221.176])
        by maili.marvell.com (Postfix) with ESMTP id 3E1133F704E;
        Tue, 19 May 2020 14:51:16 -0700 (PDT)
From:   Yuval Basson <ybason@marvell.com>
To:     <davem@davemloft.net>
CC:     <mkalderon@marvell.com>, <ybason@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next,v2 1/2] qed: changes to ILT to support XRC
Date:   Tue, 19 May 2020 23:51:25 +0300
Message-ID: <20200519205126.26987-2-ybason@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200519205126.26987-1-ybason@marvell.com>
References: <20200519205126.26987-1-ybason@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_10:2020-05-19,2020-05-19 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First ILT page for TSDM client is allocated for XRC-SRQ's.
For regular SRQ's skip first ILT page that is reserved for
XRC-SRQ's.

Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Yuval Bason <ybason@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c  | 60 +++++++++++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_cxt.h  | 10 ++++-
 drivers/net/ethernet/qlogic/qed/qed_dev.c  |  6 ++-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c |  2 +-
 4 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 1a636ba..7b76667 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -110,6 +110,7 @@ struct src_ent {
 	ALIGNED_TYPE_SIZE(union conn_context, p_hwfn)
 
 #define SRQ_CXT_SIZE (sizeof(struct rdma_srq_context))
+#define XRC_SRQ_CXT_SIZE (sizeof(struct rdma_xrc_srq_context))
 
 #define TYPE0_TASK_CXT_SIZE(p_hwfn) \
 	ALIGNED_TYPE_SIZE(union type0_task_context, p_hwfn)
@@ -293,18 +294,40 @@ static struct qed_tid_seg *qed_cxt_tid_seg_info(struct qed_hwfn *p_hwfn,
 	return NULL;
 }
 
-static void qed_cxt_set_srq_count(struct qed_hwfn *p_hwfn, u32 num_srqs)
+static void qed_cxt_set_srq_count(struct qed_hwfn *p_hwfn,
+				  u32 num_srqs, u32 num_xrc_srqs)
 {
 	struct qed_cxt_mngr *p_mgr = p_hwfn->p_cxt_mngr;
 
 	p_mgr->srq_count = num_srqs;
+	p_mgr->xrc_srq_count = num_xrc_srqs;
 }
 
-u32 qed_cxt_get_srq_count(struct qed_hwfn *p_hwfn)
+u32 qed_cxt_get_ilt_page_size(struct qed_hwfn *p_hwfn,
+			      enum ilt_clients ilt_client)
+{
+	struct qed_cxt_mngr *p_mngr = p_hwfn->p_cxt_mngr;
+	struct qed_ilt_client_cfg *p_cli = &p_mngr->clients[ilt_client];
+
+	return ILT_PAGE_IN_BYTES(p_cli->p_size.val);
+}
+
+static u32 qed_cxt_xrc_srqs_per_page(struct qed_hwfn *p_hwfn)
+{
+	u32 page_size;
+
+	page_size = qed_cxt_get_ilt_page_size(p_hwfn, ILT_CLI_TSDM);
+	return page_size / XRC_SRQ_CXT_SIZE;
+}
+
+u32 qed_cxt_get_total_srq_count(struct qed_hwfn *p_hwfn)
 {
 	struct qed_cxt_mngr *p_mgr = p_hwfn->p_cxt_mngr;
+	u32 total_srqs;
+
+	total_srqs = p_mgr->srq_count + p_mgr->xrc_srq_count;
 
-	return p_mgr->srq_count;
+	return total_srqs;
 }
 
 /* set the iids count per protocol */
@@ -692,7 +715,7 @@ int qed_cxt_cfg_ilt_compute(struct qed_hwfn *p_hwfn, u32 *line_count)
 	}
 
 	/* TSDM (SRQ CONTEXT) */
-	total = qed_cxt_get_srq_count(p_hwfn);
+	total = qed_cxt_get_total_srq_count(p_hwfn);
 
 	if (total) {
 		p_cli = qed_cxt_set_cli(&p_mngr->clients[ILT_CLI_TSDM]);
@@ -1962,11 +1985,9 @@ static void qed_rdma_set_pf_params(struct qed_hwfn *p_hwfn,
 				   struct qed_rdma_pf_params *p_params,
 				   u32 num_tasks)
 {
-	u32 num_cons, num_qps, num_srqs;
+	u32 num_cons, num_qps;
 	enum protocol_type proto;
 
-	num_srqs = min_t(u32, QED_RDMA_MAX_SRQS, p_params->num_srqs);
-
 	if (p_hwfn->mcp_info->func_info.protocol == QED_PCI_ETH_RDMA) {
 		DP_NOTICE(p_hwfn,
 			  "Current day drivers don't support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only\n");
@@ -1989,6 +2010,8 @@ static void qed_rdma_set_pf_params(struct qed_hwfn *p_hwfn,
 	}
 
 	if (num_cons && num_tasks) {
+		u32 num_srqs, num_xrc_srqs;
+
 		qed_cxt_set_proto_cid_count(p_hwfn, proto, num_cons, 0);
 
 		/* Deliberatly passing ROCE for tasks id. This is because
@@ -1997,7 +2020,13 @@ static void qed_rdma_set_pf_params(struct qed_hwfn *p_hwfn,
 		qed_cxt_set_proto_tid_count(p_hwfn, PROTOCOLID_ROCE,
 					    QED_CXT_ROCE_TID_SEG, 1,
 					    num_tasks, false);
-		qed_cxt_set_srq_count(p_hwfn, num_srqs);
+
+		num_srqs = min_t(u32, QED_RDMA_MAX_SRQS, p_params->num_srqs);
+
+		/* XRC SRQs populate a single ILT page */
+		num_xrc_srqs = qed_cxt_xrc_srqs_per_page(p_hwfn);
+
+		qed_cxt_set_srq_count(p_hwfn, num_srqs, num_xrc_srqs);
 	} else {
 		DP_INFO(p_hwfn->cdev,
 			"RDMA personality used without setting params!\n");
@@ -2163,10 +2192,17 @@ int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_hwfn,
 		p_blk = &p_cli->pf_blks[CDUC_BLK];
 		break;
 	case QED_ELEM_SRQ:
+		/* The first ILT page is not used for regular SRQs. Skip it. */
+		iid += p_hwfn->p_cxt_mngr->xrc_srq_count;
 		p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_TSDM];
 		elem_size = SRQ_CXT_SIZE;
 		p_blk = &p_cli->pf_blks[SRQ_BLK];
 		break;
+	case QED_ELEM_XRC_SRQ:
+		p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_TSDM];
+		elem_size = XRC_SRQ_CXT_SIZE;
+		p_blk = &p_cli->pf_blks[SRQ_BLK];
+		break;
 	case QED_ELEM_TASK:
 		p_cli = &p_hwfn->p_cxt_mngr->clients[ILT_CLI_CDUT];
 		elem_size = TYPE1_TASK_CXT_SIZE(p_hwfn);
@@ -2386,8 +2422,12 @@ int qed_cxt_free_proto_ilt(struct qed_hwfn *p_hwfn, enum protocol_type proto)
 		return rc;
 
 	/* Free TSDM CXT */
-	rc = qed_cxt_free_ilt_range(p_hwfn, QED_ELEM_SRQ, 0,
-				    qed_cxt_get_srq_count(p_hwfn));
+	rc = qed_cxt_free_ilt_range(p_hwfn, QED_ELEM_XRC_SRQ, 0,
+				    p_hwfn->p_cxt_mngr->xrc_srq_count);
+
+	rc = qed_cxt_free_ilt_range(p_hwfn, QED_ELEM_SRQ,
+				    p_hwfn->p_cxt_mngr->xrc_srq_count,
+				    p_hwfn->p_cxt_mngr->srq_count);
 
 	return rc;
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.h b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
index c4e815f..ce08ae8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
@@ -82,7 +82,8 @@ int qed_cxt_get_tid_mem_info(struct qed_hwfn *p_hwfn,
 enum qed_cxt_elem_type {
 	QED_ELEM_CXT,
 	QED_ELEM_SRQ,
-	QED_ELEM_TASK
+	QED_ELEM_TASK,
+	QED_ELEM_XRC_SRQ,
 };
 
 u32 qed_cxt_get_proto_cid_count(struct qed_hwfn *p_hwfn,
@@ -235,7 +236,6 @@ u32 qed_cxt_get_proto_tid_count(struct qed_hwfn *p_hwfn,
 				enum protocol_type type);
 u32 qed_cxt_get_proto_cid_start(struct qed_hwfn *p_hwfn,
 				enum protocol_type type);
-u32 qed_cxt_get_srq_count(struct qed_hwfn *p_hwfn);
 int qed_cxt_free_proto_ilt(struct qed_hwfn *p_hwfn, enum protocol_type proto);
 
 #define QED_CTX_WORKING_MEM 0
@@ -358,6 +358,7 @@ struct qed_cxt_mngr {
 
 	/* total number of SRQ's for this hwfn */
 	u32 srq_count;
+	u32 xrc_srq_count;
 
 	/* Maximal number of L2 steering filters */
 	u32 arfs_count;
@@ -372,4 +373,9 @@ struct qed_cxt_mngr {
 u16 qed_get_cdut_num_pf_work_pages(struct qed_hwfn *p_hwfn);
 u16 qed_get_cdut_num_vf_work_pages(struct qed_hwfn *p_hwfn);
 
+u32 qed_cxt_get_ilt_page_size(struct qed_hwfn *p_hwfn,
+			      enum ilt_clients ilt_client);
+
+u32 qed_cxt_get_total_srq_count(struct qed_hwfn *p_hwfn);
+
 #endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 6e85746..1eebf30 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -2269,6 +2269,7 @@ int qed_resc_alloc(struct qed_dev *cdev)
 		/* EQ */
 		n_eqes = qed_chain_get_capacity(&p_hwfn->p_spq->chain);
 		if (QED_IS_RDMA_PERSONALITY(p_hwfn)) {
+			u32 n_srq = qed_cxt_get_total_srq_count(p_hwfn);
 			enum protocol_type rdma_proto;
 
 			if (QED_IS_ROCE_PERSONALITY(p_hwfn))
@@ -2279,7 +2280,10 @@ int qed_resc_alloc(struct qed_dev *cdev)
 			num_cons = qed_cxt_get_proto_cid_count(p_hwfn,
 							       rdma_proto,
 							       NULL) * 2;
-			n_eqes += num_cons + 2 * MAX_NUM_VFS_BB;
+			/* EQ should be able to get events from all SRQ's
+			 * at the same time
+			 */
+			n_eqes += num_cons + 2 * MAX_NUM_VFS_BB + n_srq;
 		} else if (p_hwfn->hw_info.personality == QED_PCI_ISCSI) {
 			num_cons =
 			    qed_cxt_get_proto_cid_count(p_hwfn,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 38b1f40..415f3f3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -272,7 +272,7 @@ static int qed_rdma_alloc(struct qed_hwfn *p_hwfn)
 	}
 
 	/* Allocate bitmap for srqs */
-	p_rdma_info->num_srqs = qed_cxt_get_srq_count(p_hwfn);
+	p_rdma_info->num_srqs = p_hwfn->p_cxt_mngr->srq_count;
 	rc = qed_rdma_bmap_alloc(p_hwfn, &p_rdma_info->srq_map,
 				 p_rdma_info->num_srqs, "SRQ");
 	if (rc) {
-- 
1.8.3.1

