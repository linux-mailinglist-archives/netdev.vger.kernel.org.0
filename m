Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF91682297
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjAaDMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjAaDMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCA536FEB
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43E7661381
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934CCC433D2;
        Tue, 31 Jan 2023 03:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134729;
        bh=/2yub2LWmfN9tymD+tBfBXgrrPUAsfbvxaqHjTwQshM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fmv1lMt9ETivlEIkgMQ1yFddrSq/F7sD8eDCIC2uNekYjpnpu/191n5GjiGc2XaUn
         E3Jk6wC6A4L9rv/Ayc2hb01i6zrroMa5SHJ62wDu25DSAP+EvGFW4nVCCa5RphVuJA
         kAkKiBuLfbtloEjfeXBwBE6oVzpUIcYXxYS9trEIKqPFqgVfrt5ev0pjuf8F7232bz
         X+2PbLEuZ2mfN21+9fZhb6QtCLJ41V9hTGCTusf80LtHTIciVzfYwwBYFcVy1ApDkH
         J4BPUklb1C15cT4ny7BWtvQm6WMZywJOeMgmvY5wPkTEZYHx4/c6M8JwjXAwBteodA
         oJZWBOObh1aIw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Add IFC bits and enums for crypto key
Date:   Mon, 30 Jan 2023 19:11:49 -0800
Message-Id: <20230131031201.35336-4-saeed@kernel.org>
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

Add and extend structure layouts and defines for fast crypto key
update. This is a prerequisite to support bulk creation, key
modification and destruction, software wrapped DEK, and SYNC_CRYPTO
command.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 146 ++++++++++++++++++++++++++++++++--
 1 file changed, 140 insertions(+), 6 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 17e293ceb625..7143b65f9f4a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -306,6 +306,7 @@ enum {
 	MLX5_CMD_OP_SYNC_STEERING                 = 0xb00,
 	MLX5_CMD_OP_QUERY_VHCA_STATE              = 0xb0d,
 	MLX5_CMD_OP_MODIFY_VHCA_STATE             = 0xb0e,
+	MLX5_CMD_OP_SYNC_CRYPTO                   = 0xb12,
 	MLX5_CMD_OP_MAX
 };
 
@@ -1112,6 +1113,30 @@ struct mlx5_ifc_sync_steering_out_bits {
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
@@ -1768,7 +1793,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         ats[0x1];
 	u8         reserved_at_462[0x1];
 	u8         log_max_uctx[0x5];
-	u8         reserved_at_468[0x2];
+	u8         reserved_at_468[0x1];
+	u8         crypto[0x1];
 	u8         ipsec_offload[0x1];
 	u8         log_max_umem[0x5];
 	u8         max_num_eqs[0x10];
@@ -3351,6 +3377,30 @@ struct mlx5_ifc_shampo_cap_bits {
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
@@ -3371,6 +3421,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
 	struct mlx5_ifc_shampo_cap_bits shampo_cap;
 	struct mlx5_ifc_macsec_cap_bits macsec_cap;
+	struct mlx5_ifc_crypto_cap_bits crypto_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -6203,6 +6254,11 @@ struct mlx5_ifc_general_obj_create_param_bits {
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
@@ -6212,7 +6268,10 @@ struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 
 	u8         obj_id[0x20];
 
-	struct mlx5_ifc_general_obj_create_param_bits op_param;
+	union {
+		struct mlx5_ifc_general_obj_create_param_bits create;
+		struct mlx5_ifc_general_obj_query_param_bits query;
+	} op_param;
 };
 
 struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
@@ -11707,6 +11766,7 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
 	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
 	MLX5_GENERAL_OBJECT_TYPES_MACSEC = 0x27,
+	MLX5_GENERAL_OBJECT_TYPES_INT_KEK = 0x47,
 };
 
 enum {
@@ -11886,10 +11946,44 @@ struct mlx5_ifc_query_macsec_obj_out_bits {
 	struct mlx5_ifc_macsec_offload_obj_bits macsec_object;
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
@@ -11897,10 +11991,17 @@ struct mlx5_ifc_encryption_key_obj_bits {
 	u8         reserved_at_60[0x8];
 	u8         pd[0x18];
 
-	u8         reserved_at_80[0x180];
-	u8         key[8][0x20];
+	u8         reserved_at_80[0x100];
+
+	u8         opaque[0x40];
+
+	u8         reserved_at_1c0[0x40];
 
-	u8         reserved_at_300[0x500];
+	u8         key[8][0x80];
+
+	u8         sw_wrapped_dek[8][0x80];
+
+	u8         reserved_at_a00[0x600];
 };
 
 struct mlx5_ifc_create_encryption_key_in_bits {
@@ -11908,6 +12009,11 @@ struct mlx5_ifc_create_encryption_key_in_bits {
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
@@ -11963,6 +12069,34 @@ struct mlx5_ifc_create_flow_meter_aso_obj_in_bits {
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
2.39.1

