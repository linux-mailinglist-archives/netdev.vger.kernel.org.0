Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48774189C30
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgCRMnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgCRMnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 08:43:49 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C5520768;
        Wed, 18 Mar 2020 12:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584535427;
        bh=iddU/5ft/10pg+Xr5zE0XMBFuNwqtbvd8ElppRsR3+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F85LsXsnfexgwo67WV+O6TlVa6l1FuHW+D+KXBOYfs+GlFh2BgSeICaGzip7N+xaX
         mSIru3oqMvZ7H3pXQw7tTT34mKC791Ax118FhGXxBtB7xfPspwLNEXOx0+Z49JRINM
         Xam0TnqMqIfRvGBDGd5MBKlmSf/lMxcawiN7GGgE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 4/4] IB/mlx5: Move to fully dynamic UAR mode once user space supports it
Date:   Wed, 18 Mar 2020 14:43:29 +0200
Message-Id: <20200318124329.52111-5-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318124329.52111-1-leon@kernel.org>
References: <20200318124329.52111-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Move to fully dynamic UAR mode once user space supports it.
In this case we prevent any legacy mode of UARs on the allocated context
and prevent redundant allocation of the static ones.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c   |  8 ++++++--
 drivers/infiniband/hw/mlx5/main.c | 13 ++++++++++++-
 drivers/infiniband/hw/mlx5/qp.c   |  6 ++++++
 include/linux/mlx5/driver.h       |  1 +
 include/uapi/rdma/mlx5-abi.h      |  1 +
 5 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index eafedc2f697b..146ba2966744 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -764,10 +764,14 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 	MLX5_SET(cqc, cqc, log_page_size,
 		 page_shift - MLX5_ADAPTER_PAGE_SHIFT);
 
-	if (ucmd.flags & MLX5_IB_CREATE_CQ_FLAGS_UAR_PAGE_INDEX)
+	if (ucmd.flags & MLX5_IB_CREATE_CQ_FLAGS_UAR_PAGE_INDEX) {
 		*index = ucmd.uar_page_index;
-	else
+	} else if (context->bfregi.lib_uar_dyn) {
+		err = -EINVAL;
+		goto err_cqb;
+	} else {
 		*index = context->bfregi.sys_pages[0];
+	}
 
 	if (ucmd.cqe_comp_en == 1) {
 		int mini_cqe_format;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e8787af2d74d..e355e06bf3ac 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1787,6 +1787,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 				     max_cqe_version);
 	u32 dump_fill_mkey;
 	bool lib_uar_4k;
+	bool lib_uar_dyn;
 
 	if (!dev->ib_active)
 		return -EAGAIN;
@@ -1845,8 +1846,14 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 	}
 
 	lib_uar_4k = req.lib_caps & MLX5_LIB_CAP_4K_UAR;
+	lib_uar_dyn = req.lib_caps & MLX5_LIB_CAP_DYN_UAR;
 	bfregi = &context->bfregi;
 
+	if (lib_uar_dyn) {
+		bfregi->lib_uar_dyn = lib_uar_dyn;
+		goto uar_done;
+	}
+
 	/* updates req->total_num_bfregs */
 	err = calc_total_bfregs(dev, lib_uar_4k, &req, bfregi);
 	if (err)
@@ -1873,6 +1880,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 	if (err)
 		goto out_sys_pages;
 
+uar_done:
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX) {
 		err = mlx5_ib_devx_create(dev, true);
 		if (err < 0)
@@ -1894,7 +1902,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 	INIT_LIST_HEAD(&context->db_page_list);
 	mutex_init(&context->db_page_mutex);
 
-	resp.tot_bfregs = req.total_num_bfregs;
+	resp.tot_bfregs = lib_uar_dyn ? 0 : req.total_num_bfregs;
 	resp.num_ports = dev->num_ports;
 
 	if (offsetofend(typeof(resp), cqe_version) <= udata->outlen)
@@ -2142,6 +2150,9 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	int max_valid_idx = dyn_uar ? bfregi->num_sys_pages :
 				bfregi->num_static_sys_pages;
 
+	if (bfregi->lib_uar_dyn)
+		return -EINVAL;
+
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 		return -EINVAL;
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 380ba3321851..319d514a2223 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -697,6 +697,9 @@ static int alloc_bfreg(struct mlx5_ib_dev *dev,
 {
 	int bfregn = -ENOMEM;
 
+	if (bfregi->lib_uar_dyn)
+		return -EINVAL;
+
 	mutex_lock(&bfregi->lock);
 	if (bfregi->ver >= 2) {
 		bfregn = alloc_high_class_bfreg(dev, bfregi);
@@ -768,6 +771,9 @@ int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
 	u32 index_of_sys_page;
 	u32 offset;
 
+	if (bfregi->lib_uar_dyn)
+		return -EINVAL;
+
 	bfregs_per_sys_page = get_uars_per_sys_page(dev, bfregi->lib_uar_4k) *
 				MLX5_NON_FP_BFREGS_PER_UAR;
 	index_of_sys_page = bfregn / bfregs_per_sys_page;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 3f10a9633012..e4ab0eb9d202 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -224,6 +224,7 @@ struct mlx5_bfreg_info {
 	struct mutex		lock;
 	u32			ver;
 	bool			lib_uar_4k;
+	u8			lib_uar_dyn : 1;
 	u32			num_sys_pages;
 	u32			num_static_sys_pages;
 	u32			total_num_bfregs;
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index a65d60b44829..df1cc3641bda 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -79,6 +79,7 @@ struct mlx5_ib_alloc_ucontext_req {
 
 enum mlx5_lib_caps {
 	MLX5_LIB_CAP_4K_UAR	= (__u64)1 << 0,
+	MLX5_LIB_CAP_DYN_UAR	= (__u64)1 << 1,
 };
 
 enum mlx5_ib_alloc_uctx_v2_flags {
-- 
2.24.1

