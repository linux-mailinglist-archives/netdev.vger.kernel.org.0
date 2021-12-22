Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017E847CBA4
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242100AbhLVDQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58374 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242112AbhLVDQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF4D4B81A61
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF1BC36AE8;
        Wed, 22 Dec 2021 03:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142978;
        bh=+roPe5xCkKTO/ZEE/4ZjGQY5nyCPONVKKuAoa6AnPu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kY2aGTO5JF9VK/1r6USYOaDUtpFwT8AJU1/zkMzrwRwC40W09Fn/268W2wqkVfNIM
         COAFASyvqdWsO0GOi7yqwYVfFHYhDTM7tW0+8880spmvTPrCzrH++yS6P5k/duDOAl
         xz2KtZfPkFU7J63HmWMGnScVNX0GXeGLPx4cEWabn5Z0o7OMgf8vJEBBsRW459FBf/
         Bl9wVOIIEOxICaOJuLNgffnP/EsVOo8CZCFRfH7XWGTj9j7wcD+GkWryuR98O32px4
         ymOorU8I8JJIyggNsUVQamJjR1kpSlQ9Ktmaf8A5LHP25Ez/9A6DgussauhC030A/J
         DBjBudaGwc2BQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Lama Kayal <lkayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 13/14] net/mlx5e: Allocate per-channel stats dynamically at first usage
Date:   Tue, 21 Dec 2021 19:16:03 -0800
Message-Id: <20211222031604.14540-14-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Make stats allocation per-channel dynamic on demand, at channel open
operation.

Previously the stats array was pre-allocated for the maximum possible
number of channels. Here we defer the per-channel stats instance allocation
upon its first usage, so that it's allocated only if really needed.

Allocating stats on demand helps maintain a more memory-efficient code,
as we're saving memory when the used number of channels is smaller than
the maximum.

The stats memory instances are still freed in mlx5e_priv_arrays_free(),
so that they are persistent to channels' closure.

Memory size allocated for struct mlx5e_channel_stats is 3648 bytes.
If maximum number of channel stands for 64, the total memory space
allocated for stats is 3648x64 = 228K bytes. In scenarios where the
number of channels in use is significantly smaller than maximum number,
the memory saved can be remarkable.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 41 +++++++++++++------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 504844097d20..1a47108805fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2176,6 +2176,30 @@ static u8 mlx5e_enumerate_lag_port(struct mlx5_core_dev *mdev, int ix)
 	return (ix + port_aff_bias) % mlx5e_get_num_lag_ports(mdev);
 }
 
+static int mlx5e_channel_stats_alloc(struct mlx5e_priv *priv, int ix, int cpu)
+{
+	if (ix > priv->stats_nch)  {
+		netdev_warn(priv->netdev, "Unexpected channel stats index %d > %d\n", ix,
+			    priv->stats_nch);
+		return -EINVAL;
+	}
+
+	if (priv->channel_stats[ix])
+		return 0;
+
+	/* Asymmetric dynamic memory allocation.
+	 * Freed in mlx5e_priv_arrays_free, not on channel closure.
+	 */
+	mlx5e_dbg(DRV, priv, "Creating channel stats %d\n", ix);
+	priv->channel_stats[ix] = kvzalloc_node(sizeof(**priv->channel_stats),
+						GFP_KERNEL, cpu_to_node(cpu));
+	if (!priv->channel_stats[ix])
+		return -ENOMEM;
+	priv->stats_nch++;
+
+	return 0;
+}
+
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
@@ -2193,6 +2217,10 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	if (err)
 		return err;
 
+	err = mlx5e_channel_stats_alloc(priv, ix, cpu);
+	if (err)
+		return err;
+
 	c = kvzalloc_node(sizeof(*c), GFP_KERNEL, cpu_to_node(cpu));
 	if (!c)
 		return -ENOMEM;
@@ -5153,7 +5181,6 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	priv->netdev      = netdev;
 	priv->msglevel    = MLX5E_MSG_LEVEL;
 	priv->max_nch     = nch;
-	priv->stats_nch   = nch;
 	priv->max_opened_tc = 1;
 
 	if (!alloc_cpumask_var(&priv->scratchpad.cpumask, GFP_KERNEL))
@@ -5196,20 +5223,8 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	if (!priv->channel_stats)
 		goto err_free_channel_tc2realtxq;
 
-	for (i = 0; i < priv->stats_nch; i++) {
-		priv->channel_stats[i] = kvzalloc_node(sizeof(**priv->channel_stats),
-						       GFP_KERNEL, node);
-		if (!priv->channel_stats[i])
-			goto err_free_channel_stats;
-	}
-
 	return 0;
 
-err_free_channel_stats:
-	while (--i >= 0)
-		kvfree(priv->channel_stats[i]);
-	kfree(priv->channel_stats);
-	i = nch;
 err_free_channel_tc2realtxq:
 	while (--i >= 0)
 		kfree(priv->channel_tc2realtxq[i]);
-- 
2.33.1

