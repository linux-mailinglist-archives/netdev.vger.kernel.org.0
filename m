Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B084AC276
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384157AbiBGPFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442270AbiBGOsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:19 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B67C0401C1;
        Mon,  7 Feb 2022 06:48:18 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7BB972000E;
        Mon,  7 Feb 2022 14:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KEvoIRvAVCq69JUqPSnTO94KCQuJsWgdxodYKZ8Wj08=;
        b=kZ1YBpFxaZ3d/m7MBjCZGqiNHbWyrg65byhuLTgVjSqPTaLWMbrlTeop2mgug124jis6JY
        VFfJdwGsp8FBpVuzKMz6aMujIs4tS9CnWnBRZfbcpSJQNgaXjG8MgHYEkecpl+ZQdZjDYT
        BRjOxLOtPN4ZbFiOMmUg2AcOTSELTx+zOoY6UaFDpisk3Owup6SUjMOsU3/Vz3Cu/W+Fwf
        myr5IQPNmGI8OGvRh7r+UnWqeoQ4/cQ76gKWlipKtF1BZLVJn81sCxDSaPpL+HHHAfy9BV
        kV0hZ6OhYt7+eAQy6R/QGSojdGMRcQgTQPDo6mukl9Vlt6XqHZXf91Wp6+2WuQ==
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
Subject: [PATCH wpan-next v2 06/14] net: mac802154: Stop exporting ieee802154_wake/stop_queue()
Date:   Mon,  7 Feb 2022 15:47:56 +0100
Message-Id: <20220207144804.708118-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220207144804.708118-1-miquel.raynal@bootlin.com>
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 9fe8cfef1ba0..9e2e2b2cd65e 100644
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
index 702560acc8ce..c9451d18de31 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -128,6 +128,30 @@ netdev_tx_t
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
index 9016f634efba..6c56884ed508 100644
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

