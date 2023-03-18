Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8238F6BFBEC
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 18:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjCRRiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 13:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCRRiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 13:38:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC7733CD0
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 10:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=VehXpTkm/M2N2JhTCA0KxiUK3yeM841TtONwbcaJ/VM=; b=oxPdLzY12gNkKiE70An0SNiwt3
        H3eHLkVPdLy8uMiYknH8QiZ4BfFZM1r9nSXls+3mQFTvy3xPYgKaThRlA6gyoqecdCFQaUT35tHSY
        hnj4Nzwmg/9NdWYFGF+ZAtjGed++jYqzAvZtxYTYNg6H3cvWw8iiykdRpkVZAOddJqob9nyg+nShb
        WgjS2+uiqoAWYAhjhCqbyjx+/prCuz4uxefB+iplAeDPdrbP7vfDkO2y1YUSuBZPq756CtV5aHBuB
        YInuIJI+qco+BDldtjW4BMOpD5BoWfi33/JUfC7dUifh2dCa56jdvy00Q9HFn79MjwREId8MEuHEE
        KtsV4Tyg==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pdaUv-00H0VB-UE; Sat, 18 Mar 2023 17:37:42 +0000
Message-ID: <af46a70b-e028-d2e6-109b-2f46a18ed4a0@infradead.org>
Date:   Sat, 18 Mar 2023 10:37:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v8 2/2] net/ps3_gelic_net: Use dma_mapping_error
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <cover.1678570942.git.geoff@infradead.org>
 <642c56a7da025406c36862464f5a15aba3e5340e.1678570942.git.geoff@infradead.org>
 <a1deb614e9583ea82be932f34c82a2d922d148e3.camel@gmail.com>
Content-Language: en-US
In-Reply-To: <a1deb614e9583ea82be932f34c82a2d922d148e3.camel@gmail.com>
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

On 3/11/23 14:41, Alexander H Duyck wrote:
> On Sat, 2023-03-11 at 21:46 +0000, Geoff Levand wrote:
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
>>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 24 +++++++++++---------
>>  1 file changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> index 56557fc8d18a..87d3c768286e 100644
>> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> @@ -325,15 +325,17 @@ static int gelic_card_init_chain(struct gelic_card *card,
>>  
>>  	/* set up the hardware pointers in each descriptor */
>>  	for (i = 0; i < no; i++, descr++) {
>> +		dma_addr_t cpu_addr;
>> +
>>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>> -		descr->bus_addr =
>> -			dma_map_single(ctodev(card), descr,
>> -				       GELIC_DESCR_SIZE,
>> -				       DMA_BIDIRECTIONAL);
>>  
>> -		if (!descr->bus_addr)
>> +		cpu_addr = dma_map_single(ctodev(card), descr,
>> +					  GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
>> +
>> +		if (dma_mapping_error(ctodev(card), cpu_addr))
>>  			goto iommu_error;
>>  
>> +		descr->bus_addr = cpu_to_be32(cpu_addr);
>>  		descr->next = descr + 1;
>>  		descr->prev = descr - 1;
>>  	}
>> @@ -377,6 +379,7 @@ static int gelic_card_init_chain(struct gelic_card *card,
>>  static int gelic_descr_prepare_rx(struct gelic_card *card,
>>  				  struct gelic_descr *descr)
>>  {
>> +	dma_addr_t cpu_addr;
>>  	int offset;
>>  
>>  	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
>> @@ -398,11 +401,10 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
>>  	if (offset)
>>  		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
>>  	/* io-mmu-map the skb */
>> -	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
>> -						     descr->skb->data,
>> -						     gelic_rx_skb_size,
>> -						     DMA_FROM_DEVICE));
>> -	if (!descr->buf_addr) {
>> +	cpu_addr = dma_map_single(ctodev(card), descr->skb->data,
>> +				  gelic_rx_skb_size, DMA_FROM_DEVICE);
>> +	descr->buf_addr = cpu_to_be32(cpu_addr);
>> +	if (dma_mapping_error(ctodev(card), cpu_addr)) {
>>  		dev_kfree_skb_any(descr->skb);
>>  		descr->skb = NULL;
>>  		dev_info(ctodev(card),
>> @@ -782,7 +784,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
>>  
>>  	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
>>  
>> -	if (!buf) {
>> +	if (dma_mapping_error(ctodev(card), buf)) {
>>  		dev_err(ctodev(card),
>>  			"dma map 2 failed (%p, %i). Dropping packet\n",
>>  			skb->data, skb->len);
> 
> Looks good to me. The only tweak I would make is maybe using "dma_addr"
> , "phys_addr" or "bus_addr" instead of "cpu_addr", however that is more
> cosmetic than anything else.

Well, cpu_addr is used for cpu_to_be32(cpu_addr)...

> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Thanks for the review.

-Geoff


