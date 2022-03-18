Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AC04DE22C
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240515AbiCRUO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbiCRUO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:14:57 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BF218A7A9;
        Fri, 18 Mar 2022 13:13:37 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D61AA223EF;
        Fri, 18 Mar 2022 21:13:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647634416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8eeLDjh6XapUMf/oGuY0biPxASPRa2wiMP2QiDHhD0Y=;
        b=ju1TVEchIP157lqBA6dKazAzpJnVAQhCe/+uNB34ljJO3oGHPkyg7xtyX/yyYBKuu6h0zT
        P/vVglkrxbkPmBk6gphjR1Tb91YqeiA1YPhr0hxufciym2wqJQmhAbpnXkyUGko85z2cWX
        llnDWpF7LCkqv5fM+EsiQaEyFQj7zVw=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 2/3] net: mdio: mscc-miim: replace magic numbers for the bus reset
Date:   Fri, 18 Mar 2022 21:13:23 +0100
Message-Id: <20220318201324.1647416-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318201324.1647416-1-michael@walle.cc>
References: <20220318201324.1647416-1-michael@walle.cc>
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
index 64fb76c1e395..2f77bf75288d 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -158,18 +158,18 @@ static int mscc_miim_reset(struct mii_bus *bus)
 {
 	struct mscc_miim_dev *miim = bus->priv;
 	int offset = miim->phy_reset_offset;
+	int reset_bits = PHY_CFG_PHY_ENA | PHY_CFG_PHY_COMMON_RESET |
+			 PHY_CFG_PHY_RESET;
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
+		ret = regmap_write(miim->phy_regs, offset, reset_bits);
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

