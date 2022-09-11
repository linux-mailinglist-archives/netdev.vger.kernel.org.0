Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7FD5B5107
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiIKUDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiIKUDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:03:04 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4523327DF8;
        Sun, 11 Sep 2022 13:03:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFoE75818edk952CGRcViPSowmpQbjoBt7XdC/ZOFr1jBNK51OngrDdKo95dcWh/J1OKZR7JUmtWH3zHXlS5UiQKgUYqZXjW1mDxc3GtTPdqbeYr+NNtgSRxNZS0v3drHKVbk4AKCROj6hNjwqTDAfJqyVWbDVduNNkC1Dj5CFOjrwgDEk2Zl1qgG9w7dDrDZQh4YSTLa1E8BeyzP7r+AMrvy9p4olv0tnN/yq0F7IPtezI9xQLXRtOw2hKj6F8vcSU5bogTvZ0cTU5hlTyHaMngardEz6OkKVe1xcOV43L2kO8SMXVTes/nCIbJJhd6ouP4vy75VRKcrciVqpRHlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHIvTKO+UXoZEB1hgivgMMnofiDHu8X9nTf9H8NPZ4U=;
 b=B24a2TAuQjGUPaLYTiace+cXQKKT59eBAd5AxE1I4J7DjgFwfxLSUsLKtAlgs1EO4AQ4YhuKjuFnoZSdHXYRyWY9VT1ZO+uiOeHaad/Jfxh26fvZPxYP6a5p6NeiZlcHugc9l/7a4SDN+KsVac6IAliikORhLzjWLb7kQcZm6cz73IJWjn9k4w6KBBoaObgxe+/dFipKrf1e3qTxzqO4G2RLsdRBlSziinWKXuuk44FJX1DEBnzXAhwJTkFHfbzQyjW59ZMuMeozcMGhZMpdg3hkOxdWaIWtLLMCRuEKddo3YXvfmQ89zLvMbxf3S5ysnzq2LL/eJkO69iaqOR8mAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHIvTKO+UXoZEB1hgivgMMnofiDHu8X9nTf9H8NPZ4U=;
 b=ToY4KI5U0h+5ch400B0ziRWDdVHbINPbzJUtpA0WQVtvxaTsOXXI7/cYoPf6gEORakwQjR8pLZ9sP2elv9dpsWK6gLI1co7LkxjJSQDTPTIVmRfqSsql4y3HJuJQ9DZwo6LuukCZ5YLgkLm6tZJmYSrwy3XuY6+tugGZxeiROrg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5335.namprd10.prod.outlook.com
 (2603:10b6:408:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sun, 11 Sep
 2022 20:02:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Sun, 11 Sep 2022
 20:02:57 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 3/8] net: mscc: ocelot: expose stats layout definition to be used by other drivers
