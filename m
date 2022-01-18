Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532F5493018
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349638AbiARVnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:43:24 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:29288 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349572AbiARVnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:43:13 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IBseYe030788;
        Tue, 18 Jan 2022 16:42:33 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnbdu0rtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:42:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqcP5k+eBV9JvA116NSyl+gZ8g9nwOzLU5yZt2O3pppablVvwTtDzQpWhR0FPdqia39StBTENbMEJ/0Dde5KK2bVyLYqunmHe5aYcGsiDAZ275MG6o5W9BdU4kUe3bkgXGF6+p5WKwqs0XZUqxX5jhuBKgknsvtwNOQS9txSiW1zmz8DULFL7cvmGtJ2zWcavJOutV5NoUNp2YU9osWaCCAhtvL3Z4wwbPnSDDSmUlq5lml/8AFUcptkEX2efLYx7DSe26vVRBfwPO7WRtbAxpExEdTl5JRTrfaYEw+YiiGU1vUJ7RomPWq2MSpRKqn5J53azxieIgQXl4Wn56lJHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBEHX0+2KS7zBTGcTSZ80+5YmSccCTj2/B5Hu9dkVBk=;
 b=DpUXKhMdoUzeaB1GRPyC2tc7a8TCvL6mn4Kx8idnioKn/qKhYkgEG3AUJJCwZrFIFz/MvlqXEzLab4qkZIo4hMo1P51PmFqBcQzlfA5R/i0QMUzKHArmttlkdabsuzGGlHZO33kdAbIgNO5JbmemGZuVuTd1T6INJGEP95UDQz1jFuNf0uzxEiLc41gAHI78WzwhwIDEWeO8MEf5leCsH8a7n7gL30tRk2sMbI+jyuh5u7ylck4hkho/BwxLdYsgsAlksmIsgW1A5J9xMlMMYx81nrrqLfV2XwsTPiO7MfGWjgzL3znnz4WDLtWLxOJGZW19agRCOaJmqMPgKkwRQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBEHX0+2KS7zBTGcTSZ80+5YmSccCTj2/B5Hu9dkVBk=;
 b=fzgBySAPW759g6wPAODZuDE4O9eQmuIvKdgbwTalZAfUQBEn3idwRQbbH/XcYfprK7/HNHBJkuk3mK7U7qUB9ifT4+99zgSlv68BWdI09X+QPzwEOMyqQOBrs86jSKb6LQd0vDOakfta9iBAg3F0GVBJTRrVaODJ9WoxmLCWqYg=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB6003.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 21:42:32 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:42:32 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, daniel@iogearbox.net, andrew@lunn.ch,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v3 8/9] net: axienet: fix for TX busy handling
