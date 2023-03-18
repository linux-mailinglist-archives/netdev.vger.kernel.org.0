Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213B76BFBEB
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 18:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCRRiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 13:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCRRiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 13:38:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C21D3346E
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 10:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=H+IbZ/19DRV+gYWXsuBcQ5ukuvqEWhuQge8MHMq/QI4=; b=n4xVo2W0wYt22V7e6obZVbk40v
        IJmTDhbuHxZY5Bc/C+PtcVBVQ1ryFC5CJ4F4kXvsvhxzJiIpydHL5sO2yNohMJXlrSYY4IAEHl9og
        LL6kc3O2CRiMmsPTUYMMYeuvbM97SdYE9bfVQ4OcBVCb3MTxb6cFILS8ZA30Rc9UDl2NpnkMnac1q
        cScP4watfXoEvK8sVDyXR1N8Z971QsW+IAkiq+GkY1h3Z1GykLgXXvbfZ+8kJ5nAgGA1BXW0Otdfs
        sZaga2p+QnIGJVh+iJpc7zYmVIkcy4kUtF1l/GZscIs4H67rAnVdnf8T+w6gT6nXJrbns0PvXEGGi
        o3fBTInA==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pdaUn-00H0Um-67; Sat, 18 Mar 2023 17:37:33 +0000
Message-ID: <c06050fc-d00f-fbe6-c11d-dee35ad5b573@infradead.org>
Date:   Sat, 18 Mar 2023 10:37:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v8 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <cover.1678570942.git.geoff@infradead.org>
 <4581be2478ecc3292a3864e24fe9a42dac533b89.1678570942.git.geoff@infradead.org>
 <64932ccc97c3bd2ab7fac6216e465550107b7fa4.camel@gmail.com>
Content-Language: en-US
In-Reply-To: <64932ccc97c3bd2ab7fac6216e465550107b7fa4.camel@gmail.com>
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

Sorry for the delay in my reply, I was away last weekend and
couldn't do any PS3 work.

On 3/11/23 14:37, Alexander H Duyck wrote:
> On Sat, 2023-03-11 at 21:46 +0000, Geoff Levand wrote:
>> The Gelic Ethernet device needs to have the RX sk_buffs aligned to
>> GELIC_NET_RXBUF_ALIGN, and also the length of the RX sk_buffs must
>> be a multiple of GELIC_NET_RXBUF_ALIGN.
>>
>> The current Gelic Ethernet driver was not allocating sk_buffs large
>> enough to allow for this alignment.
>>
>> Also, correct the maximum and minimum MTU sizes, and add a new
>> preprocessor macro for the maximum frame size, GELIC_NET_MAX_FRAME.
>>
>> Fixes various randomly occurring runtime network errors.
>>
>> Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
>> Signed-off-by: Geoff Levand <geoff@infradead.org>
>> ---
>>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 21 +++++++++++---------
>>  drivers/net/ethernet/toshiba/ps3_gelic_net.h |  5 +++--
>>  2 files changed, 15 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> index cf8de8a7a8a1..56557fc8d18a 100644
>> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> @@ -44,6 +44,14 @@ MODULE_AUTHOR("SCE Inc.");
>>  MODULE_DESCRIPTION("Gelic Network driver");
>>  MODULE_LICENSE("GPL");
>>  
>> +/**
>> + * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the length
>> + * must be a multiple of GELIC_NET_RXBUF_ALIGN.
>> + */
>> +
>> +static const unsigned int gelic_rx_skb_size =
>> +	ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN) +
>> +	GELIC_NET_RXBUF_ALIGN - 1;
>>
> 
> After a bit more digging I now understand the need for the
> "GELIC_NET_RXBUF_ALIGN - 1". It shouldn't be added here. The device
> will not be able to DMA into it. It is being used to align the buffer
> itself to 128B. I am assuming it must be 128B aligned in BOTH size and
> offset.

I want gelic_rx_skb_size to be the value to use with netdev_alloc_skb.

