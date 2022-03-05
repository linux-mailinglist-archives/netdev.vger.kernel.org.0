Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31B44CE239
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 03:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiCEC0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 21:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiCEC0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 21:26:06 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A1422C6FE
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 18:25:17 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22524FEk004428;
        Fri, 4 Mar 2022 21:24:59 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2051.outbound.protection.outlook.com [104.47.60.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8qh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 21:24:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wvyz+wLLsm2TJr2E+k8EizpBO6XAEVQwmChl/+sirHa5Fao8aWiCVXf10/ttzC0X08bft3c9L9Sp1fdZaF/oH32Da9ZF6GXk7VDaOkkPVmu33mLBDv33LxcXUa3FamuraFt4XAc/1wQ+2nJ1BNxSiwgLCRNvt0pjsd05NS0UonhHyMd6GxrYMEUpuEKtgxJ8LhQQWz6SCsFBidfi8HKMDt3RfFeuE46hsMkWlKE1dw8rUWn2IMkml0w19q83X1tGcvOAWkm/UcfHDSWTiVHWF0ehazUzCFP/PxWk2Wpeo8+NvjAzhnAEYnc9kWqRxnrKfVZYHykljHRS5k8qh0e/og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hbsz6wDcjqlIRWTFKuKUW8d+CfW2Sx4F3QeW3d+dLzg=;
 b=MgYZ6p282LdWEOmndSQqLJ9fXeXDuvhqwpTbDpIT5YjSTqgvYP4a+6GPwrz7FNsEkwP9KonCDBwOUR7qnh4E9UBehfnFjKhZ8xOrgPwK2gXR6zPKl4Ld5wB2ed+FG6bkjpQxYRHZKTp/bwlsCCM5Y+J7gvFkAhkwTMbr5jL/ivzJgEqk0B7kcleLJKrmlmEC9v/JBexhz9RE44IJ83mvzONnkC30oH8f24kQhzKiQ5Dh6e1m65w7qgfa2cgMSOAHkUv/aRJl2hM9F72XsLqzpw81/s5avoQoKLLaNYnz5n8OyfZNINjHls9NnTBNdqUfeEVerj69kjr/Gu3NJN0AZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hbsz6wDcjqlIRWTFKuKUW8d+CfW2Sx4F3QeW3d+dLzg=;
 b=p+qjTEdbUytiHYECNhSnZKgWqnM9aa28pV8fRA4613QJqF3rJy63rgPHuh8dB+Mt8JMEQXz1oTCPi+xkX/uz99eyGa7glutrq6/z0SkSnFgYdd05r91TNdG67Bu3kgEGHvsMcF+zI4I99Gpk9Xc7jJglzzp2aJwnFTmv6DLqEao=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (10.167.1.243) by
 YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM (10.255.47.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Sat, 5 Mar 2022 02:24:57 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 02:24:57 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 2/7] net: axienet: Clean up device used for DMA calls
Date:   Fri,  4 Mar 2022 20:24:38 -0600
Message-Id: <20220305022443.2708763-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220305022443.2708763-1-robert.hancock@calian.com>
References: <20220305022443.2708763-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a1b04b3-ee8b-4700-8e01-08d9fe4f578b
X-MS-TrafficTypeDiagnostic: YTBPR01MB3184:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB3184F730E8D165145D79F5ABEC069@YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mqU+vWlDp4Dul4/Q3rkmgmkZ/M867Au2o0Eev6fserAoSP5lOSlVbkwGHzUDhKJCiSUO6FGv8RK21DUBb3AcvBecLT4FLeBn7dQuU3l2WwAx0WgoiHOJu2hsktiqag522HoX8KWRZLRZ/osj8zlPK9wm57OqxqkvdmnmLM/fwCO7dqMK2gFRLeTgLao1+SWxBltupXfe1kaAriV5fvRJCYFXpGVHGvAs9iF5J8D2x0mtvGqp7TwE+TsTGQPWK7mlTVnJwv6+MbnrsDGkZRXPjE+A+zrMV41q+W5O2BDhI5fqShuBQSWWvf/5oCnEmoRhsKsKwVSbI5EtS850SxzB+s2GAobqyH7S0okn/rbXpl1u/wdoE8753UPVwXD/BDCV0yOVy9GabeWzUGsQXCgeopPPvt32xoN7Jqk1FXAFhsagGyAXiXiKvPVse/gArOvuqujrLlBrEabaTaRcw0v4qO4wXd81crAixfzkXwINa1Ce7LrqXvud66ruQR4DJuMVrheBS+4yPb3Z5bCE7awFlOB+Z7tbAyVa9euP9hUMX6mn8DZHV2E7jL6KVrMPVIj6S7AGbQ1LXgIj8JOkH/8jpZDpS8Eib24cWc6DYXVkRE4oYVgpm3fg+icC5+AZMS+X2W7BaE1+9ZInnXSXLogjZJHuFkWzb7J59l4wvOaim8vi6ju378vs3Z3jF2IQYoLDgkdAICUNTc2l/jBP90e+yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(107886003)(5660300002)(26005)(186003)(83380400001)(6916009)(4326008)(2616005)(1076003)(8936002)(44832011)(6486002)(38350700002)(38100700002)(508600001)(86362001)(316002)(6666004)(52116002)(8676002)(66556008)(66476007)(66946007)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ReD9R1dN6oOEVtY0ZqQfTKxD0xjz8CLNZpjxH4lLnl8+pVK3ZJmHcd21AJf+?=
 =?us-ascii?Q?5azHxE9Rvv5U/xTzmATt3x0rR6SFeS7anGq0Hgl9DU28s8MQCy7MN4rcf581?=
 =?us-ascii?Q?9WpoKD6R79zp56SeOGrMaWnazyYOPIqwRdCnW5+ZPyQ6qvUxhWO666iI/VrP?=
 =?us-ascii?Q?zoo7zKEO4UsAZ4l9UjKPkesXZmyGD7KVerRYMtEz42JFSuyxj78/RE3meUZL?=
 =?us-ascii?Q?zakVuNOKhu0k0TF7g7Tn4rSJOepfelF8iDvFzYfM2Ed00GA5rzw6yrHT03Kw?=
 =?us-ascii?Q?Ra+Fk8uOZE7w6hsTqbcJ7agJx52vrQc9qwlCP+m/yX6HPzXpT/rcsfmHV1mT?=
 =?us-ascii?Q?fiOUwMwt/m0vNdKPdzWijfRunCioMoXN9VTkLdcvbR1JyuoC9+b0qyl8F8+5?=
 =?us-ascii?Q?CmiRyvnxeL+o4LCZjU9llzfFcj/0IiFYZlts4HupLfYGQvAPls5yziNIakQR?=
 =?us-ascii?Q?6mbOe6HbNUs7jHihXXxKPksW0cPFDoX3UVShfr1pPV9VFFxWMcvDyaGGUYDI?=
 =?us-ascii?Q?9WqGqLjY2sFh1pp0m6jRV3epicVMRqGxR9Tf2CoWLpzZhChiH76PL/P8og9U?=
 =?us-ascii?Q?U9WUIrgvAKDjsbEu9EagpJrJqW8z+CUBa3Jk4uZSG8w1F8Ivf5KHzan0Ns3w?=
 =?us-ascii?Q?MG4po4FjyITcAZXbGbJLy3bV0qCG0n87TIpEgvnHaCTS+OUdJSxKHsolqXpZ?=
 =?us-ascii?Q?/R43s8Jhmw6pZJFAQOjD/Cbj/n5YcVXurrUBZQzyqR4tMLhjTkoG/V94T7Ai?=
 =?us-ascii?Q?+6eqvJSGmbfo6LZXx/fQA4RTLBb1czBXC2DUY5blYAAxNLxuhygVmOldB9Ph?=
 =?us-ascii?Q?w/gBcHF5D76oOC5C8EFR+LDwYceH3vOEhKizPRSw6f8OZqRWKAApqHlPuZG7?=
 =?us-ascii?Q?H92rnYJ6aT8jl6gh8Mr37NLDAqldhSr135NYHvQ0ST3qmibYAf9THLt3GMQS?=
 =?us-ascii?Q?UkxM8Cix7hVvgNQrN9spfJO5yTZ3YmHvOxlW2uGI/Pj9KmSCYDIlGTk1q5bd?=
 =?us-ascii?Q?PV3u8GGFiQTPb8jURCpHb4tqhF1L5hlb9cpie1GBhL3sSqGtxxqT7sO3AG7Y?=
 =?us-ascii?Q?Vt797hIo8GbLP4jfhQGjCUh8euuMgf9+zQ9thR+g19UQ/3H+1I29gfdu1+SX?=
 =?us-ascii?Q?84cSG9r0e53A81L54bqOd4z/HdeFWEJdqk4Bp5NFCma435C602wnt3NrBiuV?=
 =?us-ascii?Q?UoImUn3II/5LlDRdQOs0qyYwLl+1DN3dfUs/OI/G+z9Bp0MFAul59+tX80/O?=
 =?us-ascii?Q?r+q8TNq29pZZgLNoLLqbBvGkbOVWPfOL+1xQoD23s/tPkjuOdEEpSPWf3kjC?=
 =?us-ascii?Q?tgJmO6wCacYFmtTfWoKP16K6qNWY6A8hBGCbmmW++6E3fcysT6HjC35tHiFo?=
 =?us-ascii?Q?lvILK4GCip6RWXM0vu6gH1ml0NJ1rG89RNGCFRIyOjYRA0GOMNg3/sKKC2rT?=
 =?us-ascii?Q?EqsxPZiVzNPpQPmSrqFCMDz1nLpFwRSjvim9eTinQ8wmYF/hmQGMrtglDdQy?=
 =?us-ascii?Q?GNN0cMxVtGnQoKr5QBonrRbH4gMlCW12o3DdjltHz7vwxrOJxWvoN8K/G4uI?=
 =?us-ascii?Q?kU09+TSOcjyu0XtQO7eqC3M/UflkdjV7PH8yHWxzlCbIyFjesx1UahugGGOz?=
 =?us-ascii?Q?XGK6NTHMXRgxqVGbwk6XGwgODhv/lY+/bQ/wLvKrnY6FxQF6siDfK5TfGEDo?=
 =?us-ascii?Q?tvSafqhx9eKzdTibAvMPBWutPFE=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a1b04b3-ee8b-4700-8e01-08d9fe4f578b
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 02:24:57.5520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jg3ldLHva+1CemEJHtkVevroMrDQeojnylBwx7HBeGmMpHG20UdrgE6iQuJCIfj+yrYHJK+xuQWT+YkHblShT+ejC8R7TBXjn/9LLb+TA2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3184
X-Proofpoint-ORIG-GUID: Piva6rHVLSuet7GdxFPhQFa9cC_8AP-j
X-Proofpoint-GUID: Piva6rHVLSuet7GdxFPhQFa9cC_8AP-j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=774 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203050007
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using lp->ndev.parent to find the correct device to use for
DMA API calls, just use the dev attribute in the device structure.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3457a7f13747..5a1ffdf9d8f7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -190,7 +190,7 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	/* If we end up here, tx_bd_v must have been DMA allocated. */
-	dma_free_coherent(ndev->dev.parent,
+	dma_free_coherent(lp->dev,
 			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 			  lp->tx_bd_v,
 			  lp->tx_bd_p);
@@ -215,12 +215,12 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 		 */
 		if (lp->rx_bd_v[i].cntrl) {
 			phys = desc_get_phys_addr(lp, &lp->rx_bd_v[i]);
-			dma_unmap_single(ndev->dev.parent, phys,
+			dma_unmap_single(lp->dev, phys,
 					 lp->max_frm_size, DMA_FROM_DEVICE);
 		}
 	}
 
-	dma_free_coherent(ndev->dev.parent,
+	dma_free_coherent(lp->dev,
 			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 			  lp->rx_bd_v,
 			  lp->rx_bd_p);
@@ -249,13 +249,13 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	lp->rx_bd_ci = 0;
 
 	/* Allocate the Tx and Rx buffer descriptors. */
-	lp->tx_bd_v = dma_alloc_coherent(ndev->dev.parent,
+	lp->tx_bd_v = dma_alloc_coherent(lp->dev,
 					 sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 					 &lp->tx_bd_p, GFP_KERNEL);
 	if (!lp->tx_bd_v)
 		return -ENOMEM;
 
-	lp->rx_bd_v = dma_alloc_coherent(ndev->dev.parent,
+	lp->rx_bd_v = dma_alloc_coherent(lp->dev,
 					 sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 					 &lp->rx_bd_p, GFP_KERNEL);
 	if (!lp->rx_bd_v)
@@ -285,9 +285,9 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 			goto out;
 
 		lp->rx_bd_v[i].skb = skb;
-		addr = dma_map_single(ndev->dev.parent, skb->data,
+		addr = dma_map_single(lp->dev, skb->data,
 				      lp->max_frm_size, DMA_FROM_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, addr)) {
+		if (dma_mapping_error(lp->dev, addr)) {
 			netdev_err(ndev, "DMA mapping error\n");
 			goto out;
 		}
@@ -636,7 +636,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		/* Ensure we see complete descriptor update */
 		dma_rmb();
 		phys = desc_get_phys_addr(lp, cur_p);
-		dma_unmap_single(ndev->dev.parent, phys,
+		dma_unmap_single(lp->dev, phys,
 				 (cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
 				 DMA_TO_DEVICE);
 
@@ -774,9 +774,9 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
 	}
 
-	phys = dma_map_single(ndev->dev.parent, skb->data,
+	phys = dma_map_single(lp->dev, skb->data,
 			      skb_headlen(skb), DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+	if (unlikely(dma_mapping_error(lp->dev, phys))) {
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
@@ -790,11 +790,11 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			lp->tx_bd_tail = 0;
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 		frag = &skb_shinfo(skb)->frags[ii];
-		phys = dma_map_single(ndev->dev.parent,
+		phys = dma_map_single(lp->dev,
 				      skb_frag_address(frag),
 				      skb_frag_size(frag),
 				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
 				netdev_err(ndev, "TX DMA mapping error\n");
 			ndev->stats.tx_dropped++;
@@ -872,7 +872,7 @@ static void axienet_recv(struct net_device *ndev)
 			length = cur_p->app4 & 0x0000FFFF;
 
 			phys = desc_get_phys_addr(lp, cur_p);
-			dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
+			dma_unmap_single(lp->dev, phys, lp->max_frm_size,
 					 DMA_FROM_DEVICE);
 
 			skb_put(skb, length);
@@ -905,10 +905,10 @@ static void axienet_recv(struct net_device *ndev)
 		if (!new_skb)
 			break;
 
-		phys = dma_map_single(ndev->dev.parent, new_skb->data,
+		phys = dma_map_single(lp->dev, new_skb->data,
 				      lp->max_frm_size,
 				      DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(ndev->dev.parent, phys))) {
+		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
 				netdev_err(ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
@@ -1731,7 +1731,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 		if (cur_p->cntrl) {
 			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
 
-			dma_unmap_single(ndev->dev.parent, addr,
+			dma_unmap_single(lp->dev, addr,
 					 (cur_p->cntrl &
 					  XAXIDMA_BD_CTRL_LENGTH_MASK),
 					 DMA_TO_DEVICE);
-- 
2.31.1

