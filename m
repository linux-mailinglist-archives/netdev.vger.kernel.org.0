Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647486B6111
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 22:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCKVlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 16:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCKVlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 16:41:39 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5F85B42D
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 13:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=JaSrGrstFOWhNc9EHHd8CkmnbURhPaMrH3vpBtNOWfM=; b=Ge6b2XCv3nPUxliXC964tCgAB0
        Hra1zzgmk5AXbeCjh6PMCMmDy1NS4HM9HR7iCHjOk4XkWHOz1VYLXDejC9FH48b4CHZyeZHvTxqNi
        J18fjgYarjAWPZ9T8TK33VFPpi6AE7BHdNo+cZkBW5/P4jI2+f96QVWijBeFW1XBTkpGFUWkrQr9T
        Ermgz/pFnkP3dG4I7t5MqaNDxAZ9PQqdrc5f80Pm21riOh/aWEmMZdS7137qKjnbyycV7lfX54VxR
        TWxGu7GOYKXmGA4DdLPjUimcJfY4DlF1Fqf2EMmL3FL2v8EDzAQOb26BVkP3ds8nhH86MDZjZ0BtS
        1+hEvJyw==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pb6xi-000p8M-1u;
        Sat, 11 Mar 2023 21:41:13 +0000
Message-ID: <e95db274-f7b4-8f38-2f63-49044a6c478c@infradead.org>
Date:   Sat, 11 Mar 2023 13:41:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v7 2/2] net/ps3_gelic_net: Use dma_mapping_error
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <cover.1677981671.git.geoff@infradead.org>
 <45545484eadcf15a3ef06e35ccf34981cda2e867.1677981671.git.geoff@infradead.org>
 <116190ee91ddb97e4498dcb6e58548c5332aaf54.camel@gmail.com>
Content-Language: en-US
In-Reply-To: <116190ee91ddb97e4498dcb6e58548c5332aaf54.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/6/23 08:01, Alexander H Duyck wrote:
> On Sun, 2023-03-05 at 02:08 +0000, Geoff Levand wrote:
>> The current Gelic Etherenet driver was checking the return value of its
>> dma_map_single call, and not using the dma_mapping_error() routine.
>>
>> Fixes runtime problems like these:
>>
>>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
>>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc
>>
>> Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
>> Signed-off-by: Geoff Levand <geoff@infradead.org>
>> ---
>>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> index b0ebe0e603b4..40261947e0ea 100644
>> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> @@ -323,7 +323,7 @@ static int gelic_card_init_chain(struct gelic_card *card,
>>  				       GELIC_DESCR_SIZE,
>>  				       DMA_BIDIRECTIONAL);
>>  
>> -		if (!descr->bus_addr)
>> +		if (dma_mapping_error(ctodev(card), descr->bus_addr))
>>  			goto iommu_error;
>>  
>>  		descr->next = descr + 1;
> 
> The bus_addr value is __be32 and the dma_mapping_error should be CPU
> ordered. I think there was a byteswap using cpu_to_be32 missing here.
> In addition you will probably need to have an intermediate variable to
> store it in to test the DMA address before you byte swap it and store
> it in the descriptor.

I added a local variable 'cpu_addr' as you recommend.

>> @@ -401,7 +401,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
>>  						     descr->skb->data,
>>  						     GELIC_NET_MAX_FRAME,
>>  						     DMA_FROM_DEVICE));
>> -	if (!descr->buf_addr) {
>> +	if (dma_mapping_error(ctodev(card), descr->buf_addr)) {
>>  		dev_kfree_skb_any(descr->skb);
>>  		descr->skb = NULL;
>>  		dev_info(ctodev(card),
> 
> This is happening AFTER the DMA is passed through a cpu_to_be32 right?
> The test should be on the raw value, not the byteswapped value.

Did the same here.

>> @@ -781,7 +781,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
>>  
>>  	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
>>  
>> -	if (!buf) {
>> +	if (dma_mapping_error(ctodev(card), buf)) {
>>  		dev_err(ctodev(card),
>>  			"dma map 2 failed (%p, %i). Dropping packet\n",
>>  			skb->data, skb->len);
> 
> This one is correct from what I can tell. I would recommend using it as
> a template and applying it to the two above so that you can sort out
> the byte ordering issues and perform the test and the CPU ordered DMA
> variable.

Thanks for the review.

-Geoff
