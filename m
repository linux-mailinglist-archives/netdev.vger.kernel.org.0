Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FCF23BF4
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391623AbfETPWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:22:16 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48954 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389369AbfETPWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:22:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sRcXxeomc5z+3wUBYe1XybLbExt7Uvcki/q9twuy1AM=; b=dWCbp5GkuD/IMFcXE28wPl0zii
        9m+P0PgToljuGMhGUc+k9GO2tfFf1nn95HVvrpI8iu/5YOQP6dgg2svxhnLOvFXJwj6+pLDspg5BH
        GWAnkU3/1tfUQbEkFBK1wLIFERxRCGgAtSuE7UQWv0CDhMEbT5gfZc3+FnEFw9Bi07GMxOf/awvel
        9141OBu95gsC5oONGlvkYQpwYFsEosCJiQqTnCpwd6rxX7ipflnCxvFIOmykDrCvlYG26GfklQKp1
        VjMALNdSpF3GqN6gDLbnIN5Z+BZjVsxPqQJubSBGNMIcPke19IJz5NKWVtse/TvvzF/n92pyBl4OG
        fBe7DB+w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:33354 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hSk76-0003b7-04; Mon, 20 May 2019 16:22:08 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hSk73-0000vz-UE; Mon, 20 May 2019 16:22:06 +0100
In-Reply-To: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
References: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: phy: allow Clause 45 access via mii ioctl
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hSk73-0000vz-UE@rmk-PC.armlinux.org.uk>
Date:   Mon, 20 May 2019 16:22:05 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow userspace to generate Clause 45 MII access cycles via phylib.
This is useful for tools such as mii-diag to be able to inspect Clause
45 PHYs.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e8885429293a..cd8990e34905 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -407,6 +407,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 	struct mii_ioctl_data *mii_data = if_mii(ifr);
 	u16 val = mii_data->val_in;
 	bool change_autoneg = false;
+	int prtad, devad;
 
 	switch (cmd) {
 	case SIOCGMIIPHY:
@@ -414,14 +415,29 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
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
@@ -454,11 +470,10 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
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

