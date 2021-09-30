Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AD841DCBF
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351984AbhI3O4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 10:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351915AbhI3O4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 10:56:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAFBC06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 07:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LR3knB8Te8wzWLn1hbQbQlwVqUp4UbUDqA9D7XF8Y9k=; b=khPurauGVSepkU9D1Vqt0D7GL2
        RJW5G+//obPMwZ/B2VWFG7nOCuGBtsKi1kXHMiklJxUN7L09Vp7a4P98z6+3JwfCM8GXndXfqfHBP
        qi3pMASkoZa7es9SMJkhon1arOf7ocn+db94nqeXFUoEC9lm3YsK9b8t5sCigp6qjpJLDTCYrpnun
        WyacRXfZydmx4gRsa56bWU4FNB5bzVTELnBq0cqigf56PyAkwoB6Um2Awzj8Q2Qmf5a21PDmmPQ79
        AeMQoTRIHEFJOJF8IY36PI6Cr59ATeeUKv/w244IwQjAWzmmaLUqVqhBI6QBN0W8H66Q+mpJ+kGFj
        gCJ3SbgQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39008 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mVxSP-0003cj-8v; Thu, 30 Sep 2021 15:54:45 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mVxSO-000aHB-P0; Thu, 30 Sep 2021 15:54:44 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH RFT net-next] net: mdio: ensure the type of mdio devices match
 mdio drivers
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mVxSO-000aHB-P0@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 30 Sep 2021 15:54:44 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the MDIO bus, we have PHYLIB devices and drivers, and we have non-
PHYLIB devices and drivers. PHYLIB devices are MDIO devices that are
wrapped with a struct phy_device.

Trying to bind a MDIO device with a PHYLIB driver results in out-of-
bounds accesses as we attempt to access struct phy_device members. So,
let's prevent this by ensuring that the type of the MDIO device
(indicated by the MDIO_DEVICE_FLAG_PHY flag) matches the type of the
MDIO driver (indicated by the MDIO_DEVICE_IS_PHY flag.)

Link: https://lore.kernel.org/r/2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
Tested locally in SolidRun Clearfog, DSA switch and PHY get probed
correctly. Further testing welcomed.

 drivers/net/phy/mdio_bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53f034fc2ef7..779e49715e91 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -939,6 +939,12 @@ EXPORT_SYMBOL_GPL(mdiobus_modify);
 static int mdio_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct mdio_device *mdio = to_mdio_device(dev);
+	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
+
+	/* Both the driver and device must type-match */
+	if (!(mdiodrv->mdiodrv.flags & MDIO_DEVICE_IS_PHY) !=
+	    !(mdio->flags & MDIO_DEVICE_FLAG_PHY))
+		return 0;
 
 	if (of_driver_match_device(dev, drv))
 		return 1;
-- 
2.30.2

