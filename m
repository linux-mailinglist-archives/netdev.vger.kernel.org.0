Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D78108A65
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 09:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfKYI7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 03:59:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:56606 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725793AbfKYI7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 03:59:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F1475B308;
        Mon, 25 Nov 2019 08:59:16 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 1906B1E0A57; Mon, 25 Nov 2019 09:59:15 +0100 (CET)
Date:   Mon, 25 Nov 2019 09:59:15 +0100
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
Subject: Re: [PATCH 17/19] powerpc: book3s64: convert to pin_user_pages() and
 put_user_page()
Message-ID: <20191125085915.GB1797@quack2.suse.cz>
References: <20191125042011.3002372-1-jhubbard@nvidia.com>
 <20191125042011.3002372-18-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125042011.3002372-18-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun 24-11-19 20:20:09, John Hubbard wrote:
> 1. Convert from get_user_pages() to pin_user_pages().
> 
> 2. As required by pin_user_pages(), release these pages via
> put_user_page(). In this case, do so via put_user_pages_dirty_lock().
> 
> That has the side effect of calling set_page_dirty_lock(), instead
> of set_page_dirty(). This is probably more accurate.
> 
> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
> dealing with a file backed page where we have reference on the inode it
> hangs off." [1]
> 
> 3. Release each page in mem->hpages[] (instead of mem->hpas[]), because
> that is the array that pin_longterm_pages() filled in. This is more
> accurate and should be a little safer from a maintenance point of
> view.

Except that this breaks the code. hpages is unioned with hpas...

> [1] https://lore.kernel.org/r/20190723153640.GB720@lst.de
> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  arch/powerpc/mm/book3s64/iommu_api.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
> index 56cc84520577..196383e8e5a9 100644
> --- a/arch/powerpc/mm/book3s64/iommu_api.c
> +++ b/arch/powerpc/mm/book3s64/iommu_api.c
> @@ -103,7 +103,7 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
>  	for (entry = 0; entry < entries; entry += chunk) {
>  		unsigned long n = min(entries - entry, chunk);
>  
> -		ret = get_user_pages(ua + (entry << PAGE_SHIFT), n,
> +		ret = pin_user_pages(ua + (entry << PAGE_SHIFT), n,
>  				FOLL_WRITE | FOLL_LONGTERM,
>  				mem->hpages + entry, NULL);
>  		if (ret == n) {
> @@ -167,9 +167,8 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
>  	return 0;
>  
>  free_exit:
> -	/* free the reference taken */
> -	for (i = 0; i < pinned; i++)
> -		put_page(mem->hpages[i]);
> +	/* free the references taken */
> +	put_user_pages(mem->hpages, pinned);
>  
>  	vfree(mem->hpas);
>  	kfree(mem);
> @@ -212,10 +211,9 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_mem_t *mem)
>  		if (!page)
>  			continue;
>  
> -		if (mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY)
> -			SetPageDirty(page);
> +		put_user_pages_dirty_lock(&mem->hpages[i], 1,
> +					  MM_IOMMU_TABLE_GROUP_PAGE_DIRTY);

And the dirtying condition is wrong here as well. Currently it is always
true.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
