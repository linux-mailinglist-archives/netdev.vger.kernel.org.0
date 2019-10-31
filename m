Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2ACEEBA65
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfJaXfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:35:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:53761 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfJaXfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 19:35:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 16:35:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="206259359"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by FMSMGA003.fm.intel.com with ESMTP; 31 Oct 2019 16:35:19 -0700
Date:   Thu, 31 Oct 2019 16:35:19 -0700
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
Subject: Re: [PATCH 08/19] mm/process_vm_access: set FOLL_PIN via
 pin_user_pages_remote()
Message-ID: <20191031233519.GH14771@iweiny-DESK2.sc.intel.com>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-9-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030224930.3990755-9-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:49:19PM -0700, John Hubbard wrote:
> Convert process_vm_access to use the new pin_user_pages_remote()
> call, which sets FOLL_PIN. Setting FOLL_PIN is now required for
> code that requires tracking of pinned pages.
> 
> Also, release the pages via put_user_page*().
> 
> Also, rename "pages" to "pinned_pages", as this makes for
> easier reading of process_vm_rw_single_vec().

Ok...  but it made review a bit harder...

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  mm/process_vm_access.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> index 357aa7bef6c0..fd20ab675b85 100644
> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -42,12 +42,11 @@ static int process_vm_rw_pages(struct page **pages,
>  		if (copy > len)
>  			copy = len;
>  
> -		if (vm_write) {
> +		if (vm_write)
>  			copied = copy_page_from_iter(page, offset, copy, iter);
> -			set_page_dirty_lock(page);
> -		} else {
> +		else
>  			copied = copy_page_to_iter(page, offset, copy, iter);
> -		}
> +
>  		len -= copied;
>  		if (copied < copy && iov_iter_count(iter))
>  			return -EFAULT;
> @@ -96,7 +95,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
>  		flags |= FOLL_WRITE;
>  
>  	while (!rc && nr_pages && iov_iter_count(iter)) {
> -		int pages = min(nr_pages, max_pages_per_loop);
> +		int pinned_pages = min(nr_pages, max_pages_per_loop);
>  		int locked = 1;
>  		size_t bytes;
>  
> @@ -106,14 +105,15 @@ static int process_vm_rw_single_vec(unsigned long addr,
>  		 * current/current->mm
>  		 */
>  		down_read(&mm->mmap_sem);
> -		pages = get_user_pages_remote(task, mm, pa, pages, flags,
> -					      process_pages, NULL, &locked);
> +		pinned_pages = pin_user_pages_remote(task, mm, pa, pinned_pages,
> +						     flags, process_pages,
> +						     NULL, &locked);
>  		if (locked)
>  			up_read(&mm->mmap_sem);
> -		if (pages <= 0)
> +		if (pinned_pages <= 0)
>  			return -EFAULT;
>  
> -		bytes = pages * PAGE_SIZE - start_offset;
> +		bytes = pinned_pages * PAGE_SIZE - start_offset;
>  		if (bytes > len)
>  			bytes = len;
>  
> @@ -122,10 +122,12 @@ static int process_vm_rw_single_vec(unsigned long addr,
>  					 vm_write);
>  		len -= bytes;
>  		start_offset = 0;
> -		nr_pages -= pages;
> -		pa += pages * PAGE_SIZE;
> -		while (pages)
> -			put_page(process_pages[--pages]);
> +		nr_pages -= pinned_pages;
> +		pa += pinned_pages * PAGE_SIZE;
> +
> +		/* If vm_write is set, the pages need to be made dirty: */
> +		put_user_pages_dirty_lock(process_pages, pinned_pages,
> +					  vm_write);
>  	}
>  
>  	return rc;
> -- 
> 2.23.0
> 
