Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DDC493015
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349682AbiARVnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:43:12 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:1131 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349550AbiARVmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:42:49 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20ILYMwr026521;
        Tue, 18 Jan 2022 16:42:31 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2057.outbound.protection.outlook.com [104.47.60.57])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnapfs2m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:42:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLTERn2gl8B7PZrTwDOBfikeDdmhuyqTNvYCSBloEP7ymuvtct5POpuyD2ut2W7zVwpApu2feMG5FZvYwIwE0vUuUMSMeYc7kbRAE7uzIvNNTQtyQDmw05oDj25c2bvPLzHhW3XqSEBPRxMb6FNxIJcoJ1SlRO1zuoZOLa7tXg6oe5autdLlNL1PtzyFvRg+1nGWFYWfd8WMCLummloY5PCpFLcD3l00woMFXIp7SKBW02/jcZjjCbMDhNiHh9lEZ8gIQ+iydreIeyroGnAbGnvjQIAlz8V3b9m6M4AOXMMZv1SRomSlrQbkbAicyHmovQBN7CzAmtJk+qHSpgx0rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1leo7FZYKMIKVIx6OVkLR4wHxprjP/g8VGKrKoIv9TU=;
 b=U7yysgpwdhXGfLjMBBhgJKU4hmlMmlKQ12CbVfWITazt72yOKqrF5id/7fZ4gliViwsnTwhBg2S7AcqxBxU01akgJBDP/cS9LJC8sgzpc30Nqn4U30SyANUaV+FN8I4TyeY7PImfZhC6stgUvxEUIvwI7rBk5IiRkzjuI2rkabrCQGsAEBMaurMnAh58znaNJNM/WDwiMPiAKhPTqwV4CS8gI4KNevswGTIzJr7agoy1kaQwEUry0kHg7aM3CU+Af0vOrVD0XvXI+uVLXFTD4FAg3XxkCDErkQiMCSdHg6RP8Sx+NyOxVK5PKatMQw30ytv9ARIDB4PVLnuDw6kwIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1leo7FZYKMIKVIx6OVkLR4wHxprjP/g8VGKrKoIv9TU=;
 b=rtdUqoQZKKNGESMp5Cpv7KPvBu3hnA6bZ6PEtQ/mnRY0Y+kPwx8iOEpfGAelfZk+7Xso3k4c+zLfA/80g9RaKUykdm4+M+SalIubgzD9yjG85r1j2jqUIBp9gvegMV9N6Tk9Rj9Lvbn0bNq98smwKZebzPUV3qp6E0BayUM7hTQ=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB6579.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 21:42:29 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:42:29 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, daniel@iogearbox.net, andrew@lunn.ch,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v3 6/9] net: axienet: Fix TX ring slot available check
