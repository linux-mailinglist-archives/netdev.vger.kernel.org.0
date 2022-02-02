Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812184A6B3D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbiBBFHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:07:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49114 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiBBFGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C87C6171B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2019EC340F0;
        Wed,  2 Feb 2022 05:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778399;
        bh=HqptEBPR0BoZS45tx0Mil95yr7phqZpe8Fa0/NEIqlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAfEhrlh6RUlj94/600vnoiRPrYjq2+qNgsIsn7NzD9NUPjUoRIvo3bz2OSu/+MMM
         Y/0UY7dCf44cW8P4I5bAUiIFxMmcJMax04Zc1vJ0Ae7oG+8ImwZ7qApYs9ZUGNMgyW
         XBjd97BkIXOepdNnO6uzc3rKrlJQkT+NN/ItYh7AjHt72XYRp8gh012tPiQmpZ9Jnk
         wHoteHMX6hX/NcXdQEStenICDXui2K+CfE6INfFWkW32jJajF6eRsx66jhczJBw0pM
         aj71c5r7LpYGlGXqk8bG9fW5flIoi/EhyzYKLt2SJN55253UAJcen8HPI82CtvlxM6
         Zarnofrj7BTIw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 13/18] net/mlx5e: Don't treat small ceil values as unlimited in HTB offload
Date:   Tue,  1 Feb 2022 21:03:59 -0800
Message-Id: <20220202050404.100122-14-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The hardware spec defines max_average_bw == 0 as "unlimited bandwidth".
max_average_bw is calculated as `ceil / BYTES_IN_MBIT`, which can become
0 when ceil is small, leading to an undesired effect of having no
bandwidth limit.

This commit fixes it by rounding up small values of ceil to 1 Mbit/s.

Fixes: 214baf22870c ("net/mlx5e: Support HTB offload")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 00449df98a5e..c1e07496c89c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -570,7 +570,8 @@ static int mlx5e_htb_convert_rate(struct mlx5e_priv *priv, u64 rate,
 
 static void mlx5e_htb_convert_ceil(struct mlx5e_priv *priv, u64 ceil, u32 *max_average_bw)
 {
-	*max_average_bw = div_u64(ceil, BYTES_IN_MBIT);
+	/* Hardware treats 0 as "unlimited", set at least 1. */
+	*max_average_bw = max_t(u32, div_u64(ceil, BYTES_IN_MBIT), 1);
 
 	qos_dbg(priv->mdev, "Convert: ceil %llu -> max_average_bw %u\n",
 		ceil, *max_average_bw);
-- 
2.34.1

