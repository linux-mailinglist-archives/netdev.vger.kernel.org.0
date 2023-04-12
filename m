Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32946E00A4
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjDLVRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjDLVRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:17:41 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0DB7ED6;
        Wed, 12 Apr 2023 14:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Odjc7qTGrXCBaQ4aSNBVmm2CQY2IlMzBXpaN8tsFCOQWsx2Z9k0A3TGmBrzRL8INNVExLZoXHY7nJWBTnMXNm6zX1Yq87T0IBgAqxaasQGV/fAiZJSq7Raso9j9H4QHu8bKf9+dm6uiJ/O4zbBvQP+JIi4mC3pEyFw+XY+MqOaYF7xgbBf7+AOi6LHrQpuFyVQdSMeFTQ7T6LOlIfx+seATDpdKPokdqXZJMT6Fmk89wuv2eE++vGynIbPxpJ6JJsViat2ex09rnZwICUPTxtAhYJc9UtScB5XZbjlE+HYQKxN0kjEm2xBVukejOJfxEqI1aGo3FndFledlKMsUO9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZHeOrMEPIfOBeDg3O0e6mKqr3YUEXRj2hGYu9uyflU=;
 b=MxQ5NTDvsPBw/q3h9zYDDHOKlb/g5hGD1DAxO55nPppVJNkUJs+Hss9UxU4++LVP7sgQGt6wCWiBMfac0urU0KfYNNT74MIiJe+QE320FaSVthQKnWA4DXVvLGZzEkw3nzZOjUT3NQQpN/PozKlPE6Vbuta9Bk1cYGIAu6tMQjbJVllvSxGlWUa1LKQ7pJciGoK02CX13wh6CEIoNXj6TATh9f/bvBTDSTGsA8Nmkm278RagM10p7tVVUnxflrP/9vO6GRlJpaJ2LVTxk/jju7Gca1wUkfjadxRSHvG1yuXuqEej1lsgEwLTtWhCt+FmF9qBPPPKu0Ze2Xx6Ic0f0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZHeOrMEPIfOBeDg3O0e6mKqr3YUEXRj2hGYu9uyflU=;
 b=K5fgY0dXX2ikWTngUhY7z3qHqxQtSB6L4F4016In3GOH6W0Gunj/LYNu56Q1Rr3wDIqBfamPqyUVfPAdJ8GdDinR6f2J1spTC52rL2tVcOXUA7XqDWCKFzk1VKb/+6Y3FWsdaBnHoeZGwGO8IFCRMiZbd2vBq/mD9T0FPvt3UJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by SA0PR21MB1881.namprd21.prod.outlook.com (2603:10b6:806:e6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Wed, 12 Apr
 2023 21:17:25 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968%6]) with mapi id 15.20.6319.004; Wed, 12 Apr 2023
 21:17:25 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer allocation code to prepare for various MTU
Date:   Wed, 12 Apr 2023 14:16:01 -0700
Message-Id: <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:907::15)
 To BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|SA0PR21MB1881:EE_
