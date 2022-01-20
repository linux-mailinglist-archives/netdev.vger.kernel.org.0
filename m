Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B3A49453C
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358047AbiATAvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358001AbiATAvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:49 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF64C06161C;
        Wed, 19 Jan 2022 16:51:47 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D3FE4100004;
        Thu, 20 Jan 2022 00:51:44 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 14/14] net: mac802154: Introduce a synchronous API for MLME commands
Date:   Thu, 20 Jan 2022 01:51:22 +0100
Message-Id: <20220120005122.309104-15-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120005122.309104-1-miquel.raynal@bootlin.com>
References: <20220120005122.309104-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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
index d9433e07906e..bdec3b9229e4 100644
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

