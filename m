Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29792118A03
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfLJNjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:39:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:40646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727145AbfLJNjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 08:39:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 816B4B016;
        Tue, 10 Dec 2019 13:39:35 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id AF0221E0B23; Tue, 10 Dec 2019 14:39:32 +0100 (CET)
Date:   Tue, 10 Dec 2019 14:39:32 +0100
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
Subject: Re: [PATCH v8 24/26] mm/gup: track FOLL_PIN pages
Message-ID: <20191210133932.GH1551@quack2.suse.cz>
References: <20191209225344.99740-1-jhubbard@nvidia.com>
 <20191209225344.99740-25-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191209225344.99740-25-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 09-12-19 14:53:42, John Hubbard wrote:
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
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks nice, some comments below...

> +/*
> + * try_grab_compound_head() - attempt to elevate a page's refcount, by a
> + * flags-dependent amount.
> + *
> + * This has a default assumption of "use FOLL_GET behavior, if FOLL_PIN is not
> + * set".
> + *
> + * "grab" names in this file mean, "look at flags to decide with to use FOLL_PIN
> + * or FOLL_GET behavior, when incrementing the page's refcount.
> + */
> +static struct page *try_grab_compound_head(struct page *page, int refs,
> +					   unsigned int flags)
> +{
> +	if (flags & FOLL_PIN)
> +		return try_pin_compound_head(page, refs);
> +
> +	return try_get_compound_head(page, refs);
> +}
> +
> +/**
> + * grab_page() - elevate a page's refcount by a flag-dependent amount
> + *
> + * This might not do anything at all, depending on the flags argument.
> + *
> + * "grab" names in this file mean, "look at flags to decide with to use FOLL_PIN
                                                               ^^^ whether

> + * or FOLL_GET behavior, when incrementing the page's refcount.
> + *
> + * @page:	pointer to page to be grabbed
> + * @flags:	gup flags: these are the FOLL_* flag values.
> + *
> + * Either FOLL_PIN or FOLL_GET (or neither) may be set, but not both at the same
> + * time. (That's true throughout the get_user_pages*() and pin_user_pages*()
> + * APIs.) Cases:
> + *
> + *	FOLL_GET: page's refcount will be incremented by 1.
> + *	FOLL_PIN: page's refcount will be incremented by GUP_PIN_COUNTING_BIAS.
> + */
> +void grab_page(struct page *page, unsigned int flags)
> +{
> +	if (flags & FOLL_GET)
> +		get_page(page);
> +	else if (flags & FOLL_PIN) {
> +		get_page(page);
> +		WARN_ON_ONCE(flags & FOLL_GET);
> +		/*
> +		 * Use get_page(), above, to do the refcount error
> +		 * checking. Then just add in the remaining references:
> +		 */
> +		page_ref_add(page, GUP_PIN_COUNTING_BIAS - 1);

This is wrong for two reasons:

1) You miss compound_head() indirection from get_page() for this
page_ref_add().

2) page_ref_add() could overflow the counter without noticing.

Especially with GUP_PIN_COUNTING_BIAS being non-trivial, it is realistic
that an attacker might try to overflow the page refcount and we have to
protect the kernel against that. So I think that all the places that would
use grab_page() actually need to use try_grab_page() and then gracefully
deal with the failure.

> @@ -278,11 +425,23 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
>  		goto retry;
>  	}
>  
> -	if (flags & FOLL_GET) {
> +	if (flags & (FOLL_PIN | FOLL_GET)) {
> +		/*
> +		 * Allow try_get_page() to take care of error handling, for
> +		 * both cases: FOLL_GET or FOLL_PIN:
> +		 */
>  		if (unlikely(!try_get_page(page))) {
>  			page = ERR_PTR(-ENOMEM);
>  			goto out;
>  		}
> +
> +		if (flags & FOLL_PIN) {
> +			WARN_ON_ONCE(flags & FOLL_GET);
> +
> +			/* We got a +1 refcount from try_get_page(), above. */
> +			page_ref_add(page, GUP_PIN_COUNTING_BIAS - 1);
> +			__update_proc_vmstat(page, NR_FOLL_PIN_REQUESTED, 1);
> +		}
>  	}

The same problem here as above, plus this place should use the same
try_grab..() helper, shouldn't it?

> @@ -544,8 +703,8 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
>  	/* make this handle hugepd */
>  	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
>  	if (!IS_ERR(page)) {
> -		BUG_ON(flags & FOLL_GET);
> -		return page;
> +		WARN_ON_ONCE(flags & (FOLL_GET | FOLL_PIN));
> +		return NULL;

I agree with the change to WARN_ON_ONCE but why is correct the change of
the return value? Note that this is actually a "success branch".

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
