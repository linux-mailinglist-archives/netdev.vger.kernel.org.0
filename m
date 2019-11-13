Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9217FAED5
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfKMKt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 05:49:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:33058 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726138AbfKMKtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 05:49:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5441B20D;
        Wed, 13 Nov 2019 10:49:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 1B6A71E1498; Wed, 13 Nov 2019 11:49:20 +0100 (CET)
Date:   Wed, 13 Nov 2019 11:49:20 +0100
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
Subject: Re: [PATCH v4 04/23] mm: devmap: refactor 1-based refcounting for
 ZONE_DEVICE pages
Message-ID: <20191113104920.GF6367@quack2.suse.cz>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-5-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191113042710.3997854-5-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 12-11-19 20:26:51, John Hubbard wrote:
> An upcoming patch changes and complicates the refcounting and
> especially the "put page" aspects of it. In order to keep
> everything clean, refactor the devmap page release routines:
> 
> * Rename put_devmap_managed_page() to page_is_devmap_managed(),
>   and limit the functionality to "read only": return a bool,
>   with no side effects.
> 
> * Add a new routine, put_devmap_managed_page(), to handle checking
>   what kind of page it is, and what kind of refcount handling it
>   requires.
> 
> * Rename __put_devmap_managed_page() to free_devmap_managed_page(),
>   and limit the functionality to unconditionally freeing a devmap
>   page.
> 
> This is originally based on a separate patch by Ira Weiny, which
> applied to an early version of the put_user_page() experiments.
> Since then, Jérôme Glisse suggested the refactoring described above.
> 
> Suggested-by: Jérôme Glisse <jglisse@redhat.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/mm.h | 27 ++++++++++++++++---
>  mm/memremap.c      | 67 ++++++++++++++++++++--------------------------
>  2 files changed, 53 insertions(+), 41 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a2adf95b3f9c..96228376139c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -967,9 +967,10 @@ static inline bool is_zone_device_page(const struct page *page)
>  #endif
>  
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
> -void __put_devmap_managed_page(struct page *page);
> +void free_devmap_managed_page(struct page *page);
>  DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
> -static inline bool put_devmap_managed_page(struct page *page)
> +
> +static inline bool page_is_devmap_managed(struct page *page)
>  {
>  	if (!static_branch_unlikely(&devmap_managed_key))
>  		return false;
> @@ -978,7 +979,6 @@ static inline bool put_devmap_managed_page(struct page *page)
>  	switch (page->pgmap->type) {
>  	case MEMORY_DEVICE_PRIVATE:
>  	case MEMORY_DEVICE_FS_DAX:
> -		__put_devmap_managed_page(page);
>  		return true;
>  	default:
>  		break;
> @@ -986,6 +986,27 @@ static inline bool put_devmap_managed_page(struct page *page)
>  	return false;
>  }
>  
> +static inline bool put_devmap_managed_page(struct page *page)
> +{
> +	bool is_devmap = page_is_devmap_managed(page);
> +
> +	if (is_devmap) {
> +		int count = page_ref_dec_return(page);
> +
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
> +
>  #else /* CONFIG_DEV_PAGEMAP_OPS */
>  static inline bool put_devmap_managed_page(struct page *page)
>  {
> diff --git a/mm/memremap.c b/mm/memremap.c
> index 03ccbdfeb697..bc7e2a27d025 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -410,48 +410,39 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
>  EXPORT_SYMBOL_GPL(get_dev_pagemap);
>  
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
> -void __put_devmap_managed_page(struct page *page)
> +void free_devmap_managed_page(struct page *page)
>  {
> -	int count = page_ref_dec_return(page);
> +	/* Clear Active bit in case of parallel mark_page_accessed */
> +	__ClearPageActive(page);
> +	__ClearPageWaiters(page);
> +
> +	mem_cgroup_uncharge(page);
>  
>  	/*
> -	 * If refcount is 1 then page is freed and refcount is stable as nobody
> -	 * holds a reference on the page.
> +	 * When a device_private page is freed, the page->mapping field
> +	 * may still contain a (stale) mapping value. For example, the
> +	 * lower bits of page->mapping may still identify the page as
> +	 * an anonymous page. Ultimately, this entire field is just
> +	 * stale and wrong, and it will cause errors if not cleared.
> +	 * One example is:
> +	 *
> +	 *  migrate_vma_pages()
> +	 *    migrate_vma_insert_page()
> +	 *      page_add_new_anon_rmap()
> +	 *        __page_set_anon_rmap()
> +	 *          ...checks page->mapping, via PageAnon(page) call,
> +	 *            and incorrectly concludes that the page is an
> +	 *            anonymous page. Therefore, it incorrectly,
> +	 *            silently fails to set up the new anon rmap.
> +	 *
> +	 * For other types of ZONE_DEVICE pages, migration is either
> +	 * handled differently or not done at all, so there is no need
> +	 * to clear page->mapping.
>  	 */
> -	if (count == 1) {
> -		/* Clear Active bit in case of parallel mark_page_accessed */
> -		__ClearPageActive(page);
> -		__ClearPageWaiters(page);
> -
> -		mem_cgroup_uncharge(page);
> -
> -		/*
> -		 * When a device_private page is freed, the page->mapping field
> -		 * may still contain a (stale) mapping value. For example, the
> -		 * lower bits of page->mapping may still identify the page as
> -		 * an anonymous page. Ultimately, this entire field is just
> -		 * stale and wrong, and it will cause errors if not cleared.
> -		 * One example is:
> -		 *
> -		 *  migrate_vma_pages()
> -		 *    migrate_vma_insert_page()
> -		 *      page_add_new_anon_rmap()
> -		 *        __page_set_anon_rmap()
> -		 *          ...checks page->mapping, via PageAnon(page) call,
> -		 *            and incorrectly concludes that the page is an
> -		 *            anonymous page. Therefore, it incorrectly,
> -		 *            silently fails to set up the new anon rmap.
> -		 *
> -		 * For other types of ZONE_DEVICE pages, migration is either
> -		 * handled differently or not done at all, so there is no need
> -		 * to clear page->mapping.
> -		 */
> -		if (is_device_private_page(page))
> -			page->mapping = NULL;
> +	if (is_device_private_page(page))
> +		page->mapping = NULL;
>  
> -		page->pgmap->ops->page_free(page);
> -	} else if (!count)
> -		__put_page(page);
> +	page->pgmap->ops->page_free(page);
>  }
> -EXPORT_SYMBOL(__put_devmap_managed_page);
> +EXPORT_SYMBOL(free_devmap_managed_page);
>  #endif /* CONFIG_DEV_PAGEMAP_OPS */
> -- 
> 2.24.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
