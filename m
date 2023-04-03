Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A796D5072
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbjDCSbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbjDCSay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:30:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB523598
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mmW2of5j8eT53NQ+ccvEbaXu7Pbpt+mdfWtbhwkq5TI=; b=1dxmEOle3hs0BGW5ShqfIBj+iB
        0gOO+h6U/pZtZi8jCrYM+hdxEnxy3KgxnOBpkfzIX6iULLxiy11xPdJt09Vp0DRoYEZw4FvhFLt6I
        hh+jfmqgKlwqXzv/4KONHgqM5+3wuptm2zsM+kLeduCfr1Mx0cYOsyCxuGSEP7k8I4s3bmMDwIblq
        jNMDUp2G4zKTxldn8qw7z8l4RY26paqOqnREhisOFwqDV78aOS2pntFkHOXaflgsBapDaZSnLNyNJ
        stGLBVjJtyzsF/7jGbgt0X6r6KWWRJZZDuv4mwvhbGVTlYYt0D2lqfre3iBz6/0dpN0nKrcPKbPuf
        HC4sXDcA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45838 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pjOwz-00038F-98; Mon, 03 Apr 2023 19:30:41 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pjOwy-00Fml6-M8; Mon, 03 Apr 2023 19:30:40 +0100
In-Reply-To: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
References: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Marek Beh__n <kabel@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 5/5] net: mvneta: allocate TSO header DMA memory
 in chunks
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pjOwy-00Fml6-M8@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 03 Apr 2023 19:30:40 +0100
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we no longer need to check whether the DMA address is within
the TSO header DMA memory range for the queue, we can allocate the TSO
header DMA memory in chunks rather than one contiguous order-6 chunk,
which can stress the kernel's memory subsystems to allocate.

Instead, use order-1 (8k) allocations, which will result in 32 order-1
pages containing 32 TSO headers.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 88 +++++++++++++++++++++------
 1 file changed, 70 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index bea84e86cf99..6c6b66d3ea6e 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -344,6 +344,15 @@
 
 #define MVNETA_MAX_SKB_DESCS (MVNETA_MAX_TSO_SEGS * 2 + MAX_SKB_FRAGS)
 
+/* The size of a TSO header page */
+#define MVNETA_TSO_PAGE_SIZE (2 * PAGE_SIZE)
+
+/* Number of TSO headers per page. This should be a power of 2 */
+#define MVNETA_TSO_PER_PAGE (MVNETA_TSO_PAGE_SIZE / TSO_HEADER_SIZE)
+
+/* Maximum number of TSO header pages */
+#define MVNETA_MAX_TSO_PAGES (MVNETA_MAX_TXD / MVNETA_TSO_PER_PAGE)
+
 /* descriptor aligned size */
 #define MVNETA_DESC_ALIGNED_SIZE	32
 
@@ -687,10 +696,10 @@ struct mvneta_tx_queue {
 	int next_desc_to_proc;
 
 	/* DMA buffers for TSO headers */
-	char *tso_hdrs;
+	char *tso_hdrs[MVNETA_MAX_TSO_PAGES];
 
 	/* DMA address of TSO headers */
-	dma_addr_t tso_hdrs_phys;
+	dma_addr_t tso_hdrs_phys[MVNETA_MAX_TSO_PAGES];
 
 	/* Affinity mask for CPUs*/
 	cpumask_t affinity_mask;
@@ -2659,24 +2668,71 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 	return rx_done;
 }
 
