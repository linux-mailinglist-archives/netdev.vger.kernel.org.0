Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6290B469796
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 14:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244969AbhLFN7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 08:59:01 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:26336
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245010AbhLFN67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 08:58:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i17RfnIYk4tfcTSbm1S2IIfY86rV9gdUvX6kaMtlZ3F6zOCgVudXm9zmpLr96ePy9QK79tclLliYoBkf5Idb3+xCt19KfPyNz+QC67Ky95nLfEwH1JDhLjQmE10kr+kmtZ6l8s5mR2fLHVwmWviWYePsWy95+Z7MTjD24qGH09u/6mXcaxz7VbJ/C36VOmgDIchGWwnNhk+UtGCIhyPpxqN4GEQPY1YUDdiVnRMqjuV/0g+HCWa/wx9LNzXfksCzd0yovQqNJZMAa1lgFA58KnrVIN/Yhf5BEwXTwduDtdznmpu5WbagXcMU8c1hHxCjR20pC7RIztZcfW/b64pnfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfvUY+hP1k5MFEZXLhhStSiXSkPe6/KpFYYDRLU7L2Q=;
 b=cdZlELQsw7QerBGdeJBUHnSGylwkZbCOy+uSDTpd+YwamxwtITTh8Jw7uGNyHj0A/GptIbK4PFHMN5kBLd2cPFPYR75gWoDV7foa5g2LkEyhdlilVfB4TRf2I+jdyV7zhtHAgNr8Pg40LASZZTAHeLe0FNXFRMJWHFsHuTNspiHHV2ZAQgdy+AqWGTrP4UR4FRddB3o9PBPQwrzd+Am15YK4d5Vfww6TiStWH+KYIqlPA3JBuMbJsxrt6gqJeGdzbiCTIQkQ94rVv06tEXpkGljtTZlHIPzyKzuQC2O4FgV2btr6h1OPVXD9q/R/sFjWuW77eQnbL9QEvVidL5tSUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfvUY+hP1k5MFEZXLhhStSiXSkPe6/KpFYYDRLU7L2Q=;
 b=pg8dXJEXZBUcb33c0CiEr/50Xt8NQZxONUIwUz5XcdXR9EjRL83A5bX6v5uc0W6Ui3S/uMI8utCg+AzUBFYO81Nkp/7wuzRpZalIY+VoHAHuiyUZtjY43wk9uCLmDFpiz9siVc6WFdUP3hu1wrKtFTCXkHusOT93bsiZCs6Vhq0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4524.eurprd04.prod.outlook.com (2603:10a6:5:3b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 6 Dec
 2021 13:55:25 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 13:55:25 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        rmk+kernel@arm.linux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net V2] net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()
