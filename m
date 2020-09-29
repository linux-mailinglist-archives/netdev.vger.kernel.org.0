Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAB627DC01
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgI2W2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:38 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:6339
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728511AbgI2W2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhgV2Rz8W90TSWnlgllCaouSCzE0V8iFecELM+QduNmhGZ6ZtyrsTu4PrLWB+xK16A2ceqByvuqn4F0ZiQSDSstUDr0FUAavTZ23g6u1nyFbpmq1lhEvK8XpcuF5+plnsGA7/Mwh+9zBJ77Z7TUzwfCdrZ6iQK6rP5uFOqv1U8THdmH+iCUKqVFiUu3YlLKNZBKbPi2/0xJwPcNewnfizUEqSBajh8nBWAg0md/JsmCfM73JxJLWd5VP6GAN9qRO/ZDssVcIB8f58WsIOqs1vEAm679qAX2bKct/OFyFnRIXAnKvvFnTK96UahStmkXs5Wg3tlwbbMrZx71VDTG1tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkmWnfEgSMfgfj4wQSUenoSlCLm//yaqyvWsj2xNT3Q=;
 b=XsEg6YBcnHntzrUr7I4Kg6itGBQjawdVsXhbIYqmnGW4XvmVy61R0OuhnmFduCkmSZAwdAj0ecutYfHtCtBXZh8YyCh0nLbTg79V9nIl52wrC7U6w2txuVZOugo0V8/2hTnE4CIn+YOcChc3buhRwQY3f0Wltk5c8ZAzursIFUWMuDGQt5EvmS4CIO+ruBJTt8KZbWfgtDyoKHtu+rN3wklzZsYTkleFKGTpyIlPW01XOSOXfMaJBOm24nVFZ/qXx6eReeRNbCIoETyL08VNOTHzgL15NYyCklFkxYuMlvLgKiM9OwJjBI3MjGWM5aDmWQa8wIafmgSUTNhsQxvorA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkmWnfEgSMfgfj4wQSUenoSlCLm//yaqyvWsj2xNT3Q=;
 b=n2dAP18UnmK3k2gnceqJKKp3tpZWDqwsHS1nyLu7yZMb+Qyj9id1skWmAF8UQyloobpHshhAVTzkKu6/MojvpAx75CUoMXQPTWx02rONYi6m2pRUEGkT3A85ccPr5YuArX+fHLiJl+BD2ofZIfkANLCVouRa9eAvWm71SbXcfdA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:27:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:27:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 03/13] net: mscc: ocelot: generalize existing code for VCAP
