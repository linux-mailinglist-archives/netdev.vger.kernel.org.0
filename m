Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C0D104F6C
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfKUJjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:39:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:34446 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbfKUJjr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 04:39:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5D6CCB12B;
        Thu, 21 Nov 2019 09:39:43 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id EADB11E47FC; Thu, 21 Nov 2019 10:39:41 +0100 (CET)
Date:   Thu, 21 Nov 2019 10:39:41 +0100
From:   Jan Kara <jack@suse.cz>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 17/24] mm/gup: track FOLL_PIN pages
Message-ID: <20191121093941.GA18190@quack2.suse.cz>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-18-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191121071354.456618-18-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 20-11-19 23:13:47, John Hubbard wrote:
> Add tracking of pages that were pinned via FOLL_PIN.
> 
> As mentioned in the FOLL_PIN documentation, callers who effectively set
> FOLL_PIN are required to ultimately free such pages via put_user_page().
> The effect is similar to FOLL_GET, and may be thought of as "FOLL_GET
> for DIO and/or RDMA use".
> 
> Pages that have been pinned via FOLL_PIN are identifiable via a
> new function call:
> 
>    bool page_dma_pinned(struct page *page);
> 
> What to do in response to encountering such a page, is left to later
> patchsets. There is discussion about this in [1], [2], and [3].
> 
> This also changes a BUG_ON(), to a WARN_ON(), in follow_page_mask().
> 
> [1] Some slow progress on get_user_pages() (Apr 2, 2019):
>     https://lwn.net/Articles/784574/
> [2] DMA and get_user_pages() (LPC: Dec 12, 2018):
>     https://lwn.net/Articles/774411/
> [3] The trouble with get_user_pages() (Apr 30, 2018):
>     https://lwn.net/Articles/753027/
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Jérôme Glisse <jglisse@redhat.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Thanks for the patch! We are mostly getting there. Some smaller comments
below.

> +/**
> + * try_pin_compound_head() - mark a compound page as being used by
> + * pin_user_pages*().
> + *
> + * This is the FOLL_PIN counterpart to try_get_compound_head().
> + *
> + * @page:	pointer to page to be marked
> + * @Return:	true for success, false for failure
> + */
> +__must_check bool try_pin_compound_head(struct page *page, int refs)
> +{
> +	page = try_get_compound_head(page, GUP_PIN_COUNTING_BIAS * refs);
> +	if (!page)
> +		return false;
> +
> +	__update_proc_vmstat(page, NR_FOLL_PIN_REQUESTED, refs);
> +	return true;
> +}
> +
> +#ifdef CONFIG_DEV_PAGEMAP_OPS
> +static bool __put_devmap_managed_user_page(struct page *page)

Probably call this __unpin_devmap_managed_user_page()? To match the later
conversion of put_user_page() to unpin_user_page()?

