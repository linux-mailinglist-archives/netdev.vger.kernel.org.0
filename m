Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591693450B4
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbhCVU0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:26:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231331AbhCVUZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25546619A4;
        Mon, 22 Mar 2021 20:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616444735;
        bh=IJC7vxBm4wOCHhacfNjJC1LmHxhi7h8ZLK2DxTaocnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvuZOezh5g0evWQR73la1QJozaFon4hcZ9k9oZfgZgaUjf75AUsDs67tC3Rv/oeNb
         cgmPfdJV19kxpY7in3uJX6R3FJt51BgiEakY8NLI6GO+sWXpLT0LIb9+Gjm0a1SXnX
         AIa8jdrnFTtLjc2pccEQWW2IFVz5MBp8FL/E1eFHrpZLwIfFLOWOV4Gi1RR3lJ0S2c
         hHJtnMGH6GKXZXOwJpd97E2v+K05Quld0jzRC7ddqH8TSqXsgTdGvdOS+jEvffdn2f
         voPdGMua5pD5DBwmCvox0/mgb7S6H1u2raBVU9Y80Vk+/gDJ4zOtdMFb1CXz0AC9+K
         sRC5tdT+OzouA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/6] net/mlx5e: Fix division by 0 in mlx5e_select_queue
Date:   Mon, 22 Mar 2021 13:25:23 -0700
Message-Id: <20210322202524.68886-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322202524.68886-1-saeed@kernel.org>
References: <20210322202524.68886-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

mlx5e_select_queue compares num_tc_x_num_ch to real_num_tx_queues to
determine if HTB and/or PTP offloads are active. If they are, it
calculates netdev_pick_tx() % num_tc_x_num_ch to prevent it from
selecting HTB and PTP queues for regular traffic. However, before the
channels are first activated, num_tc_x_num_ch is zero. If
ndo_select_queue gets called at this point, the HTB/PTP check will pass,
and mlx5e_select_queue will attempt to take a modulo by num_tc_x_num_ch,
which equals to zero.

This commit fixes the bug by assigning num_tc_x_num_ch to a non-zero
value before registering the netdev.

Fixes: 214baf22870c ("net/mlx5e: Support HTB offload")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c8b8249846a9..158f947a8503 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4979,6 +4979,11 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 				     priv->max_nch);
 	params->num_tc       = 1;
 
+	/* Set an initial non-zero value, so that mlx5e_select_queue won't
+	 * divide by zero if called before first activating channels.
+	 */
+	priv->num_tc_x_num_ch = params->num_channels * params->num_tc;
+
 	/* SQ */
 	params->log_sq_size = is_kdump_kernel() ?
 		MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE :
-- 
2.30.2