Date:   Wed, 30 Sep 2020 01:27:23 +0300
Message-Id: <20200929222733.770926-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:27:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c6f45c7b-41eb-46a5-ee84-08d864c6ebc4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB279733912B192080C2C89E64E0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujrtdcAhmIW7HbQ/sCbzOUMWUkQ2qnXeWOED0zhiNnkXWWdiFAeSGsLvPNlp+NPiJno4nturXX4vcYE0IAwzU+8GeN1481ULe0MzZaDoDD8v8/tWh7buMzgawPFsgqXO6dEKKheB7VrC8Hl4NfEXm9IUoIvB0JpcdCspXQ+/jCvquOA8oGgwnvw8t5RpRGDukZSK2tMwRNM7a7kHlXrUiwrq51lmqWnrK6vQ3NHk33rJtnEfpbnOx7tQRHSgZBV1P+DPWHts7M4b6P6G1LikmribWYEwftLlzQy6WbEradXPF0WavRNuCLDa+b1fzG7wJ8Kwdf5wGt5WzY7k+oNAcplMiZBMHHMvTSxg/hkijhAv+3OM7o2WbtwwQvP2xcRccuFR2xhQGDL8W2YO8SeFrEYRdndO0n9bT9lIo32OQqHcuoYCdBOiuNyc9cfzEjFC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(30864003)(5660300002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tDeNEAXBqSi4Ni9PV3BMmB+foszwOqL0hgupSE910QqFotN/RvRScvqmRyi8ox8uSaPCAFOppbSgt8H/1LgcaJZsQkb4GGnnwhzk6QeO98zglI9X2mhzj7CFfs/p8VDkc8NW1SMWCx0o6M/7LifvwgQB/CYzkKqDuurH6A4rLIYZ4yq9IPKKkWSeHM2triICZIVpnS14WTjIQCanZ9tr9x9f6O5EeoIm8N4l/24FQzhg7zFnYdCAdU1GevjscX8Tw7BG6qX2/C76imx3rRt8PmsJFaAFAriIqAsHRV+n7u5CJNybqkhpDGTxZCxXZMX0R+Z13C/LFIAKSJrylpg8wfW6TRdgp3msODAu+QYkauLgHCEw1SNYgFoyEcrDMOWs8OZo0sdVbZclMe2iLTq1uRgD0NVP7oVKNkR/MOMwhLaakaaFgVl+X6f1ywh++Zaq1pxdd2glAJdWSZ0xdAn61RTh7A/jUZrdllnZhjMCUmaq33eyLMa4rnvav6HnxwPHwwLqXudjj7wrW3C6SnsVpBR/Rhwc5EUm5/WAOg5ifNAAoP257LJ8wUG4K3BBQCC8RdSuHuU3gT1N+s9kXlGlPjdfJJipuz4e2L2ndisOp3LEEUO35o+77ZAH30tOWqDs2KRaTxQBsPV7k6AEbOekGQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f45c7b-41eb-46a5-ee84-08d864c6ebc4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:27:59.8067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6osj9eTm97Ew6/7wrxeJb5H3efFmPGDDK2C2PGmM8NMMsFgpacv2S/3RXDDL4zmYGqOpCKZU4BmeHM/PGKOpGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the Ocelot switches there are 3 TCAMs: VCAP ES0, IS1 and IS2, which
have the same configuration interface, but different sets of keys and
actions. The driver currently only supports VCAP IS2.

In preparation of VCAP IS1 and ES0 support, the existing code must be
generalized to work with any VCAP.

In that direction, we should move the structures that depend upon VCAP
instantiation, like vcap_is2_keys and vcap_is2_actions, out of struct
ocelot and into struct vcap_props .keys and .actions, a structure that
is replicated 3 times, once per VCAP. We'll pass that structure as an
argument to each function that does the key and action packing - only
the control logic needs to distinguish between ocelot->vcap[VCAP_IS2]
or IS1 or ES0.

Another change is to make use of the newly introduced ocelot_target_read
and ocelot_target_write API, since the 3 VCAPs have the same registers
but put at different addresses.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC v2:
Hopefully clearer commit message.

Changes since RFC v1:
Added VSC9953 and VSC7514 definitions.

 drivers/net/dsa/ocelot/felix.c             |   2 -
 drivers/net/dsa/ocelot/felix.h             |   2 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  25 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  25 +-
 drivers/net/ethernet/mscc/ocelot_s2.h      |  64 ----
 drivers/net/ethernet/mscc/ocelot_vcap.c    | 400 +++++++++++----------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  25 +-
 include/soc/mscc/ocelot.h                  |  22 +-
 include/soc/mscc/ocelot_vcap.h             |  62 ++++
 9 files changed, 327 insertions(+), 300 deletions(-)
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ab3ee5c3fd02..da54363b5c92 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -435,8 +435,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->num_stats	= felix->info->num_stats;
 	ocelot->shared_queue_sz	= felix->info->shared_queue_sz;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
-	ocelot->vcap_is2_keys	= felix->info->vcap_is2_keys;
-	ocelot->vcap_is2_actions= felix->info->vcap_is2_actions;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
 	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index cc3ec83a600a..ec4a8e939bcd 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -21,8 +21,6 @@ struct felix_info {
 	unsigned int			num_stats;
 	int				num_ports;
 	int				num_tx_queues;
-	struct vcap_field		*vcap_is2_keys;
-	struct vcap_field		*vcap_is2_actions;
 	const struct vcap_props		*vcap;
 	int				switch_pci_bar;
 	int				imdio_pci_bar;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index af651ae03572..46ee83dbafbf 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -138,14 +138,16 @@ static const u32 vsc9959_qs_regmap[] = {
 	REG_RESERVED(QS_INH_DBG),
 };
 
-static const u32 vsc9959_s2_regmap[] = {
-	REG(S2_CORE_UPDATE_CTRL,		0x000000),
-	REG(S2_CORE_MV_CFG,			0x000004),
-	REG(S2_CACHE_ENTRY_DAT,			0x000008),
-	REG(S2_CACHE_MASK_DAT,			0x000108),
-	REG(S2_CACHE_ACTION_DAT,		0x000208),
-	REG(S2_CACHE_CNT_DAT,			0x000308),
-	REG(S2_CACHE_TG_DAT,			0x000388),
+static const u32 vsc9959_vcap_regmap[] = {
+	/* VCAP_CORE_CFG */
+	REG(VCAP_CORE_UPDATE_CTRL,		0x000000),
+	REG(VCAP_CORE_MV_CFG,			0x000004),
+	/* VCAP_CORE_CACHE */
+	REG(VCAP_CACHE_ENTRY_DAT,		0x000008),
+	REG(VCAP_CACHE_MASK_DAT,		0x000108),
+	REG(VCAP_CACHE_ACTION_DAT,		0x000208),
+	REG(VCAP_CACHE_CNT_DAT,			0x000308),
+	REG(VCAP_CACHE_TG_DAT,			0x000388),
 };
 
 static const u32 vsc9959_qsys_regmap[] = {
@@ -359,7 +361,7 @@ static const u32 *vsc9959_regmap[TARGET_MAX] = {
 	[QSYS]	= vsc9959_qsys_regmap,
 	[REW]	= vsc9959_rew_regmap,
 	[SYS]	= vsc9959_sys_regmap,
-	[S2]	= vsc9959_s2_regmap,
+	[S2]	= vsc9959_vcap_regmap,
 	[PTP]	= vsc9959_ptp_regmap,
 	[GCB]	= vsc9959_gcb_regmap,
 	[DEV_GMII] = vsc9959_dev_gmii_regmap,
@@ -716,6 +718,9 @@ static const struct vcap_props vsc9959_vcap_props[] = {
 		},
 		.counter_words = 4,
 		.counter_width = 32,
+		.target = S2,
+		.keys = vsc9959_vcap_is2_keys,
+		.actions = vsc9959_vcap_is2_actions,
 	},
 };
 
@@ -1184,8 +1189,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.ops			= &vsc9959_ops,
 	.stats_layout		= vsc9959_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
-	.vcap_is2_keys		= vsc9959_vcap_is2_keys,
-	.vcap_is2_actions	= vsc9959_vcap_is2_actions,
 	.vcap			= vsc9959_vcap_props,
 	.shared_queue_sz	= 128 * 1024,
 	.num_mact_rows		= 2048,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 64e7c1693ab2..3d9692892395 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -140,14 +140,16 @@ static const u32 vsc9953_qs_regmap[] = {
 	REG_RESERVED(QS_INH_DBG),
 };
 
-static const u32 vsc9953_s2_regmap[] = {
-	REG(S2_CORE_UPDATE_CTRL,		0x000000),
-	REG(S2_CORE_MV_CFG,			0x000004),
-	REG(S2_CACHE_ENTRY_DAT,			0x000008),
-	REG(S2_CACHE_MASK_DAT,			0x000108),
-	REG(S2_CACHE_ACTION_DAT,		0x000208),
-	REG(S2_CACHE_CNT_DAT,			0x000308),
-	REG(S2_CACHE_TG_DAT,			0x000388),
+static const u32 vsc9953_vcap_regmap[] = {
+	/* VCAP_CORE_CFG */
+	REG(VCAP_CORE_UPDATE_CTRL,		0x000000),
+	REG(VCAP_CORE_MV_CFG,			0x000004),
+	/* VCAP_CORE_CACHE */
+	REG(VCAP_CACHE_ENTRY_DAT,		0x000008),
+	REG(VCAP_CACHE_MASK_DAT,		0x000108),
+	REG(VCAP_CACHE_ACTION_DAT,		0x000208),
+	REG(VCAP_CACHE_CNT_DAT,			0x000308),
+	REG(VCAP_CACHE_TG_DAT,			0x000388),
 };
 
 static const u32 vsc9953_qsys_regmap[] = {
@@ -352,7 +354,7 @@ static const u32 *vsc9953_regmap[TARGET_MAX] = {
 	[QSYS]		= vsc9953_qsys_regmap,
 	[REW]		= vsc9953_rew_regmap,
 	[SYS]		= vsc9953_sys_regmap,
-	[S2]		= vsc9953_s2_regmap,
+	[S2]		= vsc9953_vcap_regmap,
 	[GCB]		= vsc9953_gcb_regmap,
 	[DEV_GMII]	= vsc9953_dev_gmii_regmap,
 };
@@ -706,6 +708,9 @@ static const struct vcap_props vsc9953_vcap_props[] = {
 		},
 		.counter_words = 4,
 		.counter_width = 32,
+		.target = S2,
+		.keys = vsc9953_vcap_is2_keys,
+		.actions = vsc9953_vcap_is2_actions,
 	},
 };
 
@@ -1031,8 +1036,6 @@ static const struct felix_info seville_info_vsc9953 = {
 	.ops			= &vsc9953_ops,
 	.stats_layout		= vsc9953_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9953_stats_layout),
-	.vcap_is2_keys		= vsc9953_vcap_is2_keys,
-	.vcap_is2_actions	= vsc9953_vcap_is2_actions,
 	.vcap			= vsc9953_vcap_props,
 	.shared_queue_sz	= 2048 * 1024,
 	.num_mact_rows		= 2048,
diff --git a/drivers/net/ethernet/mscc/ocelot_s2.h b/drivers/net/ethernet/mscc/ocelot_s2.h
deleted file mode 100644
index 80107bec2e45..000000000000
--- a/drivers/net/ethernet/mscc/ocelot_s2.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
-/* Microsemi Ocelot Switch driver
- * Copyright (c) 2018 Microsemi Corporation
- */
-
-#ifndef _OCELOT_S2_CORE_H_
-#define _OCELOT_S2_CORE_H_
-
-#define S2_CORE_UPDATE_CTRL_UPDATE_CMD(x)      (((x) << 22) & GENMASK(24, 22))
-#define S2_CORE_UPDATE_CTRL_UPDATE_CMD_M       GENMASK(24, 22)
-#define S2_CORE_UPDATE_CTRL_UPDATE_CMD_X(x)    (((x) & GENMASK(24, 22)) >> 22)
-#define S2_CORE_UPDATE_CTRL_UPDATE_ENTRY_DIS   BIT(21)
-#define S2_CORE_UPDATE_CTRL_UPDATE_ACTION_DIS  BIT(20)
-#define S2_CORE_UPDATE_CTRL_UPDATE_CNT_DIS     BIT(19)
-#define S2_CORE_UPDATE_CTRL_UPDATE_ADDR(x)     (((x) << 3) & GENMASK(18, 3))
-#define S2_CORE_UPDATE_CTRL_UPDATE_ADDR_M      GENMASK(18, 3)
-#define S2_CORE_UPDATE_CTRL_UPDATE_ADDR_X(x)   (((x) & GENMASK(18, 3)) >> 3)
-#define S2_CORE_UPDATE_CTRL_UPDATE_SHOT        BIT(2)
-#define S2_CORE_UPDATE_CTRL_CLEAR_CACHE        BIT(1)
-#define S2_CORE_UPDATE_CTRL_MV_TRAFFIC_IGN     BIT(0)
-
-#define S2_CORE_MV_CFG_MV_NUM_POS(x)           (((x) << 16) & GENMASK(31, 16))
-#define S2_CORE_MV_CFG_MV_NUM_POS_M            GENMASK(31, 16)
-#define S2_CORE_MV_CFG_MV_NUM_POS_X(x)         (((x) & GENMASK(31, 16)) >> 16)
-#define S2_CORE_MV_CFG_MV_SIZE(x)              ((x) & GENMASK(15, 0))
-#define S2_CORE_MV_CFG_MV_SIZE_M               GENMASK(15, 0)
-
-#define S2_CACHE_ENTRY_DAT_RSZ                 0x4
-
-#define S2_CACHE_MASK_DAT_RSZ                  0x4
-
-#define S2_CACHE_ACTION_DAT_RSZ                0x4
-
-#define S2_CACHE_CNT_DAT_RSZ                   0x4
-
-#define S2_STICKY_VCAP_ROW_DELETED_STICKY      BIT(0)
-
-#define S2_BIST_CTRL_TCAM_BIST                 BIT(1)
-#define S2_BIST_CTRL_TCAM_INIT                 BIT(0)
-
-#define S2_BIST_CFG_TCAM_BIST_SOE_ENA          BIT(8)
-#define S2_BIST_CFG_TCAM_HCG_DIS               BIT(7)
-#define S2_BIST_CFG_TCAM_CG_DIS                BIT(6)
-#define S2_BIST_CFG_TCAM_BIAS(x)               ((x) & GENMASK(5, 0))
-#define S2_BIST_CFG_TCAM_BIAS_M                GENMASK(5, 0)
-
-#define S2_BIST_STAT_BIST_RT_ERR               BIT(15)
-#define S2_BIST_STAT_BIST_PENC_ERR             BIT(14)
-#define S2_BIST_STAT_BIST_COMP_ERR             BIT(13)
-#define S2_BIST_STAT_BIST_ADDR_ERR             BIT(12)
-#define S2_BIST_STAT_BIST_BL1E_ERR             BIT(11)
-#define S2_BIST_STAT_BIST_BL1_ERR              BIT(10)
-#define S2_BIST_STAT_BIST_BL0E_ERR             BIT(9)
-#define S2_BIST_STAT_BIST_BL0_ERR              BIT(8)
-#define S2_BIST_STAT_BIST_PH1_ERR              BIT(7)
-#define S2_BIST_STAT_BIST_PH0_ERR              BIT(6)
-#define S2_BIST_STAT_BIST_PV1_ERR              BIT(5)
-#define S2_BIST_STAT_BIST_PV0_ERR              BIT(4)
-#define S2_BIST_STAT_BIST_RUN                  BIT(3)
-#define S2_BIST_STAT_BIST_ERR                  BIT(2)
-#define S2_BIST_STAT_BIST_BUSY                 BIT(1)
-#define S2_BIST_STAT_TCAM_RDY                  BIT(0)
-
-#endif /* _OCELOT_S2_CORE_H_ */
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 51d442ca5cb3..1755979e3f36 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -9,7 +9,6 @@
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot_police.h"
 #include "ocelot_vcap.h"
-#include "ocelot_s2.h"
 
 #define OCELOT_POLICER_DISCARD 0x17f
 #define ENTRY_WIDTH 32
@@ -48,128 +47,140 @@ struct vcap_data {
 	u32 tg_mask; /* Current type-group mask */
 };
 
-static u32 vcap_s2_read_update_ctrl(struct ocelot *ocelot)
+static u32 vcap_read_update_ctrl(struct ocelot *ocelot,
+				 const struct vcap_props *vcap)
 {
-	return ocelot_read(ocelot, S2_CORE_UPDATE_CTRL);
+	return ocelot_target_read(ocelot, vcap->target, VCAP_CORE_UPDATE_CTRL);
 }
 
-static void vcap_cmd(struct ocelot *ocelot, u16 ix, int cmd, int sel)
+static void vcap_cmd(struct ocelot *ocelot, const struct vcap_props *vcap,
+		     u16 ix, int cmd, int sel)
 {
-	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
+	u32 value = (VCAP_CORE_UPDATE_CTRL_UPDATE_CMD(cmd) |
+		     VCAP_CORE_UPDATE_CTRL_UPDATE_ADDR(ix) |
+		     VCAP_CORE_UPDATE_CTRL_UPDATE_SHOT);
 
-	u32 value = (S2_CORE_UPDATE_CTRL_UPDATE_CMD(cmd) |
-		     S2_CORE_UPDATE_CTRL_UPDATE_ADDR(ix) |
-		     S2_CORE_UPDATE_CTRL_UPDATE_SHOT);
-
-	if ((sel & VCAP_SEL_ENTRY) && ix >= vcap_is2->entry_count)
+	if ((sel & VCAP_SEL_ENTRY) && ix >= vcap->entry_count)
 		return;
 
 	if (!(sel & VCAP_SEL_ENTRY))
-		value |= S2_CORE_UPDATE_CTRL_UPDATE_ENTRY_DIS;
+		value |= VCAP_CORE_UPDATE_CTRL_UPDATE_ENTRY_DIS;
 
 	if (!(sel & VCAP_SEL_ACTION))
-		value |= S2_CORE_UPDATE_CTRL_UPDATE_ACTION_DIS;
+		value |= VCAP_CORE_UPDATE_CTRL_UPDATE_ACTION_DIS;
 
 	if (!(sel & VCAP_SEL_COUNTER))
-		value |= S2_CORE_UPDATE_CTRL_UPDATE_CNT_DIS;
+		value |= VCAP_CORE_UPDATE_CTRL_UPDATE_CNT_DIS;
+
+	ocelot_target_write(ocelot, vcap->target, value, VCAP_CORE_UPDATE_CTRL);
 
-	ocelot_write(ocelot, value, S2_CORE_UPDATE_CTRL);
-	readx_poll_timeout(vcap_s2_read_update_ctrl, ocelot, value,
-				(value & S2_CORE_UPDATE_CTRL_UPDATE_SHOT) == 0,
-				10, 100000);
+	read_poll_timeout(vcap_read_update_ctrl, value,
+			  (value & VCAP_CORE_UPDATE_CTRL_UPDATE_SHOT) == 0,
+			  10, 100000, false, ocelot, vcap);
 }
 
 /* Convert from 0-based row to VCAP entry row and run command */
-static void vcap_row_cmd(struct ocelot *ocelot, u32 row, int cmd, int sel)
+static void vcap_row_cmd(struct ocelot *ocelot, const struct vcap_props *vcap,
+			 u32 row, int cmd, int sel)
 {
-	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
-
-	vcap_cmd(ocelot, vcap_is2->entry_count - row - 1, cmd, sel);
+	vcap_cmd(ocelot, vcap, vcap->entry_count - row - 1, cmd, sel);
 }
 
-static void vcap_entry2cache(struct ocelot *ocelot, struct vcap_data *data)
+static void vcap_entry2cache(struct ocelot *ocelot,
+			     const struct vcap_props *vcap,
+			     struct vcap_data *data)
 {
-	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
 	u32 entry_words, i;
 
-	entry_words = DIV_ROUND_UP(vcap_is2->entry_width, ENTRY_WIDTH);
+	entry_words = DIV_ROUND_UP(vcap->entry_width, ENTRY_WIDTH);
 
 	for (i = 0; i < entry_words; i++) {
-		ocelot_write_rix(ocelot, data->entry[i], S2_CACHE_ENTRY_DAT, i);
-		ocelot_write_rix(ocelot, ~data->mask[i], S2_CACHE_MASK_DAT, i);
+		ocelot_target_write_rix(ocelot, vcap->target, data->entry[i],
+					VCAP_CACHE_ENTRY_DAT, i);
+		ocelot_target_write_rix(ocelot, vcap->target, ~data->mask[i],
+					VCAP_CACHE_MASK_DAT, i);
 	}
-	ocelot_write(ocelot, data->tg, S2_CACHE_TG_DAT);
+	ocelot_target_write(ocelot, vcap->target, data->tg, VCAP_CACHE_TG_DAT);
 }
 
-static void vcap_cache2entry(struct ocelot *ocelot, struct vcap_data *data)
+static void vcap_cache2entry(struct ocelot *ocelot,
+			     const struct vcap_props *vcap,
+			     struct vcap_data *data)
 {
-	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
 	u32 entry_words, i;
 
-	entry_words = DIV_ROUND_UP(vcap_is2->entry_width, ENTRY_WIDTH);
+	entry_words = DIV_ROUND_UP(vcap->entry_width, ENTRY_WIDTH);
 
 	for (i = 0; i < entry_words; i++) {
-		data->entry[i] = ocelot_read_rix(ocelot, S2_CACHE_ENTRY_DAT, i);
+		data->entry[i] = ocelot_target_read_rix(ocelot, vcap->target,
+							VCAP_CACHE_ENTRY_DAT, i);
 		// Invert mask
-		data->mask[i] = ~ocelot_read_rix(ocelot, S2_CACHE_MASK_DAT, i);
+		data->mask[i] = ~ocelot_target_read_rix(ocelot, vcap->target,
+							VCAP_CACHE_MASK_DAT, i);
 	}
-	data->tg = ocelot_read(ocelot, S2_CACHE_TG_DAT);
+	data->tg = ocelot_target_read(ocelot, vcap->target, VCAP_CACHE_TG_DAT);
 }
 
-static void vcap_action2cache(struct ocelot *ocelot, struct vcap_data *data)
+static void vcap_action2cache(struct ocelot *ocelot,
+			      const struct vcap_props *vcap,
+			      struct vcap_data *data)
 {
-	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
 	u32 action_words, mask;
 	int i, width;
 
 	/* Encode action type */
-	width = vcap_is2->action_type_width;
+	width = vcap->action_type_width;
 	if (width) {
 		mask = GENMASK(width, 0);
 		data->action[0] = ((data->action[0] & ~mask) | data->type);
 	}
 
-	action_words = DIV_ROUND_UP(vcap_is2->action_width, ENTRY_WIDTH);
+	action_words = DIV_ROUND_UP(vcap->action_width, ENTRY_WIDTH);
 
 	for (i = 0; i < action_words; i++)
-		ocelot_write_rix(ocelot, data->action[i], S2_CACHE_ACTION_DAT,
-				 i);
+		ocelot_target_write_rix(ocelot, vcap->target, data->action[i],
+					VCAP_CACHE_ACTION_DAT, i);
 
-	for (i = 0; i < vcap_is2->counter_words; i++)
-		ocelot_write_rix(ocelot, data->counter[i], S2_CACHE_CNT_DAT, i);
+	for (i = 0; i < vcap->counter_words; i++)
+		ocelot_target_write_rix(ocelot, vcap->target, data->counter[i],
+					VCAP_CACHE_CNT_DAT, i);
 }
 
-static void vcap_cache2action(struct ocelot *ocelot, struct vcap_data *data)
+static void vcap_cache2action(struct ocelot *ocelot,
+			      const struct vcap_props *vcap,
+			      struct vcap_data *data)
 {
-	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
 	u32 action_words;
 	int i, width;
 
-	action_words = DIV_ROUND_UP(vcap_is2->action_width, ENTRY_WIDTH);
+	action_words = DIV_ROUND_UP(vcap->action_width, ENTRY_WIDTH);
 
 	for (i = 0; i < action_words; i++)
-		data->action[i] = ocelot_read_rix(ocelot, S2_CACHE_ACTION_DAT,
-						  i);
+		data->action[i] = ocelot_target_read_rix(ocelot, vcap->target,
+							 VCAP_CACHE_ACTION_DAT,
+							 i);
 
-	for (i = 0; i < vcap_is2->counter_words; i++)
-		data->counter[i] = ocelot_read_rix(ocelot, S2_CACHE_CNT_DAT, i);
+	for (i = 0; i < vcap->counter_words; i++)
+		data->counter[i] = ocelot_target_read_rix(ocelot, vcap->target,
+							  VCAP_CACHE_CNT_DAT,
+							  i);
 
 	/* Extract action type */
-	width = vcap_is2->action_type_width;
+	width = vcap->action_type_width;
 	data->type = (width ? (data->action[0] & GENMASK(width, 0)) : 0);
 }
 
 /* Calculate offsets for entry */
-static void is2_data_get(struct ocelot *ocelot, struct vcap_data *data, int ix)
+static void vcap_data_offset_get(const struct vcap_props *vcap,
+				 struct vcap_data *data, int ix)
 {
-	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
 	int i, col, offset, count, cnt, base;
-	int width = vcap_is2->tg_width;
+	u32 width = vcap->tg_width;
 
 	count = (data->tg_sw == VCAP_TG_HALF ? 2 : 4);
 	col = (ix % 2);
-	cnt = (vcap_is2->sw_count / count);
-	base = (vcap_is2->sw_count - col * cnt - cnt);
+	cnt = (vcap->sw_count / count);
+	base = (vcap->sw_count - col * cnt - cnt);
 	data->tg_value = 0;
 	data->tg_mask = 0;
 	for (i = 0; i < cnt; i++) {
@@ -180,13 +191,13 @@ static void is2_data_get(struct ocelot *ocelot, struct vcap_data *data, int ix)
 
 	/* Calculate key/action/counter offsets */
 	col = (count - col - 1);
-	data->key_offset = (base * vcap_is2->entry_width) / vcap_is2->sw_count;
-	data->counter_offset = (cnt * col * vcap_is2->counter_width);
+	data->key_offset = (base * vcap->entry_width) / vcap->sw_count;
+	data->counter_offset = (cnt * col * vcap->counter_width);
 	i = data->type;
-	width = vcap_is2->action_table[i].width;
-	cnt = vcap_is2->action_table[i].count;
-	data->action_offset =
-		(((cnt * col * width) / count) + vcap_is2->action_type_width);
+	width = vcap->action_table[i].width;
+	cnt = vcap->action_table[i].count;
+	data->action_offset = (((cnt * col * width) / count) +
+			      vcap->action_type_width);
 }
 
 static void vcap_data_set(u32 *data, u32 offset, u32 len, u32 value)
@@ -224,22 +235,21 @@ static void vcap_key_field_set(struct vcap_data *data, u32 offset, u32 width,
 	vcap_data_set(data->mask, offset + data->key_offset, width, mask);
 }
 
-static void vcap_key_set(struct ocelot *ocelot, struct vcap_data *data,
-			 enum vcap_is2_half_key_field field,
-			 u32 value, u32 mask)
+static void vcap_key_set(const struct vcap_props *vcap, struct vcap_data *data,
+			 int field, u32 value, u32 mask)
 {
-	u32 offset = ocelot->vcap_is2_keys[field].offset;
-	u32 length = ocelot->vcap_is2_keys[field].length;
+	u32 offset = vcap->keys[field].offset;
+	u32 length = vcap->keys[field].length;
 
 	vcap_key_field_set(data, offset, length, value, mask);
 }
 
-static void vcap_key_bytes_set(struct ocelot *ocelot, struct vcap_data *data,
-			       enum vcap_is2_half_key_field field,
+static void vcap_key_bytes_set(const struct vcap_props *vcap,
+			       struct vcap_data *data, int field,
 			       u8 *val, u8 *msk)
 {
-	u32 offset = ocelot->vcap_is2_keys[field].offset;
-	u32 count  = ocelot->vcap_is2_keys[field].length;
+	u32 offset = vcap->keys[field].offset;
+	u32 count  = vcap->keys[field].length;
 	u32 i, j, n = 0, value = 0, mask = 0;
 
 	WARN_ON(count % 8);
@@ -265,37 +275,37 @@ static void vcap_key_bytes_set(struct ocelot *ocelot, struct vcap_data *data,
 	}
 }
 
-static void vcap_key_l4_port_set(struct ocelot *ocelot, struct vcap_data *data,
-				 enum vcap_is2_half_key_field field,
+static void vcap_key_l4_port_set(const struct vcap_props *vcap,
+				 struct vcap_data *data, int field,
 				 struct ocelot_vcap_udp_tcp *port)
 {
-	u32 offset = ocelot->vcap_is2_keys[field].offset;
-	u32 length = ocelot->vcap_is2_keys[field].length;
+	u32 offset = vcap->keys[field].offset;
+	u32 length = vcap->keys[field].length;
 
 	WARN_ON(length != 16);
 
 	vcap_key_field_set(data, offset, length, port->value, port->mask);
 }
 
-static void vcap_key_bit_set(struct ocelot *ocelot, struct vcap_data *data,
-			     enum vcap_is2_half_key_field field,
+static void vcap_key_bit_set(const struct vcap_props *vcap,
+			     struct vcap_data *data, int field,
 			     enum ocelot_vcap_bit val)
 {
-	u32 offset = ocelot->vcap_is2_keys[field].offset;
-	u32 length = ocelot->vcap_is2_keys[field].length;
 	u32 value = (val == OCELOT_VCAP_BIT_1 ? 1 : 0);
 	u32 msk = (val == OCELOT_VCAP_BIT_ANY ? 0 : 1);
+	u32 offset = vcap->keys[field].offset;
+	u32 length = vcap->keys[field].length;
 
 	WARN_ON(length != 1);
 
 	vcap_key_field_set(data, offset, length, value, msk);
 }
 
-static void vcap_action_set(struct ocelot *ocelot, struct vcap_data *data,
-			    enum vcap_is2_action_field field, u32 value)
+static void vcap_action_set(const struct vcap_props *vcap,
+			    struct vcap_data *data, int field, u32 value)
 {
-	int offset = ocelot->vcap_is2_actions[field].offset;
-	int length = ocelot->vcap_is2_actions[field].length;
+	int offset = vcap->actions[field].offset;
+	int length = vcap->actions[field].length;
 
 	vcap_data_set(data->action, offset + data->action_offset, length,
 		      value);
@@ -304,32 +314,34 @@ static void vcap_action_set(struct ocelot *ocelot, struct vcap_data *data,
 static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 			   struct ocelot_vcap_filter *filter)
 {
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
+
 	switch (filter->action) {
 	case OCELOT_VCAP_ACTION_DROP:
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 1);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 1);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_IDX,
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, 1);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, 1);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX,
 				OCELOT_POLICER_DISCARD);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
 		break;
 	case OCELOT_VCAP_ACTION_TRAP:
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 1);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 0);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_IDX, 0);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 1);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, 1);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 1);
 		break;
 	case OCELOT_VCAP_ACTION_POLICE:
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 0);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 1);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_IDX,
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_PORT_MASK, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_MASK_MODE, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_ENA, 1);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_POLICE_IDX,
 				filter->pol_ix);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
