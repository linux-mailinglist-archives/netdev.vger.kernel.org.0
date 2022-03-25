Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279B94E7DAF
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiCYTaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiCYTaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:30:12 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2730B710D0
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 12:04:55 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id o10so17216336ejd.1
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 12:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gljIlYXXpBBHbzRdornYZ4fw3jcv11aVW7PwNEPzJZQ=;
        b=Ii2GPivqxQ2ddlxdamEhnLuCB7pfEZti2yKg70Bu00oB1TmGoLi9mmcYJjffLMgr7M
         kO6nzHq/i07S3UkaqTeRHaZx6aM4PAZtnbT71SCPe4jEAxpBzhOPO14QdcWfKG0/keb9
         Rp7c48ZnU1d+fvcLBcoGkqAn/OeN51HLRkwCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gljIlYXXpBBHbzRdornYZ4fw3jcv11aVW7PwNEPzJZQ=;
        b=pHudluAXaAmSWjKVZv5ztt82UkKyXQMBquOa81T9Vbo+qHzo1glwYrRXPmxJSWj/EU
         so1gHtFXPB7kq59LTXgEtDOTuStltsjOtCGW1Aezo7XRRV6ptDZnNK2j/7hWu8SynqM0
         W2CDD5FqZizplh3lHQXrVDKp7iErxD+z6C7Tj0lQwXu3x3nVyYdFrAtYNWbx0IgTKto0
         axKqJ9BuJ6fQfnK7+2+RRn1PhHA9LSH3BOnsEY7kaWalfJTvj/r/5LmSM9CqTvRgzsvP
         zk53LD2utgXwsL7TUKK3YTXP0qcjicRQ9h7OmmuJF/5qcrnAiSX94eUOoBuDJopvSRjJ
         yzGA==
X-Gm-Message-State: AOAM532kaNSpYfMiue/WnpuYN6xhZ8JX+HZePY4QtlDqqMyKtCuI9jhI
        atfWgIFfhI1/3YhcZ+LRO6bwvRnCZRuTaNoraWs=
X-Google-Smtp-Source: ABdhPJzJ6ptSzqL+kqBOXsEpRnF4h9v8XeBlBkU4VSu+tGyzcUhYYvfb5iwkxC74g9G1vVuf8hqSOw==
X-Received: by 2002:a05:6512:2308:b0:44a:7562:9e25 with SMTP id o8-20020a056512230800b0044a75629e25mr2812388lfu.37.1648233040366;
        Fri, 25 Mar 2022 11:30:40 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id h14-20020a0565123c8e00b0044a2ddb6694sm787099lfv.124.2022.03.25.11.30.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 11:30:39 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id 5so14794299lfp.1
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 11:30:38 -0700 (PDT)
X-Received: by 2002:a05:6512:2296:b0:44a:6aaf:b330 with SMTP id
 f22-20020a056512229600b0044a6aafb330mr5713368lfu.531.1648233037928; Fri, 25
 Mar 2022 11:30:37 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de> <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
 <871qyr9t4e.fsf@toke.dk> <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
In-Reply-To: <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 25 Mar 2022 11:30:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com>
Message-ID: <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     Maxime Bizon <mbizon@freebox.fr>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 3:25 AM Maxime Bizon <mbizon@freebox.fr> wrote:
>
> In the non-cache-coherent scenario, and assuming dma_map() did an
> initial cache invalidation, you can write this:

.. but the problem is that the dma mapping code is supposed to just
work, and the driver isn't supposed to know or care whether dma is
coherent or not, or using bounce buffers or not.

And currently it doesn't work.

Because what that ath9k driver does is "natural", but it's wrong for
the bounce buffer case.

And I think the problem is squarely on the dma-mapping side for two reasons:

 (a) this used to work, now it doesn't, and it's unclear how many
other drivers are affected

 (b) the dma-mapping naming and calling conventions are horrible and
actively misleading

That (a) is a big deal. The reason the ath9k issue was found quickly
is very likely *NOT* because ath9k is the only thing affected. No,
it's because ath9k is relatively common.

Just grep for dma_sync_single_for_device() and ask yourself: how many
of those other drivers have you ever even HEARD of, much less be able
to test?

And that's just one "dma_sync" function. Admittedly it's likely one of
the more common ones, but still..

Now, (b) is why I think driver nufgt get this so wrong - or, in this
case, possibly the dma-mapping code itself.

The naming - and even the documentation(!!!) - implies that what ath9k
does IS THE RIGHT THING TO DO.

The documentation clearly states:

  "Before giving the memory to the device, dma_sync_single_for_device() needs
   to be called, and before reading memory written by the device,
   dma_sync_single_for_cpu(), just like for streaming DMA mappings that are
   reused"

and ath9k obviously did exactly that, even with a comment to the effect.

