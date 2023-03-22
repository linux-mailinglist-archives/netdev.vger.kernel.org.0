Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8936C5690
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjCVUHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjCVUGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:06:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2006B74A76;
        Wed, 22 Mar 2023 13:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DCF962276;
        Wed, 22 Mar 2023 20:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7B9C4339C;
        Wed, 22 Mar 2023 20:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515268;
        bh=0pjuCuTn14yAvRcnG0mq+6qbIJfHZ9DHNONHwyNzqZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fixgxbGSw25UtgNqSwQXpCBogI7x9yk4vCdnuhg7CyEVV+N39YvS8UVP838vKRIsl
         HcwBvVarumqAx5Rlgh/0aqzlz5wpDRjLc6OFBtESTWoZxbFJDxn5NWtRg66SJk3p5k
         bmwsdDXgASpaDdwZlg65ULbXeyxfpctmXo7rUvA60cagRnpSLP8Vsq5t7B8l5FSR4o
         xJNaLPkEKVvYeic5FScWvIZXmiNl34+tVComELo8c2766c3f+i1E+DOT8wVV4SpTHT
         sr4DqnYrVBxLBJFOSrA6Fc80JC3MJB8RHwH5RcUdDYB9BrQtGJ8jDfjIdVoiuxJulm
         ECKP+iebUtAzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adham Faris <afaris@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 27/34] net/mlx5e: Lower maximum allowed MTU in XSK to match XDP prerequisites
Date:   Wed, 22 Mar 2023 15:59:19 -0400
Message-Id: <20230322195926.1996699-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adham Faris <afaris@nvidia.com>

[ Upstream commit 78dee7befd56987283c13877b834c0aa97ad51b9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 142ed2d98cd5d..738f329dc7808 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4100,13 +4100,17 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
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
 
@@ -4116,9 +4120,9 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
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

