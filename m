Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C99682296
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjAaDMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjAaDMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4164699
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE59FB8196F
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908E3C433EF;
        Tue, 31 Jan 2023 03:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134728;
        bh=AwBkwbeD+Ls7W7JnV5rDlJQJicc1LgdrKhDI9SITxIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kv9Os3wBQPbCWn6DI4EVWVC017dvcCh2nUAzTPBuE2URmLqsH+NP4YRYquh/zVc2Y
         OhpFytz/YgH9+2fzPbz1iGGP0rECZGKo6eSEiKYy46ozsBUKJxuobvCBfH++psK2S7
         iSfngWpcxbKJPo/wXdLu1jCvN72iM1ULkhDfE/cFVTrvdUi4ozFCzF/k+7JCOLrQQG
         QLoxjSuR3a9StEtYjlZw6YovzZ3CVpf7ffbO5pdQ1uAbG/f535igHqN9C3dif0rmjr
         B7qICV3452zkGQmPYC5/foLzo4Wi9mxEWjWW8gCl+Ri6jkr9Q+yxM74pFPodSHuziM
         oGARL9Nb9yTow==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Add IFC bits for general obj create param
Date:   Mon, 30 Jan 2023 19:11:48 -0800
Message-Id: <20230131031201.35336-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131031201.35336-1-saeed@kernel.org>
References: <20230131031201.35336-1-saeed@kernel.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

Before this patch, the log_obj_range was defined inside
general_obj_in_cmd_hdr to support bulk allocation. However, we need to
modify/query one of the object in the bulk in later patch, so change
those fields to param bits for parameters specific for cmd header, and
add general_obj_create_param according to what was updated in spec.
We will also add general_obj_query_param for modify/query later.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c |  6 ++++--
 include/linux/mlx5/mlx5_ifc.h                         | 11 ++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index 7758a425bfa8..8218c892b161 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -204,13 +204,15 @@ mlx5e_flow_meter_create_aso_obj(struct mlx5e_flow_meters *flow_meters, int *obj_
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
index 0b102c651fe2..17e293ceb625 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -6196,6 +6196,13 @@ struct mlx5_ifc_match_definer_bits {
 	};
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
@@ -6205,9 +6212,7 @@ struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 
 	u8         obj_id[0x20];
 
-	u8         reserved_at_60[0x3];
-	u8         log_obj_range[0x5];
-	u8         reserved_at_68[0x18];
+	struct mlx5_ifc_general_obj_create_param_bits op_param;
 };
 
 struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
-- 
2.39.1

