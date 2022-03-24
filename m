Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3DA4E6A23
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 22:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354061AbiCXVQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 17:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349749AbiCXVQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 17:16:04 -0400
X-Greylist: delayed 24396 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Mar 2022 14:14:30 PDT
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125CF2898C;
        Thu, 24 Mar 2022 14:14:29 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648156468; bh=10YpchtIHtcZ8NSl6ZT7uwLuFlfFgJXa9Oolkv8NtQg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=bgzPaBmGHN+bnivn53/b7ZIz9/UwYFmY03s5yT9g1LzfZvAJ3uIC7ce11QS/c9gDk
         R+EyTlbehDyeBvELCV6f+pU+CmP91zr7lx482udUYxg9jrlR/ovTm9K8oIjoB/rEha
         koK3I9RsZ9nIP/hbajSqIVn+Bk0NpwJEeSXvuQ3T1G3hO5g+mSdwUwK93gKKp92h+F
         OmmTJoRUd4/LgjWY01urisinyN5elIPMT5iEkPrjHSSPHnq9iwLcPxdf+NOnHNHk0j
         L5ovl1Ohbmz8Q5MEpZ3NdLlM2L2Qx85IIHFm9o24PgoAXbuYmLr7yHvHkB7jVoVtj+
         eFDzUyYMP1/pw==
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>,
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
In-Reply-To: <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de>
 <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
 <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
Date:   Thu, 24 Mar 2022 22:14:28 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87r16r834b.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Mar 24, 2022 at 10:07 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@t=
oke.dk> wrote:
>>
>> Right, but is that sync_for_device call really needed?
>
> Well, imagine that you have a non-cache-coherent DMA (not bounce
> buffers - just bad hardware)...
>
> So the driver first does that dma_sync_single_for_cpu() for the CPU
> see the current state (for the non-cache-coherent case it would just
> invalidate caches).
>
> The driver then examines the command buffer state, sees that it's
> still in progress, and does that return -EINPROGRESS.
>
> It's actually very natural in that situation to flush the caches from
> the CPU side again. And so dma_sync_single_for_device() is a fairly
> reasonable thing to do in that situation.
>
> But it doesn't seem *required*, no. The CPU caches only have a copy of
> the data in them, no writeback needed (and writeback wouldn't work
> since DMA from the device may be in progress).
>
> So I don't think the dma_sync_single_for_device() is *wrong* per se,
> because the CPU didn't actually do any modifications.
>
> But yes, I think it's unnecessary - because any later CPU accesses
> would need that dma_sync_single_for_cpu() anyway, which should
> invalidate any stale caches.

OK, the above was basically how I understood it. Thank you for
confirming!

> And it clearly doesn't work in a bounce-buffer situation, but honestly
> I don't think a "CPU modified buffers concurrently with DMA" can
> *ever* work in that situation, so I think it's wrong for a bounce
> buffer model to ever do anything in the dma_sync_single_for_device()
> situation.

Right.

> Does removing that dma_sync_single_for_device() actually fix the
> problem for the ath driver?

I am hoping Oleksandr can help answer that since my own ath9k hardware
is currently on strike :(

-Toke
