Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA67861C49
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfGHJRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:17:22 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59436 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729749AbfGHJRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:17:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x689FpqK013360;
        Mon, 8 Jul 2019 02:16:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Ya9yoxdTcMM07HioY5J7swnSCfIgDI+Y+q2cR+ONeQM=;
 b=gX8qRAPxMsG4oJ0gwy7PKRGswLLOCMt//psNp+C9jZh+Ncs0PCC+FWzYLR5HN/eoo51C
 vZWks/4FQdg27D4N6sODTyzrnQZkXtPbq8aos66npHQGaLJawFR/K9XOioMUmxQlz4qV
 RqOG09MNPqNHnTS/C5msBvyTgEKG+ia74FjLhpooQxxDIewLCTTh0hEh5csMPh5jkMiR
 L58D6N6lxZH6pDa7QRRmYzPOvfh1SltpNoFqlohv6fuu8YAHKyXh9+1dGkhn//ttq5eP
 IcQX3SE6Cfsxo/eQ6AqflbZoJrm8lywfjO7D30qHM/8r5B1+8KmUCPR5xUVFvy0inE0y 9A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tju5j6f91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 02:16:48 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 8 Jul
 2019 02:16:46 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 8 Jul 2019 02:16:46 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id BCBC33F7040;
        Mon,  8 Jul 2019 02:16:44 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>, <galpress@amazon.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 rdma-next 3/6] RDMA/qedr: Use the common mmap API
Date:   Mon, 8 Jul 2019 12:15:00 +0300
Message-ID: <20190708091503.14723-4-michal.kalderon@marvell.com>
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

