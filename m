Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFABEF0C1
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbfKDWtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:49:22 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13146 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbfKDWtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 17:49:21 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc0aaf60000>; Mon, 04 Nov 2019 14:49:26 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 04 Nov 2019 14:49:19 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 04 Nov 2019 14:49:19 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Nov
 2019 22:49:18 +0000
Subject: Re: [PATCH v2 12/18] mm/gup: track FOLL_PIN pages
To:     Jerome Glisse <jglisse@redhat.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-13-jhubbard@nvidia.com>
 <20191104185238.GG5134@redhat.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <7821cf87-75a8-45e2-cf28-f85b62192416@nvidia.com>
Date:   Mon, 4 Nov 2019 14:49:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104185238.GG5134@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572907766; bh=FuJBjY/6EN7ZD74pvhEnFnmub+fGmDUQkCP0kT0KICU=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FcJ6pYEqgdsOBIC1qVrc85UBs1dRxi/GQUXYp9dezlTyMHw/CSA0Is2qC57yISAy4
         6AMaLgxKlgWAr5NM6ndqYHzumM6X8COBXcVUW+/TbhFuYaY+Tsi+OfKm3N8L/B1SvC
         MCOjQmCNtC8acaFJmVHn5tJe4LdrVk8aNaCHptUsq77bmrRzdZGabFU6hCo1OybX2w
         R2ANEuB4R6RAmlhsyliFdh2gK+0s0y/6lhLLIwhC83jKdyyuegxiqrP4OnS/awC8KH
         8rfI+7HfLbMNNN4LhFOjO5NtjSqyVko5eLMgbZyEVFvA5q9akXVjmFK5Jgn/qqJnYh
         HRdMrbDpqrO/w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/19 10:52 AM, Jerome Glisse wrote:
> On Sun, Nov 03, 2019 at 01:18:07PM -0800, John Hubbard wrote:
>> Add tracking of pages that were pinned via FOLL_PIN.
>>
>> As mentioned in the FOLL_PIN documentation, callers who effectively set
>> FOLL_PIN are required to ultimately free such pages via put_user_page().
>> The effect is similar to FOLL_GET, and may be thought of as "FOLL_GET
>> for DIO and/or RDMA use".
>>
>> Pages that have been pinned via FOLL_PIN are identifiable via a
>> new function call:
>>
>>    bool page_dma_pinned(struct page *page);
>>
>> What to do in response to encountering such a page, is left to later
>> patchsets. There is discussion about this in [1].
>>
>> This also changes a BUG_ON(), to a WARN_ON(), in follow_page_mask().
>>
>> This also has a couple of trivial, non-functional change fixes to
>> try_get_compound_head(). That function got moved to the top of the
>> file.
> 
> Maybe split that as a separate trivial patch.


Will do.


> 
>>
>> This includes the following fix from Ira Weiny:
>>
>> DAX requires detection of a page crossing to a ref count of 1.  Fix this
>> for GUP pages by introducing put_devmap_managed_user_page() which
>> accounts for GUP_PIN_COUNTING_BIAS now used by GUP.
> 
> Please do the put_devmap_managed_page() changes in a separate
> patch, it would be a lot easier to follow, also on that front
> see comments below.


Oh! OK. It makes sense when you say it out loud. :)


...
>> +static inline bool put_devmap_managed_page(struct page *page)
>> +{
>> +	bool is_devmap = page_is_devmap_managed(page);
>> +
>> +	if (is_devmap) {
>> +		int count = page_ref_dec_return(page);
>> +
>> +		__put_devmap_managed_page(page, count);
>> +	}
>> +
>> +	return is_devmap;
>> +}
> 
> I think the __put_devmap_managed_page() should be rename
> to free_devmap_managed_page() and that the count != 1
> case move to this inline function ie:
> 
> static inline bool put_devmap_managed_page(struct page *page)
> {
> 	bool is_devmap = page_is_devmap_managed(page);
> 
> 	if (is_devmap) {
> 		int count = page_ref_dec_return(page);
> 
> 		/*
> 		 * If refcount is 1 then page is freed and refcount is stable as nobody
> 		 * holds a reference on the page.
> 		 */
> 		if (count == 1)
> 			free_devmap_managed_page(page, count);
> 		else if (!count)
> 			__put_page(page);
> 	}
> 
> 	return is_devmap;
> }
> 

Thanks, that does look cleaner and easier to read.

> 
>> +
>>  #else /* CONFIG_DEV_PAGEMAP_OPS */
>>  static inline bool put_devmap_managed_page(struct page *page)
>>  {
>> @@ -1038,6 +1051,8 @@ static inline __must_check bool try_get_page(struct page *page)
>>  	return true;
>>  }
>>  
>> +__must_check bool user_page_ref_inc(struct page *page);
>> +
> 
> What about having it as an inline here as it is pretty small.