X-MS-Office365-Filtering-Correlation-Id: e4569b92-38fe-4a49-0170-08db3b9b5031
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o4N0ryygy5jTpWegHCqPXZo9qwGvqZV58npebk2+iO41di5fPxpxoSIj1OgPQt7Zbnc1fiaTQHyFK+5+nCSjK84G3f4tNIRFXlC9E0f0VUdsYTztD5LcKkRW8cCxbkX6FN7uEdDGPADyzNRf49znHwXEH13iPjxCYYAi0/+FJn1e/WAMie+6bx0GuNkh7sCjo++WHodWE4Q5rWUaoGYUmXFVGU84B3yW33HRrD3yNrM/0oEiZgUch/+bHzEjnZjSunlkRJHHleEZkaoB2w0o14UKmguCP8DMV+WtGN5jP7/hrdUwxJ3m65/7oqy4Rn6QttRbqGom6tEj2kSbJ0wsYG/85KjdUO7jAfETok8B2Sl6026LdmPPt/VUuEgkdT+i220+BmBTBfvgALvlVyEAET6zLUeq5qDOIVkJZQ9CqI7bh+xJPb/TwtLQXEBlQ76N8tfY/YNo58FWw+qlIS8avz3vQd7UqjRxdMJAKRbaWmjDzcz2SE66GLo7ezAGX41yIrIL3IpByHAql0YF0JsfziZS1gjTVRawZcAyTTHfFW0ExLBeEX/kFuZLwBWs8r9zOp/UM0bogMdA+EjW6NCHbsNO1cswylN6mnpZcuxbZQW8r72XVUHi9XGLgp1Ov1k1C3DUyQ2vXrBZgbPbA9uo53oACnnBUlDyOAqXmfsSBI8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199021)(8676002)(38350700002)(38100700002)(2616005)(83380400001)(7846003)(186003)(478600001)(52116002)(10290500003)(6486002)(6666004)(316002)(26005)(6506007)(6512007)(2906002)(5660300002)(7416002)(36756003)(4326008)(82950400001)(66476007)(66946007)(82960400001)(41300700001)(66556008)(786003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gLasJH+rAUBEjW/FDAP9DrZmPEOXQUU90uw6LhGAyCkFXRPPtlbs7IMnMNi1?=
 =?us-ascii?Q?J5Kpn8lsVjKbdlq83iasBKn2ZefuolVrgt8sqrujW/PpjJUdC0BgIUNUIi5Q?=
 =?us-ascii?Q?JQIDOBzcsU9YVRK7eaVZpli2mh09WxVTAnbOM9eIaBAYcpQRc/Ck5aSrSJ4k?=
 =?us-ascii?Q?B/vAx+txldz4b6FFhtDp4EO9RBcHsNU4VWoLPtt9NlnSuHDnYK7YSA3vbeXP?=
 =?us-ascii?Q?dtr+w3WnMLJktaGJcn8jP1gQlxpclkOMOnNrq0fkhzEEN4seHqY3Ab+fkyjn?=
 =?us-ascii?Q?5u+HiJtti8feBjywuO57skgNhWsEmd8UIXi8S8KCpJDwHDjA7euDWQMLjtf1?=
 =?us-ascii?Q?QO2ULdKng6iNcEZlVFaQTht+wmpfcqiqpkprCsomf1U9V4gtZw+ydxGJoSUg?=
 =?us-ascii?Q?PNAoHhHF10m2D6QAtyNixjIIndd41ArA9gZOSVe4NfApWHrYN1MgbYPBEtSR?=
 =?us-ascii?Q?QtHTbNzJwhNdrNclQQpOCA7EAN/1ipfbznCbcmrxtySsemAvFifGEBk+7c//?=
 =?us-ascii?Q?hYwxUlrFEA8NfqX8XMQQoW0W0G/H0g+8vwy0J6APL9rPPg4I3mNPQ/8t+WG0?=
 =?us-ascii?Q?edR0lH0E3Kh+vw9e9Hc5x9yngjO+D/zguiRfEjDFcolKInA1myJx666NX40l?=
 =?us-ascii?Q?v5fWFAsSEOX7P8G/Gem9BaLv/hiTOWdRCK9U1MdOYroLdVU8u/rEmFmkJoIL?=
 =?us-ascii?Q?8tQD4TmYupW1h+B8zEj2AeqUf9PXNMX3NLvos7TrMlzXACElFBIq7TEjl3S7?=
 =?us-ascii?Q?9KO36D9lOns2aI84TD3zXnemNvCJcoqv4zgw0noWipko1mFV/AfdiYgOEjx6?=
 =?us-ascii?Q?ct3Q7EG/zCTCuM0K4CwPGWne7KVCXCrjlT80Q4Tfnla1yKosI5ZZfPptqtjj?=
 =?us-ascii?Q?fiyk78QXOwayjuFqh+lyuxNa7J23qFt7rPl1u2APoedp0BJsCYOq8CgunUlF?=
 =?us-ascii?Q?5ZB1HSB+EPlyC7tOKk1pER4n14v2ORERbErPeTMHCIPCm3kvGxUI22AcllBp?=
 =?us-ascii?Q?eId4HwCsUvOffKA3vFTb0iIYWqnYzohPe/VqIqJuR4vIjuzTB9TV4j+F7AYo?=
 =?us-ascii?Q?3LBqSmzOVFukYIvBxcysn44ObDTpBR+90S/DfR8m6oS8TmELy245NTJMo+/g?=
 =?us-ascii?Q?xn2z1ALMncR2MluNd70c+KzxAaO5dAND1fIhf/WK4nxvjHO0SJzx9dLcDg+S?=
 =?us-ascii?Q?JyPHZWaP2+zSqCGqRy3d9t8f53QHFzMiLbN633AR8PgTjRrd4UNo7wxGA9lO?=
 =?us-ascii?Q?kvKoMTA0xesn0h5nLTfXSGXySr9CTRxmjUwc3pmpHAg5rPF7bHoVCSN+UYGZ?=
 =?us-ascii?Q?Xne9yQWF0iX+oRu8pVfPxY/Ki7Iqr3MTNDMM0Rk4ZH4KeB60+amym3SH1cFz?=
 =?us-ascii?Q?qdnn1myiOJnIqAIZgqMr20cX+gcY04mp0jmkmlVPrBZA6t22CVGrScElKULE?=
 =?us-ascii?Q?m/GSN6lfwrcPov1BefBqwgTMN+wgqnpsIlToU6hpBUECMEeQ+AIYQDKGzKLm?=
 =?us-ascii?Q?vASuhGnxKLWFOMMwmBY7NVCWRIbdZDja6w9+VhovL0+UZIwEZKpdidd2gJig?=
 =?us-ascii?Q?EDS4mONy068H5nCiPrbdSvA8DyNAvwYVzNj7h6yM?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4569b92-38fe-4a49-0170-08db3b9b5031
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:17:25.5506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dtndnihy2Z9PVFw7cSPCKHu81jcA5AuHuEppzWj5yJx45/VnzqqZldzCRolLsmb9RSAlA/4FsILtDgJwnN6wCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1881
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move out common buffer allocation code from mana_process_rx_cqe() and
mana_alloc_rx_wqe() to helper functions.
Refactor related variables so they can be changed in one place, and buffer
sizes are in sync.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
V3:
Refectored to multiple patches for readability. Suggested by Jacob Keller.

V2:
Refectored to multiple patches for readability. Suggested by Yunsheng Lin.

---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 154 ++++++++++--------
 include/net/mana/mana.h                       |   6 +-
 2 files changed, 91 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 112c642dc89b..911954ff84ee 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1282,14 +1282,64 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	u64_stats_update_end(&rx_stats->syncp);
 
 drop:
-	WARN_ON_ONCE(rxq->xdp_save_page);
-	rxq->xdp_save_page = virt_to_page(buf_va);
+	WARN_ON_ONCE(rxq->xdp_save_va);
+	/* Save for reuse */
+	rxq->xdp_save_va = buf_va;
 
 	++ndev->stats.rx_dropped;
 
 	return;
 }
 
