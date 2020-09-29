Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1464627C20D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgI2KLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:23 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:58854
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728250AbgI2KLA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8WtOm4CjegRYaXCuGPVDWvMKRrnLkXQ17PLO1dFpdiLVUl8VBDU9pqp4L+yjnmCP2hsDnTAnF7wYPmoaddiZ0gD/tngoCyfA+l2jGIdHE/5p+NiuDqwtYHW4zTptJiv2Xq1zUbybtrqtWmbFR/izEFYEgz9Hb4QcauXwbEc03015K6WgxKozidvDquyP33AxbpSsgCzPQ56Q7LfSOtVUoYL2B3TBOgBarc2WnldeLWiFazAZsCjdiq9OPPkaCVbuw0xUg8z2Js02zAVAyG0HJhtsjChZwGZOxN4aqTYCX8y138YjZ/1bJVn+48lon1uvfImdDLZFYTcvLC7B5MuYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SP2DW4vpdVNCgPLInWea4g9oCNLicV7kuhXOpNKZxI=;
 b=mYaNo8ORSqglwQWEV1WAmf3BoKoTcR5H51zLDOorN1bC+1OohazfQBZkERSmkYhp4D7RvU/9IqlIfIeJxXYbsfv3986P9PVB+0wv6jq59QLyNuOjb62O3ObFEU7nSF5Y4whr2mAhx6R8Sz90EnkCl3W5UymD77eTf6b8rwklWS2LDCLd7a1pN/j9oBbhDxFkmNHmKw1QfUTmgkRdspEc7qBYcqCJEW/gXAByKPSNbMWf9Qm1LqstWjLvyQhn9NFw3rqVlqt5ILpPM8bnj11M9qm632ja7t7uuE2MYnenxMc+38QKyyy6GuLRI3/Yq8e56OiecxR7uY0koYUFB8TSyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SP2DW4vpdVNCgPLInWea4g9oCNLicV7kuhXOpNKZxI=;
 b=BbRB8aYmIb1cBO5HPLDhPUF3Me3JgFWc4UsSbqb0d9FFqE/TwWpp06W6JbMDm3gnLssuWV+Z49apxk6qChFMal+wOcRVwkF3YrAYRh5TiJPjb2HywZtE6xEKLPlqLvXeZ9xXwZEKhwDKQVPyb9qmPhnP3sQEns+wsHHcRDBrV2o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 06/21] net: mscc: ocelot: add definitions for VCAP IS1 keys, actions and target
