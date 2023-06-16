Return-Path: <netdev+bounces-11602-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D92733A9E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A93DC1C210BE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2263F1F190;
	Fri, 16 Jun 2023 20:11:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAF422609
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86988C433BA;
	Fri, 16 Jun 2023 20:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946307;
	bh=64CqY8kbcCM0EmlL6G/6EG505TtB7DUSNwlw7u5lBTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFpRQS2kYcg4fd6N7wIsUm6NiMeGXquiSzxCJGa5yglN1J0UxRNm+RGqP3hF5X18c
	 qSZO7rIIzQz1Zy5lEUdr0kgvCsAVhMtewGxyssg4RAp7yOAYuU7S3xgL7ieJkXEov5
	 5jNIcDX/OQ+9/OJxhAOjMgemyDXH+ZUgEfgb07Rn/w6SRk6kP6l5koprqWPHK5bnvd
	 XKibMkVAZctVarpmEV9EbLAMDXi6XMfx4V5tVErJIHbZtbTv9Hw2uLJ46aD/5vE+8O
	 C7m2W1r7Hkvob67kC/iTRRmcc4ldZHj3utBrsyllgZmJSa4hf23m0yYCU6mUsyngVD
	 zgmbnVC6Db+yQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>
Subject: [net-next 13/15] net/mlx5: DR, update query of HCA caps for EC VFs
Date: Fri, 16 Jun 2023 13:11:11 -0700
Message-Id: <20230616201113.45510-14-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

This change is needed to use EC VFs with metadata based steering.

There was an assumption that vport was equal to function ID. That's
not the case for EC VF functions. Adjust to function ID and set the
ec_vf_function bit accordingly.

Fixes: 9ac0b128248e ("net/mlx5: Update vport caps query/set for EC VFs")
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h       | 7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c           | 6 ------
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 60673f98de2b..c4be257c043d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -358,4 +358,11 @@ static inline bool mlx5_core_is_ec_vf_vport(const struct mlx5_core_dev *dev, u16
 
 	return (vport_num >= base_vport && vport_num < max_vport);
 }
+
+static inline int mlx5_vport_to_func_id(const struct mlx5_core_dev *dev, u16 vport, bool ec_vf_func)
+{
+	return ec_vf_func ? vport - mlx5_core_ec_vf_vport_base(dev)
+			  : vport;
+}
+
 #endif /* __MLX5_CORE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 1aa525e509f1..7491911ebcb5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -34,6 +34,7 @@ int mlx5dr_cmd_query_esw_vport_context(struct mlx5_core_dev *mdev,
 int mlx5dr_cmd_query_gvmi(struct mlx5_core_dev *mdev, bool other_vport,
 			  u16 vport_number, u16 *gvmi)
 {
+	bool ec_vf_func = other_vport ? mlx5_core_is_ec_vf_vport(mdev, vport_number) : false;
 	u32 in[MLX5_ST_SZ_DW(query_hca_cap_in)] = {};
 	int out_size;
 	void *out;
@@ -46,7 +47,8 @@ int mlx5dr_cmd_query_gvmi(struct mlx5_core_dev *mdev, bool other_vport,
 
 	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
 	MLX5_SET(query_hca_cap_in, in, other_function, other_vport);
-	MLX5_SET(query_hca_cap_in, in, function_id, vport_number);
+	MLX5_SET(query_hca_cap_in, in, function_id, mlx5_vport_to_func_id(mdev, vport_number, ec_vf_func));
+	MLX5_SET(query_hca_cap_in, in, ec_vf_function, ec_vf_func);
 	MLX5_SET(query_hca_cap_in, in, op_mod,
 		 MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE << 1 |
 		 HCA_CAP_OPMOD_GET_CUR);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 6d3984dd5b21..5a31fb47ffa5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1161,12 +1161,6 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
 
-static int mlx5_vport_to_func_id(const struct mlx5_core_dev *dev, u16 vport, bool ec_vf_func)
-{
-	return ec_vf_func ? vport - mlx5_core_ec_vf_vport_base(dev)
-			  : vport;
-}
-
 int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 vport, void *out,
 				  u16 opmod)
 {
-- 
2.40.1


