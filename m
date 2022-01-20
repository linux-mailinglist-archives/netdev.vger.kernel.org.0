Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94E4494537
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357994AbiATAvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:49 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:44769 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358026AbiATAvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:46 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6CBAB100002;
        Thu, 20 Jan 2022 00:51:43 +0000 (UTC)
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
Subject: [wpan-next 13/14] net: mac802154: Introduce a tx queue flushing mechanism
Date:   Thu, 20 Jan 2022 01:51:21 +0100
Message-Id: <20220120005122.309104-14-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120005122.309104-1-miquel.raynal@bootlin.com>
References: <20220120005122.309104-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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
 net/mac802154/cfg.c          |  5 ++---
 net/mac802154/ieee802154_i.h |  1 +
 net/mac802154/tx.c           | 11 ++++++++++-
 net/mac802154/util.c         |  3 ++-
 6 files changed, 17 insertions(+), 5 deletions(-)

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
index e8aabf215286..da94aaa32fcb 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -46,8 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
 	if (!local->open_count)
 		goto suspend;
 
-	atomic_inc(&wpan_phy->hold_txs);
-	ieee802154_stop_queue(&local->hw);
+	ieee802154_sync_and_stop_tx(local);
 	synchronize_net();
 
 	/* stop hardware - this must stop RX */
@@ -73,7 +72,7 @@ static int ieee802154_resume(struct wpan_phy *wpan_phy)
 		return ret;
 
 wake_up:
-	if (!atomic_dec_and_test(&wpan_phy->hold_txs))
+	if (!atomic_read(&wpan_phy->hold_txs))
 		ieee802154_wake_queue(&local->hw);
 	local->suspended = false;
 	return 0;
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 0291e49058f2..d9433e07906e 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -122,6 +122,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
 
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
 void ieee802154_xmit_sync_worker(struct work_struct *work);
+void ieee802154_sync_and_stop_tx(struct ieee802154_local *local);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index abd9a057521e..06ae2e6cea43 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -47,7 +47,8 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
 		ieee802154_wake_queue(&local->hw);
 
 	kfree_skb(skb);
-	atomic_dec(&local->phy->ongoing_txs);
+	if (!atomic_dec_and_test(&local->phy->ongoing_txs))
+		wake_up(&local->phy->sync_txq);
 	netdev_dbg(dev, "transmission failed\n");
 }
 
@@ -117,6 +118,14 @@ ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	return ieee802154_tx(local, skb);
 }
 
+void ieee802154_sync_and_stop_tx(struct ieee802154_local *local)
+{
+	atomic_inc(&local->phy->hold_txs);
+	ieee802154_stop_queue(&local->hw);
+	wait_event(local->phy->sync_txq, !atomic_read(&local->phy->ongoing_txs));
+	atomic_dec(&local->phy->hold_txs);
+}
+
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index e9c8542cfec6..949c5035cb07 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -94,7 +94,8 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 		ieee802154_wakeup_after_xmit_done(hw, skb, ifs_handling);
 
 	dev_consume_skb_any(skb);
-	atomic_dec(&hw->phy->ongoing_txs);
+	if (!atomic_dec_and_test(&hw->phy->ongoing_txs))
+		wake_up(&hw->phy->sync_txq);
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
 
-- 
2.27.0

