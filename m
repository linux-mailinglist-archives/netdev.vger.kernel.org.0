Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41324253F2
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241186AbhJGNZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbhJGNZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:25:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F148FC061570
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 06:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=92WDXCjp9fMRluM+wI2Qom/ZtBXLdt8yEY7mCQKTaEs=; b=uYT8Bldmyze5W72ZrsMzgrSNJi
        n4T9DJa0j+O0fFb/SPw1pDP3lQkJCcaheqzXAGgx7Ioa4DcsCzJJUy7ePbnq9wh2r7AksGPDEBy4G
        W040jDZ8d8CLaJGZP81GMXofOFeImLNI4kir5ZV9Cy/8X0FrAs42EZd+JeG+eFIKfcUAdXqqyzwff
        rWRrYfOeC8eKu/7fkBdL+GAI2GoCItBJsk9af5O+C+A0ZD1rq/C5fqrwc0dTRzlDzcJyncw1Ant27
        KafGCMoEokQ/6IZ2vV6SRCdSg+6FXUlvm06iwNTp45uWBs83BmdWdZ3r9mjSR/S9ty146QHw9at/W
        XX1GSpkw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59618 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mYTMz-0002Ud-DE; Thu, 07 Oct 2021 14:23:33 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mYTMy-001hFh-W4; Thu, 07 Oct 2021 14:23:33 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylib: ensure phy device drivers do not match
 by DT
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mYTMy-001hFh-W4@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 07 Oct 2021 14:23:32 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHYLIB device drivers must match by either numerical PHY ID or by their
.match_phy_device method. Matching by DT is not permitted.

Link: https://lore.kernel.org/r/2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com
Tested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ba5ad86ec826..ba295b8ad8fe 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3146,6 +3146,16 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner)
 		return -EINVAL;
 	}
 
+	/* PHYLIB device drivers must not match using a DT compatible table
+	 * as this bypasses our checks that the mdiodev that is being matched
+	 * is backed by a struct phy_device. If such a case happens, we will
+	 * make out-of-bounds accesses and lockup in phydev->lock.
+	 */
+	if (WARN(new_driver->mdiodrv.driver.of_match_table,
+		 "%s: driver must not provide a DT match table\n",
+		 new_driver->name))
+		return -EINVAL;
+
 	new_driver->mdiodrv.flags |= MDIO_DEVICE_IS_PHY;
 	new_driver->mdiodrv.driver.name = new_driver->name;
 	new_driver->mdiodrv.driver.bus = &mdio_bus_type;
-- 
2.30.2

