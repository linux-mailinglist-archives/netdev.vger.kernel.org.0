Return-Path: <netdev+bounces-5208-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7903710379
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A365D281489
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F17E6FBF;
	Thu, 25 May 2023 03:49:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E1E7494
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79790C4339B;
	Thu, 25 May 2023 03:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986550;
	bh=dGQp9w+Mn7l5EayM+qBdGCEUVOFtORZAZgQlhsphHb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUVLpS0dTNA1prXjAitwxAxdfnQms/UpDsyGuZRCq8SAz9RR8Lkx9sEBvXSV83YeC
	 spFVKjrKMLRP6ybLV66U0Ow7O+gfiSzfvIm2RYWocv8uu0270RchLQVs0hjGRPI1h8
	 m2y5lOkJYneO9EoIioQYrj+03RJHEaRC3tqSoY6mbm2xygzXM+CDXsNN7d2BqT7YRk
	 l98j/spKaNPJ4JH4/o+9MImt/PiGB3CRyQdQGZQb9FSahy2wy+kBuKc1lTlDkN/A48
	 ySxpy13WPYrjpFGxJZMBBQ3n5s3lgwiSB+MeeCDNjYhTIgWWkf4nlrg27xFVL1hWfK
	 JZRAPGTf+lAag==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>
Subject: [net 08/17] net/mlx5e: Use query_special_contexts cmd only once per mdev
Date: Wed, 24 May 2023 20:48:38 -0700
Message-Id: <20230525034847.99268-9-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

Don't query the firmware so many times (num rqs * num wqes * wqe frags)
because it slows down linearly the interface creation time when the
product is larger. Do it only once per mdev and store the result in
mlx5e_param.

Due to helper function being called from different files, move it to
an appropriate location. Rename the function with a proper prefix and
add a small cleanup.

This fix applies only for legacy rq.

Fixes: 1b1e4868836a ("net/mlx5e: Use query_special_contexts for mkeys")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 24 +++----------------
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 21 ++++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 4 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b8987a404d75..8e999f238194 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -327,6 +327,7 @@ struct mlx5e_params {
 	unsigned int sw_mtu;
 	int hard_mtu;
 	bool ptp_rx;
+	__be32 terminate_lkey_be;
 };
 
 static inline u8 mlx5e_get_dcb_num_tc(struct mlx5e_params *params)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2944691f06ad..0235adcbc609 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -727,26 +727,6 @@ static void mlx5e_rq_free_shampo(struct mlx5e_rq *rq)
 	mlx5e_rq_shampo_hd_free(rq);
 }
 
-static __be32 mlx5e_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
-{
-	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
-	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
-	int res;
-
-	if (!MLX5_CAP_GEN(dev, terminate_scatter_list_mkey))
-		return MLX5_TERMINATE_SCATTER_LIST_LKEY;
-
-	MLX5_SET(query_special_contexts_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
-	res = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
-	if (res)
-		return MLX5_TERMINATE_SCATTER_LIST_LKEY;
-
-	res = MLX5_GET(query_special_contexts_out, out,
-		       terminate_scatter_list_mkey);
-	return cpu_to_be32(res);
-}
-
 static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
 			  struct mlx5e_rq_param *rqp,
@@ -908,7 +888,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			/* check if num_frags is not a pow of two */
 			if (rq->wqe.info.num_frags < (1 << rq->wqe.info.log_num_frags)) {
 				wqe->data[f].byte_count = 0;
-				wqe->data[f].lkey = mlx5e_get_terminate_scatter_list_mkey(mdev);
+				wqe->data[f].lkey = params->terminate_lkey_be;
 				wqe->data[f].addr = 0;
 			}
 		}
@@ -5007,6 +4987,8 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	/* RQ */
 	mlx5e_build_rq_params(mdev, params);
 
+	params->terminate_lkey_be = mlx5_core_get_terminate_scatter_list_mkey(mdev);
+
 	params->packet_merge.timeout = mlx5e_choose_lro_timeout(mdev, MLX5E_DEFAULT_LRO_TIMEOUT);
 
 	/* CQ moderation params */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 9d735c343a3b..678f0be81375 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -32,6 +32,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/qp.h>
 #include "mlx5_core.h"
 
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev, u32 *mkey, u32 *in,
@@ -122,3 +123,23 @@ int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num)
 	return mlx5_cmd_exec_in(dev, destroy_psv, in);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_psv);
+
+__be32 mlx5_core_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
+	u32 mkey;
+
+	if (!MLX5_CAP_GEN(dev, terminate_scatter_list_mkey))
+		return MLX5_TERMINATE_SCATTER_LIST_LKEY;
+
+	MLX5_SET(query_special_contexts_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
+	if (mlx5_cmd_exec_inout(dev, query_special_contexts, in, out))
+		return MLX5_TERMINATE_SCATTER_LIST_LKEY;
+
+	mkey = MLX5_GET(query_special_contexts_out, out,
+			terminate_scatter_list_mkey);
+	return cpu_to_be32(mkey);
+}
+EXPORT_SYMBOL(mlx5_core_get_terminate_scatter_list_mkey);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a4c4f737f9c1..94d2be5848ae 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1093,6 +1093,7 @@ void mlx5_cmdif_debugfs_cleanup(struct mlx5_core_dev *dev);
 int mlx5_core_create_psv(struct mlx5_core_dev *dev, u32 pdn,
 			 int npsvs, u32 *sig_index);
 int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num);
+__be32 mlx5_core_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev);
 void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common);
 int mlx5_query_odp_caps(struct mlx5_core_dev *dev,
 			struct mlx5_odp_caps *odp_caps);
-- 
2.40.1


