Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BED2FBB41
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391208AbhASPch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:32:37 -0500
Received: from mail-eopbgr00122.outbound.protection.outlook.com ([40.107.0.122]:51363
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390780AbhASPLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:11:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fL6nQi461DXeptF92jZIpccIdwtMdLi5nrd1WLgkeKpd+6q+6XraCffz1CAHFKF4dqDDiePQF5jWEGxVS+eV18csh1gy0RL9nTkOIWhSI6Cw7GdemQL9i4GOY/H+jFQEBSmGU40KDBPt6299i4gxNg/BcnUU7KwUHf9YwMoOP4R9mbrlYdA29gv4lYxDt1clPNbiPizd+AXnxTXoyQD33T+sbJNJxkLItfQZyANauHMKU/0hub0XlDRXwcZqnkHw1p2zYWe/MIGpEkQ0XjLG8EF34rtc1AT88uJpjV0ZaClwxNEXO5XcOLx3qL+G+cokXJy2pjwdbzFB/H604WoDTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53WloqEftjTso8n6LOUssnNHPN+5CSNcNAFZ7ph53Wo=;
 b=PiFzEStpfZhPPOm0nGsPR6zqJoKdWN59npKjzE2f0wPRwfbPJKkh2ER2T72oB1i+gYe+kL/kell08127J51By2+TKD51gL7fydpL0bpye024/khAnygGm/MPYmylJcjeS2fbV7Rfkl6ToFyizklZYAFU435PmuuePC9/PaCWcdEG1KX1FLFMNO9fEk8BQ1A3nU462Qogt2KQtLQyYxKYpGzQNQy3//StYXdUrNICyZpkXdYlRwNYiKB89FCeBvnzuNRrX9wuMeVeqcRB8GDXe0tRf/ro9qJ3DGLFJ+P8n8ClPaxZKZtYKiVjjjud19B0kD77AcsCDkU/htaRF2sI4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53WloqEftjTso8n6LOUssnNHPN+5CSNcNAFZ7ph53Wo=;
 b=ecdRkVqLamb/+AEmfYxLWgE7Qh95OpavIZ60JeDXFrNXApUpz4o39hYvVkCOikXcL263RyzcyOhncSWDtxdqiTmxtBWJ4Kar4GP9H9mJTP90f4mttyoIn1NMvHRkSaWQ28r0Pnepe3c+XAljeSiDezwdbToqT1mVHUe09taReFw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 15:09:18 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:18 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 13/17] ethernet: ucc_geth: remove bd_mem_part and all associated code
