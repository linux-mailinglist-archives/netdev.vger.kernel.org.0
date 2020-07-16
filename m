Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4CA2220FA
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgGPKxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgGPKxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:53:06 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D52206C1;
        Thu, 16 Jul 2020 10:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594896785;
        bh=fyzOgz6MAnw4vLDS2TvalUP9YruNrVdxbhrMgzMgmE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLRK05bMZ7Gvu66371GeZr1MduA2pYtBn27hoaQx6XrJ+3KFz6aoel6uQs3Q8L/jH
         d93FX0voO2MDW0OAgdcfSLf635BUnhIn1pDVJNopta5BYF4xmUl3/zBwjNIea7ILIG
         49rlb2LUQNLe235QTHqnUWOUG32/dpeQ9FNNzdFg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Meir Lichtinger <meirl@mellanox.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next 3/3] RDMA/mlx5: Set mkey relaxed ordering by UMR with ConnectX-7
Date:   Thu, 16 Jul 2020 13:52:48 +0300
Message-Id: <20200716105248.1423452-4-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716105248.1423452-1-leon@kernel.org>
References: <20200716105248.1423452-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@mellanox.com>

Up to ConnectX-7 UMR is not used when user passes relaxed ordering
access flag. ConnectX-7 supports setting relaxed ordering read/write
mkey attribute by UMR, indicated by new HCA capabilities.

With ConnectX-7 driver uses UMR when user set relaxed ordering access
flag, in contrast to previous silicon models. Specifically it includes
setting relvant flags of mkey context mask in UMR control segment,
and relaxed ordering write and read flags in UMR mkey context segment.

Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
Reviewed-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  9 ++++--
 drivers/infiniband/hw/mlx5/wr.c      | 44 ++++++++++++++++++++++------
 include/linux/mlx5/device.h          |  4 ++-
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 52c384214f26..06ee2322052d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1459,8 +1459,13 @@ static inline bool mlx5_ib_can_use_umr(struct mlx5_ib_dev *dev,
 		return false;

 	if (access_flags & IB_ACCESS_RELAXED_ORDERING &&
-	    (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write) ||
-	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read)))
+	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write) &&
+	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+		return false;
+
+	if (access_flags & IB_ACCESS_RELAXED_ORDERING &&
+	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) &&
+	     !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
 		return false;

 	return true;
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index e58ecb46f8e3..4d4f8c22b3e6 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -263,7 +263,9 @@ static __be64 get_umr_update_translation_mask(void)
 	return cpu_to_be64(result);
 }

-static __be64 get_umr_update_access_mask(int atomic)
+static __be64 get_umr_update_access_mask(int atomic,
+					 int relaxed_ordering_write,
+					 int relaxed_ordering_read)
 {
 	u64 result;

@@ -275,6 +277,12 @@ static __be64 get_umr_update_access_mask(int atomic)
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

@@ -289,17 +297,28 @@ static __be64 get_umr_update_pd_mask(void)

 static int umr_check_mkey_mask(struct mlx5_ib_dev *dev, u64 mask)
 {
-	if ((mask & MLX5_MKEY_MASK_PAGE_SIZE &&
-	     MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled)) ||
-	    (mask & MLX5_MKEY_MASK_A &&
-	     MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled)))
+	if (mask & MLX5_MKEY_MASK_PAGE_SIZE &&
+	    MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled))
+		return -EPERM;
+
+	if (mask & MLX5_MKEY_MASK_A &&
+	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
+		return -EPERM;
+
+	if (mask & MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE &&
+	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+		return -EPERM;
+
+	if (mask & MLX5_MKEY_MASK_RELAXED_ORDERING_READ &&
+	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
 		return -EPERM;
+
 	return 0;
 }

 static int set_reg_umr_segment(struct mlx5_ib_dev *dev,
 			       struct mlx5_wqe_umr_ctrl_seg *umr,
-			       const struct ib_send_wr *wr, int atomic)
+			       const struct ib_send_wr *wr)
 {
 	const struct mlx5_umr_wr *umrwr = umr_wr(wr);

@@ -325,7 +344,10 @@ static int set_reg_umr_segment(struct mlx5_ib_dev *dev,
 	if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_TRANSLATION)
 		umr->mkey_mask |= get_umr_update_translation_mask();
 	if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_PD_ACCESS) {
-		umr->mkey_mask |= get_umr_update_access_mask(atomic);
+		umr->mkey_mask |= get_umr_update_access_mask(
+			!!(MLX5_CAP_GEN(dev->mdev, atomic)),
+			!!(MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr)),
+			!!(MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr)));
 		umr->mkey_mask |= get_umr_update_pd_mask();
 	}
 	if (wr->send_flags & MLX5_IB_SEND_UMR_ENABLE_MR)
@@ -392,6 +414,11 @@ static void set_reg_mkey_segment(struct mlx5_mkey_seg *seg,
 	MLX5_SET(mkc, seg, rr, !!(umrwr->access_flags & IB_ACCESS_REMOTE_READ));
 	MLX5_SET(mkc, seg, lw, !!(umrwr->access_flags & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, seg, lr, 1);
+	MLX5_SET(mkc, seg, relaxed_ordering_write,
+		 !!(umrwr->access_flags & IB_ACCESS_RELAXED_ORDERING));
+	MLX5_SET(mkc, seg, relaxed_ordering_read,
+		 !!(umrwr->access_flags & IB_ACCESS_RELAXED_ORDERING));
+
 	if (umrwr->pd)
 		MLX5_SET(mkc, seg, pd, to_mpd(umrwr->pd)->pdn);
 	if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_TRANSLATION &&
@@ -1230,8 +1257,7 @@ static int handle_qpt_reg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,

 	qp->sq.wr_data[idx] = MLX5_IB_WR_UMR;
 	(*ctrl)->imm = cpu_to_be32(umr_wr(wr)->mkey);
-	err = set_reg_umr_segment(dev, *seg, wr,
-				  !!(MLX5_CAP_GEN(dev->mdev, atomic)));
+	err = set_reg_umr_segment(dev, *seg, wr);
 	if (unlikely(err))
 		goto out;
 	*seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 7940a574a618..b1a891576fbe 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -276,7 +276,9 @@ enum {
 	MLX5_MKEY_MASK_RW		= 1ull << 20,
 	MLX5_MKEY_MASK_A		= 1ull << 21,
 	MLX5_MKEY_MASK_SMALL_FENCE	= 1ull << 23,
-	MLX5_MKEY_MASK_FREE		= 1ull << 29,
+	MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE	= 1ull << 25,
+	MLX5_MKEY_MASK_FREE			= 1ull << 29,
+	MLX5_MKEY_MASK_RELAXED_ORDERING_READ	= 1ull << 47,
 };

 enum {
--
2.26.2

