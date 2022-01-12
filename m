Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A3648C9EB
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbiALRia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:38:30 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:11731 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240793AbiALRiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:24 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6ssh020480;
        Wed, 12 Jan 2022 12:38:00 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2053.outbound.protection.outlook.com [104.47.60.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg53m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:38:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZOWluWWVNxLQvgCtUbJIU0coxNP1USJWTHLXojNN9AvaONvEIXeNmOCqM5R1/+Rfh9a7iP+mUle+npFpA16AmcbAe/LctJCrze2o6235CI5zlkuaU84im5V7AnA4PuvJXAkcGflNdfGw6jrY17UxX5NZLJAC2A8ew6r5SMnNsEu3W+ATaawAszczJYPnThpmqfmd5bSgmWnKqHFA6rmwkqUcK8kxX2iHNv17M7xKER56t79KknFtfm84dzlIhBY2HUyRf7OTOgt5As0mNf3Z1L/TaMNGZf3gu2vBwn35zx1i+3sX73ce3L2WuSZCkxFRqrtASB5zXGubOzQm6PamA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPp8Tc5o958at93hIiyc4I29AVhusfEQyWU5KGxFcNg=;
 b=A1aZkzxZFWdDkoAH0+FpkJnVymj7DHCLo+LS63pwmqXvfOszkmyI5jFlmVoHrblr4AzT79iwojd6PXQ9mHeHaqDcUDNUVB6wH+3x1vB2bDCp0xqROzxKNoTNAQmXfTXqZfivMiattwSqIgbSfjJsr9tdgaAxcLv3c4OV50iM3jydiL8cczTDAKT3jB1itNSK0o3/1sPpwoKWmaJx5jNgx4axMN+dw230USND2xJ9xfcfdE4rnKnZhC3uky96FvH5F8l0hd23NTxSmxce3njC3hrENP8smQD6RA/LuUWkuGUf2uFOz7J29iRm8ANnUo0rN18z0sjnoa8SvXjmSodcCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPp8Tc5o958at93hIiyc4I29AVhusfEQyWU5KGxFcNg=;
 b=BvbwNmxlNli7J0X8EPw+iWWbDKXLKkhkKN4RqrinxrUqM+zcLdbLPHHppdt/i5KUvG9vYW5o7wLWmbQ0S3vZ6XUhllr+SPnuAvv603Hzf6lskv2F9X1sp7KZdOuIhumfNqeBNQf6jX5xErRcL+qSod0p6c1qq6fhkm5DChtinnc=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 17:37:58 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:37:58 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, ariane.keller@tik.ee.ethz.ch,
        daniel@iogearbox.net, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v2 4/9] net: axienet: add missing memory barriers
