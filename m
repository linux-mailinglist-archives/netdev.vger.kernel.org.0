Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5501E647C34
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLICXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiLICXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:23:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A4124095;
        Thu,  8 Dec 2022 18:23:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCD1FB82707;
        Fri,  9 Dec 2022 02:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE8FC433D2;
        Fri,  9 Dec 2022 02:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670552617;
        bh=c2BOm561Dr5uslAERcH+AYxqVGbDtvY4eYUNbHGYwdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZsYB+l44fkmWMWgzo+mY8tjqUBHyWCPFQ6qOSEN8vZ2ET6IoxLWNbr/iJ91+qam7Q
         h2KRrARhNbHYL0uoj36Oy9WFaSIqW+MARC+zlo4DchPVA2LM62uT3fwtbds+647ooL
         s3HcO2uPEKXhg77pt7ZoFX5dLZDDn7Lg8isq3Thdrf91GBCgFV64H4tN/l1l3YFIsm
         5n4C+rxWFEHB7f4g/BQ8Pui/h1/soJf0wpiIfBYDmN0aWRHf2+agPK0bx5BzzUlIkt
         Yq/G344ptK3K+7qNG/sZmjn+svN5UowqEOVEIU1smzxvYO1arWr723cDPdWi2HykHE
         SJlkcJ+mr6gBA==
