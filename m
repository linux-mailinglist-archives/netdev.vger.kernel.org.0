Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AAE6478AC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 23:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiLHWM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 17:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiLHWMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 17:12:20 -0500
Received: from mx18lb.world4you.com (mx18lb.world4you.com [81.19.149.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7A679C0E;
        Thu,  8 Dec 2022 14:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=z7hlu+o9nBCU9kCxPQROnnbW9gdJlhNarIKiE0m/OO0=; b=fUrCMaTXRrofnBSvsUVUkT8gmc
        d/y3dwEXLhpWh8y9c4WGnoHTu/d8Ti+UhI4vD4zEGc7GvgxOaNQX6yJzbC5YyLJdRDkBB2zAbz5vd
        5COGbRaYKre37bhdUu90SV0eT5l9NztM2mzOTwmmG0Jx8UL7nIrPhCGBaWo1jO06A9fE=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx18lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p3P7n-0002qR-Ar; Thu, 08 Dec 2022 23:12:15 +0100
Message-ID: <24e5f99e-9785-9792-970c-25b4ea70710d@engleder-embedded.com>
Date:   Thu, 8 Dec 2022 23:12:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 6/6] tsnep: Add XDP RX support
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-7-gerhard@engleder-embedded.com>
 <Y5HpWf8XMcCj2k7V@boxer>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <Y5HpWf8XMcCj2k7V@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.12.22 14:40, Maciej Fijalkowski wrote:
>> +static unsigned int tsnep_rx_offset_xdp(void)
>> +{
>> +	return XDP_PACKET_HEADROOM;
>> +}
> 
> I don't see much of a value in this func :P

It is a variant of tsnep_rx_offset() for the XDP path to prevent
unneeded calls of tsnep_xdp_is_enabled(). With this function I
keep the RX offset local. But yes, it provides actually no
functionality.

>> +
>>   static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>>   {
>>   	struct device *dmadev = rx->adapter->dmadev;
>> @@ -997,6 +1033,67 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
>>   	return i;
>>   }
>>   
>> +static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
>> +			       struct xdp_buff *xdp, int *status)
>> +{
>> +	unsigned int length;
>> +	unsigned int sync;
>> +	u32 act;
>> +
>> +	length = xdp->data_end - xdp->data_hard_start - tsnep_rx_offset_xdp();
> 
> could this be xdp->data_end - xdp->data - TSNEP_RX_INLINE_METADATA_SIZE ?

xdp->data points to the start of the Ethernet frame after
TSNEP_RX_INLINE_METADATA_SIZE, so it would be wrong to substract the
metadata which is not there.
Actually xdp->data_end - xdp->data + TSNEP_RX_INLINE_METADATA_SIZE would
be equivalent

TSNEP_RX_INLINE_METADATA_SIZE contains timestamps of received frames. It
is written by DMA at the beginning of the RX buffer. So it extends the
DMA length and needs to be considered for DMA sync.

> Can you tell a bit more about that metadata macro that you have to handle
> by yourself all the time? would be good to tell about the impact on
> data_meta since you're not configuring it on xdp_prepare_buff().

I will add comments.

>> +
>> +	act = bpf_prog_run_xdp(prog, xdp);
>> +
>> +	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
>> +	sync = xdp->data_end - xdp->data_hard_start - tsnep_rx_offset_xdp();
>> +	sync = max(sync, length);
>> +
>> +	switch (act) {
>> +	case XDP_PASS:
>> +		return false;
>> +	case XDP_TX:
>> +		if (tsnep_xdp_xmit_back(rx->adapter, xdp) < 0)
>> +			goto out_failure;
>> +		*status |= TSNEP_XDP_TX;
>> +		return true;
>> +	case XDP_REDIRECT:
>> +		if (xdp_do_redirect(rx->adapter->netdev, xdp, prog) < 0)
>> +			goto out_failure;
>> +		*status |= TSNEP_XDP_REDIRECT;
>> +		return true;
>> +	default:
>> +		bpf_warn_invalid_xdp_action(rx->adapter->netdev, prog, act);
>> +		fallthrough;
>> +	case XDP_ABORTED:
>> +out_failure:
>> +		trace_xdp_exception(rx->adapter->netdev, prog, act);
>> +		fallthrough;
>> +	case XDP_DROP:
>> +		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
>> +				   sync, true);
>> +		return true;
>> +	}
>> +}
>> +
>> +static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status)
>> +{
>> +	int cpu = smp_processor_id();
>> +	int queue;
>> +	struct netdev_queue *nq;
> 
> do you care about RCT, or?

Do you mean Redundancy Control Trailer (RCT) of PRP? This is new to me.
Do I have to take care about it in the driver? There are no plans to use
redundancy protocols with this device so far.

>> +
>> +	if (status & TSNEP_XDP_TX) {
>> +		queue = cpu % adapter->num_tx_queues;
>> +		nq = netdev_get_tx_queue(adapter->netdev, queue);
>> +
>> +		__netif_tx_lock(nq, cpu);
>> +		tsnep_xdp_xmit_flush(&adapter->tx[queue]);
>> +		__netif_tx_unlock(nq);
>> +	}
>> +
>> +	if (status & TSNEP_XDP_REDIRECT)
>> +		xdp_do_flush();
>> +}
>> +finalize_xdp
>>   static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
>>   				       int length)
> 
> did you consider making tsnep_build_skb() to work on xdp_buff directly?
> probably will help you once you'll implement XDP mbuf support here.

I saw it in other drivers. I did not consider it, because in my opinion
there was no advantage for this driver. Currently xdp_buff is only
initialized on demand if BPF program is there. So for me there was no
reason to change tsnep_build_skb().

>>   {
>> @@ -1035,12 +1132,16 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>>   	int desc_available;
>>   	int done = 0;
>>   	enum dma_data_direction dma_dir;
>> +	struct bpf_prog *prog;
>>   	struct tsnep_rx_entry *entry;
>> +	struct xdp_buff xdp;
>> +	int xdp_status = 0;
>>   	struct sk_buff *skb;
>>   	int length;
>>   
>>   	desc_available = tsnep_rx_desc_available(rx);
>>   	dma_dir = page_pool_get_dma_dir(rx->page_pool);
>> +	prog = READ_ONCE(rx->adapter->xdp_prog);
>>   
>>   	while (likely(done < budget) && (rx->read != rx->write)) {
>>   		entry = &rx->entry[rx->read];
>> @@ -1084,6 +1185,28 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>>   		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
>>   		desc_available++;
>>   
>> +		if (prog) {
>> +			bool consume;
>> +
>> +			xdp_init_buff(&xdp, PAGE_SIZE, &rx->xdp_rxq);
>> +			xdp_prepare_buff(&xdp, page_address(entry->page),
>> +					 tsnep_rx_offset_xdp() + TSNEP_RX_INLINE_METADATA_SIZE,
>> +					 length - TSNEP_RX_INLINE_METADATA_SIZE,
> 
> Would it make sense to subtract TSNEP_RX_INLINE_METADATA_SIZE from length
> right after dma_sync_single_range_for_cpu?

Yes, this could make the code simpler and more readable. I will try it.

Thanks for the review!

Gerhard
