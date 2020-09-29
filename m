Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED3027C20F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgI2KLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:25 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:54849
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727983AbgI2KLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Byrmxky/HDi5af8KMi1oMNlGAWbYDpZ+utwOzBr7fpL5zxPCuoXH/HFCl1VVrHiSUIDZ+uTMz+okdJ8BpEk+Ahu0dJmqQWEQwu51XvmklTG0sA8iLPcRIeZ+4MLZdXUK4jHOScdfDALikggX7iu0hZTggXNgUajf/JRr58OPPLdcNePc9M0DS9OJitV9k9x9prKiqhQQmCZxTUXY2tNusGFnZwR10rhS4HnpxXf76z9hE5SU8JzBIr5xMsJV1JIy+dmmZaoOep9iQ3ob2dKG/bLlA4LSKLVnSMUfND1E3ry2dSYU+BWYOROFiLeuPbuL7+ohOwjWYKsPfbR9cSXJ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaDQoWefW4fuK9ss7X4ZJPPl/SyAKzl5xyv54lObnYA=;
 b=XNpC729Lcpd9AmoyDbfqYE7LsZfz2rmkoZUcmjnJE7CewOp8smDKCRLaTTxDyQh+AwIwS+ygFLW91/eiM54qFGqko4dOpziDPk0eXTSzTWARsqx4uxPUuIluwI6C+VVyGdfolxIXE/yYhlU70ifGkv80SLtWV2vwgNjNZ0XueDtnyliDCFVZij1m8x1cnVTCX8+m92OqaNsjIA/GtbrcOk8vcp1srZ1ghqc3QITJCzt4t0Al7BGJ5DX0ZACkR5S1JRZP0EkX1h0dCmMgigEWYgmC/v6z/BEgeGDudAu5/oS9AY2PLFIa91FXI/kk04tP15T/PqlvQTtDBP9dUOihxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaDQoWefW4fuK9ss7X4ZJPPl/SyAKzl5xyv54lObnYA=;
 b=eM2Fb5uxqYPNwNW0wIpkZfbRS2byJDaWw6b5pCDk5lBSzUTYAxKLFlv7IbQ/DXPWnnaYH5GTmohg4D1IoVfI/5wJKCVJHK4EvWURWJJpUrrhtGlvdrxWD395RgMuotcd2Qr0ExoA3TpMNUt+AP5EkSDQ2tCNjPlEIZUNRr9EAsk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 07/21] net: mscc: ocelot: add definitions for VCAP ES0 keys, actions and target
