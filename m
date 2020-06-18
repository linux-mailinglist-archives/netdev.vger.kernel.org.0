Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F1B1FF39A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbgFRNqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgFRNqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:46:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DD5C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 06:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GiFQJ9YH36TkCMUWPJFGLeZZczOGx1FEnxudIbi89Yo=; b=Ya8xyPdc7heG7HgJafivIXApIF
        SDD3r7e/g3inUrAcTRCi4nuIUQ1r3Gq5c7Eo5NIRixFWXQvSNsInUSdZZ1f776tbEPAvtPaBHFWMZ
        6QvgN9dCg0vY223MYyqqzoomybB7DDEboFsn72i9zYM2OBncOsUnNssv78WJ001ii3bOVmE9gM4i7
        XLJPLgpzVr0t/PWHCVGI1suSKDJJCrvMnPW6keIQjD3xADR+n3k09PV7N1pRdH0AK3ateHBnKfFlh
        JJ7EqknIjkchSnWcEalAXX2KEFrF4zGt6UFufAZBUBn8nOiqU3R0M+SKVsihqLH49vseRQCXliBSK
        RhilfWaQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37660 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jluru-0005Bb-0e; Thu, 18 Jun 2020 14:46:14 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurt-0004l4-PS; Thu, 18 Jun 2020 14:46:13 +0100
In-Reply-To: <20200618134500.GB1551@shell.armlinux.org.uk>
References: <20200618134500.GB1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 9/9] net: phy: read MMD ID from all present MMDs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jlurt-0004l4-PS@rmk-PC.armlinux.org.uk>
Date:   Thu, 18 Jun 2020 14:46:13 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expand the device_ids[] array to allow all MMD IDs to be read rather
than just the first 8 MMDs, but only read the ID if the MDIO_STAT2
register reports that a device really is present here for these new
devices to maintain compatibility with our current behaviour.  Note
that only a limited number of devices have MDIO_STAT2.

88X3310 PHY vendor MMDs do are marked as present in the
devices_in_package, but do not contain IEE 802.3 compatible register
sets in their lower space.  This avoids reading incorrect values as MMD
identifiers.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 13 +++++++++++++
 include/linux/phy.h          |  2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c1f81c4d0bb3..29ef4456ac25 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -774,6 +774,19 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 		if (!(devs_in_pkg & (1 << i)))
 			continue;
 
+		if (i == MDIO_MMD_VEND1 || i == MDIO_MMD_VEND2) {
+			/* Probe the "Device Present" bits for the vendor MMDs
+			 * to ignore these if they do not contain IEEE 802.3
+			 * registers.
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
index 19d9e040ad84..9248dd2ce4ca 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -399,7 +399,7 @@ enum phy_state {
 struct phy_c45_device_ids {
 	u32 devices_in_package;
 	u32 mmds_present;
-	u32 device_ids[8];
+	u32 device_ids[MDIO_MMD_NUM];
 };
 
 struct macsec_context;
-- 
2.20.1

