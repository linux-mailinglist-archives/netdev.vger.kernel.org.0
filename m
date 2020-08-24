Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8341250209
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 18:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgHXQ2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 12:28:09 -0400
Received: from simonwunderlich.de ([79.140.42.25]:47680 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbgHXQ1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 12:27:54 -0400
Received: from kero.packetmixer.de (p200300c5970d68d0e0160e8a82c5fd76.dip0.t-ipconnect.de [IPv6:2003:c5:970d:68d0:e016:e8a:82c5:fd76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id C056362072;
        Mon, 24 Aug 2020 18:27:46 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/5] batman-adv: Drop unused function batadv_hardif_remove_interfaces()
Date:   Mon, 24 Aug 2020 18:27:38 +0200
Message-Id: <20200824162741.880-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200824162741.880-1-sw@simonwunderlich.de>
References: <20200824162741.880-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The function batadv_hardif_remove_interfaces was meant to remove all
interfaces which are currently in the list of known (compatible) hardifs
during module unload. But the function unregister_netdevice_notifier is
called in batadv_exit before batadv_hardif_remove_interfaces. This will
trigger NETDEV_UNREGISTER events for all available interfaces and in this
process remove all interfaces from batadv_hardif_list. And
batadv_hardif_remove_interfaces only operated on this (empty) list.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/hard-interface.c | 17 -----------------
 net/batman-adv/hard-interface.h |  1 -
 net/batman-adv/main.c           |  1 -
 3 files changed, 19 deletions(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index fa06b51c0144..f95be90adaab 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -976,23 +976,6 @@ static void batadv_hardif_remove_interface(struct batadv_hard_iface *hard_iface)
 	batadv_hardif_put(hard_iface);
 }
 
-/**
- * batadv_hardif_remove_interfaces() - Remove all hard interfaces
- */
-void batadv_hardif_remove_interfaces(void)
-{
-	struct batadv_hard_iface *hard_iface, *hard_iface_tmp;
-
-	rtnl_lock();
-	list_for_each_entry_safe(hard_iface, hard_iface_tmp,
-				 &batadv_hardif_list, list) {
-		list_del_rcu(&hard_iface->list);
-		batadv_hardif_generation++;
-		batadv_hardif_remove_interface(hard_iface);
-	}
-	rtnl_unlock();
-}
-
 /**
  * batadv_hard_if_event_softif() - Handle events for soft interfaces
  * @event: NETDEV_* event to handle
diff --git a/net/batman-adv/hard-interface.h b/net/batman-adv/hard-interface.h
index bad2e50135e8..b1855d9d0b06 100644
--- a/net/batman-adv/hard-interface.h
+++ b/net/batman-adv/hard-interface.h
@@ -100,7 +100,6 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 				   struct net *net, const char *iface_name);
 void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface,
 				     enum batadv_hard_if_cleanup autodel);
-void batadv_hardif_remove_interfaces(void);
 int batadv_hardif_min_mtu(struct net_device *soft_iface);
 void batadv_update_min_mtu(struct net_device *soft_iface);
 void batadv_hardif_release(struct kref *ref);
diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 519c08c2cfba..70fee9b42e25 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -137,7 +137,6 @@ static void __exit batadv_exit(void)
 	batadv_netlink_unregister();
 	rtnl_link_unregister(&batadv_link_ops);
 	unregister_netdevice_notifier(&batadv_hard_if_notifier);
-	batadv_hardif_remove_interfaces();
 
 	flush_workqueue(batadv_event_workqueue);
 	destroy_workqueue(batadv_event_workqueue);
-- 
2.20.1

