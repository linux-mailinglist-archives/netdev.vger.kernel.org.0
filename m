Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF664E7CAC
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiCYUj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 16:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbiCYUjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 16:39:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B1415407A;
        Fri, 25 Mar 2022 13:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=hew7fHVL6FBQI77veB2hwuoO4Es9nvwsanNbsTy12PY=;
        t=1648240698; x=1649450298; b=PxFb+cxH1F5Ob9Hh8gOR/XulGWvBkFVKkY3m9WqQpmSS5vP
        elGgFVntHV8gCpZcR5VigbHYs1weDKVePC/MlY3BCRIN/wr0pXamY/d08p7BioTCsfq9MXy2Q47oA
        XoUgSGaHIJstcs4oWtaR/Ee+QPhUZSnu1t01HGQfbJwAOPpkGhbPBfUxi8ZR+JTis4WYR5JkGGVI9
        7kgEoTHBBiwdREorkL6xid1BUJhkQP+23/RiWFKcT4WZqOv/Nq6G6/x575l/Xa34YWcm65domhuyr
        SwVb8uaxQSfytQKq6x1cMeM4zGmtD/o7g/0BR//NhQnH9zjc9Jfo1lFRZUG+FqcA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXqgi-000Uby-Lq;
        Fri, 25 Mar 2022 21:37:36 +0100
Message-ID: <298f4f9ccad7c3308d3a1fd8b4b4740571305204.camel@sipsolutions.net>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Maxime Bizon <mbizon@freebox.fr>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Date:   Fri, 25 Mar 2022 21:37:35 +0100
In-Reply-To: <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
         <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
         <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
         <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
         <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
         <20220324163132.GB26098@lst.de>
         <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
         <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
         <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
         <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So I've been watching this from the sidelines mostly, and discussing a
bit with Toke, but:

On Fri, 2022-03-25 at 11:30 -0700, Linus Torvalds wrote:
> 
>  (2) The CPU now wants to see any state written by the device since
> the last sync
> 
>     This is "dma_sync_single_for_cpu(DMA_FROM_DEVICE)".
> 
>     A bounce-buffer implementation needs to copy *from* the bounce buffer.
> 
>     A cache-coherent implementation needs to do nothing.
> 
>     A non-coherent implementation maybe needs to do nothing (ie it
> assumes that previous ops have flushed the cache, and just accessing
> the data will bring the rigth thing back into it). Or it could just
> flush the cache.

Doesn't that just need to *invalidate* the cache, rather than *flush*
it? The cache is somewhat similar to the bounce buffer, and here you're
copying _from_ the bounce buffer (which is where the device is
accessing), so shouldn't it be the same for the cache, i.e. you
invalidate it so you read again from the real memory?

>  (3) The CPU has seen the state, but wants to leave it to the device
> 
>    This is "dma_sync_single_for_device(DMA_FROM_DEVICE)".
> 
>    A bounce buffer implementation needs to NOT DO ANYTHING (this is
> the current ath9k bug - copying to the bounce buffer is wrong)
> 
>   A cache coherent implementation needs to do nothing
> 
>   A non-coherent implementation needs to flush the cache again, bot
> not necessarily do a writeback-flush if there is some cheaper form
> (assuming it does nothing in the "CPU now wants to see any state" case
> because it depends on the data not having been in the caches)

And similarly here, it would seem that the implementation can't _flush_
the cache as the device might be writing concurrently (which it does in
fact do in the ath9k case), but it must invalidate the cache?

I'm not sure about the (2) case, but here it seems fairly clear cut that
if you have a cache, don't expect the CPU to write to the buffer (as
evidenced by DMA_FROM_DEVICE), you wouldn't want to write out the cache
to DRAM?


I'll also note independently that ath9k actually maps the buffers as
DMA_BIDIRECTIONAL, but the flush operations happen with DMA_FROM_DEVICE,
at least after the setup is done. I must admit that I was scratching my
head about this, I had sort of expected one should be passing the same
DMA direction to all different APIs for the same buffer, but clearly, as
we can see in your list of cases here, that's _not_ true.


Then, however, we need to define what happens if you pass
DMA_BIDIRECTIONAL to the sync_for_cpu() and sync_for_device() functions,
which adds two more cases? Or maybe we eventually just think that's not
valid at all, since you have to specify how you're (currently?) using
the buffer, which can't be DMA_BIDIRECTIONAL?


>  (4) There is a fourth case: dma_sync_single_for_cpu(DMA_TO_DEVICE)
> which maybe should generate a warning because it seems to make no
> sense? I can't think of a case where this would be an issue - the data
> is specifically for the device, but it's synced "for the CPU"?

I'd tend to agree with that, that's fairly much useless, since if only
the CPU wrote to it, then you wouldn't care about any caching or bounce
buffers, so no need to sync back.

> In other words, I think commit aa6f8dcbab47 ("swiotlb: rework 'fix
> info leak with DMA_FROM_DEVICE'") is fundamentally wrong. It doesn't
> just break ath9k, it fundamentally break that "case 3" above. It's
> doing a DMA_TO_DEVICE copy, even though it was a DMA_FROM_DEVICE sync.
> 
> So I really think that "revert aa6f8dcbab47" is not only inevitable
> because of practical worries about what it breaks, but because that
> commit was just entirely and utterly WRONG.

Honestly, I was scratching my head about this too - sadly it just says
"what was agreed", without a pointer to how that was derived, but it
seemed that the original issue was:

 "we're leaking old bounce buffer data to the device"

or was it not? In which case doing any copies during map should've been
sufficient, since then later no more data leaks could occur?

johannes
