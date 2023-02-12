Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508C66938FD
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 18:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjBLRGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 12:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBLRGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 12:06:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091D3F761
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 09:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:References:To:Subject:From:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=Gcv4F0z6e8rxH/1pMUX4AADuyvN5Bf5T85liKTQIIiM=; b=lGk3nEq/EYho2IkvXSqoX92Rv3
        Pfqtm89w1PzEZFZNdyKvh+0s+SfrDLw+jqH/Jofh8fiKy3o0Jo5BqEB7pq8TVd6wA6klg1JgvBLzU
        aDD/LslaMMHDlpjKaWywrW62UPsnUP8MMJUasw7RGoyQgdRoOq7Inn9/mFcjKLjyvtt3aNth/idDu
        Q71SjRVDRd7ZotLUI5jLKunXCNVm8L+uo85WJCopAsYhwrerAAw3WuchsGb12CaWh1brVQTGC1sAB
        +Gpsd8DSaJYRSGRFd7y50nO8E+XZmxfiUyfRpV12qzb750tt0m65Mg1B85M6HlbgL6cihjApIKxZG
        7gizMJcg==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRFo0-0050ES-0R; Sun, 12 Feb 2023 17:06:24 +0000
Message-ID: <29b83fc2-af28-e19d-b837-80778e429417@infradead.org>
Date:   Sun, 12 Feb 2023 09:06:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v4 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <cover.1675632296.git.geoff@infradead.org>
 <4150b1589ed367e18855c16762ff160e9d73a42f.1675632296.git.geoff@infradead.org>
 <9ddd548874378f29ce7729823a1590dac0c6eca2.camel@gmail.com>
Content-Language: en-US
In-Reply-To: <9ddd548874378f29ce7729823a1590dac0c6eca2.camel@gmail.com>
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

Thanks for the review.

On 2/6/23 08:25, Alexander H Duyck wrote:
> On Sun, 2023-02-05 at 22:10 +0000, Geoff Levand wrote:
>> The Gelic Ethernet device needs to have the RX sk_buffs aligned to
>> GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a multiple of
>> GELIC_NET_RXBUF_ALIGN.
>>

>>  static int gelic_descr_prepare_rx(struct gelic_card *card,
>>  				  struct gelic_descr *descr)
>>  {
>> -	int offset;
>> -	unsigned int bufsize;
>> +	struct device *dev = ctodev(card);
>> +	struct {
>> +		unsigned int total_bytes;
>> +		unsigned int offset;
>> +	} aligned_buf;
>> +	dma_addr_t cpu_addr;
>>  
>>  	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
>>  		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
>> -	/* we need to round up the buffer size to a multiple of 128 */
>> -	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
>>  
>> -	/* and we need to have it 128 byte aligned, therefore we allocate a
>> -	 * bit more */
>> -	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
>> +	aligned_buf.total_bytes = (GELIC_NET_RXBUF_ALIGN - 1) +
>> +		GELIC_NET_MAX_MTU + (GELIC_NET_RXBUF_ALIGN - 1);
>> +
> 
> This value isn't aligned to anything as there have been no steps taken
> to align it. In fact it is guaranteed to be off by 2. Did you maybe
> mean to use an "&" somewhere?

total_bytes here means the total number of bytes to allocate that will
allow for the desired alignment.  This value a bit too much though since
we really just need it to end on a GELIC_NET_RXBUF_ALIGN boundary, so 
adding ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN) should be enough.
I'll fix that in the next patch version.

>> +	descr->skb = dev_alloc_skb(aligned_buf.total_bytes);
>> +
>>  	if (!descr->skb) {
>> -		descr->buf_addr = 0; /* tell DMAC don't touch memory */
>> +		descr->buf_addr = 0;
>>  		return -ENOMEM;
> 
> Why remove this comment?

If we return -ENOMEM this descriptor shouldn't be used.

>>  	}
>> -	descr->buf_size = cpu_to_be32(bufsize);
>> +
>> +	aligned_buf.offset =
>> +		PTR_ALIGN(descr->skb->data, GELIC_NET_RXBUF_ALIGN) -
>> +			descr->skb->data;
>> +
>> +	descr->buf_size = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
> 
> Originally this was being written using cpu_to_be32. WIth this you are
> writing it raw w/ the cpu endianness. Is there a byte ordering issue
> here?

No. The PS3 has a big endian CPU, so we really don't need any
of the endian conversions.

> 
>>  	descr->dmac_cmd_status = 0;
>>  	descr->result_size = 0;
>>  	descr->valid_size = 0;
>>  	descr->data_error = 0;
>>  
>> -	offset = ((unsigned long)descr->skb->data) &
>> -		(GELIC_NET_RXBUF_ALIGN - 1);
>> -	if (offset)
>> -		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
> 
> Rather than messing with all this it might be easier to just drop
> offset in favor of NET_SKB_PAD since that should be offset in all cases
> where dev_alloc_skb is being used. With that the reserve could just be
> a constant.

GELIC_NET_RXBUF_ALIGN is a property of the gelic hardware device.  I
would think if NET_SKB_PAD would work it would just be by coincidence.

>> -	/* io-mmu-map the skb */
>> -	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
>> -						     descr->skb->data,
>> -						     GELIC_NET_MAX_MTU,
>> -						     DMA_FROM_DEVICE));
>> +	skb_reserve(descr->skb, aligned_buf.offset);
>> +
>> +	cpu_addr = dma_map_single(dev, descr->skb->data, descr->buf_size,
>> +		DMA_FROM_DEVICE);
>> +
>> +	descr->buf_addr = cpu_to_be32(cpu_addr);
>> +
>>  	if (!descr->buf_addr) {
> 
> This check should be for dma_mapping_error based on "cpu_addr". There
> are some configs that don't return NULL to indicate a mapping error.

As was requested, I have put those corrections into the second patch
of this series.

-Geoff

