Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914D1494523
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357981AbiATAvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357974AbiATAvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:36 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B25C061574;
        Wed, 19 Jan 2022 16:51:34 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 71289100008;
        Thu, 20 Jan 2022 00:51:31 +0000 (UTC)
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
Subject: [wpan-next 05/14] net: ieee802154: ca8210: Call _xmit_error() when a transmission fails
Date:   Thu, 20 Jan 2022 01:51:13 +0100
Message-Id: <20220120005122.309104-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120005122.309104-1-miquel.raynal@bootlin.com>
References: <20220120005122.309104-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee802154_xmit_error() is the right helper to call when a transmission
has failed. Let's use it instead of open-coding it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 91456c5e5691..2830e6fdd0fd 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1765,17 +1765,19 @@ static int ca8210_async_xmit_complete(
 	priv->nextmsduhandle++;
 
 	if (status) {
+		bool ifs_handling =
+			status == MAC_TRANSACTION_OVERFLOW ? true : false;
+
 		dev_err(
 			&priv->spi->dev,
 			"Link transmission unsuccessful, status = %d\n",
 			status
 		);
-		if (status != MAC_TRANSACTION_OVERFLOW) {
-			ieee802154_wake_queue(priv->hw);
-			dev_kfree_skb_any(atusb->tx_skb);
-			return 0;
-		}
+
+		ieee802154_xmit_error(priv->hw, priv->tx_skb, ifs_handling);
+		return 0;
 	}
+
 	ieee802154_xmit_complete(priv->hw, priv->tx_skb, true);
 
 	return 0;
-- 
2.27.0

