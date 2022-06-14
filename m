Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0885854A557
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353702AbiFNCUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354823AbiFNCTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:19:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1712D3F308;
        Mon, 13 Jun 2022 19:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C753B816A1;
        Tue, 14 Jun 2022 02:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AC4C3411E;
        Tue, 14 Jun 2022 02:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172578;
        bh=9DxZ9Z8KuJ6bNlC9KwxdXezx5ONbebC6I+hrSLivx6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/GehDfoKMDWfju28iEjhOUuxS0FAL9oOmak15V4j6oipLXLcaiVescTLxGNS0/g7
         eU396yJsYrL05BSZ65KxbP436id+obtGtHRpa8iLIV4ZiY90hC2JYI10HyvrzRiAJS
         UuJDrAVUeVpzfcfpfTFOJLwjHU4Lc47WaQlwV7z/h3e1Hj0rca6QDRB1knnzBcGTep
         +7XpEEBHKLBZBO4Wp7a/iDBo/mVlYwcXYaAi5N/G7yxhW9jDLaBX2RM3cUsVeKqOZb
         bTP3nBFiuSeX1C2j4gsGaIGlC127EXks3PCFvNRn3bOp3HwYs9QKWO0MbEWcz9wvTd
         RJpM6nqBw3ANQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Lin <chen45464546@163.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, nbd@openwrt.org,
        blogic@openwrt.org, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 22/23] net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag
Date:   Mon, 13 Jun 2022 22:08:58 -0400
Message-Id: <20220614020900.1100401-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020900.1100401-1-sashal@kernel.org>
References: <20220614020900.1100401-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Lin <chen45464546@163.com>

[ Upstream commit 2f2c0d2919a14002760f89f4e02960c735a316d2 ]

When rx_flag == MTK_RX_FLAGS_HWLRO,
rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
netdev_alloc_frag is for alloction of page fragment only.
Reference to other drivers and Documentation/vm/page_frags.rst

Branch to use __get_free_pages when ring->frag_size > PAGE_SIZE.

Signed-off-by: Chen Lin <chen45464546@163.com>
Link: https://lore.kernel.org/r/1654692413-2598-1-git-send-email-chen45464546@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 3351d4f9363a..c9041508d284 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -802,6 +802,17 @@ static inline void mtk_rx_get_desc(struct mtk_rx_dma *rxd,
 	rxd->rxd4 = READ_ONCE(dma_rxd->rxd4);
 }
 
+static void *mtk_max_lro_buf_alloc(gfp_t gfp_mask)
+{
+	unsigned int size = mtk_max_frag_size(MTK_MAX_LRO_RX_LENGTH);
+	unsigned long data;
+
+	data = __get_free_pages(gfp_mask | __GFP_COMP | __GFP_NOWARN,
+				get_order(size));
+
+	return (void *)data;
+}
+
 /* the qdma core needs scratch memory to be setup */
 static int mtk_init_fq_dma(struct mtk_eth *eth)
 {
@@ -1299,7 +1310,10 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 
 		/* alloc new buffer */
-		new_data = napi_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			new_data = napi_alloc_frag(ring->frag_size);
+		else
+			new_data = mtk_max_lro_buf_alloc(GFP_ATOMIC);
 		if (unlikely(!new_data)) {
 			netdev->stats.rx_dropped++;
 			goto release_desc;
@@ -1696,7 +1710,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		return -ENOMEM;
 
 	for (i = 0; i < rx_dma_size; i++) {
-		ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		else
+			ring->data[i] = mtk_max_lro_buf_alloc(GFP_KERNEL);
 		if (!ring->data[i])
 			return -ENOMEM;
 	}
-- 
2.35.1

