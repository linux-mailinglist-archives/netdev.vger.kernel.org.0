Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DA8474EA6
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbhLNXfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:35:13 -0500
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:50498
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238287AbhLNXfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 18:35:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nopL0dkg8FkZH+iBGG+FYF5y2zR26pGsHSBsGBM2TvOVyl1U8uIIK10MzJh/N4JBaX1iX103sRHS/fOKVmBJwRsjEs5DQ/V760p4PDZoxyTcrErLubwZpboQtQhUI1OTmCPlDze6Lt0FBeDwe1gNTHYZvECyskYUpj2dL73eAD5Dj747YbdO/qzpYKeIuia46eVTPfMMH2SRXPbwXjlVnHYoc/SByv36XCVlnxaOs1QK22O+zKNZxYIbr2fPRb2niMIavjn8kEq32O3jZ04KG/h1m68pg+X21TxIDLVnJxgimZOcELhMDwK1Y9d718VzD+zZnZTqNPtiIBHQ+3HmXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciZ4f0dsj9YhC5g+DeYZ3j6ilhOgT5vQluqm/VQqPyY=;
 b=EG37SjxZPx1m/fPXMDI8TF3sZxX8TNZIoquvgZoDFutNfc4t3/P8o6qAEVCBn+6kI97TfeFZ3DZaQBxXvxOX1Ba4TpQ6MH5WDB69cJJ/YSpRAlUS9L8nF9Lqjivd+z7jhp3r5d1lT03RvpLHhl3IJmsq9dGr8uYJTq3t54gc1sd/1h8PPwVIgFBlkCktJuc7lTz+re8WlK+y9ZZU0zETvjkbxOI+072oQ8kNCqE+HgtZy/aUi/atFUmE0eVq0rodBxcbvYwPS3Iy6OqcL4JwJXA0x9wG2OSCUIntp9EQDEEvJ2BjviD6hXXvEC44uX4B+xfI9YAhZbu/xlc5qdumNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciZ4f0dsj9YhC5g+DeYZ3j6ilhOgT5vQluqm/VQqPyY=;
 b=pTSkVSvEQh6AUys8H1Ge5+7Th1egOBK/mF+MGbjvfYHNuS/cG5Y+KCRPkYTt9liKQ9XRk8wKASlUObdsWL6opQxlWp081FFylsYj8vqJKQnTwAsaqEHpH2QGqyRkO2bVCbeAOOa7ZV0H9D6qkJhsqdhLiKD6aGbXT9jBPehTzuE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB6026.eurprd03.prod.outlook.com (2603:10a6:10:38::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 23:35:10 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 23:35:10 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Marcin Wojtas <mw@semihalf.com>, UNGLinuxDriver@microchip.com,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH] net: phylink: Pass state to pcs_config
