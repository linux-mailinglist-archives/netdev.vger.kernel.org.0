Return-Path: <netdev+bounces-9768-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56EC772A7B0
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12BDD280E4B
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5412C6FA5;
	Sat, 10 Jun 2023 01:43:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C8B4C98
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98444C433AF;
	Sat, 10 Jun 2023 01:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361392;
	bh=zTjcJNbw0EzkkitYJ9pOafBskBk4B5wZUeROqEVXVPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grlCF4VmLWbtWBt7fB7MjCgA7xM2WMW44oyW7mLDJZWTkkbTCnXqDBSp1hhpLL2HA
	 igehDibOdmh0hmjatRxu3kyU4nvszULZ8buhWFIfk74BOIehNmKTnZtvH7z5WoooNW
	 EFlSsQjnB8MFpuNTQVtRw5m/IB5WXSg0d8S9l8NPHgbH9091gHmdobV1J67BotNQgi
	 rIInJ98hunLVX9reVnGiB9QcWpUxTbR7SKyrlcW2XM7Mop3ovJ/ME4jjtasVD5px6n
	 CvwCcuZeXobWyb/PaLFUYOVPjF7YEl31Udue8Q2JjPENDnBHJ6f9oescpCMDlPVqg2
	 H4poMUouzz+5A==
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
Subject: [net-next 07/15] net/mlx5: Add new page type for EC VF pages
Date: Fri,  9 Jun 2023 18:42:46 -0700
Message-Id: <20230610014254.343576-8-saeed@kernel.org>
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

When the embedded cpu supports SRIOV it can be enabled and disabled
independently from the host SRIOV. Track the pages separately so we can
properly wait for returned VF pages.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 11 ++++++++++-
 include/linux/mlx5/driver.h                         |  1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index bb95b40d25eb..fc13b41cc9b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -246,6 +246,7 @@ void mlx5_pages_debugfs_init(struct mlx5_core_dev *dev)
 
 	debugfs_create_u32("fw_pages_total", 0400, pages, &dev->priv.fw_pages);
 	debugfs_create_u32("fw_pages_vfs", 0400, pages, &dev->priv.page_counters[MLX5_VF]);
+	debugfs_create_u32("fw_pages_ec_vfs", 0400, pages, &dev->priv.page_counters[MLX5_EC_VF]);
 	debugfs_create_u32("fw_pages_sfs", 0400, pages, &dev->priv.page_counters[MLX5_SF]);
 	debugfs_create_u32("fw_pages_host_pf", 0400, pages, &dev->priv.page_counters[MLX5_HOST_PF]);
 	debugfs_create_u32("fw_pages_alloc_failed", 0400, pages, &dev->priv.fw_pages_alloc_failed);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 95dc67fb3001..dcf58efac159 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -79,7 +79,13 @@ static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_funct
 	if (!func_id)
 		return mlx5_core_is_ecpf(dev) && !ec_function ? MLX5_HOST_PF : MLX5_PF;
 
-	return func_id <= mlx5_core_max_vfs(dev) ?  MLX5_VF : MLX5_SF;
+	if (func_id <= max(mlx5_core_max_vfs(dev), mlx5_core_max_ec_vfs(dev))) {
+		if (ec_function)
+			return MLX5_EC_VF;
+		else
+			return MLX5_VF;
+	}
+	return MLX5_SF;
 }
 
 static u32 mlx5_get_ec_function(u32 function)
@@ -730,6 +736,9 @@ int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev)
 	WARN(dev->priv.page_counters[MLX5_HOST_PF],
 	     "External host PF FW pages counter is %d after reclaiming all pages\n",
 	     dev->priv.page_counters[MLX5_HOST_PF]);
+	WARN(dev->priv.page_counters[MLX5_EC_VF],
+	     "EC VFs FW pages counter is %d after reclaiming all pages\n",
+	     dev->priv.page_counters[MLX5_EC_VF]);
 
 	return 0;
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 252b6a6965b8..18a608a1f567 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -581,6 +581,7 @@ enum mlx5_func_type {
 	MLX5_VF,
 	MLX5_SF,
 	MLX5_HOST_PF,
+	MLX5_EC_VF,
 	MLX5_FUNC_TYPE_NUM,
 };
 
-- 
2.40.1