Remove all function related to mmap from qedr and use the common
API

Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/qedr.h  |  13 ----
 drivers/infiniband/hw/qedr/verbs.c | 153 +++++++++++++------------------------
 drivers/infiniband/hw/qedr/verbs.h |   2 +-
 3 files changed, 52 insertions(+), 116 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 6175d1e98717..97c90d1e525d 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -231,11 +231,6 @@ struct qedr_ucontext {
 	u64 dpi_phys_addr;
 	u32 dpi_size;
 	u16 dpi;
-
-	struct list_head mm_head;
-
-	/* Lock to protect mm list */
-	struct mutex mm_list_lock;
 };
 
 union db_prod64 {
@@ -298,14 +293,6 @@ struct qedr_pd {
 	struct qedr_ucontext *uctx;
 };
 
-struct qedr_mm {
-	struct {
-		u64 phy_addr;
-		unsigned long len;
-	} key;
-	struct list_head entry;
-};
-
 union db_prod32 {
 	struct rdma_pwm_val16_data data;
 	u32 raw;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 27d90a84ea01..f33f0f1e7d76 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -58,6 +58,10 @@
 
 #define DB_ADDR_SHIFT(addr)		((addr) << DB_PWM_ADDR_OFFSET_SHIFT)
 
+enum {
+	QEDR_USER_MMAP_IO_WC = 0,
+};
+
 static inline int qedr_ib_copy_to_udata(struct ib_udata *udata, void *src,
 					size_t len)
 {
@@ -256,60 +260,6 @@ int qedr_modify_port(struct ib_device *ibdev, u8 port, int mask,
 	return 0;
 }
 
-static int qedr_add_mmap(struct qedr_ucontext *uctx, u64 phy_addr,
-			 unsigned long len)
-{
-	struct qedr_mm *mm;
-
-	mm = kzalloc(sizeof(*mm), GFP_KERNEL);
-	if (!mm)
-		return -ENOMEM;
-
-	mm->key.phy_addr = phy_addr;
-	/* This function might be called with a length which is not a multiple
-	 * of PAGE_SIZE, while the mapping is PAGE_SIZE grained and the kernel
-	 * forces this granularity by increasing the requested size if needed.
-	 * When qedr_mmap is called, it will search the list with the updated
-	 * length as a key. To prevent search failures, the length is rounded up
-	 * in advance to PAGE_SIZE.
-	 */
-	mm->key.len = roundup(len, PAGE_SIZE);
-	INIT_LIST_HEAD(&mm->entry);
-
-	mutex_lock(&uctx->mm_list_lock);
-	list_add(&mm->entry, &uctx->mm_head);
-	mutex_unlock(&uctx->mm_list_lock);
-
-	DP_DEBUG(uctx->dev, QEDR_MSG_MISC,
-		 "added (addr=0x%llx,len=0x%lx) for ctx=%p\n",
-		 (unsigned long long)mm->key.phy_addr,
-		 (unsigned long)mm->key.len, uctx);
-
-	return 0;
-}
-
-static bool qedr_search_mmap(struct qedr_ucontext *uctx, u64 phy_addr,
-			     unsigned long len)
-{
-	bool found = false;
-	struct qedr_mm *mm;
-
-	mutex_lock(&uctx->mm_list_lock);
-	list_for_each_entry(mm, &uctx->mm_head, entry) {
-		if (len != mm->key.len || phy_addr != mm->key.phy_addr)
-			continue;
-
-		found = true;
-		break;
-	}
-	mutex_unlock(&uctx->mm_list_lock);
-	DP_DEBUG(uctx->dev, QEDR_MSG_MISC,
-		 "searched for (addr=0x%llx,len=0x%lx) for ctx=%p, result=%d\n",
-		 mm->key.phy_addr, mm->key.len, uctx, found);
-
-	return found;
-}
-
 int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 {
 	struct ib_device *ibdev = uctx->device;
@@ -318,6 +268,7 @@ int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 	struct qedr_alloc_ucontext_resp uresp = {};
 	struct qedr_dev *dev = get_qedr_dev(ibdev);
 	struct qed_rdma_add_user_out_params oparams;
+	u64 key;
 
 	if (!udata)
 		return -EFAULT;
@@ -334,13 +285,17 @@ int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 	ctx->dpi_addr = oparams.dpi_addr;
 	ctx->dpi_phys_addr = oparams.dpi_phys_addr;
 	ctx->dpi_size = oparams.dpi_size;
-	INIT_LIST_HEAD(&ctx->mm_head);
-	mutex_init(&ctx->mm_list_lock);
+
+	key = rdma_user_mmap_entry_insert(uctx, ctx,
+					  ctx->dpi_phys_addr, ctx->dpi_size,
+					  QEDR_USER_MMAP_IO_WC);
+	if (key == RDMA_USER_MMAP_INVALID)
+		return -ENOMEM;
 
 	uresp.dpm_enabled = dev->user_dpm_enabled;
 	uresp.wids_enabled = 1;
 	uresp.wid_count = oparams.wid_count;
-	uresp.db_pa = ctx->dpi_phys_addr;
+	uresp.db_pa = key;
 	uresp.db_size = ctx->dpi_size;
 	uresp.max_send_wr = dev->attr.max_sqe;
 	uresp.max_recv_wr = dev->attr.max_rqe;
@@ -356,10 +311,6 @@ int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 
 	ctx->dev = dev;
 
-	rc = qedr_add_mmap(ctx, ctx->dpi_phys_addr, ctx->dpi_size);
-	if (rc)
-		return rc;
-
 	DP_DEBUG(dev, QEDR_MSG_INIT, "Allocating user context %p\n",
 		 &ctx->ibucontext);
 	return 0;
@@ -368,66 +319,64 @@ int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
 void qedr_dealloc_ucontext(struct ib_ucontext *ibctx)
 {
 	struct qedr_ucontext *uctx = get_qedr_ucontext(ibctx);
-	struct qedr_mm *mm, *tmp;
 
 	DP_DEBUG(uctx->dev, QEDR_MSG_INIT, "Deallocating user context %p\n",
 		 uctx);
 	uctx->dev->ops->rdma_remove_user(uctx->dev->rdma_ctx, uctx->dpi);
-
-	list_for_each_entry_safe(mm, tmp, &uctx->mm_head, entry) {
-		DP_DEBUG(uctx->dev, QEDR_MSG_MISC,
-			 "deleted (addr=0x%llx,len=0x%lx) for ctx=%p\n",
-			 mm->key.phy_addr, mm->key.len, uctx);
-		list_del(&mm->entry);
-		kfree(mm);
-	}
 }
 
-int qedr_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
+int qedr_mmap(struct ib_ucontext *ucontext, struct vm_area_struct *vma)
 {
-	struct qedr_ucontext *ucontext = get_qedr_ucontext(context);
-	struct qedr_dev *dev = get_qedr_dev(context->device);
-	unsigned long phys_addr = vma->vm_pgoff << PAGE_SHIFT;
-	unsigned long len = (vma->vm_end - vma->vm_start);
-	unsigned long dpi_start;
+	struct ib_device *dev = ucontext->device;
+	u64 length = vma->vm_end - vma->vm_start;
+	u64 key = vma->vm_pgoff << PAGE_SHIFT;
+	struct rdma_user_mmap_entry *entry;
+	u64 pfn;
+	int err;
 
-	dpi_start = dev->db_phys_addr + (ucontext->dpi * ucontext->dpi_size);
+	ibdev_dbg(dev,
+		  "start %#lx, end %#lx, length = %#llx, key = %#llx\n",
+		  vma->vm_start, vma->vm_end, length, key);
 
-	DP_DEBUG(dev, QEDR_MSG_INIT,
-		 "mmap invoked with vm_start=0x%pK, vm_end=0x%pK,vm_pgoff=0x%pK; dpi_start=0x%pK dpi_size=0x%x\n",
-		 (void *)vma->vm_start, (void *)vma->vm_end,
-		 (void *)vma->vm_pgoff, (void *)dpi_start, ucontext->dpi_size);
-
-	if ((vma->vm_start & (PAGE_SIZE - 1)) || (len & (PAGE_SIZE - 1))) {
-		DP_ERR(dev,
-		       "failed mmap, addresses must be page aligned: start=0x%pK, end=0x%pK\n",
-		       (void *)vma->vm_start, (void *)vma->vm_end);
+	if (length % PAGE_SIZE != 0 || !(vma->vm_flags & VM_SHARED)) {
+		ibdev_dbg(dev,
+			  "length[%#llx] is not page size aligned[%#lx] or VM_SHARED is not set [%#lx]\n",
+			  length, PAGE_SIZE, vma->vm_flags);
 		return -EINVAL;
 	}
 
-	if (!qedr_search_mmap(ucontext, phys_addr, len)) {
-		DP_ERR(dev, "failed mmap, vm_pgoff=0x%lx is not authorized\n",
-		       vma->vm_pgoff);
-		return -EINVAL;
+	if (vma->vm_flags & VM_EXEC) {
+		ibdev_dbg(dev, "Mapping executable pages is not permitted\n");
+		return -EPERM;
 	}
+	vma->vm_flags &= ~VM_MAYEXEC;
 
-	if (phys_addr < dpi_start ||
-	    ((phys_addr + len) > (dpi_start + ucontext->dpi_size))) {
-		DP_ERR(dev,
-		       "failed mmap, pages are outside of dpi; page address=0x%pK, dpi_start=0x%pK, dpi_size=0x%x\n",
-		       (void *)phys_addr, (void *)dpi_start,
-		       ucontext->dpi_size);
+	entry = rdma_user_mmap_entry_get(ucontext, key, length);
+	if (!entry) {
+		ibdev_dbg(dev, "key[%#llx] does not have valid entry\n",
+			  key);
 		return -EINVAL;
 	}
 
-	if (vma->vm_flags & VM_READ) {
-		DP_ERR(dev, "failed mmap, cannot map doorbell bar for read\n");
-		return -EINVAL;
+	ibdev_dbg(dev,
+		  "Mapping address[%#llx], length[%#llx], mmap_flag[%d]\n",
+		  entry->address, length, entry->mmap_flag);
+
+	pfn = entry->address >> PAGE_SHIFT;
+	switch (entry->mmap_flag) {
+	case QEDR_USER_MMAP_IO_WC:
+		err = rdma_user_mmap_io(ucontext, vma, pfn, length,
+					pgprot_writecombine(vma->vm_page_prot));
+		break;
+	default:
+		err = -EINVAL;
 	}
 
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff, len,
-				  vma->vm_page_prot);
+	ibdev_dbg(dev,
+		  "Couldn't mmap address[%#llx] length[%#llx] mmap_flag[%d] err[%d]\n",
+		  entry->address, length, entry->mmap_flag, err);
+
+	return err;
 }
 
 int qedr_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
diff --git a/drivers/infiniband/hw/qedr/verbs.h b/drivers/infiniband/hw/qedr/verbs.h
index 9aaa90283d6e..724d0983e972 100644
--- a/drivers/infiniband/hw/qedr/verbs.h
+++ b/drivers/infiniband/hw/qedr/verbs.h
@@ -46,7 +46,7 @@ int qedr_query_pkey(struct ib_device *, u8 port, u16 index, u16 *pkey);
 int qedr_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata);
 void qedr_dealloc_ucontext(struct ib_ucontext *uctx);
 
-int qedr_mmap(struct ib_ucontext *, struct vm_area_struct *vma);
+int qedr_mmap(struct ib_ucontext *ucontext, struct vm_area_struct *vma);
 int qedr_alloc_pd(struct ib_pd *pd, struct ib_udata *udata);
 void qedr_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
 
-- 
2.14.5

