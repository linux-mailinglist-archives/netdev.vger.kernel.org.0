Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17D635B2D2
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 11:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhDKJnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 05:43:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235005AbhDKJnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 05:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618134204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XOqiznYAiRVy/Amk28LrMWkmWtJUIVRZ/la5M97wHQ8=;
        b=PW4Lm6wjf4mSk5odkTwUl7lDbOk0iTQ5225/1e5O/aa+GBTXSvdFJAAyCqoDEy1Gixg0z3
        CCeSgfbgENxnPJ/m5+WOalyz/y05Kg3QeKYXlOK9vN8doFN6bf4RS4Yvvh5JXDKicOmyKm
        9RNoLiOT2M2TfR6aYQiBLSElz9yjX/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-iowazDUgNc61YX-AnGHs-A-1; Sun, 11 Apr 2021 05:43:21 -0400
X-MC-Unique: iowazDUgNc61YX-AnGHs-A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92CFA501FB;
        Sun, 11 Apr 2021 09:43:18 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B66045D9D3;
        Sun, 11 Apr 2021 09:43:10 +0000 (UTC)
Date:   Sun, 11 Apr 2021 11:43:07 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, brouer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210411114307.5087f958@carbon>
In-Reply-To: <20210410205246.507048-2-willy@infradead.org>
References: <20210410205246.507048-1-willy@infradead.org>
        <20210410205246.507048-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Apr 2021 21:52:45 +0100
"Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> 32-bit architectures which expect 8-byte alignment for 8-byte integers
> and need 64-bit DMA addresses (arc, arm, mips, ppc) had their struct
> page inadvertently expanded in 2019.  When the dma_addr_t was added,
> it forced the alignment of the union to 8 bytes, which inserted a 4 byte
> gap between 'flags' and the union.
> 
> We could fix this by telling the compiler to use a smaller alignment
> for the dma_addr, but that seems a little fragile.  Instead, move the
> 'flags' into the union.  That causes dma_addr to shift into the same
> bits as 'mapping', so it would have to be cleared on free.  To avoid
> this, insert three words of padding and use the same bits as ->index
> and ->private, neither of which have to be cleared on free.
> 
> Fixes: c25fff7171be ("mm: add dma_addr_t to struct page")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm_types.h | 38 ++++++++++++++++++++++++++------------
>  1 file changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6613b26a8894..45c563e9b50e 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -68,16 +68,22 @@ struct mem_cgroup;
>  #endif
>  
>  struct page {
> -	unsigned long flags;		/* Atomic flags, some possibly
> -					 * updated asynchronously */
>  	/*
> -	 * Five words (20/40 bytes) are available in this union.
> -	 * WARNING: bit 0 of the first word is used for PageTail(). That
> -	 * means the other users of this union MUST NOT use the bit to
> +	 * This union is six words (24 / 48 bytes) in size.
> +	 * The first word is reserved for atomic flags, often updated
> +	 * asynchronously.  Use the PageFoo() macros to access it.  Some
> +	 * of the flags can be reused for your own purposes, but the
> +	 * word as a whole often contains other information and overwriting
> +	 * it will cause functions like page_zone() and page_node() to stop
> +	 * working correctly.
> +	 *
> +	 * Bit 0 of the second word is used for PageTail(). That
> +	 * means the other users of this union MUST leave the bit zero to
>  	 * avoid collision and false-positive PageTail().
>  	 */
>  	union {
>  		struct {	/* Page cache and anonymous pages */
> +			unsigned long flags;
>  			/**
>  			 * @lru: Pageout list, eg. active_list protected by
>  			 * lruvec->lru_lock.  Sometimes used as a generic list
> @@ -96,13 +102,14 @@ struct page {
>  			unsigned long private;
>  		};
>  		struct {	/* page_pool used by netstack */
> -			/**
> -			 * @dma_addr: might require a 64-bit value even on
> -			 * 32-bit architectures.
> -			 */
> -			dma_addr_t dma_addr;

The original intend of placing member @dma_addr here is that it overlap
with @LRU (type struct list_head) which contains two pointers.  Thus, in
case of CONFIG_ARCH_DMA_ADDR_T_64BIT=y on 32-bit architectures it would
use both pointers.

Thinking more about this, this design is flawed as bit 0 of the first
word is used for compound pages (see PageTail and @compound_head), is
reserved.  We knew DMA addresses were aligned, thus we though this
satisfied that need.  BUT for DMA_ADDR_T_64BIT=y on 32-bit arch the
first word will contain the "upper" part of the DMA addr, which I don't
think gives this guarantee.

I guess, nobody are using this combination?!?  I though we added this
to satisfy TI (Texas Instrument) driver cpsw (code in
drivers/net/ethernet/ti/cpsw*).  Thus, I assumed it was in use?


> +			unsigned long _pp_flags;
> +			unsigned long pp_magic;
> +			unsigned long xmi;

Matteo notice, I think intent is we can store xdp_mem_info in @xmi.

> +			unsigned long _pp_mapping_pad;
> +			dma_addr_t dma_addr;	/* might be one or two words */
>  		};

Could you explain your intent here?
I worry about @index.

As I mentioned in other thread[1] netstack use page_is_pfmemalloc()
(code copy-pasted below signature) which imply that the member @index
have to be kept intact. In above, I'm unsure @index is untouched.

[1] https://lore.kernel.org/lkml/20210410082158.79ad09a6@carbon/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

/*
 * Return true only if the page has been allocated with
 * ALLOC_NO_WATERMARKS and the low watermark was not
 * met implying that the system is under some pressure.
 */
static inline bool page_is_pfmemalloc(const struct page *page)
{
	/*
	 * Page index cannot be this large so this must be
	 * a pfmemalloc page.
	 */
	return page->index == -1UL;
}

/*
 * Only to be called by the page allocator on a freshly allocated
 * page.
 */
static inline void set_page_pfmemalloc(struct page *page)
{
	page->index = -1UL;
}

static inline void clear_page_pfmemalloc(struct page *page)
{
	page->index = 0;
}

