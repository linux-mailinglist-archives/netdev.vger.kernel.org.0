Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA507452AF1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhKPGch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:32:37 -0500
Received: from mail-bn8nam12on2094.outbound.protection.outlook.com ([40.107.237.94]:48724
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232289AbhKPGaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:30:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtZwll/dLcSz+95bR61kzFvhjgKr8ySxM7kOn5e3ub1cKbJEuijKl+tHk2yiHCR4iM2SjgQ/A1YJnaczA1HiNSge/OWytSD6AfMsf0W9neOKpNWKsFRN3SdMEIgl5L1pBewH3pgkPtmgiUVHMo8zTOipcz4OjEWGStLLP8GnWXHgGLUsTxoL+P/7Cf46e7dh8CLckbBwLU9Ze0ukUhBid3iN6sgBmw/SSCmm6biz5QYy1Zhwt2ITWRvfKY8sCF2+Dn60+R2QLOPEDVt2ksPiGeV4+oKGduZWIRXPVYxAjNj0l2bcDYESpyc9IBcY+8BJqEpyPuwAQ+1bJf0dkFc52g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWV4Upnmxwx/szBkLrr9MPQtQbkM2sq/JfT0exYhS/I=;
 b=n2W7o4j8M+SibLlXlB/BO/O1Eei5Swbrkq1d1X49ICH0k+IDQbhRvPzWHSuhHwEoPcOMC7ASbImzyFzFArnSPpN6yMHzpIuLO57ORowTD51wMvz7SIFd05tjKTzNsiMs6p9kfCsfsDoRyXr8g1rGvPiFwjRqQisX3SC1LL3p4aIrJOSfKpyB4fegG7zpLxWnvt3yiEDDc2GgmAb4ZOuQv+fnhCIAUZ0gOL/MGE6vXqA0pHxrbM89a42nv0GX9QzQWbxbOn3yw6MfSJNUyL0I4hJLep7W1diAHHeGcIq4Cia8Zv/USDbCDYCYBmQEplYbYzdr9u1j5x+6wUEb4K2Gbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWV4Upnmxwx/szBkLrr9MPQtQbkM2sq/JfT0exYhS/I=;
 b=x8Ak4PN7NRKlmCadBLeVsjIOGPYeHTHHirUMOUlY1B/EfM0Saf4/cNH6qIECeaPkbsDp58JZ0DeNvA2xPQeIVJi4jHxf147++yXeENgbIbNZFmZdi7l9KrXIL1DVJ5MBG7gN5YZef6RPXj2gWYn+chHZD6jq0vSyxwni8Wt4MYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:55 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 17/23] pinctrl: microchip-sgpio: expose microchip_sgpio_core_probe interface
