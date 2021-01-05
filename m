Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77622EAFDB
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 17:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbhAEQQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 11:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbhAEQQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 11:16:45 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F231FC061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 08:15:49 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D9HfW57h1z1rwb1;
        Tue,  5 Jan 2021 17:15:47 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D9HfW3Gcqz1sFWK;
        Tue,  5 Jan 2021 17:15:47 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id woXnmTTDesEf; Tue,  5 Jan 2021 17:15:46 +0100 (CET)
X-Auth-Info: AaQSsVxDElxEij0Tpy4DvBAZ7TNGcUiTA5L94mVnlv4=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  5 Jan 2021 17:15:46 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] [RFC] net: phy: smsc: Add magnetics VIO regulator support
Date:   Tue,  5 Jan 2021 17:15:33 +0100
Message-Id: <20210105161533.250865-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for controlling regulator powering the magnetics. In case
the interface is down, it is possible to save considerable power by
turning the regulator supplying the magnetics off.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 33372756a451..edc2bd7d8100 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -20,6 +20,9 @@
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/netdevice.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/consumer.h>
 #include <linux/smscphy.h>
 
 /* Vendor-specific PHY Definitions */
@@ -46,6 +49,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 struct smsc_phy_priv {
 	bool energy_enable;
 	struct clk *refclk;
+	struct regulator *vddio;
 };
 
 static int smsc_phy_ack_interrupt(struct phy_device *phydev)
@@ -288,6 +292,20 @@ static void smsc_get_stats(struct phy_device *phydev,
 		data[i] = smsc_get_stat(phydev, i);
 }
 
+static void smsc_link_change_notify(struct phy_device *phydev)
+{
+	struct smsc_phy_priv *priv = phydev->priv;
+
+	if (!priv->vddio)
+		return;
+
+	if (phydev->state == PHY_HALTED)
+		regulator_disable(priv->vddio);
+
+	if (phydev->state == PHY_NOLINK)
+		regulator_enable(priv->vddio);
+}
+
 static void smsc_phy_remove(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
@@ -309,6 +327,10 @@ static int smsc_phy_probe(struct phy_device *phydev)
 
 	priv->energy_enable = true;
 
+	priv->vddio = devm_regulator_get_optional(&phydev->mdio.dev, "vddio");
+	if (IS_ERR(priv->vddio))
+		return PTR_ERR(priv->vddio);
+
 	if (of_property_read_bool(of_node, "smsc,disable-energy-detect"))
 		priv->energy_enable = false;
 
@@ -432,7 +454,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	.name		= "SMSC LAN8710/LAN8720",
 
 	/* PHY_BASIC_FEATURES */
-
+	.link_change_notify = smsc_link_change_notify,
 	.probe		= smsc_phy_probe,
 	.remove		= smsc_phy_remove,
 
-- 
2.29.2

