Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867E064ED3B
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 15:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiLPO6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 09:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiLPO6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 09:58:13 -0500
X-Greylist: delayed 495 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Dec 2022 06:58:10 PST
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3E75E088
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 06:58:10 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 080309C06BB;
        Fri, 16 Dec 2022 09:49:53 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Bt7EKfj-ww65; Fri, 16 Dec 2022 09:49:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 66F469C085C;
        Fri, 16 Dec 2022 09:49:52 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 66F469C085C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1671202192; bh=OIf2oVc4shHaR4T3FvAtzOKGfSx4IePKhRdfrtWEdHo=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=J1nl5YiD/ysBRngYjyrnJBupE0GagbFrDgOnY07/gCh7Tlb8Gt/v8O2k2Rjc5EtIE
         mrYCFiHNgi4i4fZSdq2QBbadQ0CHY8x/uc++un8pr2aWb317Rl8QpOplpv3RO6sf4J
         Wy5W3qAT2HPkHzAE7Wyxh77f8uXJPFZEPpCE7CSCTfJI4jU6lll7vFQFbGPW9EbPv0
         o81+PCPAl1RBONUjFpx4XP5dMaVKJr2J5KRZC8W0XqtL8qp6EEOXXAZ2Fe3rZBuB4N
         aISlNwdly6+yUAJGOXhA/f8NBQRKDeXbWeS1u797dTbvjyOiPandTpENYziUk0ZKcu
         2aczyKcDD3C5w==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GKDH-SG6qK8f; Fri, 16 Dec 2022 09:49:52 -0500 (EST)
Received: from sfl-deribaucourt.rennes.sfl (lmontsouris-657-1-69-118.w80-15.abo.wanadoo.fr [80.15.101.118])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 8F6729C06BB;
        Fri, 16 Dec 2022 09:49:51 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH] net: lan78xx: isolate LAN88XX specific operations
Date:   Fri, 16 Dec 2022 15:49:11 +0100
Message-Id: <20221216144910.1416322-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some operations during the cable switch workaround modify the register
LAN88XX_INT_MASK of the PHY. However, this register is specific to the
LAN8835 PHY. For instance, if a DP8322I PHY is connected to the LAN7801,
that register (0x19), corresponds to the LED and MAC address
configuration, resulting in unapropriate behavior.

Fixes: 14437e3fa284 ("lan78xx: workaround of forced 100 Full/Half duplex =
mode error")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
---
 drivers/net/usb/lan78xx.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f18ab8e220db..ea0a56e6cd40 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2116,6 +2116,7 @@ static void lan78xx_link_status_change(struct net_d=
evice *net)
 {
 	struct phy_device *phydev =3D net->phydev;
 	int temp;
+	bool lan88_fixup;
=20
 	/* At forced 100 F/H mode, chip may fail to set mode correctly
 	 * when cable is switched between long(~50+m) and short one.
@@ -2123,10 +2124,15 @@ static void lan78xx_link_status_change(struct net=
_device *net)
 	 * at forced 100 F/H mode.
 	 */
 	if (!phydev->autoneg && (phydev->speed =3D=3D 100)) {
-		/* disable phy interrupt */
-		temp =3D phy_read(phydev, LAN88XX_INT_MASK);
-		temp &=3D ~LAN88XX_INT_MASK_MDINTPIN_EN_;
-		phy_write(phydev, LAN88XX_INT_MASK, temp);
+		lan88_fixup =3D (PHY_LAN8835 & 0xfffffff0) =3D=3D
+			(phydev->phy_id & 0xfffffff0);
+
+		if(lan88_fixup) {
+			/* disable phy interrupt */
+			temp =3D phy_read(phydev, LAN88XX_INT_MASK);
+			temp &=3D ~LAN88XX_INT_MASK_MDINTPIN_EN_;
+			phy_write(phydev, LAN88XX_INT_MASK, temp);
+		}
=20
 		temp =3D phy_read(phydev, MII_BMCR);
 		temp &=3D ~(BMCR_SPEED100 | BMCR_SPEED1000);
@@ -2134,13 +2140,15 @@ static void lan78xx_link_status_change(struct net=
_device *net)
 		temp |=3D BMCR_SPEED100;
 		phy_write(phydev, MII_BMCR, temp); /* set to 100 later */
=20
-		/* clear pending interrupt generated while workaround */
-		temp =3D phy_read(phydev, LAN88XX_INT_STS);
+		if(lan88_fixup) {
+			/* clear pending interrupt generated while workaround */
+			temp =3D phy_read(phydev, LAN88XX_INT_STS);
=20
-		/* enable phy interrupt back */
-		temp =3D phy_read(phydev, LAN88XX_INT_MASK);
-		temp |=3D LAN88XX_INT_MASK_MDINTPIN_EN_;
-		phy_write(phydev, LAN88XX_INT_MASK, temp);
+			/* enable phy interrupt back */
+			temp =3D phy_read(phydev, LAN88XX_INT_MASK);
+			temp |=3D LAN88XX_INT_MASK_MDINTPIN_EN_;
+			phy_write(phydev, LAN88XX_INT_MASK, temp);
+		}
 	}
 }
=20
--=20
2.25.1

