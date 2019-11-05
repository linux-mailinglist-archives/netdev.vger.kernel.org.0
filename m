Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B12EF985
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 10:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbfKEJfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 04:35:38 -0500
Received: from simonwunderlich.de ([79.140.42.25]:35586 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730762AbfKEJfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 04:35:37 -0500
Received: from kero.packetmixer.de (p200300C5970F5D00F0ACF07C9CF9C7D8.dip0.t-ipconnect.de [IPv6:2003:c5:970f:5d00:f0ac:f07c:9cf9:c7d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id A80C16205C;
        Tue,  5 Nov 2019 10:35:34 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/5] batman-adv: Axe 'aggr_list_lock'
Date:   Tue,  5 Nov 2019 10:35:29 +0100
Message-Id: <20191105093531.11398-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105093531.11398-1-sw@simonwunderlich.de>
References: <20191105093531.11398-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

'aggr_list.lock' can safely be used in place of another explicit spinlock
when access to 'aggr_list' has to be guarded.

This avoids to take 2 locks, knowing that the 2nd one is always successful.

Now that the 'aggr_list.lock' is handled explicitly, the lock-free
__sbk_something() variants should be used when dealing with 'aggr_list'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_v.c     |  1 -
 net/batman-adv/bat_v_ogm.c | 30 +++++++++++++++---------------
 net/batman-adv/types.h     |  3 ---
 3 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index 64054edc2e3c..4ff6cf1ecae7 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -1085,7 +1085,6 @@ void batadv_v_hardif_init(struct batadv_hard_iface *hard_iface)
 
 	hard_iface->bat_v.aggr_len = 0;
 	skb_queue_head_init(&hard_iface->bat_v.aggr_list);
-	spin_lock_init(&hard_iface->bat_v.aggr_list_lock);
 	INIT_DELAYED_WORK(&hard_iface->bat_v.aggr_wq,
 			  batadv_v_ogm_aggr_work);
 }
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 76b732e2f31c..714ce56cfcc8 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -152,7 +152,7 @@ static unsigned int batadv_v_ogm_len(struct sk_buff *skb)
  * @skb: the OGM to check
  * @hard_iface: the interface to use to send the OGM
  *
- * Caller needs to hold the hard_iface->bat_v.aggr_list_lock.
+ * Caller needs to hold the hard_iface->bat_v.aggr_list.lock.
  *
  * Return: True, if the given OGMv2 packet still fits, false otherwise.
  */
@@ -163,7 +163,7 @@ static bool batadv_v_ogm_queue_left(struct sk_buff *skb,
 				 BATADV_MAX_AGGREGATION_BYTES);
 	unsigned int ogm_len = batadv_v_ogm_len(skb);
 
-	lockdep_assert_held(&hard_iface->bat_v.aggr_list_lock);
+	lockdep_assert_held(&hard_iface->bat_v.aggr_list.lock);
 
 	return hard_iface->bat_v.aggr_len + ogm_len <= max;
 }
