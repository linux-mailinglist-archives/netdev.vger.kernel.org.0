Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80DB1E3DF7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgE0Jsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:48:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51607 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729096AbgE0Jsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:48:54 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maxg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 May 2020 12:46:36 +0300
Received: from mtr-vdi-031.wap.labs.mlnx. (mtr-vdi-031.wap.labs.mlnx [10.209.102.136])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04R9kYio009430;
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
Subject: [PATCH 7/9] RDMA/srp: remove support for FMR memory registration
Date:   Wed, 27 May 2020 12:46:32 +0300
Message-Id: <20200527094634.24240-8-maxg@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200527094634.24240-1-maxg@mellanox.com>
References: <20200527094634.24240-1-maxg@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FMR is not supported on most recent RDMA devices (that use fast memory
registration mechanism). Also, FMR was recently removed from NFS/RDMA
ULP.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 222 +++---------------------------------
 drivers/infiniband/ulp/srp/ib_srp.h |  27 +----
 2 files changed, 22 insertions(+), 227 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cd1181c..f276155 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -71,7 +71,6 @@
 static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
-static bool prefer_fr = true;
 static bool register_always = true;
 static bool never_register;
 static int topspin_workarounds = 1;
@@ -95,10 +94,6 @@
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
 
-module_param(prefer_fr, bool, 0444);
-MODULE_PARM_DESC(prefer_fr,
-"Whether to use fast registration if both FMR and fast registration are supported");
-
 module_param(register_always, bool, 0444);
 MODULE_PARM_DESC(register_always,
 		 "Use memory registration even for contiguous memory regions");
@@ -388,24 +383,6 @@ static int srp_new_cm_id(struct srp_rdma_ch *ch)
 		srp_new_ib_cm_id(ch);
 }
 
