Return-Path: <netdev+bounces-9765-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6636D72A7A7
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21101281A90
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FC31C2E;
	Sat, 10 Jun 2023 01:43:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E04C80
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D01C4339B;
	Sat, 10 Jun 2023 01:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361389;
	bh=yA+KOegna5YHk7zYDTRWLLrQa5RnTR+/w4OMZYoIHi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBccyLvRM42636CAdjj3EvGmtvMdELe8bYmi4AmDIK1LkLRV1mmbfprsKZ5K+5dv3
	 evFMgW5NcWB6PQSqiPMWdKqmgNsTlYO9HrccjXFMfJUMZRsWiTxg0m9XVfvupAhgDs
	 1vOzqGKFGf5oaf3tyc3uV8uoj293EgOF/EqTpC1kGIC3X3urIoA8RvndWUrtvNir0r
	 Bylu9EjiAyV+o9J50PeNMHNCXnhH/myHeDZpVYUcxbYXfTbaXFF5S0FWwwBKvnnHFC
	 8gtxACXs26krcOQWl/qfw+MqFymHhaMvAV6GyIFxn9aV1HhDol1VSSiw2IF1I4TNKJ
	 AvUH0ghqFw/cA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Update vport caps query/set for EC VFs
Date: Fri,  9 Jun 2023 18:42:43 -0700
Message-Id: <20230610014254.343576-5-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230610014254.343576-1-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

These functions are for query/set by vport, there was an underlying
assumption that vport was equal to function ID. That's not the case for
EC VF functions. Set the ec_vf_function bit accordingly.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  6 +++---
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 19 +++++++++++++++----
 include/linux/mlx5/vport.h                    |  2 +-
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 0e7b5c6e4020..7ca0c7a547aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -325,10 +325,10 @@ void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev, bool suspend);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
 int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
 
-int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap, u16 function_id,
+int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap, u16 vport,
 				  u16 opmod);
-#define mlx5_vport_get_other_func_general_cap(dev, fid, out)		\
-	mlx5_vport_get_other_func_cap(dev, fid, out, MLX5_CAP_GENERAL)
+#define mlx5_vport_get_other_func_general_cap(dev, vport, out)		\
+	mlx5_vport_get_other_func_cap(dev, vport, out, MLX5_CAP_GENERAL)
 
 void mlx5_events_work_enqueue(struct mlx5_core_dev *dev, struct work_struct *work);
 static inline u32 mlx5_sriov_get_vf_total_msix(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index bc66b078a8a1..6d3984dd5b21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1161,23 +1161,32 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
 
-int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out,
+static int mlx5_vport_to_func_id(const struct mlx5_core_dev *dev, u16 vport, bool ec_vf_func)
+{
+	return ec_vf_func ? vport - mlx5_core_ec_vf_vport_base(dev)
+			  : vport;
+}
+
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 vport, void *out,
 				  u16 opmod)
 {
+	bool ec_vf_func = mlx5_core_is_ec_vf_vport(dev, vport);
 	u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)] = {};
 
 	opmod = (opmod << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
 	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
 	MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
-	MLX5_SET(query_hca_cap_in, in, function_id, function_id);
+	MLX5_SET(query_hca_cap_in, in, function_id, mlx5_vport_to_func_id(dev, vport, ec_vf_func));
 	MLX5_SET(query_hca_cap_in, in, other_function, true);
+	MLX5_SET(query_hca_cap_in, in, ec_vf_function, ec_vf_func);
 	return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
 }
 EXPORT_SYMBOL_GPL(mlx5_vport_get_other_func_cap);
 
 int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap,
-				  u16 function_id, u16 opmod)
+				  u16 vport, u16 opmod)
 {
+	bool ec_vf_func = mlx5_core_is_ec_vf_vport(dev, vport);
 	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
 	void *set_hca_cap;
 	void *set_ctx;
@@ -1191,8 +1200,10 @@ int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap
 	MLX5_SET(set_hca_cap_in, set_ctx, op_mod, opmod << 1);
 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
 	memcpy(set_hca_cap, hca_cap, MLX5_ST_SZ_BYTES(cmd_hca_cap));
-	MLX5_SET(set_hca_cap_in, set_ctx, function_id, function_id);
+	MLX5_SET(set_hca_cap_in, set_ctx, function_id,
+		 mlx5_vport_to_func_id(dev, vport, ec_vf_func));
 	MLX5_SET(set_hca_cap_in, set_ctx, other_function, true);
+	MLX5_SET(set_hca_cap_in, set_ctx, ec_vf_function, ec_vf_func);
 	ret = mlx5_cmd_exec_in(dev, set_hca_cap, set_ctx);
 
 	kfree(set_ctx);
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 7f31432f44c2..fbb9bf447889 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -132,6 +132,6 @@ int mlx5_nic_vport_affiliate_multiport(struct mlx5_core_dev *master_mdev,
 int mlx5_nic_vport_unaffiliate_multiport(struct mlx5_core_dev *port_mdev);
 
 u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev);
-int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out,
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 vport, void *out,
 				  u16 opmod);
 #endif /* __MLX5_VPORT_H__ */
-- 
2.40.1


