Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25F94AC26C
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239345AbiBGPFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442281AbiBGOsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:30 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C76FC0401C1;
        Mon,  7 Feb 2022 06:48:29 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 480C52000D;
        Mon,  7 Feb 2022 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3N1S3rGLbsDgwaPfgEoq52NBP1iyP4isiXbkLeW13wk=;
        b=PaGkctaRg5RDmERt6GXCqnai30UrvaT4v50vi5lN8ZnZ/vvXU46xJMd/0/tDZIi3iGe0V2
        URwTf736vQnzGJGYQuZTmIr96kTQZvzwnt3xXYcZ8qr2njGd2eHF2We/aitRnmu3zKvtGR
        0vyWFtb9sKzsdYUk/ZE7lSS0RsfHfXnjcXgR6ukDlYOPAIE0sV0S7IomYFW91ZqTLbwWb7
        xCeYZLy7fwXuncZY3cqI731jGmTFr4PdMUG4sVvf7/WCJxy/PJEFxeXfKcP7Sy2hIPcGQu
        WT9sMGQWimO6BwXnUMIoSnORHki9tlPpA8R5R5wuN5ZkR4H1gAWGnwsk0IgYXw==
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
Subject: [PATCH wpan-next v2 14/14] net: mac802154: Introduce a synchronous API for MLME commands
Date:   Mon,  7 Feb 2022 15:48:04 +0100
Message-Id: <20220207144804.708118-15-miquel.raynal@bootlin.com>
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

This is the slow path, we need to wait for each command to be processed
before continuing so let's introduce an helper which does the
transmission and blocks until it gets notified of its asynchronous
completion. This helper is going to be used when introducing scan
support.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h | 1 +
 net/mac802154/tx.c           | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 295c9ce091e1..ad76a60af087 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -123,6 +123,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
 void ieee802154_xmit_sync_worker(struct work_struct *work);
 void ieee802154_sync_and_stop_tx(struct ieee802154_local *local);
+void ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 06ae2e6cea43..7c281458942e 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -126,6 +126,12 @@ void ieee802154_sync_and_stop_tx(struct ieee802154_local *local)
 	atomic_dec(&local->phy->hold_txs);
 }
 
+void ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
+{
+	ieee802154_tx(local, skb);
+	ieee802154_sync_and_stop_tx(local);
+}
+
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-- 
2.27.0

