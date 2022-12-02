Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4E4640EE5
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbiLBUKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLBUKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:10:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1D1BE10A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:10:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37F486221E
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1728DC433D6;
        Fri,  2 Dec 2022 20:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011847;
        bh=/UcOl2HaYIM5kMOlEOQsCFE5cfN9tpY0BXCGOKTNLIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bztO9UWwNgkUIKxq5uOcYMDPchxZzesKqdpWVsIW/iUq/hQYdsGAJKB7KVhfUn2Td
         v/h6eZbLD02xRh7PhHZ6sQ3OoDW2xRb0K2RUQlIha2Oo9MYESulH4Ejkxu5V3QQBlO
         25gyE6QGt96IJz8bTSb8i+itegMRqO1DdVgNupEF5RHPUJrDFhbInF8LPexuklNLZF
         DvWFqRA2Xa0HZyketiOYPTEek1pxv83DH3XtD3HPCLVQ+R9l2hlv9+ui2HiGmO1tFI
         PMuhWd4p0t73BTC/heV3bMV42HYSFwLmYRc02JwN6z5s0cNwT/9GAAMrZN7n5EhRUE
         Gsougrrirj1yA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 02/16] net/mlx5: Add HW definitions for IPsec packet offload
Date:   Fri,  2 Dec 2022 22:10:23 +0200
Message-Id: <d1f82a208316358bb59aaad2b2afb0187545d125.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Add all needed bits to support IPsec packet offload mode.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 53 +++++++++++++++++--
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
index 4312614bf3bc..c8fc3c838642 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
@@ -71,6 +71,7 @@ enum {
 };
 
 enum {
+	MLX5_ACCESS_ASO_OPC_MOD_IPSEC = 0x0,
 	MLX5_ACCESS_ASO_OPC_MOD_FLOW_METER = 0x2,
 	MLX5_ACCESS_ASO_OPC_MOD_MACSEC = 0x5,
 };
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5a4e914e2a6f..300b56ea5ff4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -445,7 +445,10 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         max_modify_header_actions[0x8];
 	u8         max_ft_level[0x8];
 
-	u8         reserved_at_40[0x6];
+	u8         reformat_add_esp_trasport[0x1];
+	u8         reserved_at_41[0x2];
+	u8         reformat_del_esp_trasport[0x1];
+	u8         reserved_at_44[0x2];
 	u8         execute_aso[0x1];
 	u8         reserved_at_47[0x19];
 
@@ -638,8 +641,10 @@ struct mlx5_ifc_fte_match_set_misc2_bits {
 	u8         reserved_at_1a0[0x8];
 
 	u8         macsec_syndrome[0x8];
+	u8         ipsec_syndrome[0x8];
+	u8         reserved_at_1b8[0x8];
 
-	u8         reserved_at_1b0[0x50];
+	u8         reserved_at_1c0[0x40];
 };
 
 struct mlx5_ifc_fte_match_set_misc3_bits {
@@ -6384,6 +6389,9 @@ enum mlx5_reformat_ctx_type {
 	MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL = 0x2,
 	MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2 = 0x3,
 	MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL = 0x4,
+	MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4 = 0x5,
+	MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT = 0x8,
+	MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6 = 0xb,
 	MLX5_REFORMAT_TYPE_INSERT_HDR = 0xf,
 	MLX5_REFORMAT_TYPE_REMOVE_HDR = 0x10,
 	MLX5_REFORMAT_TYPE_ADD_MACSEC = 0x11,
@@ -11563,6 +11571,41 @@ enum {
 	MLX5_IPSEC_OBJECT_ICV_LEN_16B,
 };
 
+enum {
+	MLX5_IPSEC_ASO_REG_C_0_1 = 0x0,
+	MLX5_IPSEC_ASO_REG_C_2_3 = 0x1,
+	MLX5_IPSEC_ASO_REG_C_4_5 = 0x2,
+	MLX5_IPSEC_ASO_REG_C_6_7 = 0x3,
+};
+
+enum {
+	MLX5_IPSEC_ASO_MODE              = 0x0,
+	MLX5_IPSEC_ASO_REPLAY_PROTECTION = 0x1,
+	MLX5_IPSEC_ASO_INC_SN            = 0x2,
+};
+
+struct mlx5_ifc_ipsec_aso_bits {
+	u8         valid[0x1];
+	u8         reserved_at_201[0x1];
+	u8         mode[0x2];
+	u8         window_sz[0x2];
+	u8         soft_lft_arm[0x1];
+	u8         hard_lft_arm[0x1];
+	u8         remove_flow_enable[0x1];
+	u8         esn_event_arm[0x1];
+	u8         reserved_at_20a[0x16];
+
+	u8         remove_flow_pkt_cnt[0x20];
+
+	u8         remove_flow_soft_lft[0x20];
+
+	u8         reserved_at_260[0x80];
+
+	u8         mode_parameter[0x20];
+
+	u8         replay_protection_window[0x100];
+};
+
 struct mlx5_ifc_ipsec_obj_bits {
 	u8         modify_field_select[0x40];
 	u8         full_offload[0x1];
@@ -11584,7 +11627,11 @@ struct mlx5_ifc_ipsec_obj_bits {
 
 	u8         implicit_iv[0x40];
 
-	u8         reserved_at_100[0x700];
+	u8         reserved_at_100[0x8];
+	u8         ipsec_aso_access_pd[0x18];
+	u8         reserved_at_120[0xe0];
+
+	struct mlx5_ifc_ipsec_aso_bits ipsec_aso;
 };
 
 struct mlx5_ifc_create_ipsec_obj_in_bits {
-- 
2.38.1

