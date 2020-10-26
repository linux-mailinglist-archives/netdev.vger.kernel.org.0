Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2989E299491
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 18:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781953AbgJZR5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 13:57:34 -0400
Received: from mail-eopbgr660059.outbound.protection.outlook.com ([40.107.66.59]:6048
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1781773AbgJZR5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 13:57:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObFeC2bpsmAuOUZhIl9oVtuHrFgYW+9moE2d/sb9i/g+diX1EricAliTInViQLDL9Wv/hYil2FlbFSdKrFrER13fdtOxKOzbiRIavxcrKf1WNdZCOgSPMiCNxFNYNC4DDO4FHK8KieIIIyJAGDK3RLWT/KtV9OQwKffZWgUQdcSJYSuI/V13XjdkH8amev4pwK74powxzTsnGvO6o9WIuBmZAoyVUtacFm8mvHAzeqwDkZumEQT8LA3LCg8Tos8tgdsW8/TXyRwhK3WvaiqWTJU+wfNooUEq8CmAsH/OGmEoTplfBzhk9KVSLPgwN/HVAhUn7Ow6nHox79+dMt8mMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=recx9UM8p/gXx9RFEVogIwBLeC1o2lIA+o2mEQaOsP0=;
 b=NWYJPpnTb8+qaZUGMgFZGK98VkSPkvzS3d2ucacgYW3uSs/a3vRbmCyIkcfmbRtrJziRJC+NMF1IklkaSKE503CbZ6g9xGMYxqMK4O7ihU5DvbRKB2uGDK5hJ4HzvAVAnfTPsWzr9/3NiPZgtPzHFC8KWpFOgQkzs3BuREZZfiSv0NHzkp/J04VGOMx5VqlLY9D/vakW88dnS7NnGK7R0HG5wWYIwljFJc2DSp4p8YYwWJ0dyLHzD/vyrhnoBoyYQuCQtDxTbSrZKHZ3VImesHRX9disfzgxZ/nV+z9yllCCPocS1zNZnhBcI28AaL88YMqfkZfExmW31Mv6CrIY5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=recx9UM8p/gXx9RFEVogIwBLeC1o2lIA+o2mEQaOsP0=;
 b=BEtQPxkkM27MkHHYrZCzv6+ceY1oHAUCuWdKa+3Ol6aoINlWm3jN4GF/JBFPwYNkdkqxEytNXYtvghkPT9OZRvD7ZP7MkXyC+1ACwilrTRbQ58JDhFUJTNbymHD23xlMSxhe7lUzrv5ht4rUcyXiR3nQiOsExGf7T3AK+pNmODo=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT1PR01MB2619.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Mon, 26 Oct
 2020 17:57:30 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 17:57:30 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4] net: phy: marvell: add special handling of Finisar modules with 88E1111
