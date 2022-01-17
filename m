Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D224907C1
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239424AbiAQL4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:56:01 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:46595 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiAQLze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:34 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 4E7C4200005;
        Mon, 17 Jan 2022 11:55:31 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 26/41] net: mac802154: Add a warning in the hot path
Date:   Mon, 17 Jan 2022 12:54:25 +0100
Message-Id: <20220117115440.60296-27-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should never start a transmission after the queue has been stopped.

But because it might work we don't kill the function here but rather
warn loudly the user that something is wrong.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 18ee6fcfcd7f..de5ecda80472 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -112,6 +112,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 static netdev_tx_t
 ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 {
+	WARN_ON(mac802154_queue_is_stopped(local));
+
 	return ieee802154_tx(local, skb);
 }
 
-- 
2.27.0

