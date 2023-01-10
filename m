Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B39664DD9
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjAJVHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbjAJVH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:07:29 -0500
Received: from mx15lb.world4you.com (mx15lb.world4you.com [81.19.149.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5B45EC2E
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pWGdmfZwyhYQ1dkpnqO80F0tRY0qIpvAiczTl/ogXV4=; b=fA1YHjFloL27fRDs9RmveNBCvS
        cKlPCs5fBxd1LXoBEFJ4nrSiQ22miIbbexbs6fmf88l5nEcx+E+yrFIhLFxZk0XJXu4y+szWtxdwe
        XLDbxlGsnRgPJF5thCuEpkZT1CbM5rjmfDmVdyZfoDvzRC4ln7YNW67IuqCPkv9hRkA4=;
Received: from [88.117.53.243] (helo=[10.0.0.160])
        by mx15lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pFLq7-0003uf-KG; Tue, 10 Jan 2023 22:07:23 +0100
Message-ID: <5b719373-beb0-ce8b-7789-b24c01a28eff@engleder-embedded.com>
Date:   Tue, 10 Jan 2023 22:07:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4 05/10] tsnep: Add XDP TX support
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-6-gerhard@engleder-embedded.com>
 <f8b1b2afcdaef61c4adb8972e18cb40ad5a4787c.camel@gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <f8b1b2afcdaef61c4adb8972e18cb40ad5a4787c.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.23 17:56, Alexander H Duyck wrote:
> nOn Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
>> Implement ndo_xdp_xmit() for XDP TX support. Support for fragmented XDP
>> frames is included.
>>
>> Also some const, braces and logic clean ups are done in normal TX path
>> to keep both TX paths in sync.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep.h      |  12 +-
>>   drivers/net/ethernet/engleder/tsnep_main.c | 211 +++++++++++++++++++--
>>   2 files changed, 210 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
>> index d658413ceb14..9cb267938794 100644
>> --- a/drivers/net/ethernet/engleder/tsnep.h
>> +++ b/drivers/net/ethernet/engleder/tsnep.h
>> @@ -57,6 +57,12 @@ struct tsnep_rxnfc_rule {
>>   	int location;
>>   };
>>   
>> +enum tsnep_tx_type {
>> +	TSNEP_TX_TYPE_SKB,
>> +	TSNEP_TX_TYPE_XDP_TX,
>> +	TSNEP_TX_TYPE_XDP_NDO,
>> +};
>> +
> 
> I'm more a fan of using a bitmap rather than an enum for these type of
> things since otherwise you are having to check for 3 possible values
> for everything.
> 
> Also you may want to reorder this so that SKB is the last option. With
> that 0/1 would be your two XDP values and 2 would be your SKB value. It
> should make it easier for this to be treated more as a decision tree.

I will try to use bitmap.

>>   struct tsnep_tx_entry {
>>   	struct tsnep_tx_desc *desc;
>>   	struct tsnep_tx_desc_wb *desc_wb;
>> @@ -65,7 +71,11 @@ struct tsnep_tx_entry {
>>   
>>   	u32 properties;
>>   
>> -	struct sk_buff *skb;
>> +	enum tsnep_tx_type type;
>> +	union {
>> +		struct sk_buff *skb;
>> +		struct xdp_frame *xdpf;
>> +	};
>>   	size_t len;
>>   	DEFINE_DMA_UNMAP_ADDR(dma);xdp_return_frame_bulk
>>   };
>> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
>> index 943de5a09693..1ae73c706c9e 100644
>> --- a/drivers/net/ethernet/engleder/tsnep_main.c
>> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
>> @@ -310,10 +310,12 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
>>   	struct tsnep_tx_entry *entry = &tx->entry[index];
>>   
>>   	entry->properties = 0;
>> +	/* xdpf is union with skb */
>>   	if (entry->skb) {
>>   		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
>>   		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
>> -		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
>> +		if (entry->type == Txdp_return_frame_bulkSNEP_TX_TYPE_SKB &&
>> +		    (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS))
>>   			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
>>   
>>   		/* toggle user flag to prevent false acknowledge
>> @@ -370,7 +372,8 @@ static int tsnep_tx_desc_available(struct tsnep_tx *tx)
>>   		return tx->read - tx->write - 1;
>>   }
>>   
>> -static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
>> +static int tsnep_tx_map(const struct sk_buff *skb, struct tsnep_tx *tx,
>> +			int count)
>>   {
> 
> This change to const doesn't add anything since this is a static
> function. You could probably just skip making this change since the
> function will likely be inlined anyway.

const was requested for tsnep_xdp_tx_map() during last review round so I
added it also here to keep both function similar.

>>   	struct device *dmadev = tx->adapter->dmadev;
>>   	struct tsnep_tx_entry *entry;
>> @@ -382,7 +385,7 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
>>   	for (i = 0; i < count; i++) {
>>   		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
>>   
>> -		if (i == 0) {
>> +		if (!i) {
>>   			len = skb_headlen(skb);
>>   			dma = dma_map_single(dmadev, skb->data, len,
>>   					     DMA_TO_DEVICE);
>> @@ -400,6 +403,8 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
>>   
>>   		entry->desc->tx = __cpu_to_le64(dma);
>>   
>> +		entry->type = TSNEP_TX_TYPE_SKB;
>> +
>>   		map_len += len;
>>   	}
>>   
> 
> I wonder if it wouldn't be better to change this so that you have a 4th
> type for just "PAGE" or "FRAGMENT" since you only really need to
> identify this as SKB or XDP on the first buffer, and then all the rest
> are just going to be unmapped as page regardless of if it is XDP or
> SKB.

I will it try in combination with your bitmap suggestion.

>> @@ -417,12 +422,13 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
>>   		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
>>   
>>   		if (entry->len) {
>> -			if (i == 0)
>> +			if (!i && entry->type == TSNEP_TX_TYPE_SKB)
>>   				dma_unmap_single(dmadev,
>>   						 dma_unmap_addr(entry, dma),
>>   						 dma_unmap_len(entry, len),
>>   						 DMA_TO_DEVICE);
>> -			else
>> +			else if (entry->type == TSNEP_TX_TYPE_SKB ||
>> +				 entry->type == TSNEP_TX_TYPE_XDP_NDO)
>>   				dma_unmap_page(dmadev,
>>   					       dma_unmap_addr(entry, dma),
>>   					       dma_unmap_len(entry, len),
> 
> Rather than perform 2 checks here you could just verify type !=
> TYPE_XDP_TX which would save you a check.

Will be improved with your bitmap suggestion.

>> @@ -482,7 +488,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>>   
>>   	for (i = 0; i < count; i++)
>>   		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
>> -				  i == (count - 1));
>> +				  i == count - 1);
>>   	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
>>   
>>   	skb_tx_timestamp(skb);
>> @@ -502,12 +508,133 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>>   	return NETDEV_TX_OK;
>>   }
>>   
>> +static int tsnep_xdp_tx_map(const struct xdp_frame *xdpf, struct tsnep_tx *tx,
>> +			    const struct skb_shared_info *shinfo, int count,
>> +			    enum tsnep_tx_type type)
> 
> Again the const here isn't adding any value since this is a static
> function and will likely be inlined into the function below which calls
> it.

const was requested here during last review round so I added it. It may
add some value by detecting some problems at compile time.

>> +{
>> +	struct device *dmadev = tx->adapter->dmadev;
>> +	struct tsnep_tx_entry *entry;
>> +	const skb_frag_t *frag;
>> +	struct page *page;
>> +	unsigned int len;
>> +	int map_len = 0;
>> +	dma_addr_t dma;
>> +	void *data;
>> +	int i;
>> +
>> +	frag = NULL;
>> +	len = xdpf->len;
>> +	for (i = 0; i < count; i++) {
>> +		entry = &tx->entry[(tx->write + i) % TSNEP_RING_SIZE];
>> +		if (type == TSNEP_TX_TYPE_XDP_NDO) {
>> +			data = unlikely(frag) ? skb_frag_address(frag) :
>> +						xdpf->data;
>> +			dma = dma_map_single(dmadev, data, len, DMA_TO_DEVICE);
>> +			if (dma_mapping_error(dmadev, dma))
>> +				return -ENOMEM;
>> +
>> +			entry->type = TSNEP_TX_TYPE_XDP_NDO;
>> +		} else {
>> +			page = unlikely(frag) ? skb_frag_page(frag) :
>> +						virt_to_page(xdpf->data);
>> +			dma = page_pool_get_dma_addr(page);
>> +			if (unlikely(frag))
>> +				dma += skb_frag_off(frag);
>> +			else
>> +				dma += sizeof(*xdpf) + xdpf->headroom;
>> +			dma_sync_single_for_device(dmadev, dma, len,
>> +						   DMA_BIDIRECTIONAL);
>> +
>> +			entry->type = TSNEP_TX_TYPE_XDP_TX;
>> +		}
>> +
>> +		entry->len = len;
>> +		dma_unmap_addr_set(entry, dma, dma);
>> +
>> +		entry->desc->tx = __cpu_to_le64(dma);
>> +
>> +		map_len += len;
>> +
>> +		if (i + 1 < count) {
>> +			frag = &shinfo->frags[i];
>> +			len = skb_frag_size(frag);
>> +		}
>> +	}
>> +
>> +	return map_len;
>> +}
>> +
>> +/* This function requires __netif_tx_lock is held by the caller. */
>> +static bool tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
>> +				      struct tsnep_tx *tx,
>> +				      enum tsnep_tx_type type)
>> +{
>> +	const struct skb_shared_info *shinfo =
>> +		xdp_get_shared_info_from_frame(xdpf);
>> +	struct tsnep_tx_entry *entry;
>> +	int count, length, retval, i;
>> +
>> +	count = 1;
>> +	if (unlikely(xdp_frame_has_frags(xdpf)))
>> +		count += shinfo->nr_frags;
>> +
>> +	spin_lock_bh(&tx->lock);
>> +
>> +	/* ensure that TX ring is not filled up by XDP, always MAX_SKB_FRAGS
>> +	 * will be available for normal TX path and queue is stopped there if
>> +	 * necessary
>> +	 */
>> +	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1 + count)) {
>> +		spin_unlock_bh(&tx->lock);
>> +
>> +		return false;
>> +	}
>> +
>> +	entry = &tx->entry[tx->write];
>> +	entry->xdpf = xdpf;
>> +
>> +	retval = tsnep_xdp_tx_map(xdpf, tx, shinfo, count, type);
>> +	if (retval < 0) {
>> +		tsnep_tx_unmap(tx, tx->write, count);
>> +		entry->xdpf = NULL;
>> +
>> +		tx->dropped++;
>> +
>> +		spin_unlock_bh(&tx->lock);
>> +
>> +		return false;
>> +	}
>> +	length = retval;
>> +
>> +	for (i = 0; i < count; i++)
>> +		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
>> +				  i == count - 1);
>> +	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
>> +
>> +	/* descriptor properties shall be valid before hardware is notified */
>> +	dma_wmb();
>> +
>> +	spin_unlock_bh(&tx->lock);
>> +
>> +	return true;
>> +}
>> +
>> +static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
>> +{
>> +	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
>> +}
>> +
>>   static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>   {
>> -	int budget = 128;
>>   	struct tsnep_tx_entry *entry;
>> -	int count;
>> +	struct xdp_frame_bulk bq;
>> +	int budget = 128;
>>   	int length;
>> +	int count;
>> +
>> +	xdp_frame_bulk_init(&bq);
>> +
>> +	rcu_read_lock(); /* need for xdp_return_frame_bulk */
>>   
> 
> You should be able to get rid of both of these. See comments below.
> 
>>   	spin_lock_bh(&tx->lock);
>>   
>> @@ -527,12 +654,17 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>   		dma_rmb();
>>   
>>   		count = 1;
>> -		if (skb_shinfo(entry->skb)->nr_frags > 0)
>> +		if (entry->type == TSNEP_TX_TYPE_SKB &&
>> +		    skb_shinfo(entry->skb)->nr_frags > 0)
>>   			count += skb_shinfo(entry->skb)->nr_frags;
>> +		else if (entry->type != TSNEP_TX_TYPE_SKB &&
>> +			 xdp_frame_has_frags(entry->xdpf))
>> +			count += xdp_get_shared_info_from_frame(entry->xdpf)->nr_frags;
>>   
>>   		length = tsnep_tx_unmap(tx, tx->read, count);
>>   
>> -		if ((skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
>> +		if (entry->type == TSNEP_TX_TYPE_SKB &&
>> +		    (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
>>   		    (__le32_to_cpu(entry->desc_wb->properties) &
>>   		     TSNEP_DESC_EXTENDED_WRITEBACK_FLAG)) {
>>   			struct skb_shared_hwtstamps hwtstamps;
>> @@ -552,7 +684,18 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>   			skb_tstamp_tx(entry->skb, &hwtstamps);
>>   		}
>>   
>> -		napi_consume_skb(entry->skb, napi_budget);
>> +		switch (entry->type) {
>> +		case TSNEP_TX_TYPE_SKB:
>> +			napi_consume_skb(entry->skb, napi_budget);
>> +			break;
>> +		case TSNEP_TX_TYPE_XDP_TX:
>> +			xdp_return_frame_rx_napi(entry->xdpf);
>> +			break;
>> +		case TSNEP_TX_TYPE_XDP_NDO:
>> +			xdp_return_frame_bulk(entry->xdpf, &bq);
>> +			break;
>> +		}
>> +		/* xdpf is union with skb */
>>   		entry->skb = NULL;
>>   
>>   		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
> 
> If I am not mistaken I think you can use xdp_return_frame_rx_napi for
> both of these without having to resort to the bulk approach since the
> tsnep_tx_poll is operating in the NAPI polling context.
> 
> When you free the buffers outside of polling context you would then
> want to use the xdp_return_frame_bulk. So for example if you have any
> buffers that weren't transmitted when you get to the point of
> tsnep_tx_ring_cleanup then you would want to unmap and free them there
> using something like the xdp_return_frame or xdp_return_frame_bulk.

This is done similar in other drivers, so I thought it is good practice.
I will compare the performance of xdp_return_frame_rx_napi() and
xdp_return_frame_bulk().

>> @@ -570,7 +713,11 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>   
>>   	spin_unlock_bh(&tx->lock);
>>   
>> -	return (budget != 0);
>> +	xdp_flush_frame_bulk(&bq);
>> +
>> +	rcu_read_unlock();
>> +
>> +	return budget != 0;
>>   }
>>   
>>   static bool tsnep_tx_pending(struct tsnep_tx *tx)
>> @@ -1330,6 +1477,45 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
>>   	return ns_to_ktime(timestamp);
>>   }
>>   
>> +static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
>> +				 struct xdp_frame **xdp, u32 flags)
>> +{
>> +	struct tsnep_adapter *adapter = netdev_priv(dev);
>> +	u32 cpu = smp_processor_id();
>> +	struct netdev_queue *nq;
>> +	int nxmit, queue;
>> +	bool xmit;
>> +
>> +	if (unlikely(test_bit(__TSNEP_DOWN, &adapter->state)))
>> +		return -ENETDOWN;
>> +
> 
> Again, here you are better off probably checking for netif_carrier_ok
> rather than adding a new flag.
> 
>> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
>> +		return -EINVAL;
>> +
>> +	queue = cpu % adapter->num_tx_queues;
> 
> Modulo math here unconditionally will be expensive. Take a look at
> using reciprocal_scale like we do in skb_tx_hash.

I will try to find a better solution.

>> +	nq = netdev_get_tx_queue(adapter->netdev, queue);
>> +
>> +	__netif_tx_lock(nq, cpu);
>> +
>> +	/* Avoid transmit queue timeout since we share it with the slow path */
>> +	txq_trans_cond_update(nq);
>> +
> 
> Doing this here may not be the right spot. It might make more sense to
> do this after the call to xmit_frame_ring after the break case in order
> to guarantee that you actually put something on the ring before
> updating the state otherwise you can stall the Tx ring without
> triggering the watchdog by just hammering this.
> 
>> +	for (nxmit = 0; nxmit < n; nxmit++) {
>> +		xmit = tsnep_xdp_xmit_frame_ring(xdp[nxmit],
>> +						 &adapter->tx[queue],
>> +						 TSNEP_TX_TYPE_XDP_NDO);
>> +		if (!xmit)
>> +			break;
> 
> So move txq_trans_cond_update(nq) here.

Will be fixed.

Gerhard
