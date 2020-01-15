Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342B713C15A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgAOMoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:44:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbgAOMoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:44:11 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D384F222C3;
        Wed, 15 Jan 2020 12:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092250;
        bh=YzVzPyYRq9lDZbuXc7KcdNJuk6oP0Ssa7LrsnPZQgJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXRZUuU3si19FKatC6d8sCSo/aJR69NMaZ+ECd9m1maIexF7FebdeYVA+akN1g0et
         TKFfPqJKeCOTrzWx7MwsLt3o8gbV9GLs7udoyDEUm5EpGfwuVWb9+04GN6GQi0H/G4
         4VyTLBCs9u4wx5tJbku/+hyljWrMwt68UXTIo7jI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 09/10] net/rds: Handle ODP mr registration/unregistration
Date:   Wed, 15 Jan 2020 14:43:39 +0200
Message-Id: <20200115124340.79108-10-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115124340.79108-1-leon@kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>

On-Demand-Paging MRs are registered using ib_reg_user_mr and
unregistered with ib_dereg_mr.

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 net/rds/ib.c      |   7 +++
 net/rds/ib.h      |   3 +-
 net/rds/ib_mr.h   |   7 ++-
 net/rds/ib_rdma.c |  74 ++++++++++++++++++++++-
 net/rds/ib_send.c |  44 ++++++++++----
 net/rds/rdma.c    | 150 ++++++++++++++++++++++++++++++++++------------
 net/rds/rds.h     |  13 +++-
 7 files changed, 242 insertions(+), 56 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 3fd5f40189bd..a792d8a3872a 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -156,6 +156,13 @@ static void rds_ib_add_one(struct ib_device *device)
 	has_fmr = (device->ops.alloc_fmr && device->ops.dealloc_fmr &&
 		   device->ops.map_phys_fmr && device->ops.unmap_fmr);
 	rds_ibdev->use_fastreg = (has_fr && !has_fmr);
