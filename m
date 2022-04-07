Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796D44F8AEA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiDGWw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiDGWwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:52:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633686542C
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 15:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ur3ceYvjAn1sqOgFVluVf5cvPHlLbwOJc01c6TlDGPs=; b=W+pp7j/r86/83hM7Dze2U+kGqb
        Xvwal0311igIdq0sj2M290o1L/Kg2V5lVeKYGDh78+j2AkvxbH+p0xgRi2VoHhueWdVPaV1dYdRjF
        z5ForcEk/DB6vsLM8gG2Zj9R6o58iGMMu7lsjjFPujMw9YKSRmv8cs33USz1P/jsOpMw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncaxj-00EjHg-U3; Fri, 08 Apr 2022 00:50:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v0 RFC RFT net-next 2/5] net: phy: Convert to mdiobus_c45_{read|write}
Date:   Fri,  8 Apr 2022 00:50:20 +0200
Message-Id: <20220407225023.3510609-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407225023.3510609-1-andrew@lunn.ch>
References: <20220407225023.3510609-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.35.1

