Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE885B1091
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiIGXhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiIGXhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30D7C59C0;
        Wed,  7 Sep 2022 16:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBC37B81F28;
        Wed,  7 Sep 2022 23:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8419AC433D6;
        Wed,  7 Sep 2022 23:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593841;
        bh=bpw3aYWKMFaw5DYVyaG/UEnhS63zA/mA2l+e4JvmMRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cm5fQ2DUU/k3fJE3Z1ChLr1+CR7uGSfJiAG36Y84EPYQu49CM/KBY+vdhSTI37Hkc
         Yct/bK/n/Pcw2huPz3wgmpWRGLwvh0gMeCeyNmyUvy9pYj488IJdqLE2z+BBrqgPdt
         vJ/FjFOuvNa7gxxg/52aya24iMWZX4nAxfxDYqOa7DtfxEcIHOUDQ5CLGiEYE3F+wu
         7fDwtW7wEzA7KqR68w0x63PcwUmtZ8/gR5N0u+cZ+FhyRQBrw4Fju6c0AMYbNGwRuc
         NwCollruXlwtkyuLYUB1JBat3JYB2a/1jxjzTqssqT+XeEQ5PCAwz97NWCIlRbOVw3
         GnEbyPAtxixJA==
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
Subject: [PATCH mlx5-next 14/14] net/mlx5: Add IFC bits and enums for crypto key
Date:   Wed,  7 Sep 2022 16:36:36 -0700
Message-Id: <20220907233636.388475-15-saeed@kernel.org>
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

Add and extend structure layouts and defines for fast crypto key
update. This is a prerequisite to support bulk creation, key
modification and destruction, software wrapped DEK, and SYNC_CRYPTO
command.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 146 ++++++++++++++++++++++++++++++++--
 1 file changed, 140 insertions(+), 6 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 396b73383e58..8e548a88b839 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -303,6 +303,7 @@ enum {
 	MLX5_CMD_OP_SYNC_STEERING                 = 0xb00,
 	MLX5_CMD_OP_QUERY_VHCA_STATE              = 0xb0d,
 	MLX5_CMD_OP_MODIFY_VHCA_STATE             = 0xb0e,
+	MLX5_CMD_OP_SYNC_CRYPTO                   = 0xb12,
 	MLX5_CMD_OP_MAX
 };
 
@@ -1094,6 +1095,30 @@ struct mlx5_ifc_sync_steering_out_bits {
 	u8         reserved_at_40[0x40];
 };
 
+struct mlx5_ifc_sync_crypto_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x20];
+
+	u8         reserved_at_60[0x10];
+	u8         crypto_type[0x10];
+
+	u8         reserved_at_80[0x80];
+};
+
+struct mlx5_ifc_sync_crypto_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
 struct mlx5_ifc_device_mem_cap_bits {
 	u8         memic[0x1];
 	u8         reserved_at_1[0x1f];
@@ -1730,7 +1755,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_460[0x3];
 	u8         log_max_uctx[0x5];
-	u8         reserved_at_468[0x2];
+	u8         reserved_at_468[0x1];
+	u8         crypto[0x1];
 	u8         ipsec_offload[0x1];
 	u8         log_max_umem[0x5];
 	u8         max_num_eqs[0x10];
@@ -3310,6 +3336,30 @@ struct mlx5_ifc_nvmeotcp_cap_bits {
 	u8    reserved_at_40[0x7c0];
 };
 
+struct mlx5_ifc_crypto_cap_bits {
+	u8    reserved_at_0[0x3];
+	u8    synchronize_dek[0x1];
+	u8    int_kek_manual[0x1];
+	u8    int_kek_auto[0x1];
+	u8    reserved_at_6[0x1a];
+
+	u8    reserved_at_20[0x3];
+	u8    log_dek_max_alloc[0x5];
+	u8    reserved_at_28[0x3];
+	u8    log_max_num_deks[0x5];
+	u8    reserved_at_30[0x10];
+
+	u8    reserved_at_40[0x20];
+
+	u8    reserved_at_60[0x3];
+	u8    log_dek_granularity[0x5];
+	u8    reserved_at_68[0x3];
+	u8    log_max_num_int_kek[0x5];
+	u8    sw_wrapped_dek[0x10];
+
+	u8    reserved_at_80[0x780];
+};
+
 union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_cmd_hca_cap_bits cmd_hca_cap;
 	struct mlx5_ifc_cmd_hca_cap_2_bits cmd_hca_cap_2;
@@ -3330,6 +3380,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
 	struct mlx5_ifc_shampo_cap_bits shampo_cap;
 	struct mlx5_ifc_nvmeotcp_cap_bits nvmeotcp_cap;
+	struct mlx5_ifc_crypto_cap_bits crypto_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -6092,6 +6143,11 @@ struct mlx5_ifc_general_obj_create_param_bits {
 	u8         reserved_at_8[0x18];
 };
 
+struct mlx5_ifc_general_obj_query_param_bits {
+	u8         alias_object[0x1];
+	u8         obj_offset[0x1f];
+};
+
 struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 	u8         opcode[0x10];
 	u8         uid[0x10];
@@ -6101,7 +6157,10 @@ struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 
 	u8         obj_id[0x20];
 
-	struct mlx5_ifc_general_obj_create_param_bits op_param;
+	union {
+		struct mlx5_ifc_general_obj_create_param_bits create;
+		struct mlx5_ifc_general_obj_query_param_bits query;
+	} op_param;
 };
 
 struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
