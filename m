Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F1C1E3F1D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgE0KeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729884AbgE0KeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:34:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA77AC061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tCJYQW3rddxDHX30tJDn0Zx1UqsYyOKpgFOIKSgxE0o=; b=rMtrz9ZLK/m80enR6Wt1QaW0Sd
        FxdeFEWLuxicQy5s+IrGDRI6RMrFDa+VvjKxkhStqMOmluZ3UdtCk0u+U8uL4X2Qc7DdKj40EhYLM
        2TTulWTxdd1cLPf4OzOhgTpy2/hRMdWQGRunj4j7Qbp78+cJuSJ/Ubwq/bnjABA1HhCUJ9dvanbO5
        njgRh2qoXo9aNK6EAXPe21o82s3JIwAgB22jQfp+dYzQMLlmUD/lQzSA4vOz7Z2kCrg6j13LPc/4D
        +1nJeqxNsXi+jl20NWkeSXQfFknD3eZ0l00wG7+BqADOxEUdNCebfAnDGhTQsj+8UjNjjk6Jpytkh
        T7jVOD4w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53422 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNl-0001wa-VH; Wed, 27 May 2020 11:33:58 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNk-00083V-Hm; Wed, 27 May 2020 11:33:56 +0100
In-Reply-To: <20200527103318.GK1551@shell.armlinux.org.uk>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC v2 3/9] net: phy: clean up get_phy_c45_ids() failure
 handling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdtNk-00083V-Hm@rmk-PC.armlinux.org.uk>
Date:   Wed, 27 May 2020 11:33:56 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we decide that a PHY is not present, we do not need to go through
the hoops of setting *phy_id to 0xffffffff, and then return zero to
make get_phy_device() fail - we can return -ENODEV which will have the
same effect.

Doing so means we no longer have to pass a pointer to phy_id in, and
we can then clean up the clause 22 path in a similar way.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0d6b6ca66216..53b914ee5031 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -695,16 +695,16 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
  * get_phy_c45_ids - reads the specified addr for its 802.3-c45 IDs.
  * @bus: the target MII bus
  * @addr: PHY address on the MII bus
- * @phy_id: where to store the ID retrieved.
  * @c45_ids: where to store the c45 ID information.
  *
- *   If the PHY devices-in-package appears to be valid, it and the
- *   corresponding identifiers are stored in @c45_ids, zero is stored
- *   in @phy_id.  Otherwise 0xffffffff is stored in @phy_id.  Returns
- *   zero on success.
+ * Read the PHY "devices in package". If this appears to be valid, read
+ * the PHY identifiers for each device. Return the "devices in package"
+ * and identifiers in @c45_ids.
  *
+ * Returns zero on success, %-EIO on bus access error, or %-ENODEV if
+ * the "devices in package" is invalid.
  */
-static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
+static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 			   struct phy_c45_device_ids *c45_ids)
 {
 	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
@@ -730,10 +730,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 			return -EIO;
 
 		/* no device there, let's get out of here */
-		if ((*devs & 0x1fffffff) == 0x1fffffff) {
-			*phy_id = 0xffffffff;
-			return 0;
-		}
+		if ((*devs & 0x1fffffff) == 0x1fffffff)
+			return -ENODEV;
 	}
 
 	/* Now probe Device Identifiers for each device present. */
@@ -751,7 +749,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 			return -EIO;
 		c45_ids->device_ids[i] |= phy_reg;
 	}
-	*phy_id = 0;
+
 	return 0;
 }
 
@@ -807,7 +805,7 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
 
 	if (is_c45)
-		r = get_phy_c45_ids(bus, addr, &phy_id, &c45_ids);
+		r = get_phy_c45_ids(bus, addr, &c45_ids);
 	else
 		r = get_phy_c22_id(bus, addr, &phy_id);
 
-- 
2.20.1

