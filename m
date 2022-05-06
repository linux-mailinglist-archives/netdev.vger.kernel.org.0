Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A758751D7D7
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392008AbiEFMfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392018AbiEFMfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:35:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7BD5D677;
        Fri,  6 May 2022 05:31:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7877D61F89;
        Fri,  6 May 2022 12:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF98C385B0;
        Fri,  6 May 2022 12:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651840290;
        bh=si2hwRw1V74T6VtiHYEBGPs8aiSwK8sDjNn2Ywl3hcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0fdpGHJrk3L5nWKeddTriUxiKv6kE3Vp+8fWItcC1qhCvWlAXFu+W02rNNvBEL9k
         Fh2G8/L6iOKI932mwNyc+OK44MGr5jJ6LiM5A3CYt69VXS++yhyPAGiFQIXVFKUr1O
         FxvjxtkBRya7x3R8jr+M0tACp1Xg/Q6EPeQ/Tbm3KDPe2Skm9wC76anXg381jf9450
         P6nMPLfdRZkRzznvGB/+qH5ruDkN2fYqX4qAQKKQdiBtw68xSyJYZV9Up6/6AKAZUu
         odY7ArnWP39QbOaCsHyWwjVn9YjjDl4DKnQoEIiD4WoLJJbTgc44kiAzCveM4JAkxP
         KPWQgKP1RAS0Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: [PATCH net-next 07/14] net: ethernet: mtk_eth_soc: rely on txd_size in txd_to_idx
Date:   Fri,  6 May 2022 14:30:24 +0200
Message-Id: <e3156f4cd5e53e369125389bc7d61ad402788fbb.1651839494.git.lorenzo@kernel.org>
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

This is a preliminary patch to add mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5f0082f92cc7..a67b22dbaac7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -852,9 +852,10 @@ static struct mtk_tx_dma *qdma_to_pdma(struct mtk_tx_ring *ring,
 	return ring->dma_pdma - ring->dma + dma;
 }
 
-static int txd_to_idx(struct mtk_tx_ring *ring, struct mtk_tx_dma *dma)
+static int txd_to_idx(struct mtk_tx_ring *ring, struct mtk_tx_dma *dma,
+		      u32 txd_size)
 {
-	return ((void *)dma - (void *)ring->dma) / sizeof(*dma);
+	return ((void *)dma - (void *)ring->dma) / txd_size;
 }
 
 static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
@@ -1070,8 +1071,10 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		    !netdev_xmit_more())
 			mtk_w32(eth, txd->txd2, MTK_QTX_CTX_PTR);
 	} else {
-		int next_idx = NEXT_DESP_IDX(txd_to_idx(ring, txd),
-					     ring->dma_size);
+		int next_idx;
+
+		next_idx = NEXT_DESP_IDX(txd_to_idx(ring, txd, soc->txrx.txd_size),
+					 ring->dma_size);
 		mtk_w32(eth, next_idx, MT7628_TX_CTX_IDX0);
 	}
 
-- 
2.35.1

