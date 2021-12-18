Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874A7479DC0
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbhLRVuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:24 -0500
Received: from mail-mw2nam10on2096.outbound.protection.outlook.com ([40.107.94.96]:43520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234607AbhLRVuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWJzvAPIbTLHxEHBxSYhup1Gx6u63pVXWPrzSlFBPPRPgpGWxEsybz57tqByx61NcBK8SvW9/hvfU32peeHbHbN+pBnY0LqSImTAoF6KHE6SfNlwWhlFJqhwmxTOgepDvMxFE0IFn6U6ay7aDqDq4/9VHNKAOtrcXSmuhQbahrYFdrwvSy4wAitLG7SeJ4myCqfZDgPWMxKVKFuna0bC4yfQMBgKAeulcj0zj28nBbCEwaKKYYt4lJSaeEoHlfGCCX5bonVxZ/t9MPIChTizo9hAxv1q+bMVE7OKIfmi3eRCBBCfErJHxUo28IjJLqL9hvVd+7j/bP4/b3WP/0MXIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hc00B0xqv6Avk6vvNFD/t8Fqb6x0A2sT+rxx6vZ/siY=;
 b=Z9ZgqJlqtlEk4KHstdBOZ1sVklsufdFzsOUH715fJMbg9Ppg8yBPmgD6Rven7IdWYafNc3OaLSRUWRPxeTMx4EJgcIUhM7fEstIESSPKP/5f/lsDZyzs5kSORB+ARKnk+s4O1+24z6Pqa433jt2GcIuV0gKre28iCflGBuPB+1AdqhOzGvlxXExlAUUsycCefIcakXwRqoBdPb4RCKU1HTLIsDHOl1NOAlXoGyXODZZ++rSubs9h1p0FUF4t314AIY8mJQBpiPIf0aTgWY+bwGc6lQObmvxWHAuRCOu8LhU1P/FAIvM2DjdplNnz/uCGnQY7jW23tIo0SDy1eK9MAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc00B0xqv6Avk6vvNFD/t8Fqb6x0A2sT+rxx6vZ/siY=;
 b=s0oBk0vEE+Mo1OIz5e7pzVEyMYuqmuvhnxTY0jifhsMDY08GxhcnVOegFclwyjcVZ62AsQ0fwlwurwCGzUBsbE7cLvDdxkRXyly4okAg0mJzCNecwG1a8Z/nFN4AOzz9XasqcSG7L31w2oIsRskUBbILrQ1eoNDAABYEUgdK0yw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:12 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 09/13] net: mdio: mscc-miim: add local dev variable to cleanup probe function
