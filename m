Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00F017A573
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCEMme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:42:34 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39964 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgCEMmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:42:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r2ITGOrFdkNXFEXVpBzXxFuSd3I5PbRakhCudOea2nc=; b=sXvGzwf3u99j5itQuvvThIO+WE
        EF+krl+atXLdVg5joDcD+6E8dYl3KZ4h541gOC1zbWVGwuLl3MWq+UhQoM7t6PVfEDUoJEvxsofUH
        k5wulGsQr7SWNzmV6VMBWlEM7u6YbwOH+/lirN5tS4cO18omkloZJVSCq1QKYO1/Rqxpc+wU578tB
        f1Q//mqT7ZeYGSJSI03CBTn25k/+MT3dMdxgS+S7rxB1cw7tPIo2obf2O29Gs0iNyiU93wDszSNMd
        xEjTp2iIcQLH9X93axufrvisrDsOA9NCb0V+z4qVT8REud5qim6z5TMg3dWtE5OQoLGoCGGrgW3Zh
        tpkKUizg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:50620 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ppX-0006RF-AP; Thu, 05 Mar 2020 12:42:23 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ppV-000728-D8; Thu, 05 Mar 2020 12:42:21 +0000
In-Reply-To: <20200305124139.GB25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 04/10] net: dsa: mv88e6xxx: use BMCR definitions for
 serdes control register
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j9ppV-000728-D8@rmk-PC.armlinux.org.uk>
Date:   Thu, 05 Mar 2020 12:42:21 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SGMII/1000base-X serdes register set is a clause 22 register set
offset at 0x2000 in the PHYXS device. Rather than inventing our own
defintions, use those that already exist, and name the register
MV88E6390_SGMII_BMCR.  Also remove the unused MV88E6390_SGMII_STATUS
definitions.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 10 ++++------
 drivers/net/dsa/mv88e6xxx/serdes.h |  9 +--------
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 238219787233..37d7fd132f4e 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -410,20 +410,18 @@ static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, u8 lane,
 	int err;
 
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_CONTROL, &val);
+				    MV88E6390_SGMII_BMCR, &val);
 	if (err)
 		return err;
 
 	if (up)
-		new_val = val & ~(MV88E6390_SGMII_CONTROL_RESET |
-				  MV88E6390_SGMII_CONTROL_LOOPBACK |
-				  MV88E6390_SGMII_CONTROL_PDOWN);
+		new_val = val & ~(BMCR_RESET | BMCR_LOOPBACK | BMCR_PDOWN);
 	else
-		new_val = val | MV88E6390_SGMII_CONTROL_PDOWN;
+		new_val = val | BMCR_PDOWN;
 
 	if (val != new_val)
 		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
-					     MV88E6390_SGMII_CONTROL, new_val);
+					     MV88E6390_SGMII_BMCR, new_val);
 
 	return err;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 1906b3ab29c6..15169a1cfd05 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -47,14 +47,7 @@
 #define MV88E6390_PCS_CONTROL_1_PDOWN		BIT(11)
 
 /* 1000BASE-X and SGMII */
-#define MV88E6390_SGMII_CONTROL		0x2000
-#define MV88E6390_SGMII_CONTROL_RESET		BIT(15)
-#define MV88E6390_SGMII_CONTROL_LOOPBACK	BIT(14)
-#define MV88E6390_SGMII_CONTROL_PDOWN		BIT(11)
-#define MV88E6390_SGMII_STATUS		0x2001
-#define MV88E6390_SGMII_STATUS_AN_DONE		BIT(5)
-#define MV88E6390_SGMII_STATUS_REMOTE_FAULT	BIT(4)
-#define MV88E6390_SGMII_STATUS_LINK		BIT(2)
+#define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
 #define MV88E6390_SGMII_INT_ENABLE	0xa001
 #define MV88E6390_SGMII_INT_SPEED_CHANGE	BIT(14)
 #define MV88E6390_SGMII_INT_DUPLEX_CHANGE	BIT(13)
-- 
2.20.1