Date:   Mon, 15 Nov 2021 22:23:22 -0800
Message-Id: <20211116062328.1949151-18-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ad762ad-df57-4e9e-b8f0-08d9a8c9aab9
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4722D1FC0D2E635C9A596471A4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kS45hXHanBSlrfzYedCDAM6T4juGP2HJc2eopBxckGMye7Kka86o/iSW7kicCtTDgvD4gvWZkt3+ZMdVIUPQV441jgReRZxRIn6SQdNGj+F5oSvZu4wS0L1c1+HzfrBkXFwkCyfTzwSldcPpG3uk6Vs6bvNj3I/Ni1ilsA+hY65GUWAUwnZrNEruJtLl78RCVyptUzBTOdFTPJvNQEdZ6gVr7kGJV/LLk5Rt/M9CCNNyLVhk1anzUapuA0BJHmJGI7e6BLMCUxOxkn+9PW8UT+5GdONqsnCYPzoMwWxHgU7KMgTaVTmTAKY+1HOqUT9bhDxtlsWjg1LRKK2lfNZOcgMSul7GIYA6YcAlAMLFzQM8Lg6DmrSKioJ+sm0sXr1iFGJhM8xhOcLp66hat3VDhbh3rUPlgg+jFVi/R9ODhy3ymrgMhlO36PBeU4q2dGm9+N1M+2GGmKwtTwjqRI5k82P4O64FlZnqxdTkphCoO2FWHDqUbEpKjloMRSIKlIemo3PGYn7KP2cd4EYmGD68/PqdAIObZEpOVmNMt3YvkAmTS7ms0PE55gpSRYStTxcDih5p6YhZ/gtH8riMuYG4VOq3SUw4zF/kTQATr/fZyWxnm4HYjjWNGg/4mvTOOcKiAfEK40z+Zdq6vthRMhZodnAEOiMotPs43pUPSWfQgYNcfnrSRl/bXsPTeZAjSwqMLTKsDLA0HQxmcIZimFs9Rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eeUgueAHwrs+OgmQjdHZN2UiHb9Hn2fR/Y6MTEkC/bvnNHUUXcPDeuO8FXZF?=
 =?us-ascii?Q?7lIhcYgVjHX3JutrS7hhSCFlSoxEH5aGR8Awwa6VxBE5ORuJUTZR4k7YOJIv?=
 =?us-ascii?Q?1+ja91Mpq0oiTxrAcCMqRraBhXhi1lt/panZ1uz8ZIz/wEVPbfx2j2i4Q5Kk?=
 =?us-ascii?Q?sK+GGtClTyVgHoP/mZuUm2LX5fIDeI4dvSFGooYTbq3HgxOXOZzI/u2YY415?=
 =?us-ascii?Q?O0BZEHvQFR3+IbUiRg3IeosN71c5NXLqFKbE4X4M0c/M47U6jqPWcS3n+7pl?=
 =?us-ascii?Q?ICccugvlqp8nc0/4htYdwn+V1s6ICAS3/66m1ItyKZQ9rUoB75OO3she4PDM?=
 =?us-ascii?Q?2SvqvgMkyZAme0+ECXHPO8QN/oC5uvpYweC4+Xyo4SXa6ciMuFoAHEEnDrsX?=
 =?us-ascii?Q?OjiZJabAMJB9I4EQau6SAvlBK6Jv5hIixrVq7zyhWJUkBdispnDNDj1YaH75?=
 =?us-ascii?Q?qjgzjQte1sljSxu0BBb4d6Cv+/D+rifd9jVxUqGZrdnuc8xb7JiNxeTUP8rs?=
 =?us-ascii?Q?1ppw2mvqog0UAE7fG3Gn5giIi1ZuqulJTdd1B4TZDBfZSLFKE8bxVluVL27i?=
 =?us-ascii?Q?gjKxJhUGpILRVnlv+RolccGehTkXd3pYxUHff23YVPePpUPBRflIrQUvjQSY?=
 =?us-ascii?Q?wyMA+QrXS1nQNBvz0wS50pHJ6OHIZ2bmIHh9E+3CQi6/Sfd11mB9G2RcFX0c?=
 =?us-ascii?Q?p1yEbw0/45VToZ0RIh8T7unaRv20tNE51kN807VA7f4cRoJ823i3TD5IvIIV?=
 =?us-ascii?Q?KN2qNgCtOXDnUvGBeq12HSYf2ns5YBY087I7sUVt3Ln2pHjSNCRL3gnYHZ68?=
 =?us-ascii?Q?6vDI0RsHVRMJbv6ZeOZsH09fyyOAM9NfMFtdWwKXxQCjAa+MLilO1Vq3gydU?=
 =?us-ascii?Q?In0li2OpiMi7O6Leu0QC3lh0yPqiHepx2Ia3YoejaWtIwROsMI3W61e761KZ?=
 =?us-ascii?Q?Fv7wLX1604NpaWKd99flM+RRElc6NNBQChcNtSlEqRcF1hlkaiuahwV/iCCs?=
 =?us-ascii?Q?s+9Otc80ZoWz219PC0o2kAkRp51gGQoQr9VajPYtQviMwkQcONtPXc/lM75R?=
 =?us-ascii?Q?w05DSoqgpwP9CLA807Oq5mQTW5d7qUehXYrWZq+KeGWTBhSoIr0WRxcmbYC2?=
 =?us-ascii?Q?rJDayU/oVqoWx5iI7PLEATW/dzlFtCYgCRHsDUFcowxRg7EvCJT5dvTr2GZi?=
 =?us-ascii?Q?gZOKfYNYSxaGWCOgRqMyqvqAj04buJc/XCdqSWqyV/E3jSbD5LdOmm+Jfd1h?=
 =?us-ascii?Q?VpKiaA3Hb3v/OJqUhUhRFJY7hZUwQn82nMt6J2vxMrowqGXnscbFJIz9uXsI?=
 =?us-ascii?Q?7O+W5P/JdAYsGHcH3bkUDRJDb53OnlNx1xUIXsmkhetrhPonFTZ5nWLoD0qG?=
 =?us-ascii?Q?2LUvja5iStIXKFTxVjSobxy5WwwN6fPEKUgvLezWHibEKxM/ybvXhw73Z7sZ?=
 =?us-ascii?Q?5UcVSmG5t0SBIBEj0lHIfxzWujibD3qEyl/ZgkB/9gjJ8iKEeiTWUqoRbSXD?=
 =?us-ascii?Q?wFpNQBa24QqQ+aAJWQv71R6osPAgbr0bEn5+jUURU4SfRad8CttyHXWP2le4?=
 =?us-ascii?Q?zcSpHFsonNqc1vUb7/c7AF4vt+cRD7or2zGfrI1fUHgXQfx64Kt8KKvDgyrN?=
 =?us-ascii?Q?UlmzqWTKAlAgwUANmTFabsTP13l+waPYUfvA6GkLhxIn4gmKkmW1+0NifKWo?=
 =?us-ascii?Q?BV7kQEwjmf6t+L2Vf575wwzff3w=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad762ad-df57-4e9e-b8f0-08d9a8c9aab9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:55.7515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MxeY9zuyQ1XCkUDoXbK+zm5lWwLpvZxR7jB/BYE0c6m3cZeapaVdbc9SvJJw1lwaKSWeBniOGzu2mjoC/p40hWg6KUilgA0kaMxmVF2aeSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow external drivers to hook into microchip_sgpio with custom regmaps. In
