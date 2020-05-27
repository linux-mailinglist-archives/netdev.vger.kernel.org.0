Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3081E3DDF
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgE0Jqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:46:46 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51592 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729090AbgE0Jqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:46:43 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maxg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 May 2020 12:46:36 +0300
Received: from mtr-vdi-031.wap.labs.mlnx. (mtr-vdi-031.wap.labs.mlnx [10.209.102.136])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04R9kYim009430;
        Wed, 27 May 2020 12:46:35 +0300
From:   Max Gurtovoy <maxg@mellanox.com>
To:     jgg@mellanox.com, dledford@redhat.com, leon@kernel.org,
        galpress@amazon.com, dennis.dalessandro@intel.com,
        netdev@vger.kernel.org, sagi@grimberg.me,
        linux-rdma@vger.kernel.org, bvanassche@acm.org,
        santosh.shilimkar@oracle.com, tom@talpey.com
Cc:     aron.silverton@oracle.com, israelr@mellanox.com, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com,
        Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH 5/9] RDMA/rdmavt: remove FMR memory registration
Date:   Wed, 27 May 2020 12:46:30 +0300
Message-Id: <20200527094634.24240-6-maxg@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200527094634.24240-1-maxg@mellanox.com>
References: <20200527094634.24240-1-maxg@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use FRWR method to register memory by default and remove the ancient and
unsafe FMR method.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
---
 drivers/infiniband/sw/rdmavt/mr.c | 154 --------------------------------------
 drivers/infiniband/sw/rdmavt/mr.h |  15 ----
 drivers/infiniband/sw/rdmavt/vt.c |   4 -
 3 files changed, 173 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 72f6534..ddb0c0d 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -714,160 +714,6 @@ int rvt_invalidate_rkey(struct rvt_qp *qp, u32 rkey)
 EXPORT_SYMBOL(rvt_invalidate_rkey);
 
 /**
- * rvt_alloc_fmr - allocate a fast memory region
- * @pd: the protection domain for this memory region
- * @mr_access_flags: access flags for this memory region
- * @fmr_attr: fast memory region attributes
- *
- * Return: the memory region on success, otherwise returns an errno.
- */
-struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
-			     struct ib_fmr_attr *fmr_attr)
-{
-	struct rvt_fmr *fmr;
-	int m;
-	struct ib_fmr *ret;
-	int rval = -ENOMEM;
-
-	/* Allocate struct plus pointers to first level page tables. */
-	m = (fmr_attr->max_pages + RVT_SEGSZ - 1) / RVT_SEGSZ;
-	fmr = kzalloc(struct_size(fmr, mr.map, m), GFP_KERNEL);
-	if (!fmr)
-		goto bail;
-
-	rval = rvt_init_mregion(&fmr->mr, pd, fmr_attr->max_pages,
-				PERCPU_REF_INIT_ATOMIC);
-	if (rval)
-		goto bail;
-
-	/*
-	 * ib_alloc_fmr() will initialize fmr->ibfmr except for lkey &
-	 * rkey.
-	 */
-	rval = rvt_alloc_lkey(&fmr->mr, 0);
-	if (rval)
-		goto bail_mregion;
-	fmr->ibfmr.rkey = fmr->mr.lkey;
-	fmr->ibfmr.lkey = fmr->mr.lkey;
-	/*
-	 * Resources are allocated but no valid mapping (RKEY can't be
-	 * used).
-	 */
-	fmr->mr.access_flags = mr_access_flags;
-	fmr->mr.max_segs = fmr_attr->max_pages;
-	fmr->mr.page_shift = fmr_attr->page_shift;
-
-	ret = &fmr->ibfmr;
-done:
-	return ret;
-
-bail_mregion:
-	rvt_deinit_mregion(&fmr->mr);
-bail:
-	kfree(fmr);
-	ret = ERR_PTR(rval);
-	goto done;
-}
-
-/**
- * rvt_map_phys_fmr - set up a fast memory region
- * @ibfmr: the fast memory region to set up
- * @page_list: the list of pages to associate with the fast memory region
- * @list_len: the number of pages to associate with the fast memory region
- * @iova: the virtual address of the start of the fast memory region
- *
- * This may be called from interrupt context.
- *
- * Return: 0 on success
- */
-
-int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-		     int list_len, u64 iova)
-{
-	struct rvt_fmr *fmr = to_ifmr(ibfmr);
-	struct rvt_lkey_table *rkt;
-	unsigned long flags;
-	int m, n;
-	unsigned long i;
-	u32 ps;
-	struct rvt_dev_info *rdi = ib_to_rvt(ibfmr->device);
-
-	i = atomic_long_read(&fmr->mr.refcount.count);
-	if (i > 2)
-		return -EBUSY;
-
-	if (list_len > fmr->mr.max_segs)
-		return -EINVAL;
-
-	rkt = &rdi->lkey_table;
-	spin_lock_irqsave(&rkt->lock, flags);
-	fmr->mr.user_base = iova;
-	fmr->mr.iova = iova;
-	ps = 1 << fmr->mr.page_shift;
-	fmr->mr.length = list_len * ps;
-	m = 0;
-	n = 0;
-	for (i = 0; i < list_len; i++) {
-		fmr->mr.map[m]->segs[n].vaddr = (void *)page_list[i];
-		fmr->mr.map[m]->segs[n].length = ps;
-		trace_rvt_mr_fmr_seg(&fmr->mr, m, n, (void *)page_list[i], ps);
-		if (++n == RVT_SEGSZ) {
-			m++;
-			n = 0;
-		}
-	}
-	spin_unlock_irqrestore(&rkt->lock, flags);
-	return 0;
-}
-
-/**
- * rvt_unmap_fmr - unmap fast memory regions
- * @fmr_list: the list of fast memory regions to unmap
- *
- * Return: 0 on success.
- */
-int rvt_unmap_fmr(struct list_head *fmr_list)
-{
-	struct rvt_fmr *fmr;
-	struct rvt_lkey_table *rkt;
-	unsigned long flags;
-	struct rvt_dev_info *rdi;
-
-	list_for_each_entry(fmr, fmr_list, ibfmr.list) {
-		rdi = ib_to_rvt(fmr->ibfmr.device);
-		rkt = &rdi->lkey_table;
-		spin_lock_irqsave(&rkt->lock, flags);
-		fmr->mr.user_base = 0;
-		fmr->mr.iova = 0;
-		fmr->mr.length = 0;
-		spin_unlock_irqrestore(&rkt->lock, flags);
-	}
-	return 0;
-}
-
-/**
- * rvt_dealloc_fmr - deallocate a fast memory region
- * @ibfmr: the fast memory region to deallocate
- *
- * Return: 0 on success.
- */
-int rvt_dealloc_fmr(struct ib_fmr *ibfmr)
-{
-	struct rvt_fmr *fmr = to_ifmr(ibfmr);
-	int ret = 0;
-
-	rvt_free_lkey(&fmr->mr);
-	rvt_put_mr(&fmr->mr); /* will set completion if last */
-	ret = rvt_check_refs(&fmr->mr, __func__);
-	if (ret)
-		goto out;
-	rvt_deinit_mregion(&fmr->mr);
-	kfree(fmr);
-out:
-	return ret;
-}
-
-/**
  * rvt_sge_adjacent - is isge compressible
  * @last_sge: last outgoing SGE written
  * @sge: SGE to check
diff --git a/drivers/infiniband/sw/rdmavt/mr.h b/drivers/infiniband/sw/rdmavt/mr.h
index 2c8d075..780fc63 100644
--- a/drivers/infiniband/sw/rdmavt/mr.h
+++ b/drivers/infiniband/sw/rdmavt/mr.h
@@ -49,10 +49,6 @@
  */
 
 #include <rdma/rdma_vt.h>
