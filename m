Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6EA3105D2
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 08:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhBEH1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 02:27:46 -0500
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:19777
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231473AbhBEH1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 02:27:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOdfVQi2Ht0qZQ5JsUYz8JzWFB9B8pmkeccEWpG3gH+kuVIqsCv4Gra8Kqb2Hw67pFuAjzz6jP69L0GAq+40mGhJX0hR+8VY/ZXYeS8a0foA7fzkjKHxXiwqU9RZzx0Vyy+aYyClndIULDr13AnRUmofFm4t0CyCRHQYGESeTZR47OFYbZjoYuRKHob9MR4Cko2SddsxWNz6iNj0ULefoEXsuV6CgSjJK+XYit1B9rPJGdE7C0EoONGhem6b5C34O1MJY97D9C0zZ4P5zjB8UpnTMM30jahmQ/Y5+/awwJBeq7MicnhGBSh1G+A4F85uLklbt6lA+Fwr3hJYT3KzdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjuQOMZknOJIP0QZgyTbkrIzXG5G1+uiTeM7XtJMPUM=;
 b=IPBNGlnS/V4xpTpHTX06a4+PtQ/sLX3axg+LE45EDLwcCg0S4zMdkggJidu5juHdWA3sceG8eEUu84dlICuPJohFYG6aWqdRL8nFDi3Hx193n5sll2fXvPqATVmk4nH5drZkgPDGjuvzJ/T8oKwUfzC3Uux8TzMOUTB3l5vnx5CjfYq/A+GZ/0hL6SmZgpvw2d4YbGYb0h2M8rIT6n4J4ql4H+fPpeYs3UcBKJPXf3lkWFYKbQuOlmsP6hCbgp6J+bqNLbinaPISe7kOz7HRf4evJlqjgDtOPagZVn+gK8g9YY4yY96OvSfCIT7S1ce+WWzhhtkVIjzy1sN87yCHGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjuQOMZknOJIP0QZgyTbkrIzXG5G1+uiTeM7XtJMPUM=;
 b=My+nX6SWFmBdre19IT1rJ+Ey088Eq7zmXhNHDEL3BWrILkubVoXdFyo+BfC+JCHtkdTkUYpekFyDjz4xIvplHXyBEahGnr3ovZrBqvKeKklLTm2W7OSi1p5NhMN08+q9GqPlVL1FcHEXre2Ax6AWGO8lxGOjsXF4ZxMOjcAKsRU=
Authentication-Results: grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=none action=none
 header.from=windriver.com;
