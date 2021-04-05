Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69961353B8B
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhDEFYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhDEFYV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D90E661395;
        Mon,  5 Apr 2021 05:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600256;
        bh=cKVzXTospyoAPnuwfNPiiZRibqBhsg50do4P7egUacY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dyc6+wcWSHtvcjGCiU1g1L10qGGHNDfWffEzv31YcC7MpQVzNgUupKOZj6AL+cNlJ
         aPsppZ6ApJNt762MrExUctnt4dsWZB+msAVwQ9YUswRMySseKDegRRqj87gvdkzWuw
         XksmX5Wy2N13YmsGjs++M4OOlqY8nv3gThjc5gIGrcUOMohSaIWcyAhUB6oONuNhMo
         7s84USdQ0yvON3lhWC0adM4WUG+4uSorQ4N+J5ewnfnP4UWBo2grjmGILLBa9881VW
         u22eFp6WFHeIdSseTGYLqz93qADfomej727NHxo+OIiVZsBqZxW9u6KGk+Y6FjBXHJ
         Bqc6XdGY8Uv5g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next 01/10] RDMA: Add access flags to ib_alloc_mr() and ib_mr_pool_init()
Date:   Mon,  5 Apr 2021 08:23:55 +0300
Message-Id: <20210405052404.213889-2-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405052404.213889-1-leon@kernel.org>
References: <20210405052404.213889-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Add access flags parameter to ib_alloc_mr() and to ib_mr_pool_init(),
and refactor relevant code. This parameter is used to pass MR access
flags during MR allocation.

In the following patches, the new access flags parameter will be used
to enable Relaxed Ordering for ib_alloc_mr() and ib_mr_pool_init() users.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/mr_pool.c             |  7 +-
 drivers/infiniband/core/rw.c                  | 12 ++--
 drivers/infiniband/core/verbs.c               | 23 +++++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h      |  2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |  2 +-
 drivers/infiniband/hw/cxgb4/mem.c             |  2 +-
 drivers/infiniband/hw/hns/hns_roce_device.h   |  2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c       |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     |  3 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |  2 +-
 drivers/infiniband/hw/mlx4/mr.c               |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          | 12 ++--
 drivers/infiniband/hw/mlx5/mr.c               | 61 ++++++++--------
 drivers/infiniband/hw/mlx5/wr.c               | 69 ++++++++++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h   |  2 +-
 drivers/infiniband/hw/qedr/verbs.c            |  2 +-
 drivers/infiniband/hw/qedr/verbs.h            |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c  |  3 +-
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |  2 +-
 drivers/infiniband/sw/rdmavt/mr.c             |  3 +-
 drivers/infiniband/sw/rdmavt/mr.h             |  2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c         |  2 +-
 drivers/infiniband/sw/siw/siw_verbs.c         |  2 +-
 drivers/infiniband/sw/siw/siw_verbs.h         |  2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c      |  4 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |  2 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c        |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |  2 +-
 drivers/nvme/host/rdma.c                      |  4 +-
 fs/cifs/smbdirect.c                           |  7 +-
 include/rdma/ib_verbs.h                       | 11 ++-
 include/rdma/mr_pool.h                        |  3 +-
 net/rds/ib_frmr.c                             |  2 +-
 net/smc/smc_ib.c                              |  2 +-
 net/sunrpc/xprtrdma/frwr_ops.c                |  2 +-
 37 files changed, 163 insertions(+), 105 deletions(-)

