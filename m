Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E628388752
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243944AbhESGIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238653AbhESGHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E56E0613AE;
        Wed, 19 May 2021 06:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404372;
        bh=I3cc8LLXYkkBXlhnIeCETRB7y5DrX7/Cw/W0eX6fGHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbxn7rUwge/LkYi7t5mlmMg3fuMlyg/MEqoRBlyzOBEv5cHk3XIxqqDN6AIWRANSw
         G5ZC6ZmretVqU6W0J9u/Hk+dwyCHQkaDvVR9gahMp8mSfDAl9CpgwjQg6e39rU9eo8
         GajCOluT6PaZlaIQqXGFZhR6Z2pLxZ9l5D8xXgAvlSZ/ZJWRmOkYVZ49TH/gxP1noU
         h7VxXra3x6ITSlh5fPLUGDp4mjYkU9MpPZG5IA3+9pcCVQsiKmfyFmG1AvjPM+RTss
         jCWYlOBuQU5wzxBLUX0gzWWO6aGfRxO/snp7+/Deuq50dPznxMdj/Z2xB4lFL6Bsh/
         Dd5Em+3cG3cqg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 14/16] net/mlx5: Don't overwrite HCA capabilities when setting MSI-X count
Date:   Tue, 18 May 2021 23:05:21 -0700
Message-Id: <20210519060523.17875-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

During driver probe of device that has dynamic MSI-X feature enabled,
the following error is printed in some FW flavour (not released yet).

 mlx5_core 0000:06:00.0: firmware version: 4.7.4387
 mlx5_core 0000:06:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
 mlx5_core 0000:06:00.0: mlx5_cmd_check:777:(pid 70599): SET_HCA_CAP(0x109) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x0)
 mlx5_core 0000:06:00.0: set_hca_cap:622:(pid 70599): handle_hca_cap failed
 mlx5_core 0000:06:00.0: mlx5_function_setup:1045:(pid 70599): set_hca_cap failed
 mlx5_core 0000:06:00.0: probe_one:1465:(pid 70599): mlx5_init_one failed with error code -22
 mlx5_core: probe of 0000:06:00.0 failed with error -22

In order to make the setting capability of MSI-X future proof, let's
query the current capabilities first.

Fixes: 604774add516 ("net/mlx5: Dynamically assign MSI-X vectors count")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 1f907df5b3a2..c3373fb1cd7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -95,9 +95,10 @@ int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs)
 int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 			    int msix_vec_count)
 {
-	int sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	void *hca_cap = NULL, *query_cap = NULL, *cap;
 	int num_vf_msix, min_msix, max_msix;
-	void *hca_cap, *cap;
 	int ret;
 
 	num_vf_msix = MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
@@ -116,11 +117,20 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 	if (msix_vec_count > max_msix)
 		return -EOVERFLOW;
 
-	hca_cap = kzalloc(sz, GFP_KERNEL);
-	if (!hca_cap)
-		return -ENOMEM;
+	query_cap = kzalloc(query_sz, GFP_KERNEL);
+	hca_cap = kzalloc(set_sz, GFP_KERNEL);
+	if (!hca_cap || !query_cap) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = mlx5_vport_get_other_func_cap(dev, function_id, query_cap);
+	if (ret)
+		goto out;
 
 	cap = MLX5_ADDR_OF(set_hca_cap_in, hca_cap, capability);
+	memcpy(cap, MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability),
+	       MLX5_UN_SZ_BYTES(hca_cap_union));
 	MLX5_SET(cmd_hca_cap, cap, dynamic_msix_table_size, msix_vec_count);
 
 	MLX5_SET(set_hca_cap_in, hca_cap, opcode, MLX5_CMD_OP_SET_HCA_CAP);
@@ -130,7 +140,9 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 	MLX5_SET(set_hca_cap_in, hca_cap, op_mod,
 		 MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE << 1);
 	ret = mlx5_cmd_exec_in(dev, set_hca_cap, hca_cap);
+out:
 	kfree(hca_cap);
+	kfree(query_cap);
 	return ret;
 }
 
-- 
2.31.1

