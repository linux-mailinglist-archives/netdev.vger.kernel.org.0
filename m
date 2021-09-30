Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A64B41DCC0
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351990AbhI3O4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 10:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351915AbhI3O4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 10:56:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6ED2C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 07:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=37NrcByHl5Zi4nrWIXm5qe+AB2xu958lCaNKtMzvi2k=; b=wFJO/3JqERRkQcH9cEVMvhSRy7
        Z7hWI/lKAQBSRZa3g4Z1zq2dJ/jIcPJR/lQVO/IIFzw12WZn5rla9Jvll+8Fmj0HqzZseCL1e/Nmy
        8HrxHNVCAdJ3Md1myovp9cNw5akw7F/tY0aEaYuEK3hOxJnAQJB26XuXzpOJJudfvnmToRaGv2hI8
        78kuGbRvTBjNDsPcAWJZ7oqYcJtPQdXWbOA0Rcx9VQ8rmBa4o8tHteOSr4hUiBkXQr2K007WZQ4jf
        1JJa3yPF8Qd9m+YNM8dzgDObJfOmj/ppnFcR/UvSX6jl1AIIzI6SLFM0zm3rx2bbSPsHGLKWwkQCz
        MXsDebFQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39012 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mVxSU-0003ct-Ad; Thu, 30 Sep 2021 15:54:50 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mVxST-000aHI-T5; Thu, 30 Sep 2021 15:54:49 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH RFT net-next] net: phylib: ensure phy device drivers do not match
 by DT
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mVxST-000aHI-T5@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 30 Sep 2021 15:54:49 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHYLIB device drivers must match by either numerical PHY ID or by their
.match_phy_device method. Matching by DT is not permitted.

Link: https://lore.kernel.org/r/2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
Tested locally in SolidRun Clearfog, DSA switch and PHY get probed
correctly. Further testing welcomed.

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

