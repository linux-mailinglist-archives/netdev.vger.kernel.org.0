Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEE14DE2F8
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240870AbiCRUyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237255AbiCRUyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA05DEB7
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB5F360CA0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB35C340F6;
        Fri, 18 Mar 2022 20:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636791;
        bh=+IMVoc+yvwHIGOVU+vdGvTPAxaD059KaRrFh1eNVn8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7ZBwNGB1DvfC6wmavHOGzWFbTECMTTbCcUKHV9z+19XvJMZJwwaOmkB6K5ujuqt2
         2lDQtDd6V17vL1mUnZV8X5qpFWNuv6LC9Xr0cG8OYAtmPLGYeVXd99hzwLTm1jpyzf
         cxfuE8tEuk3Y3UPPXcwSE+bxIDFvJQsVG9pSkFz8bVAKpMuAuwZS5RXILt1tCQ9COJ
         +IKLqwQlEYKz/a+bo1b8AcV3kiM+mM5qm6KWaeunjIGb0d6mcT13zvspOxiYmq/rVS
         tv7BrLRiC0yz3xNnfpPHnVpx9MQcZ0W7RyFazBM1veFfQPnz/f8ar4ybKZD4prm0Vn
         Ga8x/B7HIbqGw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: Use page-sized fragments with XDP multi buffer
Date:   Fri, 18 Mar 2022 13:52:36 -0700
Message-Id: <20220318205248.33367-4-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The implementation of XDP in mlx5e assumes that the frame size is equal
to the page size. Force this limitation in the non-linear mode for XDP
multi buffer.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 822fbb9b80e7..9646867872c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -444,7 +444,7 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 
 	max_mtu = mlx5e_max_nonlinear_mtu(first_frag_size_max, frag_size_max,
 					  params->xdp_prog);
-	if (byte_count > max_mtu) {
+	if (byte_count > max_mtu || params->xdp_prog) {
 		frag_size_max = PAGE_SIZE;
 		first_frag_size_max = SKB_WITH_OVERHEAD(frag_size_max - headroom);
 
-- 
2.35.1

