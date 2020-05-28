Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B421E6B86
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgE1Tqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728715AbgE1TqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:46:10 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15566C08C5C9
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:06 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id fb16so13542909qvb.5
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=STHL5O604x92xq0k3MsHMBghdRwVGVA2sdwzURQqJxs=;
        b=ZlI20pgqFaBlw57BzA3wLH29ezQxlIjsu01AD59oWjD2j6g73RVD2J2QBps8SHZ/+E
         fNM9kyYfG6Q0kGww1dLhG08dzlr9Z5YSnGryv4JhV+XUhFfGlre+lHGKSoeZOJK70jSY
         H5VxglqiD2atpbU+sS6YBSC5obAdkkfaud/SfOSyOte0Jh0mJVKSI27UJTwNU9/cQVci
         ZKh63PNgdr2KV5DhpQDK0FC6lZfBYZwB+PR290N3NXNilwHxIyg9naJvZV3V5wLN0slX
         QorrxzP3bMJCQQp3IT3/mSa+PP1TDU7HFgwa/OLAwJjyLsnDsNFsvkFymN55LdW3qYNS
         NGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=STHL5O604x92xq0k3MsHMBghdRwVGVA2sdwzURQqJxs=;
        b=bbzADNt5m4A0jqFAjV+EwXIOzLr1W6N4HpnOqpgYDesv1qsi3kIyacHNh1hoQAXsoc
         XLB+8Z+EC3NmZ2TK3CA0QMfdQAOY0aYdeQLg+g3xXVcK2eGl8XwJi5dDaYCLub7/rdRn
         EoASoBUTjr9hOkVHJzHM7x/NBJZpotFkSllIGPbjreMfiFClOepgpGeN4835HwRBLCuG
         QUIDHAheg8o0PODA+2rf93kch3uYEUJ5bz+lred+1Ynwvyav5orJqMcwR7P6XvvXHpfq
         pG5jd6GHc86EGCCEpx2bNgFVlcWNyVxnORtQVjConYqwC21dOZ7BlAe3bqgl04Rjdhte
         p9ng==
X-Gm-Message-State: AOAM533Lcv0ly68iE8osmvPmJztZu/u12i6BP2XqA03bbo8g3w0An2ZN
        igI5WAI6/IM1ZzNprlkJ77/AVQ==
X-Google-Smtp-Source: ABdhPJy0RxEm/U7DINRS557X6ERBJGfXG6wjZzW2xezUXqmHjSzLTpAZejzMjj2OIibel1IVblvRtQ==
X-Received: by 2002:a0c:dd8e:: with SMTP id v14mr4711028qvk.169.1590695164923;
        Thu, 28 May 2020 12:46:04 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id a191sm5541883qkc.66.2020.05.28.12.45.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeOTU-0006gj-0T; Thu, 28 May 2020 16:45:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>, oren@mellanox.com,
        Sagi Grimberg <sagi@grimberg.me>, shlomin@mellanox.com,
        vladimirk@mellanox.com
Subject: [PATCH v3 01/13] RDMA/iser: Remove support for FMR memory registration
Date:   Thu, 28 May 2020 16:45:43 -0300
Message-Id: <1-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
In-Reply-To: <0-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Israel Rukshin <israelr@mellanox.com>

FMR is not supported on most recent RDMA devices (that use fast memory
registration mechanism). Also, FMR was recently removed from NFS/RDMA
ULP.

Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  79 +-------
 drivers/infiniband/ulp/iser/iser_initiator.c |  19 +-
 drivers/infiniband/ulp/iser/iser_memory.c    | 188 +------------------
 drivers/infiniband/ulp/iser/iser_verbs.c     | 126 ++-----------
 4 files changed, 40 insertions(+), 372 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 029c00163442d6..1d77c7f42e38be 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -65,7 +65,6 @@
 #include <linux/in6.h>
 
 #include <rdma/ib_verbs.h>