diff --git a/drivers/infiniband/core/mr_pool.c b/drivers/infiniband/core/mr_pool.c
index c0e2df128b34..b869c3487475 100644
--- a/drivers/infiniband/core/mr_pool.c
+++ b/drivers/infiniband/core/mr_pool.c
@@ -34,7 +34,8 @@ void ib_mr_pool_put(struct ib_qp *qp, struct list_head *list, struct ib_mr *mr)
 EXPORT_SYMBOL(ib_mr_pool_put);
 
 int ib_mr_pool_init(struct ib_qp *qp, struct list_head *list, int nr,
-		enum ib_mr_type type, u32 max_num_sg, u32 max_num_meta_sg)
+		    enum ib_mr_type type, u32 max_num_sg, u32 max_num_meta_sg,
+		    u32 access)
 {
 	struct ib_mr *mr;
 	unsigned long flags;
@@ -43,9 +44,9 @@ int ib_mr_pool_init(struct ib_qp *qp, struct list_head *list, int nr,
 	for (i = 0; i < nr; i++) {
 		if (type == IB_MR_TYPE_INTEGRITY)
 			mr = ib_alloc_mr_integrity(qp->pd, max_num_sg,
-						   max_num_meta_sg);
+						   max_num_meta_sg, access);
 		else
-			mr = ib_alloc_mr(qp->pd, type, max_num_sg);
+			mr = ib_alloc_mr(qp->pd, type, max_num_sg, access);
 		if (IS_ERR(mr)) {
 			ret = PTR_ERR(mr);
 			goto out;
diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index a588c2038479..d5a0038e82a4 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -110,7 +110,7 @@ static int rdma_rw_init_one_mr(struct ib_qp *qp, u32 port_num,
 
 	reg->reg_wr.wr.opcode = IB_WR_REG_MR;
 	reg->reg_wr.mr = reg->mr;
-	reg->reg_wr.access = IB_ACCESS_LOCAL_WRITE;
+	reg->reg_wr.access = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_RELAXED_ORDERING;
 	if (rdma_protocol_iwarp(qp->device, port_num))
 		reg->reg_wr.access |= IB_ACCESS_REMOTE_WRITE;
 	count++;
@@ -437,7 +437,8 @@ int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 	ctx->reg->reg_wr.wr.wr_cqe = NULL;
 	ctx->reg->reg_wr.wr.num_sge = 0;
 	ctx->reg->reg_wr.wr.send_flags = 0;
-	ctx->reg->reg_wr.access = IB_ACCESS_LOCAL_WRITE;
+	ctx->reg->reg_wr.access =
+		IB_ACCESS_LOCAL_WRITE | IB_ACCESS_RELAXED_ORDERING;
 	if (rdma_protocol_iwarp(qp->device, port_num))
 		ctx->reg->reg_wr.access |= IB_ACCESS_REMOTE_WRITE;
 	ctx->reg->reg_wr.mr = ctx->reg->mr;
@@ -711,8 +712,8 @@ int rdma_rw_init_mrs(struct ib_qp *qp, struct ib_qp_init_attr *attr)
 
 	if (nr_mrs) {
 		ret = ib_mr_pool_init(qp, &qp->rdma_mrs, nr_mrs,
-				IB_MR_TYPE_MEM_REG,
-				max_num_sg, 0);
+				      IB_MR_TYPE_MEM_REG, max_num_sg, 0,
+				      IB_ACCESS_RELAXED_ORDERING);
 		if (ret) {
 			pr_err("%s: failed to allocated %d MRs\n",
 				__func__, nr_mrs);
@@ -722,7 +723,8 @@ int rdma_rw_init_mrs(struct ib_qp *qp, struct ib_qp_init_attr *attr)
 
 	if (nr_sig_mrs) {
 		ret = ib_mr_pool_init(qp, &qp->sig_mrs, nr_sig_mrs,
-				IB_MR_TYPE_INTEGRITY, max_num_sg, max_num_sg);
+				      IB_MR_TYPE_INTEGRITY, max_num_sg,
+				      max_num_sg, IB_ACCESS_RELAXED_ORDERING);
 		if (ret) {
 			pr_err("%s: failed to allocated %d SIG MRs\n",
 				__func__, nr_sig_mrs);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index c576e2bc39c6..a1782f8a6ca0 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2136,6 +2136,7 @@ EXPORT_SYMBOL(ib_dereg_mr_user);
  * @pd:            protection domain associated with the region
  * @mr_type:       memory region type
  * @max_num_sg:    maximum sg entries available for registration.
+ * @access:	   access flags for the memory region.
  *
  * Notes:
  * Memory registeration page/sg lists must not exceed max_num_sg.
@@ -2144,7 +2145,7 @@ EXPORT_SYMBOL(ib_dereg_mr_user);
  *
  */
 struct ib_mr *ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			  u32 max_num_sg)
+			  u32 max_num_sg, u32 access)
 {
 	struct ib_mr *mr;
 
@@ -2159,7 +2160,12 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
 		goto out;
 	}
 
-	mr = pd->device->ops.alloc_mr(pd, mr_type, max_num_sg);
+	if (access & ~IB_ACCESS_RELAXED_ORDERING) {
+		mr = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	mr = pd->device->ops.alloc_mr(pd, mr_type, max_num_sg, access);
 	if (IS_ERR(mr))
 		goto out;
 
@@ -2187,15 +2193,15 @@ EXPORT_SYMBOL(ib_alloc_mr);
  * @max_num_data_sg:         maximum data sg entries available for registration
  * @max_num_meta_sg:         maximum metadata sg entries available for
  *                           registration
+ * @access:		     access flags for the memory region.
  *
  * Notes:
  * Memory registration page/sg lists must not exceed max_num_sg,
  * also the integrity page/sg lists must not exceed max_num_meta_sg.
  *
  */
-struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
-				    u32 max_num_data_sg,
-				    u32 max_num_meta_sg)
+struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd, u32 max_num_data_sg,
+				    u32 max_num_meta_sg, u32 access)
 {
 	struct ib_mr *mr;
 	struct ib_sig_attrs *sig_attrs;
@@ -2211,6 +2217,11 @@ struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
 		goto out;
 	}
 
+	if (access & ~IB_ACCESS_RELAXED_ORDERING) {
+		mr = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
 	sig_attrs = kzalloc(sizeof(struct ib_sig_attrs), GFP_KERNEL);
 	if (!sig_attrs) {
 		mr = ERR_PTR(-ENOMEM);
@@ -2218,7 +2229,7 @@ struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
 	}
 
 	mr = pd->device->ops.alloc_mr_integrity(pd, max_num_data_sg,
-						max_num_meta_sg);
+						max_num_meta_sg, access);
 	if (IS_ERR(mr)) {
 		kfree(sig_attrs);
 		goto out;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 2efaa80bfbd2..116febdf999b 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3672,7 +3672,7 @@ int bnxt_re_map_mr_sg(struct ib_mr *ib_mr, struct scatterlist *sg, int sg_nents,
 }
 
 struct ib_mr *bnxt_re_alloc_mr(struct ib_pd *ib_pd, enum ib_mr_type type,
-			       u32 max_num_sg)
+			       u32 max_num_sg, u32 access)
 {
 	struct bnxt_re_pd *pd = container_of(ib_pd, struct bnxt_re_pd, ib_pd);
 	struct bnxt_re_dev *rdev = pd->rdev;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index d68671cc6173..3e8342a6f367 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -201,7 +201,7 @@ struct ib_mr *bnxt_re_get_dma_mr(struct ib_pd *pd, int mr_access_flags);
 int bnxt_re_map_mr_sg(struct ib_mr *ib_mr, struct scatterlist *sg, int sg_nents,
 		      unsigned int *sg_offset);
 struct ib_mr *bnxt_re_alloc_mr(struct ib_pd *ib_pd, enum ib_mr_type mr_type,
-			       u32 max_num_sg);
+			       u32 max_num_sg, u32 access);
 int bnxt_re_dereg_mr(struct ib_mr *mr, struct ib_udata *udata);
 struct ib_mw *bnxt_re_alloc_mw(struct ib_pd *ib_pd, enum ib_mw_type type,
 			       struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index cdec5deb37a1..4520c53aa1f6 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -969,7 +969,7 @@ int c4iw_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len);
 void c4iw_qp_add_ref(struct ib_qp *qp);
 void c4iw_qp_rem_ref(struct ib_qp *qp);
 struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			    u32 max_num_sg);
+			    u32 max_num_sg, u32 access);
 int c4iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 		   unsigned int *sg_offset);
 void c4iw_dealloc(struct uld_ctx *ctx);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index a2c71a1d93d5..c8ed4c56925d 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -596,7 +596,7 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 }
 
 struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			    u32 max_num_sg)
