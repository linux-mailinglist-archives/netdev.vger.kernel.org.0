Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8723C4DA
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404272AbfFKHUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:20:16 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37637 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404268AbfFKHUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:20:15 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CCD4D224C0;
        Tue, 11 Jun 2019 03:20:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 03:20:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=RjRPeVHq8rKBEb5IrIPyroAW3g6dHk+abFHoWNvdfXY=; b=cAwVTSSM
        Xh+//HAgIEjN8wLNClXezHje1La6Vl2/OZrAb+2wOi2GCdEuCORQFwI4r/emf9b9
        k0t5qgWH0uRZZQO9JqeCEJFECFIFEut18KwhEc5HX09cqbazg8RCfaIWsDZHAd8w
        V7gSUlVw9sOOD4eqNwIy2fmtu3K4EH6TIBLHDfxZIHXzAcysAPYSK0MLwhUgxjT/
        o+pyvc1dYUFzzdKId4R3fitZJbfpUvoqargFKIt7QO9B19iaSPnRKFIjXMQkp7jX
        AKi667PyYRxZcIR/pnNFbWrjx2i7aKWb+9Z6g8/5wyo50ldYrROVGTfGmUN/oUxR
        Uesh6OsFA9gLog==
X-ME-Sender: <xms:LVb_XKu-fNZh11YHUiCsbOFaiFvQubvfXPZoqEFCo0KGHokB0nmD6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehfedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:LVb_XLKgsYK0my3AD5hCrnbmaORrOnFFcVzweQnAwQJ0tdfYqTrGHQ>
    <xmx:LVb_XAexYVhqtmDLydreSrr4kRIrqzDY6p-sfEnnlwHHN4eqNX491g>
    <xmx:LVb_XGLxQnnQrZkL7Gd9nnAohgw8THuGiC5lXxm_CllBMsolxL5Enw>
    <xmx:LVb_XOX6P3rQ0JJMyhDkcwhZnXxb_PHSZGFtcxcyhVxiiEYyJYyWNA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4005E380088;
        Tue, 11 Jun 2019 03:20:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 2/7] mlxsw: spectrum_router: Refresh nexthop neighbour when it becomes dead
Date:   Tue, 11 Jun 2019 10:19:41 +0300
Message-Id: <20190611071946.11089-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611071946.11089-1-idosch@idosch.org>
References: <20190611071946.11089-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The driver tries to periodically refresh neighbours that are used to
reach nexthops. This is done by periodically calling neigh_event_send().

However, if the neighbour becomes dead, there is nothing we can do to
return it to a connected state and the above function call is basically
a NOP.

This results in the nexthop never being written to the device's
adjacency table and therefore never used to forward packets.

Fix this by dropping our reference from the dead neighbour and
associating the nexthop with a new neigbhour which we will try to
refresh.

Fixes: a7ff87acd995 ("mlxsw: spectrum_router: Implement next-hop routing")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alex Veber <alexve@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 73 ++++++++++++++++++-
 1 file changed, 70 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1cda8a248b12..ef554739dd54 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2363,7 +2363,7 @@ static void mlxsw_sp_router_probe_unresolved_nexthops(struct work_struct *work)
 static void
 mlxsw_sp_nexthop_neigh_update(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_neigh_entry *neigh_entry,
-			      bool removing);
+			      bool removing, bool dead);
 
 static enum mlxsw_reg_rauht_op mlxsw_sp_rauht_op(bool adding)
 {
@@ -2507,7 +2507,8 @@ static void mlxsw_sp_router_neigh_event_work(struct work_struct *work)
 
 	memcpy(neigh_entry->ha, ha, ETH_ALEN);
 	mlxsw_sp_neigh_entry_update(mlxsw_sp, neigh_entry, entry_connected);
-	mlxsw_sp_nexthop_neigh_update(mlxsw_sp, neigh_entry, !entry_connected);
+	mlxsw_sp_nexthop_neigh_update(mlxsw_sp, neigh_entry, !entry_connected,
+				      dead);
 
 	if (!neigh_entry->connected && list_empty(&neigh_entry->nexthop_list))
 		mlxsw_sp_neigh_entry_destroy(mlxsw_sp, neigh_entry);
@@ -3472,13 +3473,79 @@ static void __mlxsw_sp_nexthop_neigh_update(struct mlxsw_sp_nexthop *nh,
 	nh->update = 1;
 }
 
+static int
+mlxsw_sp_nexthop_dead_neigh_replace(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_neigh_entry *neigh_entry)
+{
+	struct neighbour *n, *old_n = neigh_entry->key.n;
+	struct mlxsw_sp_nexthop *nh;
+	bool entry_connected;
+	u8 nud_state, dead;
+	int err;
+
+	nh = list_first_entry(&neigh_entry->nexthop_list,
+			      struct mlxsw_sp_nexthop, neigh_list_node);
+
+	n = neigh_lookup(nh->nh_grp->neigh_tbl, &nh->gw_addr, nh->rif->dev);
+	if (!n) {
+		n = neigh_create(nh->nh_grp->neigh_tbl, &nh->gw_addr,
+				 nh->rif->dev);
+		if (IS_ERR(n))
+			return PTR_ERR(n);
+		neigh_event_send(n, NULL);
+	}
+
+	mlxsw_sp_neigh_entry_remove(mlxsw_sp, neigh_entry);
+	neigh_entry->key.n = n;
+	err = mlxsw_sp_neigh_entry_insert(mlxsw_sp, neigh_entry);
+	if (err)
+		goto err_neigh_entry_insert;
+
+	read_lock_bh(&n->lock);
+	nud_state = n->nud_state;
+	dead = n->dead;
+	read_unlock_bh(&n->lock);
+	entry_connected = nud_state & NUD_VALID && !dead;
+
+	list_for_each_entry(nh, &neigh_entry->nexthop_list,
+			    neigh_list_node) {
+		neigh_release(old_n);
+		neigh_clone(n);
+		__mlxsw_sp_nexthop_neigh_update(nh, !entry_connected);
+		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nh_grp);
+	}
+
+	neigh_release(n);
+
+	return 0;
+
+err_neigh_entry_insert:
+	neigh_entry->key.n = old_n;
+	mlxsw_sp_neigh_entry_insert(mlxsw_sp, neigh_entry);
+	neigh_release(n);
+	return err;
+}
+
 static void
 mlxsw_sp_nexthop_neigh_update(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_neigh_entry *neigh_entry,
-			      bool removing)
+			      bool removing, bool dead)
 {
 	struct mlxsw_sp_nexthop *nh;
 
+	if (list_empty(&neigh_entry->nexthop_list))
+		return;
+
+	if (dead) {
+		int err;
+
+		err = mlxsw_sp_nexthop_dead_neigh_replace(mlxsw_sp,
+							  neigh_entry);
+		if (err)
+			dev_err(mlxsw_sp->bus_info->dev, "Failed to replace dead neigh\n");
+		return;
+	}
+
 	list_for_each_entry(nh, &neigh_entry->nexthop_list,
 			    neigh_list_node) {
 		__mlxsw_sp_nexthop_neigh_update(nh, removing);
-- 
2.20.1

