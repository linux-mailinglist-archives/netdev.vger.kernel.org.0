Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85A1ADFAB
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 21:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405885AbfIITvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 15:51:19 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:45409 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731163AbfIITvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 15:51:18 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MHGPA-1huCGt3SO8-00DIaQ; Mon, 09 Sep 2019 21:51:03 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] mlx5: fix type mismatch
Date:   Mon,  9 Sep 2019 21:50:09 +0200
Message-Id: <20190909195024.3268499-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190909195024.3268499-1-arnd@arndb.de>
References: <20190909195024.3268499-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:PcLYB5EynGg7nP72mzY6LT+H2emjpHAtDVecs5FMWdYr1xIOf36
 UxMZc47Smdk6LsNpYdbshbKA/JEPYc3mxKRVdU4o9MuxelAdu4hAvJNktUZVKp6/VISZNyN
 Mx27M8gQvQR/p5uQLfLF1Gj6DKSoBzPD2IFMCdKMaj662hbzPN8IHQeXF5/r5+m4szD+tIh
 7l62FjgiK8f8JLL7KeD7Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wnkiAefwb7k=:Qqul2Y3iOiGmrr9YJOxYdl
 XDPWPXmmdrzLym7phg8Z31+b3k9v6IGWIgS+DASqYyHJg1gWcCVzHN/SMfaYjKyzOR49o+Kkl
 f3g2gY9REmXZEPxsGh1u8oERc6qLGEcnCD0hCbDRmatiTpE5JmyoPV3dQ3pMSkaaT5PfF9iEu
 EVne0hTGpVaSzbgp9f3ztxoAWkg9JASSuD+Ylv7E+C77R6iqJkNetNfu+qXKo8z1oVEO9bzyR
 3UWwX4s0imlugmvkcrfMuSpPQ17nU+Zu1ef6fKvEBkJi59F5TImKXFgNfM0BOXT6ve0oWlwng
 BAZnOjRqyB4zK9Q2sxkfa231VruiYgsc5cJekUzNg1OnoRPxxV0T0LsR/S2PlpofYP2dIINTX
 KTm/FU5Rib3tHmo1RNIKcdGn1UNoXTegBsLhaCkkaxYP1QCPNSwha2XVbW/3SdpMWxEnPpfvS
 mc63Gz8FXPTT2KubymxxjiysaYE7HvlX4+gRN4NOlsfKQAnytyFnmKQGfthffCmacyAPv6V1H
 DSa15Q2OBSdyv/uvFxQgO9rmHVZ7Ae9bi+kkDj1sNy5ah8LIjNUdRa/t/TjjCT9jBy6C2Ls6o
 /9ZsOo4O2IHoi9h5OxvlEy5P8rKaqKRZfutb7UVm9ftMCExJ+2pLOZMASvV5U34oyJ0QUKNfZ
 r6yNiRKp7HTbEvf2o3MnEQHrdsZhhD7cKpetFhsxYjiZN2PHv8CPebhGhBof5ITy+ErvOFMAj
 kei2UOMJJXoZdhrarj9QgEN4uupud+LoHdOxEG6ZNG87mEPpsQKjI6QoY0rD+ERw5XadDK7P6
 SaTJYfy9rhrstTD1h1REtVNCR3bbQar/MEGqW701GZnQyS7tkA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mlx5, pointers to 'phys_addr_t' and 'u64' are mixed since the addition
of the pool memory allocator, leading to incorrect behavior on 32-bit
architectures and this compiler warning:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c:121:8: error: incompatible pointer types passing 'u64 *' (aka 'unsigned long long *') to parameter of type 'phys_addr_t *' (aka 'unsigned int *') [-Werror,-Wincompatible-pointer-types]
                                   &icm_mr->dm.addr, &icm_mr->dm.obj_id);
                                   ^~~~~~~~~~~~~~~~
include/linux/mlx5/driver.h:1092:39: note: passing argument to parameter 'addr' here
                         u64 length, u16 uid, phys_addr_t *addr, u32 *obj_id);

Change the code to use 'u64' consistently in place of 'phys_addr_t' to
fix this. The alternative of using phys_addr_t more would require a larger
rework.