+static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
+			     dma_addr_t *da, bool is_napi)
+{
+	struct page *page;
+	void *va;
+
+	/* Reuse XDP dropped page if available */
+	if (rxq->xdp_save_va) {
+		va = rxq->xdp_save_va;
+		rxq->xdp_save_va = NULL;
+	} else {
+		page = dev_alloc_page();
+		if (!page)
+			return NULL;
+
+		va = page_to_virt(page);
+	}
+
+	*da = dma_map_single(dev, va + XDP_PACKET_HEADROOM, rxq->datasize,
+			     DMA_FROM_DEVICE);
+
+	if (dma_mapping_error(dev, *da)) {
+		put_page(virt_to_head_page(va));
+		return NULL;
+	}
+
+	return va;
+}
+
+/* Allocate frag for rx buffer, and save the old buf */
+static void mana_refill_rxoob(struct device *dev, struct mana_rxq *rxq,
+			      struct mana_recv_buf_oob *rxoob, void **old_buf)
+{
+	dma_addr_t da;
+	void *va;
+
+	va = mana_get_rxfrag(rxq, dev, &da, true);
+
+	if (!va)
+		return;
+
+	dma_unmap_single(dev, rxoob->sgl[0].address, rxq->datasize,
+			 DMA_FROM_DEVICE);
+	*old_buf = rxoob->buf_va;
+
+	rxoob->buf_va = va;
+	rxoob->sgl[0].address = da;
+}
+
 static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 				struct gdma_comp *cqe)
 {
@@ -1299,10 +1349,8 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	struct mana_recv_buf_oob *rxbuf_oob;
 	struct mana_port_context *apc;
 	struct device *dev = gc->dev;
-	void *new_buf, *old_buf;
-	struct page *new_page;
+	void *old_buf = NULL;
 	u32 curr, pktlen;
-	dma_addr_t da;
 
 	apc = netdev_priv(ndev);
 
@@ -1345,40 +1393,11 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	rxbuf_oob = &rxq->rx_oobs[curr];
 	WARN_ON_ONCE(rxbuf_oob->wqe_inf.wqe_size_in_bu != 1);
 
-	/* Reuse XDP dropped page if available */
-	if (rxq->xdp_save_page) {
-		new_page = rxq->xdp_save_page;
-		rxq->xdp_save_page = NULL;
-	} else {
-		new_page = alloc_page(GFP_ATOMIC);
-	}
-
-	if (new_page) {
-		da = dma_map_page(dev, new_page, XDP_PACKET_HEADROOM, rxq->datasize,
-				  DMA_FROM_DEVICE);
-
-		if (dma_mapping_error(dev, da)) {
-			__free_page(new_page);
-			new_page = NULL;
-		}
-	}
-
-	new_buf = new_page ? page_to_virt(new_page) : NULL;
-
-	if (new_buf) {
-		dma_unmap_page(dev, rxbuf_oob->buf_dma_addr, rxq->datasize,
-			       DMA_FROM_DEVICE);
-
-		old_buf = rxbuf_oob->buf_va;
-
-		/* refresh the rxbuf_oob with the new page */
-		rxbuf_oob->buf_va = new_buf;
-		rxbuf_oob->buf_dma_addr = da;
-		rxbuf_oob->sgl[0].address = rxbuf_oob->buf_dma_addr;
-	} else {
-		old_buf = NULL; /* drop the packet if no memory */
-	}
+	mana_refill_rxoob(dev, rxq, rxbuf_oob, &old_buf);
 
+	/* Unsuccessful refill will have old_buf == NULL.
+	 * In this case, mana_rx_skb() will drop the packet.
+	 */
 	mana_rx_skb(old_buf, oob, rxq);
 
 drop:
@@ -1659,8 +1678,8 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 
 	mana_deinit_cq(apc, &rxq->rx_cq);
 
-	if (rxq->xdp_save_page)
-		__free_page(rxq->xdp_save_page);
+	if (rxq->xdp_save_va)
+		put_page(virt_to_head_page(rxq->xdp_save_va));
 
 	for (i = 0; i < rxq->num_rx_buf; i++) {
 		rx_oob = &rxq->rx_oobs[i];
@@ -1668,10 +1687,10 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 		if (!rx_oob->buf_va)
 			continue;
 
-		dma_unmap_page(dev, rx_oob->buf_dma_addr, rxq->datasize,
-			       DMA_FROM_DEVICE);
+		dma_unmap_single(dev, rx_oob->sgl[0].address,
+				 rx_oob->sgl[0].size, DMA_FROM_DEVICE);
 
-		free_page((unsigned long)rx_oob->buf_va);
+		put_page(virt_to_head_page(rx_oob->buf_va));
 		rx_oob->buf_va = NULL;
 	}
 
@@ -1681,6 +1700,26 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	kfree(rxq);
 }
 
