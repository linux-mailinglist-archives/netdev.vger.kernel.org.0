Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51534EABDB
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfJaIxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:53:13 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:21293 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfJaIxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:53:13 -0400
Received: from localhost.localdomain ([93.23.12.90])
        by mwinf5d66 with ME
        id L8sy2100A1waAWt038syit; Thu, 31 Oct 2019 09:53:11 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 31 Oct 2019 09:53:11 +0100
X-ME-IP: 93.23.12.90
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] batman-adv: Axe 'aggr_list_lock'
Date:   Thu, 31 Oct 2019 09:52:40 +0100
Message-Id: <20191031085240.7116-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'aggr_list.lock' can safely be used in place of another explicit spinlock
when access to 'aggr_list' has to be guarded.

This avoids to take 2 locks, knowing that the 2nd one is always successful.

Now that the 'aggr_list.lock' is handled explicitly, the lock-free
__sbk_something() variants should be used when dealing with 'aggr_list'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.
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
index b841c83d9c3b..c9a00100f199 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -151,7 +151,7 @@ static unsigned int batadv_v_ogm_len(struct sk_buff *skb)
  * @skb: the OGM to check
  * @hard_iface: the interface to use to send the OGM
  *
- * Caller needs to hold the hard_iface->bat_v.aggr_list_lock.
+ * Caller needs to hold the hard_iface->bat_v.aggr_list.lock.
  *
  * Return: True, if the given OGMv2 packet still fits, false otherwise.
  */
@@ -162,7 +162,7 @@ static bool batadv_v_ogm_queue_left(struct sk_buff *skb,
 				 BATADV_MAX_AGGREGATION_BYTES);
 	unsigned int ogm_len = batadv_v_ogm_len(skb);
 
-	lockdep_assert_held(&hard_iface->bat_v.aggr_list_lock);
+	lockdep_assert_held(&hard_iface->bat_v.aggr_list.lock);
 
 	return hard_iface->bat_v.aggr_len + ogm_len <= max;
 }
@@ -173,13 +173,13 @@ static bool batadv_v_ogm_queue_left(struct sk_buff *skb,
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
 
@@ -192,7 +192,7 @@ static void batadv_v_ogm_aggr_list_free(struct batadv_hard_iface *hard_iface)
  *
  * The aggregation queue is empty after this call.
  *
- * Caller needs to hold the hard_iface->bat_v.aggr_list_lock.
+ * Caller needs to hold the hard_iface->bat_v.aggr_list.lock.
  */
 static void batadv_v_ogm_aggr_send(struct batadv_hard_iface *hard_iface)
 {
@@ -201,7 +201,7 @@ static void batadv_v_ogm_aggr_send(struct batadv_hard_iface *hard_iface)
 	unsigned int ogm_len;
 	struct sk_buff *skb;
 
-	lockdep_assert_held(&hard_iface->bat_v.aggr_list_lock);
+	lockdep_assert_held(&hard_iface->bat_v.aggr_list.lock);
 
 	if (!aggr_len)
 		return;
@@ -215,7 +215,7 @@ static void batadv_v_ogm_aggr_send(struct batadv_hard_iface *hard_iface)
 	skb_reserve(skb_aggr, ETH_HLEN + NET_IP_ALIGN);
 	skb_reset_network_header(skb_aggr);
 
-	while ((skb = skb_dequeue(&hard_iface->bat_v.aggr_list))) {
+	while ((skb = __skb_dequeue(&hard_iface->bat_v.aggr_list))) {
 		hard_iface->bat_v.aggr_len -= batadv_v_ogm_len(skb);
 
 		ogm_len = batadv_v_ogm_len(skb);
@@ -242,13 +242,13 @@ static void batadv_v_ogm_queue_on_if(struct sk_buff *skb,
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
@@ -373,9 +373,9 @@ void batadv_v_ogm_aggr_work(struct work_struct *work)
 	batv = container_of(work, struct batadv_hard_iface_bat_v, aggr_wq.work);
 	hard_iface = container_of(batv, struct batadv_hard_iface, bat_v);
 
-	spin_lock_bh(&hard_iface->bat_v.aggr_list_lock);
+	spin_lock_bh(&hard_iface->bat_v.aggr_list.lock);
 	batadv_v_ogm_aggr_send(hard_iface);
-	spin_unlock_bh(&hard_iface->bat_v.aggr_list_lock);
+	spin_unlock_bh(&hard_iface->bat_v.aggr_list.lock);
 
 	batadv_v_ogm_start_queue_timer(hard_iface);
 }
@@ -406,9 +406,9 @@ void batadv_v_ogm_iface_disable(struct batadv_hard_iface *hard_iface)
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
index be7c02aa91e2..75a72d6676ec 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -126,9 +126,6 @@ struct batadv_hard_iface_bat_v {
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

