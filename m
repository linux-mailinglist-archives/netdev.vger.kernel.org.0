Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDCFEBAA0
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbfJaXi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:38:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:57516 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbfJaXi0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 19:38:26 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 16:38:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="400685375"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga005.fm.intel.com with ESMTP; 31 Oct 2019 16:38:25 -0700
Date:   Thu, 31 Oct 2019 16:38:25 -0700
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
Subject: Re: [PATCH 13/19] media/v4l2-core: pin_longterm_pages (FOLL_PIN) and
 put_user_page() conversion
Message-ID: <20191031233824.GL14771@iweiny-DESK2.sc.intel.com>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
 <20191030224930.3990755-14-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030224930.3990755-14-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:49:24PM -0700, John Hubbard wrote:
> 1. Change v4l2 from get_user_pages(FOLL_LONGTERM), to
> pin_longterm_pages(), which sets both FOLL_LONGTERM and FOLL_PIN.
> 
> 2. Because all FOLL_PIN-acquired pages must be released via
> put_user_page(), also convert the put_page() call over to
> put_user_pages_dirty_lock().
> 

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  drivers/media/v4l2-core/videobuf-dma-sg.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
> index 28262190c3ab..9b9c5b37bf59 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
> @@ -183,12 +183,12 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
>  	dprintk(1, "init user [0x%lx+0x%lx => %d pages]\n",
>  		data, size, dma->nr_pages);
>  
> -	err = get_user_pages(data & PAGE_MASK, dma->nr_pages,
> -			     flags | FOLL_LONGTERM, dma->pages, NULL);
> +	err = pin_longterm_pages(data & PAGE_MASK, dma->nr_pages,
> +				 flags, dma->pages, NULL);
>  
>  	if (err != dma->nr_pages) {
>  		dma->nr_pages = (err >= 0) ? err : 0;
> -		dprintk(1, "get_user_pages: err=%d [%d]\n", err,
> +		dprintk(1, "pin_longterm_pages: err=%d [%d]\n", err,
>  			dma->nr_pages);
>  		return err < 0 ? err : -EINVAL;
>  	}
> @@ -349,11 +349,8 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
>  	BUG_ON(dma->sglen);
>  
>  	if (dma->pages) {
> -		for (i = 0; i < dma->nr_pages; i++) {
> -			if (dma->direction == DMA_FROM_DEVICE)
> -				set_page_dirty_lock(dma->pages[i]);
> -			put_page(dma->pages[i]);
> -		}
> +		put_user_pages_dirty_lock(dma->pages, dma->nr_pages,
> +					  dma->direction == DMA_FROM_DEVICE);
>  		kfree(dma->pages);
>  		dma->pages = NULL;
>  	}
> -- 
> 2.23.0
> 
