Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE6C11CA69
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfLLKRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:17:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:33086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbfLLKRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 05:17:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 340DEB16C;
        Thu, 12 Dec 2019 10:17:45 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 66CA41E0B8F; Thu, 12 Dec 2019 11:17:41 +0100 (CET)
Date:   Thu, 12 Dec 2019 11:17:41 +0100
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v10 23/25] mm/gup: track FOLL_PIN pages
Message-ID: <20191212101741.GD10065@quack2.suse.cz>
References: <20191212081917.1264184-1-jhubbard@nvidia.com>
 <20191212081917.1264184-24-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191212081917.1264184-24-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 12-12-19 00:19:15, John Hubbard wrote:
> Add tracking of pages that were pinned via FOLL_PIN.
> 
> As mentioned in the FOLL_PIN documentation, callers who effectively set
> FOLL_PIN are required to ultimately free such pages via unpin_user_page().
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
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Thanks for the patch. As a side note, given this series is rather big, it
may be better to send just individual updated patches (as replies to the
review comments) instead of resending the whole series every time. And then
you can resend the whole series once enough changes accumulate or we reach
seemingly final state.  That way people don't have to crawl through lots of
uninteresing emails...  Just something to keep in mind for the future.

I've spotted just one issue in this patch (see below), the rest are just
small style nits.

> +#define page_ref_zero_or_close_to_bias_overflow(page) \
> +	((unsigned int) page_ref_count(page) + \
> +		GUP_PIN_COUNTING_BIAS <= GUP_PIN_COUNTING_BIAS)
> +

...

> +/**
> + * page_dma_pinned() - report if a page is pinned for DMA.
> + *
> + * This function checks if a page has been pinned via a call to
> + * pin_user_pages*().
> + *
> + * The return value is partially fuzzy: false is not fuzzy, because it means
> + * "definitely not pinned for DMA", but true means "probably pinned for DMA, but
> + * possibly a false positive due to having at least GUP_PIN_COUNTING_BIAS worth
> + * of normal page references".
> + *
> + * False positives are OK, because: a) it's unlikely for a page to get that many
> + * refcounts, and b) all the callers of this routine are expected to be able to
> + * deal gracefully with a false positive.
> + *
> + * For more information, please see Documentation/vm/pin_user_pages.rst.
> + *
> + * @page:	pointer to page to be queried.
> + * @Return:	True, if it is likely that the page has been "dma-pinned".
> + *		False, if the page is definitely not dma-pinned.
> + */
> +static inline bool page_dma_pinned(struct page *page)
> +{
> +	return (page_ref_count(compound_head(page))) >= GUP_PIN_COUNTING_BIAS;
> +}
> +

I realized one think WRT handling of page refcount overflow: Page refcount is
signed and e.g. try_get_page() fails once the refcount is negative. That
means that:

a) page_ref_zero_or_close_to_bias_overflow() is not necessary - all places
that use pinning (i.e., advance refcount by GUP_PIN_COUNTING_BIAS) are not
necesary, we should just rely on the check for negative value for
consistency.

b) page_dma_pinned() has to be careful and type page_ref_count() to
unsigned type for comparison as otherwise overflowed refcount would
suddently appear as not-pinned.