+static void mvneta_free_tso_hdrs(struct mvneta_port *pp,
+				 struct mvneta_tx_queue *txq)
+{
+	struct device *dev = pp->dev->dev.parent;
+	int i;
+
+	for (i = 0; i < MVNETA_MAX_TSO_PAGES; i++) {
+		if (txq->tso_hdrs[i]) {
+			dma_free_coherent(dev, MVNETA_TSO_PAGE_SIZE,
+					  txq->tso_hdrs[i],
+					  txq->tso_hdrs_phys[i]);
+			txq->tso_hdrs[i] = NULL;
+		}
+	}
+}
+
+static int mvneta_alloc_tso_hdrs(struct mvneta_port *pp,
+				 struct mvneta_tx_queue *txq)
+{
+	struct device *dev = pp->dev->dev.parent;
+	int i, num;
+
+	num = DIV_ROUND_UP(txq->size, MVNETA_TSO_PER_PAGE);
+	for (i = 0; i < num; i++) {
+		txq->tso_hdrs[i] = dma_alloc_coherent(dev, MVNETA_TSO_PAGE_SIZE,
+						      &txq->tso_hdrs_phys[i],
+						      GFP_KERNEL);
+		if (!txq->tso_hdrs[i]) {
+			mvneta_free_tso_hdrs(pp, txq);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static char *mvneta_get_tso_hdr(struct mvneta_tx_queue *txq, dma_addr_t *dma)
+{
+	int index, offset;
+
+	index = txq->txq_put_index / MVNETA_TSO_PER_PAGE;
+	offset = (txq->txq_put_index % MVNETA_TSO_PER_PAGE) * TSO_HEADER_SIZE;
+
+	*dma = txq->tso_hdrs_phys[index] + offset;
+
+	return txq->tso_hdrs[index] + offset;
+}
+
 static void mvneta_tso_put_hdr(struct sk_buff *skb, struct mvneta_tx_queue *txq,
 			       struct tso_t *tso, int size, bool is_last)
 {
 	struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
-	int tso_offset, hdr_len = skb_tcp_all_headers(skb);
+	int hdr_len = skb_tcp_all_headers(skb);
 	struct mvneta_tx_desc *tx_desc;
+	dma_addr_t hdr_phys;
 	char *hdr;
 
-	tso_offset = txq->txq_put_index * TSO_HEADER_SIZE;
-
-	hdr = txq->tso_hdrs + tso_offset;
+	hdr = mvneta_get_tso_hdr(txq, &hdr_phys);
 	tso_build_hdr(skb, hdr, tso, size, is_last);
 
 	tx_desc = mvneta_txq_next_desc_get(txq);
 	tx_desc->data_size = hdr_len;
 	tx_desc->command = mvneta_skb_tx_csum(skb);
 	tx_desc->command |= MVNETA_TXD_F_DESC;
-	tx_desc->buf_phys_addr = txq->tso_hdrs_phys + tso_offset;
+	tx_desc->buf_phys_addr = hdr_phys;
 	buf->type = MVNETA_TYPE_TSO;
 	buf->skb = NULL;
 
@@ -3469,7 +3525,7 @@ static void mvneta_rxq_deinit(struct mvneta_port *pp,
 static int mvneta_txq_sw_init(struct mvneta_port *pp,
 			      struct mvneta_tx_queue *txq)
 {
-	int cpu;
+	int cpu, err;
 
 	txq->size = pp->tx_ring_size;
 
@@ -3494,11 +3550,9 @@ static int mvneta_txq_sw_init(struct mvneta_port *pp,
 		return -ENOMEM;
 
 	/* Allocate DMA buffers for TSO MAC/IP/TCP headers */
-	txq->tso_hdrs = dma_alloc_coherent(pp->dev->dev.parent,
-					   txq->size * TSO_HEADER_SIZE,
-					   &txq->tso_hdrs_phys, GFP_KERNEL);
-	if (!txq->tso_hdrs)
-		return -ENOMEM;
+	err = mvneta_alloc_tso_hdrs(pp, txq);
+	if (err)
+		return err;
 
 	/* Setup XPS mapping */
 	if (pp->neta_armada3700)
@@ -3550,10 +3604,7 @@ static void mvneta_txq_sw_deinit(struct mvneta_port *pp,
 
 	kfree(txq->buf);
 
-	if (txq->tso_hdrs)
-		dma_free_coherent(pp->dev->dev.parent,
-				  txq->size * TSO_HEADER_SIZE,
-				  txq->tso_hdrs, txq->tso_hdrs_phys);
+	mvneta_free_tso_hdrs(pp, txq);
 	if (txq->descs)
 		dma_free_coherent(pp->dev->dev.parent,
 				  txq->size * MVNETA_DESC_ALIGNED_SIZE,
@@ -3562,7 +3613,6 @@ static void mvneta_txq_sw_deinit(struct mvneta_port *pp,
 	netdev_tx_reset_queue(nq);
 
 	txq->buf               = NULL;
-	txq->tso_hdrs          = NULL;
 	txq->descs             = NULL;
 	txq->last_desc         = 0;
 	txq->next_desc_to_proc = 0;
@@ -5833,6 +5883,8 @@ static int __init mvneta_driver_init(void)
 {
 	int ret;
 
+	BUILD_BUG_ON_NOT_POWER_OF_2(MVNETA_TSO_PER_PAGE);
+
 	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "net/mvneta:online",
 				      mvneta_cpu_online,
 				      mvneta_cpu_down_prepare);
-- 
2.30.2