@@ -174,13 +174,13 @@ static bool batadv_v_ogm_queue_left(struct sk_buff *skb,
  *
  * Empties the OGMv2 aggregation queue and frees all the skbs it contained.
  *
- * Caller needs to hold the hard_iface->bat_v.aggr_list_lock.
+ * Caller needs to hold the hard_iface->bat_v.aggr_list.lock.
  */
 static void batadv_v_ogm_aggr_list_free(struct batadv_hard_iface *hard_iface)
 {
-	lockdep_assert_held(&hard_iface->bat_v.aggr_list_lock);
+	lockdep_assert_held(&hard_iface->bat_v.aggr_list.lock);
 
-	skb_queue_purge(&hard_iface->bat_v.aggr_list);
+	__skb_queue_purge(&hard_iface->bat_v.aggr_list);
 	hard_iface->bat_v.aggr_len = 0;
 }
 
@@ -193,7 +193,7 @@ static void batadv_v_ogm_aggr_list_free(struct batadv_hard_iface *hard_iface)
  *
  * The aggregation queue is empty after this call.
  *
- * Caller needs to hold the hard_iface->bat_v.aggr_list_lock.
+ * Caller needs to hold the hard_iface->bat_v.aggr_list.lock.
  */
 static void batadv_v_ogm_aggr_send(struct batadv_hard_iface *hard_iface)
 {
@@ -202,7 +202,7 @@ static void batadv_v_ogm_aggr_send(struct batadv_hard_iface *hard_iface)
 	unsigned int ogm_len;
 	struct sk_buff *skb;
 
-	lockdep_assert_held(&hard_iface->bat_v.aggr_list_lock);
+	lockdep_assert_held(&hard_iface->bat_v.aggr_list.lock);
 
 	if (!aggr_len)
 		return;
@@ -216,7 +216,7 @@ static void batadv_v_ogm_aggr_send(struct batadv_hard_iface *hard_iface)
 	skb_reserve(skb_aggr, ETH_HLEN + NET_IP_ALIGN);
 	skb_reset_network_header(skb_aggr);
 
-	while ((skb = skb_dequeue(&hard_iface->bat_v.aggr_list))) {
+	while ((skb = __skb_dequeue(&hard_iface->bat_v.aggr_list))) {
 		hard_iface->bat_v.aggr_len -= batadv_v_ogm_len(skb);
 
 		ogm_len = batadv_v_ogm_len(skb);
@@ -243,13 +243,13 @@ static void batadv_v_ogm_queue_on_if(struct sk_buff *skb,
 		return;
 	}
 
-	spin_lock_bh(&hard_iface->bat_v.aggr_list_lock);
+	spin_lock_bh(&hard_iface->bat_v.aggr_list.lock);
 	if (!batadv_v_ogm_queue_left(skb, hard_iface))
 		batadv_v_ogm_aggr_send(hard_iface);
 
 	hard_iface->bat_v.aggr_len += batadv_v_ogm_len(skb);
-	skb_queue_tail(&hard_iface->bat_v.aggr_list, skb);
-	spin_unlock_bh(&hard_iface->bat_v.aggr_list_lock);
+	__skb_queue_tail(&hard_iface->bat_v.aggr_list, skb);
+	spin_unlock_bh(&hard_iface->bat_v.aggr_list.lock);
 }
 
 /**
@@ -388,9 +388,9 @@ void batadv_v_ogm_aggr_work(struct work_struct *work)
 	batv = container_of(work, struct batadv_hard_iface_bat_v, aggr_wq.work);
 	hard_iface = container_of(batv, struct batadv_hard_iface, bat_v);
 
-	spin_lock_bh(&hard_iface->bat_v.aggr_list_lock);
+	spin_lock_bh(&hard_iface->bat_v.aggr_list.lock);
 	batadv_v_ogm_aggr_send(hard_iface);
-	spin_unlock_bh(&hard_iface->bat_v.aggr_list_lock);
+	spin_unlock_bh(&hard_iface->bat_v.aggr_list.lock);
 
 	batadv_v_ogm_start_queue_timer(hard_iface);
 }
@@ -421,9 +421,9 @@ void batadv_v_ogm_iface_disable(struct batadv_hard_iface *hard_iface)
 {
 	cancel_delayed_work_sync(&hard_iface->bat_v.aggr_wq);
 
-	spin_lock_bh(&hard_iface->bat_v.aggr_list_lock);
+	spin_lock_bh(&hard_iface->bat_v.aggr_list.lock);
 	batadv_v_ogm_aggr_list_free(hard_iface);
-	spin_unlock_bh(&hard_iface->bat_v.aggr_list_lock);
+	spin_unlock_bh(&hard_iface->bat_v.aggr_list.lock);
 }
 
 /**
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 4d7f1baee7b7..47718a82eaf2 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -130,9 +130,6 @@ struct batadv_hard_iface_bat_v {
 	/** @aggr_len: size of the OGM aggregate (excluding ethernet header) */
 	unsigned int aggr_len;
 
-	/** @aggr_list_lock: protects aggr_list */
-	spinlock_t aggr_list_lock;
-
 	/**
 	 * @throughput_override: throughput override to disable link
 	 *  auto-detection
-- 
2.20.1

