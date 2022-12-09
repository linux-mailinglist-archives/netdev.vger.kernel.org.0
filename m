Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C385647A92
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiLIAOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLIAOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7D182FB6
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D94620B7
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C255CC433F1;
        Fri,  9 Dec 2022 00:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544869;
        bh=mTw8USjCUHNUcXx6wbqr/IG3MBDRIKNJ9Eh5Zj4N5nA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ef3LBC77TQDJS9+SwifNMPFOJ7VjgzWMpcw3onioiYB1yYF9v1unHdcgSo4o62Fi4
         tVoZeZ7EjIdzkorRlYnDjv2bBdpPwEzQJ2xGYS6ycXqizQu53AkdyLf++LHA24ucKx
         3cqHSznqr5srzsQ0Dfjw1Tc92SbheNaGcQ6RDUbJqoa9rneAyCNSw8Oc5XWJhaKFUp
         NlhYQhXGZdJlm8SA6/ggI2JgY3hr7Zu00W7AAKH8e8ylG4CxjCKuenFWD9n4HdKMs6
         cUXL4EzHanZw6GpCJt2w8TKeo7fxEKTpxrVFZ54FsFeerXYsJYDnh9pqoE0DWC8Ln8
         RFWej++4KJGFg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 01/15] net/mlx5: mlx5_ifc updates for MATCH_DEFINER general object
Date:   Thu,  8 Dec 2022 16:14:06 -0800
Message-Id: <20221209001420.142794-2-saeed@kernel.org>
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

Update full structure of match definer and add an ID of
the SELECT match definer type.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 68 +++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2093131483c7..294cfe175c4b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -6108,6 +6108,38 @@ struct mlx5_ifc_match_definer_format_32_bits {
 	u8         inner_dmac_15_0[0x10];
 };
 
+enum {
+	MLX5_IFC_DEFINER_FORMAT_ID_SELECT = 61,
+};
+
+#define MLX5_IFC_DEFINER_FORMAT_OFFSET_UNUSED 0x0
+#define MLX5_IFC_DEFINER_FORMAT_OFFSET_OUTER_ETH_PKT_LEN 0x48
+#define MLX5_IFC_DEFINER_DW_SELECTORS_NUM 9
+#define MLX5_IFC_DEFINER_BYTE_SELECTORS_NUM 8
+
+struct mlx5_ifc_match_definer_match_mask_bits {
+	u8         reserved_at_1c0[5][0x20];
+	u8         match_dw_8[0x20];
+	u8         match_dw_7[0x20];
+	u8         match_dw_6[0x20];
+	u8         match_dw_5[0x20];
+	u8         match_dw_4[0x20];
+	u8         match_dw_3[0x20];
+	u8         match_dw_2[0x20];
+	u8         match_dw_1[0x20];
+	u8         match_dw_0[0x20];
+
+	u8         match_byte_7[0x8];
+	u8         match_byte_6[0x8];
+	u8         match_byte_5[0x8];
+	u8         match_byte_4[0x8];
+
+	u8         match_byte_3[0x8];
+	u8         match_byte_2[0x8];
+	u8         match_byte_1[0x8];
+	u8         match_byte_0[0x8];
+};
+
 struct mlx5_ifc_match_definer_bits {
 	u8         modify_field_select[0x40];
 
@@ -6116,9 +6148,41 @@ struct mlx5_ifc_match_definer_bits {
 	u8         reserved_at_80[0x10];
 	u8         format_id[0x10];
 
-	u8         reserved_at_a0[0x160];
+	u8         reserved_at_a0[0x60];
 
-	u8         match_mask[16][0x20];
+	u8         format_select_dw3[0x8];
+	u8         format_select_dw2[0x8];
+	u8         format_select_dw1[0x8];
+	u8         format_select_dw0[0x8];
+
+	u8         format_select_dw7[0x8];
+	u8         format_select_dw6[0x8];
+	u8         format_select_dw5[0x8];
+	u8         format_select_dw4[0x8];
+
+	u8         reserved_at_100[0x18];
+	u8         format_select_dw8[0x8];
+
+	u8         reserved_at_120[0x20];
+
+	u8         format_select_byte3[0x8];
+	u8         format_select_byte2[0x8];
+	u8         format_select_byte1[0x8];
+	u8         format_select_byte0[0x8];
+
+	u8         format_select_byte7[0x8];
+	u8         format_select_byte6[0x8];
+	u8         format_select_byte5[0x8];
+	u8         format_select_byte4[0x8];
+
+	u8         reserved_at_180[0x40];
+
+	union {
+		struct {
+			u8         match_mask[16][0x20];
+		};
+		struct mlx5_ifc_match_definer_match_mask_bits match_mask_format;
+	};
 };
 
 struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
-- 
2.38.1

