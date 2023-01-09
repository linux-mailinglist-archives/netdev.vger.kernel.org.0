Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CDD663025
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbjAITPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbjAITPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:15:33 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64D28FD9
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FyPbOBhxaB3ZPTtj8QFQql5SNS5MTQHDxBscsoDhbS4=; b=kTxt8OfdoOMO/iOqmWkJ64ZmRm
        /1GvqOFS1Od9Ls9rTUIDKcN/IVOXA6o4XJ5jY/+/6aXFEKSFub+lPSz/U6WixMzMTO6KrGcgoBRyl
        OrCAKRS4jmSbJ+ipWA2JVmeiaS10zjHRyC1E3wxHRemge5+s/k27jS49SyTn9rieVSFM=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pExcI-0007WQ-7O; Mon, 09 Jan 2023 20:15:30 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 05/10] tsnep: Add XDP TX support
Date:   Mon,  9 Jan 2023 20:15:18 +0100
Message-Id: <20230109191523.12070-6-gerhard@engleder-embedded.com>
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

Implement ndo_xdp_xmit() for XDP TX support. Support for fragmented XDP
frames is included.

Also some const, braces and logic clean ups are done in normal TX path
to keep both TX paths in sync.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |  12 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 211 +++++++++++++++++++--
 2 files changed, 210 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index d658413ceb14..9cb267938794 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -57,6 +57,12 @@ struct tsnep_rxnfc_rule {
 	int location;
 };
 
+enum tsnep_tx_type {
+	TSNEP_TX_TYPE_SKB,
+	TSNEP_TX_TYPE_XDP_TX,
+	TSNEP_TX_TYPE_XDP_NDO,
+};
+
 struct tsnep_tx_entry {
 	struct tsnep_tx_desc *desc;
 	struct tsnep_tx_desc_wb *desc_wb;
@@ -65,7 +71,11 @@ struct tsnep_tx_entry {
 
 	u32 properties;
 
-	struct sk_buff *skb;
+	enum tsnep_tx_type type;
+	union {
+		struct sk_buff *skb;
+		struct xdp_frame *xdpf;
+	};
 	size_t len;
 	DEFINE_DMA_UNMAP_ADDR(dma);
 };
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 943de5a09693..1ae73c706c9e 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -310,10 +310,12 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
 	struct tsnep_tx_entry *entry = &tx->entry[index];
 
 	entry->properties = 0;
+	/* xdpf is union with skb */
 	if (entry->skb) {
 		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
 		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
-		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
+		if (entry->type == TSNEP_TX_TYPE_SKB &&
+		    (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS))
 			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
 
 		/* toggle user flag to prevent false acknowledge
@@ -370,7 +372,8 @@ static int tsnep_tx_desc_available(struct tsnep_tx *tx)
 		return tx->read - tx->write - 1;
 }
 
-static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
+static int tsnep_tx_map(const struct sk_buff *skb, struct tsnep_tx *tx,
+			int count)
 {
 	struct device *dmadev = tx->adapter->dmadev;
 	struct tsnep_tx_entry *entry;
@@ -382,7 +385,7 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 	for (i = 0; i < count; i++) {
 		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
 
-		if (i == 0) {
+		if (!i) {
 			len = skb_headlen(skb);
 			dma = dma_map_single(dmadev, skb->data, len,
 					     DMA_TO_DEVICE);
@@ -400,6 +403,8 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 
 		entry->desc->tx = __cpu_to_le64(dma);
 
+		entry->type = TSNEP_TX_TYPE_SKB;
+
 		map_len += len;
 	}
 
@@ -417,12 +422,13 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
 		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
 
 		if (entry->len) {
-			if (i == 0)
+			if (!i && entry->type == TSNEP_TX_TYPE_SKB)
 				dma_unmap_single(dmadev,
 						 dma_unmap_addr(entry, dma),
 						 dma_unmap_len(entry, len),
 						 DMA_TO_DEVICE);
-			else
+			else if (entry->type == TSNEP_TX_TYPE_SKB ||
+				 entry->type == TSNEP_TX_TYPE_XDP_NDO)
 				dma_unmap_page(dmadev,
 					       dma_unmap_addr(entry, dma),
 					       dma_unmap_len(entry, len),
@@ -482,7 +488,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 
 	for (i = 0; i < count; i++)
 		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
-				  i == (count - 1));
+				  i == count - 1);
 	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
 
 	skb_tx_timestamp(skb);
@@ -502,12 +508,133 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int tsnep_xdp_tx_map(const struct xdp_frame *xdpf, struct tsnep_tx *tx,
+			    const struct skb_shared_info *shinfo, int count,
+			    enum tsnep_tx_type type)
+{
+	struct device *dmadev = tx->adapter->dmadev;
+	struct tsnep_tx_entry *entry;
+	const skb_frag_t *frag;
+	struct page *page;
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
+		if (type == TSNEP_TX_TYPE_XDP_NDO) {
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
+				      struct tsnep_tx *tx,
+				      enum tsnep_tx_type type)
+{
+	const struct skb_shared_info *shinfo =
+		xdp_get_shared_info_from_frame(xdpf);
+	struct tsnep_tx_entry *entry;
+	int count, length, retval, i;
+
+	count = 1;
+	if (unlikely(xdp_frame_has_frags(xdpf)))
+		count += shinfo->nr_frags;
+
+	spin_lock_bh(&tx->lock);
+
+	/* ensure that TX ring is not filled up by XDP, always MAX_SKB_FRAGS
+	 * will be available for normal TX path and queue is stopped there if
+	 * necessary
+	 */
+	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1 + count)) {
+		spin_unlock_bh(&tx->lock);
+
+		return false;
+	}
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
+		spin_unlock_bh(&tx->lock);
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
+	spin_unlock_bh(&tx->lock);
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
-	int budget = 128;
 	struct tsnep_tx_entry *entry;
