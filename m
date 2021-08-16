Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6613EDF39
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhHPVTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233539AbhHPVTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98DC2610C7;
        Mon, 16 Aug 2021 21:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629148748;
        bh=n177wCw/ahBYbujCMLHbayOc13m2Lg0PvB+jA4cnY1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5NcRWg5o89XIa2QqH9F5EjyAm70kEbKjBG0zJCPiuciWSj1v2DqgwqYBcb47/0tk
         DQ+Q51AEcOOc3UCPWrKMxZvQ3eONRSa9yxVyF7J14dFbbl+tLV7qmRL5LXf4bzn5ld
         DBFAeO1/RuPFAMjwmIRKd3bL9Rogd8nv7cJa7ya3behbG/nq8172JepnRTxZ/7SDmh
         wqRQpumBWAvYgCGIUxAcq3tlgWy8xuDgEkyJFaBPd8KeA+SZduMBwGHJOFUtNcvwE5
         PrFIow8AxefK1LCrwC2Y36sozLI7wm+SpQGparvhgfTHobwLfeXegXb4qo0LpirzeL
         lqBvGeA8X25Uw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/17] net/mlx5: Bridge, obtain core device from eswitch instead of priv
Date:   Mon, 16 Aug 2021 14:18:43 -0700
Message-Id: <20210816211847.526937-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816211847.526937-1-saeed@kernel.org>
References: <20210816211847.526937-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patches in series will pass bond device to bridge, which means
the code can't assume the device is mlx5 representor. Moreover, the core
device can be easily obtained from eswitch instance, so there is no reason
for more complex code that obtains struct mlx5_priv from net_device in
order to use its mdev. Refactor the code to use esw->dev instead of
priv->mdev.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 4bca480e3e7d..e2963d8d5302 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -912,7 +912,6 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 	struct mlx5_esw_bridge_fdb_entry *entry;
 	struct mlx5_flow_handle *handle;
 	struct mlx5_fc *counter;
-	struct mlx5e_priv *priv;
 	int err;
 
 	if (bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG && vid) {
@@ -921,7 +920,6 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 			return ERR_CAST(vlan);
 	}
 
-	priv = netdev_priv(dev);
 	entry = kvzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return ERR_PTR(-ENOMEM);
@@ -934,7 +932,7 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 	if (added_by_user)
 		entry->flags |= MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER;
 
-	counter = mlx5_fc_create(priv->mdev, true);
+	counter = mlx5_fc_create(esw->dev, true);
 	if (IS_ERR(counter)) {
 		err = PTR_ERR(counter);
 		goto err_ingress_fc_create;
@@ -994,7 +992,7 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 err_ingress_filter_flow_create:
 	mlx5_del_flow_rules(entry->ingress_handle);
 err_ingress_flow_create:
-	mlx5_fc_destroy(priv->mdev, entry->ingress_counter);
+	mlx5_fc_destroy(esw->dev, entry->ingress_counter);
 err_ingress_fc_create:
 	kvfree(entry);
 	return ERR_PTR(err);
-- 
2.31.1

