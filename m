Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC4227DC00
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgI2W2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:38 -0400
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:50784
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728041AbgI2W2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rc2ra2AGrI7ukyx/CzddbXFFnoY6wx3nxo31w8PD0WVSFT3yh3Aar0E2B3QehauimMsWle+PCXWo73OXHA07FfqirQe5drT2DlCVgZGzgIPC9oTHqh7l5BxRMfE/mcaa8oq5SIsipaXqmJdjvU090lG4VfaiAzGAPg9pJ5BeIxB7geTXWXfh0kFeVJCqJHRE+Bo+ftaU7BPvKtyXzkWbJx46VAB+GNMXr5JN4l16xHnUX0CQWf8oK9OZyzCbmk543ygPOWOvmtbgnG6JH+0afTAy6x8rjD3lfTLBVWJSYN6bHbMUkT5+gbapG0uJXv2f6W6IZwysxqIejPeXOrBC9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3x7gU9F09ajl9nZtAcSHH2gnIn3sguVR4k0PC+ei0xU=;
 b=c4VAJWVwaRCuKK6BirGeAWs7fZFs2gfnTVI4l+5ZLtwg1pEU2F+mBX73sfKUVzzh6Ca5zE4SAmBIc6gj30IfR73nt8aECziWdv7bW8cvN0pFdw7LNbjvIsjCsogy9Xd5seDvq3ddSFU/WaqYTiShbRh/kegKorRfUx/yJgbSiO6hEHxaWf5udB3IAvL0a/gNT4o+ZR0lrnWPdnStnK+E0iZ2dUYtnC20/w+TwGejmMuJNJknhS1cyt896zlmbtDb4QWUZ6as1+rw1FGohouux+g0r4xVvqZEuAJv+cyI8+tZ2dNGzExAQd5sJ5pNwOY6TvImK2yyWUrWf0243A7j4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3x7gU9F09ajl9nZtAcSHH2gnIn3sguVR4k0PC+ei0xU=;
 b=L4icaEzwDtJZ7msSM3PSZxq+3AsMYuutSaKCXUMqAQbcvOpnMBq+8XMS5tVPLhSniyTKyNYgxQEu7OJmn0JpL3FQLsXxKZLmFaXSXI28U//1HPhGozY/kE64p4NxO2leevbJkumB8zULZgY2lEQrrNKCm1FkUeuFxcubF0v1wR8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:28:05 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:28:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 06/13] net: mscc: ocelot: automatically detect VCAP constants