+			    u32 max_num_sg, u32 access)
 {
 	struct c4iw_dev *rhp;
 	struct c4iw_pd *php;
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 55cbbd524057..3e2aed7e8329 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -1205,7 +1205,7 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *mr, int flags, u64 start,
 				     int mr_access_flags, struct ib_pd *pd,
 				     struct ib_udata *udata);
 struct ib_mr *hns_roce_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-				u32 max_num_sg);
+				u32 max_num_sg, u32 access);
 int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 		       unsigned int *sg_offset);
 int hns_roce_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 79b3c3023fe7..c16638ad66f4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -381,7 +381,7 @@ int hns_roce_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 }
 
 struct ib_mr *hns_roce_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-				u32 max_num_sg)
+				u32 max_num_sg, u32 access)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(pd->device);
 	struct device *dev = hr_dev->dev;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index b876d722fcc8..827dbca3ddf3 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1451,9 +1451,10 @@ static int i40iw_hw_alloc_stag(struct i40iw_device *iwdev, struct i40iw_mr *iwmr
  * @pd: ibpd pointer
  * @mr_type: memory for stag registrion
  * @max_num_sg: man number of pages
+ * @access: access flags of memory region
  */
 static struct ib_mr *i40iw_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-				    u32 max_num_sg)
+				    u32 max_num_sg, u32 access)
 {
 	struct i40iw_pd *iwpd = to_iwpd(pd);
 	struct i40iw_device *iwdev = to_iwdev(pd->device);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index e856cf23a0a1..0c99dd57de3f 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -759,7 +759,7 @@ int mlx4_ib_dereg_mr(struct ib_mr *mr, struct ib_udata *udata);
 int mlx4_ib_alloc_mw(struct ib_mw *mw, struct ib_udata *udata);
 int mlx4_ib_dealloc_mw(struct ib_mw *mw);
 struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			       u32 max_num_sg);
+			       u32 max_num_sg, u32 access);
 int mlx4_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 		      unsigned int *sg_offset);
 int mlx4_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 50becc0e4b62..5a6fc7d7a89f 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -643,7 +643,7 @@ int mlx4_ib_dealloc_mw(struct ib_mw *ibmw)
 }
 
 struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			       u32 max_num_sg)
+			       u32 max_num_sg, u32 access)
 {
 	struct mlx4_ib_dev *dev = to_mdev(pd->device);
 	struct mlx4_ib_mr *mr;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 69ecd0229322..0a8b33244fdd 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -670,6 +670,9 @@ struct mlx5_ib_mr {
 	struct mlx5_cache_ent *cache_ent;
 	struct ib_umem *umem;
 
+	/* Current access_flags */
+	int access_flags;
+
 	/* This is zero'd when the MR is allocated */
 	union {
 		/* Used only while the MR is in the cache */
@@ -705,8 +708,6 @@ struct mlx5_ib_mr {
 		/* Used only by User MRs (umem != NULL) */
 		struct {
 			unsigned int page_shift;
-			/* Current access_flags */
-			int access_flags;
 
 			/* For User ODP */
 			struct mlx5_ib_mr *parent;
@@ -1306,10 +1307,9 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 				    struct ib_pd *pd, struct ib_udata *udata);
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata);
 struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			       u32 max_num_sg);
-struct ib_mr *mlx5_ib_alloc_mr_integrity(struct ib_pd *pd,
-					 u32 max_num_sg,
-					 u32 max_num_meta_sg);
+			       u32 max_num_sg, u32 access);
+struct ib_mr *mlx5_ib_alloc_mr_integrity(struct ib_pd *pd, u32 max_num_sg,
+					 u32 max_num_meta_sg, u32 access);
 int mlx5_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 		      unsigned int *sg_offset);
 int mlx5_ib_map_mr_sg_pi(struct ib_mr *ibmr, struct scatterlist *data_sg,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 552fecd210c2..9ba7d5d6c668 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -2015,14 +2015,14 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 }
 
 static void mlx5_set_umr_free_mkey(struct ib_pd *pd, u32 *in, int ndescs,
-				   int access_mode, int page_shift)
+				   int access_mode, u32 access, int page_shift)
 {
 	void *mkc;
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 
 	/* This is only used from the kernel, so setting the PD is OK. */
-	set_mkc_access_pd_addr_fields(mkc, 0, 0, pd);
+	set_mkc_access_pd_addr_fields(mkc, access, 0, pd);
 	MLX5_SET(mkc, mkc, free, 1);
 	MLX5_SET(mkc, mkc, translations_octword_size, ndescs);
 	MLX5_SET(mkc, mkc, access_mode_1_0, access_mode & 0x3);
@@ -2033,7 +2033,8 @@ static void mlx5_set_umr_free_mkey(struct ib_pd *pd, u32 *in, int ndescs,
 
 static int _mlx5_alloc_mkey_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 				  int ndescs, int desc_size, int page_shift,
-				  int access_mode, u32 *in, int inlen)
+				  int access_mode, u32 access, u32 *in,
+				  int inlen)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	int err;
@@ -2046,7 +2047,7 @@ static int _mlx5_alloc_mkey_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 	if (err)
 		return err;
 
-	mlx5_set_umr_free_mkey(pd, in, ndescs, access_mode, page_shift);
+	mlx5_set_umr_free_mkey(pd, in, ndescs, access_mode, access, page_shift);
 
 	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
 	if (err)
