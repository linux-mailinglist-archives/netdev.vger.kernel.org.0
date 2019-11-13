Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3456BFB7BD
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 19:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfKMSi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 13:38:26 -0500
Received: from mga03.intel.com ([134.134.136.65]:57924 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727538AbfKMSiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 13:38:25 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 10:38:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,301,1569308400"; 
   d="scan'208";a="207879666"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga006.jf.intel.com with ESMTP; 13 Nov 2019 10:38:23 -0800
Date:   Wed, 13 Nov 2019 10:38:23 -0800
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
Subject: Re: [PATCH v4 03/23] mm/gup: move try_get_compound_head() to top,
 fix minor issues
Message-ID: <20191113183822.GC12699@iweiny-DESK2.sc.intel.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-4-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113042710.3997854-4-jhubbard@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 08:26:50PM -0800, John Hubbard wrote:
> An upcoming patch uses try_get_compound_head() more widely,
> so move it to the top of gup.c.
> 
> Also fix a tiny spelling error and a checkpatch.pl warning.
> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Simple enough...

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

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
