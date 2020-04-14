Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987FD1A8997
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503998AbgDNSac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:30:32 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46022 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504037AbgDNSa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:30:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0E98tIJkVKf8IA7siRz4woIJJIEvsFNW0SFCNt6lmKI=; b=GuZtNoYpooWn8ygNVpMugs2baF
        Z5RLfMh80ZPUGqe2PZQCkWwm9udy/9AYjHntwWLKbIANCC/Btb9vscOlDqa3BYKT/U531vNhPMJ3Q
        Eooeckqy/W5BNJ+6pKBiYJ7H3IGUAQJdT2WRqX3QsEdsH+cgz2BwiSe296ux9+m7mxCtmdxnOfF1W
        kTAwe6Z++TNCAG//vyveq0hyicIJ0WuSjfhcrSVVtSWzOkPkLHUe9TEbm5El+CQtAtWZthMkcH7Nv
        4IHE6RWxMKNQoZ5asgT21t6xeyDtMb5HY+zBCBRRluMJHle6OMcqA3ftyJbr7ff/dXJJ+ju83DMxk
        5EP0LIww==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:45162 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jOQK8-0001Po-7h; Tue, 14 Apr 2020 19:30:16 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jOQK7-0001WH-KM; Tue, 14 Apr 2020 19:30:15 +0100
In-Reply-To: <20200414182935.GY25745@shell.armlinux.org.uk>
References: <20200414182935.GY25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net 1/2] net: marvell10g: report firmware version
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jOQK7-0001WH-KM@rmk-PC.armlinux.org.uk>
Date:   Tue, 14 Apr 2020 19:30:15 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the firmware version when probing the PHY to allow issues
attributable to firmware to be diagnosed.

Tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7621badae64d..ee60417cdc55 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -33,6 +33,8 @@
 #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
 
 enum {
+	MV_PMA_FW_VER0		= 0xc011,
+	MV_PMA_FW_VER1		= 0xc012,
 	MV_PMA_BOOT		= 0xc050,
 	MV_PMA_BOOT_FATAL	= BIT(0),
 
@@ -83,6 +85,8 @@ enum {
 };
 
 struct mv3310_priv {
+	u32 firmware_ver;
+
 	struct device *hwmon_dev;
 	char *hwmon_name;
 };
@@ -355,6 +359,23 @@ static int mv3310_probe(struct phy_device *phydev)
 
 	dev_set_drvdata(&phydev->mdio.dev, priv);
 
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_VER0);
+	if (ret < 0)
+		return ret;
+
+	priv->firmware_ver = ret << 16;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_VER1);
+	if (ret < 0)
+		return ret;
+
+	priv->firmware_ver |= ret;
+
+	dev_info(&phydev->mdio.dev,
+		 "Firmware version %u.%u.%u.%u\n",
+		 priv->firmware_ver >> 24, (priv->firmware_ver >> 16) & 255,
+		 (priv->firmware_ver >> 8) & 255, priv->firmware_ver & 255);
+
 	/* Powering down the port when not in use saves about 600mW */
 	ret = mv3310_power_down(phydev);
 	if (ret)
-- 
2.20.1

