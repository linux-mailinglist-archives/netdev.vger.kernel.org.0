Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E29D100518
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 13:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfKRMBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 07:01:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:37574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726895AbfKRMB1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 07:01:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E731CB061;
        Mon, 18 Nov 2019 12:01:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 7EC421E4B09; Mon, 18 Nov 2019 11:16:58 +0100 (CET)
Date:   Mon, 18 Nov 2019 11:16:58 +0100
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
Subject: Re: [PATCH v5 11/24] goldish_pipe: convert to pin_user_pages() and
 put_user_page()
Message-ID: <20191118101658.GG17319@quack2.suse.cz>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
 <20191115055340.1825745-12-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115055340.1825745-12-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 14-11-19 21:53:27, John Hubbard wrote:
> 1. Call the new global pin_user_pages_fast(), from pin_goldfish_pages().
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
> Another side effect is that the release code is simplified because
> the page[] loop is now in gup.c instead of here, so just delete the
> local release_user_pages() entirely, and call
> put_user_pages_dirty_lock() directly, instead.
> 
> [1] https://lore.kernel.org/r/20190723153640.GB720@lst.de
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/platform/goldfish/goldfish_pipe.c | 17 +++--------------
>  1 file changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
> index 7ed2a21a0bac..635a8bc1b480 100644
> --- a/drivers/platform/goldfish/goldfish_pipe.c
> +++ b/drivers/platform/goldfish/goldfish_pipe.c
> @@ -274,7 +274,7 @@ static int pin_goldfish_pages(unsigned long first_page,
>  		*iter_last_page_size = last_page_size;
>  	}
>  
> -	ret = get_user_pages_fast(first_page, requested_pages,
> +	ret = pin_user_pages_fast(first_page, requested_pages,
>  				  !is_write ? FOLL_WRITE : 0,
>  				  pages);
>  	if (ret <= 0)
> @@ -285,18 +285,6 @@ static int pin_goldfish_pages(unsigned long first_page,
>  	return ret;
>  }
>  
> -static void release_user_pages(struct page **pages, int pages_count,
> -			       int is_write, s32 consumed_size)
> -{
> -	int i;
> -
> -	for (i = 0; i < pages_count; i++) {
> -		if (!is_write && consumed_size > 0)
> -			set_page_dirty(pages[i]);
> -		put_page(pages[i]);
> -	}
> -}
> -
>  /* Populate the call parameters, merging adjacent pages together */
>  static void populate_rw_params(struct page **pages,
>  			       int pages_count,
> @@ -372,7 +360,8 @@ static int transfer_max_buffers(struct goldfish_pipe *pipe,
>  
>  	*consumed_size = pipe->command_buffer->rw_params.consumed_size;
>  
> -	release_user_pages(pipe->pages, pages_count, is_write, *consumed_size);
> +	put_user_pages_dirty_lock(pipe->pages, pages_count,
> +				  !is_write && *consumed_size > 0);
>  
>  	mutex_unlock(&pipe->lock);
>  	return 0;
> -- 
> 2.24.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
