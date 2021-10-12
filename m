Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7408A42A20F
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbhJLK3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235972AbhJLK3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 06:29:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F358461078;
        Tue, 12 Oct 2021 10:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634034419;
        bh=2NtKq17dEx+8m03kFidHWlFmDOwqnCecgyLNgXswUGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lri2PsNVXWSgHJuODBNhyxSs6iCNaiq7y1KNBjG/m/Dh0+1rhv7AqK1sCXJmKMhuw
         ftiefr/tJl8U2KcMa86+7+F3MaOG78OpqnQd393MTe1ZPSpyjJfw+ahvzhg+QRu76m
         CrWe/S2Q4wS2rfooieAnMedWVflhKcSxkvcF08ZYoeNRUkOXZbEVpPH0QLaRM2L0rA
         h1WgLka0y982VLR8KbhQkeNWuVvqAbpiY1sHL7tqv3xF4GW6U7C0iX1QYIpwhrBmYO
         ADS559XD5oGClpu+s7vLB/QXRZZVOSUp/1QtxZBupK49o893ryN/7GWWldSvnTp7UO
         V9wgTlcCqGljA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH mlx5-next 3/7] RDMA/mlx5: Remove size from struct mlx5_core_mkey
Date:   Tue, 12 Oct 2021 13:26:31 +0300
Message-Id: <024e6b2918d48c5f3185032413bafcf45c1488c6.1634033956.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634033956.git.leonro@nvidia.com>
References: <cover.1634033956.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

mkey->size is already stored in ibmr->length, no need to store it here.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c            | 1 -
 drivers/infiniband/hw/mlx5/mr.c              | 5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 1 -
 drivers/vdpa/mlx5/core/resources.c           | 1 -
 include/linux/mlx5/driver.h                  | 1 -
 5 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 439b62e23afb..3d416850bba8 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1303,7 +1303,6 @@ static int devx_handle_mkey_indirect(struct devx_obj *obj,
 	mkey->key = mlx5_idx_to_mkey(
 			MLX5_GET(create_mkey_out, out, mkey_index)) | key;
 	mkey->type = MLX5_MKEY_INDIRECT_DEVX;
-	mkey->size = MLX5_GET64(mkc, mkc, len);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
 	devx_mr->ndescs = MLX5_GET(mkc, mkc, translations_octword_size);
 	init_waitqueue_head(&mkey->wait);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index e264c6be38f8..6f831598b987 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -968,7 +968,6 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 
 	mr->ibmr.pd = pd;
 	mr->umem = umem;
-	mr->mmkey.size = umem->length;
 	mr->mmkey.pd = to_mpd(pd)->pdn;
 	mr->page_shift = order_base_2(page_size);
 	set_mr_fields(dev, mr, umem->length, access_flags, iova);
@@ -1080,7 +1079,7 @@ static void *mlx5_ib_create_xlt_wr(struct mlx5_ib_mr *mr,
 	wr->wr.opcode = MLX5_IB_WR_UMR;
 	wr->pd = mr->ibmr.pd;
 	wr->mkey = mr->mmkey.key;
-	wr->length = mr->mmkey.size;
+	wr->length = mr->ibmr.length;
 	wr->virt_addr = mr->ibmr.iova;
 	wr->access_flags = mr->access_flags;
 	wr->page_shift = mr->page_shift;
@@ -1768,7 +1767,7 @@ static int umr_rereg_pas(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 
 	mr->ibmr.length = new_umem->length;
 	mr->ibmr.iova = iova;
-	mr->mmkey.size = new_umem->length;
+	mr->ibmr.length = new_umem->length;
 	mr->page_shift = order_base_2(page_size);
 	mr->umem = new_umem;
 	err = mlx5_ib_update_mr_pas(mr, upd_flags);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index d239d559994f..b5dd44944265 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -52,7 +52,6 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
-	mkey->size = MLX5_GET64(mkc, mkc, len);
 	mkey->key = (u32)mlx5_mkey_variant(mkey->key) | mlx5_idx_to_mkey(mkey_index);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
 	init_waitqueue_head(&mkey->wait);
diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
index 14d4314cdc29..d3d8b8b4e377 100644
--- a/drivers/vdpa/mlx5/core/resources.c
+++ b/drivers/vdpa/mlx5/core/resources.c
@@ -215,7 +215,6 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, struct mlx5_core_mkey *mk
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
-	mkey->size = MLX5_GET64(mkc, mkc, len);
 	mkey->key |= mlx5_idx_to_mkey(mkey_index);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
 	return 0;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 573c0cbb0879..cba157689ca8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -364,7 +364,6 @@ enum {
 };
 
 struct mlx5_core_mkey {
-	u64			size;
 	u32			key;
 	u32			pd;
 	u32			type;
-- 
2.31.1

