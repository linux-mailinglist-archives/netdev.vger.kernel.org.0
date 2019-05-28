Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD58B2CF5E
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfE1TYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:24:02 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:34641 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfE1TYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:24:02 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 45D3g26qMPz1rZJ4;
        Tue, 28 May 2019 21:23:58 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 45D3g26083z1qqkZ;
        Tue, 28 May 2019 21:23:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 8mZ_js3Y9rox; Tue, 28 May 2019 21:23:56 +0200 (CEST)
X-Auth-Info: DlH0NurDGI8SzNeUy8ZE7mDMC4Enu71knP7qqY9Y3VI=
Received: from kurokawa.lan (ip-86-49-110-70.net.upcbroadband.cz [86.49.110.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 28 May 2019 21:23:56 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: [PATCH V2] net: phy: tja11xx: Add IRQ support to the driver
Date:   Tue, 28 May 2019 21:23:24 +0200
Message-Id: <20190528192324.28862-1-marex@denx.de>
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
V2: - Define each bit of the MII_INTEN register and a mask
    - Drop IRQ acking from tja11xx_config_intr()
---
 drivers/net/phy/nxp-tja11xx.c | 48 +++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index b705d0bd798b..b41af609607d 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -40,6 +40,29 @@
 #define MII_INTSRC_TEMP_ERR		BIT(1)
 #define MII_INTSRC_UV_ERR		BIT(3)
 
+#define MII_INTEN			22
+#define MII_INTEN_PWON_EN		BIT(15)
+#define MII_INTEN_WAKEUP_EN		BIT(14)
+#define MII_INTEN_PHY_INIT_FAIL_EN	BIT(11)
+#define MII_INTEN_LINK_STATUS_FAIL_EN	BIT(10)
+#define MII_INTEN_LINK_STATUS_UP_EN	BIT(9)
+#define MII_INTEN_SYM_ERR_EN		BIT(8)
+#define MII_INTEN_TRAINING_FAILED_EN	BIT(7)
+#define MII_INTEN_SQI_WARNING_EN	BIT(6)
+#define MII_INTEN_CONTROL_ERR_EN	BIT(5)
+#define MII_INTEN_UV_ERR_EN		BIT(3)
+#define MII_INTEN_UV_RECOVERY_EN	BIT(2)
+#define MII_INTEN_TEMP_ERR_EN		BIT(1)
+#define MII_INTEN_SLEEP_ABORT_EN	BIT(0)
+#define MII_INTEN_MASK							\
+	(MII_INTEN_PWON_EN | MII_INTEN_WAKEUP_EN |			\
+	MII_INTEN_PHY_INIT_FAIL_EN | MII_INTEN_LINK_STATUS_FAIL_EN |	\
+	MII_INTEN_LINK_STATUS_UP_EN | MII_INTEN_SYM_ERR_EN |		\
+	MII_INTEN_TRAINING_FAILED_EN | MII_INTEN_SQI_WARNING_EN |	\
+	MII_INTEN_CONTROL_ERR_EN | MII_INTEN_UV_ERR_EN |		\
+	MII_INTEN_UV_RECOVERY_EN | MII_INTEN_TEMP_ERR_EN |		\
+	MII_INTEN_SLEEP_ABORT_EN)
+
 #define MII_COMMSTAT			23
 #define MII_COMMSTAT_LINK_UP		BIT(15)
 
@@ -239,6 +262,25 @@ static int tja11xx_read_status(struct phy_device *phydev)
 	return 0;
 }
 
+static int tja11xx_config_intr(struct phy_device *phydev)
+{
+	int ret;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		ret = phy_write(phydev, MII_INTEN, MII_INTEN_MASK);
+	else
+		ret = phy_write(phydev, MII_INTEN, 0);
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
@@ -366,6 +408,9 @@ static struct phy_driver tja11xx_driver[] = {
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.set_loopback   = genphy_loopback,
+		/* IRQ related */
+		.config_intr	= tja11xx_config_intr,
+		.ack_interrupt	= tja11xx_ack_interrupt,
 		/* Statistics */
 		.get_sset_count = tja11xx_get_sset_count,
 		.get_strings	= tja11xx_get_strings,
@@ -381,6 +426,9 @@ static struct phy_driver tja11xx_driver[] = {
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

