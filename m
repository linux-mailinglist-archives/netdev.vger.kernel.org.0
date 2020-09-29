Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CFD27DBFE
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgI2W2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:31 -0400
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:50784
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728041AbgI2W2b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAwqf51dysUAZe/Or+67xr3BSBUq+Mdoy6cpKhoNSvmnmMM3/rLAI7b2e3H2JNHRkChEaAubnSBd2N4wVV/9Lhb5lgl6WqkkQJOJ9BHLUBpSaKjvdzeHGEIGospqaSkQaqp/PJYqMl03MxoEsmmqD+E+FQand8AV1k4Na7EDMVhgWGFr5HxY3ddoSCyIaPTslicPbtwRho9OqqwDTyaU19Ldi72+XQTtGl3/NiiJyoGYTaAYL6RSB4syYrdIEK6HMcoZOVN8P4sVgtwq9QyZtQF/sOa3uH9gA4PRDCjXt9GnKiei2fMiHSNV92q68MWkQYM77Fc6HZMrlVINUYbaUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCAy5YHcTAagX4xXIVxr3bmxxqZAH52/UruPELh6XXI=;
 b=ECzb9FcU3tRrDIvnRJdYr7JvGoGgzr6nONOZlZnUBRXRPLLhK9lMTb4QaGxOHtzwzoI3vVktgmJuKHmxmihz4uH4uUvo/tXhpljq+saqUeyg4ldcynpo9VfX5Ej1CEy/fTHtMC9We0vmCMYYPmGoXTRc64Bsm9Ld00J3NayfDRjvxgn9ZgdlA0yYpTguoStBdxFV2GUTRfv4IJa/lSyyAwy2dLNxA4XNauSHUfcGOTPRjQbi4EJ5vnKahgnlz/25mIuJBVvuLlYlxVpeFOUvWt4jfhFkau65ukmm5IOzkCUTWgfYJYdN8uWHWWCNmX754xZ53rtzSBDmGmFY+FwVYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCAy5YHcTAagX4xXIVxr3bmxxqZAH52/UruPELh6XXI=;
 b=oMBfJIE/2cBVGn9ZfIMNFEGB9PxBc+KsApHgd3oKwNV1UyTUXswxvkdrPPt5zNIN3J7rEFqyp+PISxdB+M1faQKzIGhRNzxPmKtw7lAcqhbuYxP7gvV25PnXc0wLr24OxIuNc7oAoXD1au5n6SlxP3QiSLChGQuGbHZHMKA+3xY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:28:01 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:28:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 04/13] net: mscc: ocelot: add definitions for VCAP IS1 keys, actions and target
