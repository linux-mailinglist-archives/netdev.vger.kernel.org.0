Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B75C293019
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 22:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732379AbgJSUul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 16:50:41 -0400
Received: from mail-eopbgr670089.outbound.protection.outlook.com ([40.107.67.89]:37972
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727720AbgJSUuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 16:50:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpC3esLtuiNfg2/0KCJo3EM/3QQicjmPga2zh9lNV8TnoYFS27Kitdh8MdranarGAZx/lqnFFO2SKOh2VhZYAouIOSRQkousDDLdacEQEBa6ovT0Flkm94rE/lHtb8DgdB0nf5ROvByKvYSwAWNCYlxAiQcHKN6R1US6qkLzbw02nhXWFejwUe9iuDezVHaO5YZrH1OC4gnBZ7EcaaZQ+GmgWUMKgkQp7R2NSd6A7EraSz86CYLTnacQ48QmTgaTtSkTbFHNSFygGGHdkHHEcjLrnJTB2eQAziLS7Led3Kz0OuulEevBxhdPvNtXew8jy+vK8KS/zcjQqdHDnOBksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6P3V1WBbHh3Er08moyvtR+VMbjukPClm5ZGjR2Mn+0=;
 b=hVHeNn9yO/6hE2bcrWozfkSgrSEH2qSn/UuKSJXVHr2dtmWutzD85uaougX7iFri4ZrvH4trae7sMadWFebkBHy5AQ4+TEIujjgLaGO0T1q3Lrcu1b9/BZIHmKNCvR0erxeK8d29XixEf/3YcjrhZGxqGzOKHL/WOU2LvA3AGEkqwfx0mzotpR2miX6py93vAk/EPCzpnwwxVCjxLgaWpP+sf6MgnfSERP2BKk7DcXn7Ctb9YakqV0XrRe+jI6PbIB+MHNx0t32xafE3QcN5Q6+FdqE2DFunxCUqDHxrWtqMP50i2VGfORpTw/Eg+rpUdJ/xUbHv4BvnYTgx88nc0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6P3V1WBbHh3Er08moyvtR+VMbjukPClm5ZGjR2Mn+0=;
 b=lUhBVGcRCjVMNQNRgVAlANMgoVbC3aGf4LSeJ5Doil16iog+L1CBf1T6qr+mCHL+6S4VzpRl2LilN/V4Z1C2dKmCmUgQJzzuie0ABqPW6ycJtjfzIIeElocSyugAFvSrjdRxrhUfOlqHr77BiIoPuX3RmdyUFaNa57GmeWvMhaE=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT1PR01MB2987.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23; Mon, 19 Oct
 2020 20:50:33 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 20:50:33 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH] net: phy: marvell: add special handling of Finisar modules with 81E1111
Date:   Mon, 19 Oct 2020 14:49:13 -0600
Message-Id: <20201019204913.467287-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0030.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::43)
 To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0030.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22 via Frontend Transport; Mon, 19 Oct 2020 20:50:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90745435-86cb-4965-364b-08d874709f7f
