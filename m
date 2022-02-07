Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333CE4AC27C
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392336AbiBGPFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442287AbiBGOst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:49 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A90FC0401C1;
        Mon,  7 Feb 2022 06:48:48 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B67482000E;
        Mon,  7 Feb 2022 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9rVzdl9yWKeMeBpdUUGgsmqsGWk8s8Lpj0FHVxQlcE=;
        b=oYz1BdWJYV6AAtuDSgycFdIbAbgJzncgIeeLUbr8WIRemb4syy3txn0WNjIEbJpO0t3EaJ
        k+m5SC98+5Qi6H4wfL6tsNBYXIPW5xb9WfhCq+aCmEwDphc5vKmG3wrP8jfkydS2iUc2MO
        HiR5VXZcA3ECk8VcGJOGC8ipDHKINF/U4uFZhrizf2fF3+f4eFvszVKp2zyr7sUNlhVUYf
        1l9m9hQfDTK7lDNPHUaMNeZ5N8+ma1GPkaRiMTsuuGvmLiY/cZxJ2mHsBJjmBlMG0yIPDd
        sQVEuuK9ErxMOv0f2rbi1P/SrIsw9ZtnogBS7plzvyhDK+DdUbUaSg3zIWKRpg==
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
Subject: [PATCH wpan-next v2 13/14] net: mac802154: Introduce a tx queue flushing mechanism
Date:   Mon,  7 Feb 2022 15:48:03 +0100
Message-Id: <20220207144804.708118-14-miquel.raynal@bootlin.com>
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
index 043d8e4359e7..0d385a214da3 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -217,6 +217,7 @@ struct wpan_phy {
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
index 56fcd7ef5b6f..295c9ce091e1 100644
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
index cc572c12a8f9..e666ac7a16bd 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -93,7 +93,8 @@ static void ieee802154_xmit_end(struct ieee802154_hw *hw, bool ifs_handling,
 	if (!mac802154_queue_is_stopped(local))
 		ieee802154_wakeup_after_xmit_done(hw, ifs_handling, skb_len);
 
-	atomic_dec(&hw->phy->ongoing_txs);
+	if (!atomic_dec_and_test(&hw->phy->ongoing_txs))
+		wake_up(&hw->phy->sync_txq);
 }
 
 void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
-- 
2.27.0