@@ -11528,6 +11587,7 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
 	MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = 0x21,
 	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
+	MLX5_GENERAL_OBJECT_TYPES_INT_KEK = 0x47,
 };
 
 enum {
@@ -11578,10 +11638,44 @@ struct mlx5_ifc_modify_ipsec_obj_in_bits {
 	struct mlx5_ifc_ipsec_obj_bits ipsec_object;
 };
 
+struct mlx5_ifc_wrapped_dek_bits {
+	u8         gcm_iv[0x60];
+
+	u8         reserved_at_60[0x20];
+
+	u8         const0[0x1];
+	u8         key_size[0x1];
+	u8         reserved_at_82[0x2];
+	u8         key2_invalid[0x1];
+	u8         reserved_at_85[0x3];
+	u8         pd[0x18];
+
+	u8         key_purpose[0x5];
+	u8         reserved_at_a5[0x13];
+	u8         kek_id[0x8];
+
+	u8         reserved_at_c0[0x40];
+
+	u8         key1[0x8][0x20];
+
+	u8         key2[0x8][0x20];
+
+	u8         reserved_at_300[0x40];
+
+	u8         const1[0x1];
+	u8         reserved_at_341[0x1f];
+
+	u8         reserved_at_360[0x20];
+
+	u8         auth_tag[0x80];
+};
+
 struct mlx5_ifc_encryption_key_obj_bits {
 	u8         modify_field_select[0x40];
 
-	u8         reserved_at_40[0x14];
+	u8         state[0x8];
+	u8         sw_wrapped[0x1];
+	u8         reserved_at_49[0xb];
 	u8         key_size[0x4];
 	u8         reserved_at_58[0x4];
 	u8         key_type[0x4];
@@ -11589,10 +11683,17 @@ struct mlx5_ifc_encryption_key_obj_bits {
 	u8         reserved_at_60[0x8];
 	u8         pd[0x18];
 
-	u8         reserved_at_80[0x180];
-	u8         key[8][0x20];
+	u8         reserved_at_80[0x100];
+
+	u8         opaque[0x40];
+
+	u8         reserved_at_1c0[0x40];
+
+	u8         key[8][0x80];
+
+	u8         sw_wrapped_dek[8][0x80];
 
-	u8         reserved_at_300[0x500];
+	u8         reserved_at_a00[0x600];
 };
 
 struct mlx5_ifc_create_encryption_key_in_bits {
@@ -11600,6 +11701,11 @@ struct mlx5_ifc_create_encryption_key_in_bits {
 	struct mlx5_ifc_encryption_key_obj_bits encryption_key_object;
 };
 
+struct mlx5_ifc_modify_encryption_key_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_encryption_key_obj_bits encryption_key_object;
+};
+
 enum {
 	MLX5_FLOW_METER_MODE_BYTES_IP_LENGTH		= 0x0,
 	MLX5_FLOW_METER_MODE_BYTES_CALC_WITH_L2		= 0x1,
@@ -11655,6 +11761,34 @@ struct mlx5_ifc_create_flow_meter_aso_obj_in_bits {
 	struct mlx5_ifc_flow_meter_aso_obj_bits flow_meter_aso_obj;
 };
 
+struct mlx5_ifc_int_kek_obj_bits {
+	u8         modify_field_select[0x40];
+
+	u8         state[0x8];
+	u8         auto_gen[0x1];
+	u8         reserved_at_49[0xb];
+	u8         key_size[0x4];
+	u8         reserved_at_58[0x8];
+
+	u8         reserved_at_60[0x8];
+	u8         pd[0x18];
+
+	u8         reserved_at_80[0x180];
+	u8         key[8][0x80];
+
+	u8         reserved_at_600[0x200];
+};
+
+struct mlx5_ifc_create_int_kek_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_int_kek_obj_bits int_kek_object;
+};
+
+struct mlx5_ifc_create_int_kek_obj_out_bits {
+	struct mlx5_ifc_general_obj_out_cmd_hdr_bits general_obj_out_cmd_hdr;
+	struct mlx5_ifc_int_kek_obj_bits int_kek_object;
+};
+
 struct mlx5_ifc_sampler_obj_bits {
 	u8         modify_field_select[0x40];
 
-- 
2.37.2

