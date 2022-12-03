Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3391A641957
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiLCWLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLCWLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:11:36 -0500
Received: from mx01lb.world4you.com (mx01lb.world4you.com [81.19.149.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B41C435;
        Sat,  3 Dec 2022 14:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FgM2mbgkRu2OhStX6TU8FKTYxc4hNus0Qh81nY7PSss=; b=oXv+CO1pUQ5NN5XCUvJrLcV7Tj
        iNMn+rdAOx4K4ADvo2x1w6GugbZhk8DitMJPfUg5Ikewulj0xemjeyVc1aAEXW3ZbpbG/drLVJNoy
        +HjrUOQ2f2JITKYjfGLU7K+/417faJ38CDOXLUrJIiSqwRXFxxgbiUCE/UpQnXEsBXcs=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx01lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p1aSu-0003Ir-A2; Sat, 03 Dec 2022 22:54:32 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 4/6] tsnep: Prepare RX buffer for XDP support
Date:   Sat,  3 Dec 2022 22:54:14 +0100
Message-Id: <20221203215416.13465-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221203215416.13465-1-gerhard@engleder-embedded.com>
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
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

Reserve XDP_PACKET_HEADROOM in front of RX buffer if XDP is enabled.
Also set DMA direction properly in this case.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 31 +++++++++++++++-------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index d9ba4a8deec5..d7dcac641180 100644
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
 
@@ -808,6 +809,16 @@ static void tsnep_tx_close(struct tsnep_tx *tx)
 	tsnep_tx_ring_cleanup(tx);
 }
 
+static inline unsigned int tsnep_rx_offset(struct tsnep_rx *rx)
+{
+	struct tsnep_adapter *adapter = rx->adapter;
+
+	if (tsnep_xdp_is_enabled(adapter))
+		return XDP_PACKET_HEADROOM;
+
+	return TSNEP_SKB_PAD;
+}
+
 static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 {
 	struct device *dmadev = rx->adapter->dmadev;
@@ -869,9 +880,10 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
 	pp_params.pool_size = TSNEP_RING_SIZE;
 	pp_params.nid = dev_to_node(dmadev);
 	pp_params.dev = dmadev;
-	pp_params.dma_dir = DMA_FROM_DEVICE;
+	pp_params.dma_dir = tsnep_xdp_is_enabled(rx->adapter) ?
+			    DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
 	pp_params.max_len = TSNEP_MAX_RX_BUF_SIZE;
-	pp_params.offset = TSNEP_SKB_PAD;
+	pp_params.offset = tsnep_rx_offset(rx);
 	rx->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(rx->page_pool)) {
 		retval = PTR_ERR(rx->page_pool);
@@ -906,7 +918,7 @@ static void tsnep_rx_set_page(struct tsnep_rx *rx, struct tsnep_rx_entry *entry,
 	entry->page = page;
 	entry->len = TSNEP_MAX_RX_BUF_SIZE;
 	entry->dma = page_pool_get_dma_addr(entry->page);
-	entry->desc->rx = __cpu_to_le64(entry->dma + TSNEP_SKB_PAD);
+	entry->desc->rx = __cpu_to_le64(entry->dma + tsnep_rx_offset(rx));
 }
 
 static int tsnep_rx_alloc_buffer(struct tsnep_rx *rx, int index)
@@ -1010,14 +1022,14 @@ static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 		return NULL;
 
 	/* update pointers within the skb to store the data */
-	skb_reserve(skb, TSNEP_SKB_PAD + TSNEP_RX_INLINE_METADATA_SIZE);
+	skb_reserve(skb, tsnep_rx_offset(rx) + TSNEP_RX_INLINE_METADATA_SIZE);
 	__skb_put(skb, length - TSNEP_RX_INLINE_METADATA_SIZE - ETH_FCS_LEN);
 
 	if (rx->adapter->hwtstamp_config.rx_filter == HWTSTAMP_FILTER_ALL) {
 		struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
 		struct tsnep_rx_inline *rx_inline =
 			(struct tsnep_rx_inline *)(page_address(page) +
-						   TSNEP_SKB_PAD);
+						   tsnep_rx_offset(rx));
 
 		skb_shinfo(skb)->tx_flags |=
 			SKBTX_HW_TSTAMP_NETDEV;
@@ -1077,11 +1089,12 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		 */
 		dma_rmb();
 
-		prefetch(page_address(entry->page) + TSNEP_SKB_PAD);
+		prefetch(page_address(entry->page) + tsnep_rx_offset(rx));
 		length = __le32_to_cpu(entry->desc_wb->properties) &
 			 TSNEP_DESC_LENGTH_MASK;
-		dma_sync_single_range_for_cpu(dmadev, entry->dma, TSNEP_SKB_PAD,
-					      length, dma_dir);
+		dma_sync_single_range_for_cpu(dmadev, entry->dma,
+					      tsnep_rx_offset(rx), length,
+					      dma_dir);
 
 		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
 		desc_available++;
-- 
2.30.2

