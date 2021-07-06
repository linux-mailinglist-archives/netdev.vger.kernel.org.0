Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1267D3BD5B1
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbhGFMYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234322AbhGFLd3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:33:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64D1E61D26;
        Tue,  6 Jul 2021 11:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570573;
        bh=cJMaaJMtowFiLkow7PjF58jLQoCxdhCoY6hKVUPpwH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H15VWorYexT/ZA9TXme5lskXYCpbcRHWv3WsEHTBaGoFkM6c6U2DpCYH1hMj4V+q9
         kLlYSUDLzM+/BCtUmk6+nSLXz34+kmvBH5NM1zFaoAWXO1v57NRG76oGLDh1W75iw8
         6Q+X/CCqlB0KeK2bagGSLg6w45fn0yOG4/9PL8SgH5KDTi3+7msmJ+Sq32wxh5wV7b
         xPr22sRlr08xl00a9mlOjqnhf2VbjQHkbIRCjl/f5iePbYtvnCvf66eRG12Z5f62IS
         zATqCnU+I6wMY7v1MCpo3VREM+pkVVbwQrvsfwrBVue/rnaansLbtae+uGUNRZKmI5
         pVRrX2/BYPipw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 038/137] net/mlx5: Fix lag port remapping logic
Date:   Tue,  6 Jul 2021 07:20:24 -0400
Message-Id: <20210706112203.2062605-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 8613641063617c1dfc731b403b3ee4935ef15f87 ]

Fix the logic so that if both ports netdevices are enabled or disabled,
use the trivial mapping without swapping.

If only one of the netdevice's tx is enabled, use it to remap traffic to
that port.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 9025e5f38bb6..fe5476a76464 100644
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
2.30.2

