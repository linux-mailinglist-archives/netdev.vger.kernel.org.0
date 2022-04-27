Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98443511F73
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243583AbiD0Quk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243518AbiD0Qu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:50:26 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85A43A6AD3;
        Wed, 27 Apr 2022 09:47:13 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CFDCF10000F;
        Wed, 27 Apr 2022 16:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651078032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=px6AHkCHCkCygBsaH5J3RUD7FCF1uQeWDYconq5IqwA=;
        b=b071SoX+ibijv9ZM3IMsk8uDNOrVnM2jjXuqOXaya8R9WS0yOGou8MY4NqSTzQtbFpwifA
        CzUelAneAwkq17v/ZtP706JhMKohkXkeRglpnezbvhddvTWa5qeZKCqvFkroV9npEPcWKj
        Fxb1dw36alKNfyyI2l/g26a98Cr3yaHm0o+da7zTqia7ul5JBuChdLLgjKGYLKGJ9QDSxs
        3axpWchRpKzfUxbn+rU7wYMZUzqRujgYg6eAxJ+UGc3MlMopWLG74QdoIIZIaFsBiUkz/w
        FaQoNhmBpT9QVI9C5osMfVoTRXWK41RHsBLfKYARh8PUthQe6Kix7DOs2W7k6w==
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
Subject: [PATCH wpan-next 06/11] net: mac802154: Hold the transmit queue when relevant
Date:   Wed, 27 Apr 2022 18:46:54 +0200
Message-Id: <20220427164659.106447-7-miquel.raynal@bootlin.com>
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

Let's create a hold_txs atomic variable and increment/decrement it when
relevant. Currently we can use it during a suspend. Very soon we will
also use this feature during scans.

When the variable is incremented, any further wake up call will be
skipped until the variable gets decremented back.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h      |  3 ++-
 net/mac802154/cfg.c          |  2 ++
 net/mac802154/ieee802154_i.h | 24 ++++++++++++++++++++++++
 net/mac802154/tx.c           | 15 +++++++++++++++
 net/mac802154/util.c         |  3 +++
 5 files changed, 46 insertions(+), 1 deletion(-)

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
index dafe02548161..0540a2b014d2 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -46,6 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
 	if (!local->open_count)
 		goto suspend;
 
+	ieee802154_hold_queue(local);
 	ieee802154_stop_queue(local);
 	synchronize_net();
 
@@ -72,6 +73,7 @@ static int ieee802154_resume(struct wpan_phy *wpan_phy)
 		return ret;
 
 wake_up:
+	ieee802154_release_queue(local);
 	ieee802154_wake_queue(local);
 	local->suspended = false;
 	return 0;
diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 3f59a291b481..b55fdefb0b34 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -142,6 +142,30 @@ enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer);
  */
 void ieee802154_wake_queue(struct ieee802154_local *local);
 
+/**
+ * ieee802154_hold_queue - hold ieee802154 queue
+ * @local: main mac object
+ *
+ * Hold a queue, this queue cannot be woken up while this is active.
+ */
+void ieee802154_hold_queue(struct ieee802154_local *local);
+
+/**
+ * ieee802154_release_queue - release ieee802154 queue
+ * @local: main mac object
+ *
+ * Release a queue which is held. The queue can now be woken up.
+ */
+void ieee802154_release_queue(struct ieee802154_local *local);
+
+/**
+ * ieee802154_queue_is_held - checks whether the ieee802154 queue is held
+ * @local: main mac object
+ *
+ * Checks whether the queue is currently held.
+ */
+bool ieee802154_queue_is_held(struct ieee802154_local *local);
+
 /**
  * ieee802154_stop_queue - stop ieee802154 queue
  * @local: main mac object
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 8c0bad7796ba..d088aa8119e8 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -106,6 +106,21 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
+void ieee802154_hold_queue(struct ieee802154_local *local)
+{
+	atomic_inc(&local->phy->hold_txs);
+}
+
+void ieee802154_release_queue(struct ieee802154_local *local)
+{
+	atomic_dec(&local->phy->hold_txs);
+}
+
+bool ieee802154_queue_is_held(struct ieee802154_local *local)
+{
+	return atomic_read(&local->phy->hold_txs);
+}
+
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 4bcc9cd2eb9d..847e0864b575 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -17,6 +17,9 @@ void ieee802154_wake_queue(struct ieee802154_local *local)
 {
 	struct ieee802154_sub_if_data *sdata;
 
+	if (ieee802154_queue_is_held(local))
+		return;
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!sdata->dev)
-- 
2.27.0

