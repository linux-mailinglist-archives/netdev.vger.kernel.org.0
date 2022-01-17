Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F204907AE
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbiAQLzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239388AbiAQLzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:23 -0500
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55479C061574;
        Mon, 17 Jan 2022 03:55:22 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 5F7E7200013;
        Mon, 17 Jan 2022 11:55:19 +0000 (UTC)
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
Subject: [PATCH v3 19/41] net: ieee802154: ca8210: Call the complete helper when a transmission is over
Date:   Mon, 17 Jan 2022 12:54:18 +0100
Message-Id: <20220117115440.60296-20-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee802154_xmit_complete() is the right helper to call when a
transmission is over. The fact that it completed or not is not really a
question, but drivers must tell the core that the completion is over,
even if it was canceled. Do not call ieee802154_wake_queue() manually,
in order to let full control of this task to the core.

Here the two paths are equivalent of calling *_xmit_complete() with its
ifs_handling parameter set to true or false, so let's use it instead of
open coding it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index d3a9e4fe05f4..374827f51dff 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1750,6 +1750,7 @@ static int ca8210_async_xmit_complete(
 	u8                     status)
 {
 	struct ca8210_priv *priv = hw->priv;
+	bool ifs_handling = true;
 
 	if (priv->nextmsduhandle != msduhandle) {
 		dev_err(
@@ -1770,10 +1771,8 @@ static int ca8210_async_xmit_complete(
 			"Link transmission unsuccessful, status = %d\n",
 			status
 		);
-		if (status != MAC_TRANSACTION_OVERFLOW) {
-			ieee802154_wake_queue(priv->hw);
-			return 0;
-		}
+		if (status != MAC_TRANSACTION_OVERFLOW)
+			ifs_handling = false;
 	}
 	ieee802154_xmit_complete(priv->hw, priv->tx_skb, true);
 
-- 
2.27.0

