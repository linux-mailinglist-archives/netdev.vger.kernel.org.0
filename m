Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3324100533
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 13:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfKRMCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 07:02:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:37464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726760AbfKRMBZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 07:01:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BB66FB02C;
        Mon, 18 Nov 2019 12:01:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 7DE191E4B03; Mon, 18 Nov 2019 10:49:18 +0100 (CET)
Date:   Mon, 18 Nov 2019 10:49:18 +0100
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
        Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v5 07/24] IB/umem: use get_user_pages_fast() to pin DMA
 pages
Message-ID: <20191118094918.GE17319@quack2.suse.cz>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
 <20191115055340.1825745-8-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115055340.1825745-8-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 14-11-19 21:53:23, John Hubbard wrote:
> And get rid of the mmap_sem calls, as part of that. Note
> that get_user_pages_fast() will, if necessary, fall back to
> __gup_longterm_unlocked(), which takes the mmap_sem as needed.
> 
> Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  drivers/infiniband/core/umem.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index 24244a2f68cc..3d664a2539eb 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -271,16 +271,13 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
>  	sg = umem->sg_head.sgl;
>  
>  	while (npages) {
> -		down_read(&mm->mmap_sem);
> -		ret = get_user_pages(cur_base,
> -				     min_t(unsigned long, npages,
> -					   PAGE_SIZE / sizeof (struct page *)),
> -				     gup_flags | FOLL_LONGTERM,
> -				     page_list, NULL);
> -		if (ret < 0) {
> -			up_read(&mm->mmap_sem);
> +		ret = get_user_pages_fast(cur_base,
> +					  min_t(unsigned long, npages,
> +						PAGE_SIZE /
> +						sizeof(struct page *)),
> +					  gup_flags | FOLL_LONGTERM, page_list);
> +		if (ret < 0)
>  			goto umem_release;
> -		}
>  
>  		cur_base += ret * PAGE_SIZE;
>  		npages   -= ret;
> @@ -288,8 +285,6 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
>  		sg = ib_umem_add_sg_table(sg, page_list, ret,
>  			dma_get_max_seg_size(context->device->dma_device),
>  			&umem->sg_nents);
> -
> -		up_read(&mm->mmap_sem);
>  	}
>  
>  	sg_mark_end(sg);
> -- 
> 2.24.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
