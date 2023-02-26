Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75B26A2CCB
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 01:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBZAQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 19:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjBZAQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 19:16:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CAA15572
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 16:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=rxiJV5VgIIKM/V/bsazfK4vZaElzfa1ELcYdf+J2YiM=; b=lqrZhG2fhQ76VeuBH9/rMGm6ns
        J+v1oIyakIBjJ3oM5eGhqeGZImzROVvkL9IbA3EoHXwy7qlrGNIItRCorA6uwqZw0ki3+8yNEYwyN
        0kyVqZrmySjQ4ukJUI/5CLmeS3Gz8rT6u+YfQ72jIr8SPfV03KYusD7mBpekIzh7epSbdAAstt2qe
        mLW+uH+lJXG+HDSDmwbeyg/CNUqz+Aya/ErmbCX5Bor+YQ8TYZI3X/MlwokIbJ9YMsxBIpimVCHO7
        TQHCnSCabvtnMwUxtlPkG07dKNEgHJq7V5EQU/ZLOstyDVuNRxtYDrQpGepUTGSqK1pCIfkKJ/CLv
        LzdxjAPg==;
Received: from 108-90-42-56.lightspeed.sntcca.sbcglobal.net ([108.90.42.56] helo=[192.168.1.80])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pW4iV-00GUJv-Vf; Sun, 26 Feb 2023 00:16:40 +0000
Message-ID: <7d6676f7-c695-a9a7-f64d-798755b2d519@infradead.org>
Date:   Sat, 25 Feb 2023 16:16:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Geoff Levand <geoff@infradead.org>
Subject: Re: [PATCH net v5 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>
References: <cover.1676221818.git.geoff@infradead.org>
 <de8eacb3bb238f40ce69882e425bd83c6180d671.1676221818.git.geoff@infradead.org>
 <d18b70fc097d475ca6e4a5b9349b971eda1f853d.camel@redhat.com>
Content-Language: en-US
In-Reply-To: <d18b70fc097d475ca6e4a5b9349b971eda1f853d.camel@redhat.com>
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

On 2/14/23 02:46, Paolo Abeni wrote:
> +Alex
> On Sun, 2023-02-12 at 18:00 +0000, Geoff Levand wrote:
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
> 
> Please use the correct format for the Fixes tag: <hash> ("<msg>"). Note
> the missing quotes.

I'll add those.
 
>> -	/* io-mmu-map the skb */
>> -	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
>> -						     descr->skb->data,
>> -						     GELIC_NET_MAX_MTU,
>> -						     DMA_FROM_DEVICE));
>> +	skb_reserve(descr->skb, aligned_buf.offset);
>> +
>> +	descr->buf_addr = dma_map_single(dev, descr->skb->data, descr->buf_size,
>> +		DMA_FROM_DEVICE);
> 
> As already noted by Alex, you should preserve the cpu_to_be32(). If the
> running arch is be32, it has 0 performance and/or code size overhead,
> and it helps readability and maintainability.

I'll add those in for the next patch set.

> Please be sure to check the indentation of new code with checkpatch.

checkpatch reports a CHECK for my indentation. As is discussed in
the kernel's coding style guide, coding style is about
maintainability, and as the maintainer of this driver I think
the indentation I have used is more readable and hence easier to
maintain.

Thanks for the review.

-Geoff
