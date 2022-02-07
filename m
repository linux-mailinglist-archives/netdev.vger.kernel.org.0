Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6572D4AC272
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358363AbiBGPFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442269AbiBGOsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:18 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20721C0401C2;
        Mon,  7 Feb 2022 06:48:16 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F0C5920010;
        Mon,  7 Feb 2022 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=03PeMOOBYV3QxuR6NQ4Wuywa+Kse1fWPBQRqVz5KdeI=;
        b=FLQk+u542umCe8pYRuUaeYTuaVAxQJGj32WSSMrduRjrq3+EQsTgOaGDrVErsgkIrCaB13
        fuwp4AdLTe6U8VDoXdBCnkXHTPLnrbqfkua6mBKLv534metxUuE45O1mAH8AYksmZPXoc4
        ggaCZPVMfpyQ4iXL0SDli0XW4s+PlhpAv4f9Tf8tMcpXrgk0oSYALB05cZh8WQGVkuh5E6
        0TWnmRgegSXgLiif2Cuhamxx2cxuJAl584dA1K5OFaSlrLG1Oo0biMfFjgvv77DS5s6RL2
        Pi6Atx2pEVvJ1swgx6kNM8EUzq0ehdZHLHEkhyvNDE9Z20Ldh+pzvVY/X8WudA==
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
Subject: [PATCH wpan-next v2 05/14] net: ieee802154: ca8210: Call _xmit_error() when a transmission fails
Date:   Mon,  7 Feb 2022 15:47:55 +0100
Message-Id: <20220207144804.708118-6-miquel.raynal@bootlin.com>
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

ieee802154_xmit_error() is the right helper to call when a transmission
has failed. Let's use it instead of open-coding it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index fc74fa0f1ddd..1dfc5528f295 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1765,17 +1765,20 @@ static int ca8210_async_xmit_complete(
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
 		if (status != MAC_TRANSACTION_OVERFLOW) {
-			dev_kfree_skb_any(priv->tx_skb);
-			ieee802154_wake_queue(priv->hw);
+			ieee802154_xmit_error(priv->hw, priv->tx_skb, ifs_handling);
 			return 0;
 		}
 	}
+
 	ieee802154_xmit_complete(priv->hw, priv->tx_skb, true);
 
 	return 0;
-- 
2.27.0

