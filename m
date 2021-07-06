Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF77D3BCEF8
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhGFL1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234990AbhGFLZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C60E610C7;
        Tue,  6 Jul 2021 11:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570365;
        bh=MnWRg8O598uw45XJPMdWCTc8gdgBnSuLbsps9RCIGoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfVbKCmZwEvj0YbNpM59ij9fOf/INUaD7V63j3gdVyNZlIWtjCOK1t3vE55IDNImS
         UqVLEbRAHsGDBqT19wH3CAXgsnErfz/CyHavZCugPrmO+7OuugXh64lBT9zZdfhJP5
         Gtf2LgCfX80DWWgLuH4pXUZK/GJ4OaReoZogOsijYzNAGDerow6ORQQTO0adx062Sd
         jz5Y/T/cm6qkCse6h/OzJWsZkgxOaIj8vNJAvvDms9hSgO53po9NWfDxk670pKfSnP
         JjFyTdrWcie5M3jnPWHf9YBuLbeNE6P7JNP4OUgWpxaTGxexBNSNPs3FAyRQv3i3l5
         3c2SnKwwlHgBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 043/160] net/mlx5: Fix lag port remapping logic
Date:   Tue,  6 Jul 2021 07:16:29 -0400
Message-Id: <20210706111827.2060499-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 83a05371e2aa..8d029401ca6c 100644
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