@@ -2055,6 +2056,7 @@ static int _mlx5_alloc_mkey_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 	mr->mmkey.type = MLX5_MKEY_MR;
 	mr->ibmr.lkey = mr->mmkey.key;
 	mr->ibmr.rkey = mr->mmkey.key;
+	mr->access_flags = access;
 
 	return 0;
 
@@ -2063,9 +2065,10 @@ static int _mlx5_alloc_mkey_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 	return err;
 }
 
-static struct mlx5_ib_mr *mlx5_ib_alloc_pi_mr(struct ib_pd *pd,
-				u32 max_num_sg, u32 max_num_meta_sg,
-				int desc_size, int access_mode)
+static struct mlx5_ib_mr *mlx5_ib_alloc_pi_mr(struct ib_pd *pd, u32 max_num_sg,
+					      u32 max_num_meta_sg,
+					      int desc_size, int access_mode,
+					      u32 access)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	int ndescs = ALIGN(max_num_sg + max_num_meta_sg, 4);
@@ -2091,7 +2094,7 @@ static struct mlx5_ib_mr *mlx5_ib_alloc_pi_mr(struct ib_pd *pd,
 		page_shift = PAGE_SHIFT;
 
 	err = _mlx5_alloc_mkey_descs(pd, mr, ndescs, desc_size, page_shift,
-				     access_mode, in, inlen);
+				     access_mode, access, in, inlen);
 	if (err)
 		goto err_free_in;
 
@@ -2108,23 +2111,24 @@ static struct mlx5_ib_mr *mlx5_ib_alloc_pi_mr(struct ib_pd *pd,
 }
 
 static int mlx5_alloc_mem_reg_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
-				    int ndescs, u32 *in, int inlen)
+				    int ndescs, u32 access, u32 *in, int inlen)
 {
 	return _mlx5_alloc_mkey_descs(pd, mr, ndescs, sizeof(struct mlx5_mtt),
-				      PAGE_SHIFT, MLX5_MKC_ACCESS_MODE_MTT, in,
-				      inlen);
+				      PAGE_SHIFT, MLX5_MKC_ACCESS_MODE_MTT,
+				      access, in, inlen);
 }
 
 static int mlx5_alloc_sg_gaps_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
-				    int ndescs, u32 *in, int inlen)
+				    int ndescs, u32 access, u32 *in, int inlen)
 {
 	return _mlx5_alloc_mkey_descs(pd, mr, ndescs, sizeof(struct mlx5_klm),
-				      0, MLX5_MKC_ACCESS_MODE_KLMS, in, inlen);
+				      0, MLX5_MKC_ACCESS_MODE_KLMS, access, in,
+				      inlen);
 }
 
 static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 				      int max_num_sg, int max_num_meta_sg,
-				      u32 *in, int inlen)
+				      u32 access, u32 *in, int inlen)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	u32 psv_index[2];
@@ -2149,14 +2153,14 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 	++mr->sig->sigerr_count;
 	mr->klm_mr = mlx5_ib_alloc_pi_mr(pd, max_num_sg, max_num_meta_sg,
 					 sizeof(struct mlx5_klm),
-					 MLX5_MKC_ACCESS_MODE_KLMS);
+					 MLX5_MKC_ACCESS_MODE_KLMS, access);
 	if (IS_ERR(mr->klm_mr)) {
 		err = PTR_ERR(mr->klm_mr);
 		goto err_destroy_psv;
 	}
 	mr->mtt_mr = mlx5_ib_alloc_pi_mr(pd, max_num_sg, max_num_meta_sg,
 					 sizeof(struct mlx5_mtt),
-					 MLX5_MKC_ACCESS_MODE_MTT);
+					 MLX5_MKC_ACCESS_MODE_MTT, access);
 	if (IS_ERR(mr->mtt_mr)) {
 		err = PTR_ERR(mr->mtt_mr);
 		goto err_free_klm_mr;
@@ -2168,7 +2172,8 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 	MLX5_SET(mkc, mkc, bsf_octword_size, MLX5_MKEY_BSF_OCTO_SIZE);
 
 	err = _mlx5_alloc_mkey_descs(pd, mr, 4, sizeof(struct mlx5_klm), 0,
-				     MLX5_MKC_ACCESS_MODE_KLMS, in, inlen);
+				     MLX5_MKC_ACCESS_MODE_KLMS, access, in,
+				     inlen);
 	if (err)
 		goto err_free_mtt_mr;
 
@@ -2202,7 +2207,7 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 
 static struct ib_mr *__mlx5_ib_alloc_mr(struct ib_pd *pd,
 					enum ib_mr_type mr_type, u32 max_num_sg,
-					u32 max_num_meta_sg)
+					u32 max_num_meta_sg, u32 access)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
@@ -2226,14 +2231,16 @@ static struct ib_mr *__mlx5_ib_alloc_mr(struct ib_pd *pd,
 
 	switch (mr_type) {
 	case IB_MR_TYPE_MEM_REG:
-		err = mlx5_alloc_mem_reg_descs(pd, mr, ndescs, in, inlen);
+		err = mlx5_alloc_mem_reg_descs(pd, mr, ndescs, access, in,
+					       inlen);
 		break;
 	case IB_MR_TYPE_SG_GAPS:
-		err = mlx5_alloc_sg_gaps_descs(pd, mr, ndescs, in, inlen);
+		err = mlx5_alloc_sg_gaps_descs(pd, mr, ndescs, access, in,
+					       inlen);
 		break;
 	case IB_MR_TYPE_INTEGRITY:
-		err = mlx5_alloc_integrity_descs(pd, mr, max_num_sg,
-						 max_num_meta_sg, in, inlen);
+		err = mlx5_alloc_integrity_descs(
+			pd, mr, max_num_sg, max_num_meta_sg, access, in, inlen);
 		break;
 	default:
 		mlx5_ib_warn(dev, "Invalid mr type %d\n", mr_type);
@@ -2255,16 +2262,16 @@ static struct ib_mr *__mlx5_ib_alloc_mr(struct ib_pd *pd,
 }
 
 struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			       u32 max_num_sg)
+			       u32 max_num_sg, u32 access)
 {
-	return __mlx5_ib_alloc_mr(pd, mr_type, max_num_sg, 0);
+	return __mlx5_ib_alloc_mr(pd, mr_type, max_num_sg, 0, access);
 }
 
