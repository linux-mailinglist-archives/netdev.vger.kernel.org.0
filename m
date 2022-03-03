Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D041D4CC51D
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbiCCS0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbiCCS0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:26:11 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A571A58EA;
        Thu,  3 Mar 2022 10:25:25 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BB76F20011;
        Thu,  3 Mar 2022 18:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646331922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=regqtWdmmr7YwP29eVg+fqSTAspcC6y2WbxEFTy5muw=;
        b=mdKlb9kgwh3LLXPCZJ/K2YDn63AOlIxD1hlzJh34PEY0fa2IS0IHSUwXMHCJDb82bLJVPn
        x4rdaE6/TXvqGJKFKTL+48BvgiL1M7XazEYnhIUHx/XvFrfHjucy9dTZDvbhYKjvHdd2hU
        7q4NczKx/FVZ59KZRmBLy0KDI2K6RkcxZBzqO2j4nlA1Zt9EJZDrhwmAttX50EcyyquIwF
        EXVOy67vo/RULj6S2YGhok9T1FPH1wavvwtymwb6pvXT1AIC+0r2zFWV1IFWglmO+1pvBv
        MbzZYf06Kv+7IIq44YxVWmr8KkbqIskqSPuL9V+kb+sHFzhskrxTOsS5rGBMUw==
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
Subject: [PATCH wpan-next v3 08/11] net: ieee802154: at86rf230: Call _xmit_error() when a transmission fails
Date:   Thu,  3 Mar 2022 19:25:05 +0100
Message-Id: <20220303182508.288136-9-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220303182508.288136-1-miquel.raynal@bootlin.com>
References: <20220303182508.288136-1-miquel.raynal@bootlin.com>
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

As the error helper also requires an error code, save the error from the
previous helper in order to give this value to the core when
opportunate.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 5f19266b3045..9cc272e3460a 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -74,6 +74,7 @@ struct at86rf230_state_change {
 	u8 to_state;
 
 	bool free;
+	int reason;
 };
 
 struct at86rf230_trac {
@@ -340,14 +341,14 @@ at86rf230_async_error_recover_complete(void *context)
 {
 	struct at86rf230_state_change *ctx = context;
 	struct at86rf230_local *lp = ctx->lp;
+	int reason = ctx->reason;
 
 	if (ctx->free)
 		kfree(ctx);
 
 	if (lp->was_tx) {
 		lp->was_tx = 0;
-		dev_kfree_skb_any(lp->tx_skb);
-		ieee802154_wake_queue(lp->hw);
+		ieee802154_xmit_error(lp->hw, lp->tx_skb, reason);
 	}
 }
 
@@ -370,27 +371,24 @@ static inline void
 at86rf230_async_error(struct at86rf230_local *lp,
 		      struct at86rf230_state_change *ctx, int rc)
 {
-	int reason;
-
 	switch (rc) {
 	case TRAC_CHANNEL_ACCESS_FAILURE:
-		reason = IEEE802154_CHANNEL_ACCESS_FAILURE;
+		ctx->reason = IEEE802154_CHANNEL_ACCESS_FAILURE;
 		break;
 	case TRAC_NO_ACK:
-		reason = IEEE802154_NO_ACK;
+		ctx->reason = IEEE802154_NO_ACK;
 		break;
 	case TRAC_INVALID:
-		reason = IEEE802154_SYSTEM_ERROR;
+		ctx->reason = IEEE802154_SYSTEM_ERROR;
 		break;
 	default:
-		reason = rc;
+		ctx->reason = rc;
 	}
 
-	if (reason < 0)
-		dev_err(&lp->spi->dev, "spi_async error %d\n", reason);
+	if (ctx->reason < 0)
+		dev_err(&lp->spi->dev, "spi_async error %d\n", ctx->reason);
 	else
-		dev_err(&lp->spi->dev, "xceiver error %d\n", reason);
-
+		dev_err(&lp->spi->dev, "xceiver error %d\n", ctx->reason);
 
 	at86rf230_async_state_change(lp, ctx, STATE_FORCE_TRX_OFF,
 				     at86rf230_async_error_recover);
-- 
2.27.0

