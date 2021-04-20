Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564D436579B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhDTLdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhDTLd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 07:33:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C87C06174A;
        Tue, 20 Apr 2021 04:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OtJQAIKOLywPfylP974VGHUtk1ChEQJ4QJMSIhZUTcM=; b=UMJW1hHSEiHIxuYPCmIWqBggcQ
        7WzgUBYVndXaDyXAvzCaYB++gpfwEmHNwcJBnPHtzISKsXmtj7AQs66KzH/ShiOiEtQuDh6NS2jIC
        danHUqryMov77SaH6PzoCADuqO3OzNjDqitfmMV+5e2ij2f/eQn8q0rI3BSCdyVR8nX+Pl804z8dc
        ldQ6kKGtMIdM7D4SV/a4MiZzQWbt8sK61uwSWkb4CyJGIIQITh5cNWfGAWVtLKBLsiDOb1BvlHnDO
        0piIzcx7W6HJ167GMu1pCWEDcEpmybbhNafNeikjjMqwGNrP1EWY58fAR82XU78U2KE8ASVsO54t6
        xTFN7DAg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lYoc4-00F6IN-8G; Tue, 20 Apr 2021 11:32:24 +0000
Date:   Tue, 20 Apr 2021 12:32:16 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        mcroce@linux.microsoft.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        arcml <linux-snps-arc@lists.infradead.org>,
        Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210420113216.GA3596236@casper.infradead.org>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org>
 <CAMuHMdXm1Zg=Wm-=tn5jUJwqVGUvCi5yDaW0PXWC2DEDYGcy5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXm1Zg=Wm-=tn5jUJwqVGUvCi5yDaW0PXWC2DEDYGcy5A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 09:39:54AM +0200, Geert Uytterhoeven wrote:
> > +++ b/include/linux/mm_types.h
> > @@ -97,10 +97,10 @@ struct page {
> >                 };
> >                 struct {        /* page_pool used by netstack */
> >                         /**
> > -                        * @dma_addr: might require a 64-bit value even on
> > +                        * @dma_addr: might require a 64-bit value on
> >                          * 32-bit architectures.
> >                          */
> > -                       dma_addr_t dma_addr;
> > +                       unsigned long dma_addr[2];
> 
> So we get two 64-bit words on 64-bit platforms, while only one is
> needed?

Not really.  This is part of the 5-word union in struct page, so the space
ends up being reserved anyway, event if it's not "assigned" to dma_addr.

> > +       dma_addr_t ret = page->dma_addr[0];
> > +       if (sizeof(dma_addr_t) > sizeof(unsigned long))
> > +               ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
> 
> We don't seem to have a handy macro for a 32-bit left shift yet...
> 
> But you can also avoid the warning using
> 
>     ret |= (u64)page->dma_addr[1] << 32;

Sure.  It doesn't really matter which way we eliminate the warning;
the code is unreachable.

> > +{
> > +       page->dma_addr[0] = addr;
> > +       if (sizeof(dma_addr_t) > sizeof(unsigned long))
> > +               page->dma_addr[1] = addr >> 16 >> 16;
> 
> ... but we do have upper_32_bits() for a 32-bit right shift.

Yep, that's what my current tree looks like.
