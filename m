Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2826263177
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbgIIQNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730963AbgIIQMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:12:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E8FC061388
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 06:45:19 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kG0PO-0007Fb-Fs; Wed, 09 Sep 2020 15:45:10 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kG0PI-0000fU-V8; Wed, 09 Sep 2020 15:45:04 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: [PATCH v3 4/5] net: phy: smsc: LAN8710/20: add phy refclk in support
Date:   Wed,  9 Sep 2020 15:45:00 +0200
Message-Id: <20200909134501.32529-5-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909134501.32529-1-m.felsch@pengutronix.de>
References: <20200909134501.32529-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to specify the clock provider for the PHY refclk and don't
rely on 'magic' host clock setup. [1] tried to address this by
introducing a flag and fixing the corresponding host. But this commit
breaks the IRQ support since the irq setup during .config_intr() is
thrown away because the reset comes from the side without respecting the
current PHY state within the PHY library state machine. Furthermore the
commit fixed the problem only for FEC based hosts other hosts acting
like the FEC are not covered.

This commit goes the other way around to address the bug fixed by [1].
Instead of resetting the device from the side every time the refclk gets
(re-)enabled it requests and enables the clock till the device gets
removed. Now the PHY library is the only place where the PHY gets reset
to respect the PHY library state machine.

[1] commit 7f64e5b18ebb ("net: phy: smsc: LAN8710/20: add
    PHY_RST_AFTER_CLK_EN flag")

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v3:
- Add Florian's tag
- s/phy-state-machine/PHY library state machine/
- s/phy/PHY/
- reword last sentence of the commit message

v2:
- use non-devres clk_* functions and instead use the remove() function
- propagate errors upstream if the optional clk can't be retrieved.
- make use if dev_err_probe()
- adapt commit subject to cover that only the LAN8710/20 devices are
  changed

 drivers/net/phy/smsc.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 5f4f198df0eb..bdf8593e385e 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -12,6 +12,7 @@
  *
  */
 
+#include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mii.h>
@@ -33,6 +34,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 
 struct smsc_phy_priv {
 	bool energy_enable;
+	struct clk *refclk;
 };
 
 static int smsc_phy_config_intr(struct phy_device *phydev)
@@ -194,11 +196,20 @@ static void smsc_get_stats(struct phy_device *phydev,
 		data[i] = smsc_get_stat(phydev, i);
 }
 
+static void smsc_phy_remove(struct phy_device *phydev)
+{
+	struct smsc_phy_priv *priv = phydev->priv;
+
+	clk_disable_unprepare(priv->refclk);
+	clk_put(priv->refclk);
+}
+
 static int smsc_phy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct device_node *of_node = dev->of_node;
 	struct smsc_phy_priv *priv;
+	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -211,6 +222,19 @@ static int smsc_phy_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
+	/* Make clk optional to keep DTB backward compatibility. */
+	priv->refclk = clk_get_optional(dev, NULL);
+	if (IS_ERR(priv->refclk))
+		dev_err_probe(dev, PTR_ERR(priv->refclk), "Failed to request clock\n");
+
+	ret = clk_prepare_enable(priv->refclk);
+	if (ret)
+		return ret;
+
+	ret = clk_set_rate(priv->refclk, 50 * 1000 * 1000);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
@@ -310,6 +334,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	.flags		= PHY_RST_AFTER_CLK_EN,
 
 	.probe		= smsc_phy_probe,
+	.remove		= smsc_phy_remove,
 
 	/* basic functions */
 	.read_status	= lan87xx_read_status,
-- 
2.20.1