Date:   Mon,  6 Dec 2021 21:54:57 +0800
Message-Id: <20211206135457.15946-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:4:7c::36) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0108.apcprd03.prod.outlook.com (2603:1096:4:7c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 6 Dec 2021 13:55:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0151582-bca2-4270-d471-08d9b8c00db0
X-MS-TrafficTypeDiagnostic: DB7PR04MB4524:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4524DF5F5C1D612608414BDAE66D9@DB7PR04MB4524.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C1mvvvkF6qiYotH/SL4gbgKMwmy9VQ2SKV5qhMdDpx+c/LjIBkw4aVvFsvsmQ2in0aoo0DweeX7JChd8FDNMT943pcJxNY/ARiTiq2Z9RlgRr703MjyCxAohVfgAqkuv8VMPLoMUkXJVYZ9p7+OGcayICmTv9rEkS9N5SjfdseXd0lY88N8IKurht1GLMD1FgzsWX7/uUfD/EueEVO1EXEPO1OOwa8ohi6Xs4wjH4iIX6TX5UsvJDCUskYzb1dMDxjQmr9oA1O0BIjp2xJf7YvOMAGyg4X5IwxHtaETJhS7xM686Jo24XDzNEPg+FaosPdWzC9f3rYegMvnlobwulkBd6L08WP8FZgchc8UzYAHO+dZ3ddcTovnAyhcNlSEMqvvjeHq6+/X+EJBw8NIoS0/EBsmrOo4FUv4VHp0qu24mY9K66btMdwdxyiUQjmi1W7VkTOfenTMfa0Ly2Q2a0wV6SamlyHYmrHeBUPpoY1fGQdbHYs16wbGuSQ55m2UyxAtVYCcCp3ejh2/lAkWL2YDIgtEJMp+BiMqQWZQmN3gLcVHV/tPpKgkWCp3JaPFwDG03rVjI4PQAw42kInP5OexnD5EjCAhn87Nt+m+i5IydidLw3QFiwHgIRQ6rAOsvrYJj4ILnna4wlEiwWo/i5HC5+yJ8yQzVG3vbeo7ihAsdLWlvgQUoC6OW9iILTzyGFhL6lsv4+m6k2ldrx7Yi4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6666004)(83380400001)(8936002)(316002)(508600001)(2616005)(5660300002)(6486002)(36756003)(4326008)(956004)(186003)(38350700002)(38100700002)(1076003)(6512007)(6506007)(26005)(66946007)(52116002)(86362001)(66556008)(2906002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZqtsrstDEvuD3gBZyqXLDsuF2cPopeG/86ennRkkhFJNnFlFcEI8ml57ZZvN?=
 =?us-ascii?Q?WAz1fHJH2GQwOYD/HhZfUg9FQE43GIkpP2G7Vgvcj2mOg6bQa+3U3n3x0Sii?=
 =?us-ascii?Q?XXmEJfPcbBNZBrvCIRnxAnARXhGNNhE+YhKV4Zq9hZL9OTNxbEtglQf4YuCG?=
 =?us-ascii?Q?HegLFXA0EPeSsKKx+l/JBcbObEw3GEU3UUuBnT+xmEtTg+TYntEcx0wsCjzM?=
 =?us-ascii?Q?GnrA8HmYh4GsHRTYCeC0/iW308YYxbyqVafrBsnPA6xdPBi65lSZ9Ut6OToP?=
 =?us-ascii?Q?LuZ2MilLazJy/EA2haNVwcIEpgO9gG59VW/ro/4BuoYm1sMggcIIwXaJ8Aam?=
 =?us-ascii?Q?0a2yLdAcIi2tHdLDADGBAg4yp6l8g0nXQGEJ6gTFQJAW3rbg1Z9JAKbAfNdx?=
 =?us-ascii?Q?ylOVC6WesK1V9JZsGgslxUGdU/pHv/jb2LiFEtkoWsllj7R6mNnGnP31nqxe?=
 =?us-ascii?Q?YR/NnBcURHvZgZNR3Xpd42hD8X4qhtu2LNF0WNeUa8ScF+UhBCQt0tvmLxRM?=
 =?us-ascii?Q?47WbSiC7RoJk31Ur7QhZurZuUFhVMB0L0qwmFyP3XxlziXtSry6omH0b+qF9?=
 =?us-ascii?Q?tvjkLiVwkhKzTA5OT1o63zPjEK0a2LyywxerhuwJwGwt8idXZP1u9KnIe71V?=
 =?us-ascii?Q?rNsw3rZjN3snsuwIS+gjAADmkxC2OgwVIsjgRKT920U0h9Ta22ApuNN+9WWS?=
 =?us-ascii?Q?7Ff2+tsExO7IrDBCdFPsT5YHwxJLzR3dr/B9LmsljF535OGmPEiEM/y984/H?=
 =?us-ascii?Q?dlLhSizwUPs3Y2HT1nHKF4V/bTqiwTZYd4cMTPhLKCg4sfSCtQgf/IJv0Dav?=
 =?us-ascii?Q?z+cQyQzq9t/3aJn0s1mmzEsNlQIlKmzcfqv+BwyBjzLx47d5gn21mYHM/Xjt?=
 =?us-ascii?Q?fNsPuLiL4CJEOyIvgqm9AhBZ2TyBNKY9Qsfxu8+mRj5/Hso5Pu6wqvVysV9o?=
 =?us-ascii?Q?xxJRBWpWbNLq+YIjEKnSydjS2m5lRNYNMxiWl2Bgv9junTtMMXsfriNbboRO?=
 =?us-ascii?Q?Dk5ryyETIpoGweMgcRlHw/f5ZW4ePdeQpOACqttrzsvABQ+Ks86e6csOWtJ+?=
 =?us-ascii?Q?OqaRQ/Wey2ZIjhi0TaKNh2AVNaNQtBlzxvY8EWF22QBMABCZuc+A95LrKfG5?=
 =?us-ascii?Q?gGDesaQJPwi53oyNq7IjSybqpVGWrGR5bjUBsU+aYH2SQIMPHkbSx0cseuBH?=
 =?us-ascii?Q?BnALmgci5s7GkMAakNGBzRqpM1S0/tZ5BzqaR0YzZ2R23XRP6hePh2JIVcE/?=
 =?us-ascii?Q?E3XraXEI4ESlFvaSQu9oZQHa6rjf1XvLjS5SvpxZoEeueaBR+cVeSlk+YsM4?=
 =?us-ascii?Q?t0AWnXWjNHOqymdzxxexjpYhvHrJM/uBVladb3ZO1pYeCWIxNqdvuoOu7E/B?=
 =?us-ascii?Q?+uYraN/fkjIBELaZrZpwwvLpWo44gVfaOjjzLtLhZ4PVBqy2e8Ha6exXneIE?=
 =?us-ascii?Q?KBC6nq3H4pCfIVB7gkdh+gu5dvR7pxId0TBqGa6miphrXRBxHYUratDb2XWT?=
 =?us-ascii?Q?+p7tWQ5wp8RMapFYu4Ba5GXNYM17NSV0znRU+2Yf5pqUIzmpP5IWdB+jXqG8?=
 =?us-ascii?Q?4lsndx524V+cMJAV7QTIFxNNLJi401C+VdZm8g22p7Njbtj40y5kMybEfRGe?=
 =?us-ascii?Q?GjvD/BmGFd8/8ztR/q2MGSw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0151582-bca2-4270-d471-08d9b8c00db0
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 13:55:25.5616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9MQU0m+BFEL+KQVKpDJK7gyIsNr4s1NqBaf4zvymlX8gAztXvB250TZigpY/lykpakBJjrPbpLrA3c59VPjpjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4524
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Background:
We have a customer is running a Profinet stack on the 8MM which receives and
responds PNIO packets every 4ms and PNIO-CM packets every 40ms. However, from
time to time the received PNIO-CM package is "stock" and is only handled when
receiving a new PNIO-CM or DCERPC-Ping packet (tcpdump shows the PNIO-CM and
the DCERPC-Ping packet at the same time but the PNIO-CM HW timestamp is from
the expected 40 ms and not the 2s delay of the DCERPC-Ping).

After debugging, we noticed PNIO, PNIO-CM and DCERPC-Ping packets would
be handled by different RX queues.

The root cause should be driver ack all queues' interrupt when handle a
specific queue in fec_enet_rx_queue(). The blamed patch is introduced to
receive as much packets as possible once to avoid interrupt flooding.
But it's unreasonable to clear other queues'interrupt when handling one
queue, this patch tries to fix it.

Fixes: ed63f1dcd578 (net: fec: clear receive interrupts before processing a packet)
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Reported-by: Nicolas Diaz <nicolas.diaz@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V2:
	* introduce a macro to get receive queue interrupt
	* change to formal patch
---
 drivers/net/ethernet/freescale/fec.h      | 3 +++
 drivers/net/ethernet/freescale/fec_main.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 7b4961daa254..ed7301b69169 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -377,6 +377,9 @@ struct bufdesc_ex {
 #define FEC_ENET_WAKEUP	((uint)0x00020000)	/* Wakeup request */
 #define FEC_ENET_TXF	(FEC_ENET_TXF_0 | FEC_ENET_TXF_1 | FEC_ENET_TXF_2)
 #define FEC_ENET_RXF	(FEC_ENET_RXF_0 | FEC_ENET_RXF_1 | FEC_ENET_RXF_2)
+#define FEC_ENET_RXF_GET(X)	(((X) == 0) ? FEC_ENET_RXF_0 :	\
+				(((X) == 1) ? FEC_ENET_RXF_1 :	\
+				FEC_ENET_RXF_2))
 #define FEC_ENET_TS_AVAIL       ((uint)0x00010000)
 #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index bc418b910999..1b1f7f2a6130 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1480,7 +1480,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 			break;
 		pkt_received++;
 
-		writel(FEC_ENET_RXF, fep->hwp + FEC_IEVENT);
+		writel(FEC_ENET_RXF_GET(queue_id), fep->hwp + FEC_IEVENT);
 
 		/* Check for errors. */
 		status ^= BD_ENET_RX_LAST;
-- 
2.17.1

