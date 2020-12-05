Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD712CFE3E
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgLETVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:21:45 -0500
Received: from mail-am6eur05on2134.outbound.protection.outlook.com ([40.107.22.134]:19809
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727218AbgLETUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:20:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsnDaHGkk/uyCsHZkLCLqCXbPhTmBHVjyI//amBS+8UJAZnyjVW88Jdjcxfm0wf7bWRPTWwvDpXYkMuCkhPuXyHkmWYNspvBN/gZM7S1enYzOn9NQAj3CE1zyv8kRJEEfHY0EFNE8uzcA3OHsaPrLzvNIiYX7rC4GWrpWYsvhaUb68JQ1PrCJkEyvb2hjLrAoRlgMpCRnpJoXkQzuq0P/pfqs2RcO3iljtVWuAcIMstaSNzYo6bEf4VQ5x/GfuFv0bs096zmqxKdyedlmdsnQk6UTfYEDSDrLmaXqHPogA0TuBAmcF7HlcETWUYceJABlnxR6CUvy/FuuqA9RqWA4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXkO9S05fdZQNu+ImhLzBsKq4426rJzgFtggpGQd9b0=;
 b=DC/tD+2UVFkELgstrjB23yfpGlhomMpgq+k//SsAaPTD1HuGaZnvhVFUdqVwW/ctAJcxiv6a2BmBxAbJpFkRSnGDaBQqstogmRuYEuh7Ygo3Uylmkfp3DluSw8zyOjYdQTCnvKboMv1GH2PtyVvZ+oEX7s3inRqMdDhvwJ8hzT1RdToM06TxF5Lvn90yho/wvzRL4YlGuNGgV2yhMycX44uWCLzOfsilvY0/y939glv3iTVjR9+3GELGGaYvxcqW6ugd3wCpuPGQvoYPM5z6EqahqcVJcRLWJNtbQSSJjC2iwabsBldeZRx5voDe6mOchzN+8ubQ8JTeSlaBuFGWJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXkO9S05fdZQNu+ImhLzBsKq4426rJzgFtggpGQd9b0=;
 b=OaFZcpP8mbW1MvUQ5HqhFmEwxqPYPMgb8u4qhHqRzJFzu/Zr64web5KR6ZRFeD+A8kqVyiGsusVrv7tsbjxiaWT+rWcFMTvc4pThB2CzDK54G1Z99AVYy26UYYohLQLFJ0dNhBWBmMPusRyPjRTeHxklAeesTgunFXdPY87XwMk=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:29 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:29 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/20] ethernet: ucc_geth: don't statically allocate eight ucc_geth_info
Date:   Sat,  5 Dec 2020 20:17:37 +0100
Message-Id: <20201205191744.7847-15-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee0a046b-c2ae-45fb-faf0-08d899528c02
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1363552B820DDB60E2F6EC5E93F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hBMw0SbJYBOesXgOtW/bLmW6wYsXQZAo9nCcpKHIwpj0c4g3FNPhUFTJY21n+FWPSSVSbOlweRIgObFX8DDo8vSmrhizm3n87QNE/YlR7m8gH1kHXtjT7AguHCQu3x2DwqiK3oPej8lXD9NLcQr3DDa1+EX7sbjSzLAhqFX+ERRv//8FbozCJrXEUAtdWZu6CseynbzNflHh8nCCiCZn9pYlXGR8ypIUBwcG/gzBZlwUQ1V5jiyIYhmKKulCOHfYnZ+sQhybcWmtm3Wcyd09ymheaN//jE/ClRxk6r50wHP0xH49N0FPd7SWZeluL+lu/OWm+XybMA45gRp4uHlQ3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?32UppUUv6iz/0ReSezwEkLNuWXsmyqmAUUneYmNKZDbSa47d8CGwBeMrzQRJ?=
 =?us-ascii?Q?nMgDNazAp/0tHQFBmU5Tcm82kctbXsB69VEzSko9Y4pew8W9+EcJLOeJLKK2?=
 =?us-ascii?Q?wi7uXpZka3I2svOh4MbJIGZmzyjdE6/YsYFq5EgFtMktsIvMLRnm6eL9d1V2?=
 =?us-ascii?Q?1ctc9fRjTWn9h4SRsSnKLe+pu7IWeksx6862EipblC91oyTatgIu6ozaXsy5?=
 =?us-ascii?Q?q6yDXxzftdDcpzLHTnzFF3FWT1wUKXuqB5G5f9Jsbq/bKPmvX0QlUs3C3GGA?=
 =?us-ascii?Q?V+WYVWphvzZH2fHdrOFrNUZlTVj1wwriBxYGwBn3+DkevK1WlgCVSnHJfRty?=
 =?us-ascii?Q?7QvkPTABZQCcV+hz1lRDHKrouQoBt+HMutD7jgwrnjKQJcLRJCds9R3cFGsV?=
 =?us-ascii?Q?T06kdMSJwg6CiWNe6Oc+bHgvTDKH9vitmwt0JKqX01qtY1Q/uzD4+kX6hLAx?=
 =?us-ascii?Q?VWZl3fcGF0BivJ29Ugoq9YPplWu3ykGKgAth8jb6ub1oP7cX/YMASp5gquRu?=
 =?us-ascii?Q?XjgsFHNfBS8TujvWcGcSslfiP9woSGKB3Ho3E0sow2bVZUoHcBdCkEpF1tOf?=
 =?us-ascii?Q?wP1ndD5DN8dZDRv7pJ6mlupnGpt6vNIExotMhgF2mYRJKuO7rb185PQuZK2y?=
 =?us-ascii?Q?wCR2Yom5VtsqFnDy9N8vh+3rfOcaRV6gyOi0zB5dWYh5WMo9ttjMyD7Z134V?=
 =?us-ascii?Q?40qAMKruD97JXV4hDRxTxB3XNrmZ9t/Pz9ybnSthXr0UCGkORsAZexwmL6Om?=
 =?us-ascii?Q?ICWqucwaSc1+zWN4UpzOHZ5J01WIGRr/lVHP31tuQjNsoPLk/MkvsLvNxnxo?=
 =?us-ascii?Q?1AxpPA60rfxn3hUQuhMIEkO86rb8JkEAvt7Cg7+PuiqDEmK5XdVZ6JfKIeFn?=
 =?us-ascii?Q?Pqx3uQY+wnRQuBd1K61E4VpQUZjy6SDVDdS5iuWW3LwzFLrmMEnOZvRSQQpV?=
 =?us-ascii?Q?d8jGTc+H8jVFnHe5LTkf5KjzOEuCq+UJhmmjOOD+ZxwBJCEPCl2dhlhDf7ol?=
 =?us-ascii?Q?Tn7I?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0a046b-c2ae-45fb-faf0-08d899528c02
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:28.9488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HkyEaClC2PalthrLqJGbGU79xJKOylbVHpUsGTNciY+fx6IEi/fLGSenbmO32M1XctFpnikkIPNl3LV9SRqCmzOiJKPNsx/gINfiOniLZD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ucc_geth_info is somewhat large, and on systems with only one
or two UCC instances, that just wastes a few KB of memory. So
allocate and populate a chunk of memory at probe time instead of
initializing them all during driver init.

