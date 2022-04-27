Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2505D51200C
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243451AbiD0Qu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243598AbiD0Quk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:50:40 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08093BD070;
        Wed, 27 Apr 2022 09:47:20 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 78766100002;
        Wed, 27 Apr 2022 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651078038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vKzkq+CfZY3IbT17d7R/+82HSGULbkE/4tJqMeFNIFk=;
        b=nizfKK0bL96mWpudc/adrCC/RXKdp9ljR4SCE+4LlycfpkBLcozPdpaNotg8jvZIOPl3bw
        Qs/FvvX8nZ4tR92ud/XU7jFo7XRvHYHlYxR49685NWhe/NJqhYJ/pgeMb3jQJF3Bb/0NKr
        SJHgFbAERKSz1jssj90ZgujKRwm/6tss6faY0NQ5LgP4SBjeONrE1z/0BE/0BE+rEGgdDt
        KkkjdqPPpELDMOeIQCQNYk2VdH6qUQI4EWe/ZdcHG8R7FOUzb+VxJn0FRKyRC1b4wuteNP
        5zkARqDYEurUFbL2NbuPl58OA55e3J3bspKTj90JL77oZ3v3aA/HEd4ZzHNXgQ==
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
Subject: [PATCH wpan-next 10/11] net: mac802154: Introduce a tx queue flushing mechanism
Date:   Wed, 27 Apr 2022 18:46:58 +0200
Message-Id: <20220427164659.106447-11-miquel.raynal@bootlin.com>
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
 net/mac802154/cfg.c          |  3 +--
 net/mac802154/ieee802154_i.h |  1 +
 net/mac802154/tx.c           | 24 +++++++++++++++++++++++-
 net/mac802154/util.c         |  7 +++++--
 6 files changed, 32 insertions(+), 5 deletions(-)

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
index 0540a2b014d2..c17e38bef425 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -46,8 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
 	if (!local->open_count)
 		goto suspend;
 
-	ieee802154_hold_queue(local);
-	ieee802154_stop_queue(local);
+	ieee802154_sync_and_hold_queue(local);
 	synchronize_net();
 
 	/* stop hardware - this must stop RX */
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index c686a027555a..c87c7fa04435 100644
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
index 021dddfea542..5f94973b57e4 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -45,7 +45,8 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
 	/* Restart the netif queue on each sub_if_data object. */
 	ieee802154_wake_queue(local);
 	kfree_skb(skb);
-	atomic_dec(&local->phy->ongoing_txs);
+	if (!atomic_dec_and_test(&local->phy->ongoing_txs))
+		wake_up(&local->phy->sync_txq);
 	netdev_dbg(dev, "transmission failed\n");
 }
 
@@ -121,6 +122,27 @@ bool ieee802154_queue_is_held(struct ieee802154_local *local)
 	return atomic_read(&local->phy->hold_txs);
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
+	ieee802154_wake_queue(local);
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
index 3e2b157b34b1..056f8c4e6bcd 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -120,7 +120,8 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 	}
 
 	dev_consume_skb_any(skb);
-	atomic_dec(&hw->phy->ongoing_txs);
+	if (!atomic_dec_and_test(&hw->phy->ongoing_txs))
+		wake_up(&hw->phy->sync_txq);
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
 
@@ -132,7 +133,9 @@ void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
 	local->tx_result = reason;
 	ieee802154_wake_queue(local);
 	dev_kfree_skb_any(skb);
-	atomic_dec(&hw->phy->ongoing_txs);
+
+	if (!atomic_dec_and_test(&hw->phy->ongoing_txs))
+		wake_up(&hw->phy->sync_txq);
 }
 EXPORT_SYMBOL(ieee802154_xmit_error);
 
-- 
2.27.0

