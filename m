Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A9F5B5200
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 01:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiIKXlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 19:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIKXli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 19:41:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE042655C
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 16:41:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B010FB80BFA
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 23:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9E7C43144;
        Sun, 11 Sep 2022 23:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662939694;
        bh=/DXfdKy2JcK8fsEgrQG18CEDV68y1AP8i1PhQfd+DdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IL8vEI4v04D8Tl74usHB6u6ZJZlfY3D1npb0Y0QJJ4PDhtpHC3hiUn/z4wuOWDYam
         4UFeJKgwUiM8gIvQrkAJpCR+fC/TfnMmIu3pOVC+pKvEGTr1D0ut2ITHEyCjTqrZmS
         VsOp7fp+kcDqGjzff21BDa4WUy8b4vjbnr7qB/CXSHoUWnaKVS7Kuj3ZQOxeO8BPAT
         eEfPdGCzGaVSd48z36kRiuW/t2drZeeWfgxD+5jeF9DtWDbk+HsgMtNLZX0NLkIKsJ
         C1rngkw29Ltt20n9r5SWVjPWFi2K5IR+k2oubeXFjhwGF0URVzxuS81idilZTaMc36
         61w6uv4v/9/VQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next 05/10] net/mlx5: Add ifc bits for MACsec extended packet number (EPN) and replay protection
Date:   Mon, 12 Sep 2022 00:40:54 +0100
Message-Id: <20220911234059.98624-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220911234059.98624-1-saeed@kernel.org>
References: <20220911234059.98624-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Add ifc bits related to advanced steering operations (ASO) and general
object modify for macsec to use as part of offloading EPN and replay
protection features.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index da0ed11fcebd..bd577b99b146 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11558,6 +11558,20 @@ struct mlx5_ifc_modify_ipsec_obj_in_bits {
 	struct mlx5_ifc_ipsec_obj_bits ipsec_object;
 };
 
+enum {
+	MLX5_MACSEC_ASO_REPLAY_PROTECTION = 0x1,
+};
+
+enum {
+	MLX5_MACSEC_ASO_REPLAY_WIN_32BIT  = 0x0,
+	MLX5_MACSEC_ASO_REPLAY_WIN_64BIT  = 0x1,
+	MLX5_MACSEC_ASO_REPLAY_WIN_128BIT = 0x2,
+	MLX5_MACSEC_ASO_REPLAY_WIN_256BIT = 0x3,
+};
+
+#define MLX5_MACSEC_ASO_INC_SN  0x2
+#define MLX5_MACSEC_ASO_REG_C_4_5 0x2
+
 struct mlx5_ifc_macsec_aso_bits {
 	u8    valid[0x1];
 	u8    reserved_at_1[0x1];
@@ -11619,6 +11633,21 @@ struct mlx5_ifc_create_macsec_obj_in_bits {
 	struct mlx5_ifc_macsec_offload_obj_bits macsec_object;
 };
 
+struct mlx5_ifc_modify_macsec_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_macsec_offload_obj_bits macsec_object;
+};
+
+enum {
+	MLX5_MODIFY_MACSEC_BITMASK_EPN_OVERLAP = BIT(0),
+	MLX5_MODIFY_MACSEC_BITMASK_EPN_MSB = BIT(1),
+};
+
+struct mlx5_ifc_query_macsec_obj_out_bits {
+	struct mlx5_ifc_general_obj_out_cmd_hdr_bits general_obj_out_cmd_hdr;
+	struct mlx5_ifc_macsec_offload_obj_bits macsec_object;
+};
+
 struct mlx5_ifc_encryption_key_obj_bits {
 	u8         modify_field_select[0x40];
 
-- 
2.37.3

