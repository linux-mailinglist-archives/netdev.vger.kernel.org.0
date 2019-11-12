Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E97F88C7
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfKLGvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:51:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfKLGvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 01:51:19 -0500
Received: from rapoport-lnx (unknown [195.57.117.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 123CD2084F;
        Tue, 12 Nov 2019 06:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573541477;
        bh=Xrd0YnKaYbVVFQLPrYOT47qBaf64xGATzmWkzzpLmiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B8jDkQZ6Yaop7bTCojs7RpRcs7qzAYkt7UQtAShffH1VroOthzb0lxXZ+Uqi9E2C9
         L+fU7mWBQog4EI8R3urhYTrKWVhcrv1YybqFVDmiAVLKq35FK2BQV3cS+FpmDp9EJt
         Prf9mTDXl8/QHBhyteLCU6UJyRMnvTcnUn7JMsuk=
Date:   Tue, 12 Nov 2019 07:51:05 +0100
From:   Mike Rapoport <rppt@kernel.org>
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
Subject: Re: [PATCH v3 09/23] mm/gup: introduce pin_user_pages*() and FOLL_PIN
Message-ID: <20191112065103.GA1209@rapoport-lnx>
References: <20191112000700.3455038-1-jhubbard@nvidia.com>
 <20191112000700.3455038-10-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191112000700.3455038-10-jhubbard@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 04:06:46PM -0800, John Hubbard wrote:
> Introduce pin_user_pages*() variations of get_user_pages*() calls,
> and also pin_longterm_pages*() variations.
> 
> These variants all set FOLL_PIN, which is also introduced, and
> thoroughly documented.
> 
> The pin_longterm*() variants also set FOLL_LONGTERM, in addition
> to FOLL_PIN:
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
> Thanks to Jan Kara and Vlastimil Babka for explaining the 4 cases
> in this documentation. (I've reworded it and expanded upon it.)
> 
> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>  # Documentation

>  Documentation/core-api/index.rst          |   1 +
>  Documentation/core-api/pin_user_pages.rst | 218 ++++++++++++++++++
>  include/linux/mm.h                        |  62 +++++-
>  mm/gup.c                                  | 260 ++++++++++++++++++++--
>  4 files changed, 514 insertions(+), 27 deletions(-)
>  create mode 100644 Documentation/core-api/pin_user_pages.rst
> 
> diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
> index ab0eae1c153a..413f7d7c8642 100644
> --- a/Documentation/core-api/index.rst
> +++ b/Documentation/core-api/index.rst
> @@ -31,6 +31,7 @@ Core utilities
>     generic-radix-tree
>     memory-allocation
>     mm-api
> +   pin_user_pages
>     gfp_mask-from-fs-io
>     timekeeping
>     boot-time-mm
> diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/core-api/pin_user_pages.rst
> new file mode 100644
> index 000000000000..ce819e709435
> --- /dev/null
> +++ b/Documentation/core-api/pin_user_pages.rst
> @@ -0,0 +1,218 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +====================================================
> +pin_user_pages() and related calls
> +====================================================
> +
> +.. contents:: :local:
> +
> +Overview
> +========
> +
> +This document describes the following functions: ::
> +
> + pin_user_pages
> + pin_user_pages_fast
> + pin_user_pages_remote
> +
> + pin_longterm_pages
> + pin_longterm_pages_fast
> + pin_longterm_pages_remote
> +
> +Basic description of FOLL_PIN
> +=============================
> +
> +FOLL_PIN and FOLL_LONGTERM are flags that can be passed to the get_user_pages*()
> +("gup") family of functions. FOLL_PIN has significant interactions and
> +interdependencies with FOLL_LONGTERM, so both are covered here.
> +
> +Both FOLL_PIN and FOLL_LONGTERM are internal to gup, meaning that neither
> +FOLL_PIN nor FOLL_LONGTERM should not appear at the gup call sites. This allows
> +the associated wrapper functions  (pin_user_pages() and others) to set the
> +correct combination of these flags, and to check for problems as well.
> +
> +FOLL_PIN and FOLL_GET are mutually exclusive for a given gup call. However,
> +multiple threads and call sites are free to pin the same struct pages, via both
> +FOLL_PIN and FOLL_GET. It's just the call site that needs to choose one or the
> +other, not the struct page(s).
> +
> +The FOLL_PIN implementation is nearly the same as FOLL_GET, except that FOLL_PIN
> +uses a different reference counting technique.
> +
> +FOLL_PIN is a prerequisite to FOLL_LONGTGERM. Another way of saying that is,
> +FOLL_LONGTERM is a specific case, more restrictive case of FOLL_PIN.
> +
> +Which flags are set by each wrapper
> +===================================
> +
> +Only FOLL_PIN and FOLL_LONGTERM are covered here. These flags are added to
> +whatever flags the caller provides::
> +
> + Function                    gup flags (FOLL_PIN or FOLL_LONGTERM only)
> + --------                    ------------------------------------------
> + pin_user_pages              FOLL_PIN
> + pin_user_pages_fast         FOLL_PIN
> + pin_user_pages_remote       FOLL_PIN
> +
> + pin_longterm_pages          FOLL_PIN | FOLL_LONGTERM
> + pin_longterm_pages_fast     FOLL_PIN | FOLL_LONGTERM
> + pin_longterm_pages_remote   FOLL_PIN | FOLL_LONGTERM
> +
> +Tracking dma-pinned pages
> +=========================
> +
> +Some of the key design constraints, and solutions, for tracking dma-pinned
> +pages:
> +
> +* An actual reference count, per struct page, is required. This is because
> +  multiple processes may pin and unpin a page.
> +
> +* False positives (reporting that a page is dma-pinned, when in fact it is not)
> +  are acceptable, but false negatives are not.
> +
> +* struct page may not be increased in size for this, and all fields are already
> +  used.
> +
> +* Given the above, we can overload the page->_refcount field by using, sort of,
> +  the upper bits in that field for a dma-pinned count. "Sort of", means that,
> +  rather than dividing page->_refcount into bit fields, we simple add a medium-
> +  large value (GUP_PIN_COUNTING_BIAS, initially chosen to be 1024: 10 bits) to
> +  page->_refcount. This provides fuzzy behavior: if a page has get_page() called
> +  on it 1024 times, then it will appear to have a single dma-pinned count.
> +  And again, that's acceptable.
> +
> +This also leads to limitations: there are only 31-10==21 bits available for a
> +counter that increments 10 bits at a time.
> +
> +TODO: for 1GB and larger huge pages, this is cutting it close. That's because
> +when pin_user_pages() follows such pages, it increments the head page by "1"
> +(where "1" used to mean "+1" for get_user_pages(), but now means "+1024" for
> +pin_user_pages()) for each tail page. So if you have a 1GB huge page:
> +
> +* There are 256K (18 bits) worth of 4 KB tail pages.
> +* There are 21 bits available to count up via GUP_PIN_COUNTING_BIAS (that is,
> +  10 bits at a time)
> +* There are 21 - 18 == 3 bits available to count. Except that there aren't,
> +  because you need to allow for a few normal get_page() calls on the head page,
> +  as well. Fortunately, the approach of using addition, rather than "hard"
> +  bitfields, within page->_refcount, allows for sharing these bits gracefully.
> +  But we're still looking at about 8 references.
> +
> +This, however, is a missing feature more than anything else, because it's easily
> +solved by addressing an obvious inefficiency in the original get_user_pages()
> +approach of retrieving pages: stop treating all the pages as if they were
> +PAGE_SIZE. Retrieve huge pages as huge pages. The callers need to be aware of
> +this, so some work is required. Once that's in place, this limitation mostly
> +disappears from view, because there will be ample refcounting range available.
> +
> +* Callers must specifically request "dma-pinned tracking of pages". In other
> +  words, just calling get_user_pages() will not suffice; a new set of functions,
> +  pin_user_page() and related, must be used.
> +
> +FOLL_PIN, FOLL_GET, FOLL_LONGTERM: when to use which flags
> +==========================================================
> +
> +Thanks to Jan Kara, Vlastimil Babka and several other -mm people, for describing
> +these categories:
> +
> +CASE 1: Direct IO (DIO)
> +-----------------------
> +There are GUP references to pages that are serving
> +as DIO buffers. These buffers are needed for a relatively short time (so they
> +are not "long term"). No special synchronization with page_mkclean() or
> +munmap() is provided. Therefore, flags to set at the call site are: ::
> +
> +    FOLL_PIN
> +
> +...but rather than setting FOLL_PIN directly, call sites should use one of
> +the pin_user_pages*() routines that set FOLL_PIN.
> +
> +CASE 2: RDMA
> +------------
> +There are GUP references to pages that are serving as DMA
> +buffers. These buffers are needed for a long time ("long term"). No special
> +synchronization with page_mkclean() or munmap() is provided. Therefore, flags
> +to set at the call site are: ::
> +
> +    FOLL_PIN | FOLL_LONGTERM
> +
> +NOTE: Some pages, such as DAX pages, cannot be pinned with longterm pins. That's
> +because DAX pages do not have a separate page cache, and so "pinning" implies
> +locking down file system blocks, which is not (yet) supported in that way.
> +
> +CASE 3: Hardware with page faulting support
> +-------------------------------------------
> +Here, a well-written driver doesn't normally need to pin pages at all. However,
> +if the driver does choose to do so, it can register MMU notifiers for the range,
> +and will be called back upon invalidation. Either way (avoiding page pinning, or
> +using MMU notifiers to unpin upon request), there is proper synchronization with
> +both filesystem and mm (page_mkclean(), munmap(), etc).
> +
> +Therefore, neither flag needs to be set.
> +
> +In this case, ideally, neither get_user_pages() nor pin_user_pages() should be
> +called. Instead, the software should be written so that it does not pin pages.
> +This allows mm and filesystems to operate more efficiently and reliably.
> +
> +CASE 4: Pinning for struct page manipulation only
> +-------------------------------------------------
> +Here, normal GUP calls are sufficient, so neither flag needs to be set.
> +
> +page_dma_pinned(): the whole point of pinning
> +=============================================
> +
> +The whole point of marking pages as "DMA-pinned" or "gup-pinned" is to be able
> +to query, "is this page DMA-pinned?" That allows code such as page_mkclean()
> +(and file system writeback code in general) to make informed decisions about
> +what to do when a page cannot be unmapped due to such pins.
> +
> +What to do in those cases is the subject of a years-long series of discussions
> +and debates (see the References at the end of this document). It's a TODO item
> +here: fill in the details once that's worked out. Meanwhile, it's safe to say
> +that having this available: ::
> +
> +        static inline bool page_dma_pinned(struct page *page)
> +
> +...is a prerequisite to solving the long-running gup+DMA problem.
> +
> +Another way of thinking about FOLL_GET, FOLL_PIN, and FOLL_LONGTERM
> +===================================================================
> +
> +Another way of thinking about these flags is as a progression of restrictions:
> +FOLL_GET is for struct page manipulation, without affecting the data that the
> +struct page refers to. FOLL_PIN is a *replacement* for FOLL_GET, and is for
> +short term pins on pages whose data *will* get accessed. As such, FOLL_PIN is
> +a "more severe" form of pinning. And finally, FOLL_LONGTERM is an even more
> +restrictive case that has FOLL_PIN as a prerequisite: this is for pages that
> +will be pinned longterm, and whose data will be accessed.
> +
> +Unit testing
> +============
> +This file::
> +
> + tools/testing/selftests/vm/gup_benchmark.c
> +
> +has the following new calls to exercise the new pin*() wrapper functions:
> +
> +* PIN_FAST_BENCHMARK (./gup_benchmark -a)
> +* PIN_LONGTERM_BENCHMARK (./gup_benchmark -a)
> +* PIN_BENCHMARK (./gup_benchmark -a)
> +
> +You can monitor how many total dma-pinned pages have been acquired and released
> +since the system was booted, via two new /proc/vmstat entries: ::
> +
> +    /proc/vmstat/nr_foll_pin_requested
> +    /proc/vmstat/nr_foll_pin_requested
> +
> +Those are both going to show zero, unless CONFIG_DEBUG_VM is set. This is
> +because there is a noticeable performance drop in put_user_page(), when they
> +are activated.
> +
> +References
> +==========
> +
> +* `Some slow progress on get_user_pages() (Apr 2, 2019) <https://lwn.net/Articles/784574/>`_
> +* `DMA and get_user_pages() (LPC: Dec 12, 2018) <https://lwn.net/Articles/774411/>`_
> +* `The trouble with get_user_pages() (Apr 30, 2018) <https://lwn.net/Articles/753027/>`_
> +
> +John Hubbard, October, 2019
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 96228376139c..11e0086d64a4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1542,9 +1542,23 @@ long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
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
> @@ -1552,6 +1566,10 @@ long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
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
> @@ -2610,13 +2628,15 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
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
> @@ -2631,11 +2651,41 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
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
> + * FOLL_PIN and FOLL_GET are mutually exclusive for a given function call.
> + * (The underlying pages may experience both FOLL_GET-based and FOLL_PIN-based
> + * calls applied to them, and that's perfectly OK. This is a constraint on the
> + * callers, not on the pages.)
> + *
> + * FOLL_PIN and FOLL_LONGTERM should be set internally by the pin_user_page*()
> + * and pin_longterm_*() APIs, never directly by the caller. That's in order to
> + * help avoid mismatches when releasing pages: get_user_pages*() pages must be
> + * released via put_page(), while pin_user_pages*() pages must be released via
> + * put_user_page().
> + *
> + * Please see Documentation/vm/pin_user_pages.rst for more information.
>   */
>  
>  static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
> diff --git a/mm/gup.c b/mm/gup.c
> index cfe6dc5fc343..ea31810da828 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -194,6 +194,10 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
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
> @@ -805,7 +809,7 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>  
>  	start = untagged_addr(start);
>  
> -	VM_BUG_ON(!!pages != !!(gup_flags & FOLL_GET));
> +	VM_BUG_ON(!!pages != !!(gup_flags & (FOLL_GET | FOLL_PIN)));
>  
>  	/*
>  	 * If FOLL_FORCE is set then do not force a full fault as the hinting
> @@ -1029,7 +1033,16 @@ static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
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
> @@ -1166,6 +1179,14 @@ long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
>  		unsigned int gup_flags, struct page **pages,
>  		struct vm_area_struct **vmas, int *locked)
>  {
> +	/*
> +	 * FOLL_PIN must only be set internally by the pin_user_page*() and
> +	 * pin_longterm_*() APIs, never directly by the caller, so enforce that
> +	 * with an assertion:
> +	 */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
> +		return -EINVAL;
> +
>  	/*
>  	 * Current FOLL_LONGTERM behavior is incompatible with
>  	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
> @@ -1626,6 +1647,14 @@ long get_user_pages(unsigned long start, unsigned long nr_pages,
>  		unsigned int gup_flags, struct page **pages,
>  		struct vm_area_struct **vmas)
>  {
> +	/*
> +	 * FOLL_PIN must only be set internally by the pin_user_page*() and
> +	 * pin_longterm_*() APIs, never directly by the caller, so enforce that
> +	 * with an assertion:
> +	 */
> +	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
> +		return -EINVAL;
> +
>  	return __gup_longterm_locked(current, current->mm, start, nr_pages,
>  				     pages, vmas, gup_flags | FOLL_TOUCH);
>  }
> @@ -2377,29 +2406,14 @@ static int __gup_longterm_unlocked(unsigned long start, int nr_pages,
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
>  
> -	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM)))
> +	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM | FOLL_PIN)))
>  		return -EINVAL;
>  
>  	start = untagged_addr(start) & PAGE_MASK;
> @@ -2439,4 +2453,208 @@ int get_user_pages_fast(unsigned long start, int nr_pages,
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
> + * Returns number of pages pinned. This may be fewer than the number requested.
> + * If nr_pages is 0 or negative, returns 0. If no pages were pinned, returns
> + * -errno.
> + */
> +int get_user_pages_fast(unsigned long start, int nr_pages,
> +			unsigned int gup_flags, struct page **pages)
> +{
> +	/*
> +	 * FOLL_PIN must only be set internally by the pin_user_page*() and
> +	 * pin_longterm_*() APIs, never directly by the caller, so enforce that:
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
> + * pin_user_pages_remote() - pin pages of a remote process (task != current)
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
> + * pin_longterm_pages_remote() - pin pages of a remote process (task != current)
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
> +	gup_flags |= FOLL_LONGTERM | FOLL_REMOTE | FOLL_PIN;
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
> 2.24.0
> 

-- 
Sincerely yours,
Mike.