You mean move it to a static inline function in mm.h? It's worse than it 
looks, though: *everything* that it calls is also a static function, local
to gup.c. So I'd have to expose both try_get_compound_head() and
__update_proc_vmstat(). And that also means calling mod_node_page_state() from
mm.h, and it goes south right about there. :)


...  
>> +/**
>> + * page_dma_pinned() - report if a page is pinned by a call to pin_user_pages*()
>> + * or pin_longterm_pages*()
>> + * @page:	pointer to page to be queried.
>> + * @Return:	True, if it is likely that the page has been "dma-pinned".
>> + *		False, if the page is definitely not dma-pinned.
>> + */
> 
> Maybe add a small comment about wrap around :)


I don't *think* the count can wrap around, due to the checks in user_page_ref_inc().

But it's true that the documentation is a little light here...What did you have 
in mind?


> [...]
> 
>> @@ -1930,12 +2028,20 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>  
>>  		pgmap = get_dev_pagemap(pfn, pgmap);
>>  		if (unlikely(!pgmap)) {
>> -			undo_dev_pagemap(nr, nr_start, pages);
>> +			undo_dev_pagemap(nr, nr_start, flags, pages);
>>  			return 0;
>>  		}
>>  		SetPageReferenced(page);
>>  		pages[*nr] = page;
>> -		get_page(page);
>> +
>> +		if (flags & FOLL_PIN) {
>> +			if (unlikely(!user_page_ref_inc(page))) {
>> +				undo_dev_pagemap(nr, nr_start, flags, pages);
>> +				return 0;
>> +			}
> 
> Maybe add a comment about a case that should never happens ie
> user_page_ref_inc() fails after the second iteration of the
> loop as it would be broken and a bug to call undo_dev_pagemap()
> after the first iteration of that loop.
> 
> Also i believe that this should never happens as if first
> iteration succeed than __page_cache_add_speculative() will
> succeed for all the iterations.
> 
> Note that the pgmap case above follows that too ie the call to
> get_dev_pagemap() can only fail on first iteration of the loop,
> well i assume you can never have a huge device page that span
> different pgmap ie different devices (which is a reasonable
> assumption). So maybe this code needs fixing ie :
> 
> 		pgmap = get_dev_pagemap(pfn, pgmap);
> 		if (unlikely(!pgmap))
> 			return 0;
> 
> 

OK, yes that does make sense. And I think a comment is adequate,
no need to check for bugs during every tail page iteration. So how 
about this, as a preliminary patch:

diff --git a/mm/gup.c b/mm/gup.c
index 8f236a335ae9..a4a81e125832 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1892,17 +1892,18 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 static int __gup_device_huge(unsigned long pfn, unsigned long addr,
                unsigned long end, struct page **pages, int *nr)
 {
-       int nr_start = *nr;
-       struct dev_pagemap *pgmap = NULL;
+       /*
+        * Huge pages should never cross dev_pagemap boundaries. Therefore, use
+        * this same pgmap for the entire huge page.
+        */
+       struct dev_pagemap *pgmap = get_dev_pagemap(pfn, NULL);
+
+       if (unlikely(!pgmap))
+               return 0;
 
        do {
                struct page *page = pfn_to_page(pfn);
 
-               pgmap = get_dev_pagemap(pfn, pgmap);
-               if (unlikely(!pgmap)) {
-                       undo_dev_pagemap(nr, nr_start, pages);
-                       return 0;
-               }
                SetPageReferenced(page);
                pages[*nr] = page;
                get_page(page);




>> +		} else
>> +			get_page(page);
>> +
>>  		(*nr)++;
>>  		pfn++;
>>  	} while (addr += PAGE_SIZE, addr != end);
> 
> [...]
> 
>> @@ -2409,7 +2540,7 @@ static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
>>  	unsigned long addr, len, end;
>>  	int nr = 0, ret = 0;
>>  
>> -	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM)))
>> +	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM | FOLL_PIN)))
> 
> Maybe add a comments to explain, something like:
> 
> /*
>  * The only flags allowed here are: FOLL_WRITE, FOLL_LONGTERM, FOLL_PIN
>  *
>  * Note that get_user_pages_fast() imply FOLL_GET flag by default but
>  * callers can over-ride this default to pin case by setting FOLL_PIN.
>  */

Good idea. Here's the draft now:

/*
 * The only flags allowed here are: FOLL_WRITE, FOLL_LONGTERM, FOLL_PIN.
 *
 * Note that get_user_pages_fast() implies FOLL_GET flag by default, but
 * callers can override this default by setting FOLL_PIN instead of
 * FOLL_GET.
 */
