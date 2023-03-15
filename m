Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D636BC04D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbjCOW7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbjCOW7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DCEA3B5F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33E9661EAD
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF30AC4339C;
        Wed, 15 Mar 2023 22:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921137;
        bh=uSHOaJ+YRmaKOcG3VWebM3h4V5yaz47cOLlSn9MAqOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1VW6SUWcfX/6PActL8wgbBrFmq59TjoNDQM1Vfx5dhHPx5X+QviTrHC5bKXU2aUK
         R86N4HDORKgKhQBSg5EzD9+ez3W3sGrrU2xFCBlVAY1e9fivl5Bx9ixXRrDNa7K7Y4
         v2xYO55Ez8EaKlBl+aXwO1FR25lGIxkT1AiNpcq4NNllno1G5fLGqiFSEvmEHScRJg
         +3E3Yfcyk93l8O4zyecvL/IFw56t97gKgzEdA6ORboz7g5kJ7LgVF/SUUBAGWj1Gan
         x0LXnVJT1j7vm43pJct//ytRVJQSSZ5w5J3nGag7ThkaDXC9IAFCSRZ7phiqHHvugG
         BVbj2fGKuw0hw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net V2 10/14] net/mlx5e: Lower maximum allowed MTU in XSK to match XDP prerequisites
Date:   Wed, 15 Mar 2023 15:58:43 -0700
Message-Id: <20230315225847.360083-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315225847.360083-1-saeed@kernel.org>
References: <20230315225847.360083-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adham Faris <afaris@nvidia.com>

XSK redirecting XDP programs require linearity, hence applies
restrictions on the MTU. For PAGE_SIZE=4K, MTU shouldn't exceed 3498.

Features that contradict with XDP such HW-LRO and HW-GRO are enforced
by the driver in advance, during XSK params validation, except for MTU,
which was not enforced before this patch.

This has been spotted during test scenario described below:
Attaching xdpsock program (PAGE_SIZE=4K), with MTU < 3498, detaching
XDP program, changing the MTU to arbitrary value in the range
[3499, 3754], attaching XDP program again, which ended up with failure
since MTU is > 3498.

This commit lowers the XSK MTU limitation to be aligned with XDP MTU
limitation, since XSK socket is meaningless without XDP program.

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 56fc2aebb9ee..a7f2ab22cc40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4169,13 +4169,17 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
 		struct xsk_buff_pool *xsk_pool =
 			mlx5e_xsk_get_pool(&chs->params, chs->params.xsk, ix);
 		struct mlx5e_xsk_param xsk;
+		int max_xdp_mtu;
 
 		if (!xsk_pool)
 			continue;
 
 		mlx5e_build_xsk_param(xsk_pool, &xsk);
+		max_xdp_mtu = mlx5e_xdp_max_mtu(new_params, &xsk);
 
-		if (!mlx5e_validate_xsk_param(new_params, &xsk, mdev)) {
+		/* Validate XSK params and XDP MTU in advance */
+		if (!mlx5e_validate_xsk_param(new_params, &xsk, mdev) ||
+		    new_params->sw_mtu > max_xdp_mtu) {
 			u32 hr = mlx5e_get_linear_rq_headroom(new_params, &xsk);
 			int max_mtu_frame, max_mtu_page, max_mtu;
 
@@ -4185,9 +4189,9 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
 			 */
 			max_mtu_frame = MLX5E_HW2SW_MTU(new_params, xsk.chunk_size - hr);
 			max_mtu_page = MLX5E_HW2SW_MTU(new_params, SKB_MAX_HEAD(0));
-			max_mtu = min(max_mtu_frame, max_mtu_page);
+			max_mtu = min3(max_mtu_frame, max_mtu_page, max_xdp_mtu);
 
-			netdev_err(netdev, "MTU %d is too big for an XSK running on channel %u. Try MTU <= %d\n",
+			netdev_err(netdev, "MTU %d is too big for an XSK running on channel %u or its redirection XDP program. Try MTU <= %d\n",
 				   new_params->sw_mtu, ix, max_mtu);
 			return false;
 		}
-- 
2.39.2

