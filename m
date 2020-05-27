Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5A41E3F19
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgE0KeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbgE0KeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:34:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDF6C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Qj960EW6vsWEWVVOihJZ3HMynH5xq3SRbZVRZ10Sm4Y=; b=kgDsJijm+HvkApXjWVC+8OeM/K
        QjUPDrprQaSyBSou+X1OFs2KmjPkgyrXAVpqiXGjtloEyeo4Eqm/bJOxPlwZjb7rztziZuePCzWmS
        S7AavYphangXehsCqoq3+1BGS4U6vlBAmM69BZFJ3tZTWOgUQzbEGuMtBV0mUAtnEz5mMfLVRxdvV
        YeVGWdwYnMfkCHySbWG0AZWxFjCEEKg+VB3z/BcE7L9X26EyphyD9BWVj0BP0Wiyy5CTdJEM9hpAB
        JCM/L6/qNzxBF0a+nvL2kd6AQYTFZO4UOYAcEv5G+D/Cjy4ybYY9iUTGs6YmvNC4SIkm36wPEMjtB
        gh9/iRpg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38084 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNb-0001wN-2e; Wed, 27 May 2020 11:33:47 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNa-00083D-B7; Wed, 27 May 2020 11:33:46 +0100
In-Reply-To: <20200527103318.GK1551@shell.armlinux.org.uk>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC v2 1/9] net: phy: clean up cortina workaround
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdtNa-00083D-B7@rmk-PC.armlinux.org.uk>
Date:   Wed, 27 May 2020 11:33:46 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the Cortina PHY workaround out of the "devices in package" loop;
it doesn't need to be in there as the control flow will terminate the
loop once we enter the workaround irrespective of the workaround's
outcome. The workaround is triggered by the ID being mostly 1's, which
will in any case terminate the loop.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index d14c4ba24a90..e04284c4ebf8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -718,23 +718,21 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
 		if (phy_reg < 0)
 			return -EIO;
+	}
+
+	if ((*devs & 0x1fffffff) == 0x1fffffff) {
+		/* If mostly Fs, there is no device there, then let's probe
+		 * MMD 0, as some 10G PHYs have zero Devices In package,
+		 * e.g. Cortina CS4315/CS4340 PHY.
+		 */
+		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, 0, devs);
+		if (phy_reg < 0)
+			return -EIO;
 
+		/* no device there, let's get out of here */
 		if ((*devs & 0x1fffffff) == 0x1fffffff) {
-			/*  If mostly Fs, there is no device there,
-			 *  then let's continue to probe more, as some
-			 *  10G PHYs have zero Devices In package,
-			 *  e.g. Cortina CS4315/CS4340 PHY.
-			 */
-			phy_reg = get_phy_c45_devs_in_pkg(bus, addr, 0, devs);
-			if (phy_reg < 0)
-				return -EIO;
-			/* no device there, let's get out of here */
-			if ((*devs & 0x1fffffff) == 0x1fffffff) {
-				*phy_id = 0xffffffff;
-				return 0;
-			} else {
-				break;
-			}
+			*phy_id = 0xffffffff;
+			return 0;
 		}
 	}
 
-- 
2.20.1