if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM | FOLL_PIN)))
        return -EINVAL;

> 
>>  		return -EINVAL;
>>  
>>  	start = untagged_addr(start) & PAGE_MASK;
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 13cc93785006..66bf4c8b88f1 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
> 
> [...]
> 
>> @@ -968,7 +973,12 @@ struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
>>  	if (!*pgmap)
>>  		return ERR_PTR(-EFAULT);
>>  	page = pfn_to_page(pfn);
>> -	get_page(page);
>> +
>> +	if (flags & FOLL_GET)
>> +		get_page(page);
>> +	else if (flags & FOLL_PIN)
>> +		if (unlikely(!user_page_ref_inc(page)))
>> +			page = ERR_PTR(-ENOMEM);
> 
> While i agree that user_page_ref_inc() (ie page_cache_add_speculative())
> should never fails here as we are holding the pmd lock and thus no one
> can unmap the pmd and free the page it points to. I believe you should
> return -EFAULT like for the pgmap and not -ENOMEM as the pgmap should
> not fail either for the same reason. Thus it would be better to have
> consistent error. Maybe also add a comments explaining that it should
> not fail here.
> 

OK. I'll take a pass through and fix up the remaining points about these
sorts of cases below, as well, in v3. Those all make sense.

>>  
>>  	return page;
>>  }
> 
> [...]
> 
>> @@ -1100,7 +1115,7 @@ struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
>>  	 * device mapped pages can only be returned if the
>>  	 * caller will manage the page reference count.
>>  	 */
>> -	if (!(flags & FOLL_GET))
>> +	if (!(flags & (FOLL_GET | FOLL_PIN)))
>>  		return ERR_PTR(-EEXIST);
> 
> Maybe add a comment that FOLL_GET or FOLL_PIN must be set.
> 
>>  	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
>> @@ -1108,7 +1123,12 @@ struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
>>  	if (!*pgmap)
>>  		return ERR_PTR(-EFAULT);
>>  	page = pfn_to_page(pfn);
>> -	get_page(page);
>> +
>> +	if (flags & FOLL_GET)
>> +		get_page(page);
>> +	else if (flags & FOLL_PIN)
>> +		if (unlikely(!user_page_ref_inc(page)))
>> +			page = ERR_PTR(-ENOMEM);
> 
> Same as for follow_devmap_pmd() see above.
> 
>>  
>>  	return page;
>>  }
>> @@ -1522,8 +1542,12 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
>>  skip_mlock:
>>  	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
>>  	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
>> +
>>  	if (flags & FOLL_GET)
>>  		get_page(page);
>> +	else if (flags & FOLL_PIN)
>> +		if (unlikely(!user_page_ref_inc(page)))
>> +			page = NULL;
> 
> This should not fail either as we are holding the pmd lock maybe add
> a comment. Dunno if we want a WARN() or something to catch this
> degenerate case, or dump the page.
> 
>>  
>>  out:
>>  	return page;
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index b45a95363a84..da335b1cd798 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -4462,7 +4462,17 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
>>  same_page:
>>  		if (pages) {
>>  			pages[i] = mem_map_offset(page, pfn_offset);
>> -			get_page(pages[i]);
>> +
>> +			if (flags & FOLL_GET)
>> +				get_page(pages[i]);
>> +			else if (flags & FOLL_PIN)
>> +				if (unlikely(!user_page_ref_inc(pages[i]))) {
>> +					spin_unlock(ptl);
>> +					remainder = 0;
>> +					err = -ENOMEM;
>> +					WARN_ON_ONCE(1);
>> +					break;
>> +				}
>>  		}
> 
> user_page_ref_inc() should not fail here either because we hold the
> ptl, so the WAR_ON_ONCE() is right but maybe add a comment.
> 
>>  
>>  		if (vmas)
> 
> [...]
> 
>> @@ -5034,8 +5050,14 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long address,
>>  	pte = huge_ptep_get((pte_t *)pmd);
>>  	if (pte_present(pte)) {
>>  		page = pmd_page(*pmd) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
>> +
>>  		if (flags & FOLL_GET)
>>  			get_page(page);
>> +		else if (flags & FOLL_PIN)
>> +			if (unlikely(!user_page_ref_inc(page))) {
>> +				page = NULL;
>> +				goto out;
>> +			}
> 
> This should not fail either (again holding pmd lock), dunno if we want
> a warn or something to catch this degenerate case.
> 
>>  	} else {
>>  		if (is_hugetlb_entry_migration(pte)) {
>>  			spin_unlock(ptl);
> 
> [...]
> 
> 

Those are all good points, working on them now.

thanks,
-- 
John Hubbard
NVIDIA
