Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907442CFE3B
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgLETVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:21:30 -0500
Received: from mail-am6eur05on2101.outbound.protection.outlook.com ([40.107.22.101]:29825
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727617AbgLETVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:21:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYbRdXTtn+rtfBTTrOryib5COwUcIO4+Vzp0vm/Ej5wppFZBeOwkobitCZ7b4Vf8FzESkk9dnMBDRDOi6M+2plCDp+Yl8suqmAPYpKJ42rIGk2kqJi8CREYAEgZgTb1igftaHtoUPSgFARXOfzrMLdik3R6AgtaFSv+cnlic3J6jayfQ0C1qUv+rUwQlcCrC2nLuUYhku22yHlCrQTH/JsLn4H/EjG+i/zHFYNAYgG0dOLwjyrwUHw2pD8IEJzF1yY4V6cwHNK1Ov4/URR68rqri+LxF+AIKh8w0mKZvMB+EaHIvQsUchE0OE9udEn9nwW3Py7G+/UxVeO3SFFRTwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeN2AlPjU0c5pg7bkGqjZD3dGtPUguGMwruy8BlWpaw=;
 b=jUfjajfYncMlr1Itf5y5vyj6qY3xlVsNhbdVyU4AmzQjdQFd801+qX5n5OkRd/xExVSQiZpdhwqT0LHWgwABbENEOl3hEhntA3Im/J/u1rrftYtAYGg6m/CzkLCMJmsuuA4xG8tAL5wtkw3NwyvEO0RAehobnAzMjKna0olL4gzAu8ozRrSFrN3L/yWFUEVTHonXOXCUzHeECQ/eTnA4OXERp5vQcbFlSb+dvS8emxy2NdGtl8NAgVzjfm+8U5sg3EWEIj2bBhqktnGh8Tj1vlmlM6uvfdBvq2S2mHuou/rlNg775POi1TJYHhUfX/bCcU7d1TxsuTXaXv4i5USpYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeN2AlPjU0c5pg7bkGqjZD3dGtPUguGMwruy8BlWpaw=;
 b=gsYs5U2QdfYZ8Ejx4KReH3+AMNPNswMhtgoeKpr6rqR7QMF6hhhrHeTeSpC69c8nlr9UfPjkBGpLVo/3/GZVjaR+oCNq8pAyhFredpxorlqf1QMiMHAuv6ZuanTxOX9GEM5/npYpQcrmRjec0/GJbwvZCbjyaew4CKiMP6fBZBQ=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:34 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:34 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/20] ethernet: ucc_geth: simplify rx/tx allocations
