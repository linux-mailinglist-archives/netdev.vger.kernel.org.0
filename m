Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2C966DE79
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237092AbjAQNP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236974AbjAQNPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:15:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6286C38EAD;
        Tue, 17 Jan 2023 05:15:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E0DBB81606;
        Tue, 17 Jan 2023 13:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A93AC433D2;
        Tue, 17 Jan 2023 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673961307;
        bh=joH/gbrJOx8wND0UyaWC8D/AiaqpRF1Zu7zoRRqspK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9jhzYk+4VLYdH/B9QVKFKn3qED4M2hMOWRcp29Zyp7zP6wPRF47qeRfiKEEJo6qL
         UvfCmp+tvdNXq6l6sGwuAcwxesDHO7GSrB7+25vW/Q3FpvtarT2cZfpXVwaJKRIyVV
         SGEqBNPATqOva3AnASXJRsQdWyRX3hbq6Ld8c8N7ynuOfb7LWkFq7MhUQ1/i7eSgZD
         aFy/hX8ui2AJZlJ4SC9RPT+RmReiWcGJ7TkcOpnXUV938elU/lI0fdl5qfdHkFmoTe
         f5dyguhY1i5z3BKx1R2PglEfAxw2vwO8054sB59R6u7ylaLQ6a5xFYIxCpvV06KLEU
         KWaQlWgYhfhiQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v2 4/4] RDMA/mlx5: Use query_special_contexts for mkeys
Date:   Tue, 17 Jan 2023 15:14:52 +0200
Message-Id: <000236f0a9487d48809f87bcc3620a3964b2d3d3.1673960981.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673960981.git.leon@kernel.org>
References: <cover.1673960981.git.leon@kernel.org>
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

Use query_sepcial_contexts to get the correct value of mkeys such as
null_mkey, terminate_scatter_list_mkey and dump_fill_mkey, as FW will
change them in certain configurations.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cmd.c     | 45 ++++++++++++++++------------
 drivers/infiniband/hw/mlx5/cmd.h     |  3 +-
 drivers/infiniband/hw/mlx5/main.c    | 10 +++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  9 +++++-
 drivers/infiniband/hw/mlx5/odp.c     | 21 ++++---------
 drivers/infiniband/hw/mlx5/srq.c     |  2 +-
 drivers/infiniband/hw/mlx5/wr.c      |  2 +-
 7 files changed, 48 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index ff3742b0460a..1d0c8d5e745b 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -5,34 +5,41 @@
 
 #include "cmd.h"
 
-int mlx5_cmd_dump_fill_mkey(struct mlx5_core_dev *dev, u32 *mkey)
+int mlx5r_cmd_query_special_mkeys(struct mlx5_ib_dev *dev)
 {
 	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
+	bool is_terminate, is_dump, is_null;
 	int err;
 
-	MLX5_SET(query_special_contexts_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
-	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
-	if (!err)
-		*mkey = MLX5_GET(query_special_contexts_out, out,
-				 dump_fill_mkey);
-	return err;
-}
+	is_terminate = MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey);
+	is_dump = MLX5_CAP_GEN(dev->mdev, dump_fill_mkey);
+	is_null = MLX5_CAP_GEN(dev->mdev, null_mkey);
 
-int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
-{
-	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
-	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
-	int err;
+	dev->mkeys.terminate_scatter_list_mkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
+	if (!is_terminate && !is_dump && !is_null)
+		return 0;
 
 	MLX5_SET(query_special_contexts_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
-	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
-	if (!err)
-		*null_mkey = MLX5_GET(query_special_contexts_out, out,
-				      null_mkey);
-	return err;
+	err = mlx5_cmd_exec_inout(dev->mdev, query_special_contexts, in, out);
+	if (err)
+		return err;
+
+	if (is_dump)
+		dev->mkeys.dump_fill_mkey = MLX5_GET(query_special_contexts_out,
+						     out, dump_fill_mkey);
+
+	if (is_null)
+		dev->mkeys.null_mkey = cpu_to_be32(
+			MLX5_GET(query_special_contexts_out, out, null_mkey));
+
+	if (is_terminate)
+		dev->mkeys.terminate_scatter_list_mkey =
+			cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
+					     terminate_scatter_list_mkey));
+
+	return 0;
 }
 
 int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index ee46638db5de..93a971a40d11 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -37,8 +37,7 @@
 #include <linux/kernel.h>
 #include <linux/mlx5/driver.h>
 
-int mlx5_cmd_dump_fill_mkey(struct mlx5_core_dev *dev, u32 *mkey);
-int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey);
+int mlx5r_cmd_query_special_mkeys(struct mlx5_ib_dev *dev);
 int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
 			       void *out);
 int mlx5_cmd_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn, u16 uid);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8588f2fc0cba..fb0d97bd4074 100644
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
 
+	err = mlx5r_cmd_query_special_mkeys(dev);
+	if (err)
+		return err;
+
 	err = mlx5_ib_init_multiport_master(dev);
 	if (err)
 		return err;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7e1fb71bf7d4..ddb36c757074 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1051,6 +1051,13 @@ struct mlx5_port_caps {
 	u8 ext_port_cap;
 };
 
+
+struct mlx5_special_mkeys {
+	u32 dump_fill_mkey;
+	__be32 null_mkey;
+	__be32 terminate_scatter_list_mkey;
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
@@ -1081,7 +1088,6 @@ struct mlx5_ib_dev {
 
 	struct xarray		odp_mkeys;
 
-	u32			null_mkey;
 	struct mlx5_ib_flow_db	*flow_db;
 	/* protect resources needed as part of reset flow */
 	spinlock_t		reset_flow_resource_lock;
@@ -1110,6 +1116,7 @@ struct mlx5_ib_dev {
 	struct mlx5_port_caps port_caps[MLX5_MAX_PORTS];
 	u16 pkey_table_len;
 	u8 lag_ports;
+	struct mlx5_special_mkeys mkeys;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b4ebeadce67c..4998eaeadcbb 100644
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
@@ -1015,7 +1015,8 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 
 		/* receive WQE end of sg list. */
 		if (receive_queue && bcnt == 0 &&
-		    key == MLX5_TERMINATE_SCATTER_LIST_LKEY && io_virt == 0)
+		    key == dev->mkeys.terminate_scatter_list_mkey &&
+		    io_virt == 0)
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
index bcceb14a07f9..32c6643d0f7a 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -447,7 +447,7 @@ int mlx5_ib_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
 
 		if (i < srq->msrq.max_avail_gather) {
 			scat[i].byte_count = 0;
-			scat[i].lkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
+			scat[i].lkey = dev->mkeys.terminate_scatter_list_mkey;
 			scat[i].addr       = 0;
 		}
 	}
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index bc44551493e2..df1d1b0a3ef7 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -1252,7 +1252,7 @@ int mlx5_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 
 		if (i < qp->rq.max_gs) {
 			scat[i].byte_count = 0;
-			scat[i].lkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
+			scat[i].lkey = dev->mkeys.terminate_scatter_list_mkey;
 			scat[i].addr       = 0;
 		}
 
-- 
2.39.0

