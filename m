Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2612CFE35
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgLETVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:21:05 -0500
Received: from mail-am6eur05on2119.outbound.protection.outlook.com ([40.107.22.119]:7011
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726791AbgLETUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:20:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekosH0nbvP2bQzAvj82iyz1Bg5mGtqYQl5D5mpdVcrOOE9aIBKP6hBk+fqN9C91efxclGWjiMMlGJ7+J4maunVMW7CTbt6V8kizGaNF9d7mNLw8s47DI2SiN6lPwgMT1t0Rx/JIoGudwS0MTb1zf/Y8zKH5AmjFdroI487DC7YnOwN+6vLbKlVes9I3KYZrwsYkk7nYVMJK+5PRF8WO/OUFySYmoVm8m5V4JHXsw0CdeJToOc9dIQA9v7XTO0v1rx5NKVIqu+fHqwno0IyVns8Hn/WAIBYpjWXXqmuSRH6l1kiL1xyeXNX05PwktTIVZqUBtAfzbRePGnflDYIxa+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5cT4lWb1TOoDsBju+zP+BzDu+mFtQHaoAEkftazw2A=;
 b=P+0HBHf/DFl5YbxxeUdKtBKI9ehGypA5EWVAMEw+QEIHKMdlsVyi8oxkWSodu1PaQv8ovgW7RDHHzBOZ2aZy8D76F3MNm6IPztHLviKUVRrzFvSz5G+IwLD5svmWdHDaVYRrvBflmWxkzZQ+IytrpDwy3/VEs8l+/TE8+dblO/tse1htWFs2r6FlPgOi/Yw+lczfduZHYhGAu3WblYQbyXPLLcqmfeY8kVDjnZirMIIJ+AlqDnEMMp+zNOKdghjZzDh+0wOENG+zGgyHWZuc7dWJoNKfnCxi5Hn46D5lXXFofus2l1U3V/HH1StgyyvHZbQaofOSVHHdOmrvPJpmvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5cT4lWb1TOoDsBju+zP+BzDu+mFtQHaoAEkftazw2A=;
 b=kpnHeiJnC+fkPyqQ8KCdDAOTf/D0Yhsxfw2+K/JVx3u9I07y6jPtmanJOm1DvNRJAQwl/FbIW3N4OKD5VpUIlFpvSJp7tlC/7wpUeEaVwpKTT9xfYOlA6Ga4vMsvpx4vqZqUFOTKBICThk7knqDew9TsCV4qNdMFYRY9UXDgGdA=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:31 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:31 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/20] ethernet: ucc_geth: remove bd_mem_part and all associated code
