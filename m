Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7516DBDD6
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 00:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDHWdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 18:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDHWdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 18:33:41 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CC57DBD
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 15:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:References:
        In-Reply-To:Message-Id:Sender:Reply-To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VMEqsSzGhYHes85N/pDcDZGt30lWKlalrZN9h0ml1l4=; b=kwsNZvlpknXacU8ftp8KPXGr9Y
        DVNn37MVWPvOy16jm0KbuCNeh32sxRYhR60xGrKeb8nWwlFrNbbeOKoS9vnXor5GktMavOPk9NE9r
        TrBhxrRi6XK81q5kAjbgcEY3gH3wtb8zLu3zYmVXvgGPkpOn3tZ8sEpBnIE5G9XjcMXWfU01ttPNH
        J+qf+kbwOU5NyNMMfXqB6AoUskXBIxc/hUwbGQq2SSPhxXkud6Ayt2DZ8m1AxRLoFAQ+7tY3ZynJf
        chIBbw0p3YWJtRUZEa3dsFMVi6oDCT2smBa4GwibPgVdzyf62szT0gUE1hnKQU+EFhjlYplTgLfId
        /mfuAxuQ==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1plH7j-00D6sG-1W; Sat, 08 Apr 2023 22:33:31 +0000
Message-Id: <645368abb0e4c0c6afa2ed7f0e4ab7f932f1a2ba.1680992691.git.geoff@infradead.org>
In-Reply-To: <cover.1680992691.git.geoff@infradead.org>
References: <cover.1680992691.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 8 Apr 2023 15:18:43 -0700
Subject: [PATCH net-next v1 2/2] net/ps3_gelic_net: Use napi routines for RX SKB
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
Date:   Sat, 08 Apr 2023 22:33:31 +0000
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the PS3 Gelic network driver's RX SK buffers over to
use the napi_alloc_frag_align and napi_build_skb routines, and
then cleanup with the skb_free_frag routine.

Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 51 +++++++++++---------
 drivers/net/ethernet/toshiba/ps3_gelic_net.h |  4 +-
 2 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index d680db8c8566..0435e93638b4 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -374,20 +374,16 @@ static int gelic_card_init_chain(struct gelic_card *card,
 static int gelic_descr_prepare_rx(struct gelic_card *card,
 				  struct gelic_descr *descr)
 {
-	static const unsigned int rx_skb_size =
-		ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN) +
-		GELIC_NET_RXBUF_ALIGN - 1;
+	static const unsigned int napi_buff_size =
+		round_up(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN);
+
+	struct device *dev = ctodev(card);
 	dma_addr_t cpu_addr;
-	int offset;
+	void *napi_buff;
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
-		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
+		dev_info(dev, "%s: ERROR status\n", __func__);
 
-	descr->skb = netdev_alloc_skb(*card->netdev, rx_skb_size);
-	if (!descr->skb) {
-		descr->hw_regs.payload.dev_addr = 0; /* tell DMAC don't touch memory */
-		return -ENOMEM;
-	}
 	descr->hw_regs.dmac_cmd_status = 0;
 	descr->hw_regs.result_size = 0;
 	descr->hw_regs.valid_size = 0;
@@ -396,24 +392,33 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	descr->hw_regs.payload.size = 0;
 	descr->skb = NULL;
 
-	offset = ((unsigned long)descr->skb->data) &
-		(GELIC_NET_RXBUF_ALIGN - 1);
-	if (offset)
-		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
-	/* io-mmu-map the skb */
-	cpu_addr = dma_map_single(ctodev(card), descr->skb->data,
-				  GELIC_NET_MAX_FRAME, DMA_FROM_DEVICE);
-	descr->hw_regs.payload.dev_addr = cpu_to_be32(cpu_addr);
-	if (dma_mapping_error(ctodev(card), cpu_addr)) {
-		dev_kfree_skb_any(descr->skb);
+	napi_buff = napi_alloc_frag_align(napi_buff_size,
+		GELIC_NET_RXBUF_ALIGN);
+
+	if (unlikely(!napi_buff)) {
+		return -ENOMEM;
+	}
+
+	descr->skb = napi_build_skb(napi_buff, napi_buff_size);
+
+	if (unlikely(!descr->skb)) {
+		skb_free_frag(napi_buff);
+		return -ENOMEM;
+	}
+
+	cpu_addr = dma_map_single(dev, napi_buff, napi_buff_size,
+		DMA_FROM_DEVICE);
+
+	if (dma_mapping_error(dev, cpu_addr)) {
+		skb_free_frag(napi_buff);
 		descr->skb = NULL;
-		dev_info(ctodev(card),
-			 "%s:Could not iommu-map rx buffer\n", __func__);
+		dev_err_once(dev, "%s:Could not iommu-map rx buffer\n",
+			__func__);
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
 		return -ENOMEM;
 	}
 
-	descr->hw_regs.payload.size = cpu_to_be32(GELIC_NET_MAX_FRAME);
+	descr->hw_regs.payload.size = cpu_to_be32(napi_buff_size);
 	descr->hw_regs.payload.dev_addr = cpu_to_be32(cpu_addr);
 
 	gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
index f0b939c82900..ec5098d9dfd2 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -19,10 +19,10 @@
 #define GELIC_NET_RX_DESCRIPTORS        128 /* num of descriptors */
 #define GELIC_NET_TX_DESCRIPTORS        128 /* num of descriptors */
 
-#define GELIC_NET_MAX_FRAME             2312
+#define GELIC_NET_MAX_FRAME             2312U
 #define GELIC_NET_MAX_MTU               2294
 #define GELIC_NET_MIN_MTU               64
-#define GELIC_NET_RXBUF_ALIGN           128
+#define GELIC_NET_RXBUF_ALIGN           128U
 #define GELIC_CARD_RX_CSUM_DEFAULT      1 /* hw chksum */
 #define GELIC_NET_WATCHDOG_TIMEOUT      5*HZ
 #define GELIC_NET_BROADCAST_ADDR        0xffffffffffffL
-- 
2.34.1

