Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9266459E8A4
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343951AbiHWRHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343892AbiHWRG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:06:28 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4B2E3992;
        Tue, 23 Aug 2022 07:05:31 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 127FB240004;
        Tue, 23 Aug 2022 14:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661263530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B6DzPRsUZD3BX7st5mrwg1j5KcZUXUd28krvVfkgAGo=;
        b=mlkn26nHT8xgDfLXsM45ZguG7mU0caECQX8lOtsx4dWNzdLMa1GQsRljS31vH+R8Glz9nK
        mRMMMZJDMyrXOn4UrvCVgLfY5PvpiYGY+/bYsLnh7Zw/QfFsFYbXGyULYE7hq9OC+EXRp0
        JyoBhYybXhjFK6WGLtcPn30BZhcpPayhQ5RzGW+PgSBLQ71HlyZ2fJiRiCqIpow2JQsrAx
        YDvK9yc2sgXgVyLVbpxrsm5TC2AwSDdMQujp/WlsX1VsgG8L7oEbYisfKTA7gClqHj+WYl
        OuBzRWJkdfKFcV8US/XGzVGu3Al+BV2b6UFtmk0fR7+TZnPw8LmkjRWNbjh+4g==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 1/2] net: altera: tse: add a dedicated helper for reset
Date:   Tue, 23 Aug 2022 16:05:16 +0200
Message-Id: <20220823140517.3091239-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823140517.3091239-1-maxime.chevallier@bootlin.com>
References: <20220823140517.3091239-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
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

Performing a soft reset on the PCS block for altera TSE re-initializes
the decoding logic, and should be done when reconfiguring the link.

Move the reset logic to a dedicated helper, to ease transition to
phylink.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/altera/altera_tse_main.c | 35 +++++++++++--------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 8c5828582c21..ad59b0befc18 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -107,6 +107,25 @@ static int sgmii_pcs_scratch_test(struct altera_tse_private *priv, u16 value)
 	return (sgmii_pcs_read(priv, SGMII_PCS_SCRATCH) == value);
 }
 
+static int sgmii_pcs_reset(struct altera_tse_private *priv)
+{
+	u16 bmcr;
+	int i = 0;
+
+	/* Reset PCS block */
+	bmcr = sgmii_pcs_read(priv, MII_BMCR);
+	bmcr |= BMCR_RESET;
+	sgmii_pcs_write(priv, MII_BMCR, bmcr);
+
+	for (i = 0; i < SGMII_PCS_SW_RESET_TIMEOUT; i++) {
+		if (!(sgmii_pcs_read(priv, MII_BMCR) & BMCR_RESET))
+			return 0;
+		udelay(1);
+	}
+
+	return -ETIMEDOUT;
+}
+
 /* MDIO specific functions
  */
 static int altera_tse_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
@@ -1092,7 +1111,6 @@ static void tse_set_rx_mode(struct net_device *dev)
 static int init_sgmii_pcs(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
-	int n;
 	unsigned int tmp_reg = 0;
 
 	if (priv->phy_iface != PHY_INTERFACE_MODE_SGMII)
@@ -1131,20 +1149,7 @@ static int init_sgmii_pcs(struct net_device *dev)
 	tmp_reg |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
 	sgmii_pcs_write(priv, MII_BMCR, tmp_reg);
 
-	/* Reset PCS block */
-	tmp_reg |= BMCR_RESET;
-	sgmii_pcs_write(priv, MII_BMCR, tmp_reg);
-	for (n = 0; n < SGMII_PCS_SW_RESET_TIMEOUT; n++) {
-		if (!(sgmii_pcs_read(priv, MII_BMCR) & BMCR_RESET)) {
-			netdev_info(dev, "SGMII PCS block initialised OK\n");
-			return 0;
-		}
-		udelay(1);
-	}
-
-	/* We failed to reset the block, return a timeout */
-	netdev_err(dev, "SGMII PCS block reset failed.\n");
-	return -ETIMEDOUT;
+	return sgmii_pcs_reset(priv);
 }
 
 /* Open and initialize the interface
-- 
2.37.2

