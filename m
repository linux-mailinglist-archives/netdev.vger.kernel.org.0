Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7DE4740
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438521AbfJYJbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:31:22 -0400
Received: from simonwunderlich.de ([79.140.42.25]:53296 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408495AbfJYJbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:31:20 -0400
Received: from kero.packetmixer.de (p200300C5970A8C00492EDFEC592AE94F.dip0.t-ipconnect.de [IPv6:2003:c5:970a:8c00:492e:dfec:592a:e94f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 655C462019;
        Fri, 25 Oct 2019 11:22:18 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        syzbot+0cc629f19ccb8534935b@syzkaller.appspotmail.com,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/2] batman-adv: Avoid free/alloc race when handling OGM buffer
Date:   Fri, 25 Oct 2019 11:22:16 +0200
Message-Id: <20191025092216.12791-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025092216.12791-1-sw@simonwunderlich.de>
References: <20191025092216.12791-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

Each slave interface of an B.A.T.M.A.N. IV virtual interface has an OGM
packet buffer which is initialized using data from netdevice notifier and
other rtnetlink related hooks. It is sent regularly via various slave
interfaces of the batadv virtual interface and in this process also
modified (realloced) to integrate additional state information via TVLV
containers.

It must be avoided that the worker item is executed without a common lock
with the netdevice notifier/rtnetlink helpers. Otherwise it can either
happen that half modified/freed data is sent out or functions modifying the
OGM buffer try to access already freed memory regions.

Reported-by: syzbot+0cc629f19ccb8534935b@syzkaller.appspotmail.com
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_iv_ogm.c     | 61 ++++++++++++++++++++++++++++-----
 net/batman-adv/hard-interface.c |  2 ++
 net/batman-adv/types.h          |  3 ++
 3 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index d78938e3e008..5b0b20e6da95 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -22,6 +22,8 @@
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/pkt_sched.h>
@@ -193,14 +195,18 @@ static int batadv_iv_ogm_iface_enable(struct batadv_hard_iface *hard_iface)
 	unsigned char *ogm_buff;
 	u32 random_seqno;
 
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
 	/* randomize initial seqno to avoid collision */
 	get_random_bytes(&random_seqno, sizeof(random_seqno));
 	atomic_set(&hard_iface->bat_iv.ogm_seqno, random_seqno);
 
 	hard_iface->bat_iv.ogm_buff_len = BATADV_OGM_HLEN;
 	ogm_buff = kmalloc(hard_iface->bat_iv.ogm_buff_len, GFP_ATOMIC);
-	if (!ogm_buff)
+	if (!ogm_buff) {
+		mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 		return -ENOMEM;
+	}
 
 	hard_iface->bat_iv.ogm_buff = ogm_buff;
 
@@ -212,35 +218,59 @@ static int batadv_iv_ogm_iface_enable(struct batadv_hard_iface *hard_iface)
 	batadv_ogm_packet->reserved = 0;
 	batadv_ogm_packet->tq = BATADV_TQ_MAX_VALUE;
 
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
+
 	return 0;
 }
 
 static void batadv_iv_ogm_iface_disable(struct batadv_hard_iface *hard_iface)
 {
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
 	kfree(hard_iface->bat_iv.ogm_buff);
 	hard_iface->bat_iv.ogm_buff = NULL;
+
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
 
 static void batadv_iv_ogm_iface_update_mac(struct batadv_hard_iface *hard_iface)
 {
 	struct batadv_ogm_packet *batadv_ogm_packet;
-	unsigned char *ogm_buff = hard_iface->bat_iv.ogm_buff;
+	void *ogm_buff;
 
-	batadv_ogm_packet = (struct batadv_ogm_packet *)ogm_buff;
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
+	ogm_buff = hard_iface->bat_iv.ogm_buff;
+	if (!ogm_buff)
+		goto unlock;
+
+	batadv_ogm_packet = ogm_buff;
 	ether_addr_copy(batadv_ogm_packet->orig,
 			hard_iface->net_dev->dev_addr);
 	ether_addr_copy(batadv_ogm_packet->prev_sender,
 			hard_iface->net_dev->dev_addr);
+
+unlock:
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
 
 static void
 batadv_iv_ogm_primary_iface_set(struct batadv_hard_iface *hard_iface)
 {
 	struct batadv_ogm_packet *batadv_ogm_packet;
-	unsigned char *ogm_buff = hard_iface->bat_iv.ogm_buff;
+	void *ogm_buff;
 
-	batadv_ogm_packet = (struct batadv_ogm_packet *)ogm_buff;
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+
+	ogm_buff = hard_iface->bat_iv.ogm_buff;
+	if (!ogm_buff)
+		goto unlock;
+
+	batadv_ogm_packet = ogm_buff;
 	batadv_ogm_packet->ttl = BATADV_TTL;
+
+unlock:
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
 
 /* when do we schedule our own ogm to be sent */
@@ -742,7 +772,11 @@ batadv_iv_ogm_slide_own_bcast_window(struct batadv_hard_iface *hard_iface)
 	}
 }
 
-static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
+/**
+ * batadv_iv_ogm_schedule_buff() - schedule submission of hardif ogm buffer
+ * @hard_iface: interface whose ogm buffer should be transmitted
+ */
+static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_iface)
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	unsigned char **ogm_buff = &hard_iface->bat_iv.ogm_buff;
@@ -753,9 +787,7 @@ static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
 	u16 tvlv_len = 0;
 	unsigned long send_time;
 
-	if (hard_iface->if_status == BATADV_IF_NOT_IN_USE ||
-	    hard_iface->if_status == BATADV_IF_TO_BE_REMOVED)
-		return;
+	lockdep_assert_held(&hard_iface->bat_iv.ogm_buff_mutex);
 
 	/* the interface gets activated here to avoid race conditions between
 	 * the moment of activating the interface in
@@ -823,6 +855,17 @@ static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
 		batadv_hardif_put(primary_if);
 }
 
+static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
+{
+	if (hard_iface->if_status == BATADV_IF_NOT_IN_USE ||
+	    hard_iface->if_status == BATADV_IF_TO_BE_REMOVED)
+		return;
+
+	mutex_lock(&hard_iface->bat_iv.ogm_buff_mutex);
+	batadv_iv_ogm_schedule_buff(hard_iface);
+	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
+}
+
 /**
  * batadv_iv_orig_ifinfo_sum() - Get bcast_own sum for originator over iterface
  * @orig_node: originator which reproadcasted the OGMs directly
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index c90e47342bb0..afb52282d5bd 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -18,6 +18,7 @@
 #include <linux/kref.h>
 #include <linux/limits.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
@@ -929,6 +930,7 @@ batadv_hardif_add_interface(struct net_device *net_dev)
 	INIT_LIST_HEAD(&hard_iface->list);
 	INIT_HLIST_HEAD(&hard_iface->neigh_list);
 
+	mutex_init(&hard_iface->bat_iv.ogm_buff_mutex);
 	spin_lock_init(&hard_iface->neigh_list_lock);
 	kref_init(&hard_iface->refcount);
 
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index a9fb7b17f557..4d7f1baee7b7 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -82,6 +82,9 @@ struct batadv_hard_iface_bat_iv {
 
 	/** @ogm_seqno: OGM sequence number - used to identify each OGM */
 	atomic_t ogm_seqno;
+
+	/** @ogm_buff_mutex: lock protecting ogm_buff and ogm_buff_len */
+	struct mutex ogm_buff_mutex;
 };
 
 /**
-- 
2.20.1

