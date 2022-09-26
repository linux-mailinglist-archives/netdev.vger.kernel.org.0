Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A2A5E973B
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbiIZAac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbiIZAaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:30:23 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2093.outbound.protection.outlook.com [40.107.237.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2AE22BE6;
        Sun, 25 Sep 2022 17:30:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLK/VDxO9cZ+tFZVJ0x1samhmhyHGp4N8RNF4Uheew2o1wikxRD2Ymrkxqg0oARZ1V5P3uFRojkwL0rmNYCed5nT6Qenm709ilJbqsXnvUkcOWw6r4beeZZQ14Ep1i2pHh4OVx7IypmnkU8mXCB16OssszF40VAZFIhspMqIs382viT23DLpYzKTHc7ZYTt7epM56eBoLmubOWZbOqYO1+HomS1QAdhLNnF47Q0ouVMvclenTq4Sn0OkXsZy9O5RF5jgMa4kpY6sbTokSv4bX24RIbASJJT+Eldp5F10D8eZS6SqIT5hHFgCw+wIKVePR4haRezc1ija57qKY4cddw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiNDagnBU7jhkphoxY+DLKG3LATJEVQTXOGPVfI5hyk=;
 b=OA82U62NfiI07eLhWo6YtlZEGhYiXNFyAkrRsyQ29Hx/E5ufn8wouLdtBKTwTmTisvPpMGjMy3uA5EoE82psIe4SgU+UTR1Agrkcfrdp0/73i0QBC7eSvzPGTxf8h9aGGCxq/POy+cl0ghhXFnhgemS7NVWExRtR6UyX+RLFQ721QztaPxIH8HAwhmhay9M5q/8DI94See+6K2T8tIDgdIGWRLLkubiyTDU4BV/iNzAvhmqLAFmY7fl85ZlYuC7hmzs8IQCM6UF5iXHbyusYPCcfSF3Za0VvbNGrvS2A8S9zT8b4lRFb+A4YPb+EPxG3aRteiHbYEInYZ1KLXBk1vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiNDagnBU7jhkphoxY+DLKG3LATJEVQTXOGPVfI5hyk=;
 b=Eq4smpSZnRnH7K6fWc12aO88rwnXqp5y+JiE69fzVkLV9vb8QJW2yqX6iU+pbflXBJmIhCg0QhDyya5ZweAoe8kfw2yju7yxBdM9p4brzoMhqFZBRxER0KphU7kq751fthnKpzNffPOXycJjjuIOjVlk7m7Hnqsh9+KsFnb+UxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM4PR10MB6062.namprd10.prod.outlook.com
 (2603:10b6:8:b7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:19 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:19 +0000
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
Subject: [PATCH v3 net-next 03/14] net: mscc: ocelot: expose stats layout definition to be used by other drivers
Date:   Sun, 25 Sep 2022 17:29:17 -0700
Message-Id: <20220926002928.2744638-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926002928.2744638-1-colin.foster@in-advantage.com>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM4PR10MB6062:EE_
X-MS-Office365-Filtering-Correlation-Id: 18a14859-f204-41db-9a8e-08da9f5649f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: szOhbQv4Hrk0GZYRizyNyDWnVdofpXNfCrc6H1WxYl5w25k+nZrKOh5fxXEYA9p7uoVQVKWpCG+h4iTh55btR27D9qWfpevKRtbg7ZEGZxp4z12y8km7pbh8FFpwi2LjDmjmZ5eoV/fsDPCwzp7f80CgOaQc0vK1uPyanp9Ti3ifZUbtOlaWm7VDT6VB5xfcl4D0HdMH0+jfrmuDDeR6evtWQtHaKxo0D786WjEpXfxQBdGMxrFrMyGCW6v4W6gAo+2e1ZQkuiTf7aVNGHbqUv4G+bBxpSxxvOEejT/M8EQjtKKVzHRqmUmmEtEwC2kHJhnZknloe8XR1TByNx2JGUzjpWCfe0Sjn0/BOWvlKC2/MmvCsnXQyTpcAxP39Rv2cch9nEeeOWKSRVMdBiuy4EmM93xjzsYNHGL0qeiMBWRcKcm2vbZ3nyR+IdOQ/buLCpF+/HZw+XjViDZgWlb6ZuFT6EYHDZpJcTPkWpJffzVekhMmqUxbNzMWvfoC1W3wpgWnM7OtNgAjWWiQZ0PoXyBCCE6MHP8Gl54XVMExSI3SBpasHv6yvwj0HHL/GtzEcISUEgXYThQaJWyNomTvSSyc1taNhnAXtl6byQ+M52JK5yOwK0diV+7BE2XBHPskSMTjjFaat6fUH1FPlXvoa2/r2QSG7qcZZI46dbKVzXWKq+tCcY4S0UzxiRQOgDeQYZw0XjR0XmmbLSvF1K4AejHu94uw7hnQmjQC1mv2NLcgLY88/zxfV8FqoSDhYikCj7b2PlA0toJGOzma6WBrlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(39830400003)(136003)(451199015)(66556008)(66476007)(478600001)(8676002)(4326008)(66946007)(316002)(6486002)(54906003)(38100700002)(38350700002)(2616005)(1076003)(186003)(86362001)(26005)(6506007)(6512007)(52116002)(83380400001)(36756003)(8936002)(44832011)(7416002)(2906002)(5660300002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GixZSHPjhO6cOpjyGgxqH616tFuIm/zlSfeidtpSskMKqbrR6O47mqHZblWF?=
 =?us-ascii?Q?rUvNXbE/PixAX5jspq3di1On9FPx6R3MKC/faAAT6H/YvhHSc23nQUfsORab?=
 =?us-ascii?Q?VdvubZktGhNUomj5gbdoDwY4+9GV7YwXNlcbiBFFQ3PYFwc8R9Eo2YOoLKRq?=
 =?us-ascii?Q?+bd8jEq6iEm2CqGTaaojwgN8gYEoCLeqMRKG/FxVE58VmoRztJiY+yYQ7PF6?=
 =?us-ascii?Q?kFWl/x7r44C0SSlMZ8UaAhnb9haMYyEAHkb4LKSdFd7TVBMILu3IZk9fAGnv?=
 =?us-ascii?Q?gfhWJhBCLR2R1k5Op8SkEcj4wny2gIIR98tZU4QKvoAph28lL4BIsOMORjhp?=
 =?us-ascii?Q?MEKXUfeLJlO5JzbhFbdiR1O/gyrDc4HsfELZ5KBXBEDV8sCksJwGYL7k769t?=
 =?us-ascii?Q?KbIpJpcdO+iolbwGvlJ+xFUYhrWco47BTRfCtpB++3MQ06VmIqJp1KhWdN2z?=
 =?us-ascii?Q?Gz7Hc4rTve2sLZmJo21Ro+voIf3RD32R8x0aHUIz++Achtt6kgRZl3jALG0w?=
 =?us-ascii?Q?fPkwu2qE5wc/speQ+dN/H4NSYHxN2kl2WpTP/xjXhvz8NF6QiVTnIRNdIvxB?=
 =?us-ascii?Q?bhCuSUHoLcWTJqOaxpP33T5HPJVDrPbswRAzXL/JOXJ1C+c0uHvB3kmAsG67?=
 =?us-ascii?Q?GDwtc7C2869b9SE5PTgesepu9f++359lQsj6DitK64F1WLQA/9GCXRj+CId5?=
 =?us-ascii?Q?LhA1zaYdoYgPqWzp1MNaITSvpwBdqZPL4K3sWZCyQgKD33cSTxIO9QNsxayD?=
 =?us-ascii?Q?K+5FNWtieOrIBJxEUxmhMCBDm8XjwwgC/lr0E7TnCF7kCdaTsW72RhO0bo9U?=
 =?us-ascii?Q?nQqENud6qarn+PEqp1OA425kPGRRJpsQIt3PAMnXIlXCLJc1U8oJlL7gOjpB?=
 =?us-ascii?Q?lgUQqUEqAMDHg7KHVTKvICTRA8ktZPMSktu9u7JsZpiWuhMuLLpgemmFpKQC?=
 =?us-ascii?Q?B2IrUT9HXLCvBNJokIaO7+/6YKWr4sCGKXWxsRGeaDnH1va621MWrk9wtquW?=
 =?us-ascii?Q?tR9lidt7T/OSS2gc+KIy3XX3jLVwCZ9CVBeo19z8lf0X78SQwvxJYQ/+akcj?=
 =?us-ascii?Q?zeoEbgT/f+e3WrjJKX9A7B3WNKvOhevkWTN7V9AUA+uutxIpSPZCzP4eXJ33?=
 =?us-ascii?Q?VQGFVze7M6reUqyS+rf81Uz2Rvsw4dvEokiXl28XrM/zqzuknQxKrjPMYYpM?=
 =?us-ascii?Q?Dgd/dWfBffSESAeYlkt8zgu0EjFiBSnBjJ33IIgn+2fqZGbF1BXRCs7ERWo5?=
 =?us-ascii?Q?6H52fAWj8myGyoGyGyiGXhrIrqwDmmdFobfvsUO4SLSSZ5WHA+qFqa2Qeh9E?=
 =?us-ascii?Q?8t7283BUe/Ky3QqrwxLnjFrnz9kIindqKjdeqPkKVUnVhIuztfiyG3IEn505?=
 =?us-ascii?Q?YO1sSR5VIilrEnDlfA4RHjMChuMlxedASxGROUKQnTxE5fKU7ullLtwxMqj4?=
 =?us-ascii?Q?t11SCuW5s1EB16d3xZlEkkqq6ZoIDXJJKV65gCm9kc0bOqKadorDO4lsvFES?=
 =?us-ascii?Q?xsq0rRGs2qvBtHeNdSuluV9QQN5tsLGZ+TxtFhJHITdmwH2xcW4ngwdL0AMe?=
 =?us-ascii?Q?tkCVFWkbRSC9rcIbCDZ3A+2YsiAjbeW9FKvcgG3Qs4YG+nEjmITFS5hpxY50?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a14859-f204-41db-9a8e-08da9f5649f1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:18.9170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgMx/n4LckT9H1hr7RyMPa9PPn2DneOeLn+jncFGpHOlk0L1Vyhu0yPgkRVZszmNLFIGSylzGhuu4QDi8w0BmgLiJB4QGui5Yjj9wwBFy6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6062
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_stats_layout array is common between several different chips,
some of which can only be controlled externally. Export this structure so
it doesn't have to be duplicated in these other drivers.

Rename the structure as well, to follow the conventions of other shared
resources.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2 & v3
    * No change

v1 from previous RFC:
    * Utilize OCELOT_COMMON_STATS

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 6 +-----
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 5 +++++
 include/soc/mscc/vsc7514_regs.h            | 3 +++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 6d695375b14b..4fb525f071ac 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -42,10 +42,6 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[DEV_GMII] = vsc7514_dev_gmii_regmap,
 };
 
-static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
-	OCELOT_COMMON_STATS,
-};
-
 static void ocelot_pll5_init(struct ocelot *ocelot)
 {
 	/* Configure PLL5. This will need a proper CCF driver
@@ -80,7 +76,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	int ret;
 
 	ocelot->map = ocelot_regmap;
-	ocelot->stats_layout = ocelot_stats_layout;
+	ocelot->stats_layout = vsc7514_stats_layout;
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 123175618251..d665522e18c6 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -9,6 +9,11 @@
 #include <soc/mscc/vsc7514_regs.h>
 #include "ocelot.h"
 
+const struct ocelot_stat_layout vsc7514_stats_layout[OCELOT_NUM_STATS] = {
+	OCELOT_COMMON_STATS,
+};
+EXPORT_SYMBOL(vsc7514_stats_layout);
+
 const struct reg_field vsc7514_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
 	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index 9b40e7d00ec5..d2b5b6b86aff 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -8,8 +8,11 @@
 #ifndef VSC7514_REGS_H
 #define VSC7514_REGS_H
 
+#include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_vcap.h>
 
+extern const struct ocelot_stat_layout vsc7514_stats_layout[];
+
 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
 
 extern const u32 vsc7514_ana_regmap[];
-- 
2.25.1

