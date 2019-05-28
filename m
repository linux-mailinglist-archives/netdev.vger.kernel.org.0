Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CD02CE53
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfE1SQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:16:50 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:53157 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbfE1SQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:16:50 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45D29W6Lqfz1rYjs;
        Tue, 28 May 2019 20:16:47 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45D29W66S4z1qqkH;
        Tue, 28 May 2019 20:16:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id rOi1F258y-BX; Tue, 28 May 2019 20:16:46 +0200 (CEST)
X-Auth-Info: r1INEhT01ndBmm6Gh2kFkm12Wkkgu9fPcuguq6b9K30=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 28 May 2019 20:16:46 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: [PATCH] net: phy: tja11xx: Add IRQ support to the driver
Date:   Tue, 28 May 2019 20:16:16 +0200
Message-Id: <20190528181616.2019-1-marex@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for handling the TJA11xx PHY IRQ signal.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: linux-hwmon@vger.kernel.org
---
 drivers/net/phy/nxp-tja11xx.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index b705d0bd798b..0be9fe9a9604 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -40,6 +40,8 @@
 #define MII_INTSRC_TEMP_ERR		BIT(1)
 #define MII_INTSRC_UV_ERR		BIT(3)
 
+#define MII_INTEN			22
+
 #define MII_COMMSTAT			23
 #define MII_COMMSTAT_LINK_UP		BIT(15)
 
@@ -239,6 +241,30 @@ static int tja11xx_read_status(struct phy_device *phydev)
 	return 0;
 }
 
+static int tja11xx_config_intr(struct phy_device *phydev)
+{
+	int ret;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		ret = phy_write(phydev, MII_INTEN, 0xcfef);
+	else
+		ret = phy_write(phydev, MII_INTEN, 0);
+
+	if (ret < 0)
+		return ret;
+
+	ret = phy_read(phydev, MII_INTSRC);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int tja11xx_ack_interrupt(struct phy_device *phydev)
+{
+	int ret = phy_read(phydev, MII_INTSRC);
+
+	return ret < 0 ? ret : 0;
+}
+
 static int tja11xx_get_sset_count(struct phy_device *phydev)
 {
 	return ARRAY_SIZE(tja11xx_hw_stats);
@@ -366,6 +392,9 @@ static struct phy_driver tja11xx_driver[] = {
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.set_loopback   = genphy_loopback,
+		/* IRQ related */
+		.config_intr	= tja11xx_config_intr,
+		.ack_interrupt	= tja11xx_ack_interrupt,
 		/* Statistics */
 		.get_sset_count = tja11xx_get_sset_count,
 		.get_strings	= tja11xx_get_strings,
@@ -381,6 +410,9 @@ static struct phy_driver tja11xx_driver[] = {
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.set_loopback   = genphy_loopback,
+		/* IRQ related */
+		.config_intr	= tja11xx_config_intr,
+		.ack_interrupt	= tja11xx_ack_interrupt,
 		/* Statistics */
 		.get_sset_count = tja11xx_get_sset_count,
 		.get_strings	= tja11xx_get_strings,
-- 
2.20.1

