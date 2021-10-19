Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8346432C2D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhJSDXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230390AbhJSDXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 237906135E;
        Tue, 19 Oct 2021 03:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613651;
        bh=tobzQCrtF2TybiQVUK16T8wrUYudk/5Kl69yGoJySBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gq5zjfRc22/iDaK0lL4ULpglQCH2RlPa9zCgT9Ru7Un+SnvjPWMj+LIdXYnuLe2t4
         iu4EOzcAwLIMoFRnnu2BLxoxYn4vzlxh4IpPtsjGgQNjFwzVusSO4bLyDD0g7T0RLD
         R5QXme9jhUC+ezUCuwpOHd9qr/08E91iGmEGbOTfQ0alFyI3wnrxkLCL7SG0dU6ShY
         Ow2jHEjniTec4/ydejahm8M6mVKdwBboO21L/3icWxczgmDAA/dTkrkT8hyrPpZTVu
         gm4PHwm1wWVmcntac+ytX2oFj8TtS3AoqX6O6sk3OHAmny+INb4gmj1memWPTD6XdH
         QTp7ca7uNa/Ng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/13] net/mlx5: Introduce new uplink destination type
Date:   Mon, 18 Oct 2021 20:20:38 -0700
Message-Id: <20211019032047.55660-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

The uplink destination type should be used in rules to steer the
packet to the uplink when the device is in steering based LAG mode.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c  | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c          | 8 +++++++-
 include/linux/mlx5/mlx5_ifc.h                             | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
index 87d65f6b5310..7841ef6c193c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
@@ -235,6 +235,9 @@ const char *parse_fs_dst(struct trace_seq *p,
 	const char *ret = trace_seq_buffer_ptr(p);
 
 	switch (dst->type) {
+	case MLX5_FLOW_DESTINATION_TYPE_UPLINK:
+		trace_seq_printf(p, "uplink\n");
+		break;
 	case MLX5_FLOW_DESTINATION_TYPE_VPORT:
 		trace_seq_printf(p, "vport=%u\n", dst->vport.num);
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 2c82dc118460..750b21124a1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -577,8 +577,8 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
 				id = dst->dest_attr.ft->id;
 				break;
+			case MLX5_FLOW_DESTINATION_TYPE_UPLINK:
 			case MLX5_FLOW_DESTINATION_TYPE_VPORT:
-				id = dst->dest_attr.vport.num;
 				MLX5_SET(dest_format_struct, in_dests,
 					 destination_eswitch_owner_vhca_id_valid,
 					 !!(dst->dest_attr.vport.flags &
@@ -586,6 +586,12 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				MLX5_SET(dest_format_struct, in_dests,
 					 destination_eswitch_owner_vhca_id,
 					 dst->dest_attr.vport.vhca_id);
+				if (type == MLX5_FLOW_DESTINATION_TYPE_UPLINK) {
+					/* destination_id is reserved */
+					id = 0;
+					break;
+				}
+				id = dst->dest_attr.vport.num;
 				if (extended_dest &&
 				    dst->dest_attr.vport.pkt_reformat) {
 					MLX5_SET(dest_format_struct, in_dests,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8f41145bc6ef..09e43019d877 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1766,6 +1766,7 @@ enum mlx5_flow_destination_type {
 	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE   = 0x1,
 	MLX5_FLOW_DESTINATION_TYPE_TIR          = 0x2,
 	MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER = 0x6,
+	MLX5_FLOW_DESTINATION_TYPE_UPLINK       = 0x8,
 
 	MLX5_FLOW_DESTINATION_TYPE_PORT         = 0x99,
 	MLX5_FLOW_DESTINATION_TYPE_COUNTER      = 0x100,
-- 
2.31.1

