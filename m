Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511C0515F95
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243677AbiD3Reb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239200AbiD3Rea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:34:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C2C37032
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ffO3OITprbENPiZxJ46yYqRQX0pSPU7tm7DzVKy9QR0=; b=H12x9uLZhn0JX9dPbOsiJT7y4i
        pCRAxsaFt8uh8SsvPJDmlI07CabcyZj9WSlrmty83dpky8zYHiqpFTOSCLaODqi0d2+B0dy/1fy3T
        Md/OfQZgcxH/MruajoNAHfx2c3YXA4tEnsU6EgBo3pJKr/ooZmQQK/9oCaMwuJZ0eJjY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkqvl-000eoK-8D; Sat, 30 Apr 2022 19:30:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 2/5] net: phy: Convert to mdiobus_c45_{read|write}
Date:   Sat, 30 Apr 2022 19:30:34 +0200
Message-Id: <20220430173037.156823-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220430173037.156823-1-andrew@lunn.ch>
References: <20220430173037.156823-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop using the helpers to construct a special phy address which
indicates C45. Instead use the C45 accessors, which will call the
busses C45 specific read/write API.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index beb2b66da132..9034c6a8e18f 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -295,20 +295,20 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
 			prtad = mdio_phy_id_prtad(mii_data->phy_id);
 			devad = mdio_phy_id_devad(mii_data->phy_id);
-			devad = mdiobus_c45_addr(devad, mii_data->reg_num);
+			mii_data->val_out = mdiobus_c45_read(
+				phydev->mdio.bus, prtad, devad,
+				mii_data->reg_num);
 		} else {
-			prtad = mii_data->phy_id;
-			devad = mii_data->reg_num;
+			mii_data->val_out = mdiobus_read(
+				phydev->mdio.bus, mii_data->phy_id,
+				mii_data->reg_num);
 		}
-		mii_data->val_out = mdiobus_read(phydev->mdio.bus, prtad,
-						 devad);
 		return 0;
 
 	case SIOCSMIIREG:
 		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
 			prtad = mdio_phy_id_prtad(mii_data->phy_id);
 			devad = mdio_phy_id_devad(mii_data->phy_id);
-			devad = mdiobus_c45_addr(devad, mii_data->reg_num);
 		} else {
 			prtad = mii_data->phy_id;
 			devad = mii_data->reg_num;
@@ -351,7 +351,11 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 			}
 		}
 
-		mdiobus_write(phydev->mdio.bus, prtad, devad, val);
+		if (mdio_phy_id_is_c45(mii_data->phy_id))
+			mdiobus_c45_write(phydev->mdio.bus, prtad, devad,
+					  mii_data->reg_num, val);
+		else
+			mdiobus_write(phydev->mdio.bus, prtad, devad, val);
 
 		if (prtad == phydev->mdio.addr &&
 		    devad == MII_BMCR &&
-- 
2.35.2

