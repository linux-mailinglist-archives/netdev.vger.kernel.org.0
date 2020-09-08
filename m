Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EDE2611ED
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 15:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgIHNPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 09:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729252AbgIHLZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:25:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4072EC061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 04:25:33 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFbka-0006xN-CE; Tue, 08 Sep 2020 13:25:24 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kFbkW-0001jX-Tp; Tue, 08 Sep 2020 13:25:20 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: [PATCH v2 4/5] net: phy: smsc: LAN8710/20: add phy refclk in support
Date:   Tue,  8 Sep 2020 13:25:19 +0200
Message-Id: <20200908112520.3439-5-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200908112520.3439-1-m.felsch@pengutronix.de>
References: <20200908112520.3439-1-m.felsch@pengutronix.de>
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
rely on 'magic' host clock setup. Commit [1] tried to address this by
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
v2:
- use non-devres clk_* functions and instead use the remove() function
- propagate errors upstream if the optional clk can't be retrieved.
- make use if dev_err_probe()
- adapt commit subject to cover that only the LAN8710/20 devices are
  changed

 drivers/net/phy/smsc.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 79574fcbd880..7a1a7e13db85 100644
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

