Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29BB83803
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbfHFRjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:39:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:3801 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387490AbfHFRjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 13:39:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 10:39:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="174242846"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga008.fm.intel.com with ESMTP; 06 Aug 2019 10:39:46 -0700
Date:   Tue, 6 Aug 2019 10:39:46 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     john.hubbard@gmail.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 01/34] mm/gup: add make_dirty arg to
 put_user_pages_dirty_lock()
Message-ID: <20190806173945.GA4748@iweiny-DESK2.sc.intel.com>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
 <20190804224915.28669-2-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190804224915.28669-2-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 03:48:42PM -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> Provide a more capable variation of put_user_pages_dirty_lock(),
> and delete put_user_pages_dirty(). This is based on the
> following:
> 
> 1. Lots of call sites become simpler if a bool is passed
> into put_user_page*(), instead of making the call site
> choose which put_user_page*() variant to call.
> 
> 2. Christoph Hellwig's observation that set_page_dirty_lock()
> is usually correct, and set_page_dirty() is usually a
> bug, or at least questionable, within a put_user_page*()
> calling chain.
> 
> This leads to the following API choices:
> 
>     * put_user_pages_dirty_lock(page, npages, make_dirty)
> 
>     * There is no put_user_pages_dirty(). You have to
>       hand code that, in the rare case that it's
>       required.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/infiniband/core/umem.c             |   5 +-
>  drivers/infiniband/hw/hfi1/user_pages.c    |   5 +-
>  drivers/infiniband/hw/qib/qib_user_pages.c |  13 +--
>  drivers/infiniband/hw/usnic/usnic_uiom.c   |   5 +-
>  drivers/infiniband/sw/siw/siw_mem.c        |  19 +---
>  include/linux/mm.h                         |   5 +-
>  mm/gup.c                                   | 115 +++++++++------------
>  7 files changed, 61 insertions(+), 106 deletions(-)
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index 08da840ed7ee..965cf9dea71a 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -54,10 +54,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
>  
>  	for_each_sg_page(umem->sg_head.sgl, &sg_iter, umem->sg_nents, 0) {
>  		page = sg_page_iter_page(&sg_iter);
> -		if (umem->writable && dirty)
> -			put_user_pages_dirty_lock(&page, 1);
> -		else
> -			put_user_page(page);
> +		put_user_pages_dirty_lock(&page, 1, umem->writable && dirty);
>  	}
>  
>  	sg_free_table(&umem->sg_head);
> diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
> index b89a9b9aef7a..469acb961fbd 100644
> --- a/drivers/infiniband/hw/hfi1/user_pages.c
> +++ b/drivers/infiniband/hw/hfi1/user_pages.c
> @@ -118,10 +118,7 @@ int hfi1_acquire_user_pages(struct mm_struct *mm, unsigned long vaddr, size_t np
>  void hfi1_release_user_pages(struct mm_struct *mm, struct page **p,
>  			     size_t npages, bool dirty)
>  {
> -	if (dirty)
> -		put_user_pages_dirty_lock(p, npages);
> -	else
> -		put_user_pages(p, npages);
> +	put_user_pages_dirty_lock(p, npages, dirty);
>  
>  	if (mm) { /* during close after signal, mm can be NULL */
>  		atomic64_sub(npages, &mm->pinned_vm);
> diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
> index bfbfbb7e0ff4..26c1fb8d45cc 100644
> --- a/drivers/infiniband/hw/qib/qib_user_pages.c
> +++ b/drivers/infiniband/hw/qib/qib_user_pages.c
> @@ -37,15 +37,6 @@
>  
>  #include "qib.h"
>  
> -static void __qib_release_user_pages(struct page **p, size_t num_pages,
> -				     int dirty)
> -{
> -	if (dirty)
> -		put_user_pages_dirty_lock(p, num_pages);
> -	else
> -		put_user_pages(p, num_pages);
> -}
> -
>  /**
>   * qib_map_page - a safety wrapper around pci_map_page()
>   *
> @@ -124,7 +115,7 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
>  
>  	return 0;
>  bail_release:
> -	__qib_release_user_pages(p, got, 0);
> +	put_user_pages_dirty_lock(p, got, false);
>  bail:
>  	atomic64_sub(num_pages, &current->mm->pinned_vm);
>  	return ret;
> @@ -132,7 +123,7 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
>  
>  void qib_release_user_pages(struct page **p, size_t num_pages)
>  {
> -	__qib_release_user_pages(p, num_pages, 1);
> +	put_user_pages_dirty_lock(p, num_pages, true);
>  
>  	/* during close after signal, mm can be NULL */
>  	if (current->mm)
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> index 0b0237d41613..62e6ffa9ad78 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -75,10 +75,7 @@ static void usnic_uiom_put_pages(struct list_head *chunk_list, int dirty)
>  		for_each_sg(chunk->page_list, sg, chunk->nents, i) {
>  			page = sg_page(sg);
>  			pa = sg_phys(sg);
> -			if (dirty)
> -				put_user_pages_dirty_lock(&page, 1);
> -			else
> -				put_user_page(page);
> +			put_user_pages_dirty_lock(&page, 1, dirty);
>  			usnic_dbg("pa: %pa\n", &pa);
>  		}
>  		kfree(chunk);
> diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
> index 67171c82b0c4..1e197753bf2f 100644
> --- a/drivers/infiniband/sw/siw/siw_mem.c
> +++ b/drivers/infiniband/sw/siw/siw_mem.c
> @@ -60,20 +60,6 @@ struct siw_mem *siw_mem_id2obj(struct siw_device *sdev, int stag_index)
>  	return NULL;
>  }
>  
> -static void siw_free_plist(struct siw_page_chunk *chunk, int num_pages,
> -			   bool dirty)
> -{
> -	struct page **p = chunk->plist;
> -
> -	while (num_pages--) {
> -		if (!PageDirty(*p) && dirty)
> -			put_user_pages_dirty_lock(p, 1);
> -		else
> -			put_user_page(*p);
> -		p++;
> -	}
> -}
> -
>  void siw_umem_release(struct siw_umem *umem, bool dirty)
>  {
>  	struct mm_struct *mm_s = umem->owning_mm;
> @@ -82,8 +68,9 @@ void siw_umem_release(struct siw_umem *umem, bool dirty)
>  	for (i = 0; num_pages; i++) {
>  		int to_free = min_t(int, PAGES_PER_CHUNK, num_pages);
>  
> -		siw_free_plist(&umem->page_chunk[i], to_free,
> -			       umem->writable && dirty);
> +		put_user_pages_dirty_lock(umem->page_chunk[i].plist,
> +					  to_free,
> +					  umem->writable && dirty);
>  		kfree(umem->page_chunk[i].plist);
>  		num_pages -= to_free;
>  	}
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0334ca97c584..9759b6a24420 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1057,8 +1057,9 @@ static inline void put_user_page(struct page *page)
>  	put_page(page);
>  }
>  
> -void put_user_pages_dirty(struct page **pages, unsigned long npages);
> -void put_user_pages_dirty_lock(struct page **pages, unsigned long npages);
> +void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
> +			       bool make_dirty);
> +
>  void put_user_pages(struct page **pages, unsigned long npages);
>  
>  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> diff --git a/mm/gup.c b/mm/gup.c
> index 98f13ab37bac..7fefd7ab02c4 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -29,85 +29,70 @@ struct follow_page_context {
>  	unsigned int page_mask;
>  };
>  
> -typedef int (*set_dirty_func_t)(struct page *page);
> -
> -static void __put_user_pages_dirty(struct page **pages,
> -				   unsigned long npages,
> -				   set_dirty_func_t sdf)
> -{
> -	unsigned long index;
> -
> -	for (index = 0; index < npages; index++) {
> -		struct page *page = compound_head(pages[index]);
> -
> -		/*
> -		 * Checking PageDirty at this point may race with
> -		 * clear_page_dirty_for_io(), but that's OK. Two key cases:
> -		 *
> -		 * 1) This code sees the page as already dirty, so it skips
> -		 * the call to sdf(). That could happen because
> -		 * clear_page_dirty_for_io() called page_mkclean(),
> -		 * followed by set_page_dirty(). However, now the page is
> -		 * going to get written back, which meets the original
> -		 * intention of setting it dirty, so all is well:
> -		 * clear_page_dirty_for_io() goes on to call
> -		 * TestClearPageDirty(), and write the page back.
> -		 *
> -		 * 2) This code sees the page as clean, so it calls sdf().
> -		 * The page stays dirty, despite being written back, so it
> -		 * gets written back again in the next writeback cycle.
> -		 * This is harmless.
> -		 */
> -		if (!PageDirty(page))
> -			sdf(page);
> -
> -		put_user_page(page);
> -	}
> -}
> -
>  /**
> - * put_user_pages_dirty() - release and dirty an array of gup-pinned pages
> - * @pages:  array of pages to be marked dirty and released.
> + * put_user_pages_dirty_lock() - release and optionally dirty gup-pinned pages
> + * @pages:  array of pages to be maybe marked dirty, and definitely released.

Better would be.

@pages:  array of pages to be put

>   * @npages: number of pages in the @pages array.
> + * @make_dirty: whether to mark the pages dirty
>   *
>   * "gup-pinned page" refers to a page that has had one of the get_user_pages()
>   * variants called on that page.
>   *
>   * For each page in the @pages array, make that page (or its head page, if a
> - * compound page) dirty, if it was previously listed as clean. Then, release
> - * the page using put_user_page().
> + * compound page) dirty, if @make_dirty is true, and if the page was previously
> + * listed as clean. In any case, releases all pages using put_user_page(),
> + * possibly via put_user_pages(), for the non-dirty case.

I don't think users of this interface need this level of detail.  I think
something like.

 * For each page in the @pages array, release the page.  If @make_dirty is
 * true, mark the page dirty prior to release.


>   *
>   * Please see the put_user_page() documentation for details.
>   *
> - * set_page_dirty(), which does not lock the page, is used here.
> - * Therefore, it is the caller's responsibility to ensure that this is
> - * safe. If not, then put_user_pages_dirty_lock() should be called instead.
> + * set_page_dirty_lock() is used internally. If instead, set_page_dirty() is
> + * required, then the caller should a) verify that this is really correct,
> + * because _lock() is usually required, and b) hand code it:
> + * set_page_dirty_lock(), put_user_page().
>   *
>   */
> -void put_user_pages_dirty(struct page **pages, unsigned long npages)
> +void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
> +			       bool make_dirty)
>  {
> -	__put_user_pages_dirty(pages, npages, set_page_dirty);
> -}
> -EXPORT_SYMBOL(put_user_pages_dirty);
> +	unsigned long index;
>  
> -/**
> - * put_user_pages_dirty_lock() - release and dirty an array of gup-pinned pages
> - * @pages:  array of pages to be marked dirty and released.
> - * @npages: number of pages in the @pages array.
> - *
> - * For each page in the @pages array, make that page (or its head page, if a
> - * compound page) dirty, if it was previously listed as clean. Then, release
> - * the page using put_user_page().
> - *
> - * Please see the put_user_page() documentation for details.
> - *
> - * This is just like put_user_pages_dirty(), except that it invokes
> - * set_page_dirty_lock(), instead of set_page_dirty().
> - *
> - */
> -void put_user_pages_dirty_lock(struct page **pages, unsigned long npages)
> -{
> -	__put_user_pages_dirty(pages, npages, set_page_dirty_lock);
> +	/*
> +	 * TODO: this can be optimized for huge pages: if a series of pages is
> +	 * physically contiguous and part of the same compound page, then a
> +	 * single operation to the head page should suffice.
> +	 */

I think this comment belongs to the for loop below...  or just something about
how to make this and put_user_pages() more efficient.  It is odd, that this is
the same comment as in put_user_pages()...

The code is good.  So... Other than the comments.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Ira

> +
> +	if (!make_dirty) {
> +		put_user_pages(pages, npages);
> +		return;
> +	}
> +
> +	for (index = 0; index < npages; index++) {
> +		struct page *page = compound_head(pages[index]);
> +		/*
> +		 * Checking PageDirty at this point may race with
> +		 * clear_page_dirty_for_io(), but that's OK. Two key
> +		 * cases:
> +		 *
> +		 * 1) This code sees the page as already dirty, so it
> +		 * skips the call to set_page_dirty(). That could happen
> +		 * because clear_page_dirty_for_io() called
> +		 * page_mkclean(), followed by set_page_dirty().
> +		 * However, now the page is going to get written back,
> +		 * which meets the original intention of setting it
> +		 * dirty, so all is well: clear_page_dirty_for_io() goes
> +		 * on to call TestClearPageDirty(), and write the page
> +		 * back.
> +		 *
> +		 * 2) This code sees the page as clean, so it calls
> +		 * set_page_dirty(). The page stays dirty, despite being
> +		 * written back, so it gets written back again in the
> +		 * next writeback cycle. This is harmless.
> +		 */
> +		if (!PageDirty(page))
> +			set_page_dirty_lock(page);
> +		put_user_page(page);
> +	}
>  }
>  EXPORT_SYMBOL(put_user_pages_dirty_lock);
>  
> -- 
> 2.22.0
> 