Date:   Wed, 12 Jan 2022 11:36:55 -0600
Message-Id: <20220112173700.873002-5-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112173700.873002-1-robert.hancock@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:102:2::29) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a574dfa5-533c-4977-c21c-08d9d5f2462e
X-MS-TrafficTypeDiagnostic: YT2PR01MB5789:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB578939C8273CD7995AA90532EC529@YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ND4y1aIVp1yUATY0XjgAMEH88GVV9uUhsPNQgmqvf/zUVwN9y/YPMbQ/oVFeu3pNI4hLNXEoYG4gMXFP+B9jvc5k3gMM21C0byeJQEMxdHxm6pSZdBYfLlgwylOG6v4XPUz2sVuLnrmP6X35jrbplNwzf4O+fSUOhabyQRrHSC97rBDidEB3B/7XK0gH6/6/74S1RhdBAo66Z7/FwloSS1Ze0G3TTAeyQQ5cPHmuA1q4q77a+IJRtg+TDnHtybjH85CdfrlDUSoZl8QrrcfwRW0ajACTtduZKAMRGkfRMc6oM6gznxtceSbcMTWR7gCGqtV83Uj6GaiMH34c4vVWmZ6Lxx2pUd1JAOb/zpxuE8W3/sONr10buFeZ5GV+qh5CBcM9PhWLn4Y7uMI7UzQHDzc//I3b+JH/PiicErcoFjNt+MDMp+PVmG7cXjF526VUEsLucHIVFxkdwhPXYdPsECK+C7ZGkYxusPlYKaSz9KkTZfaS+xiHlcmEdjBG0uzJixFAayTQ/SItjjBCbLVxmerLwbMS+pI6gHRmnmoE5qadRAd1h2O8piWZbxhLmChAYdGZNxUS9o1aqUc0Nl8WSllJYMSN006B+LGKbfFjaoUBWioKVWyMOP5DQb3YqqI8rTJcSURJkh15MLj95p9QoyeNiiyGfXdlw4CligciJQUNRK2bvhyIgVwrtSX9V1Ce/pgB8RieSS4NBpI3kmGO+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(38100700002)(66556008)(66476007)(5660300002)(38350700002)(44832011)(86362001)(316002)(83380400001)(36756003)(6666004)(2906002)(2616005)(6506007)(8676002)(186003)(6512007)(1076003)(6916009)(4326008)(508600001)(107886003)(8936002)(52116002)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cHUgQVzFHLhY0HGlX+fg1gGSojJ5qj7DkZYJ4+0W+g9AVOso/hK2gPpvTgH7?=
 =?us-ascii?Q?cbZeiSC2bsv2ZP1Fhb5C5Nu6XJ3p3zKxBDmz+4HCpccgPGwqGXf+QqBnKe7M?=
 =?us-ascii?Q?gL5zzVL/GobRjlUZnKqrM/pQC99xU2MqrHXBL+DNs+qdX+rgQOqIXJfZrJNT?=
 =?us-ascii?Q?Fj5MTKhQY/F2Xgj1A37dHuCYiGPWnXq9ncIfxju2LDTsffWANXux1/woA/t3?=
 =?us-ascii?Q?30825poqWvjbQ+Wx1SQnYuMh8FrL2dzV7Edz0r31ipsAi3HbPIK8ulYC9yIH?=
 =?us-ascii?Q?6UgfTve18P3/R0IJ8YheUHGelxUhsA64eTc9fJ5oEcClzmDErUvrAbefj2dO?=
 =?us-ascii?Q?0WFEnmQdW35mYCXRJ4Q9OvW3rflMjc9rf7aTsSZMVizL6RkOCrkHW3hZ7Y+S?=
 =?us-ascii?Q?aL0MdO5UigTSbIPQFLHd49B+JFKE9AQwd54L4vQW00Mie4akDgWUkUi9pPZM?=
 =?us-ascii?Q?1DbGz/m59/yqYzUOkzCpFld0AcAFLqjZ9f8NfpMYhxQHapDw5/ouJZkLgIjF?=
 =?us-ascii?Q?QZFjr+mcWwLojwuFIxmCle6mJCgdxMFLsBNA+fO1xSQsJdr6IjRwRJ45j3Cv?=
 =?us-ascii?Q?RFJP4J7lH/5R4k0Iep9nW94jIxoSWI+bt2VDp3GnK2y3wIweU19cePb2Xtru?=
 =?us-ascii?Q?6bI3IqJhzWs/7NvKAXjZJNr4dRgQBCl9GgzD7sAsaIQOa5t/hWaKMPPFJVWR?=
 =?us-ascii?Q?4EcwfAiLFjXMoN5V0U9OS2Y1Z5c8k9SwmUX0y7/fCCPMfggBKqwrdQm6gbVW?=
 =?us-ascii?Q?4L8y9TZ2gHIOC1S23Vz02KPsFbVOVbQab+jmL510G3EwaYOQHN0WDRXC1lUX?=
 =?us-ascii?Q?KReZDV4nUUVueeTvyakOvr5m/+qfNMfwuo7h6ie4v2ceAYKnPYv/J4FbN8K1?=
 =?us-ascii?Q?0fIQl3vJ6YM8Lism5GMLBvpDHAaBeHGVh8BxdVHM6weAcMPnh5NtTMfx9jCg?=
 =?us-ascii?Q?Hz/GBJfZIPPL2qIhirpggrNx/dfYuz7Ixdez8vsUVK1+fYOyi2H1t27y2DqZ?=
 =?us-ascii?Q?UJkVl5/6zGbMjAzAl8zF343RNDbL551XTmgXX+bWcUv8Tt1fvnijsc/qpnSO?=
 =?us-ascii?Q?fklEIHIvZnXv1PDfgkuOh28ypOOCG+LKViXoOW7r/SydYs0qCbUHnGjNSQBL?=
 =?us-ascii?Q?fatQx4R51HAF08BrP+kV2omh38zBLCEdZlZQySctkdHvSHmEdVRoniZ5Bigc?=
 =?us-ascii?Q?OOJrNG7cODU+wU+DPnBmpxwqGJTt4I0twvGJYfkTEeI5k3qOG3QeG7NWj8Xt?=
 =?us-ascii?Q?ZkKOmV7O1ubycdVUAKYQKPjbG6irdXLHBRJUwelWa9J5Bhy3MW7fsjqWvqgU?=
 =?us-ascii?Q?4IBKIWNW4edmLwNB7DzZOFyd+oWduWywNSdxeYF/vGdpHhrIezExekCE2ZVO?=
 =?us-ascii?Q?vQ47ZtuyiDhwpXKp7+g5wAXu6+deR8JT4escjrueLU1aF9PKwpA7U6UqR/Ys?=
 =?us-ascii?Q?zNMImyYILckwEzNYGIjkC5aDgt6ZJtc7bhedoR/4bkUQ6qA8a2Phyn2N4Ljr?=
 =?us-ascii?Q?fMbE9yKfn6faAZnLRYsP6MlyxNz9oqY01GPCMxZu2FhgFdfLd+zY0bY/v3Bp?=
 =?us-ascii?Q?1C4FJkvV7Wyqrjz1Jpp+uESmkmt6j/9U6+MoJW3WdLbzQFs7d2JsHXsyRPef?=
 =?us-ascii?Q?oiEoFWUVlKw7dD81uwVZFm+tEOmg0bDl6xAESDONAYZD8xD3vZUd4XNXYnSA?=
 =?us-ascii?Q?PfoVGlNy0kBuv4gDVWo6QdHAXXE=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a574dfa5-533c-4977-c21c-08d9d5f2462e
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:37:58.7000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWGY4/JBychwH5EI9cdHhVqYSPPyDNQW3K5OKKMrfzRQcd/LBZII9PM2JE02xq2nMK529vjQIjYZxM1oK9gH/aKedBUl0bwi3cHMNukt5yk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5789
X-Proofpoint-GUID: jrjFn2xD_5fPfiUNFk8GvnshAyg-3Uqs
X-Proofpoint-ORIG-GUID: jrjFn2xD_5fPfiUNFk8GvnshAyg-3Uqs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=658 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was missing some required memory barriers:

Use dma_rmb to ensure we see all updates to the descriptor after we see
that an entry has been completed.

Use wmb and rmb to avoid stale descriptor status between the TX path and
TX complete IRQ path.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index f4ae035bed35..de8f85175a6c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -632,6 +632,8 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			break;
 
+		/* Ensure we see complete descriptor update */
+		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
 		dma_unmap_single(ndev->dev.parent, phys,
 				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
@@ -645,8 +647,10 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
 		cur_p->app4 = 0;
-		cur_p->status = 0;
 		cur_p->skb = NULL;
+		/* ensure our transmit path and device don't prematurely see status cleared */
+		wmb();
+		cur_p->status = 0;
 
 		if (sizep)
 			*sizep += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
@@ -704,6 +708,9 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 					    int num_frag)
 {
 	struct axidma_bd *cur_p;
+
+	/* Ensure we see all descriptor updates from device or TX IRQ path */
+	rmb();
 	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
 	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
 		return NETDEV_TX_BUSY;
@@ -843,6 +850,8 @@ static void axienet_recv(struct net_device *ndev)
 
 		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
 
+		/* Ensure we see complete descriptor update */
+		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
 		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
 				 DMA_FROM_DEVICE);
-- 
2.31.1

