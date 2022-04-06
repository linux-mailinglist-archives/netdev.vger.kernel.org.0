Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91E04F6757
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbiDFRbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238849AbiDFRbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:31:25 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAA653B51;
        Wed,  6 Apr 2022 08:34:52 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EBBF120000A;
        Wed,  6 Apr 2022 15:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649259291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=khqlgvv+tcN9XQu/qHmypxl6n0RxGiIsc6xVakThOlU=;
        b=ID6Gn4+EjmIJ+3DH02joSUhfCuxJjAGhGVUD8neWAksieHfesj9XXMJVrabxO8DxNmLt5w
        Ay+Ggo7EHj7AgCyE/V9H54zwetqe0axuo8tF7k1wZcj+ruSP0LLsVGmnPLHZkzv4EWjdrN
        sW9qSfa8486Uwl01hLmulXBzNCHB4BFBzwwB4Yvl2CyzBsFniWzfv2cdS4TLgKBhjZH2li
        6FECB0X7uZi3Lrww7WZ1j1QXstBHY++4FTYfQSMuZWMJrbaYU5TKWuVBmg75uAszY3UTrX
        nNJKyTjWYy78IM2lrM+zQfLojBiWNGkPQD0XxhsKxSwGoYKaCNIql++zCNy7oQ==
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
Subject: [PATCH v5 06/11] net: ieee802154: at86rf230: Rename the asynchronous error helper
Date:   Wed,  6 Apr 2022 17:34:36 +0200
Message-Id: <20220406153441.1667375-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
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

In theory there are two distinct error path:
- The bus error when forwarding a packet to the transceiver fails.
- The transmitter error, after the transmission has been offloaded.

Right now in this driver only the former situation is properly handled,
so rename the different helpers to reflect this situation before
improving the support of the other path.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 563031ce76f0..cafc786aab57 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -336,7 +336,7 @@ static const struct regmap_config at86rf230_regmap_spi_config = {
 };
 
 static void
-at86rf230_async_error_recover_complete(void *context)
+at86rf230_async_bus_error_recover_complete(void *context)
 {
 	struct at86rf230_state_change *ctx = context;
 	struct at86rf230_local *lp = ctx->lp;
@@ -352,7 +352,7 @@ at86rf230_async_error_recover_complete(void *context)
 }
 
 static void
-at86rf230_async_error_recover(void *context)
+at86rf230_async_bus_error_recover(void *context)
 {
 	struct at86rf230_state_change *ctx = context;
 	struct at86rf230_local *lp = ctx->lp;
@@ -363,17 +363,17 @@ at86rf230_async_error_recover(void *context)
 	}
 
 	at86rf230_async_state_change(lp, ctx, STATE_RX_AACK_ON,
-				     at86rf230_async_error_recover_complete);
+				     at86rf230_async_bus_error_recover_complete);
 }
 
 static inline void
-at86rf230_async_error(struct at86rf230_local *lp,
-		      struct at86rf230_state_change *ctx, int rc)
+at86rf230_async_bus_error(struct at86rf230_local *lp,
+			  struct at86rf230_state_change *ctx, int rc)
 {
 	dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
 
 	at86rf230_async_state_change(lp, ctx, STATE_FORCE_TRX_OFF,
-				     at86rf230_async_error_recover);
+				     at86rf230_async_bus_error_recover);
 }
 
 /* Generic function to get some register value in async mode */
@@ -390,7 +390,7 @@ at86rf230_async_read_reg(struct at86rf230_local *lp, u8 reg,
 	ctx->msg.complete = complete;
 	rc = spi_async(lp->spi, &ctx->msg);
 	if (rc)
-		at86rf230_async_error(lp, ctx, rc);
+		at86rf230_async_bus_error(lp, ctx, rc);
 }
 
 static void
@@ -405,7 +405,7 @@ at86rf230_async_write_reg(struct at86rf230_local *lp, u8 reg, u8 val,
 	ctx->msg.complete = complete;
 	rc = spi_async(lp->spi, &ctx->msg);
 	if (rc)
-		at86rf230_async_error(lp, ctx, rc);
+		at86rf230_async_bus_error(lp, ctx, rc);
 }
 
 static void
@@ -640,7 +640,7 @@ at86rf230_sync_state_change(struct at86rf230_local *lp, unsigned int state)
 	rc = wait_for_completion_timeout(&lp->state_complete,
 					 msecs_to_jiffies(100));
 	if (!rc) {
-		at86rf230_async_error(lp, &lp->state, -ETIMEDOUT);
+		at86rf230_async_bus_error(lp, &lp->state, -ETIMEDOUT);
 		return -ETIMEDOUT;
 	}
 
@@ -762,7 +762,7 @@ at86rf230_rx_trac_check(void *context)
 	rc = spi_async(lp->spi, &ctx->msg);
 	if (rc) {
 		ctx->trx.len = 2;
-		at86rf230_async_error(lp, ctx, rc);
+		at86rf230_async_bus_error(lp, ctx, rc);
 	}
 }
 
@@ -839,7 +839,7 @@ static irqreturn_t at86rf230_isr(int irq, void *data)
 	ctx->msg.complete = at86rf230_irq_status;
 	rc = spi_async(lp->spi, &ctx->msg);
 	if (rc) {
-		at86rf230_async_error(lp, ctx, rc);
+		at86rf230_async_bus_error(lp, ctx, rc);
 		enable_irq(irq);
 		return IRQ_NONE;
 	}
@@ -881,7 +881,7 @@ at86rf230_write_frame(void *context)
 	rc = spi_async(lp->spi, &ctx->msg);
 	if (rc) {
 		ctx->trx.len = 2;
-		at86rf230_async_error(lp, ctx, rc);
+		at86rf230_async_bus_error(lp, ctx, rc);
 	}
 }
 
-- 
2.27.0

