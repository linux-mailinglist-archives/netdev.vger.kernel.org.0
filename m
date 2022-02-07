Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1A14AC812
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbiBGR7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345868AbiBGRxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:53:23 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61755C0401E1
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:53:16 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id A59699C024A;
        Mon,  7 Feb 2022 12:46:24 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id X3J2siQvDzIF; Mon,  7 Feb 2022 12:46:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 2B1AF9C025D;
        Mon,  7 Feb 2022 12:46:24 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 88vzV-Xiwnxo; Mon,  7 Feb 2022 12:46:24 -0500 (EST)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-1441-98.w90-27.abo.wanadoo.fr [90.27.160.98])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 6EB059C024A;
        Mon,  7 Feb 2022 12:46:23 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY support
Date:   Mon,  7 Feb 2022 18:45:34 +0100
Message-Id: <20220207174532.362781-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
References: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Microchip 9897 Phy included in KSZ9897 Switch.
The KSZ9897 shares the same phy_id as some revisions of the KSZ8081.
match_phy_device functions were added to distinguish them.

Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
---
 drivers/net/phy/micrel.c   | 45 ++++++++++++++++++++++++++++++++++++++
 include/linux/micrel_phy.h |  5 +++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 44a24b99c894..fc5c33194bdc 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -522,6 +522,34 @@ static int ksz8081_read_status(struct phy_device *ph=
ydev)
 	return genphy_read_status(phydev);
 }

+static int ksz8081_ksz9897_match_phy_device(struct phy_device *phydev,
+					    const bool ksz_8081)
+{
+	int ret;
+
+	if ((phydev->phy_id & MICREL_PHY_ID_MASK) !=3D PHY_ID_KSZ8081)
+		return 0;
+
+	ret =3D phy_read(phydev, MICREL_KSZ8081_CTRL2);
+	if (ret < 0)
+		return ret;
+
+	/* KSZ8081A3/KSZ8091R1 PHY and KSZ9897 switch share the same
+	 * exact PHY ID. However, they can be told apart by the default value
+	 * of the LED mode. It is 0 for the PHY, and 1 for the switch.
+	 */
+	ret &=3D (MICREL_KSZ8081_CTRL2_LED_MODE0 | MICREL_KSZ8081_CTRL2_LED_MOD=
E1);
+	if (!ksz_8081)
+		return ret;
+	else
+		return !ret;
+}
+
+static int ksz8081_match_phy_device(struct phy_device *phydev)
+{
+	return ksz8081_ksz9897_match_phy_device(phydev, true);
+}
+
 static int ksz8061_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -1561,6 +1589,11 @@ static int ksz886x_cable_test_get_status(struct ph=
y_device *phydev,
 	return ret;
 }

+static int ksz9897_match_phy_device(struct phy_device *phydev)
+{
+	return ksz8081_ksz9897_match_phy_device(phydev, false);
+}
+
 #define LAN_EXT_PAGE_ACCESS_CONTROL			0x16
 #define LAN_EXT_PAGE_ACCESS_ADDRESS_DATA		0x17
 #define LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC		0x4000
@@ -1734,6 +1767,7 @@ static struct phy_driver ksphy_driver[] =3D {
 	.config_init	=3D ksz8081_config_init,
 	.soft_reset	=3D genphy_soft_reset,
 	.config_aneg	=3D ksz8081_config_aneg,
+	.match_phy_device =3D ksz8081_match_phy_device,
 	.read_status	=3D ksz8081_read_status,
 	.config_intr	=3D kszphy_config_intr,
 	.handle_interrupt =3D kszphy_handle_interrupt,
@@ -1869,6 +1903,17 @@ static struct phy_driver ksphy_driver[] =3D {
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
+	.match_phy_device =3D ksz9897_match_phy_device,
+	.read_status	=3D ksz8873mll_read_status,
+	.suspend	=3D genphy_suspend,
+	.resume		=3D genphy_resume,
 } };

 module_phy_driver(ksphy_driver);
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 1f7c33b2f5a3..05b24bf7f75f 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -36,6 +36,7 @@
 #define PHY_ID_KSZ87XX		0x00221550

 #define	PHY_ID_KSZ9477		0x00221631
+#define	PHY_ID_KSZ9897		0x00221561

 /* struct phy_device dev_flags definitions */
 #define MICREL_PHY_50MHZ_CLK	0x00000001
@@ -62,4 +63,8 @@

 #define KSZ886X_CTRL_MDIX_STAT			BIT(4)

+#define MICREL_KSZ8081_CTRL2	0x1F
+#define MICREL_KSZ8081_CTRL2_LED_MODE0	BIT(4)
+#define MICREL_KSZ8081_CTRL2_LED_MODE1	BIT(5)
+
 #endif /* _MICREL_PHY_H */
--
2.25.1
