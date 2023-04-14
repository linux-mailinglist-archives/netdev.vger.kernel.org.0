Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044B26E2C4A
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjDNWJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjDNWJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E043340F1
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E89664A8D
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5F6C4339C;
        Fri, 14 Apr 2023 22:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510185;
        bh=3x3hTi7ZXk9CEvaczLnMPQ2fQI7Ml90Fove+N7uHZMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RITvbtcGcdtVVi1tqdrnpsx6Vz4wxrTYpWZzeY79dhT/FC8SOc6+pBiqTw0J0jQyO
         mcqzeB11dbffFd8S/SDmikkV8uE6WPqKQn3U+c6QUZ3fBHPMil0hJxD3rsxezDptT8
         Vfr4JqLJB5AV57lWXAAEYULHiVcFsq4FPpkXjtT60ZQLClaxXQSECrtVYWYOUhkNCL
         rgYSYxDpsiuF73UJKAgqssiPFNCMuElA3Xldeg7q/EGgoxwVTL/eatNUTfBAy92xUW
         Q7nxFyb4JG7wa9zvPIC9kg7T+kDAyq9Pq0DrArXH8ljnYepTrix6ODAfz96NkC9r1C
         VK54FqmaWn5yg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 05/15] net/mlx5: DR, Add create/destroy for modify-header-argument general object
Date:   Fri, 14 Apr 2023 15:09:29 -0700
Message-Id: <20230414220939.136865-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add functions for creation/destruction of the new type of general object.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      | 43 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  6 +++
 2 files changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index e2cbc2b5bc27..3835ba3f4dda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -693,6 +693,49 @@ int mlx5dr_cmd_query_gid(struct mlx5_core_dev *mdev, u8 vhca_port_num,
 	return 0;
 }
 
+int mlx5dr_cmd_create_modify_header_arg(struct mlx5_core_dev *dev,
+					u16 log_obj_range, u32 pd,
+					u32 *obj_id)
+{
+	u32 in[MLX5_ST_SZ_DW(create_modify_header_arg_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
+	void *attr;
+	int ret;
+
+	attr = MLX5_ADDR_OF(create_modify_header_arg_in, in, hdr);
+	MLX5_SET(general_obj_in_cmd_hdr, attr, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, attr, obj_type,
+		 MLX5_OBJ_TYPE_HEADER_MODIFY_ARGUMENT);
+	MLX5_SET(general_obj_in_cmd_hdr, attr,
+		 op_param.create.log_obj_range, log_obj_range);
+
+	attr = MLX5_ADDR_OF(create_modify_header_arg_in, in, arg);
+	MLX5_SET(modify_header_arg, attr, access_pd, pd);
+
+	ret = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (ret)
+		return ret;
+
+	*obj_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+	return 0;
+}
+
+void mlx5dr_cmd_destroy_modify_header_arg(struct mlx5_core_dev *dev,
+					  u32 obj_id)
+{
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_OBJ_TYPE_HEADER_MODIFY_ARGUMENT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, obj_id);
+
+	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
 static int mlx5dr_cmd_set_extended_dest(struct mlx5_core_dev *dev,
 					struct mlx5dr_cmd_fte_info *fte,
 					bool *extended_dest)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 9187e9d6ea54..0075e2c7a441 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1357,6 +1357,12 @@ struct mlx5dr_cmd_gid_attr {
 int mlx5dr_cmd_query_gid(struct mlx5_core_dev *mdev, u8 vhca_port_num,
 			 u16 index, struct mlx5dr_cmd_gid_attr *attr);
 
+int mlx5dr_cmd_create_modify_header_arg(struct mlx5_core_dev *dev,
+					u16 log_obj_range, u32 pd,
+					u32 *obj_id);
+void mlx5dr_cmd_destroy_modify_header_arg(struct mlx5_core_dev *dev,
+					  u32 obj_id);
+
 struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 					       enum mlx5dr_icm_type icm_type);
 void mlx5dr_icm_pool_destroy(struct mlx5dr_icm_pool *pool);
-- 
2.39.2