Date:   Tue, 19 Jan 2021 16:07:58 +0100
Message-Id: <20210119150802.19997-14-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fce7fbc2-da17-4b74-8bcc-08d8bc8c3127
X-MS-TrafficTypeDiagnostic: AM0PR10MB3681:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3681311BA73B55795D7616D593A30@AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FuYlgs4D1rbQVybO1vL3D2x6ZpvwE5OA2DZfNMptB4/ewLgnSW/z4+Qo7pr3TSSoD+UmF+kCBcqW2ncPMg8CpfE29DQxWggtLBH4PvdaEPF2XUX26W5EMB3mVYVe01mFNxGqCoJRz3DTdaOXR7rSagADau56IZf/HWyk2v18hx56ecmICZQCffSD9FUEnqefKnNUMZBjOY7sbBB04yHq6NP9Mw1923Vke8iy9pNoaGfFvac/5eNo6qpDgcA0LdeCms1upRwGnzBA+q+SNKpmdc/1zGdfQVb0FIW11dOIzw5y32dCEEt5prb+MVZ7S/+gv3jnTw1W9rGQsCdvTvRJ0bAC0xoEbLPHx8j29oFLs2+Yxm5crYjm5qqvwIcCOnvYT8IDYyh+GyQ1f8P8+fm2yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(39840400004)(376002)(8976002)(16526019)(6916009)(5660300002)(8936002)(2906002)(6506007)(66476007)(52116002)(66946007)(1076003)(83380400001)(186003)(956004)(6666004)(6486002)(8676002)(66556008)(4326008)(54906003)(44832011)(107886003)(478600001)(36756003)(6512007)(86362001)(26005)(2616005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jZm/oawP2j1sHXuj5cKYL4wcllSdEjDlbsQ9Yp7SuCpz3mi3gN77X0SAGOb9?=
 =?us-ascii?Q?QKlY5xJnMtNPeyDTnOk0ue6Eu56bIopcsqt/Hqk4Fp8FicoscKzsb1vOy/Fd?=
 =?us-ascii?Q?kVfqY/XPtNg8vA35OROC42n/FjHKYUcL/mxhPYOuaHmp/SIrHESCcn5zjUNi?=
 =?us-ascii?Q?0qveqpLD1+dWohDEmkGv8MruUOBUQdPfXT6mo3821JazI7oEu83QfEHKlFuY?=
 =?us-ascii?Q?F2bH8ho0RTWnpp9dLIF6lOjZ9b7A7pZbIr91e7KzIobW9o0RGQmT/xRQF2Tp?=
 =?us-ascii?Q?gE4urdoDrqFOuJZipq0YgZHXgBGIsiDjk3MumeXzndgzdZEoBq8I0vdwjxB4?=
 =?us-ascii?Q?KwJqyemSJcaM4xGgYWxOlwS85nDlBFDHNgcoGLUX/mQIk3ZEHa8gAdZnos4u?=
 =?us-ascii?Q?3I3DHH+WVbv/Qkg9BgeHrEbOHtHAwHkAIIsbotgE3tbomyVDVoOqo5K5zNSY?=
 =?us-ascii?Q?YcNgywjCU7dHTQZO7F0lhghetUKNO3+w3Sepp3t2gN630589BgCnFq3r47+s?=
 =?us-ascii?Q?iKokMnEDXChJnLIyo9hEosnkCjxbCopzwqqP/ro/u6zK59JOtrcs/bEBKLvO?=
 =?us-ascii?Q?A5+vF0ebPvnsT0Oksotytjoz42Pb3HAB6FdA7AWZCzh8uDzTraDLsukfyfxU?=
 =?us-ascii?Q?aseQ3AOWNhP/S1TTi6fQm5Z6JuPDk8idONq5BrUCaG2Lei2e4FVVGkG/vipp?=
 =?us-ascii?Q?4r3KeAd3nBRjlee8n39Z4LJxZWn1q9sEkUBAHbJX/Ba3xQpZZV/CVYtoVb9E?=
 =?us-ascii?Q?wcHiTs2tzYZTtrxhRNah7DBcmuwx2Ljf2c+fH7Ac2MXtQ0VgkEydOkG82v6D?=
 =?us-ascii?Q?v3bR25Scip2s+isUNJJGdl3PuYdbd1TwJNeyiYS7gGzxAKolRY7Qp3faH62O?=
 =?us-ascii?Q?BKrROTZdLEykb8/lYk1cAuwkCzOOi1gZ0rVHjEiiLKKxJD3RREtjCiz6kcst?=
 =?us-ascii?Q?F3/1EO/6lpGi7y8nOejXjpC7/+lOvyBWjxlms4TBsiuPDufN/60XdJEX7wkm?=
 =?us-ascii?Q?QrFW?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: fce7fbc2-da17-4b74-8bcc-08d8bc8c3127
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:18.0972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fc3SQLgTZd+hBzA1JiLAh4rYpUhCR+K9D7OvgS8B+A875MnDKlLJhccQCJHIrl/ImgTKKB6VzldNoezjWy/w/3PgT6QyjMqRxx+/3VRl9gU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3681
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bd_mem_part member of ucc_geth_info always has the value
MEM_PART_SYSTEM, and AFAICT, there has never been any code setting it
to any other value. Moreover, muram is a somewhat precious resource,
so there's no point using that when normal memory serves just as well.

Apart from removing a lot of dead code, this is also motivated by
wanting to clean up the "store result from kmalloc() in a u32" mess.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 108 ++++++----------------
 include/soc/fsl/qe/qe.h                   |   6 --
 include/soc/fsl/qe/ucc_fast.h             |   1 -
 3 files changed, 29 insertions(+), 86 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 2369a5ede680..1e9d2f3f47a3 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -72,7 +72,6 @@ MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 0xffff=all)");
 
 static const struct ucc_geth_info ugeth_primary_info = {
 	.uf_info = {
-		    .bd_mem_part = MEM_PART_SYSTEM,
 		    .rtsm = UCC_FAST_SEND_IDLES_BETWEEN_FRAMES,
 		    .max_rx_buf_length = 1536,
 		    /* adjusted at startup if max-speed 1000 */
@@ -1854,12 +1853,7 @@ static void ucc_geth_free_rx(struct ucc_geth_private *ugeth)
 
 			kfree(ugeth->rx_skbuff[i]);
 
-			if (ugeth->ug_info->uf_info.bd_mem_part ==
-			    MEM_PART_SYSTEM)
-				kfree((void *)ugeth->rx_bd_ring_offset[i]);
-			else if (ugeth->ug_info->uf_info.bd_mem_part ==
-				 MEM_PART_MURAM)
-				qe_muram_free(ugeth->rx_bd_ring_offset[i]);
+			kfree((void *)ugeth->rx_bd_ring_offset[i]);
 			ugeth->p_rx_bd_ring[i] = NULL;
 		}
 	}