Also, I think just using GELIC_NET_MAX_FRAME for dma_map_single is
enough. Using gelic_rx_skb_size for dma_map_single would work, but the
gelic hardware device could only fill GELIC_NET_MAX_FRAME of the
bigger gelic_rx_skb_size DMA mapping.

>>  /* set irq_mask */
>>  int gelic_card_set_irq_mask(struct gelic_card *card, u64 mask)
>> @@ -370,21 +378,16 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
>>  				  struct gelic_descr *descr)
>>  {
>>  	int offset;
>> -	unsigned int bufsize;
>>  
>>  	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
>>  		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
>> -	/* we need to round up the buffer size to a multiple of 128 */
>> -	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
>>  
>> -	/* and we need to have it 128 byte aligned, therefore we allocate a
>> -	 * bit more */
>> -	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
>> +	descr->skb = netdev_alloc_skb(*card->netdev, gelic_rx_skb_size);
> 
> I would leave the "+  GELIC_NET_RXBUF_ALIGN - 1" here. so it should be
> 	descr->skb = netdev_alloc_skb(*card->netdev, 		
> 				      gelic_rx_skb_size +
> 				      GELIC_NET_RXBUF_ALIGN - 1);
> 
> Also I would leav the comment as it makes it a bit clearer what is
> going on here.

With the use of GELIC_NET_MAX_FRAME as the DMA mapping size
gelic_rx_skb_size becomes local to the gelic_descr_prepare_rx
routine, so I put the comment about the size requirements into
the the comment for the gelic_descr_prepare_rx routine.

> 
>>  	if (!descr->skb) {
>>  		descr->buf_addr = 0; /* tell DMAC don't touch memory */
>>  		return -ENOMEM;
>>  	}
>> -	descr->buf_size = cpu_to_be32(bufsize);
>> +	descr->buf_size = cpu_to_be32(gelic_rx_skb_size);
>>  	descr->dmac_cmd_status = 0;
>>  	descr->result_size = 0;
>>  	descr->valid_size = 0;
> 
> The part I missed was the lines of code that didn't make it into the
> patch that like between the two code blocks here above and below. They
> are doing an AND with your align mask and then adding the difference to
> the skb reserve to pad it to be 128B aligned.
> 
>> @@ -397,7 +400,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
>>  	/* io-mmu-map the skb */
>>  	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
>>  						     descr->skb->data,
>> -						     GELIC_NET_MAX_MTU,
>> +						     gelic_rx_skb_size,
>>  						     DMA_FROM_DEVICE));
>>  	if (!descr->buf_addr) {
>>  		dev_kfree_skb_any(descr->skb);
>> @@ -915,7 +918,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr *descr,
>>  	data_error = be32_to_cpu(descr->data_error);
>>  	/* unmap skb buffer */
>>  	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr),
>> -			 GELIC_NET_MAX_MTU,
>> +			 gelic_rx_skb_size,
>>  			 DMA_FROM_DEVICE);
>>  
>>  	skb_put(skb, be32_to_cpu(descr->valid_size)?
>> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
>> index 68f324ed4eaf..0d98defb011e 100644
>> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
>> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
>> @@ -19,8 +19,9 @@
>>  #define GELIC_NET_RX_DESCRIPTORS        128 /* num of descriptors */
>>  #define GELIC_NET_TX_DESCRIPTORS        128 /* num of descriptors */
>>  
>> -#define GELIC_NET_MAX_MTU               VLAN_ETH_FRAME_LEN
>> -#define GELIC_NET_MIN_MTU               VLAN_ETH_ZLEN
>> +#define GELIC_NET_MAX_FRAME             2312
>> +#define GELIC_NET_MAX_MTU               2294
>> +#define GELIC_NET_MIN_MTU               64
>>  #define GELIC_NET_RXBUF_ALIGN           128
>>  #define GELIC_CARD_RX_CSUM_DEFAULT      1 /* hw chksum */
>>  #define GELIC_NET_WATCHDOG_TIMEOUT      5*HZ

-Geoff


