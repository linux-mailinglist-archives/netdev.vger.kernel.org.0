Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FEBEBB30
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbfJaXtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:49:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:29993 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbfJaXtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 19:49:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 16:49:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="402058325"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga006.fm.intel.com with ESMTP; 31 Oct 2019 16:49:23 -0700
Date:   Thu, 31 Oct 2019 16:49:22 -0700
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
Subject: Re: [PATCH 19/19] Documentation/vm: add pin_user_pages.rst
Message-ID: <20191031234922.GM14771@iweiny-DESK2.sc.intel.com>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-20-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030224930.3990755-20-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:49:30PM -0700, John Hubbard wrote:
> Document the new pin_user_pages() and related calls
> and behavior.
> 
> Thanks to Jan Kara and Vlastimil Babka for explaining the 4 cases
> in this documentation. (I've reworded it and expanded on it slightly.)

As I said before I think this may be better in a previous patch where you
reference it.

Ira

> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  Documentation/vm/index.rst          |   1 +
>  Documentation/vm/pin_user_pages.rst | 213 ++++++++++++++++++++++++++++
>  2 files changed, 214 insertions(+)
>  create mode 100644 Documentation/vm/pin_user_pages.rst
> 
> diff --git a/Documentation/vm/index.rst b/Documentation/vm/index.rst
> index e8d943b21cf9..7194efa3554a 100644
> --- a/Documentation/vm/index.rst
> +++ b/Documentation/vm/index.rst
> @@ -44,6 +44,7 @@ descriptions of data structures and algorithms.
>     page_migration
>     page_frags
>     page_owner
> +   pin_user_pages
>     remap_file_pages
>     slub
>     split_page_table_lock
> diff --git a/Documentation/vm/pin_user_pages.rst b/Documentation/vm/pin_user_pages.rst
> new file mode 100644
> index 000000000000..7110bca3f188
> --- /dev/null
> +++ b/Documentation/vm/pin_user_pages.rst
> @@ -0,0 +1,213 @@
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
> +A new flag for get_user_pages ("gup") has been added: FOLL_PIN. FOLL_PIN has
> +significant interactions and interdependencies with FOLL_LONGTERM, so both are
> +covered here.
> +
> +Both FOLL_PIN and FOLL_LONGTERM are "internal" to gup, meaning that neither
> +FOLL_PIN nor FOLL_LONGTERM should not appear at the gup call sites. This allows
> +the associated wrapper functions  (pin_user_pages and others) to set the correct
> +combination of these flags, and to check for problems as well.
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
> +This also leads to limitations: there are only 32-10==22 bits available for a
> +counter that increments 10 bits at a time.
> +
> +TODO: for 1GB and larger huge pages, this is cutting it close. That's because
> +when pin_user_pages() follows such pages, it increments the head page by "1"
> +(where "1" used to mean "+1" for get_user_pages(), but now means "+1024" for
> +pin_user_pages()) for each tail page. So if you have a 1GB huge page:
> +
> +* There are 256K (18 bits) worth of 4 KB tail pages.
> +* There are 22 bits available to count up via GUP_PIN_COUNTING_BIAS (that is,
> +  10 bits at a time)
> +* There are 22 - 18 == 4 bits available to count. Except that there aren't,
> +  because you need to allow for a few normal get_page() calls on the head page,
> +  as well. Fortunately, the approach of using addition, rather than "hard"
> +  bitfields, within page->_refcount, allows for sharing these bits gracefully.
> +  But we're still looking at about 16 references.
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
> +TODO: There is also a special case when the pages are DAX pages: in addition to
> +the above flags, the caller needs something like a layout lease on the
> +associated file. This is yet to be implemented. When it is implemented, it's
> +expected that the lease will be a prerequisite to setting FOLL_LONGTERM.

For now we probably want to leave this note out until we figure out how this is
going to work.  Best to say something like:

Some pages, such as DAX pages, can't be pinned with longterm pins and will
fail.

Ira

> +
> +CASE 3: ODP
> +-----------
> +(Mellanox/Infiniband On Demand Paging: the hardware supports
> +replayable page faulting). There are GUP references to pages serving as DMA
> +buffers. For ODP, MMU notifiers are used to synchronize with page_mkclean()
> +and munmap(). Therefore, normal GUP calls are sufficient, so neither flag
> +needs to be set.
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
> -- 
> 2.23.0
> 