@@ -1897,12 +1891,7 @@ static void ucc_geth_free_tx(struct ucc_geth_private *ugeth)
 		kfree(ugeth->tx_skbuff[i]);
 
 		if (ugeth->p_tx_bd_ring[i]) {
-			if (ugeth->ug_info->uf_info.bd_mem_part ==
-			    MEM_PART_SYSTEM)
-				kfree((void *)ugeth->tx_bd_ring_offset[i]);
-			else if (ugeth->ug_info->uf_info.bd_mem_part ==
-				 MEM_PART_MURAM)
-				qe_muram_free(ugeth->tx_bd_ring_offset[i]);
+			kfree((void *)ugeth->tx_bd_ring_offset[i]);
 			ugeth->p_tx_bd_ring[i] = NULL;
 		}
 	}
@@ -2060,13 +2049,6 @@ static int ucc_struct_init(struct ucc_geth_private *ugeth)
 	ug_info = ugeth->ug_info;
 	uf_info = &ug_info->uf_info;
 
-	if (!((uf_info->bd_mem_part == MEM_PART_SYSTEM) ||
-	      (uf_info->bd_mem_part == MEM_PART_MURAM))) {
-		if (netif_msg_probe(ugeth))
-			pr_err("Bad memory partition value\n");
-		return -EINVAL;
-	}
-
 	/* Rx BD lengths */
 	for (i = 0; i < ug_info->numQueuesRx; i++) {
 		if ((ug_info->bdRingLenRx[i] < UCC_GETH_RX_BD_RING_SIZE_MIN) ||
@@ -2186,6 +2168,8 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 
 	/* Allocate Tx bds */
 	for (j = 0; j < ug_info->numQueuesTx; j++) {
+		u32 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
+
 		/* Allocate in multiple of
 		   UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT,
 		   according to spec */
@@ -2195,25 +2179,15 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 		if ((ug_info->bdRingLenTx[j] * sizeof(struct qe_bd)) %
 		    UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT)
 			length += UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT;
-		if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
-			u32 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
-
-			ugeth->tx_bd_ring_offset[j] =
-				(u32) kmalloc((u32) (length + align), GFP_KERNEL);
-
-			if (ugeth->tx_bd_ring_offset[j] != 0)
-				ugeth->p_tx_bd_ring[j] =
-					(u8 __iomem *)((ugeth->tx_bd_ring_offset[j] +
-					align) & ~(align - 1));
-		} else if (uf_info->bd_mem_part == MEM_PART_MURAM) {
-			ugeth->tx_bd_ring_offset[j] =
-			    qe_muram_alloc(length,
-					   UCC_GETH_TX_BD_RING_ALIGNMENT);
-			if (!IS_ERR_VALUE(ugeth->tx_bd_ring_offset[j]))
-				ugeth->p_tx_bd_ring[j] =
-				    (u8 __iomem *) qe_muram_addr(ugeth->
-							 tx_bd_ring_offset[j]);
-		}
+
+		ugeth->tx_bd_ring_offset[j] =
+			(u32) kmalloc((u32) (length + align), GFP_KERNEL);
+
+		if (ugeth->tx_bd_ring_offset[j] != 0)
+			ugeth->p_tx_bd_ring[j] =
+				(u8 __iomem *)((ugeth->tx_bd_ring_offset[j] +
+						align) & ~(align - 1));
+
 		if (!ugeth->p_tx_bd_ring[j]) {
 			if (netif_msg_ifup(ugeth))
 				pr_err("Can not allocate memory for Tx bd rings\n");
@@ -2271,25 +2245,16 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 
 	/* Allocate Rx bds */
 	for (j = 0; j < ug_info->numQueuesRx; j++) {
+		u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
+
 		length = ug_info->bdRingLenRx[j] * sizeof(struct qe_bd);
-		if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
-			u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
-
-			ugeth->rx_bd_ring_offset[j] =
-				(u32) kmalloc((u32) (length + align), GFP_KERNEL);
-			if (ugeth->rx_bd_ring_offset[j] != 0)
-				ugeth->p_rx_bd_ring[j] =
-					(u8 __iomem *)((ugeth->rx_bd_ring_offset[j] +
-					align) & ~(align - 1));
-		} else if (uf_info->bd_mem_part == MEM_PART_MURAM) {
-			ugeth->rx_bd_ring_offset[j] =
-			    qe_muram_alloc(length,
-					   UCC_GETH_RX_BD_RING_ALIGNMENT);
-			if (!IS_ERR_VALUE(ugeth->rx_bd_ring_offset[j]))
-				ugeth->p_rx_bd_ring[j] =
-				    (u8 __iomem *) qe_muram_addr(ugeth->
-							 rx_bd_ring_offset[j]);
-		}
+		ugeth->rx_bd_ring_offset[j] =
+			(u32) kmalloc((u32) (length + align), GFP_KERNEL);
+		if (ugeth->rx_bd_ring_offset[j] != 0)
+			ugeth->p_rx_bd_ring[j] =
+				(u8 __iomem *)((ugeth->rx_bd_ring_offset[j] +
+						align) & ~(align - 1));
+
 		if (!ugeth->p_rx_bd_ring[j]) {
 			if (netif_msg_ifup(ugeth))
 				pr_err("Can not allocate memory for Rx bd rings\n");
@@ -2554,20 +2519,11 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 		endOfRing =
 		    ugeth->p_tx_bd_ring[i] + (ug_info->bdRingLenTx[i] -
 					      1) * sizeof(struct qe_bd);
-		if (ugeth->ug_info->uf_info.bd_mem_part == MEM_PART_SYSTEM) {
-			out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].bd_ring_base,
-				 (u32) virt_to_phys(ugeth->p_tx_bd_ring[i]));
-			out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].
-				 last_bd_completed_address,
-				 (u32) virt_to_phys(endOfRing));
-		} else if (ugeth->ug_info->uf_info.bd_mem_part ==
-			   MEM_PART_MURAM) {
-			out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].bd_ring_base,
-				 (u32)qe_muram_dma(ugeth->p_tx_bd_ring[i]));
-			out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].
-				 last_bd_completed_address,
-				 (u32)qe_muram_dma(endOfRing));
-		}
+		out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].bd_ring_base,
+			 (u32) virt_to_phys(ugeth->p_tx_bd_ring[i]));
+		out_be32(&ugeth->p_send_q_mem_reg->sqqd[i].
+			 last_bd_completed_address,
+			 (u32) virt_to_phys(endOfRing));
 	}
 
 	/* schedulerbasepointer */