-struct ib_mr *mlx5_ib_alloc_mr_integrity(struct ib_pd *pd,
-					 u32 max_num_sg, u32 max_num_meta_sg)
+struct ib_mr *mlx5_ib_alloc_mr_integrity(struct ib_pd *pd, u32 max_num_sg,
+					 u32 max_num_meta_sg, u32 access)
 {
 	return __mlx5_ib_alloc_mr(pd, IB_MR_TYPE_INTEGRITY, max_num_sg,
-				  max_num_meta_sg);
+				  max_num_meta_sg, access);
 }
 
 int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index cf2852cba45c..a1b6d0ff8461 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -171,7 +171,8 @@ static u64 get_xlt_octo(u64 bytes)
 	       MLX5_IB_UMR_OCTOWORD;
 }
 
-static __be64 frwr_mkey_mask(bool atomic)
+static __be64 frwr_mkey_mask(bool atomic, int relaxed_ordering_write,
+			     int relaxed_ordering_read)
 {
 	u64 result;
 
@@ -190,10 +191,17 @@ static __be64 frwr_mkey_mask(bool atomic)
 	if (atomic)
 		result |= MLX5_MKEY_MASK_A;
 
+	if (relaxed_ordering_write)
+		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE;
+
+	if (relaxed_ordering_read)
+		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_READ;
+
 	return cpu_to_be64(result);
 }
 
-static __be64 sig_mkey_mask(void)
+static __be64 sig_mkey_mask(int relaxed_ordering_write,
+			    int relaxed_ordering_read)
 {
 	u64 result;
 
@@ -211,10 +219,17 @@ static __be64 sig_mkey_mask(void)
 		MLX5_MKEY_MASK_FREE		|
 		MLX5_MKEY_MASK_BSF_EN;
 
+	if (relaxed_ordering_write)
+		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE;
+
+	if (relaxed_ordering_read)
+		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_READ;
+
 	return cpu_to_be64(result);
 }
 
-static void set_reg_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr,
+static void set_reg_umr_seg(struct mlx5_ib_dev *dev,
+			    struct mlx5_wqe_umr_ctrl_seg *umr,
 			    struct mlx5_ib_mr *mr, u8 flags, bool atomic)
 {
 	int size = (mr->ndescs + mr->meta_ndescs) * mr->desc_size;
@@ -223,7 +238,9 @@ static void set_reg_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr,
 
 	umr->flags = flags;
 	umr->xlt_octowords = cpu_to_be16(get_xlt_octo(size));
-	umr->mkey_mask = frwr_mkey_mask(atomic);
+	umr->mkey_mask = frwr_mkey_mask(
+		atomic, MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr),
+		MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr));
 }
 
 static void set_linv_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr)
@@ -370,9 +387,8 @@ static u8 get_umr_flags(int acc)
 		MLX5_PERM_LOCAL_READ | MLX5_PERM_UMR_EN;
 }
 
-static void set_reg_mkey_seg(struct mlx5_mkey_seg *seg,
-			     struct mlx5_ib_mr *mr,
-			     u32 key, int access)
+static void set_reg_mkey_seg(struct mlx5_ib_dev *dev, struct mlx5_mkey_seg *seg,
+			     struct mlx5_ib_mr *mr, u32 key, int access)
 {
 	int ndescs = ALIGN(mr->ndescs + mr->meta_ndescs, 8) >> 1;
 
@@ -390,6 +406,13 @@ static void set_reg_mkey_seg(struct mlx5_mkey_seg *seg,
 	seg->start_addr = cpu_to_be64(mr->ibmr.iova);
 	seg->len = cpu_to_be64(mr->ibmr.length);
 	seg->xlt_oct_size = cpu_to_be32(ndescs);
+
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr) &&
+	    (access & IB_ACCESS_RELAXED_ORDERING))
+		MLX5_SET(mkc, seg, relaxed_ordering_write, 1);
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr) &&
+	    (access & IB_ACCESS_RELAXED_ORDERING))
+		MLX5_SET(mkc, seg, relaxed_ordering_read, 1);
 }
 
 static void set_linv_mkey_seg(struct mlx5_mkey_seg *seg)
@@ -746,7 +769,8 @@ static int set_sig_data_segment(const struct ib_send_wr *send_wr,
 	return 0;
 }
 
-static void set_sig_mkey_segment(struct mlx5_mkey_seg *seg,
+static void set_sig_mkey_segment(struct mlx5_ib_dev *dev,
+				 struct mlx5_mkey_seg *seg,
 				 struct ib_mr *sig_mr, int access_flags,
 				 u32 size, u32 length, u32 pdn)
 {
@@ -762,23 +786,34 @@ static void set_sig_mkey_segment(struct mlx5_mkey_seg *seg,
 	seg->len = cpu_to_be64(length);
 	seg->xlt_oct_size = cpu_to_be32(get_xlt_octo(size));
 	seg->bsfs_octo_size = cpu_to_be32(MLX5_MKEY_BSF_OCTO_SIZE);
+
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr) &&
+	    (access_flags & IB_ACCESS_RELAXED_ORDERING))
+		MLX5_SET(mkc, seg, relaxed_ordering_write, 1);
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr) &&
+	    (access_flags & IB_ACCESS_RELAXED_ORDERING))
+		MLX5_SET(mkc, seg, relaxed_ordering_read, 1);
 }
 