Received: from DM5PR11MB1898.namprd11.prod.outlook.com (2603:10b6:3:114::10)
 by DM6PR11MB3627.namprd11.prod.outlook.com (2603:10b6:5:13b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Fri, 5 Feb
 2021 07:26:25 +0000
Received: from DM5PR11MB1898.namprd11.prod.outlook.com
 ([fe80::d4c5:af6f:ddff:a34d]) by DM5PR11MB1898.namprd11.prod.outlook.com
 ([fe80::d4c5:af6f:ddff:a34d%8]) with mapi id 15.20.3825.024; Fri, 5 Feb 2021
 07:26:25 +0000
From:   Xulin Sun <xulin.sun@windriver.com>
To:     wg@grandegger.com, mkl@pengutronix.de
Cc:     dmurphy@ti.com, sriram.dash@samsung.com, kuba@kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xulin.sun@windriver.com, xulinsun@gmail.com
Subject: [PATCH 1/2] can: m_can: m_can_plat_probe(): free can_net device in case probe fails
Date:   Fri,  5 Feb 2021 15:25:58 +0800
Message-Id: <20210205072559.13241-1-xulin.sun@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK0PR03CA0116.apcprd03.prod.outlook.com
 (2603:1096:203:b0::32) To DM5PR11MB1898.namprd11.prod.outlook.com
 (2603:10b6:3:114::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp4.wrs.com (60.247.85.82) by HK0PR03CA0116.apcprd03.prod.outlook.com (2603:1096:203:b0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23 via Frontend Transport; Fri, 5 Feb 2021 07:26:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 942d84b1-048f-41b4-f2f5-08d8c9a75758
X-MS-TrafficTypeDiagnostic: DM6PR11MB3627:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB3627E3479C71385B2F00CE2EFBB29@DM6PR11MB3627.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jclN92PJSoowiiFZDxuieFG1YLJQLUFCDeo5ZtkZJ52UzyYMvgju1X2HoHKXz1nV9sM6W0A/F1xWEMI5dyIM6MwocVxwo54XF1caJ2Dd+iHiu8hP0HfXmY2643z/SuuqVPEvYU9lssGRtcFKdEu23pgbl4iNUDVCPpEs1KmRjQWpNhPKC4itx89/CHFPy0IT8v1g8s4G6VZb5k07MrpjRBTeNVy2KA3gULT4gWXPIMzim7vJDpIwloHrkwACY/O+rnjoxfJuB1hjOn+iTOjZ8j0QtxoM8f0xCzKAV8DhFIVq0hc6N56UyNqfj6dhUojXduo/W80ZfL6M33Jn7OPd6PocEJ4CdemznqmlIPZOGaksJTLo5lZrzYBZ2lhzq3eCNcLz+RJ5IaC+XpjnFd/IEbIUhA0TltvZ3dZ6t6gkHgxSimJSZt5kGBF1ceTvsSyabXQohV7Orh9d9lYRP+1/uWYXj+QW0vni5P31GAhxcqa51c2sgcjTnSrekM20O0mhjGcGEmt6GMi7rCBKCV0/rY2vqC8XDs1q+3Fewiyf/2W6N5BFCeuPUF4Z58Spj9jkBIbcw2hiKFuQkv2jFAAr2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1898.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(39850400004)(396003)(316002)(956004)(2616005)(16526019)(186003)(8676002)(5660300002)(66946007)(66556008)(66476007)(6666004)(52116002)(44832011)(7416002)(36756003)(83380400001)(6486002)(2906002)(4326008)(8936002)(6512007)(86362001)(6506007)(478600001)(1076003)(26005)(505234006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cWyb11B47aHN6VbIcZvuzkE2LoucnjBCXBY8XEwKp4IJCIUspSfwQ38mRyTK?=
 =?us-ascii?Q?8X1pqBk5HZ17zbIXbB8PlYOvjMuEvaHXf8hxpj48Jg+UutBh0sPQaGlptF9w?=
 =?us-ascii?Q?n5nrgUlviOWSMLx5NNexFol5lOpk+RjjhSTkI/yzBgdB/2oY0wN/I2GjPRRq?=
 =?us-ascii?Q?qZTVqxYF0sv6ghsHch50YapcpCtLanuq8qrXUomMN8NoWE0/U+Y7dVM4cqQj?=
 =?us-ascii?Q?y5kmDjXr4wd4gR/XqaR3jDRfG1DucoP0GCczC1TzsB0hNbGCg5mTXlrOjrdL?=
 =?us-ascii?Q?qh73yBJtS1eZVbdJAhOcq14loMQIdr8q6wGnjV+tNf6ZgGMkrR4iSqvRDR3k?=
 =?us-ascii?Q?rTkd4jJTa+XeDOVFN+h4zuhqjNqPaMn7hGfskfPgg2Zb4GYcK4FuOMDSPh3u?=
 =?us-ascii?Q?beBlmoyr7GbOLK7yIHJkOeTB9CQ6KnnUSo2On1bNDSpbXZntVgwIlvnRHFnn?=
 =?us-ascii?Q?dtgE4BweOlg7Fq7Y0NhII9lhMhIfMPUhESVOHKQtFlRNiJZzuQ+2Ga3OqnuX?=
 =?us-ascii?Q?vphYzxU4XGTPu3nOi8+EMQ4FdIpd0nIr4xGt2Ql4ERZ0Vy3ynb1fxTuFvL+e?=
 =?us-ascii?Q?XZ7RIw0pTZi66n5ylYh2ZU0iAuOO8JU/BikX6IWMUhJ2AdSHw7anQe2GKX1w?=
 =?us-ascii?Q?8xha+DvSTfy3ABz3PJmPjeZz8V+Kp5JJsU7Mvc0rq2LdkbW24loVFxFKDGfP?=
 =?us-ascii?Q?qyYC4ApWQwJH4p0mn3deOTD+noIdW13e0Hy9xKYHUmWuowSv0UT5MMkoYn72?=
 =?us-ascii?Q?nH/TnOgKf26qGNLtuG8HCEj1pqE2pe7SNaT0p/aqzUsnnenZqEmEBggiUP/U?=
 =?us-ascii?Q?uMw314DdlRW6W+jITxlj2JI0AegLVrtmWFAoLoLopfQ6Y5Nr20QFDwlwbQ9R?=
 =?us-ascii?Q?W25qoyf2eFrZzDfFOonItKPBF7Rab9hZI7pounHDXrzI6CweSM8IRvz98wZd?=
 =?us-ascii?Q?DT8ZE+5BI1DpDVa+f18QZMByIizC2znoISaOzpxki1atb6w3SiSd0hssUPES?=
 =?us-ascii?Q?ObzHYWMBKbEsoIlBZVrr8J3lKFxPhS1JB4wBF/v7LnR0p/2TSMhAitHf8tj3?=
 =?us-ascii?Q?rZBDwOBq7Owvfol+NiC7Cxmbq/NIFILQnIn/tvLtxseHzoQlCbY5RFIVDHjg?=
 =?us-ascii?Q?kyZ7Vl4mnnPghAeVT9UvIiP2ZvW5iMMqP6qnnotMOpEVjNAwxfPvErOrud9t?=
 =?us-ascii?Q?oEbbxbjY+2qvzvS+yvi3WIeGUjb5GlQdbzRCXl7PIVM5jgO3bvRln8vQ5z+u?=
 =?us-ascii?Q?ycy/+GdTDyXvqOzEXUAHCbeJWOzhI38Y+U+Mt5FUpm+18Q5MxoIWwuIQa+M9?=
 =?us-ascii?Q?v5EbUsMTVtK8Tar+dmSC9Egg?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 942d84b1-048f-41b4-f2f5-08d8c9a75758
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1898.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 07:26:25.2036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pjqu6VuyTRigtTd+UUctiX5Zb/7jFra9ZhD3//7d1tb0E5M76/lYR3OQSil0hIJnRg5ZxwDX7sU83u6Z7Mn9PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3627
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The can_net device is allocated through kvzalloc(), if the subsequent probe
cases fail to initialize, it should free the can_net device that has been
successfully allocated before.

To fix below memory leaks call trace:

unreferenced object 0xfffffc08418b0000 (size 32768):
comm "kworker/0:1", pid 22, jiffies 4294893966 (age 931.976s)
hex dump (first 32 bytes):
63 61 6e 25 64 00 00 00 00 00 00 00 00 00 00 00 can%d...........
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<000000003faec9cc>] __kmalloc+0x1a4/0x3e0
[<00000000560b1cad>] kvmalloc_node+0xa0/0xb0
[<0000000093bada32>] alloc_netdev_mqs+0x60/0x380
[<0000000041ddbb53>] alloc_candev_mqs+0x6c/0x14c
[<00000000d08c7529>] m_can_class_allocate_dev+0x64/0x18c
[<000000009fef1617>] m_can_plat_probe+0x2c/0x1f4
[<000000006fdcc497>] platform_drv_probe+0x5c/0xb0
[<00000000fd0f0726>] really_probe+0xec/0x41c
[<000000003ffa5158>] driver_probe_device+0x60/0xf0
[<000000005986c77e>] __device_attach_driver+0xb0/0x100
[<00000000757823bc>] bus_for_each_drv+0x8c/0xe0
[<0000000059253919>] __device_attach+0xdc/0x180
[<0000000035c2b9f1>] device_initial_probe+0x28/0x34
[<0000000082e2c85c>] bus_probe_device+0xa4/0xb0
[<00000000cc6181c3>] deferred_probe_work_func+0x7c/0xb0
[<0000000001b85f22>] process_one_work+0x1ec/0x480

Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
---
 drivers/net/can/m_can/m_can_platform.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 38ea5e600fb8..0a2655c94018 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -67,8 +67,10 @@ static int m_can_plat_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		ret = -ENOMEM;
+		goto failed_ret;
+	}
 
 	mcan_class->device_data = priv;
 
@@ -113,7 +115,11 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	ret = m_can_class_register(mcan_class);
 
+	return ret;
+
 failed_ret:
+	free_candev(mcan_class->net);
+
 	return ret;
 }
 
-- 
2.17.1

