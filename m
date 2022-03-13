Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A0A4D71D4
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 01:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiCMAXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 19:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiCMAXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 19:23:10 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B449BBB2;
        Sat, 12 Mar 2022 16:22:04 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6542D223EF;
        Sun, 13 Mar 2022 01:22:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647130922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ktKATcRoqLfirbTTmmOyuxW1FnqVXQyfWiJhpDCMKF4=;
        b=RgjMB7dQAywRjAS2CY0ReaG5nWVADe5QKwuKmAdCsTilPXYV2Qo3fcq2S2GNKfxjln2HRy
        2+vjD3wPWF9lTgAfaPmDpZHz3H/JYPUVNNluQuHiOEzJqxM9VEllD9fvQlyxRpAz5SQ/MW
        WPBZzFDRGf0yYsHmWz5b7EFEr2wrACc=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/3] net: mdio: mscc-miim: replace magic numbers for the bus reset
Date:   Sun, 13 Mar 2022 01:21:52 +0100
Message-Id: <20220313002153.11280-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220313002153.11280-1-michael@walle.cc>
References: <20220313002153.11280-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the magic numbers by macros which are already defined. It seems
the original commit missed to use them.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/mdio/mdio-mscc-miim.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 64fb76c1e395..7773d5019e66 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -158,18 +158,18 @@ static int mscc_miim_reset(struct mii_bus *bus)
 {
 	struct mscc_miim_dev *miim = bus->priv;
 	int offset = miim->phy_reset_offset;
+	int mask = PHY_CFG_PHY_ENA | PHY_CFG_PHY_COMMON_RESET |
+		   PHY_CFG_PHY_RESET;
 	int ret;
 
 	if (miim->phy_regs) {
-		ret = regmap_write(miim->phy_regs,
-				   MSCC_PHY_REG_PHY_CFG + offset, 0);
+		ret = regmap_write(miim->phy_regs, offset, 0);
 		if (ret < 0) {
 			WARN_ONCE(1, "mscc reset set error %d\n", ret);
 			return ret;
 		}
 
-		ret = regmap_write(miim->phy_regs,
-				   MSCC_PHY_REG_PHY_CFG + offset, 0x1ff);
+		ret = regmap_write(miim->phy_regs, offset, mask);
 		if (ret < 0) {
 			WARN_ONCE(1, "mscc reset clear error %d\n", ret);
 			return ret;
@@ -272,7 +272,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
 	miim = bus->priv;
 	miim->phy_regs = phy_regmap;
-	miim->phy_reset_offset = 0;
+	miim->phy_reset_offset = MSCC_PHY_REG_PHY_CFG;
 
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
-- 
2.30.2

