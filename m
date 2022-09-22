Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B8F5E59DA
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiIVEBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIVEB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:01:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2E7ABD77;
        Wed, 21 Sep 2022 21:01:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8GPbcPB3RkqCqmh8ekRa/l/B1sSD0fuD8W5v5/yqEn8nF3y9vSQyqAkvvAGxPDski4TCsZAZM3oylHFpzWISgjhU7yblSpez+qbgQ8/MjiDTb57DKnzyzR40rIKFuPM9serEknm9/jmUOHidXm8f1pK2abHyT+eQfOwroJrwKplzoyB6E562eIhcnTaIRVUcSbCH1BkoQZ3sg4P+23b8opUGvALB/pQXcemi0H6xPViLqSq+efukvbt4D/p++rUlfprWKP2qnmdae/kuabGOFOhZ8sAGm8No3j5skPAQVX1KiU304nrNM4E2iMss2nMfT/xbCU+1xGrcDI5hfElQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/MiZTdOrE2a4EtP7WT3Tipii5x7dNqyfidmZ+i0mdA=;
 b=FECl/Niv0BJMnv7k0dk6axorsaBQ0lWQI+FoYiFvNxqKJGwyaj1QEavcRLs5ZW2SrHzPka1cpxFFZGjsU0JN5yyPyPnlSYjd7gOn18TaXSn3ANTON22qBgfq2TCrTwgyPapi+vxA+WaqiYa21OERga/PJRa+8LR9W+RsgJDcG06rKBqh+KBZu6lBvJgWPKWLmQMY1MvsLI0OB7fsDGcbaMxSjqNzXquns2Ash4ULe1hBcuPkImy0SrrEoCM6jf25VkgW4b5r83QDn/ASiXkRg61rDUpvOAsO2+tGaPlpPc0c+6B4d3lCt+XJYMG2fh//MAKGfwX63kX5v5kn1QTM+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/MiZTdOrE2a4EtP7WT3Tipii5x7dNqyfidmZ+i0mdA=;
 b=gukNywk3L1TSZKq0dEZmBQuvKc/PM0JdCZo43loIy9y2i4hSLwRQBHQM8TRxWri3cgf5aXp2ngHnsLVtxvjZI5Z+z3ZxLY28xTAnyIqXQfDzg1Z+sDbnlLtOChN90BNdPHZoVAQSZ8CK1jhGieRyTFgiVG2hoIDWht92mhiVYCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5158.namprd10.prod.outlook.com (2603:10b6:408:120::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 04:01:23 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:23 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 04/14] net: mscc: ocelot: expose vcap_props structure
