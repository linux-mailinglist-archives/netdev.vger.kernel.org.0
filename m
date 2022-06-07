Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E362853FF57
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244202AbiFGMsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244189AbiFGMsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:48:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5207D29807;
        Tue,  7 Jun 2022 05:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6FA56125F;
        Tue,  7 Jun 2022 12:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0681C385A5;
        Tue,  7 Jun 2022 12:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654606079;
        bh=DGRA9vxtjrhvubgSEYFKIx84VfRGgSkc5W0ysowy7S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvQKMAYftJUsSQ9J1gstyV23pcsH7RYiaFLynkZxtXvG4ineojWc9g+dqK4JCbSPA
         NG8xvFMmQyorlTYKBgSthtIQigl/yRxrea0msxVfZtHzzju5hgfqptFFOmf2qmIgyA
         RF1mVjq6lSXl+an0mQxLhB3eVnhDmLmCXnn7L8+6HeD8giIiiUd6alM4xpnjwYETWn
         otpNLA80XffjBNAVu07HrYcF4e52MRcxW0QlkVMDg7PcBoHZajUngbwmePxm9MTP0g
         BYYgy9yGHUTOjuqgs2kHyfDVJBsuRD1JwKyvASdyIRkah4v6/ufTShAjnatB4fewcS
         CFBfVMaPqTQHA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yevgeny Kliteynik <kliteyn@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Erez Shitrit <erezsh@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 3/3] RDMA/mlx5: Support handling of modify-header pattern ICM area
Date:   Tue,  7 Jun 2022 15:47:45 +0300
Message-Id: <6680877e0f357b8535ee8355ee82cdb057c5655f.1654605768.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1654605768.git.leonro@nvidia.com>
References: <cover.1654605768.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add support for allocate/deallocate and registering MR of the new type
of ICM area. Support exists only for devices that support sw_owner_v2.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/dm.c           | 53 +++++++++++++++--------
 drivers/infiniband/hw/mlx5/mr.c           |  1 +
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |  1 +
 3 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 001d766cf291..3669c90b2dad 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -336,9 +336,15 @@ static struct ib_dm *handle_alloc_dm_memic(struct ib_ucontext *ctx,
 
 static enum mlx5_sw_icm_type get_icm_type(int uapi_type)
 {
-	return uapi_type == MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM ?
-		       MLX5_SW_ICM_TYPE_STEERING :
-		       MLX5_SW_ICM_TYPE_HEADER_MODIFY;
+	switch (uapi_type) {
+	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
+		return MLX5_SW_ICM_TYPE_HEADER_MODIFY;
+	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_PATTERN_SW_ICM:
+		return MLX5_SW_ICM_TYPE_HEADER_MODIFY_PATTERN;
+	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
+	default:
+		return MLX5_SW_ICM_TYPE_STEERING;
+	}
 }
 
 static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
@@ -347,11 +353,32 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 					    int type)
 {
 	struct mlx5_core_dev *dev = to_mdev(ctx->device)->mdev;
-	enum mlx5_sw_icm_type icm_type = get_icm_type(type);
+	enum mlx5_sw_icm_type icm_type;
 	struct mlx5_ib_dm_icm *dm;
 	u64 act_size;
 	int err;
 
+	if (!capable(CAP_SYS_RAWIO) || !capable(CAP_NET_RAW))
+		return ERR_PTR(-EPERM);
+
+	switch (type) {
+	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
+	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
+		if (!(MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner) ||
+		      MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner) ||
+		      MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner_v2) ||
+		      MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner_v2)))
+			return ERR_PTR(-EOPNOTSUPP);
+		break;
+	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_PATTERN_SW_ICM:
+		if (!MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner_v2) ||
+		    !MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner_v2))
+			return ERR_PTR(-EOPNOTSUPP);
+		break;
+	default:
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
 	if (!dm)
 		return ERR_PTR(-ENOMEM);
@@ -359,19 +386,6 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 	dm->base.type = type;
 	dm->base.ibdm.device = ctx->device;
 
-	if (!capable(CAP_SYS_RAWIO) || !capable(CAP_NET_RAW)) {
-		err = -EPERM;
-		goto free;
-	}
-
-	if (!(MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner) ||
-	      MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner) ||
-	      MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner_v2) ||
-	      MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner_v2))) {
-		err = -EOPNOTSUPP;
-		goto free;
-	}
-
 	/* Allocation size must a multiple of the basic block size
 	 * and a power of 2.
 	 */
@@ -379,6 +393,8 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 	act_size = roundup_pow_of_two(act_size);
 
 	dm->base.size = act_size;
+	icm_type = get_icm_type(type);
+
 	err = mlx5_dm_sw_icm_alloc(dev, icm_type, act_size, attr->alignment,
 				   to_mucontext(ctx)->devx_uid,
 				   &dm->base.dev_addr, &dm->obj_id);
@@ -420,8 +436,8 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
 		return handle_alloc_dm_memic(context, attr, attrs);
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
-		return handle_alloc_dm_sw_icm(context, attr, attrs, type);
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
+	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_PATTERN_SW_ICM:
 		return handle_alloc_dm_sw_icm(context, attr, attrs, type);
 	default:
 		return ERR_PTR(-EOPNOTSUPP);
@@ -474,6 +490,7 @@ static int mlx5_ib_dealloc_dm(struct ib_dm *ibdm,
 		return 0;
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
+	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_PATTERN_SW_ICM:
 		return mlx5_dm_icm_dealloc(ctx, to_icm(ibdm));
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 90bb61ad8c64..dd8887bf83f0 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1132,6 +1132,7 @@ struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 		break;
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
+	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_PATTERN_SW_ICM:
 		if (attr->access_flags & ~MLX5_IB_DM_SW_ICM_ALLOWED_ACCESS)
 			return ERR_PTR(-EINVAL);
 
diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
index a21ca8ece8db..7af9e09ea556 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_verbs.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
@@ -63,6 +63,7 @@ enum mlx5_ib_uapi_dm_type {
 	MLX5_IB_UAPI_DM_TYPE_MEMIC,
 	MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM,
 	MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM,
+	MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_PATTERN_SW_ICM,
 };
 
 enum mlx5_ib_uapi_devx_create_event_channel_flags {
-- 
2.36.1