Date:   Sun, 11 Sep 2022 13:02:39 -0700
Message-Id: <20220911200244.549029-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220911200244.549029-1-colin.foster@in-advantage.com>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0318.namprd03.prod.outlook.com
 (2603:10b6:303:dd::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: baf7a9c2-e907-46fa-86ba-08da94309e2b
X-MS-TrafficTypeDiagnostic: BN0PR10MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ld8kMVkZRWNFaseb+wsWByY4vYFk+l4gZ4u6aEryoXWTejXVLs7ZYAbMZ2HKRmL7SVMoF50V+SLX94BqDukcl3SkNgE6Ul1PZ4hL+QbaY+Dui8iVrnExQRFdBq3Fd36swrVMzUe6CrV0maP1C/xzI/xNgax1yGXgSRIt090FV9zyqxIKH9/HDj3oGlns/67RDqB22IivTI/GJ6Lg5ovsYbRL4b5MF+dv0Spo3QSNda0syKnUB/+Jfya50xrLgonnYpeJKnv8LdUcr2TVXdb5zkrMHXpo1b6r1w1LdDNEycMI8lyjNr4W1tX1Om5+mLjLn174bK2KEb/X5b/gB6RK4RIPFxfb7KPqJIxSfJjUJIpUxgZxfSvprTPEYI4EPrDj5QRVAWKmqoPEvaV4qX/29n2FSQMI7eF1SK19nrlyyWrpxTgm3fbzZyiEW6ap6K3o0//ioBg/OZtZ9/A10b6ApW3qv8BT65jY6Hzoc3BHryvZ6cKfiAbKlXSMFqtbLfulowm+p921zXgHYxSyr4zQ6zy3MN2bjoVQzWSplHfzseI2fBLjuu0beIMZAzQDiTkoU80cfnp7+Z0tcVF8X4PqRdd51QpKDDhZe2wHGEegkkiM+0qoXKBw7TYVF40AaV6gLSIKhfPgs/TqIHkP8m9C4ZpEk2XpMMcq0D9eEilGsU4y3T/nlnKrjMmVdIRiGCJYjwbNRy7X9/RWldUwsmXXFjNBvMNDhSVyNcxfIqHGnm1rTYfa8mtNrH4TDdKJuvRv3FnmdDr06BMolB57ids5BA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39830400003)(376002)(346002)(38350700002)(38100700002)(8676002)(4326008)(66946007)(36756003)(86362001)(66556008)(66476007)(2906002)(83380400001)(186003)(2616005)(6512007)(6506007)(1076003)(52116002)(478600001)(6486002)(6666004)(26005)(316002)(54906003)(44832011)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qM3MtDNie9Whn5JJYU6StPeY+W3jONDHaD2AiIR3tzDpqf1UeitRz6ZlG2xE?=
 =?us-ascii?Q?INWxhiSZbKH2ABtMfk0z5pLpkYsApCsaZMTEg5vROMvImSFPArqbNBuot1p9?=
 =?us-ascii?Q?hd2xshl2YoE6HHE/rAQxtZb/FazcFCAC8wbGiiTQhZED7Rc0Zs9HN/oxq9CD?=
 =?us-ascii?Q?3pCs+RykknaC4nzc28eduRB7/eDTvKhenM+1T1nBuUvWFZIyUiG9os4pIG2V?=
 =?us-ascii?Q?8AF0BnGUmggD03qflBitFx0wuBwfpzDtRReHUSNT+Y2DOvRlUF7MJjsNW379?=
 =?us-ascii?Q?rjQTXbWz1WPdpK4Iu9jcUsnQVzsjXveN18mzG0MvKtZef/bNRLfLL2SymJll?=
 =?us-ascii?Q?L3gBW7oEgsMIZbswoN9V8f7l1VWV7WJbXz18WNbRY84KZ68HNewROb19rrDp?=
 =?us-ascii?Q?SQqg4M8sUQ19TBdXrCtN7cwYYnBLhJ1I3NhvjjG6T0siN+UGjGQ3ggZlX4ej?=
 =?us-ascii?Q?knOdEPr/9SoVstcKGSkJT6OVRFfYDIKYecr2pGbX3dcEALH45lEJnpvVZRnP?=
 =?us-ascii?Q?Ziybq5e0mp7MfCjh6KydSb1G8VVrsUX7JMmSGhmvfziOvg2Fu1dk2N4jmokD?=
 =?us-ascii?Q?GlM387KWwoc9XSqSFcB1+BanH3TmRhw8ST34ofUmg+PKBBuPpOUyCAZsx2sv?=
 =?us-ascii?Q?OnKWCkEY3hjreLNvOCaGhBLylX/TQlyR1SjNAUg62T2wgz1ZYvSqqDwpmjZ9?=
 =?us-ascii?Q?mJTRVridxohc0hOVUJJQBoPHeDTAETYBnjUYRWoAHESCv+enrjI8XKNM+7M1?=
 =?us-ascii?Q?U6EUgAA9OXDxD+9hEdt5sTka75quT/mg91FwS+PZg0QzQitlIvaAJpHiewcP?=
 =?us-ascii?Q?Zr997USNMkEFUG4B3p9C408hs7NZheOsiFr8Oc0UqJtoExDgxQkgBTRF3PWe?=
 =?us-ascii?Q?VgoyT1HJdtDbXCDRveCF7l4NWIrH7zwwo6aaqjfY1w4LmhFScTJIz92UG+cw?=
 =?us-ascii?Q?JOJyfK8Gd+XPI5mbMGP9CUZZkG4Fit+BMeuQ9c+wAzS/kFwvUwnhoFnFUpmx?=
 =?us-ascii?Q?qL/WyNpGlzlA0PhwMWu7dVyPQncPEp+lsV8rpisFmO0hvOprciBlOolMrqNr?=
 =?us-ascii?Q?h8wnrz1eua2Ykz/kruUb8H49StgVCE8uF+IYZTYG9Mto2ejGZwXMdDvj/jUi?=
 =?us-ascii?Q?cQ8v6FJOW7cA4MZFAI95/bWBcInE4b0VFivzNPI+dloN7L+/j/An1o41ryOt?=
 =?us-ascii?Q?6+LQ70cFH1MuhrVhJhUHyQlJ1qar5BmWs33VeT1BgkEbCmS1ud8udisRRyeP?=
 =?us-ascii?Q?ez7tKipikuwxhGTUaQqFUJ4i1iPeO0F3MJtQHyxYW17xjY6tQVeIVP6HLlEf?=
 =?us-ascii?Q?k/QIN1+lwr16kq30n8aDBO0biIQktas8QLmk5x3dkrCTkRecfxkWL3EpmhS4?=
 =?us-ascii?Q?n1q3y65fcbL2kBogdvnrXRbUHjTAkL8l7hVtMjeHeyH7MyFIe33U5G9Q/PG8?=
 =?us-ascii?Q?rFqCyIkSYQSZgI/sookk2NuG1sgkuWYjt96UyllzXLrqEQD0zoaKqnDLeqo9?=
 =?us-ascii?Q?VBQkrsssLfm2fME4/5Y9XtAOfAbVKTKBVYNEzjhCD1wn0aNgOEBxK/3DpWT9?=
 =?us-ascii?Q?mbu7ibfG0yFBJboaPW/edjzYXlVNuPs7T/ZkWiLQiATHovwUx6KQZnwyM3W2?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baf7a9c2-e907-46fa-86ba-08da94309e2b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 20:02:56.0902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QLJgeFwxVVCipsCm7e6yPcuwc8EIwvBZF+WKd/QNgJFR03PbUNHkFhu1n+VcGLwzq0IbgEF0AKSayrV0gQOgqsbrXBPymn5T7j50Fo+VZro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

v1 from previous RFC:
    * Utilize OCELOT_COMMON_STATS

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 6 +-----
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 5 +++++
 include/soc/mscc/vsc7514_regs.h            | 3 +++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index e9c7740f20e9..7673ed76358b 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -38,10 +38,6 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[DEV_GMII] = vsc7514_dev_gmii_regmap,
 };
 
-static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
-	OCELOT_COMMON_STATS,
-};
-
 static void ocelot_pll5_init(struct ocelot *ocelot)
 {
 	/* Configure PLL5. This will need a proper CCF driver
@@ -76,7 +72,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
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

