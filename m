Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB72E6BFBEF
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 18:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCRRj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 13:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCRRjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 13:39:23 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2F6211A
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 10:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:Cc:To:Subject:From:References:
        In-Reply-To:Message-Id:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vIdVky4l6avrpYGF0cmv6N6pjGJLqXUDZSt6GEipmQ0=; b=fWfYYBkuDXDqUk7jwx7NvBO0XR
        2nnnFkzQVMTviq97DBAr9uzvXp3vpfZ2auJebSDhIvhxMMkwXDdMTC9Iri7NJfgcFobxohbUFEspR
        wQQcrNxbAPpGtccFKYj39vfeqv2dKR036CEy/ZUb1a72fBVjtQFPK4HfjyAGucWVMufwzqQZRCjWe
        dAqjfQzSj8piN6Cbk/rwyL1J+kJ5WafoVY++gB90czPqk8/wpw6w7prVb/2pOdbNAguwyLRKbuetL
        DeRCa3w8DNOqtzadWBtocStG9I5VPCkdsjcuhl3EdLBWIIC7YZse2MNtxHGeYjO4vqlMk7atBdHAr
        M4B9hlxg==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pdaWS-008xn0-8d; Sat, 18 Mar 2023 17:39:16 +0000
Message-Id: <1183d95e3acf0ae61d12d38511d89e5ffc0c5d54.1679160765.git.geoff@infradead.org>
In-Reply-To: <cover.1679160765.git.geoff@infradead.org>
References: <cover.1679160765.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 18 Mar 2023 10:26:14 -0700
Subject: [PATCH net v9 2/2] net/ps3_gelic_net: Use dma_mapping_error
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sat, 18 Mar 2023 17:39:16 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current Gelic Etherenet driver was checking the return value of its
dma_map_single call, and not using the dma_mapping_error() routine.

Fixes runtime problems like these:

  DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
  WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc

Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 24 +++++++++++---------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index dffd664e65f4..9d535ae59626 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -317,15 +317,17 @@ static int gelic_card_init_chain(struct gelic_card *card,
 
 	/* set up the hardware pointers in each descriptor */
 	for (i = 0; i < no; i++, descr++) {
+		dma_addr_t cpu_addr;
+
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
-		descr->bus_addr =
-			dma_map_single(ctodev(card), descr,
-				       GELIC_DESCR_SIZE,
-				       DMA_BIDIRECTIONAL);
 
-		if (!descr->bus_addr)
+		cpu_addr = dma_map_single(ctodev(card), descr,
+					  GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
+
+		if (dma_mapping_error(ctodev(card), cpu_addr))
 			goto iommu_error;
 
+		descr->bus_addr = cpu_to_be32(cpu_addr);
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
 	}
@@ -375,6 +377,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	static const unsigned int rx_skb_size =
 		ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN) +
 		GELIC_NET_RXBUF_ALIGN - 1;
+	dma_addr_t cpu_addr;
 	int offset;
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
@@ -396,11 +399,10 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	if (offset)
 		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
 	/* io-mmu-map the skb */
-	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
-						     descr->skb->data,
-						     GELIC_NET_MAX_FRAME,
-						     DMA_FROM_DEVICE));
-	if (!descr->buf_addr) {
+	cpu_addr = dma_map_single(ctodev(card), descr->skb->data,
+				  GELIC_NET_MAX_FRAME, DMA_FROM_DEVICE);
+	descr->buf_addr = cpu_to_be32(cpu_addr);
+	if (dma_mapping_error(ctodev(card), cpu_addr)) {
 		dev_kfree_skb_any(descr->skb);
 		descr->skb = NULL;
 		dev_info(ctodev(card),
@@ -780,7 +782,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 
 	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
 
-	if (!buf) {
+	if (dma_mapping_error(ctodev(card), buf)) {
 		dev_err(ctodev(card),
 			"dma map 2 failed (%p, %i). Dropping packet\n",
 			skb->data, skb->len);
-- 
2.34.1

