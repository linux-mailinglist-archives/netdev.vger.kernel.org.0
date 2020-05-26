Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6863D1E241F
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgEZObs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgEZObs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:31:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4413DC03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 07:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1gH1WZWZxUokHt0RH0Mk65gglLQt6zdT5u39gAIEgYI=; b=iSbKLK65uPhHjXpqj0veDVUqDo
        FuHV8PklLvg5jjwTK7PzutYrVT/HKq5f3FqRQdOYmxUkQQPKQsAhyGhHxw+2J2EFDdqhPI68xHDJ0
        UFnfafUTmkJRV3LoIWNIUq2j5GPfj6Zd2nG3c667GmrXIyH2G5aLk4A88/ivTnz4M+MwFNsR7NBs7
        6QdLfvU15OQDd75zZ/bo7lzQhkdZmf2TR4aXL2nw96lYzcjiXKQ/KGObHkkarRLuUR9wj88bfAN35
        aAGLp9DH/polYWK5JUXW3NsIpCzzzm1doqfJidyCTIgVB3zXkC7o0d8Mt5pmrWJ64IKPb40gnPx8i
        WjcNgvZA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55330 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdac1-00080r-2A; Tue, 26 May 2020 15:31:25 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdabx-0005sh-T7; Tue, 26 May 2020 15:31:21 +0100
In-Reply-To: <20200526142948.GY1551@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC 5/7] net: phy: set devices_in_package only after
 validation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdabx-0005sh-T7@rmk-PC.armlinux.org.uk>
Date:   Tue, 26 May 2020 15:31:21 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only set the devices_in_package to a non-zero value if we find a valid
value for this field, so we avoid leaving it set to e.g. 0x1fffffff.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index fa9164ac0f3d..a483d79cfc87 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -730,13 +730,13 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
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
 		if (i >= 8) {
 			/* Only probe for the devices-in-package if there
 			 * is a PHY reporting as present here; this avoids
@@ -750,22 +750,22 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
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
-		if ((*devs & 0x1fffffff) == 0x1fffffff) {
+		if ((devs_in_pkg & 0x1fffffff) == 0x1fffffff) {
 			*phy_id = 0xffffffff;
 			return 0;
 		}
@@ -773,7 +773,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 
 	/* Now probe Device Identifiers for each device present. */
 	for (i = 1; i < num_ids; i++) {
-		if (!(c45_ids->devices_in_package & (1 << i)))
+		if (!(devs_in_pkg & (1 << i)))
 			continue;
 
 		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID1);
@@ -786,6 +786,9 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 			return -EIO;
 		c45_ids->device_ids[i] |= phy_reg;
 	}
+
+	c45_ids->devices_in_package = devs_in_pkg;
+
 	*phy_id = 0;
 	return 0;
 }
-- 
2.20.1

