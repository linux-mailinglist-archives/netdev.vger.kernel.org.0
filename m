Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FD227C209
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgI2KLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:04 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:43453
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728247AbgI2KKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:10:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRl2UAXqNwHufKRDxpAM1LBWPNY1vAkUCPMmyboUMMAgVGWoTbEfk8pZ+RGhILBJWYUB5IJbRcVId6R3RnewW6KkQU4bba/psZucvAlgIqqrWrc8zIbjjvRRGohb5fKcA/g8kisM3DA7DZCE5W8C9jLU8CkhQiOmNKI8Gs4+jqlbXvX+y0CdrN63Oa98s8Gbm3Uz6eMAoXGIB0UnDVCc20G5ClcAv1DiJRpa7ew17O9vejddMx9MX0OwC3DwuUoTHCIjjz7+2Pbbzz73XsJZNqrareUIsI+fakUjr9NrutAVaBmRcn4eFDZiorMltk56WKyhYF7l021bvxB1MniKSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4st6mcd83vOBc7rU+919YBCXnSutjviAyTx17nMK6vs=;
 b=DW29yNmhIKga4GjXuh8fnYhmiY6xZy2UZ2yfe3Gj6FY6uXYnXOb3zYdR3ail+I+qYuusojJevw09NBvKap58To1kgwYCTpSIsdvngFAFQGp0AO2YLNe9MvIJTeOgcNV/+PjUihUDen/ia4PDFFgMQk4LLoVm8dm+byXk2OjSoRujm1zn3QZNUlz98HPfn8xmZ9Iur/LAK9vL9SaTpYrHPMXMPn+1bopW7cdP+w1iGnwgRcQw4AvylyOtz6XxBAo012rG9G6sQ2G9sPaFSzL8qVIPY0/B8QyqdjuTo1Dko39Dh6luj1s0negiJHjFCgm4BpObzoIss6OI3xfjWrBoaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4st6mcd83vOBc7rU+919YBCXnSutjviAyTx17nMK6vs=;
 b=Rc2lmTe4NZultLTnLXs44CatPf0GGKw/rA5WJk69ybyjOOi1e3n8rT5Vdy56LtIudDGFBUmwmwjWOifkvm+Q5p5fw/x3dPQMoEE0A9T3Nj8sCOxju79w0CZv2vb0DqIC+h24J+R1hn0Wigrd3X+BdRw3Yddt2N3R5tke8FKfT0Q=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:38 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 05/21] net: mscc: ocelot: automatically detect VCAP IS2 constants
