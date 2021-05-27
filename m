Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58269392682
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhE0Eii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234342AbhE0EiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F5CE61181;
        Thu, 27 May 2021 04:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090201;
        bh=7BsEfHyC8454XzpOVzpjPhIIGS6Lzi6AC9Yy8bVJ6MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ny8SHZ5sA757UCT354NrKQqocetIGWx2/WzLsOqIum5FFWBYr9YrNcHgO6DVA4BRw
         RZfk9pbz0uO4ix6VWE8j+ZDBhcpvQwNYAK9nZGq/x78z4sT8gLmDC4+KWqnc4LgjvT
         4cHsOgrvXGc9jIa9NzAO5zKsN3UNHfFt7jomgIH7wBnvaCAme2/49qV1QUlIduWKQn
         tGf7RcKAQRzGfaeTzhGFbL1FY+SNWCZZGMeM62NGifGgEQxf4mlnsIg56WPqLEWPlg
         H885C/XBcAZj1kfBrxLpDQtVU1gkxwASa8WzTh2M9NBahcpwr4OPGa/JttBA82JuXp
         8U6bpo87+gH6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/17] net/mlx5: Fix lag port remapping logic
Date:   Wed, 26 May 2021 21:36:07 -0700
Message-Id: <20210527043609.654854-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Fix the logic so that if both ports netdevices are enabled or disabled,
use the trivial mapping without swapping.

If only one of the netdevice's tx is enabled, use it to remap traffic to
that port.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index e52e2144ab12..1fb70524d067 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -118,17 +118,24 @@ static bool __mlx5_lag_is_sriov(struct mlx5_lag *ldev)
 static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 					   u8 *port1, u8 *port2)
 {
+	bool p1en;
+	bool p2en;
+
+	p1en = tracker->netdev_state[MLX5_LAG_P1].tx_enabled &&
+	       tracker->netdev_state[MLX5_LAG_P1].link_up;
+
+	p2en = tracker->netdev_state[MLX5_LAG_P2].tx_enabled &&
+	       tracker->netdev_state[MLX5_LAG_P2].link_up;
+
 	*port1 = 1;
 	*port2 = 2;
-	if (!tracker->netdev_state[MLX5_LAG_P1].tx_enabled ||
-	    !tracker->netdev_state[MLX5_LAG_P1].link_up) {
-		*port1 = 2;
+	if ((!p1en && !p2en) || (p1en && p2en))
 		return;
-	}
 
-	if (!tracker->netdev_state[MLX5_LAG_P2].tx_enabled ||
-	    !tracker->netdev_state[MLX5_LAG_P2].link_up)
+	if (p1en)
 		*port2 = 1;
+	else
+		*port1 = 2;
 }
 
 void mlx5_modify_lag(struct mlx5_lag *ldev,
-- 
2.31.1

