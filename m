Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9719C4AF1B8
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiBIMdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbiBIMdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:33:19 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2F8C0613CA;
        Wed,  9 Feb 2022 04:33:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W70GTJ4PtuGYftz7VKJqSCQDT6D/DvGkpwWiAlkpYLr6bASLOwrC7y5v03TsC6/B7AD/X58HCKH3bXzpfZjzf/iZRHJGPlIakjbU9ybmhwZRY/K9p3gPNIIN8BjrXxmmIeNcc1Lqqr942NuOo6wAMWUSQXDyfcANcCuKviGpih7xJgHL0mwzz9LW2w4eTqrjJnw15noBy9SFXWaHrFV38jGuYxDz4uxbIAs39zD6jyr3laInxe2BS6OGoMB3NPonSdHeKxgze7wVTpSzy9mvHz9QtB0ovGupLwLUt+MEAI/E7K+w6FfkTP7DIB4uV9SjU6LuhxnmBVxqXrOUxI9m5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMHoUp2+WC6WCZo4XGAylNa3NLxwZq4Q2RdfGJRkAy4=;
 b=RlJUI45U4NV716dOrJ3ZQOthZWpepy6gmP5Z/YAlsuvfA+dOjGtrOGXwjckS+DPQIftzS3hSGxaGG6pL14j8TmZuuY0AMVV2W71aaAtAeZjy3twDB/Cwawf68EsBE3AsxnDiC5qzJcfyp9CUszfdATi8HywiFwlmcqJSmvQO9z1FK4Xb0LnVXvzPAhN3QhxbD/FW5DNeybCmHWaew+WDUr9XN5sxFaGTOrOGBjl3Rs43s133IFgxSHox9dhqoVNF7RU795rkUGUNTnx78UMQKij76fkGbPyHXglaJxE1XNwqDPnNCp+B7v1W9ZInklCuwwxlPs8krcBEZ27p8hJ8+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMHoUp2+WC6WCZo4XGAylNa3NLxwZq4Q2RdfGJRkAy4=;
 b=qpwRh8D7LCZh/begEr6oDm5qIRVN3eHUFJ/qtLRNjux4aPI/R4MW2Xr0sBJ8+PUVh2JHf4Qn3Tigc9wBv8nUwNDU5SujI1n7530a6GSqrtMDdAEqdsYpqC6S8jqVSz1NY3n9n1LY+HGH2hbK8/tOmEFbXdr8IOTvm3qrVgeKpgM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com (2603:10a6:10:1f2::23)
 by DBAPR04MB7398.eurprd04.prod.outlook.com (2603:10a6:10:1a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 12:33:19 +0000
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::a012:8f08:e448:9f4a]) by DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::a012:8f08:e448:9f4a%3]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 12:33:19 +0000
From:   Po Liu <po.liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, tim.gardner@canonical.com, kuba@kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, Po Liu <po.liu@nxp.com>
Subject: [v2,net-next 2/3] net:enetc: command BD ring data memory alloc as one function alone
Date:   Wed,  9 Feb 2022 20:33:02 +0800
Message-Id: <20220209123303.22799-2-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220209123303.22799-1-po.liu@nxp.com>
References: <20220209054929.10266-3-po.liu@nxp.com>
 <20220209123303.22799-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0241.apcprd06.prod.outlook.com
 (2603:1096:4:ac::25) To DBBPR04MB7818.eurprd04.prod.outlook.com
 (2603:10a6:10:1f2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f8c6d67-114c-48e5-7552-08d9ebc85a15
X-MS-TrafficTypeDiagnostic: DBAPR04MB7398:EE_
X-Microsoft-Antispam-PRVS: <DBAPR04MB73983EF4A425BF37B9B884D9922E9@DBAPR04MB7398.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j2NhsrM4WilGz/Y6eIJS4JSU5y3oXcqUdA9fpLDCLb0lPVY+0Kf18GUu6cCpM8wADSEk9bMsDiMFpkiaI4tB6Uhu8rSVBmB0gIUPlU2nsheeG0d2vOkZNxk/U9xD6I0vU8T6uh4wJTuhvREtwbtuL4B9g+XCPSD/L6W10LGOEDG4EXAfmroB4NuEBRd+TBI71+aTMwvIED0JKAaRH2g9p6KBbJI7E4YWIIXTAOKXMzZaTMaAoozZRsL2oBbcr7ooLnX70i+RFFqR+mv/2YTdhy30qPndqE1JlrOopIFxRtrCvKdn+wC0Ev9cTxOJmGhNXdmDMdmsTGABFeuDrdPLSQcua0g7HtJrS5fr9onB6oY6gN6VWyAP5z8OSOBqldnwjYynNxQ3vd0U0OKOTQSLiseuxP0ocVMd5zNyLzfTbfPQCli20E32RuDlsMgvURjmJ2RyanrtBAzrZDf/E1pYlNva+JG7V5P8XnJk3VGK7VFmBf0BBtmqZBHcbMnMg1iu/uaUqQC9SKeLmcPfeKeUE3vDTvubUDgjsdyWCVkk4mG6t+Fvp9mUAujqKVh1VnpELRJqS77AnRv0xQmA+yUX5w2VPJ8z/4aIzDAWQqRI++dYdIu/bOAC63dyRD1oXAcfIRvuDlLG1G9+Lxk0LJP5rBkS8zNRrYelHM8nsz7SGIxLlMwvUNOL2iu3vh6yPyA22fA2gc9TSp/L3zJdeUl9sQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7818.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(66946007)(6506007)(36756003)(186003)(52116002)(6636002)(1076003)(316002)(2616005)(38350700002)(6666004)(38100700002)(66556008)(86362001)(6512007)(2906002)(4326008)(44832011)(5660300002)(66476007)(6486002)(508600001)(8676002)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MFAtDyYEoGtgWmUo/AhAi4ZTJ3d6rb305nhdXX+cFKmCnW/3gToB+gV9kJrs?=
 =?us-ascii?Q?EwmAzkDfFbFiopglCAw4lSdOTfwxTqllGN3fxYvrSQRQuyyUBMxUYmSip20C?=
 =?us-ascii?Q?nmcNRpx9K1DV7Pm1Zi/3ED/FbsaU3lQEtapVY+2F8MJfxbL3CVUBUUKzZRHk?=
 =?us-ascii?Q?iMha3s0nWjJPEZLdgcEBzopEAuh9aLTQulNH1zMKnNSL9njmAcTqI1uJdsj0?=
 =?us-ascii?Q?TZjA6ZpTKZiFn/Wzo2UKGCGuElne9wtOlVvYid0muXhcn/nZ2VH6ThKbSsFs?=
 =?us-ascii?Q?QebmcWPYGQ9TWNWF5Vc8hKWLWo9jRsy3qATXwkisbMKVvXkL8Ro3T83wlrjA?=
 =?us-ascii?Q?cCVGNpvMn/kPudLK35Q8FMm+HETcdEVvncxHJNircCq7vu7rY20fGi51bs1f?=
 =?us-ascii?Q?UPCPgLT1V38zYG2vhIFIzDzvmZxstc65tLoT+W5Bv1xhF1ObF+6UgVY330XU?=
 =?us-ascii?Q?CXGVYFn9OCNxhM/CMfO/zUNvCVfavMQ/Uvsnyx3mWrst5XdoDxaXJUi7zk93?=
 =?us-ascii?Q?zatDgLyTfnNbf3/AbLj+gQKGR/BzYz8NBKsfGLqyWl8qgKfGXZ1ktKC9nSlA?=
 =?us-ascii?Q?XCyMIoN8Hwp4OpvLjbyKMivYBJXQvlE3kmiwniSTNxu2+D6b4fWKtqPL6f7G?=
 =?us-ascii?Q?wFp24+a10JRdI7/OUUCON4sLclnTov7eDDZISB2DVVWSsta9gC/qEcVEnsWC?=
 =?us-ascii?Q?gdaeQDwjFF+9I9+noIo98MTznmpkExspWy/7frzdGXIJfis6E6D6vuCGMRtp?=
 =?us-ascii?Q?8mDXhgjQwKdi4lPvtEbGz50NthHYpOvYy61R1YS2asMT/pjh8796iTMR30CH?=
 =?us-ascii?Q?pp2HpoR1lwgxzgNt4jfeK3xaT9m7ekSvDH5DjFI0DEaet2IdbpZCSPH1FJ0u?=
 =?us-ascii?Q?EYFibd9GhAHvt6EX3H7fJPHq7xZunAe5rlwXZvRTxa3zK6UAyYiVYHpuXpBQ?=
 =?us-ascii?Q?pM2Opj/bzFKzBb7RBMwGdAWN92i0Pw+BgYBUiF2B/wjVDUxLLgn6VHB+1F95?=
 =?us-ascii?Q?TyHFyxR07so9aHFrWgJhEPBXJOqXK5goqCsWFXArGw4C9dx61eL5qC2/rhQm?=
 =?us-ascii?Q?c7WDg9nFmKA3rtVTApE3laVhcNvY1MNIaMZxydHZbzXuPl9zQXJVZJsZGFEG?=
 =?us-ascii?Q?06hy4G29bxSPajf3cijf26SLXpiVl+jgq5TBgS8x4wiHzvicQWV2wjStQTGK?=
 =?us-ascii?Q?KpobTwM1LX+Sri4b+WlkTn7tjIJXc7Xd5SKGabdUVC0JAc0HUyj8UkalLvb4?=
 =?us-ascii?Q?gmXVUNiNNKm/hKYuZDqozEUoSVpnCwFas+02n86V5Zej7f9fbyzWgG9hoet8?=
 =?us-ascii?Q?aZMZFDnym5R8z0vXgEbdSP7tf1gIfmaL+8T1BpE0Iixhwh1XDqrGT3S5DHuC?=
 =?us-ascii?Q?0MYkkmtQQusg0j9Oj6FkviX2kJph1W3W9C066Satz/Q2avgtvmGX+cJPwbXz?=
 =?us-ascii?Q?I5ckc9JdwYH6E2w0PsyDv+QRpaDCGLLyPm5/P+9KEhPy3lEuRbShgONCgxdD?=
 =?us-ascii?Q?od2OT579/H1vI4TsbBkbNslRQ4dvisMOzQLU9bFxoF2h/kVattZr50RAjJfa?=
 =?us-ascii?Q?U02hP3kLf0AVcPhyKwM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f8c6d67-114c-48e5-7552-08d9ebc85a15
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7818.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 12:33:18.9023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzvPHCeIh2fHqeWr7To5xG/4ZO7KG98Xl6Pfmt98gQ35Oa0Inwu3NOpmxIHaE9Eo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7398
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the CBDR data memory alloc standalone. It is convenient for
other part loading, for example the ENETC QOS part.

Reported-and-suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Po Liu <po.liu@nxp.com>
---
change log:
v2: no changes

 drivers/net/ethernet/freescale/enetc/enetc.h  | 38 +++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_cbdr.c | 41 +++++--------------
 2 files changed, 49 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index fb39e406b7fc..68d806dc3701 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -18,6 +18,8 @@
 #define ENETC_MAX_MTU		(ENETC_MAC_MAXFRM_SIZE - \
 				(ETH_FCS_LEN + ETH_HLEN + VLAN_HLEN))
 
