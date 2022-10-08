Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C415F86CF
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiJHSwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiJHSwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:12 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2118.outbound.protection.outlook.com [40.107.94.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1BA3F302;
        Sat,  8 Oct 2022 11:52:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/3wjO3dWACW+jLwKHCS6Z8LpqJY+08ZLyL4VgyrxbTz3zH9E7DC1BE73Sy7frjh2lRsXEuZ4P/Zh6ToOp0X3Oq28Q/U/5EmzmvsJ+Ay/af88khLQbtLH0SkJv2pfqFvRiV5+cbwqzV09UbHXVPBB02/53EEfk7CwLAqT7E4KeOMkzI5GLdEXR5BJMgpFL3jhmN/KL1GCI4KQssowIMSHbGifD/3jZ75wjE159r00CzNRJLKtSaoCpGBVwDusvbiJ57BFLlP/yH3J25X/Hf4fq+u04UWjbuvPuYNKlJts0GWFPZ1wY/jqKjN3zphJtHyH5EzvA1VKfV8Jmf5OhKtGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRtS9ifcETFXDbwozHn4pI37mZfnaWmxzS8rFhcLQqU=;
 b=kZoY+vH0tN1FhTBlrd8aOfRGEUe/OOndE7C8LJzfw+kGu7sHQKKYLZtSG8GJZuGzfewsnYWhRHxYlyeIRMlqNDZPO0pFKcfOBC+cyCtpXcRSwbu2ZqT5585JQ6ATyr3j4nGolYknSukQTCuHP7s+445krQF9xeJyBxAbIlAmRCEX3W6cUY70QL6ND9YzCA/K+kpUc0riNgJVAJMW1UQAXMhfeqHvMH11rgaX3rJ7Dayond+q/GtjcKdUMIKhiKti8lY8/5vi0b4PwuesINun50KeOMTXXY2j2zI3JIa7+uO53CewHijNDuvVF9zImOfDlKEdxUZYRpGbwq2Oapm8zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRtS9ifcETFXDbwozHn4pI37mZfnaWmxzS8rFhcLQqU=;
 b=Oa3vEhkXtz+9ulh88FZIynKcX9xbH5Of6wq1v0ncwgN76AT3vVZ2hJguwhVANNI50W6tNE5PbITFS30AVsw90RWkeiYxqe2LyhcVY8kHnVZ0nXTlIB5DvO8S9KSQxtu6xlyY1PsrzGCNDJjUfhDEMo6poOOGI2pFTE1N77Ivc/M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:07 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:07 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 06/17] net: mscc: ocelot: expose vsc7514_regmap definition
