Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAC74822BD
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242801AbhLaIUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60684 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242760AbhLaIUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79E3EB81D5F
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF67C36AEF;
        Fri, 31 Dec 2021 08:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938848;
        bh=8+WlqGNBuo6dY/go1zKrGhKWxfnXDdgRG1xrqx1hDbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRIbcLyHDWWfFJymHTd2V0IqaxkRKQ+rJDEuDisq0S4MM4cJ+g54beVkjFDXqD8k/
         +M4eh2QEggM4uMFfIpDvpIZfej/edon65i7+hvG6sNun5m43qJwfirI31N7BQr6zxo
         TT+Wgwd8bJdd9RVuZ3vB5BDYRAfzlDJjVb0FaHYXUgZ7id1bGXQ96kxsSMRNRSq4xv
         OEPlNc6DnE84BusGnhUxayOvo8h83T8SKUAGesT31ujNskaGTJyHmVY24iU1jQpmHB
         cDwQpz4K5tLQbwGAWwA8YsqC4tOg307m+CnyGfpAm6prpH5alKwaq7sodPCa6IMGlQ
         OjDD1JrDRBmaA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Muhammad Sammar <muhammads@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 10/16] net/mlx5: Add misc5 flow table match parameters
Date:   Fri, 31 Dec 2021 00:20:32 -0800
Message-Id: <20211231082038.106490-11-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211231082038.106490-1-saeed@kernel.org>
References: <20211231082038.106490-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Sammar <muhammads@nvidia.com>

Add support for misc5 match parameter as per HW spec, this will allow
matching on tunnel_header fields.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  2 +-
 include/linux/mlx5/device.h                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 25 ++++++++++++++++++-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h      |  2 +-
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 7711db245c63..5469b08d635f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -203,7 +203,7 @@ struct mlx5_ft_underlay_qp {
 	u32 qpn;
 };
 
-#define MLX5_FTE_MATCH_PARAM_RESERVED	reserved_at_c00
+#define MLX5_FTE_MATCH_PARAM_RESERVED	reserved_at_e00
 /* Calculate the fte_match_param length and without the reserved length.
  * Make sure the reserved field is the last.
  */
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 9c25edfd59a6..604b85dd770a 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1117,6 +1117,7 @@ enum {
 	MLX5_MATCH_MISC_PARAMETERS_2	= 1 << 3,
 	MLX5_MATCH_MISC_PARAMETERS_3	= 1 << 4,
 	MLX5_MATCH_MISC_PARAMETERS_4	= 1 << 5,
+	MLX5_MATCH_MISC_PARAMETERS_5	= 1 << 6,
 };
 
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 18b816b41545..c74c5e147cb9 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -670,6 +670,26 @@ struct mlx5_ifc_fte_match_set_misc4_bits {
 	u8         reserved_at_100[0x100];
 };
 
+struct mlx5_ifc_fte_match_set_misc5_bits {
+	u8         macsec_tag_0[0x20];
+
+	u8         macsec_tag_1[0x20];
+
+	u8         macsec_tag_2[0x20];
+
+	u8         macsec_tag_3[0x20];
+
+	u8         tunnel_header_0[0x20];
+
+	u8         tunnel_header_1[0x20];
+
+	u8         tunnel_header_2[0x20];
+
+	u8         tunnel_header_3[0x20];
+
+	u8         reserved_at_100[0x100];
+};
+
 struct mlx5_ifc_cmd_pas_bits {
 	u8         pa_h[0x20];
 
@@ -1839,7 +1859,9 @@ struct mlx5_ifc_fte_match_param_bits {
 
 	struct mlx5_ifc_fte_match_set_misc4_bits misc_parameters_4;
 
-	u8         reserved_at_c00[0x400];
+	struct mlx5_ifc_fte_match_set_misc5_bits misc_parameters_5;
+
+	u8         reserved_at_e00[0x200];
 };
 
 enum {
@@ -5977,6 +5999,7 @@ enum {
 	MLX5_QUERY_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_2 = 0x3,
 	MLX5_QUERY_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_3 = 0x4,
 	MLX5_QUERY_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_4 = 0x5,
+	MLX5_QUERY_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_5 = 0x6,
 };
 
 struct mlx5_ifc_query_flow_group_out_bits {
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index ca2372864b70..e539c84d63f1 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -252,7 +252,7 @@ enum mlx5_ib_device_query_context_attrs {
 	MLX5_IB_ATTR_QUERY_CONTEXT_RESP_UCTX = (1U << UVERBS_ID_NS_SHIFT),
 };
 
-#define MLX5_IB_DW_MATCH_PARAM 0x90
+#define MLX5_IB_DW_MATCH_PARAM 0xA0
 
 struct mlx5_ib_match_params {
 	__u32	match_params[MLX5_IB_DW_MATCH_PARAM];
-- 
2.33.1

