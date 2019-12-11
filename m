Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F7111A9D8
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 12:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbfLKL2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 06:28:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:60980 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727469AbfLKL2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 06:28:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4E902AD0E;
        Wed, 11 Dec 2019 11:28:10 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 63C461E0B23; Wed, 11 Dec 2019 12:28:07 +0100 (CET)
Date:   Wed, 11 Dec 2019 12:28:07 +0100
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
Subject: Re: [PATCH v9 23/25] mm/gup: track FOLL_PIN pages
Message-ID: <20191211112807.GN1551@quack2.suse.cz>
References: <20191211025318.457113-1-jhubbard@nvidia.com>
 <20191211025318.457113-24-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191211025318.457113-24-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 10-12-19 18:53:16, John Hubbard wrote:
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

The patch looks mostly good to me now. Just a few smaller comments below.

> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Jérôme Glisse <jglisse@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>

I think you inherited here the Reviewed-by tags from the "add flags" patch
you've merged into this one but that's not really fair since this patch
does much more... In particular I didn't give my Reviewed-by tag for this
patch yet.

> +/*
> + * try_grab_compound_head() - attempt to elevate a page's refcount, by a
> + * flags-dependent amount.
> + *
> + * This has a default assumption of "use FOLL_GET behavior, if FOLL_PIN is not
> + * set".
> + *
> + * "grab" names in this file mean, "look at flags to decide whether to use
> + * FOLL_PIN or FOLL_GET behavior, when incrementing the page's refcount.
> + */
> +static __maybe_unused struct page *try_grab_compound_head(struct page *page,
> +							  int refs,
> +							  unsigned int flags)
> +{
> +	if (flags & FOLL_PIN)
> +		return try_pin_compound_head(page, refs);
> +
> +	return try_get_compound_head(page, refs);
> +}

I somewhat wonder about the asymmetry of try_grab_compound_head() vs
try_grab_page() in the treatment of 'flags'. How costly would it be to make
them symmetric (i.e., either set FOLL_GET for try_grab_compound_head()
callers or make sure one of FOLL_GET, FOLL_PIN is set for try_grab_page())?

Because this difference looks like a subtle catch in the long run...

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
> + * time. (That's true throughout the get_user_pages*() and pin_user_pages*()
> + * APIs.) Cases:
> + *
> + *	FOLL_GET: page's refcount will be incremented by 1.
> + *      FOLL_PIN: page's refcount will be incremented by GUP_PIN_COUNTING_BIAS.
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
> +
> +		page_ref_add(page, GUP_PIN_COUNTING_BIAS);
> +		__update_proc_vmstat(page, NR_FOLL_PIN_REQUESTED, 1);
> +	}
> +
> +	return true;
> +}

...

> @@ -1522,8 +1536,8 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
>  skip_mlock:
>  	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
>  	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
> -	if (flags & FOLL_GET)
> -		get_page(page);
> +	if (!try_grab_page(page, flags))
> +		page = ERR_PTR(-EFAULT);

I think you need to also move the try_grab_page() earlier in the function.
At this point the page may be marked as mlocked and you'd need to undo that
in case try_grab_page() fails.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ac65bb5e38ac..0aab6fe0072f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4356,7 +4356,13 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  same_page:
>  		if (pages) {
>  			pages[i] = mem_map_offset(page, pfn_offset);
> -			get_page(pages[i]);
> +			if (!try_grab_page(pages[i], flags)) {
> +				spin_unlock(ptl);
> +				remainder = 0;
> +				err = -ENOMEM;
> +				WARN_ON_ONCE(1);
> +				break;
> +			}
>  		}

This function does a refcount overflow check early so that it doesn't have
to do try_get_page() here. So that check can be now removed when you do
try_grab_page() here anyway since that early check seems to be just a tiny
optimization AFAICT.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
