Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2944E78E0
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376730AbiCYQ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241341AbiCYQ1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:27:00 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E72DA6C9;
        Fri, 25 Mar 2022 09:25:24 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648225521; bh=CQVTQ0YWUyVqJTQIKyyy3fv+ewiFx6OvdfGg4mW6pTQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=dY6s8FZcGbx4M3Ov5kHFWbz37pKFj65G1OC6fBB8z/tVV+am88ZfoF14ED65xxRfy
         fOLQlXZTlO9XnrrFbC9jdp9qP8CzWxIoIJ9tmfXHq2P/R5yHN396bTH6CKZYI5a8WW
         DD3bdPHqaN8gCGW78pwoabnJBY2snukIyApgMIoAqaA9Vdl2OUjDqBtuq40B49gIBc
         w+FVDx4iSZKjE/araq8XXw8Ex3/qMIjxUaNZ8Exy3fR+fRHCPfJikWMxuYW7fVYSRZ
         iv5BKTJDyv5nkS+fmdfKnF9fqjQ8Q5kgi4mjFJqFWUv15ynkDAsA+TI670+ZfI4GOK
         IWwWkpT3eVt0w==
To:     mbizon@freebox.fr, Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
In-Reply-To: <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de>
 <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
 <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
Date:   Fri, 25 Mar 2022 17:25:21 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a6de80em.fsf@toke.dk>
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

Maxime Bizon <mbizon@freebox.fr> writes:

> On Thu, 2022-03-24 at 12:26 -0700, Linus Torvalds wrote:
>
>> 
>> It's actually very natural in that situation to flush the caches from
>> the CPU side again. And so dma_sync_single_for_device() is a fairly
>> reasonable thing to do in that situation.
>> 
>
> In the non-cache-coherent scenario, and assuming dma_map() did an
> initial cache invalidation, you can write this:
>
> rx_buffer_complete_1(buf)
> {
> 	invalidate_cache(buf, size)
> 	if (!is_ready(buf))
> 		return;
> 	<proceed with receive>
> }
>
> or 
>
> rx_buffer_complete_2(buf)
> {
> 	if (!is_ready(buf)) {
> 		invalidate_cache(buf, size)
> 		return;
> 	}
> 	<proceed with receive>
> }
>
> The latter is preferred for performance because dma_map() did the
> initial invalidate.
>
> Of course you could write:
>
> rx_buffer_complete_3(buf)
> {
> 	invalidate_cache(buf, size)
> 	if
> (!is_ready(buf)) {
> 		invalidate_cache(buf, size)
> 		return;
> 	}
> 	
> <proceed with receive>
> }
>
>
> but it's a waste of CPU cycles
>
> So I'd be very cautious assuming sync_for_cpu() and sync_for_device()
> are both doing invalidation in existing implementation of arch DMA ops,
> implementers may have taken some liberty around DMA-API to avoid
> unnecessary cache operation (not to blame them).

I sense an implicit "and the driver can't (or shouldn't) influence
this" here, right?

> For example looking at arch/arm/mm/dma-mapping.c, for DMA_FROM_DEVICE
>
> sync_single_for_device()
>   => __dma_page_cpu_to_dev()
>     => dma_cache_maint_page(op=dmac_map_area)
>       => cpu_cache.dma_map_area()
>
> sync_single_for_cpu()
>   => __dma_page_dev_to_cpu()
>     =>
> __dma_page_cpu_to_dev(op=dmac_unmap_area)
>       =>
> cpu_cache.dma_unmap_area()
>
> dma_map_area() always does cache invalidate.
>
> But for a couple of CPU variant, dma_unmap_area() is a noop, so
> sync_for_cpu() does nothing.
>
> Toke's patch will break ath9k on those platforms (mostly silent
> breakage, rx corruption leading to bad performance)

Okay, so that would be bad obviously. So if I'm reading you correctly
(cf my question above), we can't fix this properly from the driver side,
and we should go with the partial SWIOTLB revert instead?

-Toke
