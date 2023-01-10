Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF46664DF8
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjAJVWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjAJVVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:21:45 -0500
Received: from mx24lb.world4you.com (mx24lb.world4you.com [81.19.149.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B4EFD3F
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9rgRS8q/rFm1bbCd3zZoXKukl4zp4OrDO97QrGbaBU0=; b=YgiWXxDbOoKN0tO9jmgSC8sboS
        F5LBndVXaGol/Tg23pJjJiVgpi1LzoxFKfC8kmSqA+dFN/vNAd/YZqjcPTCWuhkEOp2GYQAM+bPDJ
        cUcHyWe1w6h7nDnVXKIkoeiP0zFepnXffxIVmfbAonUs9vqbtx9afQSaxKJ84a/oEHPo=;
Received: from [88.117.53.243] (helo=[10.0.0.160])
        by mx24lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pFM3y-0007DG-JG; Tue, 10 Jan 2023 22:21:42 +0100
Message-ID: <d2c69906-4686-c2e1-0102-a73a2d9ca061@engleder-embedded.com>
Date:   Tue, 10 Jan 2023 22:21:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4 08/10] tsnep: Add RX queue info for XDP
 support
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Saeed Mahameed <saeed@kernel.org>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-9-gerhard@engleder-embedded.com>
 <464fd490273bf0df9f0725a69aa1c890705d0513.camel@gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <464fd490273bf0df9f0725a69aa1c890705d0513.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.23 18:29, Alexander H Duyck wrote:
> On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
>> Register xdp_rxq_info with page_pool memory model. This is needed for
>> XDP buffer handling.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
>> ---
>>   drivers/net/ethernet/engleder/tsnep.h      |  2 ++
>>   drivers/net/ethernet/engleder/tsnep_main.c | 39 ++++++++++++++++------
>>   2 files changed, 31 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
>> index 855738d31d73..2268ff793edf 100644
>> --- a/drivers/net/ethernet/engleder/tsnep.h
>> +++ b/drivers/net/ethernet/engleder/tsnep.h
>> @@ -134,6 +134,8 @@ struct tsnep_rx {
>>   	u32 dropped;
>>   	u32 multicast;
>>   	u32 alloc_failed;
>> +
>> +	struct xdp_rxq_info xdp_rxq;
>>   };
>>   
> 
> Rather than placing it in your Rx queue structure it might be better to
> look at placing it in the tsnep_queue struct. The fact is this is more
> closely associated with the napi struct then your Rx ring so changing
> it to that might make more sense as you can avoid a bunch of extra
> overhead with having to pull napi to it.
> 
> Basically what it comes down it is that it is much easier to access
> queue[i].rx than it is for the rx to get access to queue[i].napi.

I will try it as suggested.

>>   struct tsnep_queue {
>> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
>> index 0c9669edb2dd..451ad1849b9d 100644
>> --- a/drivers/net/ethernet/engleder/tsnep_main.c
>> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
>> @@ -792,6 +792,9 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>>   		entry->page = NULL;
>>   	}
>>   
>> +	if (xdp_rxq_info_is_reg(&rx->xdp_rxq))
>> +		xdp_rxq_info_unreg(&rx->xdp_rxq);
>> +
>>   	if (rx->page_pool)
>>   		page_pool_destroy(rx->page_pool);
>>   
>> @@ -807,7 +810,7 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>>   	}
>>   }
>>   
>> -static int tsnep_rx_ring_init(struct tsnep_rx *rx)
>> +static int tsnep_rx_ring_init(struct tsnep_rx *rx, unsigned int napi_id)
>>   {
>>   	struct device *dmadev = rx->adapter->dmadev;
>>   	struct tsnep_rx_entry *entry;
>> @@ -850,6 +853,15 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
>>   		goto failed;
>>   	}
>>   
>> +	retval = xdp_rxq_info_reg(&rx->xdp_rxq, rx->adapter->netdev,
>> +				  rx->queue_index, napi_id);
>> +	if (retval)
>> +		goto failed;
>> +	retval = xdp_rxq_info_reg_mem_model(&rx->xdp_rxq, MEM_TYPE_PAGE_POOL,
>> +					    rx->page_pool);
>> +	if (retval)
>> +		goto failed;
>> +
>>   	for (i = 0; i < TSNEP_RING_SIZE; i++) {
>>   		entry = &rx->entry[i];
>>   		next_entry = &rx->entry[(i + 1) % TSNEP_RING_SIZE];
>> @@ -1104,7 +1116,8 @@ static bool tsnep_rx_pending(struct tsnep_rx *rx)
>>   }
>>   
>>   static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
>> -			 int queue_index, struct tsnep_rx *rx)
>> +			 unsigned int napi_id, int queue_index,
>> +			 struct tsnep_rx *rx)
>>   {
>>   	dma_addr_t dma;
>>   	int retval;
>> @@ -1118,7 +1131,7 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
>>   	else
>>   		rx->offset = TSNEP_SKB_PAD;
>>   
>> -	retval = tsnep_rx_ring_init(rx);
>> +	retval = tsnep_rx_ring_init(rx, napi_id);
>>   	if (retval)
>>   		return retval;
>>   
>> @@ -1245,14 +1258,19 @@ static void tsnep_free_irq(struct tsnep_queue *queue, bool first)
>>   static int tsnep_netdev_open(struct net_device *netdev)
>>   {
>>   	struct tsnep_adapter *adapter = netdev_priv(netdev);
>> -	int i;
>> -	void __iomem *addr;
>>   	int tx_queue_index = 0;
>>   	int rx_queue_index = 0;
>> -	int retval;
>> +	unsigned int napi_id;
>> +	void __iomem *addr;
>> +	int i, retval;
>>   
>>   	for (i = 0; i < adapter->num_queues; i++) {
>>   		adapter->queue[i].adapter = adapter;
>> +
>> +		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
>> +			       tsnep_poll);
>> +		napi_id = adapter->queue[i].napi.napi_id;
>> +
> 
> This is a good example of what I am referring to.
> 
>>   		if (adapter->queue[i].tx) {
>>   			addr = adapter->addr + TSNEP_QUEUE(tx_queue_index);
>>   			retval = tsnep_tx_open(adapter, addr, tx_queue_index,
>> @@ -1263,7 +1281,7 @@ static int tsnep_netdev_open(struct net_device *netdev)
>>   		}
>>   		if (adapter->queue[i].rx) {
>>   			addr = adapter->addr + TSNEP_QUEUE(rx_queue_index);
>> -			retval = tsnep_rx_open(adapter, addr,
>> +			retval = tsnep_rx_open(adapter, addr, napi_id,
>>   					       rx_queue_index,
>>   					       adapter->queue[i].rx);
>>   			if (retval)
>> @@ -1295,8 +1313,6 @@ static int tsnep_netdev_open(struct net_device *netdev)
>>   		goto phy_failed;
>>   
>>   	for (i = 0; i < adapter->num_queues; i++) {
>> -		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
>> -			       tsnep_poll);
>>   		napi_enable(&adapter->queue[i].napi);
>>   
>>   		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
> 
> What you could do here is look at making all the napi_add/napi_enable
> and xdp_rxq_info items into one function to handle all the enabling.

I will rework that.

>> @@ -1317,6 +1333,8 @@ static int tsnep_netdev_open(struct net_device *netdev)
>>   			tsnep_rx_close(adapter->queue[i].rx);
>>   		if (adapter->queue[i].tx)
>>   			tsnep_tx_close(adapter->queue[i].tx);
>> +
>> +		netif_napi_del(&adapter->queue[i].napi);
>>   	}
>>   	return retval;
>>   }
>> @@ -1335,7 +1353,6 @@ static int tsnep_netdev_close(struct net_device *netdev)
>>   		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
>>   
>>   		napi_disable(&adapter->queue[i].napi);
>> -		netif_napi_del(&adapter->queue[i].napi);
>>   
>>   		tsnep_free_irq(&adapter->queue[i], i == 0);
>>   
> 
> Likewise here you could take care of all the same items with the page
> pool being freed after you have already unregistered and freed the napi
> instance.

I'm not sure if I understand it right. According to your suggestion
above napi and xdp_rxq_info should be freed here?

Gerhard