Date:   Sat,  5 Dec 2020 20:17:43 +0100
Message-Id: <20201205191744.7847-21-rasmus.villemoes@prevas.dk>
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
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6c00743-aea5-45a8-0211-08d899528f45
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1363B91125F873395D2E905893F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sc8AUr1hzFhSHpdVcWhFHT6JQN1tFHkJ7OC7KuEtk98t9r2DfmJLGXtU7OFvhdarzyyYT08R3kCRu9377v1Fc0pg0Xov7Ku6GviSnuVwP71oTVk5vLDXoQFUtvOqUUD43hxzwSRlzjI8d/W6ESDr4fOVcEr9ujgN5PCFRKmP4iRm2j3h0cETK/b7CVt6eYr9novJhWrLVj3ct6XNuiZEcfNxRG1K+yY0CGr6q1AjFhCZpMSRl4JuGe7D/FJZY+IR0nb+8fDK98xJC/FUccq/EykzugCob680J+rI31XSfv4VPo0O6hsYV6ZxPwoBAXHmGZ8fbMulQTfv9tkC+q6/6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YJLpbRyFUvtyvCxGmp4CI4TtwLKuf0jpAqkJ0XaLCk82LkE4h98RfEjJWvTx?=
 =?us-ascii?Q?LrGuNOKpr9zIP5NoLfmKK/Yl8zeIxP7DQJrMjOZ8ighkmL5HPiIbbRGqXe3h?=
 =?us-ascii?Q?MXbw5P7xL/5BSSifYbI+n2jNFxEzeQ+mMnkum7R2GY/t1b3GigsuYK7q+13P?=
 =?us-ascii?Q?8rHAnLSnGDT3wamPhNp8vZg2zQkJH0QZe+eZf2lTx34V30a/Z+VMdq3YayO+?=
 =?us-ascii?Q?iQtvz/ZrekJ4Y27M5Y0eAzkXIh7nyY1OPVh2gakzbklkkfa6LQh9pb/jVVOR?=
 =?us-ascii?Q?z3CIsO8dKR9665kYvWBtVXUDOcv18FQOCPyZfj6lV+6YRfJU4rMOT0hhXJPB?=
 =?us-ascii?Q?LFd9Ax7sOMVQKGdgNBjBOuspIR0ENlgEKryq7MjQWpfzwR89Srlw7tI3XV3f?=
 =?us-ascii?Q?ngsLRafIp4QpaYDdDaZG6DCXaSW3cTVnA2zcTO4hk2Y4ff96rsGdAmhRgYqH?=
 =?us-ascii?Q?82U3gnjP+CsVUp8bZzOqAQ3oXVKnsb0FDs1YTJV+AVe6s8MqqnSiqNi7OAmq?=
 =?us-ascii?Q?Zru9WoTLpw3SpL8lGnJtRalzKHC3UM9foWRC8/OyhapuLC4ELsNz2zMpA3Qy?=
 =?us-ascii?Q?oUabgMshn41J7XglJpbBjlQhsbZ7MfaaUn4C1I6QrN8sks863hLVCrJCjZ20?=
 =?us-ascii?Q?kby0QLVXVRFXV1+PNZhMrvULB+JF9KaZktT2MzRUpjs94VTgiXNkKpDQ7iC6?=
 =?us-ascii?Q?wsJUZR4AxON2nzJz/mNwuz0ZRuD2eSD0I7b4prUD8PMEwUFtkywU6P8+zfP5?=
 =?us-ascii?Q?mygxGCn/EkGAnBIjn3DW8eZ6Vq9qevFpcXirZHwJgslBIyal+z4ajDWQ1kGE?=
 =?us-ascii?Q?05i3+8A6rXVeZKplBmVtMwq8hB6bwlVY0XpTFX1MLH5InHyxzHFgnUg/OZD+?=
 =?us-ascii?Q?sjnxX+Z8uNQZ9y36wBSqq39ahEHsWhfAlFlIxeNFQ7qWCjzkx6TMD5OmRRwM?=
 =?us-ascii?Q?haJFcAHUubOpXsaBq1PQO0J5eE2wzqV+Qb0feh+VwMLACy25nrl1LPG28EiT?=
 =?us-ascii?Q?X26x?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c00743-aea5-45a8-0211-08d899528f45
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:34.4196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gaBf0nuCAQmlVhRLl6mylJxCGPQB66sJAef1YOVA5tEGxVyxDiV4hUj3kwXgTSnGUTCafCy5U4YeMw1TNnEIaj+8de3Fe/syx47CRZcBVqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since kmalloc() is nowadays [1] guaranteed to return naturally
aligned (i.e., aligned to the size itself) memory for power-of-2
sizes, we don't need to over-allocate the align amount, compute an
aligned address within the allocation, and (for later freeing) also
storing the original pointer [2].

Instead, just round up the length we want to allocate to the alignment
requirements, then round that up to the next power of 2. In theory,
this could allocate up to about twice as much memory as we needed.  In
practice, (a) kmalloc() would in most cases anyway return a
power-of-2-sized allocation and (b) with the default values of the
bdRingLen[RT]x fields, the length is already itself a power of 2
greater than the alignment.

So we actually end up saving memory compared to the current
situtation (e.g. for tx, we currently allocate 128+32 bytes, which
kmalloc() likely rounds up to 192 or 256; with this patch, we just
allocate 128 bytes.) Also struct ucc_geth_private becomes a little
smaller.

[1] 59bb47985c1d ("mm, sl[aou]b: guarantee natural alignment for
kmalloc(power-of-two)")

[2] That storing was anyway done in a u32, which works on 32 bit
machines, but is not very elegant and certainly makes a reader of the
code pause for a while.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 50 ++++++++---------------
 drivers/net/ethernet/freescale/ucc_geth.h |  2 -
 2 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 3cad2255bd97..a4ed9209513e 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -1835,7 +1835,7 @@ static void ucc_geth_free_rx(struct ucc_geth_private *ugeth)
 
 			kfree(ugeth->rx_skbuff[i]);
 
-			kfree((void *)ugeth->rx_bd_ring_offset[i]);
+			kfree(ugeth->p_rx_bd_ring[i]);
 			ugeth->p_rx_bd_ring[i] = NULL;
 		}
 	}
