Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F4C631D82
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiKUJ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiKUJ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:56:50 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27BC1000;
        Mon, 21 Nov 2022 01:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3ZrcEtYNl25nMMTHcFNumGxaVkHJAIv216WY/T0hEPc=; b=zJZpqq/GXfQ9jFVIK1WYOzgOcP
        aTtLj8x3ST6Ewj4hwx0cYsbqezTbCzAYzIv1rDB7HXZoo01idEIx70CVxBpuWcUK3omsvMv1li2qm
        +l7UAIhx0bnx+QpuXzCM1cORjhzesboJz8sVFIVH6J4Ul3/45hecWgDdqWOeJr1W4yOXMQiVEgk50
        cAZ6etUXFiRcX4dSuNq3BEbyT+y1n/Zs2yfuXYAbS04pYVDaBx4Yc9Td7+vmYbkxzwPamm2jrTu7Y
        hBAe3nMC6xqNy6ZEHCqxCeRntdgIqvRpOac0NmFd1Th4YkDOZXnXAQpuSOqhkX8nGisYNRTQ2uTam
        69ZoS0Kg==;
Received: from [2001:4bb8:199:6d04:3c43:44c4:4e80:d8ad] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ox3XY-00C2Do-Nv; Mon, 21 Nov 2022 09:56:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Ungerer <gerg@linux-m68k.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-m68k@lists.linux-m68k.org, uclinux-dev@uclinux.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/2] net: fec: use dma_alloc_noncoherent for m532x
Date:   Mon, 21 Nov 2022 10:56:30 +0100
Message-Id: <20221121095631.216209-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121095631.216209-1-hch@lst.de>
References: <20221121095631.216209-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The m532x coldfire platforms can't properly implement dma_alloc_coherent
and currently just return noncoherent memory from it.  The fec driver
than works around this with a flush of all caches in the receive path.
Make this hack a little less bad by using the explicit
dma_alloc_noncoherent API and documenting the hacky cache flushes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/freescale/fec_main.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 28ef4d3c18789..5230698310b5e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1580,6 +1580,10 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	struct page *page;
 
 #ifdef CONFIG_M532x
+	/*
+	 * Hacky flush of all caches instead of using the DMA API for the TSO
+	 * headers.
+	 */
 	flush_cache_all();
 #endif
 	rxq = fep->rx_queue[queue_id];
@@ -3123,10 +3127,17 @@ static void fec_enet_free_queue(struct net_device *ndev)
 	for (i = 0; i < fep->num_tx_queues; i++)
 		if (fep->tx_queue[i] && fep->tx_queue[i]->tso_hdrs) {
 			txq = fep->tx_queue[i];
+#ifdef CONFIG_M532x
 			dma_free_coherent(&fep->pdev->dev,
 					  txq->bd.ring_size * TSO_HEADER_SIZE,
 					  txq->tso_hdrs,
 					  txq->tso_hdrs_dma);
+#else
+			dma_free_noncoherent(&fep->pdev->dev,
+					  txq->bd.ring_size * TSO_HEADER_SIZE,
+					  txq->tso_hdrs, txq->tso_hdrs_dma,
+					  DMA_BIDIRECTIONAL);
+#endif
 		}
 
 	for (i = 0; i < fep->num_rx_queues; i++)
@@ -3157,10 +3168,18 @@ static int fec_enet_alloc_queue(struct net_device *ndev)
 		txq->tx_wake_threshold =
 			(txq->bd.ring_size - txq->tx_stop_threshold) / 2;
 
+#ifdef CONFIG_M532x
 		txq->tso_hdrs = dma_alloc_coherent(&fep->pdev->dev,
 					txq->bd.ring_size * TSO_HEADER_SIZE,
 					&txq->tso_hdrs_dma,
 					GFP_KERNEL);
+#else
+		/* m68knommu manually flushes all caches in fec_enet_rx_queue */
+		txq->tso_hdrs = dma_alloc_noncoherent(&fep->pdev->dev,
+					txq->bd.ring_size * TSO_HEADER_SIZE,
+					&txq->tso_hdrs_dma, DMA_BIDIRECTIONAL,
+					GFP_KERNEL);
+#endif
 		if (!txq->tso_hdrs) {
 			ret = -ENOMEM;
 			goto alloc_failed;
-- 
2.30.2

