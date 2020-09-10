Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC5F26457A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 13:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbgIJLtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 07:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgIJLng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 07:43:36 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858A8C0617A9
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 04:43:36 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d16so771048pll.13
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 04:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=rcUmOVI7cytY41sx7VNGdoUb2/C+8X2uCYR3BlDpvHs=;
        b=RmxUGU3khn+dW/MHr/uRcF2PX0nU9OURilWyYFtfhbD3peGmtGADORPk/LjGDb5Ndp
         Wbi3e0/nnd7YZIEW+3URUhawzElRZktf4unh56a5L2hlMnwczPEI1noCG3RwcnjEJzBl
         4LFnDDEh5YFM6/+Xj+wa/6VabmwXWZGKIoGfATOLxwnG3T0CinNESlvxoExi909JPH/Z
         9LenjwRIuoPb68UmkgtD0dengqB3O+baxIXBkNYhi5gf/cChomE0FktbM9qqwcIWacoh
         T+9o7+UOPBNafqpANZ4JYVnewxW9+aFyatUbaldf60Iu09v5vT0QTMqWeCh8dSGvmO9j
         CUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rcUmOVI7cytY41sx7VNGdoUb2/C+8X2uCYR3BlDpvHs=;
        b=e8bDvalsjKyBM1+pzR886A3CHa68pKzKm3yRDYH6XvzE9y6j54Zu8p6V6jxaFtZ0UN
         yf3sRlN4fQVMQaDXydxqguYBRFxlQWvZAPE0zYd6zlqoDlXOZJCx9xPHupsdYk0StG35
         Bekqej2SUgStEFIUqG5itCggh91MxNuIPdzuMcfYAT8Lo7dIUYRGYwg94Wwbyzfruco9
         ZjlntIrkxtf1USxQai7ZPimaR5O6XBx02FqxU1IxLiJgq4ftlL3LfrGuIil2+C3NSz04
         lV9OnNClLOcVop3l/Wbz1JJA79IESBLUernIaD4iwmWPgoGm9PtaaL0AMiA4NUBPk8Yp
         1dng==
X-Gm-Message-State: AOAM531hMZjc1ST8HL9vHYlzyahBYYChYtSpOsZscQmSVTXqFj6S+S75
        fddFIaO1uvCJczmpk7E7P/nMNg==
X-Google-Smtp-Source: ABdhPJzhqPA/TNOY2ZTU0/12ESV6i6f9gpw9myLb4EGpvlOO5ps6wvK3XL2f3LpZLdGNu2GGt0vqgQ==
X-Received: by 2002:a17:90b:c90:: with SMTP id o16mr5057651pjz.86.1599738216000;
        Thu, 10 Sep 2020 04:43:36 -0700 (PDT)
Received: from prashant-PC.puresoft.int ([125.63.92.170])
        by smtp.gmail.com with ESMTPSA id y5sm5535225pge.62.2020.09.10.04.43.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 04:43:35 -0700 (PDT)
From:   Vikas Singh <vikas.singh@puresoftware.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Cc:     calvin.johnson@oss.nxp.com, kuldip.dwivedi@puresoftware.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: [PATCH v2] net: Phy: Add PHY lookup support on MDIO bus in case of ACPI probe
Date:   Thu, 10 Sep 2020 17:13:03 +0530
Message-Id: <1599738183-26957-1-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function referred to (of_mdiobus_link_mdiodev()) is only built when
CONFIG_OF_MDIO is enabled, which is again, a DT specific thing, and would
not work in case of ACPI.
Given that it is a static function so renamed of_mdiobus_link_mdiodev()
as mdiobus_link_mdiodev() and did necessary changes, finally moved it out
of the #ifdef(CONFIG_OF_MDIO) therefore make it work for both DT & ACPI.

Signed-off-by: Vikas Singh <vikas.singh@puresoftware.com>
---

Notes:
    - Add generic handling for "fwnode" and "of_node".
    - Remove duplicate loops.

 drivers/net/phy/mdio_bus.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 46b3370..b0faa95 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -434,6 +434,7 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_bus_np)
 	return d ? to_mii_bus(d) : NULL;
 }
 EXPORT_SYMBOL(of_mdio_find_bus);
+#endif
 
 /* Walk the list of subnodes of a mdio bus and look for a node that
  * matches the mdio device's address with its 'reg' property. If
@@ -441,35 +442,37 @@ EXPORT_SYMBOL(of_mdio_find_bus);
  * auto-probed phy devices to be supplied with information passed in
  * via DT.
  */
-static void of_mdiobus_link_mdiodev(struct mii_bus *bus,
-				    struct mdio_device *mdiodev)
+static void mdiobus_link_mdiodev(struct mii_bus *bus,
+				 struct mdio_device *mdiodev)
 {
 	struct device *dev = &mdiodev->dev;
-	struct device_node *child;
+	struct fwnode_handle *child;
+	int addr;
 
-	if (dev->of_node || !bus->dev.of_node)
+	if (dev->fwnode || !bus->dev.fwnode) {
+		pr_err("PHY fwnode is not available on bus for registration\n");
 		return;
+	}
 
-	for_each_available_child_of_node(bus->dev.of_node, child) {
-		int addr;
+	device_for_each_child_node(&bus->dev, child) {
+		if (!fwnode_device_is_available(child))
+			continue;
 
-		addr = of_mdio_parse_addr(dev, child);
-		if (addr < 0)
+		if (is_of_node(child)) {
+			addr = of_mdio_parse_addr(dev, to_of_node(child));
+			if (addr < 0)
+				continue;
+		} else if (fwnode_property_read_u32(child, "reg", &addr))
 			continue;
 
 		if (addr == mdiodev->addr) {
-			dev->of_node = child;
-			dev->fwnode = of_fwnode_handle(child);
-			return;
+			dev->of_node = to_of_node(child);
+			dev->fwnode = child;
+			break;
 		}
 	}
+	return;
 }
-#else /* !IS_ENABLED(CONFIG_OF_MDIO) */
-static inline void of_mdiobus_link_mdiodev(struct mii_bus *mdio,
-					   struct mdio_device *mdiodev)
-{
-}
-#endif
 
 /**
  * mdiobus_create_device_from_board_info - create a full MDIO device given
@@ -688,10 +691,10 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 		return phydev;
 
 	/*
-	 * For DT, see if the auto-probed phy has a correspoding child
-	 * in the bus node, and set the of_node pointer in this case.
+	 * See if the auto-probed phy has a corresponding child
+	 * in the bus node, and set the of_node & fwnode pointers.
 	 */
-	of_mdiobus_link_mdiodev(bus, &phydev->mdio);
+	mdiobus_link_mdiodev(bus, &phydev->mdio);
 
 	err = phy_device_register(phydev);
 	if (err) {
-- 
2.7.4

