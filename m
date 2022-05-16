Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE515289B2
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245703AbiEPQIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245695AbiEPQIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:08:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D571637BE3;
        Mon, 16 May 2022 09:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71BBF60FF0;
        Mon, 16 May 2022 16:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08663C36AE3;
        Mon, 16 May 2022 16:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652717288;
        bh=t9Pe6TXTNALE+q/ldJlquf7ThnvPV79cToZ2NboGpxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0D/+6G8mP/AWzIsQLvSuw0LSpd18Bv0OLjcNWim29BH7jtv1nZGuB3jv5F8SHuFX
         crOzUQyqTCOVNLcPDsUePdv2wV4QCFoVrnMV4Qtg1Mdj0/JxQU0paIHbmFDUWJ/1c/
         cqUy/pvwTP/q1vLydTH4y+dqiWVogccDDblqvdr4O+k4swkQA0O+2R5KojnVg94fHA
         HXYJw1Y3cV24YPFkpVk+2Co8XDW1Zt9OMEwsMFDPLqmTYGG+NOYE3BNARTyoY2LC+Z
         fNIN3UkmKkDGGLzFGGCPYH0TOsuP2W38+Zi8Db6Eu4mlkPZNSroEbxTrepfvCwsxuU
         76IiZ90ujIIQQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next 09/15] net: ethernet: mtk_eth_soc: rely on txd_size field in mtk_poll_tx/mtk_poll_rx
Date:   Mon, 16 May 2022 18:06:36 +0200
Message-Id: <af15492e3eaa4a86f80bfa4145376dce40a1a7d4.1652716741.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
2.35.3

