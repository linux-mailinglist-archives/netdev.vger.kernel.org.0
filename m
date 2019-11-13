Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0756FAEEB
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfKMKu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 05:50:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:33800 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727432AbfKMKu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 05:50:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 91AAEB320;
        Wed, 13 Nov 2019 10:50:23 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 550261E1498; Wed, 13 Nov 2019 11:50:23 +0100 (CET)
Date:   Wed, 13 Nov 2019 11:50:23 +0100
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
Subject: Re: [PATCH v4 03/23] mm/gup: move try_get_compound_head() to top,
 fix minor issues
Message-ID: <20191113105023.GG6367@quack2.suse.cz>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-4-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113042710.3997854-4-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 12-11-19 20:26:50, John Hubbard wrote:
> An upcoming patch uses try_get_compound_head() more widely,
> so move it to the top of gup.c.
> 
> Also fix a tiny spelling error and a checkpatch.pl warning.
> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/gup.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 199da99e8ffc..933524de6249 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -29,6 +29,21 @@ struct follow_page_context {
>  	unsigned int page_mask;
>  };
>  
> +/*
> + * Return the compound head page with ref appropriately incremented,
> + * or NULL if that failed.
> + */
> +static inline struct page *try_get_compound_head(struct page *page, int refs)
> +{
> +	struct page *head = compound_head(page);
> +
> +	if (WARN_ON_ONCE(page_ref_count(head) < 0))
> +		return NULL;
> +	if (unlikely(!page_cache_add_speculative(head, refs)))
> +		return NULL;
> +	return head;
> +}
> +
>  /**
>   * put_user_pages_dirty_lock() - release and optionally dirty gup-pinned pages
>   * @pages:  array of pages to be maybe marked dirty, and definitely released.
> @@ -1793,20 +1808,6 @@ static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
>  	}
>  }
>  
> -/*
> - * Return the compund head page with ref appropriately incremented,
> - * or NULL if that failed.
> - */
> -static inline struct page *try_get_compound_head(struct page *page, int refs)
> -{
> -	struct page *head = compound_head(page);
> -	if (WARN_ON_ONCE(page_ref_count(head) < 0))
> -		return NULL;
> -	if (unlikely(!page_cache_add_speculative(head, refs)))
> -		return NULL;
> -	return head;
> -}
> -
>  #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
>  static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>  			 unsigned int flags, struct page **pages, int *nr)
> -- 
> 2.24.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