-#include <rdma/ib_fmr_pool.h>
 #include <rdma/rdma_cm.h>
 
 #define DRV_NAME	"iser"
@@ -312,33 +311,6 @@ struct iser_comp {
 	int                      active_qps;
 };
 
-/**
- * struct iser_reg_ops - Memory registration operations
- *     per-device registration schemes
- *
- * @alloc_reg_res:     Allocate registration resources
- * @free_reg_res:      Free registration resources
- * @reg_mem:           Register memory buffers
- * @unreg_mem:         Un-register memory buffers
- * @reg_desc_get:      Get a registration descriptor for pool
- * @reg_desc_put:      Get a registration descriptor to pool
- */
-struct iser_reg_ops {
-	int            (*alloc_reg_res)(struct ib_conn *ib_conn,
-					unsigned cmds_max,
-					unsigned int size);
-	void           (*free_reg_res)(struct ib_conn *ib_conn);
-	int            (*reg_mem)(struct iscsi_iser_task *iser_task,
-				  struct iser_data_buf *mem,
-				  struct iser_reg_resources *rsc,
-				  struct iser_mem_reg *reg);
-	void           (*unreg_mem)(struct iscsi_iser_task *iser_task,
-				    enum iser_data_dir cmd_dir);
-	struct iser_fr_desc * (*reg_desc_get)(struct ib_conn *ib_conn);
-	void           (*reg_desc_put)(struct ib_conn *ib_conn,
-				       struct iser_fr_desc *desc);
-};
-
 /**
  * struct iser_device - iSER device handle
  *
@@ -351,8 +323,6 @@ struct iser_reg_ops {
  * @comps_used:    Number of completion contexts used, Min between online
  *                 cpus and device max completion vectors
  * @comps:         Dinamically allocated array of completion handlers
- * @reg_ops:       Registration ops
- * @remote_inv_sup: Remote invalidate is supported on this device
  */
 struct iser_device {
 	struct ib_device             *ib_device;
@@ -362,26 +332,18 @@ struct iser_device {
 	int                          refcount;
 	int			     comps_used;
 	struct iser_comp	     *comps;
-	const struct iser_reg_ops    *reg_ops;
-	bool                         remote_inv_sup;
 };
 
 /**
  * struct iser_reg_resources - Fast registration resources
  *
  * @mr:         memory region
- * @fmr_pool:   pool of fmrs
  * @sig_mr:     signature memory region
- * @page_vec:   fast reg page list used by fmr pool
  * @mr_valid:   is mr valid indicator
  */
 struct iser_reg_resources {
-	union {
-		struct ib_mr             *mr;
-		struct ib_fmr_pool       *fmr_pool;
-	};
+	struct ib_mr                     *mr;
 	struct ib_mr                     *sig_mr;
-	struct iser_page_vec             *page_vec;
 	u8				  mr_valid:1;
 };
 
@@ -403,7 +365,7 @@ struct iser_fr_desc {
  * struct iser_fr_pool - connection fast registration pool
  *
  * @list:                list of fastreg descriptors
- * @lock:                protects fmr/fastreg pool
+ * @lock:                protects fastreg pool
  * @size:                size of the pool
  */
 struct iser_fr_pool {
@@ -518,12 +480,6 @@ struct iscsi_iser_task {
 	struct iser_data_buf         prot[ISER_DIRS_NUM];
 };
 
-struct iser_page_vec {
-	u64 *pages;
-	int npages;
-	struct ib_mr fake_mr;
-};
-
 /**
  * struct iser_global - iSER global context
  *
@@ -548,8 +504,6 @@ extern int iser_pi_guard;
 extern unsigned int iser_max_sectors;
 extern bool iser_always_reg;
 
-int iser_assign_reg_ops(struct iser_device *device);
-
 int iser_send_control(struct iscsi_conn *conn,
 		      struct iscsi_task *task);
 
@@ -591,22 +545,17 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 				     struct iser_data_buf *mem,
 				     enum iser_data_dir cmd_dir);
 
-int iser_reg_rdma_mem(struct iscsi_iser_task *task,
-		      enum iser_data_dir dir,
-		      bool all_imm);
-void iser_unreg_rdma_mem(struct iscsi_iser_task *task,
-			 enum iser_data_dir dir);
+int iser_reg_mem_fastreg(struct iscsi_iser_task *task,
+			 enum iser_data_dir dir,
+			 bool all_imm);
+void iser_unreg_mem_fastreg(struct iscsi_iser_task *task,
+			    enum iser_data_dir dir);
 
 int  iser_connect(struct iser_conn *iser_conn,
 		  struct sockaddr *src_addr,
 		  struct sockaddr *dst_addr,
 		  int non_blocking);
 
-void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
-			enum iser_data_dir cmd_dir);
-void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
-			    enum iser_data_dir cmd_dir);
-
 int  iser_post_recvl(struct iser_conn *iser_conn);
 int  iser_post_recvm(struct iser_conn *iser_conn, int count);
 int  iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc,
@@ -625,26 +574,12 @@ int  iser_initialize_task_headers(struct iscsi_task *task,
 			struct iser_tx_desc *tx_desc);
 int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 			      struct iscsi_session *session);
-int iser_alloc_fmr_pool(struct ib_conn *ib_conn,
-			unsigned cmds_max,
-			unsigned int size);
-void iser_free_fmr_pool(struct ib_conn *ib_conn);
 int iser_alloc_fastreg_pool(struct ib_conn *ib_conn,
 			    unsigned cmds_max,
 			    unsigned int size);
 void iser_free_fastreg_pool(struct ib_conn *ib_conn);
 u8 iser_check_task_pi_status(struct iscsi_iser_task *iser_task,
 			     enum iser_data_dir cmd_dir, sector_t *sector);
-struct iser_fr_desc *
-iser_reg_desc_get_fr(struct ib_conn *ib_conn);
-void
-iser_reg_desc_put_fr(struct ib_conn *ib_conn,
-		     struct iser_fr_desc *desc);
-struct iser_fr_desc *
-iser_reg_desc_get_fmr(struct ib_conn *ib_conn);
-void
-iser_reg_desc_put_fmr(struct ib_conn *ib_conn,
-		      struct iser_fr_desc *desc);
 
 static inline struct iser_conn *
 to_iser_conn(struct ib_conn *ib_conn)
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 4a7045bb0831c3..27a6f75a9912ff 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -72,7 +72,7 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 			return err;
 	}
 
-	err = iser_reg_rdma_mem(iser_task, ISER_DIR_IN, false);
+	err = iser_reg_mem_fastreg(iser_task, ISER_DIR_IN, false);
 	if (err) {
 		iser_err("Failed to set up Data-IN RDMA\n");
 		return err;
@@ -126,8 +126,8 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 			return err;
 	}
 
-	err = iser_reg_rdma_mem(iser_task, ISER_DIR_OUT,
-				buf_out->data_len == imm_sz);
+	err = iser_reg_mem_fastreg(iser_task, ISER_DIR_OUT,
+				   buf_out->data_len == imm_sz);
 	if (err != 0) {
 		iser_err("Failed to register write cmd RDMA mem\n");
 		return err;
@@ -250,8 +250,8 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 	iser_conn->qp_max_recv_dtos_mask = session->cmds_max - 1; /* cmds_max is 2^N */
 	iser_conn->min_posted_rx = iser_conn->qp_max_recv_dtos >> 2;
 
-	if (device->reg_ops->alloc_reg_res(ib_conn, session->scsi_cmds_max,
-					   iser_conn->pages_per_mr))
+	if (iser_alloc_fastreg_pool(ib_conn, session->scsi_cmds_max,
+				    iser_conn->pages_per_mr))
 		goto create_rdma_reg_res_failed;
 
 	if (iser_alloc_login_buf(iser_conn))
@@ -293,7 +293,7 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
 rx_desc_alloc_fail:
 	iser_free_login_buf(iser_conn);
 alloc_login_buf_fail:
-	device->reg_ops->free_reg_res(ib_conn);
+	iser_free_fastreg_pool(ib_conn);
 create_rdma_reg_res_failed:
 	iser_err("failed allocating rx descriptors / data buffers\n");
 	return -ENOMEM;
@@ -306,8 +306,7 @@ void iser_free_rx_descriptors(struct iser_conn *iser_conn)
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
 
-	if (device->reg_ops->free_reg_res)
-		device->reg_ops->free_reg_res(ib_conn);
+	iser_free_fastreg_pool(ib_conn);
 
 	rx_desc = iser_conn->rx_descs;
 	for (i = 0; i < iser_conn->qp_max_recv_dtos; i++, rx_desc++)
@@ -768,7 +767,7 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 	int prot_count = scsi_prot_sg_count(iser_task->sc);
 
 	if (iser_task->dir[ISER_DIR_IN]) {
-		iser_unreg_rdma_mem(iser_task, ISER_DIR_IN);
+		iser_unreg_mem_fastreg(iser_task, ISER_DIR_IN);
 		iser_dma_unmap_task_data(iser_task,
 					 &iser_task->data[ISER_DIR_IN],
 					 DMA_FROM_DEVICE);
@@ -779,7 +778,7 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 	}
 
 	if (iser_task->dir[ISER_DIR_OUT]) {
-		iser_unreg_rdma_mem(iser_task, ISER_DIR_OUT);
+		iser_unreg_mem_fastreg(iser_task, ISER_DIR_OUT);
 		iser_dma_unmap_task_data(iser_task,
 					 &iser_task->data[ISER_DIR_OUT],
 					 DMA_TO_DEVICE);
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 999ef7cdd05e42..d4e057fac219b8 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -38,62 +38,13 @@
 #include <linux/scatterlist.h>
 
 #include "iscsi_iser.h"
-static
-int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
-		      struct iser_data_buf *mem,
-		      struct iser_reg_resources *rsc,
-		      struct iser_mem_reg *mem_reg);
-static
-int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
-		     struct iser_data_buf *mem,
-		     struct iser_reg_resources *rsc,
-		     struct iser_mem_reg *mem_reg);
-
-static const struct iser_reg_ops fastreg_ops = {
-	.alloc_reg_res	= iser_alloc_fastreg_pool,
-	.free_reg_res	= iser_free_fastreg_pool,
-	.reg_mem	= iser_fast_reg_mr,
-	.unreg_mem	= iser_unreg_mem_fastreg,
-	.reg_desc_get	= iser_reg_desc_get_fr,
-	.reg_desc_put	= iser_reg_desc_put_fr,
-};
-
-static const struct iser_reg_ops fmr_ops = {
-	.alloc_reg_res	= iser_alloc_fmr_pool,
-	.free_reg_res	= iser_free_fmr_pool,
-	.reg_mem	= iser_fast_reg_fmr,
-	.unreg_mem	= iser_unreg_mem_fmr,
-	.reg_desc_get	= iser_reg_desc_get_fmr,
-	.reg_desc_put	= iser_reg_desc_put_fmr,
-};
 
 void iser_reg_comp(struct ib_cq *cq, struct ib_wc *wc)
 {
 	iser_err_comp(wc, "memreg");
 }
 
-int iser_assign_reg_ops(struct iser_device *device)
-{
-	struct ib_device *ib_dev = device->ib_device;
-
-	/* Assign function handles  - based on FMR support */
-	if (ib_dev->ops.alloc_fmr && ib_dev->ops.dealloc_fmr &&
-	    ib_dev->ops.map_phys_fmr && ib_dev->ops.unmap_fmr) {
-		iser_info("FMR supported, using FMR for registration\n");
-		device->reg_ops = &fmr_ops;
-	} else if (ib_dev->attrs.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
-		iser_info("FastReg supported, using FastReg for registration\n");
-		device->reg_ops = &fastreg_ops;
-		device->remote_inv_sup = iser_always_reg;
-	} else {
-		iser_err("IB device does not support FMRs nor FastRegs, can't register memory\n");
-		return -1;
-	}
-
-	return 0;
-}
-
-struct iser_fr_desc *
+static struct iser_fr_desc *
 iser_reg_desc_get_fr(struct ib_conn *ib_conn)
 {
 	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
@@ -109,7 +60,7 @@ iser_reg_desc_get_fr(struct ib_conn *ib_conn)
 	return desc;
 }
 
-void
+static void
 iser_reg_desc_put_fr(struct ib_conn *ib_conn,
 		     struct iser_fr_desc *desc)
 {
@@ -121,44 +72,6 @@ iser_reg_desc_put_fr(struct ib_conn *ib_conn,
 	spin_unlock_irqrestore(&fr_pool->lock, flags);
 }
 
-struct iser_fr_desc *
-iser_reg_desc_get_fmr(struct ib_conn *ib_conn)
-{
-	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
-
-	return list_first_entry(&fr_pool->list,
-				struct iser_fr_desc, list);
-}
-
-void
-iser_reg_desc_put_fmr(struct ib_conn *ib_conn,
-		      struct iser_fr_desc *desc)
-{
-}
-
-static void iser_data_buf_dump(struct iser_data_buf *data,
-			       struct ib_device *ibdev)
-{
-	struct scatterlist *sg;
-	int i;
-
-	for_each_sg(data->sg, sg, data->dma_nents, i)
-		iser_dbg("sg[%d] dma_addr:0x%lX page:0x%p "
-			 "off:0x%x sz:0x%x dma_len:0x%x\n",
-			 i, (unsigned long)sg_dma_address(sg),
-			 sg_page(sg), sg->offset, sg->length, sg_dma_len(sg));
-}
-
-static void iser_dump_page_vec(struct iser_page_vec *page_vec)
-{
-	int i;
-
-	iser_err("page vec npages %d data length %lld\n",
-		 page_vec->npages, page_vec->fake_mr.length);
-	for (i = 0; i < page_vec->npages; i++)
-		iser_err("vec[%d]: %llx\n", i, page_vec->pages[i]);
-}
-
 int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 			    struct iser_data_buf *data,
 			    enum iser_data_dir iser_dir,
@@ -213,84 +126,9 @@ iser_reg_dma(struct iser_device *device, struct iser_data_buf *mem,
 	return 0;
 }
 
-static int iser_set_page(struct ib_mr *mr, u64 addr)
-{
-	struct iser_page_vec *page_vec =
-		container_of(mr, struct iser_page_vec, fake_mr);
-
-	page_vec->pages[page_vec->npages++] = addr;
-
-	return 0;
-}
-
-static
-int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
-		      struct iser_data_buf *mem,
-		      struct iser_reg_resources *rsc,
-		      struct iser_mem_reg *reg)
-{
-	struct ib_conn *ib_conn = &iser_task->iser_conn->ib_conn;
-	struct iser_device *device = ib_conn->device;
-	struct iser_page_vec *page_vec = rsc->page_vec;
-	struct ib_fmr_pool *fmr_pool = rsc->fmr_pool;
-	struct ib_pool_fmr *fmr;
-	int ret, plen;
-
-	page_vec->npages = 0;
-	page_vec->fake_mr.page_size = SZ_4K;
-	plen = ib_sg_to_pages(&page_vec->fake_mr, mem->sg,
-			      mem->dma_nents, NULL, iser_set_page);
-	if (unlikely(plen < mem->dma_nents)) {
-		iser_err("page vec too short to hold this SG\n");
-		iser_data_buf_dump(mem, device->ib_device);
-		iser_dump_page_vec(page_vec);
-		return -EINVAL;
-	}
-
-	fmr  = ib_fmr_pool_map_phys(fmr_pool, page_vec->pages,
-				    page_vec->npages, page_vec->pages[0]);
-	if (IS_ERR(fmr)) {
-		ret = PTR_ERR(fmr);
-		iser_err("ib_fmr_pool_map_phys failed: %d\n", ret);
-		return ret;
-	}
-
-	reg->sge.lkey = fmr->fmr->lkey;
-	reg->rkey = fmr->fmr->rkey;
-	reg->sge.addr = page_vec->fake_mr.iova;
-	reg->sge.length = page_vec->fake_mr.length;
-	reg->mem_h = fmr;
-
-	iser_dbg("fmr reg: lkey=0x%x, rkey=0x%x, addr=0x%llx,"
-		 " length=0x%x\n", reg->sge.lkey, reg->rkey,
-		 reg->sge.addr, reg->sge.length);
-
-	return 0;
-}
-
-/**
- * Unregister (previosuly registered using FMR) memory.
- * If memory is non-FMR does nothing.
- */
-void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
-			enum iser_data_dir cmd_dir)
-{
-	struct iser_mem_reg *reg = &iser_task->rdma_reg[cmd_dir];
-
-	if (!reg->mem_h)
-		return;
-
-	iser_dbg("PHYSICAL Mem.Unregister mem_h %p\n", reg->mem_h);
-
-	ib_fmr_pool_unmap((struct ib_pool_fmr *)reg->mem_h);
-
-	reg->mem_h = NULL;
-}
-
 void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 			    enum iser_data_dir cmd_dir)
 {
-	struct iser_device *device = iser_task->iser_conn->ib_conn.device;
 	struct iser_mem_reg *reg = &iser_task->rdma_reg[cmd_dir];
 	struct iser_fr_desc *desc;
 	struct ib_mr_status mr_status;
@@ -312,7 +150,7 @@ void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
 		ib_check_mr_status(desc->rsc.sig_mr, IB_MR_CHECK_SIG_STATUS,
 				   &mr_status);
 	}
