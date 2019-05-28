Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256922C3A8
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfE1J5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:57:37 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35906 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfE1J5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:57:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3nKs77Ra+XpsPTFQ6m5fDmW9ie6mA0zQy8G3CNGWkmY=; b=VqFvU++Ly+zh04CkU2hGWLXuaY
        bOfkpBAsTZc/yW+pWCMoATsWtWoV0iyjbzoGezys7I7Q+NuDA9fNCrFY0LV3adiwzdYaz/Ed1BiGK
        zKw1xMzn5K3LtZ3zgpQT20SqpaWMRBjHdvUesfRUc+SCGoJb7DiH/yxlNo6RptsytVCmBY3EQlEkq
        nB/5H512lY+PCD0dfgU4TKX3an8GIFO6BKU3f5NOPYheIc4JHwPuRq89KiVv08lECpPOSXNKt0j1I
        3YbXwqKmtb29QSdXq6QDwelWosKJSIpN9aiTBAZlSaH70s6whZY7VSxOwWS9IQ40pxX7TlqiLHvRh
        5l/OKovA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:39914 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYrK-0004yn-NK; Tue, 28 May 2019 10:57:30 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYrJ-0005ZA-0S; Tue, 28 May 2019 10:57:29 +0100
In-Reply-To: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/5] net: phy: allow Clause 45 access via mii ioctl
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hVYrJ-0005ZA-0S@rmk-PC.armlinux.org.uk>
Date:   Tue, 28 May 2019 10:57:29 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow userspace to generate Clause 45 MII access cycles via phylib.
This is useful for tools such as mii-diag to be able to inspect Clause
45 PHYs.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 3745220c5c98..6d279c2ac1f8 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -386,6 +386,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 	struct mii_ioctl_data *mii_data = if_mii(ifr);
 	u16 val = mii_data->val_in;
 	bool change_autoneg = false;
+	int prtad, devad;
 
 	switch (cmd) {
 	case SIOCGMIIPHY:
@@ -393,14 +394,29 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 		/* fall through */
 
 	case SIOCGMIIREG:
-		mii_data->val_out = mdiobus_read(phydev->mdio.bus,
-						 mii_data->phy_id,
-						 mii_data->reg_num);
+		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
+			prtad = mdio_phy_id_prtad(mii_data->phy_id);
+			devad = mdio_phy_id_devad(mii_data->phy_id);
+			devad = MII_ADDR_C45 | devad << 16 | mii_data->reg_num;
+		} else {
+			prtad = mii_data->phy_id;
+			devad = mii_data->reg_num;
+		}
+		mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
+						 devad);
 		return 0;
 
 	case SIOCSMIIREG:
-		if (mii_data->phy_id == phydev->mdio.addr) {
-			switch (mii_data->reg_num) {
+		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
+			prtad = mdio_phy_id_prtad(mii_data->phy_id);
+			devad = mdio_phy_id_devad(mii_data->phy_id);
+			devad = MII_ADDR_C45 | devad << 16 | mii_data->reg_num;
+		} else {
+			prtad = mii_data->phy_id;
+			devad = mii_data->reg_num;
+		}
+		if (prtad == phydev->mdio.addr) {
+			switch (devad) {
 			case MII_BMCR:
 				if ((val & (BMCR_RESET | BMCR_ANENABLE)) == 0) {
 					if (phydev->autoneg == AUTONEG_ENABLE)
@@ -433,11 +449,10 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 			}
 		}
 
-		mdiobus_write(phydev->mdio.bus, mii_data->phy_id,
-			      mii_data->reg_num, val);
+		mdiobus_write(phydev->mdio.bus, prtad, devad, val);
 
-		if (mii_data->phy_id == phydev->mdio.addr &&
-		    mii_data->reg_num == MII_BMCR &&
+		if (prtad == phydev->mdio.addr &&
+		    devad == MII_BMCR &&
 		    val & BMCR_RESET)
 			return phy_init_hw(phydev);
 
-- 
2.7.4

