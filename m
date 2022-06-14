Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E314D54B8CF
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344704AbiFNSkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243974AbiFNSks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:40:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7772C46642;
        Tue, 14 Jun 2022 11:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 067D9617C3;
        Tue, 14 Jun 2022 18:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39442C3411B;
        Tue, 14 Jun 2022 18:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655232045;
        bh=BsBNFaSn2xnfHjLXy8ksKrkvSK3Pk0qaviYNvHJ9aCo=;
        h=From:To:Cc:Subject:Date:From;
        b=LWZ94fPYv1hSdLxcZKmHlqdTrWq+Ki4/wbM9T7P28+gDEYzIdFKDP9bIMSL+3ro7w
         937/NXo8p0+s9juzmU+KHyD3utEJiPXBkkqLpYjgjR0fXRzM5MzJ6PybgrIuRC6nis
         lBck670GcCLedNyUXThQ2P05kllmXmjJG2JM5VpE5EULXNmT5n86gXQ6Vi1buyPdio
         eCwobpoBx+GvwDfCsORSUNy1zp3P08bunNkczZ9197Ar0z9UP9YqmnFhBHqnjZQ3b9
         GYdRR0rBbAH44HWIKpLgjxfMIvstKTAQHfha2uMXYel19c6wFAYixzzw4iZU+QEZSU
         411OoP7aZkIbQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [GIT PULL][next-next][rdma-next] mlx5-next: updates 2022-06-14                               
Date:   Tue, 14 Jun 2022 11:40:28 -0700
Message-Id: <20220614184028.51548-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
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

From: Saeed Mahameed <saeedm@nvidia.com>                                        

The following changes since commit f2906aa863381afb0015a9eb7fefad885d4e5a56:

  Linux 5.19-rc1 (2022-06-05 17:18:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to cdcdce948d64139aea1c6dfea4b04f5c8ad2784e:

  net/mlx5: Add bits and fields to support enhanced CQE compression (2022-06-13 14:59:06 -0700)

----------------------------------------------------------------

This pull includes shared updates to net-next and rdma-next for upcoming mlx5   
features.                                                                       
                                                                                
Please pull and let me know if there's any problem                              
                                                                                
1) Updated HW bits and definitions for upcoming features
 1.1) vport debug counters
 1.2) flow meter
 1.3) Execute ASO action for flow entry 
 1.4) enhanced CQE compression

2) Add ICM header-modify-pattern RDMA API

Leon Says
=========

SW steering manipulates packet's header using "modifying header" actions.
Many of these actions do the same operation, but use different data each time.
Currently we create and keep every one of these actions, which use expensive
and limited resources.

Now we introduce a new mechanism - pattern and argument, which splits
a modifying action into two parts:
1. action pattern: contains the operations to be applied on packet's header,
mainly set/add/copy of fields in the packet
2. action data/argument: contains the data to be used by each operation
in the pattern.

This way we reuse same patterns with different arguments to create new
modifying actions, and since many actions share the same operations, we end
up creating a small number of patterns that we keep in a dedicated cache.

These modify header patterns are implemented as new type of ICM memory,
so the following kernel patch series add the support for this new ICM type.
==========

----------------------------------------------------------------
Jianbo Liu (2):
      net/mlx5: Add IFC bits and enums for flow meter
      net/mlx5: Add support EXECUTE_ASO action for flow entry

Ofer Levi (1):
      net/mlx5: Add bits and fields to support enhanced CQE compression

Saeed Mahameed (1):
      net/mlx5: Add HW definitions of vport debug counters

Shay Drory (2):
      net/mlx5: group fdb cleanup to single function
      net/mlx5: Remove not used MLX5_CAP_BITS_RW_MASK

