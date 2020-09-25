Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7CC2786ED
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgIYMTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:48 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:63262
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728566AbgIYMTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqE/dICCINTjT7FMocTCf5pJeQtHd96A0Qnso68U8Q6L8M9k0TY0E0fveFvYwLUzik8H8B5720tskFzPt0XdnHtGNrig8Uy65SoSHxwblIWpXVou5e1FpKzKpyq3adZGnhiZaAw9Kk0iyNy+ZaIpm/nLRfA2EN5Lqcwj/nb3hqfRlqFyYuWelOusbhsp7QrWUzCdmwFlTLbaLiJKA4TFV5+PvQZ3CkYImoUsWL1YqKzzMKtYCU+6HGG6ukh3BhM3g3z/YFjVXMPQOgw1GDAqA0BAu8xETQh1cOYn2spkCt2UulLNcNTQSrmx+yHum5Pdo3fJOTjsa+sBQ616p9yEHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ON2KwEtEpxjKxhMJWcHZ8ExKvseMrXcBB2njg1xcvTw=;
 b=JrBMblJaGv81lCgBV2zNOgPY16zCPsqKX3o6i/pphSOdIfMYNsJr/qkiht3/4r6+cFSQ97LtjwUL2x1lB0AQZfBq8ZK3KDGF6RxnZ9wRrVW6qrkGu7JgOg1+IG6+gmi7MrdmhhgPZ16FoRNizsus0omaw0+R/0/6SU1iNP3mrlodB1HYIs5xfSbgABcz0HAT0ZwcTFO5yE0dBKUWhOLXOBX8su/SNr3ejFdGeF8MbvID/o6MEksItI9PviScX+MJIPOqyp4uWyVfMzbiRIxOwgBye8FT8YE31xKXCbiaCbDc0aCmC2ycRF2xnnc+tWShqHhmX7vjWyWUzadI/vyMtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ON2KwEtEpxjKxhMJWcHZ8ExKvseMrXcBB2njg1xcvTw=;
 b=NrPgdK/lIckpYJsLmji8anlqkk6aZK15hhSE4I+XeXhC7Z3qLknGjZr8ea5fHPXx2TaeVut6zVtvy8GDUzUS9wNrR3sZxnPWgVGpcPeiNixHaNY/Q3Jo2JPQNnKqjuVo3zaxp+wGzSFZITTdZQ7m4qRmzLh3rc9iPIaL3XSXtfw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:28 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 09/14] net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1
Date:   Fri, 25 Sep 2020 15:18:50 +0300
Message-Id: <20200925121855.370863-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925121855.370863-1-vladimir.oltean@nxp.com>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:803:104::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:27 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c209d60d-3ca7-4b01-e2fb-08d8614d3fa9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB355016DA693C9278A4EE8A3AE0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I9YQts3MTdsN0N3mZe0zJIt3D80vHruq3ehGkpUTQrDsQXNhHXJi/CHU5m6fV8GZYglpO68aL821LwMZGK+aiB1BggDt2d5JIYjcEAsjcxG1j9N+VFCiDTXaBH8WpV3lpo3FcChXAnXtlG36CGQMWkOAWf+AMF8DEcasrQ+cV1tFGeAYP4oXoNc7+OcKnQkLt0mi/OISnV+8cGuFUmvd6jiGVNib/j3xdVdl3V6qHUc723VcUMmGA5iLZabacULtGERcPHzdKY2NZ0yMuZk/r7rnDnuhmXlvxVmy2jsU8oySu5hoTXUHzueZ2d9rW0gHC/AtTmS5ae+WPJhhIbqTYoVmT5CwT9Dr3oqWoquQ8xYZkvqZDlvyZIGzSJ+adrIV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(30864003)(69590400008)(83380400001)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mVjo0nMcj1PrdW+2WGhS2qSJ5E2LAh95wNKxKCr7XiYRpDhB/TFgAaXTa6uwyX3VkTtbpfs4psNkW1LU2/ob9kdyZbYl6m8rIsCaeBHLrGws5N2v7lFkerDhwFesU3M+R6HMQ3i6/4VWc1wQ+yKR92qaJdGAYYmFMFw1TCFYDvNixy9xVzySBYLadNQgas85my4QD1WinS3YBhI+Jrrg/vEUphj5Dgpl0zDf9rtVYrgbIWYbgbzNAfIxUSBQ9u9iDx7K6Rp4IKmvWXuw68UHPtQHskcntbB/HrwPpr7Zkk39AM33QKfB02HaUdPwUXm5PHC+ehKKAkkOKfOf1Hd18GOy2dzvt/JVbuwclQ/+6GSKJmFOUvE8Y3lAPwR2huMYCLfwItP5UfO5T8E9/XtGWfyX07yBUY6zmhDQxIzgL3n+HXGvX/2TGCZf2gWdT6mfqaXZKsvsb3WmVzv/3nAotuIlyFKW6uVeRh8mFPOi4ApCMZdXO8NVFXJFkrcUkDo+sC7yfSc0FrgeIXoA6jCGwFzNS6Ntcv1s5iK85IBZCBtdLubQcTNfH2APiCeCxfaIugzMqXMdAwpKLvEY1E/HnhPR5NrHfI5qFxawMKTUSBOG23uGACG6o6wCevqh3ZezXkNMTeWWCNZVb85OpLxBvg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c209d60d-3ca7-4b01-e2fb-08d8614d3fa9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:28.3508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FuOdKptDqKnXdgQsZ9Bs/uylhhyoFNm3F7x87N0CbhF0rr2tmUH8Ga9s/peoJCP6TlzqmcE5RgFy61QMPV8YBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

