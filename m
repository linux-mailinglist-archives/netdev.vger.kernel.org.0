Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1003F36307D
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 15:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhDQN5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 09:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDQN5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 09:57:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5156AC061574;
        Sat, 17 Apr 2021 06:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xqgFJlR+jU3BMFPCC8NQxTzbFxfigD7vTUNnUGq4vIY=; b=SZN1IHMPzUuDEQpeH8U5/v7rff
        H6wrF1LIVDWRSRtlMXzSRwuAre+050GPjLA2iogcsGTXqqfEDGxaC4rXfUbOM25eg0E50CHt5+SJL
        1DjWYV0FM+08rQ1DpvQpoRCUX1YJJPp0dedZYxJ9aY2NaXbG+K3aifWyE0y411QrrJCRsyswU33Sa
        YbZV2+Q8TcIZK7v5N7lFZg8nXNefltcXpFfCGcJzW2rxXoRzVgIZbtuchtRjCKjJct4ZvMbIHXCjN
        otbSGYMAGgTgXFZOZWNCv3haV2wRKBJOwIRzHCU6S+6H0uqypx9YY5LVvS6Yy/6PQ424wGJ7CYdGm
        5eCR6yHQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXlRC-00BJyr-Q7; Sat, 17 Apr 2021 13:56:47 +0000
Date:   Sat, 17 Apr 2021 14:56:42 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        David Laight <David.Laight@aculab.com>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210417135642.GR2531743@casper.infradead.org>
References: <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon>
 <20210414213556.GY2531743@casper.infradead.org>
 <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com>
 <20210415200832.32796445@carbon>
 <20210416152755.GL2531743@casper.infradead.org>
 <CAK8P3a2dekzohOrHpLq6yyuaoyC4UOxxucu6kX2oddeq5Jdqfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2dekzohOrHpLq6yyuaoyC4UOxxucu6kX2oddeq5Jdqfg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 12:31:37PM +0200, Arnd Bergmann wrote:
> On Fri, Apr 16, 2021 at 5:27 PM Matthew Wilcox <willy@infradead.org> wrote:
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index b5b195305346..db7c7020746a 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -198,7 +198,17 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
> >
> >  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
> >  {
> > -       return page->dma_addr;
> > +       dma_addr_t ret = page->dma_addr[0];
> > +       if (sizeof(dma_addr_t) > sizeof(unsigned long))
> > +               ret |= (dma_addr_t)page->dma_addr[1] << 32;
> > +       return ret;
> > +}
> 
> Have you considered using a PFN type address here? I suspect you
> can prove that shifting the DMA address by PAGE_BITS would
> make it fit into an 'unsigned long' on all 32-bit architectures with
> 64-bit dma_addr_t. This requires that page->dma_addr to be
> page aligned, as well as fit into 44 bits. I recently went through the
> maximum address space per architecture to define a
> MAX_POSSIBLE_PHYSMEM_BITS, and none of them have more than
> 40 here, presumably the same is true for dma address space.

I wouldn't like to make that assumption.  I've come across IOMMUs (maybe
on parisc?  powerpc?) that like to encode fun information in the top
few bits.  So we could get it down to 52 bits, but I don't think we can
get all the way down to 32 bits.  Also, we need to keep the bottom bit
clear for PageTail, so that further constrains us.

Anyway, I like the "two unsigned longs" approach I posted yesterday,
but thanks for the suggestion.
