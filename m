Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4B05959F2
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiHPLYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbiHPLYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:24:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2095FA4B0F
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 215B8CE174E
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E5BC433D6;
        Tue, 16 Aug 2022 10:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646304;
        bh=GzI/zCcgkP/YH/5RUJbM3AsKglWVr+opDZi77JQ+AGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Di0k80JwG68ls1+WRG8ezOihnD/j4gQYTNF+ozpzPf64mHJbqfzTTKv5Lp2WiUM1E
         E7MSADHK1cupUrMhAdVodiTIjhwWaRf03fKeh4LeVHiJiemYIDEt1wU9kNMoPH6TaX
         VzNe4HNJ79PIf5h+PDtFBXpI7P6HWcSDZKRm9rH8PfWqxuh3sTQm6I3qjrLMHoNV4I
         XLmfXBGJHw9TtpBomn1UCddbWJ2ec8Zta3AX7e4m9dEECyQFskNMeHCxemZXzM+dQi
         cAodZG/94DNxJfnQSGpYw76ST3rfwqxCCsSGiYjdQWe+O2RomcrTLCzofSi1GVp1AH
         CRc6x7gA8aV1Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 02/26] net/mlx5: Add HW definitions for IPsec full offload
Date:   Tue, 16 Aug 2022 13:37:50 +0300
Message-Id: <4256f76e64118005835df8104a3734f734e2d9f2.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Add all needed bits to support IPsec full offload mode.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 55 +++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4acd5610e96b..57b4ae2dce07 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -442,7 +442,10 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         max_modify_header_actions[0x8];
 	u8         max_ft_level[0x8];
 
-	u8         reserved_at_40[0x6];
+	u8         reformat_add_esp_trasport[0x1];
+	u8         reserved_at_41[0x2];
+	u8         reformat_del_esp_trasport[0x1];
+	u8         reserved_at_44[0x2];
 	u8         execute_aso[0x1];
 	u8         reserved_at_47[0x19];
 
@@ -611,7 +614,11 @@ struct mlx5_ifc_fte_match_set_misc2_bits {
 
 	u8         metadata_reg_a[0x20];
 
-	u8         reserved_at_1a0[0x60];
+	u8         reserved_at_1a0[0x10];
+	u8         ipsec_syndrome[0x8];
+	u8         ipsec_next_header[0x8];
+
+	u8         reserved_at_1c0[0x40];
 };
 
 struct mlx5_ifc_fte_match_set_misc3_bits {
@@ -6314,6 +6321,9 @@ enum mlx5_reformat_ctx_type {
 	MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL = 0x2,
 	MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2 = 0x3,
 	MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL = 0x4,
+	MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4 = 0x5,
+	MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT = 0x8,
+	MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6 = 0xb,
 	MLX5_REFORMAT_TYPE_INSERT_HDR = 0xf,
 	MLX5_REFORMAT_TYPE_REMOVE_HDR = 0x10,
 };
@@ -11477,6 +11487,41 @@ enum {
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
@@ -11498,7 +11543,11 @@ struct mlx5_ifc_ipsec_obj_bits {
 
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
2.37.2

