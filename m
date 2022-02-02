Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E9A4A6B2B
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiBBFGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48992 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiBBFGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 929AB616B5
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7664C340EF;
        Wed,  2 Feb 2022 05:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778392;
        bh=rBzXw6WeDuhxQRJ9OJ5RnS89zcizQ+Mpg63fGCqydgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXFCKlJOw/oys+QeZLi9gdn9Nw/J+1jU/UqpiXD6McCgOZJjfKPTPuIlpiGa70add
         m53Ydjts4/e7tyrHHgwmGjPXPAIZSKXKg0xAPO8BF7s6fB1VcIqqHwDz6PVkoBk8oA
         OV6k+/tg1G23eanUIhGVbHhAS0wYf0U5oje5fIo0pzvRB3xCQP+/IWoP+jw4vc/oyT
         PvD78f9F+E/pgZucxioZBdPNQ2FsGO4h7Z9AeSFMbIQyHDQOdaou1L9pUdx2L5tAJ9
         jt2ylYu+HSvIE5sNTI+7LknJ71jjOKDL7JWY23kJYlpP8QqrqFSUeHWJJ5zPQeQoip
         VMBqZ95DpDTDA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/18] net/mlx5: Bridge, take rtnl lock in init error handler
Date:   Tue,  1 Feb 2022 21:03:47 -0800
Message-Id: <20220202050404.100122-2-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

The mlx5_esw_bridge_cleanup() is expected to be called with rtnl lock
taken, which is true for mlx5e_rep_bridge_cleanup() function but not for
error handling code in mlx5e_rep_bridge_init(). Add missing rtnl
lock/unlock calls and extend both mlx5_esw_bridge_cleanup() and its dual
function mlx5_esw_bridge_init() with ASSERT_RTNL() to verify the invariant
from now on.

Fixes: 7cd6a54a8285 ("net/mlx5: Bridge, handle FDB events")
Fixes: 19e9bfa044f3 ("net/mlx5: Bridge, add offload infrastructure")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c    | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index c6d2f8c78db7..d5cb27667005 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -509,7 +509,9 @@ void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 err_register_swdev:
 	destroy_workqueue(br_offloads->wq);
 err_alloc_wq:
+	rtnl_lock();
 	mlx5_esw_bridge_cleanup(esw);
+	rtnl_unlock();
 }
 
 void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index f690f430f40f..05e08cec5a8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1574,6 +1574,8 @@ struct mlx5_esw_bridge_offloads *mlx5_esw_bridge_init(struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_bridge_offloads *br_offloads;
 
+	ASSERT_RTNL();
+
 	br_offloads = kvzalloc(sizeof(*br_offloads), GFP_KERNEL);
 	if (!br_offloads)
 		return ERR_PTR(-ENOMEM);
@@ -1590,6 +1592,8 @@ void mlx5_esw_bridge_cleanup(struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_bridge_offloads *br_offloads = esw->br_offloads;
 
+	ASSERT_RTNL();
+
 	if (!br_offloads)
 		return;
 
-- 
2.34.1

