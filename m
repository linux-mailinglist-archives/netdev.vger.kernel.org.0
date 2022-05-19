Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE3E52D6EF
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240427AbiESPGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240403AbiESPFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:05:42 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330133DDCA;
        Thu, 19 May 2022 08:05:35 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6F93B1BF205;
        Thu, 19 May 2022 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652972733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2B+r65yB0mGRK8gkmQuQoNq6bmXn2sLkjbYzly/OAs=;
        b=Ua8F/fW1cOEszdpb4ShFK8ex8R/wgoo8Z5raHbGADg2Dey+srrbGqrwHi9ytOLy7bxsjo4
        4hTwmOfOiKrUWtUr3S3BGl9yf0eAbB59OE5UgWQzmIAIe+zPFajEfB5ALtnxmFkr5FwSqX
        RQji7BNjsDuPs1dytbR3tDVzQPAzg+UhjaWstOax7X+FLl8Zl714eWVlOVI89GsknUtnD4
        JUcMoI3efBtY5qcRpRAF9ZnTMJqhXbBfKOrLb3CDEYHt69jgcIY4UlKd//H6Yzel8i5O3G
        N7ZejSlq1UAD+mkMoGgGYxUxK1lCAgq/oHyaEbRujv45nqLllMbcru+Nh0fbTA==
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
Subject: [PATCH wpan-next v4 08/11] net: mac802154: Introduce a tx queue flushing mechanism
Date:   Thu, 19 May 2022 17:05:13 +0200
Message-Id: <20220519150516.443078-9-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220519150516.443078-1-miquel.raynal@bootlin.com>
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
index 999534f64485..5e1fcc7b0123 100644
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

