Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2068B46568C
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245430AbhLATkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:40:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34048 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbhLATkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:40:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 960DAB820F1;
        Wed,  1 Dec 2021 19:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D335C53FCC;
        Wed,  1 Dec 2021 19:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638387410;
        bh=kc5/OleVC6fEtlPhvq/xyc1UpZEv5YKknWvWDA4gvg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvhinP9GFlxWiFJqOm1r0sCPlDn9ljLffM1uC71aTXIOgcbxrmfR3so8Zz8Qud1Da
         NXtUdnrtqZrS2gzhYTt7Mpuc9bbtKV4oprZY6BoMww29ZiYqsYTl4eLuwfMtkBdz19
         /xJd/vX7ovZVhguoX0m3IWlc2dURYtfE5S+u6D4ZUlRCjw3plZg+2ScWiGuuAW/BBF
         AUGz4YlRAu6Th7XAahQdmmQ1EWoozq6eKCWzpPGxS0OrKmxW3/P5MEOfhnAcDWhvLz
         1r4EKrUDB+S7u3OHfknZvoNb2L7vPiIbg9kWxFekTAUyMTLSc2Mzc6Jp7drMQTH9Yi
         hMkeJhRKDTVCw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 1/4] net/mlx5: Separate FDB namespace
Date:   Wed,  1 Dec 2021 11:36:18 -0800
Message-Id: <20211201193621.9129-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201193621.9129-1-saeed@kernel.org>
References: <20211201193621.9129-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

This patch doesn't add an additional namespaces, but just separates the
naming to be used by each FDB user, bypass and kernel.
Downstream patches will actually split this up and allow to have more
than single priority for the bypass users.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/fs.c                   | 14 +++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |  1 +
 include/linux/mlx5/fs.h                           |  1 +
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index b780185d9dc6..510ef85ef6e4 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -1508,7 +1508,7 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 		    !esw_encap)
 			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 		break;
-	case MLX5_FLOW_NAMESPACE_FDB:
+	case MLX5_FLOW_NAMESPACE_FDB_BYPASS:
 		max_table_size = BIT(
 			MLX5_CAP_ESW_FLOWTABLE_FDB(dev->mdev, log_max_ft_size));
 		if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev->mdev, decap) && esw_encap)
@@ -1546,7 +1546,7 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 	case MLX5_FLOW_NAMESPACE_EGRESS:
 		prio = &dev->flow_db->egress_prios[priority];
 		break;
-	case MLX5_FLOW_NAMESPACE_FDB:
+	case MLX5_FLOW_NAMESPACE_FDB_BYPASS:
 		prio = &dev->flow_db->fdb;
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_RX:
@@ -1937,7 +1937,7 @@ mlx5_ib_ft_type_to_namespace(enum mlx5_ib_uapi_flow_table_type table_type,
 		*namespace = MLX5_FLOW_NAMESPACE_EGRESS;
 		break;
 	case MLX5_IB_UAPI_FLOW_TABLE_TYPE_FDB:
-		*namespace = MLX5_FLOW_NAMESPACE_FDB;
+		*namespace = MLX5_FLOW_NAMESPACE_FDB_BYPASS;
 		break;
 	case MLX5_IB_UAPI_FLOW_TABLE_TYPE_RDMA_RX:
 		*namespace = MLX5_FLOW_NAMESPACE_RDMA_RX;
@@ -2029,8 +2029,8 @@ static int get_dests(struct uverbs_attr_bundle *attrs,
 	}
 
 	/* Allow only DEVX object, drop as dest for FDB */
-	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB && !(dest_devx ||
-	     (*flags & MLX5_IB_ATTR_CREATE_FLOW_FLAGS_DROP)))
+	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB_BYPASS &&
+	    !(dest_devx || (*flags & MLX5_IB_ATTR_CREATE_FLOW_FLAGS_DROP)))
 		return -EINVAL;
 
 	/* Allow only DEVX object or QP as dest when inserting to RDMA_RX */
@@ -2050,7 +2050,7 @@ static int get_dests(struct uverbs_attr_bundle *attrs,
 		if (!is_flow_dest(devx_obj, dest_id, dest_type))
 			return -EINVAL;
 		/* Allow only flow table as dest when inserting to FDB or RDMA_RX */
-		if ((fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB ||
+		if ((fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB_BYPASS ||
 		     fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_RDMA_RX) &&
 		    *dest_type != MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE)
 			return -EINVAL;
@@ -2320,7 +2320,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	if (err)
 		goto end;
 
-	if (obj->ns_type == MLX5_FLOW_NAMESPACE_FDB &&
+	if (obj->ns_type == MLX5_FLOW_NAMESPACE_FDB_BYPASS &&
 	    mlx5_eswitch_mode(dev->mdev) != MLX5_ESWITCH_OFFLOADS) {
 		err = -EINVAL;
 		goto end;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 750b21124a1a..762b9730a897 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -788,7 +788,8 @@ static int mlx5_cmd_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns,
 	int err;
 	u32 *in;
 
-	if (namespace == MLX5_FLOW_NAMESPACE_FDB)
+	if (namespace == MLX5_FLOW_NAMESPACE_FDB ||
+	    namespace == MLX5_FLOW_NAMESPACE_FDB_BYPASS)
 		max_encap_size = MLX5_CAP_ESW(dev, max_encap_header_size);
 	else
 		max_encap_size = MLX5_CAP_FLOWTABLE(dev, max_encap_header_size);
@@ -860,6 +861,7 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 
 	switch (namespace) {
 	case MLX5_FLOW_NAMESPACE_FDB:
+	case MLX5_FLOW_NAMESPACE_FDB_BYPASS:
 		max_actions = MLX5_CAP_ESW_FLOWTABLE_FDB(dev, max_modify_header_actions);
 		table_type = FS_FT_FDB;
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 386ab9a2d490..2d26e16a67cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2220,6 +2220,7 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 
 	switch (type) {
 	case MLX5_FLOW_NAMESPACE_FDB:
+	case MLX5_FLOW_NAMESPACE_FDB_BYPASS:
 		if (steering->fdb_root_ns)
 			return &steering->fdb_root_ns->ns;
 		return NULL;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index cd2d4c572367..b1aad14689e3 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -73,6 +73,7 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_KERNEL,
 	MLX5_FLOW_NAMESPACE_LEFTOVERS,
 	MLX5_FLOW_NAMESPACE_ANCHOR,
+	MLX5_FLOW_NAMESPACE_FDB_BYPASS,
 	MLX5_FLOW_NAMESPACE_FDB,
 	MLX5_FLOW_NAMESPACE_ESW_EGRESS,
 	MLX5_FLOW_NAMESPACE_ESW_INGRESS,
-- 
2.31.1