-		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
+		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
 		break;
 	}
 }
@@ -337,7 +349,7 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 static void is2_entry_set(struct ocelot *ocelot, int ix,
 			  struct ocelot_vcap_filter *filter)
 {
-	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
 	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
 	u32 val, msk, type, type_mask = 0xf, i, count;
 	struct ocelot_vcap_u64 payload;
@@ -348,52 +360,52 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	memset(&data, 0, sizeof(data));
 
 	/* Read row */
-	vcap_row_cmd(ocelot, row, VCAP_CMD_READ, VCAP_SEL_ALL);
-	vcap_cache2entry(ocelot, &data);
-	vcap_cache2action(ocelot, &data);
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_ALL);
+	vcap_cache2entry(ocelot, vcap, &data);
+	vcap_cache2action(ocelot, vcap, &data);
 
 	data.tg_sw = VCAP_TG_HALF;
-	is2_data_get(ocelot, &data, ix);
+	vcap_data_offset_get(vcap, &data, ix);
 	data.tg = (data.tg & ~data.tg_mask);
 	if (filter->prio != 0)
 		data.tg |= data.tg_value;
 
 	data.type = IS2_ACTION_TYPE_NORMAL;
 
-	vcap_key_set(ocelot, &data, VCAP_IS2_HK_PAG, 0, 0);
-	vcap_key_set(ocelot, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
+	vcap_key_set(vcap, &data, VCAP_IS2_HK_PAG, 0, 0);
+	vcap_key_set(vcap, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
-	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_1);
-	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_HOST_MATCH,
+	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_ANY);
+	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_HOST_MATCH,
 			 OCELOT_VCAP_BIT_ANY);
