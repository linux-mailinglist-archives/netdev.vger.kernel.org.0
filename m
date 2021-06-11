Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00B73A3F7D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhFKJxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:53:04 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:42734
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229480AbhFKJxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 05:53:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIw7I6RsOwbQkqu4LsuucmwcqBeTSAXpf6ecnIyMYjgaqd4YSItSHi0aBV14Tp3Hl7Qs5b1OGfh7o9P+CBW66Od36gdSa/jwLWQYXtt6JIhsXIYAs3UW0bRj8gtXBIKL83cyAXKnBjAAgiEqv3PDH80o2mlHCmdeIzRjKz1X78AecMiaX5ypDYEaiMRJO51+YCHVs3z4gILB6L1adLEQFycklKZ49PSd8UY27GDPwNyITh3/mJLaS0Iwx0hWJOoitfeKerasa8TultyVm5pHDljHQ57RrcsBpR6nxR/e7dbeyEcR0KQNV0uGoZkLfQlTyisQEo1qxdtVsJZTxn1l7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4y+FjJo1mDzOR51YaS1RmK4I7NA/VbGEmnO/K62mrs=;
 b=HC/rlFEXbsV9PxmwbWcrZWWvlbU4RGlY8S0Mm2DwsxsmJn8qwZ35hgrjz6mo8mI3ogZeFe6h6wr5SxEvNk20IBV9B66i7K20aABVbPg4XhuXPwnOEb6OnrzharwRET9rjL+xq7k3NHB+fz4CfXx9zXLUkLqLp0CzEJJ1tPOVE2kLSVUIS661x5v27yam2uwIkbeMor+KFhVGvN0Vozfw7qpGVxrV3EXbbqAsbG6y/esPc5Qy0T3atJwIGqYEvrcdZhaLXXE7QISq9CO0loZasuUqFS0Opr/0jxmCsnn+kVKhK2pmd76mTT1nVBzPLar+DbDDXoVCv8+CDQrZNdmZ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4y+FjJo1mDzOR51YaS1RmK4I7NA/VbGEmnO/K62mrs=;
 b=T7bsNOk2Z8SgZps+lHcsnskrA44tXwdAb1AF7n/m50sPOPES2Hm3KVas+Iv2DpLzVG6hMA2uVQOLVgpisU4sBWkf9DHT5lIKT0B52NY9sFK0l8lQjI2vN+cQzn6Je683l13I1IrlH+2uFIuZD9002alZxBLp7qaaW2Hob2/95fA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5787.eurprd04.prod.outlook.com (2603:10a6:10:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Fri, 11 Jun
 2021 09:51:01 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4219.020; Fri, 11 Jun 2021
 09:51:01 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Date:   Fri, 11 Jun 2021 17:50:03 +0800
Message-Id: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::17)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 09:50:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2aec5d94-fa6c-4fc8-5738-08d92cbe6b9d
X-MS-TrafficTypeDiagnostic: DB8PR04MB5787:
X-Microsoft-Antispam-PRVS: <DB8PR04MB578782918D9884238A1CEF84E6349@DB8PR04MB5787.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m877+lXB9JgXBP7I2Lhe7Xn5uukFoC8FAauExFsKnn4lP8pISOgq+cx0VgFkH3o7Gxophwsk0hikBvzy5hjFjsYoV/ba/aEN2ZcLpy1pIigUtOFDuD4p02FTvMZQ36LrmP/jMVHisOOGmJG7p05pjwktKR95RDvSkA99SxXxrLDdUn9RRpFTzq4iZETPH5bGgdKNOSRMhTtJR9eb/bfqCk+WVFZMgzytjv/E8HIa0JEoRkz2sdawQYaMZfwsDwYxwx9bboVki7FjYwFAZ94I4YOjKYXd6zTXA2C5+EJa1rau+SO4LD64CNP7easCjr+ZMbD0WcK3LQJV/TLKE4ihy6cVC1JvEuG0uL+e1e6BHduaSPVpO9Q0hIWC7Ime/x611366L5LlnSu6qsJa97Tsd1VHdBowpNeKbvHjiZf64OqnVcKTn1D/9lPmeAosnoMACXUtDxrBbJNgmZTurn7Q1pFLlnaxyzR4MQDKz5cKGRqlazfOurpUFynv5GRvgm9SXoiR4FJKsrA9l06cs0ZcJPPMVMuvvHx63SYRu21ctqmuNRWQ1bSLmdvvFxQRr4oN2iUaORN672o1c/WrjKXR99RK4NS+IBhQHZNikG0YJRyI9ozvYiIyKRRrL/MtFTLDkyu/4nccyQBe9weJfUhA3ocRVbtGdV+RNon+i7Ynq/EsTM3kyCTaEUO+TDYIzm572ygY8WF+OEJSEiTwsB/3mq+9Eoi43gGRbA3//ARKToYXLqWY8AnyeHwXABTqAMVpCZEVKXIi9+bzQ/MNeFunkgs/R6WXjClJeBV0L15G4f5+s4C7YPL0eCJ4HZcUNI3L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(39850400004)(376002)(6512007)(966005)(66476007)(52116002)(86362001)(478600001)(186003)(2906002)(16526019)(6486002)(38100700002)(6506007)(36756003)(38350700002)(4744005)(5660300002)(2616005)(956004)(83380400001)(26005)(4326008)(316002)(1076003)(8936002)(6666004)(8676002)(66946007)(66556008)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mx5mR+zypHZVcPN8kgtuIW092tPZo7d6StTX3JcHx7pUH4mrCkOkjtW0Tvzg?=
 =?us-ascii?Q?nVBdXTQUX6vV/9UIoQodl1nuucVEOc/sGZObWvLoCoU8Lmac5+tWsBgYHUcc?=
 =?us-ascii?Q?nMpzJFEZoXIiDWH+/5fVb0tnKOxZL4KI7rew/91AGZsUAc8ayHuI7wRO5aAA?=
 =?us-ascii?Q?t6Os7hBT0J4x/xgADuNNyvk6g9U16UlzgnDGQXxYqr4C/ec25nC7aiZJ6zCs?=
 =?us-ascii?Q?3K2wArvWXNzgyrDIL5lI05fshTjruzu6O/SJXMkVh5VsCVp/JfiwpYwJ86hj?=
 =?us-ascii?Q?1LEW94mqSyY1woBo2n8UDiZpc+AMgUqRL07lF+wgMfbE13rxoPyIMcy9UCit?=
 =?us-ascii?Q?SPPG+3BlqnouHLIeA0g57aUsc2rhVma/mkyCu3LCtqZWptDvKAzLV2mUKfDI?=
 =?us-ascii?Q?Jz5sKd4U3MT+IwUGBy5CE34X2f4IiGSrL9c8G/7PZGzRcNBh/lMbO+V6OlVj?=
 =?us-ascii?Q?xk3A8pn4eoEv4VRZRoXWjzX2PDKifchBJ2vLg68YgzrAbsYh03zW29thDdka?=
 =?us-ascii?Q?cmBRPB1piERbZP3aWJR4LNpOscyJuh0A1hOgCDYh2MsvlXIjPx1URNGlO0u3?=
 =?us-ascii?Q?B2gFRMSDC/kxYq8L9c0/Ds2Llzd64cpy5nPZohUqb6mlYD53qVgnpHRGkKsJ?=
 =?us-ascii?Q?il8Gwu7hDkh9uMjRGMaYYssiAASyz5k2QWZp55VKMiLxfjDOu9/K1cMsjMYT?=
 =?us-ascii?Q?F1+jGo3+qZK8h/dCiseOIfRX9luXJo/mAqy1n7sTOqF0mJ+X9OstO5hEUYwm?=
 =?us-ascii?Q?VEUpa7MuN+4G7wm8HnIESR6WiT/JtFriQKKh9bn7SfyMjZzDiWEVpQKI443Z?=
 =?us-ascii?Q?pkYNGmcN/iI/4Os25SZ1AKeTXrLX1rJXGSn2Ke1vHYceLAOl7+VzAiwqNwKs?=
 =?us-ascii?Q?CVW/eVu9Kh4+rIaRehdW0FkNS0QT5RwNfOiBRz1QTGtalRWZGdD/gR+Xb/5W?=
 =?us-ascii?Q?dovNYh8Roq5nFiLheTN5qujERdq64Mm8koe4ABm/uLgUIZ2qzVOp9CkHZA9S?=
 =?us-ascii?Q?u225cssVQqPk4hyVS1IVTEy3pU9BiweeHbYpWSe1Uk8c7EgGCVNzB1pco5e3?=
 =?us-ascii?Q?teYkSCq6eVHg2woDhBK+BhcRK54nm8M1JBWhZWyyGd9Hdm1Qw1EF2sXsjATK?=
 =?us-ascii?Q?cZ0aKozoSlT35VyK3I/UBF22g/hwy1qYTcX1+xIJ4MZlFYL7vVyUrP7WPv1j?=
 =?us-ascii?Q?DDhuyqQiM0079bihiqdZxsEAXy1hNnbpAVnj5KHhK8i0gGsFEo3MT3Ha4WPa?=
 =?us-ascii?Q?3raElDRbHKZ6/G7Y0hrOVJ9DALrxLKFn/xoI8Ej5RSuzndxXKjYZSW75hgyb?=
 =?us-ascii?Q?y3vvqCz4pMYTT6Izfr9E0xeH?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aec5d94-fa6c-4fc8-5738-08d92cbe6b9d
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 09:51:01.3614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vOxZ7zezG6JyMPUkyHrY6bR5MrjlenZ2lm0n0FU4G9qJtB5iFj7kXaK5/MrhlYtIUPmZGrhiatzBQcuKltMUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5787
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set intends to fix TX bandwidth fluctuations, any feedback would be appreciated.

---
ChangeLogs:
	V1: remove RFC tag, RFC discussions please turn to below:
	    https://lore.kernel.org/lkml/YK0Ce5YxR2WYbrAo@lunn.ch/T/
	V2: change functions to be static in this patch set. And add the
	t-b tag.

Fugang Duan (1):
  net: fec: add ndo_select_queue to fix TX bandwidth fluctuations

Joakim Zhang (1):
  net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP

 drivers/net/ethernet/freescale/fec.h      |  5 +++
 drivers/net/ethernet/freescale/fec_main.c | 43 ++++++++++++++++++++---
 2 files changed, 43 insertions(+), 5 deletions(-)

-- 
2.17.1

