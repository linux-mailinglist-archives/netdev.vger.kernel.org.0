Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297E64E5874
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343712AbiCWSgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240076AbiCWSgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:36:02 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DF371EC6;
        Wed, 23 Mar 2022 11:34:31 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D640E223EF;
        Wed, 23 Mar 2022 19:34:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648060470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHCZJ6LDhJPWyNs1i/kh4KtN0UeNoQ/8cRyWcxS+ogQ=;
        b=dFlsyxAo8dcPa20FXsTjsnW6J2a7KECJKzXWhOAegSqtf/Tk0SiAJ2oMQvurANaz3FdvbF
        qYTG7UF9l8ILkDzyVM/kIkxXa0arjplxSHT79WCSfrUajgRhaFW+o2OVuOOWK3MuwGLYcy
        J3hVoODSg3Ct4zqcPPCRSeHVTqikW1w=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next 2/5] net: phy: support indirect c45 access in get_phy_c45_ids()
Date:   Wed, 23 Mar 2022 19:34:16 +0100
Message-Id: <20220323183419.2278676-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220323183419.2278676-1-michael@walle.cc>
References: <20220323183419.2278676-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some PHYs, namely the Maxlinear GPY215, whose driver is
explicitly supporting C45-over-C22 access. At least that was the
intention. In practice, it cannot work because get_phy_c45_ids()
will always issue c45 register accesses.

There is another issue at hand: the Microchip LAN8814, which is
a c22 only quad PHY, has issues with c45 accesses on the same bus
and its address decoder will find a match in the middle of another
c45 transaction. This will lead to spurious reads and writes. The
reads will corrupt the c45 in flight. The write will lead to random
writes to the LAN8814 registers. As a workaround for PHYs which
support C45-over-C22 register accesses, we can make the MDIO bus
c22-only.

For both reasons, extend the register accesses in get_phy_c45_ids()
to allow indirect accesses, indicated by the bus->probe_capabilities
bits. The probe_capabilites can then be degraded by a device tree
property, for example. Or it will just work when the MDIO driver
is c22-only and set the capabilities accordingly.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/phy_device.c | 46 ++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8406ac739def..c766f5bb421a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -649,6 +649,42 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 }
 EXPORT_SYMBOL(phy_device_create);
 
+static int mdiobus_probe_mmd_read(struct mii_bus *bus, int prtad, int devad,
+				  u16 regnum)
+{
+	int ret;
+
+	/* For backwards compatibility, treat MDIOBUS_NO_CAP as c45 capable */
+	if (bus->probe_capabilities == MDIOBUS_NO_CAP ||
+	    bus->probe_capabilities >= MDIOBUS_C45)
+		return mdiobus_c45_read(bus, prtad, devad, regnum);
+
+	mutex_lock(&bus->mdio_lock);
+
+	/* Write the desired MMD Devad */
+	ret = __mdiobus_write(bus, prtad, MII_MMD_CTRL, devad);
+	if (ret)
+		goto out;
+
+	/* Write the desired MMD register address */
+	ret = __mdiobus_write(bus, prtad, MII_MMD_DATA, regnum);
+	if (ret)
+		goto out;
+
+	/* Select the Function : DATA with no post increment */
+	ret = __mdiobus_write(bus, prtad, MII_MMD_CTRL,
+			      devad | MII_MMD_CTRL_NOINCR);
+	if (ret)
+		goto out;
+
+	ret = __mdiobus_read(bus, prtad, MII_MMD_DATA);
+
+out:
+	mutex_unlock(&bus->mdio_lock);
+
+	return ret;
+}
+
 /* phy_c45_probe_present - checks to see if a MMD is present in the package
  * @bus: the target MII bus
  * @prtad: PHY package address on the MII bus
@@ -664,7 +700,7 @@ static int phy_c45_probe_present(struct mii_bus *bus, int prtad, int devad)
 {
 	int stat2;
 
-	stat2 = mdiobus_c45_read(bus, prtad, devad, MDIO_STAT2);
+	stat2 = mdiobus_probe_mmd_read(bus, prtad, devad, MDIO_STAT2);
 	if (stat2 < 0)
 		return stat2;
 
@@ -687,12 +723,12 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
 {
 	int phy_reg;
 
-	phy_reg = mdiobus_c45_read(bus, addr, dev_addr, MDIO_DEVS2);
+	phy_reg = mdiobus_probe_mmd_read(bus, addr, dev_addr, MDIO_DEVS2);
 	if (phy_reg < 0)
 		return -EIO;
 	*devices_in_package = phy_reg << 16;
 
-	phy_reg = mdiobus_c45_read(bus, addr, dev_addr, MDIO_DEVS1);
+	phy_reg = mdiobus_probe_mmd_read(bus, addr, dev_addr, MDIO_DEVS1);
 	if (phy_reg < 0)
 		return -EIO;
 	*devices_in_package |= phy_reg;
@@ -776,12 +812,12 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 				continue;
 		}
 
-		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID1);
+		phy_reg = mdiobus_probe_mmd_read(bus, addr, i, MII_PHYSID1);
 		if (phy_reg < 0)
 			return -EIO;
 		c45_ids->device_ids[i] = phy_reg << 16;
 
-		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID2);
+		phy_reg = mdiobus_probe_mmd_read(bus, addr, i, MII_PHYSID2);
 		if (phy_reg < 0)
 			return -EIO;
 		c45_ids->device_ids[i] |= phy_reg;
-- 
2.30.2