+#define ENETC_CBD_DATA_MEM_ALIGN 64
+
 struct enetc_tx_swbd {
 	union {
 		struct sk_buff *skb;
@@ -415,6 +417,42 @@ int enetc_get_rss_table(struct enetc_si *si, u32 *table, int count);
 int enetc_set_rss_table(struct enetc_si *si, const u32 *table, int count);
 int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd);
 
+static inline void *enetc_cbd_alloc_data_mem(struct enetc_si *si,
+					     struct enetc_cbd *cbd,
+					     int size, dma_addr_t *dma,
+					     void **data_align)
+{
+	struct enetc_cbdr *ring = &si->cbd_ring;
+	dma_addr_t dma_align;
+	void *data;
+
+	data = dma_alloc_coherent(ring->dma_dev,
+				  size + ENETC_CBD_DATA_MEM_ALIGN,
+				  dma, GFP_KERNEL);
+	if (!data) {
+		dev_err(ring->dma_dev, "CBD alloc data memory failed!\n");
+		return NULL;
+	}
+
+	dma_align = ALIGN(*dma, ENETC_CBD_DATA_MEM_ALIGN);
+	*data_align = PTR_ALIGN(data, ENETC_CBD_DATA_MEM_ALIGN);
+
+	cbd->addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd->addr[1] = cpu_to_le32(upper_32_bits(dma_align));
+	cbd->length = cpu_to_le16(size);
+
+	return data;
+}
+
+static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
+					   void *data, dma_addr_t *dma)
+{
+	struct enetc_cbdr *ring = &si->cbd_ring;
+
+	dma_free_coherent(ring->dma_dev, size + ENETC_CBD_DATA_MEM_ALIGN,
+			  data, *dma);
+}
+
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
index 073e56dcca4e..af68dc46a795 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -166,70 +166,55 @@ int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 	return enetc_send_cmd(si, &cbd);
 }
 
