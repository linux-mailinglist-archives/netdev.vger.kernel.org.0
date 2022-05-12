Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A7052501F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355349AbiELOdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355351AbiELOdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:33:47 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA00225E7BD;
        Thu, 12 May 2022 07:33:34 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C3F4AFF80A;
        Thu, 12 May 2022 14:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652366013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oc+YYFcB9F2PbelME9QHTxAT2CiRXpDuuUb/zfH4ixs=;
        b=Gz7DvP2XTZa/fX1DOo9jraUYe31c+SXLrokPeTVlJnFbRhf0om53Xsdqx52/CQWUqaAQk+
        uSii/b3yglJfnD6LRgUrg/WnAV2aQwa+rcatM6evD36tt3bhEcrJHHbPM3ozSWALbu7OdQ
        c8UUVPWT5W0ZIi5xTmj+8l3t4ID0Dq2Z4cl8fgnmsO8B1q4rj+D7LgrAjjnpS8/SziZYY/
        6G0hZw5xkZGPYzrPOHVJSOHK5/VKI6kSq63xuulYNDNap3sp+iSPF4Hz8SMY9jY1Tixt5N
        40GhZVR71blU4R+4RES7sFvlMx0zRBQTOrpud9s6EEPpMS/Pk4ILny711l2O9A==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 10/11] net: mac802154: Add a warning in the hot path
Date:   Thu, 12 May 2022 16:33:13 +0200
Message-Id: <20220512143314.235604-11-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512143314.235604-1-miquel.raynal@bootlin.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
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
index 8b6326aa2d42..a1370e87233e 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -218,6 +218,7 @@ struct wpan_phy {
 	struct mutex queue_lock;
 	atomic_t ongoing_txs;
 	atomic_t hold_txs;
+	atomic_t queue_stopped;
 	wait_queue_head_t sync_txq;
 
 	char priv[] __aligned(NETDEV_ALIGN);
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index ec8d872143ee..a3c9f194c025 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -123,9 +123,13 @@ static int ieee802154_sync_queue(struct ieee802154_local *local)
 
 int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
 {
+	int ret;
+
 	ieee802154_hold_queue(local);
+	ret = ieee802154_sync_queue(local);
+	atomic_set(&local->phy->queue_stopped, 1);
 
-	return ieee802154_sync_queue(local);
+	return ret;
 }
 
 int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
@@ -153,9 +157,19 @@ int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	return ret;
 }
 
+static bool ieee802154_queue_is_stopped(struct ieee802154_local *local)
+{
+	return atomic_read(&local->phy->queue_stopped);
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
index 65a9127a41ea..54f05ae88172 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -29,6 +29,7 @@ static void ieee802154_wake_queue(struct ieee802154_hw *hw)
 	struct ieee802154_sub_if_data *sdata;
 
 	rcu_read_lock();
+	atomic_set(&local->phy->queue_stopped, 0);
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!sdata->dev)
 			continue;
-- 
2.27.0