Date:   Tue, 18 Jan 2022 15:41:31 -0600
Message-Id: <20220118214132.357349-9-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220118214132.357349-1-robert.hancock@calian.com>
References: <20220118214132.357349-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:300:117::19) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26b64f9e-29ab-4804-0037-08d9dacb6ed7
X-MS-TrafficTypeDiagnostic: YT3PR01MB6003:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB6003A2C41C9E00591586B08BEC589@YT3PR01MB6003.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k+RNKoljgb7gnJfZUTQBNKnaCzwExuBNHLOyFFrCBlAdjtMjqGSgblrzVQPZbMzIZM1sKwq+o4Kigwi4DZQe6jtyONMWfzYCFOg8/q9rWxK7sbSIk7WEuy+go1egCjU+6aI8mH61yxxr609SbCoowUWif7n6KFFPzIPt92WuOy+6/HxVKkpjOwkpO0YcisnXu5jzi5pY7N9yCQ6w0UlAHvLn2WX9pqcom9sSrZsMYALgGMNCzxmhTxiGxwd+xvTqF9FpknQ8TOGwr2BI+AiN0KlKn1fga0aNWWktS+zFC0MskpZagTF7VT8g5/10PwRdGPVo/r8IgBdGYkugqOTYdexf6Ux4fnp9BT6QPpE2F/onealxWaYkjZx74xOQQajcYAN/1oo/7dBN9Svc1G7zprpxf5h5DiZqCrLN2AbjMVcc17hPkhF4eV4mY6nN6C5142UjHyA0Og79z8ghrjhOjg9d0x17PANM9nK7JBUgzI4FCT67RYP4sfEwqBeAUDbwNNtt25sKVLScPtR0kMRatsSBJ1JLlSnQ0e5JUo6j3MAjR25rI4nCkiVbG9V7Q7Jbqh1sUvkyK1TazoK/TlqqmYSUqNR7x/h8QRNaO7W5RxrPcFsWP9ObajI760Z+zUbxPVUGvyl2J/FA8Dwiac0upYf9aR1cwqK3JYhzBjVQLQLADZq7x608xZMPtiHNKAYmKuxfn1cDIxZdK2xPxyh/Ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(1076003)(66556008)(6486002)(86362001)(66476007)(8676002)(38350700002)(83380400001)(186003)(66946007)(6916009)(26005)(2616005)(4326008)(36756003)(508600001)(2906002)(8936002)(38100700002)(52116002)(107886003)(44832011)(6512007)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?34i/0YwabBUKYjrmQdtPlnukTnMtsQNoCTGIyWvSsgrTnPUX2Fghd7wifOnY?=
 =?us-ascii?Q?/DQnD/DZeUQvPQ5C5A3LSYiLUuFN8t9tcaAsa56UkHUdphFMDBYdn976dVY0?=
 =?us-ascii?Q?R138TanzjwMDnJ0FgyVPg/QxmB0DtSETinYwixr+u7B3yW9YaIZiSkASiz/f?=
 =?us-ascii?Q?vW/2EIBUjl2pUvHkmotkMtLpAQIYCqvVYFZZhQHlrMtjRyVSJVtD8zV/V5u4?=
 =?us-ascii?Q?RXPY70kyTmRruIj9nmts4MAS+sq5WI2TL43zBtmg3DRUwUxchpnz7764WmkH?=
 =?us-ascii?Q?6wOwZgmCkVpQD7ZcFRZxsbCGFNOTGZ1S9o/yXGI9RPMY+p4Gi2sefcW/4xSp?=
 =?us-ascii?Q?PDraAMRfP82agNqWIcT3Qg5ZGBAPs/pBoN600j0k1L35gTj898Q31Psh46H5?=
 =?us-ascii?Q?3wZEURbbbwvKoVEyvRoNVK2dfI/BmQWYBdSgnFC56ddXPdBFfIlgSqscz3mM?=
 =?us-ascii?Q?DuAZj4ha158dvZe2ggt5VThY4ITjlKiWdBeq/HhRJ6nA1MKRh/q4RmaYLUMc?=
 =?us-ascii?Q?MhiM+Tlx5gr0P2wNZiL+EyIDSyANlxFeibnUOxCSu6g2EvhIC08SXSxqdc8P?=
 =?us-ascii?Q?Ezv/BfDMOfsTXvHqsnS7+WpjcPvH2VcSMe5k9KOVtWOM3TQKS1fb64eIYQO0?=
 =?us-ascii?Q?ZutgHJAfW+wl64YIneCal3x5MH0hC66p/l36N/WIuBO82koHgEuEkoRxvOWI?=
 =?us-ascii?Q?uWSIH49/8OcVAfFMmok/TGotgmxWBAHDbWbj0MvWWxgk1lzXTyi2lvdfw7tD?=
 =?us-ascii?Q?wdUBxtvFw8qsVy1Z9lks4nO4KDifdyIWdWPLFBMBFsPiI0gTxZeS/h4fiew4?=
 =?us-ascii?Q?mAX1+OSqJNEfxBWwtkRIiVA0x2uqGMd2WqUKOmBSShbxJJTBKi2vhaP9c9zD?=
 =?us-ascii?Q?DGxnLTmHJj/uk9yVFIE2/7FZuzZgRIVzWnCHp2exu9wU4+B+/tcIuhhqTFCn?=
 =?us-ascii?Q?fdsJp47lGz8d07pLuDt0aRu4/kJSKOSVnTZVmpnmEyTkMT6jAbwRdOFpqoRs?=
 =?us-ascii?Q?T8mUM6lfIm5U6TvxNBi/2BZxhS21OQhi8eAKDjFGXCelmkfcS76gx00/enKe?=
 =?us-ascii?Q?KJ9ZgZvkBJsWSR2Qe2YCGCJALxUOghOSC9LTIKsejMVB3/2Zx/jbS5Oqmg6+?=
 =?us-ascii?Q?cV39blrn6gw5G/itIoyIxRpKL1nRRycrF8cVbrX0DJ0K+SSHW2hwsb5/RsJ0?=
 =?us-ascii?Q?b0YaI+eTx8Wl7vOX9+oL76GR1j3YfVvR3Wd1SO+34TnGJ+NoDt/GvX0w7PPa?=
 =?us-ascii?Q?MTkdn8ue/QbjH5eY9pN0sPjTz0QJxZ2sMcFQl4L4IfyU01KhbDUays1LIF6B?=
 =?us-ascii?Q?XpyFi8ewhFTsrX7UTRZpoL03Zve3zkTHV+K1AbptdXWVGe414wVcoaHvpg7/?=
 =?us-ascii?Q?yHWGGaVxGd89xxrPCMqfV/fPja+rg5Dsve9vNo+5Dn3lB/KxCppf+nhWcMuu?=
 =?us-ascii?Q?Wfxia9JwGy6pzSgTNGy8AG3EjlbzbIQCwtYdoLCzGsmt6471iWq5vo6HQEPs?=
 =?us-ascii?Q?rUwebc0q1uRIXkvhMtNUT0V0CdrkTpfNtJJzJ1fL9g6LfbmXLOBFCjBfr7zK?=
 =?us-ascii?Q?P7sknkhvdNHgFNkqCpVIOdoZl5t0pQjm/jY96G1mt7hRvXlm996O9+O+sjSD?=
 =?us-ascii?Q?XZltaArp9CwcWTnOCz4+gxfL4/il0r6832KrsJekfF2i0scE6/IShAq3VDSK?=
 =?us-ascii?Q?hbxxto6zMfLBctrqU4P+bPJZ0LQ=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b64f9e-29ab-4804-0037-08d9dacb6ed7
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:42:32.3529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RCZmjI9XvmYxQLDMEU67wZqD3GJ3zA/g6tdP7Ce9d3oBr9VZorm4JphWFnxbpDiJDmfZmxgDXnHA90ho2Rdfwpz2hhUocfXaVw1VsIJfgvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6003
X-Proofpoint-ORIG-GUID: K2CLDWFdhdbIlmbI3t_iPYGjBwuZYM8R
X-Proofpoint-GUID: K2CLDWFdhdbIlmbI3t_iPYGjBwuZYM8R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=675
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Network driver documentation indicates we should be avoiding returning
NETDEV_TX_BUSY from ndo_start_xmit in normal cases, since it requires
the packets to be requeued. Instead the queue should be stopped after
a packet is added to the TX ring when there may not be enough room for an
additional one. Also, when TX ring entries are completed, we should only
wake the queue if we know there is room for another full maximally
fragmented packet.

