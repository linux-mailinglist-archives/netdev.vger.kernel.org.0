Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 193F3127169
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 00:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfLSXZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 18:25:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41400 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLSXZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 18:25:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UWpx7f81KWPKHgTgOSJMYWKG+m9yTTNuFdraMicZURI=; b=buPTY0Ay0zM7RhhqnLsV6lQd9C
        3W+CYCdsvPIBgaNubIFUIG21nVcZPa/whpLNxJyxbDqQ4lH0EELnJDwSs8GkRNaHGjxVaHyhlE1sc
        7nIqPPX99owxv0ffxqZLR2KGAoPDUtZD1hrfBsDzdYLbxvREtdEOiyJVk3JFL5luDobuFNo0zt5mV
        CzaSrlfP2gSt8nlG2Q8dlngmu515jHriSsUT/M84QL1lSEKypcQ49amwKYe8xjuvdTtyAhEgbrrOf
        bVWUkga7ZY/GxBBtsMx4COmPls61vaz8+Z23IzNX0j+27+Hi1cNhPfXeWQj9l3RWzznEt+3lOhw9/
        CGHJSoKg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:35138 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ii5A6-0005MI-00; Thu, 19 Dec 2019 23:24:54 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ii5A4-0003Ni-Vs; Thu, 19 Dec 2019 23:24:53 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net v2] net: phy: ensure that phy IDs are correctly typed
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ii5A4-0003Ni-Vs@rmk-PC.armlinux.org.uk>
Date:   Thu, 19 Dec 2019 23:24:52 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY IDs are 32-bit unsigned quantities. Ensure that they are always
treated as such, and not passed around as "int"s.

Fixes: 13d0ab6750b2 ("net: phy: check return code when requesting PHY driver module")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 8 ++++----
 include/linux/phy.h          | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0887ed2bb050..b13c52873ef5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -553,7 +553,7 @@ static const struct device_type mdio_bus_phy_type = {
 	.pm = MDIO_BUS_PHY_PM_OPS,
 };
 
-static int phy_request_driver_module(struct phy_device *dev, int phy_id)
+static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
 {
 	int ret;
 
@@ -565,15 +565,15 @@ static int phy_request_driver_module(struct phy_device *dev, int phy_id)
 	 * then modprobe isn't available.
 	 */
 	if (IS_ENABLED(CONFIG_MODULES) && ret < 0 && ret != -ENOENT) {
-		phydev_err(dev, "error %d loading PHY driver module for ID 0x%08x\n",
-			   ret, phy_id);
+		phydev_err(dev, "error %d loading PHY driver module for ID 0x%08lx\n",
+			   ret, (unsigned long)phy_id);
 		return ret;
 	}
 
 	return 0;
 }
 
-struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
+struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids)
 {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5032d453ac66..dd4a91f1feaa 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1000,7 +1000,7 @@ int phy_modify_paged_changed(struct phy_device *phydev, int page, u32 regnum,
 int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
 		     u16 mask, u16 set);
 
-struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
+struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
-- 
2.20.1

