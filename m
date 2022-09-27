Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624395ECEBD
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiI0Uhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiI0Ugz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6043813EBE
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 130EAB81C19
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996E1C433B5;
        Tue, 27 Sep 2022 20:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311011;
        bh=r51md00n9ZaRRofusiBT+GvxEm6SVEkPQ7AdUGft7+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kvk4SzU4T4zYhLmzQIEczzBBWn3q9x/qeXSCImz8RyB6wqfztnL7QMblRX02uHqvf
         i5yeqhQe742Yg7VYWnrrS34VPkNhncBaao4QlGEG86UfRxM0fKZ5RbtC2oMLO5a0fS
         IB1QzOGYlrDsoKeT7mxfCc+bIJxg5RkOwPsaxOYFmsaCTI9c2pQS5p6bfcNB8z/n2L
         vPClas5ecteGLhSMGCOO1Ulaaom1dAMK1KQkHHe+FvikhX7lU9flMgpO+5iqsU6Ri6
         gF0InQlmZB2D+sHXsOi8m1mZ+H4ZcmgaBVXwHMARlCJ5CTruHT7psn+JGP7HIJJz6i
         gZAujjgZEaB9w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 13/16] net/mlx5e: xsk: Fix SKB headroom calculation in validation
Date:   Tue, 27 Sep 2022 13:36:08 -0700
Message-Id: <20220927203611.244301-14-saeed@kernel.org>
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

In a typical scenario, if an XSK socket is opened first, then an XDP
program is attached, mlx5e_validate_xsk_param will be called twice:
first on XSK bind, second on channel restart caused by enabling XDP. The
validation includes a call to mlx5e_rx_is_linear_skb, which checks the
presence of the XDP program.

The above means that mlx5e_rx_is_linear_skb might return true the first
time, but false the second time, as mlx5e_rx_get_linear_sz_skb's return
value will increase, because of a different headroom used with XDP.

As XSK RQs never exist without XDP, it would make sense to trick
mlx5e_rx_get_linear_sz_skb into thinking XDP is enabled at the first
check as well. This way, if MTU is too big, it would be detected on XSK
bind, without giving false hope to the userspace application.

However, it turns out that this check is too restrictive in the first
place. SKBs created on XDP_PASS on XSK RQs don't have any headroom. That
means that big MTUs filtered out on the first and the second checks
might actually work.

So, address this issue in the proper way, but taking into account the
absence of the SKB headroom on XSK RQs, when calculating the buffer
size.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 23 ++++++++-----------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index c9a4a507a168..5dd3567d02d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -24,24 +24,21 @@ u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 	return headroom;
 }
 
-static u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
-				    struct mlx5e_xsk_param *xsk)
+static u32 mlx5e_rx_get_linear_sz_xsk(struct mlx5e_params *params,
+				      struct mlx5e_xsk_param *xsk)
 {
 	u32 hw_mtu = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	u16 linear_rq_headroom = mlx5e_get_linear_rq_headroom(params, xsk);
 
-	return linear_rq_headroom + hw_mtu;
+	return xsk->headroom + hw_mtu;
 }
 
-static u32 mlx5e_rx_get_linear_sz_xsk(struct mlx5e_params *params,
-				      struct mlx5e_xsk_param *xsk)
+static u32 mlx5e_rx_get_linear_sz_skb(struct mlx5e_params *params, bool xsk)
 {
-	return mlx5e_rx_get_min_frag_sz(params, xsk);
-}
+	/* SKBs built on XDP_PASS on XSK RQs don't have headroom. */
+	u16 headroom = xsk ? 0 : mlx5e_get_linear_rq_headroom(params, NULL);
+	u32 hw_mtu = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 
-static u32 mlx5e_rx_get_linear_sz_skb(struct mlx5e_params *params)
-{
-	return MLX5_SKB_FRAG_SZ(mlx5e_rx_get_min_frag_sz(params, NULL));
+	return MLX5_SKB_FRAG_SZ(headroom + hw_mtu);
 }
 
 static u32 mlx5e_rx_get_linear_stride_sz(struct mlx5e_params *params,
@@ -57,7 +54,7 @@ static u32 mlx5e_rx_get_linear_stride_sz(struct mlx5e_params *params,
 	if (params->xdp_prog)
 		return PAGE_SIZE;
 
-	return roundup_pow_of_two(mlx5e_rx_get_linear_sz_skb(params));
+	return roundup_pow_of_two(mlx5e_rx_get_linear_sz_skb(params, false));
 }
 
 u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params,
@@ -77,7 +74,7 @@ bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params,
 	/* Both XSK and non-XSK cases allocate an SKB on XDP_PASS. Packet data
 	 * must fit into a CPU page.
 	 */
-	if (mlx5e_rx_get_linear_sz_skb(params) > PAGE_SIZE)
+	if (mlx5e_rx_get_linear_sz_skb(params, xsk) > PAGE_SIZE)
 		return false;
 
 	/* XSK frames must be big enough to hold the packet data. */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 84cd86ff64d4..f8d45360a643 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4009,7 +4009,7 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
 			 * 2. Size of SKBs allocated on XDP_PASS <= PAGE_SIZE.
 			 */
 			max_mtu_frame = MLX5E_HW2SW_MTU(new_params, xsk.chunk_size - hr);
-			max_mtu_page = mlx5e_xdp_max_mtu(new_params, &xsk);
+			max_mtu_page = MLX5E_HW2SW_MTU(new_params, SKB_MAX_HEAD(0));
 			max_mtu = min(max_mtu_frame, max_mtu_page);
 
 			netdev_err(netdev, "MTU %d is too big for an XSK running on channel %u. Try MTU <= %d\n",
-- 
2.37.3

