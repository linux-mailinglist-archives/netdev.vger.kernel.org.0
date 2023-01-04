Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D5765DD05
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbjADTmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240196AbjADTlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:41:45 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBCCB6
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 11:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7CTITfTCKlDccREck77scWHtAYAC3geHyUZtd5TycYo=; b=pDDdKBEU2BXX1TBna7KZoetOmc
        2sTbxeoIYJLfKnWPQHlaM+7LjGUM4Q9/tNSnDQcfWpJRN5C1sp5o+J8rJyeT/UEbb97c1e4OPk671
        UjR5SH45I4ybtelDOOROEGs0apq+A6ZdcLQncoKRUVVk0NPvNcoPHWaUrRvMz8/UaQTw=;
Received: from 88-117-53-17.adsl.highway.telekom.at ([88.117.53.17] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pD9du-0003c2-Hd; Wed, 04 Jan 2023 20:41:42 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH net-next v3 7/9] tsnep: Prepare RX buffer for XDP support
Date:   Wed,  4 Jan 2023 20:41:30 +0100
Message-Id: <20230104194132.24637-8-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230104194132.24637-1-gerhard@engleder-embedded.com>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
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
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 31 +++++++++++++++-------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index a603b79b7411..b24a00782f27 100644
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
 
@@ -777,6 +778,16 @@ static void tsnep_tx_close(struct tsnep_tx *tx)
 	tsnep_tx_ring_cleanup(tx);
 }
 
+static unsigned int tsnep_rx_offset(struct tsnep_rx *rx)
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
@@ -838,9 +849,10 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
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
@@ -875,7 +887,7 @@ static void tsnep_rx_set_page(struct tsnep_rx *rx, struct tsnep_rx_entry *entry,
 	entry->page = page;
 	entry->len = TSNEP_MAX_RX_BUF_SIZE;
 	entry->dma = page_pool_get_dma_addr(entry->page);
-	entry->desc->rx = __cpu_to_le64(entry->dma + TSNEP_SKB_PAD);
+	entry->desc->rx = __cpu_to_le64(entry->dma + tsnep_rx_offset(rx));
 }
 
 static int tsnep_rx_alloc_buffer(struct tsnep_rx *rx, int index)
@@ -979,14 +991,14 @@ static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 		return NULL;
 
 	/* update pointers within the skb to store the data */
-	skb_reserve(skb, TSNEP_SKB_PAD + TSNEP_RX_INLINE_METADATA_SIZE);
+	skb_reserve(skb, tsnep_rx_offset(rx) + TSNEP_RX_INLINE_METADATA_SIZE);
 	__skb_put(skb, length - ETH_FCS_LEN);
 
 	if (rx->adapter->hwtstamp_config.rx_filter == HWTSTAMP_FILTER_ALL) {
 		struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
 		struct tsnep_rx_inline *rx_inline =
 			(struct tsnep_rx_inline *)(page_address(page) +
-						   TSNEP_SKB_PAD);
+						   tsnep_rx_offset(rx));
 
 		skb_shinfo(skb)->tx_flags |=
 			SKBTX_HW_TSTAMP_NETDEV;
@@ -1046,11 +1058,12 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
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
 
 		/* RX metadata with timestamps is in front of actual data,
 		 * subtract metadata size to get length of actual data and
-- 
2.30.2

