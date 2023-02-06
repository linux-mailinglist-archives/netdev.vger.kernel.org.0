Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D100E68B988
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjBFKKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjBFKJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:41 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FDF13539;
        Mon,  6 Feb 2023 02:09:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIBZy1z4pNqFQmxycnVyVFqnWmwSDzYSVniEZbN7j3P/HLNmRFDxDDVGLVmQvac5xheWt438Z8mz4gQyV3zqS1P5dnyqohQxzOcfWk69tyPxwN1GqW9hQkQZ/5zUG9tT7PlJTQvn5N1NrI+G/PqFqL19hedqq6PBbOkZaWyF+FoyhRmhmPf+zrEp1aE9D6+iU0wWzXGEJN62cmJJMZgB06HySiHUMcyyKKCaTK9FPiKu2shbD1NHcpvokZpsEUDkQTT8I0Nlsf1uNIKFfP2pjQ2XpW+jL5QUwR7bpJmDTtJ8RdYeENB6wfxLvykR4zhC6ZbaqCxV1sZWfesmPN0QwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZRjZzSov683JeYNCQDpyIqDuzmh07GzJ9EMtycOdho=;
 b=DNJbZXnbUCGfhcUQXAsoBYqUBBcwiln76+nhZYMkOqJ2AyXTLG0rVha54ckv0MzgL1zm+tD6P6G2D0OiYz4OMWEQq0YYSKyBUtphRPzbwHRNsrj0fiqdCOHHHP+dpR0I4vACJg8kf3zvpaAd/wqk+xqNAFgdY3Gks6BBUltuosZSYID77sfR/hu9cgs1bH4GfkBpf+CrRf739pkizwQBGvUvisgGuJCJb+8lbBcUf0xSu7SV20sj7yOXWUYAiwRQUy5+jjdu78IulDHFqnR7F3301iwUP2kM9OFUEgpWmiaKd1W9hx6EYP5cE3Jbab2zqEeZBdUYrE0VD+7Z9XD6DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZRjZzSov683JeYNCQDpyIqDuzmh07GzJ9EMtycOdho=;
 b=HyvgDWMQ07qGQBI3EiO1/iWJcdhH5iMXWN+QgXxmj5lhYH5pAWHcyp7WrKNvKmKetZVXSCBl1/ikhu6lyr7LN7KWZPB5YqPHwNhcbqhqtRypZS8VT+jm0qzE/TpiMpdkTITwg1MSuUtxB5ynN7Mr+xONukWf/1mSiAoAqs7e6vY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7735.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:09:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:09:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 11/11] net: enetc: add TX support for zero-copy XDP sockets
