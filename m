Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416851E3F25
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgE0Kew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgE0Kew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:34:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FF6C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lNgRSIIyepK56X5KOUqu/qc+HOtADMT8wPG/QiF43+Y=; b=t2ZUTYyAR9f4j9UkSzjd/l/ui7
        z9hysRbVdRcR5YjtBeS1mnorzILz76BQBVvTh41Kb9mS+TuIayE9c+NPsL2ys7SGtNS/2GDnmDot3
        KbrVpTf0l48Hkms97taLLxNYFQ+v6NDyIIN8TowKMLDYqChy1Zw+ZVOwLgGjx5XZnTEzF21+y1bhl
        DuaNmNP3Hyqeph6/KwOgvd9Y/x0Vh1ewSmvFZndiBKdZw09bq/nxVxHyl8Udc9vrl08iLHGrLJBAB
        h3zZp2XOEKmGn+jF3luvGr0Gxs7aZ5YNws16tHAgx26YS3cjJWDmCvv0jDv+PWfhCD9Wk1dX4/OXj
        he/1D5vw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:38128 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtOI-0001xI-Ro; Wed, 27 May 2020 11:34:31 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtOF-00084V-7R; Wed, 27 May 2020 11:34:27 +0100
In-Reply-To: <20200527103318.GK1551@shell.armlinux.org.uk>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC v2 9/9] net: phy: read MMD ID from all present MMDs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdtOF-00084V-7R@rmk-PC.armlinux.org.uk>
Date:   Wed, 27 May 2020 11:34:27 +0100
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
 drivers/net/phy/phy_device.c | 13 +++++++++++++
 include/linux/phy.h          |  2 +-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c90409b00e94..ebd3306610a4 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -772,6 +772,19 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
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