And I think ath9k is actually right here, but the documentation is so
odd and weak that it's the dma-mapping code that was buggy.

So the dma mapping layer literally broke the documented behavior, and
then Christoph goes and says (in another email in this discussion):

 "Unless I'm misunderstanding this thread we found the bug in ath9k
  and have a fix for that now?"

which I think is a gross mis-characterization of the whole issue, and
ignores *BOTH* of (a) and (b).

So what's the move forward here?

I personally think we need to

 - revert commit aa6f8dcbab47 for the simple reason that it is known
to break one driver. But it is unknown how many other drivers are
affected.

   Even if you think aa6f8dcbab47 was the right thing to do (and I
don't - see later), the fact is that it's new behavior that the dma
bounce buffer code hasn't done in the past, and clearly confuses
things.

 - think very carefully about the ath9k case.

   We have a patch that fixes it for the bounce buffer case, but you
seem to imply that it might actually break non-coherent cases:

   "So I'd be very cautious assuming sync_for_cpu() and sync_for_device()
    are both doing invalidation in existing implementation of arch DMA ops,
    implementers may have taken some liberty around DMA-API to avoid
    unnecessary cache operation (not to blame them)"

   so who knows what other dma situations it might break?

   Because if some non-coherent mapping infrastructure assumes that
*only* sync_for_device() will actually flush-and-invalidate caches
(because the platform thinks that once they are flushed, getting them
back to the CPU doesn't need any special ops), then you're right:
Toke's ath9k patch will just result in cache coherency issues on those
platforms instead.

 - think even *more* about what the ath9k situation means for the dma
mapping naming and documentation.

I basically think the DMA syncing has at least three cases (and a
fourth combination that makes no sense):

 (1) The CPU has actively written to memory, and wants to give that
data to the device.

   This is "dma_sync_single_for_device(DMA_TO_DEVICE)".

    A cache-coherent thing needs to do nothing.

   A non-coherent thing needs to do a cache "writeback" (and probably
will flush)

   A bounce buffer implementation needs to copy *to* the bounce buffer

 (2) The CPU now wants to see any state written by the device since
the last sync

    This is "dma_sync_single_for_cpu(DMA_FROM_DEVICE)".

    A bounce-buffer implementation needs to copy *from* the bounce buffer.

    A cache-coherent implementation needs to do nothing.

    A non-coherent implementation maybe needs to do nothing (ie it
assumes that previous ops have flushed the cache, and just accessing
the data will bring the rigth thing back into it). Or it could just
flush the cache.

 (3) The CPU has seen the state, but wants to leave it to the device

   This is "dma_sync_single_for_device(DMA_FROM_DEVICE)".

   A bounce buffer implementation needs to NOT DO ANYTHING (this is
the current ath9k bug - copying to the bounce buffer is wrong)

  A cache coherent implementation needs to do nothing

  A non-coherent implementation needs to flush the cache again, bot
not necessarily do a writeback-flush if there is some cheaper form
(assuming it does nothing in the "CPU now wants to see any state" case
because it depends on the data not having been in the caches)

 (4) There is a fourth case: dma_sync_single_for_cpu(DMA_TO_DEVICE)
which maybe should generate a warning because it seems to make no
sense? I can't think of a case where this would be an issue - the data
is specifically for the device, but it's synced "for the CPU"?

Do people agree? Or am I missing something?

But I don't think the documentation lays out these cases, and I don't
think the naming is great.

I also don't think that we can *change* the naming. That's water under
the bridge. It is what it is. So I think people need to really agree
on the semantics (did I get them entirely wrong above?) and try to
think about ways to maybe give warnings for things that make no sense.

Based on my suggested understanding of what the DMA layer should do,
the ath9k code is actually doing exactly the right thing. It is doing

        dma_sync_single_for_device(DMA_FROM_DEVICE);

and based on my four cases above, the bounce buffer code must do
nothing, because "for_device()" together with "FROM_DEVICE" clearly
says that all the data is coming *from* the device, and copying any
bounce buffers is wrong.

In other words, I think commit aa6f8dcbab47 ("swiotlb: rework 'fix
info leak with DMA_FROM_DEVICE'") is fundamentally wrong. It doesn't
just break ath9k, it fundamentally break that "case 3" above. It's
doing a DMA_TO_DEVICE copy, even though it was a DMA_FROM_DEVICE sync.

So I really think that "revert aa6f8dcbab47" is not only inevitable
because of practical worries about what it breaks, but because that
commit was just entirely and utterly WRONG.

But having written this long wall of text, I'm now slightly worried
that I'm just confused, and am trying to just convince myself.

So please: can people think about this a bit more, and try to shoot
down the above argument and show that I'm just being silly?

And if I'm right, can we please document this and try really hard to
come up with some sanity checks (perhaps based on some "dma buffer
state" debug code?)

                 Linus
