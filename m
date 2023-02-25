Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE256A2BB7
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 21:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBYUqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 15:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBYUqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 15:46:50 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436D011665
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 12:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=jD12WVcuBPN6CyOhT4zokjMjChMJk3nlnct2iiHTwlM=; b=rTupgEMg7mkm++Img6cxhnDF8t
        Qq2di1JbEb4pThJkj+m3C/Ov4FRSpi1XiEsBDIQpd9cMtpu3rY41UZVFI5omK6o4ltveYKYVeQ5bz
        V0dkPsY73sVqd5D3/jo16Cqbp8I9YRX5ulojxMYgT7Mbrunb9Z1AVhWxIbF3XCIvkZMVh7IfF02sj
        UzDmnp+hHy0PoDXFPCbp/Jzh0A4aysV0iC5GV+B0deHCuMWM/enOLD+EI8n0c1YAgf55osPdfdVUB
        JP3bGWs9NtC7+im6yIFXx1V19RmQTRMGi7pLVKhdlaCGH+sqm97KTMkwEUneEr/CIWlFkjofyFLeh
        fGSZK7KA==;
Received: from 108-211-142-169.lightspeed.wlfrct.sbcglobal.net ([108.211.142.169] helo=[192.168.5.123])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pW1RG-00DeWs-1K;
        Sat, 25 Feb 2023 20:46:39 +0000
Message-ID: <2bdbcb46-fbaa-a2e6-81dd-9e36aad7ab9a@infradead.org>
Date:   Sat, 25 Feb 2023 12:46:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v5 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <cover.1676221818.git.geoff@infradead.org>
 <de8eacb3bb238f40ce69882e425bd83c6180d671.1676221818.git.geoff@infradead.org>
 <6d2a84e9-be27-6707-3d65-b00c8e206d2a@intel.com>
Content-Language: en-US
In-Reply-To: <6d2a84e9-be27-6707-3d65-b00c8e206d2a@intel.com>
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

Hi,

On 2/14/23 09:34, Alexander Lobakin wrote:
>> The Gelic Ethernet device needs to have the RX sk_buffs aligned to
>> GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a
>> multiple of GELIC_NET_RXBUF_ALIGN.
>>
>> The current Gelic Ethernet driver was not allocating sk_buffs large
>> enough to allow for this alignment.
>>
>> Fixes various randomly occurring runtime network errors.
>>
>> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
>> Signed-off-by: Geoff Levand <geoff@infradead.org>
>> ---
>>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 55 ++++++++++++--------
>>  1 file changed, 33 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> index cf8de8a7a8a1..2bb68e60d0d5 100644
>> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> @@ -365,51 +365,62 @@ static int gelic_card_init_chain(struct gelic_card *card,
>>   *
>>   * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
>>   * Activate the descriptor state-wise
>> + *
>> + * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the length
>> + * must be a multiple of GELIC_NET_RXBUF_ALIGN.
>>   */
>>  static int gelic_descr_prepare_rx(struct gelic_card *card,
>>  				  struct gelic_descr *descr)
>>  {
>> -	int offset;
>> -	unsigned int bufsize;
>> +	struct device *dev = ctodev(card);
>> +	struct {
>> +		const unsigned int buffer_bytes;
>> +		const unsigned int total_bytes;
>> +		unsigned int offset;
>> +	} aligned_buf = {
>> +		.buffer_bytes = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN),
>> +		.total_bytes = (GELIC_NET_RXBUF_ALIGN - 1) +
>> +			ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN),
>> +	};
>>  
>>  	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
>>  		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
>> -	/* we need to round up the buffer size to a multiple of 128 */
>> -	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
>>  
>> -	/* and we need to have it 128 byte aligned, therefore we allocate a
>> -	 * bit more */
>> -	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
>> +	descr->skb = dev_alloc_skb(aligned_buf.total_bytes);
> 
> I highly recommend using {napi,netdev}_alloc_frag_align() +
> {napi_,}build_skb() to not waste memory. It will align everything for
> ye, so you won't need all this.

I converted this over to use napi_alloc_frag_align and napi_build_skb, and
then cleanup with skb_free_frag.  I couldn't find any good documentation for
those napi routines though.

For napi_alloc_frag_align, it seems the align parameter should be the
alignment required by the gelic hardware device, so GELIC_NET_RXBUF_ALIGN.
But for the fragsz parameter I couldn't quite figure out from the existing
users of it what exactly it should be.  

I assumed it needed to be the maximum number of bytes the hardware device can
fill, so I set it to be ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN), but
with that I got skb_over_panic errors (skb->tail > skb->end).  I added some
debugging code and found that when it hit the panic skb->end was always 384
bytes short.  I changed GELIC_NET_MAX_MTU to be 1920 which is
ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN) + 384, and it seems to be
working OK.  Does this seem OK?  Maybe the current GELIC_NET_MAX_MTU value is
incorrect.  I did not write that driver, and I don't have any good
documentation for the gelic device.

Thanks for any help you can give.

-Geoff
