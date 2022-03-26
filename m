Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED244E81E7
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 17:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiCZQHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 12:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbiCZQHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 12:07:19 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856B6473AB;
        Sat, 26 Mar 2022 09:05:39 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648310737; bh=j8t9GHYbTPEWySbmxXMqGskEDtyF/bdWSNoBF6Lu/64=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=vg5mZbAvUN7CYb8K0HW8bypeTCqe4EFeCCg/wFiKDy9xFjqeiZqBVqi5dL/LcpteU
         BdD2O10/08TxH+ZSpQfApD7e4kXNnhXEswpAi0qIPzZLyHIb8vwAGK7sSvEuh+ATRh
         8A1bKgWXXH7vxKok1gmasDztPnrGJX/kETDfmTXL6S69P9nLYP9pNNT4YiW4DkuV+I
         rCIzYyRNFJvclHuPjZib3iboNjgTAjVMsc98W3fXQw8BCGOQWWZrWl+al87Q0Hnh4P
         Wsie6QDudtT0oWCYjMNYitOFVJEHi++yrHQm3mHva53vdhFOgmKIFP9QpVg5VbsnWE
         gsMxBomOxfcPQ==
To:     Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     mbizon@freebox.fr, Linus Torvalds <torvalds@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, Kalle Valo <kvalo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        iommu <iommu@lists.linux-foundation.org>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
In-Reply-To: <20220326003853.44c3285c.pasic@linux.ibm.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de>
 <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
 <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
 <cce202fb-5185-aa3e-9e9b-11626192cb49@arm.com>
 <20220326003853.44c3285c.pasic@linux.ibm.com>
Date:   Sat, 26 Mar 2022 17:05:37 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <8735j47l7y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Halil Pasic <pasic@linux.ibm.com> writes:

> On Fri, 25 Mar 2022 11:27:41 +0000
> Robin Murphy <robin.murphy@arm.com> wrote:
>
>> What muddies the waters a bit is that the opposite combination 
>> sync_for_cpu(DMA_TO_DEVICE) really *should* always be a no-op, and I for 
>> one have already made the case for eliding that in code elsewhere, but 
>> it doesn't necessarily hold for the inverse here, hence why I'm not sure 
>> there even is a robust common solution for peeking at a live 
>> DMA_FROM_DEVICE buffer.
>
> In https://lkml.org/lkml/2022/3/24/739 I also argued, that a robust
> common solution for a peeking at a live DMA_FROM_DEVICE buffer is
> probably not possible, at least not with the current programming model
> as described by Documentation/core-api/dma-api.rst.
>
> Namely AFAIU the programming model is based on exclusive ownership: the
> buffer is either owned by the device, which means CPU(s) are not allowed
> to *access* it, or it is owned by the CPU(s), and the device is not
> allowed to *access* it. Do we agree on this?
>
> Considering what Linus said here https://lkml.org/lkml/2022/3/24/775
> I understand that: if the idea that dma_sync_*_for_{cpu,device} always
> transfers ownership to the cpu and device respectively is abandoned, 
> and we re-define ownership in a sense that only the owner may write,
> but non-owner is allowed to read, then it may be possible to make the
> scenario under discussion work. 
>
> The scenario in pseudo code:
>
> /* when invoked device might be doing DMA into buf */
> rx_buf_complete(buf)
> {
> 	prepare_peek(buf, DMA_FROM_DEVICE);
>         if (!is_ready(buf)) {
>                 /*let device gain the buffer again*/
>                 peek_done_not_ready(buf, DMA_FROM_DEVICE);
>                 return false;
>         }
> 	peek_done_ready(buf, DMA_FROM_DEVICE);
> 	process_buff(buf, DMA_FROM_DEVICE); is
> }
>
> IMHO it is pretty obvious, that prepare_peek() has to update the
> cpu copy of the data *without* transferring ownership to the CPU. Since
> the owner is still the device, it is legit for the device to keep
> modifying the buffer via DMA. In case of the swiotlb, we would copy the
> content of the bounce buffer to the orig buffer possibly after
> invalidating
> caches, and for non-swiotlb we would do invalidate caches. So
> prepare_peek() could be actually something like,
> dma_sync_single_for_cpu(buf, DMA_FROM_DEVICE,
>                         DMA_ATTR_NO_OWNERSHIP_TRANSFER)
> which would most end up being functionally the same, as without the
> flag, since my guess is that the ownership is only tracked in our
> heads.

Well we also need to ensure that the CPU caches are properly invalidated
either in prepare_peek() or peek_done_not_ready(), so that the data is
not cached between subsequent peeks. This could translate to either
turning prepare_peek() into dma_sync_single_for_cpu(buf,
DMA_FROM_DEVICE, DMA_ATTR_NO_OWNERSHIP_TRANSFER_BUT_INVALIDATE_CACHES),
or it could turn peek_done_not_ready() into something that just
invalidates the cache.

I was also toying with the idea of having a copy-based peek helper like:

u32 data = dma_peek_word(buf, offset)

which leaves the ownership as-is, but copies out a single word from the
buffer at the given offset (from the bounce buffer or real buffer as
appropriate) without messing with the ownership notion. The trouble with
this idea is that ath9k reads two different words that are 44 bytes from
each other, so it would have to do two such calls, which would be racy :(

-Toke
