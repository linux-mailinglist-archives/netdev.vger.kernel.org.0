Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F02857D93D
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiGVEHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbiGVEGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:06:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2112.outbound.protection.outlook.com [40.107.237.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9CA89AA0;
        Thu, 21 Jul 2022 21:06:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJTXNFIUi0kJdetmSlJOarRXnRrVc65HA7pJf8X7e4Ec04fweK1STE0cW2MDz8c4jyBcsPzFq+fCkLqk1LIWJ2kcRD5iUhIHwvidNW01P99AriTWLuKv8e0DWfGHR/EHuW3NMhajoELUxj/sgXn2zvNbkX6UgKpkqrU8mYB2bYmucdgzN0lgIy5gIt6KKfE0POwQJJH/ERElc7bqtrwfN/pbDkCJlkW9qq6Vez8sqmnylUDAA6IcufPQDUcczeV2d5pvxP5WaNV5kPO8DUjWxkZOjTLwhjNT81+1gCoGeS7Se9qp8b3k3JqjrmFcFyXlQWPkOnubx6U/DU7ZPfz9KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lafS11npwB5UTfmFr3JA0o7GOe2aDgah3CQnMORekVQ=;
 b=jppbpzzUyp2YWFAD4xZSBsoLpb1ulPbadoruilL0i/PdRGrsKOMVHCXw3OekB0WIb8Ac/7ds89WkZUVJm3P0WQ2XwFIN9BypqlXGKhF/imYgnVpZp72URdZss0U2z0xISG5BR9/sFY+VTv747UOyTRBoWCQyc9DaQ7WpxJFITHucZzW2jbePQKMa814JYBcGvnpKyFaAQnBblq80WZxpaWuiTM25IGN/jdZfeQX4VGcqDeAnPFgFQDCcdjDEOKOcqwkOqvjt2+9Td8Iko/+MKx6YcG3rJe1sfUfKkMekoWd7CHy4EjOJWJxPQaCghBJGUFPkY6i7hwBRm30yJd3vdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lafS11npwB5UTfmFr3JA0o7GOe2aDgah3CQnMORekVQ=;
 b=b7a50q+32ZHIM/1bYsV0+DYy3nJig/Wx1PbEPI0+R9vuxjGqZc2t2D+Q//NDbvGE7mm6uudKw00GqA2txROdi13rV/Bt2V2+cl9JQzNmYkdRX5V1v/OpdgB2alD/fqRXkmdVc44CuPvTjQa4MVwrbgDy9lTYwCngLAuFzzKxMPY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3919.namprd10.prod.outlook.com
 (2603:10b6:208:1be::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 04:06:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 04:06:29 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v14 mfd 5/9] pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
Date:   Thu, 21 Jul 2022 21:06:05 -0700
Message-Id: <20220722040609.91703-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722040609.91703-1-colin.foster@in-advantage.com>
References: <20220722040609.91703-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:303:8e::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cd3ad85-b562-4cea-cc85-08da6b978d59
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /DMMyxZQpDw0DGyg52M4kNjMJvZuzCI57YVq5Y9dibWnz6QycXkxlVgrMVtvgCCGfwXocmOPTyMi1NZMyWi1R+aWYMCHfSihIIE7DL2yeDJWEmE4to70pVEgQtWf/ByBubtlxgpEEudJ6xe6PbSHqR31d/8cR0inYa28CHgDV3voaGPtITRBKr+iZFaT3unNiqroCshCJQb13RDKLe24HZtNBeu92snalyf4BuZC85NVoxlxANsh59pGTPzN5ADvZ/ZEXTkXzDVI6g65e+iC52XMBN4zEydT3SVpanWnUjdvCLm8IhhG5+xZu0ncCIG374owuvQZLCOwiOjplfdfKmk0twewowDmb+GJqOQTdR+OjkB3s+MsUOTOLazYklojqYWGZbxABrhsk4aCGqesNgbhBB+r+SS0oCEUOSStif7QRO6IqdwbmBfYjGcGjS9t+lratm3ojZF9yuEq2exwfldX5gABlUeNQTW1A1Ki6ytA+vi1r3p0kaYU0kyCLqSwSCALFpiNjMqiEFlzG56XHU76MHC2FcSpeThULuqLhIIhtin0Kan6V32Im237FU/DbrAmopmfRt0+8NTXXKRBLQgv9htj+Zs5EhPkojA8E9HCfHrVrhh507jC3h0ikgfN98xjofc5RX62A9NKcdymtcLIJHL1s37UOwJLIYvs7Zcqln1ai0eA/QRIE99ix99onWRto7fAEFZFFxzpmfKU7EUEXiJUR6PqW7kuR3v67WXPqTu5qF+uStoBb1JAx3Oh53y2kujBV3A3v9CzuFtIMJL7MkD9qAL384RZ0WXsS+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39840400004)(36756003)(6506007)(2906002)(44832011)(41300700001)(52116002)(5660300002)(1076003)(66556008)(8676002)(8936002)(4326008)(66476007)(186003)(6486002)(478600001)(6666004)(6512007)(7416002)(83380400001)(26005)(316002)(86362001)(38100700002)(2616005)(38350700002)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GOtDzABlpqXDh+4eG1oWK2sOZLcYx0f2rgSRK+1UZcdVzVLzCpzDfkGps9C+?=
 =?us-ascii?Q?kj6U1e4jsLvwRxsikCJcImssQ/9vFp7x9TGeOwZCC5mzbrIIY0rz8ZzQsJJu?=
 =?us-ascii?Q?eG4GzlPKpbSd8lvz0prZDUn0gjFbVgP+KgCm1VoQssU1TONUroXN4gnq214p?=
 =?us-ascii?Q?izA1R9hUmUGRwPLwdhW1hwHhiw8kdwaFYf60trbYRgnxYollBQI5+m1Hkr55?=
 =?us-ascii?Q?+UnrvsaJabmNdYvTk6V786tztCUGdZHqlrCoJ1Z/Ij6Xv6ippilR4m1JXWmi?=
 =?us-ascii?Q?BezI5/nZAtJPQqDkL5a/oVmiQBaRhQvOP34QamHlQYntCOiVn0/zYUNnBh5J?=
 =?us-ascii?Q?nDiakYMAVO9cN8W3o6y4As6SRH+DD9IlOqRAo7ECVynAU5ICreW2zDvlQKG3?=
 =?us-ascii?Q?ssz4M/dZDmyU5Xwk/fVpDu8DrewNs01xqhUQBPQ+TuE2+wEYKFLLW2VM5zxV?=
 =?us-ascii?Q?B9YD4fyzXQUaAFFZoUxS6EojmC1O3U2SKCNvopy4KryC2vL0zi4X7Bl7/HPE?=
 =?us-ascii?Q?Zq6TeC+Nh1++qQMISvPG4N3V/mNCly3Egkx9jcyVJhMpSNRH8GVJxX9YXWK/?=
 =?us-ascii?Q?jSn6GJ6cVu9dl4CYOCBdhvX33VUFOscZlf7xq3vcfASvqzENPubBhxaHewuT?=
 =?us-ascii?Q?nrUeN3wt+Ixlfd6QL83rYtsEqdT6k7Cz3rsCikE/Zg+NTSc8Nt7kkaGO7BcX?=
 =?us-ascii?Q?i926JvVqTuJZpV582BDND5dyH37Ya0h+aKmQfmWKhxl6FO8oUALiAtSfugY4?=
 =?us-ascii?Q?zIF7P3VAlHlVNuQTgGGuAyL/4pAfh16JnKO2s9LoqLi+ImR/sjvuT/EUpymv?=
 =?us-ascii?Q?deQjRM1LJw8f0S5zyPwMfgsiIJ9/1jXXCUSKI+L18jtKjHUuNDhTMQwcxIEQ?=
 =?us-ascii?Q?HaOmVzvamUHTuy9JLH5ODaRwhMrBAl98FxeNJzh5lFvO6TBJWrvUSGaO3hGD?=
 =?us-ascii?Q?cmVG4zpmBxqRD+afzt+LjocCZEEP87ZHUxdzaRjyiOq9L+Tsic2MxmbJfIKu?=
 =?us-ascii?Q?oQo700J/0SjVuj5udWcrNlOfkNsUHZnHPtE86CY6ZVgv5xQOl2bRcOvlq2Px?=
 =?us-ascii?Q?qp6yPV9aubx4dOXo1YrFv6QTniyxvbO6fciMrgHfLYbRT8NWH1Xm3VqDQ1vF?=
 =?us-ascii?Q?5kJvAd75ZG/w7xXhWyWBViJ1mDRV9gH2W5XzQ6FTOzonfnFMyheOfVLOS/g2?=
 =?us-ascii?Q?yV1gou9rqfJG9ZR8wu97StHVmL+PQ4Lu5DaeP2XBbVPtnvk0nEpnn4QRphIw?=
 =?us-ascii?Q?/NJbHCt6vpilz+4LiBkGlND1VK0+71Io5ih1I4gQK3UzB8+7RyXEtnmq91wP?=
 =?us-ascii?Q?UvJwRDnzfn68Hg7t08A9WIufwIBAWad9qIXlerjuJ4LTd2c2sCt92I9AJ26T?=
 =?us-ascii?Q?zCi//eEP4d5M4GdLY4VDHJ7hYU3f0X3S/HD1Get1vRmCdL4PsNzpVnz8XURo?=
 =?us-ascii?Q?iNM5TXDeQ6NoXDQqxek++Dv7MVaF4wIZcpXXZaWIGMQ0KHW2QYIg4OcHitvd?=
 =?us-ascii?Q?x0GG60PMiHkfXx2kdxrMwCWNUEUbTjdgzwyctdJLGzUxbi0+OtxgvUBB0FrV?=
 =?us-ascii?Q?Gpa1m2MnV1xEl+C69IKG2sh/Z/reWWjUVtS/zuCW66wYT9I0QWpnStwpX61Q?=
 =?us-ascii?Q?smgVqDW/FEoltY8xFJq3tbw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd3ad85-b562-4cea-cc85-08da6b978d59
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 04:06:28.3771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZrwiMYKLCsrx3MHBYjXifhS5qngChChrK2gpTkRgXbvIVxrbcYjPWJfxjGz4Rb9z3WMZQXNQY0sXtiK5uxBbrci/n9yieAdVy2710IcWt+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the commit message suggests, this simply adds the ability to select
SGPIO pinctrl as a module. This becomes more practical when the SGPIO
hardware exists on an external chip, controlled indirectly by I2C or SPI.
This commit enables that level of control.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v14
    * No changes

