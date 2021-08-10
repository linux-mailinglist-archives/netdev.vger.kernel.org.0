Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE2B3E51AA
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhHJEAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236555AbhHJD77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 23:59:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E922460FC4;
        Tue, 10 Aug 2021 03:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567978;
        bh=BlUHdKSKcf8KCuupIy3A9mlqcMwqbNRMUq6tct/Fqpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkJsrIwZiToLW+PAvUsRd4zc8LFEmZdjlFppGofLjnINWbdwCgHl1TGNwI8/l1pxL
         OHpf1odbDzwyZ2URhRJV6R1tY7SIQzoH2jMJFva9EjL0XnKjvPYzTZLtxrqPhHkeC8
         Q9MAjTh6/GQoe7l15BXaQGW68t1dI7CGpSdW/B87NJjWtQ/NV5ZT84qV2OUyaKRBuq
         LGhfs6w2ulvr3okgkYNqy58xxtfTI5J0UACwajXFkzSaRLxYeF0gePknDjvdXauhgf
         B0dJJXguALuTOKhkxAUq9eMx6K0YykHOcdsD7lXPoVloNawsAE/FvumTCEEFQRXV2J
         cBVswy7UI4m7A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/12] net/mlx5: Bridge, fix ageing time
Date:   Mon,  9 Aug 2021 20:59:15 -0700
Message-Id: <20210810035923.345745-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Ageing time is not converted from clock_t to jiffies which results
incorrect ageing timeout calculation in workqueue update task. Fix it by
applying clock_t_to_jiffies() to provided value.

Fixes: c636a0f0f3f0 ("net/mlx5: Bridge, dynamic entry ageing")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index a6e1d4f78268..f3f56f32e435 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -579,7 +579,7 @@ static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 	xa_init(&bridge->vports);
 	bridge->ifindex = ifindex;
 	bridge->refcnt = 1;
-	bridge->ageing_time = BR_DEFAULT_AGEING_TIME;
+	bridge->ageing_time = clock_t_to_jiffies(BR_DEFAULT_AGEING_TIME);
 	list_add(&bridge->list, &br_offloads->bridges);
 
 	return bridge;
@@ -1006,7 +1006,7 @@ int mlx5_esw_bridge_ageing_time_set(unsigned long ageing_time, struct mlx5_eswit
 	if (!vport->bridge)
 		return -EINVAL;
 
-	vport->bridge->ageing_time = ageing_time;
+	vport->bridge->ageing_time = clock_t_to_jiffies(ageing_time);
 	return 0;
 }
 
-- 
2.31.1

