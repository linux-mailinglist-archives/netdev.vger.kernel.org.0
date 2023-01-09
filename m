Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405AE66301D
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbjAITPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbjAITPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:15:33 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BAD63EB
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cSA+xS23hMLKtq6Vlcv1/f5Q/MEAf3XrGwSJW21j8bA=; b=xIljMZzSf0ao2jPHml5SZ4VVVE
        v92C+7BTujWLUIP8oXa1fAJw9nGd0hdrRIohVN2vw/7iKQMkn+kXHTuxRHqwsWEMgCAwu2qAmrkHx
        FZqFT1qD0y27eBwoiYz92Z1YafhhQnwXLhQELX9BCEnK/fX/S63y0y1e1sIE54I45uI8=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pExcJ-0007WQ-Hd; Mon, 09 Jan 2023 20:15:31 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 07/10] tsnep: Prepare RX buffer for XDP support
Date:   Mon,  9 Jan 2023 20:15:20 +0100
Message-Id: <20230109191523.12070-8-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230109191523.12070-1-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce tsnep_adapter::xdp_prog, which will later signal that XDP is
enabled.

Reserve XDP_PACKET_HEADROOM in front of RX buffer if XDP is enabled.
Also set DMA direction properly in this case.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |  3 +++
 drivers/net/ethernet/engleder/tsnep_main.c | 22 ++++++++++++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 9cb267938794..855738d31d73 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -117,6 +117,7 @@ struct tsnep_rx {
 	struct tsnep_adapter *adapter;
 	void __iomem *addr;
 	int queue_index;
+	unsigned int offset;
 
 	void *page[TSNEP_RING_PAGE_COUNT];
 	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
@@ -183,6 +184,8 @@ struct tsnep_adapter {
 	int rxnfc_count;
 	int rxnfc_max;
 
+	struct bpf_prog *xdp_prog;
+
 	int num_tx_queues;
 	struct tsnep_tx tx[TSNEP_MAX_QUEUES];
 	int num_rx_queues;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 1110530ec639..0c9669edb2dd 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -26,9 +26,10 @@
 #include <linux/etherdevice.h>
 #include <linux/phy.h>
 #include <linux/iopoll.h>
+#include <linux/bpf.h>
 
 #define TSNEP_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
-#define TSNEP_HEADROOM ALIGN(TSNEP_SKB_PAD, 4)
+#define TSNEP_HEADROOM ALIGN(max(TSNEP_SKB_PAD, XDP_PACKET_HEADROOM), 4)
 #define TSNEP_MAX_RX_BUF_SIZE (PAGE_SIZE - TSNEP_HEADROOM - \
 			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 
@@ -838,9 +839,10 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 	pp_params.pool_size = TSNEP_RING_SIZE;
 	pp_params.nid = dev_to_node(dmadev);
 	pp_params.dev = dmadev;
-	pp_params.dma_dir = DMA_FROM_DEVICE;
+	pp_params.dma_dir = !!rx->adapter->xdp_prog ?
+			    DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
 	pp_params.max_len = TSNEP_MAX_RX_BUF_SIZE;
-	pp_params.offset = TSNEP_SKB_PAD;
+	pp_params.offset = rx->offset;
 	rx->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(rx->page_pool)) {
 		retval = PTR_ERR(rx->page_pool);
@@ -875,7 +877,7 @@ static void tsnep_rx_set_page(struct tsnep_rx *rx, struct tsnep_rx_entry *entry,
 	entry->page = page;
 	entry->len = TSNEP_MAX_RX_BUF_SIZE;
 	entry->dma = page_pool_get_dma_addr(entry->page);
-	entry->desc->rx = __cpu_to_le64(entry->dma + TSNEP_SKB_PAD);
+	entry->desc->rx = __cpu_to_le64(entry->dma + rx->offset);
 }
 
 static int tsnep_rx_alloc_buffer(struct tsnep_rx *rx, int index)
@@ -979,14 +981,14 @@ static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 		return NULL;
 
 	/* update pointers within the skb to store the data */
-	skb_reserve(skb, TSNEP_SKB_PAD + TSNEP_RX_INLINE_METADATA_SIZE);
+	skb_reserve(skb, rx->offset + TSNEP_RX_INLINE_METADATA_SIZE);
 	__skb_put(skb, length - ETH_FCS_LEN);
 
 	if (rx->adapter->hwtstamp_config.rx_filter == HWTSTAMP_FILTER_ALL) {
 		struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
 		struct tsnep_rx_inline *rx_inline =
 			(struct tsnep_rx_inline *)(page_address(page) +
-						   TSNEP_SKB_PAD);
+						   rx->offset);
 
 		skb_shinfo(skb)->tx_flags |=
 			SKBTX_HW_TSTAMP_NETDEV;
@@ -1046,10 +1048,10 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		 */
 		dma_rmb();
 
-		prefetch(page_address(entry->page) + TSNEP_SKB_PAD);
+		prefetch(page_address(entry->page) + rx->offset);
 		length = __le32_to_cpu(entry->desc_wb->properties) &
 			 TSNEP_DESC_LENGTH_MASK;
-		dma_sync_single_range_for_cpu(dmadev, entry->dma, TSNEP_SKB_PAD,
+		dma_sync_single_range_for_cpu(dmadev, entry->dma, rx->offset,
 					      length, dma_dir);
 
 		/* RX metadata with timestamps is in front of actual data,
@@ -1111,6 +1113,10 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 	rx->adapter = adapter;
 	rx->addr = addr;
 	rx->queue_index = queue_index;
+	if (!!adapter->xdp_prog)
+		rx->offset = XDP_PACKET_HEADROOM;
+	else
+		rx->offset = TSNEP_SKB_PAD;
 
 	retval = tsnep_rx_ring_init(rx);
 	if (retval)
-- 
2.30.2

