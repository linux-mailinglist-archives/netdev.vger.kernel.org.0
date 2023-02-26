Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B896A2D26
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 03:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBZCZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 21:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjBZCZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 21:25:52 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C955046A8
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 18:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Date:To:Subject:From:References:
        In-Reply-To:Message-Id:Sender:Reply-To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Z7fSGLE5THzQSgIJMWxnTeKVOIDfOp2oRuapvL2QDuI=; b=J4ZtEuqtlfesrVZ34OqRjnf8ZK
        oPPFBDS7z47wt26+H38Q770rgV6MOIJ0QMuLQYoaQ2hsAlEISVUF4bCB8wL0iWWuQ09/8yrXBnxYx
        fDUxJZ1Exn9l90AMF48fBQknArzGWhonVQ7wdG/+vzEJGgTtRI4lxZF5bvx9gnZE7C8itILXDKcmK
        8OhduQSJKdN3aWBiaT4VlTIubJbjrS7w2H+8Z1HxSEkqx7RTSSFuqgD/7e4dkdHKs3r+4xBzPLhCX
        LlBBVOJ8WumFvnN8YbM7K5YIsYDonGf1yzmsiL9G1mKtOVMAvo53T7+9GG0L9LfCtq8S1r+YNzgl1
        sIsYNX6w==;
Received: from geoff by merlin.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pW6jO-005Uim-MN; Sun, 26 Feb 2023 02:25:42 +0000
Message-Id: <1bf36b8e08deb3d16fafde3e88ae7cd761e4e7b3.1677377639.git.geoff@infradead.org>
In-Reply-To: <cover.1677377639.git.geoff@infradead.org>
References: <cover.1677377639.git.geoff@infradead.org>
From:   Geoff Levand <geoff@infradead.org>
Patch-Date: Sat, 25 Feb 2023 17:37:20 -0800
Subject: [PATCH net v6 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sun, 26 Feb 2023 02:25:42 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Gelic Ethernet device needs to have the RX sk_buffs aligned to
GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a
multiple of GELIC_NET_RXBUF_ALIGN.

The current Gelic Ethernet driver was not allocating sk_buffs large
enough to allow for this alignment.

Fixes various randomly occurring runtime network errors.

Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
Signed-off-by: Geoff Levand <geoff@infradead.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 66 +++++++++++---------
 drivers/net/ethernet/toshiba/ps3_gelic_net.h |  2 +-
 2 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index cf8de8a7a8a1..7e12e041acd3 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -365,51 +365,61 @@ static int gelic_card_init_chain(struct gelic_card *card,
  *
  * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
  * Activate the descriptor state-wise
+ *
+ * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the length
+ * must be a multiple of GELIC_NET_RXBUF_ALIGN.
  */
 static int gelic_descr_prepare_rx(struct gelic_card *card,
 				  struct gelic_descr *descr)
 {
-	int offset;
-	unsigned int bufsize;
+	struct device *dev = ctodev(card);
+	void *napi_buff;
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
 		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
-	/* we need to round up the buffer size to a multiple of 128 */
-	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
-
-	/* and we need to have it 128 byte aligned, therefore we allocate a
-	 * bit more */
-	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
-	if (!descr->skb) {
-		descr->buf_addr = 0; /* tell DMAC don't touch memory */
-		return -ENOMEM;
-	}
-	descr->buf_size = cpu_to_be32(bufsize);
+
 	descr->dmac_cmd_status = 0;
 	descr->result_size = 0;
 	descr->valid_size = 0;
 	descr->data_error = 0;
+	descr->buf_size = cpu_to_be32(GELIC_NET_MAX_MTU);
+
+	napi_buff = napi_alloc_frag_align(GELIC_NET_MAX_MTU,
+		GELIC_NET_RXBUF_ALIGN);
+
+	if (unlikely(!napi_buff)) {
+		descr->skb = NULL;
+		descr->buf_addr = 0;
+		descr->buf_size = 0;
+		return -ENOMEM;
+	}
+
+	descr->skb = napi_build_skb(napi_buff, GELIC_NET_MAX_MTU);
+
+	if (unlikely(!descr->skb)) {
+		skb_free_frag(napi_buff);
+		descr->skb = NULL;
+		descr->buf_addr = 0;
+		descr->buf_size = 0;
+		return -ENOMEM;
+	}
+
+	descr->buf_addr = cpu_to_be32(dma_map_single(dev, napi_buff,
+		GELIC_NET_MAX_MTU, DMA_FROM_DEVICE));
 
-	offset = ((unsigned long)descr->skb->data) &
-		(GELIC_NET_RXBUF_ALIGN - 1);
-	if (offset)
-		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
-	/* io-mmu-map the skb */
-	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
-						     descr->skb->data,
-						     GELIC_NET_MAX_MTU,
-						     DMA_FROM_DEVICE));
 	if (!descr->buf_addr) {
-		dev_kfree_skb_any(descr->skb);
+		skb_free_frag(napi_buff);
 		descr->skb = NULL;
-		dev_info(ctodev(card),
-			 "%s:Could not iommu-map rx buffer\n", __func__);
+		descr->buf_addr = 0;
+		descr->buf_size = 0;
+		dev_err_once(dev, "%s:Could not iommu-map rx buffer\n",
+			__func__);
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
 		return -ENOMEM;
-	} else {
-		gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
-		return 0;
 	}
+
+	gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
index 68f324ed4eaf..d3868eb7234c 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -19,7 +19,7 @@
 #define GELIC_NET_RX_DESCRIPTORS        128 /* num of descriptors */
 #define GELIC_NET_TX_DESCRIPTORS        128 /* num of descriptors */
 
-#define GELIC_NET_MAX_MTU               VLAN_ETH_FRAME_LEN
+#define GELIC_NET_MAX_MTU               1920
 #define GELIC_NET_MIN_MTU               VLAN_ETH_ZLEN
 #define GELIC_NET_RXBUF_ALIGN           128
 #define GELIC_CARD_RX_CSUM_DEFAULT      1 /* hw chksum */
-- 
2.34.1


