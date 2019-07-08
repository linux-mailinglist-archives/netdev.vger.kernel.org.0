Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2C961C3D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbfGHJRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:17:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2874 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729748AbfGHJRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:17:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x689FkrN013333;
        Mon, 8 Jul 2019 02:16:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=jDYZsBvPRyUC1nYCpvbU3Edjg6e+ya4ybGVNYCpfk/8=;
 b=cAqLpQ72aErgVP2bGyk0Bl4o4tZ/JtsAfzyiN3aGKwaL3BeQbrflaQeQMW/CFjb9fsgW
 LAndy+Icz0WJfRMZjN0c9YxzHHixv/Eoo2Yag7dd8NlvnElb3egO4FeBalZM1tGIxI1l
 0ATbjkyaIa34WSP/JJP1jJJ9mjsFPE3SI5PVR/invjV4UWsKlO6Ez0L1RpgvXi6uyBd6
 RU7LrwdoZzw4cbtvZEAXQDPyT1uOxG4obnF9np1ZI7DxLcJmJb6AZSPDG6wD+fh2xLWM
 T9b9Zabf8i5O9DqjlUfFM1EUekwqgQMEhuE4i4kfunsTbnffS9F/OwbeZIXmr/0lf6DZ Gg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tju5j6f9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 02:16:53 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 8 Jul
 2019 02:16:51 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 8 Jul 2019 02:16:52 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id B89913F703F;
        Mon,  8 Jul 2019 02:16:49 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>, <galpress@amazon.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 rdma-next 5/6] RDMA/qedr: Add doorbell overflow recovery support