-static struct ib_fmr_pool *srp_alloc_fmr_pool(struct srp_target_port *target)
-{
-	struct srp_device *dev = target->srp_host->srp_dev;
-	struct ib_fmr_pool_param fmr_param;
-
-	memset(&fmr_param, 0, sizeof(fmr_param));
-	fmr_param.pool_size	    = target->mr_pool_size;
-	fmr_param.dirty_watermark   = fmr_param.pool_size / 4;
-	fmr_param.cache		    = 1;
-	fmr_param.max_pages_per_fmr = dev->max_pages_per_mr;
-	fmr_param.page_shift	    = ilog2(dev->mr_page_size);
-	fmr_param.access	    = (IB_ACCESS_LOCAL_WRITE |
-				       IB_ACCESS_REMOTE_WRITE |
-				       IB_ACCESS_REMOTE_READ);
-
-	return ib_create_fmr_pool(dev->pd, &fmr_param);
-}
-
 /**
  * srp_destroy_fr_pool() - free the resources owned by a pool
  * @pool: Fast registration pool to be destroyed.
@@ -556,7 +533,6 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	struct ib_qp_init_attr *init_attr;
 	struct ib_cq *recv_cq, *send_cq;
 	struct ib_qp *qp;
-	struct ib_fmr_pool *fmr_pool = NULL;
 	struct srp_fr_pool *fr_pool = NULL;
 	const int m = 1 + dev->use_fast_reg * target->mr_per_cmd * 2;
 	int ret;
@@ -619,14 +595,6 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 				     "FR pool allocation failed (%d)\n", ret);
 			goto err_qp;
 		}
-	} else if (dev->use_fmr) {
-		fmr_pool = srp_alloc_fmr_pool(target);
-		if (IS_ERR(fmr_pool)) {
-			ret = PTR_ERR(fmr_pool);
-			shost_printk(KERN_WARNING, target->scsi_host, PFX
-				     "FMR pool allocation failed (%d)\n", ret);
-			goto err_qp;
-		}
 	}
 
 	if (ch->qp)
@@ -644,10 +612,6 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 		if (ch->fr_pool)
 			srp_destroy_fr_pool(ch->fr_pool);
 		ch->fr_pool = fr_pool;
-	} else if (dev->use_fmr) {
-		if (ch->fmr_pool)
-			ib_destroy_fmr_pool(ch->fmr_pool);
-		ch->fmr_pool = fmr_pool;
 	}
 
 	kfree(init_attr);
@@ -702,9 +666,6 @@ static void srp_free_ch_ib(struct srp_target_port *target,
 	if (dev->use_fast_reg) {
 		if (ch->fr_pool)
 			srp_destroy_fr_pool(ch->fr_pool);
-	} else if (dev->use_fmr) {
-		if (ch->fmr_pool)
-			ib_destroy_fmr_pool(ch->fmr_pool);
 	}
 
 	srp_destroy_qp(ch);
@@ -1017,12 +978,8 @@ static void srp_free_req_data(struct srp_target_port *target,
 
 	for (i = 0; i < target->req_ring_size; ++i) {
 		req = &ch->req_ring[i];
-		if (dev->use_fast_reg) {
+		if (dev->use_fast_reg)
 			kfree(req->fr_list);
-		} else {
-			kfree(req->fmr_list);
-			kfree(req->map_page);
-		}
 		if (req->indirect_dma_addr) {
 			ib_dma_unmap_single(ibdev, req->indirect_dma_addr,
 					    target->indirect_size,
@@ -1056,16 +1013,8 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
 					GFP_KERNEL);
 		if (!mr_list)
 			goto out;
-		if (srp_dev->use_fast_reg) {
+		if (srp_dev->use_fast_reg)
 			req->fr_list = mr_list;
-		} else {
-			req->fmr_list = mr_list;
-			req->map_page = kmalloc_array(srp_dev->max_pages_per_mr,
-						      sizeof(void *),
-						      GFP_KERNEL);
-			if (!req->map_page)
-				goto out;
-		}
 		req->indirect_desc = kmalloc(target->indirect_size, GFP_KERNEL);
 		if (!req->indirect_desc)
 			goto out;
@@ -1272,11 +1221,6 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
 		if (req->nmdesc)
 			srp_fr_pool_put(ch->fr_pool, req->fr_list,
 					req->nmdesc);
-	} else if (dev->use_fmr) {
-		struct ib_pool_fmr **pfmr;
-
-		for (i = req->nmdesc, pfmr = req->fmr_list; i > 0; i--, pfmr++)
-			ib_fmr_pool_unmap(*pfmr);
 	}
 
 	ib_dma_unmap_sg(ibdev, scsi_sglist(scmnd), scsi_sg_count(scmnd),
@@ -1472,50 +1416,6 @@ static void srp_map_desc(struct srp_map_state *state, dma_addr_t dma_addr,
 	state->ndesc++;
 }
 
-static int srp_map_finish_fmr(struct srp_map_state *state,
-			      struct srp_rdma_ch *ch)
-{
-	struct srp_target_port *target = ch->target;
-	struct srp_device *dev = target->srp_host->srp_dev;
-	struct ib_pool_fmr *fmr;
-	u64 io_addr = 0;
-
-	if (state->fmr.next >= state->fmr.end) {
-		shost_printk(KERN_ERR, ch->target->scsi_host,
-			     PFX "Out of MRs (mr_per_cmd = %d)\n",
-			     ch->target->mr_per_cmd);
-		return -ENOMEM;
-	}
-
-	WARN_ON_ONCE(!dev->use_fmr);
-
-	if (state->npages == 0)
-		return 0;
-
-	if (state->npages == 1 && target->global_rkey) {
-		srp_map_desc(state, state->base_dma_addr, state->dma_len,
-			     target->global_rkey);
-		goto reset_state;
-	}
-
-	fmr = ib_fmr_pool_map_phys(ch->fmr_pool, state->pages,
-				   state->npages, io_addr);
-	if (IS_ERR(fmr))
-		return PTR_ERR(fmr);
-
-	*state->fmr.next++ = fmr;
-	state->nmdesc++;
-
-	srp_map_desc(state, state->base_dma_addr & ~dev->mr_page_mask,
-		     state->dma_len, fmr->fmr->rkey);
-
-reset_state:
-	state->npages = 0;
-	state->dma_len = 0;
-
-	return 0;
-}
-
 static void srp_reg_mr_err_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	srp_handle_qp_err(cq, wc, "FAST REG");
@@ -1606,74 +1506,6 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	return n;
 }
 
-static int srp_map_sg_entry(struct srp_map_state *state,
-			    struct srp_rdma_ch *ch,
-			    struct scatterlist *sg)
-{
-	struct srp_target_port *target = ch->target;
-	struct srp_device *dev = target->srp_host->srp_dev;
-	dma_addr_t dma_addr = sg_dma_address(sg);
-	unsigned int dma_len = sg_dma_len(sg);
-	unsigned int len = 0;
-	int ret;
-
-	WARN_ON_ONCE(!dma_len);
-
-	while (dma_len) {
-		unsigned offset = dma_addr & ~dev->mr_page_mask;
-
-		if (state->npages == dev->max_pages_per_mr ||
-		    (state->npages > 0 && offset != 0)) {
-			ret = srp_map_finish_fmr(state, ch);
-			if (ret)
-				return ret;
-		}
-
-		len = min_t(unsigned int, dma_len, dev->mr_page_size - offset);
-
-		if (!state->npages)
-			state->base_dma_addr = dma_addr;
-		state->pages[state->npages++] = dma_addr & dev->mr_page_mask;
-		state->dma_len += len;
-		dma_addr += len;
-		dma_len -= len;
-	}
-
-	/*
-	 * If the end of the MR is not on a page boundary then we need to
-	 * close it out and start a new one -- we can only merge at page
-	 * boundaries.
-	 */
-	ret = 0;
-	if ((dma_addr & ~dev->mr_page_mask) != 0)
-		ret = srp_map_finish_fmr(state, ch);
-	return ret;
-}
-
-static int srp_map_sg_fmr(struct srp_map_state *state, struct srp_rdma_ch *ch,
-			  struct srp_request *req, struct scatterlist *scat,
-			  int count)
-{
-	struct scatterlist *sg;
-	int i, ret;
-
-	state->pages = req->map_page;
-	state->fmr.next = req->fmr_list;
-	state->fmr.end = req->fmr_list + ch->target->mr_per_cmd;
-
-	for_each_sg(scat, sg, count, i) {
-		ret = srp_map_sg_entry(state, ch, sg);
-		if (ret)
-			return ret;
-	}
-
-	ret = srp_map_finish_fmr(state, ch);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
 static int srp_map_sg_fr(struct srp_map_state *state, struct srp_rdma_ch *ch,
 			 struct srp_request *req, struct scatterlist *scat,
 			 int count)
@@ -1733,7 +1565,6 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
 	struct srp_device *dev = target->srp_host->srp_dev;
 	struct srp_map_state state;
 	struct srp_direct_buf idb_desc;
-	u64 idb_pages[1];
 	struct scatterlist idb_sg[1];
 	int ret;
 
@@ -1756,14 +1587,6 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
 		if (ret < 0)
 			return ret;
 		WARN_ON_ONCE(ret < 1);
-	} else if (dev->use_fmr) {
-		state.pages = idb_pages;
-		state.pages[0] = (req->indirect_dma_addr &
-				  dev->mr_page_mask);
-		state.npages = 1;
-		ret = srp_map_finish_fmr(&state, ch);
-		if (ret < 0)
-			return ret;
 	} else {
 		return -EINVAL;
 	}
