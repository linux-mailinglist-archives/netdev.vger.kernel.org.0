Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48B051D7DD
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392046AbiEFMfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391997AbiEFMfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:35:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CA5644F8;
        Fri,  6 May 2022 05:31:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8FDA61FEC;
        Fri,  6 May 2022 12:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79235C385B3;
        Fri,  6 May 2022 12:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651840297;
        bh=zEJsWirQnQXWctCHPkKQJzi/whAfvJ6iSHD6rFIf3tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbE/+C/zareGS3Cj9zNzl4xxtkgN1Chg4HA45QPMN/LaoHG3CSraAZJMnb8VipvZk
         iLBQcvvWiHyNdvjiWViZnR0rQ6xRKVjT76EXq26WhkiQuSbKelBUDK+WQF0FIo6/0u
         aNb6rVP2XcuReUtytLQDt1Ao1ibsMX0shqz647nkl2NzBATfea/J3HcFROsFb/3fSG
         fZW0zUVfHtEsL+0kbSMVNcpo85EyVogYzMph/ulCS8BCEbP//HdCOgQfESnxar9xFV
         9ZQSv8yB8kMYv4qePs5m+Mp17/b7Jp+0KHQBuwwBA7W8k6dNnxGfRRS+ewF+UNuxpJ
         9PIPd5Qz5ofrw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: [PATCH net-next 09/14] net: ethernet: mtk_eth_soc: rely on txd_size field in mtk_poll_tx/mtk_poll_rx
Date:   Fri,  6 May 2022 14:30:26 +0200
Message-Id: <9e09eaa3ac54ceea29fc4a3ce1eb64e765d41955.1651839494.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651839494.git.lorenzo@kernel.org>
References: <cover.1651839494.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary to ad mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bb628b65a9e5..d431311578e8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1211,9 +1211,12 @@ static struct mtk_rx_ring *mtk_get_rx_ring(struct mtk_eth *eth)
 		return &eth->rx_ring[0];
 
 	for (i = 0; i < MTK_MAX_RX_RING_NUM; i++) {
+		struct mtk_rx_dma *rxd;
+
 		ring = &eth->rx_ring[i];
 		idx = NEXT_DESP_IDX(ring->calc_idx, ring->dma_size);
-		if (ring->dma[idx].rxd2 & RX_DMA_DONE) {
+		rxd = (void *)ring->dma + idx * eth->soc->txrx.rxd_size;
+		if (rxd->rxd2 & RX_DMA_DONE) {
 			ring->calc_idx_update = true;
 			return ring;
 		}
@@ -1264,7 +1267,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto rx_done;
 
 		idx = NEXT_DESP_IDX(ring->calc_idx, ring->dma_size);
-		rxd = &ring->dma[idx];
+		rxd = (void *)ring->dma + idx * eth->soc->txrx.rxd_size;
 		data = ring->data[idx];
 
 		if (!mtk_rx_get_desc(&trxd, rxd))
@@ -1453,7 +1456,7 @@ static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
 
 		mtk_tx_unmap(eth, tx_buf, true);
 
-		desc = &ring->dma[cpu];
+		desc = (void *)ring->dma + cpu * eth->soc->txrx.txd_size;
 		ring->last_free = desc;
 		atomic_inc(&ring->free_count);
 
-- 
2.35.1

