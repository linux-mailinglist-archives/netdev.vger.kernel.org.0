Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30206CFD9E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjC3IDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjC3ICv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:02:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FB51A7
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:02:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B50F361F44
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3B8C433EF;
        Thu, 30 Mar 2023 08:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163368;
        bh=fby0VhQwUnZqeiNVRU33aZBizRs5+Lx2M+m5Mwkz+os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gl0cO5ZvlI9WjwZCzyyAm6UJ4h0dfqQ9N7jiDoKzi54z8vEqxUyAD5d740z04xbvw
         +DYAMZQPYXwU0wk/mzA8/AgM37hPuODQKGSYLI+KJ/t+gl766DHR/z98R5djZkscTY
         WpYd/ZG3x0Sh3JDkUSLWQY/J9X7uDY/ueZBZssmHC4dnvTAxkmg4nKbnqWmhBJJ4EU
         gPFSZgjvYFHV9IHGcBgW+QEt/uBJszsp+6OnXrZbGubqUQf2z/EjEW1HA0ZALUBHB6
         DRPDaXc5yCrScVlvRWAeWww0KC4UlC2/vXhytm4Cak38jmuhyICTg3Ya2j1oylszlZ
         c5WmMvABnFWGA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next 01/10] net/mlx5e: Factor out IPsec ASO update function
Date:   Thu, 30 Mar 2023 11:02:22 +0300
Message-Id: <d04770b959822fed51c22c13e798f04d760a682e.1680162300.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680162300.git.leonro@nvidia.com>
References: <cover.1680162300.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The ASO update is common operation which is going to be used in next
patch, so as a preparation, let's refactor the code for future reuse.

As part of this refactoring, not used function argument was removed too.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mlx5/core/en_accel/ipsec_offload.c        | 27 ++++++++++---------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 5342b0b07681..43cfa4df1311 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -275,26 +275,21 @@ void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 	memcpy(&sa_entry->attrs, attrs, sizeof(sa_entry->attrs));
 }
 
-static void
-mlx5e_ipsec_aso_update_esn(struct mlx5e_ipsec_sa_entry *sa_entry,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
+static void mlx5e_ipsec_aso_update(struct mlx5e_ipsec_sa_entry *sa_entry,
+				   struct mlx5_wqe_aso_ctrl_seg *data)
 {
-	struct mlx5_wqe_aso_ctrl_seg data = {};
+	data->data_mask_mode = MLX5_ASO_DATA_MASK_MODE_BITWISE_64BIT << 6;
+	data->condition_1_0_operand = MLX5_ASO_ALWAYS_TRUE |
+				      MLX5_ASO_ALWAYS_TRUE << 4;
 
-	data.data_mask_mode = MLX5_ASO_DATA_MASK_MODE_BITWISE_64BIT << 6;
-	data.condition_1_0_operand = MLX5_ASO_ALWAYS_TRUE | MLX5_ASO_ALWAYS_TRUE
-								    << 4;
-	data.data_offset_condition_operand = MLX5_IPSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET;
-	data.bitwise_data = cpu_to_be64(BIT_ULL(54));
-	data.data_mask = data.bitwise_data;
-
-	mlx5e_ipsec_aso_query(sa_entry, &data);
+	mlx5e_ipsec_aso_query(sa_entry, data);
 }
 
 static void mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry,
 					 u32 mode_param)
 {
 	struct mlx5_accel_esp_xfrm_attrs attrs = {};
+	struct mlx5_wqe_aso_ctrl_seg data = {};
 
 	if (mode_param < MLX5E_IPSEC_ESN_SCOPE_MID) {
 		sa_entry->esn_state.esn++;
@@ -305,7 +300,13 @@ static void mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry,
 
 	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &attrs);
 	mlx5_accel_esp_modify_xfrm(sa_entry, &attrs);
-	mlx5e_ipsec_aso_update_esn(sa_entry, &attrs);
+
+	data.data_offset_condition_operand =
+		MLX5_IPSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET;
+	data.bitwise_data = cpu_to_be64(BIT_ULL(54));
+	data.data_mask = data.bitwise_data;
+
+	mlx5e_ipsec_aso_update(sa_entry, &data);
 }
 
 static void mlx5e_ipsec_handle_event(struct work_struct *_work)
-- 
2.39.2