-	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L2_MC, filter->dmac_mc);
-	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L2_BC, filter->dmac_bc);
-	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_VLAN_TAGGED, tag->tagged);
-	vcap_key_set(ocelot, &data, VCAP_IS2_HK_VID,
+	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L2_MC, filter->dmac_mc);
+	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L2_BC, filter->dmac_bc);
+	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_VLAN_TAGGED, tag->tagged);
+	vcap_key_set(vcap, &data, VCAP_IS2_HK_VID,
 		     tag->vid.value, tag->vid.mask);
-	vcap_key_set(ocelot, &data, VCAP_IS2_HK_PCP,
+	vcap_key_set(vcap, &data, VCAP_IS2_HK_PCP,
 		     tag->pcp.value[0], tag->pcp.mask[0]);
-	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_DEI, tag->dei);
+	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_DEI, tag->dei);
 
 	switch (filter->key_type) {
 	case OCELOT_VCAP_KEY_ETYPE: {
 		struct ocelot_vcap_key_etype *etype = &filter->key.etype;
 
 		type = IS2_TYPE_ETYPE;
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_DMAC,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_L2_DMAC,
 				   etype->dmac.value, etype->dmac.mask);
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_SMAC,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_L2_SMAC,
 				   etype->smac.value, etype->smac.mask);
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_MAC_ETYPE_ETYPE,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_MAC_ETYPE_ETYPE,
 				   etype->etype.value, etype->etype.mask);
 		/* Clear unused bits */
