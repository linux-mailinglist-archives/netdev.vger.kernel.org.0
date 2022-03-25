Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3504E7DB1
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbiCYVPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiCYVPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:15:00 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDAA34B99;
        Fri, 25 Mar 2022 14:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=lbD/A+mPwRg8dZJHLfabQrV74g1iS2RTgXnbR4+XnGY=;
        t=1648242805; x=1649452405; b=Ib9JNvmIrbaIq4qyxKnZ9Tkmka/mOeq9EwrctRUr/3VGkEK
        J7LUg2Py9S/VyTcFA/wF0aQ/Cvj0UZTS6PCiaXsEHS2z04WMDbHCBCju/ieGO/48w+e982A10R/zX
        eLQVkmMHFP3vMT1jFaV/wwWNfdk0isI/lfsKCzDaStrv+48+efPD3hx+skgIWAAeJogOxJi4X96SY
        nga/8Td2RNuZ05G7xisTtrW0JigPDQlSZedfh9WYXifrBhC3Ygb490+Tr/beWKqj/KJBwvViyx7X3
        AtKxNNj0joHKS64Jj6Rdg4/QVEunFT7PvYrfDYMrD1B8hxSYV6a8B7/J8TI5W0qw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXrF7-000VW3-JE;
        Fri, 25 Mar 2022 22:13:09 +0100
Message-ID: <e42e4c8bf35b62c671ec20ec6c21a43216e7daa6.camel@sipsolutions.net>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
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
Date:   Fri, 25 Mar 2022 22:13:08 +0100
In-Reply-To: <CAHk-=whXAan2ExANMryPSFaBWeyzikPi+fPUseMoVhQAxR7cEA@mail.gmail.com>
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
         <298f4f9ccad7c3308d3a1fd8b4b4740571305204.camel@sipsolutions.net>
         <CAHk-=whXAan2ExANMryPSFaBWeyzikPi+fPUseMoVhQAxR7cEA@mail.gmail.com>
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

On Fri, 2022-03-25 at 13:47 -0700, Linus Torvalds wrote:
> On Fri, Mar 25, 2022 at 1:38 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> > 
> > >  (2) The CPU now wants to see any state written by the device since
> > > the last sync
> > > 
> > >     This is "dma_sync_single_for_cpu(DMA_FROM_DEVICE)".
> > > 
> > >     A bounce-buffer implementation needs to copy *from* the bounce buffer.
> > > 
> > >     A cache-coherent implementation needs to do nothing.
> > > 
> > >     A non-coherent implementation maybe needs to do nothing (ie it
> > > assumes that previous ops have flushed the cache, and just accessing
> > > the data will bring the rigth thing back into it). Or it could just
> > > flush the cache.
> > 
> > Doesn't that just need to *invalidate* the cache, rather than *flush*
> > it?
> 
> Yes.  I should have been more careful.

Well I see now that you said 'cache "writeback"' in (1), and 'flush' in
(2), so perhaps you were thinking of the same, and I'm just calling it
"flush" and "invalidate" respectively?

> That said, I think "invalidate without writeback" is a really
> dangerous operation (it can generate some *really* hard to debug
> memory state), so on the whole I think you should always strive to
> just do "flush-and-invalidate".

Hmm. Yeah, can't really disagree with that.

However, this seems to be the wrong spot to flush (writeback?) the
cache, as we're trying to get data from the device, not potentially
overwrite the data that the device wrote because we have a dirty
cacheline. Hmm. Then again, how could we possibly have a dirty
cacheline?


Which starts to clarify in my mind why we have a sort of (implied)
ownership model: if the CPU dirties a cacheline while the device has
ownership then the cache writeback might overwrite the DMA data. So it's
easier to think of it as "CPU has ownership" and "device has ownership",
but evidently that simple model breaks down in real-world cases such as
ath9k where the CPU wants to look, but not write, and the device
continues doing DMA at the same time.


Now in that case the cache wouldn't be considered dirty either since the
CPU was just reading, but who knows? Hence the suggestion of just
invalidate, not flush.

> If the core has support for "invalidate clean cache lines only", then
> that's possibly a good alternative.

Well if you actually did dirty the cacheline, then you have a bug one
way or the other, and it's going to be really hard to debug - either you
lose the CPU write, or you lose the device write, there's no way you're
not losing one of them?


ath9k doesn't write, of course, so hopefully the core wouldn't write
back what it must think of as clean cachelines, even if the device
modified the memory underneath already.


So really while I agree with your semantics, I was previously privately
suggesting to Toke we should probably have something like

dma_single_cpu_peek()
// read buffer and check if it was done
dma_single_cpu_peek_finish()

which really is equivalent to the current

dma_sync_single_for_cpu(DMA_FROM_DEVICE)
// ...
dma_sync_single_for_device(DMA_FROM_DEVICE)

that ath9k does, but makes it clearer that you really can't write to the
buffer... but, water under the bridge, I guess.

Thinking about the ownership model again - it seems that we need to at
least modify that ownership model in the sense that we have *write*
ownership that we pass around, not just "ownership". But if we do that,
then we need to clarify which operations pass write ownership and which
don't.

So the operations
(1) dma_sync_single_for_device(DMA_TO_DEVICE)
(2) dma_sync_single_for_cpu(DMA_FROM_DEVICE)
(3) dma_sync_single_for_device(DMA_FROM_DEVICE)

really only (1) passes write ownership to the device, but then you can't
get it back?

But that cannot be true, because ath9k maps the buffer as
DMA_BIDIRECTIONAL, and then eventually might want to recycle it.

Actually though, perhaps passing write ownership back to the CPU isn't
an operation that the DMA API needs to worry about - if the CPU has read
ownership and the driver knows separately that the device is no longer
accessing it, then basically the CPU already got write ownership, and
passes that back uses (1)?


> > Then, however, we need to define what happens if you pass
> > DMA_BIDIRECTIONAL to the sync_for_cpu() and sync_for_device() functions,
> > which adds two more cases? Or maybe we eventually just think that's not
> > valid at all, since you have to specify how you're (currently?) using
> > the buffer, which can't be DMA_BIDIRECTIONAL?
> 
> Ugh. Do we actually have cases that do it?

Yes, a few.

> That sounds really odd for
> a "sync" operation. It sounds very reasonable for _allocating_ DMA,
> but for syncing I'm left scratching my head what the semantics would
> be.

I agree.

> But yes, if we do and people come up with semantics for it, those
> semantics should be clearly documented.

I'm not sure? I'm wondering if this isn't just because - like me
initially - people misunderstood the direction argument, or didn't
understand it well enough, and then just passed the same value as for
the map()/unmap()?

You have to pass the size to all of them too, after all ... but I'm
speculating.

> And if we don't - or people can't come up with semantics for it - we
> should actively warn about it and not have some code that does odd
> things that we don't know what they mean.

Makes sense.

> But it sounds like you agree with my analysis, just not with some of
> my bad/incorrect word choices.

Yes.

johannes
