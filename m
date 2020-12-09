Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3850F2D43F9
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbgLIOLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:11:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46442 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732758AbgLIOKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 09:10:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn0AG-00B3sU-Q5; Wed, 09 Dec 2020 15:09:56 +0100
Date:   Wed, 9 Dec 2020 15:09:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
Message-ID: <20201209140956.GC2611606@lunn.ch>
References: <20201206034408.31492-1-TheSven73@gmail.com>
 <20201206034408.31492-2-TheSven73@gmail.com>
 <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
 <20201208225125.GA2602479@lunn.ch>
 <CAGngYiVp2u-A07rrkbeJCbqPW9efjkJUNC+NBxrtCM2JtXGpVA@mail.gmail.com>
 <3aed88da-8e82-3bd0-6822-d30f1bd5ec9e@gmail.com>
 <CAGngYiUvJE+L4-tw91ozPaq7mGUbh0PS0q7MpLnHVwDqGrFwEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGngYiUvJE+L4-tw91ozPaq7mGUbh0PS0q7MpLnHVwDqGrFwEw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 10:49:16PM -0500, Sven Van Asbroeck wrote:
> On Tue, Dec 8, 2020 at 6:36 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> > dma_sync_single_for_{cpu,device} is what you would need in order to make
> > a partial cache line invalidation. You would still need to unmap the
> > same address+length pair that was used for the initial mapping otherwise
> > the DMA-API debugging will rightfully complain.
> 
> I tried replacing
>     dma_unmap_single(9K, DMA_FROM_DEVICE);
> with
>     dma_sync_single_for_cpu(received_size=1500 bytes, DMA_FROM_DEVICE);
>     dma_unmap_single_attrs(9K, DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
> 
> and that works! But the bandwidth is still pretty bad, because the cpu
> now spends most of its time doing
>     dma_map_single(9K, DMA_FROM_DEVICE);
> which spends a lot of time doing __dma_page_cpu_to_dev.

9K is not a nice number, since for each allocation it probably has to
find 4 contiguous pages. See what the performance difference is with
2K, 4K and 8K. If there is a big difference, you might want to special
case when the MTU is set for jumbo packets, or check if the hardware
can do scatter/gather.

You also need to be careful with caches and speculation. As you have
seen, bad things can happen. And it can be a lot more subtle. If some
code is accessing the page before the buffer and gets towards the end
of the page, the CPU might speculatively bring in the next page, i.e
the start of the buffer. If that happens before the DMA operation, and
you don't invalidate the cache correctly, you get hard to find
corruption.

    Andrew
