Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50429511F25
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243487AbiD0QuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243451AbiD0QuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:50:19 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C4E2E0277;
        Wed, 27 Apr 2022 09:47:07 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7974B100007;
        Wed, 27 Apr 2022 16:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651078025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0DYVMXV9G/YRNcorwQ5Bnz33u0sYDIwpfJKTDtj7B8=;
        b=ZXD3j2+hnUPtImpfZYr8vTxsLYc638wmAzHMoZhS+dq63hj6CiH/iAzm+AaXncAa6qCoLO
        sz/3ejfTMxeGVwSgMMGyznWW1vXGIvc7WVzUOzLayQWR2AjsDzcSBsgEGfePEw02vnBH1h
        JC2c+bBvYr7Ka9xcvYEPtw2zlJL3+7HITfjZOMs1SXEzIrEW5X4HPxs7HvLGHKPFgqhP6V
        8GvKw5/a692UQEyG5+LjAlxW+4IR2Mg0BzomkkmCvB7mEZABPJ1w0wd7CZ6NmDvYLVqrxc
        WhseO2ntD/tyxrp0y4ZMThaqm7KLZVOA+gJnqHZRQqx+6Bbbbj8wEfCwBiXzmA==
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
Subject: [PATCH wpan-next 02/11] net: mac802154: Change the wake/stop queue prototypes
Date:   Wed, 27 Apr 2022 18:46:50 +0200
Message-Id: <20220427164659.106447-3-miquel.raynal@bootlin.com>
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

Currently the pointer returned by *_alloc_hw() is used for these
helpers, while actually all the callers have a *local pointer available
and anyway this local pointer is going to be derived inside both
helpers. We will soon add more helpers like these so let's change the
prototype right now to improve the harmony in this file.

There is no functional change.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/cfg.c          |  4 ++--
 net/mac802154/ieee802154_i.h |  8 ++++----
 net/mac802154/tx.c           |  6 +++---
 net/mac802154/util.c         | 12 +++++-------
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index 1e4a9f74ed43..dafe02548161 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -46,7 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
 	if (!local->open_count)
 		goto suspend;
 
-	ieee802154_stop_queue(&local->hw);
+	ieee802154_stop_queue(local);
 	synchronize_net();
 
 	/* stop hardware - this must stop RX */
@@ -72,7 +72,7 @@ static int ieee802154_resume(struct wpan_phy *wpan_phy)
 		return ret;
 
 wake_up:
-	ieee802154_wake_queue(&local->hw);
+	ieee802154_wake_queue(local);
 	local->suspended = false;
 	return 0;
 }
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 83f5ccd1ca0f..6652445a1147 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -132,7 +132,7 @@ enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer);
 
 /**
  * ieee802154_wake_queue - wake ieee802154 queue
- * @hw: pointer as obtained from ieee802154_alloc_hw().
+ * @local: main mac object
  *
  * Tranceivers usually have either one transmit framebuffer or one framebuffer
  * for both transmitting and receiving. Hence, the core currently only handles
@@ -140,11 +140,11 @@ enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer);
  * avoid new skb to come during the transmission. The queue then needs to be
  * woken up after the operation.
  */
-void ieee802154_wake_queue(struct ieee802154_hw *hw);
+void ieee802154_wake_queue(struct ieee802154_local *local);
 
 /**
  * ieee802154_stop_queue - stop ieee802154 queue
- * @hw: pointer as obtained from ieee802154_alloc_hw().
+ * @local: main mac object
  *
  * Tranceivers usually have either one transmit framebuffer or one framebuffer
  * for both transmitting and receiving. Hence, the core currently only handles
@@ -152,7 +152,7 @@ void ieee802154_wake_queue(struct ieee802154_hw *hw);
  * stop giving us new skbs while we are busy with the transmitted one. The queue
  * must then be stopped before transmitting.
  */
-void ieee802154_stop_queue(struct ieee802154_hw *hw);
+void ieee802154_stop_queue(struct ieee802154_local *local);
 
 /* MIB callbacks */
 void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan);
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index c829e4a75325..c5befaca5366 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -43,7 +43,7 @@ void ieee802154_xmit_worker(struct work_struct *work)
 
 err_tx:
 	/* Restart the netif queue on each sub_if_data object. */
-	ieee802154_wake_queue(&local->hw);
+	ieee802154_wake_queue(local);
 	kfree_skb(skb);
 	netdev_dbg(dev, "transmission failed\n");
 }
@@ -74,7 +74,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	}
 
 	/* Stop the netif queue on each sub_if_data object. */
-	ieee802154_stop_queue(&local->hw);
+	ieee802154_stop_queue(local);
 
 	/* async is priority, otherwise sync is fallback */
 	if (local->ops->xmit_async) {
@@ -82,7 +82,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 
 		ret = drv_xmit_async(local, skb);
 		if (ret) {
-			ieee802154_wake_queue(&local->hw);
+			ieee802154_wake_queue(local);
 			goto err_tx;
 		}
 
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 15a46b56d85a..6ded390f0132 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -13,9 +13,8 @@
 /* privid for wpan_phys to determine whether they belong to us or not */
 const void *const mac802154_wpan_phy_privid = &mac802154_wpan_phy_privid;
 
-void ieee802154_wake_queue(struct ieee802154_hw *hw)
+void ieee802154_wake_queue(struct ieee802154_local *local)
 {
-	struct ieee802154_local *local = hw_to_local(hw);
 	struct ieee802154_sub_if_data *sdata;
 
 	rcu_read_lock();
@@ -28,9 +27,8 @@ void ieee802154_wake_queue(struct ieee802154_hw *hw)
 	rcu_read_unlock();
 }
 
-void ieee802154_stop_queue(struct ieee802154_hw *hw)
+void ieee802154_stop_queue(struct ieee802154_local *local)
 {
-	struct ieee802154_local *local = hw_to_local(hw);
 	struct ieee802154_sub_if_data *sdata;
 
 	rcu_read_lock();
@@ -48,7 +46,7 @@ enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer)
 	struct ieee802154_local *local =
 		container_of(timer, struct ieee802154_local, ifs_timer);
 
-	ieee802154_wake_queue(&local->hw);
+	ieee802154_wake_queue(local);
 
 	return HRTIMER_NORESTART;
 }
@@ -82,7 +80,7 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 				      hw->phy->sifs_period * NSEC_PER_USEC,
 				      HRTIMER_MODE_REL);
 	} else {
-		ieee802154_wake_queue(hw);
+		ieee802154_wake_queue(local);
 	}
 
 	dev_consume_skb_any(skb);
@@ -95,7 +93,7 @@ void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
 	struct ieee802154_local *local = hw_to_local(hw);
 
 	local->tx_result = reason;
-	ieee802154_wake_queue(hw);
+	ieee802154_wake_queue(local);
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL(ieee802154_xmit_error);
-- 
2.27.0

