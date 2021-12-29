Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4AF480F3D
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238533AbhL2DWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:22:55 -0500
Received: from mail-bn8nam08on2138.outbound.protection.outlook.com ([40.107.100.138]:18785
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233058AbhL2DWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 22:22:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWL08LsP36ZgpJF7kEIzWcHvlrHYCdJK4bv1KH9Rq4KHCZRQfPLdmheLM4fvcjI7Y1LOVlfqYVJpYle01uL7r+5CQQsMTpDekV36DRigvzhALAyDnt3CyTwru5PCrN0AdLhNbPEZRgCjjkRK2R2BRVgPuGrAs/WQUA3c5/zJNbdO7836DNfC1wKzCrzICPH6yjQjIrXF4xrYRyxl18zNZRve8qngzfUW+6TzkCg697/5TMCizhK/BZezNlsCxYgbD/B45x9Kx0iayLq84UaCw6+tVElEt/W8c0UyGUK/4wNqeRZuRWuhvoIIItlQM+1WSBlduFb5x8btLFGhlfSscw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxp44wy/vkVOsA6JwbYdAYpKJJeRm9GLNLloxAuFrYk=;
 b=Pq4el0nqFEWpZMxlDEXMC/gECN9IQRuKdLnyEv/RJnaWjzt6FSO1Q4KbfifzATLKE12r/RC1ZuoOS9ZuAULceYtQtUrv6Hfyjx6tgisU+B0VibVKv8s7SFbCFsdXE3sQPb73Osk/yLgWvVCPlUhHy3J09c9TnrZAaIh27cK+dxHOr1nQgvVO3Oi2salrnalgmD66mhDeq81LATPI68ah5ykR/YdNe9HY919VkWH36Rf/XDVn9T/5iuZBpiQ32zyIItm70NDJnSjR3PqLTI4AOeLhTxvazi+KqGhSEh0nu/z3nTggzOlXJ2GgCkr/+ehY5Zrr1TCRdYZlWnLalomvlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxp44wy/vkVOsA6JwbYdAYpKJJeRm9GLNLloxAuFrYk=;
 b=O0H0J+qnxbGHf3agN5wdSEkS0EZQ7bYhIK7heD1U5duJXukhld/784nNIT3fXCjQsYhLHbZTOxyeYZZNkT2kkZ4C2pz+wjjA0AWksk9ort2Rb5RpZZg0DAgtQtF+0nSF41vcRzAil+Jul0bQNxZ4gWn1S2zdcZ9nOpcPBv/qqZg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 29 Dec
 2021 03:22:49 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 03:22:49 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 2/5] net: dsa: felix: name change for clarity from pcs to mdio_device