Date:   Wed, 21 Sep 2022 21:00:52 -0700
Message-Id: <20220922040102.1554459-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c100bec-8eeb-4e66-ec7c-08da9c4f1d3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g+qQCC8xkecV2+bOG0qd8ObaW46w0c0XgcFMgQ2mVYKhZsJljvhFo0om6pgJaQmO+hRL1z3KXtgjWFjGSZ5RD8q+yPi7ZAmYJwVe8vFN/P3Nws/9hAChlLO6eOl3GXWCbJR3Bt+C3fz+HuyzheCCAT/5OALnulQ5FexZ250mOhdrzfHyibQv91PSmcvO6aD6tuDUvPX4kS6fObezF9PXTuy8Uu7TP3EMLE67KEupZl23vdeUlZczMEve9tzwxo3Kvmku/nsCSVUiG9VZY4iaqqXjkZwJl1E4iHXokUnxsciLJ15ahrGNrv7JqUdlkYCvEux98ASl4SjRTXFq8dQ1WMOTIswFrWD1001xNk5wlDMG4oGNHSmRxRmpAiz6G/noRp2MKLRlJtTWrigrMvUx2MWPxq3zv63kzu2XILAjeecLwiry6wcxahxbSi37ZZMYea+w1/a5I7a0B3J1z9hyV1bhWVekluHR9f/UoAIrxxMjgNgIdexNuogwnPVhVNp8ih8V+kXmRzcqBesIUsCpsmGe2IWU16Enaa7ggKamET5Hx9BqcmoJOyr7AsIGvi3cBDl4a94PCBLkiqKJUw+JPLNMisbh4PN+yLwtvYYwnBk9C1C9Jbfsk0Fon9+3lNY6DCb113xY/FmUYB9Jt4cNXtYfxEvjVE0Pfih9D618fYBK2IuW0foZfXGe+p6k3EHgtMAbrguKZgxieQgu1/8oAcarTaSZiQ3DQVb8V1QwXaOuc8g93PFXtUrPsU7fQXuxIMcKJk81IC2UT9dN8x3/xQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(6666004)(36756003)(41300700001)(8936002)(44832011)(26005)(6512007)(7416002)(6506007)(5660300002)(316002)(478600001)(54906003)(6486002)(38100700002)(8676002)(66476007)(66556008)(38350700002)(4326008)(66946007)(83380400001)(52116002)(1076003)(186003)(2616005)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GhZS7bff/s14Z59yFXj8/nzPdgJr81u0gBSMDu0XAaTIRW/cr9A58vS2loZx?=
 =?us-ascii?Q?PE1O30wUtfNxZT2yylMlOG81FnI8a1SGPrD9pOVb13WeMWSb6H+6/HiU/eTu?=
 =?us-ascii?Q?MiOQVVONZc4okXiHe6ErTiD6ZMKAHcaqHG2PmZjvT5KjTEXBcy/9zcOHBKp4?=
 =?us-ascii?Q?DqO7fyQO0gaLW6ptzeOhlRdb7Ox5QbtOHbLqzK+jxR6KoLrrgd+DSEOGI/NE?=
 =?us-ascii?Q?s3/zJKBsWfDb0m7IIfILlSPPvxl6IOo/1PVUCIDfpq6HoxFu194afRoON0tg?=
 =?us-ascii?Q?sa541DDZx74Lh+Oxhhd4UmoWqhrG9qC3+eY68Oq334+XRhYnMXeeCMjzaRMt?=
 =?us-ascii?Q?OLezS3G6hx8XzwqrrxeLmUoh4LLuiOeWP9f0PrZHr2ELVyIzhUY3lHlnuO3I?=
 =?us-ascii?Q?Tn/5vU6/ur7fvqlVDqPwnwk7hShcCOUCau0mwFVunQ25+GhLjNcre1NJwGJq?=
 =?us-ascii?Q?E8h0YyqX0yAWYFmpy+vipHIsRR0Qq4eq23YYmjhXsdGRji8OFLmV4pbCfO/2?=
 =?us-ascii?Q?NNCmMG2Sf0r6htYQLz492vR1hpl9DDWx+yNSHG7MVhX4f1g2rQL5nfbylON6?=
 =?us-ascii?Q?uM4jLj6KazcnpMtS89aq5hU6Orf3+LMpFuNAJd0YwOPhwLVsz99qblQxtkFT?=
 =?us-ascii?Q?g7SWsFNuGeb0IrbRm9mipfCVk1K2XvwxLWgUFHP/0bLGoXotFgqhaPY2Gthp?=
 =?us-ascii?Q?Ub+7HFDfN1UQqJ4HF/GG0B9AAaMqY1srPydvKnXg0Fwk8voucIsv/zNdJhpW?=
 =?us-ascii?Q?Zei7uM4F35g8vOV9IofYGY+sHiH6SfBHZ9EJTWsJVNWwqXjgkmsVFRk9d5cN?=
 =?us-ascii?Q?9Hxn+1UTv+kCMpt7Ow49T8337utfmYA4lBdymu4K9/hGuZXTOOhtwQYqd57J?=
 =?us-ascii?Q?Sx6zBErwfJIwnh3QiEcktMwBojUG8vwmBhebpoqjZ0PR8v7JQdE3uXET5tO5?=
 =?us-ascii?Q?kqbgOxrnLkgtO6vHVShB/dspioch+I5nHrgDZMXxrWCpaSC4pybAsvkMQiho?=
 =?us-ascii?Q?0amTxUtFGmcryUvfKS6YhPBNUtytlp/saw9/rIJCWVGS3w7ydAgsoA6atMa/?=
 =?us-ascii?Q?AmZJ8YZL8hgkKTt88/9hRna28b3EVfuK3l1xSMPjAyzpF+oj296MkjpfHorT?=
 =?us-ascii?Q?USoKLcp0Trk3Mz/CwxgvEiw2QsRtuWIyl+ckOjJDPiKtzNBGBty0Hq8mZgKo?=
 =?us-ascii?Q?UIfIM740kqaucJ2gKLNSbQFREvc6WPEqX6Pl3LazJ2oSQC4JIXX+ID2cBl+w?=
 =?us-ascii?Q?bGIR1+Wfcj//dzB23YYZ6zn/z+kSolpBiZOzx9ARQPASyeD+g9VLzt9zNeQV?=
 =?us-ascii?Q?h2j9ZfgkI/oiCS5QxYUw5d4rXDgrcUvTJAqEEv4Uuvwo03RDioKuXHrHcWNx?=
 =?us-ascii?Q?l1ovLYfPWxrgUjbP+jmqDJ9VF4+CtZ6ALdh9kxR/AcldAwH71yE08VOesIBT?=
 =?us-ascii?Q?gUWBpwhwv3yz8/ybm0T8kJn3tYV3axwBDLxZUH39jWaJyKPYdywIqEiLf6z4?=
 =?us-ascii?Q?EB8Pj+u4c05VGXl0W65sRDFCcdtkWv+cspq+jCYvhNpamOg3SLEzdLUepqyZ?=
 =?us-ascii?Q?WTjYrn2WSFDKo4s1zMiYi/OyhacDF+RAgSQudgAsBF2N3O/l9EQdUNqSWh99?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c100bec-8eeb-4e66-ec7c-08da9c4f1d3a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:23.4346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WlBjZnvUsZA/XmGr2Ki0BE0pJ/a7zEbo63QxovKgLPKcOLBM8CoUS0K868krrS2IgZzFnsh52wOjEI7kE4iN8aJsYi9242O3orPKdjxoO0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vcap_props structure is common to other devices, specifically the