Date:   Wed, 30 Sep 2020 01:27:24 +0300
Message-Id: <20200929222733.770926-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929222733.770926-1-vladimir.oltean@nxp.com>
References: <20200929222733.770926-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:28:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4db46c13-fc05-40e8-247c-08d864c6ecd5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797065F0952547ACD5FBF97E0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NqflVmtbZTJsC4czQkJeP0hM8Gr/Zl/onvWrWo+fE/6Z5Mh5vMP72RL9BF50WoCdTZjoaBEWFkDtRXNtOSzssqeNbt7s5LqCn+rRxAbAQ+fGATgrZLiEE+BOCNdJuLqgUqHM2WVJh0zd1puJNJM01Z9UEKhDQN4WUiiKQbdWVVWh8gb87YMGqDH+qRgefyrkqVoRqFLwTygI89YmcSoPinLXV4W0kTMr5Re7sV3egpVY0ADprUYFuJ/O7Av/ooGb2cUi5dU0lSXlr9M2ObWpdgtsCbrT9vpw1IB+DUNyzg+sZQCeW+DIW9r7ZRbF1P+ObFpg9wHTKDyALBkbOxHtXr/RutdmYZHNVgFlvpwLbdgRAeu1THGV5CYlQx1lUHtDu6lIoOTM++HKJC1E9hCrU8mqNJWMsMSzacSiK7vNxPbM9rcBsZA+A2SzXxn+A8zR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(30864003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: a7Z+5mV6yleHpwHY7XDsK3//FSrN747EbDJ9ZZaYZTLvITJAUbYIGU1ZK19QkblUCOVPJt9vx2XpU1KSpVxGfIcewHGbPQify2609nF42uDUDqviqr95ikdPF9IuFSEqT/PAt3Gki9PYuwNg/HQ5JsZV6481UwU4th8VErCxRTdnAHQkWyrVsoef959E1RwbeBjVVbj0Z1jtHeJYh2b6UwgEYonGR+iJbROuasONKB8yv9aE2Rh4t6hCwtIM9PvMNgXbCppKVPYjx4umSvn7F2SpmNRJDYghGg9B3g5pab6pVB2iwK4HfX6mh5DIqlvNGhyK4HJWu534w3NKHY4TA8b5Y1VYuAy1DxxuP5a+nKmdrCJ+mGca8joV2rD9nWXNWjHWNAsmYjMYdw4Ue6SOxSoVbf9XZF1cDhp76VrxmxO47BDbmHUibg9BK66DAFmBysiVVFE0Tvmv9jeDkUtYf+QO37JS0x9ccSauKKpXxOj3MZJLM/eJ4COUJJMwTY2ftnLByMz9ZgmDtRs5iq6A1L2UgF3e4QaznQoLH9gWVXgf1vOFT5oOy6J1/TVgbaukrfioxFnSSue3kjA26EPnw5wGG3DZPyc8WxVicLXxze34U9OpHyFBVpxZCwnPBMyPQf3dY/zEYVijtePRY1mNHA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db46c13-fc05-40e8-247c-08d864c6ecd5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:28:01.6086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5R0Nsbog53GJZ+sQ+NgIFF0BftAorTzxaeTH3XYgkOGer0fpekRHmDwvoz1m2oW7lHLXalfBrfnocRPiVXkhew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation step for the offloading to IS1, let's create the
infrastructure for talking with this hardware block.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC v2:
Shuffled patch order.

Changes since RFC v1:
Added definitions for VSC9953 and VSC7514.

 arch/mips/boot/dts/mscc/ocelot.dtsi        |  3 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 92 +++++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 92 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 88 ++++++++++++++++++++
 include/soc/mscc/ocelot.h                  |  1 +
 include/soc/mscc/ocelot_vcap.h             | 93 +++++++++++++++++++++-
 6 files changed, 367 insertions(+), 2 deletions(-)

diff --git a/arch/mips/boot/dts/mscc/ocelot.dtsi b/arch/mips/boot/dts/mscc/ocelot.dtsi
index f94e8a02ed06..70c74860b822 100644
--- a/arch/mips/boot/dts/mscc/ocelot.dtsi
+++ b/arch/mips/boot/dts/mscc/ocelot.dtsi
@@ -134,11 +134,12 @@ switch@1010000 {
 			      <0x1280000 0x100>,
 			      <0x1800000 0x80000>,
 			      <0x1880000 0x10000>,
+			      <0x1050000 0x10000>,
 			      <0x1060000 0x10000>;
 			reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
 				    "port2", "port3", "port4", "port5", "port6",
 				    "port7", "port8", "port9", "port10", "qsys",
-				    "ana", "s2";
+				    "ana", "s1", "s2";
 			interrupts = <18 21 22>;
 			interrupt-names = "ptp_rdy", "xtr", "inj";
 
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 46ee83dbafbf..460cdef4b50b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -361,6 +361,7 @@ static const u32 *vsc9959_regmap[TARGET_MAX] = {
 	[QSYS]	= vsc9959_qsys_regmap,
 	[REW]	= vsc9959_rew_regmap,
 	[SYS]	= vsc9959_sys_regmap,
+	[S1]	= vsc9959_vcap_regmap,
 	[S2]	= vsc9959_vcap_regmap,
 	[PTP]	= vsc9959_ptp_regmap,
 	[GCB]	= vsc9959_gcb_regmap,
@@ -394,6 +395,11 @@ static const struct resource vsc9959_target_io_res[TARGET_MAX] = {
 		.end	= 0x001ffff,
 		.name	= "sys",
 	},
+	[S1] = {
+		.start	= 0x0050000,
+		.end	= 0x00503ff,
+		.name	= "s1",
+	},
 	[S2] = {
 		.start	= 0x0060000,
 		.end	= 0x00603ff,
@@ -598,6 +604,80 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x111,	.name = "drop_green_prio_7", },
 };
 
+static const struct vcap_field vsc9959_vcap_is1_keys[] = {
+	[VCAP_IS1_HK_TYPE]			= {  0,   1},
+	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
+	[VCAP_IS1_HK_IGR_PORT_MASK]		= {  3,   7},
+	[VCAP_IS1_HK_RSV]			= { 10,   9},
+	[VCAP_IS1_HK_OAM_Y1731]			= { 19,   1},
+	[VCAP_IS1_HK_L2_MC]			= { 20,   1},
+	[VCAP_IS1_HK_L2_BC]			= { 21,   1},
+	[VCAP_IS1_HK_IP_MC]			= { 22,   1},
+	[VCAP_IS1_HK_VLAN_TAGGED]		= { 23,   1},
+	[VCAP_IS1_HK_VLAN_DBL_TAGGED]		= { 24,   1},
+	[VCAP_IS1_HK_TPID]			= { 25,   1},
+	[VCAP_IS1_HK_VID]			= { 26,  12},
+	[VCAP_IS1_HK_DEI]			= { 38,   1},
+	[VCAP_IS1_HK_PCP]			= { 39,   3},
+	/* Specific Fields for IS1 Half Key S1_NORMAL */
+	[VCAP_IS1_HK_L2_SMAC]			= { 42,  48},
+	[VCAP_IS1_HK_ETYPE_LEN]			= { 90,   1},
+	[VCAP_IS1_HK_ETYPE]			= { 91,  16},
+	[VCAP_IS1_HK_IP_SNAP]			= {107,   1},
+	[VCAP_IS1_HK_IP4]			= {108,   1},
+	/* Layer-3 Information */
+	[VCAP_IS1_HK_L3_FRAGMENT]		= {109,   1},
+	[VCAP_IS1_HK_L3_FRAG_OFS_GT0]		= {110,   1},
+	[VCAP_IS1_HK_L3_OPTIONS]		= {111,   1},
+	[VCAP_IS1_HK_L3_DSCP]			= {112,   6},
+	[VCAP_IS1_HK_L3_IP4_SIP]		= {118,  32},
+	/* Layer-4 Information */
+	[VCAP_IS1_HK_TCP_UDP]			= {150,   1},
+	[VCAP_IS1_HK_TCP]			= {151,   1},
+	[VCAP_IS1_HK_L4_SPORT]			= {152,  16},
+	[VCAP_IS1_HK_L4_RNG]			= {168,   8},
+	/* Specific Fields for IS1 Half Key S1_5TUPLE_IP4 */
+	[VCAP_IS1_HK_IP4_INNER_TPID]            = { 42,   1},
+	[VCAP_IS1_HK_IP4_INNER_VID]		= { 43,  12},
+	[VCAP_IS1_HK_IP4_INNER_DEI]		= { 55,   1},
+	[VCAP_IS1_HK_IP4_INNER_PCP]		= { 56,   3},
+	[VCAP_IS1_HK_IP4_IP4]			= { 59,   1},
+	[VCAP_IS1_HK_IP4_L3_FRAGMENT]		= { 60,   1},
+	[VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0]	= { 61,   1},
+	[VCAP_IS1_HK_IP4_L3_OPTIONS]		= { 62,   1},
+	[VCAP_IS1_HK_IP4_L3_DSCP]		= { 63,   6},
+	[VCAP_IS1_HK_IP4_L3_IP4_DIP]		= { 69,  32},
+	[VCAP_IS1_HK_IP4_L3_IP4_SIP]		= {101,  32},
+	[VCAP_IS1_HK_IP4_L3_PROTO]		= {133,   8},
+	[VCAP_IS1_HK_IP4_TCP_UDP]		= {141,   1},
+	[VCAP_IS1_HK_IP4_TCP]			= {142,   1},
+	[VCAP_IS1_HK_IP4_L4_RNG]		= {143,   8},
+	[VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE]	= {151,  32},
+};
+
+static const struct vcap_field vsc9959_vcap_is1_actions[] = {
+	[VCAP_IS1_ACT_DSCP_ENA]			= {  0,  1},
+	[VCAP_IS1_ACT_DSCP_VAL]			= {  1,  6},
+	[VCAP_IS1_ACT_QOS_ENA]			= {  7,  1},
+	[VCAP_IS1_ACT_QOS_VAL]			= {  8,  3},
+	[VCAP_IS1_ACT_DP_ENA]			= { 11,  1},
+	[VCAP_IS1_ACT_DP_VAL]			= { 12,  1},
+	[VCAP_IS1_ACT_PAG_OVERRIDE_MASK]	= { 13,  8},
+	[VCAP_IS1_ACT_PAG_VAL]			= { 21,  8},
+	[VCAP_IS1_ACT_RSV]			= { 29,  9},
+	[VCAP_IS1_ACT_VID_REPLACE_ENA]		= { 38,  1},
+	[VCAP_IS1_ACT_VID_ADD_VAL]		= { 39, 12},
+	[VCAP_IS1_ACT_FID_SEL]			= { 51,  2},
+	[VCAP_IS1_ACT_FID_VAL]			= { 53, 13},
+	[VCAP_IS1_ACT_PCP_DEI_ENA]		= { 66,  1},
+	[VCAP_IS1_ACT_PCP_VAL]			= { 67,  3},
+	[VCAP_IS1_ACT_DEI_VAL]			= { 70,  1},
+	[VCAP_IS1_ACT_VLAN_POP_CNT_ENA]		= { 71,  1},
+	[VCAP_IS1_ACT_VLAN_POP_CNT]		= { 72,  2},
+	[VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA]	= { 74,  4},
+	[VCAP_IS1_ACT_HIT_STICKY]		= { 78,  1},
+};
+
 static struct vcap_field vsc9959_vcap_is2_keys[] = {
 	/* Common: 41 bits */
 	[VCAP_IS2_TYPE]				= {  0,   4},
@@ -697,6 +777,18 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 };
 
 static const struct vcap_props vsc9959_vcap_props[] = {
+	[VCAP_IS1] = {
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 78, /* HIT_STICKY not included */
+				.count = 4,
+			},
+		},
+		.target = S1,
+		.keys = vsc9959_vcap_is1_keys,
+		.actions = vsc9959_vcap_is1_actions,
+	},
 	[VCAP_IS2] = {
 		.tg_width = 2,
 		.sw_count = 4,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 3d9692892395..50484fdbc69a 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -354,6 +354,7 @@ static const u32 *vsc9953_regmap[TARGET_MAX] = {
 	[QSYS]		= vsc9953_qsys_regmap,
 	[REW]		= vsc9953_rew_regmap,
 	[SYS]		= vsc9953_sys_regmap,
+	[S1]		= vsc9953_vcap_regmap,
 	[S2]		= vsc9953_vcap_regmap,
 	[GCB]		= vsc9953_gcb_regmap,
 	[DEV_GMII]	= vsc9953_dev_gmii_regmap,
@@ -386,6 +387,11 @@ static const struct resource vsc9953_target_io_res[TARGET_MAX] = {
 		.end	= 0x001ffff,
 		.name	= "sys",
 	},
+	[S1] = {
+		.start	= 0x0050000,
+		.end	= 0x00503ff,
+		.name	= "s1",
+	},
 	[S2] = {
 		.start	= 0x0060000,
 		.end	= 0x00603ff,
@@ -601,6 +607,80 @@ static const struct ocelot_stat_layout vsc9953_stats_layout[] = {
 	{ .offset = 0x91,	.name = "drop_green_prio_7", },
 };
 
+static const struct vcap_field vsc9953_vcap_is1_keys[] = {
+	[VCAP_IS1_HK_TYPE]			= {  0,   1},
+	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
+	[VCAP_IS1_HK_IGR_PORT_MASK]		= {  3,  11},
+	[VCAP_IS1_HK_RSV]			= { 14,  10},
+	/* VCAP_IS1_HK_OAM_Y1731 not supported */
+	[VCAP_IS1_HK_L2_MC]			= { 24,   1},
+	[VCAP_IS1_HK_L2_BC]			= { 25,   1},
+	[VCAP_IS1_HK_IP_MC]			= { 26,   1},
+	[VCAP_IS1_HK_VLAN_TAGGED]		= { 27,   1},
+	[VCAP_IS1_HK_VLAN_DBL_TAGGED]		= { 28,   1},
+	[VCAP_IS1_HK_TPID]			= { 29,   1},
+	[VCAP_IS1_HK_VID]			= { 30,  12},
+	[VCAP_IS1_HK_DEI]			= { 42,   1},
+	[VCAP_IS1_HK_PCP]			= { 43,   3},
+	/* Specific Fields for IS1 Half Key S1_NORMAL */
+	[VCAP_IS1_HK_L2_SMAC]			= { 46,  48},
+	[VCAP_IS1_HK_ETYPE_LEN]			= { 94,   1},
+	[VCAP_IS1_HK_ETYPE]			= { 95,  16},
+	[VCAP_IS1_HK_IP_SNAP]			= {111,   1},
+	[VCAP_IS1_HK_IP4]			= {112,   1},
+	/* Layer-3 Information */
+	[VCAP_IS1_HK_L3_FRAGMENT]		= {113,   1},
+	[VCAP_IS1_HK_L3_FRAG_OFS_GT0]		= {114,   1},
+	[VCAP_IS1_HK_L3_OPTIONS]		= {115,   1},
+	[VCAP_IS1_HK_L3_DSCP]			= {116,   6},
+	[VCAP_IS1_HK_L3_IP4_SIP]		= {122,  32},
+	/* Layer-4 Information */
+	[VCAP_IS1_HK_TCP_UDP]			= {154,   1},
+	[VCAP_IS1_HK_TCP]			= {155,   1},
+	[VCAP_IS1_HK_L4_SPORT]			= {156,  16},
+	[VCAP_IS1_HK_L4_RNG]			= {172,   8},
+	/* Specific Fields for IS1 Half Key S1_5TUPLE_IP4 */
+	[VCAP_IS1_HK_IP4_INNER_TPID]            = { 46,   1},
+	[VCAP_IS1_HK_IP4_INNER_VID]		= { 47,  12},
+	[VCAP_IS1_HK_IP4_INNER_DEI]		= { 59,   1},
+	[VCAP_IS1_HK_IP4_INNER_PCP]		= { 60,   3},
+	[VCAP_IS1_HK_IP4_IP4]			= { 63,   1},
+	[VCAP_IS1_HK_IP4_L3_FRAGMENT]		= { 64,   1},
+	[VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0]	= { 65,   1},
+	[VCAP_IS1_HK_IP4_L3_OPTIONS]		= { 66,   1},
+	[VCAP_IS1_HK_IP4_L3_DSCP]		= { 67,   6},
+	[VCAP_IS1_HK_IP4_L3_IP4_DIP]		= { 73,  32},
+	[VCAP_IS1_HK_IP4_L3_IP4_SIP]		= {105,  32},
+	[VCAP_IS1_HK_IP4_L3_PROTO]		= {137,   8},
+	[VCAP_IS1_HK_IP4_TCP_UDP]		= {145,   1},
+	[VCAP_IS1_HK_IP4_TCP]			= {146,   1},
+	[VCAP_IS1_HK_IP4_L4_RNG]		= {147,   8},
+	[VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE]	= {155,  32},
+};
+
+static const struct vcap_field vsc9953_vcap_is1_actions[] = {
+	[VCAP_IS1_ACT_DSCP_ENA]			= {  0,  1},
+	[VCAP_IS1_ACT_DSCP_VAL]			= {  1,  6},
+	[VCAP_IS1_ACT_QOS_ENA]			= {  7,  1},
+	[VCAP_IS1_ACT_QOS_VAL]			= {  8,  3},
+	[VCAP_IS1_ACT_DP_ENA]			= { 11,  1},
+	[VCAP_IS1_ACT_DP_VAL]			= { 12,  1},
+	[VCAP_IS1_ACT_PAG_OVERRIDE_MASK]	= { 13,  8},
+	[VCAP_IS1_ACT_PAG_VAL]			= { 21,  8},
+	[VCAP_IS1_ACT_RSV]			= { 29, 11},
+	[VCAP_IS1_ACT_VID_REPLACE_ENA]		= { 40,  1},
+	[VCAP_IS1_ACT_VID_ADD_VAL]		= { 41, 12},
+	[VCAP_IS1_ACT_FID_SEL]			= { 53,  2},
+	[VCAP_IS1_ACT_FID_VAL]			= { 55, 13},
+	[VCAP_IS1_ACT_PCP_DEI_ENA]		= { 68,  1},
+	[VCAP_IS1_ACT_PCP_VAL]			= { 69,  3},
+	[VCAP_IS1_ACT_DEI_VAL]			= { 72,  1},
+	[VCAP_IS1_ACT_VLAN_POP_CNT_ENA]		= { 73,  1},
+	[VCAP_IS1_ACT_VLAN_POP_CNT]		= { 74,  2},
+	[VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA]	= { 76,  4},
+	[VCAP_IS1_ACT_HIT_STICKY]		= { 80,  1},
+};
+
 static struct vcap_field vsc9953_vcap_is2_keys[] = {
 	/* Common: 41 bits */
 	[VCAP_IS2_TYPE]				= {  0,   4},
@@ -687,6 +767,18 @@ static struct vcap_field vsc9953_vcap_is2_actions[] = {
 };
 
 static const struct vcap_props vsc9953_vcap_props[] = {
+	[VCAP_IS1] = {
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 80, /* HIT_STICKY not included */
+				.count = 4,
+			},
+		},
+		.target = S1,
+		.keys = vsc9953_vcap_is1_keys,
+		.actions = vsc9953_vcap_is1_actions,
+	},
 	[VCAP_IS2] = {
 		.tg_width = 2,
 		.sw_count = 4,
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index f9b7673dab2e..4bb3f7f62029 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -758,6 +758,81 @@ static const struct ocelot_ops ocelot_ops = {
 	.wm_enc			= ocelot_wm_enc,
 };
 
+static const struct vcap_field vsc7514_vcap_is1_keys[] = {
+	[VCAP_IS1_HK_TYPE]			= {  0,   1},
+	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
+	[VCAP_IS1_HK_IGR_PORT_MASK]		= {  3,  12},
+	[VCAP_IS1_HK_RSV]			= { 15,   9},
+	[VCAP_IS1_HK_OAM_Y1731]			= { 24,   1},
+	[VCAP_IS1_HK_L2_MC]			= { 25,   1},
+	[VCAP_IS1_HK_L2_BC]			= { 26,   1},
+	[VCAP_IS1_HK_IP_MC]			= { 27,   1},
+	[VCAP_IS1_HK_VLAN_TAGGED]		= { 28,   1},
+	[VCAP_IS1_HK_VLAN_DBL_TAGGED]		= { 29,   1},
+	[VCAP_IS1_HK_TPID]			= { 30,   1},
+	[VCAP_IS1_HK_VID]			= { 31,  12},
+	[VCAP_IS1_HK_DEI]			= { 43,   1},
+	[VCAP_IS1_HK_PCP]			= { 44,   3},
+	/* Specific Fields for IS1 Half Key S1_NORMAL */
+	[VCAP_IS1_HK_L2_SMAC]			= { 47,  48},
+	[VCAP_IS1_HK_ETYPE_LEN]			= { 95,   1},
+	[VCAP_IS1_HK_ETYPE]			= { 96,  16},
+	[VCAP_IS1_HK_IP_SNAP]			= {112,   1},
+	[VCAP_IS1_HK_IP4]			= {113,   1},
+	/* Layer-3 Information */
+	[VCAP_IS1_HK_L3_FRAGMENT]		= {114,   1},
+	[VCAP_IS1_HK_L3_FRAG_OFS_GT0]		= {115,   1},
+	[VCAP_IS1_HK_L3_OPTIONS]		= {116,   1},
+	[VCAP_IS1_HK_L3_DSCP]			= {117,   6},
+	[VCAP_IS1_HK_L3_IP4_SIP]		= {123,  32},
+	/* Layer-4 Information */
+	[VCAP_IS1_HK_TCP_UDP]			= {155,   1},
+	[VCAP_IS1_HK_TCP]			= {156,   1},
+	[VCAP_IS1_HK_L4_SPORT]			= {157,  16},
+	[VCAP_IS1_HK_L4_RNG]			= {173,   8},
+	/* Specific Fields for IS1 Half Key S1_5TUPLE_IP4 */
+	[VCAP_IS1_HK_IP4_INNER_TPID]            = { 47,   1},
+	[VCAP_IS1_HK_IP4_INNER_VID]		= { 48,  12},
+	[VCAP_IS1_HK_IP4_INNER_DEI]		= { 60,   1},
+	[VCAP_IS1_HK_IP4_INNER_PCP]		= { 61,   3},
+	[VCAP_IS1_HK_IP4_IP4]			= { 64,   1},
+	[VCAP_IS1_HK_IP4_L3_FRAGMENT]		= { 65,   1},
+	[VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0]	= { 66,   1},
+	[VCAP_IS1_HK_IP4_L3_OPTIONS]		= { 67,   1},
+	[VCAP_IS1_HK_IP4_L3_DSCP]		= { 68,   6},
+	[VCAP_IS1_HK_IP4_L3_IP4_DIP]		= { 74,  32},
+	[VCAP_IS1_HK_IP4_L3_IP4_SIP]		= {106,  32},
+	[VCAP_IS1_HK_IP4_L3_PROTO]		= {138,   8},
+	[VCAP_IS1_HK_IP4_TCP_UDP]		= {146,   1},
+	[VCAP_IS1_HK_IP4_TCP]			= {147,   1},
+	[VCAP_IS1_HK_IP4_L4_RNG]		= {148,   8},
+	[VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE]	= {156,  32},
+};
+
+static const struct vcap_field vsc7514_vcap_is1_actions[] = {
+	[VCAP_IS1_ACT_DSCP_ENA]			= {  0,  1},
+	[VCAP_IS1_ACT_DSCP_VAL]			= {  1,  6},
+	[VCAP_IS1_ACT_QOS_ENA]			= {  7,  1},
+	[VCAP_IS1_ACT_QOS_VAL]			= {  8,  3},
+	[VCAP_IS1_ACT_DP_ENA]			= { 11,  1},
+	[VCAP_IS1_ACT_DP_VAL]			= { 12,  1},
+	[VCAP_IS1_ACT_PAG_OVERRIDE_MASK]	= { 13,  8},
+	[VCAP_IS1_ACT_PAG_VAL]			= { 21,  8},
+	[VCAP_IS1_ACT_RSV]			= { 29,  9},
+	/* The fields below are incorrectly shifted by 2 in the manual */
+	[VCAP_IS1_ACT_VID_REPLACE_ENA]		= { 38,  1},
+	[VCAP_IS1_ACT_VID_ADD_VAL]		= { 39, 12},
+	[VCAP_IS1_ACT_FID_SEL]			= { 51,  2},
+	[VCAP_IS1_ACT_FID_VAL]			= { 53, 13},
+	[VCAP_IS1_ACT_PCP_DEI_ENA]		= { 66,  1},
+	[VCAP_IS1_ACT_PCP_VAL]			= { 67,  3},
+	[VCAP_IS1_ACT_DEI_VAL]			= { 70,  1},
+	[VCAP_IS1_ACT_VLAN_POP_CNT_ENA]		= { 71,  1},
+	[VCAP_IS1_ACT_VLAN_POP_CNT]		= { 72,  2},
+	[VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA]	= { 74,  4},
+	[VCAP_IS1_ACT_HIT_STICKY]		= { 78,  1},
+};
+
 static const struct vcap_field vsc7514_vcap_is2_keys[] = {
 	/* Common: 46 bits */
 	[VCAP_IS2_TYPE]				= {  0,   4},
@@ -857,6 +932,18 @@ static const struct vcap_field vsc7514_vcap_is2_actions[] = {
 };
 
 static const struct vcap_props vsc7514_vcap_props[] = {
+	[VCAP_IS1] = {
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 78, /* HIT_STICKY not included */
+				.count = 4,
+			},
+		},
+		.target = S1,
+		.keys = vsc7514_vcap_is1_keys,
+		.actions = vsc7514_vcap_is1_actions,
+	},
 	[VCAP_IS2] = {
 		.tg_width = 2,
 		.sw_count = 4,
@@ -1042,6 +1129,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		{ QSYS, "qsys" },
 		{ ANA, "ana" },
 		{ QS, "qs" },
+		{ S1, "s1" },
 		{ S2, "s2" },
 		{ PTP, "ptp", 1 },
 	};
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 728b040e4e3e..d0073c94e22a 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -123,6 +123,7 @@ enum ocelot_target {
 	QSYS,
 	REW,
 	SYS,
+	S1,
 	S2,
 	HSIO,
 	PTP,
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 05466a1d7bd4..7ac184047292 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -14,7 +14,7 @@
  */
 
 enum {
-	/* VCAP_IS1, */
+	VCAP_IS1,
 	VCAP_IS2,
 	/* VCAP_ES0, */
 };
@@ -264,4 +264,95 @@ enum vcap_is2_action_field {
 	VCAP_IS2_ACT_HIT_CNT,
 };
 
+/* =================================================================
+ *  VCAP IS1
+ * =================================================================
+ */
+
+/* IS1 half key types */
+#define IS1_TYPE_S1_NORMAL 0
+#define IS1_TYPE_S1_5TUPLE_IP4 1
+
+/* IS1 full key types */
+#define IS1_TYPE_S1_NORMAL_IP6 0
+#define IS1_TYPE_S1_7TUPLE 1
+#define IS2_TYPE_S1_5TUPLE_IP6 2
+
+enum {
+	IS1_ACTION_TYPE_NORMAL,
+	IS1_ACTION_TYPE_MAX,
+};
+
+enum vcap_is1_half_key_field {
+	VCAP_IS1_HK_TYPE,
+	VCAP_IS1_HK_LOOKUP,
+	VCAP_IS1_HK_IGR_PORT_MASK,
+	VCAP_IS1_HK_RSV,
+	VCAP_IS1_HK_OAM_Y1731,
+	VCAP_IS1_HK_L2_MC,
+	VCAP_IS1_HK_L2_BC,
+	VCAP_IS1_HK_IP_MC,
+	VCAP_IS1_HK_VLAN_TAGGED,
+	VCAP_IS1_HK_VLAN_DBL_TAGGED,
+	VCAP_IS1_HK_TPID,
+	VCAP_IS1_HK_VID,
+	VCAP_IS1_HK_DEI,
+	VCAP_IS1_HK_PCP,
+	/* Specific Fields for IS1 Half Key S1_NORMAL */
+	VCAP_IS1_HK_L2_SMAC,
+	VCAP_IS1_HK_ETYPE_LEN,
+	VCAP_IS1_HK_ETYPE,
+	VCAP_IS1_HK_IP_SNAP,
+	VCAP_IS1_HK_IP4,
+	VCAP_IS1_HK_L3_FRAGMENT,
+	VCAP_IS1_HK_L3_FRAG_OFS_GT0,
+	VCAP_IS1_HK_L3_OPTIONS,
+	VCAP_IS1_HK_L3_DSCP,
+	VCAP_IS1_HK_L3_IP4_SIP,
+	VCAP_IS1_HK_TCP_UDP,
+	VCAP_IS1_HK_TCP,
+	VCAP_IS1_HK_L4_SPORT,
+	VCAP_IS1_HK_L4_RNG,
+	/* Specific Fields for IS1 Half Key S1_5TUPLE_IP4 */
+	VCAP_IS1_HK_IP4_INNER_TPID,
+	VCAP_IS1_HK_IP4_INNER_VID,
+	VCAP_IS1_HK_IP4_INNER_DEI,
+	VCAP_IS1_HK_IP4_INNER_PCP,
+	VCAP_IS1_HK_IP4_IP4,
+	VCAP_IS1_HK_IP4_L3_FRAGMENT,
+	VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0,
+	VCAP_IS1_HK_IP4_L3_OPTIONS,
+	VCAP_IS1_HK_IP4_L3_DSCP,
+	VCAP_IS1_HK_IP4_L3_IP4_DIP,
+	VCAP_IS1_HK_IP4_L3_IP4_SIP,
+	VCAP_IS1_HK_IP4_L3_PROTO,
+	VCAP_IS1_HK_IP4_TCP_UDP,
+	VCAP_IS1_HK_IP4_TCP,
+	VCAP_IS1_HK_IP4_L4_RNG,
+	VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE,
+};
+
+enum vcap_is1_action_field {
+	VCAP_IS1_ACT_DSCP_ENA,
+	VCAP_IS1_ACT_DSCP_VAL,
+	VCAP_IS1_ACT_QOS_ENA,
+	VCAP_IS1_ACT_QOS_VAL,
+	VCAP_IS1_ACT_DP_ENA,
+	VCAP_IS1_ACT_DP_VAL,
+	VCAP_IS1_ACT_PAG_OVERRIDE_MASK,
+	VCAP_IS1_ACT_PAG_VAL,
+	VCAP_IS1_ACT_RSV,
+	VCAP_IS1_ACT_VID_REPLACE_ENA,
+	VCAP_IS1_ACT_VID_ADD_VAL,
+	VCAP_IS1_ACT_FID_SEL,
+	VCAP_IS1_ACT_FID_VAL,
+	VCAP_IS1_ACT_PCP_DEI_ENA,
+	VCAP_IS1_ACT_PCP_VAL,
+	VCAP_IS1_ACT_DEI_VAL,
+	VCAP_IS1_ACT_VLAN_POP_CNT_ENA,
+	VCAP_IS1_ACT_VLAN_POP_CNT,
+	VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA,
+	VCAP_IS1_ACT_HIT_STICKY,
+};
+
 #endif /* _OCELOT_VCAP_H_ */
-- 
2.25.1