Date:   Thu, 8 Dec 2022 18:23:35 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Subject: Re: [PATCH net-next v2 2/6] tsnep: Add XDP TX support
Message-ID: <Y5KcJ+VliAl0aR0l@x130>
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-3-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221208054045.3600-3-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Dec 06:40, Gerhard Engleder wrote:
>Implement ndo_xdp_xmit() for XDP TX support. Support for fragmented XDP
>frames is included.
>
>Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>---
> drivers/net/ethernet/engleder/tsnep.h      |  12 +-
> drivers/net/ethernet/engleder/tsnep_main.c | 204 ++++++++++++++++++++-
> 2 files changed, 207 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
>index f72c0c4da1a9..29b04127f529 100644
>--- a/drivers/net/ethernet/engleder/tsnep.h
>+++ b/drivers/net/ethernet/engleder/tsnep.h
>@@ -57,6 +57,12 @@ struct tsnep_rxnfc_rule {
> 	int location;
> };
>
>+enum tsnep_tx_type {
>+	TSNEP_TX_TYPE_SKB,
>+	TSNEP_TX_TYPE_XDP_TX,
>+	TSNEP_TX_TYPE_XDP_NDO,
>+};
>+
> struct tsnep_tx_entry {
> 	struct tsnep_tx_desc *desc;
> 	struct tsnep_tx_desc_wb *desc_wb;
>@@ -65,7 +71,11 @@ struct tsnep_tx_entry {
>
> 	u32 properties;
>
>-	struct sk_buff *skb;
>+	enum tsnep_tx_type type;
>+	union {
>+		struct sk_buff *skb;
>+		struct xdp_frame *xdpf;
>+	};
> 	size_t len;
> 	DEFINE_DMA_UNMAP_ADDR(dma);
> };
>diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
>index a28fde9fb060..b97cfd5fa1fa 100644
>--- a/drivers/net/ethernet/engleder/tsnep_main.c
>+++ b/drivers/net/ethernet/engleder/tsnep_main.c
>@@ -310,10 +310,11 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
> 	struct tsnep_tx_entry *entry = &tx->entry[index];
>
> 	entry->properties = 0;
>-	if (entry->skb) {
>+	if (entry->skb || entry->xdpf) {
> 		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
> 		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
>-		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
>+		if (entry->type == TSNEP_TX_TYPE_SKB &&
>+		    skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
> 			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
>
> 		/* toggle user flag to prevent false acknowledge
>@@ -400,6 +401,8 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
>
> 		entry->desc->tx = __cpu_to_le64(dma);
>
>+		entry->type = TSNEP_TX_TYPE_SKB;
>+
> 		map_len += len;
> 	}
>
>@@ -417,12 +420,13 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
> 		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
>
> 		if (entry->len) {
>-			if (i == 0)
>+			if (i == 0 && entry->type == TSNEP_TX_TYPE_SKB)
> 				dma_unmap_single(dmadev,
> 						 dma_unmap_addr(entry, dma),
> 						 dma_unmap_len(entry, len),
> 						 DMA_TO_DEVICE);
>-			else
>+			else if (entry->type == TSNEP_TX_TYPE_SKB ||
>+				 entry->type == TSNEP_TX_TYPE_XDP_NDO)
> 				dma_unmap_page(dmadev,
> 					       dma_unmap_addr(entry, dma),
> 					       dma_unmap_len(entry, len),
>@@ -505,6 +509,122 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
> 	return NETDEV_TX_OK;
> }
>
>+static int tsnep_xdp_tx_map(struct xdp_frame *xdpf, struct tsnep_tx *tx,
>+			    struct skb_shared_info *shinfo, int count,
>+			    bool dma_map)
>+{
>+	struct device *dmadev = tx->adapter->dmadev;
>+	skb_frag_t *frag;
>+	unsigned int len;
>+	struct tsnep_tx_entry *entry;
>+	void *data;
>+	struct page *page;
>+	dma_addr_t dma;
>+	int map_len = 0;
>+	int i;
>+
>+	frag = NULL;
>+	len = xdpf->len;
>+	for (i = 0; i < count; i++) {
>+		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
>+		if (dma_map) {

wouldn't it have made more sense if you passed TSNEP_TX_TYPE instead of
bool dma_map ?
here and in tsnep_xdp_xmit_frame_ring as well.. 

>+			data = unlikely(frag) ? skb_frag_address(frag) :
>+						xdpf->data;
>+			dma = dma_map_single(dmadev, data, len, DMA_TO_DEVICE);
>+			if (dma_mapping_error(dmadev, dma))
>+				return -ENOMEM;
>+
>+			entry->type = TSNEP_TX_TYPE_XDP_NDO;
>+		} else {
>+			page = unlikely(frag) ? skb_frag_page(frag) :
>+						virt_to_page(xdpf->data);
>+			dma = page_pool_get_dma_addr(page);
>+			if (unlikely(frag))
>+				dma += skb_frag_off(frag);
>+			else
>+				dma += sizeof(*xdpf) + xdpf->headroom;
>+			dma_sync_single_for_device(dmadev, dma, len,
>+						   DMA_BIDIRECTIONAL);
>+
>+			entry->type = TSNEP_TX_TYPE_XDP_TX;
>+		}
>+
>+		entry->len = len;
>+		dma_unmap_addr_set(entry, dma, dma);
>+
>+		entry->desc->tx = __cpu_to_le64(dma);
>+
>+		map_len += len;
>+
>+		if ((i + 1) < count) {
>+			frag = &shinfo->frags[i];
>+			len = skb_frag_size(frag);
>+		}
>+	}
>+
>+	return map_len;
>+}
>+
>+/* This function requires __netif_tx_lock is held by the caller. */
>+static int tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
>+				     struct tsnep_tx *tx, bool dma_map)
>+{
>+	struct skb_shared_info *shinfo = xdp_get_shared_info_from_frame(xdpf);
>+	unsigned long flags;
>+	int count = 1;
>+	struct tsnep_tx_entry *entry;
>+	int length;
>+	int i;
>+	int retval;

Maciiej already commented on this, and i agree with him, the whole series
needs some work on rev xmas tree variable declaration, code will look much
neater.

>+
>+	if (unlikely(xdp_frame_has_frags(xdpf)))
>+		count += shinfo->nr_frags;
>+
>+	spin_lock_irqsave(&tx->lock, flags);
>+
>+	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1 + count)) {
>+		/* prevent full TX ring due to XDP */
>+		spin_unlock_irqrestore(&tx->lock, flags);
>+
>+		return -EBUSY;

You don't really do anything with the retval, so just return a boolean.

>+	}
>+
>+	entry = &tx->entry[tx->write];
>+	entry->xdpf = xdpf;
>+
>+	retval = tsnep_xdp_tx_map(xdpf, tx, shinfo, count, dma_map);
>+	if (retval < 0) {
>+		tsnep_tx_unmap(tx, tx->write, count);
>+		entry->xdpf = NULL;
>+
>+		tx->dropped++;
>+
>+		spin_unlock_irqrestore(&tx->lock, flags);
>+
>+		netdev_err(tx->adapter->netdev, "XDP TX DMA map failed\n");

please avoid printing in data path, find other means to expose such info.
stats
tracepoints
debug_message rate limited, etc .. 


>+
>+		return retval;
>+	}
>+	length = retval;
>+
>+	for (i = 0; i < count; i++)
>+		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
>+				  i == (count - 1));
>+	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
>+
>+	/* descriptor properties shall be valid before hardware is notified */
>+	dma_wmb();
>+
>+	spin_unlock_irqrestore(&tx->lock, flags);
>+
>+	return 0;
>+}
>+
>+static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
>+{
>+	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
>+}
>+
> static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> {
> 	unsigned long flags;
>@@ -512,6 +632,11 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> 	struct tsnep_tx_entry *entry;
> 	int count;
> 	int length;
>+	struct xdp_frame_bulk bq;
>+
>+	xdp_frame_bulk_init(&bq);
>+
>+	rcu_read_lock(); /* need for xdp_return_frame_bulk */
>
> 	spin_lock_irqsave(&tx->lock, flags);
>
>@@ -531,12 +656,17 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> 		dma_rmb();
>
> 		count = 1;
>-		if (skb_shinfo(entry->skb)->nr_frags > 0)
>+		if (entry->type == TSNEP_TX_TYPE_SKB &&
>+		    skb_shinfo(entry->skb)->nr_frags > 0)
> 			count += skb_shinfo(entry->skb)->nr_frags;
>+		else if (entry->type != TSNEP_TX_TYPE_SKB &&
>+			 xdp_frame_has_frags(entry->xdpf))
>+			count += xdp_get_shared_info_from_frame(entry->xdpf)->nr_frags;
>
> 		length = tsnep_tx_unmap(tx, tx->read, count);
>
>-		if ((skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
>+		if (entry->type == TSNEP_TX_TYPE_SKB &&
>+		    (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
> 		    (__le32_to_cpu(entry->desc_wb->properties) &
> 		     TSNEP_DESC_EXTENDED_WRITEBACK_FLAG)) {
> 			struct skb_shared_hwtstamps hwtstamps;
>@@ -556,8 +686,20 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
> 			skb_tstamp_tx(entry->skb, &hwtstamps);
> 		}
>
>-		napi_consume_skb(entry->skb, budget);
>-		entry->skb = NULL;
>+		switch (entry->type) {
>+		case TSNEP_TX_TYPE_SKB:
>+			napi_consume_skb(entry->skb, budget);
>+			entry->skb = NULL;
>+			break;
>+		case TSNEP_TX_TYPE_XDP_TX:
>+			xdp_return_frame_rx_napi(entry->xdpf);
>+			entry->xdpf = NULL;
>+			break;
>+		case TSNEP_TX_TYPE_XDP_NDO:
>+			xdp_return_frame_bulk(entry->xdpf, &bq);
>+			entry->xdpf = NULL;
>+			break;
>+		}
>
> 		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
>
>@@ -574,6 +716,10 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>
> 	spin_unlock_irqrestore(&tx->lock, flags);
>
>+	xdp_flush_frame_bulk(&bq);
>+
>+	rcu_read_unlock();
>+
> 	return (budget != 0);
> }
>
>@@ -1335,6 +1481,47 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
> 	return ns_to_ktime(timestamp);
> }
>
>+static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
>+				 struct xdp_frame **xdp, u32 flags)
>+{
>+	struct tsnep_adapter *adapter = netdev_priv(dev);
>+	int cpu = smp_processor_id();
>+	int queue;
>+	struct netdev_queue *nq;
>+	int nxmit = 0;
>+	int i;
>+	int retval;
>+
>+	if (unlikely(test_bit(__TSNEP_DOWN, &adapter->state)))
>+		return -ENETDOWN;
>+
>+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
>+		return -EINVAL;
>+
>+	queue = cpu % adapter->num_tx_queues;
>+	nq = netdev_get_tx_queue(adapter->netdev, queue);
>+
>+	__netif_tx_lock(nq, cpu);
>+
>+	/* Avoid transmit queue timeout since we share it with the slow path */
>+	txq_trans_cond_update(nq);
>+
>+	for (i = 0; i < n; i++) {
>+		retval = tsnep_xdp_xmit_frame_ring(xdp[i], &adapter->tx[queue], true);
>+		if (retval)
>+			break;
>+
>+		nxmit++; 

you could just use the loop iterator and drop nxmit.

>+	}
>+
>+	if (flags & XDP_XMIT_FLUSH)
>+		tsnep_xdp_xmit_flush(&adapter->tx[queue]);
>+
>+	__netif_tx_unlock(nq);
>+
>+	return nxmit;
>
[ ... ]
