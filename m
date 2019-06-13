Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFC644202
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391878AbfFMQSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:18:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38040 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731104AbfFMIkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:40:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D8bXjG020216;
        Thu, 13 Jun 2019 01:39:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=FFIlDSp+q8wzFijXmmG+e4u+Q/qrK4J7+xLpzOIT34k=;
 b=WLV9HAaaJip0De2YLIVjx+Dxe/qJiJlnRfoXvUZ8TvXNRbDA12i5tzjtxznFOU96SVdy
 yyfiGsAwl4uweOxYV091g5Dz8HXyyuY4wCKK3bOay9xOeSf5sWtSZYggd3jWRzp8hhVD
 FbVmMqUxIBNuuTuBXx0b9p1G+PX+Q6hJI17YWTK0G4hO9UOHSbHWIXdxee6ED5k1Ew+a
 z+UGQOUfL7AGa58VLx9j9h22R7D57kWjZpBD+U7yfHabDXkCOIdDGtnTWetGUyIgbmqS
 QCb89u04JbJQwaM21rj4S2BvH49+gf0nkno1xkJ2oY49ePo2U2aJn7CBE4a9Sa9P2uad ow== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2t3j8206jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 01:39:42 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 13 Jun
 2019 01:39:41 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 13 Jun 2019 01:39:41 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id E29B43F703F;
        Thu, 13 Jun 2019 01:39:39 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 rdma-next 2/3] RDMA/qedr: Add doorbell overflow recovery support
