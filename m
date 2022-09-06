Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7D55ADEF2
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiIFFVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiIFFVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BE26CF6B
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF22DB815FB
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B8CC433C1;
        Tue,  6 Sep 2022 05:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441704;
        bh=3Vnt58qIBBWDXY0tzVT0lM07TV2ERqNJDJPSYizCP3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtD4g34eGQfYoxZKujTUQy4ANGKhVLOpD2+tXsaLUiYwsm5A1oClM1VW8UQ24ORRx
         y9+sN5sYaxdXxoGGwV+8+h4e8NX54V4iZCRl6FhwFL0ujSGHEQRrkjqum2ekmgrVdm
         jpwG+Uz+ygEIlNvmAlMtzs2QXEhAL1cBFcAIl2P7uYRoESwb8ldzu3ZeGBTndu8wKW
         7Kx5jT+B3GjiQnuzzUwJXNpXzrSUsc3zwyYqOQA6adwYwytSefrQhOjh6SUzzu+mh0
         8zi2+MXuid5D+vrDPCyix/CcdLtd4VzwP7jMib0NhAAgaWIqIaXtqy/1GdkqfszwbD
         Ihl+cgINMQjwA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 06/17] net/mlx5: Introduce MACsec Connect-X offload hardware bits and structures
Date:   Mon,  5 Sep 2022 22:21:18 -0700
Message-Id: <20220906052129.104507-7-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
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

From: Lior Nahmanson <liorna@nvidia.com>

Add MACsec offload related IFC structs, layouts and enumerations.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/device.h   |  4 ++
 include/linux/mlx5/mlx5_ifc.h | 99 ++++++++++++++++++++++++++++++++++-
 2 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index b5f58fd37a0f..2927810f172b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1198,6 +1198,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
 	MLX5_CAP_DEV_SHAMPO = 0x1d,
+	MLX5_CAP_MACSEC = 0x1f,
 	MLX5_CAP_GENERAL_2 = 0x20,
 	MLX5_CAP_PORT_SELECTION = 0x25,
 	/* NUM OF CAP Types */
@@ -1446,6 +1447,9 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_DEV_SHAMPO(mdev, cap)\
 	MLX5_GET(shampo_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_SHAMPO], cap)
 
