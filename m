Return-Path: <netdev+bounces-9770-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C32D272A7B5
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:46:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F9B2280E4B
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF4679E3;
	Sat, 10 Jun 2023 01:43:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEEE6FCB
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04248C43444;
	Sat, 10 Jun 2023 01:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361395;
	bh=5Tydcx7r5wASz6K3yHPeFKHwl6UXOEDqmgMxwgXR3N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CV7vy9K0c/8s/YK5a6hynJs49T1UISByQMWOV8d7JX0VXL2Bsqke4Ja24ZmJgR/e4
	 itu5jATWXoDD64lIR1Ty6XlHeY9SdW6Bj9V144+R4wt+FPN+3J6bP8xBSY5dmIFJnZ
	 JN5HExhuRNzkdGbaRcoJEcIaoymmhIAdK0Bl53FCQSVc2N+sO0z7eLbt+LREcEeBp6
	 D70Vidtb0gkv83jPsNEf+kzvqsS6aAcFYXlrcz/gyKLdmJH3EvqmCleNepZEBn92WD
	 77EkrgUl/WuH5EwywxVihyzhjdOk4IaAVT3rTSe6dq+3SXoqkVQl3EZdz2jHWe0l9S
	 IjTDxmmjbfFLA==
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
Subject: [net-next 09/15] net/mlx5: Query correct caps for min msix vectors
Date: Fri,  9 Jun 2023 18:42:48 -0700
Message-Id: <20230610014254.343576-10-saeed@kernel.org>
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

The VFs on the host and the embedded CPU platform share function
numbers. Set the ec_vf_function field to query the caps for the correct
function.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c    | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 843da89a9035..b2dbae763ca6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -41,6 +41,15 @@ struct mlx5_irq_table {
 	struct mlx5_irq_pool *sf_comp_pool;
 };
 
+static int mlx5_core_func_to_vport(const struct mlx5_core_dev *dev,
+				   int func,
+				   bool ec_vf_func)
+{
+	if (!ec_vf_func)
+		return func;
+	return mlx5_core_ec_vf_vport_base(dev) + func - 1;
+}
+
 /**
  * mlx5_get_default_msix_vec_count - Get the default number of MSI-X vectors
  *                                   to be ssigned to each VF.
@@ -79,6 +88,8 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
 	void *hca_cap = NULL, *query_cap = NULL, *cap;
 	int num_vf_msix, min_msix, max_msix;
+	bool ec_vf_function;
+	int vport;
 	int ret;
 
 	num_vf_msix = MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
@@ -104,7 +115,9 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 		goto out;
 	}
 
-	ret = mlx5_vport_get_other_func_general_cap(dev, function_id, query_cap);
+	ec_vf_function = mlx5_core_ec_sriov_enabled(dev);
+	vport = mlx5_core_func_to_vport(dev, function_id, ec_vf_function);
+	ret = mlx5_vport_get_other_func_general_cap(dev, vport, query_cap);
 	if (ret)
 		goto out;
 
@@ -115,6 +128,7 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 
 	MLX5_SET(set_hca_cap_in, hca_cap, opcode, MLX5_CMD_OP_SET_HCA_CAP);
 	MLX5_SET(set_hca_cap_in, hca_cap, other_function, 1);
+	MLX5_SET(set_hca_cap_in, hca_cap, ec_vf_function, ec_vf_function);
 	MLX5_SET(set_hca_cap_in, hca_cap, function_id, function_id);
 
 	MLX5_SET(set_hca_cap_in, hca_cap, op_mod,
-- 
2.40.1


