Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901346C561B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjCVUDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbjCVUC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:02:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF3F6C194;
        Wed, 22 Mar 2023 12:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C391CB81DEC;
        Wed, 22 Mar 2023 19:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F40C4339B;
        Wed, 22 Mar 2023 19:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515155;
        bh=ka09scpr85fTJaNZZ/TCmNGG300rxFPGXllP186sa8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nts8UoKjhbwVUur8fuBDPlIqbYWVOfH0v8q46PPbNiRRMcp6AbASPZWmRCXn7pLVv
         TA1bj+MyCtc5ZL2glIi7IK0IYbGHiOEPeuDPtcjeuwRjc3a6zZe1S1q3OU7gaYM0Jq
         kv1Y7PuPsCClAoyPew6xlUyN3kzQE7JoXpvDj8hsFFY8RJZmU1Xhk2TPldBTo8xGBC
         cRlr5Kjd0MVYvQtPdKW3dXfAgEjpfVOpqMNOwmGqAaSKnyOiYAAr88ATK+lUR504Ig
         /Vo1e9snsrgve7qVoQRexyTN/O+u91z6aoMFgObOPChqDayLPavfkt9/TngJNHcxer
         Tq3Uy46IEdJzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adham Faris <afaris@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 38/45] net/mlx5e: Lower maximum allowed MTU in XSK to match XDP prerequisites
Date:   Wed, 22 Mar 2023 15:56:32 -0400
Message-Id: <20230322195639.1995821-38-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
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
index 6c24f33a5ea5c..a859c8ce1d664 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4113,13 +4113,17 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
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
 
@@ -4129,9 +4133,9 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
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

