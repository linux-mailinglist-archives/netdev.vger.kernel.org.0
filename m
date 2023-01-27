Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB93067EE42
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjA0ThA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjA0Tgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:36:36 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F333A79CB3;
        Fri, 27 Jan 2023 11:36:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eohf6v6lyi/ytOECPcBikoB5MSZLw0IWYb3v2wgTQXu0ud3PIjTTxLhqKxn/3tB8sPUU1gu2DRLwNOhz6l0qY/tfhiOMwyM041O4wLzCAkcTARbjF2Uj28tCWqFr7uFajMLG1GYUazMwZpcLvAjwFrZ7Yp30/Bfg9lhdNreJRkqIBpMb2PC2Xn88QfyemRqi4fACI55DmwD2in88tuSTNCQbuKsjJARfeKwUqlyagoc6HkpsuQAr69YzeJLiH05kGxlrD4SkEVGS6DTTTaE4hMedk/1hX3tCynZhsOySdYF8Gi9Z+lwbScqGM6eqLcYfcFQ6Ri9eDqP8Fkp8v182WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HgUi+P+S3mCJCE3I+qYaHMZsyV6D3kldWfPPaBL0ik=;
 b=XPdQwbiHgHKfjgt/wUJmnOzSs8B9SJSj+GRJFLj3XPy0H2PgOC8w0Rd1+mvJ8xZqioqOWaEajLXCTXp42BVInDcXXikqepHdGw8TdEQDj7T13/HPk5xrAQtePA2zrE0OHnw7eOCnL/nTzqhe1I3ToHuGeWkdLttjVGS7zCG7BlCuw60n2JWjS7ozRqUn6q8HsEcE8yXvpVbtRg4hUR80pOEc8pGB21/N1LOHIbIGBvi4TPGCLVMDMawhrFYggwuL9DW1dQDQ8JC7xonCZt6Ae8FFNZGYujw4FI7mdCgLLar3Jf6ryTCz3OKyFtnHj8fKnEFp8lCWbGX79+IL1/mhZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HgUi+P+S3mCJCE3I+qYaHMZsyV6D3kldWfPPaBL0ik=;
 b=IaqQgumiQE40SJvONW5vUN4e/FF2Gw8WbzC8V0Yul761cYUJlyRFyrCCEVRh7YAjh8HpkjmHNUffxTrYhGznoToHKIp7KZMNPMzk8RWi69kZxeYWihcqrs8REO2YzAVZNAPKEXB3g6eLCv9cQodnt0rOrJiSYBJGmbAqe8yHBqI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:19 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:19 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 05/13] net: mscc: ocelot: expose vsc7514_regmap definition
