Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4451E3F22
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbgE0Keq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgE0Kep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:34:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB54C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SJ0wIVLQsQrIAZlf/Qmo4rIqb4AGjRz9X57GWMB+5XY=; b=pDxDw5p7OnHGvC5kP9YYY47DHq
        TXaTxRkgwxplGAQvP3VpRFWVaaiT+HFepNaVXAmqaALQF46yNVZJKBv6/eTRRKjb2eivp3JxIvdP7
        l/8s/1oK05zH8q4ZqCUGmUiOcSqVBH7Xf99KnRk5fmtNC8tFb6KK4RgtEmuNWqM2lrp/zoZKubqsi
        KqQ2KZa9u50vQ+A7OR0hqPqYcPnj2fXdRxfLV7ybEIP2i/9eOVI21mc6cDQ7So7u/gwqSLJ4P65dU
        1Lkv3FhH3ocOUHZns4Yic/dmzx/RMN0yP/z8ruBOpFEzwzR1RShffr5zEZUYtxIBayJZxRA5aVCF4
        d7Q7lPpg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:48042 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtO8-0001x5-8l; Wed, 27 May 2020 11:34:20 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtO5-000849-0b; Wed, 27 May 2020 11:34:17 +0100
In-Reply-To: <20200527103318.GK1551@shell.armlinux.org.uk>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC v2 7/9] net: phy: set devices_in_package only after
 validation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdtO5-000849-0b@rmk-PC.armlinux.org.uk>
Date:   Wed, 27 May 2020 11:34:17 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only set the devices_in_package to a non-zero value if we find a valid
value for this field, so we avoid leaving it set to e.g. 0x1fffffff.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 79f01cfec774..82a223225901 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -730,13 +730,13 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 			   struct phy_c45_device_ids *c45_ids)
 {
 	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
-	u32 *devs = &c45_ids->devices_in_package;
+	u32 devs_in_pkg = 0;
 	int i, ret, phy_reg;
 
 	/* Find first non-zero Devices In package. Device zero is reserved
 	 * for 802.3 c45 complied PHYs, so don't probe it at first.
 	 */
-	for (i = 1; i < MDIO_MMD_NUM && *devs == 0; i++) {
+	for (i = 1; i < MDIO_MMD_NUM && devs_in_pkg == 0; i++) {
 		if (i == MDIO_MMD_VEND1 || i == MDIO_MMD_VEND2) {
 			/* Check that there is a device present at this
 			 * address before reading the devices-in-package
@@ -751,28 +751,28 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 			if (!ret)
 				continue;
 		}
-		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
+		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, &devs_in_pkg);
 		if (phy_reg < 0)
 			return -EIO;
 	}
 
-	if ((*devs & 0x1fffffff) == 0x1fffffff) {
+	if ((devs_in_pkg & 0x1fffffff) == 0x1fffffff) {
 		/* If mostly Fs, there is no device there, then let's probe
 		 * MMD 0, as some 10G PHYs have zero Devices In package,
 		 * e.g. Cortina CS4315/CS4340 PHY.
 		 */
-		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, 0, devs);
+		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, 0, &devs_in_pkg);
 		if (phy_reg < 0)
 			return -EIO;
 
 		/* no device there, let's get out of here */
-		if ((*devs & 0x1fffffff) == 0x1fffffff)
+		if ((devs_in_pkg & 0x1fffffff) == 0x1fffffff)
 			return -ENODEV;
 	}
 
 	/* Now probe Device Identifiers for each device present. */
 	for (i = 1; i < num_ids; i++) {
-		if (!(c45_ids->devices_in_package & (1 << i)))
+		if (!(devs_in_pkg & (1 << i)))
 			continue;
 
 		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID1);
@@ -786,6 +786,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 		c45_ids->device_ids[i] |= phy_reg;
 	}
 
+	c45_ids->devices_in_package = devs_in_pkg;
+
 	return 0;
 }
 
-- 
2.20.1