Date:   Thu, 13 Jun 2019 11:38:18 +0300
Message-ID: <20190613083819.6998-3-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190613083819.6998-1-michal.kalderon@marvell.com>
References: <20190613083819.6998-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_05:,,
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
 drivers/infiniband/hw/qedr/qedr.h  |  13 +-
 drivers/infiniband/hw/qedr/verbs.c | 351 ++++++++++++++++++++++++++++++-------
 include/uapi/rdma/qedr-abi.h       |  25 +++
 3 files changed, 329 insertions(+), 60 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 8df56aba9d2c..006712ac1c88 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -231,7 +231,7 @@ struct qedr_ucontext {
 	u64 dpi_phys_addr;
 	u32 dpi_size;
 	u16 dpi;
-
+	bool db_rec;
 	struct list_head mm_head;
 
 	/* Lock to protect mm list */
@@ -263,6 +263,11 @@ struct qedr_userq {
 	struct qedr_pbl *pbl_tbl;
 	u64 buf_addr;
 	size_t buf_len;
+
+	/* doorbell recovery */
+	void __iomem *db_addr;
+	struct qedr_user_db_rec *db_rec_data;
+	u64 db_rec_phys;
 };
 
 struct qedr_cq {
@@ -298,11 +303,17 @@ struct qedr_pd {
 	struct qedr_ucontext *uctx;
 };
 
+enum qedr_mm_type {
+	QEDR_MM_TYPE_DB_BAR,
+	QEDR_MM_TYPE_DB_REC
+};
+
 struct qedr_mm {
 	struct {
 		u64 phy_addr;
 		unsigned long len;
 	} key;
+	enum qedr_mm_type type;
 	struct list_head entry;
 };
 
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 3c0dba072071..4c19e172ecd6 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -257,7 +257,7 @@ int qedr_modify_port(struct ib_device *ibdev, u8 port, int mask,
 }
 
 static int qedr_add_mmap(struct qedr_ucontext *uctx, u64 phy_addr,
-			 unsigned long len)
+			 unsigned long len, enum qedr_mm_type type)
 {
 	struct qedr_mm *mm;
 
@@ -265,6 +265,7 @@ static int qedr_add_mmap(struct qedr_ucontext *uctx, u64 phy_addr,
 	if (!mm)
 		return -ENOMEM;
 
+	mm->type = type;
 	mm->key.phy_addr = phy_addr;
 	/* This function might be called with a length which is not a multiple
 	 * of PAGE_SIZE, while the mapping is PAGE_SIZE grained and the kernel
@@ -281,24 +282,26 @@ static int qedr_add_mmap(struct qedr_ucontext *uctx, u64 phy_addr,
 	mutex_unlock(&uctx->mm_list_lock);
 
 	DP_DEBUG(uctx->dev, QEDR_MSG_MISC,
-		 "added (addr=0x%llx,len=0x%lx) for ctx=%p\n",
+		 "added (addr=0x%llx,len=0x%lx,type=%s) for ctx=%p\n",
 		 (unsigned long long)mm->key.phy_addr,
-		 (unsigned long)mm->key.len, uctx);
+		 (unsigned long)mm->key.len,
+		 (type == QEDR_MM_TYPE_DB_REC) ? "DB_REC" : "DB_BAR",
+		 uctx);
 
 	return 0;
 }
 
-static bool qedr_search_mmap(struct qedr_ucontext *uctx, u64 phy_addr,
-			     unsigned long len)
+static struct qedr_mm *qedr_remove_mmap(struct qedr_ucontext *uctx,
+					u64 phy_addr, unsigned long len)
 {
+	struct qedr_mm *mm, *tmp;
 	bool found = false;
-	struct qedr_mm *mm;
 
 	mutex_lock(&uctx->mm_list_lock);
-	list_for_each_entry(mm, &uctx->mm_head, entry) {
+	list_for_each_entry_safe(mm, tmp, &uctx->mm_head, entry) {
 		if (len != mm->key.len || phy_addr != mm->key.phy_addr)
 			continue;
-
+		list_del_init(&mm->entry);
 		found = true;
 		break;
 	}
@@ -307,7 +310,10 @@ static bool qedr_search_mmap(struct qedr_ucontext *uctx, u64 phy_addr,
 		 "searched for (addr=0x%llx,len=0x%lx) for ctx=%p, result=%d\n",
 		 mm->key.phy_addr, mm->key.len, uctx, found);
 
-	return found;
+	if (found)
+		return mm;
+
+	return NULL;
 }
 
 int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
@@ -316,12 +322,24 @@ int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 	int rc;
 	struct qedr_ucontext *ctx = get_qedr_ucontext(uctx);
 	struct qedr_alloc_ucontext_resp uresp = {};
+	struct qedr_alloc_ucontext_req ureq = {};
 	struct qedr_dev *dev = get_qedr_dev(ibdev);
 	struct qed_rdma_add_user_out_params oparams;
 
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
@@ -356,7 +374,8 @@ int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 
 	ctx->dev = dev;
 
-	rc = qedr_add_mmap(ctx, ctx->dpi_phys_addr, ctx->dpi_size);
+	rc = qedr_add_mmap(ctx, ctx->dpi_phys_addr, ctx->dpi_size,
+			   QEDR_MM_TYPE_DB_BAR);
 	if (rc)
 		return rc;
 
@@ -383,6 +402,43 @@ void qedr_dealloc_ucontext(struct ib_ucontext *ibctx)
 	}
 }
 
+/* Map the doorbell bar */
+int qedr_mmap_db_bar(struct qedr_dev *dev, struct qedr_ucontext *ucontext,
+		     struct vm_area_struct *vma, unsigned long dpi_start)
+{
+	unsigned long phys_addr = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long len = (vma->vm_end - vma->vm_start);
+
+	if (phys_addr < dpi_start ||
+	    ((phys_addr + len) > (dpi_start + ucontext->dpi_size))) {
+		DP_ERR(dev,
+		       "failed mmap, pages are outside of dpi; page address=0x%pK, dpi_start=0x%pK, dpi_size=0x%x\n",
+		       (void *)phys_addr, (void *)dpi_start,
+		       ucontext->dpi_size);
+		return -EINVAL;
+	}
+
+	if (vma->vm_flags & VM_READ) {
+		DP_ERR(dev, "failed mmap, cannot map doorbell bar for read\n");
+		return -EINVAL;
+	}
+
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+
+	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff, len,
+				  vma->vm_page_prot);
+}
+
+/* Map the kernel doorbell recovery memory entry */
+int qedr_mmap_db_rec(struct vm_area_struct *vma)
+{
+	unsigned long len = vma->vm_end - vma->vm_start;
+
+	return remap_pfn_range(vma, vma->vm_start,
+			       vma->vm_pgoff,
+			       len, vma->vm_page_prot);
+}
+
 int qedr_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
 	struct qedr_ucontext *ucontext = get_qedr_ucontext(context);
@@ -390,6 +446,8 @@ int qedr_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	unsigned long phys_addr = vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long len = (vma->vm_end - vma->vm_start);
 	unsigned long dpi_start;
+	struct qedr_mm *mm;
+	int rc;
 
 	dpi_start = dev->db_phys_addr + (ucontext->dpi * ucontext->dpi_size);
 
@@ -405,29 +463,28 @@ int qedr_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
-	if (!qedr_search_mmap(ucontext, phys_addr, len)) {
-		DP_ERR(dev, "failed mmap, vm_pgoff=0x%lx is not authorized\n",
+	mm = qedr_remove_mmap(ucontext, phys_addr, len);
+	if (!mm) {
+		DP_ERR(dev, "failed to remove mmap, vm_pgoff=0x%lx\n",
 		       vma->vm_pgoff);
 		return -EINVAL;
 	}
 
-	if (phys_addr < dpi_start ||
-	    ((phys_addr + len) > (dpi_start + ucontext->dpi_size))) {
-		DP_ERR(dev,
-		       "failed mmap, pages are outside of dpi; page address=0x%pK, dpi_start=0x%pK, dpi_size=0x%x\n",
-		       (void *)phys_addr, (void *)dpi_start,
-		       ucontext->dpi_size);
-		return -EINVAL;
+	switch (mm->type) {
+	case QEDR_MM_TYPE_DB_BAR:
+		rc = qedr_mmap_db_bar(dev, ucontext, vma, dpi_start);
+		break;
+	case QEDR_MM_TYPE_DB_REC:
+		rc = qedr_mmap_db_rec(vma);
+		break;
+	default:
+		rc = -EINVAL;
+		break;
 	}
 
-	if (vma->vm_flags & VM_READ) {
-		DP_ERR(dev, "failed mmap, cannot map doorbell bar for read\n");
-		return -EINVAL;
-	}
+	kfree(mm);
 
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff, len,
-				  vma->vm_page_prot);
+	return rc;
 }
 
 int qedr_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
@@ -657,16 +714,48 @@ static void qedr_populate_pbls(struct qedr_dev *dev, struct ib_umem *umem,
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
+	uresp.db_rec_addr = cq->q.db_rec_phys;
 
 	rc = qedr_ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (rc)
@@ -694,10 +783,36 @@ static inline int qedr_align_cq_entries(int entries)
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
+	return qedr_add_mmap(uctx, q->db_rec_phys, PAGE_SIZE,
+			     QEDR_MM_TYPE_DB_REC);
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
@@ -735,7 +850,8 @@ static inline int qedr_init_user_queue(struct ib_udata *udata,
 		}
 	}
 
-	return 0;
+	/* mmap the user address used to store doorbell data for recovery */
+	return qedr_init_user_db_rec(udata, dev, q, requires_db_rec);
 
 err0:
 	ib_umem_release(q->umem);
@@ -821,6 +937,7 @@ struct ib_cq *qedr_create_cq(struct ib_device *ibdev,
 	int entries = attr->cqe;
 	struct qedr_cq *cq;
 	int chain_entries;
+	u32 db_offset;
 	int page_cnt;
 	u64 pbl_ptr;
 	u16 icid;
@@ -844,9 +961,13 @@ struct ib_cq *qedr_create_cq(struct ib_device *ibdev,
 	if (!cq)
 		return ERR_PTR(-ENOMEM);
 
+	/* calc db offset. user will add DPI base, kernel will add db addr */
+	db_offset = DB_ADDR_SHIFT(DQ_PWM_OFFSET_UCM_RDMA_CQ_CONS_32BIT);
+
 	if (udata) {
 		memset(&ureq, 0, sizeof(ureq));
-		if (ib_copy_from_udata(&ureq, udata, sizeof(ureq))) {
+		if (ib_copy_from_udata(&ureq, udata, min(sizeof(ureq),
+							 udata->inlen))) {
 			DP_ERR(dev,
 			       "create cq: problem copying data from user space\n");
 			goto err0;
@@ -861,8 +982,9 @@ struct ib_cq *qedr_create_cq(struct ib_device *ibdev,
 		cq->cq_type = QEDR_CQ_TYPE_USER;
 
 		rc = qedr_init_user_queue(udata, dev, &cq->q, ureq.addr,
-					  ureq.len, IB_ACCESS_LOCAL_WRITE, 1,
-					  1);
+					  ureq.len, true,
+					  IB_ACCESS_LOCAL_WRITE,
+					  1, 1);
 		if (rc)
 			goto err0;
 
@@ -870,6 +992,7 @@ struct ib_cq *qedr_create_cq(struct ib_device *ibdev,
 		page_cnt = cq->q.pbl_info.num_pbes;
 
 		cq->ibcq.cqe = chain_entries;
+		cq->q.db_addr = (u8 __iomem *)ctx->dpi_addr + db_offset;
 	} else {
 		cq->cq_type = QEDR_CQ_TYPE_KERNEL;
 
@@ -900,14 +1023,21 @@ struct ib_cq *qedr_create_cq(struct ib_device *ibdev,
 	spin_lock_init(&cq->cq_lock);
 
 	if (udata) {
-		rc = qedr_copy_cq_uresp(dev, cq, udata);
+		rc = qedr_copy_cq_uresp(dev, cq, udata, db_offset);
 		if (rc)
 			goto err3;
+
+		rc = qedr_db_recovery_add(dev, cq->q.db_addr,
+					  &cq->q.db_rec_data->db_data,
+					  DB_REC_WIDTH_64B,
+					  DB_REC_USER);
+		if (rc)
+			goto err3;
+
 	} else {
 		/* Generate doorbell address. */
-		cq->db_addr = dev->db_addr +
-		    DB_ADDR_SHIFT(DQ_PWM_OFFSET_UCM_RDMA_CQ_CONS_32BIT);
 		cq->db.data.icid = cq->icid;
+		cq->db_addr = dev->db_addr + db_offset;
 		cq->db.data.params = DB_AGG_CMD_SET <<
 		    RDMA_PWM_VAL32_DATA_AGG_CMD_SHIFT;
 
@@ -917,6 +1047,11 @@ struct ib_cq *qedr_create_cq(struct ib_device *ibdev,
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
@@ -935,8 +1070,16 @@ struct ib_cq *qedr_create_cq(struct ib_device *ibdev,
 	else
 		dev->ops->common->chain_free(dev->cdev, &cq->pbl);
 err1:
-	if (udata)
+	if (udata) {
 		ib_umem_release(cq->q.umem);
+		if (cq->q.db_rec_data) {
+			qedr_db_recovery_del(dev, cq->q.db_addr,
+					     &cq->q.db_rec_data->db_data);
+			free_page((unsigned long)cq->q.db_rec_data);
+		}
+	} else {
+		qedr_db_recovery_del(dev, cq->db_addr, &cq->db.data);
+	}
 err0:
 	kfree(cq);
 	return ERR_PTR(-EINVAL);
@@ -969,8 +1112,10 @@ int qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	cq->destroyed = 1;
 
 	/* GSIs CQs are handled by driver, so they don't exist in the FW */
-	if (cq->cq_type == QEDR_CQ_TYPE_GSI)
+	if (cq->cq_type == QEDR_CQ_TYPE_GSI) {
+		qedr_db_recovery_del(dev, cq->db_addr, &cq->db.data);
 		goto done;
+	}
 
 	iparams.icid = cq->icid;
 	rc = dev->ops->rdma_destroy_cq(dev->rdma_ctx, &iparams, &oparams);
@@ -982,6 +1127,14 @@ int qedr_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	if (udata) {
 		qedr_free_pbl(dev, &cq->q.pbl_info, cq->q.pbl_tbl);
 		ib_umem_release(cq->q.umem);
+
+		if (cq->q.db_rec_data) {
+			qedr_db_recovery_del(dev, cq->q.db_addr,
+					     &cq->q.db_rec_data->db_data);
+			free_page((unsigned long)cq->q.db_rec_data);
+		}
+	} else {
+		qedr_db_recovery_del(dev, cq->db_addr, &cq->db.data);
 	}
 
 	/* We don't want the IRQ handler to handle a non-existing CQ so we
@@ -1176,6 +1329,7 @@ static void qedr_copy_rq_uresp(struct qedr_dev *dev,
 	}
 
 	uresp->rq_icid = qp->icid;
+	uresp->rq_db_rec_addr = qp->urq.db_rec_phys;
 }
 
 static void qedr_copy_sq_uresp(struct qedr_dev *dev,
@@ -1189,22 +1343,24 @@ static void qedr_copy_sq_uresp(struct qedr_dev *dev,
 		uresp->sq_icid = qp->icid;
 	else
 		uresp->sq_icid = qp->icid + 1;
+
+	uresp->sq_db_rec_addr = qp->usq.db_rec_phys;
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
@@ -1248,16 +1404,35 @@ static void qedr_set_common_qp_params(struct qedr_dev *dev,
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
@@ -1311,7 +1486,7 @@ static int qedr_init_srq_user_params(struct ib_udata *udata,
 	int rc;
 
 	rc = qedr_init_user_queue(udata, srq->dev, &srq->usrq, ureq->srq_addr,
-				  ureq->srq_len, access, dmasync, 1);
+				  ureq->srq_len, false, access, dmasync, 1);
 	if (rc)
 		return rc;
 
@@ -1407,7 +1582,8 @@ int qedr_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *init_attr,
 	hw_srq->max_sges = init_attr->attr.max_sge;
 
 	if (udata) {
-		if (ib_copy_from_udata(&ureq, udata, sizeof(ureq))) {
+		if (ib_copy_from_udata(&ureq, udata, min(sizeof(ureq),
+							 udata->inlen))) {
 			DP_ERR(dev,
 			       "create srq: problem copying data from user space\n");
 			goto err0;
@@ -1605,6 +1781,18 @@ static void qedr_cleanup_user(struct qedr_dev *dev, struct qedr_qp *qp)
 	if (qp->urq.umem)
 		ib_umem_release(qp->urq.umem);
 	qp->urq.umem = NULL;
+
+	if (qp->usq.db_rec_data) {
+		qedr_db_recovery_del(dev, qp->usq.db_addr,
+				     &qp->usq.db_rec_data->db_data);
+		free_page((unsigned long)qp->usq.db_rec_data);
+	}
+
+	if (qp->urq.db_rec_data) {
+		qedr_db_recovery_del(dev, qp->urq.db_addr,
+				     &qp->urq.db_rec_data->db_data);
+		free_page((unsigned long)qp->urq.db_rec_data);
+	}
 }
 
 static int qedr_create_user_qp(struct qedr_dev *dev,
@@ -1616,12 +1804,14 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
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
@@ -1629,14 +1819,16 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 
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
@@ -1666,13 +1858,31 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	qp->qp_id = out_params.qp_id;
 	qp->icid = out_params.icid;
 
-	rc = qedr_copy_qp_uresp(dev, qp, udata);
+	rc = qedr_copy_qp_uresp(dev, qp, udata, &uresp);
 	if (rc)
 		goto err;
 
+	/* db offset was calculated in copy_qp_uresp, now set in the user q */
+	ctx = pd->uctx;
+	qp->usq.db_addr = (u8 __iomem *)ctx->dpi_addr + uresp.sq_db_offset;
+	qp->urq.db_addr = (u8 __iomem *)ctx->dpi_addr + uresp.rq_db_offset;
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
@@ -1683,12 +1893,21 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
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
@@ -1696,6 +1915,13 @@ static void qedr_set_iwarp_db_info(struct qedr_dev *dev, struct qedr_qp *qp)
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
@@ -1743,8 +1969,7 @@ qedr_roce_create_kernel_qp(struct qedr_dev *dev,
 	qp->qp_id = out_params.qp_id;
 	qp->icid = out_params.icid;
 
-	qedr_set_roce_db_info(dev, qp);
-	return rc;
+	return qedr_set_roce_db_info(dev, qp);
 }
 
 static int
@@ -1802,8 +2027,7 @@ qedr_iwarp_create_kernel_qp(struct qedr_dev *dev,
 	qp->qp_id = out_params.qp_id;
 	qp->icid = out_params.icid;
 
-	qedr_set_iwarp_db_info(dev, qp);
-	return rc;
+	return qedr_set_iwarp_db_info(dev, qp);
 
 err:
 	dev->ops->rdma_destroy_qp(dev->rdma_ctx, qp->qed_qp);
@@ -1818,6 +2042,15 @@ static void qedr_cleanup_kernel(struct qedr_dev *dev, struct qedr_qp *qp)
 
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
diff --git a/include/uapi/rdma/qedr-abi.h b/include/uapi/rdma/qedr-abi.h
index 7a10b3a325fa..aa06dfa1a031 100644
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
+	__u64 db_rec_addr;
 };
 
 struct qedr_create_qp_ureq {
@@ -109,6 +119,13 @@ struct qedr_create_qp_uresp {
 
 	__u32 rq_db2_offset;
 	__u32 reserved;
+
+	/* address of SQ doorbell recovery user entry */
+	__u64 sq_db_rec_addr;
+
+	/* address of RQ doorbell recovery user entry */
+	__u64 rq_db_rec_addr;
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

