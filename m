Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FC535B32F
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 12:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhDKKdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 06:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhDKKdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 06:33:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B36C061574;
        Sun, 11 Apr 2021 03:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5k6scgEO0Liw53Nd/CWv1w1ZPoYPba04K+Obtfiig/M=; b=UlE+P4Kkm1ME3C0ZL37PlH2Hnx
        jnR+orvGDjexhh1QJxhvp4T6/QphMALkcuyrajBEyS7VaVALxvY7d7bPkkLauHaZNdhSagJLhtT+F
        BkqNRS2cBSjC8xse6AgrMMiPAFkhXzauNOUrrSu23znATccsY56ohHTCRrzqjox4zNyhhdYk7TySL
        5QbkG9h9z4Jphgv4bRVDtw7kv7WMN1OlvCgVBd0TQngSpYco1PVSB4RNyugOoo/k1O8AXx4Bb1duv
        9o0DqdhbIBV/NEgsoipCkf930mj7BQhWStT0lYIoJJPMiFjtkG6i0+rRuyG+Nl3CoxLYUdizqdwdV
        lH96aDRA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lVXP4-002pvE-H5; Sun, 11 Apr 2021 10:33:19 +0000
Date:   Sun, 11 Apr 2021 11:33:18 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210411103318.GC2531743@casper.infradead.org>
References: <20210410205246.507048-1-willy@infradead.org>
 <20210410205246.507048-2-willy@infradead.org>
 <20210411114307.5087f958@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411114307.5087f958@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 11:43:07AM +0200, Jesper Dangaard Brouer wrote:
> On Sat, 10 Apr 2021 21:52:45 +0100
> "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:
> 
> > 32-bit architectures which expect 8-byte alignment for 8-byte integers
> > and need 64-bit DMA addresses (arc, arm, mips, ppc) had their struct
> > page inadvertently expanded in 2019.  When the dma_addr_t was added,
> > it forced the alignment of the union to 8 bytes, which inserted a 4 byte
> > gap between 'flags' and the union.
> > 
> > We could fix this by telling the compiler to use a smaller alignment
> > for the dma_addr, but that seems a little fragile.  Instead, move the
> > 'flags' into the union.  That causes dma_addr to shift into the same
> > bits as 'mapping', so it would have to be cleared on free.  To avoid
> > this, insert three words of padding and use the same bits as ->index
> > and ->private, neither of which have to be cleared on free.
> > 
> > Fixes: c25fff7171be ("mm: add dma_addr_t to struct page")
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  include/linux/mm_types.h | 38 ++++++++++++++++++++++++++------------
> >  1 file changed, 26 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 6613b26a8894..45c563e9b50e 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -68,16 +68,22 @@ struct mem_cgroup;
> >  #endif
> >  
> >  struct page {
> > -	unsigned long flags;		/* Atomic flags, some possibly
> > -					 * updated asynchronously */
> >  	/*
> > -	 * Five words (20/40 bytes) are available in this union.
> > -	 * WARNING: bit 0 of the first word is used for PageTail(). That
> > -	 * means the other users of this union MUST NOT use the bit to
> > +	 * This union is six words (24 / 48 bytes) in size.
> > +	 * The first word is reserved for atomic flags, often updated
> > +	 * asynchronously.  Use the PageFoo() macros to access it.  Some
> > +	 * of the flags can be reused for your own purposes, but the
> > +	 * word as a whole often contains other information and overwriting
> > +	 * it will cause functions like page_zone() and page_node() to stop
> > +	 * working correctly.
> > +	 *
> > +	 * Bit 0 of the second word is used for PageTail(). That
> > +	 * means the other users of this union MUST leave the bit zero to
> >  	 * avoid collision and false-positive PageTail().
> >  	 */
> >  	union {
> >  		struct {	/* Page cache and anonymous pages */
> > +			unsigned long flags;
> >  			/**
> >  			 * @lru: Pageout list, eg. active_list protected by
> >  			 * lruvec->lru_lock.  Sometimes used as a generic list
> > @@ -96,13 +102,14 @@ struct page {
> >  			unsigned long private;
> >  		};
> >  		struct {	/* page_pool used by netstack */
> > -			/**
> > -			 * @dma_addr: might require a 64-bit value even on
> > -			 * 32-bit architectures.
> > -			 */
> > -			dma_addr_t dma_addr;
> 
> The original intend of placing member @dma_addr here is that it overlap
> with @LRU (type struct list_head) which contains two pointers.  Thus, in
> case of CONFIG_ARCH_DMA_ADDR_T_64BIT=y on 32-bit architectures it would
> use both pointers.
> 
> Thinking more about this, this design is flawed as bit 0 of the first
> word is used for compound pages (see PageTail and @compound_head), is
> reserved.  We knew DMA addresses were aligned, thus we though this
> satisfied that need.  BUT for DMA_ADDR_T_64BIT=y on 32-bit arch the
> first word will contain the "upper" part of the DMA addr, which I don't
> think gives this guarantee.
> 
> I guess, nobody are using this combination?!?  I though we added this
> to satisfy TI (Texas Instrument) driver cpsw (code in
> drivers/net/ethernet/ti/cpsw*).  Thus, I assumed it was in use?

It may be in use, but we've got away with it?  It's relatively rare
that this is going to bite us.  I think what has to happen is:

page is mapped to userspace
task calls get_user_page_fast(), loads the PTE
<preempted>
page is unmapped & freed
page is reallocated to the page_pool
page is DMA mapped to an address that happens to have that bit set
<first task resumes>
task looks for the compound_head() of that PTE, and attempts to bump
the refcount.  *oops*

If it has happened, would it have turned into a bug report?
If we had seen such a bug report, would we have noticed it?

> > +			unsigned long _pp_flags;
> > +			unsigned long pp_magic;
> > +			unsigned long xmi;
> 
> Matteo notice, I think intent is we can store xdp_mem_info in @xmi.

Yep.

> > +			unsigned long _pp_mapping_pad;
> > +			dma_addr_t dma_addr;	/* might be one or two words */
> >  		};
> 
> Could you explain your intent here?
> I worry about @index.
> 
> As I mentioned in other thread[1] netstack use page_is_pfmemalloc()
> (code copy-pasted below signature) which imply that the member @index
> have to be kept intact. In above, I'm unsure @index is untouched.

Argh, I read that piece of your message, and then promptly forgot about
it.  I really don't like page_is_pfmemalloc() using the entirety of
page->index for this.  How about we just do what slab does anyway
and use PageActive for page_is_pfmemalloc()?

Basically, we have three aligned dwords here.  We can either alias with
@flags and the first word of @lru, or the second word of @lru and @mapping,
or @index and @private.  @flags is a non-starter.  If we use @mapping,
then you have to set it to NULL before you free it, and I'm not sure
how easy that will be for you.  If that's trivial, then we could use
the layout:

	unsigned long _pp_flags;
	unsigned long pp_magic;
	union {
		dma_addr_t dma_addr;    /* might be one or two words */
		unsigned long _pp_align[2];
	};
	unsigned long pp_pfmemalloc;
	unsigned long xmi;

