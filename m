Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554E36B6110
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 22:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjCKVlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 16:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCKVlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 16:41:19 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF6C580DF
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 13:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=QYdHd+aYOrFc1fCnHOv/r8e3i54B2FPD2t32pyTPCwU=; b=C0dW921fXJPPsrxruWkMon8D6F
        2kYDp7kCIQtAd1MD7sfPiibIrYMJqG3/RzkW8B1ptmJw+7tB3G2e6eL/vFzqi2SxJk+NPEcJGXlny
        daWBOCMIA+KG0L7c8eHw68B56tjxR+TBzYL7O5qH5QmK7zgM7n23ABamf+K7GPklk0j7rwB7wva5A
        ArVLPzD3WQmzW4oPOSRb08zqlI+R5a71/ukmkKOkHT+zzfQ/8FPnZX9ClaDRTiNJ7qFMox7FT2mkm
        8H8NoM1rNxvM/2c7m1AMU4+2L6wyhdeloLfgz+4+9Nz7A/6/ASQhgadStUqu5/yF2iuxYXfamB+qY
        1zckmHSw==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pb6xM-000p6r-23;
        Sat, 11 Mar 2023 21:40:51 +0000
Message-ID: <8b281e5c-d330-a412-f477-59c32a3b6a85@infradead.org>
Date:   Sat, 11 Mar 2023 13:40:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v7 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <cover.1677981671.git.geoff@infradead.org>
 <22d742b4e7d11ff48e8c40e39db3c776e495abe2.1677981671.git.geoff@infradead.org>
 <4dfe231890d9b29f90d90f98d0898dcd7910f25a.camel@gmail.com>
Content-Language: en-US
In-Reply-To: <4dfe231890d9b29f90d90f98d0898dcd7910f25a.camel@gmail.com>
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

On 3/6/23 07:54, Alexander H Duyck wrote:
> On Sun, 2023-03-05 at 02:08 +0000, Geoff Levand wrote:
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
>>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 10 ++++++----
>>  drivers/net/ethernet/toshiba/ps3_gelic_net.h |  5 +++--
>>  2 files changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> index cf8de8a7a8a1..b0ebe0e603b4 100644
>> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
>> @@ -375,11 +375,13 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
>>  	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
>>  		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
>>  	/* we need to round up the buffer size to a multiple of 128 */
>> -	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
>> +	bufsize = (GELIC_NET_MAX_FRAME + GELIC_NET_RXBUF_ALIGN - 1) &
>> +		(~(GELIC_NET_RXBUF_ALIGN - 1));
> 
> Why did you stop using ALIGN? What you coded looks exactly like what
> the code for ALIGN does. From what I can tell you just need to replace
> GELIC_NET_MAX_MTU with GELIC_NET_MAX_FRAME.

OK, I'll use ALIGN for the next patch set.
   
>>  	/* and we need to have it 128 byte aligned, therefore we allocate a
>>  	 * bit more */
>> -	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
>> +	descr->skb = netdev_alloc_skb(*card->netdev, bufsize +
>> +		GELIC_NET_RXBUF_ALIGN - 1);
> 
> This wrapping doesn't look right to me. Also why add the align value
> again here? I would think that it being added above should have taken
> care of what you needed. Are you adding any data beyond the end of what
> is DMAed into the frame?

This is just a straight copy of what is done in the spider net driver.
As I mentioned in the comment of this patch, the DMA buffer must be a
multiple of GELIC_NET_RXBUF_ALIGN, and that is what that extra
'GELIC_NET_RXBUF_ALIGN - 1' is for.
 
>>  	if (!descr->skb) {
>>  		descr->buf_addr = 0; /* tell DMAC don't touch memory */
>>  		return -ENOMEM;
>> @@ -397,7 +399,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
>>  	/* io-mmu-map the skb */
>>  	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
>>  						     descr->skb->data,
>> -						     GELIC_NET_MAX_MTU,
>> +						     GELIC_NET_MAX_FRAME,
>>  						     DMA_FROM_DEVICE));
> 
> Rather than using the define GELIC_NET_MAX_FRAME, why not just use
> bufsize since that is what you actually have allocated for receive?

Again, this is a straight copy of what is done in the spider net driver.
It does seem like using bufsize would be better, so I'll change that.

>>  	if (!descr->buf_addr) {
>>  		dev_kfree_skb_any(descr->skb);
>> @@ -915,7 +917,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr *descr,
>>  	data_error = be32_to_cpu(descr->data_error);
>>  	/* unmap skb buffer */
>>  	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr),
>> -			 GELIC_NET_MAX_MTU,
>> +			 GELIC_NET_MAX_FRAME,
>>  			 DMA_FROM_DEVICE);
> 
> I suppose my suggestion above would cause a problem here since you
> would need to also define buffer size here. However since it looks like
> you are adding a define below anyway maybe you should just look at
> adding a new RX_BUFSZ define and just drop bufsize completely.

I think making bufsize a static const would be better, since it
would avoid using the pre-processor.

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
> 
> Since you are adding defines why not just add:
> #define GELIC_NET_RX_BUFSZ \
> 	ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN)

Thanks for the review.

-Geoff

