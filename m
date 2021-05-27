Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B90F3935BA
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbhE0S6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236115AbhE0S6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8197F611C9;
        Thu, 27 May 2021 18:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141801;
        bh=7BsEfHyC8454XzpOVzpjPhIIGS6Lzi6AC9Yy8bVJ6MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsnuJAMRSDhuRRUN6Y3h76cR6eZurI0OI5cxy7uGpnotrkUBwdCnkL/7xmDBcMP5X
         /xC3V0VkCbmcoGW3qirZ8g/eIO5Nn9yrwCj+nLd1reiiHqZ1IqZlQiJvnOdVkW3mk3
         z+SbhDYZNt4QgOxPOinE4MXKpTuvgTOjdL2I/hjWuMYvKMxH3+94Cvf5fPZCdHdgpG
         NDHtZREtJBIeqOTWjIM1Idi0ZY1IkjCw+cYaMEqqZ2EgZ0X9SpH2Ma0lOd3vvj6eFw
         kqqFxyDOKKCYel3zB6UogZHmqqhYdO+tkPnnXGXryUIn+oMMVEUa51OXbwHaahPNZv
         6hNY+H42lPblw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 15/15] net/mlx5: Fix lag port remapping logic
Date:   Thu, 27 May 2021 11:56:24 -0700
Message-Id: <20210527185624.694304-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
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

