Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2664F214E87
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgGESbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:31:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47464 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbgGESbJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 14:31:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1js9Pv-003itC-T3; Sun, 05 Jul 2020 20:31:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/7] net: phy: at803x: Avoid comparison is always false warning
Date:   Sun,  5 Jul 2020 20:29:15 +0200
Message-Id: <20200705182921.887441-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705182921.887441-1-andrew@lunn.ch>
References: <20200705182921.887441-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By placing the GENMASK value into an unsigned int and then passing it
to PREF_FIELD, the type is reduces down from ULL. Given the reduced
size of the type, the range checks in PREP_FAIL() are always true, and
-Wtype-limits then gives a warning.

By skipping the intermediate variable, the warning can be avoided.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/at803x.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 97cbe593f0ea..bdd84f6f0214 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -400,7 +400,7 @@ static int at803x_parse_dt(struct phy_device *phydev)
 {
 	struct device_node *node = phydev->mdio.dev.of_node;
 	struct at803x_priv *priv = phydev->priv;
-	unsigned int sel, mask;
+	unsigned int sel;
 	u32 freq, strength;
 	int ret;
 
@@ -409,7 +409,6 @@ static int at803x_parse_dt(struct phy_device *phydev)
 
 	ret = of_property_read_u32(node, "qca,clk-out-frequency", &freq);
 	if (!ret) {
-		mask = AT803X_CLK_OUT_MASK;
 		switch (freq) {
 		case 25000000:
 			sel = AT803X_CLK_OUT_25MHZ_XTAL;
@@ -428,8 +427,8 @@ static int at803x_parse_dt(struct phy_device *phydev)
 			return -EINVAL;
 		}
 
-		priv->clk_25m_reg |= FIELD_PREP(mask, sel);
-		priv->clk_25m_mask |= mask;
+		priv->clk_25m_reg |= FIELD_PREP(AT803X_CLK_OUT_MASK, sel);
+		priv->clk_25m_mask |= AT803X_CLK_OUT_MASK;
 
 		/* Fixup for the AR8030/AR8035. This chip has another mask and
 		 * doesn't support the DSP reference. Eg. the lowest bit of the
-- 
2.27.0.rc2