@@ -1872,10 +1872,8 @@ static void ucc_geth_free_tx(struct ucc_geth_private *ugeth)
 
 		kfree(ugeth->tx_skbuff[i]);
 
-		if (ugeth->p_tx_bd_ring[i]) {
-			kfree((void *)ugeth->tx_bd_ring_offset[i]);
-			ugeth->p_tx_bd_ring[i] = NULL;
-		}
+		kfree(ugeth->p_tx_bd_ring[i]);
+		ugeth->p_tx_bd_ring[i] = NULL;
 	}
 
 }
@@ -2150,25 +2148,15 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 
 	/* Allocate Tx bds */
 	for (j = 0; j < ucc_geth_tx_queues(ug_info); j++) {
-		u32 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
-
-		/* Allocate in multiple of
-		   UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT,
-		   according to spec */
-		length = ((ug_info->bdRingLenTx[j] * sizeof(struct qe_bd))
-			  / UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT)
-		    * UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT;
-		if ((ug_info->bdRingLenTx[j] * sizeof(struct qe_bd)) %
-		    UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT)
-			length += UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT;
-
-		ugeth->tx_bd_ring_offset[j] =
-			(u32) kmalloc((u32) (length + align), GFP_KERNEL);
-
-		if (ugeth->tx_bd_ring_offset[j] != 0)
-			ugeth->p_tx_bd_ring[j] =
-				(u8 __iomem *)((ugeth->tx_bd_ring_offset[j] +
-						align) & ~(align - 1));
+		u32 align = max(UCC_GETH_TX_BD_RING_ALIGNMENT,
+				UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT);
+		u32 alloc;
+
+		length = ug_info->bdRingLenTx[j] * sizeof(struct qe_bd);
+		alloc = round_up(length, align);
+		alloc = roundup_pow_of_two(alloc);
+
+		ugeth->p_tx_bd_ring[j] = kmalloc(alloc, GFP_KERNEL);
 
 		if (!ugeth->p_tx_bd_ring[j]) {
 			if (netif_msg_ifup(ugeth))
@@ -2176,9 +2164,7 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 			return -ENOMEM;
 		}
 		/* Zero unused end of bd ring, according to spec */
-		memset_io((void __iomem *)(ugeth->p_tx_bd_ring[j] +
-		       ug_info->bdRingLenTx[j] * sizeof(struct qe_bd)), 0,
-		       length - ug_info->bdRingLenTx[j] * sizeof(struct qe_bd));
+		memset(ugeth->p_tx_bd_ring[j] + length, 0, alloc - length);
 	}
 
 	/* Init Tx bds */
@@ -2225,15 +2211,13 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 	/* Allocate Rx bds */
 	for (j = 0; j < ucc_geth_rx_queues(ug_info); j++) {
 		u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
+		u32 alloc;
 
 		length = ug_info->bdRingLenRx[j] * sizeof(struct qe_bd);
-		ugeth->rx_bd_ring_offset[j] =
-			(u32) kmalloc((u32) (length + align), GFP_KERNEL);
-		if (ugeth->rx_bd_ring_offset[j] != 0)
-			ugeth->p_rx_bd_ring[j] =
-				(u8 __iomem *)((ugeth->rx_bd_ring_offset[j] +
-						align) & ~(align - 1));
+		alloc = round_up(length, align);
+		alloc = roundup_pow_of_two(alloc);
 
+		ugeth->p_rx_bd_ring[j] = kmalloc(alloc, GFP_KERNEL);
 		if (!ugeth->p_rx_bd_ring[j]) {
 			if (netif_msg_ifup(ugeth))
 				pr_err("Can not allocate memory for Rx bd rings\n");
diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
index 6539fed9cc22..ccc4ca1ae9b6 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -1182,9 +1182,7 @@ struct ucc_geth_private {
 	struct ucc_geth_rx_bd_queues_entry __iomem *p_rx_bd_qs_tbl;
 	u32 rx_bd_qs_tbl_offset;
 	u8 __iomem *p_tx_bd_ring[NUM_TX_QUEUES];
-	u32 tx_bd_ring_offset[NUM_TX_QUEUES];
 	u8 __iomem *p_rx_bd_ring[NUM_RX_QUEUES];
-	u32 rx_bd_ring_offset[NUM_RX_QUEUES];
 	u8 __iomem *confBd[NUM_TX_QUEUES];
 	u8 __iomem *txBd[NUM_TX_QUEUES];
 	u8 __iomem *rxBd[NUM_RX_QUEUES];
-- 
2.23.0

