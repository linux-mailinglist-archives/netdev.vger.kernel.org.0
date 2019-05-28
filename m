Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B4F2C356
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfE1Jew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:34:52 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35628 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfE1Jew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=b7EjUgtkYMhbMLswseelCo3NtK+10aHTKWB3H04r1bA=; b=IRUByUvg7sTVD+M/n9G/h4DHX6
        kbY3dIEXppCOv2NXFuL8TUOmIQha0vhPXIGWzfdlMHVbrfgPVa071YOxYLAKRxT0Ji1brvkRU8jj8
        xRPZ8JB4267CHWPLCBjCg87zd3eMX7qb9C6GoZ12ATWMr/5PpJzbiT9FPbNIKjfI2PME9tEoV972y
        aeGSTtY4nLhtGoCKf1ek4cqJ53r8ZWAZUtPXDfZZ7QciwH2l3rAEVOgzq6uD12tBQEDRZdaRXImiU
        LqXCHml4uooKg2uFOKgD1WVp1FuuoC0aSPl/QnSh+E+05ZHU1ruLTIWO2ziNMhyQvpHG1MrCBCzcp
        nywusKhw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:39880 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYVH-0004sQ-7A; Tue, 28 May 2019 10:34:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYVG-0005D8-8w; Tue, 28 May 2019 10:34:42 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] net: phy: marvell10g: report if the PHY fails to boot
 firmware
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
Date:   Tue, 28 May 2019 10:34:42 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some boards do not have the PHY firmware programmed in the 3310's flash,
which leads to the PHY not working as expected.  Warn the user when the
PHY fails to boot the firmware and refuse to initialise.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
I think this patch needs testing with the Marvell 88x2110 PHY before
this can be merged into mainline, but I think it should go into -rc
and be back-ported to stable trees to avoid user frustration. I spent
some time last night debugging one such instance, and the user
afterwards indicated that they'd had the problem for a long time, and
had thought of throwing the hardware out the window!  Clearly not a
good user experience.

 drivers/net/phy/marvell10g.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 100b401b1f4a..754cde873dde 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -31,6 +31,9 @@
 #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
 
 enum {
+	MV_PMA_BOOT		= 0xc050,
+	MV_PMA_BOOT_FATAL	= BIT(0),
+
 	MV_PCS_BASE_T		= 0x0000,
 	MV_PCS_BASE_R		= 0x1000,
 	MV_PCS_1000BASEX	= 0x2000,
@@ -211,6 +214,16 @@ static int mv3310_probe(struct phy_device *phydev)
 	    (phydev->c45_ids.devices_in_package & mmd_mask) != mmd_mask)
 		return -ENODEV;
 
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MV_PMA_BOOT_FATAL) {
+		dev_warn(&phydev->mdio.dev,
+			 "PHY failed to boot firmware, status=%04x\n", ret);
+		return -ENODEV;
+	}
+
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
-- 
2.7.4