-		vcap_key_set(ocelot, &data, VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0,
+		vcap_key_set(vcap, &data, VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0,
 			     0, 0);
-		vcap_key_set(ocelot, &data, VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1,
+		vcap_key_set(vcap, &data, VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1,
 			     0, 0);
-		vcap_key_set(ocelot, &data, VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2,
+		vcap_key_set(vcap, &data, VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2,
 			     0, 0);
-		vcap_key_bytes_set(ocelot, &data,
+		vcap_key_bytes_set(vcap, &data,
 				   VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0,
 				   etype->data.value, etype->data.mask);
 		break;
@@ -402,15 +414,15 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 		struct ocelot_vcap_key_llc *llc = &filter->key.llc;
 
 		type = IS2_TYPE_LLC;
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_DMAC,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_L2_DMAC,
 				   llc->dmac.value, llc->dmac.mask);
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_SMAC,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_L2_SMAC,
 				   llc->smac.value, llc->smac.mask);
 		for (i = 0; i < 4; i++) {
 			payload.value[i] = llc->llc.value[i];
 			payload.mask[i] = llc->llc.mask[i];
 		}
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_MAC_LLC_L2_LLC,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_MAC_LLC_L2_LLC,
 				   payload.value, payload.mask);
 		break;
 	}
@@ -418,11 +430,11 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 		struct ocelot_vcap_key_snap *snap = &filter->key.snap;
 
 		type = IS2_TYPE_SNAP;
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_DMAC,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_L2_DMAC,
 				   snap->dmac.value, snap->dmac.mask);
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_SMAC,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_L2_SMAC,
 				   snap->smac.value, snap->smac.mask);
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_MAC_SNAP_L2_SNAP,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_MAC_SNAP_L2_SNAP,
 				   filter->key.snap.snap.value,
 				   filter->key.snap.snap.mask);
 		break;