Date:   Tue, 18 Jan 2022 15:41:29 -0600
Message-Id: <20220118214132.357349-7-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: bc20150b-25bd-4549-aec9-08d9dacb6d0c
X-MS-TrafficTypeDiagnostic: YT2PR01MB6579:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB657921CF60BE95FE62F29B2CEC589@YT2PR01MB6579.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XhNy3hYNZ+YHQxIkM7YJMaa9aC2YcQhzvEbbos7OsROGNhlbBgj9ILmYYxprLVGBqbL5TRaVVpU+NRV5OQsqXstQ2h2Wc4LB22NltLwr+arOvUBeKL7Pn4FdmX4yECVMO4+EJatQDfgK08nFPOypznz4BnBOx1VRU3oifdwLuigOhzbHy2Ufb0pGmHPvBAD9FGwzzNV3lI/O30jy+iF8iRYnIGu5mo2sbhcHT0UffpEcBWs+m+cBWucFijSXQ0vFX7Az21RS1pMkMbfZrV2pIkODIL9QoYbhI81IjXYPplHdzNDnDEJZl+lBb9GMJBImFovXNMLBH4okQBsXac2opTxmAJWwP/udIZ79pzDf6qegLLT6JAjJv/DEOuPQDwMxXYQcUN8KquL9j2LH0FhXwQSRI9RTvKbBheAgxANPA+j+nHEsFD1uCxN1FgdGPaHPPlMTyBS71/rI+h5+pBwFn4R8KxCCRRWgria6xuy+be93eWrYN+8xy/30IwhcepZZpsOH07jbnySFeTd7Hi7Ks0FAhMOsjD5jlVRk3zmiSdedK56l61HNEPQTL2NOW71KNW0oQRA6fckCvdzv/88NJrvoxIWuwLoGkmfs97w+c1aEsSVnT+a7Yl/tE9lteaN2STil0/Ud6kWNmAODNeDqSGAypweoZ3AoF+858MPbTzMK+jivrxr/rlJRJGcpyDLzxSrq49jwCU2/CmL+qV8mWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(5660300002)(2906002)(66556008)(4326008)(66946007)(86362001)(6486002)(44832011)(316002)(52116002)(6512007)(1076003)(83380400001)(26005)(6506007)(107886003)(6916009)(508600001)(38350700002)(8936002)(186003)(2616005)(38100700002)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cbUJxTVxpZo3TD8vUJrxL/7PgTkeApwL1brle+jjFIVjMJyqTJ6hoc5QX5Wo?=
 =?us-ascii?Q?qmqgRyN//C/u+gDLrslGJYYV755yBGguZQu6j/oJdiYRfC1GM/K2KDEp57c5?=
 =?us-ascii?Q?Ji7qNBNISl0iMl2TAg52kzqLqbqxMTSEfIJiSAUaNjAKgLwaIqBJzM/9gwhw?=
 =?us-ascii?Q?1920VCMXP5xbtsn6NdMc3efUXUwk/lNHCu0Dj7Sk8SmNDbubM6hP2evlyaak?=
 =?us-ascii?Q?Ppl3HX4y06oJdfqH97zR5ZmaKdWmztBY8qqf0fFe0/mtPWO+XbjL+FSNWOq7?=
 =?us-ascii?Q?v6657m6qy6tkdAe2lk9CIkzNyCmGoGde7h6GHksDevpjMNFKlmFnXwWZ/kIA?=
 =?us-ascii?Q?AlNA4PfBpFbbcXD39jKrUHWoYXdrmmzSAMbzBZE53lKiQnZutbcXvgnLTCeY?=
 =?us-ascii?Q?sNL9AQjd1ult3XNdvevzuQeQBgksNeNcoQfjZ6ebCjLCqELLDRPS02oe17aB?=
 =?us-ascii?Q?e2hXqgpsXgRMCY4TS4Faw/FLi4LRUsavKA+aaCb0hkVeYYXrCdo8ofJmkRFL?=
 =?us-ascii?Q?iitIc8ehgqI6+bpWEaPVhvzVdFH1Z8nbs6o0Ex800PVjYU/ydX7VSDKzdYWX?=
 =?us-ascii?Q?SH7Z/DIuJBDQfsm2sSXBqdqLwJYU/BxUs7951JyrPrntXufRYljeGzIlMn6l?=
 =?us-ascii?Q?DvM8tc0r6tJev2fSbOCAb8T6tHzpTbN8738lO2AqBjzVFnkEHbguOKeSGCy4?=
 =?us-ascii?Q?g23ReJJlSVV9/pIMVc44s4SiEQ0AjD80xt3HSTB/GEuzqF+bbtUhmYwpAZA0?=
 =?us-ascii?Q?R5Oa8brq10MrcbLzaJNlgzjPVJ2ScYpvYkp4am6VbEYcdM8vAK4xZywvnxLf?=
 =?us-ascii?Q?BQ8qi/MZPrNbtmKTqbxwEEZrJk5yxlF3wAajVmAy3lXMpLfKa8zhUkynyC+r?=
 =?us-ascii?Q?Bje6Ct3bJB0AOpTz5+7pFKISJtqemq86n3dncKNasWzkMxuP4Ef5CYLSvMTw?=
 =?us-ascii?Q?w+0RIH96q0a9X/B5px6tLzJJxf+f8cDKCuhQPySpFasDDUiZ1lADPswMAo85?=
 =?us-ascii?Q?CxhTwLCoOviglJCb1fCTWNOR19tCgikz16lgiwAFBLJLnoE3l6J8ypwGePzH?=
 =?us-ascii?Q?ga3CCp/UBJC7Hf7zFhnSueAi3/uxLTS4+GI5ybgsYDXVRWiUwCjNMYgz2Za7?=
 =?us-ascii?Q?NK+BY56Ium6IQp6JYXp9/Bq4cB1bZGC3pn3wQJ5LqdCnpMasr19yjlOxhZ/D?=
 =?us-ascii?Q?0oL5mg6jEqtKydNG3hCsryCkqRskRBoQGolDxSf7ocOQqT7fLqvQdYgS4jSW?=
 =?us-ascii?Q?5TKbnfTXvq+FR1X2QzT0HBL1eA+vosMHGaHG+JymBbg1xuq/SISh94Wvv9Mv?=
 =?us-ascii?Q?KRS7TmXgPD+VPtMjskn69g/QP6zsNhFdt4WrEDn9wlZkIq8xjeUzHgOashXQ?=
 =?us-ascii?Q?swETmPc0wFhnvn763xYwz5yqW/2ygWiEhcO4mPKPNkA/8CJ9KRK3uRuawlPT?=
 =?us-ascii?Q?88sbwu9sGVXZkRcnpmSgb/anybul8cDMitFB4VNNSV/WhvOQqi7yUnR7SsWN?=
 =?us-ascii?Q?NSt8S8Sx/zBD6KDwM57LemEqO4WN27lxcgU3NbI5wo6Np3GhCZ233z6eG5P3?=
 =?us-ascii?Q?kCKng144ruh1k7bv3I9sGlcLZFoXfJcpKw5nowtOXBwnAlxnhQUvKjtuyH3z?=
 =?us-ascii?Q?wh+QzmYNTwokoJsJMllLOUL+G51sd9fBncJEp6Q56WfAXxV8wkkhFKyhlW1y?=
 =?us-ascii?Q?ZLNU/NydTiOmQvJ0/jNY3srALBc=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc20150b-25bd-4549-aec9-08d9dacb6d0c
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:42:29.3649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQUMIPSknaMKufjNXZLXHKY93hbyXRxHYshbN4Bw1FASHv8pFqwwegjbNcS3V2oC7HhQR9ehTT6mTN1RFazh5Y2iYg4wzdvYJk7sryvtj+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6579
X-Proofpoint-GUID: hLY4scXcj9sQFhtL7zJcxFJQynepx5gf
X-Proofpoint-ORIG-GUID: hLY4scXcj9sQFhtL7zJcxFJQynepx5gf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=658 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 mlxscore=0 malwarescore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for whether a TX ring slot was available was incorrect,
since a slot which had been loaded with transmit data but the device had
not started transmitting would be treated as available, potentially
causing non-transmitted slots to be overwritten. The control field in
the descriptor should be checked, rather than the status field (which may
only be updated when the device completes the entry).

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3f92001bacaf..85fe2b3bd37a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -643,7 +643,6 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			dev_consume_skb_irq(cur_p->skb);
 
-		cur_p->cntrl = 0;
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
@@ -651,6 +650,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		cur_p->skb = NULL;
 		/* ensure our transmit path and device don't prematurely see status cleared */
 		wmb();
+		cur_p->cntrl = 0;
 		cur_p->status = 0;
 
 		if (sizep)
@@ -713,7 +713,7 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 	/* Ensure we see all descriptor updates from device or TX IRQ path */
 	rmb();
 	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
-	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
+	if (cur_p->cntrl)
 		return NETDEV_TX_BUSY;
 	return 0;
 }
-- 
2.31.1