-struct rvt_fmr {
-	struct ib_fmr ibfmr;
-	struct rvt_mregion mr;        /* must be last */
-};
 
 struct rvt_mr {
 	struct ib_mr ibmr;
@@ -60,11 +56,6 @@ struct rvt_mr {
 	struct rvt_mregion mr;  /* must be last */
 };
 
-static inline struct rvt_fmr *to_ifmr(struct ib_fmr *ibfmr)
-{
-	return container_of(ibfmr, struct rvt_fmr, ibfmr);
-}
-
 static inline struct rvt_mr *to_imr(struct ib_mr *ibmr)
 {
 	return container_of(ibmr, struct rvt_mr, ibmr);
@@ -83,11 +74,5 @@ struct ib_mr *rvt_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
 			   u32 max_num_sg, struct ib_udata *udata);
 int rvt_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		  int sg_nents, unsigned int *sg_offset);
-struct ib_fmr *rvt_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
-			     struct ib_fmr_attr *fmr_attr);
-int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-		     int list_len, u64 iova);
-int rvt_unmap_fmr(struct list_head *fmr_list);
-int rvt_dealloc_fmr(struct ib_fmr *ibfmr);
 
 #endif          /* DEF_RVTMR_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 72b031a..f904bb3 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -378,7 +378,6 @@ enum {
 static const struct ib_device_ops rvt_dev_ops = {
 	.uverbs_abi_ver = RVT_UVERBS_ABI_VERSION,
 
-	.alloc_fmr = rvt_alloc_fmr,
 	.alloc_mr = rvt_alloc_mr,
 	.alloc_pd = rvt_alloc_pd,
 	.alloc_ucontext = rvt_alloc_ucontext,
@@ -387,7 +386,6 @@ enum {
 	.create_cq = rvt_create_cq,
 	.create_qp = rvt_create_qp,
 	.create_srq = rvt_create_srq,
-	.dealloc_fmr = rvt_dealloc_fmr,
 	.dealloc_pd = rvt_dealloc_pd,
 	.dealloc_ucontext = rvt_dealloc_ucontext,
 	.dereg_mr = rvt_dereg_mr,
@@ -399,7 +397,6 @@ enum {
 	.get_dma_mr = rvt_get_dma_mr,
 	.get_port_immutable = rvt_get_port_immutable,
 	.map_mr_sg = rvt_map_mr_sg,
-	.map_phys_fmr = rvt_map_phys_fmr,
 	.mmap = rvt_mmap,
 	.modify_ah = rvt_modify_ah,
 	.modify_device = rvt_modify_device,
@@ -420,7 +417,6 @@ enum {
 	.reg_user_mr = rvt_reg_user_mr,
 	.req_notify_cq = rvt_req_notify_cq,
 	.resize_cq = rvt_resize_cq,
-	.unmap_fmr = rvt_unmap_fmr,
 
 	INIT_RDMA_OBJ_SIZE(ib_ah, rvt_ah, ibah),
 	INIT_RDMA_OBJ_SIZE(ib_cq, rvt_cq, ibcq),
-- 
1.8.3.1

