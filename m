Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48DF52D6F1
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240444AbiESPGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240429AbiESPFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:05:42 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6C7517EA;
        Thu, 19 May 2022 08:05:37 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1A36E1BF211;
        Thu, 19 May 2022 15:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652972736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8R4bNPsgCv/WrPxVpudpqyd/QBoanUSwODXOCdeGr6c=;
        b=ONCwxsjRR9W4VtegOzIp4lo6Cs4Y8kpxMwGcY1d9MZv4EEY4n7yXKN/lhKrsmAfhV6Z0+6
        m+T5iUyhSsq8aZvjWPnUbtEv0wIiJWtynG2qamzrvwSXaYBaf9MpBEhbVOqfnX2P1PEOCZ
        AuFB8FwN6dfWkcJ19/rY3ou8mtErSMAdiSb8X7i6JctC7Drq+YDPlmZ3gmt3ohbhQFIH+g
        MH8+IB6QxAlPXm1GVdEjmlPlM3XaSghYGqa4MHhqK0biEwGJ3jlWZ/FLY4uijsiC8oSkdG
        Q3aOvRS7585yXxeMOJe7rG4vacFr0QHaJjB1iZxmWZgZgmXz5yXREaR1KRbioQ==
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
Subject: [PATCH wpan-next v4 09/11] net: mac802154: Introduce a synchronous API for MLME commands
Date:   Thu, 19 May 2022 17:05:14 +0200
Message-Id: <20220519150516.443078-10-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220519150516.443078-1-miquel.raynal@bootlin.com>
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
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

This is the slow path, we need to wait for each command to be processed
before continuing so let's introduce an helper which does the
transmission and blocks until it gets notified of its asynchronous
completion. This helper is going to be used when introducing scan
support.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h |  4 ++++
 net/mac802154/tx.c           | 44 ++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index a057827fc48a..8a4816ae71e7 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -125,6 +125,10 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
 void ieee802154_xmit_sync_worker(struct work_struct *work);
 int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
+int ieee802154_mlme_op_pre(struct ieee802154_local *local);
+int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
+void ieee802154_mlme_op_post(struct ieee802154_local *local);
+int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_buff *skb);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 38f74b8b6740..4827391600f6 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -128,6 +128,50 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
 	return ieee802154_sync_queue(local);
 }
 
+int ieee802154_mlme_op_pre(struct ieee802154_local *local)
+{
+	return ieee802154_sync_and_hold_queue(local);
+}
+
+int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
+{
+	int ret;
+
+	/* Avoid possible calls to ->ndo_stop() when we asynchronously perform
+	 * MLME transmissions.
+	 */
+	rtnl_lock();
+
+	/* Ensure the device was not stopped, otherwise error out */
+	if (!local->open_count) {
+		rtnl_unlock();
+		return -ENETDOWN;
+	}
+
+	ieee802154_tx(local, skb);
+	ret = ieee802154_sync_queue(local);
+
+	rtnl_unlock();
+
+	return ret;
+}
+
+void ieee802154_mlme_op_post(struct ieee802154_local *local)
+{
+	ieee802154_release_queue(local);
+}
+
+int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_buff *skb)
+{
+	int ret;
+
+	ieee802154_mlme_op_pre(local);
+	ret = ieee802154_mlme_tx(local, skb);
+	ieee802154_mlme_op_post(local);
+
+	return ret;
+}
+
 static netdev_tx_t
 ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 {
-- 
2.34.1

