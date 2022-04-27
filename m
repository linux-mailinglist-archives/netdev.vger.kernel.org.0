Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A86511F6C
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243454AbiD0QuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243385AbiD0QuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:50:17 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8812D28A9;
        Wed, 27 Apr 2022 09:47:05 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 17C2A10000C;
        Wed, 27 Apr 2022 16:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651078024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/cuTyMCze0n5qYU5HkcXz/EVFulTr5jEuFTHRjxkZI=;
        b=ESN9hD81MjrhU1lR9GGrSNJhGzsbnQgb7huAwPzGPrUUlgWniUwZmSE0q42aSmCet7slC8
        2ox2bblDTLGQD9oUUzm9jTXrH0Zl71DBCB9W0jEo4zh2bQDCFJadLn2UDsRQQ+Dj7p8iu3
        sNmgB4tJydj3USVeaVdYFl4aKETPLN9E7Af79Y1kKyJhQ7vAn52TGICNqf8ETBoJIY4orf
        cooFqbYslgVTNmcVME0YzM973T0kcUQxFw4JLEowZfOy/XJ6wnA9NYG0hL4SPZ1NoRetn2
        HwIs3G02+BAKo3gSF/jzXdniCf9iZuCGcBc3KPBSrReAhafSEYILGZ0nV3dLYw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 01/11] net: mac802154: Stop exporting ieee802154_wake/stop_queue()
Date:   Wed, 27 Apr 2022 18:46:49 +0200
Message-Id: <20220427164659.106447-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220427164659.106447-1-miquel.raynal@bootlin.com>
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index bdac0ddbdcdb..357d25ef627a 100644
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
- * Tranceivers usually have either one transmit framebuffer or one framebuffer
- * for both transmitting and receiving. Hence, the core currently only handles
- * one frame at a time for each phy, which means we had to stop the queue to
- * avoid new skb to come during the transmission. The queue then needs to be
- * woken up after the operation.
- *
- * Drivers should use this function instead of netif_wake_queue.
- */
-void ieee802154_wake_queue(struct ieee802154_hw *hw);
-
-/**
- * ieee802154_stop_queue - stop ieee802154 queue
- * @hw: pointer as obtained from ieee802154_alloc_hw().
- *
- * Tranceivers usually have either one transmit framebuffer or one framebuffer
- * for both transmitting and receiving. Hence, the core currently only handles
- * one frame at a time for each phy, which means we need to tell upper layers to
- * stop giving us new skbs while we are busy with the transmitted one. The queue
- * must then be stopped before transmitting.
- *
- * Drivers should use this function instead of netif_stop_queue.
- */
-void ieee802154_stop_queue(struct ieee802154_hw *hw);
 
 /**
  * ieee802154_xmit_complete - frame transmission complete
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 1381e6a5e180..83f5ccd1ca0f 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -130,6 +130,30 @@ netdev_tx_t
 ieee802154_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer);
 
+/**
+ * ieee802154_wake_queue - wake ieee802154 queue
+ * @hw: pointer as obtained from ieee802154_alloc_hw().
+ *
+ * Tranceivers usually have either one transmit framebuffer or one framebuffer
+ * for both transmitting and receiving. Hence, the core currently only handles
+ * one frame at a time for each phy, which means we had to stop the queue to
+ * avoid new skb to come during the transmission. The queue then needs to be
+ * woken up after the operation.
+ */
+void ieee802154_wake_queue(struct ieee802154_hw *hw);
+
+/**
+ * ieee802154_stop_queue - stop ieee802154 queue
+ * @hw: pointer as obtained from ieee802154_alloc_hw().
+ *
+ * Tranceivers usually have either one transmit framebuffer or one framebuffer
+ * for both transmitting and receiving. Hence, the core currently only handles
+ * one frame at a time for each phy, which means we need to tell upper layers to
+ * stop giving us new skbs while we are busy with the transmitted one. The queue
+ * must then be stopped before transmitting.
+ */
+void ieee802154_stop_queue(struct ieee802154_hw *hw);
+
 /* MIB callbacks */
 void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan);
 
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 9f024d85563b..15a46b56d85a 100644
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

