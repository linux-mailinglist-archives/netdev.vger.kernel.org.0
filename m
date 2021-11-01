Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05827442009
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 19:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhKAScO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 14:32:14 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50866 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbhKAScM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 14:32:12 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A1ITCNu043565;
        Mon, 1 Nov 2021 13:29:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635791352;
        bh=i4SlabNeux/CJimAkQl7wJwhqnLKCYcOWMS9od/vzeY=;
        h=From:To:CC:Subject:Date;
        b=OVy0MGH0qJpsuETkkV0b4+dyA01znzuE02NmtzVacbw/BAmdLk49ftD1qqBQmVBim
         8BTHCRKLBfkxXIjpgGMo/SqTuHqOCFilHhD49wHXEe/wjjPmbyJN3Go9mLuJyhkHNr
         6BIDmRaxT8KPEkwf8NKLeC+67DS1Szccd0sL4RFM=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A1ITCnZ000738
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 Nov 2021 13:29:12 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 1
 Nov 2021 13:29:12 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 1 Nov 2021 13:29:12 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A1ITBl3073637;
        Mon, 1 Nov 2021 13:29:11 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH] net: phy/mdio: enable mmd indirect access through phy_mii_ioctl()
Date:   Mon, 1 Nov 2021 20:28:59 +0200
Message-ID: <20211101182859.24073-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables access to C22 PHY MMD address space through
phy_mii_ioctl() SIOCGMIIREG/SIOCSMIIREG IOCTLs. It checks if R/W request is
received with C45 flag enabled while MDIO bus doesn't support C45 and, in
this case, tries to treat prtad as PHY MMD selector and use MMD API.

With this change it's possible to r/w PHY MMD registers with phytool, for
example, before:

  phytool read eth0/0x1f:0/0x32
  0xffea

after:
  phytool read eth0/0x1f:0/0x32
  0x00d1

This feature is very useful for various PHY issues debugging (now it's
required to modify phy code to collect MMD regs dump).

The patch is marked as RFC as it possible that I've missed something and
such feature already present in Kernel, but I just can't find it. 
It also doesn't cover phylink.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/phy/phy-core.c | 32 ++++++++++++++++++++++++--------
 drivers/net/phy/phy.c      | 29 ++++++++++++++++++++++++++---
 include/linux/phy.h        |  2 ++
 3 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 2870c33b8975..2c83a121a5fa 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -457,6 +457,28 @@ static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
 			devad | MII_MMD_CTRL_NOINCR);
 }
 
+int __mmd_phy_read(struct mii_bus *bus, int phy_addr, int devad, u32 regnum)
+{
+	int retval;
+
+	mmd_phy_indirect(bus, phy_addr, devad, regnum);
+
+	/* Read the content of the MMD's selected register */
+	retval = __mdiobus_read(bus, phy_addr, MII_MMD_DATA);
+
+	return retval;
+}
+
+int __mmd_phy_write(struct mii_bus *bus, int phy_addr, int devad, u32 regnum, u16 val)
+{
+	mmd_phy_indirect(bus, phy_addr, devad, regnum);
+
+	/* Write the data into MMD's selected register */
+	__mdiobus_write(bus, phy_addr, MII_MMD_DATA, val);
+
+	return 0;
+}
+
 /**
  * __phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
@@ -482,10 +504,7 @@ int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
 		struct mii_bus *bus = phydev->mdio.bus;
 		int phy_addr = phydev->mdio.addr;
 
-		mmd_phy_indirect(bus, phy_addr, devad, regnum);
-
-		/* Read the content of the MMD's selected register */
-		val = __mdiobus_read(bus, phy_addr, MII_MMD_DATA);
+		val = __mmd_phy_read(bus, phy_addr, devad, regnum);
 	}
 	return val;
 }
@@ -538,10 +557,7 @@ int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val)
 		struct mii_bus *bus = phydev->mdio.bus;
 		int phy_addr = phydev->mdio.addr;
 
-		mmd_phy_indirect(bus, phy_addr, devad, regnum);
-
-		/* Write the data into MMD's selected register */
-		__mdiobus_write(bus, phy_addr, MII_MMD_DATA, val);
+		__mmd_phy_write(bus, phy_addr, devad, regnum, val);
 
 		ret = 0;
 	}
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index a3bfb156c83d..212ec5954b95 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -300,8 +300,19 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 			prtad = mii_data->phy_id;
 			devad = mii_data->reg_num;
 		}
-		mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
-						 devad);
+		if (mdio_phy_id_is_c45(mii_data->phy_id) &&
+		    phydev->mdio.bus->probe_capabilities <= MDIOBUS_C22) {
+			phy_lock_mdio_bus(phydev);
+
+			mii_data->val_out = __mmd_phy_read(phydev->mdio.bus,
+							   mdio_phy_id_devad(mii_data->phy_id),
+							   prtad,
+							   mii_data->reg_num);
+
+			phy_unlock_mdio_bus(phydev);
+		} else {
+			mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad, devad);
+		}
 		return 0;
 
 	case SIOCSMIIREG:
@@ -351,7 +362,19 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 			}
 		}
 
-		mdiobus_write(phydev->mdio.bus, prtad, devad, val);
+		if (mdio_phy_id_is_c45(mii_data->phy_id) &&
+		    phydev->mdio.bus->probe_capabilities <= MDIOBUS_C22) {
+			phy_lock_mdio_bus(phydev);
+
+			__mmd_phy_write(phydev->mdio.bus, mdio_phy_id_devad(mii_data->phy_id),
+					prtad,
+					mii_data->reg_num,
+					val);
+
+			phy_unlock_mdio_bus(phydev);
+		} else {
+			mdiobus_write(phydev->mdio.bus, prtad, devad, val);
+		}
 
 		if (prtad == phydev->mdio.addr &&
 		    devad == MII_BMCR &&
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 96e43fbb2dd8..f6032c1708e6 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1114,12 +1114,14 @@ int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
  * from an MMD on a given PHY.
  */
 int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
+int __mmd_phy_read(struct mii_bus *bus, int phy_addr, int devad, u32 regnum);
 
 /*
  * phy_write_mmd - Convenience function for writing a register
  * on an MMD on a given PHY.
  */
 int phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val);
+int __mmd_phy_write(struct mii_bus *bus, int phy_addr, int devad, u32 regnum, u16 val);
 
 /*
  * __phy_write_mmd - Convenience function for writing a register
-- 
2.17.1

