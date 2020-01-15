Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8AD13C14C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgAOMnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgAOMnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:43:50 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EB472465A;
        Wed, 15 Jan 2020 12:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092228;
        bh=H5VyQTxv4IUoC5/DvGbTg8NTbxAht0TeMG6luOT2qSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcJRBOZ1XgYg413AY4kOObMRSWL6PGUH+zfxwbNOVA0GGvOaBLW/WnQUgmALP+uAt
         Bo5P7ZkbTuYHHqqoliDiYOBdANVtdXYIlN4hyMySDSThaLASITdxG8LlrzUGm4S7K5
         JZzPGcuRSzUeXEBEemFwhdB5a8sLYhfGxvxU5EFM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Guy Levi <guyle@mellanox.com>
Subject: [PATCH mlx5-next 01/10] IB: Allow calls to ib_umem_get from kernel ULPs
Date:   Wed, 15 Jan 2020 14:43:31 +0200
Message-Id: <20200115124340.79108-2-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115124340.79108-1-leon@kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

So far the assumption was that ib_umem_get() and ib_umem_odp_get()
are called from flows that start in UVERBS and therefore has a user
context. This assumption restricts flows that are initiated by ULPs
and need the service that ib_umem_get() provides.

This patch changes ib_umem_get() and ib_umem_odp_get() to get IB device
directly by relying on the fact that both UVERBS and ULPs sets that
field correctly.

Reviewed-by: Guy Levi <guyle@mellanox.com>
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/umem.c                | 27 ++++++-----------
 drivers/infiniband/core/umem_odp.c            | 29 +++++--------------
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      | 12 ++++----
 drivers/infiniband/hw/cxgb4/mem.c             |  2 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |  2 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c       |  2 +-
 drivers/infiniband/hw/hns/hns_roce_db.c       |  3 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c       |  4 +--
 drivers/infiniband/hw/hns/hns_roce_qp.c       |  2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c      |  5 ++--
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     |  2 +-
 drivers/infiniband/hw/mlx4/cq.c               |  2 +-
 drivers/infiniband/hw/mlx4/doorbell.c         |  3 +-
 drivers/infiniband/hw/mlx4/mr.c               |  8 ++---
 drivers/infiniband/hw/mlx4/qp.c               |  5 ++--
 drivers/infiniband/hw/mlx4/srq.c              |  3 +-
 drivers/infiniband/hw/mlx5/cq.c               |  6 ++--
 drivers/infiniband/hw/mlx5/devx.c             |  2 +-
 drivers/infiniband/hw/mlx5/doorbell.c         |  3 +-
 drivers/infiniband/hw/mlx5/mr.c               | 18 +++++-------
 drivers/infiniband/hw/mlx5/odp.c              |  2 +-
 drivers/infiniband/hw/mlx5/qp.c               |  4 +--
 drivers/infiniband/hw/mlx5/srq.c              |  2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c  |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |  2 +-
 drivers/infiniband/hw/qedr/verbs.c            |  9 +++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c  |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c  |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  |  7 +++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c |  2 +-
 drivers/infiniband/sw/rdmavt/mr.c             |  2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c            |  2 +-
 include/rdma/ib_umem.h                        |  4 +--
 include/rdma/ib_umem_odp.h                    |  6 ++--
 34 files changed, 85 insertions(+), 103 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 7a3b99597ead..146f98fbf22b 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -181,15 +181,14 @@ EXPORT_SYMBOL(ib_umem_find_best_pgsz);
 /**
  * ib_umem_get - Pin and DMA map userspace memory.
  *
- * @udata: userspace context to pin memory for
+ * @device: IB device to connect UMEM
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
  */
-struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
+struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 			    size_t size, int access)
 {
-	struct ib_ucontext *context;
 	struct ib_umem *umem;
 	struct page **page_list;
 	unsigned long lock_limit;
@@ -201,14 +200,6 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
 	struct scatterlist *sg;
 	unsigned int gup_flags = FOLL_WRITE;

-	if (!udata)
-		return ERR_PTR(-EIO);
-
-	context = container_of(udata, struct uverbs_attr_bundle, driver_udata)
-			  ->context;
-	if (!context)
-		return ERR_PTR(-EIO);
-
 	/*
 	 * If the combination of the addr and size requested for this memory
 	 * region causes an integer overflow, return error.
@@ -226,7 +217,7 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
 	umem = kzalloc(sizeof(*umem), GFP_KERNEL);
 	if (!umem)
 		return ERR_PTR(-ENOMEM);
-	umem->ibdev = context->device;
+	umem->ibdev      = device;
 	umem->length     = size;
 	umem->address    = addr;
 	umem->writable   = ib_access_writable(access);
@@ -281,7 +272,7 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
 		npages   -= ret;

 		sg = ib_umem_add_sg_table(sg, page_list, ret,
-			dma_get_max_seg_size(context->device->dma_device),
+			dma_get_max_seg_size(device->dma_device),
 			&umem->sg_nents);

 		up_read(&mm->mmap_sem);
@@ -289,10 +280,10 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,

 	sg_mark_end(sg);

-	umem->nmap = ib_dma_map_sg(context->device,
-				  umem->sg_head.sgl,
-				  umem->sg_nents,
-				  DMA_BIDIRECTIONAL);
+	umem->nmap = ib_dma_map_sg(device,
+				   umem->sg_head.sgl,
+				   umem->sg_nents,
+				   DMA_BIDIRECTIONAL);

 	if (!umem->nmap) {
 		ret = -ENOMEM;
@@ -303,7 +294,7 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
 	goto out;

 umem_release:
-	__ib_umem_release(context->device, umem, 0);
+	__ib_umem_release(device, umem, 0);
 vma:
 	atomic64_sub(ib_umem_num_pages(umem), &mm->pinned_vm);
 out:
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index b9baf7d0a5cb..cb3b17a7b9b0 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -110,15 +110,12 @@ static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
  * They exist only to hold the per_mm reference to help the driver create
  * children umems.
  *
- * @udata: udata from the syscall being used to create the umem
+ * @device: IB device to create UMEM
  * @access: ib_reg_mr access flags
  */
-struct ib_umem_odp *ib_umem_odp_alloc_implicit(struct ib_udata *udata,
+struct ib_umem_odp *ib_umem_odp_alloc_implicit(struct ib_device *device,
 					       int access)
 {
-	struct ib_ucontext *context =
-		container_of(udata, struct uverbs_attr_bundle, driver_udata)
-			->context;
 	struct ib_umem *umem;
 	struct ib_umem_odp *umem_odp;
 	int ret;
@@ -126,14 +123,11 @@ struct ib_umem_odp *ib_umem_odp_alloc_implicit(struct ib_udata *udata,
 	if (access & IB_ACCESS_HUGETLB)
 		return ERR_PTR(-EINVAL);

-	if (!context)
-		return ERR_PTR(-EIO);
-
 	umem_odp = kzalloc(sizeof(*umem_odp), GFP_KERNEL);
 	if (!umem_odp)
 		return ERR_PTR(-ENOMEM);
 	umem = &umem_odp->umem;
-	umem->ibdev = context->device;
+	umem->ibdev = device;
 	umem->writable = ib_access_writable(access);
 	umem->owning_mm = current->mm;
 	umem_odp->is_implicit_odp = 1;
@@ -201,7 +195,7 @@ EXPORT_SYMBOL(ib_umem_odp_alloc_child);
 /**
  * ib_umem_odp_get - Create a umem_odp for a userspace va
  *
- * @udata: userspace context to pin memory for
+ * @device: IB device struct to get UMEM
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
@@ -210,23 +204,14 @@ EXPORT_SYMBOL(ib_umem_odp_alloc_child);
  * pinning, instead, stores the mm for future page fault handling in
  * conjunction with MMU notifiers.
  */
-struct ib_umem_odp *ib_umem_odp_get(struct ib_udata *udata, unsigned long addr,
-				    size_t size, int access,
+struct ib_umem_odp *ib_umem_odp_get(struct ib_device *device,
+				    unsigned long addr, size_t size, int access,
 				    const struct mmu_interval_notifier_ops *ops)
 {
 	struct ib_umem_odp *umem_odp;
-	struct ib_ucontext *context;
 	struct mm_struct *mm;
 	int ret;

-	if (!udata)
-		return ERR_PTR(-EIO);
-
-	context = container_of(udata, struct uverbs_attr_bundle, driver_udata)
-			  ->context;
-	if (!context)
-		return ERR_PTR(-EIO);
-
 	if (WARN_ON_ONCE(!(access & IB_ACCESS_ON_DEMAND)))
 		return ERR_PTR(-EINVAL);

@@ -234,7 +219,7 @@ struct ib_umem_odp *ib_umem_odp_get(struct ib_udata *udata, unsigned long addr,
 	if (!umem_odp)
 		return ERR_PTR(-ENOMEM);

-	umem_odp->umem.ibdev = context->device;
+	umem_odp->umem.ibdev = device;
 	umem_odp->umem.length = size;
 	umem_odp->umem.address = addr;
 	umem_odp->umem.writable = ib_access_writable(access);
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 9b6ca15a183c..077f184e47e5 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -837,7 +837,8 @@ static int bnxt_re_init_user_qp(struct bnxt_re_dev *rdev, struct bnxt_re_pd *pd,
 		bytes += (qplib_qp->sq.max_wqe * psn_sz);
 	}
 	bytes = PAGE_ALIGN(bytes);
-	umem = ib_umem_get(udata, ureq.qpsva, bytes, IB_ACCESS_LOCAL_WRITE);
+	umem = ib_umem_get(&rdev->ibdev, ureq.qpsva, bytes,
+			   IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(umem))
 		return PTR_ERR(umem);

@@ -850,7 +851,7 @@ static int bnxt_re_init_user_qp(struct bnxt_re_dev *rdev, struct bnxt_re_pd *pd,
 	if (!qp->qplib_qp.srq) {
 		bytes = (qplib_qp->rq.max_wqe * BNXT_QPLIB_MAX_RQE_ENTRY_SIZE);
 		bytes = PAGE_ALIGN(bytes);
-		umem = ib_umem_get(udata, ureq.qprva, bytes,
+		umem = ib_umem_get(&rdev->ibdev, ureq.qprva, bytes,
 				   IB_ACCESS_LOCAL_WRITE);
 		if (IS_ERR(umem))
 			goto rqfail;
@@ -1304,7 +1305,8 @@ static int bnxt_re_init_user_srq(struct bnxt_re_dev *rdev,

 	bytes = (qplib_srq->max_wqe * BNXT_QPLIB_MAX_RQE_ENTRY_SIZE);
 	bytes = PAGE_ALIGN(bytes);
-	umem = ib_umem_get(udata, ureq.srqva, bytes, IB_ACCESS_LOCAL_WRITE);
+	umem = ib_umem_get(&rdev->ibdev, ureq.srqva, bytes,
+			   IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(umem))
 		return PTR_ERR(umem);

@@ -2545,7 +2547,7 @@ int bnxt_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 			goto fail;
 		}

-		cq->umem = ib_umem_get(udata, req.cq_va,
+		cq->umem = ib_umem_get(&rdev->ibdev, req.cq_va,
 				       entries * sizeof(struct cq_base),
 				       IB_ACCESS_LOCAL_WRITE);
 		if (IS_ERR(cq->umem)) {
@@ -3512,7 +3514,7 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 	/* The fixed portion of the rkey is the same as the lkey */
 	mr->ib_mr.rkey = mr->qplib_mr.rkey;

-	umem = ib_umem_get(udata, start, length, mr_access_flags);
+	umem = ib_umem_get(&rdev->ibdev, start, length, mr_access_flags);
 	if (IS_ERR(umem)) {
 		dev_err(rdev_to_dev(rdev), "Failed to get umem");
 		rc = -EFAULT;
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index fe3a7e8561df..962dc97a8ff2 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -543,7 +543,7 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,

 	mhp->rhp = rhp;

-	mhp->umem = ib_umem_get(udata, start, length, acc);
+	mhp->umem = ib_umem_get(pd->device, start, length, acc);
 	if (IS_ERR(mhp->umem))
 		goto err_free_skb;

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index b6b936cb5c53..7e05033a650f 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1385,7 +1385,7 @@ struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start, u64 length,
 		goto err_out;
 	}

-	mr->umem = ib_umem_get(udata, start, length, access_flags);
+	mr->umem = ib_umem_get(ibpd->device, start, length, access_flags);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		ibdev_dbg(&dev->ibdev,
diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 61f53a85767b..5ffe4c996ed3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -163,7 +163,7 @@ static int get_cq_umem(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 	u32 npages;
 	int ret;

-	*umem = ib_umem_get(udata, ucmd.buf_addr, buf->size,
+	*umem = ib_umem_get(&hr_dev->ib_dev, ucmd.buf_addr, buf->size,
 			    IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(*umem))
 		return PTR_ERR(*umem);
diff --git a/drivers/infiniband/hw/hns/hns_roce_db.c b/drivers/infiniband/hw/hns/hns_roce_db.c
index 10af6958ab69..bff6abdccfb0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_db.c
+++ b/drivers/infiniband/hw/hns/hns_roce_db.c
@@ -31,7 +31,8 @@ int hns_roce_db_map_user(struct hns_roce_ucontext *context,

 	refcount_set(&page->refcount, 1);
 	page->user_virt = page_addr;
-	page->umem = ib_umem_get(udata, page_addr, PAGE_SIZE, 0);
+	page->umem = ib_umem_get(context->ibucontext.device, page_addr,
+				 PAGE_SIZE, 0);
 	if (IS_ERR(page->umem)) {
 		ret = PTR_ERR(page->umem);
 		kfree(page);
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 95765560c1cf..b9898e71655a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -1145,7 +1145,7 @@ struct ib_mr *hns_roce_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);

-	mr->umem = ib_umem_get(udata, start, length, access_flags);
+	mr->umem = ib_umem_get(pd->device, start, length, access_flags);
 	if (IS_ERR(mr->umem)) {
 		ret = PTR_ERR(mr->umem);
 		goto err_free;
@@ -1230,7 +1230,7 @@ static int rereg_mr_trans(struct ib_mr *ibmr, int flags,
 	}
 	ib_umem_release(mr->umem);

-	mr->umem = ib_umem_get(udata, start, length, mr_access_flags);
+	mr->umem = ib_umem_get(ibmr->device, start, length, mr_access_flags);
 	if (IS_ERR(mr->umem)) {
 		ret = PTR_ERR(mr->umem);
 		mr->umem = NULL;
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 7c8de1e0d48a..3257ad11be48 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -763,7 +763,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 			goto err_alloc_rq_inline_buf;
 		}

-		hr_qp->umem = ib_umem_get(udata, ucmd.buf_addr,
+		hr_qp->umem = ib_umem_get(ib_pd->device, ucmd.buf_addr,
 					  hr_qp->buff_size, 0);
 		if (IS_ERR(hr_qp->umem)) {
 			dev_err(dev, "ib_umem_get error for create qp\n");
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 7113ebfdb4f0..c6d5f06f9cde 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -186,7 +186,8 @@ static int create_user_srq(struct hns_roce_srq *srq, struct ib_udata *udata,
 	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
 		return -EFAULT;

-	srq->umem = ib_umem_get(udata, ucmd.buf_addr, srq_buf_size, 0);
+	srq->umem =
+		ib_umem_get(srq->ibsrq.device, ucmd.buf_addr, srq_buf_size, 0);
 	if (IS_ERR(srq->umem))
 		return PTR_ERR(srq->umem);

@@ -205,7 +206,7 @@ static int create_user_srq(struct hns_roce_srq *srq, struct ib_udata *udata,
 		goto err_user_srq_mtt;

 	/* config index queue BA */
-	srq->idx_que.umem = ib_umem_get(udata, ucmd.que_addr,
+	srq->idx_que.umem = ib_umem_get(srq->ibsrq.device, ucmd.que_addr,
 					srq->idx_que.buf_size, 0);
 	if (IS_ERR(srq->idx_que.umem)) {
 		dev_err(hr_dev->dev, "ib_umem_get error for index queue\n");
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 86375947bc67..e75787ddc941 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1763,7 +1763,7 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,

 	if (length > I40IW_MAX_MR_SIZE)
 		return ERR_PTR(-EINVAL);
-	region = ib_umem_get(udata, start, length, acc);
+	region = ib_umem_get(pd->device, start, length, acc);
 	if (IS_ERR(region))
 		return (struct ib_mr *)region;

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 72eeb9a85bc5..f8b936b76dcd 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -144,7 +144,7 @@ static int mlx4_ib_get_cq_umem(struct mlx4_ib_dev *dev, struct ib_udata *udata,
 	int shift;
 	int n;

-	*umem = ib_umem_get(udata, buf_addr, cqe * cqe_size,
+	*umem = ib_umem_get(&dev->ib_dev, buf_addr, cqe * cqe_size,
 			    IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(*umem))
 		return PTR_ERR(*umem);
diff --git a/drivers/infiniband/hw/mlx4/doorbell.c b/drivers/infiniband/hw/mlx4/doorbell.c
index 714f9df5bf39..d41f03ccb0e1 100644
--- a/drivers/infiniband/hw/mlx4/doorbell.c
+++ b/drivers/infiniband/hw/mlx4/doorbell.c
@@ -64,7 +64,8 @@ int mlx4_ib_db_map_user(struct ib_udata *udata, unsigned long virt,

 	page->user_virt = (virt & PAGE_MASK);
 	page->refcnt    = 0;
-	page->umem = ib_umem_get(udata, virt & PAGE_MASK, PAGE_SIZE, 0);
+	page->umem = ib_umem_get(context->ibucontext.device, virt & PAGE_MASK,
+				 PAGE_SIZE, 0);
 	if (IS_ERR(page->umem)) {
 		err = PTR_ERR(page->umem);
 		kfree(page);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index dfa17bcdcdbc..b0121c90c561 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -367,7 +367,7 @@ int mlx4_ib_umem_calc_optimal_mtt_size(struct ib_umem *umem, u64 start_va,
 	return block_shift;
 }

-static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
+static struct ib_umem *mlx4_get_umem_mr(struct ib_device *device, u64 start,
 					u64 length, int access_flags)
 {
 	/*
@@ -398,7 +398,7 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
 		up_read(&current->mm->mmap_sem);
 	}

-	return ib_umem_get(udata, start, length, access_flags);
+	return ib_umem_get(device, start, length, access_flags);
 }

 struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
@@ -415,7 +415,7 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);

-	mr->umem = mlx4_get_umem_mr(udata, start, length, access_flags);
+	mr->umem = mlx4_get_umem_mr(pd->device, start, length, access_flags);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err_free;
@@ -504,7 +504,7 @@ int mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags,

 		mlx4_mr_rereg_mem_cleanup(dev->dev, &mmr->mmr);
 		ib_umem_release(mmr->umem);
-		mmr->umem = mlx4_get_umem_mr(udata, start, length,
+		mmr->umem = mlx4_get_umem_mr(mr->device, start, length,
 					     mr_access_flags);
 		if (IS_ERR(mmr->umem)) {
 			err = PTR_ERR(mmr->umem);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 8d240bc92b6b..26425dd2d960 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -916,7 +916,7 @@ static int create_rq(struct ib_pd *pd, struct ib_qp_init_attr *init_attr,
 	qp->buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
 		       (qp->sq.wqe_cnt << qp->sq.wqe_shift);

-	qp->umem = ib_umem_get(udata, wq.buf_addr, qp->buf_size, 0);
+	qp->umem = ib_umem_get(pd->device, wq.buf_addr, qp->buf_size, 0);
 	if (IS_ERR(qp->umem)) {
 		err = PTR_ERR(qp->umem);
 		goto err;
@@ -1110,7 +1110,8 @@ static int create_qp_common(struct ib_pd *pd, struct ib_qp_init_attr *init_attr,
 		if (err)
 			goto err;

-		qp->umem = ib_umem_get(udata, ucmd.buf_addr, qp->buf_size, 0);
+		qp->umem =
+			ib_umem_get(pd->device, ucmd.buf_addr, qp->buf_size, 0);
 		if (IS_ERR(qp->umem)) {
 			err = PTR_ERR(qp->umem);
 			goto err;
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 8dcf6e3d9ae2..8f9d5035142d 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -110,7 +110,8 @@ int mlx4_ib_create_srq(struct ib_srq *ib_srq,
 		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
 			return -EFAULT;

-		srq->umem = ib_umem_get(udata, ucmd.buf_addr, buf_size, 0);
+		srq->umem =
+			ib_umem_get(ib_srq->device, ucmd.buf_addr, buf_size, 0);
 		if (IS_ERR(srq->umem))
 			return PTR_ERR(srq->umem);

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index dd8d24ee8e1d..367a71bc5f4b 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -708,8 +708,8 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	*cqe_size = ucmd.cqe_size;

 	cq->buf.umem =
-		ib_umem_get(udata, ucmd.buf_addr, entries * ucmd.cqe_size,
-			    IB_ACCESS_LOCAL_WRITE);
+		ib_umem_get(&dev->ib_dev, ucmd.buf_addr,
+			    entries * ucmd.cqe_size, IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(cq->buf.umem)) {
 		err = PTR_ERR(cq->buf.umem);
 		return err;
@@ -1108,7 +1108,7 @@ static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	if (ucmd.cqe_size && SIZE_MAX / ucmd.cqe_size <= entries - 1)
 		return -EINVAL;

-	umem = ib_umem_get(udata, ucmd.buf_addr,
+	umem = ib_umem_get(&dev->ib_dev, ucmd.buf_addr,
 			   (size_t)ucmd.cqe_size * entries,
 			   IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(umem)) {
diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 7bb91d24d394..d7efc9f6daf0 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2129,7 +2129,7 @@ static int devx_umem_get(struct mlx5_ib_dev *dev, struct ib_ucontext *ucontext,
 	if (err)
 		return err;

-	obj->umem = ib_umem_get(&attrs->driver_udata, addr, size, access);
+	obj->umem = ib_umem_get(&dev->ib_dev, addr, size, access);
 	if (IS_ERR(obj->umem))
 		return PTR_ERR(obj->umem);

diff --git a/drivers/infiniband/hw/mlx5/doorbell.c b/drivers/infiniband/hw/mlx5/doorbell.c
index 12737c509aa2..61475b571531 100644
--- a/drivers/infiniband/hw/mlx5/doorbell.c
+++ b/drivers/infiniband/hw/mlx5/doorbell.c
@@ -64,7 +64,8 @@ int mlx5_ib_db_map_user(struct mlx5_ib_ucontext *context,

 	page->user_virt = (virt & PAGE_MASK);
 	page->refcnt    = 0;
-	page->umem = ib_umem_get(udata, virt & PAGE_MASK, PAGE_SIZE, 0);
+	page->umem = ib_umem_get(context->ibucontext.device, virt & PAGE_MASK,
+				 PAGE_SIZE, 0);
 	if (IS_ERR(page->umem)) {
 		err = PTR_ERR(page->umem);
 		kfree(page);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1fcae0735e01..1913e88522ec 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -746,10 +746,9 @@ static int mr_cache_max_order(struct mlx5_ib_dev *dev)
 	return MLX5_MAX_UMR_SHIFT;
 }

-static int mr_umem_get(struct mlx5_ib_dev *dev, struct ib_udata *udata,
-		       u64 start, u64 length, int access_flags,
-		       struct ib_umem **umem, int *npages, int *page_shift,
-		       int *ncont, int *order)
+static int mr_umem_get(struct mlx5_ib_dev *dev, u64 start, u64 length,
+		       int access_flags, struct ib_umem **umem, int *npages,
+		       int *page_shift, int *ncont, int *order)
 {
 	struct ib_umem *u;

@@ -758,7 +757,7 @@ static int mr_umem_get(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	if (access_flags & IB_ACCESS_ON_DEMAND) {
 		struct ib_umem_odp *odp;

-		odp = ib_umem_odp_get(udata, start, length, access_flags,
+		odp = ib_umem_odp_get(&dev->ib_dev, start, length, access_flags,
 				      &mlx5_mn_ops);
 		if (IS_ERR(odp)) {
 			mlx5_ib_dbg(dev, "umem get failed (%ld)\n",
@@ -774,7 +773,7 @@ static int mr_umem_get(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 		if (order)
 			*order = ilog2(roundup_pow_of_two(*ncont));
 	} else {
-		u = ib_umem_get(udata, start, length, access_flags);
+		u = ib_umem_get(&dev->ib_dev, start, length, access_flags);
 		if (IS_ERR(u)) {
 			mlx5_ib_dbg(dev, "umem get failed (%ld)\n", PTR_ERR(u));
 			return PTR_ERR(u);
@@ -1260,7 +1259,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return &mr->ibmr;
 	}

-	err = mr_umem_get(dev, udata, start, length, access_flags, &umem,
+	err = mr_umem_get(dev, start, length, access_flags, &umem,
 			  &npages, &page_shift, &ncont, &order);

 	if (err < 0)
@@ -1427,9 +1426,8 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		flags |= IB_MR_REREG_TRANS;
 		ib_umem_release(mr->umem);
 		mr->umem = NULL;
-		err = mr_umem_get(dev, udata, addr, len, access_flags,
-				  &mr->umem, &npages, &page_shift, &ncont,
-				  &order);
+		err = mr_umem_get(dev, addr, len, access_flags, &mr->umem,
+				  &npages, &page_shift, &ncont, &order);
 		if (err)
 			goto err;
 	}
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 409dffb5b0c0..14265175a2d8 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -535,7 +535,7 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	struct mlx5_ib_mr *imr;
 	int err;

-	umem_odp = ib_umem_odp_alloc_implicit(udata, access_flags);
+	umem_odp = ib_umem_odp_alloc_implicit(&dev->ib_dev, access_flags);
 	if (IS_ERR(umem_odp))
 		return ERR_CAST(umem_odp);

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 425efa1349b0..a102bae6d74b 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -749,7 +749,7 @@ static int mlx5_ib_umem_get(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 {
 	int err;

-	*umem = ib_umem_get(udata, addr, size, 0);
+	*umem = ib_umem_get(&dev->ib_dev, addr, size, 0);
 	if (IS_ERR(*umem)) {
 		mlx5_ib_dbg(dev, "umem_get failed\n");
 		return PTR_ERR(*umem);
@@ -806,7 +806,7 @@ static int create_user_rq(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (!ucmd->buf_addr)
 		return -EINVAL;

-	rwq->umem = ib_umem_get(udata, ucmd->buf_addr, rwq->buf_size, 0);
+	rwq->umem = ib_umem_get(&dev->ib_dev, ucmd->buf_addr, rwq->buf_size, 0);
 	if (IS_ERR(rwq->umem)) {
 		mlx5_ib_dbg(dev, "umem_get failed\n");
 		err = PTR_ERR(rwq->umem);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 62939df3c692..b1a8a9175040 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -80,7 +80,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,

 	srq->wq_sig = !!(ucmd.flags & MLX5_SRQ_FLAG_SIGNATURE);

-	srq->umem = ib_umem_get(udata, ucmd.buf_addr, buf_size, 0);
+	srq->umem = ib_umem_get(pd->device, ucmd.buf_addr, buf_size, 0);
 	if (IS_ERR(srq->umem)) {
 		mlx5_ib_dbg(dev, "failed umem get, size %d\n", buf_size);
 		err = PTR_ERR(srq->umem);
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 33002530fee7..ac19d57803b5 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -880,7 +880,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);

-	mr->umem = ib_umem_get(udata, start, length, acc);
+	mr->umem = ib_umem_get(pd->device, start, length, acc);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 9bc1ca6f6f9e..d47ea675734b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -869,7 +869,7 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(status);
-	mr->umem = ib_umem_get(udata, start, len, acc);
+	mr->umem = ib_umem_get(ibpd->device, start, len, acc);
 	if (IS_ERR(mr->umem)) {
 		status = -EFAULT;
 		goto umem_err;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 115f187f0c86..484b555150e0 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -783,7 +783,7 @@ static inline int qedr_init_user_queue(struct ib_udata *udata,

 	q->buf_addr = buf_addr;
 	q->buf_len = buf_len;
-	q->umem = ib_umem_get(udata, q->buf_addr, q->buf_len, access);
+	q->umem = ib_umem_get(&dev->ibdev, q->buf_addr, q->buf_len, access);
 	if (IS_ERR(q->umem)) {
 		DP_ERR(dev, "create user queue: failed ib_umem_get, got %ld\n",
 		       PTR_ERR(q->umem));
@@ -1426,9 +1426,8 @@ static int qedr_init_srq_user_params(struct ib_udata *udata,
 	if (rc)
 		return rc;

-	srq->prod_umem =
-		ib_umem_get(udata, ureq->prod_pair_addr,
-			    sizeof(struct rdma_srq_producers), access);
+	srq->prod_umem = ib_umem_get(srq->ibsrq.device, ureq->prod_pair_addr,
+				     sizeof(struct rdma_srq_producers), access);
 	if (IS_ERR(srq->prod_umem)) {
 		qedr_free_pbl(srq->dev, &srq->usrq.pbl_info, srq->usrq.pbl_tbl);
 		ib_umem_release(srq->usrq.umem);
@@ -2850,7 +2849,7 @@ struct ib_mr *qedr_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,

 	mr->type = QEDR_MR_USER;

-	mr->umem = ib_umem_get(udata, start, len, acc);
+	mr->umem = ib_umem_get(ibpd->device, start, len, acc);
 	if (IS_ERR(mr->umem)) {
 		rc = -EFAULT;
 		goto err0;
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
index a26a4fd86bf4..4f6cc0de7ef9 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
@@ -135,7 +135,7 @@ int pvrdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 			goto err_cq;
 		}

-		cq->umem = ib_umem_get(udata, ucmd.buf_addr, ucmd.buf_size,
+		cq->umem = ib_umem_get(ibdev, ucmd.buf_addr, ucmd.buf_size,
 				       IB_ACCESS_LOCAL_WRITE);
 		if (IS_ERR(cq->umem)) {
 			ret = PTR_ERR(cq->umem);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
index c61e665ff261..b039f1f00e05 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
@@ -126,7 +126,7 @@ struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		return ERR_PTR(-EINVAL);
 	}

-	umem = ib_umem_get(udata, start, length, access_flags);
+	umem = ib_umem_get(pd->device, start, length, access_flags);
 	if (IS_ERR(umem)) {
 		dev_warn(&dev->pdev->dev,
 			 "could not get umem for mem region\n");
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index f15809c28f67..9de1281f9a3b 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -276,8 +276,9 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,

 			if (!is_srq) {
 				/* set qp->sq.wqe_cnt, shift, buf_size.. */
-				qp->rumem = ib_umem_get(udata, ucmd.rbuf_addr,
-							ucmd.rbuf_size, 0);
+				qp->rumem =
+					ib_umem_get(pd->device, ucmd.rbuf_addr,
+						    ucmd.rbuf_size, 0);
 				if (IS_ERR(qp->rumem)) {
 					ret = PTR_ERR(qp->rumem);
 					goto err_qp;
@@ -288,7 +289,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 				qp->srq = to_vsrq(init_attr->srq);
 			}

-			qp->sumem = ib_umem_get(udata, ucmd.sbuf_addr,
+			qp->sumem = ib_umem_get(pd->device, ucmd.sbuf_addr,
 						ucmd.sbuf_size, 0);
 			if (IS_ERR(qp->sumem)) {
 				if (!is_srq)
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
index 98c8be71d91d..d330decfb80a 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
@@ -146,7 +146,7 @@ int pvrdma_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *init_attr,
 		goto err_srq;
 	}

-	srq->umem = ib_umem_get(udata, ucmd.buf_addr, ucmd.buf_size, 0);
+	srq->umem = ib_umem_get(ibsrq->device, ucmd.buf_addr, ucmd.buf_size, 0);
 	if (IS_ERR(srq->umem)) {
 		ret = PTR_ERR(srq->umem);
 		goto err_srq;
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index b9a76bf74857..72f6534fbb52 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -390,7 +390,7 @@ struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (length == 0)
 		return ERR_PTR(-EINVAL);

-	umem = ib_umem_get(udata, start, length, mr_access_flags);
+	umem = ib_umem_get(pd->device, start, length, mr_access_flags);
 	if (IS_ERR(umem))
 		return (void *)umem;

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 35a2baf2f364..e83c7b518bfa 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -169,7 +169,7 @@ int rxe_mem_init_user(struct rxe_pd *pd, u64 start,
 	void			*vaddr;
 	int err;

-	umem = ib_umem_get(udata, start, length, access);
+	umem = ib_umem_get(pd->ibpd.device, start, length, access);
 	if (IS_ERR(umem)) {
 		pr_warn("err %d from rxe_umem_get\n",
 			(int)PTR_ERR(umem));
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 753f54e17e0a..e3518fd6b95b 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -69,7 +69,7 @@ static inline size_t ib_umem_num_pages(struct ib_umem *umem)

 #ifdef CONFIG_INFINIBAND_USER_MEM

-struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
+struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 			    size_t size, int access);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
@@ -83,7 +83,7 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,

 #include <linux/err.h>

-static inline struct ib_umem *ib_umem_get(struct ib_udata *udata,
+static inline struct ib_umem *ib_umem_get(struct ib_device *device,
 					  unsigned long addr, size_t size,
 					  int access)
 {
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 81429acc8257..64314ff76612 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -114,9 +114,9 @@ static inline size_t ib_umem_odp_num_pages(struct ib_umem_odp *umem_odp)
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING

 struct ib_umem_odp *
-ib_umem_odp_get(struct ib_udata *udata, unsigned long addr, size_t size,
+ib_umem_odp_get(struct ib_device *device, unsigned long addr, size_t size,
 		int access, const struct mmu_interval_notifier_ops *ops);
-struct ib_umem_odp *ib_umem_odp_alloc_implicit(struct ib_udata *udata,
+struct ib_umem_odp *ib_umem_odp_alloc_implicit(struct ib_device *device,
 					       int access);
 struct ib_umem_odp *
 ib_umem_odp_alloc_child(struct ib_umem_odp *root_umem, unsigned long addr,
@@ -134,7 +134,7 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem_odp *umem_odp, u64 start_offset,
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */

 static inline struct ib_umem_odp *
-ib_umem_odp_get(struct ib_udata *udata, unsigned long addr, size_t size,
+ib_umem_odp_get(struct ib_device *device, unsigned long addr, size_t size,
 		int access, const struct mmu_interval_notifier_ops *ops)
 {
 	return ERR_PTR(-EINVAL);
--
2.20.1

