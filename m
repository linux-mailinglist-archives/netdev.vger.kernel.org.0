Return-Path: <netdev+bounces-11594-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B93E4733A8F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E99091C2107E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED6F200CF;
	Fri, 16 Jun 2023 20:11:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98221F160
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B302C433CB;
	Fri, 16 Jun 2023 20:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946296;
	bh=xiEBLwiQ8T6PnKp6Od4+Fsn8rWyCP3TuHiu+zOGeZ4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVdWiSuuC0VRTGuhh+zWfe4YP3hWR0tswsUJT5+afQxDnwPhBMKjgtD96sLWxdqEZ
	 +aF5CdUEeqpFuK255y4xRZcAlm3BnlqW3xIr0BoqxUth7Bliz+ChSZro6ZfImZnF59
	 YP5DDaNhkI7Xa2K7boBtrj0vOyFOGhoPbV0A4o+L7VtR9w658qJ+h3DMPr/awGEZxK
	 ftUNQjfNpPiyGC7EJXgipNSXan4bvo8QpiWCWYD6zUabbBI7y5TNqR3F0xDVyVk07U
	 ZzfXC9WwvbQUxDCmbCSU72AfuKmrRadZnNBY9dDsiv2Q51UGn18gHzGSf/lLtT33Ud
	 hQhd7FqKEHTQA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Create eswitch debugfs root directory
Date: Fri, 16 Jun 2023 13:11:03 -0700
Message-Id: <20230616201113.45510-6-saeed@kernel.org>
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

From: Vlad Buslov <vladbu@nvidia.com>

Following patch in series uses the new directory for bridge FDB debugfs.
The new directory is intended for all future eswitch-specific debugfs
files.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 2af9c4646bc7..5aaedbf71783 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/debugfs.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/mlx5/vport.h>
@@ -1765,6 +1766,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	esw->manager_vport = mlx5_eswitch_manager_vport(dev);
 	esw->first_host_vport = mlx5_eswitch_first_host_vport_num(dev);
 
+	esw->debugfs_root = debugfs_create_dir("esw", mlx5_debugfs_get_dev_root(dev));
 	esw->work_queue = create_singlethread_workqueue("mlx5_esw_wq");
 	if (!esw->work_queue) {
 		err = -ENOMEM;
@@ -1818,6 +1820,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 abort:
 	if (esw->work_queue)
 		destroy_workqueue(esw->work_queue);
+	debugfs_remove_recursive(esw->debugfs_root);
 	kfree(esw);
 unregister_param:
 	devl_params_unregister(priv_to_devlink(dev), mlx5_eswitch_params,
@@ -1844,6 +1847,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	mutex_destroy(&esw->offloads.decap_tbl_lock);
 	esw_offloads_cleanup(esw);
 	mlx5_esw_vports_cleanup(esw);
+	debugfs_remove_recursive(esw->debugfs_root);
 	kfree(esw);
 	devl_params_unregister(priv_to_devlink(esw->dev), mlx5_eswitch_params,
 			       ARRAY_SIZE(mlx5_eswitch_params));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 266b60fefe25..bcbab06759c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -304,6 +304,8 @@ enum {
 	MLX5_ESW_FDB_CREATED = BIT(0),
 };
 
+struct dentry;
+
 struct mlx5_eswitch {
 	struct mlx5_core_dev    *dev;
 	struct mlx5_nb          nb;
@@ -312,6 +314,7 @@ struct mlx5_eswitch {
 	struct hlist_head       mc_table[MLX5_L2_ADDR_HASH_SIZE];
 	struct esw_mc_addr mc_promisc;
 	/* end of legacy */
+	struct dentry *debugfs_root;
 	struct workqueue_struct *work_queue;
 	struct xarray vports;
 	u32 flags;
-- 
2.40.1