Fixes: 29cf8febd185 ("net/mlx5: DR, ICM pool memory allocator")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/hw/mlx5/cmd.c                 | 4 ++--
 drivers/infiniband/hw/mlx5/cmd.h                 | 4 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h             | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c | 4 ++--
 include/linux/mlx5/driver.h                      | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 4937947400cd..fbcad70ef6dc 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -82,7 +82,7 @@ int mlx5_cmd_modify_cong_params(struct mlx5_core_dev *dev,
 	return mlx5_cmd_exec(dev, in, in_size, out, sizeof(out));
 }
 
-int mlx5_cmd_alloc_memic(struct mlx5_dm *dm, phys_addr_t *addr,
+int mlx5_cmd_alloc_memic(struct mlx5_dm *dm, u64 *addr,
 			 u64 length, u32 alignment)
 {
 	struct mlx5_core_dev *dev = dm->dev;
@@ -157,7 +157,7 @@ int mlx5_cmd_alloc_memic(struct mlx5_dm *dm, phys_addr_t *addr,
 	return -ENOMEM;
 }
 
-int mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr, u64 length)
+int mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, u64 addr, u64 length)
 {
 	struct mlx5_core_dev *dev = dm->dev;
 	u64 hw_start_addr = MLX5_CAP64_DEV_MEM(dev, memic_bar_start_addr);
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index 169cab4915e3..2ea7a45a6abb 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -44,9 +44,9 @@ int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
 int mlx5_cmd_query_ext_ppcnt_counters(struct mlx5_core_dev *dev, void *out);
 int mlx5_cmd_modify_cong_params(struct mlx5_core_dev *mdev,
 				void *in, int in_size);
-int mlx5_cmd_alloc_memic(struct mlx5_dm *dm, phys_addr_t *addr,
+int mlx5_cmd_alloc_memic(struct mlx5_dm *dm, u64 *addr,
 			 u64 length, u32 alignment);
-int mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr, u64 length);
+int mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, u64 addr, u64 length);
 void mlx5_cmd_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn, u16 uid);
 void mlx5_cmd_destroy_tir(struct mlx5_core_dev *dev, u32 tirn, u16 uid);
 void mlx5_cmd_destroy_tis(struct mlx5_core_dev *dev, u32 tisn, u16 uid);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2ceaef3ea3fb..476d4447f901 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -561,7 +561,7 @@ enum mlx5_ib_mtt_access_flags {
 
 struct mlx5_ib_dm {
 	struct ib_dm		ibdm;
-	phys_addr_t		dev_addr;
+	u64			dev_addr;
 	u32			type;
 	size_t			size;
 	union {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
index e065c2f68f5a..ad4d7484fa63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
@@ -90,7 +90,7 @@ void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
 }
 
 int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
-			 u64 length, u16 uid, phys_addr_t *addr, u32 *obj_id)
+			 u64 length, u16 uid, u64 *addr, u32 *obj_id)
 {
 	u32 num_blocks = DIV_ROUND_UP_ULL(length, MLX5_SW_ICM_BLOCK_SIZE(dev));
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
@@ -175,7 +175,7 @@ int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
 EXPORT_SYMBOL_GPL(mlx5_dm_sw_icm_alloc);
 
 int mlx5_dm_sw_icm_dealloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
-			   u64 length, u16 uid, phys_addr_t addr, u32 obj_id)
+			   u64 length, u16 uid, u64 addr, u32 obj_id)
 {
 	u32 num_blocks = DIV_ROUND_UP_ULL(length, MLX5_SW_ICM_BLOCK_SIZE(dev));
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 3e80f03a387f..e07f9daf7d42 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1089,9 +1089,9 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 struct mlx5_uars_page *mlx5_get_uars_page(struct mlx5_core_dev *mdev);
 void mlx5_put_uars_page(struct mlx5_core_dev *mdev, struct mlx5_uars_page *up);
 int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
-			 u64 length, u16 uid, phys_addr_t *addr, u32 *obj_id);
+			 u64 length, u16 uid, u64 *addr, u32 *obj_id);
 int mlx5_dm_sw_icm_dealloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
-			   u64 length, u16 uid, phys_addr_t addr, u32 obj_id);
+			   u64 length, u16 uid, u64 addr, u32 obj_id);
 
 #ifdef CONFIG_MLX5_CORE_IPOIB
 struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
-- 
2.20.0

