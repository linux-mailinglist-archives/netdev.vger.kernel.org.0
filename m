Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673BD37B43C
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 04:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhELCpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 22:45:24 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:55840
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230018AbhELCpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 22:45:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErJS1LOAgZZGbLUTF4x8uaZmZjSrpFdtpnArRgUCnWMd3C96eZIr+rHGF+N9/yaFUY+ah8Fbk4OLhStfRC74aH+OnBPfo2b/aou5V3GQ/rZMBr57lnrqDz83n9jzqjDbVTx+EwlsDBbFk6KoxV4JV8KlN9lK6A9UiDcjQFLXTiUNAJnyDIZ+24f+nZ3N2KWZ43BIO2QCJJYUUS9VIFwyA8oawrRlyEdGNbdgB5cNeUamzrpVp6a+BH2PwjmOmuTeLK7myCuOv8ZBr4vPua8mbahyp+qMh51wq3K/+KmsHA+yJknNKzQELh5DCWNtGbdhOBBKR2X4s7NryZXm7pqDvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhSeP2cChvGtWVl74QmYeG22iZnS3tLE0zWJn2t4SBE=;
 b=R3MmRzrJl2kWlWdYoVJR476ipRUmHYAx97ed9tnVMMXINacmjyRPXyMw9wq1fm3Ub7YHRF5ztcoaSD7ZxScNED9kCUMn5kX0ZZd4141+hYxQcO5AncRDlDt55M8cteFGJrvvkKlenlau12lNF9vZZQaVv1//eBJz2pCXjfod56SozwZtGFf3Cw4GunOVOkDljMafjDvsG48mUM1gE8tXSrqnhlEo46jdq20lqu4X1gsObHwRicYQzhDdxUZNJNlqpaUVZ5bXgth3BnmaL3oZoHR0ty76gKfXnk/cHpqmE24ViEULuyxMnZRDMrJFrwMm8tAWikNFpILhl9ceGvBIBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhSeP2cChvGtWVl74QmYeG22iZnS3tLE0zWJn2t4SBE=;
 b=kkyjQlOdUHe5Kcp/QnSEhRjvu+0DwQxEV8VMWKflu+jzc4TsFMdul7AtR5Psrv7s0y+IIxbv/nfjdAS6SfLy05B4RTUjBP/B0/yMyjBMs5IJxpDa9PDy8sqLJroCjGZKdNebqwGYzEyiPWCG46bYd6+n0GonGHaV0MG9llOSz3E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5884.eurprd04.prod.outlook.com (2603:10a6:10:b0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 12 May
 2021 02:44:11 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4129.025; Wed, 12 May 2021
 02:44:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net: fec: fix the potential memory leak in fec_enet_init()
Date:   Wed, 12 May 2021 10:43:59 +0800
Message-Id: <20210512024400.19041-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512024400.19041-1-qiangqing.zhang@nxp.com>
References: <20210512024400.19041-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0095.apcprd03.prod.outlook.com
 (2603:1096:4:7c::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0095.apcprd03.prod.outlook.com (2603:1096:4:7c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Wed, 12 May 2021 02:44:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e6b4e68-957f-4352-fcef-08d914efd2c7
X-MS-TrafficTypeDiagnostic: DB8PR04MB5884:
X-Microsoft-Antispam-PRVS: <DB8PR04MB5884E27C00176EC50C7FDABCE6529@DB8PR04MB5884.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:486;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8GJlK8hTZardI8hBoicwxo0UqxVWcBzP8qfp7CiHANfK2UMmh4IiGYcKUvj6ggUwHMWOdhOuS5sPlQ1V60+8TYlFgRFK+OsDNy9eCFCIB2MjzwC6fzWTBwrgYpITBBni70ui95+84JByHaVBtDIkxwgwnJVPHDO5EZFBuDe/PIa2/p3fovfl03xjvgQ2uZ6Bd1Ltrx6C1rUpaUXj0gYe/Qy5CO2Jz48k96J0MdLrkEhGqXYu7IXAAsbrwL+QOcAxAio1GOIbZ6YLC1oh14KRiOzuMc/ATAdLa8a6KJCp2eCvrzSonDQpdMvPlBM2T9ZsTp5+9qqyDch8/hnOTviRY5LQbRscSUrfGV0XHFLN45ITtqPrfOSzbN2ECFRSWEzkdbzcaGjuPOXQ6ouGzhT5oZN0j69m9dg/qxl3MIGx5uHjX8wcN+frxHSd4t2vAnogpOcBAajvn6+BmDlhm4uKytzUfvFQrDaJb9MqW6XE0/T1DLfkHi5D+V9SSsv9g+/2OW24zRURFKAhvRoa/0R8HgmiF2W9yzyLhyutzmfj8YJaPwILJ2uEVEbQh8/j7euepqvwzXXyZ2jmWjUVRpRlzemOROudju6D/7A0gbjzz9wK1fZAlgcz+FMHCUCjTqnxgOVsWerCdDRS/5vbrwGfgAltktN47lcz4DEWZI0SqvoiVfcJ/HPdaPhVRF0eWeTy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(478600001)(2616005)(52116002)(8936002)(5660300002)(86362001)(956004)(4326008)(66476007)(66556008)(8676002)(66946007)(6666004)(1076003)(83380400001)(6486002)(186003)(6512007)(16526019)(6506007)(26005)(316002)(36756003)(2906002)(38350700002)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4U0ASPBBYUx3pz0rk4kl5IUEJ1i36oiIaXN12Ay07NRTM0xLfGIKvQ6AkNjT?=
 =?us-ascii?Q?z5GpknFY1Q8Y8Yv8fk8v35ZPRiVQgWTQlZXAQCN8gOt/VF8VkMn8G0Ofx9U8?=
 =?us-ascii?Q?E7qznsFDX0KlWW7RAX1uO623jN5rbhos+7zb2FVUa5qE2DxiSScLNruP4jpS?=
 =?us-ascii?Q?CL2kmqLFfvSImHt356FXCd6W9vo5H5AlK8O76Mezv8aovJzetnyjV5hdv6mR?=
 =?us-ascii?Q?rDWWBYVPeg9eGOkcYh9jFh6ZDtXEWBRMVU/wyBPJE6C2TagNRSi3fzrb/ggK?=
 =?us-ascii?Q?k0pxYHxfhYYzhHpjiceMkr36J9nltD4gjdqu0V4T8jkaJBu4iaundgicBlqw?=
 =?us-ascii?Q?0HAbSKkpVLhqrv6lIAFJKqjo4BJn5kJvYS3pGGHQUNMec727KnkOpJdasJf+?=
 =?us-ascii?Q?Yqu3qSWf10EnoWNM6Q1SDi4Km0z1Zgl7HNWBjfIn7lyUZ9pqKpNDMmhAEb1t?=
 =?us-ascii?Q?DhEQOItr8eMj4W8agpTsfrY2c0Qyr7Kp9fO2qVVs3jJT0H9RjiBN0Qmb2GM5?=
 =?us-ascii?Q?AeF/+6aCirC987y7di5QfAhGl8QgCuLsjHYyAUJPTR2JPNvRI4alrdoHbj3G?=
 =?us-ascii?Q?9evzI0uBJ5S+QGcCpFQ6xpOQvDmK7sLGJj37tjx8A978Ft+tjovpOjFKpbuI?=
 =?us-ascii?Q?EwRve6c9EF6cScicRMfWLw559Fd0T9kvbP4wNB+uUyzXMHfcEIYtzeSwhcy9?=
 =?us-ascii?Q?wafUZqoC+Wv3CJCW3zwSfCiIMn4QaoSvkJDDkI8si6baLIICx9jbIasE7gt6?=
 =?us-ascii?Q?rmYGw2HwAxJZRMyktprY+UCpwN7yei9PCqsqpvM0f0Tsigg+vjE/PBcbepOq?=
 =?us-ascii?Q?T4XrCD4B7RdlV723iqAixFLcj9+QUeVoAPCWn2lXq0xW/ei9mzPFo/s3lTBm?=
 =?us-ascii?Q?K7UvMW380HkwvThPxiWPiPM2uB9Y+kcJQbKlO3GfvYagKPIWKe/M8RoWrP50?=
 =?us-ascii?Q?s+XTNSE+8nyERonjJX/Yw+73ObJM+SC4UL91/cHIdd4VElr+g7+8w9ZmocfR?=
 =?us-ascii?Q?sDH/UgtI6mphHcFs6VAQcCGE4BtFv2tgVy9h5Qvvdn5DV9NOJV6fd27T03gK?=
 =?us-ascii?Q?+OrjCJbLRsbF04oKeKZmnfsoN+U24R4+JpF30SgOqxDloN75A3e2ehwvtyoT?=
 =?us-ascii?Q?i6wORGVVvdoYsOFOhhTH79KGetRfYWA99t6mNXXxef7jy/oeJDih4x0VWp9b?=
 =?us-ascii?Q?OR1DoBEg5JNJWIjUDMkL8JZDJRzMiux9g5drrIogYfwFIqvrgAq8yvHzB5ko?=
 =?us-ascii?Q?ofJBQvQvnjiBV26X2gSZC53+J+ZjC04pS1/rQHWO9r2AwXzW84IMND6rkq7Z?=
 =?us-ascii?Q?CNG6+A/tiO7jhDGPgOjyKgkc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6b4e68-957f-4352-fcef-08d914efd2c7
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 02:44:11.8454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2nNg6yMA9cVqYOCugQ4VLMMPyrVjCCfUPaXTuFnzv4fWVrJlFLpfOuNuKaboMHcE5b03PAuJs3M/FszMPNWY8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

If the memory allocated for cbd_base is failed, it should
free the memory allocated for the queues, otherwise it causes
memory leak.

And if the memory allocated for the queues is failed, it can
return error directly.

Fixes: 59d0f7465644 ("net: fec: init multi queue date structure")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f2065f9d02e6..a2ada39c22d7 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3290,7 +3290,9 @@ static int fec_enet_init(struct net_device *ndev)
 		return ret;
 	}
 
-	fec_enet_alloc_queue(ndev);
+	ret = fec_enet_alloc_queue(ndev);
+	if (ret)
+		return ret;
 
 	bd_size = (fep->total_tx_ring_size + fep->total_rx_ring_size) * dsize;
 
@@ -3298,7 +3300,8 @@ static int fec_enet_init(struct net_device *ndev)
 	cbd_base = dmam_alloc_coherent(&fep->pdev->dev, bd_size, &bd_dma,
 				       GFP_KERNEL);
 	if (!cbd_base) {
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_queue_mem;
 	}
 
 	/* Get the Ethernet address */
@@ -3376,6 +3379,10 @@ static int fec_enet_init(struct net_device *ndev)
 		fec_enet_update_ethtool_stats(ndev);
 
 	return 0;
+
+free_queue_mem:
+	fec_enet_free_queue(ndev);
+	return ret;
 }
 
 #ifdef CONFIG_OF
-- 
2.17.1

