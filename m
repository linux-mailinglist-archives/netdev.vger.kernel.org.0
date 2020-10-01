Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C0228081F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733104AbgJATxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733010AbgJATxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:15 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042CB20848;
        Thu,  1 Oct 2020 19:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581995;
        bh=MI4K65xuGBjssuRrs6f77rCEAPbog4Yk0DxhBnmsewo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yX5+hBvTyxgP4rgFz/bso7gVVRfuXem9V4EH1XrW8v7gxrb2wC59t2uH21ddCFz9P
         pPWYnw0VcoeT45qmuvT94BKrtygGcnM+iBuIYYVEF8Y3saTO6CVPdygGO25Jzv9xGu
         68LseNyZ9E37LUkKXLqx/+O9xPXYJahClU4O7Gqc=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 09/15] net/mlx5e: Add resiliency in Striding RQ mode for packets larger than MTU
Date:   Thu,  1 Oct 2020 12:52:41 -0700
Message-Id: <20201001195247.66636-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Prior to this fix, in Striding RQ mode the driver was vulnerable when
receiving packets in the range (stride size - headroom, stride size].
Where stride size is calculated by mtu+headroom+tailroom aligned to the
closest power of 2.
Usually, this filtering is performed by the HW, except for a few cases:
- Between 2 VFs over the same PF with different MTUs
- On bluefield, when the host physical function sets a larger MTU than
  the ARM has configured on its representor and uplink representor.

When the HW filtering is not present, packets that are larger than MTU
might be harmful for the RQ's integrity, in the following impacts:
1) Overflow from one WQE to the next, causing a memory corruption that
in most cases is unharmful: as the write happens to the headroom of next
packet, which will be overwritten by build_skb(). In very rare cases,
high stress/load, this is harmful. When the next WQE is not yet reposted
and points to existing SKB head.
2) Each oversize packet overflows to the headroom of the next WQE. On
the last WQE of the WQ, where addresses wrap-around, the address of the
remainder headroom does not belong to the next WQE, but it is out of the
memory region range. This results in a HW CQE error that moves the RQ
into an error state.

Solution:
Add a page buffer at the end of each WQE to absorb the leak. Actually
the maximal overflow size is headroom but since all memory units must be
of the same size, we use page size to comply with UMR WQEs. The increase
in memory consumption is of a single page per RQ. Initialize the mkey
with all MTTs pointing to a default page. When the channels are
activated, UMR WQEs will redirect the RX WQEs to the actual memory from
the RQ's pool, while the overflow MTTs remain mapped to the default page.

Fixes: 73281b78a37a ("net/mlx5e: Derive Striding RQ size from MTU")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  8 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 55 +++++++++++++++++--
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 90d5caabd6af..356f5852955f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -91,7 +91,12 @@ struct page_pool;
 #define MLX5_MPWRQ_PAGES_PER_WQE		BIT(MLX5_MPWRQ_WQE_PAGE_ORDER)
 
 #define MLX5_MTT_OCTW(npages) (ALIGN(npages, 8) / 2)
-#define MLX5E_REQUIRED_WQE_MTTS		(ALIGN(MLX5_MPWRQ_PAGES_PER_WQE, 8))
+/* Add another page to MLX5E_REQUIRED_WQE_MTTS as a buffer between
+ * WQEs, This page will absorb write overflow by the hardware, when
+ * receiving packets larger than MTU. These oversize packets are
+ * dropped by the driver at a later stage.
+ */
+#define MLX5E_REQUIRED_WQE_MTTS		(ALIGN(MLX5_MPWRQ_PAGES_PER_WQE + 1, 8))
 #define MLX5E_LOG_ALIGNED_MPWQE_PPW	(ilog2(MLX5E_REQUIRED_WQE_MTTS))
 #define MLX5E_REQUIRED_MTTS(wqes)	(wqes * MLX5E_REQUIRED_WQE_MTTS)
 #define MLX5E_MAX_RQ_NUM_MTTS	\
