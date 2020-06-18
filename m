Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98791FF391
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbgFRNpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730116AbgFRNpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:45:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632E8C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 06:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WTru7edNn8MCB5Scv+/luMphYcFkpQo0NPRSa81kWu0=; b=gVVVBCDnWtT/dMtmaFZg4gbUBX
        0AxF1h5dQT+sxXzSgmntLcX/97dTBKISoGP2EBiL0AvT7mYKOdFBhpea934rS0pPQBMRTXnvhDHRT
        0dwrq9JXJ/MA1mK1K6zLsadUxr4Ud7wFC+NnGsU8jM/KzLaX8ik4oNOqslL2qtDrjgSBvGSmtfSQW
        QBSomf0QlwTk+BgyAFcqczqpZQ9MyoweIMgseXtguXhkU6oN0n6Nw0l5zN/i0uO/Q7F4LbRIQh43a
        dCR2roiioeawrALR1lIA1qQM6YbWuu6QA+6NAJXxzq7LProlEBmIEQDHj7U0k4D3/uvq5pMDIO/S4
        0/vi80CA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37642 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurE-0005AA-UW; Thu, 18 Jun 2020 14:45:33 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurE-0004jN-N6; Thu, 18 Jun 2020 14:45:32 +0100
In-Reply-To: <20200618134500.GB1551@shell.armlinux.org.uk>
References: <20200618134500.GB1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/9] net: phy: clean up cortina workaround
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jlurE-0004jN-N6@rmk-PC.armlinux.org.uk>
Date:   Thu, 18 Jun 2020 14:45:32 +0100
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
index 04946de74fa0..c71dc2624c4b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -720,23 +720,21 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
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

