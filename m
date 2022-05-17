Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D829152A815
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351005AbiEQQfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350985AbiEQQfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:35:14 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4424EF69;
        Tue, 17 May 2022 09:35:11 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 127FE1BF203;
        Tue, 17 May 2022 16:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652805310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x2L9vTayR4JTg3k5T13rX8g1ZQkraEl1NcEyTxGGc/U=;
        b=amTS96f6fI+lBdi6Y6Waw0MNYbYTZd1NVTVXIZF7ZzRnhYYU3tRqmgJq13h53sKX3Pc78q
        7Tcjjsl4WLZuAkYFWz2c8mvC2Ho7pKYjB+KcUKz4zKV+GSmvxYTuy49Q9haIKtgnOn2i56
        H1aLpXNmlMur0ddDfZ11eNFAezO/D9eOzU72EK12xRpg3KDaFjCZgWMn5TmsYSHcEgXDRI
        3n9PXuz9d/UKpSgRhIacihmjY0kpHydf69iCg5LCqA9vH7yoN6eoWxUfXmfh1QZE87tJN/
        unsBwZGeO3qvrysYBKZ8ZltVe/kMaY2s2S5nA6Rlel2H5qQ1WKYMCSKIv5qjqA==
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
Subject: [PATCH wpan-next v3 10/11] net: mac802154: Add a warning in the hot path
Date:   Tue, 17 May 2022 18:34:49 +0200
Message-Id: <20220517163450.240299-11-miquel.raynal@bootlin.com>
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

We should never start a transmission after the queue has been stopped.

But because it might work we don't kill the function here but rather
warn loudly the user that something is wrong.

Set an atomic when the queue will remain stopped. Reset this atomic when
the queue actually gets restarded. Just check this atomic to know if the
transmission is legitimate, warn if it is not.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h |  1 +
 net/mac802154/tx.c      | 16 +++++++++++++++-
 net/mac802154/util.c    |  1 +
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 8881b6126b58..f4e7b3fe7cf0 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -218,6 +218,7 @@ struct wpan_phy {
 	spinlock_t queue_lock;
 	atomic_t ongoing_txs;
 	atomic_t hold_txs;
+	unsigned long queue_stopped;
 	wait_queue_head_t sync_txq;
 
 	char priv[] __aligned(NETDEV_ALIGN);
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 6cc4e5c7ba94..e36aca788ea2 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -123,9 +123,13 @@ static int ieee802154_sync_queue(struct ieee802154_local *local)
 
 int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
 {
+	int ret;
+
 	ieee802154_hold_queue(local);
+	ret = ieee802154_sync_queue(local);
+	set_bit(0, &local->phy->queue_stopped);
 
-	return ieee802154_sync_queue(local);
+	return ret;
 }
 
 static int ieee802154_mlme_op_pre(struct ieee802154_local *local)
@@ -174,9 +178,19 @@ int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_buff *skb)
 	return ret;
 }
 
+static bool ieee802154_queue_is_stopped(struct ieee802154_local *local)
+{
+	return test_bit(0, &local->phy->queue_stopped);
+}
+
 static netdev_tx_t
 ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 {
+	/* Warn if the net interface tries to transmit frames while the
+	 * ieee802154 core assumes the queue is stopped.
+	 */
+	WARN_ON_ONCE(ieee802154_queue_is_stopped(local));
+
 	return ieee802154_tx(local, skb);
 }
 
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index cddb42984484..faf12c2135bf 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -29,6 +29,7 @@ static void ieee802154_wake_queue(struct ieee802154_hw *hw)
 	struct ieee802154_sub_if_data *sdata;
 
 	rcu_read_lock();
+	clear_bit(0, &local->phy->queue_stopped);
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!sdata->dev)
 			continue;
-- 
2.34.1

