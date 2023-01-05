Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FB465E494
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjAEESw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjAEESf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:18:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440123F12C;
        Wed,  4 Jan 2023 20:18:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C34D4B8198C;
        Thu,  5 Jan 2023 04:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D329C433F0;
        Thu,  5 Jan 2023 04:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672892298;
        bh=iTX+61shDiS83d+w4LmfMVuNSLLqJKR7/KFXinYRwIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXXf0kwxf+QUK/2ULrRDKxPIxt26hKWuzxuFAJOqeuWxM0pjCLi6M1+M+GisGOkqf
         N61n13ti8prkUwYERGCfoM/7qkkpe47TlfUxPUH2yw3OkSw0xdGS3ukM7x3KMWv0JX
         NN5S5W6GrQQWQ1EjTEmO7uwGXFmqCZhWd5gHM1VH54vz5cBHU77GaLNIEEfLxXjDOy
         HBEuXNsjG2QSIVvutVReawYrr2nNb9+5Qk8oiiSbGW0IUz0sVTSs51eMyrXAuI6wIT
         /Yc1TkfAfKIoDGTkudwbcsTkKK3SqMyVLkZCn/KpBN64fPqaGCz9gcWusANUEp44Hd
         qgvmzBRROkF9Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>
Subject: [PATCH mlx5-next 5/8] net/mlx5: Implement new destination type TABLE_TYPE
Date:   Wed,  4 Jan 2023 20:17:53 -0800
Message-Id: <20230105041756.677120-6-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105041756.677120-1-saeed@kernel.org>
References: <20230105041756.677120-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

Implement new destination type to support flow transition between
different table types.
e.g. from NIC_RX to RDMA_RX or from RDMA_TX to NIC_TX.
The new destination is described in the tracepoint as follows:
"mlx5_fs_add_rule: rule=00000000d53cd0ed fte=0000000048a8a6ed index=0 sw_action=<> [dst] flow_table_type=7 id:262152"

Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c    | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c            | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c           | 3 ++-
 include/linux/mlx5/fs.h                                     | 1 +
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
index 2732128e7a6e..6d73127b7217 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
@@ -275,6 +275,10 @@ const char *parse_fs_dst(struct trace_seq *p,
 				 fs_dest_range_field_to_str(dst->range.field),
 				 dst->range.min, dst->range.max);
 		break;
+	case MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE:
+		trace_seq_printf(p, "flow_table_type=%u id:%u\n", dst->ft->type,
+				 dst->ft->id);
+		break;
 	case MLX5_FLOW_DESTINATION_TYPE_NONE:
 		trace_seq_printf(p, "none\n");
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 32d4c967469c..a3a9cc6f15ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -653,6 +653,12 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				id = dst->dest_attr.sampler_id;
 				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_SAMPLER;
 				break;
+			case MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE:
+				MLX5_SET(dest_format_struct, in_dests,
+					 destination_table_type, dst->dest_attr.ft->type);
+				id = dst->dest_attr.ft->id;
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_TABLE_TYPE;
+				break;
 			default:
 				id = dst->dest_attr.tir_num;
 				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_TIR;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 5a85d8c1e797..2333f835fb70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -449,7 +449,8 @@ static bool is_fwd_dest_type(enum mlx5_flow_destination_type type)
 		type == MLX5_FLOW_DESTINATION_TYPE_VPORT ||
 		type == MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER ||
 		type == MLX5_FLOW_DESTINATION_TYPE_TIR ||
-		type == MLX5_FLOW_DESTINATION_TYPE_RANGE;
+		type == MLX5_FLOW_DESTINATION_TYPE_RANGE ||
+		type == MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE;
 }
 
 static bool check_valid_spec(const struct mlx5_flow_spec *spec)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index ba6958b49a8e..1d2a0638ae74 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -51,6 +51,7 @@ enum mlx5_flow_destination_type {
 	MLX5_FLOW_DESTINATION_TYPE_COUNTER,
 	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM,
 	MLX5_FLOW_DESTINATION_TYPE_RANGE,
+	MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE,
 };
 
 enum {
-- 
2.38.1