Date:   Mon,  6 Feb 2023 12:08:37 +0200
Message-Id: <20230206100837.451300-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206100837.451300-1-vladimir.oltean@nxp.com>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7735:EE_
X-MS-Office365-Filtering-Correlation-Id: cfaedb37-f894-44f0-baab-08db082a33c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ck36N+AbtTiYwYrjMn80LLaqqZAiwZoIAYcYyhcN9JMQLBIEc45WKLJO9isRou/F4//Mb4vgH98Y5CX4w74w0YGwVuwD7JdslDd2qkMTH5O8+MuFFBoZlS84pZEaNnBC/A1XxSixLvAp8h9SIuWng6SGPhR9r3c+lc4m73ugNUKiKzzA2fIJS3iAuf4E7NR4qyrhHf7H/rKch9g8zYPBsXLCxpxnFJX12OpSIZrp/QZL84wH0373vJrkJER7GH1hqhFQDoLEX6UUFG0eRM1KCev7KchFlMT+Pki31V8cvgrqEi/1hegh8at0ClhchCt4cLe9sujA7pZSgM9X5mUq362J30OUVTAep/S7LvDa5Rpu6drYwSWfEaobGo2kPUBRqAJ/F18A8T9+gw6UDyHPJ7f/tNo4ByLjCFurCHI/UvJ0W0hRZY7JsrOZ8LCm0kamXDaZHSKqufucCjagjQ9sbi6KkJvUQeWF4cXUjti9qhH5N/KWwqkKWb2lnG/LVzYXptMbi0OHyuBQx/Fkd8aFvLL6nag7oohIUyI2Yq3xd+5y6zr7M7SLbvB1AWdjxn3L0w6j0IXaVSw1BeKeTRevWV8dx0QfCWHdINvPgyOm7aQRCElX2LoPTkvGvbgGQBqqG3v5w5c96oLbbZKrHuAR+NSOCA4YotZF4F2H8rRWV7cvHLd3yuvdMx7MmfvMJlz8Iqbr2ywhcmcZ6c6j70dqEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(66946007)(66556008)(4326008)(6916009)(41300700001)(8936002)(8676002)(7416002)(5660300002)(54906003)(66476007)(2906002)(44832011)(2616005)(83380400001)(478600001)(6486002)(186003)(52116002)(6512007)(26005)(316002)(6506007)(6666004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h0lvIiW+XLk7srarxFeCds48D2OdPd5YYN9EACnOWtq912jI2lbQ9eT3yc6x?=
 =?us-ascii?Q?usnZgpAIBKvwfbBmja1XCVLptnxKX0agpawShP3ax9zhHjEt7U3HeFW8f77f?=
 =?us-ascii?Q?6JbK9/jB+iNnNxcUMB56Et9H2XWIfYG4NFRxe12T8GokYPANpehJeYUJ4cTh?=
 =?us-ascii?Q?dv9q0+4nIPWlCR/H7m+/rwAzwVnPns88t+xzKChNgeTaxASkEDU5D1yAHEk/?=
 =?us-ascii?Q?1l3IJ1rabo0WDtJJPX3gLnDgQC7emky5oNydqqav+eEi85SwkFwbyAaBVVSP?=
 =?us-ascii?Q?eh/eyNZ62B33zv82fzBDHyL1MQ3Nkiym+vx62n0Bvd9fr85UKkN7B+5d9tSv?=
 =?us-ascii?Q?4/fZJQveK2wA9i4ELSAA3u39/Dls6HKrkX/Q4sT6zJmT/vVgi5h8wdwc0F0J?=
 =?us-ascii?Q?eQWqBp6J+Gm5S40DY3tggRlXxfelJzvq9/WzLCxPZucNvoxwKUGJ9N0V2S/d?=
 =?us-ascii?Q?NjO2aNHgvZlXU+dO5yfvhMmnM3zwC3DmGZWE5EOPVcgNLgk85dYcK21CIFAp?=
 =?us-ascii?Q?vDs6mZZNCOQcUU4iJ0rP/QkzLwagITYj+6szNYRmwiC2e8Ji0BE33KtBMNyb?=
 =?us-ascii?Q?sEPjQz1evon2LnFBNDN9XCZILHN61evS8m4L6X3mBhd/nPdfi5za9yw6kIgr?=
 =?us-ascii?Q?y/cV3r/pLuIrS5J0mGQG8gGDz+RPVqeS2JSPPzgVCPnIniWobqLmGbxV8jhd?=
 =?us-ascii?Q?8gjjcQg+Kxy5rn5ME2PXfUwHOAPzcnH/WeFGWuf4CxCIO+4aIPTv5ObrF02c?=
 =?us-ascii?Q?R6X+jdib6XEoZ75eo0cmytisMsWh+I3H4Hhd2ArHj4GBSSYdgmQrw1dq5eWc?=
 =?us-ascii?Q?Lwin4Agrbf6r/puYfc1OvPv9fITX7ThFbSVmgv6fiHk70Z0j4xEDWLZYvvSe?=
 =?us-ascii?Q?P1bka3JQBvCKr4g0OW1hHBCyKP+9KIg1Dt3SgG+QN15rk49c5B3JHUif/oO3?=
 =?us-ascii?Q?/zrMjhpoVIQRCWWcwthd/fx3HJEXfH0xC504DNBVHs2Va2aCktzD83bGW+0l?=
 =?us-ascii?Q?N4xibdlSU90V3tMyGYHLTTQjGzh5995VULmwwnGxxMwc28Ot6bDezieKa/2Q?=
 =?us-ascii?Q?rIDkkjuMFPgd1y34ZiT4q8V45KY9J+1CoDz4CyXrKpuI10/vmT5zWfjjQ/vd?=
 =?us-ascii?Q?NaTWy8TFhc6UhuvuKJNxFgwVhbJDOkxq+LM2xTBHxI1oHhGAjU2H5R+f9cUz?=
 =?us-ascii?Q?gwHGV/yf97eMWTiJPx3ftXVDjtbIrRk+7Q/ONkb3UewWS5NOP0Ctrt1KpmfI?=
 =?us-ascii?Q?ljHnKH/i8IpSsaldJsi0sDUeKO7KmKo4SsBz0q3bzJdCET3hwQNfOtHX3Qw7?=
 =?us-ascii?Q?8nfqIH+Rb9PeaiG5EYyKjE8YjpvlgARXpndGCY8ihKpv5Qcr8AnXcYs0EF01?=
 =?us-ascii?Q?FpErQiC2OO8a1SnkWx8tPKwZ1/nj6BCvU9+FtaFC2E7QhHzAt7mQOPLu2sFJ?=
 =?us-ascii?Q?+LQhOG/Fngx3NsIo74a6oGXfvC/5n0vIDNSTSeJ9Ppqwi2oCMwGsZHIEZQfd?=
 =?us-ascii?Q?DT5R6K00yVFUu5FgxunU9Q1rVwe7lmX+Uz0aJsYPMDtGKODEnZidZSAjxmXE?=
 =?us-ascii?Q?OIy+vOLzZNkOjASHsbbeJRXp6+POeDjLpylW5PEloaTPUofqEKFoldE4u/5Y?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfaedb37-f894-44f0-baab-08db082a33c3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:09:15.5045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFZWl0ar8O4FagS4wxTDltUJ5qOLx6Ba4PEVs4LW9LyvEIlTprB/dlIS05hJQS1lB8P2RB+NvGDkJtN6uO02kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7735
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Schedule NAPI by hand from enetc_xsk_wakeup(), and send frames from the
XSK TX queue from NAPI context. Add them to the completion queue from
the enetc_clean_tx_ring() procedure which is common for all kinds of
traffic.