Date:   Sat,  8 Oct 2022 11:51:41 -0700
Message-Id: <20221008185152.2411007-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a7ad9ff-37d2-47b9-dbce-08daa95e3291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5WC8uz1fYyRHLYAud2b/oFDQK9H9SPNIGkJtuwjgtxAb4i0VSQEn7vrHsgPs8tq0OZS4Dg4WsYIRaA56yT1ejE5ZCb1hmLl231YFPDbgO8bWFElA++5vSmPA6O+bAKScTaGWnX7K/qEfspslKi+i9ZM5eYd/lfSdNpLhu7vi7HjgS17w0c5n/RxNxl+ZOgD+z1aMTedB+bCL0S1jGcOFkGyFfQZd7JbRJWvBpU8ujkQ2pH/5uai8Vh+mg3FMQAeWRoGt9mwIFdaP+UPSYKwYk+jAcmYMVOaIEvbhGr14DdZ9shPnQvfuofIqokNG9aNPYV4NFzG4e2EyEv/1OlvPod3xOWFhxpI+E4LuMxVMDVpGrR9WAU375dUKnqMQXvfdZeGq+E2tM+AicRWOo0dFxqVcQlTD5/6QNqZKy1eg0CBV3Xn7FuWA7DIWhnTh4RsCcySwreEwX58SuvAsfobUwSpjRpGUy3auNQODlxaWpkg30XbsrJKmqZj74sjabCYIG0lq9y6hdai+lQh6M2SOqH7xKZ+FnAvvwdqMEgfDvuKX8MWN0LgbPMibMPGcFl3+9gKr7QV4kXGO8bBTJ5hVnoycrKSkIGoj9rtl+OuHBfSbip8t2HQOIHdefC950bfn/0qCYB+Mv3/Ev4aYocvOJ845/EnDCpsj5Xb2jILfOZp6ZE3UrNxMRi5DkoECwMKSqGjIoSGiFKuVEWI2ByTh8agfr+hVi1vcb/11oUjR0yICsFWQIvxqISGnr0btTluCSPACN6zygIrfTuEuFG6WQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fWQK+MMfykQPulg+bEgC/pFpHn3rGAfSLkEatmz6CU8HSxluDVMuf/2Dw0dP?=
 =?us-ascii?Q?aQiqxieMCG/Dhkk0EGoyN/T3j8LMRMm8SW9VovamWEbMkmp18VvoPR/wn5MR?=
 =?us-ascii?Q?kirnAkQXBowtM1fNIu3ZiZxWTIeZZ/y+YLmTsixxw2jfmQNKmnFL9Z1Hps7h?=
 =?us-ascii?Q?iFhU5h+1jrijNCX3lV8lnwBSB0Nrs5YlMyEM755P3O0Sn7EMbeXKFdlqQgwh?=
 =?us-ascii?Q?2pbE+9uSrZgQ+nR/0lWgQqoW7sWEyCxT27YXybiJFNrituWXvtFVhokQC/3G?=
 =?us-ascii?Q?8snnRXLrwD6pwfRIjaI2LqCBm5COy2RU2ubztxIri8NRyfNy3VjqvAhWSCQC?=
 =?us-ascii?Q?NztmztP3NNyOssxRzO6ikzoZsUEMELjVD1xVuRI4zA6+NJS39v6KHtmrgSgt?=
 =?us-ascii?Q?2cQeb+nhgsyQk1t5gXoya8DYv2z2LK37GBBNIVH6OycBfP7BYOzX8qloPSgx?=
 =?us-ascii?Q?jh8KOjtFofNqtdnNRhyhjxw1YrokjbkHG7zQSjX/6QBlQfuiBLUfiOQCPYh4?=
 =?us-ascii?Q?Frr1RJ4E1pheoYjNXLd3zdtK/vKQwg3BSATZB+bN7ujhhRuPjiNVpPP6PMVI?=
 =?us-ascii?Q?kCGG9Q48hSsa2eE3xQwpxS89666mw7RsZNtXIDYzgyQK2YWwdY5foJnqufoA?=
 =?us-ascii?Q?GsQfbRhdcX16EzCW5ouWCqtlwFE5AYE1t1Vwn3NpNP4t8brDpXLynVdXfBkp?=
 =?us-ascii?Q?n/gvS8SVWzhLIY+7Gs9vQlgBkV/uFdSOeVmUMcSg4jLjORA79y0h6Q94qCJt?=
 =?us-ascii?Q?VpAxlHzZ/3lvDfqC4WHlG3ttSpljO2UcXJmumAzKStwyEtOvCAn3+vFdwSK8?=
 =?us-ascii?Q?dwm7jncXGtMa4WzQBxHsyngZdkMOkjjkEkMx0dqQpHGMlkla5u20kpFBPa51?=
 =?us-ascii?Q?su2gbJ3A/QX4LoDt1KvZDb7KB25ovBrJcd5Outj6ameIQrJ+PvMOKuUcWOoH?=
 =?us-ascii?Q?jjew4DlUJQUhdlQCblBEtJafvJ0tu3uVzOzEBIkaD41X1OWY+L1XpY2pMoSU?=
 =?us-ascii?Q?+dcFgNmNSJOidDwOBljcBraPpQtBIZS5wCbWft2ADHtsJAoT1OxCYV80NCCy?=
 =?us-ascii?Q?MMeci2dJ/UVAfFrFje8VM0/qHl63AOY0cVkmq4x0a/A0Q6/86b2r7gxDWE+/?=
 =?us-ascii?Q?PsvulIaEsRh+fDl9owynvKMMhAE+ydmZDYQk+HHjBfBry9VQMG8yyJTZpsMC?=
 =?us-ascii?Q?y6h/T+JJmY09nDSg63NBopPz8bdPobw/ItAWzFMyI9+vg5WSq7UH+oQ2SfrT?=
 =?us-ascii?Q?1rbs0RuFjBgx3LfZYPTSK6b0PO+T+fEUOIeUglz8rKE5mzgXDUbgyJl2q6Mc?=
 =?us-ascii?Q?Fsd7tlHK7SJZxk10enjNWPPZ7pLo+AtY1nMYCEeIn/gRkPULomj7jg9OCzXV?=
 =?us-ascii?Q?c4WrrTK5Gxt/0h9hSRP+V9ay/+9zN2KOr1Cfx5Ahrhv1IJ4t2553nQm1g8Bb?=
 =?us-ascii?Q?ELF8BVNzXvrD6lzhPDCxtrwrOBUsOxvHR409c+skLfq1Oanh/p9mqK/3jV2H?=
 =?us-ascii?Q?oAgjCJXHMKJd/f1xBAgWwjbB/Si6Xrv/MaXMuDTxdmF96Eyp6IqQY/CxOa47?=
 =?us-ascii?Q?7iFlgwlQtvEABeLFZCMGLkaJVyfSlKCo+IWI7rXIpYvBvTu+6Rn/DqMhVBKf?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a7ad9ff-37d2-47b9-dbce-08daa95e3291
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:06.8036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: myAcTGQVmRD5jZLHAPzXQ1aTJV/ykof0mpRzbTPWi3udUNnEgQ3kisvDTiFucNgrDEUGOdNoChgI+DIeHyaAH7Q75qDmK9zLas5aS3RMCA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
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

v4
    * New patch

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 15 +--------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 14 ++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  2 ++
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 822b11d33288..a30a3694f200 100644
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
 	ocelot->stats_layout = vsc7514_stats_layout;
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index c943da4dd1f1..3a0b6307a13a 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -434,6 +434,20 @@ const u32 vsc7514_dev_gmii_regmap[] = {
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
index a939849efd91..38efc0fa73b1 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -25,6 +25,8 @@ extern const u32 vsc7514_vcap_regmap[];
 extern const u32 vsc7514_ptp_regmap[];
 extern const u32 vsc7514_dev_gmii_regmap[];
 
+extern const u32 *vsc7514_regmap[TARGET_MAX];
+
 extern const struct vcap_field vsc7514_vcap_es0_keys[];
 extern const struct vcap_field vsc7514_vcap_es0_actions[];
 extern const struct vcap_field vsc7514_vcap_is1_keys[];
-- 
2.25.1

