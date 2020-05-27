Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9D91E3F1F
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgE0KeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729861AbgE0KeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:34:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBF2C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Nh5OGyMBzvetMd0F9cG302ze+vVIsex3EF2IrTph/aQ=; b=zTJdHVaxnvlvs/ROtj91Uxu14a
        XUBkcJvVxBI6tZI1HmydhpJbtVU0FqNKep7n1CykxfKjvZug1qNl/6T5/SesimZoPZv1874pkawkd
        fhjybgoVVbuHsckrDGdDt0qsYHckmxuNYmkOLdxGBH3R7ZFdOZp8LbZR9PmDN7s5CSPyMp3uIje0V
        VHBiKAmkQtQXaxRF/CU8NwIS2M4hATVxvWkKq0T9PdeWsFCfDOsGf38W6jNNcZdx5SCn8u4R6TO8z
        ThCZlfj2NELXBbrxTiB8jQcRqJ5gBG4I2vjKqW30y8iZAhW1HkFrJc28OiCCSFSVGdL4JdkGCcmQp
        Mdeu2bFQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38094 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNr-0001wi-T4; Wed, 27 May 2020 11:34:04 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNp-00083h-L4; Wed, 27 May 2020 11:34:01 +0100
In-Reply-To: <20200527103318.GK1551@shell.armlinux.org.uk>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC v2 4/9] net: phy: clean up get_phy_c22_id() invalid ID
 handling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdtNp-00083h-L4@rmk-PC.armlinux.org.uk>
Date:   Wed, 27 May 2020 11:34:01 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the ID check from get_phy_device() into get_phy_c22_id(), which
simplifies get_phy_device(). The ID reading functions are now
responsible for indicating whether they found a PHY or not via their
return code - they must return -ENODEV when a PHY is not present.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 53b914ee5031..424e608cec21 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -759,8 +759,10 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
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
@@ -782,6 +784,10 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 
 	*phy_id |= phy_reg;
 
+	/* If the phy_id is mostly Fs, there is no device there */
+	if ((*phy_id & 0x1fffffff) == 0x1fffffff)
+		return -ENODEV;
+
 	return 0;
 }
 
@@ -812,10 +818,6 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
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