Date:   Sat, 18 Dec 2021 13:49:50 -0800
Message-Id: <20211218214954.109755-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08d41177-cecf-4625-d7df-08d9c2705e71
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5633EA4BE3DC3268455142BBA4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2UV65HEWPnYYzl4DGPbsV4PAb7QJ5YxDyvt8HA0NLtR7PGXAFFsYQEgs4vJTRckX9c11brWzGC0Am+yjPDqnnIDUxrkF3Jf6m+tt8STgR9i7Rkf88/B4t6Mhpmt6epNdT8jvrx7mq7WahowGiahNVD0OXAxmlrbiKFJ2yfNMXSGD+ONfwPR+SjabG+y6zlAct8o+SU4VzvnB5CpkasxXyZMqhKT5nfTcE8jn8TsClky83LfD+2XyML0bQ1YmWpklbq9P0cCmP6naGbrJA3jF28dWdTATyX90wX+Uz3yyoJVIttqa1+tb9eju5uhcknbZmSqy+EJFfs68RtDa/rVDvhiPXFQsXYkRXeycRMn12IyOSWYAKOp+RBjSHV4AdBjwVvHmXzySigxlSlpgMCnTrVJv8/IWHc6OG5YmS6X5VDsDsblJKPNmcYdNEfq+1vQPSugHm3EBfsNvookb6+JWKckMDq/svF9duazO5dDxzHrYmBtzuQsGbxGwSdAm5SPtjoc/RcWPNcrzxOaZWjHLpkke4G4H0PrymWUZrd34jRCRpckSKPIG5XepjgX4RngTF2Frn4DlFpYMBW66elheKk0HdnncuEnzOEoDNjcjYQF0mFVKGeb7IjIPxNpUDPSZZzf+hSrJKf7iBQgPzrFJmXpYDo9lFNlAjAzVRvWf6ZgGHxrRiCDzshnGNEIhUU0Wd7Q8fqxOdldpZCPcT+uvig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39840400004)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(83380400001)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LVvPaCIK/SwaasYxDf/LfJ75+VOuipoDTT3Uy5+qgCtS7btv9c8SI7LmEyYQ?=
 =?us-ascii?Q?v/EpZ8bYmpVABWJeH4p1Bk1Xqb/or6ZXzEhHVplVLGeVjDbK4L/bpsJ/LLqk?=
 =?us-ascii?Q?Vf9RHihKeWKwHdLXsZNbbOb7ADgEzcu2X+MIiwwI+L3tLXO04S2yrQyUdSAz?=
 =?us-ascii?Q?ShFkgAt75Lt0grg4MURd5RnxWOMvkFOW3I7VW4XafzQ+lSDGFamGbZFf/sKr?=
 =?us-ascii?Q?81NJyvHZrjaSDjOc4n4Qufs85jV05BJblXcwWpyjhLILVh2qNMOEA1O8Ggq8?=
 =?us-ascii?Q?hgOz+98D8lm5Jqdb1EEwP9Avxije7i2tDgCtk4b6H/9oQNBjXQ+KeNXQhPcV?=
 =?us-ascii?Q?r4/iUKMM7K/YsMBl6TCHif9gkiq13lnkm2NyhGFGwzVIBpMihSYv61bJ13RZ?=
 =?us-ascii?Q?cWUAMI96yc5karRl+MDKrIFm9c59Ttr5g6SM9b5qKzeeycu2pP+fURTKFQjn?=
 =?us-ascii?Q?rvtOuIvJDGrJBIjLM3VLEI7jiz0UaHNqgsxzQwu9HXjpFTtZliEaxj/zkZIX?=
 =?us-ascii?Q?vdVzOy2WsQ4/HToRTLcd+k+JhI2dO0cMU9G/8uQXX0QKq7cygYUPIcziHIne?=
 =?us-ascii?Q?HnmmetaxciWx8x8FX77IRrc29mSuqWjPSQd7YF9q7IhC/38WlPzgilPEHcDd?=
 =?us-ascii?Q?qgeYSo5p3eSEXaXBGyFf+RxWnvQvF32iylyx+gOfJD5jQ2K61oA5ZaUEdxUO?=
 =?us-ascii?Q?0qRlDhvSm+WyG6vfWBaikLUqjBhSi/MaQZ6hcQlSJSxVMbphSEKw3sSpAmoA?=
 =?us-ascii?Q?JuYQ2hGFn3IXMnJ6v+Qy8vvlcrNvcrqdJoBnzmE+C56SbMdgm+Nuoysc+qc1?=
 =?us-ascii?Q?W6OuR0YjvHl+2X6H4iueHJZWTFKFEwrL1ZZdEbg4+JgkDYhvsRWHtRhxhBYK?=
 =?us-ascii?Q?b5R1dc3u7BlnXKOWj5h6LHsK5od3xPLxIcQ5HsmAretXD41uf6ckrx4D8FS2?=
 =?us-ascii?Q?pDl9sVkVLrxUlAbdWge2U5EBNOM5R4yLZcC0iUrBJuT5WnxXoe7m+rcGip90?=
 =?us-ascii?Q?qPWEVwe7mZvpkKLT//R1pwiTPdOmhW3USU0t6g47+wf5hufeT3VQZHJ6DLJ7?=
 =?us-ascii?Q?vPss5SvC35hWMumI7MIolNcSHgxL6ryBKlJh5yqzVwrNUTgnl5A61VtwqB0P?=
 =?us-ascii?Q?bGKlJvNUtVmj9Mz6UXBSH+B+q+Dl2NE7EoXYog+DdEB01XuJ03CXyHVX+C8S?=
 =?us-ascii?Q?tAmr9bTBvMoqipFjKUGrOosUczj3/GQN/B+O441lar1pkb7ScMPaNU/8ShCC?=
 =?us-ascii?Q?8tvvXdd7GFbJRalsTHVFPhHdcgE+K0ILZFD/H/XtUEl7iwdXadn6k4Yy9C7i?=
 =?us-ascii?Q?MR4S524IxzxFsz3a0w/blQAdEb/o7fCI95WKnar9lJMMTma06P2R1cJ8c/mk?=
 =?us-ascii?Q?OMdcjVO4vnlWDZHDuCPGBB+cFjRYZqkmuZOyHMyJAB5/62r2j36pqsqBI45U?=
 =?us-ascii?Q?lR/ihdhlykoeADcojkAkFCimehEr1QM5vStSfpnwYSIukiGjeDCSfLtBrMGP?=
 =?us-ascii?Q?sr5M1Q1zrZ7uzkv5A5Ztj4eyY+9Gi51umIDhKJ3tkIJBLs2lUaAm4RR1V9Eo?=
 =?us-ascii?Q?ITdH2mOrP91h6wQwJETnq29WBlTxbFm5P1+xzE6OtrK2BI5SWtuhGGrQ943M?=
 =?us-ascii?Q?KBHPlzzW2zNDolQJdheMCX0mFET0XobaAEfKWUc/cyvZW4VWAivIr755jKzT?=
 =?us-ascii?Q?BVcr+BSiaUelN2a5ElmptQR9M6Q=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d41177-cecf-4625-d7df-08d9c2705e71
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:12.7999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: acwZbkW9goG7udsmBUWTFC+r/CssCL5ingCutJmrcs9H0cdpGXBdz4QVkoSSnwvX+IMi5yuagX3aYNJxu5V+fDr9OhVAbwO8D7tKWwU74BY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a local device *dev in order to not dereference the platform_device
several times throughout the probe function.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index e16ab2ffacf6..00757e77fab0 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -223,6 +223,7 @@ EXPORT_SYMBOL(mscc_miim_setup);
 static int mscc_miim_probe(struct platform_device *pdev)
 {
 	struct regmap *mii_regmap, *phy_regmap = NULL;
+	struct device *dev = &pdev->dev;
 	void __iomem *regs, *phy_regs;
 	struct mscc_miim_dev *miim;
 	struct resource *res;
@@ -231,47 +232,46 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
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
 						   &mscc_miim_regmap_config);
 		if (IS_ERR(phy_regmap)) {
-			dev_err(&pdev->dev, "Unable to create phy register regmap\n");
+			dev_err(dev, "Unable to create phy register regmap\n");
 			return PTR_ERR(phy_regmap);
 		}
 	}
 
-	ret = mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0,
-			      phy_regmap, 0);
+	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0, phy_regmap,
+			      0);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Unable to setup the MDIO bus\n");
+		dev_err(dev, "Unable to setup the MDIO bus\n");
 		return ret;
 	}
 
 	miim = bus->priv;
 
-	ret = of_mdiobus_register(bus, pdev->dev.of_node);
+	ret = of_mdiobus_register(bus, dev->of_node);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
+		dev_err(dev, "Cannot register MDIO bus (%d)\n", ret);
 		return ret;
 	}
 
-- 
2.25.1

