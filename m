Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C531265E9D1
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbjAELYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbjAELYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:24:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D5B50156;
        Thu,  5 Jan 2023 03:24:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F4F5CE1AB9;
        Thu,  5 Jan 2023 11:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2B1C43396;
        Thu,  5 Jan 2023 11:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672917846;
        bh=iDRv36a7kvHSWk4d9VFpT6ngWFV5rk3U/v7U93b9UKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsUcSy9RGhQPtCoU9QekJsnN2WXz9swxsAfQjFGmDsaauYFzo03sHU8cwXprGlQGy
         Bwg1EsPByKhB+mA3vIVtWEbizBka0QjpJG1Lusaz+/gSjUg6mMmgHXh84R8WSw+RSA
         4rhfDGKvKCw5CeXhtnWBJHm2CY7a00v9w7ht1t+h7OvceOiHRS/O2pafcEnB8Py3Ee
         1PG5iQ8PuB1QsyNdslH7+wg8yGf8dJ8GNLrnFHCGY4b+c3wqx6NdoXqeWIcaHb1PC2
         iyoWconcoNzLkHvkUeW33gSJcLhI8YNlmFNge8LV/0JIGVSnPBg90yyc1FISi0NjZt
         AjegLgi74i7Jw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v1 4/4] RDMA/mlx5: Use query_special_contexts for mkeys
Date:   Thu,  5 Jan 2023 13:23:48 +0200
Message-Id: <77e7a5d09ef4adbba92446f230348a2e5b81964a.1672917578.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672917578.git.leonro@nvidia.com>
References: <cover.1672917578.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Har-Toov <ohartoov@nvidia.com>

Using query_sepcial_contexts to get the correct value of mkeys such as
null_mkey, terminate_scatter_list_mkey and dump_fill_mkey, as FW will
change them in some configurations.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cmd.c     | 30 ++++++++++------------------
 drivers/infiniband/hw/mlx5/cmd.h     |  3 +--
 drivers/infiniband/hw/mlx5/main.c    | 10 +++++-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  8 +++++++-
 drivers/infiniband/hw/mlx5/odp.c     | 21 ++++++-------------
 drivers/infiniband/hw/mlx5/srq.c     |  2 +-
 drivers/infiniband/hw/mlx5/wr.c      |  2 +-
 7 files changed, 32 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index ff3742b0460a..97c52b7745a7 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -5,7 +5,7 @@
 
 #include "cmd.h"
 
-int mlx5_cmd_dump_fill_mkey(struct mlx5_core_dev *dev, u32 *mkey)
+int mlx5_cmd_query_special_mkeys(struct mlx5_ib_dev *dev)
 {
 	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
@@ -13,26 +13,18 @@ int mlx5_cmd_dump_fill_mkey(struct mlx5_core_dev *dev, u32 *mkey)
 
 	MLX5_SET(query_special_contexts_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
-	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
-	if (!err)
-		*mkey = MLX5_GET(query_special_contexts_out, out,
-				 dump_fill_mkey);
-	return err;
-}
+	err = mlx5_cmd_exec_inout(dev->mdev, query_special_contexts, in, out);
+	if (err)
+		return err;
 
-int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
-{
-	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
-	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
-	int err;
+	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey))
+		dev->mkeys.dump_fill_mkey = MLX5_GET(query_special_contexts_out,
+						     out, dump_fill_mkey);
 
-	MLX5_SET(query_special_contexts_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
-	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
-	if (!err)
-		*null_mkey = MLX5_GET(query_special_contexts_out, out,
-				      null_mkey);
-	return err;
+	if (MLX5_CAP_GEN(dev->mdev, null_mkey))
+		dev->mkeys.null_mkey = cpu_to_be32(
+			MLX5_GET(query_special_contexts_out, out, null_mkey));
+	return 0;
 }
 
 int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index ee46638db5de..79ccd7dfa67a 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -37,8 +37,7 @@
 #include <linux/kernel.h>
 #include <linux/mlx5/driver.h>
 
-int mlx5_cmd_dump_fill_mkey(struct mlx5_core_dev *dev, u32 *mkey);
-int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey);
+int mlx5_cmd_query_special_mkeys(struct mlx5_ib_dev *dev);
 int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
 			       void *out);
 int mlx5_cmd_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn, u16 uid);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c669ef6e47e7..12e8bf99a40e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1756,13 +1756,9 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_ucontext *context = to_mucontext(uctx);
 	struct mlx5_bfreg_info *bfregi = &context->bfregi;
-	int err;
 
 	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey)) {
-		err = mlx5_cmd_dump_fill_mkey(dev->mdev,
-					      &resp->dump_fill_mkey);
-		if (err)
-			return err;
+		resp->dump_fill_mkey = dev->mkeys.dump_fill_mkey;
 		resp->comp_mask |=
 			MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DUMP_FILL_MKEY;
 	}
