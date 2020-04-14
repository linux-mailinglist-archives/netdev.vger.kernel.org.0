Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D371A8B81
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391643AbgDNTvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505218AbgDNTtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:49:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68D1C061A10
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 12:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dc91mFvP04DL01uUajoQ5C/brMW5lgGgAeNxyMmxchY=; b=tT/0Uff06lpynsNlCWRFx6EfeI
        LFZhPdzDi51leNeG2zj21/hBP6sUoOo+hCcGa6T8tDCBBY25q/Yl0qaQNRb63KAZmx3n7MOh94niN
        guyN8tNWPM7SHO5fsIUnytVExVCXJZk5Oji6zum78zgaWmT9CYR2sX5iJZV0YZNqZoYNHew/tb2sS
        lECJMpTE7v43j27FW78Li0A2cUKY+1wJxlvG+FJJA+1ELU8+7B6EDuS9oWyiIbCMsCGfoo+6919lN
        H1gwFyNrFDqyjOfjgbn+R9sJtDVCoN273SBVxEKvcYmyMC8PSh9glsaC2TgpgS83l2E+3A7qrMr11
        zjcFjIxA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34122 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jORYT-0001lf-Ks; Tue, 14 Apr 2020 20:49:09 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jORYS-000409-7i; Tue, 14 Apr 2020 20:49:08 +0100
In-Reply-To: <20200414194753.GB25745@shell.armlinux.org.uk>
References: <20200414194753.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net v2 2/2] net: marvell10g: soft-reset the PHY when coming
 out of low power
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jORYS-000409-7i@rmk-PC.armlinux.org.uk>
Date:   Tue, 14 Apr 2020 20:49:08 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soft-reset the PHY when coming out of low power mode, which seems to
be necessary with firmware versions 0.3.3.0 and 0.3.10.0.

This depends on ("net: marvell10g: report firmware version")

Fixes: c9cc1c815d36 ("net: phy: marvell10g: place in powersave mode at probe")
Reported-by: Matteo Croce <mcroce@redhat.com>
Tested-by: Matteo Croce <mcroce@redhat.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 748532d9e1ae..95e3f4644aeb 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -75,7 +75,8 @@ enum {
 
 	/* Vendor2 MMD registers */
 	MV_V2_PORT_CTRL		= 0xf001,
-	MV_V2_PORT_CTRL_PWRDOWN = 0x0800,
+	MV_V2_PORT_CTRL_SWRST	= BIT(15),
+	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
 	MV_V2_TEMP_CTRL_SAMPLE	= 0x0000,
@@ -239,8 +240,17 @@ static int mv3310_power_down(struct phy_device *phydev)
 
 static int mv3310_power_up(struct phy_device *phydev)
 {
-	return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
-				  MV_V2_PORT_CTRL_PWRDOWN);
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	int ret;
+
+	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+				 MV_V2_PORT_CTRL_PWRDOWN);
+
+	if (priv->firmware_ver < 0x00030000)
+		return ret;
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+				MV_V2_PORT_CTRL_SWRST);
 }
 
 static int mv3310_reset(struct phy_device *phydev, u32 unit)
-- 
2.20.1

