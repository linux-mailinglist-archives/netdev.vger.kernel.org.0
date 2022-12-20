Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455E365215A
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiLTNUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiLTNT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:19:58 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2311311A02
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 05:19:58 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 7AB419C0896;
        Tue, 20 Dec 2022 08:19:57 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id YNQL6nAXMba7; Tue, 20 Dec 2022 08:19:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id F3F8A9C088E;
        Tue, 20 Dec 2022 08:19:56 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com F3F8A9C088E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1671542397; bh=coGhhtpSMNtwpb5pSpFdVKVrvxeZic6SB0iZG2SHK04=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=twZkbCIXkjlOhi+cy5dicecjQhvD/jf2s6ATsYi07VEI871TI7NMFz5n8xaS+ogyD
         XEHgQmQYI7T36attu8Cqi1+BZ/jwY7al/NlHlmTaY7WfmQPEQ+2mpbZfec/tHCMKXG
         c+SetbH2yoOltZWi3AgDTbM2o8DDg4fU9dnGZEgIlBzGuZtnQ4lS3A2TJhzQyQskWU
         rL+e3XBcfR/ubaSa8vSY+gZb+0NqvXMZQcZxu+0csvPqCpfXwQJg7heKpThsb+PwDA
         7ACCHZ2AABiWZLP3/5IHNhGQQHuJEP2u/xRDiCvuSs0x5Bz/8/8CkehDpX0r/AyxR/
         nUe8lRY7QBiow==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JFeWIOsbG9xQ; Tue, 20 Dec 2022 08:19:56 -0500 (EST)
Received: from sfl-deribaucourt.rennes.sfl (mtl.savoirfairelinux.net [192.168.50.3])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 1909F9C0896;
        Tue, 20 Dec 2022 08:19:56 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, woojung.huh@microchip.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH v3 3/3] net: lan78xx: prevent LAN88XX specific operations
Date:   Tue, 20 Dec 2022 14:19:23 +0100
Message-Id: <20221220131921.806365-4-enguerrand.de-ribaucourt@savoirfairelinux.com>
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

Use the generic phy interrupt functions instead.

Fixes: 89b36fb5e532 ("lan78xx: Lan7801 Support for Fixed PHY")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
---
 drivers/net/usb/lan78xx.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f18ab8e220db..0f279082b924 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -28,6 +28,7 @@
 #include <linux/phy_fixed.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
+#include <linux/phy.h>
 #include "lan78xx.h"
=20
 #define DRIVER_AUTHOR	"WOOJUNG HUH <woojung.huh@microchip.com>"
@@ -2123,10 +2124,7 @@ static void lan78xx_link_status_change(struct net_=
device *net)
 	 * at forced 100 F/H mode.
 	 */
 	if (!phydev->autoneg && (phydev->speed =3D=3D 100)) {
-		/* disable phy interrupt */
-		temp =3D phy_read(phydev, LAN88XX_INT_MASK);
-		temp &=3D ~LAN88XX_INT_MASK_MDINTPIN_EN_;
-		phy_write(phydev, LAN88XX_INT_MASK, temp);
+		phy_disable_interrupts(phydev);
=20
 		temp =3D phy_read(phydev, MII_BMCR);
 		temp &=3D ~(BMCR_SPEED100 | BMCR_SPEED1000);
@@ -2134,13 +2132,7 @@ static void lan78xx_link_status_change(struct net_=
device *net)
 		temp |=3D BMCR_SPEED100;
 		phy_write(phydev, MII_BMCR, temp); /* set to 100 later */
=20
-		/* clear pending interrupt generated while workaround */
-		temp =3D phy_read(phydev, LAN88XX_INT_STS);
-
-		/* enable phy interrupt back */
-		temp =3D phy_read(phydev, LAN88XX_INT_MASK);
-		temp |=3D LAN88XX_INT_MASK_MDINTPIN_EN_;
-		phy_write(phydev, LAN88XX_INT_MASK, temp);
+		phy_enable_interrupts(phydev);
 	}
 }
=20
--=20
2.25.1