+static int mana_fill_rx_oob(struct mana_recv_buf_oob *rx_oob, u32 mem_key,
+			    struct mana_rxq *rxq, struct device *dev)
+{
+	dma_addr_t da;
+	void *va;
+
+	va = mana_get_rxfrag(rxq, dev, &da, false);
+
+	if (!va)
+		return -ENOMEM;
+
+	rx_oob->buf_va = va;
+
+	rx_oob->sgl[0].address = da;
+	rx_oob->sgl[0].size = rxq->datasize;
+	rx_oob->sgl[0].mem_key = mem_key;
+
+	return 0;
+}
+
 #define MANA_WQE_HEADER_SIZE 16
 #define MANA_WQE_SGE_SIZE 16
 
@@ -1690,9 +1729,8 @@ static int mana_alloc_rx_wqe(struct mana_port_context *apc,
 	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
 	struct mana_recv_buf_oob *rx_oob;
 	struct device *dev = gc->dev;
-	struct page *page;
-	dma_addr_t da;
 	u32 buf_idx;
+	int ret;
 
 	WARN_ON(rxq->datasize == 0 || rxq->datasize > PAGE_SIZE);
 
@@ -1703,25 +1741,12 @@ static int mana_alloc_rx_wqe(struct mana_port_context *apc,
 		rx_oob = &rxq->rx_oobs[buf_idx];
 		memset(rx_oob, 0, sizeof(*rx_oob));
 
-		page = alloc_page(GFP_KERNEL);
-		if (!page)
-			return -ENOMEM;
-
-		da = dma_map_page(dev, page, XDP_PACKET_HEADROOM, rxq->datasize,
-				  DMA_FROM_DEVICE);
-
-		if (dma_mapping_error(dev, da)) {
-			__free_page(page);
-			return -ENOMEM;
-		}
-
-		rx_oob->buf_va = page_to_virt(page);
-		rx_oob->buf_dma_addr = da;
-
 		rx_oob->num_sge = 1;
-		rx_oob->sgl[0].address = rx_oob->buf_dma_addr;
-		rx_oob->sgl[0].size = rxq->datasize;
-		rx_oob->sgl[0].mem_key = apc->ac->gdma_dev->gpa_mkey;
+
+		ret = mana_fill_rx_oob(rx_oob, apc->ac->gdma_dev->gpa_mkey, rxq,
+				       dev);
+		if (ret)
+			return ret;
 
 		rx_oob->wqe_req.sgl = rx_oob->sgl;
 		rx_oob->wqe_req.num_sge = rx_oob->num_sge;
@@ -1780,9 +1805,10 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	rxq->ndev = ndev;
 	rxq->num_rx_buf = RX_BUFFERS_PER_QUEUE;
 	rxq->rxq_idx = rxq_idx;
-	rxq->datasize = ALIGN(MAX_FRAME_SIZE, 64);
 	rxq->rxobj = INVALID_MANA_HANDLE;
 
+	rxq->datasize = ALIGN(ETH_FRAME_LEN, 64);
+
 	err = mana_alloc_rx_wqe(apc, rxq, &rq_size, &cq_size);
 	if (err)
 		goto out;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index bb11a6535d80..037bcabf6b98 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -36,9 +36,6 @@ enum TRI_STATE {
 
 #define COMP_ENTRY_SIZE 64
 
-#define ADAPTER_MTU_SIZE 1500
-#define MAX_FRAME_SIZE (ADAPTER_MTU_SIZE + 14)
-
 #define RX_BUFFERS_PER_QUEUE 512
 
 #define MAX_SEND_BUFFERS_PER_QUEUE 256
@@ -282,7 +279,6 @@ struct mana_recv_buf_oob {
 	struct gdma_wqe_request wqe_req;
 
 	void *buf_va;
-	dma_addr_t buf_dma_addr;
 
 	/* SGL of the buffer going to be sent has part of the work request. */
 	u32 num_sge;
@@ -322,7 +318,7 @@ struct mana_rxq {
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
-	struct page *xdp_save_page;
+	void *xdp_save_va; /* for reusing */
 	bool xdp_flush;
 	int xdp_rc; /* XDP redirect return code */
 
-- 
2.25.1

