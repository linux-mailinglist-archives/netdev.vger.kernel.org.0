Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3564F8AF2
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiDGXrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 19:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbiDGXrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 19:47:05 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2118.outbound.protection.outlook.com [40.107.96.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20124DFD3;
        Thu,  7 Apr 2022 16:45:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9QJxa4/6UQNm2k6rYVI02COlyruk6uRS7EZZROBtbDi4fQBwnBCXAJ+nPATO4v8L1FKQjfF+D2934pGV0QVgtsN4lxbkb2I7Psdam/3deLo8WVHcNIC3WqxwwdLoDeH6x37Imp8msPcNXDHJawSjXWcZ+k8pDuAYUHuJH+wtpuit3jQ1kXkxD9e+zyjmbT2yec7SvgCwjvjAxjAoVe0aQUkOA980R1Oc1MJsYmetx/k9JzVPNHcuhTXBFRXI8OK7vwu3iw8/8b1J/tRPrIoSODWFmcsbOc8pM/DAGWY7Uar7XVcYOYHHsi4DXsjt/BX9z7P8JEvs9u7rxUQUiIXuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pz1tzj1vsD4+6d7yX8fmFrISodQlY0yq8bCcOafp3w4=;
 b=NJymR8GkPTpX2JItLnX8QBrX0BOqsOxmur4ltHmwyRFUw9544m1wZ7ePqDrICzPPpLKPCprJGNMyj79+Dcp7s0I9B9570z/0F0kqOY38JdouLQhzA2FPvwoBTP7HFQUpWJoah440uCiudxVf5KcKnESJsolLxfz0IsK4B5VEHf0sbjN77pZ5CYtkDu1AhVVWjEQFGRf12Q2I3AOoJ2YcDu0M3p51rkkWSrI7/0QlToegU89L5Fw5jgqJmlSzNWOLF3W65BSn7CEyY5uzo54b0mQNIpl+fk1e+fUt28L/tRV2tSZeFz7jYwq9tw8ec5j0DQ63nI3ykY99yUswtkvDhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pz1tzj1vsD4+6d7yX8fmFrISodQlY0yq8bCcOafp3w4=;
 b=ODcy/mn/RfRXMHWFRDPyIejJjVdB9mZxpyUsb8lUwXXz1Qn5QRwccz1JC+ljaNdWF2ttqFcqdv7j+8lNL8YxNiSQYymqvyM8nfKieUN48dVZJW1Qknldcb8UnmwGn+UO1QpqIaXsOiGwIHeuinmDdFBswLbs3VhZsiNVOJE5uvg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN6PR10MB1233.namprd10.prod.outlook.com
 (2603:10b6:405:f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 23:45:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 23:45:00 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 1/1] net: mdio: mscc-miim: add local dev variable to cleanup probe function
Date:   Thu,  7 Apr 2022 16:44:45 -0700
Message-Id: <20220407234445.114585-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407234445.114585-1-colin.foster@in-advantage.com>
References: <20220407234445.114585-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:a03:117::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f16f4ab-57fe-4504-bcd1-08da18f0a0eb
X-MS-TrafficTypeDiagnostic: BN6PR10MB1233:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12333B1410A7F4FD1F5ACE1CA4E69@BN6PR10MB1233.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KaHAujG82Ikza3e2q62ePkdWr5N+iiS1/KmJ9mL35MPmk7qq+Ezwgew+xma7Q9jaXa4qMRsGeX+P1jC+u7zvT6BhGKLqThgiB7UktPWx3KYbeKMXxhbKp3DDJtU3WM3oAZy1whGJvuqjGY9aEWDhNRou3HpPlCrJ26Xo3BbtEVkFHUiAraiJYFl5GdxRC7p5jqmAgd5BW8YQ6YW1PcwFZ7Q6jIf1Mt042f7aSFEjAZKExt2KrQUs/flBM8rd/kaeADF2I64jt47K2GhiKLiOoxgxDBt/B725bg40WL2sWzCVYoN+RCrG64ekRvOGxJqcE/u7wHGXTuOiyMaobyTjF7DoS3vAXg07cd+yY8keBhCEuOpkiulkHCkQ/7ibKtrbimhLpA2WXogTHfHH26qdLnL47OTit8UAzHklHmO9ulvOKNTN5eMiaDkDizYCdBjBGvnGlODlm5lYIuZMNrHBaDQkXckkfWMNBS48ZWEgwomDlZOBs5dgrjCBit+gejxmSE8Uo1rDEdgCBbhkp1TyqlYyqUtvrOjssZbuxD8v8Xh4+kjTVXtledy8VE08MaPs/6Cp1aGtwNCDDvr7TwxxDyM6wW5cCq7OOdimnpj7W10AcccrkQgoQWtWMfpbuCgWoNdLPuVHzEnyljP7stkVNYju022zhnxBEQCwPnLsm4kT4AyrrPVsRRUTQVblRxq8Da1Y2Fs1TIzZEoj/oXNaXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(376002)(39830400003)(346002)(136003)(5660300002)(6512007)(52116002)(8676002)(66476007)(26005)(66946007)(6666004)(66556008)(8936002)(2906002)(83380400001)(186003)(44832011)(2616005)(1076003)(7416002)(86362001)(4326008)(54906003)(6506007)(38350700002)(508600001)(38100700002)(6486002)(36756003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PuAs6Jva14eCUq6h1s5cVlctS90qTDA8kgw9TQ1CNS+AZKNZvoLXhz/WU4wK?=
 =?us-ascii?Q?8qzC0tAhJD0jjQrwP9hfsQJNfCIEJiFRjRZT5YWrgcM0II6l/XW5xB1b2scP?=
 =?us-ascii?Q?w8OYx1hw4haBO8TtWaSFFx560daJlQqBWuvWFVq5L9yXkuiHBCQN25VTDfdi?=
 =?us-ascii?Q?0XVf3BYFRw1RwxK8H93jp2p8jtWw4IOsMarGmPnLLDCPzpoODo5bdLddEq5F?=
 =?us-ascii?Q?wkgf7N59WZg+YHJzSVYvGLxL4uKLL8L9mWhhDE9bT8ioMp4DLaq3glcx3bTl?=
 =?us-ascii?Q?/E94l0ceA1y3wkGfgZ7kcVl6TTAuw1wP66xVC+PnNN1hGzzbGWkTXE0otAYP?=
 =?us-ascii?Q?mPJ07sivrmzHpQx9RjtYPYF8bFIge7BkEife7w3xvDVTe0kpiXqdvA1mefL9?=
 =?us-ascii?Q?umjGBQ9B4JiHqBaQoLPuJhvaioULXjMdogi4AchmPFBTXBCRONwUS4yPxuAJ?=
 =?us-ascii?Q?/wFcYDu8AXe+icx//UCCTvZOZgtru9HIoaI9GZX4bJwy6t4iVr00pzihD15c?=
 =?us-ascii?Q?YNn9GrNTiTUqtprpkoQ95gdj+Hq5V2cLjWr+6Q/4ZOJwcVXPOT6jhCnRgPaH?=
 =?us-ascii?Q?67A7kVoApoaLdrbkjYElV32qmb0PzR/mliu4wHpJb97WV8HgQezfEurLuMWu?=
 =?us-ascii?Q?9Swck9f0hKepuLrNJhfvD/78p5G7zDMORdPVEHwBRP50ubUUfPHfSG4kyCzg?=
 =?us-ascii?Q?POqmmdTnrrslxdqpGBfb9xrIR3UXRN6aLF2yVtg/l58w0rssiGPrczd8qXU+?=
 =?us-ascii?Q?0zV34rMiXzgPkiTIgsdQjQhIBeo1VnWTZLUTKw7CVFfTVpFmg/wuBxwDVB6O?=
 =?us-ascii?Q?fPJm2KYG8PUdSUceoC6Y99n5BWunAe11s+dTZSKZDmho9i8rqbWpfmQDXjiI?=
 =?us-ascii?Q?UBZuMXjTea0lzMjBrLVlSFu54JIhN5DLVCBH7WLAhH7l/QR6LvIcyyGq2/hf?=
 =?us-ascii?Q?NHvou+ymlx7Y/whfRBWDE/SD+oZ8wc/YnvZfTpmAP/wEQNXKnAo+H9ujNHYC?=
 =?us-ascii?Q?431KGd6sso/n2imUdIMx9IsvtaXiicDImX49xP9YiLAhDdsGiedS35kgLsiM?=
 =?us-ascii?Q?8v1Wq4sUlW2FXAFWQT/IXgMT+m5+Y30d5V9NmiR5o4oXRRC4SNESN2zA+Lpx?=
 =?us-ascii?Q?Gur4uepEx6rTAbPEKOOqrAKz+BEkX5MxrgDZAOghrOXTyLLowKlNZiZeBZJr?=
 =?us-ascii?Q?krPQyTjjSt6YBKodGQNzq/l6D7I5HezjheYR0Puf48xX/e8+zIfsgijIoiKj?=
 =?us-ascii?Q?8Jmho+JmYzHT9KHCM+A6lo1IIxvBoyw5Ws8gP1dAxv9W7yTQtP50i5OxofzK?=
 =?us-ascii?Q?AZCv53lEOI8MOaTlyWO9GHm83IXSsw6BehcBsGRdL32RwutTQJkJUWAdsXjq?=
 =?us-ascii?Q?soJZmmLUwbUT3iVb8XeNWlylfA0bykh6iQFPq5eKyyMOAjvLrlK+42RacsY7?=
 =?us-ascii?Q?lAzWr4fuhiYyRQi+6jgQZ6bgUhETLfbAvD6Jh7daHY5w8bQmUDuAouhByZk+?=
 =?us-ascii?Q?w0lz3aBlCIzcARjE4T2q8ZhTT9tb4dOaWnhgysKDPiSRxYBh2sLmQaNJXmuq?=
 =?us-ascii?Q?+QKyK20Z3ALN4a/6aYc2vAR3ZwKQsrn2yqtsW1/ihkPfMuhHsPEueJA5vrMc?=
 =?us-ascii?Q?JdmyctSRsE9lE3mbbVTL/JWE7BJqU8kcqvD4kbC4MJoaePD7s0MslkB/xRef?=
 =?us-ascii?Q?kgFpKyihEvg8egJaZOWNToX3tR9xxFhu6sZ0vw5m0VJlcZg47b3HQEbRQn2B?=
 =?us-ascii?Q?H7BcMjQgrsiNobhBGnMn08xOJ+Bk14gjNGQhTsNSSuVk1GomrxFz?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f16f4ab-57fe-4504-bcd1-08da18f0a0eb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 23:44:59.9711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnT/AgAyx/58PPHUcofTzQBqk326b+RIldAs3OB3vfIlLL8WpsY0lRBGwO9GNYOgvsBJuNkFJ4YW32a4ofTy2ORtBIOJG5Kvo66oCkSLT1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1233
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
 drivers/net/mdio/mdio-mscc-miim.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index c3d1a7eaec41..8bfa81123e30 100644
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
+		phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
 						   &mscc_miim_phy_regmap_config);
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

