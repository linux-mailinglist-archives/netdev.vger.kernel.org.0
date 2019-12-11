Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F5E11A928
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfLKKmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:42:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:59588 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728030AbfLKKmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 05:42:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D483FB178;
        Wed, 11 Dec 2019 10:42:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id F3EB81E0B23; Wed, 11 Dec 2019 11:42:36 +0100 (CET)
Date:   Wed, 11 Dec 2019 11:42:36 +0100
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
Subject: Re: [PATCH v9 20/25] powerpc: book3s64: convert to pin_user_pages()
 and put_user_page()
Message-ID: <20191211104236.GM1551@quack2.suse.cz>
References: <20191211025318.457113-1-jhubbard@nvidia.com>
 <20191211025318.457113-21-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211025318.457113-21-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 10-12-19 18:53:13, John Hubbard wrote:
> 1. Convert from get_user_pages() to pin_user_pages().
> 
> 2. As required by pin_user_pages(), release these pages via
> put_user_page().
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

I'd just note that mm_iommu_do_alloc() has a pre-existing bug that the last
jump to 'free_exit' (at line 157) happens already after converting page
pointers to physical addresses so put_page() calls there will just crash.
But that's completely unrelated to your change. I'll send a fix separately.

								Honza

> ---
>  arch/powerpc/mm/book3s64/iommu_api.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
> index 56cc84520577..a86547822034 100644
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
> @@ -215,7 +214,8 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_mem_t *mem)
>  		if (mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY)
>  			SetPageDirty(page);
>  
> -		put_page(page);
> +		put_user_page(page);
> +
>  		mem->hpas[i] = 0;
>  	}
>  }
> -- 
> 2.24.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
