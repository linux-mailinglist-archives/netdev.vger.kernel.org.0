Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5112FEBA39
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbfJaXPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:15:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:52440 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfJaXPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 19:15:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 16:15:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="225867978"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga004.fm.intel.com with ESMTP; 31 Oct 2019 16:15:04 -0700
Date:   Thu, 31 Oct 2019 16:15:04 -0700
From:   Ira Weiny <ira.weiny@intel.com>
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
        "David S . Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
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
Subject: Re: [PATCH 05/19] mm/gup: introduce pin_user_pages*() and FOLL_PIN
Message-ID: <20191031231503.GF14771@iweiny-DESK2.sc.intel.com>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-6-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030224930.3990755-6-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:49:16PM -0700, John Hubbard wrote:
> Introduce pin_user_pages*() variations of get_user_pages*() calls,
> and also pin_longterm_pages*() variations.
> 
> These variants all set FOLL_PIN, which is also introduced, and
> basically documented. (An upcoming patch provides more extensive
> documentation.) The second set (pin_longterm*) also sets
> FOLL_LONGTERM:
> 
>     pin_user_pages()
>     pin_user_pages_remote()
>     pin_user_pages_fast()
> 
>     pin_longterm_pages()
>     pin_longterm_pages_remote()
>     pin_longterm_pages_fast()
> 
> All pages that are pinned via the above calls, must be unpinned via
> put_user_page().
> 
> The underlying rules are:
> 
> * These are gup-internal flags, so the call sites should not directly
> set FOLL_PIN nor FOLL_LONGTERM. That behavior is enforced with
> assertions, for the new FOLL_PIN flag. However, for the pre-existing
> FOLL_LONGTERM flag, which has some call sites that still directly
> set FOLL_LONGTERM, there is no assertion yet.
> 
> * Call sites that want to indicate that they are going to do DirectIO
>   ("DIO") or something with similar characteristics, should call a
>   get_user_pages()-like wrapper call that sets FOLL_PIN. These wrappers
>   will:
>         * Start with "pin_user_pages" instead of "get_user_pages". That
>           makes it easy to find and audit the call sites.
>         * Set FOLL_PIN
> 
> * For pages that are received via FOLL_PIN, those pages must be returned
>   via put_user_page().
> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  include/linux/mm.h |  53 ++++++++-
>  mm/gup.c           | 284 +++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 311 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index cc292273e6ba..62c838a3e6c7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1526,9 +1526,23 @@ long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
>  			    unsigned long start, unsigned long nr_pages,
>  			    unsigned int gup_flags, struct page **pages,
>  			    struct vm_area_struct **vmas, int *locked);
> +long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
> +			   unsigned long start, unsigned long nr_pages,
> +			   unsigned int gup_flags, struct page **pages,
> +			   struct vm_area_struct **vmas, int *locked);
> +long pin_longterm_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
> +			       unsigned long start, unsigned long nr_pages,
> +			       unsigned int gup_flags, struct page **pages,
> +			       struct vm_area_struct **vmas, int *locked);
>  long get_user_pages(unsigned long start, unsigned long nr_pages,
>  			    unsigned int gup_flags, struct page **pages,
>  			    struct vm_area_struct **vmas);
> +long pin_user_pages(unsigned long start, unsigned long nr_pages,
> +		    unsigned int gup_flags, struct page **pages,
> +		    struct vm_area_struct **vmas);
> +long pin_longterm_pages(unsigned long start, unsigned long nr_pages,
> +			unsigned int gup_flags, struct page **pages,
> +			struct vm_area_struct **vmas);
>  long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
>  		    unsigned int gup_flags, struct page **pages, int *locked);
>  long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
> @@ -1536,6 +1550,10 @@ long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
>  
>  int get_user_pages_fast(unsigned long start, int nr_pages,
>  			unsigned int gup_flags, struct page **pages);
> +int pin_user_pages_fast(unsigned long start, int nr_pages,
> +			unsigned int gup_flags, struct page **pages);
> +int pin_longterm_pages_fast(unsigned long start, int nr_pages,
> +			    unsigned int gup_flags, struct page **pages);
>  
>  int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
>  int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
> @@ -2594,13 +2612,15 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>  #define FOLL_ANON	0x8000	/* don't do file mappings */
>  #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
>  #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
> +#define FOLL_PIN	0x40000	/* pages must be released via put_user_page() */
>  
>  /*
> - * NOTE on FOLL_LONGTERM:
> + * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
> + * other. Here is what they mean, and how to use them:
>   *
>   * FOLL_LONGTERM indicates that the page will be held for an indefinite time
> - * period _often_ under userspace control.  This is contrasted with
> - * iov_iter_get_pages() where usages which are transient.
> + * period _often_ under userspace control.  This is in contrast to
> + * iov_iter_get_pages(), where usages which are transient.
>   *
>   * FIXME: For pages which are part of a filesystem, mappings are subject to the
>   * lifetime enforced by the filesystem and we need guarantees that longterm
> @@ -2615,11 +2635,32 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>   * Currently only get_user_pages() and get_user_pages_fast() support this flag
>   * and calls to get_user_pages_[un]locked are specifically not allowed.  This
>   * is due to an incompatibility with the FS DAX check and
> - * FAULT_FLAG_ALLOW_RETRY
> + * FAULT_FLAG_ALLOW_RETRY.
>   *
> - * In the CMA case: longterm pins in a CMA region would unnecessarily fragment
> - * that region.  And so CMA attempts to migrate the page before pinning when
> + * In the CMA case: long term pins in a CMA region would unnecessarily fragment
> + * that region.  And so, CMA attempts to migrate the page before pinning, when
>   * FOLL_LONGTERM is specified.
> + *
> + * FOLL_PIN indicates that a special kind of tracking (not just page->_refcount,
> + * but an additional pin counting system) will be invoked. This is intended for
> + * anything that gets a page reference and then touches page data (for example,
> + * Direct IO). This lets the filesystem know that some non-file-system entity is
> + * potentially changing the pages' data. In contrast to FOLL_GET (whose pages
> + * are released via put_page()), FOLL_PIN pages must be released, ultimately, by
> + * a call to put_user_page().
> + *
> + * FOLL_PIN is similar to FOLL_GET: both of these pin pages. They use different
> + * and separate refcounting mechanisms, however, and that means that each has
> + * its own acquire and release mechanisms:
> + *
> + *     FOLL_GET: get_user_pages*() to acquire, and put_page() to release.
> + *
> + *     FOLL_PIN: pin_user_pages*() or pin_longterm_pages*() to acquire, and
> + *               put_user_pages to release.
> + *
> + * FOLL_PIN and FOLL_GET are mutually exclusive.

You mean the flags are mutually exclusive for any single call, correct?
Because my first thought was that you meant that a page which was pin'ed can't
be "got".  Which I don't think is true or necessary...

> + *
> + * Please see Documentation/vm/pin_user_pages.rst for more information.

NIT: I think we should include this file as part of this patch...

>   */
>  
>  static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
> diff --git a/mm/gup.c b/mm/gup.c
> index 8fb0d9cdfaf5..8694bc7b3df3 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -179,6 +179,10 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
>  	spinlock_t *ptl;
>  	pte_t *ptep, pte;
>  
> +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> +	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
> +			 (FOLL_PIN | FOLL_GET)))
> +		return ERR_PTR(-EINVAL);
>  retry:
>  	if (unlikely(pmd_bad(*pmd)))
>  		return no_page_table(vma, flags);
> @@ -790,7 +794,7 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>  
>  	start = untagged_addr(start);
>  
> -	VM_BUG_ON(!!pages != !!(gup_flags & FOLL_GET));
> +	VM_BUG_ON(!!pages != !!(gup_flags & (FOLL_GET | FOLL_PIN)));
>  
>  	/*
>  	 * If FOLL_FORCE is set then do not force a full fault as the hinting
> @@ -1014,7 +1018,16 @@ static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
>  		BUG_ON(*locked != 1);
>  	}
>  
> -	if (pages)
> +	/*
> +	 * FOLL_PIN and FOLL_GET are mutually exclusive. Traditional behavior
> +	 * is to set FOLL_GET if the caller wants pages[] filled in (but has
> +	 * carelessly failed to specify FOLL_GET), so keep doing that, but only
> +	 * for FOLL_GET, not for the newer FOLL_PIN.
> +	 *
> +	 * FOLL_PIN always expects pages to be non-null, but no need to assert
> +	 * that here, as any failures will be obvious enough.
> +	 */
> +	if (pages && !(flags & FOLL_PIN))
>  		flags |= FOLL_GET;
>  
>  	pages_done = 0;
> @@ -1133,6 +1146,12 @@ static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
>   * is written to, set_page_dirty (or set_page_dirty_lock, as appropriate) must
>   * be called after the page is finished with, and before put_page is called.
>   *
> + * A note on gup_flags: FOLL_PIN must only be set internally by the
> + * pin_user_page*() and pin_longterm_*() APIs, never directly by the caller.
> + * That's in order to help avoid mismatches when releasing pages:
> + * get_user_pages*() pages must be released via put_page(), while
> + * pin_user_pages*() pages must be released via put_user_page().
> + *
>   * get_user_pages is typically used for fewer-copy IO operations, to get a
>   * handle on the memory by some means other than accesses via the user virtual
>   * addresses. The pages may be submitted for DMA to devices or accessed via
> @@ -1151,6 +1170,14 @@ long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
>  		unsigned int gup_flags, struct page **pages,
>  		struct vm_area_struct **vmas, int *locked)
>  {
> +	/*
> +	 * As detailed above, FOLL_PIN must only be set internally by the
> +	 * pin_user_page*() and pin_longterm_*() APIs, never directly by the
> +	 * caller, so enforce that with an assertion:
> +	 */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
> +		return -EINVAL;
> +
>  	/*
>  	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
>  	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
> @@ -1603,11 +1630,25 @@ static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
>   * and mm being operated on are the current task's and don't allow
>   * passing of a locked parameter.  We also obviously don't pass
>   * FOLL_REMOTE in here.
> + *
> + * A note on gup_flags: FOLL_PIN should only be set internally by the
> + * pin_user_page*() and pin_longterm_*() APIs, never directly by the caller.
> + * That's in order to help avoid mismatches when releasing pages:
> + * get_user_pages*() pages must be released via put_page(), while
> + * pin_user_pages*() pages must be released via put_user_page().

Rather than put this here should we put it next to the definition of FOLL_PIN?
Because now we have this text 2x...  :-/

>   */
>  long get_user_pages(unsigned long start, unsigned long nr_pages,
>  		unsigned int gup_flags, struct page **pages,
>  		struct vm_area_struct **vmas)
>  {
> +	/*
> +	 * As detailed above, FOLL_PIN must only be set internally by the
> +	 * pin_user_page*() and pin_longterm_*() APIs, never directly by the
> +	 * caller, so enforce that with an assertion:
> +	 */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
> +		return -EINVAL;
> +
>  	return __gup_longterm_locked(current, current->mm, start, nr_pages,
>  				     pages, vmas, gup_flags | FOLL_TOUCH);
>  }
> @@ -2366,24 +2407,9 @@ static int __gup_longterm_unlocked(unsigned long start, int nr_pages,
>  	return ret;
>  }
>  
> -/**
> - * get_user_pages_fast() - pin user pages in memory
> - * @start:	starting user address
> - * @nr_pages:	number of pages from start to pin
> - * @gup_flags:	flags modifying pin behaviour
> - * @pages:	array that receives pointers to the pages pinned.
> - *		Should be at least nr_pages long.
> - *
> - * Attempt to pin user pages in memory without taking mm->mmap_sem.
> - * If not successful, it will fall back to taking the lock and
> - * calling get_user_pages().
> - *
> - * Returns number of pages pinned. This may be fewer than the number
> - * requested. If nr_pages is 0 or negative, returns 0. If no pages
> - * were pinned, returns -errno.
> - */
> -int get_user_pages_fast(unsigned long start, int nr_pages,
> -			unsigned int gup_flags, struct page **pages)
> +static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
> +					unsigned int gup_flags,
> +					struct page **pages)
>  {
>  	unsigned long addr, len, end;
>  	int nr = 0, ret = 0;
> @@ -2428,4 +2454,222 @@ int get_user_pages_fast(unsigned long start, int nr_pages,
>  
>  	return ret;
>  }
> +
> +/**
> + * get_user_pages_fast() - pin user pages in memory
> + * @start:	starting user address
> + * @nr_pages:	number of pages from start to pin
> + * @gup_flags:	flags modifying pin behaviour
> + * @pages:	array that receives pointers to the pages pinned.
> + *		Should be at least nr_pages long.
> + *
> + * Attempt to pin user pages in memory without taking mm->mmap_sem.
> + * If not successful, it will fall back to taking the lock and
> + * calling get_user_pages().
> + *
> + * A note on gup_flags: FOLL_PIN must only be set internally by the
> + * pin_user_page*() and pin_longterm_*() APIs, never directly by the caller.
> + * That's in order to help avoid mismatches when releasing pages:
> + * get_user_pages*() pages must be released via put_page(), while
> + * pin_user_pages*() pages must be released via put_user_page().
> + *
> + * Returns number of pages pinned. This may be fewer than the number requested.
> + * If nr_pages is 0 or negative, returns 0. If no pages were pinned, returns
> + * -errno.
> + */
> +int get_user_pages_fast(unsigned long start, int nr_pages,
> +			unsigned int gup_flags, struct page **pages)
> +{
> +	/*
> +	 * As detailed above, FOLL_PIN must only be set internally by the
> +	 * pin_user_page*() and pin_longterm_*() APIs, never directly by the
> +	 * caller, so enforce that:
> +	 */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
> +		return -EINVAL;
> +
> +	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
> +}
>  EXPORT_SYMBOL_GPL(get_user_pages_fast);
> +
> +/**
> + * pin_user_pages_fast() - pin user pages in memory without taking locks
> + *
> + * Nearly the same as get_user_pages_fast(), except that FOLL_PIN is set. See
> + * get_user_pages_fast() for documentation on the function arguments, because
> + * the arguments here are identical.
> + *
> + * FOLL_PIN means that the pages must be released via put_user_page(). Please
> + * see Documentation/vm/pin_user_pages.rst for further details.
> + *
> + * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rst. It
> + * is NOT intended for Case 2 (RDMA: long-term pins).
> + */
> +int pin_user_pages_fast(unsigned long start, int nr_pages,
> +			unsigned int gup_flags, struct page **pages)
> +{
> +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> +		return -EINVAL;
> +
> +	gup_flags |= FOLL_PIN;
> +	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
> +}
> +EXPORT_SYMBOL_GPL(pin_user_pages_fast);
> +
> +/**
> + * pin_longterm_pages_fast() - pin user pages in memory without taking locks
> + *
> + * Nearly the same as get_user_pages_fast(), except that FOLL_PIN and
> + * FOLL_LONGTERM are set. See get_user_pages_fast() for documentation on the
> + * function arguments, because the arguments here are identical.
> + *
> + * FOLL_PIN means that the pages must be released via put_user_page(). Please
> + * see Documentation/vm/pin_user_pages.rst for further details.
> + *
> + * FOLL_LONGTERM means that the pages are being pinned for "long term" use,
> + * typically by a non-CPU device, and we cannot be sure that waiting for a
> + * pinned page to become unpin will be effective.
> + *
> + * This is intended for Case 2 (RDMA: long-term pins) of the FOLL_PIN
> + * documentation.
> + */
> +int pin_longterm_pages_fast(unsigned long start, int nr_pages,
> +			    unsigned int gup_flags, struct page **pages)
> +{
> +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> +		return -EINVAL;
> +
> +	gup_flags |= (FOLL_PIN | FOLL_LONGTERM);
> +	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
> +}
> +EXPORT_SYMBOL_GPL(pin_longterm_pages_fast);
> +
> +/**
> + * pin_user_pages_remote() - pin pages for (typically) use by Direct IO, and
> + * return the pages to the user.
> + *
> + * Nearly the same as get_user_pages_remote(), except that FOLL_PIN is set. See
> + * get_user_pages_remote() for documentation on the function arguments, because
> + * the arguments here are identical.
> + *
> + * FOLL_PIN means that the pages must be released via put_user_page(). Please
> + * see Documentation/vm/pin_user_pages.rst for details.
> + *
> + * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rst. It
> + * is NOT intended for Case 2 (RDMA: long-term pins).
> + */
> +long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
> +			   unsigned long start, unsigned long nr_pages,
> +			   unsigned int gup_flags, struct page **pages,
> +			   struct vm_area_struct **vmas, int *locked)
> +{
> +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> +		return -EINVAL;
> +
> +	gup_flags |= FOLL_TOUCH | FOLL_REMOTE | FOLL_PIN;
> +
> +	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
> +				       locked, gup_flags);
> +}
> +EXPORT_SYMBOL(pin_user_pages_remote);
> +
> +/**
> + * pin_longterm_pages_remote() - pin pages for (typically) use by Direct IO, and
> + * return the pages to the user.
> + *
> + * Nearly the same as get_user_pages_remote(), but note that FOLL_TOUCH is not
> + * set, and FOLL_PIN and FOLL_LONGTERM are set. See get_user_pages_remote() for
> + * documentation on the function arguments, because the arguments here are
> + * identical.
> + *
> + * FOLL_PIN means that the pages must be released via put_user_page(). Please
> + * see Documentation/vm/pin_user_pages.rst for further details.
> + *
> + * FOLL_LONGTERM means that the pages are being pinned for "long term" use,
> + * typically by a non-CPU device, and we cannot be sure that waiting for a
> + * pinned page to become unpin will be effective.
> + *
> + * This is intended for Case 2 (RDMA: long-term pins) in
> + * Documentation/vm/pin_user_pages.rst.
> + */
> +long pin_longterm_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
> +			       unsigned long start, unsigned long nr_pages,
> +			       unsigned int gup_flags, struct page **pages,
> +			       struct vm_area_struct **vmas, int *locked)
> +{
> +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> +		return -EINVAL;
> +
> +	/*
> +	 * FIXME: as noted in the get_user_pages_remote() implementation, it
> +	 * is not yet possible to safely set FOLL_LONGTERM here. FOLL_LONGTERM
> +	 * needs to be set, but for now the best we can do is a "TODO" item.
> +	 */

Wait?  Why can't we set FOLL_LONGTERM here?  pin_* are new calls which are not
used yet right?

You set it in the other new pin_* functions?

Ira

> +	gup_flags |= FOLL_REMOTE | FOLL_PIN;
> +
> +	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
> +				       locked, gup_flags);
> +}
> +EXPORT_SYMBOL(pin_longterm_pages_remote);
> +
> +/**
> + * pin_user_pages() - pin user pages in memory for use by other devices
> + *
> + * Nearly the same as get_user_pages(), except that FOLL_TOUCH is not set, and
> + * FOLL_PIN is set.
> + *
> + * FOLL_PIN means that the pages must be released via put_user_page(). Please
> + * see Documentation/vm/pin_user_pages.rst for details.
> + *
> + * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rst. It
> + * is NOT intended for Case 2 (RDMA: long-term pins).
> + */
> +long pin_user_pages(unsigned long start, unsigned long nr_pages,
> +		    unsigned int gup_flags, struct page **pages,
> +		    struct vm_area_struct **vmas)
> +{
> +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> +		return -EINVAL;
> +
> +	gup_flags |= FOLL_PIN;
> +	return __gup_longterm_locked(current, current->mm, start, nr_pages,
> +				     pages, vmas, gup_flags);
> +}
> +EXPORT_SYMBOL(pin_user_pages);
> +
> +/**
> + * pin_longterm_pages() - pin user pages in memory for long-term use (RDMA,
> + * typically)
> + *
> + * Nearly the same as get_user_pages(), except that FOLL_PIN and FOLL_LONGTERM
> + * are set. See get_user_pages_fast() for documentation on the function
> + * arguments, because the arguments here are identical.
> + *
> + * FOLL_PIN means that the pages must be released via put_user_page(). Please
> + * see Documentation/vm/pin_user_pages.rst for further details.
> + *
> + * FOLL_LONGTERM means that the pages are being pinned for "long term" use,
> + * typically by a non-CPU device, and we cannot be sure that waiting for a
> + * pinned page to become unpin will be effective.
> + *
> + * This is intended for Case 2 (RDMA: long-term pins) in
> + * Documentation/vm/pin_user_pages.rst.
> + */
> +long pin_longterm_pages(unsigned long start, unsigned long nr_pages,
> +			unsigned int gup_flags, struct page **pages,
> +			struct vm_area_struct **vmas)
> +{
> +	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
> +		return -EINVAL;
> +
> +	gup_flags |= FOLL_PIN | FOLL_LONGTERM;
> +	return __gup_longterm_locked(current, current->mm, start, nr_pages,
> +				     pages, vmas, gup_flags);
> +}
> +EXPORT_SYMBOL(pin_longterm_pages);
> -- 
> 2.23.0
> 