Print a warning if there is insufficient space at the start of start_xmit,
since this should no longer happen.

Combined with increasing the default TX ring size (in a subsequent
patch), this appears to recover the TX performance lost by previous changes
to actually manage the TX ring state properly.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 86 ++++++++++---------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 8dc9e92e05d2..b4f42ee9b75d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -660,6 +660,32 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 	return i;
 }
 
+/**
+ * axienet_check_tx_bd_space - Checks if a BD/group of BDs are currently busy
+ * @lp:		Pointer to the axienet_local structure
+ * @num_frag:	The number of BDs to check for
+ *
+ * Return: 0, on success
+ *	    NETDEV_TX_BUSY, if any of the descriptors are not free
+ *
+ * This function is invoked before BDs are allocated and transmission starts.
+ * This function returns 0 if a BD or group of BDs can be allocated for
+ * transmission. If the BD or any of the BDs are not free the function
+ * returns a busy status. This is invoked from axienet_start_xmit.
+ */
+static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
+					    int num_frag)
+{
+	struct axidma_bd *cur_p;
+
+	/* Ensure we see all descriptor updates from device or TX IRQ path */
+	rmb();
+	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
+	if (cur_p->cntrl)
+		return NETDEV_TX_BUSY;
+	return 0;
+}
+
 /**
  * axienet_start_xmit_done - Invoked once a transmit is completed by the
  * Axi DMA Tx channel.
@@ -689,33 +715,8 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 	/* Matches barrier in axienet_start_xmit */
 	smp_mb();
 
-	netif_wake_queue(ndev);
-}
-
-/**
- * axienet_check_tx_bd_space - Checks if a BD/group of BDs are currently busy
- * @lp:		Pointer to the axienet_local structure
- * @num_frag:	The number of BDs to check for
- *
- * Return: 0, on success
- *	    NETDEV_TX_BUSY, if any of the descriptors are not free
- *
- * This function is invoked before BDs are allocated and transmission starts.
- * This function returns 0 if a BD or group of BDs can be allocated for
- * transmission. If the BD or any of the BDs are not free the function
- * returns a busy status. This is invoked from axienet_start_xmit.
- */
-static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
-					    int num_frag)
-{
-	struct axidma_bd *cur_p;
-
-	/* Ensure we see all descriptor updates from device or TX IRQ path */
-	rmb();
-	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
-	if (cur_p->cntrl)
-		return NETDEV_TX_BUSY;
-	return 0;
+	if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
+		netif_wake_queue(ndev);
 }
 
 /**
@@ -748,19 +749,14 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
 	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
-		if (netif_queue_stopped(ndev))
-			return NETDEV_TX_BUSY;
-
+		/* Should not happen as last start_xmit call should have
+		 * checked for sufficient space and queue should only be
+		 * woken when sufficient space is available.
+		 */
 		netif_stop_queue(ndev);
-
-		/* Matches barrier in axienet_start_xmit_done */
-		smp_mb();
-
-		/* Space might have just been freed - check again */
-		if (axienet_check_tx_bd_space(lp, num_frag + 1))
-			return NETDEV_TX_BUSY;
-
-		netif_wake_queue(ndev);
+		if (net_ratelimit())
+			netdev_warn(ndev, "TX ring unexpectedly full\n");
+		return NETDEV_TX_BUSY;
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
@@ -821,6 +817,18 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (++lp->tx_bd_tail >= lp->tx_bd_num)
 		lp->tx_bd_tail = 0;
 
+	/* Stop queue if next transmit may not have space */
+	if (axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
+		netif_stop_queue(ndev);
+
+		/* Matches barrier in axienet_start_xmit_done */
+		smp_mb();
+
+		/* Space might have just been freed - check again */
+		if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
+			netif_wake_queue(ndev);
+	}
+
 	return NETDEV_TX_OK;
 }
 
-- 
2.31.1

