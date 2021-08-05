Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9993E0F80
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 09:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbhHEHro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 03:47:44 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:25821
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238705AbhHEHrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 03:47:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYWjV+FtmBNG+yvCNetKr9IF8rd4sUrI9dbKXvm9b53YN813YIN4XxF65HwqSJ91bjHld/oY6FrRRE+aoM5ieN6P0fL+b0TXPXZvbaLkHlKxnLBTVuaR7NIepR1eo/fHgM6MHFBG/u1TmlLFNzfsrEiPH/7iQlstfJ4/iMse2xtbwgMEk53zO5GIyoou8F8o7Rbm11PzsleiBf8jLTOQ6WC9U9jQQLQjZiQY+wpArYKRSzYz0SWEINeeCmPAlW4ddveDuu933c0zlcz3ot1WPOcP0kTYsEOOngmwuuy9nXpPfRa4tz66wY3NPdaE8WxC9hMCfNmZV2v13lZOAzvYtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3LBZz64V8Naet+pT0+Bv01e8DPE3/aTQaiv7S8JHlk=;
 b=MgUr5lmeXe++eL7j3ro4vOPLzvHYAp/z1P3Vo7+i2NhyJmRxFUH/91Ik0I2clgfHfQlvb/1dRfjn4YElYiw+Fx/9svtSkKsa3jQLR92hoY57Z82dvBpnpShmmF6A5aFSVV8HJuLWaw0Uz+4S8nGmkswfZEA/IskEzzYwXdtGMQyt0xjRHKSUy0Y1zh4xlZ3iDvzslrIvTY63Px32bIziETTtTbwmBJ71eV1lHzlTiLaAE7E79J+U764Wctl1g3HlRzvw4jnnIQZ0RqI1B10aoJrbRJYdv2F56tiMJNTZAgesyeCDsBP3Hhh1AwRmqIiP+g9U6/oyvv8hcFcvuCrcjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3LBZz64V8Naet+pT0+Bv01e8DPE3/aTQaiv7S8JHlk=;
 b=gvE/bxMbl2j0Cx20tUlbmGUmK17pmDP50Iy0A6y4ssl3HBT+qkrVGKx+IFbVOrOkZSYu2+zE2pSFIDxNCI05yds6eZaU+7sEJG14Y/DU8zTu8LuyriBIwp/kzSc/pIO7bjDdpejXpE9DGMPVC8nDs5MW9p3AcGHju5BCuZfAlpw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6249.eurprd04.prod.outlook.com (2603:10a6:10:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 07:47:01 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 07:47:01 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        andrew@lunn.ch
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 2/3] net: fec: add support to select wakeup irq source
Date:   Thu,  5 Aug 2021 15:46:14 +0800
Message-Id: <20210805074615.29096-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) To
 DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.1 via Frontend Transport; Thu, 5 Aug 2021 07:46:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15dc6f66-f72d-43a8-7ce8-08d957e5360f
