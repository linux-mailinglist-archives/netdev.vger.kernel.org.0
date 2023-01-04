Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A7C65DCFF
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbjADTlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240011AbjADTln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:41:43 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB5DB17
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 11:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8mNjNyjCEK1GvzFmNiikgeFft0psgFGGTNeQD9Bjkko=; b=kYb36NfyIjo7sU21Ioa1Bbpc6h
        hrxIpflWmBQfG6NMYLkZuiU1X7ztT23HAEhqFpZ3bFRwCrrSFTjsnrrMdOpjI9/GZWWXKzCKdCPjz
        LWqPkeWmJW+1nl68QPjdvAiwbSrS5lKCwVftpXqHRAXh+HhiWNVif5WEWKD6H8W1oWuA=;
Received: from 88-117-53-17.adsl.highway.telekom.at ([88.117.53.17] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pD9ds-0003c2-QF; Wed, 04 Jan 2023 20:41:40 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 4/9] tsnep: Add XDP TX support
Date:   Wed,  4 Jan 2023 20:41:27 +0100
Message-Id: <20230104194132.24637-5-gerhard@engleder-embedded.com>
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

Implement ndo_xdp_xmit() for XDP TX support. Support for fragmented XDP
frames is included.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |  12 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 208 ++++++++++++++++++++-
 2 files changed, 209 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index f72c0c4da1a9..29b04127f529 100644
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
index 56c8cae6251e..2c7252ded23a 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -310,10 +310,11 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
 	struct tsnep_tx_entry *entry = &tx->entry[index];
 
 	entry->properties = 0;
-	if (entry->skb) {
+	if (entry->skb || entry->xdpf) {
 		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
 		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
-		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
+		if (entry->type == TSNEP_TX_TYPE_SKB &&
+		    skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
 			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
 
 		/* toggle user flag to prevent false acknowledge
@@ -400,6 +401,8 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 
 		entry->desc->tx = __cpu_to_le64(dma);
 
+		entry->type = TSNEP_TX_TYPE_SKB;
+
 		map_len += len;
 	}
 
@@ -417,12 +420,13 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
 		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
 
 		if (entry->len) {
-			if (i == 0)
+			if (i == 0 && entry->type == TSNEP_TX_TYPE_SKB)
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
@@ -502,12 +506,134 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int tsnep_xdp_tx_map(struct xdp_frame *xdpf, struct tsnep_tx *tx,
+			    struct skb_shared_info *shinfo, int count,
+			    enum tsnep_tx_type type)
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
+		if ((i + 1) < count) {
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
+	struct skb_shared_info *shinfo = xdp_get_shared_info_from_frame(xdpf);
+	struct tsnep_tx_entry *entry;
+	int count = 1;
+	int length;
+	int retval;
+	int i;
+
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
+				  i == (count - 1));
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
 
@@ -527,12 +653,17 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
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
@@ -552,8 +683,20 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 			skb_tstamp_tx(entry->skb, &hwtstamps);
 		}
 
-		napi_consume_skb(entry->skb, budget);
-		entry->skb = NULL;
+		switch (entry->type) {
+		case TSNEP_TX_TYPE_SKB:
+			napi_consume_skb(entry->skb, budget);
+			entry->skb = NULL;
+			break;
+		case TSNEP_TX_TYPE_XDP_TX:
+			xdp_return_frame_rx_napi(entry->xdpf);
+			entry->xdpf = NULL;
+			break;
+		case TSNEP_TX_TYPE_XDP_NDO:
+			xdp_return_frame_bulk(entry->xdpf, &bq);
+			entry->xdpf = NULL;
+			break;
+		}
 
 		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
 
@@ -570,6 +713,10 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 
 	spin_unlock_bh(&tx->lock);
 
+	xdp_flush_frame_bulk(&bq);
+
+	rcu_read_unlock();
+
 	return (budget != 0);
 }
 
@@ -1330,6 +1477,46 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
 	return ns_to_ktime(timestamp);
 }
 
+static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
+				 struct xdp_frame **xdp, u32 flags)
+{
+	struct tsnep_adapter *adapter = netdev_priv(dev);
+	int cpu = smp_processor_id();
+	struct netdev_queue *nq;
+	int nxmit;
+	int queue;
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
@@ -1341,6 +1528,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_set_features = tsnep_netdev_set_features,
 	.ndo_get_tstamp = tsnep_netdev_get_tstamp,
 	.ndo_setup_tc = tsnep_tc_setup,
+	.ndo_xdp_xmit = tsnep_netdev_xdp_xmit,
 };
 
 static int tsnep_mac_init(struct tsnep_adapter *adapter)
-- 
2.30.2

