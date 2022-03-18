Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FDF4DE2EF
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240874AbiCRUym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240825AbiCRUyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A89DEE7
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 326EFB8257F
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894ECC340F4;
        Fri, 18 Mar 2022 20:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636790;
        bh=x3nZ+bCcab6JNcMR4e7NLvLL2CLLpt+d5R29q4bWxXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujS0Bj5rV7Stj2erMt4q7DOwZH+Wtbg6VCgwzND/saK34N0Sez75IuLdlS8CrfIWt
         B30Fi35HMtl92naC1o41gnAIvSGiTORVIjzH5qDAmNqukJRuvvOSgiNzpIS8wAHwP+
         9Q4uuhXQE/6OMWn0Ah4iNFXjafpr0oyZXaM+TD5Uhv7Fnr6g5SLW4Y8hbYfVWPvGxo
         q2SMsh1JdzgdMcrNKJtwseVkMajDRnGPLhtNSiBSinCsp1VfkzAltRUF9f+zsn5IVy
         hBbUky7cyDqFIpT3licAki3bY7+MfZRLY7l9IxKF0AFRtwocGPoY4qmW8uarL/8//B
         0UUTrJadJYKBA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP
Date:   Fri, 18 Mar 2022 13:52:35 -0700
Message-Id: <20220318205248.33367-3-saeed@kernel.org>
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

XDP multi buffer implementation in the kernel assumes that all fragments
have the same size. bpf_xdp_frags_increase_tail uses this assumption to
get the size of the last fragment, and __xdp_build_skb_from_frame uses
it to calculate truesize as nr_frags * xdpf->frame_sz.

The current implementation of mlx5e uses fragments of different size in
non-linear legacy RQ. Specifically, the last fragment can be larger than
the others. It's an optimization for packets smaller than MTU.

This commit adapts mlx5e to the kernel limitations and makes it use
fragments of the same size, in order to add support for XDP multi
buffer. The change is applied only if XDP is active, otherwise the old
optimization still applies.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 5c4711be6fae..822fbb9b80e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -398,8 +398,12 @@ void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct mlx5e
 	};
 }
 
-static int mlx5e_max_nonlinear_mtu(int first_frag_size, int frag_size)
+static int mlx5e_max_nonlinear_mtu(int first_frag_size, int frag_size, bool xdp)
 {
+	if (xdp)
+		/* XDP requires all fragments to be of the same size. */
+		return first_frag_size + (MLX5E_MAX_RX_FRAGS - 1) * frag_size;
+
 	/* Optimization for small packets: the last fragment is bigger than the others. */
 	return first_frag_size + (MLX5E_MAX_RX_FRAGS - 2) * frag_size + PAGE_SIZE;
 }
@@ -438,12 +442,14 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	headroom = mlx5e_get_linear_rq_headroom(params, xsk);
 	first_frag_size_max = SKB_WITH_OVERHEAD(frag_size_max - headroom);
 
-	max_mtu = mlx5e_max_nonlinear_mtu(first_frag_size_max, frag_size_max);
+	max_mtu = mlx5e_max_nonlinear_mtu(first_frag_size_max, frag_size_max,
+					  params->xdp_prog);
 	if (byte_count > max_mtu) {
 		frag_size_max = PAGE_SIZE;
 		first_frag_size_max = SKB_WITH_OVERHEAD(frag_size_max - headroom);
 
-		max_mtu = mlx5e_max_nonlinear_mtu(first_frag_size_max, frag_size_max);
+		max_mtu = mlx5e_max_nonlinear_mtu(first_frag_size_max, frag_size_max,
+						  params->xdp_prog);
 		if (byte_count > max_mtu) {
 			mlx5_core_err(mdev, "MTU %u is too big for non-linear legacy RQ (max %d)\n",
 				      params->sw_mtu, max_mtu);
@@ -463,14 +469,18 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 		info->arr[i].frag_size = frag_size;
 		buf_size += frag_size;
 
-		if (i == 0) {
-			/* Ensure that headroom and tailroom are included. */
-			frag_size += headroom;
-			frag_size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+		if (params->xdp_prog) {
+			/* XDP multi buffer expects fragments of the same size. */
+			info->arr[i].frag_stride = frag_size_max;
+		} else {
+			if (i == 0) {
+				/* Ensure that headroom and tailroom are included. */
+				frag_size += headroom;
+				frag_size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+			}
+			info->arr[i].frag_stride = roundup_pow_of_two(frag_size);
 		}
 
-		info->arr[i].frag_stride = roundup_pow_of_two(frag_size);
-
 		i++;
 	}
 	info->num_frags = i;
-- 
2.35.1

