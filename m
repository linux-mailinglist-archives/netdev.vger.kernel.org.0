Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B074A4907B1
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239397AbiAQLzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:46 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:56781 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236699AbiAQLzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:23 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 2372520000B;
        Mon, 17 Jan 2022 11:55:21 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 20/41] net: mac802154: Stop exporting ieee802154_wake/stop_queue()
Date:   Mon, 17 Jan 2022 12:54:19 +0100
Message-Id: <20220117115440.60296-21-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Individual drivers do not necessarily need to call these helpers
manually. There are other functions, more suited for this purpose, that
will do that for them. The advantage is that, as no more drivers call
these, it eases the tracking of the ongoing transfers that we are about
to introduce while keeping the possibility to bypass thse counters from
core code.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/mac802154.h      | 27 ---------------------------
 net/mac802154/ieee802154_i.h | 24 ++++++++++++++++++++++++
 net/mac802154/util.c         |  2 --
 3 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 94b2e3008e77..13798867b8d3 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -460,33 +460,6 @@ void ieee802154_unregister_hw(struct ieee802154_hw *hw);
  */
 void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb,
 			   u8 lqi);
-/**
- * ieee802154_wake_queue - wake ieee802154 queue
- * @hw: pointer as obtained from ieee802154_alloc_hw().
- *
- * Tranceivers have either one transmit framebuffer or one framebuffer for both
- * transmitting and receiving. Hence, the core only handles one frame at a time
- * for each phy, which means we had to stop the queue to avoid new skb to come
- * during the transmission. The queue then needs to be woken up after the
- * operation.
- *
- * Drivers should use this function instead of netif_wake_queue.
- */
-void ieee802154_wake_queue(struct ieee802154_hw *hw);
-
-/**
- * ieee802154_stop_queue - stop ieee802154 queue
- * @hw: pointer as obtained from ieee802154_alloc_hw().
- *
- * Tranceivers have either one transmit framebuffer or one framebuffer for both
- * transmitting and receiving. Hence, the core only handles one frame at a time
- * for each phy, which means we need to tell upper layers to stop giving us new
- * skbs while we are busy with the transmitted one. The queue must then be
- * stopped before transmitting.
- *
- * Drivers should use this function instead of netif_stop_queue.
- */
-void ieee802154_stop_queue(struct ieee802154_hw *hw);
 
 /**
  * ieee802154_xmit_complete - frame transmission complete
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 702560acc8ce..97b66088532b 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -128,6 +128,30 @@ netdev_tx_t
 ieee802154_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer);
 
+/**
+ * ieee802154_wake_queue - wake ieee802154 queue
+ * @hw: pointer as obtained from ieee802154_alloc_hw().
+ *
+ * Tranceivers have either one transmit framebuffer or one framebuffer for both
+ * transmitting and receiving. Hence, the core only handles one frame at a time
+ * for each phy, which means we had to stop the queue to avoid new skb to come
+ * during the transmission. The queue then needs to be woken up after the
+ * operation.
+ */
+void ieee802154_wake_queue(struct ieee802154_hw *hw);
+
+/**
+ * ieee802154_stop_queue - stop ieee802154 queue
+ * @hw: pointer as obtained from ieee802154_alloc_hw().
+ *
+ * Tranceivers have either one transmit framebuffer or one framebuffer for both
+ * transmitting and receiving. Hence, the core only handles one frame at a time
+ * for each phy, which means we need to tell upper layers to stop giving us new
+ * skbs while we are busy with the transmitted one. The queue must then be
+ * stopped before transmitting.
+ */
+void ieee802154_stop_queue(struct ieee802154_hw *hw);
+
 /* MIB callbacks */
 void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan);
 
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index f2078238718b..e093ccaebd76 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -27,7 +27,6 @@ void ieee802154_wake_queue(struct ieee802154_hw *hw)
 	}
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(ieee802154_wake_queue);
 
 void ieee802154_stop_queue(struct ieee802154_hw *hw)
 {
@@ -43,7 +42,6 @@ void ieee802154_stop_queue(struct ieee802154_hw *hw)
 	}
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(ieee802154_stop_queue);
 
 enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer)
 {
-- 
2.27.0

