Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D70066D029
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbjAPUZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbjAPUZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:25:19 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679D825289
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=z6fJPgP5HYNG8i3+suuJRngt0cuXZ/Otk26vje0YWUg=; b=EbSP/hI13IJgrOIy2xAyrDaopz
        cnm1BSNHCFak2xuC+vN3giljp9wt90bar7SLEg8senst/LV6YaMKwgYILO9tFi7hgn8Qnz+EYs97l
        kRUmqdHcq5CS5CSpF6fX48mMV4gZO0SapNKyfr7wnj2kLtS5vAjmC9UiBub+uTbPtfu4=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pHW2Z-00018Q-Ql; Mon, 16 Jan 2023 21:25:11 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, alexander.duyck@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v5 4/9] tsnep: Add XDP TX support
Date:   Mon, 16 Jan 2023 21:24:53 +0100
Message-Id: <20230116202458.56677-5-gerhard@engleder-embedded.com>
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

Implement ndo_xdp_xmit() for XDP TX support. Support for fragmented XDP
frames is included.

Also some braces and logic cleanups are done in normal TX path to keep
both TX paths in sync.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |   6 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 193 ++++++++++++++++++++-
 2 files changed, 189 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 48910cb1bd8a..bd0fbddd3a75 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -65,7 +65,11 @@ struct tsnep_tx_entry {
 
 	u32 properties;
 
-	struct sk_buff *skb;
+	u32 type;
+	union {
+		struct sk_buff *skb;
+		struct xdp_frame *xdpf;
+	};
 	size_t len;
 	DEFINE_DMA_UNMAP_ADDR(dma);
 };
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index d25608e81ad8..9b3eddda3f06 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -43,6 +43,11 @@
 #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
 				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
 
