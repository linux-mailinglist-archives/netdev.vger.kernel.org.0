Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135164681A5
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383952AbhLDBEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:04:31 -0500
Received: from mail-dm6nam11on2113.outbound.protection.outlook.com ([40.107.223.113]:36640
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354589AbhLDBEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 20:04:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHJ0TrdkbSmh6sFosq6vCGMXgcMHb/Eqh3SlbEIdnVjFchXOSq42Bf23hzBBm7DUG3E2Rvnxp8NWjQx7mIJKhy9lOH7G14n3wr2rP5CThjuzIgrE3SCzpJ5hzVq1uQ1Ova66uP6VN1h4rDVyHDhuQAX+N6YHKkv7MqV+2nwbEbaiwAfg6EuWibH5nBPwkSqe0hBWQALjfY0U5WpLUYFEJKJ0mpCUgAT/4s4Ht6Y4AeObI1uPJO3leuyGsMbVXgJi894cjqbNgSsQ4Y1IFoUzTa03UAWV3outGbeXLViXgEhjiIs96pKCIezAapUy9kigaV3QFpSAQRHX7R3Y1WCpGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJHikKGjzYL3zY3aXozgnTIg6hgegdf2xZxHKjteHdk=;
 b=cMoGdUwM+ZYz8KCYen240oQ0maPNpjiLfDHceTD6futBpk9DMDPEXeG9NesksYuWVtuGG+5CDnAeyw7x/p/VODizPstLJde/rcBOCkHvDY5Lxqqa7O5R5p0Dx5YW56weH4cWrk3c6aQHhjQhrw+dqFxSkKUTkADI3+OkQ9bay/jSahpaJsJC9w4+1IIKlkHSrrKdIP59o8TfsoUvu20xScfXdnOx9sFg1GB/EZ6VtkrIix0WTDsJfKJNjjAMnGce7+4XvK1bPiL4yhLDYAS9wx8eFAZ+xTsdHiWMXbcSc/CGQEVkMxYmaAvwgc6MR0qlNamY+RUggXDtGGbCszHcgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJHikKGjzYL3zY3aXozgnTIg6hgegdf2xZxHKjteHdk=;
 b=M8fyqmJgd6eCg+cOxcwD0ivP0vrembU04vJcX7gVIIO5V8j/Iag0VeKJfh7TFzuJLxc8d+UiaID6LFw1aKCmMogz4TC7s+eYRstVqoDIIx3zuM1QimUqhOjjEj1SW89AfEQtTKgt4HwP9iwPchG5Swygp6ZJ0AnIK6/z9K5/Hds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Sat, 4 Dec
 2021 01:01:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.028; Sat, 4 Dec 2021
 01:01:03 +0000
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
Subject: [PATCH v2 net-next 1/5] net: dsa: ocelot: remove unnecessary pci_bar variables
Date:   Fri,  3 Dec 2021 17:00:46 -0800
Message-Id: <20211204010050.1013718-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204010050.1013718-1-colin.foster@in-advantage.com>
References: <20211204010050.1013718-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:300:4b::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR02CA0020.namprd02.prod.outlook.com (2603:10b6:300:4b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sat, 4 Dec 2021 01:01:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ace868a-0bb0-459a-af57-08d9b6c18b2e
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:
X-Microsoft-Antispam-PRVS: <MW4PR10MB5701EB2DE8C8CA3A1C925798A46B9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zpde6PDCRWABFJMvg4SCzBBcH+8kSDoNnO4pkWl9WGeDGR8WAbzJLvQK6W4iUaSYiwxwwRyhcZpsVTq8ey1TWnOd1KJwipkvqI8w2cOE0njwquQxwg/9xGWMvHlJB1iktWae7hSWXf1VdQenT+/4agBCc8bnfzNCa8UALs0Paxrrwun+pnkAfdX4B7XhyAbxj99Uq8uW4q6nm3YcZYjQywAtf+lSCtwyhhZzzzLd4WYtAoYRMUiKrMORUkkVKjgReO3SjeeumVZCxUtNALzGCzYjj1s0JacZPZNrVOwFlXWeCbt2kw21+XZOMErkYYHapwR5+c3F4IrBCIM9G/gFUpK8Euo248c/S5OZjRopo7FAhmcvKmc73/CEl7qptXv4rX1vgg1hw+wKye5dEtsL8iy5zTNp9qxZee446OM1kpFXNTIRXnXepPOapS+L0f8+qlQUDmwGmgjYMNK0ORLPSlXBHx83FoezMX6hRKGLiGD0RdAayie3NXLP/TC1Pc0UeIcpbL/Hu+b6JyMaWT+G8IcTfML5Qk6pzVRbIg/HpExb/kRYufATzcsgdrOrTrt4WASxvZImmb1x8/iNpk5cJBTtrTrcd6Ul/oIuOpxha7srVj2aPluVitxjsFfMLuQag4wIUkT+0rtnR6zz6cQSQ+5eaIHfKg3zhkKeVOZwrVNT7VOsiDnB8uz7olHAKmpUFcixVp5Uy3plSlS1VPc4eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39830400003)(376002)(346002)(5660300002)(7416002)(6666004)(83380400001)(6512007)(2906002)(8936002)(66946007)(6486002)(66556008)(1076003)(66476007)(316002)(186003)(8676002)(4326008)(54906003)(36756003)(86362001)(38100700002)(44832011)(956004)(52116002)(508600001)(26005)(38350700002)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F9VjqBa2EJ6B2tw8MSZwjZi0PHQ9GNr4qhthcD9vugbWsk7yPMoFqsfUWKpP?=
 =?us-ascii?Q?3+83Lo+S2Tia9UHWbCQxuo4JwRaIMUU6d4xZ9vjQReMOa84G04YyS59x+HSX?=
 =?us-ascii?Q?bbrN2tuaSNhHJ8COMkeUIp/nVgu/fNbZuhoJh9b6WHONBqsylk5GhHpr8sds?=
 =?us-ascii?Q?yc0P9s5/DKh0xpCrbtGdcbRJ1BUeo4fSz2GLoqvj4vWXQ2wDuMm6yDjAzN+V?=
 =?us-ascii?Q?1WIMLIOQ+JkADEfYQcpRm4tfZEyDPYUIhIu0ficQCeg7qqnahcaHIr48PH3+?=
 =?us-ascii?Q?I3fBBpYyhiTC+gHrH3uSPiMqSNwpOBoo4cK/6tZ6kh6eXJz6ugRSyhv1dJ2Q?=
 =?us-ascii?Q?PJd1wvRhq5FRfrTyPfSpZ5gfSKu5EO5ggUQFSLpxxBCrppljSAQEeUIDWyiS?=
 =?us-ascii?Q?S8lrSghQXu+MU9Q36pG9kcxdbc8YVhCexrKU6xDAkysVy1MsVzsE7Wyno9Cu?=
 =?us-ascii?Q?dCH3BYYJ5pI3eu7vLF0dV1dVCXetl/64dM5+8GsPNejIcTZjv1a5b36A41Gl?=
 =?us-ascii?Q?M91eb9APHWgye/5DWPKA7BiqsCpzL8HBIjzNfeCYejLYr9hhQkJSI/L7155i?=
 =?us-ascii?Q?0iY1iVvJMkNFWLCUSQrVW4KvH/hZnrsvOm33Zvy8ZOeg0B+Kr+7jHW6yFmk+?=
 =?us-ascii?Q?tw0JGAQWTkfqe2kZHIBsAviFnz6/diYk7azUsYCrFFd3WK7aAcqV4MGThAw/?=
 =?us-ascii?Q?OMhca7VBK2XvZo4xStmFwCoZ8ZNsijXP1BAuIkKwo86ppA1wCNjSmZ6sSqiA?=
 =?us-ascii?Q?85ydrDaWtAs8wZvSV4ykcv+6SbM08E0NAwRLbV9xbF34oP1bgo6xnemLkZMW?=
 =?us-ascii?Q?PYFXX37MVtGCs2g8+Z/SVkYEupjuJdIsDAcV+o+5//7EvFNwrnoSdgTrAVTT?=
 =?us-ascii?Q?z+wufAQLsws7sOZZTuvzv9jgi7f7Et9LAljCoCxFu1UafE2k5H7ACmkZO2jS?=
 =?us-ascii?Q?PNoqGaqdRVV7RoGyG4eARowKcLmHMwYn2QPH65UbnpZYZHxHCdRDNqZ6YrZ/?=
 =?us-ascii?Q?cK9QIbqZ+w/V7kIjYATAuf4nxO0AKFiYybpxAbW6rdVtHP1YyrkE+r4C+9Jc?=
 =?us-ascii?Q?7F/adGPNChw1feIsWNOOWtmkszf1NvXwHsIF8gYWfwls4JWuKEaoy4Gp1BWq?=
 =?us-ascii?Q?WN1UojgHmWX+jLh2Gd5iz1l5GHcVvSfQh1tGrlTy7S/mOj9fpQ68eAlX/xmu?=
 =?us-ascii?Q?zGOXrMutpL6W7+tV7VuE60d0xR5HrvnAKTnKF4/XXWLMGrEifCfQwcihaxfj?=
 =?us-ascii?Q?Xu/DeRVwdjmYc8A1Iv+BXXf7XtWSFdPx7Ye8ZjLAfvIu4sxus4Wr5zm09N5C?=
 =?us-ascii?Q?daq9UixhnhSr1Sxp6lO1sbJSa6e1eQP2idNdyq74LJtIlcl1MYyRt1FdSOBQ?=
 =?us-ascii?Q?/8wR3gBB/G90L6MkYqZ+F3Tvmlet3YyILIaZYCOCY1YUVbrKJVyoJJK8nGIO?=
 =?us-ascii?Q?zwLDQizd/V+E5ng8mmFbi+XXy+QJ/BE78v+VKOsjKzf7OC70bohB9Lu/g+/q?=
 =?us-ascii?Q?Sg7+JGOuRrpj9stA6swuNv5g3hNI+zrHUcaUkZqhfQSG7C5TBAU6WGUgNGES?=
 =?us-ascii?Q?j6aHTay8kFFIaaEaMvELykK8DBGK8aWN0N8HBTfkxhGkGsiZN97KmNpNSX0n?=
 =?us-ascii?Q?5+f/klqvECwa9Je94PBxYPFHpVgcJgZjhOPmfMiXXkjt2nS5ORqjtaTffFuA?=
 =?us-ascii?Q?S/wwSw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ace868a-0bb0-459a-af57-08d9b6c18b2e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 01:01:03.1940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4Vg02C3VA8CNOHqLv2mxlu5VgAcxUo3Ki12oGqx3LnH0xs0+l9WDnaMY1ThniC6RyH6T2oJCMeQQR8p6Egsq1e+buA5gt1th9R9vvSXeIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
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

