Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47456494520
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357989AbiATAvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:38 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:42931 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357947AbiATAvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:35 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 01B01100009;
        Thu, 20 Jan 2022 00:51:32 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 06/14] net: mac802154: Stop exporting ieee802154_wake/stop_queue()
Date:   Thu, 20 Jan 2022 01:51:14 +0100
Message-Id: <20220120005122.309104-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120005122.309104-1-miquel.raynal@bootlin.com>
References: <20220120005122.309104-1-miquel.raynal@bootlin.com>
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
index e7443e1acde8..9e2e2b2cd65e 100644
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
index 8e7e4cf16fc3..a5424b559239 100644
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