Date:   Sat,  5 Dec 2020 20:17:39 +0100
Message-Id: <20201205191744.7847-17-rasmus.villemoes@prevas.dk>
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
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50ebd930-5c7e-46ac-7467-08d899528d3b
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB13633C60B30D2BA25409C88E93F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fmJecnkWEd67/z8T62dy+01LsbOoGK78+RWZPYjAxPIREJSco6tAhdaywDz+M2X5rogiExNsLeefDAtX0UoJxALWiXg6mmHaai1Bo6l99S3pYMnkqu92wKcN9A1bRzW3pQc7ZdKU7MdR2R4VtcRhs8hSh6K32wQOQNvoH3JO7Df4CICAMG5txIW0YZK3O0cUbpzvkw2J8rI7RPx/QDwkCAQqWRuQTVtW6pxbYnW3vFBuGlj3wluYhFmrUvCPzx2Qrh7GPEpQS/+kgTLN69wjwo8nk7dFJ+CmxS6EhedF/JOxLNO6bHbdnPfJZZobva9wXo6HCmmnqN9H3Gke/IUq2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uuZQHVKQpRG8HD50dFELlBhFP0TP6N0Lk7wqcFWFUAefODgB5+Ab8v8tWpL0?=
 =?us-ascii?Q?8X1d/OfAm+yvvN3ywWka/afuxDHqBKYQ4TXbC61SeJedtCw7Twe282ZFZxYq?=
 =?us-ascii?Q?CrCjQxmf/NdUOiH0P6khO7pUK5YzB4Je/OJGDFi/9qim84o7+gkzF63FiXIt?=
 =?us-ascii?Q?PlyJ6ASmCpkfrL21mJc+96YmXWwoBiUX1l7ZlKs/d7WrVhQUoPXHdZka8r2M?=
 =?us-ascii?Q?6f9/uq0nWWPNx1CgvFBrZt/Q9JoQEK05zlUT0l7S+gyURpnAfVUyaXLP3EXc?=
 =?us-ascii?Q?es4Joaa/cRN2pmkYdz9Pilfymr8s033qQi2O+wrv/CgR46s7RM7R/RmPOIrr?=
 =?us-ascii?Q?hXg+qwWqL4Ik4WAu5nEqBk+Ko/x4Qnrpn1KkQSc4a2+D4wfYZCQZnyGT2JRt?=
 =?us-ascii?Q?YO4ksebKV8GJkWxASI3f3bfXVpmjdKOzwnuhelj7jnLh/j5rBbBhHtGaGw2T?=
 =?us-ascii?Q?R/To+p3WrXQvwpRlYWocwCNcaiEHEoutTOP+AFFpeHEqXd8TOthvY0KeLzjF?=
 =?us-ascii?Q?3RiTMA9n4nNrKcYF1NzfC+G7qfg/wRnv7+IE0oQW6uMYWvyBvf5WzdjMIwjI?=
 =?us-ascii?Q?iVGPCJP/WJYsQDClUx1UGP+TqUS4BlklhZtxdMv1KXZsqCCThisbJpEHyBZQ?=
 =?us-ascii?Q?PUlyGzTVULHeXV4rSwSGcF/iMzQt95WcIOBv0vPuwpifjIGWkP1CIsrmKGYc?=
 =?us-ascii?Q?Yp+YFqU6b9eKIb3UmYkR4eFLIoc4EwMTk5RXxqKrdNPN9zrBRGMHqwYB9J0q?=
 =?us-ascii?Q?slWuE0UjlWJV2OdzsNblG5y20JP7Q+3dBvIVWfuP15chGnUbGWV1MdSP7b64?=
 =?us-ascii?Q?cNMal5FqHrbj/IjKPDzxtARb+qImfzARUSf+uYNHPsEC9yz2dADSkd+E9hJe?=
 =?us-ascii?Q?6IdRtHuzI/fHkmQJVtvD+hi9rxmB/KyxOOabwfCnlDazPB9qb+S+omNwB9HH?=
 =?us-ascii?Q?yWDecbimeMNxT7Rou2sC43f4k5p0eIcULLlV8i7wf7+TP75JIZI7O7ZCWNH3?=
 =?us-ascii?Q?cHU+?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ebd930-5c7e-46ac-7467-08d899528d3b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:31.0496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTCez1hgKvnAH3OrDYzfaOT8PDkI/jpWqOAnXGP5uerz3bMvrLzS667SRz4AYHiyyk/WRgnkuUmWOCMVxbs6KYQ9YgsjJfYvxYi12qbsDq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
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
 drivers/net/ethernet/freescale/ucc_geth.c | 106 ++++++----------------
 include/soc/fsl/qe/qe.h                   |   6 --
 include/soc/fsl/qe/ucc_fast.h             |   1 -
 3 files changed, 29 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index ccde42f547b8..c9f619908561 100644
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
@@ -2195,24 +2179,15 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 		if ((ug_info->bdRingLenTx[j] * sizeof(struct qe_bd)) %
 		    UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT)
 			length += UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT;
-		if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
-			u32 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
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
@@ -2270,24 +2245,16 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 
 	/* Allocate Rx bds */
 	for (j = 0; j < ug_info->numQueuesRx; j++) {
+		u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
+
 		length = ug_info->bdRingLenRx[j] * sizeof(struct qe_bd);
-		if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
-			u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
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
@@ -2552,20 +2519,11 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
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
@@ -2784,14 +2742,8 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
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