> +{
> +	bool is_devmap = page_is_devmap_managed(page);
> +
> +	if (is_devmap) {
> +		int count = page_ref_sub_return(page, GUP_PIN_COUNTING_BIAS);
> +
> +		__update_proc_vmstat(page, NR_FOLL_PIN_RETURNED, 1);
> +		/*
> +		 * devmap page refcounts are 1-based, rather than 0-based: if
> +		 * refcount is 1, then the page is free and the refcount is
> +		 * stable because nobody holds a reference on the page.
> +		 */
> +		if (count == 1)
> +			free_devmap_managed_page(page);
> +		else if (!count)
> +			__put_page(page);
> +	}
> +
> +	return is_devmap;
> +}
> +#else
> +static bool __put_devmap_managed_user_page(struct page *page)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_DEV_PAGEMAP_OPS */
> +
> +/**
> + * put_user_page() - release a dma-pinned page
> + * @page:            pointer to page to be released
> + *
> + * Pages that were pinned via pin_user_pages*() must be released via either
> + * put_user_page(), or one of the put_user_pages*() routines. This is so that
> + * such pages can be separately tracked and uniquely handled. In particular,
> + * interactions with RDMA and filesystems need special handling.
> + */
> +void put_user_page(struct page *page)
> +{
> +	page = compound_head(page);
> +
> +	/*
> +	 * For devmap managed pages we need to catch refcount transition from
> +	 * GUP_PIN_COUNTING_BIAS to 1, when refcount reach one it means the
> +	 * page is free and we need to inform the device driver through
> +	 * callback. See include/linux/memremap.h and HMM for details.
> +	 */
> +	if (__put_devmap_managed_user_page(page))
> +		return;
> +
> +	if (page_ref_sub_and_test(page, GUP_PIN_COUNTING_BIAS))
> +		__put_page(page);
> +
> +	__update_proc_vmstat(page, NR_FOLL_PIN_RETURNED, 1);
> +}
> +EXPORT_SYMBOL(put_user_page);
> +
>  /**
>   * put_user_pages_dirty_lock() - release and optionally dirty gup-pinned pages
>   * @pages:  array of pages to be maybe marked dirty, and definitely released.
> @@ -237,10 +327,11 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
>  	}
>  
>  	page = vm_normal_page(vma, address, pte);
> -	if (!page && pte_devmap(pte) && (flags & FOLL_GET)) {
> +	if (!page && pte_devmap(pte) && (flags & (FOLL_GET | FOLL_PIN))) {
>  		/*
> -		 * Only return device mapping pages in the FOLL_GET case since
> -		 * they are only valid while holding the pgmap reference.
> +		 * Only return device mapping pages in the FOLL_GET or FOLL_PIN
> +		 * case since they are only valid while holding the pgmap
> +		 * reference.
>  		 */
>  		*pgmap = get_dev_pagemap(pte_pfn(pte), *pgmap);
>  		if (*pgmap)
> @@ -283,6 +374,11 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
>  			page = ERR_PTR(-ENOMEM);
>  			goto out;
>  		}
> +	} else if (flags & FOLL_PIN) {
> +		if (unlikely(!try_pin_page(page))) {
> +			page = ERR_PTR(-ENOMEM);
> +			goto out;
> +		}

Use grab_page() here?

>  	}
>  	if (flags & FOLL_TOUCH) {
>  		if ((flags & FOLL_WRITE) &&
> @@ -1890,9 +2000,15 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>  		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
>  		page = pte_page(pte);
>  
> -		head = try_get_compound_head(page, 1);
> -		if (!head)
> -			goto pte_unmap;
> +		if (flags & FOLL_PIN) {
> +			head = page;
> +			if (unlikely(!try_pin_page(head)))
> +				goto pte_unmap;
> +		} else {
> +			head = try_get_compound_head(page, 1);
> +			if (!head)
> +				goto pte_unmap;
> +		}

Why don't you use grab_page() here? Also you seem to loose the head =
compound_head(page) indirection here for the FOLL_PIN case?

>  
>  		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
>  			put_page(head);
> @@ -1946,12 +2062,20 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>  
>  		pgmap = get_dev_pagemap(pfn, pgmap);
>  		if (unlikely(!pgmap)) {
> -			undo_dev_pagemap(nr, nr_start, pages);
> +			undo_dev_pagemap(nr, nr_start, flags, pages);
>  			return 0;
>  		}
>  		SetPageReferenced(page);
>  		pages[*nr] = page;
> -		get_page(page);
> +
> +		if (flags & FOLL_PIN) {
> +			if (unlikely(!try_pin_page(page))) {
> +				undo_dev_pagemap(nr, nr_start, flags, pages);
> +				return 0;
> +			}
> +		} else
> +			get_page(page);
> +

Use grab_page() here?

>  		(*nr)++;
>  		pfn++;
>  	} while (addr += PAGE_SIZE, addr != end);
...
> @@ -2025,12 +2149,31 @@ static int __record_subpages(struct page *page, unsigned long addr,
>  	return nr;
>  }
>  
> -static void put_compound_head(struct page *page, int refs)
> +static bool grab_compound_head(struct page *head, int refs, unsigned int flags)
>  {
> +	if (flags & FOLL_PIN) {
> +		if (unlikely(!try_pin_compound_head(head, refs)))
> +			return false;
> +	} else {
> +		head = try_get_compound_head(head, refs);
> +		if (!head)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void put_compound_head(struct page *page, int refs, unsigned int flags)
> +{
> +	struct page *head = compound_head(page);
> +
> +	if (flags & FOLL_PIN)
> +		refs *= GUP_PIN_COUNTING_BIAS;
> +
>  	/* Do a get_page() first, in case refs == page->_refcount */
> -	get_page(page);
> -	page_ref_sub(page, refs);
> -	put_page(page);
> +	get_page(head);
> +	page_ref_sub(head, refs);
> +	put_page(head);
>  }
>  
>  #ifdef CONFIG_ARCH_HAS_HUGEPD
> @@ -2064,14 +2207,13 @@ static int gup_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
>  
>  	head = pte_page(pte);
>  	page = head + ((addr & (sz-1)) >> PAGE_SHIFT);
> -	refs = __record_subpages(page, addr, end, pages + *nr);
> +	refs = record_subpages(page, addr, end, pages + *nr);
>  
> -	head = try_get_compound_head(head, refs);
> -	if (!head)
> +	if (!grab_compound_head(head, refs, flags))

Are you sure this is correct? Historically we seem to have always had logic
like:

	head = compound_head(pte_page / pmd_page / ... (orig))

in this code. And you removed this now. Looking at the code I'm not sure
whether the compound_head() indirection is really needed or not. We seem to
have already huge page head in the page table but maybe there's some subtle
case I'm missing. So I'd be calmer if we left the head=compound_head(...)
in the code but if you really want to remove it, I'd like to see Ack from
someone actually familiar with huge pages - e.g. Kirill Shutemov...

And even if we find out that compound_head() indirection isn't really
needed, that is big enough change in the logic that it would deserve to be
done in a separate patch (if only for debugging by bisection purposes).

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 13cc93785006..981a9ea0b83f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
...
> @@ -5034,8 +5052,20 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long address,
>  	pte = huge_ptep_get((pte_t *)pmd);
>  	if (pte_present(pte)) {
>  		page = pmd_page(*pmd) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
> +
>  		if (flags & FOLL_GET)
>  			get_page(page);
> +		else if (flags & FOLL_PIN) {
> +			/*
> +			 * try_pin_page() is not actually expected to fail
> +			 * here because we hold the ptl.
> +			 */
> +			if (unlikely(!try_pin_page(page))) {
> +				WARN_ON_ONCE(1);
> +				page = NULL;
> +				goto out;
> +			}
> +		}

Use grab_page() here?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
