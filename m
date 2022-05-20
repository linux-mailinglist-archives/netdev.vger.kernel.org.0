Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F190652F22A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352437AbiETSMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352428AbiETSMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:12:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2F1E52AC;
        Fri, 20 May 2022 11:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC3C60FF1;
        Fri, 20 May 2022 18:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BCEC34116;
        Fri, 20 May 2022 18:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070347;
        bh=0hDAKVM6YH6gIxA25jk8QajliGXLumpZOREVwF1ZjI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOyyfN188Vu+xRsaB+Qu+MZJHdkdz5UNIJEpR3xPOxMv+a8W8NeVNj+ftEVnMJtuQ
         QAw8oF7ylSQTG5wJ3ljjqjTfzMY0B8vy5h0+3qLfcoTjeAOyAIyElCwybMfMsePS8N
         fGI3YLQiFsc32NO6tf6VbeCPom4n1H3gjkw0F8M0ClOzJQpE64oRHOscSlyyyrpa6I
         0UpUD6nIlbPsWZP//X1HJ0EEtx00LbnjHMO7oTta7ehf/DG6TgA5mbCIRlr9zCOcKQ
         KVjkuOz9rAsz5x+zbyc2G3JUeHDMcRhHLZNX5DilsQJyY5h0go9OSixGaNCNH58BRK
         LFEQ62+BRhYVw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 03/16] net: ethernet: mtk_eth_soc: rely on GFP_KERNEL for dma_alloc_coherent whenever possible
Date:   Fri, 20 May 2022 20:11:26 +0200
Message-Id: <2962c1559ff67d2095acbb51d2bcd1dfd8b0abe4.1653069056.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653069056.git.lorenzo@kernel.org>
References: <cover.1653069056.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on GFP_KERNEL for dma descriptors mappings in mtk_tx_alloc(),
mtk_rx_alloc() and mtk_init_fq_dma() since they are run in non-irq
context.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 16f131445d8b..ccd864c968b2 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -816,7 +816,7 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 	eth->scratch_ring = dma_alloc_coherent(eth->dma_dev,
 					       cnt * sizeof(struct mtk_tx_dma),
 					       &eth->phy_scratch_ring,
-					       GFP_ATOMIC);
+					       GFP_KERNEL);
 	if (unlikely(!eth->scratch_ring))
 		return -ENOMEM;
 
@@ -1591,7 +1591,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		goto no_tx_mem;
 
 	ring->dma = dma_alloc_coherent(eth->dma_dev, MTK_DMA_SIZE * sz,
-				       &ring->phys, GFP_ATOMIC);
+				       &ring->phys, GFP_KERNEL);
 	if (!ring->dma)
 		goto no_tx_mem;
 
@@ -1609,8 +1609,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	 */
 	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
 		ring->dma_pdma = dma_alloc_coherent(eth->dma_dev, MTK_DMA_SIZE * sz,
-						    &ring->phys_pdma,
-						    GFP_ATOMIC);
+						    &ring->phys_pdma, GFP_KERNEL);
 		if (!ring->dma_pdma)
 			goto no_tx_mem;
 
@@ -1722,7 +1721,7 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 
 	ring->dma = dma_alloc_coherent(eth->dma_dev,
 				       rx_dma_size * sizeof(*ring->dma),
-				       &ring->phys, GFP_ATOMIC);
+				       &ring->phys, GFP_KERNEL);
 	if (!ring->dma)
 		return -ENOMEM;
 
-- 
2.35.3

