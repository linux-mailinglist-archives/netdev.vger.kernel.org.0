Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29201E3F21
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgE0Kel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgE0Kel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:34:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08270C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HDiufrRuku5UBndrtoT1INr09HBmbmTFPh5/5ZNO/g4=; b=Az0IWTdRNn9RuUhOsHJZNQshC/
        FPapU/EjQP/QhYCEhwWpbZayR6JZualmmbD3PVsLoHyG6LGF4auh/agXIvBiMA2CnU3X2GnWsd0QR
        7V6EakFWgMKlifEc2kNb2JU40BCIMbuNKXV0dDH02QDQO4n84JkgdsgOoe80KoIHnrh3yBh1AaVps
        rAiPHQ5IiMPBRgbD+FsmXU3fsaGeyH8IYM6yjI9G6soN+ObSTZFeSj7T54QW14RBHqWeDhGkWKx7y
        FxHccu/2tDuvyozrZkJMQYKPtBwxAgoTrXBMTYWIcz4355sb6YbVrFm3DoOcxmVuFNWfxqvkVvNSN
        J4BkCf2A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:48040 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtO3-0001wy-QF; Wed, 27 May 2020 11:34:16 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNz-000840-Sk; Wed, 27 May 2020 11:34:11 +0100
In-Reply-To: <20200527103318.GK1551@shell.armlinux.org.uk>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC v2 6/9] net: phy: add support for probing MMDs >= 8 for
 devices-in-package
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdtNz-000840-Sk@rmk-PC.armlinux.org.uk>
Date:   Wed, 27 May 2020 11:34:11 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for probing MMDs above 7 for a valid devices-in-package
specifier, but only probe the vendor MMDs for this if they also report
that there the device is present in status register 2.  This avoids
issues where the MMD is implemented, but does not provide IEEE 802.3
compliant registers (such as the MV88X3310 PHY.)

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 40 ++++++++++++++++++++++++++++++++++--
 include/linux/phy.h          |  2 ++
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index bc20ee01b31d..79f01cfec774 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -659,6 +659,28 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 }
 EXPORT_SYMBOL(phy_device_create);
 
+/* phy_c45_probe_present - checks to see if a MMD is present in the package
+ * @bus: the target MII bus
+ * @prtad: PHY package address on the MII bus
+ * @devad: PHY device (MMD) address
+ *
+ * Read the MDIO_STAT2 register, and check whether a device is responding
+ * at this address.
+ *
+ * Returns: negative error number on bus access error, zero if no device
+ * is responding, or positive if a device is present.
+ */
+static int phy_c45_probe_present(struct mii_bus *bus, int prtad, int devad)
+{
+	int stat2;
+
+	stat2 = mdiobus_c45_read(bus, prtad, devad, MDIO_STAT2);
+	if (stat2 < 0)
+		return stat2;
+
+	return (stat2 & MDIO_STAT2_DEVPRST) == MDIO_STAT2_DEVPRST_VAL;
+}
+
 /* get_phy_c45_devs_in_pkg - reads a MMD's devices in package registers.
  * @bus: the target MII bus
  * @addr: PHY address on the MII bus
@@ -709,12 +731,26 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 {
 	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
 	u32 *devs = &c45_ids->devices_in_package;
-	int i, phy_reg;
+	int i, ret, phy_reg;
 
 	/* Find first non-zero Devices In package. Device zero is reserved
 	 * for 802.3 c45 complied PHYs, so don't probe it at first.
 	 */
-	for (i = 1; i < num_ids && *devs == 0; i++) {
+	for (i = 1; i < MDIO_MMD_NUM && *devs == 0; i++) {
+		if (i == MDIO_MMD_VEND1 || i == MDIO_MMD_VEND2) {
+			/* Check that there is a device present at this
+			 * address before reading the devices-in-package
+			 * register to avoid reading garbage from the PHY.
+			 * Some PHYs (88x3310) vendor space is not IEEE802.3
+			 * compliant.
+			 */
+			ret = phy_c45_probe_present(bus, addr, i);
+			if (ret < 0)
+				return -EIO;
+
+			if (!ret)
+				continue;
+		}
 		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
 		if (phy_reg < 0)
 			return -EIO;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9b7c46cf14d3..41c046545354 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -350,6 +350,8 @@ enum phy_state {
 	PHY_NOLINK,
 };
 
+#define MDIO_MMD_NUM 32
+
 /**
  * struct phy_c45_device_ids - 802.3-c45 Device Identifiers
  * @devices_in_package: Bit vector of devices present.
-- 
2.20.1