@@ -431,24 +443,24 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 		struct ocelot_vcap_key_arp *arp = &filter->key.arp;
 
 		type = IS2_TYPE_ARP;
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_MAC_ARP_SMAC,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_MAC_ARP_SMAC,
 				   arp->smac.value, arp->smac.mask);
-		vcap_key_bit_set(ocelot, &data,
+		vcap_key_bit_set(vcap, &data,
 				 VCAP_IS2_HK_MAC_ARP_ADDR_SPACE_OK,
 				 arp->ethernet);
-		vcap_key_bit_set(ocelot, &data,
+		vcap_key_bit_set(vcap, &data,
 				 VCAP_IS2_HK_MAC_ARP_PROTO_SPACE_OK,
 				 arp->ip);
-		vcap_key_bit_set(ocelot, &data,
+		vcap_key_bit_set(vcap, &data,
 				 VCAP_IS2_HK_MAC_ARP_LEN_OK,
 				 arp->length);
-		vcap_key_bit_set(ocelot, &data,
+		vcap_key_bit_set(vcap, &data,
 				 VCAP_IS2_HK_MAC_ARP_TARGET_MATCH,
 				 arp->dmac_match);
-		vcap_key_bit_set(ocelot, &data,
+		vcap_key_bit_set(vcap, &data,
 				 VCAP_IS2_HK_MAC_ARP_SENDER_MATCH,
 				 arp->smac_match);
-		vcap_key_bit_set(ocelot, &data,
+		vcap_key_bit_set(vcap, &data,
 				 VCAP_IS2_HK_MAC_ARP_OPCODE_UNKNOWN,
 				 arp->unknown);
 
@@ -457,15 +469,15 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 		       (arp->arp == OCELOT_VCAP_BIT_0 ? 2 : 0));
 		msk = ((arp->req == OCELOT_VCAP_BIT_ANY ? 0 : 1) |
 		       (arp->arp == OCELOT_VCAP_BIT_ANY ? 0 : 2));
-		vcap_key_set(ocelot, &data, VCAP_IS2_HK_MAC_ARP_OPCODE,
+		vcap_key_set(vcap, &data, VCAP_IS2_HK_MAC_ARP_OPCODE,
 			     val, msk);
-		vcap_key_bytes_set(ocelot, &data,
+		vcap_key_bytes_set(vcap, &data,
 				   VCAP_IS2_HK_MAC_ARP_L3_IP4_DIP,
 				   arp->dip.value.addr, arp->dip.mask.addr);
-		vcap_key_bytes_set(ocelot, &data,
+		vcap_key_bytes_set(vcap, &data,
 				   VCAP_IS2_HK_MAC_ARP_L3_IP4_SIP,
 				   arp->sip.value.addr, arp->sip.mask.addr);
-		vcap_key_set(ocelot, &data, VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP,
+		vcap_key_set(vcap, &data, VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP,
 			     0, 0);
 		break;
 	}
@@ -534,22 +546,22 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 			seq_zero = ipv6->seq_zero;
 		}
 
-		vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_IP4,
+		vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_IP4,
 				 ipv4 ? OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
-		vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L3_FRAGMENT,
+		vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L3_FRAGMENT,
 				 fragment);
-		vcap_key_set(ocelot, &data, VCAP_IS2_HK_L3_FRAG_OFS_GT0, 0, 0);
-		vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L3_OPTIONS,
+		vcap_key_set(vcap, &data, VCAP_IS2_HK_L3_FRAG_OFS_GT0, 0, 0);
+		vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L3_OPTIONS,
 				 options);
-		vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_IP4_L3_TTL_GT0,
+		vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_IP4_L3_TTL_GT0,
 				 ttl);
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L3_TOS,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_L3_TOS,
 				   ds.value, ds.mask);
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L3_IP4_DIP,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_L3_IP4_DIP,
 				   dip.value.addr, dip.mask.addr);
-		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L3_IP4_SIP,
+		vcap_key_bytes_set(vcap, &data, VCAP_IS2_HK_L3_IP4_SIP,
 				   sip.value.addr, sip.mask.addr);
-		vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_DIP_EQ_SIP,
+		vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_DIP_EQ_SIP,
 				 sip_eq_dip);
 		val = proto.value[0];
 		msk = proto.mask[0];
@@ -558,33 +570,33 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 			/* UDP/TCP protocol match */
 			tcp = (val == 6 ?
 			       OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
-			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_TCP, tcp);
-			vcap_key_l4_port_set(ocelot, &data,
+			vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_TCP, tcp);
+			vcap_key_l4_port_set(vcap, &data,
 					     VCAP_IS2_HK_L4_DPORT, dport);
-			vcap_key_l4_port_set(ocelot, &data,
+			vcap_key_l4_port_set(vcap, &data,
 					     VCAP_IS2_HK_L4_SPORT, sport);
-			vcap_key_set(ocelot, &data, VCAP_IS2_HK_L4_RNG, 0, 0);
-			vcap_key_bit_set(ocelot, &data,
+			vcap_key_set(vcap, &data, VCAP_IS2_HK_L4_RNG, 0, 0);
+			vcap_key_bit_set(vcap, &data,
 					 VCAP_IS2_HK_L4_SPORT_EQ_DPORT,
 					 sport_eq_dport);
-			vcap_key_bit_set(ocelot, &data,
+			vcap_key_bit_set(vcap, &data,
 					 VCAP_IS2_HK_L4_SEQUENCE_EQ0,
 					 seq_zero);
-			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_FIN,
+			vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L4_FIN,
 					 tcp_fin);
-			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_SYN,
+			vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L4_SYN,
 					 tcp_syn);
-			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_RST,
+			vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L4_RST,
 					 tcp_rst);
-			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_PSH,
+			vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L4_PSH,
 					 tcp_psh);
-			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_ACK,
+			vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L4_ACK,
 					 tcp_ack);
-			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_URG,
+			vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L4_URG,
 					 tcp_urg);
