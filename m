Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8511C1021F1
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKSKTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:19:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:49868 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726555AbfKSKTS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 05:19:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 737CFAE87;
        Tue, 19 Nov 2019 10:19:13 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D586A1E47E5; Tue, 19 Nov 2019 11:19:10 +0100 (CET)
Date:   Tue, 19 Nov 2019 11:19:10 +0100
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
        Christoph Hellwig <hch@lst.de>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v6 02/24] mm/gup: factor out duplicate code from four
 routines
Message-ID: <20191119101910.GC25605@quack2.suse.cz>
References: <20191119081643.1866232-1-jhubbard@nvidia.com>
 <20191119081643.1866232-3-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191119081643.1866232-3-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 19-11-19 00:16:21, John Hubbard wrote:
> There are four locations in gup.c that have a fair amount of code
> duplication. This means that changing one requires making the same
> changes in four places, not to mention reading the same code four
> times, and wondering if there are subtle differences.
> 
> Factor out the common code into static functions, thus reducing the
> overall line count and the code's complexity.
> 
> Also, take the opportunity to slightly improve the efficiency of the
> error cases, by doing a mass subtraction of the refcount, surrounded
> by get_page()/put_page().
> 
> Also, further simplify (slightly), by waiting until the the successful
> end of each routine, to increment *nr.
> 
> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good to me now! You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/gup.c | 91 ++++++++++++++++++++++----------------------------------
>  1 file changed, 36 insertions(+), 55 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 85caf76b3012..f3c7d6625817 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1969,6 +1969,25 @@ static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long addr,
>  }
>  #endif
>  
> +static int __record_subpages(struct page *page, unsigned long addr,
> +			     unsigned long end, struct page **pages)
> +{
> +	int nr;
> +
> +	for (nr = 0; addr != end; addr += PAGE_SIZE)
> +		pages[nr++] = page++;
> +
> +	return nr;
> +}
> +
> +static void put_compound_head(struct page *page, int refs)
> +{
> +	/* Do a get_page() first, in case refs == page->_refcount */
> +	get_page(page);
> +	page_ref_sub(page, refs);
> +	put_page(page);
> +}
> +
>  #ifdef CONFIG_ARCH_HAS_HUGEPD
>  static unsigned long hugepte_addr_end(unsigned long addr, unsigned long end,
>  				      unsigned long sz)
> @@ -1998,32 +2017,20 @@ static int gup_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
>  	/* hugepages are never "special" */
>  	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
>  
> -	refs = 0;
>  	head = pte_page(pte);
> -
>  	page = head + ((addr & (sz-1)) >> PAGE_SHIFT);
> -	do {
> -		VM_BUG_ON(compound_head(page) != head);
> -		pages[*nr] = page;
> -		(*nr)++;
> -		page++;
> -		refs++;
> -	} while (addr += PAGE_SIZE, addr != end);
> +	refs = __record_subpages(page, addr, end, pages + *nr);
>  
>  	head = try_get_compound_head(head, refs);
> -	if (!head) {
> -		*nr -= refs;
> +	if (!head)
>  		return 0;
> -	}
>  
>  	if (unlikely(pte_val(pte) != pte_val(*ptep))) {
> -		/* Could be optimized better */
> -		*nr -= refs;
> -		while (refs--)
> -			put_page(head);
> +		put_compound_head(head, refs);
>  		return 0;
>  	}
>  
> +	*nr += refs;
>  	SetPageReferenced(head);
>  	return 1;
>  }
> @@ -2071,28 +2078,19 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>  					     pages, nr);
>  	}
>  
> -	refs = 0;
>  	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
> -	do {
> -		pages[*nr] = page;
> -		(*nr)++;
> -		page++;
> -		refs++;
> -	} while (addr += PAGE_SIZE, addr != end);
> +	refs = __record_subpages(page, addr, end, pages + *nr);
>  
>  	head = try_get_compound_head(pmd_page(orig), refs);
> -	if (!head) {
> -		*nr -= refs;
> +	if (!head)
>  		return 0;
> -	}
>  
>  	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
> -		*nr -= refs;
> -		while (refs--)
> -			put_page(head);
> +		put_compound_head(head, refs);
>  		return 0;
>  	}
>  
> +	*nr += refs;
>  	SetPageReferenced(head);
>  	return 1;
>  }
> @@ -2114,28 +2112,19 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
>  					     pages, nr);
>  	}
>  
> -	refs = 0;
>  	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
> -	do {
> -		pages[*nr] = page;
> -		(*nr)++;
> -		page++;
> -		refs++;
> -	} while (addr += PAGE_SIZE, addr != end);
> +	refs = __record_subpages(page, addr, end, pages + *nr);
>  
>  	head = try_get_compound_head(pud_page(orig), refs);
> -	if (!head) {
> -		*nr -= refs;
> +	if (!head)
>  		return 0;
> -	}
>  
>  	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
> -		*nr -= refs;
> -		while (refs--)
> -			put_page(head);
> +		put_compound_head(head, refs);
>  		return 0;
>  	}
>  
> +	*nr += refs;
>  	SetPageReferenced(head);
>  	return 1;
>  }
> @@ -2151,28 +2140,20 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
>  		return 0;
>  
>  	BUILD_BUG_ON(pgd_devmap(orig));
> -	refs = 0;
> +
>  	page = pgd_page(orig) + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
> -	do {
> -		pages[*nr] = page;
> -		(*nr)++;
> -		page++;
> -		refs++;
> -	} while (addr += PAGE_SIZE, addr != end);
> +	refs = __record_subpages(page, addr, end, pages + *nr);
>  
>  	head = try_get_compound_head(pgd_page(orig), refs);
> -	if (!head) {
> -		*nr -= refs;
> +	if (!head)
>  		return 0;
> -	}
>  
>  	if (unlikely(pgd_val(orig) != pgd_val(*pgdp))) {
> -		*nr -= refs;
> -		while (refs--)
> -			put_page(head);
> +		put_compound_head(head, refs);
>  		return 0;
>  	}
>  
> +	*nr += refs;
>  	SetPageReferenced(head);
>  	return 1;
>  }
> -- 
> 2.24.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
