Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDB65DAC07
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiIUSLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiIUSLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:11:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5E061738
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:11:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4897B62615
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A306C433B5;
        Wed, 21 Sep 2022 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663783863;
        bh=/DXfdKy2JcK8fsEgrQG18CEDV68y1AP8i1PhQfd+DdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8ckGAbvvospOxOa2NzJn3O5me1qeZ8HL2vW3o3kXguLRNojMKTaTYxZPgcmo4f11
         U7QMvN/8pqaz0Sb/IrL4mOBPqgFArrZyB5/j/xshTsH3tIzqEYkep0fLhu1/INMlV5
         Iq7aTU3ljX0SmkOzJrsvdXosD3S/ZGGvS9S7G1403LEwD3i7T6Ur0TtMAbZSot6lId
         GgF5FuZQ22LTVepqDEXDvowgyMx2EYO0cFS86C1VmlTo5Jc1oNVSfihZ9XitOrKavo
         5jMZzwHl7k2lz4jeo8gr4leg7Mz3ivzmKRtkmOY+C3Rem7ukhXgaPIO1vhSTkH31ne
         5U8z9kpi0OUxA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V3 05/10] net/mlx5: Add ifc bits for MACsec extended packet number (EPN) and replay protection
Date:   Wed, 21 Sep 2022 11:10:49 -0700
Message-Id: <20220921181054.40249-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921181054.40249-1-saeed@kernel.org>
References: <20220921181054.40249-1-saeed@kernel.org>
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

