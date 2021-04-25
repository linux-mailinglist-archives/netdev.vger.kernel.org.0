Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8FB36A84E
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 18:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhDYQOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 12:14:55 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:36596 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhDYQOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 12:14:54 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d64 with ME
        id x4EB2400621Fzsu034EBvP; Sun, 25 Apr 2021 18:14:12 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 25 Apr 2021 18:14:12 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] macvlan: Use 'hash' iterators to simplify code
Date:   Sun, 25 Apr 2021 18:14:10 +0200
Message-Id: <fa1b35d89a6254b3d46d9385ae6f85584138cc31.1619367130.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 'hash_for_each_rcu' and 'hash_for_each_safe' instead of hand writing
them. This saves some lines of code, reduce indentation and improve
readability.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 drivers/net/macvlan.c | 45 +++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 9a9a5cf36a4b..b4f9c66e9a75 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -272,25 +272,22 @@ static void macvlan_broadcast(struct sk_buff *skb,
 	if (skb->protocol == htons(ETH_P_PAUSE))
 		return;
 
-	for (i = 0; i < MACVLAN_HASH_SIZE; i++) {
-		hlist_for_each_entry_rcu(vlan, &port->vlan_hash[i], hlist) {
-			if (vlan->dev == src || !(vlan->mode & mode))
-				continue;
+	hash_for_each_rcu(port->vlan_hash, i, vlan, hlist) {
+		if (vlan->dev == src || !(vlan->mode & mode))
+			continue;
 
-			hash = mc_hash(vlan, eth->h_dest);
-			if (!test_bit(hash, vlan->mc_filter))
-				continue;
+		hash = mc_hash(vlan, eth->h_dest);
+		if (!test_bit(hash, vlan->mc_filter))
+			continue;
 
-			err = NET_RX_DROP;
-			nskb = skb_clone(skb, GFP_ATOMIC);
-			if (likely(nskb))
-				err = macvlan_broadcast_one(
-					nskb, vlan, eth,
+		err = NET_RX_DROP;
+		nskb = skb_clone(skb, GFP_ATOMIC);
+		if (likely(nskb))
+			err = macvlan_broadcast_one(nskb, vlan, eth,
 					mode == MACVLAN_MODE_BRIDGE) ?:
-				      netif_rx_ni(nskb);
-			macvlan_count_rx(vlan, skb->len + ETH_HLEN,
-					 err == NET_RX_SUCCESS, true);
-		}
+			      netif_rx_ni(nskb);
+		macvlan_count_rx(vlan, skb->len + ETH_HLEN,
+				 err == NET_RX_SUCCESS, true);
 	}
 }
 
@@ -380,20 +377,14 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 static void macvlan_flush_sources(struct macvlan_port *port,
 				  struct macvlan_dev *vlan)
 {
+	struct macvlan_source_entry *entry;
+	struct hlist_node *next;
 	int i;
 
-	for (i = 0; i < MACVLAN_HASH_SIZE; i++) {
-		struct hlist_node *h, *n;
-
-		hlist_for_each_safe(h, n, &port->vlan_source_hash[i]) {
-			struct macvlan_source_entry *entry;
+	hash_for_each_safe(port->vlan_source_hash, i, next, entry, hlist)
+		if (entry->vlan == vlan)
+			macvlan_hash_del_source(entry);
 
-			entry = hlist_entry(h, struct macvlan_source_entry,
-					    hlist);
-			if (entry->vlan == vlan)
-				macvlan_hash_del_source(entry);
-		}
-	}
 	vlan->macaddr_count = 0;
 }
 
-- 
2.30.2