We reuse one of the TX rings for XDP (XDP_TX/XDP_REDIRECT) for XSK as
well. They are already cropped from the TX rings that the network stack
can use when XDP is enabled (with or without AF_XDP).

As for XDP_REDIRECT calling enetc's ndo_xdp_xmit, I'm not sure if that
can run simultaneously with enetc_poll() (on different CPUs, but towards
the same TXQ). I guess it probably can, but idk what to do about it.
The problem is that enetc_xdp_xmit() sends to
priv->xdp_tx_ring[smp_processor_id()], while enetc_xsk_xmit() and XDP_TX
send to priv->xdp_tx_ring[NAPI instance]. So when the NAPI instance runs
on a different CPU that the one it is numerically equal to, we should
have a lock that serializes XDP_REDIRECT with the others.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 102 ++++++++++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc.h |   2 +
 2 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3990c006c011..bc0db788afc7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -84,7 +84,7 @@ static void enetc_free_tx_swbd(struct enetc_bdr *tx_ring,
 	struct xdp_frame *xdp_frame = enetc_tx_swbd_get_xdp_frame(tx_swbd);
 	struct sk_buff *skb = enetc_tx_swbd_get_skb(tx_swbd);
 
-	if (tx_swbd->dma)
+	if (!tx_swbd->is_xsk && tx_swbd->dma)
 		enetc_unmap_tx_buff(tx_ring, tx_swbd);
 
 	if (xdp_frame) {
@@ -817,7 +817,8 @@ static void enetc_recycle_xdp_tx_buff(struct enetc_bdr *tx_ring,
 	rx_ring->xdp.xdp_tx_in_flight--;
 }
 
-static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
+static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget,
+				int *xsk_confirmed)
 {
 	int tx_frm_cnt = 0, tx_byte_cnt = 0, tx_win_drop = 0;
 	struct net_device *ndev = tx_ring->ndev;
@@ -854,7 +855,9 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 				tx_win_drop++;
 		}
 
-		if (tx_swbd->is_xdp_tx)
+		if (tx_swbd->is_xsk)
+			(*xsk_confirmed)++;
+		else if (tx_swbd->is_xdp_tx)
 			enetc_recycle_xdp_tx_buff(tx_ring, tx_swbd);
 		else if (likely(tx_swbd->dma))
 			enetc_unmap_tx_buff(tx_ring, tx_swbd);
@@ -1465,6 +1468,58 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 }
 EXPORT_SYMBOL_GPL(enetc_xdp_xmit);
 