VCAP IS1 is a VCAP module which can filter on the most common L2/L3/L4
Ethernet keys, and modify the results of the basic QoS classification
and VLAN classification based on those flow keys.

There are 3 VCAP IS1 lookups, mapped over chains 10000, 11000 and 12000.
Currently the driver is hardcoded to use IS1_ACTION_TYPE_NORMAL half
keys.

TODO: fill the VCAP properties, key and action offsets for VSC9953
Seville and VSC7514 Ocelot. Only tested on VSC9959 Felix.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c    | 102 ++++++++++++
 drivers/net/ethernet/mscc/ocelot.c        |   7 +
 drivers/net/ethernet/mscc/ocelot_flower.c |  72 ++++++++
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 191 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vcap.h   |  17 ++
 include/soc/mscc/ocelot.h                 |   1 +
 include/soc/mscc/ocelot_vcap.h            |  91 +++++++++++
 7 files changed, 481 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 66e991ab9df5..869af4c994a4 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -19,6 +19,8 @@
 #define VSC9959_VCAP_IS2_CNT		1024
 #define VSC9959_VCAP_IS2_ENTRY_WIDTH	376
 #define VSC9959_VCAP_PORT_CNT		6
+#define VSC9959_VCAP_IS1_CNT		256
+#define VSC9959_VCAP_IS1_ENTRY_WIDTH	376
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
 
 static const u32 vsc9959_ana_regmap[] = {
@@ -361,6 +363,7 @@ static const u32 *vsc9959_regmap[TARGET_MAX] = {
 	[QSYS]	= vsc9959_qsys_regmap,
 	[REW]	= vsc9959_rew_regmap,
 	[SYS]	= vsc9959_sys_regmap,
+	[S1]	= vsc9959_vcap_regmap,
 	[S2]	= vsc9959_vcap_regmap,
 	[PTP]	= vsc9959_ptp_regmap,
 	[GCB]	= vsc9959_gcb_regmap,
@@ -394,6 +397,11 @@ static const struct resource vsc9959_target_io_res[TARGET_MAX] = {
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
@@ -598,6 +606,80 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x111,	.name = "drop_green_prio_7", },
 };
 
+static struct vcap_field vsc9959_vcap_is1_keys[] = {
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
+static struct vcap_field vsc9959_vcap_is1_actions[] = {
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
@@ -697,6 +779,26 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 };
 
 static const struct vcap_props vsc9959_vcap_props[] = {
+	[VCAP_IS1] = {
+		.tg_width = 2,
+		.sw_count = 4,
+		.entry_count = VSC9959_VCAP_IS1_CNT,
+		.entry_width = VSC9959_VCAP_IS1_ENTRY_WIDTH,
+		.action_count = VSC9959_VCAP_IS1_CNT + 1,
+		.action_width = 312,
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 78,
+				.count = 4
+			},
+		},
+		.counter_words = 1,
+		.counter_width = 4,
+		.target = S1,
+		.keys = vsc9959_vcap_is1_keys,
+		.actions = vsc9959_vcap_is1_actions,
+	},
 	[VCAP_IS2] = {
 		.tg_width = 2,
 		.sw_count = 4,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index f67e284521aa..66921a932009 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -107,6 +107,13 @@ static void ocelot_vcap_enable(struct ocelot *ocelot, int port)
 	ocelot_write_gix(ocelot, ANA_PORT_VCAP_S2_CFG_S2_ENA |
 			 ANA_PORT_VCAP_S2_CFG_S2_IP6_CFG(0xa),
 			 ANA_PORT_VCAP_S2_CFG, port);
+
+	ocelot_write_gix(ocelot, ANA_PORT_VCAP_CFG_S1_ENA,
+			 ANA_PORT_VCAP_CFG, port);
+	ocelot_write_gix(ocelot,
+			 ANA_PORT_VCAP_S1_KEY_CFG_S1_KEY_IP6_CFG(2) |
+			 ANA_PORT_VCAP_S1_KEY_CFG_S1_KEY_IP4_CFG(2),
+			 ANA_PORT_VCAP_S1_KEY_CFG, port);
 }
 
 static inline u32 ocelot_vlant_read_vlanaccess(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 0cbd21ff5a0b..d9927fff8354 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -57,6 +57,17 @@ static int ocelot_chain_to_lookup(int chain)
 	return (chain / VCAP_LOOKUP) % 10;
 }
 
+/* Caller must ensure this is a valid IS2 chain first,
+ * by calling ocelot_chain_to_block.
+ */
+static int ocelot_chain_to_pag(int chain)
+{
+	int lookup = ocelot_chain_to_lookup(chain);
+
+	/* calculate PAG value as chain index relative to the first PAG */
+	return chain - VCAP_IS2_CHAIN(lookup, 0);
+}
+
 static bool ocelot_is_goto_target_valid(int goto_target, int chain,
 					bool ingress)
 {
@@ -202,8 +213,69 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 			filter->action.pol.burst = a->police.burst;
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
+		case FLOW_ACTION_VLAN_POP:
+			if (filter->block_id != VCAP_IS1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "VLAN pop action can only be offloaded to VCAP IS1");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			filter->action.vlan_pop_cnt_ena = true;
+			filter->action.vlan_pop_cnt++;
+			if (filter->action.vlan_pop_cnt > 2) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Cannot pop more than 2 VLAN headers");
+				return -EOPNOTSUPP;
+			}
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
+		case FLOW_ACTION_VLAN_MANGLE:
+			if (filter->block_id != VCAP_IS1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "VLAN modify action can only be offloaded to VCAP IS1");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			filter->action.vid_replace_ena = true;
+			filter->action.pcp_dei_ena = true;
+			filter->action.vid = a->vlan.vid;
+			filter->action.pcp = a->vlan.prio;
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
+		case FLOW_ACTION_PRIORITY:
+			if (filter->block_id != VCAP_IS1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Priority action can only be offloaded to VCAP IS1");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			filter->action.qos_ena = true;
+			filter->action.qos_val = a->priority;
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
 		case FLOW_ACTION_GOTO:
 			filter->goto_target = a->chain_index;
+
+			if (filter->block_id == VCAP_IS1 &&
+			    ocelot_chain_to_lookup(chain) == 2) {
+				int pag = ocelot_chain_to_pag(filter->goto_target);
+
+				filter->action.pag_override_mask = 0xff;
+				filter->action.pag_val = pag;
+				filter->type = OCELOT_VCAP_FILTER_PAG;
+			}
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Cannot offload action");
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 1741a462d2f0..3a011fe9e006 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -623,6 +623,194 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
 }
 
+static void is1_action_set(struct ocelot *ocelot, struct vcap_data *data,
+			   const struct ocelot_vcap_filter *filter)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
+	const struct ocelot_vcap_action *a = &filter->action;
+
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_VID_REPLACE_ENA,
+			a->vid_replace_ena);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_VID_ADD_VAL, a->vid);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_VLAN_POP_CNT_ENA,
+			a->vlan_pop_cnt_ena);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_VLAN_POP_CNT,
+			a->vlan_pop_cnt);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_PCP_DEI_ENA, a->pcp_dei_ena);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_PCP_VAL, a->pcp);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_DEI_VAL, a->dei);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_QOS_ENA, a->qos_ena);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_QOS_VAL, a->qos_val);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_PAG_OVERRIDE_MASK,
+			a->pag_override_mask);
+	vcap_action_set(vcap, data, VCAP_IS1_ACT_PAG_VAL, a->pag_val);
+}
+
+static void is1_entry_set(struct ocelot *ocelot, int ix,
+			  struct ocelot_vcap_filter *filter)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
+	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
+	struct ocelot_vcap_u64 payload;
+	struct vcap_data data;
+	u32 val, msk, type, i;
+	int row = ix / 2;
+
+	memset(&payload, 0, sizeof(payload));
+	memset(&data, 0, sizeof(data));
+
+	/* Read row */
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_ALL);
+	vcap_cache2entry(ocelot, vcap, &data);
+	vcap_cache2action(ocelot, vcap, &data);
+
+	data.tg_sw = VCAP_TG_HALF;
+	data.type = IS1_ACTION_TYPE_NORMAL;
+	vcap_data_offset_get(vcap, &data, ix);
+	data.tg = (data.tg & ~data.tg_mask);
+	if (filter->prio != 0)
+		data.tg |= data.tg_value;
+
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_IGR_PORT_MASK, 0,
+		     ~filter->ingress_port_mask);
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_L2_MC, filter->dmac_mc);
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_L2_BC, filter->dmac_bc);
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_VLAN_TAGGED, tag->tagged);
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_VID,
+		     tag->vid.value, tag->vid.mask);
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_PCP,
+		     tag->pcp.value[0], tag->pcp.mask[0]);
+	type = IS1_TYPE_S1_NORMAL;
+
+	switch (filter->key_type) {
+	case OCELOT_VCAP_KEY_ETYPE: {
+		struct ocelot_vcap_key_etype *etype = &filter->key.etype;
+
+		type = IS1_TYPE_S1_NORMAL;
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_L2_SMAC,
+				   etype->smac.value, etype->smac.mask);
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_ETYPE,
+				   etype->etype.value, etype->etype.mask);
+		break;
+	}
+	case OCELOT_VCAP_KEY_IPV4:
+	case OCELOT_VCAP_KEY_IPV6: {
+		enum ocelot_vcap_bit sip_eq_dip, sport_eq_dport;
+		enum ocelot_vcap_bit seq_zero, tcp;
+		enum ocelot_vcap_bit ttl, fragment, options;
+		enum ocelot_vcap_bit tcp_ack, tcp_urg;
+		enum ocelot_vcap_bit tcp_fin, tcp_syn, tcp_rst, tcp_psh;
+		struct ocelot_vcap_key_ipv4 *ipv4 = NULL;
+		struct ocelot_vcap_key_ipv6 *ipv6 = NULL;
+		struct ocelot_vcap_udp_tcp *sport, *dport;
+		struct ocelot_vcap_ipv4 sip, dip;
+		struct ocelot_vcap_u8 proto, ds;
+		struct ocelot_vcap_u48 *ip_data;
+		struct ocelot_vcap_u32 port;
+
+		type = IS1_TYPE_S1_5TUPLE_IP4;
+		if (filter->key_type == OCELOT_VCAP_KEY_IPV4) {
+			ipv4 = &filter->key.ipv4;
+			ttl = ipv4->ttl;
+			fragment = ipv4->fragment;
+			options = ipv4->options;
+			proto = ipv4->proto;
+			ds = ipv4->ds;
+			ip_data = &ipv4->data;
+			sip = ipv4->sip;
+			dip = ipv4->dip;
+			sport = &ipv4->sport;
+			dport = &ipv4->dport;
+			tcp_fin = ipv4->tcp_fin;
+			tcp_syn = ipv4->tcp_syn;
+			tcp_rst = ipv4->tcp_rst;
+			tcp_psh = ipv4->tcp_psh;
+			tcp_ack = ipv4->tcp_ack;
+			tcp_urg = ipv4->tcp_urg;
+			sip_eq_dip = ipv4->sip_eq_dip;
+			sport_eq_dport = ipv4->sport_eq_dport;
+			seq_zero = ipv4->seq_zero;
+		} else {
+			ipv6 = &filter->key.ipv6;
+			ttl = ipv6->ttl;
+			fragment = OCELOT_VCAP_BIT_ANY;
+			options = OCELOT_VCAP_BIT_ANY;
+			proto = ipv6->proto;
+			ds = ipv6->ds;
+			ip_data = &ipv6->data;
+			for (i = 0; i < 4; i++) {
+				dip.value.addr[i] = ipv6->dip.value[i];
+				dip.mask.addr[i] = ipv6->dip.mask[i];
+				sip.value.addr[i] = ipv6->sip.value[i];
+				sip.mask.addr[i] = ipv6->sip.mask[i];
+			}
+			sport = &ipv6->sport;
+			dport = &ipv6->dport;
+			tcp_fin = ipv6->tcp_fin;
+			tcp_syn = ipv6->tcp_syn;
+			tcp_rst = ipv6->tcp_rst;
+			tcp_psh = ipv6->tcp_psh;
+			tcp_ack = ipv6->tcp_ack;
+			tcp_urg = ipv6->tcp_urg;
+			sip_eq_dip = ipv6->sip_eq_dip;
+			sport_eq_dport = ipv6->sport_eq_dport;
+			seq_zero = ipv6->seq_zero;
+		}
+
+		vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_IP4_IP4,
+				 ipv4 ? OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
+		vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_IP4_L3_FRAGMENT,
+				 fragment);
+		vcap_key_set(vcap, &data, VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0,
+			     0, 0);
+		vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_IP4_L3_OPTIONS,
+				 options);
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_IP4_L3_IP4_DIP,
+				   dip.value.addr, dip.mask.addr);
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_IP4_L3_IP4_SIP,
+				   sip.value.addr, sip.mask.addr);
+		val = proto.value[0];
+		msk = proto.mask[0];
+		if (msk == 0xff && (val == 6 || val == 17)) {
+			/* UDP/TCP protocol match */
+			tcp = (val == 6 ?
+			       OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
+			vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_IP4_TCP,
+					 tcp);
+			vcap_key_l4_port_set(vcap, &data,
+					     VCAP_IS1_HK_L4_SPORT, sport);
+			vcap_key_set(vcap, &data, VCAP_IS1_HK_IP4_L4_RNG,
+				     0, 0);
+			port.value[0] = sport->value & 0xFF;
+			port.value[1] = sport->value >> 8;
+			port.value[2] = dport->value & 0xFF;
+			port.value[3] = dport->value >> 8;
+			port.mask[0] = sport->mask & 0xFF;
+			port.mask[1] = sport->mask >> 8;
+			port.mask[2] = dport->mask & 0xFF;
+			port.mask[3] = dport->mask >> 8;
+			vcap_key_bytes_set(vcap, &data,
+					   VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE,
+					   port.value, port.mask);
+		}
+		break;
+	}
+	default:
+		break;
+	}
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_TYPE,
+			 type ? OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
+
+	is1_action_set(ocelot, &data, filter);
+	vcap_data_set(data.counter, data.counter_offset,
+		      vcap->counter_width, filter->stats.pkts);
+
+	/* Write row */
+	vcap_entry2cache(ocelot, vcap, &data);
+	vcap_action2cache(ocelot, vcap, &data);
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
+}
+
 static void vcap_entry_get(struct ocelot *ocelot, int ix,
 			   struct ocelot_vcap_filter *filter)
 {
@@ -646,6 +834,8 @@ static void vcap_entry_get(struct ocelot *ocelot, int ix,
 static void vcap_entry_set(struct ocelot *ocelot, int ix,
 			   struct ocelot_vcap_filter *filter)
 {
+	if (filter->block_id == VCAP_IS1)
+		return is1_entry_set(ocelot, ix, filter);
 	if (filter->block_id == VCAP_IS2)
 		return is2_entry_set(ocelot, ix, filter);
 }
@@ -1003,6 +1193,7 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 {
 	int i;
 
+	ocelot_vcap_init_one(ocelot, &ocelot->vcap[VCAP_IS1]);
 	ocelot_vcap_init_one(ocelot, &ocelot->vcap[VCAP_IS2]);
 
 	/* Create a policer that will drop the frames for the cpu.
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index bd876b49f0fa..665b4c3aa200 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -160,6 +160,7 @@ struct ocelot_vcap_key_ipv4 {
 struct ocelot_vcap_key_ipv6 {
 	struct ocelot_vcap_u8 proto; /* IPv6 protocol */
 	struct ocelot_vcap_u128 sip; /* IPv6 source (byte 0-7 ignored) */
+	struct ocelot_vcap_u128 dip; /* IPv6 destination (byte 0-7 ignored) */
 	enum ocelot_vcap_bit ttl;  /* TTL zero */
 	struct ocelot_vcap_u8 ds;
 	struct ocelot_vcap_u48 data; /* Not UDP/TCP: IP data */
@@ -185,6 +186,21 @@ enum ocelot_mask_mode {
 
 struct ocelot_vcap_action {
 	union {
+		/* VCAP IS1 */
+		struct {
+			bool vid_replace_ena;
+			u16 vid;
+			bool vlan_pop_cnt_ena;
+			int vlan_pop_cnt;
+			bool pcp_dei_ena;
+			u8 pcp;
+			u8 dei;
+			bool qos_ena;
+			u8 qos_val;
+			u8 pag_override_mask;
+			u8 pag_val;
+		};
+
 		/* VCAP IS2 */
 		struct {
 			bool cpu_copy_ena;
@@ -217,6 +233,7 @@ struct ocelot_vcap_filter {
 	int block_id;
 	int goto_target;
 	int lookup;
+	u8 pag;
 	u16 prio;
 	u32 id;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index b1ddff256cf6..1dcc98f22541 100644
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
index 22b58f768191..68a16c20a46a 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -265,4 +265,95 @@ enum vcap_is2_action_field {
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

