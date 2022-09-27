Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E82F5ECEBA
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbiI0Uh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbiI0Ugy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4833D38AD
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1CF1B81C17
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4FEC433C1;
        Tue, 27 Sep 2022 20:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311010;
        bh=yotfOHVfYmY9J3VWRWKY/hp7RW5/FUI+ZHysaQ7fEG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjMshaY7bPg657HjD/VGaXnn3vD4+HArAgdhtP3PSrKSoamTjs3qWzxvcyNmhrpBz
         sPnQJi45xkpvNpyIoQovZXkP/D3Zmh1UanndkAPBb26ktnQ1LQ1gG/7CBwHihnldq3
         BCzB6bvo5Q5Kd7nJ59a9YVHkqr9t0tVoyygOqalvD7bcgh1gloYaM3rcjs298vHv4d
         I7k3kCjZ2ocRx6bhygElYTrzdtAI+7Ns4G4ay/NnWOJHAo1CY7RytASB2x+QWRBAB6
         BjTXcdPuUSnm9Jw+TgadS5IbbB9CXGTArg7UcFyIJpoMfXAS1R8VkVkYw7tgMhBkdO
         61cQWOZoGm85g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 12/16] net/mlx5e: xsk: Remove dead code in validation
Date:   Tue, 27 Sep 2022 13:36:07 -0700
Message-Id: <20220927203611.244301-13-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

One of the checks in mlx5e_rx_is_linear_skb verifies that the RX buffer
fits into the XSK frame size. Remove the duplicating check from
mlx5e_validate_xsk_param. It allows to make mlx5e_rx_get_min_frag_sz
static.

Remove mlx5e_rx_is_xdp altogether, as its only usage is located in a
branch where xsk == NULL.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c  | 12 +++---------
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h  |  2 --
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c   |  4 ----
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index bb039c3c4039..c9a4a507a168 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -7,12 +7,6 @@
 #include "en_accel/en_accel.h"
 #include "en_accel/ipsec.h"
 
-static bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
-			    struct mlx5e_xsk_param *xsk)
-{
-	return params->xdp_prog || xsk;
-}
-
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk)
 {
@@ -22,7 +16,7 @@ u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 		return xsk->headroom;
 
 	headroom = NET_IP_ALIGN;
-	if (mlx5e_rx_is_xdp(params, xsk))
+	if (params->xdp_prog)
 		headroom += XDP_PACKET_HEADROOM;
 	else
 		headroom += MLX5_RX_HEADROOM;
@@ -30,8 +24,8 @@ u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 	return headroom;
 }
 
-u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
-			     struct mlx5e_xsk_param *xsk)
+static u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
+				    struct mlx5e_xsk_param *xsk)
 {
 	u32 hw_mtu = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	u16 linear_rq_headroom = mlx5e_get_linear_rq_headroom(params, xsk);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 6e86cbfc7b58..3e148a00fa73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -101,8 +101,6 @@ void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev, struct mlx5e_params *
 
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk);
-u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
-			     struct mlx5e_xsk_param *xsk);
 u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params,
 				struct mlx5e_xsk_param *xsk);
 bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 0b3c9f10b597..c7c25f20ad72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -21,10 +21,6 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 			xsk->chunk_size < MLX5E_MIN_XSK_CHUNK_SIZE)
 		return false;
 
-	/* Current MTU and XSK headroom don't allow packets to fit the frames. */
-	if (mlx5e_rx_get_min_frag_sz(params, xsk) > xsk->chunk_size)
-		return false;
-
 	/* frag_sz is different for regular and XSK RQs, so ensure that linear
 	 * SKB mode is possible.
 	 */
-- 
2.37.3

