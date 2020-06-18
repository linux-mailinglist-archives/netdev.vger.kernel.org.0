Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA571FF393
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgFRNpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgFRNpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:45:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6786C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 06:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tFOv+YVPwjLJyVpWeYC1IcmmAnR5VK5kd8WjdRrUblE=; b=BCw2nW0B1SOdoEG9tq2vfaFpB5
        p/x4zn47n1dLhm//Waf1EbttJMIuoYColb47l1MmQ4VuDuF9QNYstqs7P75C5So2wQDfb35sqr6lj
        rYtD0aQQB9MBYmr3N5kMYMx+F8Al9FEtivz2n6JldeAdmQebbojXrWWX77JAXpp5uISsEHT8r38r9
        Hr7rdcVtaLJBADtYg50nOwjVtpVj2aR37cIg2Hdy7qrnSZRfdINsDxRsUjrhsmfk4CxzzrY2V1puw
        EemLRN2fmXsrahHDm9ItNla+ifXHHvsHNYnQdAWoiDRPSehEHSfKnlOfc3sa+YJt/Bf/rldbN0bNx
        XOVjgFZA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37646 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurP-0005AW-7R; Thu, 18 Jun 2020 14:45:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlurP-0004jn-08; Thu, 18 Jun 2020 14:45:43 +0100
In-Reply-To: <20200618134500.GB1551@shell.armlinux.org.uk>
References: <20200618134500.GB1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/9] net: phy: clean up get_phy_c45_ids() failure
 handling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jlurP-0004jn-08@rmk-PC.armlinux.org.uk>
Date:   Thu, 18 Jun 2020 14:45:43 +0100
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

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a351eabe772f..e8dc9fcf188e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -697,16 +697,16 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
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
@@ -732,10 +732,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
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
@@ -753,7 +751,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 			return -EIO;
 		c45_ids->device_ids[i] |= phy_reg;
 	}
-	*phy_id = 0;
+
 	return 0;
 }
 
@@ -809,7 +807,7 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
 
 	if (is_c45)
-		r = get_phy_c45_ids(bus, addr, &phy_id, &c45_ids);
+		r = get_phy_c45_ids(bus, addr, &c45_ids);
 	else
 		r = get_phy_c22_id(bus, addr, &phy_id);
 
-- 
2.20.1