+#define TSNEP_TX_TYPE_SKB	BIT(0)
+#define TSNEP_TX_TYPE_SKB_FRAG	BIT(1)
+#define TSNEP_TX_TYPE_XDP_TX	BIT(2)
+#define TSNEP_TX_TYPE_XDP_NDO	BIT(3)
+
 static void tsnep_enable_irq(struct tsnep_adapter *adapter, u32 mask)
 {
 	iowrite32(mask, adapter->addr + ECM_INT_ENABLE);
@@ -306,10 +311,12 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
 	struct tsnep_tx_entry *entry = &tx->entry[index];
 
 	entry->properties = 0;
+	/* xdpf is union with skb */
 	if (entry->skb) {
 		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
 		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
-		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
+		if ((entry->type & TSNEP_TX_TYPE_SKB) &&
+		    (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS))
 			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
 
 		/* toggle user flag to prevent false acknowledge
@@ -378,15 +385,19 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 	for (i = 0; i < count; i++) {
 		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
 
-		if (i == 0) {
+		if (!i) {
 			len = skb_headlen(skb);
 			dma = dma_map_single(dmadev, skb->data, len,
 					     DMA_TO_DEVICE);
+
+			entry->type = TSNEP_TX_TYPE_SKB;
 		} else {
 			len = skb_frag_size(&skb_shinfo(skb)->frags[i - 1]);
 			dma = skb_frag_dma_map(dmadev,
 					       &skb_shinfo(skb)->frags[i - 1],
 					       0, len, DMA_TO_DEVICE);
+
+			entry->type = TSNEP_TX_TYPE_SKB_FRAG;
 		}
 		if (dma_mapping_error(dmadev, dma))
 			return -ENOMEM;
@@ -413,12 +424,13 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
 		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
 
 		if (entry->len) {
-			if (i == 0)
+			if (entry->type & TSNEP_TX_TYPE_SKB)
 				dma_unmap_single(dmadev,
 						 dma_unmap_addr(entry, dma),
 						 dma_unmap_len(entry, len),
 						 DMA_TO_DEVICE);
-			else
+			else if (entry->type &
+				 (TSNEP_TX_TYPE_SKB_FRAG | TSNEP_TX_TYPE_XDP_NDO))
 				dma_unmap_page(dmadev,
 					       dma_unmap_addr(entry, dma),
 					       dma_unmap_len(entry, len),
@@ -472,7 +484,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 	for (i = 0; i < count; i++)
 		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
-				  i == (count - 1));
+				  i == count - 1);
 	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
 
 	skb_tx_timestamp(skb);
@@ -490,6 +502,110 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int tsnep_xdp_tx_map(struct xdp_frame *xdpf, struct tsnep_tx *tx,
+			    struct skb_shared_info *shinfo, int count, u32 type)
+{
+	struct device *dmadev = tx->adapter->dmadev;
+	struct tsnep_tx_entry *entry;
+	struct page *page;
+	skb_frag_t *frag;
+	unsigned int len;
+	int map_len = 0;
+	dma_addr_t dma;
+	void *data;
+	int i;
+
+	frag = NULL;
+	len = xdpf->len;
+	for (i = 0; i < count; i++) {
+		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
+		if (type & TSNEP_TX_TYPE_XDP_NDO) {
+			data = unlikely(frag) ? skb_frag_address(frag) :
+						xdpf->data;
+			dma = dma_map_single(dmadev, data, len, DMA_TO_DEVICE);
+			if (dma_mapping_error(dmadev, dma))
+				return -ENOMEM;
+
+			entry->type = TSNEP_TX_TYPE_XDP_NDO;
+		} else {
+			page = unlikely(frag) ? skb_frag_page(frag) :
+						virt_to_page(xdpf->data);
+			dma = page_pool_get_dma_addr(page);
+			if (unlikely(frag))
+				dma += skb_frag_off(frag);
+			else
+				dma += sizeof(*xdpf) + xdpf->headroom;
+			dma_sync_single_for_device(dmadev, dma, len,
+						   DMA_BIDIRECTIONAL);
+
+			entry->type = TSNEP_TX_TYPE_XDP_TX;
+		}
+
+		entry->len = len;
+		dma_unmap_addr_set(entry, dma, dma);
+
+		entry->desc->tx = __cpu_to_le64(dma);
+
+		map_len += len;
+
+		if (i + 1 < count) {
+			frag = &shinfo->frags[i];
+			len = skb_frag_size(frag);
+		}
+	}
+
+	return map_len;
+}
+
+/* This function requires __netif_tx_lock is held by the caller. */
+static bool tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
+				      struct tsnep_tx *tx, u32 type)
+{
+	struct skb_shared_info *shinfo = xdp_get_shared_info_from_frame(xdpf);
+	struct tsnep_tx_entry *entry;
+	int count, length, retval, i;
+
+	count = 1;
+	if (unlikely(xdp_frame_has_frags(xdpf)))
+		count += shinfo->nr_frags;
+
+	/* ensure that TX ring is not filled up by XDP, always MAX_SKB_FRAGS
+	 * will be available for normal TX path and queue is stopped there if
+	 * necessary
+	 */
+	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1 + count))
+		return false;
+
+	entry = &tx->entry[tx->write];
+	entry->xdpf = xdpf;
+
+	retval = tsnep_xdp_tx_map(xdpf, tx, shinfo, count, type);
+	if (retval < 0) {
+		tsnep_tx_unmap(tx, tx->write, count);
+		entry->xdpf = NULL;
+
+		tx->dropped++;
+
+		return false;
+	}
+	length = retval;
+
+	for (i = 0; i < count; i++)
+		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
+				  i == count - 1);
+	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
+
+	/* descriptor properties shall be valid before hardware is notified */
+	dma_wmb();
+
+	return true;
+}
+
+static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
+{
+	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
+}
+
 static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 {
 	struct tsnep_tx_entry *entry;
@@ -517,12 +633,17 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		dma_rmb();
 
 		count = 1;
-		if (skb_shinfo(entry->skb)->nr_frags > 0)
+		if ((entry->type & TSNEP_TX_TYPE_SKB) &&
+		    skb_shinfo(entry->skb)->nr_frags > 0)
 			count += skb_shinfo(entry->skb)->nr_frags;
+		else if (!(entry->type & TSNEP_TX_TYPE_SKB) &&
+			 xdp_frame_has_frags(entry->xdpf))
+			count += xdp_get_shared_info_from_frame(entry->xdpf)->nr_frags;
 
 		length = tsnep_tx_unmap(tx, tx->read, count);
 
-		if ((skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
+		if ((entry->type & TSNEP_TX_TYPE_SKB) &&
+		    (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
 		    (__le32_to_cpu(entry->desc_wb->properties) &
 		     TSNEP_DESC_EXTENDED_WRITEBACK_FLAG)) {
 			struct skb_shared_hwtstamps hwtstamps;
@@ -542,7 +663,11 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 			skb_tstamp_tx(entry->skb, &hwtstamps);
 		}
 
-		napi_consume_skb(entry->skb, napi_budget);
+		if (entry->type & TSNEP_TX_TYPE_SKB)
+			napi_consume_skb(entry->skb, napi_budget);
+		else
+			xdp_return_frame_rx_napi(entry->xdpf);
+		/* xdpf is union with skb */
 		entry->skb = NULL;
 
 		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
@@ -560,7 +685,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 
 	__netif_tx_unlock(nq);
 
-	return (budget != 0);
+	return budget != 0;
 }
 
 static bool tsnep_tx_pending(struct tsnep_tx *tx)
@@ -1316,6 +1441,55 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
 	return ns_to_ktime(timestamp);
 }
 
+static struct tsnep_tx *tsnep_xdp_get_tx(struct tsnep_adapter *adapter, u32 cpu)
+{
+	if (cpu >= TSNEP_MAX_QUEUES)
+		cpu &= TSNEP_MAX_QUEUES - 1;
+
+	while (cpu >= adapter->num_tx_queues)
+		cpu -= adapter->num_tx_queues;
+
+	return &adapter->tx[cpu];
+}
+
+static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
+				 struct xdp_frame **xdp, u32 flags)
+{
+	struct tsnep_adapter *adapter = netdev_priv(dev);
+	u32 cpu = smp_processor_id();
+	struct netdev_queue *nq;
+	struct tsnep_tx *tx;
+	int nxmit;
+	bool xmit;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	tx = tsnep_xdp_get_tx(adapter, cpu);
+	nq = netdev_get_tx_queue(adapter->netdev, tx->queue_index);
+
+	__netif_tx_lock(nq, cpu);
+
+	for (nxmit = 0; nxmit < n; nxmit++) {
+		xmit = tsnep_xdp_xmit_frame_ring(xdp[nxmit], tx,
+						 TSNEP_TX_TYPE_XDP_NDO);
+		if (!xmit)
+			break;
+
+		/* avoid transmit queue timeout since we share it with the slow
+		 * path
+		 */
+		txq_trans_cond_update(nq);
+	}
+
+	if (flags & XDP_XMIT_FLUSH)
+		tsnep_xdp_xmit_flush(tx);
+
+	__netif_tx_unlock(nq);
+
+	return nxmit;
+}
+
 static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_open = tsnep_netdev_open,
 	.ndo_stop = tsnep_netdev_close,
@@ -1327,6 +1501,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_set_features = tsnep_netdev_set_features,
 	.ndo_get_tstamp = tsnep_netdev_get_tstamp,
 	.ndo_setup_tc = tsnep_tc_setup,
+	.ndo_xdp_xmit = tsnep_netdev_xdp_xmit,
 };
 
 static int tsnep_mac_init(struct tsnep_adapter *adapter)
-- 
2.30.2

