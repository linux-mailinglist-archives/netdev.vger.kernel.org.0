Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED97F638AFE
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKYNSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiKYNSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:18:12 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B296314;
        Fri, 25 Nov 2022 05:18:10 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 91A2910000C;
        Fri, 25 Nov 2022 13:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669382289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=55j9+pE5serVzhnMTbv/yWHlwVqG0P8aXjk+91N8pmo=;
        b=SiOXIiLYraXwB85aZtJFfKRo6XCjpwXBNzHzXLTa1n1xVN9B4F4cVUdYoUL5xzUDi5aD8C
        mamEZ7hnUlvXa2l0lcG0A5M7Zg6Q8NohX8z9aNt8X8XcH28q5SGdwwiZeCN/3RhvmTMt9W
        rdKT+qb/vBD1ddGSoC9TKCw9tdjcoTskdaPB5e4lst2JvsPsG8k7vxTb1a76sCLqgf2OzT
        cuUSHHetIhIu52TSdgwzYLkmuvGdx1J7NqAmPQwDxrQup2/GcoyyNOBPVniPJ8WBqcAS8A
        6KbMxbEpwSMpNa/ZiDj0eAjf5/EWyd6iMB8QtiFIr60CG3/gEmikL/BelB23AA==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 1/3] net: pcs: altera-tse: use read_poll_timeout to wait for reset
Date:   Fri, 25 Nov 2022 14:17:59 +0100
Message-Id: <20221125131801.64234-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
References: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Software resets on the TSE PCS don't clear registers, but rather reset
all internal state machines regarding AN, comma detection and
encoding/decoding. Use read_poll_timeout to wait for the reset to clear
instead of manually polling the register.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/pcs/pcs-altera-tse.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/pcs/pcs-altera-tse.c b/drivers/net/pcs/pcs-altera-tse.c
index 97a7cabff962..e86cadc391e8 100644
--- a/drivers/net/pcs/pcs-altera-tse.c
+++ b/drivers/net/pcs/pcs-altera-tse.c
@@ -60,7 +60,6 @@ static void tse_pcs_write(struct altera_tse_pcs *tse_pcs, int regnum,
 
 static int tse_pcs_reset(struct altera_tse_pcs *tse_pcs)
 {
-	int i = 0;
 	u16 bmcr;
 
 	/* Reset PCS block */
@@ -68,13 +67,9 @@ static int tse_pcs_reset(struct altera_tse_pcs *tse_pcs)
 	bmcr |= BMCR_RESET;
 	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
 
-	for (i = 0; i < SGMII_PCS_SW_RESET_TIMEOUT; i++) {
-		if (!(tse_pcs_read(tse_pcs, MII_BMCR) & BMCR_RESET))
-			return 0;
-		udelay(1);
-	}
-
-	return -ETIMEDOUT;
+	return read_poll_timeout(tse_pcs_read, bmcr, (bmcr & BMCR_RESET),
+				 10, SGMII_PCS_SW_RESET_TIMEOUT, 1,
+				 tse_pcs, MII_BMCR);
 }
 
 static int alt_tse_pcs_validate(struct phylink_pcs *pcs,
-- 
2.38.1