Yevgeny Kliteynik (3):
      net/mlx5: Introduce header-modify-pattern ICM properties
      net/mlx5: Manage ICM of type modify-header pattern
      RDMA/mlx5: Support handling of modify-header pattern ICM area

 drivers/infiniband/hw/mlx5/dm.c                   |  53 +++++---
 drivers/infiniband/hw/mlx5/mr.c                   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  33 +++++
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |  18 +--
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c  |  42 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |   7 -
 include/linux/mlx5/device.h                       |  36 +++---
 include/linux/mlx5/driver.h                       |   1 +
 include/linux/mlx5/fs.h                           |  14 ++
 include/linux/mlx5/mlx5_ifc.h                     | 151 ++++++++++++++++++++--
 include/uapi/rdma/mlx5_user_ioctl_verbs.h         |   1 +
 11 files changed, 292 insertions(+), 65 deletions(-)

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
index 1e7653c997b5..aedfd7ff4846 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1083,6 +1083,7 @@ struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 		break;
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
+	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_PATTERN_SW_ICM:
 		if (attr->access_flags & ~MLX5_IB_DM_SW_ICM_ALLOWED_ACCESS)
 			return ERR_PTR(-EINVAL);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 2ccf7bef9b05..735dc805dad7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -479,6 +479,30 @@ static int mlx5_set_extended_dest(struct mlx5_core_dev *dev,
 
 	return 0;
 }
+
+static void
+mlx5_cmd_set_fte_flow_meter(struct fs_fte *fte, void *in_flow_context)
+{
+	void *exe_aso_ctrl;
+	void *execute_aso;
+
+	execute_aso = MLX5_ADDR_OF(flow_context, in_flow_context,
+				   execute_aso[0]);
+	MLX5_SET(execute_aso, execute_aso, valid, 1);
+	MLX5_SET(execute_aso, execute_aso, aso_object_id,
+		 fte->action.exe_aso.object_id);
+
+	exe_aso_ctrl = MLX5_ADDR_OF(execute_aso, execute_aso, exe_aso_ctrl);
+	MLX5_SET(exe_aso_ctrl_flow_meter, exe_aso_ctrl, return_reg_id,
+		 fte->action.exe_aso.return_reg_id);
+	MLX5_SET(exe_aso_ctrl_flow_meter, exe_aso_ctrl, aso_type,
+		 fte->action.exe_aso.type);
+	MLX5_SET(exe_aso_ctrl_flow_meter, exe_aso_ctrl, init_color,
+		 fte->action.exe_aso.flow_meter.init_color);
+	MLX5_SET(exe_aso_ctrl_flow_meter, exe_aso_ctrl, meter_id,
+		 fte->action.exe_aso.flow_meter.meter_idx);
+}
+
 static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 			    int opmod, int modify_mask,
 			    struct mlx5_flow_table *ft,
@@ -663,6 +687,15 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 			 list_size);
 	}
 
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO) {
+		if (fte->action.exe_aso.type == MLX5_EXE_ASO_FLOW_METER) {
+			mlx5_cmd_set_fte_flow_meter(fte, in_flow_context);
+		} else {
+			err = -EOPNOTSUPP;
+			goto err_out;
+		}
+	}
+
 	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 err_out:
 	kvfree(in);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fdcf7f529330..14187e50e2f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2866,6 +2866,14 @@ static int create_fdb_bypass(struct mlx5_flow_steering *steering)
 	return 0;
 }
 
+static void cleanup_fdb_root_ns(struct mlx5_flow_steering *steering)
+{
+	cleanup_root_ns(steering->fdb_root_ns);
+	steering->fdb_root_ns = NULL;
+	kfree(steering->fdb_sub_ns);
+	steering->fdb_sub_ns = NULL;
+}
+
 static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 {
 	struct fs_prio *maj_prio;
@@ -2916,10 +2924,7 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 	return 0;
 
 out_err:
-	cleanup_root_ns(steering->fdb_root_ns);
-	kfree(steering->fdb_sub_ns);
-	steering->fdb_sub_ns = NULL;
-	steering->fdb_root_ns = NULL;
+	cleanup_fdb_root_ns(steering);
 	return err;
 }
 