-			vcap_key_set(ocelot, &data, VCAP_IS2_HK_L4_1588_DOM,
+			vcap_key_set(vcap, &data, VCAP_IS2_HK_L4_1588_DOM,
 				     0, 0);
-			vcap_key_set(ocelot, &data, VCAP_IS2_HK_L4_1588_VER,
+			vcap_key_set(vcap, &data, VCAP_IS2_HK_L4_1588_VER,
 				     0, 0);
 		} else {
 			if (msk == 0) {
@@ -598,10 +610,10 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 					payload.mask[i] = ip_data->mask[i];
 				}
 			}
-			vcap_key_bytes_set(ocelot, &data,
+			vcap_key_bytes_set(vcap, &data,
 					   VCAP_IS2_HK_IP4_L3_PROTO,
 					   proto.value, proto.mask);
-			vcap_key_bytes_set(ocelot, &data,
+			vcap_key_bytes_set(vcap, &data,
 					   VCAP_IS2_HK_L3_PAYLOAD,
 					   payload.value, payload.mask);
 		}
@@ -611,42 +623,44 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	default:
 		type = 0;
 		type_mask = 0;
-		count = vcap_is2->entry_width / 2;
+		count = vcap->entry_width / 2;
 		/* Iterate over the non-common part of the key and
 		 * clear entry data
 		 */
-		for (i = ocelot->vcap_is2_keys[VCAP_IS2_HK_L2_DMAC].offset;
+		for (i = vcap->keys[VCAP_IS2_HK_L2_DMAC].offset;
 		     i < count; i += ENTRY_WIDTH) {
 			vcap_key_field_set(&data, i, min(32u, count - i), 0, 0);
 		}
 		break;
 	}
 
-	vcap_key_set(ocelot, &data, VCAP_IS2_TYPE, type, type_mask);
+	vcap_key_set(vcap, &data, VCAP_IS2_TYPE, type, type_mask);
 	is2_action_set(ocelot, &data, filter);
 	vcap_data_set(data.counter, data.counter_offset,
-		      vcap_is2->counter_width, filter->stats.pkts);
+		      vcap->counter_width, filter->stats.pkts);
 
 	/* Write row */
-	vcap_entry2cache(ocelot, &data);
-	vcap_action2cache(ocelot, &data);
-	vcap_row_cmd(ocelot, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
+	vcap_entry2cache(ocelot, vcap, &data);
+	vcap_action2cache(ocelot, vcap, &data);
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
 }
 
-static void is2_entry_get(struct ocelot *ocelot, struct ocelot_vcap_filter *filter,
-			  int ix)
+static void
+vcap_entry_get(struct ocelot *ocelot, struct ocelot_vcap_filter *filter, int ix)
 {
-	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
 	struct vcap_data data;
-	int row = (ix / 2);
+	int row, count;
 	u32 cnt;
 
-	vcap_row_cmd(ocelot, row, VCAP_CMD_READ, VCAP_SEL_COUNTER);
-	vcap_cache2action(ocelot, &data);
 	data.tg_sw = VCAP_TG_HALF;
-	is2_data_get(ocelot, &data, ix);
+	count = (1 << (data.tg_sw - 1));
+	row = (ix / count);
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_COUNTER);
+	vcap_cache2action(ocelot, vcap, &data);
+	vcap_data_offset_get(vcap, &data, ix);
 	cnt = vcap_data_get(data.counter, data.counter_offset,
-			    vcap_is2->counter_width);
+			    vcap->counter_width);
 
 	filter->stats.pkts = cnt;
 }
@@ -958,7 +972,7 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 	if (index < 0)
 		return index;
 
-	is2_entry_get(ocelot, filter, index);
+	vcap_entry_get(ocelot, filter, index);
 
 	/* After we get the result we need to clear the counters */
 	tmp = ocelot_vcap_block_find_filter(block, index);
@@ -968,22 +982,30 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 	return 0;
 }
 
-int ocelot_vcap_init(struct ocelot *ocelot)
+static void ocelot_vcap_init_one(struct ocelot *ocelot,
+				 const struct vcap_props *vcap)
 {
-	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
-	struct ocelot_vcap_block *block = &ocelot->block;
 	struct vcap_data data;
 
 	memset(&data, 0, sizeof(data));
 
-	vcap_entry2cache(ocelot, &data);
-	ocelot_write(ocelot, vcap_is2->entry_count, S2_CORE_MV_CFG);
-	vcap_cmd(ocelot, 0, VCAP_CMD_INITIALIZE, VCAP_SEL_ENTRY);
+	vcap_entry2cache(ocelot, vcap, &data);
+	ocelot_target_write(ocelot, vcap->target, vcap->entry_count,
+			    VCAP_CORE_MV_CFG);
+	vcap_cmd(ocelot, vcap, 0, VCAP_CMD_INITIALIZE, VCAP_SEL_ENTRY);
 
-	vcap_action2cache(ocelot, &data);
-	ocelot_write(ocelot, vcap_is2->action_count, S2_CORE_MV_CFG);
-	vcap_cmd(ocelot, 0, VCAP_CMD_INITIALIZE,
+	vcap_action2cache(ocelot, vcap, &data);
+	ocelot_target_write(ocelot, vcap->target, vcap->action_count,
+			    VCAP_CORE_MV_CFG);
+	vcap_cmd(ocelot, vcap, 0, VCAP_CMD_INITIALIZE,
 		 VCAP_SEL_ACTION | VCAP_SEL_COUNTER);
+}
+
+int ocelot_vcap_init(struct ocelot *ocelot)
+{
+	struct ocelot_vcap_block *block = &ocelot->block;
+
+	ocelot_vcap_init_one(ocelot, &ocelot->vcap[VCAP_IS2]);
 
 	/* Create a policer that will drop the frames for the cpu.
 	 * This policer will be used as action in the acl rules to drop
@@ -1002,7 +1024,7 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 
 	block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
 
-	INIT_LIST_HEAD(&ocelot->block.rules);
+	INIT_LIST_HEAD(&block->rules);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index d7aef2fb9848..f9b7673dab2e 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -241,14 +241,16 @@ static const u32 ocelot_sys_regmap[] = {
 	REG(SYS_PTP_CFG,				0x0006c4),
 };
 
-static const u32 ocelot_s2_regmap[] = {
-	REG(S2_CORE_UPDATE_CTRL,			0x000000),
-	REG(S2_CORE_MV_CFG,				0x000004),
-	REG(S2_CACHE_ENTRY_DAT,				0x000008),
-	REG(S2_CACHE_MASK_DAT,				0x000108),
-	REG(S2_CACHE_ACTION_DAT,			0x000208),
-	REG(S2_CACHE_CNT_DAT,				0x000308),
-	REG(S2_CACHE_TG_DAT,				0x000388),
+static const u32 ocelot_vcap_regmap[] = {
+	/* VCAP_CORE_CFG */
+	REG(VCAP_CORE_UPDATE_CTRL,			0x000000),
+	REG(VCAP_CORE_MV_CFG,				0x000004),
+	/* VCAP_CORE_CACHE */
+	REG(VCAP_CACHE_ENTRY_DAT,			0x000008),
+	REG(VCAP_CACHE_MASK_DAT,			0x000108),
+	REG(VCAP_CACHE_ACTION_DAT,			0x000208),
+	REG(VCAP_CACHE_CNT_DAT,				0x000308),
+	REG(VCAP_CACHE_TG_DAT,				0x000388),
 };
 
 static const u32 ocelot_ptp_regmap[] = {
@@ -311,7 +313,7 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[QSYS] = ocelot_qsys_regmap,
 	[REW] = ocelot_rew_regmap,
 	[SYS] = ocelot_sys_regmap,
-	[S2] = ocelot_s2_regmap,
+	[S2] = ocelot_vcap_regmap,
 	[PTP] = ocelot_ptp_regmap,
 	[DEV_GMII] = ocelot_dev_gmii_regmap,
 };
@@ -876,6 +878,9 @@ static const struct vcap_props vsc7514_vcap_props[] = {
 		},
 		.counter_words = 4,
 		.counter_width = 32,
+		.target = S2,
+		.keys = vsc7514_vcap_is2_keys,
+		.actions = vsc7514_vcap_is2_actions,
 	},
 };
 
@@ -1113,8 +1118,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	ocelot->num_phys_ports = of_get_child_count(ports);
 
