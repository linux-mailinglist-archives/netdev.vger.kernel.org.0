Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79024F8ADB
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiDGXD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 19:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiDGXD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 19:03:26 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2120.outbound.protection.outlook.com [40.107.95.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C12116B58;
        Thu,  7 Apr 2022 16:01:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bn0/qkUnabX8431NblgZir4ZMCCVD64uUGHBpuCm/skTO/6vDQZ/U7QdCrjq2RfrLE+6x5TUKjdql8Xtiu3rEeE3Zhbrh73DWrYXJrJPqu+1H7anCVPMKVNRHm7KWBFK1Q3O8Q88zmrplL9veWOHn0O+XNtawjIq5mUBD1d0C4f3K21B6LW64cHqxRzpgrwU8mS/jbAd+lms+FAugDLtMn+ZQt87eRiBUNXvc8ZPkRjnfOlvEFDUjX08Qb7CzPOWaAW1sIjDimyE0c16XisNrbb1yBQ1QJ1eOTLmsvzRgOoJiD+VbCCe6jQh8i5ehcdG25/tRVGHzj8bVBrmjUKlxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HI9s/ow7eOcR3EtnEi6njigh5BpmjH8jGOXM5d3NEl8=;
 b=aG5giSlQQDFD4KpIkmEYQVMRjp2Ff9bH6210JTUcqKNKdIwCmc4hhUS2VNBwA3ERE9jtZsTD598omzpkiJi572ixgkODy4FSjfowpuXLAY0ZuYb8rgDwKj4Rf2UWZMPBrDBGba9Pj/+J3jyywTe+4xZfIzHw1Qm4A2A5nzbWp8SPNsG2laptrJ/cpGEiF/4Cu8pLwD2qF7bq/Y6a7jtleSxaxO61J24XTjlt4rQFqx6FYmli3AYhrm2TpGSqUprOJyfR084ZXr917yWvhwqcGaIpG2kZO20Ujz1uG8lcc7B4n/bsGzbguWu/x6Q/QBELZjVbAq0kfsifsIVVgq/yig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HI9s/ow7eOcR3EtnEi6njigh5BpmjH8jGOXM5d3NEl8=;
 b=a2bgrSCYlmKuN6rsD4/VLmfgIQmrCYPStNmo4siEA+avJ9CZY2h1VFx02lhVvK6z6IX1GD8R5H6qWKrep56QLLT4FO4lMQnH9RR50nIqVwTgiTaN8JZPTgo5rHyxX4YKI25syelX6J+oiqkGthsS7MigzCFgpG087h4TA883jkk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB3125.namprd10.prod.outlook.com
 (2603:10b6:a03:14c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 23:01:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 23:01:22 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v1 net-next 1/1] net: mdio: mscc-miim: add local dev variable to cleanup probe function
Date:   Thu,  7 Apr 2022 16:01:10 -0700
Message-Id: <20220407230110.13514-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407230110.13514-1-colin.foster@in-advantage.com>
References: <20220407230110.13514-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::13) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3915a62-dcd3-4d4f-6221-08da18ea887a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3125:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3125C0D4B89A716DA0266826A4E69@BYAPR10MB3125.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xI1xVKsEmOWY85XNN1ivUXqvjOMbq/ezy+5ehOyujym8MkkboQ6iEKEcV3ZpWXdvmEoEYq/MIAkcIlhBq6ufM7uIZOT5UEICnUvPVLVVLy54xcis0Rt/HVGE2i58w3XxiU9/PU4PQyNIbttkWbot0WzVBE6rBxvVgswI547BAEt6ehQ9qaTwmt6Pd2kqi5UYxx3/5DRVvQSqk888OKTcHDUCT17eIru1CwnWpFaOb/3KaYoLYmg4AeDNiCJ70tbzzSVYSkOYlbUYUVAyZXsQfQDfO20Eisu6+qZxBQJ3y1EzCRi4PBAOoK8dCK7Qv2GLToB7iTNayrSboWgK7GG92RG0ket5a5iMs6STdatmAFsFtTptIL5nB4BlHR5xvTc7B9tmAeKozBe+4u/cKb2EUDzunpmBxQ+rYMqaClLEGj9q2kaIc3bmKWN3CAE3LsBcwqeZe5c5R0RVYdISf43IkLMd6JIsTh45fgqv4Zpz+4yAOy7BuyUu2uC0YpMuBz2jtQdm00Rx6CIiToI7Dy8x4nrpddRaIlv04PvtFhcEglHjf6i6E02L65L7i7KluEB5oMxePd7dO8HM99YZFOxVH7l7CkXkufnhdCRp1lm3dsI2IWWbyvYl7a1R0xm47GoXSExYObsoBuqF3opXLXAdWK6E4Tng55iz4zI/JJmxn2A6ZOWT50UPT6LKzREUzZ6uC+1YWCQTA2bYZBjowo5RLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(346002)(39830400003)(366004)(5660300002)(4326008)(44832011)(6486002)(508600001)(8676002)(2616005)(66946007)(66476007)(26005)(186003)(2906002)(6512007)(7416002)(1076003)(316002)(36756003)(54906003)(38100700002)(38350700002)(86362001)(6666004)(6506007)(66556008)(83380400001)(8936002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zk9WKQB9b8g0+kqFiQ935wbp9tZU8OUWKyzh+9uHp2iw6MeCPeTBLwszZtCX?=
 =?us-ascii?Q?1JJJi+XxxSX+KyF1blA8tQTwQKPBrzXVptzNHM9uK/E6ZTec1xKFoJy5lu81?=
 =?us-ascii?Q?7tPQeGvhUIIMq3IVj5u3oPDdvE6/4CoJ03Osc9dvGK8osDfrRg/hI497fqnZ?=
 =?us-ascii?Q?V6o9DTAmTLItAEEiqsvALTEJr9RAy7FXTcqlQxx/JCfWmTu1dtO9Kb363FTA?=
 =?us-ascii?Q?Q1WVoEZcLj/opTeYwcTczUW7E6147q7aLeQ7M0OgQX3feHvgbNxQWkxLOi+v?=
 =?us-ascii?Q?Fg6TNcGaqBgA1hFsGncfrmKi1D+kXeOWCFMu81LOcvJcVWGQlEjVeLgUtxS1?=
 =?us-ascii?Q?14IioESoxcjYnQCWaXL6ymaXBEPlzkCyErS67a3xjyfKjPPPxU3i1suOGidB?=
 =?us-ascii?Q?H4HQkh5C9fYsTQhZCzaAewID4/k/pIVYjjiR0m8gZ2ieOYn7A4maPoYzk1TX?=
 =?us-ascii?Q?kWsYQafzDwZMdpzhlvYXKwD1bHjh52yC1/ilJNGvu8QPokz5eVk4Ei1HyxvF?=
 =?us-ascii?Q?DWBSWmKEBnJ/AXx1ZPCJ8aImj1fUOnWIc8j3BfExRy1aYSyj28mT0XOT3JFZ?=
 =?us-ascii?Q?S8Ldg7OfabfBV0VeDZcddwCM2w3osn+EaQoHViWD/R8RS771yuzZoCKb+lH6?=
 =?us-ascii?Q?U3UTiYGmhelxexl59MmYEC5xtSNVXw7aXEBng1ySMhT6QOjfjGmn6A+6jGn7?=
 =?us-ascii?Q?F8lkeT8EO4dwAX4D/L0SS/jiKtDBG9t41mBNP9KCYd/v2Gf0ugQZHZjfOO7l?=
 =?us-ascii?Q?y7K9T5LlWv5E+bkZdNktuCCTvSnw6RK68Qr1k6IApnbut2fDBvL+bIdhaEwQ?=
 =?us-ascii?Q?TPulPTzLIjDBu01LFM0d+VqkeIp93SdnlyJYqDWffhKBMu6hVrmmAvJzLPfj?=
 =?us-ascii?Q?p35tF9jl0dx2w6Zj1Q0vPggQii1af3i1NbzG+X4oAPH3QKXX4gPtLTwZduqQ?=
 =?us-ascii?Q?368paAyb3XSfRgyhiLcToQ1hswHObZC46t/eX0VE4KBV187EbNQgmlM5moNx?=
 =?us-ascii?Q?Z3zWRmUoDmNuqSkkvW/cP860cjOiIpSZdk8feCZloO5seS9NvE+JfIRjzMY1?=
 =?us-ascii?Q?xAUFKIXPbZ1wKh1+PdWp+f5vyI9NSJUGzcURn1PWjER5QqMvs5CHaNQRIHy1?=
 =?us-ascii?Q?AxO0fAPP6RcRYwiwNuMGk88uiNZioLD0F/hudgO7xT200HI9UaJq2/fNmCFQ?=
 =?us-ascii?Q?S5R3I3mjbvSPFJ5Jt5s7O/dX4rDFGDkuo0lHdg0jWe6niDxnwyzEjMjNRdQB?=
 =?us-ascii?Q?rDFb3Puqsb3Yo8tuvffKd6ZO6P0uB/z71l0lVg9ChNy7hz0xOT9T/bGsm8nc?=
 =?us-ascii?Q?gXrrgE59xdWDqT5y8kjSIiTBDCQJ1FpxUEOEdh7MJwW2ujUxS5C5C2yllpq9?=
 =?us-ascii?Q?IbyHUc8LjjIhjqv753L4W8JWwsx7obBabzV58OEd7Q2dz6wyszG338UQtFh4?=
 =?us-ascii?Q?qyFNL2hxflzyIC70bna7uGeeuWVIBDKMm5ogE4kKQZ7O2iUSlA44ze0FCHGz?=
 =?us-ascii?Q?fnQZXqgA54AI6wGZvfzMDSPQMk1ah2KFSEyJFRkbs3jc3ZoQexf/3dwS64Ad?=
 =?us-ascii?Q?YSg/wtSTxTxgJLoU+l4vH9byvDgWzJFOFV6pQlfonbn56qk1/mpmh7sJ999l?=
 =?us-ascii?Q?mpOBz6fZslf7h4uVnk0etp4uLSJz7xp5COZAq6CND9NNHUMXI6llEC7a4wLN?=
 =?us-ascii?Q?Wx+XL2RB14x1deWwgzrv4lS6I6xDUJiVU/kmUwaZoN/yIK2qWi1BbKTwTn+a?=
 =?us-ascii?Q?fdGwrKjWNRsNPHKw1DM40BBVZozZPR7gd7SUMh47JnBG0Kbgts1n?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3915a62-dcd3-4d4f-6221-08da18ea887a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 23:01:21.9825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHrG+meEgRGVlPUfHBGOyqxJM06w3vtOT1Vap3NAsVhHGV5tkfRLhL7D8B1uRbHai5yRNjhawTKvfYbQwihUiH+qzruWBLijWKcGe4aaoY8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3125
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a local device *dev in order to not dereference the platform_device
several times throughout the probe function.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index c3d1a7eaec41..c6ebc3fc7ffb 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -266,6 +266,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 {
 	struct regmap *mii_regmap, *phy_regmap = NULL;
 	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
 	void __iomem *regs, *phy_regs;
 	struct mscc_miim_dev *miim;
 	struct resource *res;
@@ -274,57 +275,55 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
 	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(regs)) {
-		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
+		dev_err(dev, "Unable to map MIIM registers\n");
 		return PTR_ERR(regs);
 	}
 
-	mii_regmap = devm_regmap_init_mmio(&pdev->dev, regs,
-					   &mscc_miim_regmap_config);
+	mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
 
 	if (IS_ERR(mii_regmap)) {
-		dev_err(&pdev->dev, "Unable to create MIIM regmap\n");
+		dev_err(dev, "Unable to create MIIM regmap\n");
 		return PTR_ERR(mii_regmap);
 	}
 
 	/* This resource is optional */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res) {
-		phy_regs = devm_ioremap_resource(&pdev->dev, res);
+		phy_regs = devm_ioremap_resource(dev, res);
 		if (IS_ERR(phy_regs)) {
-			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
+			dev_err(dev, "Unable to map internal phy registers\n");
 			return PTR_ERR(phy_regs);
 		}
 
-		phy_regmap = devm_regmap_init_mmio(&pdev->dev, phy_regs,
-						   &mscc_miim_phy_regmap_config);
+		phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
+						   &mscc_miim_regmap_config);
 		if (IS_ERR(phy_regmap)) {
-			dev_err(&pdev->dev, "Unable to create phy register regmap\n");
+			dev_err(dev, "Unable to create phy register regmap\n");
 			return PTR_ERR(phy_regmap);
 		}
 	}
 
-	ret = mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0);
+	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Unable to setup the MDIO bus\n");
+		dev_err(dev, "Unable to setup the MDIO bus\n");
 		return ret;
 	}
 
 	miim = bus->priv;
 	miim->phy_regs = phy_regmap;
 
-	miim->info = device_get_match_data(&pdev->dev);
+	miim->info = device_get_match_data(dev);
 	if (!miim->info)
 		return -EINVAL;
 
-	miim->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	miim->clk = devm_clk_get_optional(dev, NULL);
 	if (IS_ERR(miim->clk))
 		return PTR_ERR(miim->clk);
 
 	of_property_read_u32(np, "clock-frequency", &miim->bus_freq);
 
 	if (miim->bus_freq && !miim->clk) {
-		dev_err(&pdev->dev,
-			"cannot use clock-frequency without a clock\n");
+		dev_err(dev, "cannot use clock-frequency without a clock\n");
 		return -EINVAL;
 	}
 
@@ -338,7 +337,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
 	ret = of_mdiobus_register(bus, np);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
+		dev_err(dev, "Cannot register MDIO bus (%d)\n", ret);
 		goto out_disable_clk;
 	}
 
-- 
2.25.1