VSC7512 chip that can only be controlled externally. Export this structure
so it doesn't need to be recreated.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 & v2 from previous RFC:
    * No changes

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 43 ---------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 44 ++++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  1 +
 3 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4fb525f071ac..19e5486d1dbd 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -181,49 +181,6 @@ static const struct ocelot_ops ocelot_ops = {
 	.netdev_to_port		= ocelot_netdev_to_port,
 };
 
-static struct vcap_props vsc7514_vcap_props[] = {
-	[VCAP_ES0] = {
-		.action_type_width = 0,
-		.action_table = {
-			[ES0_ACTION_TYPE_NORMAL] = {
-				.width = 73, /* HIT_STICKY not included */
-				.count = 1,
-			},
-		},
-		.target = S0,
-		.keys = vsc7514_vcap_es0_keys,
-		.actions = vsc7514_vcap_es0_actions,
-	},
-	[VCAP_IS1] = {
-		.action_type_width = 0,
-		.action_table = {
-			[IS1_ACTION_TYPE_NORMAL] = {
-				.width = 78, /* HIT_STICKY not included */
-				.count = 4,
-			},
-		},
-		.target = S1,
-		.keys = vsc7514_vcap_is1_keys,
-		.actions = vsc7514_vcap_is1_actions,
-	},
-	[VCAP_IS2] = {
-		.action_type_width = 1,
-		.action_table = {
-			[IS2_ACTION_TYPE_NORMAL] = {
-				.width = 49,
-				.count = 2
-			},
-			[IS2_ACTION_TYPE_SMAC_SIP] = {
-				.width = 6,
-				.count = 4
-			},
-		},
-		.target = S2,
-		.keys = vsc7514_vcap_is2_keys,
-		.actions = vsc7514_vcap_is2_actions,
-	},
-};
-
 static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "ocelot ptp",
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index d665522e18c6..c943da4dd1f1 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -644,3 +644,47 @@ const struct vcap_field vsc7514_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32 },
 };
 EXPORT_SYMBOL(vsc7514_vcap_is2_actions);
+
+struct vcap_props vsc7514_vcap_props[] = {
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
+	[VCAP_IS2] = {
+		.action_type_width = 1,
+		.action_table = {
+			[IS2_ACTION_TYPE_NORMAL] = {
+				.width = 49,
+				.count = 2
+			},
+			[IS2_ACTION_TYPE_SMAC_SIP] = {
+				.width = 6,
+				.count = 4
+			},
+		},
+		.target = S2,
+		.keys = vsc7514_vcap_is2_keys,
+		.actions = vsc7514_vcap_is2_actions,
+	},
+};
+EXPORT_SYMBOL(vsc7514_vcap_props);
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index d2b5b6b86aff..a939849efd91 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -12,6 +12,7 @@
 #include <soc/mscc/ocelot_vcap.h>
 
 extern const struct ocelot_stat_layout vsc7514_stats_layout[];
+extern struct vcap_props vsc7514_vcap_props[];
 
 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
 
-- 
2.25.1