@@ -3079,10 +3084,7 @@ void mlx5_fs_core_cleanup(struct mlx5_core_dev *dev)
 	struct mlx5_flow_steering *steering = dev->priv.steering;
 
 	cleanup_root_ns(steering->root_ns);
-	cleanup_root_ns(steering->fdb_root_ns);
-	steering->fdb_root_ns = NULL;
-	kfree(steering->fdb_sub_ns);
-	steering->fdb_sub_ns = NULL;
+	cleanup_fdb_root_ns(steering);
 	cleanup_root_ns(steering->port_sel_root_ns);
 	cleanup_root_ns(steering->sniffer_rx_root_ns);
 	cleanup_root_ns(steering->sniffer_tx_root_ns);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
index 3d5e57ff558c..7e02cbe8c3b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
@@ -12,13 +12,16 @@ struct mlx5_dm {
 	spinlock_t lock;
 	unsigned long *steering_sw_icm_alloc_blocks;
 	unsigned long *header_modify_sw_icm_alloc_blocks;
+	unsigned long *header_modify_pattern_sw_icm_alloc_blocks;
 };
 
 struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 {
+	u64 header_modify_pattern_icm_blocks = 0;
 	u64 header_modify_icm_blocks = 0;
 	u64 steering_icm_blocks = 0;
 	struct mlx5_dm *dm;
+	bool support_v2;
 
 	if (!(MLX5_CAP_GEN_64(dev, general_obj_types) & MLX5_GENERAL_OBJ_TYPES_CAP_SW_ICM))
 		return NULL;
@@ -53,8 +56,27 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 			goto err_modify_hdr;
 	}
 
+	support_v2 = MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner_v2) &&
+		     MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner_v2) &&
+		     MLX5_CAP64_DEV_MEM(dev, header_modify_pattern_sw_icm_start_address);
+
+	if (support_v2) {
+		header_modify_pattern_icm_blocks =
+			BIT(MLX5_CAP_DEV_MEM(dev, log_header_modify_pattern_sw_icm_size) -
+			    MLX5_LOG_SW_ICM_BLOCK_SIZE(dev));
+
+		dm->header_modify_pattern_sw_icm_alloc_blocks =
+			kcalloc(BITS_TO_LONGS(header_modify_pattern_icm_blocks),
+				sizeof(unsigned long), GFP_KERNEL);
+		if (!dm->header_modify_pattern_sw_icm_alloc_blocks)
+			goto err_pattern;
+	}
+
 	return dm;
 
+err_pattern:
+	kfree(dm->header_modify_sw_icm_alloc_blocks);
+
 err_modify_hdr:
 	kfree(dm->steering_sw_icm_alloc_blocks);
 
@@ -86,6 +108,14 @@ void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
 		kfree(dm->header_modify_sw_icm_alloc_blocks);
 	}
 
+	if (dm->header_modify_pattern_sw_icm_alloc_blocks) {
+		WARN_ON(!bitmap_empty(dm->header_modify_pattern_sw_icm_alloc_blocks,
+				      BIT(MLX5_CAP_DEV_MEM(dev,
+							   log_header_modify_pattern_sw_icm_size) -
+					  MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))));
+		kfree(dm->header_modify_pattern_sw_icm_alloc_blocks);
+	}
+
 	kfree(dm);
 }
 
@@ -130,6 +160,13 @@ int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
 						log_header_modify_sw_icm_size);
 		block_map = dm->header_modify_sw_icm_alloc_blocks;
 		break;
+	case MLX5_SW_ICM_TYPE_HEADER_MODIFY_PATTERN:
+		icm_start_addr = MLX5_CAP64_DEV_MEM(dev,
+						    header_modify_pattern_sw_icm_start_address);
+		log_icm_size = MLX5_CAP_DEV_MEM(dev,
+						log_header_modify_pattern_sw_icm_size);
+		block_map = dm->header_modify_pattern_sw_icm_alloc_blocks;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -203,6 +240,11 @@ int mlx5_dm_sw_icm_dealloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type
 		icm_start_addr = MLX5_CAP64_DEV_MEM(dev, header_modify_sw_icm_start_address);
 		block_map = dm->header_modify_sw_icm_alloc_blocks;
 		break;
