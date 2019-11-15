Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E105BFE48C
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 19:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKOSGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 13:06:35 -0500
Received: from mga05.intel.com ([192.55.52.43]:12098 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfKOSGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 13:06:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2019 10:06:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,309,1569308400"; 
   d="scan'208";a="203454343"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga008.fm.intel.com with ESMTP; 15 Nov 2019 10:06:32 -0800
Date:   Fri, 15 Nov 2019 10:06:32 -0800
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
Subject: Re: [PATCH v5 09/24] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
Message-ID: <20191115180631.GA23832@iweiny-DESK2.sc.intel.com>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
 <20191115055340.1825745-10-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115055340.1825745-10-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 09:53:25PM -0800, John Hubbard wrote:
> As it says in the updated comment in gup.c: current FOLL_LONGTERM
> behavior is incompatible with FAULT_FLAG_ALLOW_RETRY because of the
> FS DAX check requirement on vmas.
> 
> However, the corresponding restriction in get_user_pages_remote() was
> slightly stricter than is actually required: it forbade all
> FOLL_LONGTERM callers, but we can actually allow FOLL_LONGTERM callers
> that do not set the "locked" arg.
> 
> Update the code and comments accordingly, and update the VFIO caller
> to take advantage of this, fixing a bug as a result: the VFIO caller
> is logically a FOLL_LONGTERM user.
> 
> Also, remove an unnessary pair of calls that were releasing and
> reacquiring the mmap_sem. There is no need to avoid holding mmap_sem
> just in order to call page_to_pfn().
> 
> Also, move the DAX check ("if a VMA is DAX, don't allow long term
> pinning") from the VFIO call site, all the way into the internals
> of get_user_pages_remote() and __gup_longterm_locked(). That is:
> get_user_pages_remote() calls __gup_longterm_locked(), which in turn
> calls check_dax_vmas(). It's lightly explained in the comments as well.
> 
> Thanks to Jason Gunthorpe for pointing out a clean way to fix this,
> and to Dan Williams for helping clarify the DAX refactoring.
> 
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Jerome Glisse <jglisse@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 30 +++++-------------------------
>  mm/gup.c                        | 27 ++++++++++++++++++++++-----
>  2 files changed, 27 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index d864277ea16f..c7a111ad9975 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -340,7 +340,6 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  {
>  	struct page *page[1];
>  	struct vm_area_struct *vma;
> -	struct vm_area_struct *vmas[1];
>  	unsigned int flags = 0;
>  	int ret;
>  
> @@ -348,33 +347,14 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  		flags |= FOLL_WRITE;
>  
>  	down_read(&mm->mmap_sem);
> -	if (mm == current->mm) {
> -		ret = get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
> -				     vmas);
> -	} else {
> -		ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
> -					    vmas, NULL);
> -		/*
> -		 * The lifetime of a vaddr_get_pfn() page pin is
> -		 * userspace-controlled. In the fs-dax case this could
> -		 * lead to indefinite stalls in filesystem operations.
> -		 * Disallow attempts to pin fs-dax pages via this
> -		 * interface.
> -		 */
> -		if (ret > 0 && vma_is_fsdax(vmas[0])) {
> -			ret = -EOPNOTSUPP;
> -			put_page(page[0]);
> -		}
> -	}
> -	up_read(&mm->mmap_sem);
> -
> +	ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
> +				    page, NULL, NULL);
>  	if (ret == 1) {
>  		*pfn = page_to_pfn(page[0]);
> -		return 0;
> +		ret = 0;
> +		goto done;
>  	}
>  
> -	down_read(&mm->mmap_sem);
> -
>  	vaddr = untagged_addr(vaddr);
>  
>  	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
> @@ -384,7 +364,7 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  		if (is_invalid_reserved_pfn(*pfn))
>  			ret = 0;
>  	}
> -
> +done:
>  	up_read(&mm->mmap_sem);
>  	return ret;
>  }
> diff --git a/mm/gup.c b/mm/gup.c
> index b859bd4da4d7..6cf613bfe7dc 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -29,6 +29,13 @@ struct follow_page_context {
>  	unsigned int page_mask;
>  };
>  
> +static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
> +						  struct mm_struct *mm,
> +						  unsigned long start,
> +						  unsigned long nr_pages,
> +						  struct page **pages,
> +						  struct vm_area_struct **vmas,
> +						  unsigned int flags);
>  /*
>   * Return the compound head page with ref appropriately incremented,
>   * or NULL if that failed.
> @@ -1167,13 +1174,23 @@ long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
>  		struct vm_area_struct **vmas, int *locked)
>  {
>  	/*
> -	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
> +	 * Parts of FOLL_LONGTERM behavior are incompatible with
>  	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
> -	 * vmas.  As there are no users of this flag in this call we simply
> -	 * disallow this option for now.
> +	 * vmas. However, this only comes up if locked is set, and there are
> +	 * callers that do request FOLL_LONGTERM, but do not set locked. So,
> +	 * allow what we can.
>  	 */
> -	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
> -		return -EINVAL;
> +	if (gup_flags & FOLL_LONGTERM) {
> +		if (WARN_ON_ONCE(locked))
> +			return -EINVAL;
> +		/*
> +		 * This will check the vmas (even if our vmas arg is NULL)
> +		 * and return -ENOTSUPP if DAX isn't allowed in this case:
> +		 */
> +		return __gup_longterm_locked(tsk, mm, start, nr_pages, pages,
> +					     vmas, gup_flags | FOLL_TOUCH |
> +					     FOLL_REMOTE);
> +	}
>  
>  	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
>  				       locked,
> -- 
> 2.24.0
> 