Date:   Mon, 26 Oct 2020 11:57:14 -0600
Message-Id: <20201026175714.1332354-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MWHPR2201CA0058.namprd22.prod.outlook.com
 (2603:10b6:301:16::32) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by MWHPR2201CA0058.namprd22.prod.outlook.com (2603:10b6:301:16::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 17:57:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f36b590a-9225-4650-cad0-08d879d89b78
X-MS-TrafficTypeDiagnostic: YT1PR01MB2619:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB26193D69B3DE0D0D8CAF8C5CEC190@YT1PR01MB2619.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U6OI8/5+Vf7WYBb0sO2eFzSO5AKFv1yegRiHpemBABpAQWsys2Zlnwocx4L60DBL1WtYgYWcTVHo2zdRmuznlFLCjrNTj0/w+i5R4cjNYDXXaUI5jA5pygzarAw7VfuOKJ+xPNSSW2aC0AaGBVVc6f7g8bjTPSTMUNn01bVansWjvVP5mbQUrUwiJfslA/3uBzoHbJHM22a7r07IT9rQyDV0PZrrWNu2bwMNu4btUqaRkfeHH9sdddFa/3d8GDAnVfga0pI4hPzxkj3PqyzSNV/NL3iJSXNC7tuP6vgjwbL3enSEi4Nvqj3qb3DrPHA7nlBiSYP3cYVKI/nSF+ClgdIXjuFLrZPlvLdrqCSpYAvfyjcz8H52Zej6eBLMN3KxSJWd711mA47e/u1ztvVUfZKySpWRWHO3xXaJaJdUarzre/ZnYUGkRdnu/SA5hA50+Jc59nLNH3pZPZ1LUnkmhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(136003)(346002)(366004)(376002)(1076003)(36756003)(8936002)(6512007)(8676002)(2906002)(4326008)(2616005)(6506007)(478600001)(16526019)(966005)(52116002)(6486002)(107886003)(956004)(26005)(44832011)(66476007)(5660300002)(186003)(66946007)(316002)(86362001)(83380400001)(6666004)(66556008)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: K6tcfqPWVtbAG1HwR8eIMa1hyfW7xd0rP8TIWTOeLMyYPV97IBZy8qL03nPj+8HRBxfGnJqv20FNVwtDipACYz/+u0zhAG330p+l9mKfh8kx1hXUxEDUmeN4xhD2Uk1953omIMib9fKn0o/jliEU8ymZsjCsjhnnltVvqcFFFvwOlyX5xkLL0YfjEWAAI9amxGvWKtPxzx8HBMMBvgVGQTUtfQdiLaSslFnvHz9fsqGJTd3ppI3nm6uzgzKcd79yBrMttE7G94U12zjNzE/PvZYTBAtuYdtYk/lfjJbFpRPtBGP8TwjP/XJXaJwwcpkVU62DuPmUGvPwbv6jiwyJ/ptvDNlt7m+B14zc7yNhkDgFbRA4TPx/H3ctUBO0GzzegdMuk1foGXbKnMqtAC8auI/LPw0zLcwc3ZB4W8kEXjoUqe8+tqi82B8E+dup4xqQTdKaowGgYTAbg6CZ2QIq6bymy8EUPecoOBU2qG40PdkALIAZuTP0Je6H0mtG0JZHZ++pKDAQOC/UQreuUa3omoz+Egt1dNMKmDN6SdAOoA/+llO6DQcyv1/LUl4spMnGk0GWg1KSSZcTikCfJLba15F5Tx5xjFxWjC3a1MZNGMUHzm12yDkPKqj6qzPKDA8MxfQAaeVj6HHgXflTQ0Tiqw==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36b590a-9225-4650-cad0-08d879d89b78
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 17:57:30.3905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0y8XFRJi+QIYckRt9z5Vc7Ac+h8k8g17agVieWBfJ68SoeC2r2/m+foSvbgAiEgcVon+FeKv3fPNkj0VBY5MKO8xLgZv1oPLQRB3ZutDwT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB2619
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Finisar FCLF8520P2BTL 1000BaseT SFP module uses a Marvel 88E1111 PHY
with a modified PHY ID. Add support for this ID using the 88E1111
methods.

By default these modules do not have 1000BaseX auto-negotiation enabled,
which is not generally desirable with Linux networking drivers. Add
handling to enable 1000BaseX auto-negotiation when these modules are
used in 1000BaseX mode. Also, some special handling is required to ensure
that 1000BaseT auto-negotiation is enabled properly when desired.

Based on existing handling in the AMD xgbe driver and the information in
the Finisar FAQ:
https://www.finisar.com/sites/default/files/resources/an-2036_1000base-t_sfp_faqreve1.pdf

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
---

Changed in v4: Fixed variable order in m88e1111_config_aneg, added Russell's
Reviewed-by

 drivers/net/phy/marvell.c   | 99 ++++++++++++++++++++++++++++++++++++-
 include/linux/marvell_phy.h |  3 ++
 2 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5aec673a0120..2ed4b873a0cc 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -80,8 +80,11 @@
 #define MII_M1111_HWCFG_MODE_FIBER_RGMII	0x3
 #define MII_M1111_HWCFG_MODE_SGMII_NO_CLK	0x4
 #define MII_M1111_HWCFG_MODE_RTBI		0x7
+#define MII_M1111_HWCFG_MODE_COPPER_1000X_AN	0x8
 #define MII_M1111_HWCFG_MODE_COPPER_RTBI	0x9
 #define MII_M1111_HWCFG_MODE_COPPER_RGMII	0xb
+#define MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN	0xc
+#define MII_M1111_HWCFG_SERIAL_AN_BYPASS	BIT(12)
 #define MII_M1111_HWCFG_FIBER_COPPER_RES	BIT(13)
 #define MII_M1111_HWCFG_FIBER_COPPER_AUTO	BIT(15)
 
@@ -629,6 +632,51 @@ static int marvell_config_aneg_fiber(struct phy_device *phydev)
 	return genphy_check_and_restart_aneg(phydev, changed);
 }
 
