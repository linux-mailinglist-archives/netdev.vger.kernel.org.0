Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7490966D02B
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbjAPUZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbjAPUZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:25:18 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFA52799A
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RTQYqP4UPiEJjn68ckr8xHMNrv7a5B15zJEBy+Cs/CI=; b=kbrYRnt7aZQ8K/+OU/uIK8S0F1
        1vbta3WhaZQQZVqC9+zI0m0kTlIlVw3HIJT7XZOdx5IxHK4ioE0Ijfnr0F5K/BYzV8iwgl59EjT8w
        zgBKLDbUSDyIX/BguH1tFUtd2yEjlrw3TtUHe/dOW6gj8pe0sy33oIj0HM99hEN4UyqQ=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pHW2a-00018Q-Qc; Mon, 16 Jan 2023 21:25:12 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, alexander.duyck@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v5 6/9] tsnep: Prepare RX buffer for XDP support
Date:   Mon, 16 Jan 2023 21:24:55 +0100
Message-Id: <20230116202458.56677-7-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230116202458.56677-1-gerhard@engleder-embedded.com>
References: <20230116202458.56677-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always reserve XDP_PACKET_HEADROOM in front of RX buffer. Similar DMA
direction is always set to DMA_BIDIRECTIONAL. This eliminates the need
for RX queue reconfiguration during BPF program setup. The RX queue is
always prepared for XDP.

No negative impact of DMA_BIDIRECTIONAL was measured.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 0730cd45f9a3..45e576e74510 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -26,9 +26,10 @@
 #include <linux/etherdevice.h>
 #include <linux/phy.h>
 #include <linux/iopoll.h>
+#include <linux/bpf.h>
 
-#define TSNEP_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
-#define TSNEP_HEADROOM ALIGN(TSNEP_SKB_PAD, 4)
+#define TSNEP_RX_OFFSET (max(NET_SKB_PAD, XDP_PACKET_HEADROOM) + NET_IP_ALIGN)
+#define TSNEP_HEADROOM ALIGN(TSNEP_RX_OFFSET, 4)
 #define TSNEP_MAX_RX_BUF_SIZE (PAGE_SIZE - TSNEP_HEADROOM - \
 			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 
@@ -806,9 +807,9 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 	pp_params.pool_size = TSNEP_RING_SIZE;
 	pp_params.nid = dev_to_node(dmadev);
 	pp_params.dev = dmadev;
-	pp_params.dma_dir = DMA_FROM_DEVICE;
+	pp_params.dma_dir = DMA_BIDIRECTIONAL;
 	pp_params.max_len = TSNEP_MAX_RX_BUF_SIZE;
-	pp_params.offset = TSNEP_SKB_PAD;
+	pp_params.offset = TSNEP_RX_OFFSET;
 	rx->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(rx->page_pool)) {
 		retval = PTR_ERR(rx->page_pool);
@@ -843,7 +844,7 @@ static void tsnep_rx_set_page(struct tsnep_rx *rx, struct tsnep_rx_entry *entry,
 	entry->page = page;
 	entry->len = TSNEP_MAX_RX_BUF_SIZE;
 	entry->dma = page_pool_get_dma_addr(entry->page);
-	entry->desc->rx = __cpu_to_le64(entry->dma + TSNEP_SKB_PAD);
+	entry->desc->rx = __cpu_to_le64(entry->dma + TSNEP_RX_OFFSET);
 }
 
 static int tsnep_rx_alloc_buffer(struct tsnep_rx *rx, int index)
@@ -947,14 +948,14 @@ static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 		return NULL;
 
 	/* update pointers within the skb to store the data */
-	skb_reserve(skb, TSNEP_SKB_PAD + TSNEP_RX_INLINE_METADATA_SIZE);
+	skb_reserve(skb, TSNEP_RX_OFFSET + TSNEP_RX_INLINE_METADATA_SIZE);
 	__skb_put(skb, length - ETH_FCS_LEN);
 
 	if (rx->adapter->hwtstamp_config.rx_filter == HWTSTAMP_FILTER_ALL) {
 		struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
 		struct tsnep_rx_inline *rx_inline =
 			(struct tsnep_rx_inline *)(page_address(page) +
-						   TSNEP_SKB_PAD);
+						   TSNEP_RX_OFFSET);
 
 		skb_shinfo(skb)->tx_flags |=
 			SKBTX_HW_TSTAMP_NETDEV;
@@ -1014,11 +1015,11 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		 */
 		dma_rmb();
 
-		prefetch(page_address(entry->page) + TSNEP_SKB_PAD);
+		prefetch(page_address(entry->page) + TSNEP_RX_OFFSET);
 		length = __le32_to_cpu(entry->desc_wb->properties) &
 			 TSNEP_DESC_LENGTH_MASK;
-		dma_sync_single_range_for_cpu(dmadev, entry->dma, TSNEP_SKB_PAD,
-					      length, dma_dir);
+		dma_sync_single_range_for_cpu(dmadev, entry->dma,
+					      TSNEP_RX_OFFSET, length, dma_dir);
 
 		/* RX metadata with timestamps is in front of actual data,
 		 * subtract metadata size to get length of actual data and
-- 
2.30.2

