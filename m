Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902F342AE3F
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbhJLUzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 16:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235135AbhJLUzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 16:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46B2760F3A;
        Tue, 12 Oct 2021 20:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634072011;
        bh=FCJJXytzF05DhKpVRK6b4tV5ryR7HR9uoUVEPuhczhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoLPti8A6oc/jkUweLYK7GWoAHflx96ZSM9vQIXLM1qYuNcdWQfQqCJGp0j/oNVBd
         g6mizTXu2mWJ6i5ExdxJ6UnuVVxX5hZuVyXO3H/aAGKWyf1G73nhwxnkDyYhBi51TA
         TxdC/CvSDEqJTUDM1KkXePZOTRBVqgweWr0zILayTIrAAKz31Dldv8iHWdTK9EIptR
         ro4CqokS3+Pis/lJe+D+hqknEbABep7k/O50TbVxLjt6N3d07XGRQhyx3yP7tw9ZPe
         v4tNMRJqg0+N2JEO7ShQP1RrLvNUcwbgSe7qX9z/1drU6tN8HM9eBHAAt1ZUnfD3Vl
         OrrIEwOZGqVnA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/6] net/mlx5e: Fix division by 0 in mlx5e_select_queue for representors
Date:   Tue, 12 Oct 2021 13:53:23 -0700
Message-Id: <20211012205323.20123-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012205323.20123-1-saeed@kernel.org>
References: <20211012205323.20123-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Commit 846d6da1fcdb ("net/mlx5e: Fix division by 0 in
mlx5e_select_queue") makes mlx5e_build_nic_params assign a non-zero
initial value to priv->num_tc_x_num_ch, so that mlx5e_select_queue
doesn't fail with division by 0 if called before the first activation of
channels. However, the initialization flow of representors doesn't call
mlx5e_build_nic_params, so this bug can still happen with representors.

This commit fixes the bug by adding the missing assignment to
mlx5e_build_rep_params.

Fixes: 846d6da1fcdb ("net/mlx5e: Fix division by 0 in mlx5e_select_queue")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0439203fc7d9..0684ac6699b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -618,6 +618,11 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	params->mqprio.num_tc       = 1;
 	params->tunneled_offload_en = false;
 
+	/* Set an initial non-zero value, so that mlx5e_select_queue won't
+	 * divide by zero if called before first activating channels.
+	 */
+	priv->num_tc_x_num_ch = params->num_channels * params->mqprio.num_tc;
+
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
 }
 
-- 
2.31.1