-	int count;
+	struct xdp_frame_bulk bq;
+	int budget = 128;
 	int length;
+	int count;
+
+	xdp_frame_bulk_init(&bq);
+
+	rcu_read_lock(); /* need for xdp_return_frame_bulk */
 
 	spin_lock_bh(&tx->lock);
 
@@ -527,12 +654,17 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		dma_rmb();
 
 		count = 1;
-		if (skb_shinfo(entry->skb)->nr_frags > 0)
+		if (entry->type == TSNEP_TX_TYPE_SKB &&
+		    skb_shinfo(entry->skb)->nr_frags > 0)
 			count += skb_shinfo(entry->skb)->nr_frags;
+		else if (entry->type != TSNEP_TX_TYPE_SKB &&
+			 xdp_frame_has_frags(entry->xdpf))
+			count += xdp_get_shared_info_from_frame(entry->xdpf)->nr_frags;
 
 		length = tsnep_tx_unmap(tx, tx->read, count);
 
-		if ((skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
+		if (entry->type == TSNEP_TX_TYPE_SKB &&
+		    (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
 		    (__le32_to_cpu(entry->desc_wb->properties) &
 		     TSNEP_DESC_EXTENDED_WRITEBACK_FLAG)) {
 			struct skb_shared_hwtstamps hwtstamps;
@@ -552,7 +684,18 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 			skb_tstamp_tx(entry->skb, &hwtstamps);
 		}
 
-		napi_consume_skb(entry->skb, napi_budget);
+		switch (entry->type) {
+		case TSNEP_TX_TYPE_SKB:
+			napi_consume_skb(entry->skb, napi_budget);
+			break;
+		case TSNEP_TX_TYPE_XDP_TX:
+			xdp_return_frame_rx_napi(entry->xdpf);
+			break;
+		case TSNEP_TX_TYPE_XDP_NDO:
+			xdp_return_frame_bulk(entry->xdpf, &bq);
+			break;
+		}
+		/* xdpf is union with skb */
 		entry->skb = NULL;
 
 		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
@@ -570,7 +713,11 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 
 	spin_unlock_bh(&tx->lock);
 
-	return (budget != 0);
+	xdp_flush_frame_bulk(&bq);
+
+	rcu_read_unlock();
+
+	return budget != 0;
 }
 
 static bool tsnep_tx_pending(struct tsnep_tx *tx)
@@ -1330,6 +1477,45 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
 	return ns_to_ktime(timestamp);
 }
 
+static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
+				 struct xdp_frame **xdp, u32 flags)
+{
+	struct tsnep_adapter *adapter = netdev_priv(dev);
+	u32 cpu = smp_processor_id();
+	struct netdev_queue *nq;
+	int nxmit, queue;
+	bool xmit;
+
+	if (unlikely(test_bit(__TSNEP_DOWN, &adapter->state)))
+		return -ENETDOWN;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	queue = cpu % adapter->num_tx_queues;
+	nq = netdev_get_tx_queue(adapter->netdev, queue);
+
+	__netif_tx_lock(nq, cpu);
+
+	/* Avoid transmit queue timeout since we share it with the slow path */
+	txq_trans_cond_update(nq);
+
+	for (nxmit = 0; nxmit < n; nxmit++) {
+		xmit = tsnep_xdp_xmit_frame_ring(xdp[nxmit],
+						 &adapter->tx[queue],
+						 TSNEP_TX_TYPE_XDP_NDO);
+		if (!xmit)
+			break;
+	}
+
+	if (flags & XDP_XMIT_FLUSH)
+		tsnep_xdp_xmit_flush(&adapter->tx[queue]);
+
+	__netif_tx_unlock(nq);
+
+	return nxmit;
+}
+
 static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_open = tsnep_netdev_open,
 	.ndo_stop = tsnep_netdev_close,
@@ -1341,6 +1527,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_set_features = tsnep_netdev_set_features,
 	.ndo_get_tstamp = tsnep_netdev_get_tstamp,
 	.ndo_setup_tc = tsnep_tc_setup,
+	.ndo_xdp_xmit = tsnep_netdev_xdp_xmit,
 };
 
 static int tsnep_mac_init(struct tsnep_adapter *adapter)
-- 
2.30.2