Note that the existing "ug_info == NULL" check was dead code, as the
address of some static array element can obviously never be NULL.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 32 +++++++++--------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index a06744d8b4af..273342233bba 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -157,8 +157,6 @@ static const struct ucc_geth_info ugeth_primary_info = {
 	.riscRx = QE_RISC_ALLOCATION_RISC1_AND_RISC2,
 };
 
-static struct ucc_geth_info ugeth_info[8];
-
 #ifdef DEBUG
 static void mem_disp(u8 *addr, int size)
 {
@@ -3714,25 +3712,23 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	if ((ucc_num < 0) || (ucc_num > 7))
 		return -ENODEV;
 
-	ug_info = &ugeth_info[ucc_num];
-	if (ug_info == NULL) {
-		if (netif_msg_probe(&debug))
-			pr_err("[%d] Missing additional data!\n", ucc_num);
-		return -ENODEV;
-	}
+	ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
+	if (ug_info == NULL)
+		return -ENOMEM;
+	memcpy(ug_info, &ugeth_primary_info, sizeof(*ug_info));
 
 	ug_info->uf_info.ucc_num = ucc_num;
 
 	err = ucc_geth_parse_clock(np, "rx", &ug_info->uf_info.rx_clock);
 	if (err)
-		return err;
+		goto err_free_info;
 	err = ucc_geth_parse_clock(np, "tx", &ug_info->uf_info.tx_clock);
 	if (err)
-		return err;
+		goto err_free_info;
 
 	err = of_address_to_resource(np, 0, &res);
 	if (err)
-		return -EINVAL;
+		goto err_free_info;
 
 	ug_info->uf_info.regs = res.start;
 	ug_info->uf_info.irq = irq_of_parse_and_map(np, 0);
@@ -3745,7 +3741,7 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 		 */
 		err = of_phy_register_fixed_link(np);
 		if (err)
-			return err;
+			goto err_free_info;
 		ug_info->phy_node = of_node_get(np);
 	}
 
@@ -3876,6 +3872,8 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 		of_phy_deregister_fixed_link(np);
 	of_node_put(ug_info->tbi_node);
 	of_node_put(ug_info->phy_node);
+err_free_info:
+	kfree(ug_info);
 
 	return err;
 }
@@ -3886,6 +3884,7 @@ static int ucc_geth_remove(struct platform_device* ofdev)
 	struct ucc_geth_private *ugeth = netdev_priv(dev);
 	struct device_node *np = ofdev->dev.of_node;
 
+	kfree(ugeth->ug_info);
 	ucc_geth_memclean(ugeth);
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
@@ -3920,17 +3919,10 @@ static struct platform_driver ucc_geth_driver = {
 
 static int __init ucc_geth_init(void)
 {
-	int i, ret;
-
 	if (netif_msg_drv(&debug))
 		pr_info(DRV_DESC "\n");
-	for (i = 0; i < 8; i++)
-		memcpy(&(ugeth_info[i]), &ugeth_primary_info,
-		       sizeof(ugeth_primary_info));
-
-	ret = platform_driver_register(&ucc_geth_driver);
 
-	return ret;
+	return platform_driver_register(&ucc_geth_driver);
 }
 
 static void __exit ucc_geth_exit(void)
-- 
2.23.0

