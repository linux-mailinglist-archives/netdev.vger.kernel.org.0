Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B420E65F78B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 00:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbjAEXWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 18:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbjAEXWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 18:22:41 -0500
Received: from mx04lb.world4you.com (mx04lb.world4you.com [81.19.149.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9018A69513
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 15:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WJaMWSa4X7X7uRKG/j7MwgwxtRKhJgCU9vILHDTbRzs=; b=uKYe6ghhQV/AkLCWRKA7u1ZJ+L
        q16pBPvsE3pHxQi6DE8+SoZ0FWn7jxmiatml48Fx34IRcpNhL7MT1Rf7YhOQPcE66ZqC5Tr2KrmKZ
        DLoc3Mi6HjuJgUF38lQEMemQl7nW15lIjbg9Clr8ZW+e3+nJdOQj0gelP5ltp+ipLsfY=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx04lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pDZZA-0008Mm-MQ; Fri, 06 Jan 2023 00:22:32 +0100
Message-ID: <6d625989-5be4-a780-b4a4-c53e6f219ee8@engleder-embedded.com>
Date:   Fri, 6 Jan 2023 00:22:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 9/9] tsnep: Add XDP RX support
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-10-gerhard@engleder-embedded.com>
 <b148f80c-fa9a-a663-a723-b8f58de29a24@intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <b148f80c-fa9a-a663-a723-b8f58de29a24@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.01.23 18:52, Alexander Lobakin wrote:
> From: Gerhard Engleder <gerhard@engleder-embedded.com>
> Date: Wed Jan 04 2023 20:41:32 GMT+0100
> 
>> If BPF program is set up, then run BPF program for every received frame
>> and execute the selected action.
>>
>> Test results with A53 1.2GHz:
>>
>> XDP_DROP (samples/bpf/xdp1)
>> proto 17:     883878 pkt/s
>>
>> XDP_TX (samples/bpf/xdp2)
>> proto 17:     255693 pkt/s
>>
>> XDP_REDIRECT (samples/bpf/xdpsock)
>>   sock0@eth2:0 rxdrop xdp-drv
>>                     pps            pkts           1.00
>> rx                 855,582        5,404,523
>> tx                 0              0
>>
>> XDP_REDIRECT (samples/bpf/xdp_redirect)
>> eth2->eth1         613,267 rx/s   0 err,drop/s   613,272 xmit/s
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep_main.c | 129 ++++++++++++++++++++-
>>   1 file changed, 127 insertions(+), 2 deletions(-)
> 
> [...]
> 
>> @@ -624,6 +628,34 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
>>   	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
>>   }
>>   
>> +static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
>> +				struct xdp_buff *xdp)
>> +{
>> +	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
>> +	int cpu = smp_processor_id();
>> +	struct netdev_queue *nq;
>> +	int queue;
> 
> Squash with @cpu above (or make @cpu u32)?

Will change to u32.

>> +	bool xmit;
>> +
>> +	if (unlikely(!xdpf))
>> +		return -EFAULT;
>> +
>> +	queue = cpu % adapter->num_tx_queues;
>> +	nq = netdev_get_tx_queue(adapter->netdev, queue);
>> +
>> +	__netif_tx_lock(nq, cpu);
> 
> [...]
> 
>> @@ -788,6 +820,11 @@ static unsigned int tsnep_rx_offset(struct tsnep_rx *rx)
>>   	return TSNEP_SKB_PAD;
>>   }
>>   
>> +static unsigned int tsnep_rx_offset_xdp(void)
>> +{
>> +	return XDP_PACKET_HEADROOM;
>> +}
> 
> The reason for creating a function to always return a constant?

It is a variant of tsnep_rx_offset() for the XDP path to prevent
unneeded calls of tsnep_xdp_is_enabled(). With this function I
keep the RX offset local. But yes, it provides actually no
functionality. I will add a comment.

What about always using XDP_PACKET_HEADROOM as offset in the RX buffer?
NET_IP_ALIGN would not be considered then, but it is zero anyway on
the main platforms x86 and arm64. This would simplify the code.

>> +
>>   static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>>   {
>>   	struct device *dmadev = rx->adapter->dmadev;
> 
> [...]
> 
>> +static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status)
>> +{
>> +	int cpu = smp_processor_id();
>> +	struct netdev_queue *nq;
>> +	int queue;
> 
> (same re squashing)

u32.

>> +
>> +	if (status & TSNEP_XDP_TX) {
>> +		queue = cpu % adapter->num_tx_queues;
>> +		nq = netdev_get_tx_queue(adapter->netdev, queue);
>> +
>> +		__netif_tx_lock(nq, cpu);
>> +		tsnep_xdp_xmit_flush(&adapter->tx[queue]);
>> +		__netif_tx_unlock(nq);
>> +	}
> 
> This can be optimized. Given that one NAPI cycle is always being run on
> one CPU, you can get both @queue and @nq once at the beginning of a
> polling cycle and then pass it to perform %XDP_TX and this flush.
> Alternatively, if you don't want to do that not knowing in advance if
> you'll need it at all during the cycle, you can obtain them at the first
> tsnep_xdp_xmit_back() invocation.

I will give it a try.

>> +
>> +	if (status & TSNEP_XDP_REDIRECT)
>> +		xdp_do_flush();
>> +}
>> +
>>   static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
>>   				       int length)
>>   {
> 
> [...]
> 
>> @@ -1087,6 +1189,26 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>>   		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
>>   		desc_available++;
>>   
>> +		if (prog) {
>> +			bool consume;
>> +
>> +			xdp_init_buff(&xdp, PAGE_SIZE, &rx->xdp_rxq);
> 
> xdp_init_buff() is designed to be called once per NAPI cycle, at the
> beginning. You don't need to reinit it given that the values you pass
> are always the same.

Will be done.

Thanks for the review!

Gerhard
