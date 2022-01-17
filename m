Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653884907EF
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbiAQL42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239456AbiAQLzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:45 -0500
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7014C061748;
        Mon, 17 Jan 2022 03:55:35 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D167E200003;
        Mon, 17 Jan 2022 11:55:32 +0000 (UTC)
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
Subject: [PATCH v3 27/41] net: mac802154: Introduce a tx queue flushing mechanism
Date:   Mon, 17 Jan 2022 12:54:26 +0100
Message-Id: <20220117115440.60296-28-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now we are able to stop a queue but we have no indication if a
transmission is ongoing or not. We recently introduced an ongoing tx
count variable so let's use it to wake up a queue. Waiters on the queue
will be woken up once all the ongoing transmissions are over. Thanks to
this feature, we will soon be able to introduce a synchronous API.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h      | 1 +
 net/ieee802154/core.c        | 1 +
 net/mac802154/cfg.c          | 1 +
 net/mac802154/ieee802154_i.h | 1 +
 net/mac802154/tx.c           | 6 ++++++
 net/mac802154/util.c         | 1 +
 6 files changed, 11 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 56aa672e1912..0848896120fa 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -286,6 +286,7 @@ struct wpan_phy {
 	/* Transmission monitoring and control */
 	atomic_t ongoing_txs;
 	atomic_t hold_txs;
+	wait_queue_head_t sync_txq;
 
 	char priv[] __aligned(NETDEV_ALIGN);
 };
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index de259b5170ab..0953cacafbff 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -129,6 +129,7 @@ wpan_phy_new(const struct cfg802154_ops *ops, size_t priv_size)
 	wpan_phy_net_set(&rdev->wpan_phy, &init_net);
 
 	init_waitqueue_head(&rdev->dev_wait);
+	init_waitqueue_head(&rdev->wpan_phy.sync_txq);
 
 	return &rdev->wpan_phy;
 }
diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index e8aabf215286..e2900c9b788c 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -48,6 +48,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
 
 	atomic_inc(&wpan_phy->hold_txs);
 	ieee802154_stop_queue(&local->hw);
+	ieee802154_sync_tx(local);
 	synchronize_net();
 
 	/* stop hardware - this must stop RX */
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 0291e49058f2..37d5438fdb3f 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -122,6 +122,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
 
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
 void ieee802154_xmit_sync_worker(struct work_struct *work);
+void ieee802154_sync_tx(struct ieee802154_local *local);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index de5ecda80472..d1fd2cc67cbe 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -48,6 +48,7 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
 
 	kfree_skb(skb);
 	atomic_dec(&local->phy->ongoing_txs);
+	wake_up(&local->phy->sync_txq);
 	netdev_dbg(dev, "transmission failed\n");
 }
 
@@ -117,6 +118,11 @@ ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	return ieee802154_tx(local, skb);
 }
 
+void ieee802154_sync_tx(struct ieee802154_local *local)
+{
+	wait_event(local->phy->sync_txq, !atomic_read(&local->phy->ongoing_txs));
+}
+
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index db2ac53b937e..230fe3390df7 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -90,6 +90,7 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 after_wakeup:
 	dev_consume_skb_any(skb);
 	atomic_dec(&hw->phy->ongoing_txs);
+	wake_up(&hw->phy->sync_txq);
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
 
-- 
2.27.0

