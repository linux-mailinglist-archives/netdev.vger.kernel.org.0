Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9C242DFD0
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhJNRFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 13:05:12 -0400
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:20865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231327AbhJNRFK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 13:05:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5TdVq6Kp/2hBsae+jUEAtpR7nO5sGPozhQTUCHjZXQiHcJnedDOcbNkE0IDmHdoL1LJZAm+oC8QqG6EFXDBEjXfXm6fga00CfJ1OIN9SR13eXAXjBMWNH7ogLFNmEVdjaEBe+5Xx9NpgdVrwNuYzj8J4UFdGsTgL3MlFlCkYG/g9wMIn+S6pjtUWwfDHsUn0na4KP7C6qFO1fTbcsc3HLn0K8xlIIwOWxnzteJYRdWuXQFshoRwh26JE5T+M3AAa7ljXARhOsm4HG8oz+PATe8Zwp0qeKCO3cVHya2cnJ/4jjUaF59IEpQeW4hgXjiA3fVj8xCrr3yQHr9uAVmzxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yClx/LuScyqoh8Eo8XP/wGMWVA+tbroR3jfSYbvpbOg=;
 b=kMkbvXcIFA8+IgLY0na8xwQdfikQNfM/MAB0R0vuptgvhg2+MOgSui97xRW/vzHEKrpXOj608jLQpuwe24J5zsXWM/2pMCr/F8GMz0N7BBvxuS6AAOYDMS0EkdVtjozIIcJoCc06cKPezN4YNQh+r7PdFgdqCEUQOVA24EgsXQTxOoLgqQuYWhIQPA9nFfI1MLAbfgfuzbtYgNCaEg0q1G8IiFo292dCikNI3HfT7qMzgYTxaSLuEHbb37JxDXDb4pRyH0wNW0jPdE2iqPSS/ANUB27/7fr6xb9EhQFHVnpPYXg7yHJy8xFlgaB40nWdl2WYduotz/+8FinoCwjeVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yClx/LuScyqoh8Eo8XP/wGMWVA+tbroR3jfSYbvpbOg=;
 b=BthmI3d4KlyErC9UjRQmrtOkpE1BH2dT2lrre6jTEc+TdWO4/GLBSqq4gO3kKKFUsRahAAxaBgLQrB/s+tUaKdUQnIkRa1tSXpo6YVHLZt1c9HaqZr3pl6KLrheLM4B9ckJW/vGITEH2l1VoxMqRT/Gc8PDpeiX8SsJ0XSUAzrU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5825.eurprd04.prod.outlook.com
 (2603:10a6:208:127::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 14 Oct
 2021 17:02:57 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 17:02:57 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/5] dpaa2-eth: add support for IRQ coalescing
