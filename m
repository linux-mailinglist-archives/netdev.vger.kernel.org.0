Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF58749452F
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358003AbiATAvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:43 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:52077 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357998AbiATAvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:41 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C8C4510000E;
        Thu, 20 Jan 2022 00:51:38 +0000 (UTC)
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
Subject: [wpan-next 10/14] net: mac802154: Hold the transmit queue when relevant
Date:   Thu, 20 Jan 2022 01:51:18 +0100
Message-Id: <20220120005122.309104-11-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120005122.309104-1-miquel.raynal@bootlin.com>
References: <20220120005122.309104-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's create a hold_txs atomic variable and increment/decrement it when
relevant. A current use is during a suspend. Very soon we will also use
this feature during scans.

When the variable is incremented, any further call to helpers usually
waking up the queue will skip this part because it is the core
responsibility to wake up the queue when relevant.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h      |  3 ++-
 net/mac802154/cfg.c          |  4 +++-
 net/mac802154/ieee802154_i.h |  5 +++++
 net/mac802154/tx.c           |  7 +++++--
 net/mac802154/util.c         | 14 ++++++++++++--
 5 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 969cae56b000..56aa672e1912 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -283,8 +283,9 @@ struct wpan_phy {
 	/* the network namespace this phy lives in currently */
 	possible_net_t _net;
 
-	/* Transmission monitoring */
+	/* Transmission monitoring and control */
 	atomic_t ongoing_txs;
+	atomic_t hold_txs;
 
 	char priv[] __aligned(NETDEV_ALIGN);
 };
diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index 1e4a9f74ed43..e8aabf215286 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -46,6 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
 	if (!local->open_count)
 		goto suspend;
 
+	atomic_inc(&wpan_phy->hold_txs);
 	ieee802154_stop_queue(&local->hw);
 	synchronize_net();
 
@@ -72,7 +73,8 @@ static int ieee802154_resume(struct wpan_phy *wpan_phy)
 		return ret;
 
 wake_up:
-	ieee802154_wake_queue(&local->hw);
+	if (!atomic_dec_and_test(&wpan_phy->hold_txs))
+		ieee802154_wake_queue(&local->hw);
 	local->suspended = false;
 	return 0;
 }
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 18d1f6804810..0291e49058f2 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -190,6 +190,11 @@ void mac802154_unlock_table(struct net_device *dev);
 
 int mac802154_wpan_update_llsec(struct net_device *dev);
 
+static inline bool mac802154_queue_is_stopped(struct ieee802154_local *local)
+{
+	return atomic_read(&local->phy->hold_txs);
+}
+
 /* interface handling */
 int ieee802154_iface_init(void);
 void ieee802154_iface_exit(void);
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 731e86bfe73f..a8d4d5e175b6 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -43,7 +43,9 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
 
 err_tx:
 	/* Restart the netif queue on each sub_if_data object. */
-	ieee802154_wake_queue(&local->hw);
+	if (!mac802154_queue_is_stopped(local))
+		ieee802154_wake_queue(&local->hw);
+
 	kfree_skb(skb);
 	atomic_dec(&local->phy->ongoing_txs);
 	netdev_dbg(dev, "transmission failed\n");
@@ -87,7 +89,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 
 		ret = drv_xmit_async(local, skb);
 		if (ret) {
-			ieee802154_wake_queue(&local->hw);
+			if (!mac802154_queue_is_stopped(local))
+				ieee802154_wake_queue(&local->hw);
 			goto err_tx;
 		}
 
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index ae405d995868..e9c8542cfec6 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -87,7 +87,12 @@ ieee802154_wakeup_after_xmit_done(struct ieee802154_hw *hw, struct sk_buff *skb,
 void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 			      bool ifs_handling)
 {
-	ieee802154_wakeup_after_xmit_done(hw, skb, ifs_handling);
+	struct ieee802154_local *local = hw_to_local(hw);
+
+	/* Avoid waking-up a queue which needs to remain stopped */
+	if (!mac802154_queue_is_stopped(local))
+		ieee802154_wakeup_after_xmit_done(hw, skb, ifs_handling);
+
 	dev_consume_skb_any(skb);
 	atomic_dec(&hw->phy->ongoing_txs);
 }
@@ -97,7 +102,12 @@ EXPORT_SYMBOL(ieee802154_xmit_complete);
 void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
 			   bool ifs_handling)
 {
-	ieee802154_wakeup_after_xmit_done(hw, skb, ifs_handling);
+	struct ieee802154_local *local = hw_to_local(hw);
+
+	/* Avoid waking-up a queue which needs to remain stopped */
+	if (!mac802154_queue_is_stopped(local))
+		ieee802154_wakeup_after_xmit_done(hw, skb, ifs_handling);
+
 	dev_kfree_skb_any(skb);
 	atomic_dec(&hw->phy->ongoing_txs);
 }
-- 
2.27.0