@@ -3634,6 +3630,10 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 		dev->port[i].roce.last_port_state = IB_PORT_DOWN;
 	}
 
+	err = mlx5_cmd_query_special_mkeys(dev);
+	if (err)
+		return err;
+
 	err = mlx5_ib_init_multiport_master(dev);
 	if (err)
 		return err;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 093aa69af0ef..fc2c49b3cb39 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1051,6 +1051,12 @@ struct mlx5_port_caps {
 	u8 ext_port_cap;
 };
 
+
+struct mlx5_special_mkeys {
+	u32 dump_fill_mkey;
+	__be32 null_mkey;
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
@@ -1081,7 +1087,6 @@ struct mlx5_ib_dev {
 
 	struct xarray		odp_mkeys;
 
-	u32			null_mkey;
 	struct mlx5_ib_flow_db	*flow_db;
 	/* protect resources needed as part of reset flow */
 	spinlock_t		reset_flow_resource_lock;
@@ -1110,6 +1115,7 @@ struct mlx5_ib_dev {
 	struct mlx5_port_caps port_caps[MLX5_MAX_PORTS];
 	u16 pkey_table_len;
 	u8 lag_ports;
+	struct mlx5_special_mkeys mkeys;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b4ebeadce67c..d39f9c86563d 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -104,7 +104,7 @@ static void populate_klm(struct mlx5_klm *pklm, size_t idx, size_t nentries,
 	if (flags & MLX5_IB_UPD_XLT_ZAP) {
 		for (; pklm != end; pklm++, idx++) {
 			pklm->bcount = cpu_to_be32(MLX5_IMR_MTT_SIZE);
-			pklm->key = cpu_to_be32(mr_to_mdev(imr)->null_mkey);
+			pklm->key = mr_to_mdev(imr)->mkeys.null_mkey;
 			pklm->va = 0;
 		}
 		return;
@@ -137,7 +137,7 @@ static void populate_klm(struct mlx5_klm *pklm, size_t idx, size_t nentries,
 			pklm->key = cpu_to_be32(mtt->ibmr.lkey);
 			pklm->va = cpu_to_be64(idx * MLX5_IMR_MTT_SIZE);
 		} else {
-			pklm->key = cpu_to_be32(mr_to_mdev(imr)->null_mkey);
+			pklm->key = mr_to_mdev(imr)->mkeys.null_mkey;
 			pklm->va = 0;
 		}
 	}
@@ -984,6 +984,7 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 				   void *wqe_end, u32 *bytes_mapped,
 				   u32 *total_wqe_bytes, bool receive_queue)
 {
+	struct mlx5_core_dev *mdev = dev->mdev;
 	int ret = 0, npages = 0;
 	u64 io_virt;
 	__be32 key;
@@ -1015,7 +1016,7 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 
 		/* receive WQE end of sg list. */
 		if (receive_queue && bcnt == 0 &&
-		    key == MLX5_TERMINATE_SCATTER_LIST_LKEY && io_virt == 0)
+		    key == mdev->terminate_scatter_list_mkey && io_virt == 0)
 			break;
 
 		if (!inline_segment && total_wqe_bytes) {
@@ -1615,25 +1616,15 @@ static const struct ib_device_ops mlx5_ib_dev_odp_ops = {
 
 int mlx5_ib_odp_init_one(struct mlx5_ib_dev *dev)
 {
-	int ret = 0;
-
 	internal_fill_odp_caps(dev);
 
 	if (!(dev->odp_caps.general_caps & IB_ODP_SUPPORT))
-		return ret;
+		return 0;
 
 	ib_set_device_ops(&dev->ib_dev, &mlx5_ib_dev_odp_ops);
 
-	if (dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT) {
-		ret = mlx5_cmd_null_mkey(dev->mdev, &dev->null_mkey);
-		if (ret) {
-			mlx5_ib_err(dev, "Error getting null_mkey %d\n", ret);
-			return ret;
-		}
-	}
-
 	mutex_init(&dev->odp_eq_mutex);
-	return ret;
+	return 0;
 }
 
 void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *dev)
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index bcceb14a07f9..52ffcc4859f7 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -447,7 +447,7 @@ int mlx5_ib_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
 
 		if (i < srq->msrq.max_avail_gather) {
 			scat[i].byte_count = 0;
-			scat[i].lkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
+			scat[i].lkey = mdev->terminate_scatter_list_mkey;
 			scat[i].addr       = 0;
 		}
 	}
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index bc44551493e2..57609545154a 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -1252,7 +1252,7 @@ int mlx5_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 
 		if (i < qp->rq.max_gs) {
 			scat[i].byte_count = 0;
-			scat[i].lkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
+			scat[i].lkey = mdev->terminate_scatter_list_mkey;
 			scat[i].addr       = 0;
 		}
 
-- 
2.38.1

