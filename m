Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AC86AADCB
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 03:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjCECIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 21:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjCECIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 21:08:21 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E947113D5C
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 18:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:Cc:To:Subject:From:References:
        In-Reply-To:Message-Id:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tCA8RznNgTSozDHpBLe7Y7BSCMBWgHdlmMqaTgNotXc=; b=Hwzco48gX8ydhB0qaUTSpY0kQ4
        /qElbE2MJnQLbBtIDhbkc3YfGEr4sjCuPAEaaQpIXDPRrEBYEzhq5oyyNKBz+LFFqRx7vwQq3WH2T
        MnRCrR7EdXfvjGmT6gVkkF7OnTV1G+0vYM3GhjBmZ+URrckXl3nj4Y9ABO2C4kfkT95cyThMRcNSG
        k+ePu8YBfkZkCZQ6IJfVjybCImlwVT2Q+FHumKyyNMXMm+hZWAzoojNZggngFMITCn+wlSh5jtKwV
        iwQpCr29I8Jg9fGsKbnd0FVZ0U3L1D1m+1cp6QDobbVlIKZUbo+9dcU1rcmscF6sRZIP7kHyXuMKP
        q402c+MQ==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pYdnF-006Wd0-0P; Sun, 05 Mar 2023 02:08:09 +0000
Message-Id: <22d742b4e7d11ff48e8c40e39db3c776e495abe2.1677981671.git.geoff@infradead.org>
In-Reply-To: <cover.1677981671.git.geoff@infradead.org>
References: <cover.1677981671.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 4 Mar 2023 17:48:15 -0800
Subject: [PATCH net v7 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sun, 05 Mar 2023 02:08:09 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Gelic Ethernet device needs to have the RX sk_buffs aligned to
GELIC_NET_RXBUF_ALIGN, and also the length of the RX sk_buffs must
be a multiple of GELIC_NET_RXBUF_ALIGN.

The current Gelic Ethernet driver was not allocating sk_buffs large
enough to allow for this alignment.

Also, correct the maximum and minimum MTU sizes, and add a new
preprocessor macro for the maximum frame size, GELIC_NET_MAX_FRAME.

Fixes various randomly occurring runtime network errors.

Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 10 ++++++----
 drivers/net/ethernet/toshiba/ps3_gelic_net.h |  5 +++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index cf8de8a7a8a1..b0ebe0e603b4 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -375,11 +375,13 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
 		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
 	/* we need to round up the buffer size to a multiple of 128 */
-	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
+	bufsize = (GELIC_NET_MAX_FRAME + GELIC_NET_RXBUF_ALIGN - 1) &
+		(~(GELIC_NET_RXBUF_ALIGN - 1));
 
 	/* and we need to have it 128 byte aligned, therefore we allocate a
 	 * bit more */
-	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
+	descr->skb = netdev_alloc_skb(*card->netdev, bufsize +
+		GELIC_NET_RXBUF_ALIGN - 1);
 	if (!descr->skb) {
 		descr->buf_addr = 0; /* tell DMAC don't touch memory */
 		return -ENOMEM;
@@ -397,7 +399,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	/* io-mmu-map the skb */
 	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
 						     descr->skb->data,
-						     GELIC_NET_MAX_MTU,
+						     GELIC_NET_MAX_FRAME,
 						     DMA_FROM_DEVICE));
 	if (!descr->buf_addr) {
 		dev_kfree_skb_any(descr->skb);
@@ -915,7 +917,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr *descr,
 	data_error = be32_to_cpu(descr->data_error);
 	/* unmap skb buffer */
 	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr),
-			 GELIC_NET_MAX_MTU,
+			 GELIC_NET_MAX_FRAME,
 			 DMA_FROM_DEVICE);
 
 	skb_put(skb, be32_to_cpu(descr->valid_size)?
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
index 68f324ed4eaf..0d98defb011e 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -19,8 +19,9 @@
 #define GELIC_NET_RX_DESCRIPTORS        128 /* num of descriptors */
 #define GELIC_NET_TX_DESCRIPTORS        128 /* num of descriptors */
 
-#define GELIC_NET_MAX_MTU               VLAN_ETH_FRAME_LEN
-#define GELIC_NET_MIN_MTU               VLAN_ETH_ZLEN
+#define GELIC_NET_MAX_FRAME             2312
+#define GELIC_NET_MAX_MTU               2294
+#define GELIC_NET_MIN_MTU               64
 #define GELIC_NET_RXBUF_ALIGN           128
 #define GELIC_CARD_RX_CSUM_DEFAULT      1 /* hw chksum */
 #define GELIC_NET_WATCHDOG_TIMEOUT      5*HZ
-- 
2.34.1