@@ -617,6 +622,7 @@ struct mlx5e_rq {
 	u32                    rqn;
 	struct mlx5_core_dev  *mdev;
 	struct mlx5_core_mkey  umr_mkey;
+	struct mlx5e_dma_info  wqe_overflow;
 
 	/* XDP read-mostly */
 	struct xdp_rxq_info    xdp_rxq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1fbd7a0f3ca6..b1a16fb9667e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -246,12 +246,17 @@ static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq,
 
 static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 				 u64 npages, u8 page_shift,
-				 struct mlx5_core_mkey *umr_mkey)
+				 struct mlx5_core_mkey *umr_mkey,
+				 dma_addr_t filler_addr)
 {
-	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
+	struct mlx5_mtt *mtt;
+	int inlen;
 	void *mkc;
 	u32 *in;
 	int err;
+	int i;
+
+	inlen = MLX5_ST_SZ_BYTES(create_mkey_in) + sizeof(*mtt) * npages;
 
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in)
@@ -271,6 +276,18 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 MLX5_MTT_OCTW(npages));
 	MLX5_SET(mkc, mkc, log_page_size, page_shift);
+	MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
+		 MLX5_MTT_OCTW(npages));
+
+	/* Initialize the mkey with all MTTs pointing to a default
+	 * page (filler_addr). When the channels are activated, UMR
+	 * WQEs will redirect the RX WQEs to the actual memory from
+	 * the RQ's pool, while the gaps (wqe_overflow) remain mapped
+	 * to the default page.
+	 */
+	mtt = MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
+	for (i = 0 ; i < npages ; i++)
+		mtt[i].ptag = cpu_to_be64(filler_addr);
 
 	err = mlx5_core_create_mkey(mdev, umr_mkey, in, inlen);
 
@@ -282,7 +299,8 @@ static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq
 {
 	u64 num_mtts = MLX5E_REQUIRED_MTTS(mlx5_wq_ll_get_size(&rq->mpwqe.wq));
 
-	return mlx5e_create_umr_mkey(mdev, num_mtts, PAGE_SHIFT, &rq->umr_mkey);
+	return mlx5e_create_umr_mkey(mdev, num_mtts, PAGE_SHIFT, &rq->umr_mkey,
+				     rq->wqe_overflow.addr);
 }
 
 static inline u64 mlx5e_get_mpwqe_offset(struct mlx5e_rq *rq, u16 wqe_ix)
@@ -350,6 +368,28 @@ static void mlx5e_rq_err_cqe_work(struct work_struct *recover_work)
 	mlx5e_reporter_rq_cqe_err(rq);
 }
 
+static int mlx5e_alloc_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
+{
+	rq->wqe_overflow.page = alloc_page(GFP_KERNEL);
+	if (!rq->wqe_overflow.page)
+		return -ENOMEM;
+
+	rq->wqe_overflow.addr = dma_map_page(rq->pdev, rq->wqe_overflow.page, 0,
+					     PAGE_SIZE, rq->buff.map_dir);
+	if (dma_mapping_error(rq->pdev, rq->wqe_overflow.addr)) {
+		__free_page(rq->wqe_overflow.page);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
+{
+	 dma_unmap_page(rq->pdev, rq->wqe_overflow.addr, PAGE_SIZE,
+			rq->buff.map_dir);
+	 __free_page(rq->wqe_overflow.page);
+}
+
 static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
@@ -409,6 +449,10 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		if (err)
 			goto err_rq_xdp;
 
+		err = mlx5e_alloc_mpwqe_rq_drop_page(rq);
+		if (err)
+			goto err_rq_wq_destroy;
+
 		rq->mpwqe.wq.db = &rq->mpwqe.wq.db[MLX5_RCV_DBR];
 
 		wq_sz = mlx5_wq_ll_get_size(&rq->mpwqe.wq);
@@ -424,7 +468,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 		err = mlx5e_create_rq_umr_mkey(mdev, rq);
 		if (err)
-			goto err_rq_wq_destroy;
+			goto err_rq_drop_page;
 		rq->mkey_be = cpu_to_be32(rq->umr_mkey.key);
 
 		err = mlx5e_rq_alloc_mpwqe_info(rq, c);
@@ -548,6 +592,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		kvfree(rq->mpwqe.info);
 err_rq_mkey:
 		mlx5_core_destroy_mkey(mdev, &rq->umr_mkey);
+err_rq_drop_page:
+		mlx5e_free_mpwqe_rq_drop_page(rq);
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		mlx5e_free_di_list(rq);
@@ -582,6 +628,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		kvfree(rq->mpwqe.info);
 		mlx5_core_destroy_mkey(rq->mdev, &rq->umr_mkey);
+		mlx5e_free_mpwqe_rq_drop_page(rq);
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		kvfree(rq->wqe.frags);
-- 
2.26.2