Date:   Wed, 30 Sep 2020 01:27:26 +0300
Message-Id: <20200929222733.770926-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:28:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db49b2a5-bb59-41ec-b768-08d864c6eef5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797611494782958E12B7A00E0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gkox9TQq2VWrrOMGlxNjjO7AJOVuiq30/ihEjOWvOq3vlkcVFu6hC8Ez1Cpd4KSRkA3Sv5JrPbMuupBXswpI58Wl/ckZpsYYqo3TdY+jtUGByDywt/LRGEgRiaG3AKI4GzgA+nBXKevGG/NYOfd0VvpTjczGrFQIhf5MpAq1Pg7rsbN3VdRkkFnhnAmrV43/qcVxM4G4mMMRVm86PAkL4pNwxpbZn4XgKSv5S5coocLPNQ7V6+QyNlYwcbGwxFncZOYqlXRIktVP56yRIBUASVZKleVnxBjGiy/wqGj3CNBcWQLbg/XtcO3wZw5WM1g9yUV7c3Yi2XiifL7W+JFRuO7AnZlfog4ZaHH7f4kUpN0joyeb4mJEF6Q6p6B0ePEkvme6ND7dFk+p8LDJkwCh8b1TkHJ+S4QZs/pBVUvoubduPx80RQYb2stdFKEnKF+U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(30864003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OXq5gpABkCL0JUE/mc7pv/Nzux7rwB9NSVRhg5bVAs9gGK7vGGE9RqHKHBTu97b/v03tbL+9L/DDh8RPic8mj6SlF8xZU6UUnqfVJ+ez0t/OnPQInfni3UuWqVtabpS4qHk21XxH+1K26hv7KFdrTt+Q9wpzHaaZUsnKt+9GxmouHEAIh0VXMV1D0lBhkjt4gLTiMBZ9cej/FTRi7UitffE9yEidedHXzqaLdJCkSOtIbaHxzhZAxvGhjdGv2F9wvCN0Lv3xfNvG7Sal3Q1qZGMD+4/vD6anAWXmojHLSpHjlkHHlpYnoLB6xrfhchejdz8GaGh71cGM0HGfKwWeHFztInoxjqdLFiHN/pIbO/ZZKxdhpasVp46YbeQ/7e2xtLjRYN4R6k8y35AzLj05YmGft05wj3CtGZfvdGXq1HccJQgbUL6qJbQbGG7+1UaKIkotrGtgVRNJ4bvVZyU1KkBoll/JGbgu9pGeoIDFqrBL/zpbOrhvmgTgVbmxZhca/Ic7Y8ToWOLdBvkflw+cdtDigDgC36daGu9EdLLlbJGPK5a4sJe2m1/TruLbhvSsYL+Et08aqB6ln5axS1RV/WHsS88NAQYYanDozvB1b75fD8gAXJxOw85ncCk3LtCmflh95sWaCqlUhHRcHJRLyA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db49b2a5-bb59-41ec-b768-08d864c6eef5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:28:05.0956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQFsUL7mnEKcwyKr3zC8TwrrZdKdN/hokzxaIkilM+5myD5YcqchwVXB58Q2fmmVrIxZ0e+mUjlHedgFfPWF1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The numbers in struct vcap_props are not intuitive to derive, because
they are not a straightforward copy-and-paste from the reference manual
but instead rely on a fairly detailed level of understanding of the
layout of an entry in the TCAM and in the action RAM. For this reason,
bugs are very easy to introduce here.

Ease the work of hardware porters and read from hardware the constants
that were exported for this particular purpose. Note that this implies
that struct vcap_props can no longer be const.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.h             |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 13 +++-
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 13 +++-
 drivers/net/ethernet/mscc/ocelot.c         |  1 +
 drivers/net/ethernet/mscc/ocelot_vcap.c    | 79 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vcap.h    |  1 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 13 +++-
 include/soc/mscc/ocelot.h                  | 13 +++-
 include/soc/mscc/ocelot_vcap.h             |  3 +
 9 files changed, 131 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index ec4a8e939bcd..d5f46784306e 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -21,7 +21,7 @@ struct felix_info {
 	unsigned int			num_stats;
 	int				num_ports;
 	int				num_tx_queues;
-	const struct vcap_props		*vcap;
+	struct vcap_props		*vcap;
 	int				switch_pci_bar;
 	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index a70f7a7277dc..6533f17f60f0 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -148,6 +148,17 @@ static const u32 vsc9959_vcap_regmap[] = {
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
@@ -814,7 +825,7 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 44, 32},
 };
 
-static const struct vcap_props vsc9959_vcap_props[] = {
+static struct vcap_props vsc9959_vcap_props[] = {
 	[VCAP_ES0] = {
 		.action_type_width = 0,
 		.action_table = {
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index f26a6eab44f6..38b82a57a64f 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -150,6 +150,17 @@ static const u32 vsc9953_vcap_regmap[] = {
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
@@ -804,7 +815,7 @@ static struct vcap_field vsc9953_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 50, 32},
 };
 
-static const struct vcap_props vsc9953_vcap_props[] = {
+static struct vcap_props vsc9953_vcap_props[] = {
 	[VCAP_ES0] = {
 		.action_type_width = 0,
 		.action_table = {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b9375d96cdbc..974821b9cdc4 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2017 Microsemi Corporation
  */
 #include <linux/if_bridge.h>
+#include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 1755979e3f36..b736c3d3df2f 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1001,11 +1001,79 @@ static void ocelot_vcap_init_one(struct ocelot *ocelot,
 		 VCAP_SEL_ACTION | VCAP_SEL_COUNTER);
 }
 
+static void ocelot_vcap_detect_constants(struct ocelot *ocelot,
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
 int ocelot_vcap_init(struct ocelot *ocelot)
 {
 	struct ocelot_vcap_block *block = &ocelot->block;
-
-	ocelot_vcap_init_one(ocelot, &ocelot->vcap[VCAP_IS2]);
+	int i;
 
 	/* Create a policer that will drop the frames for the cpu.
 	 * This policer will be used as action in the acl rules to drop
@@ -1022,6 +1090,13 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 	ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_CIR_STATE,
 			 OCELOT_POLICER_DISCARD);
 
+	for (i = 0; i < OCELOT_NUM_VCAP_BLOCKS; i++) {
+		struct vcap_props *vcap = &ocelot->vcap[i];
+
+		ocelot_vcap_detect_constants(ocelot, vcap);
+		ocelot_vcap_init_one(ocelot, vcap);
+	}
+
 	block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
 
 	INIT_LIST_HEAD(&block->rules);
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index 0dfbfc011b2e..50742d13c01a 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -222,6 +222,7 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *rule);
 
+void ocelot_detect_vcap_constants(struct ocelot *ocelot);
 int ocelot_vcap_init(struct ocelot *ocelot);
 
 int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 86f8b77decf5..36332bc9af3b 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -251,6 +251,17 @@ static const u32 ocelot_vcap_regmap[] = {
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
@@ -963,7 +974,7 @@ static const struct vcap_field vsc7514_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32},
 };
 
-static const struct vcap_props vsc7514_vcap_props[] = {
+static struct vcap_props vsc7514_vcap_props[] = {
 	[VCAP_ES0] = {
 		.action_type_width = 0,
 		.action_table = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index b0a9efce8813..0c40122dcb88 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -523,6 +523,17 @@ enum {
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
@@ -621,7 +632,7 @@ struct ocelot {
 	struct list_head		multicast;
 
 	struct ocelot_vcap_block	block;
-	const struct vcap_props		*vcap;
+	struct vcap_props		*vcap;
 
 	/* Workqueue to check statistics for overflow with its lock */
 	struct mutex			stats_lock;
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 707e609ec919..96300adf3648 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -17,8 +17,11 @@ enum {
 	VCAP_ES0,
 	VCAP_IS1,
 	VCAP_IS2,
+	__VCAP_COUNT,
 };
 
+#define OCELOT_NUM_VCAP_BLOCKS		__VCAP_COUNT
+
 struct vcap_props {
 	u16 tg_width; /* Type-group width (in bits) */
 	u16 sw_count; /* Sub word count */
-- 
2.25.1