the case where the sgpio is part of an external chip like a VSC7512
controlled over SPI, a pre-existing SPI regmap can be used.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 46 ++++++++++++++---------
 include/soc/mscc/ocelot.h                 | 11 ++++++
 2 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 10736ef5c6ca..2ddee50707d0 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -835,22 +835,15 @@ static struct sgpio_properties
 	return NULL;
 }
 
-static int microchip_sgpio_probe(struct platform_device *pdev)
+int microchip_sgpio_core_probe(struct device *dev, struct device_node *node,
+			       struct regmap *regmap, u32 offset)
 {
 	int div_clock = 0, ret, port, i, nbanks;
-	struct device *dev = &pdev->dev;
-	struct device_node *node = dev_of_node(dev);
 	struct fwnode_handle *child, *fwnode;
 	struct reset_control *reset;
 	struct sgpio_priv *priv;
 	struct clk *clk;
-	u32 __iomem *regs;
 	u32 val;
-	struct regmap_config regmap_config = {
-		.reg_bits = 32,
-		.val_bits = 32,
-		.reg_stride = 4,
-	};
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -878,18 +871,14 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
-
-	priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
-	if (IS_ERR(priv->regs))
-		return PTR_ERR(priv->regs);
-
+	priv->regs = regmap;
 	priv->regs_offset = 0;
 	priv->properties = microchip_sgpio_match_from_node(node);
 	priv->in.is_input = true;
 
+	if (!priv->properties)
+		return dev_err_probe(dev, -EINVAL, "No property match found\n");
+
 	/* Get rest of device properties */
 	ret = microchip_sgpio_get_ports(priv);
 	if (ret)
@@ -926,6 +915,29 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 
 	return 0;
 }
+EXPORT_SYMBOL(microchip_sgpio_core_probe);
+
+static int microchip_sgpio_probe(struct platform_device *pdev)
+{
+	struct regmap_config regmap_config = {0};
+	struct device *dev = &pdev->dev;
+	struct regmap *regmap;
+	u32 __iomem *regs;
+
+	regmap_config.reg_bits = 32;
+	regmap_config.val_bits = 32;
+	regmap_config.reg_stride = 4;
+
+	regs = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	regmap = devm_regmap_init_mmio(dev, regs, &regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	return microchip_sgpio_core_probe(dev, dev->of_node, regmap, 0);
+}
 
 static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	.driver = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 14acfe82d0a4..8c27f8f79fff 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -930,4 +930,15 @@ int ocelot_pinctrl_core_probe(struct device *dev,
 }
 #endif
 
+#if IS_ENABLED(CONFIG_PINCTRL_MICROCHIP_SGPIO)
+int microchip_sgpio_core_probe(struct device *dev, struct device_node *node,
+			       struct regmap *regmap, u32 offset);
+#else
+int microchip_sgpio_core_probe(struct device *dev, struct device_node *node,
+			       struct regmap *regmap, u32 offset)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #endif
-- 
2.25.1