-#define RFSE_ALIGN	64
 /* Set entry in RFS table */
 int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
 		       int index)
 {
 	struct enetc_cbdr *ring = &si->cbd_ring;
 	struct enetc_cbd cbd = {.cmd = 0};
-	dma_addr_t dma, dma_align;
 	void *tmp, *tmp_align;
+	dma_addr_t dma;
 	int err;
 
 	/* fill up the "set" descriptor */
 	cbd.cmd = 0;
 	cbd.cls = 4;
 	cbd.index = cpu_to_le16(index);
-	cbd.length = cpu_to_le16(sizeof(*rfse));
 	cbd.opt[3] = cpu_to_le32(0); /* SI */
 
-	tmp = dma_alloc_coherent(ring->dma_dev, sizeof(*rfse) + RFSE_ALIGN,
-				 &dma, GFP_KERNEL);
-	if (!tmp) {
-		dev_err(ring->dma_dev, "DMA mapping of RFS entry failed!\n");
+	tmp = enetc_cbd_alloc_data_mem(si, &cbd, sizeof(*rfse),
+				       &dma, &tmp_align);
+	if (!tmp)
 		return -ENOMEM;
-	}
 
-	dma_align = ALIGN(dma, RFSE_ALIGN);
-	tmp_align = PTR_ALIGN(tmp, RFSE_ALIGN);
 	memcpy(tmp_align, rfse, sizeof(*rfse));
 
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
-
 	err = enetc_send_cmd(si, &cbd);
 	if (err)
 		dev_err(ring->dma_dev, "FS entry add failed (%d)!", err);
 
-	dma_free_coherent(ring->dma_dev, sizeof(*rfse) + RFSE_ALIGN,
-			  tmp, dma);
+	enetc_cbd_free_data_mem(si, sizeof(*rfse), tmp, &dma);
 
 	return err;
 }
 