-	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
-	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
 	ocelot->vcap = vsc7514_vcap_props;
 	ocelot->inj_prefix = OCELOT_TAG_PREFIX_NONE;
 	ocelot->xtr_prefix = OCELOT_TAG_PREFIX_NONE;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d459f4f25dc8..728b040e4e3e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -393,13 +393,6 @@ enum ocelot_reg {
 	SYS_CM_DATA_RD,
 	SYS_CM_OP,
 	SYS_CM_DATA,
-	S2_CORE_UPDATE_CTRL = S2 << TARGET_OFFSET,
-	S2_CORE_MV_CFG,
-	S2_CACHE_ENTRY_DAT,
-	S2_CACHE_MASK_DAT,
-	S2_CACHE_ACTION_DAT,
-	S2_CACHE_CNT_DAT,
-	S2_CACHE_TG_DAT,
 	PTP_PIN_CFG = PTP << TARGET_OFFSET,
 	PTP_PIN_TOD_SEC_MSB,
 	PTP_PIN_TOD_SEC_LSB,
@@ -518,6 +511,18 @@ enum ocelot_regfield {
 	REGFIELD_MAX
 };
 
+enum {
+	/* VCAP_CORE_CFG */
+	VCAP_CORE_UPDATE_CTRL,
+	VCAP_CORE_MV_CFG,
+	/* VCAP_CORE_CACHE */
+	VCAP_CACHE_ENTRY_DAT,
+	VCAP_CACHE_MASK_DAT,
+	VCAP_CACHE_ACTION_DAT,
+	VCAP_CACHE_CNT_DAT,
+	VCAP_CACHE_TG_DAT,
+};
+
 enum ocelot_ptp_pins {
 	PTP_PIN_0,
 	PTP_PIN_1,
@@ -614,9 +619,6 @@ struct ocelot {
 	struct list_head		multicast;
 
 	struct ocelot_vcap_block	block;
-
-	const struct vcap_field		*vcap_is2_keys;
-	const struct vcap_field		*vcap_is2_actions;
 	const struct vcap_props		*vcap;
 
 	/* Workqueue to check statistics for overflow with its lock */
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 5748373ab4d3..05466a1d7bd4 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -6,6 +6,8 @@
 #ifndef _OCELOT_VCAP_H_
 #define _OCELOT_VCAP_H_
 
+#include <soc/mscc/ocelot.h>
+
 /* =================================================================
  *  VCAP Common
  * =================================================================
@@ -33,6 +35,11 @@ struct vcap_props {
 	} action_table[2];
 	u16 counter_words; /* Number of counter words */
 	u16 counter_width; /* Counter width (in bits) */
+
+	enum ocelot_target		target;
+
+	const struct vcap_field		*keys;
+	const struct vcap_field		*actions;
 };
 
 /* VCAP Type-Group values */
@@ -41,6 +48,61 @@ struct vcap_props {
 #define VCAP_TG_HALF 2 /* Half entry */
 #define VCAP_TG_QUARTER 3 /* Quarter entry */
 
+#define VCAP_CORE_UPDATE_CTRL_UPDATE_CMD(x)      (((x) << 22) & GENMASK(24, 22))
+#define VCAP_CORE_UPDATE_CTRL_UPDATE_CMD_M       GENMASK(24, 22)
+#define VCAP_CORE_UPDATE_CTRL_UPDATE_CMD_X(x)    (((x) & GENMASK(24, 22)) >> 22)
+#define VCAP_CORE_UPDATE_CTRL_UPDATE_ENTRY_DIS   BIT(21)
+#define VCAP_CORE_UPDATE_CTRL_UPDATE_ACTION_DIS  BIT(20)
+#define VCAP_CORE_UPDATE_CTRL_UPDATE_CNT_DIS     BIT(19)
+#define VCAP_CORE_UPDATE_CTRL_UPDATE_ADDR(x)     (((x) << 3) & GENMASK(18, 3))
+#define VCAP_CORE_UPDATE_CTRL_UPDATE_ADDR_M      GENMASK(18, 3)
+#define VCAP_CORE_UPDATE_CTRL_UPDATE_ADDR_X(x)   (((x) & GENMASK(18, 3)) >> 3)
+#define VCAP_CORE_UPDATE_CTRL_UPDATE_SHOT        BIT(2)
+#define VCAP_CORE_UPDATE_CTRL_CLEAR_CACHE        BIT(1)
+#define VCAP_CORE_UPDATE_CTRL_MV_TRAFFIC_IGN     BIT(0)
+
+#define VCAP_CORE_MV_CFG_MV_NUM_POS(x)           (((x) << 16) & GENMASK(31, 16))
+#define VCAP_CORE_MV_CFG_MV_NUM_POS_M            GENMASK(31, 16)
+#define VCAP_CORE_MV_CFG_MV_NUM_POS_X(x)         (((x) & GENMASK(31, 16)) >> 16)
+#define VCAP_CORE_MV_CFG_MV_SIZE(x)              ((x) & GENMASK(15, 0))
+#define VCAP_CORE_MV_CFG_MV_SIZE_M               GENMASK(15, 0)
+
+#define VCAP_CACHE_ENTRY_DAT_RSZ                 0x4
+
+#define VCAP_CACHE_MASK_DAT_RSZ                  0x4
+
+#define VCAP_CACHE_ACTION_DAT_RSZ                0x4
+
+#define VCAP_CACHE_CNT_DAT_RSZ                   0x4
+
+#define VCAP_STICKY_VCAP_ROW_DELETED_STICKY      BIT(0)
+
+#define TCAM_BIST_CTRL_TCAM_BIST                 BIT(1)
+#define TCAM_BIST_CTRL_TCAM_INIT                 BIT(0)
+
+#define TCAM_BIST_CFG_TCAM_BIST_SOE_ENA          BIT(8)
+#define TCAM_BIST_CFG_TCAM_HCG_DIS               BIT(7)
+#define TCAM_BIST_CFG_TCAM_CG_DIS                BIT(6)
+#define TCAM_BIST_CFG_TCAM_BIAS(x)               ((x) & GENMASK(5, 0))
+#define TCAM_BIST_CFG_TCAM_BIAS_M                GENMASK(5, 0)
+
+#define TCAM_BIST_STAT_BIST_RT_ERR               BIT(15)
+#define TCAM_BIST_STAT_BIST_PENC_ERR             BIT(14)
+#define TCAM_BIST_STAT_BIST_COMP_ERR             BIT(13)
+#define TCAM_BIST_STAT_BIST_ADDR_ERR             BIT(12)
+#define TCAM_BIST_STAT_BIST_BL1E_ERR             BIT(11)
+#define TCAM_BIST_STAT_BIST_BL1_ERR              BIT(10)
+#define TCAM_BIST_STAT_BIST_BL0E_ERR             BIT(9)
+#define TCAM_BIST_STAT_BIST_BL0_ERR              BIT(8)
+#define TCAM_BIST_STAT_BIST_PH1_ERR              BIT(7)
+#define TCAM_BIST_STAT_BIST_PH0_ERR              BIT(6)
+#define TCAM_BIST_STAT_BIST_PV1_ERR              BIT(5)
+#define TCAM_BIST_STAT_BIST_PV0_ERR              BIT(4)
+#define TCAM_BIST_STAT_BIST_RUN                  BIT(3)
+#define TCAM_BIST_STAT_BIST_ERR                  BIT(2)
+#define TCAM_BIST_STAT_BIST_BUSY                 BIT(1)
+#define TCAM_BIST_STAT_TCAM_RDY                  BIT(0)
+
 /* =================================================================
  *  VCAP IS2
  * =================================================================
-- 
2.25.1

