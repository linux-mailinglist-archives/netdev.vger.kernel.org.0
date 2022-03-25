Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA584E7D27
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiCYTgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiCYTgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:36:19 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462102E5188;
        Fri, 25 Mar 2022 12:09:37 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648232029; bh=2/6Vw2ASBAiN11k5yojKv5+vCVhPImMu3UVtt56378s=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=u6q8TNoDqnTn5TUskazRYnwgeG+FCVCycn+e4KdE8c61ipZ71vDDXvjHlHXaTSufc
         /7zUjA3cna3B1x8HpC7xOnRsqbkf3oxSIjhlvc2TBhwwVaooYqMMVK90FuenhMHD/2
         QS79/isfJKz7ViC1uu+Wdx+J3znSWRwUjvnqrUahIJiVwHX51aJj1/gj9kScR5ZAJe
         SUnOve0P5jpqAuBha431w1dhO5VMokHhVBKZvf300guwM7zTQJRRqrDCikWFvCLTNy
         weUjZRns/h9tE3SQyZ1YXoNzvSRKC+ij1BEfuTN4pybtBu+xQp3jtpNx0kJHo92MC0
         9CDkrzVDsS39Q==
To:     Robin Murphy <robin.murphy@arm.com>, mbizon@freebox.fr,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
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
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
In-Reply-To: <f4224721-4578-61d3-69a7-9a3a76c50529@arm.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de>
 <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
 <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
 <87a6de80em.fsf@toke.dk> <f4224721-4578-61d3-69a7-9a3a76c50529@arm.com>
Date:   Fri, 25 Mar 2022 19:13:49 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <871qyp99ya.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robin Murphy <robin.murphy@arm.com> writes:

> On 2022-03-25 16:25, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Maxime Bizon <mbizon@freebox.fr> writes:
>>=20
>>> On Thu, 2022-03-24 at 12:26 -0700, Linus Torvalds wrote:
>>>
>>>>
>>>> It's actually very natural in that situation to flush the caches from
>>>> the CPU side again. And so dma_sync_single_for_device() is a fairly
>>>> reasonable thing to do in that situation.
>>>>
>>>
>>> In the non-cache-coherent scenario, and assuming dma_map() did an
>>> initial cache invalidation, you can write this:
>>>
>>> rx_buffer_complete_1(buf)
>>> {
>>> 	invalidate_cache(buf, size)
>>> 	if (!is_ready(buf))
>>> 		return;
>>> 	<proceed with receive>
>>> }
>>>
>>> or
>>>
>>> rx_buffer_complete_2(buf)
>>> {
>>> 	if (!is_ready(buf)) {
>>> 		invalidate_cache(buf, size)
>>> 		return;
>>> 	}
>>> 	<proceed with receive>
>>> }
>>>
>>> The latter is preferred for performance because dma_map() did the
>>> initial invalidate.
>>>
>>> Of course you could write:
>>>
>>> rx_buffer_complete_3(buf)
>>> {
>>> 	invalidate_cache(buf, size)
>>> 	if
>>> (!is_ready(buf)) {
>>> 		invalidate_cache(buf, size)
>>> 		return;
>>> 	}
>>>=20=09
>>> <proceed with receive>
>>> }
>>>
>>>
>>> but it's a waste of CPU cycles
>>>
>>> So I'd be very cautious assuming sync_for_cpu() and sync_for_device()
>>> are both doing invalidation in existing implementation of arch DMA ops,
>>> implementers may have taken some liberty around DMA-API to avoid
>>> unnecessary cache operation (not to blame them).
>>=20
>> I sense an implicit "and the driver can't (or shouldn't) influence
>> this" here, right?
>
> Right, drivers don't get a choice of how a given DMA API implementation=20
> works.
>
>>> For example looking at arch/arm/mm/dma-mapping.c, for DMA_FROM_DEVICE
>>>
>>> sync_single_for_device()
>>>    =3D> __dma_page_cpu_to_dev()
>>>      =3D> dma_cache_maint_page(op=3Ddmac_map_area)
>>>        =3D> cpu_cache.dma_map_area()
>>>
>>> sync_single_for_cpu()
>>>    =3D> __dma_page_dev_to_cpu()
>>>      =3D>
>>> __dma_page_cpu_to_dev(op=3Ddmac_unmap_area)
>>>        =3D>
>>> cpu_cache.dma_unmap_area()
>>>
>>> dma_map_area() always does cache invalidate.
>>>
>>> But for a couple of CPU variant, dma_unmap_area() is a noop, so
>>> sync_for_cpu() does nothing.
>>>
>>> Toke's patch will break ath9k on those platforms (mostly silent
>>> breakage, rx corruption leading to bad performance)
>>=20
>> Okay, so that would be bad obviously. So if I'm reading you correctly
>> (cf my question above), we can't fix this properly from the driver side,
>> and we should go with the partial SWIOTLB revert instead?
>
> Do you have any other way of telling if DMA is idle, or temporarily
> pausing it before the sync_for_cpu, such that you could honour the
> notion of ownership transfer properly?

I'll go check with someone who has a better grasp of how the hardware
works, but I don't think so...

> As mentioned elsewhere I suspect the only "real" fix if you really do
> need to allow concurrent access is to use the coherent DMA API for
> buffers rather than streaming mappings, but that's obviously some far
> more significant surgery.

That would imply copying the packet data out of that (persistent)
coherent mapping each time we do a recv operation, though, right? That
would be quite a performance hit...

If all we need is a way to make dma_sync_single_for_cpu() guarantee a
cache invalidation, why can't we just add a separate version that does
that (dma_sync_single_for_cpu_peek() or something)? Using that with the
patch I posted earlier should be enough to resolve the issue, AFAICT?

-Toke
