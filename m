Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158F31FF395
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbgFRNpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgFRNpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:45:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ACFC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 06:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sk+9T1RYWICB5Yv0T0jdi/loFuuQNQotM0fGiRbX6sY=; b=sP7HQ9xSUFJz+jJdkzjUdgv3sB
        mZ3+pvsZe2UkIo5QNicnU2I2ZrK9As9KKo3X/yKwyC7k2p04mETkB/uJcGE4KJ6FjvQ8n2M+WhqJC
        p1IYh6BQ0tYi29oVOJD0KXyLWKxEZCM0oTPiGhj36jajEauOrC/PAtBkdt3H6gexWIfIrRLJSgK/C
        M2TOXobwjzXkhL2B3vTUmLp7AreR2AMPFJ4YT5k4QBqL0ksUOdgPNW7fHgh55Lb02g7h5lFHaiMNM
        EPpT/p+W9zDxvTABhpakVoZGbytWihm1ymLAweziev+na4fFBkvlT2Q7wTZvFylZmB0PXG3KVqw5i
        75FIfJgA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37648 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurU-0005Ah-Bp; Thu, 18 Jun 2020 14:45:48 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurU-0004k0-4N; Thu, 18 Jun 2020 14:45:48 +0100
In-Reply-To: <20200618134500.GB1551@shell.armlinux.org.uk>
References: <20200618134500.GB1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/9] net: phy: clean up get_phy_c22_id() invalid ID
 handling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jlurU-0004k0-4N@rmk-PC.armlinux.org.uk>
Date:   Thu, 18 Jun 2020 14:45:48 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the ID check from get_phy_device() into get_phy_c22_id(), which
simplifies get_phy_device(). The ID reading functions are now
responsible for indicating whether they found a PHY or not via their
return code - they must return -ENODEV when a PHY is not present.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e8dc9fcf188e..0e802c6add09 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -761,8 +761,10 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
  * @addr: PHY address on the MII bus
  * @phy_id: where to store the ID retrieved.
  *
- * Read the 802.3 clause 22 PHY ID from the PHY at @addr on the @bus.
- * Return the PHY ID read from the PHY in @phy_id on successful access.
+ * Read the 802.3 clause 22 PHY ID from the PHY at @addr on the @bus,
+ * placing it in @phy_id. Return zero on successful read and the ID is
+ * valid, %-EIO on bus access error, or %-ENODEV if no device responds
+ * or invalid ID.
  */
 static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 {
@@ -784,6 +786,10 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 
 	*phy_id |= phy_reg;
 
+	/* If the phy_id is mostly Fs, there is no device there */
+	if ((*phy_id & 0x1fffffff) == 0x1fffffff)
+		return -ENODEV;
+
 	return 0;
 }
 
@@ -814,10 +820,6 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 	if (r)
 		return ERR_PTR(r);
 
-	/* If the phy_id is mostly Fs, there is no device there */
-	if ((phy_id & 0x1fffffff) == 0x1fffffff)
-		return ERR_PTR(-ENODEV);
-
 	return phy_device_create(bus, addr, phy_id, is_c45, &c45_ids);
 }
 EXPORT_SYMBOL(get_phy_device);
-- 
2.20.1