Date:   Tue, 29 Sep 2020 13:10:02 +0300
Message-Id: <20200929101016.3743530-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eb370334-2a06-42e5-783a-08d8645feadf
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB529534E98C64AFA640FA9950E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CcVUxxcMId4yz40XB4F13H9iCLWEZUnACUOczRmVilKC8nBRuaOOIs40Py+n4snuoawmsyiOIzLrHq22ZI0hwUfi6tSeKH2EN+g68ldiC7lDCEL+gBCA+ZDU36sPlteLKrTnuhEnbPLnh3QuO2Nqr9186miZVm8GPq5uo47CPlbt4zVE+harFfbH9kraTqJTHpv3f2+JYljXIu5dwG8PmF7BbzO+FO4YFU687EWjrf53UjI4Ae2i25WK/bKooFAkYsZJrBDs8DX9y6h09Ckt6JDZ72UcUxUeA0eonl/ALXFLmp91l1EZCwbyjn3UHoBvStaaXuJog5F5si41bZ8ljSNhiTrQnXbhPtPpXQtXWyGqWBu0z0NVU6aRTjz32Xboh6HQ74S0g1MWPOTyQGqsCZtq4gymvn60mczsATfVmxjjKatgeeu0wk1mYOAUbeTB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(30864003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: f5wipNmre9R6LfM2gi2/vY3k/jK7c1SV6ZNKro4NPR2BFx631aHAZYqGZIUTrhhve7RBKP+r2u1jVwbFnpqIMoITTDabuWADfKQ8rwZV1K73m9LG9R33VaCF7i3SP8cMCcuZnWJr31RsaqHnxhPN/z6LTCwyiAIyVZbMGBasfsOti7j0vbnLAaiOu53irizt8w6qmQNniYKerQ0tiKiF5H7ifa/JP5U6c5sC+L5RTlVI1VdfcXWxxdXEvZkhNGhQgy3lS4GhFG0HsekEyumvpOZ7SQSAspprxnTzdt2eVC2vY0tmptH5LYEPG1aPbiAVm0XYXyFWIisU4bIPOBJSEbF1OuAVvVD0c3tPtHR6F+F5KSH/oFI8g7sxfD9jbaKLwJPmzAMqIrnRaJRzVbR5OTn19DNKO2PPGHRsGjzgToFZs1UVvpYUAc6GgklPcL8dUXEVZSw0eWRdUNyB3vQkx9ZtjUG1O9J6uRv2u52hZiV02+UTvY6cME6WR/TP5ymgJogxkLfssXPgTWCYMu8T0ggLSK/wIBdK3bHBABYfWYDq+nBWu+4SLPTylsMgWPlzJyjNYzi0mkqoHtUhFd1gZnurU819X5X3xoZ3PHLTE0Cq0pziN8fxwa/6z3Ol7+OQzp01R6k2DVizNOIhCdrLdA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb370334-2a06-42e5-783a-08d8645feadf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:40.0118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXMx7XfnX8mIEhnZBMNBm3gg5v7SsJRJv/eDFgk71TGbHnVnjH/S5QC0rFMoqpR85UoiDSbaKRjaH2WFyQlZkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation step for the offloading to ES0, let's create the
infrastructure for talking with this hardware block.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Added definitions for VSC9953 and VSC7514.

 arch/mips/boot/dts/mscc/ocelot.dtsi        |  3 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 50 ++++++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 50 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 45 +++++++++++++++++++
 include/soc/mscc/ocelot.h                  |  1 +
 include/soc/mscc/ocelot_vcap.h             | 44 ++++++++++++++++++-
 6 files changed, 191 insertions(+), 2 deletions(-)

diff --git a/arch/mips/boot/dts/mscc/ocelot.dtsi b/arch/mips/boot/dts/mscc/ocelot.dtsi
index 70c74860b822..535a98284dcb 100644
--- a/arch/mips/boot/dts/mscc/ocelot.dtsi
+++ b/arch/mips/boot/dts/mscc/ocelot.dtsi
@@ -134,12 +134,13 @@ switch@1010000 {
 			      <0x1280000 0x100>,
 			      <0x1800000 0x80000>,
 			      <0x1880000 0x10000>,
+			      <0x1040000 0x10000>,
 			      <0x1050000 0x10000>,
 			      <0x1060000 0x10000>;
 			reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
 				    "port2", "port3", "port4", "port5", "port6",
 				    "port7", "port8", "port9", "port10", "qsys",
-				    "ana", "s1", "s2";
+				    "ana", "s0", "s1", "s2";
 			interrupts = <18 21 22>;
 			interrupt-names = "ptp_rdy", "xtr", "inj";
 
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 5a2dc6ec98d5..de18e106edd3 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -369,6 +369,7 @@ static const u32 *vsc9959_regmap[TARGET_MAX] = {
 	[QSYS]	= vsc9959_qsys_regmap,
 	[REW]	= vsc9959_rew_regmap,
 	[SYS]	= vsc9959_sys_regmap,
+	[S0]	= vsc9959_vcap_regmap,
 	[S1]	= vsc9959_vcap_regmap,
 	[S2]	= vsc9959_vcap_regmap,
 	[PTP]	= vsc9959_ptp_regmap,
@@ -403,6 +404,11 @@ static const struct resource vsc9959_target_io_res[TARGET_MAX] = {
 		.end	= 0x001ffff,
 		.name	= "sys",
 	},
+	[S0] = {
+		.start	= 0x0040000,
+		.end	= 0x00403ff,
+		.name	= "s0",
+	},
 	[S1] = {
 		.start	= 0x0050000,
 		.end	= 0x00503ff,
@@ -612,6 +618,38 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x111,	.name = "drop_green_prio_7", },
 };
 
+static const struct vcap_field vsc9959_vcap_es0_keys[] = {
+	[VCAP_ES0_EGR_PORT]			= {  0,  3},
+	[VCAP_ES0_IGR_PORT]			= {  3,  3},
+	[VCAP_ES0_RSV]				= {  6,  2},
+	[VCAP_ES0_L2_MC]			= {  8,  1},
+	[VCAP_ES0_L2_BC]			= {  9,  1},
+	[VCAP_ES0_VID]				= { 10, 12},
+	[VCAP_ES0_DP]				= { 22,  1},
+	[VCAP_ES0_PCP]				= { 23,  3},
+};
+
+static const struct vcap_field vsc9959_vcap_es0_actions[] = {
+	[VCAP_ES0_ACT_PUSH_OUTER_TAG]		= {  0,  2},
+	[VCAP_ES0_ACT_PUSH_INNER_TAG]		= {  2,  1},
+	[VCAP_ES0_ACT_TAG_A_TPID_SEL]		= {  3,  2},
+	[VCAP_ES0_ACT_TAG_A_VID_SEL]		= {  5,  1},
+	[VCAP_ES0_ACT_TAG_A_PCP_SEL]		= {  6,  2},
+	[VCAP_ES0_ACT_TAG_A_DEI_SEL]		= {  8,  2},
+	[VCAP_ES0_ACT_TAG_B_TPID_SEL]		= { 10,  2},
+	[VCAP_ES0_ACT_TAG_B_VID_SEL]		= { 12,  1},
+	[VCAP_ES0_ACT_TAG_B_PCP_SEL]		= { 13,  2},
+	[VCAP_ES0_ACT_TAG_B_DEI_SEL]		= { 15,  2},
+	[VCAP_ES0_ACT_VID_A_VAL]		= { 17, 12},
+	[VCAP_ES0_ACT_PCP_A_VAL]		= { 29,  3},
+	[VCAP_ES0_ACT_DEI_A_VAL]		= { 32,  1},
+	[VCAP_ES0_ACT_VID_B_VAL]		= { 33, 12},
+	[VCAP_ES0_ACT_PCP_B_VAL]		= { 45,  3},
+	[VCAP_ES0_ACT_DEI_B_VAL]		= { 48,  1},
+	[VCAP_ES0_ACT_RSV]			= { 49, 23},
+	[VCAP_ES0_ACT_HIT_STICKY]		= { 72,  1},
+};
+
 static const struct vcap_field vsc9959_vcap_is1_keys[] = {
 	[VCAP_IS1_HK_TYPE]			= {  0,   1},
 	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
@@ -785,6 +823,18 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 };
 
 static struct vcap_props vsc9959_vcap_props[] = {
+	[VCAP_ES0] = {
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 72, /* HIT_STICKY not included */
+				.count = 1,
+			},
+		},
+		.target = S0,
+		.keys = vsc9959_vcap_es0_keys,
+		.actions = vsc9959_vcap_es0_actions,
+	},
 	[VCAP_IS1] = {
 		.action_type_width = 0,
 		.action_table = {
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 363f7f4cd7a3..8ed7354ba98b 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -361,6 +361,7 @@ static const u32 *vsc9953_regmap[TARGET_MAX] = {
 	[QSYS]		= vsc9953_qsys_regmap,
 	[REW]		= vsc9953_rew_regmap,
 	[SYS]		= vsc9953_sys_regmap,
+	[S0]		= vsc9953_vcap_regmap,
 	[S1]		= vsc9953_vcap_regmap,
 	[S2]		= vsc9953_vcap_regmap,
 	[GCB]		= vsc9953_gcb_regmap,
@@ -394,6 +395,11 @@ static const struct resource vsc9953_target_io_res[TARGET_MAX] = {
 		.end	= 0x001ffff,
 		.name	= "sys",
 	},
+	[S0] = {
+		.start	= 0x0040000,
+		.end	= 0x00403ff,
+		.name	= "s0",
+	},
 	[S1] = {
 		.start	= 0x0050000,
 		.end	= 0x00503ff,
@@ -614,6 +620,38 @@ static const struct ocelot_stat_layout vsc9953_stats_layout[] = {
 	{ .offset = 0x91,	.name = "drop_green_prio_7", },
 };
 
+static const struct vcap_field vsc9953_vcap_es0_keys[] = {
+	[VCAP_ES0_EGR_PORT]			= {  0,  4},
+	[VCAP_ES0_IGR_PORT]			= {  4,  4},
+	[VCAP_ES0_RSV]				= {  8,  2},
+	[VCAP_ES0_L2_MC]			= { 10,  1},
+	[VCAP_ES0_L2_BC]			= { 11,  1},
+	[VCAP_ES0_VID]				= { 12, 12},
+	[VCAP_ES0_DP]				= { 24,  1},
+	[VCAP_ES0_PCP]				= { 25,  3},
+};
+
+static const struct vcap_field vsc9953_vcap_es0_actions[] = {
+	[VCAP_ES0_ACT_PUSH_OUTER_TAG]		= {  0,  2},
+	[VCAP_ES0_ACT_PUSH_INNER_TAG]		= {  2,  1},
+	[VCAP_ES0_ACT_TAG_A_TPID_SEL]		= {  3,  2},
+	[VCAP_ES0_ACT_TAG_A_VID_SEL]		= {  5,  1},
+	[VCAP_ES0_ACT_TAG_A_PCP_SEL]		= {  6,  2},
+	[VCAP_ES0_ACT_TAG_A_DEI_SEL]		= {  8,  2},
+	[VCAP_ES0_ACT_TAG_B_TPID_SEL]		= { 10,  2},
+	[VCAP_ES0_ACT_TAG_B_VID_SEL]		= { 12,  1},
+	[VCAP_ES0_ACT_TAG_B_PCP_SEL]		= { 13,  2},
+	[VCAP_ES0_ACT_TAG_B_DEI_SEL]		= { 15,  2},
+	[VCAP_ES0_ACT_VID_A_VAL]		= { 17, 12},
+	[VCAP_ES0_ACT_PCP_A_VAL]		= { 29,  3},
+	[VCAP_ES0_ACT_DEI_A_VAL]		= { 32,  1},
+	[VCAP_ES0_ACT_VID_B_VAL]		= { 33, 12},
+	[VCAP_ES0_ACT_PCP_B_VAL]		= { 45,  3},
+	[VCAP_ES0_ACT_DEI_B_VAL]		= { 48,  1},
+	[VCAP_ES0_ACT_RSV]			= { 49, 24},
+	[VCAP_ES0_ACT_HIT_STICKY]		= { 73,  1},
+};
+
 static const struct vcap_field vsc9953_vcap_is1_keys[] = {
 	[VCAP_IS1_HK_TYPE]			= {  0,   1},
 	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
@@ -774,6 +812,18 @@ static struct vcap_field vsc9953_vcap_is2_actions[] = {
 };
 
 static struct vcap_props vsc9953_vcap_props[] = {
+	[VCAP_ES0] = {
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 73, /* HIT_STICKY not included */
+				.count = 1,
+			},
+		},
+		.target = S0,
+		.keys = vsc9953_vcap_es0_keys,
+		.actions = vsc9953_vcap_es0_actions,
+	},
 	[VCAP_IS1] = {
 		.action_type_width = 0,
 		.action_table = {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index da31fcee0a6f..b66416f55d84 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -764,6 +764,38 @@ static const struct ocelot_ops ocelot_ops = {
 	.wm_enc			= ocelot_wm_enc,
 };
 
+static struct vcap_field vsc7514_vcap_es0_keys[] = {
+	[VCAP_ES0_EGR_PORT]			= {  0,  4},
+	[VCAP_ES0_IGR_PORT]			= {  4,  4},
+	[VCAP_ES0_RSV]				= {  8,  2},
+	[VCAP_ES0_L2_MC]			= { 10,  1},
+	[VCAP_ES0_L2_BC]			= { 11,  1},
+	[VCAP_ES0_VID]				= { 12, 12},
+	[VCAP_ES0_DP]				= { 24,  1},
+	[VCAP_ES0_PCP]				= { 25,  3},
+};
+
+struct vcap_field vsc7514_vcap_es0_actions[] = {
+	[VCAP_ES0_ACT_PUSH_OUTER_TAG]		= {  0,  2},
+	[VCAP_ES0_ACT_PUSH_INNER_TAG]		= {  2,  1},
+	[VCAP_ES0_ACT_TAG_A_TPID_SEL]		= {  3,  2},
+	[VCAP_ES0_ACT_TAG_A_VID_SEL]		= {  5,  1},
+	[VCAP_ES0_ACT_TAG_A_PCP_SEL]		= {  6,  2},
+	[VCAP_ES0_ACT_TAG_A_DEI_SEL]		= {  8,  2},
+	[VCAP_ES0_ACT_TAG_B_TPID_SEL]		= { 10,  2},
+	[VCAP_ES0_ACT_TAG_B_VID_SEL]		= { 12,  1},
+	[VCAP_ES0_ACT_TAG_B_PCP_SEL]		= { 13,  2},
+	[VCAP_ES0_ACT_TAG_B_DEI_SEL]		= { 15,  2},
+	[VCAP_ES0_ACT_VID_A_VAL]		= { 17, 12},
+	[VCAP_ES0_ACT_PCP_A_VAL]		= { 29,  3},
+	[VCAP_ES0_ACT_DEI_A_VAL]		= { 32,  1},
+	[VCAP_ES0_ACT_VID_B_VAL]		= { 33, 12},
+	[VCAP_ES0_ACT_PCP_B_VAL]		= { 45,  3},
+	[VCAP_ES0_ACT_DEI_B_VAL]		= { 48,  1},
+	[VCAP_ES0_ACT_RSV]			= { 49, 24},
+	[VCAP_ES0_ACT_HIT_STICKY]		= { 73,  1},
+};
+
 static struct vcap_field vsc7514_vcap_is1_keys[] = {
 	[VCAP_IS1_HK_TYPE]			= {  0,   1},
 	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
@@ -938,6 +970,18 @@ static const struct vcap_field vsc7514_vcap_is2_actions[] = {
 };
 
 static struct vcap_props vsc7514_vcap_props[] = {
+	[VCAP_ES0] = {
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 73, /* HIT_STICKY not included */
+				.count = 1,
+			},
+		},
+		.target = S0,
+		.keys = vsc7514_vcap_es0_keys,
+		.actions = vsc7514_vcap_es0_actions,
+	},
 	[VCAP_IS1] = {
 		.action_type_width = 0,
 		.action_table = {
@@ -1126,6 +1170,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		{ QSYS, "qsys" },
 		{ ANA, "ana" },
 		{ QS, "qs" },
+		{ S0, "s0" },
 		{ S1, "s1" },
 		{ S2, "s2" },
 		{ PTP, "ptp", 1 },
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index af541189c103..17a72954f3e7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -123,6 +123,7 @@ enum ocelot_target {
 	QSYS,
 	REW,
 	SYS,
+	S0,
 	S1,
 	S2,
 	HSIO,
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 7ac184047292..9139a9894e90 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -16,7 +16,7 @@
 enum {
 	VCAP_IS1,
 	VCAP_IS2,
-	/* VCAP_ES0, */
+	VCAP_ES0,
 };
 
 struct vcap_props {
@@ -355,4 +355,46 @@ enum vcap_is1_action_field {
 	VCAP_IS1_ACT_HIT_STICKY,
 };
 
+/* =================================================================
+ *  VCAP ES0
+ * =================================================================
+ */
+
+enum {
+	ES0_ACTION_TYPE_NORMAL,
+	ES0_ACTION_TYPE_MAX,
+};
+
+enum vcap_es0_key_field {
+	VCAP_ES0_EGR_PORT,
+	VCAP_ES0_IGR_PORT,
+	VCAP_ES0_RSV,
+	VCAP_ES0_L2_MC,
+	VCAP_ES0_L2_BC,
+	VCAP_ES0_VID,
+	VCAP_ES0_DP,
+	VCAP_ES0_PCP,
+};
+
+enum vcap_es0_action_field {
+	VCAP_ES0_ACT_PUSH_OUTER_TAG,
+	VCAP_ES0_ACT_PUSH_INNER_TAG,
+	VCAP_ES0_ACT_TAG_A_TPID_SEL,
+	VCAP_ES0_ACT_TAG_A_VID_SEL,
+	VCAP_ES0_ACT_TAG_A_PCP_SEL,
+	VCAP_ES0_ACT_TAG_A_DEI_SEL,
+	VCAP_ES0_ACT_TAG_B_TPID_SEL,
+	VCAP_ES0_ACT_TAG_B_VID_SEL,
+	VCAP_ES0_ACT_TAG_B_PCP_SEL,
+	VCAP_ES0_ACT_TAG_B_DEI_SEL,
+	VCAP_ES0_ACT_VID_A_VAL,
+	VCAP_ES0_ACT_PCP_A_VAL,
+	VCAP_ES0_ACT_DEI_A_VAL,
+	VCAP_ES0_ACT_VID_B_VAL,
+	VCAP_ES0_ACT_PCP_B_VAL,
+	VCAP_ES0_ACT_DEI_B_VAL,
+	VCAP_ES0_ACT_RSV,
+	VCAP_ES0_ACT_HIT_STICKY,
+};
+
 #endif /* _OCELOT_VCAP_H_ */
-- 
2.25.1