Date:   Tue, 14 Dec 2021 18:34:50 -0500
Message-Id: <20211214233450.1488736-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:208:15e::22) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 919ce31f-69dd-459b-5ded-08d9bf5a5e2c
X-MS-TrafficTypeDiagnostic: DB8PR03MB6026:EE_
X-Microsoft-Antispam-PRVS: <DB8PR03MB602616B1E1614042367D6AFC96759@DB8PR03MB6026.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SwyJksRKB7pX25ad3cKZGYlS3b/B3TaKzUGVAn/gjRg0nzzRgrtPbT1DA5wHeNW0iHJi3vm/y3jio7unVlYn71t5QgwUWjBlkSo+3aZGGx0erlEeuwTelO6K9ywYQXC2gjCES/hkdFJdL7bGMjs2u9LAfIz3YdaNE2q2ivCt5iW9HDfCNyHKVQcSJlkaCXcXFh4uQ2a6nssFkOedd3fSuK6u8BWB1dGTWD57BWqGySoF2S15E4u94o5TGFt12d8cS0JrOAlDS8P5KRq7cziFakL7Z2tM0TefqYtW+QRHSW/f4Iy/2WXt+ZA2/nl0kVmjEcVwBFtPpPk/PcwsXNoZJ5xfBigTsFuUjyxiwCFzLOmA9ctTlZRsjQxKtwVDe6IV43zhLkBjtPRb40MCPBkrAe+RzDLKZHf2qUe920xyB6thOjwTYm79SAp8NxzKo/jzkF1RQfINiWaivYRancWnP8pjtoP3OGNdZLdOXbOwvawbUu3in8aZRWUsPk6ifpeHIOZjizraqp94ian4Af/CznBf1mnhk7xhmq7wueNanIPrsK1L/tvsapMAnqtI72IyaxeFCwlsIQiNRnSdqg/dpoY5LNpN8cTNhmM/uwZo/Acl+NQP1Sipcd6DNcx0iDrAIP4fsil4Alyxhjn5vpZNj/zWAJNQJkMwLOGtuxiHMh3hFGfH3gNezzPWE/GhC1wOiOiRDGrJKgMOPIWhcaaBKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(2906002)(110136005)(26005)(4326008)(1076003)(30864003)(66476007)(8936002)(66556008)(52116002)(316002)(7416002)(5660300002)(186003)(6512007)(38350700002)(6666004)(83380400001)(38100700002)(86362001)(44832011)(6506007)(8676002)(2616005)(6486002)(508600001)(36756003)(66946007)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QywOU73ORTmEFjYuSxG+tAFm0NnAC7Epuccecbk62WXPCZzHmrxSILRCjPB4?=
 =?us-ascii?Q?ifArhEqasqIy4zejHIyMX4rF+cytH9QZCjX943drcr+HLJKhJxBA6idlo8R8?=
 =?us-ascii?Q?MOKyW3aHp6Qx+MKtAd5GDJ0lilcWUHg4euoHNCxBj85xdtW6ywqiR4kCOh+z?=
 =?us-ascii?Q?q8vvqVwmufqbn5mlXMrayb01wjDVknIxOnlFbptHp5vkFn4hg7KR1crPYQ/c?=
 =?us-ascii?Q?8m8jGmaMVKmKmX1Gi6ziGus1JAOt1JnF9evMrOhPowU3RfjKYCfxCoqfAw2L?=
 =?us-ascii?Q?7uB2CaKiNaZUA+wIdJfz8Kb+I9zf8A/s2DI0HDNU+HmqAOBnuiVr46rtoJqS?=
 =?us-ascii?Q?fP87at8BM/9hhGCQi8HBgAnVp/AdoCMvEpbIKw458kaeoeltneX3adAWelcA?=
 =?us-ascii?Q?ntqv/iAE6Ls6le9yjv+wG3xwnYLQQ1mqst7FGJ2nE/tqZnj4o1U4kDkNNdZA?=
 =?us-ascii?Q?GrVUdrwtk8DMNA5Z/amtnNrvY1jyCW2lThK+IFTei0cTolz7qUAaf1pGXDy0?=
 =?us-ascii?Q?WncqMuDfDb5gvnfU/UMjY7KjHlQGHhBRw99DGxqTfvDmP+UbLS1Kv5g5FD3D?=
 =?us-ascii?Q?RC/jIrBLO6FaAnyJNRtmas17ly9bnpW/RXTmM2TJGHVyssMX5WLpbt23Gwdi?=
 =?us-ascii?Q?KBTqQxqOKgK7185pNdACqwpboVD3Srm1VQ9r5rnk4JFm9Fn6guqlL//kvFwp?=
 =?us-ascii?Q?PMo0Lp5aFDuTpVRrhBZjhIou2dtENDf/NTw0hAvcTjOKgjgPM/v3H9PaKLbA?=
 =?us-ascii?Q?y+GIwwi2cyt+BhFLK7u2x5gfxjcc2x9R+rQ2/Cqa1fbG08tupepcbrcImhqP?=
 =?us-ascii?Q?gQI7CBrlwb6F037ucSV/JdJHQgMSA0Crn+BvtAIEcAnIt3YV7zxBbt9XafPj?=
 =?us-ascii?Q?XriKmWQ89E5kPNJQFQKsA+7Ol0yI6fJgvVPDWq2pwEE48JgX2tdb8hzTV5Jx?=
 =?us-ascii?Q?hl4j3ak+awlhcr+Pd8s97baaTgrrFlFV7H1kcF6mNEnnxD5THF6wJW2f/iFs?=
 =?us-ascii?Q?WxnWrshNLP5VMQk+WRMd/R8mx0dphOPJjPqqMkGkGBBwTiCcMw6RRXRbHaSk?=
 =?us-ascii?Q?jF0yivKTDGY35Byj4xyXzQC+0OJkpsZKvW5H+AizaP7hurbVcWykSHIQAJt9?=
 =?us-ascii?Q?Xn/e6Q3dq3aOTKPE/VaJRhS8ID5tX1deqsX0AazawssjfzmL1g7m4uTQVt4W?=
 =?us-ascii?Q?S3n1FWbxTTmT4YuH9INiIhpXtnqcB6bBjghFT7MjZPhjG4PtVlihCe0/13F5?=
 =?us-ascii?Q?Wkpyv2sPSwar+00nTqFmZOW31eBqIffKFDQwCP3aF6Gg2Zpagw5H4CFcNK06?=
 =?us-ascii?Q?/HPbb/OGGr2YO9PpdkbbqsFgD6VL+HogCsJuMrajG8N00hSKxEXzZW1UojTf?=
 =?us-ascii?Q?nBVtesO9B3UhxvWqSgjyaa3Qr6EXEdTS2yNosyqq+BaIkiEZSKCVmOWH4bx7?=
 =?us-ascii?Q?D9Mt9MRuC8kZnsuudYXHrdX5IX51f5fVjmZWp4PRSCECrKXIal+V0HlvXlLx?=
 =?us-ascii?Q?RYiCwV+DNnOKkh6eVA56J2QUTdS+A24E5VXtF0enC8yjVS85TQdYJClW0X+G?=
 =?us-ascii?Q?cMOpaFHSo9Vf0zWRsmNPKexK9nbH4rLrbUnU5W57pq8JPbzo8kFpimzR/9l1?=
 =?us-ascii?Q?c4XZ4zRrH/8enEpQfsf1YqE=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919ce31f-69dd-459b-5ded-08d9bf5a5e2c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 23:35:10.0092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UHbDbO8h57gk4M05qeLI91hltbvLPL69dy9cF/o1xragVOWIouUyoUW/pcr7i+oTtFkX06hqjRdzQC5JELogbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6026
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although most PCSs only need the interface and advertising to configure
themselves, there is an oddly named "permit_pause_to_mac" parameter
included as well, and only used by mvpp2. This parameter indicates
whether pause settings should be autonegotiated or not. mvpp2 needs this
because it cannot both set the pause mode manually and and advertise
pause support. That is, if you want to set the pause mode, you have to
advertise that you don't support flow control. We can't just
autonegotiate the pause mode and then set it manually, because if
the link goes down we will start advertising the wrong thing. So
instead, we have to set it up front during pcs_config. However, we can't
determine whether we are autonegotiating flow control based on our
advertisement (since we advertise flow control even when it is set
manually).

