Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA46E4D3C33
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238432AbiCIVjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiCIVjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1F554BC7
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D0FAB823DA
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F44C340F6;
        Wed,  9 Mar 2022 21:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861889;
        bh=ymWzFyc9zPiIbh0LnrpJnwmLOZwhUe0cD1K8g/DQBiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4AXBnZI4GO08VSMIjyV9dxffIHbjydTqj9lx96Dla/CQPUF+AMvmvyAyiclWgJSe
         fjroPWs+oRTnOc95HyFYyX4biBXb6Z+oC+Xk/Cj/di9UVTehZgWPIv5N7bMQqNOpgb
         ED/BXyQ04MhdWnHTWWvolt+bU8V0pRrUzLPkKRQgyt/NcwZ6rKPb+TH5aPY/bQPbdJ
         KfQtG5MpqlRvW0Y3/Odc7k5jh1yzHjk13zVDGPeiBRCd/bJTfbONK8NfKEyqZUtttC
         ZsZrsrVlI0r9Ma1qHs8mwG7/BKtG0s4EnJzSZSVfGQOXdUX0CUlpt/5y5KpXt1o4g2
         Y5FFRTPHAY4nw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/16] net/mlx5: Add pages debugfs
Date:   Wed,  9 Mar 2022 13:37:47 -0800
Message-Id: <20220309213755.610202-9-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Add pages debugfs to expose the following counters for debuggability:
fw_pages_total - How many pages were given to FW and not returned yet.
vfs_pages - For SRIOV, how many pages were given to FW for virtual
functions usage.
host_pf_pages - For ECPF, how many pages were given to FW for external
hosts physical functions usage.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/debugfs.c   | 17 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c |  2 ++
 include/linux/mlx5/driver.h                     |  9 ++++++---
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 883e44457367..8673ba2df910 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -212,6 +212,23 @@ void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev)
 	debugfs_remove_recursive(dev->priv.dbg.cq_debugfs);
 }
 
+void mlx5_pages_debugfs_init(struct mlx5_core_dev *dev)
+{
+	struct dentry *pages;
+
+	dev->priv.dbg.pages_debugfs = debugfs_create_dir("pages", dev->priv.dbg.dbg_root);
+	pages = dev->priv.dbg.pages_debugfs;
+
+	debugfs_create_u32("fw_pages_total", 0400, pages, &dev->priv.fw_pages);
+	debugfs_create_u32("fw_pages_vfs", 0400, pages, &dev->priv.vfs_pages);
+	debugfs_create_u32("fw_pages_host_pf", 0400, pages, &dev->priv.host_pf_pages);
+}
+
+void mlx5_pages_debugfs_cleanup(struct mlx5_core_dev *dev)
+{
+	debugfs_remove_recursive(dev->priv.dbg.pages_debugfs);
+}
+
 static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 			 int index, int *is_str)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index d29a305858ad..8855fe71d480 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -714,12 +714,14 @@ int mlx5_pagealloc_init(struct mlx5_core_dev *dev)
 		return -ENOMEM;
 
 	xa_init(&dev->priv.page_root_xa);
+	mlx5_pages_debugfs_init(dev);
 
 	return 0;
 }
 
 void mlx5_pagealloc_cleanup(struct mlx5_core_dev *dev)
 {
+	mlx5_pages_debugfs_cleanup(dev);
 	xa_destroy(&dev->priv.page_root_xa);
 	destroy_workqueue(dev->priv.pg_wq);
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index aa539d245a12..c5f93b5910ed 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -557,6 +557,7 @@ struct mlx5_debugfs_entries {
 	struct dentry *eq_debugfs;
 	struct dentry *cq_debugfs;
 	struct dentry *cmdif_debugfs;
+	struct dentry *pages_debugfs;
 };
 
 struct mlx5_ft_pool;
@@ -569,11 +570,11 @@ struct mlx5_priv {
 	struct mlx5_nb          pg_nb;
 	struct workqueue_struct *pg_wq;
 	struct xarray           page_root_xa;
-	int			fw_pages;
+	u32			fw_pages;
 	atomic_t		reg_pages;
 	struct list_head	free_list;
-	int			vfs_pages;
-	int			host_pf_pages;
+	u32			vfs_pages;
+	u32			host_pf_pages;
 
 	struct mlx5_core_health health;
 	struct list_head	traps;
@@ -1026,6 +1027,8 @@ int mlx5_pagealloc_init(struct mlx5_core_dev *dev);
 void mlx5_pagealloc_cleanup(struct mlx5_core_dev *dev);
 void mlx5_pagealloc_start(struct mlx5_core_dev *dev);
 void mlx5_pagealloc_stop(struct mlx5_core_dev *dev);
+void mlx5_pages_debugfs_init(struct mlx5_core_dev *dev);
+void mlx5_pages_debugfs_cleanup(struct mlx5_core_dev *dev);
 void mlx5_core_req_pages_handler(struct mlx5_core_dev *dev, u16 func_id,
 				 s32 npages, bool ec_function);
 int mlx5_satisfy_startup_pages(struct mlx5_core_dev *dev, int boot);
-- 
2.35.1

