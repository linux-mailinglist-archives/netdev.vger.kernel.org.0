Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414F513C15F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgAOMoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:44:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAOMoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:44:17 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 210952465A;
        Wed, 15 Jan 2020 12:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092256;
        bh=o8GPlHHvl0y2yljQmzqhbd72Sa5MlrON6CwQ08wV4EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wh1F0TaOXP/0Qc31gDOfg/qS/Q4UKOqBDb1ck/ZQIV1Q/GoSyvgApDWWlK7wGZ8J2
         HSaz1Zv4DX5lTPVwoZrWxumillcQa8NGmvpkKnfHKABihIMn4Qrnut2FoSTpHfYvm6
         KA/WfGx4l2Ws530TstEoADByNb/sl/2SX4Xwq7O4=
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
Subject: [PATCH mlx5-next 07/10] RDMA/mlx5: Fix handling of IOVA != user_va in ODP paths
Date:   Wed, 15 Jan 2020 14:43:37 +0200
Message-Id: <20200115124340.79108-8-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115124340.79108-1-leon@kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

Till recently it was not possible for userspace to specify a different
IOVA, but with the new ibv_reg_mr_iova() library call this can be done.

To compute the user_va we must compute:
  user_va = (iova - iova_start) + user_va_start

while being cautious of overflow and other math problems.

The iova is not reliably stored in the mmkey when the MR is created. Only
the cached creation path (the common one) set it, so it must also be set
when creating uncached MRs.

Fix the weird use of iova when computing the starting page index in the
MR. In the normal case, when iova == umem.address:
  iova & (~(BIT(page_shift) - 1)) ==
  ALIGN_DOWN(umem.address, odp->page_size) ==
  ib_umem_start(odp)

And when iova is different using it in math with a user_va is wrong.

Finally, do not allow an implicit ODP to be created with a non-zero IOVA
as we have no support for that.

Fixes: 7bdf65d411c1 ("IB/mlx5: Handle page faults")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mr.c  |  2 ++
 drivers/infiniband/hw/mlx5/odp.c | 19 +++++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1913e88522ec..6fa0a83c19de 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1249,6 +1249,8 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,

 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && !start &&
 	    length == U64_MAX) {
+		if (virt_addr != start)
+			return ERR_PTR(-EINVAL);
 		if (!(access_flags & IB_ACCESS_ON_DEMAND) ||
 		    !(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 			return ERR_PTR(-EINVAL);
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 879ed9ac0af9..4216814ba871 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -662,11 +662,10 @@ static int pagefault_real_mr(struct mlx5_ib_mr *mr, struct ib_umem_odp *odp,
 	bool downgrade = flags & MLX5_PF_FLAGS_DOWNGRADE;
 	unsigned long current_seq;
 	u64 access_mask;
-	u64 start_idx, page_mask;
+	u64 start_idx;

 	page_shift = odp->page_shift;
-	page_mask = ~(BIT(page_shift) - 1);
-	start_idx = (user_va - (mr->mmkey.iova & page_mask)) >> page_shift;
+	start_idx = (user_va - ib_umem_start(odp)) >> page_shift;
 	access_mask = ODP_READ_ALLOWED_BIT;

 	if (odp->umem.writable && !downgrade)
@@ -805,11 +804,19 @@ static int pagefault_mr(struct mlx5_ib_mr *mr, u64 io_virt, size_t bcnt,
 {
 	struct ib_umem_odp *odp = to_ib_umem_odp(mr->umem);

+	if (unlikely(io_virt < mr->mmkey.iova))
+		return -EFAULT;
+
 	if (!odp->is_implicit_odp) {
-		if (unlikely(io_virt < ib_umem_start(odp) ||
-			     ib_umem_end(odp) - io_virt < bcnt))
+		u64 user_va;
+
+		if (check_add_overflow(io_virt - mr->mmkey.iova,
+				       (u64)odp->umem.address, &user_va))
+			return -EFAULT;
+		if (unlikely(user_va >= ib_umem_end(odp) ||
+			     ib_umem_end(odp) - user_va < bcnt))
 			return -EFAULT;
-		return pagefault_real_mr(mr, odp, io_virt, bcnt, bytes_mapped,
+		return pagefault_real_mr(mr, odp, user_va, bcnt, bytes_mapped,
 					 flags);
 	}
 	return pagefault_implicit_mr(mr, odp, io_virt, bcnt, bytes_mapped,
--
2.20.1