-	device->reg_ops->reg_desc_put(&iser_task->iser_conn->ib_conn, desc);
+	iser_reg_desc_put_fr(&iser_task->iser_conn->ib_conn, reg->mem_h);
 	reg->mem_h = NULL;
 }
 
@@ -509,15 +347,14 @@ iser_reg_data_sg(struct iscsi_iser_task *task,
 	if (use_dma_key)
 		return iser_reg_dma(device, mem, reg);
 
-	return device->reg_ops->reg_mem(task, mem, &desc->rsc, reg);
+	return iser_fast_reg_mr(task, mem, &desc->rsc, reg);
 }
 
-int iser_reg_rdma_mem(struct iscsi_iser_task *task,
-		      enum iser_data_dir dir,
-		      bool all_imm)
+int iser_reg_mem_fastreg(struct iscsi_iser_task *task,
+			 enum iser_data_dir dir,
+			 bool all_imm)
 {
 	struct ib_conn *ib_conn = &task->iser_conn->ib_conn;
-	struct iser_device *device = ib_conn->device;
 	struct iser_data_buf *mem = &task->data[dir];
 	struct iser_mem_reg *reg = &task->rdma_reg[dir];
 	struct iser_fr_desc *desc = NULL;
@@ -528,7 +365,7 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
 		      scsi_get_prot_op(task->sc) == SCSI_PROT_NORMAL;
 
 	if (!use_dma_key) {
-		desc = device->reg_ops->reg_desc_get(ib_conn);
+		desc = iser_reg_desc_get_fr(ib_conn);
 		reg->mem_h = desc;
 	}
 
@@ -549,15 +386,8 @@ int iser_reg_rdma_mem(struct iscsi_iser_task *task,
 
 err_reg:
 	if (desc)
-		device->reg_ops->reg_desc_put(ib_conn, desc);
+		iser_reg_desc_put_fr(ib_conn, desc);
 
 	return err;
 }
 
-void iser_unreg_rdma_mem(struct iscsi_iser_task *task,
-			 enum iser_data_dir dir)
-{
-	struct iser_device *device = task->iser_conn->ib_conn.device;
-
-	device->reg_ops->unreg_mem(task, dir);
-}
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 127887c6c03fb9..c1f44c41f501fd 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -68,11 +68,12 @@ static void iser_event_handler(struct ib_event_handler *handler,
 static int iser_create_device_ib_res(struct iser_device *device)
 {
 	struct ib_device *ib_dev = device->ib_device;
-	int ret, i, max_cqe;
+	int i, max_cqe;
 
-	ret = iser_assign_reg_ops(device);
-	if (ret)
-		return ret;
+	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS)) {
+		iser_err("IB device does not support memory registrations\n");
+		return -1;
+	}
 
 	device->comps_used = min_t(int, num_online_cpus(),
 				 ib_dev->num_comp_vectors);
@@ -147,96 +148,6 @@ static void iser_free_device_ib_res(struct iser_device *device)
 	device->pd = NULL;
 }
 
