Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C7A2D36B3
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbgLHXIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:08:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbgLHXIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 18:08:32 -0500
Date:   Tue, 8 Dec 2020 15:07:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607468872;
        bh=nHqLjGa7WrRpzyyp54HyHUJiZs7T5K709l/dHW3MvIo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=jiTAcSlBteT4edoQqPTbYzc9uZN9uGlK31Aq295tsGDqB7M+JyZSlP6IxdD6I5pP4
         5Z/EGkrqlHe8qaG/mf4k1o8rCzZ+l4PNjF/S/ZxcG4ggilpGJsuCEX6k4UIjQEHNf0
         CgF7KS6xiA1VOTHsOi9d8Y//20JXs4RGDEaSa06H6OKBSDaHUJs5vsl1SdcQfLKFls
         l7SiKB+GkxgcuYSdCFE8rdiF+80vK0d2RwM7B0MpwQtOT51egmKfnfhctX6YyP+KpF
         AMM7qf+hEoZsL+JsFThaMYWKdBabzmB9S4GVrkMiQWXjk4A2WCZnh106CdZ9xou7hC
         SsE+EkqZQzRyw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
Message-ID: <20201208150750.75afc991@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAGngYiVp2u-A07rrkbeJCbqPW9efjkJUNC+NBxrtCM2JtXGpVA@mail.gmail.com>
References: <20201206034408.31492-1-TheSven73@gmail.com>
        <20201206034408.31492-2-TheSven73@gmail.com>
        <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
        <20201208225125.GA2602479@lunn.ch>
        <CAGngYiVp2u-A07rrkbeJCbqPW9efjkJUNC+NBxrtCM2JtXGpVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 18:02:30 -0500 Sven Van Asbroeck wrote:
> On Tue, Dec 8, 2020 at 5:51 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > So I assumed that it's a PCIe dma bandwidth issue, but I could be wrong -
> > > I didn't do any PCIe bandwidth measurements.  
> >
> > Sometimes it is actually cache operations which take all the
> > time. This needs to invalidate the cache, so that when the memory is
> > then accessed, it get fetched from RAM. On SMP machines, cache
> > invalidation can be expensive, due to all the cross CPU operations.
> > I've actually got better performance by building a UP kernel on some
> > low core count ARM CPUs.
> >
> > There are some tricks which can be played. Do you actually need all
> > 9K? Does the descriptor tell you actually how much is used? You can
> > get a nice speed up if you just unmap 64 bytes for a TCP ACK, rather
> > than the full 9K.

Good point!

> Thank you for the suggestion! The original driver developer chose 9K because
> presumably that's the largest frame size supported by the chip.
> 
> Yes, I believe the chip will tell us via the descriptor how much it has
> written, I would have to double-check. I was already looking for a
> "trick" to transfer only the required number of bytes, but I was led to
> believe that dma_map_single() and dma_unmap_single() always needed to match.
> 
> So:
> dma_map_single(9K) followed by dma_unmap_single(9K) is correct, and
> dma_map_single(9K) followed by dma_unmap_single(1500 bytes) means trouble.
> 
> How can we get around that?

You can set DMA_ATTR_SKIP_CPU_SYNC and then sync only the part of the
buffer that got written.