-static void set_sig_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
-				u32 size)
+static void set_sig_umr_segment(struct mlx5_ib_dev *dev,
+				struct mlx5_wqe_umr_ctrl_seg *umr, u32 size)
 {
 	memset(umr, 0, sizeof(*umr));
 
 	umr->flags = MLX5_FLAGS_INLINE | MLX5_FLAGS_CHECK_FREE;
 	umr->xlt_octowords = cpu_to_be16(get_xlt_octo(size));
 	umr->bsf_octowords = cpu_to_be16(MLX5_MKEY_BSF_OCTO_SIZE);
-	umr->mkey_mask = sig_mkey_mask();
+	umr->mkey_mask = sig_mkey_mask(
+		MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr),
+		MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr));
 }
 
 static int set_pi_umr_wr(const struct ib_send_wr *send_wr,
 			 struct mlx5_ib_qp *qp, void **seg, int *size,
 			 void **cur_edge)
 {
+	struct mlx5_ib_pd *pd = to_mpd(qp->ibqp.pd);
+	struct mlx5_ib_dev *dev = to_mdev(pd->ibpd.device);
 	const struct ib_reg_wr *wr = reg_wr(send_wr);
 	struct mlx5_ib_mr *sig_mr = to_mmr(wr->mr);
 	struct mlx5_ib_mr *pi_mr = sig_mr->pi_mr;
@@ -806,13 +841,13 @@ static int set_pi_umr_wr(const struct ib_send_wr *send_wr,
 	else
 		xlt_size = sizeof(struct mlx5_klm);
 
-	set_sig_umr_segment(*seg, xlt_size);
+	set_sig_umr_segment(dev, *seg, xlt_size);
 	*seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
 	*size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;
 	handle_post_send_edge(&qp->sq, seg, *size, cur_edge);
 
-	set_sig_mkey_segment(*seg, wr->mr, wr->access, xlt_size, region_len,
-			     pdn);
+	set_sig_mkey_segment(dev, *seg, wr->mr, wr->access, xlt_size,
+			     region_len, pdn);
 	*seg += sizeof(struct mlx5_mkey_seg);
 	*size += sizeof(struct mlx5_mkey_seg) / 16;
 	handle_post_send_edge(&qp->sq, seg, *size, cur_edge);
@@ -867,7 +902,7 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	u8 flags = 0;
 
 	/* Matches access in mlx5_set_umr_free_mkey() */
-	if (!mlx5_ib_can_reconfig_with_umr(dev, 0, wr->access)) {
+	if (!mlx5_ib_can_reconfig_with_umr(dev, mr->access_flags, wr->access)) {
 		mlx5_ib_warn(
 			to_mdev(qp->ibqp.device),
 			"Fast update for MR access flags is not possible\n");
@@ -885,12 +920,12 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	if (umr_inline)
 		flags |= MLX5_UMR_INLINE;
 
-	set_reg_umr_seg(*seg, mr, flags, atomic);
+	set_reg_umr_seg(dev, *seg, mr, flags, atomic);
 	*seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
 	*size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;
 	handle_post_send_edge(&qp->sq, seg, *size, cur_edge);
 
-	set_reg_mkey_seg(*seg, mr, wr->key, wr->access);
+	set_reg_mkey_seg(dev, *seg, mr, wr->key, wr->access);
 	*seg += sizeof(struct mlx5_mkey_seg);
 	*size += sizeof(struct mlx5_mkey_seg) / 16;
 	handle_post_send_edge(&qp->sq, seg, *size, cur_edge);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 58619ce64d0d..419711552825 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2904,7 +2904,7 @@ int ocrdma_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags cq_flags)
 }
 
 struct ib_mr *ocrdma_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
-			      u32 max_num_sg)
+			      u32 max_num_sg, u32 access)
 {
 	int status;
 	struct ocrdma_mr *mr;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index b1c5fad81603..7644e343fcd6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -102,7 +102,7 @@ struct ib_mr *ocrdma_get_dma_mr(struct ib_pd *, int acc);
 struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *, u64 start, u64 length,
 				 u64 virt, int acc, struct ib_udata *);
 struct ib_mr *ocrdma_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			      u32 max_num_sg);
+			      u32 max_num_sg, u32 access);
 int ocrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 		     unsigned int *sg_offset);
 
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 41e12f011f22..51fa57b97928 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -3132,7 +3132,7 @@ static struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd,
 }
 
 struct ib_mr *qedr_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
-			    u32 max_num_sg)
+			    u32 max_num_sg, u32 access)
 {
 	struct qedr_mr *mr;
 
diff --git a/drivers/infiniband/hw/qedr/verbs.h b/drivers/infiniband/hw/qedr/verbs.h
index 34ad47515861..8ea872b56ee0 100644
--- a/drivers/infiniband/hw/qedr/verbs.h
+++ b/drivers/infiniband/hw/qedr/verbs.h
@@ -86,7 +86,7 @@ int qedr_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		   int sg_nents, unsigned int *sg_offset);
 
 struct ib_mr *qedr_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			    u32 max_num_sg);
+			    u32 max_num_sg, u32 access);
 int qedr_poll_cq(struct ib_cq *, int num_entries, struct ib_wc *wc);
 int qedr_post_send(struct ib_qp *, const struct ib_send_wr *,
 		   const struct ib_send_wr **bad_wr);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
index e80848bfb3bd..b3fa783698a0 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
@@ -198,11 +198,12 @@ struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
  * @pd: protection domain
  * @mr_type: type of memory region
  * @max_num_sg: maximum number of pages
+ * @access: access flags of memory region
  *
  * @return: ib_mr pointer on success, otherwise returns an errno.
  */
 struct ib_mr *pvrdma_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			      u32 max_num_sg)
