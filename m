Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEA227DC03
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgI2W2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:46 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:6339
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728467AbgI2W2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmL93lovKbZCHrZZTmydochAlOP78E25nylzcDO+/ehrdaI/8J0NIEdqIYR+XcNCONvZOnuyH/sA5Vgelys4gSAlc0s+2eYkFd5SqUMGbSKvYlKk61rDJqdsAcROAmd6Ikr093yjpUxi3rG9A8EByrjMwVCWnLUHkezQXxm/d2/fPdnVX+Oe1KmgX4V2Mj6PN6ubQwvH57aMvM2rR37zcsHrgOQUI73etRBNHc3qraqYPcgBOxgV6DJFPSnJU4Z+MaF7GjtLMPtHbnBChSWtZetW0RfaC+XKytb0CCUXsfCyBCyEGBwfjzBWbB/PFi3ZPB9l1ndAf6H2OTQb9rebhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT8P8pZrroQgJi0abP5ej0+mAb132e1Qmvv3Mh8TUrE=;
 b=SGDHiptvKr8xGedk8lmBwakJngbtQupbZOkrYVGeUvFb+a3EtCf7W9igRPu3sb5n6l2HNJevV+FtjSpaRmO+6ydTRdIAjMhCx6FimZyysjMMHxLU3MxONGkfxQZyJMrPVJOdb/a976tSuKOYNkVzb9i+4Yz4jUe3ZXYdxocE/gfLNFH8I9UakAeCkB2IJ42jFPkf+BwUVUiKsay+9TXbiF9NeW82A4O21C6WlsUIKCFLU41+WcA2kviSpTm1kqxGeoUmtrw/kzSeM5WBVZBUiUFnMLnBQlZ+Yq3NHTyzcaDTHFAYhLttIubY2bdoeY/c+hoD6BNOLqsOJhXuYHeO3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT8P8pZrroQgJi0abP5ej0+mAb132e1Qmvv3Mh8TUrE=;
 b=VR1cd58gTdjJe63hRJicUn27Kig+vOcCP3DnrmGBrqL3Ob2l61Gw56beo2rLm7uxSK8E8ocRN9+RAXpvL0z+SLfKtqNhoj27SYUIVfNKAleWd6ZlS8FqMPHotb+IveZAuPK39yQJKsFEDUnsP6TcOfHFqIODwKIYNCTEYAlgjoo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:28:06 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:28:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 07/13] net: mscc: ocelot: remove unneeded VCAP parameters for IS2
Date:   Wed, 30 Sep 2020 01:27:27 +0300
Message-Id: <20200929222733.770926-8-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:28:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e124691-a1ae-4ab9-2f52-08d864c6effa
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797D4F9620B2C344BB7B808E0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l/RyFhSiLG/5Hx35Vi/VMH/K+lXMWezX3B1Pll7N+9FsxQmeosoNS1uxdek8BFvbRDjDsrB8FKPRrDv6LavcH4kvcaGQuG6JrAlzpCK8RMmX02FDsXeszHeDxw2o0rmGP18wjMCcgzkhx2Me1H+M5ocpVyFOgtA2m+phu6cH/eak34nY+Jdmx3RJYmvYQrdfVEbIIP0LXDgkd49kW5bIJ5Wq74lGE7A69yK08C6bhQcDXHwPdzEUJooGNLj34H0t31GVCdtFM8BQPB2JFamL29wx6V+jMlPwSgzDzZOrDTtR3cXq3FSqu52qne20FGlAxV3dHJcgxVnDBZM+Y0wy0QraZd39ZQOagWse6sCvHJuv00uR/eCEFfbehqcDviCmc5nWLxeTKOLzEoFHJy4+4I4HgzwaqIwQuq6iQpq06Hz+HPEdG3/RFuG+NfE/923Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dRi5qcAEc8qrDvTcg6vXqxbe6XhS6bRrINnPSlK+OXw445oN1b3BJQSa26uezb+re/wqkdvbYIeatyKA4xufKiMo9VY5K8aQg+NCU/zJ2nSj5gX4PS3vEzCYmuxAgQyKiaez1V3OJTpqL4wmQ4lyP4w4t5n6b4EL00JlOzLMVzG9l7YjiGOFmsTgW3lh3E8FODFn5Z4VKpwyj6FQ8lKXuhqKNCW/fI17GEonoIGNxMwMB1Z63LBgGKw5mLZxgi2xEIRus+vZZEx4sBlhgIF/3ZzLE/fWxeQyX8VlwmJqMbxSb+5mU//gCzSDJccSyj3rlSexdCUNB7AjMmAa99lBdaTxfm8tZfIQOtOUIoFyuUZu0Ad/76hARoPnPWkTuNngFGKbtxC/x3YRG9rLxauP4nQ+QP3zzpqIBRKOB2qCfziiPsKIAx4I0RO1Meg/s7iuk7vx56ZxIbNxX2bEaCJf0vDFHB3ixg9lwEcidXmyFc8rg/k3iWP5uyKSx2H+ejlW5ZV2ZFAvUT4LQMx5yk3fehMfjCtAIkUhB2kBTUiklcD+W+g6XwnWMZ+Eu1YO6jHgvsvYt/tOdRpsHNqctW36UvzSgeAGLSl7uXVR9zq2um6K0ku+8AYDtiBVFH2+mlj7GxeAgiF3aXyg8+lflyUqEA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e124691-a1ae-4ab9-2f52-08d864c6effa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:28:06.7406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFtgWqugV6FKB3+ILV1hdgim+SpOLWt4PwlRa+hHZbMjf5drEmGKvRjjMDMJRkoK0vOHz+zmBlJLnfy+p1bHCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we are deriving these from the constants exposed by the
hardware, we can delete the static info we're keeping in the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 12 ------------
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 13 -------------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 13 -------------
 3 files changed, 38 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 6533f17f60f0..7d9b5fb73f2e 100644
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
@@ -851,13 +848,6 @@ static struct vcap_props vsc9959_vcap_props[] = {
 		.actions = vsc9959_vcap_is1_actions,
 	},
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
@@ -869,8 +859,6 @@ static struct vcap_props vsc9959_vcap_props[] = {
 				.count = 4
 			},
 		},
-		.counter_words = 4,
-		.counter_width = 32,
 		.target = S2,
 		.keys = vsc9959_vcap_is2_keys,
 		.actions = vsc9959_vcap_is2_actions,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 38b82a57a64f..874e84092b68 100644
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
@@ -841,13 +837,6 @@ static struct vcap_props vsc9953_vcap_props[] = {
 		.actions = vsc9953_vcap_is1_actions,
 	},
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
@@ -859,8 +848,6 @@ static struct vcap_props vsc9953_vcap_props[] = {
 				.count = 4
 			},
 		},
-		.counter_words = 4,
-		.counter_width = 32,
 		.target = S2,
 		.keys = vsc9953_vcap_is2_keys,
 		.actions = vsc9953_vcap_is2_actions,
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 36332bc9af3b..086cddef319f 100644
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
@@ -1000,13 +996,6 @@ static struct vcap_props vsc7514_vcap_props[] = {
 		.actions = vsc7514_vcap_is1_actions,
 	},
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
@@ -1018,8 +1007,6 @@ static struct vcap_props vsc7514_vcap_props[] = {
 				.count = 4
 			},
 		},
-		.counter_words = 4,
-		.counter_width = 32,
 		.target = S2,
 		.keys = vsc7514_vcap_is2_keys,
 		.actions = vsc7514_vcap_is2_actions,
-- 
2.25.1

