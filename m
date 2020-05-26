Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6231E1F36
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 12:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731800AbgEZKAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 06:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgEZKAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 06:00:14 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED15C08C5C1
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 03:00:13 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c597221100fc44a592f3d496ba.dip0.t-ipconnect.de [IPv6:2003:c5:9722:1100:fc44:a592:f3d4:96ba])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 043076205F;
        Tue, 26 May 2020 12:00:09 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/3] batman-adv: use rcu_replace_pointer() where appropriate
Date:   Tue, 26 May 2020 12:00:06 +0200
Message-Id: <20200526100007.10501-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200526100007.10501-1-sw@simonwunderlich.de>
References: <20200526100007.10501-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antonio Quartulli <a@unstable.cc>

In commit a63fc6b75cca ("rcu: Upgrade rcu_swap_protected() to
rcu_replace_pointer()") a new helper macro named rcu_replace_pointer() was
introduced to simplify code requiring to switch an rcu pointer to a new
value while extracting the old one.

Use rcu_replace_pointer() where appropriate to make code slimer.

Signed-off-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/gateway_client.c | 4 ++--
 net/batman-adv/hard-interface.c | 4 ++--
 net/batman-adv/routing.c        | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index e22e49289677..a18dcc686dc3 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -146,8 +146,8 @@ static void batadv_gw_select(struct batadv_priv *bat_priv,
 	if (new_gw_node)
 		kref_get(&new_gw_node->refcount);
 
-	curr_gw_node = rcu_dereference_protected(bat_priv->gw.curr_gw, 1);
-	rcu_assign_pointer(bat_priv->gw.curr_gw, new_gw_node);
+	curr_gw_node = rcu_replace_pointer(bat_priv->gw.curr_gw, new_gw_node,
+					   true);
 
 	if (curr_gw_node)
 		batadv_gw_node_put(curr_gw_node);
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index c7e98a40dd33..3a256af92784 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -473,8 +473,8 @@ static void batadv_primary_if_select(struct batadv_priv *bat_priv,
 	if (new_hard_iface)
 		kref_get(&new_hard_iface->refcount);
 
-	curr_hard_iface = rcu_dereference_protected(bat_priv->primary_if, 1);
-	rcu_assign_pointer(bat_priv->primary_if, new_hard_iface);
+	curr_hard_iface = rcu_replace_pointer(bat_priv->primary_if,
+					      new_hard_iface, 1);
 
 	if (!new_hard_iface)
 		goto out;
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 3632bd976c56..d343382e9664 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -71,13 +71,13 @@ static void _batadv_update_route(struct batadv_priv *bat_priv,
 	 * the code needs to ensure the curr_router variable contains a pointer
 	 * to the replaced best neighbor.
 	 */
-	curr_router = rcu_dereference_protected(orig_ifinfo->router, true);
 
 	/* increase refcount of new best neighbor */
 	if (neigh_node)
 		kref_get(&neigh_node->refcount);
 
-	rcu_assign_pointer(orig_ifinfo->router, neigh_node);
+	curr_router = rcu_replace_pointer(orig_ifinfo->router, neigh_node,
+					  true);
 	spin_unlock_bh(&orig_node->neigh_list_lock);
 	batadv_orig_ifinfo_put(orig_ifinfo);
 
-- 
2.20.1

