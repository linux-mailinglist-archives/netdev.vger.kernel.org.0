Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F9653EEDC
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 21:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiFFTtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 15:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiFFTtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 15:49:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A278389F
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 12:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24B18B81B3D
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 19:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9C6C385A9;
        Mon,  6 Jun 2022 19:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654544948;
        bh=3Y/KHoTrQT6IeNQh9g1R9PRk/OuHTxu9UIy1sab/6aM=;
        h=From:To:Cc:Subject:Date:From;
        b=Q3qupXSjXyIT2uybSqSLb/aRAhoeX+K0pu5DXTGZiAQMQ/3V2YYVjCiT/0K5DcCuN
         crx92iWLE/bYe9WHVBsvLqu7FR7ogDQIx8fNwjhkTBY5lUJco6XfnwO1TJwPFaRG8b
         KX4G2ZZFSLVnbiQiT9KE/6dZfLY4OLgRJf/CSEvSurSahnZSFkM6PIolekTARGwRdq
         otMloGqiBk18o3KRFHQTjXcDvabQJDNDYeNrle6H9hJKjgWqxs1c/C9/cRzsOJRUrt
         wv6fvyXn82vZiYQbjD4l/zDvz1MJcVkzKVxgQZSonLQ5Z/oCebhDmdrhd+qSX6rG27
         ytGT0skDIDP+Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: enable rx cksum offload for MTK_NETSYS_V2
Date:   Mon,  6 Jun 2022 21:49:00 +0200
Message-Id: <c8699805c18f7fd38315fcb8da2787676d83a32c.1654544585.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
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

Enable rx checksum offload for mt7986 chipset.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b3b3c079a0fa..9d7700984e9b 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1433,8 +1433,8 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 	int done = 0, bytes = 0;
 
 	while (done < budget) {
+		unsigned int pktlen, *rxdcsum;
 		struct net_device *netdev;
-		unsigned int pktlen;
 		dma_addr_t dma_addr;
 		u32 hash, reason;
 		int mac = 0;
@@ -1498,7 +1498,13 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		pktlen = RX_DMA_GET_PLEN0(trxd.rxd2);
 		skb->dev = netdev;
 		skb_put(skb, pktlen);
-		if (trxd.rxd4 & eth->soc->txrx.rx_dma_l4_valid)
+
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+			rxdcsum = &trxd.rxd3;
+		else
+			rxdcsum = &trxd.rxd4;
+
+		if (*rxdcsum & eth->soc->txrx.rx_dma_l4_valid)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 		else
 			skb_checksum_none_assert(skb);
@@ -3744,6 +3750,7 @@ static const struct mtk_soc_data mt7986_data = {
 		.txd_size = sizeof(struct mtk_tx_dma_v2),
 		.rxd_size = sizeof(struct mtk_rx_dma_v2),
 		.rx_irq_done_mask = MTK_RX_DONE_INT_V2,
+		.rx_dma_l4_valid = RX_DMA_L4_VALID_V2,
 		.dma_max_len = MTK_TX_DMA_BUF_LEN_V2,
 		.dma_len_offset = 8,
 	},
-- 
2.35.3