+static void enetc_xsk_map_tx_desc(struct enetc_tx_swbd *tx_swbd,
+				  const struct xdp_desc *xsk_desc,
+				  struct xsk_buff_pool *pool)
+{
+	dma_addr_t dma;
+
+	dma = xsk_buff_raw_get_dma(pool, xsk_desc->addr);
+	xsk_buff_raw_dma_sync_for_device(pool, dma, xsk_desc->len);
+
+	tx_swbd->dma = dma;
+	tx_swbd->len = xsk_desc->len;
+	tx_swbd->is_xsk = true;
+	tx_swbd->is_eof = true;
+}
+
+static bool enetc_xsk_xmit(struct net_device *ndev, struct xsk_buff_pool *pool,
+			   u32 queue_id)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct xdp_desc *xsk_descs = pool->tx_descs;
+	struct enetc_tx_swbd tx_swbd = {0};
+	struct enetc_bdr *tx_ring;
+	u32 budget, batch;
+	int i, k;
+
+	tx_ring = priv->xdp_tx_ring[queue_id];
+
+	/* Shouldn't race with anyone because we are running in the softirq
+	 * of the only CPU that sends packets to this TX ring
+	 */
+	budget = min(enetc_bd_unused(tx_ring) - 1, ENETC_XSK_TX_BATCH);
+
+	batch = xsk_tx_peek_release_desc_batch(pool, budget);
+	if (!batch)
+		return true;
+
+	i = tx_ring->next_to_use;
+
+	for (k = 0; k < batch; k++) {
+		enetc_xsk_map_tx_desc(&tx_swbd, &xsk_descs[k], pool);
+		enetc_xdp_map_tx_buff(tx_ring, i, &tx_swbd, tx_swbd.len);
+		enetc_bdr_idx_inc(tx_ring, &i);
+	}
+
+	tx_ring->next_to_use = i;
+
+	xsk_tx_release(pool);
+	enetc_update_tx_ring_tail(tx_ring);
+
+	return budget != batch;
+}
+
 static void enetc_map_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 				     struct xdp_buff *xdp_buff, u16 size)
 {
@@ -1881,6 +1936,7 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	struct enetc_bdr *rx_ring = &v->rx_ring;
 	struct xsk_buff_pool *pool;
 	struct bpf_prog *prog;
+	int xsk_confirmed = 0;
 	bool complete = true;
 	int work_done;
 	int i;
@@ -1888,7 +1944,8 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	enetc_lock_mdio();
 
 	for (i = 0; i < v->count_tx_rings; i++)
-		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
+		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget,
+					 &xsk_confirmed))
 			complete = false;
 
 	prog = rx_ring->xdp.prog;
@@ -1901,6 +1958,17 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 	else
 		work_done = enetc_clean_rx_ring(rx_ring, napi, budget);
 
+	if (pool) {
+		if (xsk_confirmed)
+			xsk_tx_completed(pool, xsk_confirmed);
+
+		if (xsk_uses_need_wakeup(pool))
+			xsk_set_tx_need_wakeup(pool);
+
+		if (!enetc_xsk_xmit(rx_ring->ndev, pool, rx_ring->index))
+			complete = false;
+	}
+
 	if (work_done == budget)
 		complete = false;
 	if (work_done)
@@ -3122,7 +3190,31 @@ static int enetc_setup_xsk_pool(struct net_device *ndev,
 
 int enetc_xsk_wakeup(struct net_device *ndev, u32 queue_id, u32 flags)
 {
-	/* xp_assign_dev() wants this; nothing needed for RX */
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_int_vector *v;
+	struct enetc_bdr *rx_ring;
+
+	if (!netif_running(ndev) || !netif_carrier_ok(ndev))
+		return -ENETDOWN;
+
+	if (queue_id >= priv->bdr_int_num)
+		return -ERANGE;
+
+	v = priv->int_vector[queue_id];
+	rx_ring = &v->rx_ring;
+
+	if (!rx_ring->xdp.xsk_pool || !rx_ring->xdp.prog)
+		return -EINVAL;
+
+	/* No way to kick TX by triggering a hardirq right away =>
+	 * raise softirq. This might schedule NAPI on a CPU different than the
+	 * smp_affinity of its IRQ would suggest, but that would happen anyway
+	 * if, say, we change that affinity under heavy traffic.
+	 * So enetc_poll() has to be prepared for it anyway.
+	 */
+	if (!napi_if_scheduled_mark_missed(&v->napi))
+		napi_schedule(&v->napi);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index e1a746e37c9a..403f40473b52 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -36,6 +36,7 @@ struct enetc_tx_swbd {
 	u8 is_eof:1;
 	u8 is_xdp_tx:1;
 	u8 is_xdp_redirect:1;
+	u8 is_xsk:1;
 	u8 qbv_en:1;
 };
 
@@ -86,6 +87,7 @@ struct enetc_xdp_data {
 #define ENETC_RX_RING_DEFAULT_SIZE	2048
 #define ENETC_TX_RING_DEFAULT_SIZE	2048
 #define ENETC_DEFAULT_TX_WORK		(ENETC_TX_RING_DEFAULT_SIZE / 2)
+#define ENETC_XSK_TX_BATCH		ENETC_DEFAULT_TX_WORK
 
 struct enetc_bdr_resource {
 	/* Input arguments saved for teardown */
-- 
2.34.1