+#define MLX5_CAP_MACSEC(mdev, cap)\
+	MLX5_GET(macsec_cap, (mdev)->caps.hca[MLX5_CAP_MACSEC]->cur, cap)
+
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
 	MLX5_CMD_STAT_INT_ERR			= 0x1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5758218cb3fa..8decbf9a7bdd 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -82,6 +82,7 @@ enum {
 	MLX5_GENERAL_OBJ_TYPES_CAP_SW_ICM = (1ULL << MLX5_OBJ_TYPE_SW_ICM),
 	MLX5_GENERAL_OBJ_TYPES_CAP_GENEVE_TLV_OPT = (1ULL << 11),
 	MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q = (1ULL << 13),
+	MLX5_GENERAL_OBJ_TYPES_CAP_MACSEC_OFFLOAD = (1ULL << 39),
 };
 
 enum {
@@ -449,7 +450,12 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         reserved_at_60[0x2];
 	u8         reformat_insert[0x1];
 	u8         reformat_remove[0x1];
-	u8         reserver_at_64[0x14];
+	u8         macsec_encrypt[0x1];
+	u8         macsec_decrypt[0x1];
+	u8         reserved_at_66[0x2];
+	u8         reformat_add_macsec[0x1];
+	u8         reformat_remove_macsec[0x1];
+	u8         reserved_at_6a[0xe];
 	u8         log_max_ft_num[0x8];
 
 	u8         reserved_at_80[0x10];
@@ -611,7 +617,11 @@ struct mlx5_ifc_fte_match_set_misc2_bits {
 
 	u8         metadata_reg_a[0x20];
 
-	u8         reserved_at_1a0[0x60];
+	u8         reserved_at_1a0[0x8];
+
+	u8         macsec_syndrome[0x8];
+
+	u8         reserved_at_1b0[0x50];
 };
 
 struct mlx5_ifc_fte_match_set_misc3_bits {
@@ -1276,6 +1286,24 @@ struct mlx5_ifc_ipsec_cap_bits {
 	u8         reserved_at_30[0x7d0];
 };
 
+struct mlx5_ifc_macsec_cap_bits {
+	u8    macsec_epn[0x1];
+	u8    reserved_at_1[0x2];
+	u8    macsec_crypto_esp_aes_gcm_256_encrypt[0x1];
+	u8    macsec_crypto_esp_aes_gcm_128_encrypt[0x1];
+	u8    macsec_crypto_esp_aes_gcm_256_decrypt[0x1];
+	u8    macsec_crypto_esp_aes_gcm_128_decrypt[0x1];
+	u8    reserved_at_7[0x4];
+	u8    log_max_macsec_offload[0x5];
+	u8    reserved_at_10[0x10];
+
+	u8    min_log_macsec_full_replay_window[0x8];
+	u8    max_log_macsec_full_replay_window[0x8];
+	u8    reserved_at_30[0x10];
+
+	u8    reserved_at_40[0x7c0];
+};
+
 enum {
 	MLX5_WQ_TYPE_LINKED_LIST  = 0x0,
 	MLX5_WQ_TYPE_CYCLIC       = 0x1,
@@ -3295,6 +3323,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_device_mem_cap_bits device_mem_cap;
 	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
 	struct mlx5_ifc_shampo_cap_bits shampo_cap;
+	struct mlx5_ifc_macsec_cap_bits macsec_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -3323,6 +3352,7 @@ enum {
 
 enum {
 	MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC   = 0x0,
+	MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_MACSEC  = 0x1,
 };
 
 struct mlx5_ifc_vlan_bits {
@@ -6320,6 +6350,8 @@ enum mlx5_reformat_ctx_type {
 	MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL = 0x4,
 	MLX5_REFORMAT_TYPE_INSERT_HDR = 0xf,
 	MLX5_REFORMAT_TYPE_REMOVE_HDR = 0x10,
+	MLX5_REFORMAT_TYPE_ADD_MACSEC = 0x11,
+	MLX5_REFORMAT_TYPE_DEL_MACSEC = 0x12,
 };
 
 struct mlx5_ifc_alloc_packet_reformat_context_in_bits {
@@ -11475,6 +11507,7 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
 	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
+	MLX5_GENERAL_OBJECT_TYPES_MACSEC = 0x27,
 };
 
 enum {
@@ -11525,6 +11558,67 @@ struct mlx5_ifc_modify_ipsec_obj_in_bits {
 	struct mlx5_ifc_ipsec_obj_bits ipsec_object;
 };
 
+struct mlx5_ifc_macsec_aso_bits {
+	u8    valid[0x1];
+	u8    reserved_at_1[0x1];
+	u8    mode[0x2];
+	u8    window_size[0x2];
+	u8    soft_lifetime_arm[0x1];
+	u8    hard_lifetime_arm[0x1];
+	u8    remove_flow_enable[0x1];
+	u8    epn_event_arm[0x1];
+	u8    reserved_at_a[0x16];
+
+	u8    remove_flow_packet_count[0x20];
+
+	u8    remove_flow_soft_lifetime[0x20];
+
+	u8    reserved_at_60[0x80];
+
+	u8    mode_parameter[0x20];
+
+	u8    replay_protection_window[8][0x20];
+};
+
+struct mlx5_ifc_macsec_offload_obj_bits {
+	u8    modify_field_select[0x40];
+
+	u8    confidentiality_en[0x1];
+	u8    reserved_at_41[0x1];
+	u8    esn_en[0x1];
+	u8    esn_overlap[0x1];
+	u8    reserved_at_44[0x2];
+	u8    confidentiality_offset[0x2];
+	u8    reserved_at_48[0x4];
+	u8    aso_return_reg[0x4];
+	u8    reserved_at_50[0x10];
+
+	u8    esn_msb[0x20];
+
+	u8    reserved_at_80[0x8];
+	u8    dekn[0x18];
+
+	u8    reserved_at_a0[0x20];
+
+	u8    sci[0x40];
+
+	u8    reserved_at_100[0x8];
+	u8    macsec_aso_access_pd[0x18];
+
+	u8    reserved_at_120[0x60];
+
+	u8    salt[3][0x20];
+
+	u8    reserved_at_1e0[0x20];
+
+	struct mlx5_ifc_macsec_aso_bits macsec_aso;
+};
+
+struct mlx5_ifc_create_macsec_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_macsec_offload_obj_bits macsec_object;
+};
+
 struct mlx5_ifc_encryption_key_obj_bits {
 	u8         modify_field_select[0x40];
 
@@ -11642,6 +11736,7 @@ enum {
 enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS = 0x1,
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC = 0x2,
+	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_MACSEC = 0x4,
 };
 
 struct mlx5_ifc_tls_static_params_bits {
-- 
2.37.2