+			      u32 max_num_sg, u32 access)
 {
 	struct pvrdma_dev *dev = to_vdev(pd->device);
 	struct pvrdma_user_mr *mr;
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
index 544b94d97c3a..079fb4c09979 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
@@ -371,7 +371,7 @@ struct ib_mr *pvrdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				 struct ib_udata *udata);
 int pvrdma_dereg_mr(struct ib_mr *mr, struct ib_udata *udata);
 struct ib_mr *pvrdma_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			      u32 max_num_sg);
+			      u32 max_num_sg, u32 access);
 int pvrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		     int sg_nents, unsigned int *sg_offset);
 int pvrdma_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 601d18dda1f5..b484a7968681 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -571,11 +571,12 @@ int rvt_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
  * @pd: protection domain for this memory region
  * @mr_type: mem region type
  * @max_num_sg: Max number of segments allowed
+ * @access: access flags of memory region
  *
  * Return: the memory region on success, otherwise return an errno.
  */
 struct ib_mr *rvt_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			   u32 max_num_sg)
+			   u32 max_num_sg, u32 access)
 {
 	struct rvt_mr *mr;
 
diff --git a/drivers/infiniband/sw/rdmavt/mr.h b/drivers/infiniband/sw/rdmavt/mr.h
index b3aba359401b..0542b2c6dbfc 100644
--- a/drivers/infiniband/sw/rdmavt/mr.h
+++ b/drivers/infiniband/sw/rdmavt/mr.h
@@ -71,7 +71,7 @@ struct ib_mr *rvt_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			      struct ib_udata *udata);
 int rvt_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata);
 struct ib_mr *rvt_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			   u32 max_num_sg);
+			   u32 max_num_sg, u32 access);
 int rvt_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		  int sg_nents, unsigned int *sg_offset);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index aeb5e232c195..6a23f54c88a6 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -925,7 +925,7 @@ static int rxe_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 }
 
 static struct ib_mr *rxe_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
-				  u32 max_num_sg)
+				  u32 max_num_sg, u32 access)
 {
 	struct rxe_dev *rxe = to_rdev(ibpd->device);
 	struct rxe_pd *pd = to_rpd(ibpd);
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index d2313efb26db..a9ea13cd67bd 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -1383,7 +1383,7 @@ struct ib_mr *siw_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 }
 
 struct ib_mr *siw_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			   u32 max_sge)