-#define RSSE_ALIGN	64
 static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 			       bool read)
 {
 	struct enetc_cbdr *ring = &si->cbd_ring;
 	struct enetc_cbd cbd = {.cmd = 0};
-	dma_addr_t dma, dma_align;
 	u8 *tmp, *tmp_align;
+	dma_addr_t dma;
 	int err, i;
 
-	if (count < RSSE_ALIGN)
+	if (count < ENETC_CBD_DATA_MEM_ALIGN)
 		/* HW only takes in a full 64 entry table */
 		return -EINVAL;
 
-	tmp = dma_alloc_coherent(ring->dma_dev, count + RSSE_ALIGN,
-				 &dma, GFP_KERNEL);
-	if (!tmp) {
-		dev_err(ring->dma_dev, "DMA mapping of RSS table failed!\n");
+	tmp = enetc_cbd_alloc_data_mem(si, &cbd, count,
+				       &dma, (void *)&tmp_align);
+	if (!tmp)
 		return -ENOMEM;
-	}
-	dma_align = ALIGN(dma, RSSE_ALIGN);
-	tmp_align = PTR_ALIGN(tmp, RSSE_ALIGN);
 
 	if (!read)
 		for (i = 0; i < count; i++)
@@ -238,10 +223,6 @@ static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 	/* fill up the descriptor */
 	cbd.cmd = read ? 2 : 1;
 	cbd.cls = 3;
-	cbd.length = cpu_to_le16(count);
-
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 
 	err = enetc_send_cmd(si, &cbd);
 	if (err)
@@ -251,7 +232,7 @@ static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 		for (i = 0; i < count; i++)
 			table[i] = tmp_align[i];
 
-	dma_free_coherent(ring->dma_dev, count + RSSE_ALIGN, tmp, dma);
+	enetc_cbd_free_data_mem(si, count, tmp, &dma);
 
 	return err;
 }
-- 
2.17.1