+	case MLX5_SW_ICM_TYPE_HEADER_MODIFY_PATTERN:
+		icm_start_addr = MLX5_CAP64_DEV_MEM(dev,
+						    header_modify_pattern_sw_icm_start_address);
+		block_map = dm->header_modify_pattern_sw_icm_alloc_blocks;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c9b4e50a593e..2078d9f03a5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -314,13 +314,6 @@ struct mlx5_reg_host_endianness {
 	u8      rsvd[15];
 };
 
-#define CAP_MASK(pos, size) ((u64)((1 << (size)) - 1) << (pos))
-
-enum {
-	MLX5_CAP_BITS_RW_MASK = CAP_MASK(MLX5_CAP_OFF_CMDIF_CSUM, 2) |
-				MLX5_DEV_CAP_FLAG_DCT,
-};
-
 static u16 to_fw_pkey_sz(struct mlx5_core_dev *dev, u32 size)
 {
 	switch (size) {
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 604b85dd770a..b5f58fd37a0f 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -386,21 +386,6 @@ enum {
 	MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG	= 9,
 };
 
-enum {
-	MLX5_DEV_CAP_FLAG_XRC		= 1LL <<  3,
-	MLX5_DEV_CAP_FLAG_BAD_PKEY_CNTR	= 1LL <<  8,
-	MLX5_DEV_CAP_FLAG_BAD_QKEY_CNTR	= 1LL <<  9,
-	MLX5_DEV_CAP_FLAG_APM		= 1LL << 17,
-	MLX5_DEV_CAP_FLAG_ATOMIC	= 1LL << 18,
-	MLX5_DEV_CAP_FLAG_BLOCK_MCAST	= 1LL << 23,
-	MLX5_DEV_CAP_FLAG_ON_DMND_PG	= 1LL << 24,
-	MLX5_DEV_CAP_FLAG_CQ_MODER	= 1LL << 29,
-	MLX5_DEV_CAP_FLAG_RESIZE_CQ	= 1LL << 30,
-	MLX5_DEV_CAP_FLAG_DCT		= 1LL << 37,
-	MLX5_DEV_CAP_FLAG_SIG_HAND_OVER	= 1LL << 40,
-	MLX5_DEV_CAP_FLAG_CMDIF_CSUM	= 3LL << 46,
-};
-
 enum {
 	MLX5_ROCE_VERSION_1		= 0,
 	MLX5_ROCE_VERSION_2		= 2,
@@ -455,6 +440,7 @@ enum {
 
 	MLX5_OPCODE_UMR			= 0x25,
 
+	MLX5_OPCODE_ACCESS_ASO		= 0x2d,
 };
 
 enum {
@@ -495,10 +481,6 @@ enum {
 	MLX5_MAX_PAGE_SHIFT		= 31
 };
 
-enum {
-	MLX5_CAP_OFF_CMDIF_CSUM		= 46,
-};
-
 enum {
 	/*
 	 * Max wqe size for rdma read is 512 bytes, so this
@@ -840,7 +822,10 @@ struct mlx5_cqe64 {
 	__be32		timestamp_l;
 	__be32		sop_drop_qpn;
 	__be16		wqe_counter;
-	u8		signature;
+	union {
+		u8	signature;
+		u8	validity_iteration_count;
+	};
 	u8		op_own;
 };
 
@@ -872,6 +857,11 @@ enum {
 	MLX5_CQE_FORMAT_CSUM_STRIDX = 0x3,
 };
 
+enum {
+	MLX5_CQE_COMPRESS_LAYOUT_BASIC = 0,
+	MLX5_CQE_COMPRESS_LAYOUT_ENHANCED = 1,
+};
+
 #define MLX5_MINI_CQE_ARRAY_SIZE 8
 
 static inline u8 mlx5_get_cqe_format(struct mlx5_cqe64 *cqe)
@@ -884,6 +874,12 @@ static inline u8 get_cqe_opcode(struct mlx5_cqe64 *cqe)
 	return cqe->op_own >> 4;
 }
 
+static inline u8 get_cqe_enhanced_num_mini_cqes(struct mlx5_cqe64 *cqe)
+{
+	/* num_of_mini_cqes is zero based */
+	return get_cqe_opcode(cqe) + 1;
+}
+
 static inline u8 get_cqe_lro_tcppsh(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->lro.tcppsh_abort_dupack >> 6) & 1;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 5040cd774c5a..76d7661e3e63 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -676,6 +676,7 @@ struct mlx5e_resources {
 enum mlx5_sw_icm_type {
 	MLX5_SW_ICM_TYPE_STEERING,
 	MLX5_SW_ICM_TYPE_HEADER_MODIFY,
+	MLX5_SW_ICM_TYPE_HEADER_MODIFY_PATTERN,
 };
 
 #define MLX5_MAX_RESERVED_GIDS 8
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 8135713b0d2d..ece3e35622d7 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -212,6 +212,19 @@ struct mlx5_flow_group *
 mlx5_create_flow_group(struct mlx5_flow_table *ft, u32 *in);
 void mlx5_destroy_flow_group(struct mlx5_flow_group *fg);
 
+struct mlx5_exe_aso {
+	u32 object_id;
+	u8 type;
+	u8 return_reg_id;
+	union {
+		u32 ctrl_data;
+		struct {
+			u8 meter_idx;
+			u8 init_color;
+		} flow_meter;
+	};
+};
+
 struct mlx5_fs_vlan {
         u16 ethtype;
         u16 vid;
@@ -237,6 +250,7 @@ struct mlx5_flow_act {
 	struct mlx5_fs_vlan vlan[MLX5_FS_VLAN_DEPTH];
 	struct ib_counters *counters;
 	struct mlx5_flow_group *fg;
+	struct mlx5_exe_aso exe_aso;
 };
 
 #define MLX5_DECLARE_FLOW_ACT(name) \
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fd7d083a34d3..8e87eb47f9dc 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -442,7 +442,9 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         max_modify_header_actions[0x8];
 	u8         max_ft_level[0x8];
 
-	u8         reserved_at_40[0x20];
+	u8         reserved_at_40[0x6];
+	u8         execute_aso[0x1];
+	u8         reserved_at_47[0x19];
 
 	u8         reserved_at_60[0x2];
 	u8         reformat_insert[0x1];
@@ -940,7 +942,17 @@ struct mlx5_ifc_qos_cap_bits {
 
 	u8         max_tsar_bw_share[0x20];
 
-	u8         reserved_at_100[0x700];
+	u8         reserved_at_100[0x20];
+
+	u8         reserved_at_120[0x3];
+	u8         log_meter_aso_granularity[0x5];
+	u8         reserved_at_128[0x3];
+	u8         log_meter_aso_max_alloc[0x5];
+	u8         reserved_at_130[0x3];
+	u8         log_max_num_meter_aso[0x5];
+	u8         reserved_at_138[0x8];
+
+	u8         reserved_at_140[0x6c0];
 };
 
 struct mlx5_ifc_debug_cap_bits {
@@ -1086,11 +1098,14 @@ struct mlx5_ifc_device_mem_cap_bits {
 	u8         log_sw_icm_alloc_granularity[0x6];
 	u8         log_steering_sw_icm_size[0x8];
 
-	u8         reserved_at_120[0x20];
+	u8         reserved_at_120[0x18];
+	u8         log_header_modify_pattern_sw_icm_size[0x8];
 
 	u8         header_modify_sw_icm_start_address[0x40];
 
-	u8         reserved_at_180[0x80];
+	u8         reserved_at_180[0x40];
+
+	u8         header_modify_pattern_sw_icm_start_address[0x40];
 
 	u8         memic_operations[0x20];
 
@@ -1426,7 +1441,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_120[0xa];
 	u8         log_max_ra_req_dc[0x6];
-	u8         reserved_at_130[0xa];
+	u8         reserved_at_130[0x9];
+	u8         vnic_env_cq_overrun[0x1];
 	u8         log_max_ra_res_dc[0x6];
 
 	u8         reserved_at_140[0x5];
@@ -1621,7 +1637,11 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         nic_receive_steering_discard[0x1];
 	u8         receive_discard_vport_down[0x1];
 	u8         transmit_discard_vport_down[0x1];
-	u8         reserved_at_343[0x5];
+	u8         eq_overrun_count[0x1];
+	u8         reserved_at_344[0x1];
+	u8         invalid_command_count[0x1];
+	u8         quota_exceeded_count[0x1];
+	u8         reserved_at_347[0x1];
 	u8         log_max_flow_counter_bulk[0x8];
 	u8         max_flow_counter_15_0[0x10];
 
@@ -1719,7 +1739,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   log_max_dci_errored_streams[0x5];
 	u8	   reserved_at_598[0x8];
 
-	u8         reserved_at_5a0[0x13];
+	u8         reserved_at_5a0[0x10];
+	u8         enhanced_cqe_compression[0x1];
+	u8         reserved_at_5b1[0x2];
 	u8         log_max_dek[0x5];
 	u8         reserved_at_5b8[0x4];
 	u8         mini_cqe_resp_stride_index[0x1];
@@ -3277,6 +3299,7 @@ enum {
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2 = 0x800,
 	MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT = 0x1000,
 	MLX5_FLOW_CONTEXT_ACTION_IPSEC_ENCRYPT = 0x2000,
+	MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO = 0x4000,
 };
 
 enum {
@@ -3292,6 +3315,38 @@ struct mlx5_ifc_vlan_bits {
 	u8         vid[0xc];
 };
 
+enum {
+	MLX5_FLOW_METER_COLOR_RED	= 0x0,
+	MLX5_FLOW_METER_COLOR_YELLOW	= 0x1,
+	MLX5_FLOW_METER_COLOR_GREEN	= 0x2,
+	MLX5_FLOW_METER_COLOR_UNDEFINED	= 0x3,
+};
+
+enum {
+	MLX5_EXE_ASO_FLOW_METER		= 0x2,
+};
+
+struct mlx5_ifc_exe_aso_ctrl_flow_meter_bits {
+	u8        return_reg_id[0x4];
+	u8        aso_type[0x4];
+	u8        reserved_at_8[0x14];
+	u8        action[0x1];
+	u8        init_color[0x2];
+	u8        meter_id[0x1];
+};
+
+union mlx5_ifc_exe_aso_ctrl {
+	struct mlx5_ifc_exe_aso_ctrl_flow_meter_bits exe_aso_ctrl_flow_meter;
+};
+
+struct mlx5_ifc_execute_aso_bits {
+	u8        valid[0x1];
+	u8        reserved_at_1[0x7];
+	u8        aso_object_id[0x18];
+
+	union mlx5_ifc_exe_aso_ctrl exe_aso_ctrl;
+};
+
 struct mlx5_ifc_flow_context_bits {
 	struct mlx5_ifc_vlan_bits push_vlan;
 
@@ -3323,7 +3378,9 @@ struct mlx5_ifc_flow_context_bits {
 
 	struct mlx5_ifc_fte_match_param_bits match_value;
 
-	u8         reserved_at_1200[0x600];
+	struct mlx5_ifc_execute_aso_bits execute_aso[4];
+
+	u8         reserved_at_1300[0x500];
 
 	union mlx5_ifc_dest_format_struct_flow_counter_list_auto_bits destination[];
 };
@@ -3391,11 +3448,21 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
 
 	u8         transmit_discard_vport_down[0x40];
 
-	u8         reserved_at_140[0xa0];
+	u8         async_eq_overrun[0x20];
+
+	u8         comp_eq_overrun[0x20];
+
+	u8         reserved_at_180[0x20];
+
+	u8         invalid_command[0x20];
+
+	u8         quota_exceeded_command[0x20];
 
 	u8         internal_rq_out_of_buffer[0x20];
 
-	u8         reserved_at_200[0xe00];
+	u8         cq_overrun[0x20];
+
+	u8         reserved_at_220[0xde0];
 };
 
 struct mlx5_ifc_traffic_counter_bits {
@@ -4074,7 +4141,8 @@ struct mlx5_ifc_cqc_bits {
 	u8         cqe_comp_en[0x1];
 	u8         mini_cqe_res_format[0x2];
 	u8         st[0x4];
-	u8         reserved_at_18[0x8];
+	u8         reserved_at_18[0x6];
+	u8         cqe_compression_layout[0x2];
 
 	u8         reserved_at_20[0x20];
 
@@ -5970,7 +6038,9 @@ struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 
 	u8         obj_id[0x20];
 
-	u8         reserved_at_60[0x20];
+	u8         reserved_at_60[0x3];
+	u8         log_obj_range[0x5];
+	u8         reserved_at_68[0x18];
 };
 
 struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
@@ -11370,12 +11440,14 @@ enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = BIT_ULL(0x24),
 };
 
 enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
+	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
 };
 
 enum {
@@ -11448,6 +11520,61 @@ struct mlx5_ifc_create_encryption_key_in_bits {
 	struct mlx5_ifc_encryption_key_obj_bits encryption_key_object;
 };
 
+enum {
+	MLX5_FLOW_METER_MODE_BYTES_IP_LENGTH		= 0x0,
+	MLX5_FLOW_METER_MODE_BYTES_CALC_WITH_L2		= 0x1,
+	MLX5_FLOW_METER_MODE_BYTES_CALC_WITH_L2_IPG	= 0x2,
+	MLX5_FLOW_METER_MODE_NUM_PACKETS		= 0x3,
+};
+
+struct mlx5_ifc_flow_meter_parameters_bits {
+	u8         valid[0x1];
+	u8         bucket_overflow[0x1];
+	u8         start_color[0x2];
+	u8         both_buckets_on_green[0x1];
+	u8         reserved_at_5[0x1];
+	u8         meter_mode[0x2];
+	u8         reserved_at_8[0x18];
+
+	u8         reserved_at_20[0x20];
+
+	u8         reserved_at_40[0x3];
+	u8         cbs_exponent[0x5];
+	u8         cbs_mantissa[0x8];
+	u8         reserved_at_50[0x3];
+	u8         cir_exponent[0x5];
+	u8         cir_mantissa[0x8];
+
+	u8         reserved_at_60[0x20];
+
+	u8         reserved_at_80[0x3];
+	u8         ebs_exponent[0x5];
+	u8         ebs_mantissa[0x8];
+	u8         reserved_at_90[0x3];
+	u8         eir_exponent[0x5];
+	u8         eir_mantissa[0x8];
+
+	u8         reserved_at_a0[0x60];
+};
+
+struct mlx5_ifc_flow_meter_aso_obj_bits {
+	u8         modify_field_select[0x40];
+
+	u8         reserved_at_40[0x40];
+
+	u8         reserved_at_80[0x8];
+	u8         meter_aso_access_pd[0x18];
+
+	u8         reserved_at_a0[0x160];
+
+	struct mlx5_ifc_flow_meter_parameters_bits flow_meter_parameters[2];
+};
+
+struct mlx5_ifc_create_flow_meter_aso_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits hdr;
+	struct mlx5_ifc_flow_meter_aso_obj_bits flow_meter_aso_obj;
+};
+
 struct mlx5_ifc_sampler_obj_bits {
 	u8         modify_field_select[0x40];
 
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
