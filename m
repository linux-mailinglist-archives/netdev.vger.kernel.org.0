Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08552F5F2D
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbhANKqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbhANKqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:46:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1E5C061574;
        Thu, 14 Jan 2021 02:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9c/RAxqz4uj5zq3YgUTJtsutm0+/ot3zKjXuHo78vW0=; b=YL5kEJQb+u5RgThkm1t+dgXgA4
        qLRt/qJcI4Ny5MVcQr5NlicwUlrYTztzn+mIxaXE9STfb+N9PSXmexdpDKZo9VpvCYYMnkXG5Udht
        Mi9QVVD5kr0JUqhbkEbIVnR+D5FyDyjXsnn5cq1XsARYEtpwqZf9QxKxjJf79jcYVzGRPsndcQFyP
        ghhRYG7IIJIvGP94W8QkzTlftaJ/hKA/q55wHu31x3EPLEHbECaKY25jGC84GZaAMYJKKAK5Q0bif
        cYEhESaAe3Kr0cpDiRYb4D2SMwvfxX+lbH3StSCsb4P8XFkGSvzSQRyAyCKFGfshrVFSg1lR4Sno1
        4HDd2MxA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55648 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l008U-0002KY-16; Thu, 14 Jan 2021 10:45:50 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l008T-0004tS-Q5; Thu, 14 Jan 2021 10:45:49 +0000
In-Reply-To: <20210114104455.GP1551@shell.armlinux.org.uk>
References: <20210114104455.GP1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Jon Nettleton <jon@solid-run.com>
Subject: [PATCH net-next 2/2] net: phy: at803x: add support for configuring
 SmartEEE
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1l008T-0004tS-Q5@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 14 Jan 2021 10:45:49 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SmartEEE for the atheros phy was deemed buggy by Freescale and commits
were added to disable it for their boards.

In initial testing, SolidRun found that the default settings were
causing disconnects but by increasing the Tw buffer time we could allow
enough time for all parts of the link to come out of a low power state
and function properly without causing a disconnect. This allows us to
have functional power savings of between 300 and 400mW, rather than
disabling the feature altogether.

This commit adds support for disabling SmartEEE and configuring the Tw
parameters for 1G and 100M speeds.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/at803x.c | 65 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 3909dc9fc94b..104dd7b37c5d 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -132,6 +132,11 @@
 #define AT803X_MIN_DOWNSHIFT 2
 #define AT803X_MAX_DOWNSHIFT 9
 
+#define AT803X_MMD3_SMARTEEE_CTL1		0x805b
+#define AT803X_MMD3_SMARTEEE_CTL2		0x805c
+#define AT803X_MMD3_SMARTEEE_CTL3		0x805d
+#define AT803X_MMD3_SMARTEEE_CTL3_LPI_EN	BIT(8)
+
 #define ATH9331_PHY_ID 0x004dd041
 #define ATH8030_PHY_ID 0x004dd076
 #define ATH8031_PHY_ID 0x004dd074
@@ -146,8 +151,11 @@ MODULE_LICENSE("GPL");
 struct at803x_priv {
 	int flags;
 #define AT803X_KEEP_PLL_ENABLED	BIT(0)	/* don't turn off internal PLL */
+#define AT803X_DISABLE_SMARTEEE	BIT(1)
 	u16 clk_25m_reg;
 	u16 clk_25m_mask;
+	u8 smarteee_lpi_tw_1g;
+	u8 smarteee_lpi_tw_100m;
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
@@ -411,13 +419,32 @@ static int at803x_parse_dt(struct phy_device *phydev)
 {
 	struct device_node *node = phydev->mdio.dev.of_node;
 	struct at803x_priv *priv = phydev->priv;
-	u32 freq, strength;
+	u32 freq, strength, tw;
 	unsigned int sel;
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_OF_MDIO))
 		return 0;
 
+	if (of_property_read_bool(node, "qca,disable-smarteee"))
+		priv->flags |= AT803X_DISABLE_SMARTEEE;
+
+	if (!of_property_read_u32(node, "qca,smarteee-tw-us-1g", &tw)) {
+		if (!tw || tw > 255) {
+			phydev_err(phydev, "invalid qca,smarteee-tw-us-1g\n");
+			return -EINVAL;
+		}
+		priv->smarteee_lpi_tw_1g = tw;
+	}
+
+	if (!of_property_read_u32(node, "qca,smarteee-tw-us-100m", &tw)) {
+		if (!tw || tw > 255) {
+			phydev_err(phydev, "invalid qca,smarteee-tw-us-100m\n");
+			return -EINVAL;
+		}
+		priv->smarteee_lpi_tw_100m = tw;
+	}
+
 	ret = of_property_read_u32(node, "qca,clk-out-frequency", &freq);
 	if (!ret) {
 		switch (freq) {
@@ -526,6 +553,38 @@ static void at803x_remove(struct phy_device *phydev)
 		regulator_disable(priv->vddio);
 }
 
+static int at803x_smarteee_config(struct phy_device *phydev)
+{
+	struct at803x_priv *priv = phydev->priv;
+	u16 mask = 0, val = 0;
+	int ret;
+
+	if (priv->flags & AT803X_DISABLE_SMARTEEE)
+		return phy_modify_mmd(phydev, MDIO_MMD_PCS,
+				      AT803X_MMD3_SMARTEEE_CTL3,
+				      AT803X_MMD3_SMARTEEE_CTL3_LPI_EN, 0);
+
+	if (priv->smarteee_lpi_tw_1g) {
+		mask |= 0xff00;
+		val |= priv->smarteee_lpi_tw_1g << 8;
+	}
+	if (priv->smarteee_lpi_tw_100m) {
+		mask |= 0x00ff;
+		val |= priv->smarteee_lpi_tw_100m;
+	}
+	if (!mask)
+		return 0;
+
+	ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_MMD3_SMARTEEE_CTL1,
+			     mask, val);
+	if (ret)
+		return ret;
+
+	return phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_MMD3_SMARTEEE_CTL3,
+			      AT803X_MMD3_SMARTEEE_CTL3_LPI_EN,
+			      AT803X_MMD3_SMARTEEE_CTL3_LPI_EN);
+}
+
 static int at803x_clk_out_config(struct phy_device *phydev)
 {
 	struct at803x_priv *priv = phydev->priv;
@@ -577,6 +636,10 @@ static int at803x_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	ret = at803x_smarteee_config(phydev);
+	if (ret < 0)
+		return ret;
+
 	ret = at803x_clk_out_config(phydev);
 	if (ret < 0)
 		return ret;
-- 
2.20.1

