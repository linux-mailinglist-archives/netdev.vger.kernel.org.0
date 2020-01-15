Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8313C152
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgAOMn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAOMn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:43:58 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43920222C3;
        Wed, 15 Jan 2020 12:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092237;
        bh=WOxWPvT5vCVhiL79Xr9riM1KPDDuufjN5dlnvD9Et4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNMA22cGPdBg7Mvk4m3ZRlk/teFaWQfc1GcAaHM4hfkJqqhWHA/BkYD6C0JHxrqu5
         a/zQCpAr9LMsMNjeRyxYFgRYr1vrFxe7QemXBkmn9GQ5f1G4pU7kdy2Xii/UzbeOMd
         zCSqp6rsqr23cO7oivmwQk/BABbg82NoeYYYShbY=
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
Subject: [PATCH mlx5-next 02/10] IB/core: Introduce ib_reg_user_mr
Date:   Wed, 15 Jan 2020 14:43:32 +0200
Message-Id: <20200115124340.79108-3-leon@kernel.org>
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

Add ib_reg_user_mr() for kernel ULPs to register user MRs.

The common use case that uses this function is a userspace application
that allocates memory for HCA access but the responsibility to register
the memory at the HCA is on an kernel ULP. This ULP that acts as an agent
for the userspace application.

This function is intended to be used without a user context so vendor
drivers need to be aware of calling reg_user_mr() device operation with
udata equal to NULL.

Among all drivers, i40iw is the only driver which relies on presence
of udata, so check udata existence for that driver.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Guy Levi <guyle@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/verbs.c           | 30 +++++++++++++++++++++++
 drivers/infiniband/hw/efa/efa_verbs.c     |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c |  3 +++
 include/rdma/ib_verbs.h                   |  6 +++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 78b27aff2846..23d9911f7365 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1993,6 +1993,36 @@ EXPORT_SYMBOL(ib_resize_cq);

 /* Memory regions */

+struct ib_mr *ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+			     u64 virt_addr, int access_flags)
+{
+	struct ib_mr *mr;
+
+	if (access_flags & IB_ACCESS_ON_DEMAND) {
+		if (!(pd->device->attrs.device_cap_flags &
+		      IB_DEVICE_ON_DEMAND_PAGING)) {
+			pr_debug("ODP support not available\n");
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	mr = pd->device->ops.reg_user_mr(pd, start, length, virt_addr,
+					 access_flags, NULL);
+
+	if (IS_ERR(mr))
+		return mr;
+
+	mr->device = pd->device;
+	mr->pd = pd;
+	mr->dm = NULL;
+	atomic_inc(&pd->usecnt);
+	mr->res.type = RDMA_RESTRACK_MR;
+	rdma_restrack_kadd(&mr->res);
+
+	return mr;
+}
+EXPORT_SYMBOL(ib_reg_user_mr);
+
 int ib_dereg_mr_user(struct ib_mr *mr, struct ib_udata *udata)
 {
 	struct ib_pd *pd = mr->pd;
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 7e05033a650f..74c5ed32c7c5 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1358,7 +1358,7 @@ struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start, u64 length,
 	int inline_size;
 	int err;

-	if (udata->inlen &&
+	if (udata && udata->inlen &&
 	    !ib_is_udata_cleared(udata, 0, sizeof(udata->inlen))) {
 		ibdev_dbg(&dev->ibdev,
 			  "Incompatible ABI params, udata not cleared\n");
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index e75787ddc941..4072cc68aa10 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1758,6 +1758,9 @@ static struct ib_mr *i40iw_reg_user_mr(struct ib_pd *pd,
 	int ret;
 	int pg_shift;

+	if (!udata)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (iwdev->closing)
 		return ERR_PTR(-ENODEV);

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6506df9f31ae..1aeb92609279 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4166,6 +4166,12 @@ static inline void ib_dma_free_coherent(struct ib_device *dev,
 	dma_free_coherent(dev->dma_device, size, cpu_addr, dma_handle);
 }

+/* ib_reg_user_mr - register a memory region for virtual addresses from kernel
+ * space. This function should be called when 'current' is the owning MM.
+ */
+struct ib_mr *ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+			     u64 virt_addr, int mr_access_flags);
+
 /**
  * ib_dereg_mr_user - Deregisters a memory region and removes it from the
  *   HCA translation table.
--
2.20.1

