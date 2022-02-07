Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7474AC282
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442474AbiBGPFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442285AbiBGOso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:44 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F935C0401C1;
        Mon,  7 Feb 2022 06:48:43 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C8E0220018;
        Mon,  7 Feb 2022 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gKnd6M0EVSNZgQEvfaJLr2HCQgkWZxPrPgHQMKTb7RA=;
        b=UDTRE5JWVrBaSVBWraLt2u+J0pZKkBtzFDZKMu0WNUyZ2U1QxEpJayKdd8eMnAKw7DIEaa
        gSDpup0OmVC7i+iFO+WPknVCFpcO4nJMFkJG7FWLmBy5kZiz3uBQMzlW5tlaFMea1x2oQ2
        UAQhMGBZ2ACrHgefVTGkRrTZDFcIJUeU1+4WZrm84nMT1i7E3a7yAxVFdYNsR3ytajdkKt
        tRVadQcRmwxYtyVNb40PbhRuLZ2/AVyPKaYCac5L18G05aPSiSPRCcHqIpEuMGdvpTbRJi
        DEZJwQDbF+kbRWbL6IaUzIzFxAT+NrbTe+LBtt8dr5sOuuzYSDc3dvQMZAIjbw==
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
Subject: [PATCH wpan-next v2 10/14] net: mac802154: Hold the transmit queue when relevant
Date:   Mon,  7 Feb 2022 15:48:00 +0100
Message-Id: <20220207144804.708118-11-miquel.raynal@bootlin.com>
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

Let's create a hold_txs atomic variable and increment/decrement it when
relevant. A current use is during a suspend. Very soon we will also use
this feature during scans.

When the variable is incremented, any further call to helpers usually
waking up the queue will skip this part because it is the core
responsibility to wake up the queue when relevant.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h      | 3 ++-
 net/mac802154/cfg.c          | 4 +++-
 net/mac802154/ieee802154_i.h | 5 +++++
 net/mac802154/tx.c           | 7 +++++--
 net/mac802154/util.c         | 7 ++++++-
 5 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 473ebcb9b155..043d8e4359e7 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -214,8 +214,9 @@ struct wpan_phy {
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
index d3bcc097e491..56fcd7ef5b6f 100644
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
index a72d202c212b..cc572c12a8f9 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -87,7 +87,12 @@ ieee802154_wakeup_after_xmit_done(struct ieee802154_hw *hw, bool ifs_handling,
 static void ieee802154_xmit_end(struct ieee802154_hw *hw, bool ifs_handling,
 				unsigned int skb_len)
 {
-	ieee802154_wakeup_after_xmit_done(hw, ifs_handling, skb_len);
+	struct ieee802154_local *local = hw_to_local(hw);
+
+	/* Avoid waking-up a transmit queue which needs to remain stopped */
+	if (!mac802154_queue_is_stopped(local))
+		ieee802154_wakeup_after_xmit_done(hw, ifs_handling, skb_len);
+
 	atomic_dec(&hw->phy->ongoing_txs);
 }
 
-- 
2.27.0

