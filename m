Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D4F257AD2
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 15:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgHaNtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 09:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbgHaNsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 09:48:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A5AC061755
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 06:48:53 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kCkAw-0000Lh-Ic; Mon, 31 Aug 2020 15:48:46 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kCkAr-0005HG-4B; Mon, 31 Aug 2020 15:48:41 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 4/5] net: phy: smsc: add phy refclk in support
Date:   Mon, 31 Aug 2020 15:48:35 +0200
Message-Id: <20200831134836.20189-5-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200831134836.20189-1-m.felsch@pengutronix.de>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
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

Add support to specify the clock provider for the phy refclk and don't
rely on 'magic' host clock setup. [1] tried to address this by
introducing a flag and fixing the corresponding host. But this commit
breaks the IRQ support since the irq setup during .config_intr() is
thrown away because the reset comes from the side without respecting the
current phy-state within the phy-state-machine. Furthermore the commit
fixed the problem only for FEC based hosts other hosts acting like the
FEC are not covered.

This commit goes the other way around to address the bug fixed by [1].
Instead of resetting the device from the side every time the refclk gets
(re-)enabled it requests and enables the clock till the device gets
removed. The phy is still rest but now within the phylib and  with
respect to the phy-state-machine.

[1] commit 7f64e5b18ebb ("net: phy: smsc: LAN8710/20: add
    PHY_RST_AFTER_CLK_EN flag")

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/net/phy/smsc.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 79574fcbd880..b98a7845681f 100644
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
@@ -194,11 +196,19 @@ static void smsc_get_stats(struct phy_device *phydev,
 		data[i] = smsc_get_stat(phydev, i);
 }
 
+static void smsc_clk_disable_action(void *data)
+{
+	struct smsc_phy_priv *priv = data;
+
+	clk_disable_unprepare(priv->refclk);
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
@@ -211,6 +221,26 @@ static int smsc_phy_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
+	priv->refclk = devm_clk_get_optional(dev, NULL);
+	if (IS_ERR(priv->refclk)) {
+		if (PTR_ERR(priv->refclk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		/* Clocks are optional all errors should be ignored here */
+		return 0;
+	}
+
+	/* Starting from here errors should not be ignored anymore */
+	ret = clk_set_rate(priv->refclk, 50 * 1000 * 1000);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(priv->refclk);
+	if (ret)
+		return ret;
+
+	devm_add_action_or_reset(dev, smsc_clk_disable_action, priv);
+
 	return 0;
 }
 
-- 
2.20.1