Date:   Tue, 28 Dec 2021 19:22:34 -0800
Message-Id: <20211229032237.912649-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229032237.912649-1-colin.foster@in-advantage.com>
References: <20211229032237.912649-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:300:ae::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99fcc300-b96b-4ea1-0cc9-08d9ca7a7d99
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB552138119B12C57733C50EC6A4449@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YAFIXFbck6dkZ65pLgdguSyhqbALAVWmjIw6Aioq+QtUUkV7ayCN6zpZr3MBejwssn/kkLi+8udB9Ak3A1+uKcSRafHbdqpB/E+aQKkswunDXdASNN5B/X9uG1EECZ2CnLoZi48MLdNDrHlh100LJA40ToUruBK7qA8/rtZSTa4mki/t7eoUP/jQMCe8+QtDaHiouyPSB6dkcBftoSjp7rlqBbVUKfGEwC9UPaABfbkXsaSXK2pYh0m/yzWFC8hDVn7VvVN8F7chH5dOdhnKe/Po05LAH/UQyMk9HZSO/EAIcYIS+Vf4AjuVNWmYkRSZmCAig5NhmcATuK119dfdgC9wDBKGDE6BMpzIwIbCYqI/ma+i55BxhX00JjSnc4I3oINzUgzMx5RFCbxdc2dyntzPUxuzNAQwpzx0KJj+RNyfBwx5goLS/G4gOOPvA6xnkjy3KvURp83RyN5ZdrhFYjWf9Lsrk8v8PX+obAl4Bf67ohpYAX1+YtoK/QtcWOEGo9TA6FDzEMGyYQLIBTNRxIWHiNfUIHMZvacyJLWUYkVemVSsIUblwo6S+j5+XL2dT9beXEMMrshzB8Ab8lEWhYlV7LufKER2j+iStAlivP+xaWvxx0SJbJEGEjoks/muyiVtUWcr7DcBQqYqUtd3XRxOzTJ7mfkNQ7Ig1Sk8eyoGw6OowGJPVr2J50QbYtjzihAG4zVOuwiQGznJ4DkIdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(42606007)(376002)(396003)(366004)(39830400003)(6666004)(316002)(66946007)(186003)(8676002)(4326008)(2616005)(2906002)(6512007)(44832011)(83380400001)(26005)(6506007)(508600001)(1076003)(86362001)(54906003)(5660300002)(8936002)(38100700002)(38350700002)(52116002)(66556008)(66476007)(6486002)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ByCsJWLCv75YLcpZhNhpOsCmATOds6OyzQ4jiLRTA6fym4iJppPA9+rJ2jOd?=
 =?us-ascii?Q?ZjCplS2SFBjH0uhP/pmpF3oYTtY63Bl6RfJcOeIqTZCOTY7nW2l3dqFpuX/t?=
 =?us-ascii?Q?ifGACiUw6zxvBv2mrCHGVp+JD7vLiocnqdIvoq1myRylSfXbC78CDvh4UlCh?=
 =?us-ascii?Q?sKpwvcHprHyPe1cqkfM9J9Ha7r7RdscYkwaFMGn90ZAvDLT+6eyHW0GA/f1H?=
 =?us-ascii?Q?uZT2Iu6PyRKO09PwREBlmLQ03MRnnSSp1uJ8TGPhcUU/ZqxNQZPatfSOmiFX?=
 =?us-ascii?Q?IXdZwX9lMo80Vrtb/2ML4F+jjToMy1f4cygaBhdiNQ3Xw6tvHVVQ/TmyBNzC?=
 =?us-ascii?Q?FAJvP0JIfWsdzpn+ArfaC6aVzAXhDh61P3sNwgXpZWrAVQOEwmeHWNs9m9Bi?=
 =?us-ascii?Q?PHCs46LaJqCm1qiPvC+2jbbLykbS3LCvhdQLfeGsv8dykhMo9GG4l294Rc+l?=
 =?us-ascii?Q?+/QOLwau+UsQ2uf4FxC/P/V+WovUMBYsoaXJSPz+94G4IPlM7ioUqPLo4jKt?=
 =?us-ascii?Q?0ObkLrW/ykh4hEo38IwCfFThiRf1WOqFBTD0nUueH1rzx0fuUClJLWLRZJ2X?=
 =?us-ascii?Q?jMr+xHYa5P6dS/E/dgIQTxObpp4sywaMdWRmKOm6VFyPPEMijfjLA2U65QS7?=
 =?us-ascii?Q?wmCUQjwcYqMbLzVY5DmhNyWj+lZ9UJRLkBO6NqJpFF/gHtf9J691bJ0aToSM?=
 =?us-ascii?Q?oyrU84KeIaFGosTJ72rZg/q17nVcnKNwoy8+DTyC/8WsW37Ufj9614b9bazN?=
 =?us-ascii?Q?RFe+S+g2tKuFFrYnz5SmOKEbhMb5aPpTWrYQqrw+02VOeHtwqPfRa+DG6Uzh?=
 =?us-ascii?Q?YK6FiLG8VGTwjL9RUyRdzsM8KmzvxfcVUqk1E4sL9x7QWZYLsGe5g05J8gLc?=
 =?us-ascii?Q?KQk7taT1IJNsGE+Ae2xy4d8PEtEdHqvcRSVb/Oft19Kk0L5DHRmx+db9fpUe?=
 =?us-ascii?Q?jcccsCnHZ2G+EQHMUcWc2ExxAC+FyQEaiKQRgkZptzmEjfGqzLqi6QQVV/JJ?=
 =?us-ascii?Q?1kj/1MOaRWmt0SLqKuwhUnKfJgkR/ScYojfC6xIAa7o5sTDolmCENo+krhhu?=
 =?us-ascii?Q?u+hAikrf2il4nlD2zXC/XNqi9ycbjdglPotrG/KiZvE17SGuSjpIRfzZ8Q1A?=
 =?us-ascii?Q?M5CGl6K5O6bHYYX0bcbbgclag9IodqJghz8MzT2mpoYdVn+DiMC2u20nG3XQ?=
 =?us-ascii?Q?Ck6lcnOOnpmZNQ26T/UOE8hFCJsybHUeJNh2vjYTHR2H5n6vJbEC8fFcQ/LU?=
 =?us-ascii?Q?1stsXveYon2E3uh/z3yVp+DwIXnumwbjgbCD7zlG8l6i23cVACPjNZtLsbpI?=
 =?us-ascii?Q?P8q6IQoxLRNaym+5muEP5TJL/9+oSx95FZmVB0L6z03NRpUhpvvtG9yyS1uc?=
 =?us-ascii?Q?wQKlzT82bz30O0rdp3zha4VfT9/O3A0eNXAU3tGjD8CVwDw/hx7DQfiAVgm2?=
 =?us-ascii?Q?M1eXAfErsT5tCqOnUJSsDIa/ucvRqcwaGd9f6uoOyCeEAEjWGH06yi2awM+0?=
 =?us-ascii?Q?9eOm7UyeQBw2s+vzSqn7ILF+HTO3Xp7FtWqEu1AbWrqYsXmNXTEq/fEStZjs?=
 =?us-ascii?Q?hFnsGyoiKzLjZxz5ghNgF/z5ljxnlRJm5/aJopLBUmHvUvyDaSa6KcjZXmxa?=
 =?us-ascii?Q?Rmth8PoxbKV9ZUKcxv1seiYxBsbYkKB+cjzs2TMGUjGD1fpE6O6Cnpt/hVUE?=
 =?us-ascii?Q?iQOWVw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99fcc300-b96b-4ea1-0cc9-08d9ca7a7d99
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 03:22:49.2888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /FZxmWt4rGolOibAweo2MKd9xYRIG+pTbWEwfq0jprqmtP7iR6BwlgVz2nIu1P9VR0JlPTkJ085/4qV9BSv1XxgJmZ6vC/8QLNGq0ISzzd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple rename of a variable to make things more logical.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 93ad1d65e212..bf8d38239e7e 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1089,7 +1089,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *pcs;
+		struct mdio_device *mdio_device;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1097,13 +1097,13 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		pcs = mdio_device_create(felix->imdio, port);
-		if (IS_ERR(pcs))
+		mdio_device = mdio_device_create(felix->imdio, port);
+		if (IS_ERR(mdio_device))
 			continue;
 
-		phylink_pcs = lynx_pcs_create(pcs);
+		phylink_pcs = lynx_pcs_create(mdio_device);
 		if (!phylink_pcs) {
-			mdio_device_free(pcs);
+			mdio_device_free(mdio_device);
 			continue;
 		}
 
-- 
2.25.1

