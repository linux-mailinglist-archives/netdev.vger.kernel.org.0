Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0F0647A95
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLIAOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLIAOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029CE85D08
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69BDCB826A7
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD8AC433F0;
        Fri,  9 Dec 2022 00:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544873;
        bh=Kg5SQSxm46HsYvmseVusitgq8u975F6YboGFddqML44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gta9k6qiEHgFAyc2KAA7gWbjQvJ9wQ0voBGI8J5HGuvs51NJLug0yp9r4BpOYjSRI
         klbXMD6ZEJ3iuWMna08lUQX/LF8sEWeDwI3KHXRosqS206PLjMZlP3Y4OgeqU532qx
         86ryAW31Ifh53HUacznnP8S5Ia/WK36jgSsfN5zU6fWteuT3hGAhwiwoMlIQcO5Yo6
         M/zb2mYpZDY3UsmOVsHaWkN+DQMN7l1IJMKPdqUCKjkQJiRAl7eFI2Qol+zqh63Kdw
         rs+UbUIbJIJZUrk08S+9JUhdgw44onCkc391/AHoHicRwVHMA6C83Mg3cSPfvNkyvL
         GIQcchvqFzTvw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 03/15] net/mlx5: DR, Add functions to create/destroy MATCH_DEFINER general object
Date:   Thu,  8 Dec 2022 16:14:08 -0800
Message-Id: <20221209001420.142794-4-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

SW steering is able to match only on the exact values of the packet fields,
as requested by the user: the user provides mask for the fields that are of
interest, and the exact values to be matched on when the traffic is handled.

Match Definer is a general FW object that defines which fields in the
packet will be referenced by the mask and tag of each STE. Match definer ID
is part of STE fields, and it defines how the HW needs to interpret the STE's
mask/tag values.
Till now SW steering used the definers that were managed by FW and implemented
the STE layout as described by the HW spec. Now that we're adding a new type
of STE, SW steering needs to define for the HW how it should interpret this
new STE's layout.
This is done with a programmable match definer.

The programmable definer allows to selects which fields will be included in
the definer, and their layout: it has up to 9 DW selectors 8 Byte selectors.
Each selector indicates a DW/Byte worth of fields out of the table that
is defined by HW spec by referencing the offset of the required DW/Byte.

This patch adds dr_cmd function to create and destroy MATCH_DEFINER
general object.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      | 77 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  9 +++
 2 files changed, 86 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index b4739eafc180..07b6a6dcb92f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -564,6 +564,83 @@ void mlx5dr_cmd_destroy_reformat_ctx(struct mlx5_core_dev *mdev,
 	mlx5_cmd_exec_in(mdev, dealloc_packet_reformat_context, in);
 }
 
+static void dr_cmd_set_definer_format(void *ptr, u16 format_id,
+				      u8 *dw_selectors,
+				      u8 *byte_selectors)
+{
+	if (format_id != MLX5_IFC_DEFINER_FORMAT_ID_SELECT)
+		return;
+
+	MLX5_SET(match_definer, ptr, format_select_dw0, dw_selectors[0]);
+	MLX5_SET(match_definer, ptr, format_select_dw1, dw_selectors[1]);
+	MLX5_SET(match_definer, ptr, format_select_dw2, dw_selectors[2]);
+	MLX5_SET(match_definer, ptr, format_select_dw3, dw_selectors[3]);
+	MLX5_SET(match_definer, ptr, format_select_dw4, dw_selectors[4]);
+	MLX5_SET(match_definer, ptr, format_select_dw5, dw_selectors[5]);
+	MLX5_SET(match_definer, ptr, format_select_dw6, dw_selectors[6]);
+	MLX5_SET(match_definer, ptr, format_select_dw7, dw_selectors[7]);
+	MLX5_SET(match_definer, ptr, format_select_dw8, dw_selectors[8]);
+
+	MLX5_SET(match_definer, ptr, format_select_byte0, byte_selectors[0]);
+	MLX5_SET(match_definer, ptr, format_select_byte1, byte_selectors[1]);
+	MLX5_SET(match_definer, ptr, format_select_byte2, byte_selectors[2]);
+	MLX5_SET(match_definer, ptr, format_select_byte3, byte_selectors[3]);
+	MLX5_SET(match_definer, ptr, format_select_byte4, byte_selectors[4]);
+	MLX5_SET(match_definer, ptr, format_select_byte5, byte_selectors[5]);
+	MLX5_SET(match_definer, ptr, format_select_byte6, byte_selectors[6]);
+	MLX5_SET(match_definer, ptr, format_select_byte7, byte_selectors[7]);
+}
+
+int mlx5dr_cmd_create_definer(struct mlx5_core_dev *mdev,
+			      u16 format_id,
+			      u8 *dw_selectors,
+			      u8 *byte_selectors,
+			      u8 *match_mask,
+			      u32 *definer_id)
+{
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
+	u32 in[MLX5_ST_SZ_DW(create_match_definer_in)] = {};
+	void *ptr;
+	int err;
+
+	ptr = MLX5_ADDR_OF(create_match_definer_in, in,
+			   general_obj_in_cmd_hdr);
+	MLX5_SET(general_obj_in_cmd_hdr, ptr, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, ptr, obj_type,
+		 MLX5_OBJ_TYPE_MATCH_DEFINER);
+
+	ptr = MLX5_ADDR_OF(create_match_definer_in, in, obj_context);
+	MLX5_SET(match_definer, ptr, format_id, format_id);
+
+	dr_cmd_set_definer_format(ptr, format_id,
+				  dw_selectors, byte_selectors);
+
+	ptr = MLX5_ADDR_OF(match_definer, ptr, match_mask);
+	memcpy(ptr, match_mask, MLX5_FLD_SZ_BYTES(match_definer, match_mask));
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	*definer_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+
+	return 0;
+}
+
+void
+mlx5dr_cmd_destroy_definer(struct mlx5_core_dev *mdev, u32 definer_id)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_OBJ_TYPE_MATCH_DEFINER);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, definer_id);
+
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
 int mlx5dr_cmd_query_gid(struct mlx5_core_dev *mdev, u8 vhca_port_num,
 			 u16 index, struct mlx5dr_cmd_gid_attr *attr)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 41a37b9ac98b..772ee747511f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -81,6 +81,7 @@ mlx5dr_icm_next_higher_chunk(enum mlx5dr_icm_chunk_size chunk)
 enum {
 	DR_STE_SIZE = 64,
 	DR_STE_SIZE_CTRL = 32,
+	DR_STE_SIZE_MATCH_TAG = 32,
 	DR_STE_SIZE_TAG = 16,
 	DR_STE_SIZE_MASK = 16,
 	DR_STE_SIZE_REDUCED = DR_STE_SIZE - DR_STE_SIZE_MASK,
@@ -1295,6 +1296,14 @@ int mlx5dr_cmd_create_reformat_ctx(struct mlx5_core_dev *mdev,
 				   u32 *reformat_id);
 void mlx5dr_cmd_destroy_reformat_ctx(struct mlx5_core_dev *mdev,
 				     u32 reformat_id);
+int mlx5dr_cmd_create_definer(struct mlx5_core_dev *mdev,
+			      u16 format_id,
+			      u8 *dw_selectors,
+			      u8 *byte_selectors,
+			      u8 *match_mask,
+			      u32 *definer_id);
+void mlx5dr_cmd_destroy_definer(struct mlx5_core_dev *mdev,
+				u32 definer_id);
 
 struct mlx5dr_cmd_gid_attr {
 	u8 gid[16];
-- 
2.38.1