Date:   Fri, 27 Jan 2023 11:35:51 -0800
Message-Id: <20230127193559.1001051-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: d4c7f9b4-fd21-4a3d-5ea5-08db009dc392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 50IfpK554P6StsPHUxwjgqebqGNZBlfvEJ5nmwqZfGRdvQ6HS8p8OlouyI5wIwAUG+JxGRnRc+Jhnb6qfMj9UigF3LA0T5HoFK3KzzTP07lvb5YxattyuOdW3RYsunHSn/rbVQoybht7QBGfBkVlPM1vNQPTdmNUCZw/E6VtBLjR0Oat/UPKxjAwPB8fP0X5w5/j70ZVNFyyHJbrSzypSD2Oh1GqAd373fBeJtCTXSRkr7gcO7vhPILwqL/8c4ZE6zMwte03CY/NIOsjI0DoO2UPa1KTonpAQ//G8yLWSDx6tHjY+9HP/wC4IPXTr6M+bUpxjvweTtjDlAWOujv5EKKXdehLbXVr2x3KFQA1/RetjDUR/v+YEGjBQTx/pb+y/AAgrU4KIZ3z5SI73lp1oy6JVsXuF9zZ1alFyioRur65DZ5ZGeUuTVi7NjW3Rug+sk3b2lGRnie4YMXELUkU85am3LhiNhUEp76/NBfQDOrMMeTPQQXvlV6qIylTNQPArX2LAOatdsZt3oOi8y331wYKacDP+Ud+cXdhffC3MIBBCzMMjC0ouZ9s6HB9/xiB/RTlP00P6tTvCahj3OcmmDNdpKhMeUL8sM55PqyBbJ1bRElbTAgQIn8Fa/Yg5QHWOxeU26NotGz+3fOZKT0Bqron+Vh9Yc+55zTPMyIKIR53FNCyJdIQmgrfeuMRp0Hz/3soxTRSJxvsC4yqdnxOjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39830400003)(136003)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V7aCDuLq8NiFDTVZTr1LDGJmW//t+LFa4+fdIsCkux264edtPzdu8PYnkHEy?=
 =?us-ascii?Q?0RonF0U7UKG/bGluIMvVCxcQx40ghJ6/+D5NY8RdzVSvmgv18iIOEfx88P36?=
 =?us-ascii?Q?nhfKkDa5qZ09yGm/+m402bg7IKfkJ4ZayaCGvWP/DcAkcz9OA01UQBWd1ynb?=
 =?us-ascii?Q?F0OjwnMgp+fNs8n1skE8talcGLLVt6T2Onnc4x0+rqesQq0KrQH0k2DGoHDR?=
 =?us-ascii?Q?ip4N5yjqVSxbXASJYN/OaR7iI4Qanfil2x7VW2tccbE+akMqse23BpdPshqb?=
 =?us-ascii?Q?Oyi2+bw5/wtCsw3H1QTxYsQQYduJ1dUJuxH63xTLTlJMRM7OnAmuT3tLPGuw?=
 =?us-ascii?Q?dN0vXNOWRvFrw+ewJTzglRa+vxfOdEh8EpBzCKdreZffGj6v12OaFW98++An?=
 =?us-ascii?Q?OWVR+YXbIrfnL0Kfslg4K4MVBzF9NZj/y9oVFhpYqZqt4HWReC7+k8EaPGuS?=
 =?us-ascii?Q?bi1t60uki/qOa2Uso518nlIAtDS9ntm9ctcVPSedc/gckZ6WFETA74igCzWt?=
 =?us-ascii?Q?oMGvlNwhrt+Br52sp2cL42tzA6V5mKnGBEq2acdCLH4hXs84IZXadVytp1nq?=
 =?us-ascii?Q?sLlWrxGp9VwtVB+d4NCeKcGe3NSTTMnY5TuzRP9lYu4an345gURxofBxEPlI?=
 =?us-ascii?Q?qhALqJRvpZJzvVkCpxhXv4jkpGgBmwTkWffqmucUOjeUoXAArpDahQgs9HMv?=
 =?us-ascii?Q?QxxY6hFckUQ4AGC6LXVDeYmGs1oeXBi9E7h/aGG09C5Gd2a37O2igXhjB4F4?=
 =?us-ascii?Q?DQSwUj0/uiLkspFMUvB7Wvp+HAhKsQA1jgJ7qmMCg8iZjbSVHvjYGhR3gEDD?=
 =?us-ascii?Q?Q7aoOqCyUchs/7nTjmpn129Axpuv+XCacLVQEtj5ojI5AtkQPRyktaIfurvZ?=
 =?us-ascii?Q?0yAkM4pleI5DxLCnw7MIpUOemt0QUUBObcAhhii8HSwJ2yxIbblhRuEfeF/X?=
 =?us-ascii?Q?zIlG53TV2ynGCk4mbEsW2YzKInxZ+1ERwHxIA9ITp29oXSp6KzUEU+3BUSLk?=
 =?us-ascii?Q?Lgv0K3zS1Qpk8aRuTeMPKyQr91CRl6uKJmR3e5OQOT/VpBLaQCppk/ct/PhU?=
 =?us-ascii?Q?qLZMFUnlcKk9W3wWBWSBlCNocPZ2BDgLJQpNLYlYsZ2ZdHmO/fq1wq1pCp94?=
 =?us-ascii?Q?jld07SkFKcL/GBRRrTqoI//BhSOQu+rjOOrvYNjwNwrun4VgYx1S7+hHXXyU?=
 =?us-ascii?Q?vKX3hOAc9KB9v4UbfSJI0Ghmlg1w5w0YTo22AuwLwtR922wc3hzmfX/DnePo?=
 =?us-ascii?Q?NVUMBjuQ1odE/dpj6sFMixRw6JhAxNJa9kftzE0ISh2El4V3Wgggbg5ujZkL?=
 =?us-ascii?Q?WWWiThmHi/zNEZHMX1ObxZFhtIxa5VnZyw0GDL4jfeLqViKTxlDH4zfD7DDd?=
 =?us-ascii?Q?/RjVtV0MOPHyvUtj1XQwLcPRur7lD+hlFLdbwFUIaAHfU8x1J+0S2pC/rV3m?=
 =?us-ascii?Q?BtTMQ2f6YpD1l4+CGBZu9BTyDxAWLe1FHlYGRfHCB8rSr73VZsDR6nwtcm/Y?=
 =?us-ascii?Q?tmP4JKsxiBmh9X1pMgqbJEEKUEFj8JllsCjbZ23w69yI/vOIQ2AvbA85tzHT?=
 =?us-ascii?Q?46z7aAedr5YyF2PipA1EFdWWrazOWkOFf8xy51q6jkKmDEpEl4qilejrDeiv?=
 =?us-ascii?Q?uH1mIle8Ydyi+k5FlQxZ79Y=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c7f9b4-fd21-4a3d-5ea5-08db009dc392
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:19.6103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dt4RHKFLrgOtUCw8YwH6de1ZHiG5FZdZfTy6Y1KnnOMbz3Mz8AvWbAO5ELIf/vyY8YC7pOhajPbNGZo1fpTZ5Q6e+wdanjfmTRSJLTr4h4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC7514 target regmap is identical for ones shared with similar
hardware, specifically the VSC7512. Share this resource, and change the
name to match the pattern of other exported resources.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v5
    * No change

