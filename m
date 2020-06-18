Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669951FF398
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbgFRNqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgFRNqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:46:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE67DC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 06:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QzRQrOdnhxiJG1ol77C1+vh3e2NLJm2naHErfJ0MsVc=; b=qvgIF6FL/YnSOGexRIXtpc6anl
        YxSqu788C000MWbvT/UDk9jvYHNvKz4N3CbJKHGIfTwk1yBK62AI3EpsczW+edLhl/Lu67FQ84cGc
        p27SIEtrM3+zqcwcHP9lpD7TfTesZdRVVjQaROpzbZNzOe00WbdwCQIQThC51Z4KolNi1O99Ab4sJ
        5ATZhP3wjA+VquPaQLwJEhRW3q2r/DLKlS0hYNoU/Y6o+gyND6kgjADvfP4Crf2Nq4f/miBjMZcAC
        /n4zAdETomI+cMh+3JXkS+I6c0BmufUJeGuDGTObvWgx+Z+35ISZeq8yURm0AS1hOvFj6KiXmmsR5
        s5Xaqc6Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37656 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurj-0005BF-Nw; Thu, 18 Jun 2020 14:46:03 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurj-0004kd-Gl; Thu, 18 Jun 2020 14:46:03 +0100
In-Reply-To: <20200618134500.GB1551@shell.armlinux.org.uk>
References: <20200618134500.GB1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 7/9] net: phy: set devices_in_package only after
 validation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jlurj-0004kd-Gl@rmk-PC.armlinux.org.uk>
Date:   Thu, 18 Jun 2020 14:46:03 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only set the devices_in_package to a non-zero value if we find a valid
value for this field, so we avoid leaving it set to e.g. 0x1fffffff.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8d9af2772853..8e11e3d3a801 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -732,13 +732,13 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
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
@@ -753,28 +753,28 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
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
@@ -788,6 +788,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 		c45_ids->device_ids[i] |= phy_reg;
 	}
 
+	c45_ids->devices_in_package = devs_in_pkg;
+
 	return 0;
 }
 
-- 
2.20.1

