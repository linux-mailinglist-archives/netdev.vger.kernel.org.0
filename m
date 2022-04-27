Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FAE511F1F
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243556AbiD0QvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243518AbiD0Qul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:50:41 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AE83BDE4C;
        Wed, 27 Apr 2022 09:47:21 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DE6D7100008;
        Wed, 27 Apr 2022 16:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651078040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BIiG20WZvkHQ4ep4wdahDp0PX+zvyjhFTQ2/0CC9xKE=;
        b=dkfZlUwUt9kqDyy5AKoaowaBywT+wnU+nZcW6YYhZnwqsEgYBn1BkilD2IV3TyBR3SAA0J
        1xniS1RC05PgLqyPC7pTpDgaPHQSx37CcuC5EWxFzicHs+MkShn7KTWf21sh6G6OVaN88m
        ddUY3QB+byws1Yp4nR9i1rnx9lTaKuaG+k+Du8v/lVgSSQ/Sc0Bm4RsSPX9iwi7r5Amc5f
        CS0IPnojUrqvGJ+LK1pLxgypt6XKNqOM6Kmy5WyNoKm8Yv7i+YMbRIJnoSwwRAu8t+gPcr
        6u4S6EVLw0g/gDLdRxVdoSsH9tzS9Ce3tmmutpV+Up+5E26kJ8TgMKOoRiN7ug==
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
Subject: [PATCH wpan-next 11/11] net: mac802154: Introduce a synchronous API for MLME commands
Date:   Wed, 27 Apr 2022 18:46:59 +0200
Message-Id: <20220427164659.106447-12-miquel.raynal@bootlin.com>
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

This is the slow path, we need to wait for each command to be processed
before continuing so let's introduce an helper which does the
transmission and blocks until it gets notified of its asynchronous
completion. This helper is going to be used when introducing scan
support.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h |  1 +
 net/mac802154/tx.c           | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index c87c7fa04435..8aa8d0dd9c41 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
 void ieee802154_xmit_sync_worker(struct work_struct *work);
 int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
+int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 5f94973b57e4..17244293c59a 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -143,6 +143,25 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
 	return ieee802154_sync_queue(local);
 }
 
+int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
+{
+	bool queue_held = ieee802154_queue_is_held(local);
+	int ret;
+
+	if (!queue_held)
+		ieee802154_sync_and_hold_queue(local);
+
+	ieee802154_tx(local, skb);
+	ret = ieee802154_sync_queue(local);
+
+	if (!queue_held)
+		ieee802154_release_queue(local);
+
+	ieee802154_wake_queue(local);
+
+	return ret;
+}
+
 static netdev_tx_t
 ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 {
-- 
2.27.0

