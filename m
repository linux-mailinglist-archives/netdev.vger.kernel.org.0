Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7129134A1E
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbgAHSGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:06:13 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45130 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730100AbgAHSGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:06:12 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yishaih@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [10.7.2.17])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 008I65Eu030047;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [127.0.0.1])
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8) with ESMTP id 008I65u4022359;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: (from yishaih@localhost)
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8/Submit) id 008I65xB022357;
        Wed, 8 Jan 2020 20:06:05 +0200
From:   Yishai Hadas <yishaih@mellanox.com>
To:     linux-rdma@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com
Cc:     saeedm@mellanox.com, yishaih@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH rdma-next 10/10] RDMA/mlx5: Set relaxed ordering when requested
Date:   Wed,  8 Jan 2020 20:05:40 +0200
Message-Id: <1578506740-22188-11-git-send-email-yishaih@mellanox.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Enable relaxed ordering in mkey context when requested.
As relaxed ordering is not currently supported in UMR, disable UMR usage
for relaxed ordering MRs.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  5 ++++-
 drivers/infiniband/hw/mlx5/mr.c      | 19 +++++++++++++++++--
 drivers/infiniband/hw/mlx5/odp.c     |  2 +-
 drivers/infiniband/hw/mlx5/qp.c      |  2 +-
 4 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b06f32f..3f0a55c 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1507,7 +1507,7 @@ int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
 u16 mlx5_ib_get_counters_id(struct mlx5_ib_dev *dev, u8 port_num);
 
 static inline bool mlx5_ib_can_use_umr(struct mlx5_ib_dev *dev,
-				       bool do_modify_atomic)
+				       bool do_modify_atomic, int access_flags)
 {
 	if (MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled))
 		return false;
@@ -1517,6 +1517,9 @@ static inline bool mlx5_ib_can_use_umr(struct mlx5_ib_dev *dev,
 	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
 		return false;
 
+	if (access_flags & IB_ACCESS_RELAXED_ORDERING)
+		return false;
+
 	return true;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index ea8bfc3..75b825a 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -661,12 +661,21 @@ int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 					  struct ib_pd *pd)
 {
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+
 	MLX5_SET(mkc, mkc, a, !!(acc & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, mkc, rw, !!(acc & IB_ACCESS_REMOTE_WRITE));
 	MLX5_SET(mkc, mkc, rr, !!(acc & IB_ACCESS_REMOTE_READ));
 	MLX5_SET(mkc, mkc, lw, !!(acc & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, mkc, lr, 1);
 
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
+		MLX5_SET(mkc, mkc, relaxed_ordering_write,
+			 !!(acc & IB_ACCESS_RELAXED_ORDERING));
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read))
+		MLX5_SET(mkc, mkc, relaxed_ordering_read,
+			 !!(acc & IB_ACCESS_RELAXED_ORDERING));
+
 	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET64(mkc, mkc, start_addr, start_addr);
@@ -1075,6 +1084,12 @@ static struct mlx5_ib_mr *reg_create(struct ib_mr *ibmr, struct ib_pd *pd,
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	MLX5_SET(mkc, mkc, free, !populate);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
+		MLX5_SET(mkc, mkc, relaxed_ordering_write,
+			 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read))
+		MLX5_SET(mkc, mkc, relaxed_ordering_read,
+			 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
 	MLX5_SET(mkc, mkc, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, mkc, rw, !!(access_flags & IB_ACCESS_REMOTE_WRITE));
 	MLX5_SET(mkc, mkc, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
@@ -1263,7 +1278,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (err < 0)
 		return ERR_PTR(err);
 
-	use_umr = mlx5_ib_can_use_umr(dev, true);
+	use_umr = mlx5_ib_can_use_umr(dev, true, access_flags);
 
 	if (order <= mr_cache_max_order(dev) && use_umr) {
 		mr = alloc_mr_from_cache(pd, umem, virt_addr, length, ncont,
@@ -1431,7 +1446,7 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 			goto err;
 	}
 
-	if (!mlx5_ib_can_use_umr(dev, true) ||
+	if (!mlx5_ib_can_use_umr(dev, true, access_flags) ||
 	    (flags & IB_MR_REREG_TRANS && !use_umr_mtt_update(mr, addr, len))) {
 		/*
 		 * UMR can't be used - MKey needs to be replaced.
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index f924250..bed81dc 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -342,7 +342,7 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 	memset(caps, 0, sizeof(*caps));
 
 	if (!MLX5_CAP_GEN(dev->mdev, pg) ||
-	    !mlx5_ib_can_use_umr(dev, true))
+	    !mlx5_ib_can_use_umr(dev, true, 0))
 		return;
 
 	caps->general_caps = IB_ODP_SUPPORT;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7e51870..76e30ad 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4823,7 +4823,7 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	bool atomic = wr->access & IB_ACCESS_REMOTE_ATOMIC;
 	u8 flags = 0;
 
-	if (!mlx5_ib_can_use_umr(dev, atomic)) {
+	if (!mlx5_ib_can_use_umr(dev, atomic, wr->access)) {
 		mlx5_ib_warn(to_mdev(qp->ibqp.device),
 			     "Fast update of %s for MR is disabled\n",
 			     (MLX5_CAP_GEN(dev->mdev,
-- 
1.8.3.1

