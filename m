Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5F7465691
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245473AbhLATkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:40:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34070 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245160AbhLATkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:40:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B24EEB82120;
        Wed,  1 Dec 2021 19:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915F3C53FAD;
        Wed,  1 Dec 2021 19:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638387412;
        bh=2hBO0qwF3NnmmMrk5/D2fomvvu7V950hydiuKkCuDuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNJ1ynGRHJf+QxKC96ZybeGE7EjLymDb7A/FSiMyFIZiufszKQotDcsn4Fu9rI/9k
         /u+4zABNgwSSamLdSAE81ZQmcxOULlynl8Y0fPkZLiGVg8UCsULfkJuojLps9LY5Xr
         CMi8uYqn8OU0XWGcmtCe/mkYbsUIyxVKeAdvd/LAAywmJ8UHJUMHPl2M869e2yr4Nv
         a8nnferwN2KaiW621OpP6ABcw7UI9POONVx2evoWKr/miBocrd7QJ8+0RpF3TOxNLN
         0QlHLU5UNbtR5Mm9ovFrrMqNBmUrrd7du9PL+YM66YCCYt8N6KkfJ+pYbK/AYhCztY
         rJfbUH9ccoHRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 3/4] net/mlx5: Create more priorities for FDB bypass namespace
Date:   Wed,  1 Dec 2021 11:36:20 -0800
Message-Id: <20211201193621.9129-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201193621.9129-1-saeed@kernel.org>
References: <20211201193621.9129-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Create 16 flow steering priorities for FDB bypass users.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 35 +++++++++++++++----
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 9736f0dd6a49..a8671d7b7ca8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2236,7 +2236,6 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 
 	switch (type) {
 	case MLX5_FLOW_NAMESPACE_FDB:
-	case MLX5_FLOW_NAMESPACE_FDB_BYPASS:
 		if (steering->fdb_root_ns)
 			return &steering->fdb_root_ns->ns;
 		return NULL;
@@ -2252,6 +2251,10 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		if (steering->sniffer_tx_root_ns)
 			return &steering->sniffer_tx_root_ns->ns;
 		return NULL;
+	case MLX5_FLOW_NAMESPACE_FDB_BYPASS:
+		root_ns = steering->fdb_root_ns;
+		prio =  FDB_BYPASS_PATH;
+		break;
 	case MLX5_FLOW_NAMESPACE_EGRESS:
 	case MLX5_FLOW_NAMESPACE_EGRESS_KERNEL:
 		root_ns = steering->egress_root_ns;
@@ -2843,6 +2846,28 @@ static int create_fdb_fast_path(struct mlx5_flow_steering *steering)
 	return 0;
 }
 
+static int create_fdb_bypass(struct mlx5_flow_steering *steering)
+{
+	struct mlx5_flow_namespace *ns;
+	struct fs_prio *prio;
+	int i;
+
+	prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_BYPASS_PATH, 0);
+	if (IS_ERR(prio))
+		return PTR_ERR(prio);
+
+	ns = fs_create_namespace(prio, MLX5_FLOW_TABLE_MISS_ACTION_DEF);
+	if (IS_ERR(ns))
+		return PTR_ERR(ns);
+
+	for (i = 0; i < MLX5_BY_PASS_NUM_REGULAR_PRIOS; i++) {
+		prio = fs_create_prio(ns, i, 1);
+		if (IS_ERR(prio))
+			return PTR_ERR(prio);
+	}
+	return 0;
+}
+
 static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 {
 	struct fs_prio *maj_prio;
@@ -2852,12 +2877,10 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 	if (!steering->fdb_root_ns)
 		return -ENOMEM;
 
-	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_BYPASS_PATH,
-				  1);
-	if (IS_ERR(maj_prio)) {
-		err = PTR_ERR(maj_prio);
+	err = create_fdb_bypass(steering);
+	if (err)
 		goto out_err;
-	}
+
 	err = create_fdb_fast_path(steering);
 	if (err)
 		goto out_err;
-- 
2.31.1

