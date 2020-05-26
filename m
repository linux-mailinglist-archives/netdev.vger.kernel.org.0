Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67DE1E2421
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgEZOby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgEZObx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:31:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BE5C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 07:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Z0AHBZDR4nvLc36KYS+OhHGz24Xfwa7dds3SDsndAD0=; b=ixxTkIqtrnDzCnlo7SlK8yBgA+
        89k0lYqrSwWxlswpJCauUrFXAMmDhCi5Xbsw9GO9+PXov1bIOFOVb8uzcdHzWhA0bHHutkUbfjUYH
        zNRF5vZXoCXelqK0tPco+NXYSajwGlw/1o5iaQwQfXqryHegyFvGXF8gPkBVoLFEqoVOrX1wmfoAH
        6WIlMiOszI2diIbIidm/3lXVpR1fwCMDcUvOUdK1eRvnTXcwlVQDerTHAIuK56K1Tsi+Wic6bZ7Eg
        zlWE9VmsxmMoJq0ZhbgDGG4K1fuFMYVT1GSbeXfyMwxyS03zh8as2t/YsiU6BlDwbJLuHLqp8UoYz
        qb6QjONQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42434 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdacA-000814-Ru; Tue, 26 May 2020 15:31:35 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdac8-0005tC-3o; Tue, 26 May 2020 15:31:32 +0100
In-Reply-To: <20200526142948.GY1551@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC 7/7] net: phy: read MMD ID from all present MMDs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdac8-0005tC-3o@rmk-PC.armlinux.org.uk>
Date:   Tue, 26 May 2020 15:31:32 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expand the device_ids[] array to allow all MMD IDs to be read rather
than just the first 8 MMDs, but only read the ID if the MDIO_STAT2
register reports that a device really is present here for these new
devices to maintain compatibility with our current behaviour.

88X3310 PHY vendor MMDs do are marked as present in the
devices_in_package, but do not contain IEE 802.3 compatible register
sets in their lower space.  This avoids reading incorrect values as MMD
identifiers.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 14 ++++++++++++++
 include/linux/phy.h          |  2 +-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1c948bbf4fa0..92742c7be80f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -773,6 +773,20 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 		if (!(devs_in_pkg & (1 << i)))
 			continue;
 
+		if (i >= 8) {
+			/* Only probe the MMD ID for MMDs >= 8 if they report
+			 * that they are present. We have at least one PHY that
+			 * reports MMD presence in devs_in_pkg, but does not
+			 * contain valid IEEE 802.3 ID registers in some MMDs.
+			 */
+			ret = phy_c45_probe_present(bus, addr, i);
+			if (ret < 0)
+				return ret;
+
+			if (!ret)
+				continue;
+		}
+
 		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID1);
 		if (phy_reg < 0)
 			return -EIO;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0d41c710339a..3325dd8fb9ac 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -361,7 +361,7 @@ enum phy_state {
 struct phy_c45_device_ids {
 	u32 devices_in_package;
 	u32 mmds_present;
-	u32 device_ids[8];
+	u32 device_ids[MDIO_MMD_NUM];
 };
 
 struct macsec_context;
-- 
2.20.1

