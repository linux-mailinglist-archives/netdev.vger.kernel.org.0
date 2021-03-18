Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C3E34045F
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 12:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhCRLQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 07:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhCRLQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 07:16:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB98D64F2A;
        Thu, 18 Mar 2021 11:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616066161;
        bh=oiREY68drN1myyHRioNElxvpy+ZFbkwcPBMGSuC/nHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXDJebLNQY7hsJQ1R4MaoWazB4abPm7Q59INUg+PSdlg1ht9h9yeOayXXbtdWCeJ9
         Q7WyuERcXSs4ZfS8DgMEGYP1oeGQSfuKsCIjJQ9OLhBHLVRgMAIE7fWwT09HKTyYTL
         i9RqG0Ao+WKrKhsdQSfIz/ukU2kxeOMChKz1iMcbZC75JQ2/cwKjZIl3ZPge/VJTQ1
         EcvjNzE2JwLgvEDT/GCBnHJGco/A2XfQQrirwszoGLpLw5P/jP2BLMnX6eubqVNFxd
         WYLTabpetINpiHwle18irKeTqhp2zBGzzohohv4f4Yod9b0v5ryZHexxvUNUiOCck/
         OzoKuaqig8Vsg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next 3/7] RDMA/mlx5: Avoid use after free in allocate MEMIC bad flow
Date:   Thu, 18 Mar 2021 13:15:44 +0200
Message-Id: <20210318111548.674749-4-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318111548.674749-1-leon@kernel.org>
References: <20210318111548.674749-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

When driver fails to copy the MEMIC address to the user, we
call to rdma_user_mmap_entry_remove on the mmap entry. Since in this
state the refcount of the mmap entry is decreased to zero, mmap_free
is triggered and release the dm object. Therefore we need to avoid
the explicit call to free the dm.

Fixes: dc2316eba73f ("IB/mlx5: Fix device memory flows")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5226664f1bda..d652af720036 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2375,13 +2375,18 @@ static int handle_alloc_dm_memic(struct ib_ucontext *ctx,

 	err = mlx5_cmd_alloc_memic(dm_db, &dm->dev_addr,
 				   dm->size, attr->alignment);
-	if (err)
+	if (err) {
+		kfree(dm);
 		return err;
+	}

 	address = dm->dev_addr & PAGE_MASK;
 	err = add_dm_mmap_entry(ctx, dm, address);
-	if (err)
-		goto err_dealloc;
+	if (err) {
+		mlx5_cmd_dealloc_memic(dm_db, dm->dev_addr, dm->size);
+		kfree(dm);
+		return err;
+	}

 	page_idx = dm->mentry.rdma_entry.start_pgoff & 0xFFFF;
 	err = uverbs_copy_to(attrs,
@@ -2402,8 +2407,6 @@ static int handle_alloc_dm_memic(struct ib_ucontext *ctx,

 err_copy:
 	rdma_user_mmap_entry_remove(&dm->mentry.rdma_entry);
-err_dealloc:
-	mlx5_cmd_dealloc_memic(dm_db, dm->dev_addr, dm->size);

 	return err;
 }
@@ -2472,9 +2475,7 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,

 	switch (type) {
 	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
-		err = handle_alloc_dm_memic(context, dm,
-					    attr,
-					    attrs);
+		err = handle_alloc_dm_memic(context, dm, attr, attrs);
 		break;
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
 		err = handle_alloc_dm_sw_icm(context, dm,
@@ -2496,7 +2497,9 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 	return &dm->ibdm;

 err_free:
-	kfree(dm);
+	/* In MEMIC error flow, dm will be freed internally */
+	if (type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
+		kfree(dm);
 	return ERR_PTR(err);
 }

--
2.30.2