+static int m88e1111_config_aneg(struct phy_device *phydev)
+{
+	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
+	int err;
+
+	if (extsr < 0)
+		return extsr;
+
+	/* If not using SGMII or copper 1000BaseX modes, use normal process.
+	 * Steps below are only required for these modes.
+	 */
+	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+	    (extsr & MII_M1111_HWCFG_MODE_MASK) !=
+	    MII_M1111_HWCFG_MODE_COPPER_1000X_AN)
+		return marvell_config_aneg(phydev);
+
+	err = marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
+	if (err < 0)
+		goto error;
+
+	/* Configure the copper link first */
+	err = marvell_config_aneg(phydev);
+	if (err < 0)
+		goto error;
+
+	/* Do not touch the fiber page if we're in copper->sgmii mode */
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII)
+		return 0;
+
+	/* Then the fiber link */
+	err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
+	if (err < 0)
+		goto error;
+
+	err = marvell_config_aneg_fiber(phydev);
+	if (err < 0)
+		goto error;
+
+	return marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
+
+error:
+	marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
+	return err;
+}
+
 static int m88e1510_config_aneg(struct phy_device *phydev)
 {
 	int err;
@@ -814,6 +862,27 @@ static int m88e1111_config_init_rtbi(struct phy_device *phydev)
 		MII_M1111_HWCFG_FIBER_COPPER_AUTO);
 }
 
+static int m88e1111_config_init_1000basex(struct phy_device *phydev)
+{
+	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
+
+	if (extsr < 0)
+		return extsr;
+
+	/* If using copper mode, ensure 1000BaseX auto-negotiation is enabled */
+	if ((extsr & MII_M1111_HWCFG_MODE_MASK) ==
+	    MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN) {
+		int err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
+			  MII_M1111_HWCFG_MODE_MASK |
+			  MII_M1111_HWCFG_SERIAL_AN_BYPASS,
+			  MII_M1111_HWCFG_MODE_COPPER_1000X_AN |
+			  MII_M1111_HWCFG_SERIAL_AN_BYPASS);
+		if (err < 0)
+			return err;
+	}
+	return 0;
+}
+
 static int m88e1111_config_init(struct phy_device *phydev)
 {
 	int err;
@@ -836,6 +905,12 @@ static int m88e1111_config_init(struct phy_device *phydev)
 			return err;
 	}
 
+	if (phydev->interface == PHY_INTERFACE_MODE_1000BASEX) {
+		err = m88e1111_config_init_1000basex(phydev);
+		if (err < 0)
+			return err;
+	}
+
 	err = marvell_of_reg_init(phydev);
 	if (err < 0)
 		return err;
@@ -2658,7 +2733,28 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
 		.config_init = m88e1111_config_init,
-		.config_aneg = marvell_config_aneg,
+		.config_aneg = m88e1111_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
+		.read_page = marvell_read_page,
+		.write_page = marvell_write_page,
+		.get_sset_count = marvell_get_sset_count,
+		.get_strings = marvell_get_strings,
+		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1111_get_tunable,
+		.set_tunable = m88e1111_set_tunable,
+	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E1111_FINISAR,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E1111 (Finisar)",
+		/* PHY_GBIT_FEATURES */
+		.probe = marvell_probe,
+		.config_init = m88e1111_config_init,
+		.config_aneg = m88e1111_config_aneg,
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
@@ -2989,6 +3085,7 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E1101, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1112, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1111, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E1111_FINISAR, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1118, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1121R, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1145, MARVELL_PHY_ID_MASK },
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index ff7b7607c8cf..52b1610eae68 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -25,6 +25,9 @@
 #define MARVELL_PHY_ID_88X3310		0x002b09a0
 #define MARVELL_PHY_ID_88E2110		0x002b09b0
 
+/* Marvel 88E1111 in Finisar SFP module with modified PHY ID */
+#define MARVELL_PHY_ID_88E1111_FINISAR	0x01ff0cc0
+
 /* The MV88e6390 Ethernet switch contains embedded PHYs. These PHYs do
  * not have a model ID. So the switch driver traps reads to the ID2
  * register and returns the switch family ID
-- 
2.18.4

