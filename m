Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D513D511FF0
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243591AbiD0Qun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243557AbiD0Qu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:50:28 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54B13B2FE8;
        Wed, 27 Apr 2022 09:47:16 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 022F010000C;
        Wed, 27 Apr 2022 16:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651078035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UYcW7qXTukp8gAmJtzYIXgiO9r5Z22F+sU4J8lU9bZE=;
        b=Wq+SGdHLQnifOpnQzK8sZjQMLAqnquYIT8ERq7OGT9hjePepWu3vhJyIXxR76wb0xD7GFR
        5QlY7NnSR+g8vStLuwRUPULagPUfWmHYAxfMmhxDgFmm1OKnyNekJYYMpjtEJCb0G77KwP
        yvWRSEui9ZREO86LdehCraspGdQhj+HVqLkXR136+Yy0ADCvYXaM2Dhjxn1xFUnC1/pEAA
        ZLiAckKS9ImKeHDcOlhtv4EXpwgTuqQoad9jRXjCDQPISpnaT7sr69NfI8ARAbfMB3Po4D
        9J3zlI5X2vpjHtEtLrave3HxS7u7oY5DfPZG1If0Vk3kiHjtDHCVZwSuji3TNA==
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
Subject: [PATCH wpan-next 08/11] net: mac802154: Add a warning in the hot path
Date:   Wed, 27 Apr 2022 18:46:56 +0200
Message-Id: <20220427164659.106447-9-miquel.raynal@bootlin.com>
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

We should never start a transmission after the queue has been stopped.

But because it might work we don't kill the function here but rather
warn loudly the user that something is wrong.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h |  8 ++++++++
 net/mac802154/tx.c           |  2 ++
 net/mac802154/util.c         | 18 ++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index b55fdefb0b34..cb61a4abaf37 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -178,6 +178,14 @@ bool ieee802154_queue_is_held(struct ieee802154_local *local);
  */
 void ieee802154_stop_queue(struct ieee802154_local *local);
 
+/**
+ * ieee802154_queue_is_stopped - check whether ieee802154 queue was stopped
+ * @local: main mac object
+ *
+ * Goes through all the interfaces and indicates if they are all stopped or not.
+ */
+bool ieee802154_queue_is_stopped(struct ieee802154_local *local);
+
 /* MIB callbacks */
 void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan);
 
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index a8a83f0167bf..021dddfea542 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -124,6 +124,8 @@ bool ieee802154_queue_is_held(struct ieee802154_local *local)
 static netdev_tx_t
 ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 {
+	WARN_ON_ONCE(ieee802154_queue_is_stopped(local));
+
 	return ieee802154_tx(local, skb);
 }
 
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 847e0864b575..cfd17a7db532 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -44,6 +44,24 @@ void ieee802154_stop_queue(struct ieee802154_local *local)
 	rcu_read_unlock();
 }
 
+bool ieee802154_queue_is_stopped(struct ieee802154_local *local)
+{
+	struct ieee802154_sub_if_data *sdata;
+	bool stopped = true;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!sdata->dev)
+			continue;
+
+		if (!netif_queue_stopped(sdata->dev))
+			stopped = false;
+	}
+	rcu_read_unlock();
+
+	return stopped;
+}
+
 enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer)
 {
 	struct ieee802154_local *local =
-- 
2.27.0