Date:   Tue, 29 Sep 2020 13:10:01 +0300
Message-Id: <20200929101016.3743530-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 66252fe1-3bdc-4d56-9fa4-08d8645fea5c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB52956C1B0BEA15B9A573A800E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZDGVLwLAUm6c6mAYTovvjry0DHcdfhyKtSvuerRdbqQkLYJ840ioleNvJOfqhZmKT9nywQe/0ZZ3qB6nUL3bBvlcczJXr0qEWx6zg8iV9KMHCfYbYXzWcm1UAIHziEyPRfLHlKnCiO7gbpmwNjo53KtesT+XeLFsFxv0uv7Ldk9DXn6LyoO+xAgwlC7iegxt3aorIJxdD1z80ZzpNrSVOOtHEJIZxy8TU8+JLz8IY9qoHLDJASppBamV2RoOsImmLXmXc22i2/8atkZVH2czw6yohra7tDsRqHF+7ESn1TD75XlIx0oROlcGJfyvjdVtgKocXVRYS8XbTbatRrriLbtoixfH8tv7hMvcN2oNyC3/iubx63T92ZWZttMQMcs2X07aFX52CJsVKoU3l9DmU6iwlRemLkxzGwvdKt4ceEXBuNVNjbj8Nbkl3f7jMGir
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(30864003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bzg3lqJ4YXbEOAYZyrVGahsIpd+T7IbHrWlvX4WUotgxyCSlKjT8yTDWgTDKwqyaSnRW7McgnX5Ms8bNEdTEAAAlOMyrAGcTn15n34sIQKdan3K6Z2wWYHDDW391KvBFANWsLVV+GDE7yfxGZPGuNOi55jyFZ/STThsP2u09QdUTbOEHTPsIU3lQyBjjQdjVi6y8JSItfDmQlqddgGUIoNpZa0CwU2qinzimKe/uf6/pb8P/FtgwVIJZSe2dc+G+wN60OLmyh9PXvWxF0L4al++hFRwKJ4senEd7+DhwN/EC2/rFmisQKmw/aehsywA34EX3L+CWg/jlJPrywN+mJ6PlHBTsWbBU+GVjZZKssWFCXLZexTpBFz/UTxp91cguEbnT2yf/238y50RopcLB6Gp2sHjkHFpIgyb0K7IC73aW6DImVNji/cOmAXxHPlbuJ3oN/zFNLYOADlQFBwxP89FzqLTOYw/OY9ajN6mgGhERkrGkveG8Zo8LBLHVgiuC2Lo4LPWoKx8bDEQBwW6ArSvZ57ZZg8hyO59xliSnO/JmWNXv3JWRGgK63SxzK7F1RfKmV/Tbq0Xoc3M8l7/Zxi66dqiZmvGEwvv9TNq9FnrWwqsNS65jhgvziarvz61svSely9y26Ftpg8QMnajpFA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66252fe1-3bdc-4d56-9fa4-08d8645fea5c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:39.1783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCBqWphHyBIUoGQt+tIaQ2KAQylfCa/DzZx8bLkcL+cZgacsgP9Fn+DFPERq1HgA3vQr3uq1ZDTShApF2ODJ1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation step for the offloading to IS1, let's create the
infrastructure for talking with this hardware block.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
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
index 089cfd8873eb..5a2dc6ec98d5 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -369,6 +369,7 @@ static const u32 *vsc9959_regmap[TARGET_MAX] = {
 	[QSYS]	= vsc9959_qsys_regmap,
 	[REW]	= vsc9959_rew_regmap,
 	[SYS]	= vsc9959_sys_regmap,
+	[S1]	= vsc9959_vcap_regmap,
 	[S2]	= vsc9959_vcap_regmap,
 	[PTP]	= vsc9959_ptp_regmap,
 	[GCB]	= vsc9959_gcb_regmap,
@@ -402,6 +403,11 @@ static const struct resource vsc9959_target_io_res[TARGET_MAX] = {
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
@@ -606,6 +612,80 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
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
@@ -705,6 +785,18 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 };
 
 static struct vcap_props vsc9959_vcap_props[] = {
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
 		.action_type_width = 1,
 		.action_table = {
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 5669c9c6bf60..363f7f4cd7a3 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -361,6 +361,7 @@ static const u32 *vsc9953_regmap[TARGET_MAX] = {
 	[QSYS]		= vsc9953_qsys_regmap,
 	[REW]		= vsc9953_rew_regmap,
 	[SYS]		= vsc9953_sys_regmap,
+	[S1]		= vsc9953_vcap_regmap,
 	[S2]		= vsc9953_vcap_regmap,
 	[GCB]		= vsc9953_gcb_regmap,
 	[DEV_GMII]	= vsc9953_dev_gmii_regmap,
@@ -393,6 +394,11 @@ static const struct resource vsc9953_target_io_res[TARGET_MAX] = {
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
@@ -608,6 +614,80 @@ static const struct ocelot_stat_layout vsc9953_stats_layout[] = {
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
@@ -694,6 +774,18 @@ static struct vcap_field vsc9953_vcap_is2_actions[] = {
 };
 
 static struct vcap_props vsc9953_vcap_props[] = {
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
 		.action_type_width = 1,
 		.action_table = {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 8c96e62b2104..da31fcee0a6f 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -764,6 +764,81 @@ static const struct ocelot_ops ocelot_ops = {
 	.wm_enc			= ocelot_wm_enc,
 };
 
+static struct vcap_field vsc7514_vcap_is1_keys[] = {
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
+static struct vcap_field vsc7514_vcap_is1_actions[] = {
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
@@ -863,6 +938,18 @@ static const struct vcap_field vsc7514_vcap_is2_actions[] = {
 };
 
 static struct vcap_props vsc7514_vcap_props[] = {
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
 		.action_type_width = 1,
 		.action_table = {
@@ -1039,6 +1126,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		{ QSYS, "qsys" },
 		{ ANA, "ana" },
 		{ QS, "qs" },
+		{ S1, "s1" },
 		{ S2, "s2" },
 		{ PTP, "ptp", 1 },
 	};
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 36c23832eb06..af541189c103 100644
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

