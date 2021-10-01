Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65B841EA4A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 12:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353296AbhJAKC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 06:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353184AbhJAKC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 06:02:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B21C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 03:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HEs1+f8S6t6jETPnUudA3SHYrAvuGDxp+PjLV1/0EZo=; b=GyT9Navy01CPzNKg/97TPLS7lG
        vRQnyWhJ//nvXqSs7fSVx0sTKA3odY9OwsduJgujRfbCj6kk2D3M/xHaDMUW7DIvjdL6we0LVyNwL
        obFydS5mfx3FzHyIirwEJBVE2dIH3ls3mARuXpW8O4D7PwfypqCouVMksDtRl9qwWBbB+ULEHT25N
        NC4tSZAetGElkUTwRuchL2pUe6kckl5PaZHCIq14YT24DVFPnriJkZntZ4A+GpwI3sRO5ddbhiwIL
        b94l0LclXzwUXUuIDshCUjNieGy3tXC9flngrm8mqvDvUITd+la3wGgrEjcvjdFwKqx4eCjWKb/rV
        KzbkkxaA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57874 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mWFLN-0004VH-T7; Fri, 01 Oct 2021 11:00:41 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mWFLN-000fYQ-Cl; Fri, 01 Oct 2021 11:00:41 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH RFT v2 net-next] net: mdio: ensure the type of mdio devices match
 mdio drivers
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mWFLN-000fYQ-Cl@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 01 Oct 2021 11:00:41 +0100
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

v2: dead christmas tree ordering.

 drivers/net/phy/mdio_bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53f034fc2ef7..3a36b463c22a 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -938,8 +938,14 @@ EXPORT_SYMBOL_GPL(mdiobus_modify);
  */
 static int mdio_bus_match(struct device *dev, struct device_driver *drv)
 {
+	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
 	struct mdio_device *mdio = to_mdio_device(dev);
 
+	/* Both the driver and device must type-match */
+	if (!(mdiodrv->mdiodrv.flags & MDIO_DEVICE_IS_PHY) !=
+	    !(mdio->flags & MDIO_DEVICE_FLAG_PHY))
+		return 0;
+
 	if (of_driver_match_device(dev, drv))
 		return 1;
 
-- 
2.30.2