@@ -2786,14 +2742,8 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	/* Setup the table */
 	/* Assume BD rings are already established */
 	for (i = 0; i < ug_info->numQueuesRx; i++) {
-		if (ugeth->ug_info->uf_info.bd_mem_part == MEM_PART_SYSTEM) {
-			out_be32(&ugeth->p_rx_bd_qs_tbl[i].externalbdbaseptr,
-				 (u32) virt_to_phys(ugeth->p_rx_bd_ring[i]));
-		} else if (ugeth->ug_info->uf_info.bd_mem_part ==
-			   MEM_PART_MURAM) {
-			out_be32(&ugeth->p_rx_bd_qs_tbl[i].externalbdbaseptr,
-				 (u32)qe_muram_dma(ugeth->p_rx_bd_ring[i]));
-		}
+		out_be32(&ugeth->p_rx_bd_qs_tbl[i].externalbdbaseptr,
+			 (u32) virt_to_phys(ugeth->p_rx_bd_ring[i]));
 		/* rest of fields handled by QE */
 	}
 
diff --git a/include/soc/fsl/qe/qe.h b/include/soc/fsl/qe/qe.h
index 66f1afc393d1..4925a1b59dc9 100644
--- a/include/soc/fsl/qe/qe.h
+++ b/include/soc/fsl/qe/qe.h
@@ -27,12 +27,6 @@
 #define QE_NUM_OF_BRGS	16
 #define QE_NUM_OF_PORTS	1024
 
-/* Memory partitions
-*/
-#define MEM_PART_SYSTEM		0
-#define MEM_PART_SECONDARY	1
-#define MEM_PART_MURAM		2
-
 /* Clocks and BRGs */
 enum qe_clock {
 	QE_CLK_NONE = 0,
diff --git a/include/soc/fsl/qe/ucc_fast.h b/include/soc/fsl/qe/ucc_fast.h
index dc4e79468094..9696a5b9b5d1 100644
--- a/include/soc/fsl/qe/ucc_fast.h
+++ b/include/soc/fsl/qe/ucc_fast.h
@@ -146,7 +146,6 @@ struct ucc_fast_info {
 	resource_size_t regs;
 	int irq;
 	u32 uccm_mask;
-	int bd_mem_part;
 	int brkpt_support;
 	int grant_support;
 	int tsa;
-- 
2.23.0

