Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289C63FB954
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237735AbhH3PyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:54:18 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:46753
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237696AbhH3PyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 11:54:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4xwRf1D+5TFkXD0OEWJ+T+rC40vZ7vBcdhzQtldn/wExBoo+ryYf6TJ1pAOJK6IXVLXvyz52+afzL5iRrXyZ07zPZdJWg6R0jIuu2iM7ia78JwfRU44oDotiPbGGGVo7jhKrJpJfL18MboylT1eoOTu0EKXot3iL6WCLLeeZ9t8XeuzEShHRtiygscuMa3aMmlBy/ZGr4I2mGVRuaINc+8x3mV+E/jgOuVHU4qMUlmpK4+YB3AEu6lxcWXyl0P0mveR6aoDqusN55WWiPfS3Lqt5myPkh78AuU+2+hEmkVzwNJYZDKTuuEVIBzdy4ZnYY/PbKdsMNzwOuzjh7Cl8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lONAFphLHHBrplFu5N65nd/wGEIs2fQbXwaq2Oy6BM=;
 b=AE2pfEQNxLq4f8JPFOT4AgWvB6zP55WMJmmcbyg8AMOf24udZedzGJ2Eo80NIbAoUY5VYBtWSBYDqfefKd4ZEt+/9haAqKjdjpLHluLRBzay8zT5QeogjYFg9UH69GWYWwyB5RlbfG8lDqIb52eSOEEzZ9nutrICCjsCq0M5p/Ro+4iTpxTQ2str+YgbsmX8aGDVp8YHf0XhvgAEDTqO0rjlci2ZYySKes0+jDKAMFVZrV0hVA/KYQxtyEcvMwn/N2LRfATvj0EKtuewipyQGl1t+BG6+FYf3A78cc++0tkmefZvDz8rf95GsvOZOXv+igcPS/JbRgRlJJQLhYKz8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lONAFphLHHBrplFu5N65nd/wGEIs2fQbXwaq2Oy6BM=;
 b=snXg+nxXHg7LnL1T6f1IYcXJqtTIYNEebgXKYodvbEGQNY3Ed/wC0e83ZBYakx885YbvE03cV29R5UYb6/SFx6V5/zvsK/BlNriFbeIiulOcbDkHkKMJcGf73grMmUev4PxBtcGOPdKZuhMhRMUKPRLmqv/iglnX09Xm28dxnoU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Mon, 30 Aug
 2021 15:53:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 15:53:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC PATCH v2 net-next 5/5] net: phy: mscc: configure in-band auto-negotiation for VSC8514