Date:   Mon, 8 Jul 2019 12:15:02 +0300
Message-ID: <20190708091503.14723-6-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190708091503.14723-1-michal.kalderon@marvell.com>
References: <20190708091503.14723-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_02:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the doorbell recovery mechanism to register rdma related doorbells
that will be restored in case there is a doorbell overflow attention.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c  |   1 +
 drivers/infiniband/hw/qedr/qedr.h  |   7 +
 drivers/infiniband/hw/qedr/verbs.c | 273 ++++++++++++++++++++++++++++++++-----
 drivers/infiniband/hw/qedr/verbs.h |   2 +
 include/uapi/rdma/qedr-abi.h       |  25 ++++
 5 files changed, 273 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 3db4b6ba5ad6..34225c88f03d 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -206,6 +206,7 @@ static const struct ib_device_ops qedr_dev_ops = {
 	.get_link_layer = qedr_link_layer,
 	.map_mr_sg = qedr_map_mr_sg,
 	.mmap = qedr_mmap,
+	.mmap_free = qedr_mmap_free,
 	.modify_port = qedr_modify_port,
 	.modify_qp = qedr_modify_qp,
 	.modify_srq = qedr_modify_srq,
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 7e80ce521d8d..8aed24b32de6 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -231,6 +231,7 @@ struct qedr_ucontext {
 	u64 dpi_phys_addr;
 	u32 dpi_size;
 	u16 dpi;
+	bool db_rec;
 };
 
 union db_prod64 {
@@ -258,6 +259,12 @@ struct qedr_userq {
 	struct qedr_pbl *pbl_tbl;
 	u64 buf_addr;
 	size_t buf_len;
+
+	/* doorbell recovery */
+	void __iomem *db_addr;
+	struct qedr_user_db_rec *db_rec_data;
+	u64 db_rec_phys;
+	u64 db_rec_key;
 };
 
 struct qedr_cq {
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index f33f0f1e7d76..15221d9c7773 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -60,6 +60,7 @@
 
 enum {
 	QEDR_USER_MMAP_IO_WC = 0,
+	QEDR_USER_MMAP_PHYS_PAGE,
 };
 
 static inline int qedr_ib_copy_to_udata(struct ib_udata *udata, void *src,
@@ -266,6 +267,7 @@ int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 	int rc;
 	struct qedr_ucontext *ctx = get_qedr_ucontext(uctx);
 	struct qedr_alloc_ucontext_resp uresp = {};
+	struct qedr_alloc_ucontext_req ureq = {};
 	struct qedr_dev *dev = get_qedr_dev(ibdev);
 	struct qed_rdma_add_user_out_params oparams;
 	u64 key;
@@ -273,6 +275,17 @@ int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 	if (!udata)
 		return -EFAULT;
 
+	if (udata->inlen) {
+		rc = ib_copy_from_udata(&ureq, udata,
+					min(sizeof(ureq), udata->inlen));
+		if (rc) {
+			DP_ERR(dev, "Problem copying data from user space\n");
+			return -EFAULT;
+		}
+
+		ctx->db_rec = !!(ureq.context_flags & QEDR_ALLOC_UCTX_DB_REC);
+	}
+
 	rc = dev->ops->rdma_add_user(dev->rdma_ctx, &oparams);
 	if (rc) {
 		DP_ERR(dev,
@@ -325,6 +338,13 @@ void qedr_dealloc_ucontext(struct ib_ucontext *ibctx)
 	uctx->dev->ops->rdma_remove_user(uctx->dev->rdma_ctx, uctx->dpi);
 }
 
+void qedr_mmap_free(u64 address, u64 length, u8 mmap_flag)
+{
+	/* DMA mapping is already gone, now free the pages */
+	if (mmap_flag == QEDR_USER_MMAP_PHYS_PAGE)
+		free_page((unsigned long)phys_to_virt(address));
+}
+
 int qedr_mmap(struct ib_ucontext *ucontext, struct vm_area_struct *vma)
 {
 	struct ib_device *dev = ucontext->device;
@@ -368,6 +388,11 @@ int qedr_mmap(struct ib_ucontext *ucontext, struct vm_area_struct *vma)
 		err = rdma_user_mmap_io(ucontext, vma, pfn, length,
 					pgprot_writecombine(vma->vm_page_prot));
 		break;
+	case QEDR_USER_MMAP_PHYS_PAGE:
+		err = vm_insert_page(vma, vma->vm_start, pfn_to_page(pfn));
+		if (err)
+			break;
+		break;
 	default:
 		err = -EINVAL;
 	}
@@ -606,16 +631,48 @@ static void qedr_populate_pbls(struct qedr_dev *dev, struct ib_umem *umem,
 	}
 }
 
+static int qedr_db_recovery_add(struct qedr_dev *dev,
+				void __iomem *db_addr,
+				void *db_data,
+				enum qed_db_rec_width db_width,
+				enum qed_db_rec_space db_space)
+{
+	if (!db_data) {
+		DP_DEBUG(dev, QEDR_MSG_INIT, "avoiding db rec since old lib\n");
+		return 0;
+	}
+
+	return dev->ops->common->db_recovery_add(dev->cdev, db_addr, db_data,
+						 db_width, db_space);
+}
+
+static void qedr_db_recovery_del(struct qedr_dev *dev,
+				 void __iomem *db_addr,
+				 void *db_data)
+{
+	if (!db_data) {
+		DP_DEBUG(dev, QEDR_MSG_INIT, "avoiding db rec since old lib\n");
+		return;
+	}
+
+	/* Ignore return code as there is not much we can do about it. Error
+	 * log will be printed inside.
+	 */
+	dev->ops->common->db_recovery_del(dev->cdev, db_addr, db_data);
+}
+
 static int qedr_copy_cq_uresp(struct qedr_dev *dev,
-			      struct qedr_cq *cq, struct ib_udata *udata)
+			      struct qedr_cq *cq, struct ib_udata *udata,
+			      u32 db_offset)
 {
 	struct qedr_create_cq_uresp uresp;
 	int rc;
 
 	memset(&uresp, 0, sizeof(uresp));
 
-	uresp.db_offset = DB_ADDR_SHIFT(DQ_PWM_OFFSET_UCM_RDMA_CQ_CONS_32BIT);
+	uresp.db_offset = db_offset;
 	uresp.icid = cq->icid;
+	uresp.db_rec_addr = cq->q.db_rec_key;
 
 	rc = qedr_ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (rc)
@@ -643,10 +700,42 @@ static inline int qedr_align_cq_entries(int entries)
 	return aligned_size / QEDR_CQE_SIZE;
 }
 
+static int qedr_init_user_db_rec(struct ib_udata *udata,
+				 struct qedr_dev *dev, struct qedr_userq *q,
+				 bool requires_db_rec)
+{
+	struct qedr_ucontext *uctx =
+		rdma_udata_to_drv_context(udata, struct qedr_ucontext,
+					  ibucontext);
+
+	/* Aborting for non doorbell userqueue (SRQ) or non-supporting lib */
+	if (requires_db_rec == 0 || !uctx->db_rec)
+		return 0;
+
+	/* Allocate a page for doorbell recovery, add to mmap ) */
+	q->db_rec_data = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!q->db_rec_data) {
+		DP_ERR(dev,
+		       "get_free_page failed\n");
+		return -ENOMEM;
+	}
+
+	q->db_rec_phys = virt_to_phys(q->db_rec_data);
+	q->db_rec_key = rdma_user_mmap_entry_insert(&uctx->ibucontext, q,
+						    q->db_rec_phys,
+						    PAGE_SIZE,
+						    QEDR_USER_MMAP_PHYS_PAGE);
+	if (q->db_rec_key == RDMA_USER_MMAP_INVALID)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static inline int qedr_init_user_queue(struct ib_udata *udata,
 				       struct qedr_dev *dev,
 				       struct qedr_userq *q, u64 buf_addr,
-				       size_t buf_len, int access, int dmasync,
+				       size_t buf_len, bool requires_db_rec,
+				       int access, int dmasync,
 				       int alloc_and_init)
 {
 	u32 fw_pages;
@@ -684,7 +773,8 @@ static inline int qedr_init_user_queue(struct ib_udata *udata,
 		}
 	}
 
-	return 0;
+	/* mmap the user address used to store doorbell data for recovery */
+	return qedr_init_user_db_rec(udata, dev, q, requires_db_rec);
 
 err0:
 	ib_umem_release(q->umem);
@@ -770,6 +860,7 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	int entries = attr->cqe;
 	struct qedr_cq *cq = get_qedr_cq(ibcq);
 	int chain_entries;
+	u32 db_offset;
 	int page_cnt;
 	u64 pbl_ptr;
 	u16 icid;
@@ -789,8 +880,12 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	chain_entries = qedr_align_cq_entries(entries);
 	chain_entries = min_t(int, chain_entries, QEDR_MAX_CQES);
 
+	/* calc db offset. user will add DPI base, kernel will add db addr */
+	db_offset = DB_ADDR_SHIFT(DQ_PWM_OFFSET_UCM_RDMA_CQ_CONS_32BIT);
+
 	if (udata) {
-		if (ib_copy_from_udata(&ureq, udata, sizeof(ureq))) {
+		if (ib_copy_from_udata(&ureq, udata, min(sizeof(ureq),
+							 udata->inlen))) {
 			DP_ERR(dev,
 			       "create cq: problem copying data from user space\n");
 			goto err0;
@@ -805,8 +900,9 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		cq->cq_type = QEDR_CQ_TYPE_USER;
 
 		rc = qedr_init_user_queue(udata, dev, &cq->q, ureq.addr,
-					  ureq.len, IB_ACCESS_LOCAL_WRITE, 1,
-					  1);
+					  ureq.len, true,
+					  IB_ACCESS_LOCAL_WRITE,
+					  1, 1);
 		if (rc)
 			goto err0;
 
@@ -814,6 +910,7 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		page_cnt = cq->q.pbl_info.num_pbes;
 
 		cq->ibcq.cqe = chain_entries;
+		cq->q.db_addr = ctx->dpi_addr + db_offset;
 	} else {
 		cq->cq_type = QEDR_CQ_TYPE_KERNEL;
 
@@ -844,14 +941,21 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	spin_lock_init(&cq->cq_lock);
 
 	if (udata) {
-		rc = qedr_copy_cq_uresp(dev, cq, udata);
+		rc = qedr_copy_cq_uresp(dev, cq, udata, db_offset);
+		if (rc)
+			goto err3;
+
+		rc = qedr_db_recovery_add(dev, cq->q.db_addr,
+					  &cq->q.db_rec_data->db_data,
+					  DB_REC_WIDTH_64B,
+					  DB_REC_USER);
 		if (rc)
 			goto err3;
+
 	} else {
 		/* Generate doorbell address. */
-		cq->db_addr = dev->db_addr +
-		    DB_ADDR_SHIFT(DQ_PWM_OFFSET_UCM_RDMA_CQ_CONS_32BIT);
 		cq->db.data.icid = cq->icid;
+		cq->db_addr = dev->db_addr + db_offset;
 		cq->db.data.params = DB_AGG_CMD_SET <<
 		    RDMA_PWM_VAL32_DATA_AGG_CMD_SHIFT;
 
@@ -861,6 +965,11 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		cq->latest_cqe = NULL;
 		consume_cqe(cq);
 		cq->cq_cons = qed_chain_get_cons_idx_u32(&cq->pbl);
+
+		rc = qedr_db_recovery_add(dev, cq->db_addr, &cq->db.data,
+					  DB_REC_WIDTH_64B, DB_REC_KERNEL);
+		if (rc)
+			goto err3;
 	}
 
 	DP_DEBUG(dev, QEDR_MSG_CQ,
@@ -879,8 +988,18 @@ int qedr_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	else
 		dev->ops->common->chain_free(dev->cdev, &cq->pbl);
 err1:
-	if (udata)
+	if (udata) {
 		ib_umem_release(cq->q.umem);
+		if (cq->q.db_rec_data) {
+			qedr_db_recovery_del(dev, cq->q.db_addr,
+					     &cq->q.db_rec_data->db_data);
+			if (cq->q.db_rec_key == RDMA_USER_MMAP_INVALID)
+				free_page((unsigned long)cq->q.db_rec_data);
+			/* o/w will be freed by ib_uverbs on context free */
+		}
+	} else {
+		qedr_db_recovery_del(dev, cq->db_addr, &cq->db.data);
+	}
 err0:
 	return -EINVAL;
 }
@@ -911,8 +1030,10 @@ void qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	cq->destroyed = 1;
 
 	/* GSIs CQs are handled by driver, so they don't exist in the FW */
-	if (cq->cq_type == QEDR_CQ_TYPE_GSI)
+	if (cq->cq_type == QEDR_CQ_TYPE_GSI) {
+		qedr_db_recovery_del(dev, cq->db_addr, &cq->db.data);
 		return;
+	}
 
 	iparams.icid = cq->icid;
 	dev->ops->rdma_destroy_cq(dev->rdma_ctx, &iparams, &oparams);
@@ -921,6 +1042,12 @@ void qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	if (udata) {
 		qedr_free_pbl(dev, &cq->q.pbl_info, cq->q.pbl_tbl);
 		ib_umem_release(cq->q.umem);
+
+		if (cq->q.db_rec_data)
+			qedr_db_recovery_del(dev, cq->q.db_addr,
+					     &cq->q.db_rec_data->db_data);
+	} else {
+		qedr_db_recovery_del(dev, cq->db_addr, &cq->db.data);
 	}
 
 	/* We don't want the IRQ handler to handle a non-existing CQ so we
@@ -1085,8 +1212,8 @@ static int qedr_copy_srq_uresp(struct qedr_dev *dev,
 }
 
 static void qedr_copy_rq_uresp(struct qedr_dev *dev,
-			       struct qedr_create_qp_uresp *uresp,
-			       struct qedr_qp *qp)
+			      struct qedr_create_qp_uresp *uresp,
+			      struct qedr_qp *qp)
 {
 	/* iWARP requires two doorbells per RQ. */
 	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
@@ -1099,6 +1226,7 @@ static void qedr_copy_rq_uresp(struct qedr_dev *dev,
 	}
 
 	uresp->rq_icid = qp->icid;
+	uresp->rq_db_rec_addr = qp->urq.db_rec_key;
 }
 
 static void qedr_copy_sq_uresp(struct qedr_dev *dev,
@@ -1112,22 +1240,24 @@ static void qedr_copy_sq_uresp(struct qedr_dev *dev,
 		uresp->sq_icid = qp->icid;
 	else
 		uresp->sq_icid = qp->icid + 1;
+
+	uresp->sq_db_rec_addr = qp->usq.db_rec_key;
 }
 
 static int qedr_copy_qp_uresp(struct qedr_dev *dev,
-			      struct qedr_qp *qp, struct ib_udata *udata)
+			      struct qedr_qp *qp, struct ib_udata *udata,
+			      struct qedr_create_qp_uresp *uresp)
 {
-	struct qedr_create_qp_uresp uresp;
 	int rc;
 
-	memset(&uresp, 0, sizeof(uresp));
-	qedr_copy_sq_uresp(dev, &uresp, qp);
-	qedr_copy_rq_uresp(dev, &uresp, qp);
+	memset(uresp, 0, sizeof(*uresp));
+	qedr_copy_sq_uresp(dev, uresp, qp);
+	qedr_copy_rq_uresp(dev, uresp, qp);
 
-	uresp.atomic_supported = dev->atomic_cap != IB_ATOMIC_NONE;
-	uresp.qp_id = qp->qp_id;
+	uresp->atomic_supported = dev->atomic_cap != IB_ATOMIC_NONE;
+	uresp->qp_id = qp->qp_id;
 
-	rc = qedr_ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+	rc = qedr_ib_copy_to_udata(udata, uresp, sizeof(*uresp));
 	if (rc)
 		DP_ERR(dev,
 		       "create qp: failed a copy to user space with qp icid=0x%x.\n",
@@ -1171,16 +1301,35 @@ static void qedr_set_common_qp_params(struct qedr_dev *dev,
 		 qp->sq.max_sges, qp->sq_cq->icid);
 }
 
-static void qedr_set_roce_db_info(struct qedr_dev *dev, struct qedr_qp *qp)
+static int qedr_set_roce_db_info(struct qedr_dev *dev, struct qedr_qp *qp)
 {
+	int rc;
+
 	qp->sq.db = dev->db_addr +
 		    DB_ADDR_SHIFT(DQ_PWM_OFFSET_XCM_RDMA_SQ_PROD);
 	qp->sq.db_data.data.icid = qp->icid + 1;
+	rc = qedr_db_recovery_add(dev, qp->sq.db,
+				  &qp->sq.db_data,
+				  DB_REC_WIDTH_32B,
+				  DB_REC_KERNEL);
+	if (rc)
+		return rc;
+
 	if (!qp->srq) {
 		qp->rq.db = dev->db_addr +
 			    DB_ADDR_SHIFT(DQ_PWM_OFFSET_TCM_ROCE_RQ_PROD);
 		qp->rq.db_data.data.icid = qp->icid;
+
+		rc = qedr_db_recovery_add(dev, qp->rq.db,
+					  &qp->rq.db_data,
+					  DB_REC_WIDTH_32B,
+					  DB_REC_KERNEL);
+		if (rc)
+			qedr_db_recovery_del(dev, qp->sq.db,
+					     &qp->sq.db_data);
 	}
+
+	return rc;
 }
 
 static int qedr_check_srq_params(struct qedr_dev *dev,
@@ -1234,7 +1383,7 @@ static int qedr_init_srq_user_params(struct ib_udata *udata,
 	int rc;
 
 	rc = qedr_init_user_queue(udata, srq->dev, &srq->usrq, ureq->srq_addr,
-				  ureq->srq_len, access, dmasync, 1);
+				  ureq->srq_len, false, access, dmasync, 1);
 	if (rc)
 		return rc;
 
@@ -1330,7 +1479,8 @@ int qedr_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *init_attr,
 	hw_srq->max_sges = init_attr->attr.max_sge;
 
 	if (udata) {
-		if (ib_copy_from_udata(&ureq, udata, sizeof(ureq))) {
+		if (ib_copy_from_udata(&ureq, udata, min(sizeof(ureq),
+							 udata->inlen))) {
 			DP_ERR(dev,
 			       "create srq: problem copying data from user space\n");
 			goto err0;
@@ -1526,6 +1676,14 @@ static void qedr_cleanup_user(struct qedr_dev *dev, struct qedr_qp *qp)
 
 	ib_umem_release(qp->urq.umem);
 	qp->urq.umem = NULL;
+
+	if (qp->usq.db_rec_data)
+		qedr_db_recovery_del(dev, qp->usq.db_addr,
+				     &qp->usq.db_rec_data->db_data);
+
+	if (qp->urq.db_rec_data)
+		qedr_db_recovery_del(dev, qp->urq.db_addr,
+				     &qp->urq.db_rec_data->db_data);
 }
 
 static int qedr_create_user_qp(struct qedr_dev *dev,
@@ -1537,12 +1695,14 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	struct qed_rdma_create_qp_in_params in_params;
 	struct qed_rdma_create_qp_out_params out_params;
 	struct qedr_pd *pd = get_qedr_pd(ibpd);
+	struct qedr_create_qp_uresp uresp;
+	struct qedr_ucontext *ctx = NULL;
 	struct qedr_create_qp_ureq ureq;
 	int alloc_and_init = rdma_protocol_roce(&dev->ibdev, 1);
 	int rc = -EINVAL;
 
 	memset(&ureq, 0, sizeof(ureq));
-	rc = ib_copy_from_udata(&ureq, udata, sizeof(ureq));
+	rc = ib_copy_from_udata(&ureq, udata, min(sizeof(ureq), udata->inlen));
 	if (rc) {
 		DP_ERR(dev, "Problem copying data from user space\n");
 		return rc;
@@ -1550,14 +1710,16 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 
 	/* SQ - read access only (0), dma sync not required (0) */
 	rc = qedr_init_user_queue(udata, dev, &qp->usq, ureq.sq_addr,
-				  ureq.sq_len, 0, 0, alloc_and_init);
+				  ureq.sq_len, true, 0, 0,
+				  alloc_and_init);
 	if (rc)
 		return rc;
 
 	if (!qp->srq) {
 		/* RQ - read access only (0), dma sync not required (0) */
 		rc = qedr_init_user_queue(udata, dev, &qp->urq, ureq.rq_addr,
-					  ureq.rq_len, 0, 0, alloc_and_init);
+					  ureq.rq_len, true,
+					  0, 0, alloc_and_init);
 		if (rc)
 			return rc;
 	}
@@ -1587,13 +1749,31 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	qp->qp_id = out_params.qp_id;
 	qp->icid = out_params.icid;
 
-	rc = qedr_copy_qp_uresp(dev, qp, udata);
+	rc = qedr_copy_qp_uresp(dev, qp, udata, &uresp);
 	if (rc)
 		goto err;
 
+	/* db offset was calculated in copy_qp_uresp, now set in the user q */
+	ctx = pd->uctx;
+	qp->usq.db_addr = ctx->dpi_addr + uresp.sq_db_offset;
+	qp->urq.db_addr = ctx->dpi_addr + uresp.rq_db_offset;
+
+	rc = qedr_db_recovery_add(dev, qp->usq.db_addr,
+				  &qp->usq.db_rec_data->db_data,
+				  DB_REC_WIDTH_32B,
+				  DB_REC_USER);
+	if (rc)
+		goto err;
+
+	rc = qedr_db_recovery_add(dev, qp->urq.db_addr,
+				  &qp->urq.db_rec_data->db_data,
+				  DB_REC_WIDTH_32B,
+				  DB_REC_USER);
+	if (rc)
+		goto err;
 	qedr_qp_user_print(dev, qp);
 
-	return 0;
+	return rc;
 err:
 	rc = dev->ops->rdma_destroy_qp(dev->rdma_ctx, qp->qed_qp);
 	if (rc)
@@ -1604,12 +1784,21 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	return rc;
 }
 
-static void qedr_set_iwarp_db_info(struct qedr_dev *dev, struct qedr_qp *qp)
+static int qedr_set_iwarp_db_info(struct qedr_dev *dev, struct qedr_qp *qp)
 {
+	int rc;
+
 	qp->sq.db = dev->db_addr +
 	    DB_ADDR_SHIFT(DQ_PWM_OFFSET_XCM_RDMA_SQ_PROD);
 	qp->sq.db_data.data.icid = qp->icid;
 
+	rc = qedr_db_recovery_add(dev, qp->sq.db,
+				  &qp->sq.db_data,
+				  DB_REC_WIDTH_32B,
+				  DB_REC_KERNEL);
+	if (rc)
+		return rc;
+
 	qp->rq.db = dev->db_addr +
 		    DB_ADDR_SHIFT(DQ_PWM_OFFSET_TCM_IWARP_RQ_PROD);
 	qp->rq.db_data.data.icid = qp->icid;
@@ -1617,6 +1806,13 @@ static void qedr_set_iwarp_db_info(struct qedr_dev *dev, struct qedr_qp *qp)
 			   DB_ADDR_SHIFT(DQ_PWM_OFFSET_TCM_FLAGS);
 	qp->rq.iwarp_db2_data.data.icid = qp->icid;
 	qp->rq.iwarp_db2_data.data.value = DQ_TCM_IWARP_POST_RQ_CF_CMD;
+
+	rc = qedr_db_recovery_add(dev, qp->rq.db,
+				  &qp->rq.db_data,
+				  DB_REC_WIDTH_32B,
+				  DB_REC_KERNEL);
+
+	return rc;
 }
 
 static int
@@ -1664,8 +1860,7 @@ qedr_roce_create_kernel_qp(struct qedr_dev *dev,
 	qp->qp_id = out_params.qp_id;
 	qp->icid = out_params.icid;
 
-	qedr_set_roce_db_info(dev, qp);
-	return rc;
+	return qedr_set_roce_db_info(dev, qp);
 }
 
 static int
@@ -1723,8 +1918,7 @@ qedr_iwarp_create_kernel_qp(struct qedr_dev *dev,
 	qp->qp_id = out_params.qp_id;
 	qp->icid = out_params.icid;
 
-	qedr_set_iwarp_db_info(dev, qp);
-	return rc;
+	return qedr_set_iwarp_db_info(dev, qp);
 
 err:
 	dev->ops->rdma_destroy_qp(dev->rdma_ctx, qp->qed_qp);
@@ -1739,6 +1933,15 @@ static void qedr_cleanup_kernel(struct qedr_dev *dev, struct qedr_qp *qp)
 
 	dev->ops->common->chain_free(dev->cdev, &qp->rq.pbl);
 	kfree(qp->rqe_wr_id);
+
+	/* GSI qp is not registered to db mechanism so no need to delete */
+	if (qp->qp_type == IB_QPT_GSI)
+		return;
+
+	qedr_db_recovery_del(dev, qp->sq.db, &qp->sq.db_data);
+
+	if (!qp->srq)
+		qedr_db_recovery_del(dev, qp->rq.db, &qp->rq.db_data);
 }
 
 static int qedr_create_kernel_qp(struct qedr_dev *dev,
diff --git a/drivers/infiniband/hw/qedr/verbs.h b/drivers/infiniband/hw/qedr/verbs.h
index 724d0983e972..21f0ee356bef 100644
--- a/drivers/infiniband/hw/qedr/verbs.h
+++ b/drivers/infiniband/hw/qedr/verbs.h
@@ -47,6 +47,8 @@ int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata);
 void qedr_dealloc_ucontext(struct ib_ucontext *uctx);
 
 int qedr_mmap(struct ib_ucontext *ucontext, struct vm_area_struct *vma);
+void qedr_mmap_free(u64 address, u64 length, u8 mmap_flag);
+
 int qedr_alloc_pd(struct ib_pd *pd, struct ib_udata *udata);
 void qedr_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
 
diff --git a/include/uapi/rdma/qedr-abi.h b/include/uapi/rdma/qedr-abi.h
index 7a10b3a325fa..c022ee26089b 100644
--- a/include/uapi/rdma/qedr-abi.h
+++ b/include/uapi/rdma/qedr-abi.h
@@ -38,6 +38,15 @@
 #define QEDR_ABI_VERSION		(8)
 
 /* user kernel communication data structures. */
+enum qedr_alloc_ucontext_flags {
+	QEDR_ALLOC_UCTX_RESERVED	= 1 << 0,
+	QEDR_ALLOC_UCTX_DB_REC		= 1 << 1
+};
+
+struct qedr_alloc_ucontext_req {
+	__u32 context_flags;
+	__u32 reserved;
+};
 
 struct qedr_alloc_ucontext_resp {
 	__aligned_u64 db_pa;
@@ -74,6 +83,7 @@ struct qedr_create_cq_uresp {
 	__u32 db_offset;
 	__u16 icid;
 	__u16 reserved;
+	__aligned_u64 db_rec_addr;
 };
 
 struct qedr_create_qp_ureq {
@@ -109,6 +119,13 @@ struct qedr_create_qp_uresp {
 
 	__u32 rq_db2_offset;
 	__u32 reserved;
+
+	/* address of SQ doorbell recovery user entry */
+	__aligned_u64 sq_db_rec_addr;
+
+	/* address of RQ doorbell recovery user entry */
+	__aligned_u64 rq_db_rec_addr;
+
 };
 
 struct qedr_create_srq_ureq {
@@ -128,4 +145,12 @@ struct qedr_create_srq_uresp {
 	__u32 reserved1;
 };
 
+/* doorbell recovery entry allocated and populated by userspace doorbelling
+ * entities and mapped to kernel. Kernel uses this to register doorbell
+ * information with doorbell drop recovery mechanism.
+ */
+struct qedr_user_db_rec {
+	__aligned_u64 db_data; /* doorbell data */
+};
+
 #endif /* __QEDR_USER_H__ */
-- 
2.14.5