@@ -1787,9 +1610,6 @@ static void srp_check_mapping(struct srp_map_state *state,
 	if (dev->use_fast_reg)
 		for (i = 0, pfr = req->fr_list; i < state->nmdesc; i++, pfr++)
 			mr_len += (*pfr)->mr->length;
-	else if (dev->use_fmr)
-		for (i = 0; i < state->nmdesc; i++)
-			mr_len += be32_to_cpu(req->indirect_desc[i].len);
 	if (desc_len != scsi_bufflen(req->scmnd) ||
 	    mr_len > scsi_bufflen(req->scmnd))
 		pr_err("Inconsistent: scsi len %d <> desc len %lld <> mr len %lld; ndesc %d; nmdesc = %d\n",
@@ -1904,8 +1724,6 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
 	state.desc = req->indirect_desc;
 	if (dev->use_fast_reg)
 		ret = srp_map_sg_fr(&state, ch, req, scat, count);
-	else if (dev->use_fmr)
-		ret = srp_map_sg_fmr(&state, ch, req, scat, count);
 	else
 		ret = srp_map_sg_dma(&state, ch, req, scat, count);
 	req->nmdesc = state.nmdesc;
@@ -3864,13 +3682,13 @@ static ssize_t srp_create_target(struct device *dev,
 		goto out;
 	}
 
-	if (!srp_dev->has_fmr && !srp_dev->has_fr && !target->allow_ext_sg &&
+	if (!srp_dev->has_fr && !target->allow_ext_sg &&
 	    target->cmd_sg_cnt < target->sg_tablesize) {
 		pr_warn("No MR pool and no external indirect descriptors, limiting sg_tablesize to cmd_sg_cnt\n");
 		target->sg_tablesize = target->cmd_sg_cnt;
 	}
 
-	if (srp_dev->use_fast_reg || srp_dev->use_fmr) {
+	if (srp_dev->use_fast_reg) {
 		bool gaps_reg = (ibdev->attrs.device_cap_flags &
 				 IB_DEVICE_SG_GAPS_REG);
 
@@ -3878,12 +3696,12 @@ static ssize_t srp_create_target(struct device *dev,
 				  (ilog2(srp_dev->mr_page_size) - 9);
 		if (!gaps_reg) {
 			/*
-			 * FR and FMR can only map one HCA page per entry. If
-			 * the start address is not aligned on a HCA page
-			 * boundary two entries will be used for the head and
-			 * the tail although these two entries combined
-			 * contain at most one HCA page of data. Hence the "+
-			 * 1" in the calculation below.
+			 * FR can only map one HCA page per entry. If the start
+			 * address is not aligned on a HCA page boundary two
+			 * entries will be used for the head and the tail
+			 * although these two entries combined contain at most
+			 * one HCA page of data. Hence the "+ 1" in the
+			 * calculation below.
 			 *
 			 * The indirect data buffer descriptor is contiguous
 			 * so the memory for that buffer will only be
@@ -4162,23 +3980,15 @@ static void srp_add_one(struct ib_device *device)
 	srp_dev->max_pages_per_mr = min_t(u64, SRP_MAX_PAGES_PER_MR,
 					  max_pages_per_mr);
 
-	srp_dev->has_fmr = (device->ops.alloc_fmr &&
-			    device->ops.dealloc_fmr &&
-			    device->ops.map_phys_fmr &&
-			    device->ops.unmap_fmr);
 	srp_dev->has_fr = (attr->device_cap_flags &
 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
-	if (!never_register && !srp_dev->has_fmr && !srp_dev->has_fr) {
-		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
-	} else if (!never_register &&
-		   attr->max_mr_size >= 2 * srp_dev->mr_page_size) {
-		srp_dev->use_fast_reg = (srp_dev->has_fr &&
-					 (!srp_dev->has_fmr || prefer_fr));
-		srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
-	}
+	if (!never_register && !srp_dev->has_fr)
+		dev_warn(&device->dev, "FR is not supported\n");
+	else if (!never_register &&
+		 attr->max_mr_size >= 2 * srp_dev->mr_page_size)
+		srp_dev->use_fast_reg = srp_dev->has_fr;
 
-	if (never_register || !register_always ||
-	    (!srp_dev->has_fmr && !srp_dev->has_fr))
+	if (never_register || !register_always || !srp_dev->has_fr)
 		flags |= IB_PD_UNSAFE_GLOBAL_RKEY;
 
 	if (srp_dev->use_fast_reg) {
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 6fabcc2..6818cac 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -44,7 +44,6 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_sa.h>
 #include <rdma/ib_cm.h>
-#include <rdma/ib_fmr_pool.h>
 #include <rdma/rdma_cm.h>
 
 enum {
@@ -95,8 +94,7 @@ enum srp_iu_type {
 /*
  * @mr_page_mask: HCA memory registration page mask.
  * @mr_page_size: HCA memory registration page size.
- * @mr_max_size: Maximum size in bytes of a single FMR / FR registration
- *   request.
+ * @mr_max_size: Maximum size in bytes of a single FR registration request.
  */
 struct srp_device {
 	struct list_head	dev_list;
@@ -107,9 +105,7 @@ struct srp_device {
 	int			mr_page_size;
 	int			mr_max_size;
 	int			max_pages_per_mr;
-	bool			has_fmr;
 	bool			has_fr;
-	bool			use_fmr;
 	bool			use_fast_reg;
 };
 
@@ -127,11 +123,7 @@ struct srp_host {
 struct srp_request {
 	struct scsi_cmnd       *scmnd;
 	struct srp_iu	       *cmd;
-	union {
-		struct ib_pool_fmr **fmr_list;
-		struct srp_fr_desc **fr_list;
-	};
-	u64		       *map_page;
+	struct srp_fr_desc     **fr_list;
 	struct srp_direct_buf  *indirect_desc;
 	dma_addr_t		indirect_dma_addr;
 	short			nmdesc;
@@ -155,10 +147,7 @@ struct srp_rdma_ch {
 	struct ib_cq	       *send_cq;
 	struct ib_cq	       *recv_cq;
 	struct ib_qp	       *qp;
-	union {
-		struct ib_fmr_pool     *fmr_pool;
-		struct srp_fr_pool     *fr_pool;
-	};
+	struct srp_fr_pool     *fr_pool;
 	uint32_t		max_it_iu_len;
 	uint32_t		max_ti_iu_len;
 	u8			max_imm_sge;
@@ -319,20 +308,16 @@ struct srp_fr_pool {
  * @pages:	    Array with DMA addresses of pages being considered for
  *		    memory registration.
  * @base_dma_addr:  DMA address of the first page that has not yet been mapped.
- * @dma_len:	    Number of bytes that will be registered with the next
- *		    FMR or FR memory registration call.
+ * @dma_len:	    Number of bytes that will be registered with the next FR
+ *                  memory registration call.
  * @total_len:	    Total number of bytes in the sg-list being mapped.
  * @npages:	    Number of page addresses in the pages[] array.
- * @nmdesc:	    Number of FMR or FR memory descriptors used for mapping.
+ * @nmdesc:	    Number of FR memory descriptors used for mapping.
  * @ndesc:	    Number of SRP buffer descriptors that have been filled in.
  */
 struct srp_map_state {
 	union {
 		struct {
-			struct ib_pool_fmr **next;
-			struct ib_pool_fmr **end;
-		} fmr;
-		struct {
 			struct srp_fr_desc **next;
 			struct srp_fr_desc **end;
 		} fr;
-- 
1.8.3.1

