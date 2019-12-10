Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9332111850A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfLJK2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:28:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:58544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbfLJK2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 05:28:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 769B2B280;
        Tue, 10 Dec 2019 10:28:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E89EB1E0B23; Tue, 10 Dec 2019 11:28:18 +0100 (CET)
Date:   Tue, 10 Dec 2019 11:28:18 +0100
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
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH v8 08/26] mm/gup: allow FOLL_FORCE for
 get_user_pages_fast()
Message-ID: <20191210102818.GF1551@quack2.suse.cz>
References: <20191209225344.99740-1-jhubbard@nvidia.com>
 <20191209225344.99740-9-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209225344.99740-9-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 09-12-19 14:53:26, John Hubbard wrote:
> Commit 817be129e6f2 ("mm: validate get_user_pages_fast flags") allowed
> only FOLL_WRITE and FOLL_LONGTERM to be passed to get_user_pages_fast().
> This, combined with the fact that get_user_pages_fast() falls back to
> "slow gup", which *does* accept FOLL_FORCE, leads to an odd situation:
> if you need FOLL_FORCE, you cannot call get_user_pages_fast().
> 
> There does not appear to be any reason for filtering out FOLL_FORCE.
> There is nothing in the _fast() implementation that requires that we
> avoid writing to the pages. So it appears to have been an oversight.
> 
> Fix by allowing FOLL_FORCE to be set for get_user_pages_fast().
> 
> Fixes: 817be129e6f2 ("mm: validate get_user_pages_fast flags")
> Cc: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/gup.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index c0c56888e7cc..958ab0757389 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2414,7 +2414,8 @@ int get_user_pages_fast(unsigned long start, int nr_pages,
>  	unsigned long addr, len, end;
>  	int nr = 0, ret = 0;
>  
> -	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM)))
> +	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
> +				       FOLL_FORCE)))
>  		return -EINVAL;
>  
>  	start = untagged_addr(start) & PAGE_MASK;
> -- 
> 2.24.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
