Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E84D3D83D5
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhG0XVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232995AbhG0XU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70D5460241;
        Tue, 27 Jul 2021 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428055;
        bh=GFUpMLYn2ySkaVYyMU0chcIm9IhRSaUM1EXqj9SPtcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNSA/tVLkEI4YnAfEzrKEQ+J4lM78I7fPfNqnMmHXT9/nRs4zQ5/1QEleYL+0eWCM
         7Y7j0L/EXgoAk2isAE9jw7RXXPmiLK+U7ItCxa1NgMZz7a6F/NdZsQWLignQhIUUBZ
         vhoHDhmq69goRSSo3QojdWh/R/kdPeXTckIBliZ2UwqAFizfmPKeXsVShXkyGe/UiU
         PoWGhGLyoxYwxIA2e5hyM5zYABx8rq1AdIpFGhGMB7Ro+xn16Emo+p8aJH7Figb+xk
         5KrOO/nDr6ZtHBKbYNvd0rscVT9UwFwwOWNJq41HuqsD/TE2XpjeelK8jkvNsqv6nL
         4xywtJ21NIVOg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/12] net/mlx5e: Add NETIF_F_HW_TC to hw_features when HTB offload is available
Date:   Tue, 27 Jul 2021 16:20:44 -0700
Message-Id: <20210727232050.606896-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

If a feature flag is only present in features, but not in hw_features,
the user can't reset it. Although hw_features may contain NETIF_F_HW_TC
by the point where the driver checks whether HTB offload is supported,
this flag is controlled by another condition that may not hold. Set it
explicitly to make sure the user can disable it.

Fixes: 214baf22870c ("net/mlx5e: Support HTB offload")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c6f99fc77411..c5a2e3e6fe4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4870,6 +4870,9 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	if (MLX5_CAP_ETH(mdev, scatter_fcs))
 		netdev->hw_features |= NETIF_F_RXFCS;
 
+	if (mlx5_qos_is_supported(mdev))
+		netdev->hw_features |= NETIF_F_HW_TC;
+
 	netdev->features          = netdev->hw_features;
 
 	/* Defaults */
@@ -4890,8 +4893,6 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 		netdev->hw_features	 |= NETIF_F_NTUPLE;
 #endif
 	}
-	if (mlx5_qos_is_supported(mdev))
-		netdev->features |= NETIF_F_HW_TC;
 
 	netdev->features         |= NETIF_F_HIGHDMA;
 	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
-- 
2.31.1

