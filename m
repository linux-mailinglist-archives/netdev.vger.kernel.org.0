Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE6827DBFF
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgI2W2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:34 -0400
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:50784
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728467AbgI2W2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6AL3sfh3RlFMyiI0g0PxJ7d/NCi3O9V6splPMAxqbFKreRji/+JCzyx+HTcJh82WEMFIlqiUt4sXErHxuYR1ch9L3uc3PsybvCH3zTiIbcfQKB0x3GrBieyv7E96+cUBv+A2XbyM53ivCmruRy/CiacJpyVbSGZycXj1ew37iKZwHvSb4mG9RpzZlwiGWl2YhGwIm+gB6qmMhw+11OmNYLFHUGdd8d2BqVrorOwms4z2i3UsgItW73zlSSUYVSKkDvvD76tMvjqxPKmmauDm9eCVQm6pDXzTb+WSKUDdM7qHAvhsrRvCnH4i17bpXTvlw3t4bvt6fIR4iygzIGz6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDgXWNyt0aOEYmjw4TUcKJj5+g6vZ4XeZXuWYMSI2EQ=;
 b=A60H8ZzE455s9Cav/j/eK2T7vaG2NW30gu1wO7rFX6m1bfQZ8LtHWXp6HXUbpV3VRTkmFEcAdhWYqZmHe52aL0ErH/lXcAS1Svg6y/WU+D/8eL/drAIqwpqsMna8PaYXBg4ZayR9JkknhMiIZDKSi14/m8Al5Yinh2WVLgCHqGDaK45vrqQSTkKzO5iwi9PPNo+ixYnDPHWSsibLE47fXfEchNgdDXbnvvrYEMGR61cZgSHUE4b5N5JF373HJOfjvLN2vAPoGKGGjMHRLo2UycJ6iSnKmI4PqN0/5zkrgH/ISbguQLDFYcKSQHcAAsFLnJ8HKmJVgmbxGM/quKRNUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDgXWNyt0aOEYmjw4TUcKJj5+g6vZ4XeZXuWYMSI2EQ=;
 b=HY4ReE5uBe2eWbarGIAxG2YD/W/KXJxBjxwWeajsWipATNyEsI0ySbZGq8fFioeaJ7wDzXeeg6319zNsLch0JuhcyWtuF6DHNzbuK9E8OEuzg9Yl8yofKM4BpZ5UOdIH2PTHAFgJ0D7C1rp4rCK8Vfv0pRkW0bpxdO0k96pOnw0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:28:03 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:28:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 05/13] net: mscc: ocelot: add definitions for VCAP ES0 keys, actions and target
