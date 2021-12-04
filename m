Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B1C4686F5
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385426AbhLDSZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:25:09 -0500
Received: from mail-dm6nam10on2095.outbound.protection.outlook.com ([40.107.93.95]:6433
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1385413AbhLDSZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:25:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWOfPtfXCkx2/lCcCir80QguWqEeqCySVRaNPuxe2e+en4NhNxJT9TxxHbET8hhFtsoYkRZXMXnWESW5oXk+rPdwGycIBfvDqpdxhXcB0RwygUH5Bc77fyNwcE3gM68XYAK7xg7n4lptSuGUPya528sMhzKi4ivs6MxvqQg0hKIOegQ8WEs1PU73QbkWkh8zd0FuZ57n69kNvGYWie6MgaxstN+cF5KQHIRJjqvOFZdu9ifnCZdrOrht2uNkiC2JiNJqGEKP2ZL+Mupa4k15+RI2y31vu3ircdXzR17zOUiMTC8SGn2nvt1SM1qEMU8SjMQJfUz7EWgPnhZgx2oXDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJHikKGjzYL3zY3aXozgnTIg6hgegdf2xZxHKjteHdk=;
 b=eL0lin29Cd+m+ulDUWzI/GOcUXguDLcWv8s9Bgj/U2iXkSGUeduBI/Wk3+Bm6a1m2lo/t4fkgNmYP2vq88nGVeH4K3jtLOMPqW8liNyg9liyJHVaxmbparAJ3X5gHKt/6tZjj2fxJ3mqw74rqOzrh0Uq0ZUcUQWx/9dhIv7n14hnzmf2a0+h4x4r7xSoxw0HNz6MA2qOZ2MVxbhg4mkMFhTCi5Eu7KzfTSj0Qleep1kPm6NoHdV908+Q278I7HOjSBSPfs563CIqjiak0JJcWjZy5KGFHGDEjcqqCw1V4P9HZYOQdj+tyYvSL6W2x0+y2s6pB4TP1C6IXuncPWOPHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJHikKGjzYL3zY3aXozgnTIg6hgegdf2xZxHKjteHdk=;
 b=LZXs0MreIHpg3azsCzfS9a2AQ5fyzPvOcdtgg+7Yl3u4p62WGHdsTseTc5kxAUU458aN9Jz4ecGUN5tjnqHwxNMGScMgfeIDLaKQ0YbE0hXAkHJLOs4V8i4i18pisIME1fPlIyLNSXz6Bk9kJ1mTcPloYSV0h0pBTNnbchE1bE8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2061.namprd10.prod.outlook.com
 (2603:10b6:301:36::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sat, 4 Dec
 2021 18:21:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:21:41 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v3 net-next 1/5] net: dsa: ocelot: remove unnecessary pci_bar variables
Date:   Sat,  4 Dec 2021 10:21:25 -0800
Message-Id: <20211204182129.1044899-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204182129.1044899-1-colin.foster@in-advantage.com>
References: <20211204182129.1044899-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR10CA0002.namprd10.prod.outlook.com (2603:10b6:301::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 18:21:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a031f61-5c24-4f55-af0f-08d9b752eb3f
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2061:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2061B4F1B5209B1D76AE9FBEA46B9@MWHPR1001MB2061.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/APKF9L8yNcxirOkuIGKlAGzynLhzfIwnn1+yzH2dcIm4p6dP1Jsmwy7oPjxm65b9dcSj9Sh1PP0xlxs9aDiGZ0x1s9F6a+yWterrnztRKNrFTgl0Vn4r+xU6htIwM+CPOqbPgJZlyASRb4H4Q0z3wflKeB5hXSPDRAjHCWoQ+sgTXVDx7VWM6Hw44f0nRi+jXAeBJEDzBUqK9U6Lj/wRTue6bHDwuGC2KxOXninKne5CWguQmUZ+rC4ScEA7a6wHTnvtBzT0Wo/iGLkgn6gKO/ZIFeH1lkN+5eZwwQadFdX740fccMSg/cpE+tuPUm1Cl5pkyHmI30ivCjhg4WjY1HEe4ZiCHfabGHxus1q8n7WmcG2kMMLKcTl65mLPihC/gN3bEorDIPyFVPgjRgCFygDvE+e9OzMcDZYsxw/DOYyPV83JYt7ZxTi/eMGXEDQptdC47C/uSGTDF6pwjFmS2QsxeCjPVtj6fT6ZOwhgtHFrWwvbh2NsnkQYktLhFRaFB+0ssV66Y/O78kt7SAEPt1vxJto9B0HEb49RCLNhsr2OikwmsMF7aJxZMzC+NEUHcbWSgJYlFdIp1kPilo1dOnDju1DYFQQVhBR4eoGyDPiVB6jRaIMPs0BOHBUFtIF278qVMsogJscCGSY4SsP/4ZH7yPBohqEBWUzrDiVssFAimIz+zIungjvcEkDCxB8kCqWYxzuNOOJBD2ydkALA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(39830400003)(346002)(54906003)(52116002)(7416002)(6486002)(2906002)(6506007)(36756003)(66556008)(8676002)(26005)(186003)(66476007)(316002)(8936002)(83380400001)(2616005)(86362001)(6666004)(5660300002)(66946007)(956004)(38100700002)(4326008)(38350700002)(44832011)(508600001)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y3Jkrf241xkFnAy/XzkblNo3+CwSuhnF3WgwsobKLRWbiScHk5o+NPsnnx9d?=
 =?us-ascii?Q?f2N2P7jJ+EWXMbaHcYNvVamvomlWjDkD1QodFn+nMO3GOkJ15GwYh5SD1wHk?=
 =?us-ascii?Q?nYW44T2nMmmjyYFAuZW7lUrbQVP58sd39EQJdZEMbTL1/E2jqaQ6T3bzEs6i?=
 =?us-ascii?Q?MsHgMKnG4MLPdzoKDOflR5ezQLO9fxDpwin9wLgMlRJ07o38FZaEzs7Z3toG?=
 =?us-ascii?Q?sU47vCXe78jc7UgO2aMC9YaulY+VWCzur1sd5mZ/lD+yQOcYyhx+I9BtcOXS?=
 =?us-ascii?Q?WdtwAZficTiIKZf0hDrF0pHi/DRTgm1V5BlE0dPTGZV7jmwTCsa4ec4UQ7GU?=
 =?us-ascii?Q?YErVvMOQMYCkuzt5LYlKecUyeMnDg1T5uvJgMKxhV09pRmrALS/AcU4OR59f?=
 =?us-ascii?Q?TcE6P9GIU32tcmG+i33dC6OrCJ+2NUQLXAPO0o0Yrq0o456m3KGo2aAhhunc?=
 =?us-ascii?Q?vV+7XvNvFb1yCM/a+oHMVbEShtGheh/q8OaL155XflL5tpsbmlFXV7GyvaLX?=
 =?us-ascii?Q?c9tkBXmwQX9mv9RvqPWw+JNKgkGCG9ypxQHSbj7w8+BoO/y6+4OlE7pSkstG?=
 =?us-ascii?Q?uwl2onxAk4GxsHPT9AT4hnzXqMBCUR6tWX1Xa0xoPpUkEWnlAp+BO4MpxkPV?=
 =?us-ascii?Q?Fes6LzZBbEdfDdjLsUwlYBjXkLAhZqC0k9F3wPGpAaLV66tEKu1R0Xl968Q4?=
 =?us-ascii?Q?Yh9+IPk1PrXqC9yjDhczYbfFLJgSf6K4nq5MASA+P7od+b0wg+qpYMnYJ/cJ?=
 =?us-ascii?Q?yVRPXxqns5U9MpOpEfrnCGL1e0KfvSIjJnpRGK9Xi7L5OWSL1EbSs6bgxcTs?=
 =?us-ascii?Q?cvz/0OxDjCn20eA0xvjsylHN9uZYk3rk/eBR4tjz0fJkacjpdc9lPdqNNIGZ?=
 =?us-ascii?Q?LzqaBiCo58FmVDo/b+ECp14qVu7piRrUAOg/fSy6ENT8MQPViAtQhZ+hrQXy?=
 =?us-ascii?Q?YGvhcxIeD9W/EcOljJ8oSGxQWzyaj4GpYZF61518ohBhWgqGD8krLx5E6wxv?=
 =?us-ascii?Q?I+bsMI34ObcxQXv0SXQaH8Do1TmYUBprRNqjbnvslpj5xnfmNFMGbps/nqCi?=
 =?us-ascii?Q?CrEtpPFqP41YuwNe6ZqG2e1z1quKCLVT7uPzhc2XCAhBnytOSth92I/tzfbi?=
 =?us-ascii?Q?+kG9vJTSfGGVQhkiUC/gpyZsxDlu9DGJl/QUfOcosgm6xKVdQ7POp0gMbeVz?=
 =?us-ascii?Q?niVSJ8chhQIhZCiKYdgZN3FQ+ZcowDWo48JU++YIAWBA8/iZTVWFJOPyF8Yw?=
 =?us-ascii?Q?XnmeVza9lrifCpG2gzUa0GiSULsBarrMFyhlJkW/7QzkZzetgRUFT/rLAF6G?=
 =?us-ascii?Q?J+3E9fKbK0oHSM3BnaYV6fUpsDCW6aWI1pGkm01L4JRe76jBZO8XuGF1bNxF?=
 =?us-ascii?Q?QuGCCyA53jrh7ytXeQCJ2NPnYox/WcGfSXeuQ0SnO/CKCkmQPwAG/Q92FmJv?=
 =?us-ascii?Q?c6cyNlZcfrsQ56D8hsWwsp4Y3XYvF+qeWIR97Wv6J8Ie68FScwRhRrGYALeT?=
 =?us-ascii?Q?+v9qm6F5SM8Cvg66YaQIUrbbRh2FVA1GzgFU+58C8SgVFvrT80VmymuSprQl?=
 =?us-ascii?Q?kiOIclXyh3m8Fn4P/gzbeLMR6SnM+DEyRI4wBibJbfV0k4iQ4wto+MXin7qt?=
 =?us-ascii?Q?+66AxcuHKUJOdA3EbsLG1fqY5t9Bw2EFRRpKP7SyQeM11Gpv5hLVfwvBnZ8C?=
 =?us-ascii?Q?15hhvrFY+mo4mInkWS8w+J+YLXE=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a031f61-5c24-4f55-af0f-08d9b752eb3f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:21:41.3485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJfFQtSY50stwscqbXoLFBtbFqjGIgvLZW3gr/yrk7WF26kTIl91GqMvYM6g2f8F3cM9AO1Qy/2NT6wD/ClNuOXREBKQM88kOVTxz5zjQ+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pci_bar variables for the switch and imdio don't make sense for the
generic felix driver. Moving them to felix_vsc9959 to limit scope and
simplify the felix_info struct.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/ocelot/felix.h         |  2 --
 drivers/net/dsa/ocelot/felix_vsc9959.c | 10 ++++------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index dfe08dddd262..183dbf832db9 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -25,8 +25,6 @@ struct felix_info {
 	u16				vcap_pol_max;
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
-	int				switch_pci_bar;
-	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
 
 	/* Some Ocelot switches are integrated into the SoC without the
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 9add86eda7e3..0676e204c804 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -21,6 +21,8 @@
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
 #define VSC9959_VCAP_POLICER_BASE	63
 #define VSC9959_VCAP_POLICER_MAX	383
+#define VSC9959_SWITCH_PCI_BAR		4
+#define VSC9959_IMDIO_PCI_BAR		0
 
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
@@ -2230,8 +2232,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= OCELOT_NUM_TC,
-	.switch_pci_bar		= 4,
-	.imdio_pci_bar		= 0,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
@@ -2290,10 +2290,8 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	ocelot->dev = &pdev->dev;
 	ocelot->num_flooding_pgids = OCELOT_NUM_TC;
 	felix->info = &felix_info_vsc9959;
-	felix->switch_base = pci_resource_start(pdev,
-						felix->info->switch_pci_bar);
-	felix->imdio_base = pci_resource_start(pdev,
-					       felix->info->imdio_pci_bar);
+	felix->switch_base = pci_resource_start(pdev, VSC9959_SWITCH_PCI_BAR);
+	felix->imdio_base = pci_resource_start(pdev, VSC9959_IMDIO_PCI_BAR);
 
 	pci_set_master(pdev);
 
-- 
2.25.1

