Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD086A2CCA
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 01:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBZAQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 19:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBZAQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 19:16:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE33F16322
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 16:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=f5sZmW9CTNoMaZuZiOjLg2bU1Ow5oLTF6hPMSdLKgLw=; b=UO/4OLrAe4+oz21QwmmTEShDWm
        PRafUYf0FkfPSTe8mLeEMufEyw3ufKgclmGm9I0ZNu3MKI/ko8Q6xOvC5x2G3+7v5wI0qlZORZ6i6
        81m86PdU0zPdRbtrrjGaa4y5cBocZrfwvE8J8oSWz/nl7Sy3YV5IQw+C4m0P8simwRA4FqP5KfEPc
        XDmbVBbH6kEzV1yN9DZBfq/EFIf0eLzDRgBSJ8yGG5WkFjE+mWhCFC+Mof5f0vuRGdR06FPMVMy/z
        vEFS7+v1jpIQOiDg/wSj/U3O3pXTSGDtjGC6Njb3Q+8QIvT4m2mgSSTxJzRuKAyT6k76gg5nk3alL
        5dsxwjaw==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pW4iM-00GUJb-IN; Sun, 26 Feb 2023 00:16:31 +0000
Message-ID: <f67df256-f503-66bc-2cda-3eee907f11d8@infradead.org>
Date:   Sat, 25 Feb 2023 16:16:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v5 2/2] net/ps3_gelic_net: Use dma_mapping_error
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>
References: <cover.1676221818.git.geoff@infradead.org>
 <ea17b44b48e4dad6c97e3f1e61266fcf9f0ad2d5.1676221818.git.geoff@infradead.org>
 <d9cca450f83f03e257e3bacc6946356c691d2412.camel@redhat.com>
Content-Language: en-US
In-Reply-To: <d9cca450f83f03e257e3bacc6946356c691d2412.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/14/23 02:58, Paolo Abeni wrote:
> +Alex
> On Sun, 2023-02-12 at 18:00 +0000, Geoff Levand wrote:
>> The current Gelic Etherenet driver was checking the return value of its
>> dma_map_single call, and not using the dma_mapping_error() routine.
>>
>> Fixes runtime problems like these:
>>
>>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
>>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc
>>
>> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
> 
> Please use the correct format for the above tag.
> 
>> Signed-off-by: Geoff Levand <geoff@infradead.org>
>> ---
>>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 41 ++++++++++----------
>>  1 file changed, 20 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> index 2bb68e60d0d5..0e52bb99e344 100644
>> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> @@ -309,22 +309,30 @@ static int gelic_card_init_chain(struct gelic_card *card,
>>  				 struct gelic_descr_chain *chain,
>>  				 struct gelic_descr *start_descr, int no)
>>  {
>> -	int i;
>> +	struct device *dev = ctodev(card);
>>  	struct gelic_descr *descr;
>> +	int i;
>>  
>> -	descr = start_descr;
>> -	memset(descr, 0, sizeof(*descr) * no);
>> +	memset(start_descr, 0, no * sizeof(*start_descr));
>>  
>>  	/* set up the hardware pointers in each descriptor */
>> -	for (i = 0; i < no; i++, descr++) {
>> +	for (i = 0, descr = start_descr; i < no; i++, descr++) {
>>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>>  		descr->bus_addr =
>>  			dma_map_single(ctodev(card), descr,
>>  				       GELIC_DESCR_SIZE,
>>  				       DMA_BIDIRECTIONAL);
>>  
>> -		if (!descr->bus_addr)
>> -			goto iommu_error;
>> +		if (unlikely(dma_mapping_error(dev, descr->bus_addr))) {
> 
> Not a big issue, but I think the existing goto is preferable to the
> following indentation

In a latter patch I put the common cleanup code into a separate static
routine and call that here.
 
>> +			dev_err(dev, "%s:%d: dma_mapping_error\n", __func__,
>> +				__LINE__);
>> +
>> +			for (i--, descr--; i >= 0; i--, descr--) {
> 
> Again not a big deal, but I think the construct suggested by Alex in
> the previous patch is more clear.

Well, I like this better...

>> +				dma_unmap_single(ctodev(card), descr->bus_addr,
>> +					GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
>> +			}
>> +			return -ENOMEM;
>> +		}
>>  
>>  		descr->next = descr + 1;
>>  		descr->prev = descr - 1;
>> @@ -346,14 +354,6 @@ static int gelic_card_init_chain(struct gelic_card *card,
>>  	(descr - 1)->next_descr_addr = 0;
>>  
>>  	return 0;
>> -
>> -iommu_error:
>> -	for (i--, descr--; 0 <= i; i--, descr--)
>> -		if (descr->bus_addr)
>> -			dma_unmap_single(ctodev(card), descr->bus_addr,
>> -					 GELIC_DESCR_SIZE,
>> -					 DMA_BIDIRECTIONAL);
>> -	return -ENOMEM;
>>  }
>>  
>>  /**
>> @@ -408,13 +408,12 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
>>  	descr->buf_addr = dma_map_single(dev, descr->skb->data, descr->buf_size,
>>  		DMA_FROM_DEVICE);
>>  
>> -	if (!descr->buf_addr) {
>> +	if (unlikely(dma_mapping_error(dev, descr->buf_addr))) {
>> +		dev_err(dev, "%s:%d: dma_mapping_error\n", __func__, __LINE__);
>>  		dev_kfree_skb_any(descr->skb);
>>  		descr->buf_addr = 0;
>>  		descr->buf_size = 0;
>>  		descr->skb = NULL;
>> -		dev_info(dev,
>> -			 "%s:Could not iommu-map rx buffer\n", __func__);
> 
> You touched the above line in the previous patch. Since it does lot
> look functional-related to the fix here you can as well drop the
> message in the previous patch.

Sure, I'll consider it.

Thanks for the review.

-Geoff