> +/**
> + * try_pin_compound_head() - mark a compound page as being used by
> + * pin_user_pages*().
> + *
> + * This is the FOLL_PIN counterpart to try_get_compound_head().
> + *
> + * @page:	pointer to page to be marked
> + * @Return:	the compound head page, with ref appropriately incremented,
> + * or NULL upon failure.
> + */
> +__must_check struct page *try_pin_compound_head(struct page *page, int refs)
> +{
> +	struct page *head = try_get_compound_head(page,
> +						  GUP_PIN_COUNTING_BIAS * refs);
> +	if (!head)
> +		return NULL;
> +
> +	__update_proc_vmstat(page, NR_FOLL_PIN_REQUESTED, refs);
> +	return head;
> +}
> +
> +/*
> + * try_grab_compound_head() - attempt to elevate a page's refcount, by a
> + * flags-dependent amount.
> + *
> + * "grab" names in this file mean, "look at flags to decide whether to use
> + * FOLL_PIN or FOLL_GET behavior, when incrementing the page's refcount.
> + *
> + * Either FOLL_PIN or FOLL_GET (or neither) must be set, but not both at the
> + * same time. (That's true throughout the get_user_pages*() and
> + * pin_user_pages*() APIs.) Cases:
> + *
> + *	FOLL_GET: page's refcount will be incremented by 1.
> + *      FOLL_PIN: page's refcount will be incremented by GUP_PIN_COUNTING_BIAS.

Some tab vs space issue here... Generally we don't use tabs inside comments
for indenting so I'd wote for using just spaces.

> + *
> + * Return: head page (with refcount appropriately incremented) for success, or
> + * NULL upon failure. If neither FOLL_GET nor FOLL_PIN was set, that's
> + * considered failure, and furthermore, a likely bug in the caller, so a warning
> + * is also emitted.
> + */
> +static __maybe_unused struct page *try_grab_compound_head(struct page *page,
> +							  int refs,
> +							  unsigned int flags)
> +{
> +	if (flags & FOLL_GET)
> +		return try_get_compound_head(page, refs);
> +	else if (flags & FOLL_PIN)
> +		return try_pin_compound_head(page, refs);
> +
> +	WARN_ON_ONCE((flags & (FOLL_GET | FOLL_PIN)) == 0);

This could be just WARN_ON_ONCE(1), right?

> +	return NULL;
> +}
> +
> +/**
> + * try_grab_page() - elevate a page's refcount by a flag-dependent amount
> + *
> + * This might not do anything at all, depending on the flags argument.
> + *
> + * "grab" names in this file mean, "look at flags to decide whether to use
> + * FOLL_PIN or FOLL_GET behavior, when incrementing the page's refcount.
> + *
> + * @page:	pointer to page to be grabbed
> + * @flags:	gup flags: these are the FOLL_* flag values.
> + *
> + * Either FOLL_PIN or FOLL_GET (or neither) may be set, but not both at the same
> + * time. Cases:
> + *
> + *	FOLL_GET: page's refcount will be incremented by 1.
> + *      FOLL_PIN: page's refcount will be incremented by GUP_PIN_COUNTING_BIAS.

Again tab vs space difference here.

> + *
> + * Return: true for success, or if no action was required (if neither FOLL_PIN
> + * nor FOLL_GET was set, nothing is done). False for failure: FOLL_GET or
> + * FOLL_PIN was set, but the page could not be grabbed.
> + */
> +bool __must_check try_grab_page(struct page *page, unsigned int flags)
> +{
> +	if (flags & FOLL_GET)
> +		return try_get_page(page);
> +	else if (flags & FOLL_PIN) {
> +		page = compound_head(page);
> +		WARN_ON_ONCE(flags & FOLL_GET);
> +
> +		if (WARN_ON_ONCE(page_ref_zero_or_close_to_bias_overflow(page)))
> +			return false;

As I mentioned above, this will need "negative refcount" check instead...

> +
> +		page_ref_add(page, GUP_PIN_COUNTING_BIAS);
> +		__update_proc_vmstat(page, NR_FOLL_PIN_REQUESTED, 1);
> +	}
> +
> +	return true;
> +}

...

> @@ -1468,6 +1482,7 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	struct page *page = NULL;
> +	struct page *subpage = NULL;
>  
>  	assert_spin_locked(pmd_lockptr(mm, pmd));
>  
> @@ -1486,6 +1501,14 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
>  	VM_BUG_ON_PAGE(!PageHead(page) && !is_zone_device_page(page), page);
>  	if (flags & FOLL_TOUCH)
>  		touch_pmd(vma, addr, pmd, flags);
> +
> +	subpage = page;
> +	subpage += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
> +	VM_BUG_ON_PAGE(!PageCompound(subpage) &&
> +		       !is_zone_device_page(subpage), subpage);
> +	if (!try_grab_page(subpage, flags))
> +		return ERR_PTR(-EFAULT);
> +

Hum, I think you've made this change more complex than it has to be.
try_grab_page() is the same for head page or subpage because we increment
the refcount on the compound_head(page) anyway. So I'd leave this function
as is (not add subpage or move VM_BUG_ON_PAGE()), just have at this place:

	if (!try_grab_page(page, flags))
		return ERR_PTR(-EFAULT);

Also one comment regarding the error code. Some places seem to return -ENOMEM
when they fail to grab page reference. Shouldn't we rather return that one
for consistency?

>  	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
>  		/*
>  		 * We don't mlock() pte-mapped THPs. This way we can avoid
> @@ -1509,24 +1532,18 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
>  		 */
>  
>  		if (PageAnon(page) && compound_mapcount(page) != 1)
> -			goto skip_mlock;
> +			goto out;
>  		if (PageDoubleMap(page) || !page->mapping)
> -			goto skip_mlock;
> +			goto out;
>  		if (!trylock_page(page))
> -			goto skip_mlock;
> +			goto out;
>  		lru_add_drain();
>  		if (page->mapping && !PageDoubleMap(page))
>  			mlock_vma_page(page);
>  		unlock_page(page);
>  	}
> -skip_mlock:
> -	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
> -	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
> -	if (flags & FOLL_GET)
> -		get_page(page);
> -
>  out:
> -	return page;
> +	return subpage;
>  }
>  

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
