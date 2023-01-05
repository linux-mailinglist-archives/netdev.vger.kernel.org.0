Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFBC65F58B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjAEVNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbjAEVNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:13:15 -0500
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1407B4BD73
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1be1JcFgsOrabDpWjuAMWSSW32p/Xv/InnQj2+YAy2c=; b=PuKgV1IjITMY3GPocmO1p1RAs/
        o2t6rt2nxQATZt9ZpUDlxW2SDw5ATsn05gGCQIO7D7Zt665i6qoybFQJAylP6tK+zIqfRgskR3AC9
        TUMRPD14emUREJYMf/uyYtJzKHJfxyyK3Dbxdi6mm+Ev21KgyZCNZ55QIfFW5EI+5QFU=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pDXXp-0008VA-3S; Thu, 05 Jan 2023 22:13:01 +0100
Message-ID: <01d5398f-84a1-0fbe-e815-76f9f2c3e022@engleder-embedded.com>
Date:   Thu, 5 Jan 2023 22:13:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 4/9] tsnep: Add XDP TX support
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-5-gerhard@engleder-embedded.com>
 <0d4b78ab-603d-e39d-f804-4f5d2f8efab8@intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <0d4b78ab-603d-e39d-f804-4f5d2f8efab8@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.01.23 14:01, Alexander Lobakin wrote:
> From: Gerhard Engleder <gerhard@engleder-embedded.com>
> Date: Wed Jan 04 2023 20:41:27 GMT+0100
> 
>> Implement ndo_xdp_xmit() for XDP TX support. Support for fragmented XDP
>> frames is included.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep.h      |  12 +-
>>   drivers/net/ethernet/engleder/tsnep_main.c | 208 ++++++++++++++++++++-
>>   2 files changed, 209 insertions(+), 11 deletions(-)
> 
> [...]
> 
>> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
>> index 56c8cae6251e..2c7252ded23a 100644
>> --- a/drivers/net/ethernet/engleder/tsnep_main.c
>> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
>> @@ -310,10 +310,11 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
>>   	struct tsnep_tx_entry *entry = &tx->entry[index];
>>   
>>   	entry->properties = 0;
>> -	if (entry->skb) {
>> +	if (entry->skb || entry->xdpf) {
>>   		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
>>   		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
>> -		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
>> +		if (entry->type == TSNEP_TX_TYPE_SKB &&
>> +		    skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
> 
> Please enclose bitops (& here) hanging around any logical ops (&& here
> in their own set of braces ().

Will be done.

>>   			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
>>   
>>   		/* toggle user flag to prevent false acknowledge
> 
> [...]
> 
>> @@ -417,12 +420,13 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
>>   		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
>>   
>>   		if (entry->len) {
>> -			if (i == 0)
>> +			if (i == 0 && entry->type == TSNEP_TX_TYPE_SKB)
> 
> `if (!i && ...)`, I think even checkpatch warns or was warning about
> preferring !a over `a == 0` at some point.

There is no checkpatch warning. I will change it here and at a similar
location in normal TX path.

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
>> @@ -502,12 +506,134 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>>   	return NETDEV_TX_OK;
>>   }
>>   
>> +static int tsnep_xdp_tx_map(struct xdp_frame *xdpf, struct tsnep_tx *tx,
>> +			    struct skb_shared_info *shinfo, int count,
> 
> I believe most of those pointers, if not all of them, can be const, you
> only read data from them (probably except @tx).

Will be done.

>> +			    enum tsnep_tx_type type)
>> +{
>> +	struct device *dmadev = tx->adapter->dmadev;
>> +	struct tsnep_tx_entry *entry;
>> +	struct page *page;
>> +	skb_frag_t *frag;
> 
> This one as well (also please check for @page, can't say for sure).

Will be done for frag. page is not possible.

>> +	unsigned int len;
>> +	int map_len = 0;
>> +	dma_addr_t dma;
>> +	void *data;
>> +	int i;
> 
> [...]
> 
>> +		entry->len = len;
>> +		dma_unmap_addr_set(entry, dma, dma);
>> +
>> +		entry->desc->tx = __cpu_to_le64(dma);
>> +
>> +		map_len += len;
>> +
>> +		if ((i + 1) < count) {
> 
> Those braces are redundant here.

Braces will be removed.

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
>> +	struct skb_shared_info *shinfo = xdp_get_shared_info_from_frame(xdpf);
> 
> Same for this one (const).

Will be done.

>> +	struct tsnep_tx_entry *entry;
>> +	int count = 1;
>> +	int length;
>> +	int retval;
>> +	int i;
> 
> Maybe squash some of them into one line as they are of the same type?

Will be done.

>> +
>> +	if (unlikely(xdp_frame_has_frags(xdpf)))
>> +		count += shinfo->nr_frags;
>> +
>> +	spin_lock_bh(&tx->lock);
> 
> [...]
> 
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
>> +				  i == (count - 1));
> 
> Redundant braces around `count - 1`.

Braces will be removed here and at a similar location in normal TX path.

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
> 
> BTW, why do you ignore NAPI budget and use your own?

I followed the style of igb/igc which also use their own budget fo 128
for TX polling. I checked again and in contrast to these drivers tsnep
does not forward the budget to napi_consume_skb(). I assume this should
be changed with a separate patch?

I have to confess, that I don't understand exactly how this NAPI budget
stuff works. I did not find any documentation so I followed igb/igc.

>>   	int length;
>> +	int count;
>> +
>> +	xdp_frame_bulk_init(&bq);
>> +
>> +	rcu_read_lock(); /* need for xdp_return_frame_bulk */
>>   
>>   	spin_lock_bh(&tx->lock);
>>   
> 
> [...]
> 
>> @@ -552,8 +683,20 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>   			skb_tstamp_tx(entry->skb, &hwtstamps);
>>   		}
>>   
>> -		napi_consume_skb(entry->skb, budget);
>> -		entry->skb = NULL;
>> +		switch (entry->type) {
>> +		case TSNEP_TX_TYPE_SKB:
>> +			napi_consume_skb(entry->skb, budget);
>> +			entry->skb = NULL;
>> +			break;
>> +		case TSNEP_TX_TYPE_XDP_TX:
>> +			xdp_return_frame_rx_napi(entry->xdpf);
>> +			entry->xdpf = NULL;
>> +			break;
>> +		case TSNEP_TX_TYPE_XDP_NDO:
>> +			xdp_return_frame_bulk(entry->xdpf, &bq);
>> +			entry->xdpf = NULL;
>> +			break;
>> +		}
> 
> entry ::skb and ::xdpf share the same slot, you could nullify it here
> once instead of duplicating the same op across each case.

I will nullify only ::sbk and add comment about ::xdpf.

>>   
>>   		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
>>   
>> @@ -570,6 +713,10 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>   
>>   	spin_unlock_bh(&tx->lock);
>>   
>> +	xdp_flush_frame_bulk(&bq);
>> +
>> +	rcu_read_unlock();
>> +
>>   	return (budget != 0);
> 
> Also redundant braces.

Braces will be removed.

>>   }
>>   
>> @@ -1330,6 +1477,46 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
>>   	return ns_to_ktime(timestamp);
>>   }
>>   
>> +static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
>> +				 struct xdp_frame **xdp, u32 flags)
>> +{
>> +	struct tsnep_adapter *adapter = netdev_priv(dev);
>> +	int cpu = smp_processor_id();
> 
> Can be u32.

u32 will be used.

>> +	struct netdev_queue *nq;
>> +	int nxmit;
>> +	int queue;
> 
> Squash?

Squashed.

Gerhard