Date:   Mon, 30 Aug 2021 18:52:50 +0300
Message-Id: <20210830155250.4029923-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 15:53:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dbc941e-4d77-4eba-4088-08d96bce4611
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4910DB33DE794B2E3F2059DAE0CB9@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vA3Ejh7vwy4cGO/IrB9XcflK94UzC4Gqs0vmk3CJDHulmjVRB/j/Nmxw1IlEhlXwhrhugA5C6QJnF9D7OfeLrouNfQyzf2q8nXOMhxE2Gz6aUa2E1E2nYzL/Kc4dbXq9A5bODbVmrJuSh+Iz10qrCj6d28VcpgD46YMscU02pjBAZEbU23AVGTFrRgn1fn44A3gNTwLb6Upq7u3i/PZMwodxZUljeOPfLkXcxkUo8IrTUpRe10Xj7reOcRTzw72sOVI628l1CTyudbEMUNo/SX/C5VjF6GJvxHXRpWl7hSh2C+75XEfdxNHOcje0lq2iXA4jgsFsYcYaEPpMuPbCHfWTG3/zrYw3QkXXvzpf6urHqA+Vsvl2LnioN8ZqbopK8VctsDmpmH6Qmby6bUiV1l8imdgurWvV+B/0NpQGHhMSxaZi75281BiwiQQlwgXayDTw80TCqmrdRFcHLHUVUbwUYc2E3QJu0c5lNpK5M33B8AbTg/0wW5v3AzyaV52tCKoq7Qy26Y+Ef7dYFOz5t8dxkh3b0Yw+8aKJfvK+pv9Bn57S/tyhG8k4rQpFOABUC+Bt8nlY2PoTv9zZ29hR8Y0oO5n5QAkB33OLNUzYdm5GEQVuG549k6tBpOKFuQbNrg01wUPEr/BHK4EUca8vBbZyHYSZ2Vr1u7iPsWu6ZgRTJjikbQfWkG+vbjgAbHoiIi4LNFxV+h0w3oYsxVraA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(5660300002)(186003)(6512007)(86362001)(36756003)(7416002)(2616005)(956004)(1076003)(6916009)(66946007)(8936002)(6506007)(2906002)(6486002)(8676002)(66476007)(66556008)(6666004)(38100700002)(54906003)(38350700002)(4326008)(83380400001)(26005)(44832011)(316002)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pm5c/SD5dKpOn1ppJZS18gOB0SdaGc1YO4x6gruepubl7DUAOG9yYUqCsYdz?=
 =?us-ascii?Q?i+vw+7wEs8fKHwOaqD3cjXXE3LiV8Pbg1NEAatYM79mraBPSS+nS7+nRbX4t?=
 =?us-ascii?Q?kwwKolWU7us2SNdoAVHaIH05mF0RNRx7cxt4se9XrN0h21gRR7pZqe/OuX8U?=
 =?us-ascii?Q?93NsbqJbxYPaGQRWtWR0uln73t91htNZxL1FVF1RoQzRCfG0oKj+euueA3Dr?=
 =?us-ascii?Q?FFm1NYHzhR1jrS2pI5CqdfqPKINA5/l/DczL08CtXKaywusaXib2PcW9+ole?=
 =?us-ascii?Q?3oKsyqIPDvxu5XcEWo9AFFB6TO1DRa/7U0VUYEh5Kce+jf9i0iLt7uyXYTFX?=
 =?us-ascii?Q?0F9FaGT7GzfbIbtNK6XnCYRhhW56OmaNzgxDbo5IfoVNhBg99oDACLJpqFsF?=
 =?us-ascii?Q?7OAm0LGQUvLYSNM8aR6SP8KEXNxQ3VXPJrpFUQz2yfEehl4vk3dDLZZA5mbp?=
 =?us-ascii?Q?tG51fRSG6jbqV1ZKXp7/6sgPq3Lgpt0eYIK7o/19Xqw8A5dOX5AM51uJcWqC?=
 =?us-ascii?Q?0UvNAnULFL2E54JE73f7X3fUb5yYuVQINiSrrEuisHtHqd0IE93jzUWsUKve?=
 =?us-ascii?Q?UHUl6QO1GhfZ/Ks8iUej5wODXb0a+0HpLiVxflNck/cUgl45cjNQDZJyikpD?=
 =?us-ascii?Q?59xRe8uA6+KVMRhDaQy+QYn1bUxlAAYnIC4mkw8gOpr/AuoiO3iCN0gChjmB?=
 =?us-ascii?Q?d5Ygru8Jvl5kZ7qsPVAewU0y/2CEvmrPofRtK8EaW8ngRJm9GJ9ZzfNU0C50?=
 =?us-ascii?Q?Ca0XRaQIeauRj0rpUWDJzRCei89mauUIaKpT9oZy5FOSOayTyzgCzdK1SROQ?=
 =?us-ascii?Q?RxKQ14V7WaamPLoqo7hRJRMjtNEx2SDkIwNsNodov9soD30E0wVO4b7EI3WD?=
 =?us-ascii?Q?neRRoDUMXaw+9cbv7SFVAqvjlW4QqvDheF42mKgPNNRNpDJHM/0QLu4oH8mV?=
 =?us-ascii?Q?BCX/IhPsji8qwLteqxQ527A1qDuuA6tuRw1QPIgtwRmQj2IibekCiSlHCzYm?=
 =?us-ascii?Q?92C2puZmXKcVVVhI68F9E6E/k3Rl0skHcJD/OPdpf9WapckctsMSN0AlRfcp?=
 =?us-ascii?Q?CfHCtmAS2QBsVOh2SudOdDbeFWyEUNowTTkKZ1KugydPQVMQ3l9OgqesedXQ?=
 =?us-ascii?Q?gemVbV1cL9HWuobdlHJoa4dPj04Mt85F9X8tGHuLSCNs5U2YUgVl+i6HHLjg?=
 =?us-ascii?Q?/X/fXEWYiRCd8s0PqiYJZLSeSGTHqIQlTWEiyF2mIHkhZV/lpKl6UCTPNX8n?=
 =?us-ascii?Q?24Fz48IAKxhXxMkYaPW9zLuNtzJWfgGAS4uzfy6bWZqDddIkPU3s4tgxl/sZ?=
 =?us-ascii?Q?JzJfILQJIHB5AMeu0xWKHmu+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbc941e-4d77-4eba-4088-08d96bce4611
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 15:53:13.4095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBhdRFKU0DirjqcmfnkX4D5QpfbblaJlo/pVYoTHoOqkXBzWJ2/EYeABXH9Sk+WQ1LiU8z/T47P656na86Zbww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the in-band configuration knob for the VSC8514 quad PHY. Tested with
QSGMII in-band AN both on and off on NXP LS1028A-RDB and T1040-RDB.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/mscc/mscc.h      |  2 ++
 drivers/net/phy/mscc/mscc_main.c | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index a50235fdf7d9..366db1425561 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -195,6 +195,8 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
 
 /* Extended Page 3 Registers */
+#define MSCC_PHY_SERDES_PCS_CTRL	  16
+#define MSCC_PHY_SERDES_ANEG		  BIT(7)
 #define MSCC_PHY_SERDES_TX_VALID_CNT	  21
 #define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
 #define MSCC_PHY_SERDES_RX_VALID_CNT	  28
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 6e32da28e138..ca537204bc27 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2189,6 +2189,24 @@ static int vsc85xx_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static int vsc8514_validate_inband_aneg(struct phy_device *phydev,
+					phy_interface_t interface)
+{
+	return PHY_INBAND_ANEG_OFF | PHY_INBAND_ANEG_ON;
+}
+
+static int vsc8514_config_inband_aneg(struct phy_device *phydev, bool enabled)
+{
+	int reg_val = 0;
+
+	if (enabled)
+		reg_val = MSCC_PHY_SERDES_ANEG;
+
+	return phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
+				MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
+				reg_val);
+}
+
 static int vsc8514_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
@@ -2395,6 +2413,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.validate_inband_aneg = vsc8514_validate_inband_aneg,
+	.config_inband_aneg = vsc8514_config_inband_aneg,
 },
 {
 	.phy_id		= PHY_ID_VSC8530,
-- 
2.25.1

