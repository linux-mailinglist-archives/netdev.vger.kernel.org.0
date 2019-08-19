Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFA192289
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 13:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfHSLgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 07:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfHSLgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 07:36:39 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358B72063F;
        Mon, 19 Aug 2019 11:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566214598;
        bh=QsmOmcTjeV0lKPUNon1RjJ7lGJdKTjiu790zyBEUJZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQNS+0Gq/MavRJi7SE8YdIn/LzpOkeakKIqh9+q9DkwH04knTkybIE6hnWARTZOLS
         3lopqdMUxVTOUy/EkQEWVafNUpPfdLM3Ojbh+18cGpNQx9AOlhprj0IHax/8GEgE/3
         ft+e3fQHY3ZEOFYlEysVMSxOqMpc/q61Y/dtqdw8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 3/3] RDMA/mlx5: RDMA_RX flow type support for user applications
Date:   Mon, 19 Aug 2019 14:36:26 +0300
Message-Id: <20190819113626.20284-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190819113626.20284-1-leon@kernel.org>
References: <20190819113626.20284-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Currently user applications can only steer TCP/IP(NIC RX/RX) traffic.
This patch adds RDMA_RX as a new flow type to allow the user to insert
steering rules to control RDMA traffic.
Two destinations are supported(but not set at the same time): devx
flow table object and QP.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c         | 13 +++++++++++--
 drivers/infiniband/hw/mlx5/main.c         |  7 +++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |  1 +
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index b8841355fcd5..571bb8539cdb 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -32,6 +32,9 @@ mlx5_ib_ft_type_to_namespace(enum mlx5_ib_uapi_flow_table_type table_type,
 	case MLX5_IB_UAPI_FLOW_TABLE_TYPE_FDB:
 		*namespace = MLX5_FLOW_NAMESPACE_FDB;
 		break;
+	case MLX5_IB_UAPI_FLOW_TABLE_TYPE_RDMA_RX:
+		*namespace = MLX5_FLOW_NAMESPACE_RDMA_RX;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -101,6 +104,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB && !dest_devx)
 		return -EINVAL;
 
+	/* Allow only DEVX object or QP as dest when inserting to RDMA_RX */
+	if ((fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_RDMA_RX) &&
+	    ((!dest_devx && !dest_qp) || (dest_devx && dest_qp)))
+		return -EINVAL;
+
 	if (dest_devx) {
 		devx_obj = uverbs_attr_get_obj(
 			attrs, MLX5_IB_ATTR_CREATE_FLOW_DEST_DEVX);
@@ -112,8 +120,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 		 */
 		if (!mlx5_ib_devx_is_flow_dest(devx_obj, &dest_id, &dest_type))
 			return -EINVAL;
-		/* Allow only flow table as dest when inserting to FDB */
-		if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB &&
+		/* Allow only flow table as dest when inserting to FDB or RDMA_RX */
+		if ((fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB ||
+		     fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_RDMA_RX) &&
 		    dest_type != MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE)
 			return -EINVAL;
 	} else if (dest_qp) {
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 08020affdc17..4e86212e6ea8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3963,6 +3963,11 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 		    esw_encap)
 			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 		priority = FDB_BYPASS_PATH;
+	} else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_RDMA_RX) {
+		max_table_size =
+			BIT(MLX5_CAP_FLOWTABLE_RDMA_RX(dev->mdev,
+						       log_max_ft_size));
+		priority = fs_matcher->priority;
 	}
 
 	max_table_size = min_t(int, max_table_size, MLX5_FS_MAX_ENTRIES);
@@ -3977,6 +3982,8 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 		prio = &dev->flow_db->egress_prios[priority];
 	else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB)
 		prio = &dev->flow_db->fdb;
+	else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_RDMA_RX)
+		prio = &dev->flow_db->rdma_rx[priority];
 
 	if (!prio)
 		return ERR_PTR(-EINVAL);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index cb41a7e6255a..6abfbf3a69b7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -200,6 +200,7 @@ struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	sniffer[MLX5_IB_NUM_SNIFFER_FTS];
 	struct mlx5_ib_flow_prio	egress[MLX5_IB_NUM_EGRESS_FTS];
 	struct mlx5_ib_flow_prio	fdb;
+	struct mlx5_ib_flow_prio	rdma_rx[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_flow_table		*lag_demux_ft;
 	/* Protect flow steering bypass flow tables
 	 * when add/del flow rules.
diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
index 7e9900b0e746..88b6ca70c2fe 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_verbs.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
@@ -43,6 +43,7 @@ enum mlx5_ib_uapi_flow_table_type {
 	MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_RX     = 0x0,
 	MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_TX	= 0x1,
 	MLX5_IB_UAPI_FLOW_TABLE_TYPE_FDB	= 0x2,
+	MLX5_IB_UAPI_FLOW_TABLE_TYPE_RDMA_RX	= 0x3,
 };
 
 enum mlx5_ib_uapi_flow_action_packet_reformat_type {
-- 
2.20.1