-/**
- * iser_alloc_fmr_pool - Creates FMR pool and page_vector
- * @ib_conn: connection RDMA resources
- * @cmds_max: max number of SCSI commands for this connection
- * @size: max number of pages per map request
- *
- * Return: 0 on success, or errno code on failure
- */
-int iser_alloc_fmr_pool(struct ib_conn *ib_conn,
-			unsigned cmds_max,
-			unsigned int size)
-{
-	struct iser_device *device = ib_conn->device;
-	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
-	struct iser_page_vec *page_vec;
-	struct iser_fr_desc *desc;
-	struct ib_fmr_pool *fmr_pool;
-	struct ib_fmr_pool_param params;
-	int ret;
-
-	INIT_LIST_HEAD(&fr_pool->list);
-	spin_lock_init(&fr_pool->lock);
-
-	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
-	if (!desc)
-		return -ENOMEM;
-
-	page_vec = kmalloc(sizeof(*page_vec) + (sizeof(u64) * size),
-			   GFP_KERNEL);
-	if (!page_vec) {
-		ret = -ENOMEM;
-		goto err_frpl;
-	}
-
-	page_vec->pages = (u64 *)(page_vec + 1);
-
-	params.page_shift        = ilog2(SZ_4K);
-	params.max_pages_per_fmr = size;
-	/* make the pool size twice the max number of SCSI commands *
-	 * the ML is expected to queue, watermark for unmap at 50%  */
-	params.pool_size	 = cmds_max * 2;
-	params.dirty_watermark	 = cmds_max;
-	params.cache		 = 0;
-	params.flush_function	 = NULL;
-	params.access		 = (IB_ACCESS_LOCAL_WRITE  |
-				    IB_ACCESS_REMOTE_WRITE |
-				    IB_ACCESS_REMOTE_READ);
-
-	fmr_pool = ib_create_fmr_pool(device->pd, &params);
-	if (IS_ERR(fmr_pool)) {
-		ret = PTR_ERR(fmr_pool);
-		iser_err("FMR allocation failed, err %d\n", ret);
-		goto err_fmr;
-	}
-
-	desc->rsc.page_vec = page_vec;
-	desc->rsc.fmr_pool = fmr_pool;
-	list_add(&desc->list, &fr_pool->list);
-
-	return 0;
-
-err_fmr:
-	kfree(page_vec);
-err_frpl:
-	kfree(desc);
-
-	return ret;
-}
-
-/**
- * iser_free_fmr_pool - releases the FMR pool and page vec
- * @ib_conn: connection RDMA resources
- */
-void iser_free_fmr_pool(struct ib_conn *ib_conn)
-{
-	struct iser_fr_pool *fr_pool = &ib_conn->fr_pool;
-	struct iser_fr_desc *desc;
-
-	desc = list_first_entry(&fr_pool->list,
-				struct iser_fr_desc, list);
-	list_del(&desc->list);
-
-	iser_info("freeing conn %p fmr pool %p\n",
-		  ib_conn, desc->rsc.fmr_pool);
-
-	ib_destroy_fmr_pool(desc->rsc.fmr_pool);
-	kfree(desc->rsc.page_vec);
-	kfree(desc);
-}
-
 static struct iser_fr_desc *
 iser_create_fastreg_desc(struct iser_device *device,
 			 struct ib_pd *pd,
@@ -667,13 +578,12 @@ iser_calc_scsi_params(struct iser_conn *iser_conn,
 	u32 max_num_sg;
 
 	/*
-	 * FRs without SG_GAPS or FMRs can only map up to a (device) page per
-	 * entry, but if the first entry is misaligned we'll end up using two
-	 * entries (head and tail) for a single page worth data, so one
-	 * additional entry is required.
+	 * FRs without SG_GAPS can only map up to a (device) page per entry,
+	 * but if the first entry is misaligned we'll end up using two entries
+	 * (head and tail) for a single page worth data, so one additional
+	 * entry is required.
 	 */
-	if ((attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) &&
-	    (attr->device_cap_flags & IB_DEVICE_SG_GAPS_REG))
+	if (attr->device_cap_flags & IB_DEVICE_SG_GAPS_REG)
 		reserved_mr_pages = 0;
 	else
 		reserved_mr_pages = 1;
@@ -684,14 +594,8 @@ iser_calc_scsi_params(struct iser_conn *iser_conn,
 		max_num_sg = attr->max_fast_reg_page_list_len;
 
 	sg_tablesize = DIV_ROUND_UP(max_sectors * SECTOR_SIZE, SZ_4K);
-	if (attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS)
-		sup_sg_tablesize =
-			min_t(
-			 uint, ISCSI_ISER_MAX_SG_TABLESIZE,
-			 max_num_sg - reserved_mr_pages);
-	else
-		sup_sg_tablesize = ISCSI_ISER_MAX_SG_TABLESIZE;
-
+	sup_sg_tablesize = min_t(uint, ISCSI_ISER_MAX_SG_TABLESIZE,
+				 max_num_sg - reserved_mr_pages);
 	iser_conn->scsi_sg_tablesize = min(sg_tablesize, sup_sg_tablesize);
 	iser_conn->pages_per_mr =
 		iser_conn->scsi_sg_tablesize + reserved_mr_pages;
@@ -755,7 +659,7 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
 	struct iser_cm_hdr req_hdr;
 	struct iser_conn *iser_conn = (struct iser_conn *)cma_id->context;
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
-	struct iser_device *device = ib_conn->device;
+	struct ib_device *ib_dev = ib_conn->device->ib_device;
 
 	if (iser_conn->state != ISER_CONN_PENDING)
 		/* bailout */
@@ -766,14 +670,14 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
 		goto failure;
 
 	memset(&conn_param, 0, sizeof conn_param);
-	conn_param.responder_resources = device->ib_device->attrs.max_qp_rd_atom;
+	conn_param.responder_resources = ib_dev->attrs.max_qp_rd_atom;
 	conn_param.initiator_depth     = 1;
 	conn_param.retry_count	       = 7;
 	conn_param.rnr_retry_count     = 6;
 
 	memset(&req_hdr, 0, sizeof(req_hdr));
 	req_hdr.flags = ISER_ZBVA_NOT_SUP;
-	if (!device->remote_inv_sup)
+	if (!iser_always_reg)
 		req_hdr.flags |= ISER_SEND_W_INV_NOT_SUP;
 	conn_param.private_data	= (void *)&req_hdr;
 	conn_param.private_data_len = sizeof(struct iser_cm_hdr);
-- 
2.26.2