+			   u32 max_sge, u32 access)
 {
 	struct siw_device *sdev = to_siw_dev(pd->device);
 	struct siw_mr *mr = NULL;
diff --git a/drivers/infiniband/sw/siw/siw_verbs.h b/drivers/infiniband/sw/siw/siw_verbs.h
index 67ac08886a70..817f72cd242a 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.h
+++ b/drivers/infiniband/sw/siw/siw_verbs.h
@@ -68,7 +68,7 @@ int siw_req_notify_cq(struct ib_cq *base_cq, enum ib_cq_notify_flags flags);
 struct ib_mr *siw_reg_user_mr(struct ib_pd *base_pd, u64 start, u64 len,
 			      u64 rnic_va, int rights, struct ib_udata *udata);
 struct ib_mr *siw_alloc_mr(struct ib_pd *base_pd, enum ib_mr_type mr_type,
-			   u32 max_sge);
+			   u32 max_sge, u32 access);
 struct ib_mr *siw_get_dma_mr(struct ib_pd *base_pd, int rights);
 int siw_map_mr_sg(struct ib_mr *base_mr, struct scatterlist *sl, int num_sle,
 		  unsigned int *sg_off);
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 136f6c4492e0..3c370ee25f2f 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -121,7 +121,7 @@ iser_create_fastreg_desc(struct iser_device *device,
 	else
 		mr_type = IB_MR_TYPE_MEM_REG;
 
-	desc->rsc.mr = ib_alloc_mr(pd, mr_type, size);
+	desc->rsc.mr = ib_alloc_mr(pd, mr_type, size, 0);
 	if (IS_ERR(desc->rsc.mr)) {
 		ret = PTR_ERR(desc->rsc.mr);
 		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
@@ -129,7 +129,7 @@ iser_create_fastreg_desc(struct iser_device *device,
 	}
 
 	if (pi_enable) {
-		desc->rsc.sig_mr = ib_alloc_mr_integrity(pd, size, size);
+		desc->rsc.sig_mr = ib_alloc_mr_integrity(pd, size, size, 0);
 		if (IS_ERR(desc->rsc.sig_mr)) {
 			ret = PTR_ERR(desc->rsc.sig_mr);
 			iser_err("Failed to allocate sig_mr err=%d\n", ret);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 64990df81937..0d3960ed5b2b 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1260,7 +1260,7 @@ static int alloc_sess_reqs(struct rtrs_clt_sess *sess)
 			goto out;
 
 		req->mr = ib_alloc_mr(sess->s.dev->ib_pd, IB_MR_TYPE_MEM_REG,
-				      sess->max_pages_per_mr);
+				      sess->max_pages_per_mr, 0);
 		if (IS_ERR(req->mr)) {
 			err = PTR_ERR(req->mr);
 			req->mr = NULL;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 5e9bb7bf5ef3..575f31ff20fd 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -638,7 +638,7 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 			goto free_sg;
 		}
 		mr = ib_alloc_mr(sess->s.dev->ib_pd, IB_MR_TYPE_MEM_REG,
-				 sgt->nents);
+				 sgt->nents, 0);
 		if (IS_ERR(mr)) {
 			err = PTR_ERR(mr);
 			goto unmap_sg;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 31f8aa2c40ed..8481ad769ba4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -436,7 +436,7 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
 		mr_type = IB_MR_TYPE_MEM_REG;
 
 	for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
-		mr = ib_alloc_mr(pd, mr_type, max_page_list_len);
+		mr = ib_alloc_mr(pd, mr_type, max_page_list_len, 0);
 		if (IS_ERR(mr)) {
 			ret = PTR_ERR(mr);
 			if (ret == -ENOMEM)
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 53ac4d7442ba..4dbc17311e0b 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -534,7 +534,7 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 	ret = ib_mr_pool_init(queue->qp, &queue->qp->rdma_mrs,
 			      queue->queue_size,
 			      IB_MR_TYPE_MEM_REG,
-			      pages_per_mr, 0);
+			      pages_per_mr, 0, 0);
 	if (ret) {
 		dev_err(queue->ctrl->ctrl.device,
 			"failed to initialize MR pool sized %d for QID %d\n",
@@ -545,7 +545,7 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 	if (queue->pi_support) {
 		ret = ib_mr_pool_init(queue->qp, &queue->qp->sig_mrs,
 				      queue->queue_size, IB_MR_TYPE_INTEGRITY,
-				      pages_per_mr, pages_per_mr);
+				      pages_per_mr, pages_per_mr, 0);
 		if (ret) {
 			dev_err(queue->ctrl->ctrl.device,
 				"failed to initialize PI MR pool sized %d for QID %d\n",
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 10dfe5006792..647098a5cf3b 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2178,9 +2178,8 @@ static void smbd_mr_recovery_work(struct work_struct *work)
 				continue;
 			}
 
-			smbdirect_mr->mr = ib_alloc_mr(
-				info->pd, info->mr_type,
-				info->max_frmr_depth);
+			smbdirect_mr->mr = ib_alloc_mr(info->pd, info->mr_type,
+						       info->max_frmr_depth, 0);
 			if (IS_ERR(smbdirect_mr->mr)) {
 				log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
 					    info->mr_type,
@@ -2245,7 +2244,7 @@ static int allocate_mr_list(struct smbd_connection *info)
 		if (!smbdirect_mr)
 			goto out;
 		smbdirect_mr->mr = ib_alloc_mr(info->pd, info->mr_type,
-					info->max_frmr_depth);
+					       info->max_frmr_depth, 0);
 		if (IS_ERR(smbdirect_mr->mr)) {
 			log_rdma_mr(ERR, "ib_alloc_mr failed mr_type=%x max_frmr_depth=%x\n",
 				    info->mr_type, info->max_frmr_depth);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bed4cfe50554..59138174affa 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2444,10 +2444,10 @@ struct ib_device_ops {
 				       struct ib_udata *udata);
 	int (*dereg_mr)(struct ib_mr *mr, struct ib_udata *udata);
 	struct ib_mr *(*alloc_mr)(struct ib_pd *pd, enum ib_mr_type mr_type,
-				  u32 max_num_sg);
+				  u32 max_num_sg, u32 access);
 	struct ib_mr *(*alloc_mr_integrity)(struct ib_pd *pd,
 					    u32 max_num_data_sg,
-					    u32 max_num_meta_sg);
+					    u32 max_num_meta_sg, u32 access);
 	int (*advise_mr)(struct ib_pd *pd,
 			 enum ib_uverbs_advise_mr_advice advice, u32 flags,
 			 struct ib_sge *sg_list, u32 num_sge,
@@ -4142,11 +4142,10 @@ static inline int ib_dereg_mr(struct ib_mr *mr)
 }
 
 struct ib_mr *ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
-			  u32 max_num_sg);
+			  u32 max_num_sg, u32 access);
 
-struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
-				    u32 max_num_data_sg,
-				    u32 max_num_meta_sg);
+struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd, u32 max_num_data_sg,
+				    u32 max_num_meta_sg, u32 access);
 
 /**
  * ib_update_fast_reg_key - updates the key portion of the fast_reg MR
diff --git a/include/rdma/mr_pool.h b/include/rdma/mr_pool.h
index e77123bcb43b..2a0ee791037d 100644
--- a/include/rdma/mr_pool.h
+++ b/include/rdma/mr_pool.h
@@ -11,7 +11,8 @@ struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct list_head *list);
 void ib_mr_pool_put(struct ib_qp *qp, struct list_head *list, struct ib_mr *mr);
 
 int ib_mr_pool_init(struct ib_qp *qp, struct list_head *list, int nr,
-		enum ib_mr_type type, u32 max_num_sg, u32 max_num_meta_sg);
+		    enum ib_mr_type type, u32 max_num_sg, u32 max_num_meta_sg,
+		    u32 access);
 void ib_mr_pool_destroy(struct ib_qp *qp, struct list_head *list);
 
 #endif /* _RDMA_MR_POOL_H */
diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 9b6ffff72f2d..694eb916319e 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -76,7 +76,7 @@ static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
 
 	frmr = &ibmr->u.frmr;
 	frmr->mr = ib_alloc_mr(rds_ibdev->pd, IB_MR_TYPE_MEM_REG,
-			 pool->max_pages);
+			       pool->max_pages, 0);
 	if (IS_ERR(frmr->mr)) {
 		pr_warn("RDS/IB: %s failed to allocate MR", __func__);
 		err = PTR_ERR(frmr->mr);
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 7d7ba0320d5a..4e91ed3dc265 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -579,7 +579,7 @@ int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
 		return 0; /* already done */
 
 	buf_slot->mr_rx[link_idx] =
-		ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, 1 << buf_slot->order);
+		ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, 1 << buf_slot->order, 0);
 	if (IS_ERR(buf_slot->mr_rx[link_idx])) {
 		int rc;
 
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 766a1048a48a..cfbdd197cdfe 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -135,7 +135,7 @@ int frwr_mr_init(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr *mr)
 	struct ib_mr *frmr;
 	int rc;
 
-	frmr = ib_alloc_mr(ep->re_pd, ep->re_mrtype, depth);
+	frmr = ib_alloc_mr(ep->re_pd, ep->re_mrtype, depth, 0);
 	if (IS_ERR(frmr))
 		goto out_mr_err;
 
-- 
2.30.2