Date:   Tue, 29 Sep 2020 13:10:00 +0300
Message-Id: <20200929101016.3743530-6-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3afa6a14-9e24-4d83-b99f-08d8645fe9df
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295D2B25A44CF8DEF189DF7E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fyr1hVKyezLZUIE+H/8to1ruJenLMJLZLsy3/pMPw8/lcJnE21fo1XLhrsZXJvIAma6vTS9AZxG+acVnHfrlz9pYpDOi5rugIT/z6nZXBcT6+A0UuXaK2AVRdiKRoc4TRazVB1NqBqrB+o+PJJBX3VszHERkMVklSm6EtmEaq3q8UQReypgFEM1GM52uaO7q99o2MO5sDR98YCnVy5dqinIem8EaZuPSKMxlrTer2dyKlskRCITS+GSzuAXHKQKaf7RktKfkmiis85T7S7pjpM2NCAv9dumoTHTzVqdCcI18pgTkJhUc27aFi9s+l5GR+YMkcWN3+kFBA44nzUP9aUMhRND57eP99Nby8zMqSST01HhWi/34BWLm/cMgrRxTWmDEZnsAUTylGb68tqsBszt+gBX+rocGRWRO2RXC0482E6NmMEfZcn+uGJpeINFa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(30864003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wVqiqA0/jTU9Ro19H8wZ2AJ5MamYIBvwRZcM/ZGUQwo6ijYYBI/hzi1PLMdOT/2ujaPmHHmNfA7CbJvdrCtsKA+s+VXDXmO3MIYZE4eN7/s6FHQKqf+Jhu5u1VMq0emgmyh3H3YWh/dwCAOwOTaNfu52kd4sl5msKoTDE9zGz1pXKDhFIAAnmOwco3TOTWABeTUEktn8fkq7NE5sPXqYvHKdeE8rF7PRbkOYUK/aoSw5yjnYKeTHdOiRrSD98P4r2nxsSEKyv3zgw26gLCTJJwbqKnwT21wV1gRl4uQdgrLvU+jbT1GaShDw4hywCdv22++LJhIlGlP3HpvamL84iwsNxTqq+KEgpVnnBEQJyeqAKHCSfotYfxzm3RYbfhToHvYAkSjwX0CdxPiHd4YNgAyvM4GEZUAWgwEUXtFt+DtIggdb2Ni7gx6PLrB6nZ46jRBfUM+bP26FK0fRqjODCewKcgCdauXDS/8D8vi1eXxuiN46/qiEQvw5Yp8BRHF+H5FQft8J+o5+LOpRSLPN6++3RCMQ0gN0c5g7EZPTSGH0BoT4EfoDlDoB9JaIXU/I1l5uxjW2e9+ww3CbrlUve0bVoOwXjvM0VRd2bripad5S0BOi3K6jiTHzzfKlpHyGpapQtLRAvDsK1wnVeeyXxg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3afa6a14-9e24-4d83-b99f-08d8645fe9df
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:38.3478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JOpJknW8i50wTD1gX5aJpt5OEx1gFuarZ4xP6T0bmA5f6/hP5NxCFaWir19fPKG9eP49uL+gQ8cg31A43dHx5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The numbers in struct vcap_props may be fun to look at, but they are not
fun to derive, especially since they are not a straightforward
copy-and-paste from the reference manual.

Ease the work of hardware porters and read from hardware the constants
that were exported for this particular purpose. Note that this implies
that struct vcap_props can no longer be const.

This patch only refactors the constants that already exist, aka those
for VCAP IS2. For IS1 and ES0, detection will be done in another patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.h             |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 25 ++++----
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 26 ++++----
 drivers/net/ethernet/mscc/ocelot.c         | 72 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 26 ++++----
 include/soc/mscc/ocelot.h                  | 13 +++-
 6 files changed, 121 insertions(+), 43 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 6f6383904cc9..295c3e9cad54 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -20,7 +20,7 @@ struct felix_info {
 	unsigned int			num_stats;
 	int				num_ports;
 	int				num_tx_queues;
-	const struct vcap_props		*vcap;
+	struct vcap_props		*vcap;
 	int				switch_pci_bar;
 	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 5d750f9ffc0c..089cfd8873eb 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -16,9 +16,6 @@
 #include <linux/pci.h>
 #include "felix.h"
 
-#define VSC9959_VCAP_IS2_CNT		1024
-#define VSC9959_VCAP_IS2_ENTRY_WIDTH	376
-#define VSC9959_VCAP_PORT_CNT		6
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
 
 static const u32 vsc9959_ana_regmap[] = {
@@ -148,6 +145,17 @@ static const u32 vsc9959_vcap_regmap[] = {
 	REG(VCAP_CACHE_ACTION_DAT,		0x000208),
 	REG(VCAP_CACHE_CNT_DAT,			0x000308),
 	REG(VCAP_CACHE_TG_DAT,			0x000388),
+	/* VCAP_CONST */
+	REG(VCAP_CONST_VCAP_VER,		0x000398),
+	REG(VCAP_CONST_ENTRY_WIDTH,		0x00039c),
+	REG(VCAP_CONST_ENTRY_CNT,		0x0003a0),
+	REG(VCAP_CONST_ENTRY_SWCNT,		0x0003a4),
+	REG(VCAP_CONST_ENTRY_TG_WIDTH,		0x0003a8),
+	REG(VCAP_CONST_ACTION_DEF_CNT,		0x0003ac),
+	REG(VCAP_CONST_ACTION_WIDTH,		0x0003b0),
+	REG(VCAP_CONST_CNT_WIDTH,		0x0003b4),
+	REG(VCAP_CONST_CORE_CNT,		0x0003b8),
+	REG(VCAP_CONST_IF_CNT,			0x0003bc),
 };
 
 static const u32 vsc9959_qsys_regmap[] = {
@@ -696,15 +704,8 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32},
 };
 
-static const struct vcap_props vsc9959_vcap_props[] = {
+static struct vcap_props vsc9959_vcap_props[] = {
 	[VCAP_IS2] = {
-		.tg_width = 2,
-		.sw_count = 4,
-		.entry_count = VSC9959_VCAP_IS2_CNT,
-		.entry_width = VSC9959_VCAP_IS2_ENTRY_WIDTH,
-		.action_count = VSC9959_VCAP_IS2_CNT +
-				VSC9959_VCAP_PORT_CNT + 2,
-		.action_width = 89,
 		.action_type_width = 1,
 		.action_table = {
 			[IS2_ACTION_TYPE_NORMAL] = {
@@ -716,8 +717,6 @@ static const struct vcap_props vsc9959_vcap_props[] = {
 				.count = 4
 			},
 		},
-		.counter_words = 4,
-		.counter_width = 32,
 		.target = S2,
 		.keys = vsc9959_vcap_is2_keys,
 		.actions = vsc9959_vcap_is2_actions,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 70ce36f3b2a5..5669c9c6bf60 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -12,10 +12,6 @@
 #include <linux/iopoll.h>
 #include "felix.h"
 
-#define VSC9953_VCAP_IS2_CNT			1024
-#define VSC9953_VCAP_IS2_ENTRY_WIDTH		376
-#define VSC9953_VCAP_PORT_CNT			10
-
 #define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
 #define MSCC_MIIM_CMD_OPR_READ			BIT(2)
 #define MSCC_MIIM_CMD_WRDATA_SHIFT		4
@@ -150,6 +146,17 @@ static const u32 vsc9953_vcap_regmap[] = {
 	REG(VCAP_CACHE_ACTION_DAT,		0x000208),
 	REG(VCAP_CACHE_CNT_DAT,			0x000308),
 	REG(VCAP_CACHE_TG_DAT,			0x000388),
+	/* VCAP_CONST */
+	REG(VCAP_CONST_VCAP_VER,		0x000398),
+	REG(VCAP_CONST_ENTRY_WIDTH,		0x00039c),
+	REG(VCAP_CONST_ENTRY_CNT,		0x0003a0),
+	REG(VCAP_CONST_ENTRY_SWCNT,		0x0003a4),
+	REG(VCAP_CONST_ENTRY_TG_WIDTH,		0x0003a8),
+	REG(VCAP_CONST_ACTION_DEF_CNT,		0x0003ac),
+	REG(VCAP_CONST_ACTION_WIDTH,		0x0003b0),
+	REG(VCAP_CONST_CNT_WIDTH,		0x0003b4),
+	REG_RESERVED(VCAP_CONST_CORE_CNT),
+	REG_RESERVED(VCAP_CONST_IF_CNT),
 };
 
 static const u32 vsc9953_qsys_regmap[] = {
@@ -686,15 +693,8 @@ static struct vcap_field vsc9953_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 50, 32},
 };
 
-static const struct vcap_props vsc9953_vcap_props[] = {
+static struct vcap_props vsc9953_vcap_props[] = {
 	[VCAP_IS2] = {
-		.tg_width = 2,
-		.sw_count = 4,
-		.entry_count = VSC9953_VCAP_IS2_CNT,
-		.entry_width = VSC9953_VCAP_IS2_ENTRY_WIDTH,
-		.action_count = VSC9953_VCAP_IS2_CNT +
-				VSC9953_VCAP_PORT_CNT + 2,
-		.action_width = 101,
 		.action_type_width = 1,
 		.action_table = {
 			[IS2_ACTION_TYPE_NORMAL] = {
@@ -706,8 +706,6 @@ static const struct vcap_props vsc9953_vcap_props[] = {
 				.count = 4
 			},
 		},
-		.counter_words = 4,
-		.counter_width = 32,
 		.target = S2,
 		.keys = vsc9953_vcap_is2_keys,
 		.actions = vsc9953_vcap_is2_actions,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index f001cba4eb7a..8a9ad0507b99 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2017 Microsemi Corporation
  */
 #include <linux/if_bridge.h>
+#include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
@@ -1380,6 +1381,75 @@ static void ocelot_cpu_port_init(struct ocelot *ocelot)
 			 ANA_PORT_VLAN_CFG, cpu);
 }
 
+static void ocelot_detect_vcap_constants(struct ocelot *ocelot,
+					 struct vcap_props *vcap)
+{
+	int counter_memory_width;
+	int num_default_actions;
+	int version;
+
+	version = ocelot_target_read(ocelot, vcap->target,
+				     VCAP_CONST_VCAP_VER);
+	/* Only version 0 VCAP supported for now */
+	if (WARN_ON(version != 0))
+		return;
+
+	/* Width in bits of type-group field */
+	vcap->tg_width = ocelot_target_read(ocelot, vcap->target,
+					    VCAP_CONST_ENTRY_TG_WIDTH);
+	/* Number of subwords per TCAM row */
+	vcap->sw_count = ocelot_target_read(ocelot, vcap->target,
+					    VCAP_CONST_ENTRY_SWCNT);
+	/* Number of rows in TCAM. There can be this many full keys, or double
+	 * this number half keys, or 4 times this number quarter keys.
+	 */
+	vcap->entry_count = ocelot_target_read(ocelot, vcap->target,
+					       VCAP_CONST_ENTRY_CNT);
+	/* Assuming there are 4 subwords per TCAM row, their layout in the
+	 * actual TCAM (not in the cache) would be:
+	 *
+	 * |  SW 3  | TG 3 |  SW 2  | TG 2 |  SW 1  | TG 1 |  SW 0  | TG 0 |
+	 *
+	 * (where SW=subword and TG=Type-Group).
+	 *
+	 * What VCAP_CONST_ENTRY_CNT is giving us is the width of one full TCAM
+	 * row. But when software accesses the TCAM through the cache
+	 * registers, the Type-Group values are written through another set of
+	 * registers VCAP_TG_DAT, and therefore, it appears as though the 4
+	 * subwords are contiguous in the cache memory.
+	 * Important mention: regardless of the number of key entries per row
+	 * (and therefore of key size: 1 full key or 2 half keys or 4 quarter
+	 * keys), software always has to configure 4 Type-Group values. For
+	 * example, in the case of 1 full key, the driver needs to set all 4
+	 * Type-Group to be full key.
+	 *
+	 * For this reason, we need to fix up the value that the hardware is
+	 * giving us. We don't actually care about the width of the entry in
+	 * the TCAM. What we care about is the width of the entry in the cache
+	 * registers, which is how we get to interact with it. And since the
+	 * VCAP_ENTRY_DAT cache registers access only the subwords and not the
+	 * Type-Groups, this means we need to subtract the width of the
+	 * Type-Groups when packing and unpacking key entry data in a TCAM row.
+	 */
+	vcap->entry_width = ocelot_target_read(ocelot, vcap->target,
+					       VCAP_CONST_ENTRY_WIDTH);
+	vcap->entry_width -= vcap->tg_width * vcap->sw_count;
+	num_default_actions = ocelot_target_read(ocelot, vcap->target,
+						 VCAP_CONST_ACTION_DEF_CNT);
+	vcap->action_count = vcap->entry_count + num_default_actions;
+	vcap->action_width = ocelot_target_read(ocelot, vcap->target,
+						VCAP_CONST_ACTION_WIDTH);
+	/* The width of the counter memory, this is the complete width of all
+	 * counter-fields associated with one full-word entry. There is one
+	 * counter per entry sub-word (see CAP_CORE::ENTRY_SWCNT for number of
+	 * subwords.)
+	 */
+	vcap->counter_words = vcap->sw_count;
+	counter_memory_width = ocelot_target_read(ocelot, vcap->target,
+						  VCAP_CONST_CNT_WIDTH);
+	vcap->counter_width = counter_memory_width / vcap->counter_words;
+}
+
 static void ocelot_detect_features(struct ocelot *ocelot)
 {
 	int mmgt, eq_ctrl;
@@ -1396,6 +1466,8 @@ static void ocelot_detect_features(struct ocelot *ocelot)
 	dev_info(ocelot->dev,
 		 "Detected %d bytes of packet buffer and %d frame references\n",
 		 ocelot->packet_buffer_size, ocelot->num_frame_refs);
+
+	ocelot_detect_vcap_constants(ocelot, &ocelot->vcap[VCAP_IS2]);
 }
 
 int ocelot_init(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 3622753ae4d9..8c96e62b2104 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -19,10 +19,6 @@
 #include "ocelot.h"
 
 #define IFH_EXTRACT_BITFIELD64(x, o, w) (((x) >> (o)) & GENMASK_ULL((w) - 1, 0))
-#define VSC7514_VCAP_IS2_CNT 64
-#define VSC7514_VCAP_IS2_ENTRY_WIDTH 376
-#define VSC7514_VCAP_IS2_ACTION_WIDTH 99
-#define VSC7514_VCAP_PORT_CNT 11
 
 static const u32 ocelot_ana_regmap[] = {
 	REG(ANA_ADVLEARN,				0x009000),
@@ -251,6 +247,17 @@ static const u32 ocelot_vcap_regmap[] = {
 	REG(VCAP_CACHE_ACTION_DAT,			0x000208),
 	REG(VCAP_CACHE_CNT_DAT,				0x000308),
 	REG(VCAP_CACHE_TG_DAT,				0x000388),
+	/* VCAP_CONST */
+	REG(VCAP_CONST_VCAP_VER,			0x000398),
+	REG(VCAP_CONST_ENTRY_WIDTH,			0x00039c),
+	REG(VCAP_CONST_ENTRY_CNT,			0x0003a0),
+	REG(VCAP_CONST_ENTRY_SWCNT,			0x0003a4),
+	REG(VCAP_CONST_ENTRY_TG_WIDTH,			0x0003a8),
+	REG(VCAP_CONST_ACTION_DEF_CNT,			0x0003ac),
+	REG(VCAP_CONST_ACTION_WIDTH,			0x0003b0),
+	REG(VCAP_CONST_CNT_WIDTH,			0x0003b4),
+	REG(VCAP_CONST_CORE_CNT,			0x0003b8),
+	REG(VCAP_CONST_IF_CNT,				0x0003bc),
 };
 
 static const u32 ocelot_ptp_regmap[] = {
@@ -855,15 +862,8 @@ static const struct vcap_field vsc7514_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32},
 };
 
-static const struct vcap_props vsc7514_vcap_props[] = {
+static struct vcap_props vsc7514_vcap_props[] = {
 	[VCAP_IS2] = {
-		.tg_width = 2,
-		.sw_count = 4,
-		.entry_count = VSC7514_VCAP_IS2_CNT,
-		.entry_width = VSC7514_VCAP_IS2_ENTRY_WIDTH,
-		.action_count = VSC7514_VCAP_IS2_CNT +
-				VSC7514_VCAP_PORT_CNT + 2,
-		.action_width = 99,
 		.action_type_width = 1,
 		.action_table = {
 			[IS2_ACTION_TYPE_NORMAL] = {
@@ -875,8 +875,6 @@ static const struct vcap_props vsc7514_vcap_props[] = {
 				.count = 4
 			},
 		},
-		.counter_words = 4,
-		.counter_width = 32,
 		.target = S2,
 		.keys = vsc7514_vcap_is2_keys,
 		.actions = vsc7514_vcap_is2_actions,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 45c7dc7b54b6..36c23832eb06 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -521,6 +521,17 @@ enum {
 	VCAP_CACHE_ACTION_DAT,
 	VCAP_CACHE_CNT_DAT,
 	VCAP_CACHE_TG_DAT,
+	/* VCAP_CONST */
+	VCAP_CONST_VCAP_VER,
+	VCAP_CONST_ENTRY_WIDTH,
+	VCAP_CONST_ENTRY_CNT,
+	VCAP_CONST_ENTRY_SWCNT,
+	VCAP_CONST_ENTRY_TG_WIDTH,
+	VCAP_CONST_ACTION_DEF_CNT,
+	VCAP_CONST_ACTION_WIDTH,
+	VCAP_CONST_CNT_WIDTH,
+	VCAP_CONST_CORE_CNT,
+	VCAP_CONST_IF_CNT,
 };
 
 enum ocelot_ptp_pins {
@@ -620,7 +631,7 @@ struct ocelot {
 	struct list_head		multicast;
 
 	struct ocelot_vcap_block	block;
-	const struct vcap_props		*vcap;
+	struct vcap_props		*vcap;
 
 	/* Workqueue to check statistics for overflow with its lock */
 	struct mutex			stats_lock;
-- 
2.25.1