X-MS-TrafficTypeDiagnostic: DBBPR04MB6249:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6249A0F004204022245D3D78E6F29@DBBPR04MB6249.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:327;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MGvuHsdAPC3nj9RM0mJuxybQiKoYB2mu64wBepiWTGQXaXXLBJwPHqLKTTS2pFzkrxEVisWb7YOeVAKFWd24hvSQBhuFoGP/z3OagVQ9tWQuePCpJAzhig5Fko+m7lhi3WglH8XSxvufVMmfD4SOjjTI101ee3ky7mhUekREwb25yElavUTBk+vU53idEksQtTGuocscdZcSQQDme89T2BF/3Sm7hCq8W7UknGDYqepYkkaFWjDOvy/YArq2U2kuGbZLOj3l0B4G1m74B3IcV6F/F19+zAUQgv9/1M6Wla7vGPS2Vbe8+Uc9kXYA5niqeeOD3m4JKythEtiapVo5Cus+AUI0hUu/oLIvIauTzptwDKCjZ4+X8zkfv2qlGhfNW/7XBT39+0GQnv2inWcaxza4hOLihWa7rMlLUlD9EU+QYA4b9cmaZklAJi9cdIMHN/X3x63Rcuu8GbvzucZLI6m0OBnShoQNgdyF+U7hhtF/Hs0thPmkrMwbol9SxWtNjc46OjT+MNQi673hKnN/WbDtX7Gtn7eQmU7o3cQtIczEPkcl4a/5xRJFYEYLZIEKaMRRgNquueDsG4mJ7GIaiosDs2lxxPVYglKQr/wWrs+DYpopGXYtEaenOlfAD6TtrfH5oT3BimjSVEjtGkHnhvem4/SuvGUgaiNBai5P0d0Ag48TXjWDT1JcK/POjUhy0FVr8Zt+3f84dJroLPRAyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(2906002)(83380400001)(186003)(66476007)(956004)(316002)(7416002)(2616005)(66946007)(66556008)(6486002)(86362001)(6512007)(1076003)(6506007)(52116002)(4326008)(8676002)(8936002)(26005)(38350700002)(478600001)(6666004)(5660300002)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MJ8CJUW+hB3Fj71uFU6za8DzeWb2hYXvu/Act/n7hzu/TLOPrFqf5zQGy1bO?=
 =?us-ascii?Q?LQiPaM7pDYkBTx4X326kq2V1/bI6KD4wjaAhxhlDjGIwxnr9yvpKNKTqMvBd?=
 =?us-ascii?Q?YhkPgmTwk8G0TbpUZcFJdkZnWB4/SmqcOkGnDPSv42Zpql8y+OLPjzOUqbpg?=
 =?us-ascii?Q?N+vs46zim7X1XSkNTcjP8TUyVrHF4ZqYeKRyZGoIEsUaE9ZgM1AoVaXoOGt7?=
 =?us-ascii?Q?PXq6Xdm9lNoLYM3kvd2Lo+DH0bcva8+S4+zcNAzqrFPaO3zzWDxDo/VP7wLp?=
 =?us-ascii?Q?8bqSbdRYtlMBywp1SGiXtPCkPNQrdVWzTGD5TIpoUl31lmz8y3y0RGmQqGOP?=
 =?us-ascii?Q?nRjjUYRmsSWHtXDbMZODw63xvCYGZDQUTrNwR8Jj2uXgktMlC29SoQvpfAJj?=
 =?us-ascii?Q?50TMRoOyIcDqT4gZRJy6Rve5z70IOitp2xRsozHYfJD+7w/RpUwgLp4Jsa55?=
 =?us-ascii?Q?Qfeky1rhBfphiocvjSWQSl6NlTd4Xswwiq4qBLVkC60mVgOpbQ6CYv78uOCq?=
 =?us-ascii?Q?B2oyMpJh6xhYKOtEvBnJJJ0mXedRYlqBQsle4Wlmf05UP0w1KjuDZU108d3A?=
 =?us-ascii?Q?yaoZ3BLKND1hScz4DApO+ueHRkQq6gXFwZLjHYrc5g7HtQ4LFBtHMa+gCpkp?=
 =?us-ascii?Q?bEyiDy8lvfJnqAVpYDmMQoWlRW5zOdNmitmxPIS7aI8DiXFW0tKZODiLsCJ3?=
 =?us-ascii?Q?7qBw/A/ivtVG7tziJym0wPoIMprGy6xbNECts/DVC3xYBXKTF4a9Cu6wA4fN?=
 =?us-ascii?Q?u2+Fu/pnACPnTZfx1BYF86oOAvXXT8gWHenS+rrlKEr5caJznDfjnpcoXmd6?=
 =?us-ascii?Q?qDVfz9mk+3RYRGkHHG+2fFuL6A3iV2xa2KRYKk6F06qEc8pnehpwSekHa88b?=
 =?us-ascii?Q?cIX9ZwsIZWS5Pf4bNIrT1EdJw6Wt0HepFJZ284TUWR0wBzEp0bobS45noHki?=
 =?us-ascii?Q?cDKvTO9nneOgBJVYR0dtj0Eqxh45Jfuw9L312qTTN4HRZOqWQn1rPPjyMDBe?=
 =?us-ascii?Q?qE6HNzDm6yGXKf7RpV9JFFWLjuY9TNTxhI5fb0i45NyU4WEAsiC6IpYL/tjA?=
 =?us-ascii?Q?+nkyhOTmNG+ZPOvrMrciecVHY3o9L9w5R5lLGvafC8bSNVVG1TwCB1Ocwg3T?=
 =?us-ascii?Q?AJ8l55p4Dl+AtZm2Es0iBIsuq7GMItLy7el7ebcjh+R93NL/0fbVy0A3UF5e?=
 =?us-ascii?Q?j41x144vpokCdbiw7p+YtvjotKbAsjCYCxW2X/UZNdCvSEgrzp0snPJZpeMY?=
 =?us-ascii?Q?LPrE/2223R8hZoOhagWRXFPVax8Dtx5j1DTzAk8zyV5E77IyFwclioa82D63?=
 =?us-ascii?Q?+PabyKJLB8xTHGygNU2/CcWr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15dc6f66-f72d-43a8-7ce8-08d957e5360f
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 07:47:01.7848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpxFkhxyj1pZbW4d87qtTcxxGdTGW0/aIshrQ/etciW4FULDUKl6ucUzd0+5Z75vizdp3qECI1Js6b5JEjR0SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6249
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FEC driver default treats irq[0] as wakeup source, but this situation
changed on i.MX8M SoCs, this patch adds support to select wakeup irq
source with "fsl,wakeup-irq" property.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |  1 +
 drivers/net/ethernet/freescale/fec_main.c | 15 +++++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index ae3259164395..fe4dfe2d25ea 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -578,6 +578,7 @@ struct fec_enet_private {
 	bool	bufdesc_ex;
 	int	pause_flag;
 	int	wol_flag;
+	int     wake_irq;
 	u32	quirks;
 
 	struct	napi_struct napi;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 1201c13afa6f..c422a309d33c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2878,12 +2878,12 @@ fec_enet_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 	device_set_wakeup_enable(&ndev->dev, wol->wolopts & WAKE_MAGIC);
 	if (device_may_wakeup(&ndev->dev)) {
 		fep->wol_flag |= FEC_WOL_FLAG_ENABLE;
-		if (fep->irq[0] > 0)
-			enable_irq_wake(fep->irq[0]);
+		if (fep->wake_irq > 0)
+			enable_irq_wake(fep->wake_irq);
 	} else {
 		fep->wol_flag &= (~FEC_WOL_FLAG_ENABLE);
-		if (fep->irq[0] > 0)
-			disable_irq_wake(fep->irq[0]);
+		if (fep->wake_irq > 0)
+			disable_irq_wake(fep->wake_irq);
 	}
 
 	return 0;
@@ -3935,6 +3935,13 @@ fec_probe(struct platform_device *pdev)
 		fep->irq[i] = irq;
 	}
 
+	/* Get wakeup irq */
+	ret = of_property_read_u32(np, "fsl,wakeup-irq", &irq);
+	if (!ret && irq >= 0 && irq < irq_cnt)
+		fep->wake_irq = fep->irq[irq];
+	else
+		fep->wake_irq = fep->irq[0];
+
 	ret = fec_enet_mii_init(pdev);
 	if (ret)
 		goto failed_mii_init;
-- 
2.17.1