So we have had this strange additional argument tagging along which is
used by one driver (though soon to be one more since mvneta has the same
problem). We could stick MLO_PAUSE_AN in the "mode" parameter, since
that contains other autonegotiation configuration. However, there are a
lot of places in the codebase which do a direct comparison (e.g. mode ==
MLO_AN_FIXED), so it would be difficult to add an extra bit without
breaking things. But this whole time, mac_config has been getting the
whole state, and it has not suffered unduly. So just pass state and
eliminate these other parameters.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/cadence/macb_main.c      |  8 ++----
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 28 +++++++++----------
 .../microchip/lan966x/lan966x_phylink.c       | 10 +++----
 .../microchip/sparx5/sparx5_phylink.c         | 16 +++++------
 drivers/net/pcs/pcs-lynx.c                    | 15 +++++-----
 drivers/net/pcs/pcs-xpcs.c                    |  6 ++--
 drivers/net/phy/phylink.c                     |  9 ++----
 include/linux/phylink.h                       | 14 +++-------
 8 files changed, 42 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d4da9adf6777..2ae717f262e8 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -540,9 +540,7 @@ static void macb_usx_pcs_get_state(struct phylink_pcs *pcs,
 
 static int macb_usx_pcs_config(struct phylink_pcs *pcs,
 			       unsigned int mode,
-			       phy_interface_t interface,
-			       const unsigned long *advertising,
-			       bool permit_pause_to_mac)
+			       const struct phylink_link_state *state)
 {
 	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
 
@@ -565,9 +563,7 @@ static void macb_pcs_an_restart(struct phylink_pcs *pcs)
 
 static int macb_pcs_config(struct phylink_pcs *pcs,
 			   unsigned int mode,
-			   phy_interface_t interface,
-			   const unsigned long *advertising,
-			   bool permit_pause_to_mac)
+			   const struct phylink_link_state *state)
 {
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b1cce4425296..62de173536bf 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6146,9 +6146,7 @@ static void mvpp2_xlg_pcs_get_state(struct phylink_pcs *pcs,
 
 static int mvpp2_xlg_pcs_config(struct phylink_pcs *pcs,
 				unsigned int mode,
-				phy_interface_t interface,
-				const unsigned long *advertising,
-				bool permit_pause_to_mac)
+				const struct phylink_link_state *state)
 {
 	return 0;
 }
@@ -6194,9 +6192,7 @@ static void mvpp2_gmac_pcs_get_state(struct phylink_pcs *pcs,
 }
 
 static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
-				 phy_interface_t interface,
-				 const unsigned long *advertising,
-				 bool permit_pause_to_mac)
+				 const struct phylink_link_state *state)
 {
 	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
 	u32 mask, val, an, old_an, changed;
@@ -6213,7 +6209,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			MVPP2_GMAC_CONFIG_FULL_DUPLEX;
 		val = MVPP2_GMAC_IN_BAND_AUTONEG;
 
-		if (interface == PHY_INTERFACE_MODE_SGMII) {
+		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
 			/* SGMII mode receives the speed and duplex from PHY */
 			val |= MVPP2_GMAC_AN_SPEED_EN |
 			       MVPP2_GMAC_AN_DUPLEX_EN;
@@ -6222,18 +6218,21 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			val |= MVPP2_GMAC_CONFIG_GMII_SPEED |
 			       MVPP2_GMAC_CONFIG_FULL_DUPLEX;
 
-			/* The FLOW_CTRL_AUTONEG bit selects either the hardware
-			 * automatically or the bits in MVPP22_GMAC_CTRL_4_REG
-			 * manually controls the GMAC pause modes.
+			/* The FLOW_CTRL_AUTONEG bit selects whether flow
+			 * control should come from autonegotiation or whether
+			 * it should be manually configured (by
+			 * MVPP22_GMAC_CTRL_4_REG). If it is cleared (to select
+			 * manual configuration) then flow control
+			 * advertisement will be ignored.
 			 */
-			if (permit_pause_to_mac)
+			if (state->pause & MLO_PAUSE_AN)
 				val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
 
 			/* Configure advertisement bits */
 			mask |= MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN;
-			if (phylink_test(advertising, Pause))
+			if (phylink_test(state->advertising, Pause))
 				val |= MVPP2_GMAC_FC_ADV_EN;
-			if (phylink_test(advertising, Asym_Pause))
+			if (phylink_test(state->advertising, Asym_Pause))
 				val |= MVPP2_GMAC_FC_ADV_ASM_EN;
 		}
 	} else {
@@ -6632,8 +6631,7 @@ static void mvpp2_acpi_start(struct mvpp2_port *port)
 			   port->phy_interface);
 	mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
 	port->phylink_pcs.ops->pcs_config(&port->phylink_pcs, MLO_AN_INBAND,
-					  port->phy_interface,
-					  state.advertising, false);
+					  &state);
 	mvpp2_mac_finish(&port->phylink_config, MLO_AN_INBAND,
 			 port->phy_interface);
 	mvpp2_mac_link_up(&port->phylink_config, NULL,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
index b66a9aa00ea4..dc3dda2fad14 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
@@ -86,19 +86,17 @@ static void lan966x_pcs_get_state(struct phylink_pcs *pcs,
 
 static int lan966x_pcs_config(struct phylink_pcs *pcs,
 			      unsigned int mode,
-			      phy_interface_t interface,
-			      const unsigned long *advertising,
-			      bool permit_pause_to_mac)
+			      const struct phylink_link_state *state)
 {
 	struct lan966x_port *port = lan966x_pcs_to_port(pcs);
 	struct lan966x_port_config config;
 	int ret;
 
 	config = port->config;
-	config.portmode = interface;
+	config.portmode = state->interface;
 	config.inband = phylink_autoneg_inband(mode);
-	config.autoneg = phylink_test(advertising, Autoneg);
-	config.advertising = advertising;
+	config.autoneg = phylink_test(state->advertising, Autoneg);
+	config.advertising = state->advertising;
 
 	ret = lan966x_port_pcs_set(port, &config);
 	if (ret)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
index 8ba33bc1a001..07500502d5be 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
@@ -84,9 +84,7 @@ static void sparx5_pcs_get_state(struct phylink_pcs *pcs,
 
 static int sparx5_pcs_config(struct phylink_pcs *pcs,
 			     unsigned int mode,
-			     phy_interface_t interface,
-			     const unsigned long *advertising,
-			     bool permit_pause_to_mac)
+			     const struct phylink_link_state *state)
 {
 	struct sparx5_port *port = sparx5_pcs_to_port(pcs);
 	struct sparx5_port_config conf;
@@ -94,16 +92,16 @@ static int sparx5_pcs_config(struct phylink_pcs *pcs,
 
 	conf = port->conf;
 	conf.power_down = false;
-	conf.portmode = interface;
+	conf.portmode = state->interface;
 	conf.inband = phylink_autoneg_inband(mode);
-	conf.autoneg = phylink_test(advertising, Autoneg);
+	conf.autoneg = phylink_test(state->advertising, Autoneg);
 	conf.pause_adv = 0;
-	if (phylink_test(advertising, Pause))
+	if (phylink_test(state->advertising, Pause))
 		conf.pause_adv |= ADVERTISE_1000XPAUSE;
-	if (phylink_test(advertising, Asym_Pause))
+	if (phylink_test(state->advertising, Asym_Pause))
 		conf.pause_adv |= ADVERTISE_1000XPSE_ASYM;
-	if (sparx5_is_baser(interface)) {
-		if (phylink_test(advertising, FIBRE))
+	if (sparx5_is_baser(state->interface)) {
+		if (phylink_test(state->advertising, FIBRE))
 			conf.media = PHY_MEDIA_SR;
 		else
 			conf.media = PHY_MEDIA_DAC;
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index af36cd647bf5..7b5351885b4d 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -182,18 +182,18 @@ static int lynx_pcs_config_usxgmii(struct mdio_device *pcs, unsigned int mode,
 }
 
 static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
-			   phy_interface_t ifmode,
-			   const unsigned long *advertising,
-			   bool permit)
+			   const struct phylink_link_state *state)
 {
 	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
 
-	switch (ifmode) {
+	switch (state->interface) {
 	case PHY_INTERFACE_MODE_1000BASEX:
-		return lynx_pcs_config_1000basex(lynx->mdio, mode, advertising);
+		return lynx_pcs_config_1000basex(lynx->mdio, mode,
+						 state->advertising);
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
-		return lynx_pcs_config_sgmii(lynx->mdio, mode, advertising);
+		return lynx_pcs_config_sgmii(lynx->mdio, mode,
+					     state->advertising);
 	case PHY_INTERFACE_MODE_2500BASEX:
 		if (phylink_autoneg_inband(mode)) {
 			dev_err(&lynx->mdio->dev,
@@ -202,7 +202,8 @@ static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		}
 		break;
 	case PHY_INTERFACE_MODE_USXGMII:
-		return lynx_pcs_config_usxgmii(lynx->mdio, mode, advertising);
+		return lynx_pcs_config_usxgmii(lynx->mdio, mode,
+					       state->advertising);
 	case PHY_INTERFACE_MODE_10GBASER:
 		/* Nothing to do here for 10GBASER */
 		break;
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index cd6742e6ba8b..5eceb84573cb 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -831,13 +831,11 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 EXPORT_SYMBOL_GPL(xpcs_do_config);
 
 static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
-		       phy_interface_t interface,
-		       const unsigned long *advertising,
-		       bool permit_pause_to_mac)
+		       const struct phylink_link_state *state)
 {
 	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
 
-	return xpcs_do_config(xpcs, interface, mode);
+	return xpcs_do_config(xpcs, state->interface, mode);
 }
 
 static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 20df8af3e201..d47570365b93 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -768,10 +768,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 
 	if (pl->pcs_ops) {
 		err = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
-					      state->interface,
-					      state->advertising,
-					      !!(pl->link_config.pause &
-						 MLO_PAUSE_AN));
+					      state);
 		if (err < 0)
 			phylink_err(pl, "pcs_config failed: %pe\n",
 				    ERR_PTR(err));
@@ -821,9 +818,7 @@ static int phylink_change_inband_advert(struct phylink *pl)
 	 * the programmed advertisement has changed.
 	 */
 	ret = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
-				      pl->link_config.interface,
-				      pl->link_config.advertising,
-				      !!(pl->link_config.pause & MLO_PAUSE_AN));
+				      &pl->link_config);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index a2f266cc3442..d3d09c064596 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -408,9 +408,7 @@ struct phylink_pcs_ops {
 	void (*pcs_get_state)(struct phylink_pcs *pcs,
 			      struct phylink_link_state *state);
 	int (*pcs_config)(struct phylink_pcs *pcs, unsigned int mode,
-			  phy_interface_t interface,
-			  const unsigned long *advertising,
-			  bool permit_pause_to_mac);
+			  const struct phylink_link_state *state);
 	void (*pcs_an_restart)(struct phylink_pcs *pcs);
 	void (*pcs_link_up)(struct phylink_pcs *pcs, unsigned int mode,
 			    phy_interface_t interface, int speed, int duplex);
@@ -439,13 +437,10 @@ void pcs_get_state(struct phylink_pcs *pcs,
  * pcs_config() - Configure the PCS mode and advertisement
  * @pcs: a pointer to a &struct phylink_pcs.
  * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
- * @interface: interface mode to be used
- * @advertising: adertisement ethtool link mode mask
- * @permit_pause_to_mac: permit forwarding pause resolution to MAC
+ * @state: the state to configure, containing the interface and advertisement
  *
  * Configure the PCS for the operating mode, the interface mode, and set
- * the advertisement mask. @permit_pause_to_mac indicates whether the
- * hardware may forward the pause mode resolution to the MAC.
+ * the advertisement mask.
  *
  * When operating in %MLO_AN_INBAND, inband should always be enabled,
  * otherwise inband should be disabled.
@@ -458,8 +453,7 @@ void pcs_get_state(struct phylink_pcs *pcs,
  * For most 10GBASE-R, there is no advertisement.
  */
 int pcs_config(struct phylink_pcs *pcs, unsigned int mode,
-	       phy_interface_t interface, const unsigned long *advertising,
-	       bool permit_pause_to_mac);
+	       const struct phylink_link_state *state);
 
 /**
  * pcs_an_restart() - restart 802.3z BaseX autonegotiation
-- 
2.25.1