Date:   Wed, 30 Sep 2020 01:27:25 +0300
Message-Id: <20200929222733.770926-6-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:28:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6859f710-68d8-46d8-f21b-08d864c6ede7
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB279742BDB89B3FCC614B576CE0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D61vNCro1t6Q6b3mQWmx8oO0Lliex8OS0nAZDNs+V4i/kjb94mOIL092D5f+bYlm0357S6F+HALBULLg1jIsWT1hdbjHHX/7WDkdX16z++X1EQXX4oVzbywqYV3SmcxuplK5xqKk+4pRrsZYlbATy0pV7yWRwbngJRJrqc6Num6FaBDHRZrraXT/ec+j3aDrZ74NKUJe46ZX1mhoBGt1sZlyvAkoHmkPxX1bOPuYRL2EdwmpZYVyFlu/qY63V+qrDSl0x7q3Aq+HFpwWeUKsl2M26PC/xn7E0eAzYteay4qI75xeTJEZxPwz/1CGKu+a0UJCIdbBho7nGrs/T7WOBWbJSrpwHoD9dZiwuCxhJLcMfkJqzuiBbxla5JPYKfc78CCTM6EUWmi/tZ/VnICGBrRzz0H2o0G7qXBKBK/zyVlQzkTxfFaqpu8aEypbhk+r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(30864003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ih7rlGYhixMIjokBerctrpBGfcSbhlWy05lNJ9kVeiwBv/7vD+EmQdKtcpEsUCph6oUgdsvlNiv8L4SFjtf0ndSyxKxLgtukfLvRHwIcLSHDmtC9Zc8FXwtsbM30SSoL5XK0NbYITYe9tS9DRS0/IT/L+VlKQUDxpm3JisulvW/RKFviMGiK20hCPr+nH8XysgdvgJI75CnxrHb/uMUrNt9xF2PuOlP6oXle7e6iuqLsNwH2WCqoG8/490G1S7IpmW6XDNRAZjE8hZa1pvuOFCKGzDTSrfd1xhyagqrn63j55ThCFGI+nGcqB4os9VdypZ7yMY7tMLSIkH43h223XMJ5tJgeDESOj6m4wziRwvabckAdSCXr2leZq9nPkHn+lmKLRjW3fRUaYjJxq9h+uR+Zn7nmu7tFPeXHRXJ9HD5viP4pwfq6YQwtAHFYPXpfbU4tZYdD7NurbN6hPR8v88IdmfEIFIJqpGR+dAK7qy4jGVYUrhoGVJNm6y/MRJHVVK3GqrGEcor5LOrce4yxjmOzbcT4NSAho6D8zohV1GQptToa+ZSv45ndiyMFSAT2CAR+j7cGKS8+R1rWNdukk7BnqQHTVPuRql0iLRrM2haZyI4ccfa7sgduxgLxS8iwPeX2EV3Mc5LaYE0hHsdojg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6859f710-68d8-46d8-f21b-08d864c6ede7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:28:03.2837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NzLSJrGrmG+p/y9hlhemY6XyIAbAfoQ6HHbBwmHFKvizXRkO15RINwytlp7JK6jGtNkdhbPOXNp+nX+1DLZBpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation step for the offloading to ES0, let's create the
infrastructure for talking with this hardware block.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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
index 460cdef4b50b..a70f7a7277dc 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -361,6 +361,7 @@ static const u32 *vsc9959_regmap[TARGET_MAX] = {
 	[QSYS]	= vsc9959_qsys_regmap,
 	[REW]	= vsc9959_rew_regmap,
 	[SYS]	= vsc9959_sys_regmap,
+	[S0]	= vsc9959_vcap_regmap,
 	[S1]	= vsc9959_vcap_regmap,
 	[S2]	= vsc9959_vcap_regmap,
 	[PTP]	= vsc9959_ptp_regmap,
@@ -395,6 +396,11 @@ static const struct resource vsc9959_target_io_res[TARGET_MAX] = {
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
@@ -604,6 +610,38 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
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
@@ -777,6 +815,18 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 };
 
 static const struct vcap_props vsc9959_vcap_props[] = {
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
index 50484fdbc69a..f26a6eab44f6 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -354,6 +354,7 @@ static const u32 *vsc9953_regmap[TARGET_MAX] = {
 	[QSYS]		= vsc9953_qsys_regmap,
 	[REW]		= vsc9953_rew_regmap,
 	[SYS]		= vsc9953_sys_regmap,
+	[S0]		= vsc9953_vcap_regmap,
 	[S1]		= vsc9953_vcap_regmap,
 	[S2]		= vsc9953_vcap_regmap,
 	[GCB]		= vsc9953_gcb_regmap,
@@ -387,6 +388,11 @@ static const struct resource vsc9953_target_io_res[TARGET_MAX] = {
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
@@ -607,6 +613,38 @@ static const struct ocelot_stat_layout vsc9953_stats_layout[] = {
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
@@ -767,6 +805,18 @@ static struct vcap_field vsc9953_vcap_is2_actions[] = {
 };
 
 static const struct vcap_props vsc9953_vcap_props[] = {
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
index 4bb3f7f62029..86f8b77decf5 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -758,6 +758,38 @@ static const struct ocelot_ops ocelot_ops = {
 	.wm_enc			= ocelot_wm_enc,
 };
 
+static const struct vcap_field vsc7514_vcap_es0_keys[] = {
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
+static const struct vcap_field vsc7514_vcap_es0_actions[] = {
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
 static const struct vcap_field vsc7514_vcap_is1_keys[] = {
 	[VCAP_IS1_HK_TYPE]			= {  0,   1},
 	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
@@ -932,6 +964,18 @@ static const struct vcap_field vsc7514_vcap_is2_actions[] = {
 };
 
 static const struct vcap_props vsc7514_vcap_props[] = {
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
@@ -1129,6 +1173,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		{ QSYS, "qsys" },
 		{ ANA, "ana" },
 		{ QS, "qs" },
+		{ S0, "s0" },
 		{ S1, "s1" },
 		{ S2, "s2" },
 		{ PTP, "ptp", 1 },
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d0073c94e22a..b0a9efce8813 100644
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
index 7ac184047292..707e609ec919 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -14,9 +14,9 @@
  */
 
 enum {
+	VCAP_ES0,
 	VCAP_IS1,
 	VCAP_IS2,
-	/* VCAP_ES0, */
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

