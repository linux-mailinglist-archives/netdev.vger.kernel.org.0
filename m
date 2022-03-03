Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600384CC526
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbiCCS0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235755AbiCCS0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:26:10 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE96E1A58E4;
        Thu,  3 Mar 2022 10:25:22 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3246D2000E;
        Thu,  3 Mar 2022 18:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646331919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YJXbl6AYQi16uRc3GrKH3BgZvJvVjapvU0fhtBE7LcY=;
        b=WF+7s/bSIFt9w8pGKpgjBN708I8BeoCChdW1hmuA8ejyKgKpaqUH/p50acY0ljrkaMlhHq
        A7V4Cq2DaxP24WkDGAxBb93n/OEp1eKfotCaEv4ng5v7ogkgNS+WOpg5+XXlc4/7ZI8k/G
        47+Tk6Q2APocd3y3RCe+/DNRj83iA9q6Ak0lMPmc7NVrYUNvymu3Faytl0+8ne7qUlEbTk
        XPH59tbXmUIZL9YzS+gpZBQE58g0em6naIpyJI3RQQEbVwxr2wVbMtficWzp1Yh6dhqLX5
        22I2+MTqfkCRHA8d7q+SOYPKpuLM8WIcICjN+9IScX8mn4kMAqwMIwFMk9J85A==
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
Subject: [PATCH wpan-next v3 06/11] net: ieee802154: at86rf230: Return early in case of error
Date:   Thu,  3 Mar 2022 19:25:03 +0100
Message-Id: <20220303182508.288136-7-miquel.raynal@bootlin.com>
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

The TRAC register is only parsed in the Tx path if the debugfs entry is
enabled. This does not look like a good idea because this register gives
us the actual status of the transmitted packet.

Let's always check the content of this register and error out when
appropriate.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 49 ++++++++++++++++--------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 616acfa8cd28..12ee071057d2 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -673,33 +673,36 @@ at86rf230_tx_trac_check(void *context)
 	struct at86rf230_state_change *ctx = context;
 	struct at86rf230_local *lp = ctx->lp;
 
-	if (IS_ENABLED(CONFIG_IEEE802154_AT86RF230_DEBUGFS)) {
-		u8 trac = TRAC_MASK(ctx->buf[1]);
+	u8 trac = TRAC_MASK(ctx->buf[1]);
 
-		switch (trac) {
-		case TRAC_SUCCESS:
-			lp->trac.success++;
-			break;
-		case TRAC_SUCCESS_DATA_PENDING:
-			lp->trac.success_data_pending++;
-			break;
-		case TRAC_CHANNEL_ACCESS_FAILURE:
-			lp->trac.channel_access_failure++;
-			break;
-		case TRAC_NO_ACK:
-			lp->trac.no_ack++;
-			break;
-		case TRAC_INVALID:
-			lp->trac.invalid++;
-			break;
-		default:
-			WARN_ONCE(1, "received tx trac status %d\n", trac);
-			lp->trac.invalid++;
-			break;
-		}
+	switch (trac) {
+	case TRAC_SUCCESS:
+		lp->trac.success++;
+		break;
+	case TRAC_SUCCESS_DATA_PENDING:
+		lp->trac.success_data_pending++;
+		break;
+	case TRAC_CHANNEL_ACCESS_FAILURE:
+		lp->trac.channel_access_failure++;
+		goto failure;
+	case TRAC_NO_ACK:
+		lp->trac.no_ack++;
+		goto failure;
+	case TRAC_INVALID:
+		lp->trac.invalid++;
+		goto failure;
+	default:
+		WARN_ONCE(1, "received tx trac status %d\n", trac);
+		lp->trac.invalid++;
+		goto failure;
 	}
 
 	at86rf230_async_state_change(lp, ctx, STATE_TX_ON, at86rf230_tx_on);
+
+	return;
+
+failure:
+	at86rf230_async_error(lp, ctx, -EIO);
 }
 
 static void
-- 
2.27.0

