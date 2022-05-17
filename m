Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D86252A811
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350974AbiEQQfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350971AbiEQQfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:35:13 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD444EF4C;
        Tue, 17 May 2022 09:35:08 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E693A1BF20E;
        Tue, 17 May 2022 16:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652805307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m9Um3dimatFK4ZcLWzZuZldgUYszV5ihxNHm+/ejbC4=;
        b=ejBLHyhjAZu27fMYHE2w0DJWzYE9avXS0kJkTwq5mpnmS2NEkdQD3uXDgDwfnMQ7AVQacD
        978fQiJZr9JDW62VigVfCphXhtSBtk0AyPWmNS1g6l0jOPC/NBM839cMi6QuDtKNzq/G+x
        MpDIjOYobUo8+7cbttja+oy3Wzs7rgpfQRyzdEPtbiOcti0EyVgOVRcT1tU18gKkfcpJO3
        EkbrOuO4IVK1cjS3GHEPbJ40PionoKxSZKv6NWiInhV7r5kWiGjqny2buTdv69DBT8zxQO
        nuf997upfHv+CZ6tj/90g5kHUOusiXZMLWM3VoHWFWmwp1eROITgrAmGs9/O9Q==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v3 08/11] net: mac802154: Introduce a tx queue flushing mechanism
Date:   Tue, 17 May 2022 18:34:47 +0200
Message-Id: <20220517163450.240299-9-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517163450.240299-1-miquel.raynal@bootlin.com>
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
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

Right now we are able to stop a queue but we have no indication if a
transmission is ongoing or not.

Thanks to recent additions, we can track the number of ongoing
transmissions so we know if the last transmission is over. Adding on top
of it an internal wait queue also allows to be woken up asynchronously
when this happens. If, beforehands, we marked the queue to be held and
stopped it, we end up flushing and stopping the tx queue.

Thanks to this feature, we will soon be able to introduce a synchronous
transmit API.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h      |  1 +
 net/ieee802154/core.c        |  1 +
 net/mac802154/cfg.c          |  2 +-
 net/mac802154/ieee802154_i.h |  1 +
 net/mac802154/tx.c           | 26 ++++++++++++++++++++++++--
 net/mac802154/util.c         |  6 ++++--
 6 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 7a191418f258..8881b6126b58 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -218,6 +218,7 @@ struct wpan_phy {
 	spinlock_t queue_lock;
 	atomic_t ongoing_txs;
 	atomic_t hold_txs;
+	wait_queue_head_t sync_txq;
 
 	char priv[] __aligned(NETDEV_ALIGN);
 };
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 47a4de6df88b..57546e07e06a 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -129,6 +129,7 @@ wpan_phy_new(const struct cfg802154_ops *ops, size_t priv_size)
 	wpan_phy_net_set(&rdev->wpan_phy, &init_net);
 
 	init_waitqueue_head(&rdev->dev_wait);
+	init_waitqueue_head(&rdev->wpan_phy.sync_txq);
 
 	spin_lock_init(&rdev->wpan_phy.queue_lock);
 
diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index b51100fd9e3f..93df24f75572 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -46,7 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
 	if (!local->open_count)
 		goto suspend;
 
-	ieee802154_hold_queue(local);
+	ieee802154_sync_and_hold_queue(local);
 	synchronize_net();
 
 	/* stop hardware - this must stop RX */
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index e34db1d49ef4..a057827fc48a 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -124,6 +124,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
 
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
 void ieee802154_xmit_sync_worker(struct work_struct *work);
+int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 607019b8f8ab..38f74b8b6740 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -44,7 +44,8 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
 err_tx:
 	/* Restart the netif queue on each sub_if_data object. */
 	ieee802154_release_queue(local);
-	atomic_dec(&local->phy->ongoing_txs);
+	if (!atomic_dec_and_test(&local->phy->ongoing_txs))
+		wake_up(&local->phy->sync_txq);
 	kfree_skb(skb);
 	netdev_dbg(dev, "transmission failed\n");
 }
@@ -100,12 +101,33 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 
 err_wake_netif_queue:
 	ieee802154_release_queue(local);
-	atomic_dec(&local->phy->ongoing_txs);
+	if (!atomic_dec_and_test(&local->phy->ongoing_txs))
+		wake_up(&local->phy->sync_txq);
 err_free_skb:
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 
+static int ieee802154_sync_queue(struct ieee802154_local *local)
+{
+	int ret;
+
+	ieee802154_hold_queue(local);
+	ieee802154_disable_queue(local);
+	wait_event(local->phy->sync_txq, !atomic_read(&local->phy->ongoing_txs));
+	ret = local->tx_result;
+	ieee802154_release_queue(local);
+
+	return ret;
+}
+
+int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
+{
+	ieee802154_hold_queue(local);
+
+	return ieee802154_sync_queue(local);
+}
+
 static netdev_tx_t
 ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 {
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 02645f57fc2a..cddb42984484 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -140,7 +140,8 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 	}
 
 	dev_consume_skb_any(skb);
-	atomic_dec(&hw->phy->ongoing_txs);
+	if (!atomic_dec_and_test(&hw->phy->ongoing_txs))
+		wake_up(&hw->phy->sync_txq);
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
 
@@ -152,7 +153,8 @@ void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
 	local->tx_result = reason;
 	ieee802154_release_queue(local);
 	dev_kfree_skb_any(skb);
-	atomic_dec(&hw->phy->ongoing_txs);
+	if (!atomic_dec_and_test(&hw->phy->ongoing_txs))
+		wake_up(&hw->phy->sync_txq);
 }
 EXPORT_SYMBOL(ieee802154_xmit_error);
 
-- 
2.34.1

