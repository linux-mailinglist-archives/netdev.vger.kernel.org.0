Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45624A9A12
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbiBDNgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:36:51 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:54400 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240656AbiBDNgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 08:36:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 062539C0226;
        Fri,  4 Feb 2022 08:36:50 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id keV3fXXiDst4; Fri,  4 Feb 2022 08:36:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 997FF9C0215;
        Fri,  4 Feb 2022 08:36:49 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6WOkgcdVpilt; Fri,  4 Feb 2022 08:36:49 -0500 (EST)
Received: from localhost.localdomain (85-170-128-172.rev.numericable.fr [85.170.128.172])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id AEA0B9C0214;
        Fri,  4 Feb 2022 08:36:48 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY support
Date:   Fri,  4 Feb 2022 14:36:34 +0100
Message-Id: <20220204133635.296974-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220204133635.296974-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
References: <20220204133635.296974-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Microchip 9897 Phy included in KSZ9897 Switch.
The KSZ9897 shares the same prefix as the KSZ8081. The phy_id_mask was
updated to allow the KSZ9897 to be matched.

Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
---
 drivers/net/phy/micrel.c   | 15 +++++++++++++--
 include/linux/micrel_phy.h |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 44a24b99c894..9b2047e26449 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1726,7 +1726,7 @@ static struct phy_driver ksphy_driver[] =3D {
 }, {
 	.phy_id		=3D PHY_ID_KSZ8081,
 	.name		=3D "Micrel KSZ8081 or KSZ8091",
-	.phy_id_mask	=3D MICREL_PHY_ID_MASK,
+	.phy_id_mask	=3D 0x00ffffff,
 	.flags		=3D PHY_POLL_CABLE_TEST,
 	/* PHY_BASIC_FEATURES */
 	.driver_data	=3D &ksz8081_type,
@@ -1869,6 +1869,16 @@ static struct phy_driver ksphy_driver[] =3D {
 	.config_init	=3D kszphy_config_init,
 	.suspend	=3D genphy_suspend,
 	.resume		=3D genphy_resume,
+}, {
+	.phy_id		=3D PHY_ID_KSZ9897,
+	.phy_id_mask	=3D 0x00ffffff,
+	.name		=3D "Microchip KSZ9897",
+	/* PHY_BASIC_FEATURES */
+	.config_init	=3D kszphy_config_init,
+	.config_aneg	=3D ksz8873mll_config_aneg,
+	.read_status	=3D ksz8873mll_read_status,
+	.suspend	=3D genphy_suspend,
+	.resume		=3D genphy_resume,
 } };
=20
 module_phy_driver(ksphy_driver);
@@ -1888,11 +1898,12 @@ static struct mdio_device_id __maybe_unused micre=
l_tbl[] =3D {
 	{ PHY_ID_KSZ8041, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8051, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8061, MICREL_PHY_ID_MASK },
-	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
+	{ PHY_ID_KSZ8081, 0x00ffffff },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8804, MICREL_PHY_ID_MASK },
+	{ PHY_ID_KSZ9897, 0x00ffffff },
 	{ }
 };
=20
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 1f7c33b2f5a3..8d09a732ddf3 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -36,6 +36,7 @@
 #define PHY_ID_KSZ87XX		0x00221550
=20
 #define	PHY_ID_KSZ9477		0x00221631
+#define	PHY_ID_KSZ9897		0x00221561
=20
 /* struct phy_device dev_flags definitions */
 #define MICREL_PHY_50MHZ_CLK	0x00000001
--=20
2.25.1