+	rds_ibdev->odp_capable =
+		!!(device->attrs.device_cap_flags &
+		   IB_DEVICE_ON_DEMAND_PAGING) &&
+		!!(device->attrs.odp_caps.per_transport_caps.rc_odp_caps &
+		   IB_ODP_SUPPORT_WRITE) &&
+		!!(device->attrs.odp_caps.per_transport_caps.rc_odp_caps &
+		   IB_ODP_SUPPORT_READ);

 	rds_ibdev->fmr_max_remaps = device->attrs.max_map_per_fmr?: 32;
 	rds_ibdev->max_1m_mrs = device->attrs.max_mr ?
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 6e6f24753998..0296f1f7acda 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -247,7 +247,8 @@ struct rds_ib_device {
 	struct ib_device	*dev;
 	struct ib_pd		*pd;
 	struct dma_pool		*rid_hdrs_pool; /* RDS headers DMA pool */
-	bool                    use_fastreg;
+	u8			use_fastreg:1;
+	u8			odp_capable:1;

 	unsigned int		max_mrs;
 	struct rds_ib_mr_pool	*mr_1m_pool;
diff --git a/net/rds/ib_mr.h b/net/rds/ib_mr.h
index 9045a8c0edff..0c8252d7fe2b 100644
--- a/net/rds/ib_mr.h
+++ b/net/rds/ib_mr.h
@@ -67,6 +67,7 @@ struct rds_ib_frmr {

 /* This is stored as mr->r_trans_private. */
 struct rds_ib_mr {
+	struct delayed_work		work;
 	struct rds_ib_device		*device;
 	struct rds_ib_mr_pool		*pool;
 	struct rds_ib_connection	*ic;
@@ -81,9 +82,11 @@ struct rds_ib_mr {
 	unsigned int			sg_len;
 	int				sg_dma_len;

+	u8				odp:1;
 	union {
 		struct rds_ib_fmr	fmr;
 		struct rds_ib_frmr	frmr;
+		struct ib_mr		*mr;
 	} u;
 };

@@ -122,12 +125,14 @@ void rds6_ib_get_mr_info(struct rds_ib_device *rds_ibdev,
 void rds_ib_destroy_mr_pool(struct rds_ib_mr_pool *);
 void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
 		    struct rds_sock *rs, u32 *key_ret,
-		    struct rds_connection *conn);
+		    struct rds_connection *conn, u64 start, u64 length,
+		    int need_odp);
 void rds_ib_sync_mr(void *trans_private, int dir);
 void rds_ib_free_mr(void *trans_private, int invalidate);
 void rds_ib_flush_mrs(void);
 int rds_ib_mr_init(void);
 void rds_ib_mr_exit(void);
+u32 rds_ib_get_lkey(void *trans_private);

 void __rds_ib_teardown_mr(struct rds_ib_mr *);
 void rds_ib_teardown_mr(struct rds_ib_mr *);
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index c8c1e3ae8d84..5a02b313ec50 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -37,8 +37,15 @@

 #include "rds_single_path.h"
 #include "ib_mr.h"
+#include "rds.h"

 struct workqueue_struct *rds_ib_mr_wq;
+struct rds_ib_dereg_odp_mr {
+	struct work_struct work;
+	struct ib_mr *mr;
+};
+
+static void rds_ib_odp_mr_worker(struct work_struct *work);

 static struct rds_ib_device *rds_ib_get_device(__be32 ipaddr)
 {
@@ -213,6 +220,8 @@ void rds_ib_sync_mr(void *trans_private, int direction)
 	struct rds_ib_mr *ibmr = trans_private;
 	struct rds_ib_device *rds_ibdev = ibmr->device;

+	if (ibmr->odp)
+		return;
 	switch (direction) {
 	case DMA_FROM_DEVICE:
 		ib_dma_sync_sg_for_cpu(rds_ibdev->dev, ibmr->sg,
@@ -482,6 +491,16 @@ void rds_ib_free_mr(void *trans_private, int invalidate)

 	rdsdebug("RDS/IB: free_mr nents %u\n", ibmr->sg_len);

+	if (ibmr->odp) {
+		/* A MR created and marked as use_once. We use delayed work,
+		 * because there is a change that we are in interrupt and can't
+		 * call to ib_dereg_mr() directly.
+		 */
+		INIT_DELAYED_WORK(&ibmr->work, rds_ib_odp_mr_worker);
+		queue_delayed_work(rds_ib_mr_wq, &ibmr->work, 0);
+		return;
+	}
+
 	/* Return it to the pool's free list */
 	if (rds_ibdev->use_fastreg)
 		rds_ib_free_frmr_list(ibmr);
@@ -526,9 +545,17 @@ void rds_ib_flush_mrs(void)
 	up_read(&rds_ib_devices_lock);
 }

+u32 rds_ib_get_lkey(void *trans_private)
+{
+	struct rds_ib_mr *ibmr = trans_private;
+
+	return ibmr->u.mr->lkey;
+}
+
 void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
 		    struct rds_sock *rs, u32 *key_ret,
-		    struct rds_connection *conn)
+		    struct rds_connection *conn,
+		    u64 start, u64 length, int need_odp)
 {
 	struct rds_ib_device *rds_ibdev;
 	struct rds_ib_mr *ibmr = NULL;
@@ -541,6 +568,42 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
 		goto out;
 	}

+	if (need_odp == ODP_ZEROBASED || need_odp == ODP_VIRTUAL) {
+		u64 virt_addr = need_odp == ODP_ZEROBASED ? 0 : start;
+		int access_flags =
+			(IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
+			 IB_ACCESS_REMOTE_WRITE | IB_ACCESS_REMOTE_ATOMIC |
+			 IB_ACCESS_ON_DEMAND);
+		struct ib_mr *ib_mr;
+
+		if (!rds_ibdev->odp_capable) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
+
+		ib_mr = ib_reg_user_mr(rds_ibdev->pd, start, length, virt_addr,
+				       access_flags);
+
+		if (IS_ERR(ib_mr)) {
+			rdsdebug("rds_ib_get_user_mr returned %d\n",
+				 IS_ERR(ib_mr));
+			ret = PTR_ERR(ib_mr);
+			goto out;
+		}
+		if (key_ret)
+			*key_ret = ib_mr->rkey;
+
+		ibmr = kzalloc(sizeof(*ibmr), GFP_KERNEL);
+		if (!ibmr) {
+			ib_dereg_mr(ib_mr);
+			ret = -ENOMEM;
+			goto out;
+		}
+		ibmr->u.mr = ib_mr;
+		ibmr->odp = 1;
+		return ibmr;
+	}
+
 	if (conn)
 		ic = conn->c_transport_data;

@@ -629,3 +692,12 @@ void rds_ib_mr_exit(void)
 {
 	destroy_workqueue(rds_ib_mr_wq);
 }
+
+static void rds_ib_odp_mr_worker(struct work_struct  *work)
+{
+	struct rds_ib_mr *ibmr;
+
+	ibmr = container_of(work, struct rds_ib_mr, work.work);
+	ib_dereg_mr(ibmr->u.mr);
+	kfree(ibmr);
+}
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index d1cc1d7778d8..dfe778220657 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -39,6 +39,7 @@
 #include "rds_single_path.h"
 #include "rds.h"
 #include "ib.h"
+#include "ib_mr.h"

 /*
  * Convert IB-specific error message to RDS error message and call core
@@ -635,6 +636,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 		send->s_sge[0].addr = ic->i_send_hdrs_dma[pos];

 		send->s_sge[0].length = sizeof(struct rds_header);
+		send->s_sge[0].lkey = ic->i_pd->local_dma_lkey;

 		memcpy(ic->i_send_hdrs[pos], &rm->m_inc.i_hdr,
 		       sizeof(struct rds_header));
@@ -650,6 +652,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 			send->s_sge[1].addr = sg_dma_address(scat);
 			send->s_sge[1].addr += rm->data.op_dmaoff;
 			send->s_sge[1].length = len;
+			send->s_sge[1].lkey = ic->i_pd->local_dma_lkey;

 			bytes_sent += len;
 			rm->data.op_dmaoff += len;
@@ -858,20 +861,29 @@ int rds_ib_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 	int ret;
 	int num_sge;
 	int nr_sig = 0;
+	u64 odp_addr = op->op_odp_addr;
+	u32 odp_lkey = 0;

 	/* map the op the first time we see it */
-	if (!op->op_mapped) {
-		op->op_count = ib_dma_map_sg(ic->i_cm_id->device,
-					     op->op_sg, op->op_nents, (op->op_write) ?
-					     DMA_TO_DEVICE : DMA_FROM_DEVICE);
-		rdsdebug("ic %p mapping op %p: %d\n", ic, op, op->op_count);
-		if (op->op_count == 0) {
-			rds_ib_stats_inc(s_ib_tx_sg_mapping_failure);
-			ret = -ENOMEM; /* XXX ? */
-			goto out;
+	if (!op->op_odp_mr) {
+		if (!op->op_mapped) {
+			op->op_count =
+				ib_dma_map_sg(ic->i_cm_id->device, op->op_sg,
+					      op->op_nents,
+					      (op->op_write) ? DMA_TO_DEVICE :
+							       DMA_FROM_DEVICE);
+			rdsdebug("ic %p mapping op %p: %d\n", ic, op,
+				 op->op_count);
+			if (op->op_count == 0) {
+				rds_ib_stats_inc(s_ib_tx_sg_mapping_failure);
+				ret = -ENOMEM; /* XXX ? */
+				goto out;
+			}
+			op->op_mapped = 1;
 		}
-
-		op->op_mapped = 1;
+	} else {
+		op->op_count = op->op_nents;
+		odp_lkey = rds_ib_get_lkey(op->op_odp_mr->r_trans_private);
 	}

 	/*
@@ -923,14 +935,20 @@ int rds_ib_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 		for (j = 0; j < send->s_rdma_wr.wr.num_sge &&
 		     scat != &op->op_sg[op->op_count]; j++) {
 			len = sg_dma_len(scat);
-			send->s_sge[j].addr = sg_dma_address(scat);
+			if (!op->op_odp_mr) {
+				send->s_sge[j].addr = sg_dma_address(scat);
+				send->s_sge[j].lkey = ic->i_pd->local_dma_lkey;
+			} else {
+				send->s_sge[j].addr = odp_addr;
+				send->s_sge[j].lkey = odp_lkey;
+			}
 			send->s_sge[j].length = len;
-			send->s_sge[j].lkey = ic->i_pd->local_dma_lkey;

 			sent += len;
 			rdsdebug("ic %p sent %d remote_addr %llu\n", ic, sent, remote_addr);

 			remote_addr += len;
+			odp_addr += len;
 			scat++;
 		}

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index eb23c38ce2b3..3c6afdda709b 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -177,13 +177,14 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 			  struct rds_conn_path *cp)
 {
 	struct rds_mr *mr = NULL, *found;
+	struct scatterlist *sg = NULL;
 	unsigned int nr_pages;
 	struct page **pages = NULL;
-	struct scatterlist *sg;
 	void *trans_private;
 	unsigned long flags;
 	rds_rdma_cookie_t cookie;
-	unsigned int nents;
+	unsigned int nents = 0;
+	int need_odp = 0;
 	long i;
 	int ret;

@@ -196,6 +197,20 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
+	/* If the combination of the addr and size requested for this memory
+	 * region causes an integer overflow, return error.
+	 */
+	if (((args->vec.addr + args->vec.bytes) < args->vec.addr) ||
+	    PAGE_ALIGN(args->vec.addr + args->vec.bytes) <
+		    (args->vec.addr + args->vec.bytes)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!can_do_mlock()) {
+		ret = -EPERM;
+		goto out;
+	}

 	nr_pages = rds_pages_in_vec(&args->vec);
 	if (nr_pages == 0) {
@@ -250,36 +265,44 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 	 * the zero page.
 	 */
 	ret = rds_pin_pages(args->vec.addr, nr_pages, pages, 1);
-	if (ret < 0)
+	if (ret == -EOPNOTSUPP) {
+		need_odp = 1;
+	} else if (ret <= 0) {
 		goto out;
+	} else {
+		nents = ret;
+		sg = kcalloc(nents, sizeof(*sg), GFP_KERNEL);
+		if (!sg) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		WARN_ON(!nents);
+		sg_init_table(sg, nents);

-	nents = ret;
-	sg = kcalloc(nents, sizeof(*sg), GFP_KERNEL);
-	if (!sg) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	WARN_ON(!nents);
-	sg_init_table(sg, nents);
-
-	/* Stick all pages into the scatterlist */
-	for (i = 0 ; i < nents; i++)
-		sg_set_page(&sg[i], pages[i], PAGE_SIZE, 0);
-
-	rdsdebug("RDS: trans_private nents is %u\n", nents);
+		/* Stick all pages into the scatterlist */
+		for (i = 0 ; i < nents; i++)
+			sg_set_page(&sg[i], pages[i], PAGE_SIZE, 0);

+		rdsdebug("RDS: trans_private nents is %u\n", nents);
+	}
 	/* Obtain a transport specific MR. If this succeeds, the
 	 * s/g list is now owned by the MR.
 	 * Note that dma_map() implies that pending writes are
 	 * flushed to RAM, so no dma_sync is needed here. */
-	trans_private = rs->rs_transport->get_mr(sg, nents, rs,
-						 &mr->r_key,
-						 cp ? cp->cp_conn : NULL);
+	trans_private = rs->rs_transport->get_mr(
+		sg, nents, rs, &mr->r_key, cp ? cp->cp_conn : NULL,
+		args->vec.addr, args->vec.bytes,
+		need_odp ? ODP_ZEROBASED : ODP_NOT_NEEDED);

 	if (IS_ERR(trans_private)) {
-		for (i = 0 ; i < nents; i++)
-			put_page(sg_page(&sg[i]));
-		kfree(sg);
+		/* In ODP case, we don't GUP pages, so don't need
+		 * to release anything.
+		 */
+		if (!need_odp) {
+			for (i = 0 ; i < nents; i++)
+				put_page(sg_page(&sg[i]));
+			kfree(sg);
+		}
 		ret = PTR_ERR(trans_private);
 		goto out;
 	}
@@ -293,7 +316,11 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 	 * map page aligned regions. So we keep the offset, and build
 	 * a 64bit cookie containing <R_Key, offset> and pass that
 	 * around. */
-	cookie = rds_rdma_make_cookie(mr->r_key, args->vec.addr & ~PAGE_MASK);
+	if (need_odp)
+		cookie = rds_rdma_make_cookie(mr->r_key, 0);
+	else
+		cookie = rds_rdma_make_cookie(mr->r_key,
+					      args->vec.addr & ~PAGE_MASK);
 	if (cookie_ret)
 		*cookie_ret = cookie;

@@ -458,22 +485,26 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
 {
 	unsigned int i;

-	for (i = 0; i < ro->op_nents; i++) {
-		struct page *page = sg_page(&ro->op_sg[i]);
-
-		/* Mark page dirty if it was possibly modified, which
-		 * is the case for a RDMA_READ which copies from remote
-		 * to local memory */
-		if (!ro->op_write) {
-			WARN_ON(!page->mapping && irqs_disabled());
-			set_page_dirty(page);
+	if (ro->op_odp_mr) {
+		rds_mr_put(ro->op_odp_mr);
+	} else {
+		for (i = 0; i < ro->op_nents; i++) {
+			struct page *page = sg_page(&ro->op_sg[i]);
+
+			/* Mark page dirty if it was possibly modified, which
+			 * is the case for a RDMA_READ which copies from remote
+			 * to local memory
+			 */
+			if (!ro->op_write)
+				set_page_dirty(page);
+			put_page(page);
 		}
-		put_page(page);
 	}

 	kfree(ro->op_notifier);
 	ro->op_notifier = NULL;
 	ro->op_active = 0;
+	ro->op_odp_mr = NULL;
 }

 void rds_atomic_free_op(struct rm_atomic_op *ao)
@@ -583,6 +614,7 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 	struct rds_iovec *iovs;
 	unsigned int i, j;
 	int ret = 0;
+	bool odp_supported = true;

 	if (cmsg->cmsg_len < CMSG_LEN(sizeof(struct rds_rdma_args))
 	    || rm->rdma.op_active)
@@ -604,6 +636,9 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 		ret = -EINVAL;
 		goto out_ret;
 	}
+	/* odp-mr is not supported for multiple requests within one message */
+	if (args->nr_local != 1)
+		odp_supported = false;

 	iovs = vec->iov;

@@ -625,6 +660,8 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 	op->op_silent = !!(args->flags & RDS_RDMA_SILENT);
 	op->op_active = 1;
 	op->op_recverr = rs->rs_recverr;
+	op->op_odp_mr = NULL;
+
 	WARN_ON(!nr_pages);
 	op->op_sg = rds_message_alloc_sgs(rm, nr_pages, &ret);
 	if (!op->op_sg)
@@ -674,10 +711,44 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 		 * If it's a READ operation, we need to pin the pages for writing.
 		 */
 		ret = rds_pin_pages(iov->addr, nr, pages, !op->op_write);
-		if (ret < 0)
+		if ((!odp_supported && ret <= 0) ||
+		    (odp_supported && ret <= 0 && ret != -EOPNOTSUPP))
 			goto out_pages;
-		else
-			ret = 0;
+
+		if (ret == -EOPNOTSUPP) {
+			struct rds_mr *local_odp_mr;
+
+			if (!rs->rs_transport->get_mr) {
+				ret = -EOPNOTSUPP;
+				goto out_pages;
+			}
+			local_odp_mr =
+				kzalloc(sizeof(*local_odp_mr), GFP_KERNEL);
+			if (!local_odp_mr) {
+				ret = -ENOMEM;
+				goto out_pages;
+			}
+			RB_CLEAR_NODE(&local_odp_mr->r_rb_node);
+			refcount_set(&local_odp_mr->r_refcount, 1);
+			local_odp_mr->r_trans = rs->rs_transport;
+			local_odp_mr->r_sock = rs;
+			local_odp_mr->r_trans_private =
+				rs->rs_transport->get_mr(
+					NULL, 0, rs, &local_odp_mr->r_key, NULL,
+					iov->addr, iov->bytes, ODP_VIRTUAL);
+			if (IS_ERR(local_odp_mr->r_trans_private)) {
+				ret = IS_ERR(local_odp_mr->r_trans_private);
+				rdsdebug("get_mr ret %d %p\"", ret,
+					 local_odp_mr->r_trans_private);
+				kfree(local_odp_mr);
+				ret = -EOPNOTSUPP;
+				goto out_pages;
+			}
+			rdsdebug("Need odp; local_odp_mr %p trans_private %p\n",
+				 local_odp_mr, local_odp_mr->r_trans_private);
+			op->op_odp_mr = local_odp_mr;
+			op->op_odp_addr = iov->addr;
+		}

 		rdsdebug("RDS: nr_bytes %u nr %u iov->bytes %llu iov->addr %llx\n",
 			 nr_bytes, nr, iov->bytes, iov->addr);
@@ -693,6 +764,7 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 					min_t(unsigned int, iov->bytes, PAGE_SIZE - offset),
 					offset);

+			sg->dma_length = sg->length;
 			rdsdebug("RDS: sg->offset %x sg->len %x iov->addr %llx iov->bytes %llu\n",
 			       sg->offset, sg->length, iov->addr, iov->bytes);

@@ -711,6 +783,7 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 		goto out_pages;
 	}
 	op->op_bytes = nr_bytes;
+	ret = 0;

 out_pages:
 	kfree(pages);
@@ -757,7 +830,8 @@ int rds_cmsg_rdma_dest(struct rds_sock *rs, struct rds_message *rm,
 	spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);

 	if (mr) {
-		mr->r_trans->sync_mr(mr->r_trans_private, DMA_TO_DEVICE);
+		mr->r_trans->sync_mr(mr->r_trans_private,
+				     DMA_TO_DEVICE);
 		rm->rdma.op_rdma_mr = mr;
 	}
 	return err;
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 53e86911773a..e4a603523083 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -40,7 +40,6 @@
 #ifdef ATOMIC64_INIT
 #define KERNEL_HAS_ATOMIC64
 #endif
-
 #ifdef RDS_DEBUG
 #define rdsdebug(fmt, args...) pr_debug("%s(): " fmt, __func__ , ##args)
 #else
@@ -478,6 +477,9 @@ struct rds_message {
 			struct rds_notifier	*op_notifier;

 			struct rds_mr		*op_rdma_mr;
+
+			u64			op_odp_addr;
+			struct rds_mr		*op_odp_mr;
 		} rdma;
 		struct rm_data_op {
 			unsigned int		op_active:1;
@@ -573,7 +575,8 @@ struct rds_transport {
 	void (*exit)(void);
 	void *(*get_mr)(struct scatterlist *sg, unsigned long nr_sg,
 			struct rds_sock *rs, u32 *key_ret,
-			struct rds_connection *conn);
+			struct rds_connection *conn,
+			u64 start, u64 length, int need_odp);
 	void (*sync_mr)(void *trans_private, int direction);
 	void (*free_mr)(void *trans_private, int invalidate);
 	void (*flush_mrs)(void);
@@ -956,6 +959,12 @@ static inline bool rds_destroy_pending(struct rds_connection *conn)
 	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
 }

+enum {
+	ODP_NOT_NEEDED,
+	ODP_ZEROBASED,
+	ODP_VIRTUAL
+};
+
 /* stats.c */
 DECLARE_PER_CPU_SHARED_ALIGNED(struct rds_statistics, rds_stats);
 #define rds_stats_inc_which(which, member) do {		\
--
2.20.1

