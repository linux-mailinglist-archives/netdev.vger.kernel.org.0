Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1D25B108C
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiIGXhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiIGXh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797BDBC826;
        Wed,  7 Sep 2022 16:37:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D4FD61B0C;
        Wed,  7 Sep 2022 23:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB195C433C1;
        Wed,  7 Sep 2022 23:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593840;
        bh=sY6CxC+K5JQu+Q3NE7YUKZg+4zTcsuGp+sFy/YUCQOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzWzbFW+NNUYrvevoUNRxcJQ2eiWyS3o+5uqdN15C97YvQzs7ZsTZza54o3ghQqAt
         Dgg9zv+PMhpWnT6dftQWyO+IPPGRCg/eFq0AzB7WeDX8GBTKbkVIKFNm4oLaQFRDe3
         YlKcSy24qSrfd193ydVHHs8U7wnc3cZrSJimV5Ndk82SKVQuKOfwMykXONqiC27v0D
         Je4mVxq1x7ep+xQiwS/EnaeG/9gAYCFBPcCm7JXPEU5HVMTmSv0xnS01bUuAMgvHrn
         u4GkGDwASyiKoMC4hk0/TuXNFSqZDILVmlnJm6VioBSI5ze2O2S2b44XwSuF8fMVKO
         vX5mUTXWG68FQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH mlx5-next 13/14] net/mlx5: Add IFC bits for general obj create param
Date:   Wed,  7 Sep 2022 16:36:35 -0700
Message-Id: <20220907233636.388475-14-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907233636.388475-1-saeed@kernel.org>
References: <20220907233636.388475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

Before this patch, the log_obj_range was defined inside
general_obj_in_cmd_hdr to support bulk allocation. However, we need to
modify/query one of the object in the bulk in later patch, so change
those fields to param bits for parameters specific for cmd header, and
add general_obj_create_param according to what was updated in spec.
We will also add general_obj_query_param for modify/query later.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c |  6 ++++--
 include/linux/mlx5/mlx5_ifc.h                         | 11 ++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index a53e205f4a89..b51fa590cdf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -199,13 +199,15 @@ mlx5e_flow_meter_create_aso_obj(struct mlx5e_flow_meters *flow_meters, int *obj_
 	u32 in[MLX5_ST_SZ_DW(create_flow_meter_aso_obj_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	struct mlx5_core_dev *mdev = flow_meters->mdev;
-	void *obj;
+	void *obj, *param;
 	int err;
 
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
 		 MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO);
-	MLX5_SET(general_obj_in_cmd_hdr, in, log_obj_range, flow_meters->log_granularity);
+	param = MLX5_ADDR_OF(general_obj_in_cmd_hdr, in, op_param);
+	MLX5_SET(general_obj_create_param, param, log_obj_range,
+		 flow_meters->log_granularity);
 
 	obj = MLX5_ADDR_OF(create_flow_meter_aso_obj_in, in, flow_meter_aso_obj);
 	MLX5_SET(flow_meter_aso_obj, obj, meter_aso_access_pd, flow_meters->pdn);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fac675418541..396b73383e58 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -6085,6 +6085,13 @@ struct mlx5_ifc_match_definer_bits {
 	u8         match_mask[16][0x20];
 };
 
+struct mlx5_ifc_general_obj_create_param_bits {
+	u8         alias_object[0x1];
+	u8         reserved_at_1[0x2];
+	u8         log_obj_range[0x5];
+	u8         reserved_at_8[0x18];
+};
+
 struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 	u8         opcode[0x10];
 	u8         uid[0x10];
@@ -6094,9 +6101,7 @@ struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 
 	u8         obj_id[0x20];
 
-	u8         reserved_at_60[0x3];
-	u8         log_obj_range[0x5];
-	u8         reserved_at_68[0x18];
+	struct mlx5_ifc_general_obj_create_param_bits op_param;
 };
 
 struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
-- 
2.37.2