---
 drivers/pinctrl/Kconfig                   | 5 ++++-
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index ba48ff8be6e2..4e8d0ae6c81e 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -292,7 +292,7 @@ config PINCTRL_MCP23S08
 	  corresponding interrupt-controller.
 
 config PINCTRL_MICROCHIP_SGPIO
-	bool "Pinctrl driver for Microsemi/Microchip Serial GPIO"
+	tristate "Pinctrl driver for Microsemi/Microchip Serial GPIO"
 	depends on OF
 	depends on HAS_IOMEM
 	select GPIOLIB
@@ -310,6 +310,9 @@ config PINCTRL_MICROCHIP_SGPIO
 	  connect control signals from SFP modules and to act as an
 	  LED controller.
 
+	  If compiled as a module, the module name will be
+	  pinctrl-microchip-sgpio.
+
 config PINCTRL_OCELOT
 	tristate "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
 	depends on OF
diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 6f55bf7d5e05..e56074b7e659 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -999,6 +999,7 @@ static const struct of_device_id microchip_sgpio_gpio_of_match[] = {
 		/* sentinel */
 	}
 };
+MODULE_DEVICE_TABLE(of, microchip_sgpio_gpio_of_match);
 
 static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	.driver = {
@@ -1008,4 +1009,7 @@ static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	},
 	.probe = microchip_sgpio_probe,
 };
-builtin_platform_driver(microchip_sgpio_pinctrl_driver);
+module_platform_driver(microchip_sgpio_pinctrl_driver);
+
+MODULE_DESCRIPTION("Microchip SGPIO Pinctrl Driver");
+MODULE_LICENSE("GPL");
-- 
2.25.1

