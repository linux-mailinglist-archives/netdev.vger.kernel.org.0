Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FFA192541
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgCYKRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:17:48 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33983 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgCYKRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 06:17:48 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48nPFP3VPpz1rt4C;
        Wed, 25 Mar 2020 11:17:45 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48nPFP2dbCz1r0cT;
        Wed, 25 Mar 2020 11:17:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id EVWG01mQ1PSP; Wed, 25 Mar 2020 11:17:43 +0100 (CET)
X-Auth-Info: mEW+8yWUKx3wQVMIV02stZex5Cvuc/wh4CTSer8hAPM=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 25 Mar 2020 11:17:43 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     o.rempel@pengutronix.de, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: [RFC][PATCH 2/2] net: phy: tja11xx: Add BroadRReach Master/Slave support into TJA11xx PHY driver
Date:   Wed, 25 Mar 2020 11:17:36 +0100
Message-Id: <20200325101736.2100-2-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325101736.2100-1-marex@denx.de>
References: <20200325101736.2100-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PHY tunable callbacks to allow configuring BroadRReach
Master/Slave mode.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: linux-hwmon@vger.kernel.org
---
 drivers/net/phy/nxp-tja11xx.c | 58 +++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index f1aeef449c33..78f6594a6acc 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -26,6 +26,7 @@
 #define MII_ECTRL_WAKE_REQUEST		BIT(0)
 
 #define MII_CFG1			18
+#define MII_CFG1_MASTER_SLAVE		BIT(15)
 #define MII_CFG1_AUTO_OP		BIT(14)
 #define MII_CFG1_SLEEP_CONFIRM		BIT(6)
 #define MII_CFG1_LED_MODE_MASK		GENMASK(5, 4)
@@ -115,6 +116,11 @@ static int tja11xx_enable_link_control(struct phy_device *phydev)
 	return phy_set_bits(phydev, MII_ECTRL, MII_ECTRL_LINK_CONTROL);
 }
 
+static int tja11xx_disable_link_control(struct phy_device *phydev)
+{
+	return phy_clear_bits(phydev, MII_ECTRL, MII_ECTRL_LINK_CONTROL);
+}
+
 static int tja11xx_wakeup(struct phy_device *phydev)
 {
 	int ret;
@@ -299,6 +305,52 @@ static void tja11xx_get_stats(struct phy_device *phydev,
 	}
 }
 
+static int tja11xx_get_tunable(struct phy_device *phydev,
+			       struct ethtool_tunable *tuna, void *data)
+{
+	u8 *mode = (u8 *)data;
+	int ret;
+
+	switch (tuna->id) {
+	case ETHTOOL_PHY_BRR_MODE:
+		ret = phy_read(phydev, MII_CFG1);
+		if (ret < 0)
+			return ret;
+		*mode = !!(ret & MII_CFG1_MASTER_SLAVE);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int tja11xx_set_tunable(struct phy_device *phydev,
+			       struct ethtool_tunable *tuna, const void *data)
+{
+	u8 mode = *(u8 *)data;
+	int ret;
+
+	switch (tuna->id) {
+	case ETHTOOL_PHY_BRR_MODE:
+		ret = tja11xx_disable_link_control(phydev);
+		if (ret)
+			return ret;
+
+		ret = phy_modify(phydev, MII_CFG1, MII_CFG1_MASTER_SLAVE,
+				 mode ? MII_CFG1_MASTER_SLAVE : 0);
+		if (ret)
+			return ret;
+
+		ret = tja11xx_enable_link_control(phydev);
+		if (ret)
+			return ret;
+
+		/* TJA1100 needs this to bring the link back up. */
+		return genphy_soft_reset(phydev);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int tja11xx_hwmon_read(struct device *dev,
 			      enum hwmon_sensor_types type,
 			      u32 attr, int channel, long *value)
@@ -425,6 +477,9 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_sset_count = tja11xx_get_sset_count,
 		.get_strings	= tja11xx_get_strings,
 		.get_stats	= tja11xx_get_stats,
+		/* Tunables */
+		.get_tunable	= tja11xx_get_tunable,
+		.set_tunable	= tja11xx_set_tunable,
 	}, {
 		PHY_ID_MATCH_MODEL(PHY_ID_TJA1101),
 		.name		= "NXP TJA1101",
@@ -444,6 +499,9 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_sset_count = tja11xx_get_sset_count,
 		.get_strings	= tja11xx_get_strings,
 		.get_stats	= tja11xx_get_stats,
+		/* Tunables */
+		.get_tunable	= tja11xx_get_tunable,
+		.set_tunable	= tja11xx_set_tunable,
 	}
 };
 
-- 
2.25.1

