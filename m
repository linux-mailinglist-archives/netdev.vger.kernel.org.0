Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D593C5960D9
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiHPRPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiHPRPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:15:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0526E71736
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:15:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B014AB8164B
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 17:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1F7C433C1;
        Tue, 16 Aug 2022 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660670105;
        bh=XHYU4LYQAmbNhHrkrLx9er6CglyvBpEC9FIKkn8jxvA=;
        h=From:To:Cc:Subject:Date:From;
        b=dqUCMrHsYVGEl9+N+vwoABiJJHUgaRkJlRR1GCqPiW2acPhfdEpTuHiM4vVv5RJI1
         EHPpcwuWgpZvY00Ygg26qK9mOPjhxXMie6Vw8Zx6Pu3qd+CEY1IRLzKM7QetKKmOLJ
         xYj6Q4/ZGBdz4wf7QTiZhBmHw00squRPCoEfLe7Ey+dGOBsfQVb6aCqU3mxmpWxMTD
         +qmLMUDGIZbH8QZvv1TllJousbd6W0glfLSm07sbDTu2whiqS8tzpLtxEMRV6KVX3m
         s8N9daiBYVITuRgWeLpmnUmGGw4sLezX3/TB3W2bPij2d+b0N7lUANCImyI1bEFYOK
         NlcZ1fwOpiI/g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: remove unused txd_pdma pointer in mtk_xdp_submit_frame
Date:   Tue, 16 Aug 2022 19:14:30 +0200
Message-Id: <2c40b0fbb9163a0d62ff897abae17db84a9f3b99.1660669138.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of unnecessary txd_pdma pointer in mtk_xdp_submit_frame for loop
since it is actually used at the end of the routine using latest mtk_tx_dma
consumed pointer as reference.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d9426b01f462..dff274132ae3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1573,8 +1573,8 @@ static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 		.last	= !xdp_frame_has_frags(xdpf),
 	};
 	int err, index = 0, n_desc = 1, nr_frags;
-	struct mtk_tx_dma *htxd, *txd, *txd_pdma;
 	struct mtk_tx_buf *htx_buf, *tx_buf;
+	struct mtk_tx_dma *htxd, *txd;
 	void *data = xdpf->data;
 
 	if (unlikely(test_bit(MTK_RESETTING, &eth->state)))
@@ -1608,7 +1608,6 @@ static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 
 		if (MTK_HAS_CAPS(soc->caps, MTK_QDMA) || (index & 0x1)) {
 			txd = mtk_qdma_phys_to_virt(ring, txd->txd2);
-			txd_pdma = qdma_to_pdma(ring, txd);
 			if (txd == ring->last_free)
 				goto unmap;
 
@@ -1629,7 +1628,8 @@ static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 	htx_buf->data = xdpf;
 
 	if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
-		txd_pdma = qdma_to_pdma(ring, txd);
+		struct mtk_tx_dma *txd_pdma = qdma_to_pdma(ring, txd);
+
 		if (index & 1)
 			txd_pdma->txd2 |= TX_DMA_LS0;
 		else
@@ -1660,13 +1660,15 @@ static int mtk_xdp_submit_frame(struct mtk_eth *eth, struct xdp_frame *xdpf,
 
 unmap:
 	while (htxd != txd) {
-		txd_pdma = qdma_to_pdma(ring, htxd);
 		tx_buf = mtk_desc_to_tx_buf(ring, htxd, soc->txrx.txd_size);
 		mtk_tx_unmap(eth, tx_buf, NULL, false);
 
 		htxd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
-		if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA))
+		if (!MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
+			struct mtk_tx_dma *txd_pdma = qdma_to_pdma(ring, htxd);
+
 			txd_pdma->txd2 = TX_DMA_DESP2_DEF;
+		}
 
 		htxd = mtk_qdma_phys_to_virt(ring, htxd->txd2);
 	}
-- 
2.37.2