Date:   Thu, 14 Oct 2021 20:02:10 +0300
Message-Id: <20211014170215.132687-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::34) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0029.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 17:02:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fc84ad4-76ac-432c-34c6-08d98f347865
X-MS-TrafficTypeDiagnostic: AM0PR04MB5825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB582575C83A33F93073F7D636E0B89@AM0PR04MB5825.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HvRuqAUYad2H7DY4ZCtABQo/Ayx2qsUulBKlnOHCZJPJl/qnpZ8yey/0jFWtizc+iwZDT1GCBpXFXJJ/9m2fDMpSDpuN2NxgGERHorYm6xLdVk0hkckfBj8qgLoi3TOuYw0lBU+46vYLeP84T7D83iuy/l8GfWtlI3tp1frZsyC0SeAFg5d/emO4S10g1crG6m7H5Ifh8SbOBtrpdoStpbeEdtoiENbUznXYZAmhikVeouL8YaeGaazvOMcyRIsTChmSnLw8QEVhnQ/1OJMUxqQRtQHFS1aRwD/ObgCXEffVt/NZtxz4zmC8LPCseYW+YD9Qr8tFtwCbtw9kTMBiHWy4t7NyXIk9LW+aKxuwqYWQ+/Z3567p4mgk1lL087kaqg301rR/TN+on4NrHFyZGQZw4MghDZ4u9vld45MhVR38Gw2P5U0Ofkhyx+8xXxcpCghkFhYXvCZd6Ou9UEMMArxtYTvhrlT9MR4bE9T2DSNCgxBNW7vnUhTGJAxvBRU9hT2ZvrzJJfRnyD7MK3YpJJWln298RowjZam0zEEqraewMM5I033h1ONn4EFCj+dYAg8eiRC0wa/kymk8k8Lwj6j51UdXEFS5QOHYsFt8cEN2AEF5twcoMb4lCCllsf7YmCj+7biGDQAwbzr5vAQNyJovnJnQG8eNlQ8V8tP2pQ6iH9dKi3j0t5YW1dISkhec
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(5660300002)(2616005)(956004)(1076003)(8936002)(6666004)(66476007)(186003)(316002)(36756003)(8676002)(4326008)(26005)(2906002)(6506007)(38350700002)(66556008)(52116002)(86362001)(44832011)(38100700002)(83380400001)(66946007)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4sw0Ymivh2qeZcXBUvNZv4LZbo3KuREenNi+DTMFSd7T3Fzpty0AS9+MR8aZ?=
 =?us-ascii?Q?c8tZwUA830ItbTZkAYilvah0lbHVKHdR8ecZoPYwk1JKMDWi+UK7dYgyVCM3?=
 =?us-ascii?Q?GEJ2WeNIsnVQaHX0h15aZQSUIM2XH7rzjKZJlaNI+n60jpAIKbwB8cmtcWVs?=
 =?us-ascii?Q?f7F4MKKzB/AzIOlc83G3Hr7JV80A7/5Rr0LW2ONz3WYDPGnD8KXC3nfLsfUE?=
 =?us-ascii?Q?AgGCDx6jGGcjqXMzPnNNyyjAcNEIhi3zOd5OFKzLry2ogGM33yEIpIAYSpKo?=
 =?us-ascii?Q?QiGXdZN13GmLhPQY5Zv3Nr/Xyfxmq9SZpBROC0CLhhry/dzsVhfP8xRZJ4WP?=
 =?us-ascii?Q?s+Sgjg8e7kTS8lj412GbGMySk3CVA2nr5e7+iu4ygSzQ97sE3GVNIYnxI6CO?=
 =?us-ascii?Q?h4UlK2v07h6xAcWgRrue/SGijbma47RsRdyQYZ+mgU1rhq2MwhvIV/FZLvPF?=
 =?us-ascii?Q?kakREBSwVuBi8psoDO3ce8dCenfzSKYqrR5MNsJlJ7bcqPQmUctJeKj+vKdR?=
 =?us-ascii?Q?JkENxoTwsTwH4Wr0PqEQvtD1JhMVXoAQ5EZ5rb8jXIz1VYnOkngckV8lrI04?=
 =?us-ascii?Q?Imkd/UZe2jCQASfclfAv4jCGV+22PtoFmcKJRJNkiRqrqha2wLr3/+9f7Djo?=
 =?us-ascii?Q?bWfcVFrfCybGI5eWYHWUdFo1v6V8FsPBWb6K1zSzEN64g2H9YhZTW/hL088Q?=
 =?us-ascii?Q?MBnmJJtG7EWGuKL5Nr605O3gh+xltZeepkwvMcBXVn9e9+7XU69CbQiq9jD3?=
 =?us-ascii?Q?WCqL7SyGcQwx3tQ8IJr8weCrI5NVgxyJ1u7V7uz3DFb+Qs/cpxho9qmu/JY8?=
 =?us-ascii?Q?/FS5b9v4NjOrii38vcPvci5enjgh7f5hVEpXtO0BWwZj7WVWSWFKbo35TGlU?=
 =?us-ascii?Q?31o/1CDmLiOyffFvt7du5GypiAgw7uW9BMXNuls8tKbTyQ8EhfZPu9UtoAwk?=
 =?us-ascii?Q?isv4A6Ov2WPu9RQ7bNDzbjsHGluIvCC1z8jNkV3uHMRHWnZYA5WMShR1H0jM?=
 =?us-ascii?Q?YAym+Gaw0Mh2K8KyGPSy09csf5kHEIVJvuUOrefLmBcsGM2rkYf924K1IlNd?=
 =?us-ascii?Q?3OL2li+7GdvG/Q6lXOG58lGt1hnkrJtWjUlWAZrJ2O64FGf2YzJs2DTE+fRX?=
 =?us-ascii?Q?XK374FWEd5Jc5x3wyf2MDOsdhIk/D8/oHC2KxK6b4NtTfVjnvGNWdJLKiMbE?=
 =?us-ascii?Q?CRcBpCxBodvEXFNx5e5ZRioCNWNFI7IlpCNt4cnh0tkWxZQuNy4tiR4y5HFh?=
 =?us-ascii?Q?RjCXyXcopklrvS0F1PqgNXrUN4g3/exJ9FsgzOaDSTZrSZI1C8dxIpzaLZc7?=
 =?us-ascii?Q?YxangCOf07BZNpm1+RKoaJof?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc84ad4-76ac-432c-34c6-08d98f347865
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 17:02:57.2445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cRp+KVmQ6PcZKMA+IJ8ZA6Fu7J8k2HYkv2Vrcp4Rsf6BnjcLTmwMC8eGD5n8srjl2XLYw3LaeVaX/Yrg4yJPbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for interrupts coalescing in dpaa2-eth.
The first patches add support for the hardware level configuration of
the IRQ coalescing in the dpio driver, while the ones that touch the
dpaa2-eth driver are responsible for the ethtool user interraction.

With the adaptive IRQ coalescing in place and enabled we have observed
the following changes in interrupt rates on one A72 core @2.2GHz
(LX2160A) while running a Rx TCP flow.  The TCP stream is sent on a
10Gbit link and the only cpu that does Rx is fully utilized.
                                IRQ rate (irqs / sec)
before:   4.59 Gbits/sec                24k
after:    5.67 Gbits/sec                1.3k

Ioana Ciornei (5):
  soc: fsl: dpio: extract the QBMAN clock frequency from the attributes
  soc: fsl: dpio: add support for irq coalescing per software portal
  net: dpaa2: add support for manual setup of IRQ coalesing
  soc: fsl: dpio: add Net DIM integration
  net: dpaa2: add adaptive interrupt coalescing

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  11 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |   2 +
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  58 +++++++++
 drivers/soc/fsl/Kconfig                       |   1 +
 drivers/soc/fsl/dpio/dpio-cmd.h               |   3 +
 drivers/soc/fsl/dpio/dpio-driver.c            |   1 +
 drivers/soc/fsl/dpio/dpio-service.c           | 117 ++++++++++++++++++
 drivers/soc/fsl/dpio/dpio.c                   |   1 +
 drivers/soc/fsl/dpio/dpio.h                   |   2 +
 drivers/soc/fsl/dpio/qbman-portal.c           |  59 +++++++++
 drivers/soc/fsl/dpio/qbman-portal.h           |  13 ++
 include/soc/fsl/dpaa2-io.h                    |   8 ++
 12 files changed, 275 insertions(+), 1 deletion(-)

-- 
2.31.1

