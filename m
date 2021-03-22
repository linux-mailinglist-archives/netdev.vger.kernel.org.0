Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53983450B3
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhCVU0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231191AbhCVUZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:25:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB895619A3;
        Mon, 22 Mar 2021 20:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616444735;
        bh=PROEm4XWinY+KY3Y9/LiV1/m1e1BYesFZdyMLA9qNs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fk2y+JaoZLiRPoNmXYYa/2JIzkzlIRYUClzC99p6fvaet8BAZ3RBKxUKNJehRvfe9
         fowTZv2Sqw1G2AKULYvnpmJASlAMIrQ73XoVj6vErckFIbYLoLm1t1RZ4AeA0ag6BC
         H+HqwQbf6PefmmrYnme3IBIUg3NrUk7UfM+lkTAN3s95K83YwIL89PsMCZ7wG0j8My
         yMEUKGms0LznMzYlTnBXv0JXGrO38DEdDIsDgXResZNlKaP9AjjTqmf4biACf85KgX
         vWkIjzf2IKQpWvVXcVcNSQg/AbRcqEUv1R5GN6hG8Zak+VDaHY6IhqkUoOoJaahDH7
         t3YmmeeBq/AAA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/6] net/mlx5e: Fix error path for ethtool set-priv-flag
Date:   Mon, 22 Mar 2021 13:25:22 -0700
Message-Id: <20210322202524.68886-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322202524.68886-1-saeed@kernel.org>
References: <20210322202524.68886-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Expose error value when failing to comply to command:
$ ethtool --set-priv-flags eth2 rx_cqe_compress [on/off]

Fixes: be7e87f92b58 ("net/mlx5e: Fail safe cqe compressing/moderation mode setting")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 0e059d5c57ac..f5f2a8fd0046 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1887,6 +1887,7 @@ static int set_pflag_rx_cqe_compress(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
+	int err;
 
 	if (!MLX5_CAP_GEN(mdev, cqe_compression))
 		return -EOPNOTSUPP;
@@ -1896,7 +1897,10 @@ static int set_pflag_rx_cqe_compress(struct net_device *netdev,
 		return -EINVAL;
 	}
 
-	mlx5e_modify_rx_cqe_compression_locked(priv, enable);
+	err = mlx5e_modify_rx_cqe_compression_locked(priv, enable);
+	if (err)
+		return err;
+
 	priv->channels.params.rx_cqe_compress_def = enable;
 
 	return 0;
-- 
2.30.2