X-MS-TrafficTypeDiagnostic: YT1PR01MB2987:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB2987EDCD50EC0A7BCC0654F0EC1E0@YT1PR01MB2987.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRs7jItC7OfVCYBnd1mv+KmEKCAH9ngnxD9y3Wq3YOVa+clbSlFCaxSJWGxhCqM6CE3UgnQrwPQJuyiMT6cacx9/up+t2ZpsZcH+6qt2lI5mSXQCUhneW0iTrIxbZ3cN6SEN15mvLSQe73MK6KhED31wVrdWTCB5x3w1loiz0Le4wrMFju4rpyBrB6n3hbFgR7GphpK73h8PvGZ+kBXOJ2xK/997zvnpyIef/vJHlGR3mE9VEQvmahIuCWZAqhGhfBocpXJytxPMP3/YxgezHI6l6AQzzVctnlZOfq9NXTR12+OKaIjDp6Kve9Ip3REopMTyYr/1Ks3Fg8/+e9exntruh17/TSpxjEnELEVpkQy7eerxtXEQ3oDdGBjZTi+gUCxP5ggbxTbXSjb3kF78ciKn4kEiEb0R7GsRgASxu1ciPuFcUhNaFG7REni0/Uv18bqQe3L6c++M4EZG4B+vZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(366004)(376002)(346002)(6486002)(2906002)(956004)(2616005)(966005)(36756003)(86362001)(8676002)(44832011)(6512007)(316002)(16526019)(6506007)(69590400008)(26005)(186003)(107886003)(83380400001)(52116002)(4326008)(66946007)(8936002)(6666004)(66476007)(66556008)(5660300002)(1076003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: utd7a2kekFtr3rM8yCA7ji7gzWY7v1TBhhsZUmBuKHFMUVmW6gHFdYRSogqDjTk0eepzQuYTWyQ54V1LRylK2G19GYnfiJi4B0tmvZIkIyvuAkoUeoVcfLn/WrUeKsPy/Xczne3tATt4ZhfCYDJkZ10e3VebsSFazLj1DW2ik0cove9Qsy+kQmXsm58Zgd+I2v1r0jnS7IAEqzvaNIDiTnRTNEw+WV3cwtba65x15w42yn7LD5LiiaV3Gd+LOPE1jQI0BqMVNhRD5ezkZoiWTdSYftLUMkpqOVAXRt/gABExRN8nfem2l9N6+kGDwZpD2tsMd+pOSSiMo1pDlNG2itMpCdJskqB7TWTlsuQ3jnQ0M2aGUx34RxF5Ul0OPNmov2F1h1sLyhQn9QMHn9BuK5N/39DiyPa+NjYSh5TZyavneVdxx2B/Z1+miRodaRYA6L2Fh8hafFm4hHVUIr0jTgCNcxIlf0atEsJZZYV1s6SUUiVAtnSbUgtmm9rvltjBhvP1MT9eZYcxLZoBvL57BYmi4h+Q0nIhB2OkkRHnnMDkleI1dbWcNjVoeVvby2z1i6jIGgtZIzZiCIC+OLf57CUgZHfNU+/xT6Xdk29NyBq5Ft+mkg3Xg3Kugc+1TWEktTysN6DCqPzzL3OZNDAWaA==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90745435-86cb-4965-364b-08d874709f7f
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 20:50:33.5687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtIge2KvPNJkV6VLwP6EEJGGTHCM/ABgWvVy+hw+SHTr1beGZDiEBCFcz/B3opneZ6zxIxmk6LW2PTX2s2pjBOtr6KgTLkNqbYYpMrdGKAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB2987
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Finisar FCLF8520P2BTL 1000BaseT SFP module uses a Marvel 81E1111 PHY
with a modified PHY ID, and by default does not have 1000BaseX
auto-negotiation enabled, which is not generally desirable with Linux
networking drivers. Add handling to enable 1000BaseX auto-negotiation.
Also, it requires some special handling to ensure that 1000BaseT auto-
negotiation is enabled properly when desired.

Based on existing handling in the AMD xgbe driver and the information in
the Finisar FAQ:
https://www.finisar.com/sites/default/files/resources/an-2036_1000base-t_sfp_faqreve1.pdf

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/marvell.c   | 82 +++++++++++++++++++++++++++++++++++++
 include/linux/marvell_phy.h |  3 ++
 2 files changed, 85 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5aec673a0120..8d85c96209ad 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -80,8 +80,11 @@
 #define MII_M1111_HWCFG_MODE_FIBER_RGMII	0x3
 #define MII_M1111_HWCFG_MODE_SGMII_NO_CLK	0x4
 #define MII_M1111_HWCFG_MODE_RTBI		0x7
+#define MII_M1111_HWCFG_MODE_COPPER_1000BX_AN	0x8
 #define MII_M1111_HWCFG_MODE_COPPER_RTBI	0x9
 #define MII_M1111_HWCFG_MODE_COPPER_RGMII	0xb
+#define MII_M1111_HWCFG_MODE_COPPER_1000BX_NOAN 0xc
+#define MII_M1111_HWCFG_SERIAL_AN_BYPASS	BIT(12)
 #define MII_M1111_HWCFG_FIBER_COPPER_RES	BIT(13)
 #define MII_M1111_HWCFG_FIBER_COPPER_AUTO	BIT(15)
 
@@ -629,6 +632,39 @@ static int marvell_config_aneg_fiber(struct phy_device *phydev)
 	return genphy_check_and_restart_aneg(phydev, changed);
 }
 
+static int m88e1111_finisar_config_aneg(struct phy_device *phydev)
+{
+	int err;
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
@@ -843,6 +879,30 @@ static int m88e1111_config_init(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int m88e1111_finisar_config_init(struct phy_device *phydev)
+{
+	int err;
+	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
+
+	if (extsr < 0)
+		return extsr;
+
+	/* If using 1000BaseX and 1000BaseX auto-negotiation is disabled, enable it */
+	if (phydev->interface == PHY_INTERFACE_MODE_1000BASEX &&
+	    (extsr & MII_M1111_HWCFG_MODE_MASK) ==
+	    MII_M1111_HWCFG_MODE_COPPER_1000BX_NOAN) {
+		err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
+				 MII_M1111_HWCFG_MODE_MASK |
+				 MII_M1111_HWCFG_SERIAL_AN_BYPASS,
+				 MII_M1111_HWCFG_MODE_COPPER_1000BX_AN |
+				 MII_M1111_HWCFG_SERIAL_AN_BYPASS);
+		if (err < 0)
+			return err;
+	}
+
+	return m88e1111_config_init(phydev);
+}
+
 static int m88e1111_get_downshift(struct phy_device *phydev, u8 *data)
 {
 	int val, cnt, enable;
@@ -2672,6 +2732,27 @@ static struct phy_driver marvell_drivers[] = {
 		.get_tunable = m88e1111_get_tunable,
 		.set_tunable = m88e1111_set_tunable,
 	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E1111_FINISAR,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E1111 (Finisar)",
+		/* PHY_GBIT_FEATURES */
+		.probe = marvell_probe,
+		.config_init = &m88e1111_finisar_config_init,
+		.config_aneg = &m88e1111_finisar_config_aneg,
+		.read_status = &marvell_read_status,
+		.ack_interrupt = &marvell_ack_interrupt,
+		.config_intr = &marvell_config_intr,
+		.resume = &genphy_resume,
+		.suspend = &genphy_suspend,
+		.read_page = marvell_read_page,
+		.write_page = marvell_write_page,
+		.get_sset_count = marvell_get_sset_count,
+		.get_strings = marvell_get_strings,
+		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1111_get_tunable,
+		.set_tunable = m88e1111_set_tunable,
+	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1118,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
@@ -2989,6 +3070,7 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
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

