Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DD56938FC
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 18:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBLRGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 12:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjBLRGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 12:06:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13A61027A
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 09:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:References:To:Subject:From:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=Oed/F5Kza827R6qIh5Sawh5mlN677+AOoCzpdKVQNbo=; b=ZS3e3b7OIL4z+/ybEzJeEB0clD
        AATg6kcrZkxZF09BPTM3DDgARHRSinhTM0YzzP5DiOjaZB4gdTSX2cbn+bsdxgO2KhFykFms6OKqc
        1CYsNUzN5G2C1jijkUkcGVy5Uq+/UEMnBucd8lLuW0cD8nQUFJN4br0kIoXAs08gd8OUou2p7s1mF
        Mx9c9sEpRWImBTTlATtDVWz6zWsJZ5TamHHPoZhwZfKO1Fgshjne5zOBjRF+yXrFnnzQlFPZ/Zjts
        NRsPH7PWvuiF71Hci/IWbFYL4EQoss9TfOIyUs83q7RxlA1qZVbV4IE2+jKzCiPAMifC5K7VFYPI9
        Xnreke4Q==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRFo9-0050Eq-Kp; Sun, 12 Feb 2023 17:06:34 +0000
Message-ID: <4ef437ef-37ef-6d3e-fd7e-d2456069f42b@infradead.org>
Date:   Sun, 12 Feb 2023 09:06:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v4 2/2] net/ps3_gelic_net: Use dma_mapping_error
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <cover.1675632296.git.geoff@infradead.org>
 <8d40259f863ed1a077687f3c3d5b8b3707478170.1675632296.git.geoff@infradead.org>
 <79eb8baa3f2d96d47ab3e4d4c4c6bdc8bacfa207.camel@gmail.com>
Content-Language: en-US
In-Reply-To: <79eb8baa3f2d96d47ab3e4d4c4c6bdc8bacfa207.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

On 2/6/23 08:37, Alexander H Duyck wrote:
> On Sun, 2023-02-05 at 22:10 +0000, Geoff Levand wrote:
>> The current Gelic Etherenet driver was checking the return value of its
>> dma_map_single call, and not using the dma_mapping_error() routine.
>>
>> Fixes runtime problems like these:
>>
>>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
>>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc
>>
>> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
>> Signed-off-by: Geoff Levand <geoff@infradead.org>
>> ---
>>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 52 ++++++++++----------
>>  1 file changed, 27 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> index 7a8b5e1e77a6..5622b512e2e4 100644
>> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> @@ -309,22 +309,34 @@ static int gelic_card_init_chain(struct gelic_card *card,
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
> 
> Are bus_addr and the CPU the same byte ordering? Just wondering since
> this is being passed raw. I would have expected it to go through a
> cpu_to_be32.

As I mentioned in my reply to the first patch, the PS3's CPU is
big endian, so we really don't need any of the endian conversions.

>> -		if (!descr->bus_addr)
>> -			goto iommu_error;
>> +		if (unlikely(dma_mapping_error(dev, descr->bus_addr))) {
> 
> The expectation for dma_mapping_error is that the address is in cpu
> order. So in this case it is partially correct since bus_addr wasn't
> byte swapped, but generally the dma address used should be a CPU byte
> ordered variable.
> 
>> +			dev_err(dev, "%s:%d: dma_mapping_error\n", __func__,
>> +				__LINE__);
>> +
>> +			for (i--, descr--; i > 0; i--, descr--) {
>> +				if (descr->bus_addr) {
> 
> So I am pretty sure this is broken. Usually for something like this I
> will resort to just doing a while (i--) as "i == 0" should be a valid
> buffer to have to unmap.
> 
> Maybe something like:
> 			while (i--) {
> 				descr--;
> 
> Also I think you can get rid of the if since descr->bus_addr should be
> valid for all values since you populated it just a few lines above for
> each value of i.

OK, I'll change that.
>> +					dma_unmap_single(ctodev(card),
>> +						descr->bus_addr,
>> +						GELIC_DESCR_SIZE,
>> +						DMA_BIDIRECTIONAL);
>> +				}
>> +			}
>> +			return -ENOMEM;
>> +		}
>>  
>>  		descr->next = descr + 1;
>>  		descr->prev = descr - 1;
>> @@ -334,8 +346,7 @@ static int gelic_card_init_chain(struct gelic_card *card,
>>  	start_descr->prev = (descr - 1);
>>  
>>  	/* chain bus addr of hw descriptor */
>> -	descr = start_descr;
>> -	for (i = 0; i < no; i++, descr++) {
>> +	for (i = 0, descr = start_descr; i < no; i++, descr++) {
>>  		descr->next_descr_addr = cpu_to_be32(descr->next->bus_addr);
>>  	}
>>  
> 
> This seems like an unrelated change that was snuck in.

I'll remove that.

Once again, thanks for the review.

-Geoff