v4
    * New patch

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 15 +--------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 14 ++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  2 ++
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 1e94108ab8bc..7388c3b0535c 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -26,19 +26,6 @@
 #define VSC7514_VCAP_POLICER_BASE			128
 #define VSC7514_VCAP_POLICER_MAX			191
 
-static const u32 *ocelot_regmap[TARGET_MAX] = {
-	[ANA] = vsc7514_ana_regmap,
-	[QS] = vsc7514_qs_regmap,
-	[QSYS] = vsc7514_qsys_regmap,
-	[REW] = vsc7514_rew_regmap,
-	[SYS] = vsc7514_sys_regmap,
-	[S0] = vsc7514_vcap_regmap,
-	[S1] = vsc7514_vcap_regmap,
-	[S2] = vsc7514_vcap_regmap,
-	[PTP] = vsc7514_ptp_regmap,
-	[DEV_GMII] = vsc7514_dev_gmii_regmap,
-};
-
 static void ocelot_pll5_init(struct ocelot *ocelot)
 {
 	/* Configure PLL5. This will need a proper CCF driver
@@ -72,7 +59,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 {
 	int ret;
 
-	ocelot->map = ocelot_regmap;
+	ocelot->map = vsc7514_regmap;
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index c3ad01722829..da0c0dcc8f81 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -429,6 +429,20 @@ const u32 vsc7514_dev_gmii_regmap[] = {
 };
 EXPORT_SYMBOL(vsc7514_dev_gmii_regmap);
 
+const u32 *vsc7514_regmap[TARGET_MAX] = {
+	[ANA] = vsc7514_ana_regmap,
+	[QS] = vsc7514_qs_regmap,
+	[QSYS] = vsc7514_qsys_regmap,
+	[REW] = vsc7514_rew_regmap,
+	[SYS] = vsc7514_sys_regmap,
+	[S0] = vsc7514_vcap_regmap,
+	[S1] = vsc7514_vcap_regmap,
+	[S2] = vsc7514_vcap_regmap,
+	[PTP] = vsc7514_ptp_regmap,
+	[DEV_GMII] = vsc7514_dev_gmii_regmap,
+};
+EXPORT_SYMBOL(vsc7514_regmap);
+
 const struct vcap_field vsc7514_vcap_es0_keys[] = {
 	[VCAP_ES0_EGR_PORT]			= { 0,   4 },
 	[VCAP_ES0_IGR_PORT]			= { 4,   4 },
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index 8cfbc7ec07f8..dfb91629c8bd 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -23,6 +23,8 @@ extern const u32 vsc7514_vcap_regmap[];
 extern const u32 vsc7514_ptp_regmap[];
 extern const u32 vsc7514_dev_gmii_regmap[];
 
+extern const u32 *vsc7514_regmap[TARGET_MAX];
+
 extern const struct vcap_field vsc7514_vcap_es0_keys[];
 extern const struct vcap_field vsc7514_vcap_es0_actions[];
 extern const struct vcap_field vsc7514_vcap_is1_keys[];
-- 
2.25.1

