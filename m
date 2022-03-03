Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D154E4CC529
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbiCCS0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbiCCS0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:26:10 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCD71A58E9;
        Thu,  3 Mar 2022 10:25:24 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 737132000F;
        Thu,  3 Mar 2022 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646331920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPv/8Ot5ykbhlNZhcY2g7IR2LHAZfOxJORZgNi+HzlY=;
        b=Vyp+ldFqelPevxlLvIltLkMYDubuDE+/jwHK95FaRfCzwJCfsMzrpgICCqiSkn3BeCFnlp
        SKlH88HVpY0BGVeEFd/XxYMv/ocbYMkbnxYp8i/4GIiuqPSlQACn9AG56MkxrZftGZ//GD
        X62uE5wG5yhGHr7fkAWbVL1eriG6cVfBg1gg1wjBkyNr/8Wcv4AlN37l8SwELC2OZZ7U0M
        oj4A56fztryjh1DFfl40kAEcK8KZuYCPJ+hawFYPteEXK/p20mNPVbO66xm3zo5n/9Bqsq
        mInF3WIzRwtWerjdQUsks9i110amsG1Ez/yDyd9552PwlPCNeYyufo/kGajSlw==
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
Subject: [PATCH wpan-next v3 07/11] net: ieee802154: at86rf230: Provide meaningful error codes when possible
Date:   Thu,  3 Mar 2022 19:25:04 +0100
Message-Id: <20220303182508.288136-8-miquel.raynal@bootlin.com>
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

Either the spi operation failed, or the device encountered an error. In
both case, we know more or less what happened thanks to the spi call
return code or the content of the TRAC register otherwise. Use them in
order to propagate one step above the error.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 12ee071057d2..5f19266b3045 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -370,7 +370,27 @@ static inline void
 at86rf230_async_error(struct at86rf230_local *lp,
 		      struct at86rf230_state_change *ctx, int rc)
 {
-	dev_err(&lp->spi->dev, "spi_async error %d\n", rc);
+	int reason;
+
+	switch (rc) {
+	case TRAC_CHANNEL_ACCESS_FAILURE:
+		reason = IEEE802154_CHANNEL_ACCESS_FAILURE;
+		break;
+	case TRAC_NO_ACK:
+		reason = IEEE802154_NO_ACK;
+		break;
+	case TRAC_INVALID:
+		reason = IEEE802154_SYSTEM_ERROR;
+		break;
+	default:
+		reason = rc;
+	}
+
+	if (reason < 0)
+		dev_err(&lp->spi->dev, "spi_async error %d\n", reason);
+	else
+		dev_err(&lp->spi->dev, "xceiver error %d\n", reason);
+
 
 	at86rf230_async_state_change(lp, ctx, STATE_FORCE_TRX_OFF,
 				     at86rf230_async_error_recover);
@@ -693,6 +713,7 @@ at86rf230_tx_trac_check(void *context)
 		goto failure;
 	default:
 		WARN_ONCE(1, "received tx trac status %d\n", trac);
+		trac = TRAC_INVALID;
 		lp->trac.invalid++;
 		goto failure;
 	}
@@ -702,7 +723,7 @@ at86rf230_tx_trac_check(void *context)
 	return;
 
 failure:
-	at86rf230_async_error(lp, ctx, -EIO);
+	at86rf230_async_error(lp, ctx, trac);
 }
 
 static void
-- 
2.27.0

