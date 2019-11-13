Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0174FAF7B
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 12:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfKMLP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 06:15:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:47422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727316AbfKMLP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 06:15:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69351B4F8;
        Wed, 13 Nov 2019 11:15:23 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D45001E1498; Wed, 13 Nov 2019 12:15:21 +0100 (CET)
Date:   Wed, 13 Nov 2019 12:15:21 +0100
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
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v4 02/23] mm/gup: factor out duplicate code from four
 routines
Message-ID: <20191113111521.GI6367@quack2.suse.cz>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
 <20191113042710.3997854-3-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191113042710.3997854-3-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 12-11-19 20:26:49, John Hubbard wrote:
> There are four locations in gup.c that have a fair amount of code
> duplication. This means that changing one requires making the same
> changes in four places, not to mention reading the same code four
> times, and wondering if there are subtle differences.
> 
> Factor out the common code into static functions, thus reducing the
> overall line count and the code's complexity.
> 
> Also, take the opportunity to slightly improve the efficiency of the
> error cases, by doing a mass subtraction of the refcount, surrounded
> by get_page()/put_page().
> 
> Also, further simplify (slightly), by waiting until the the successful
> end of each routine, to increment *nr.
> 
> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

> diff --git a/mm/gup.c b/mm/gup.c
> index 85caf76b3012..199da99e8ffc 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1969,6 +1969,34 @@ static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long addr,
>  }
>  #endif
>  
> +static int __record_subpages(struct page *page, unsigned long addr,
> +			     unsigned long end, struct page **pages, int nr)
> +{
> +	int nr_recorded_pages = 0;
> +
> +	do {
> +		pages[nr] = page;
> +		nr++;
> +		page++;
> +		nr_recorded_pages++;
> +	} while (addr += PAGE_SIZE, addr != end);
> +	return nr_recorded_pages;
> +}

Why don't you pass in already pages + nr?

> +
> +static void put_compound_head(struct page *page, int refs)
> +{
> +	/* Do a get_page() first, in case refs == page->_refcount */
> +	get_page(page);
> +	page_ref_sub(page, refs);
> +	put_page(page);
> +}
> +
> +static void __huge_pt_done(struct page *head, int nr_recorded_pages, int *nr)
> +{
> +	*nr += nr_recorded_pages;
> +	SetPageReferenced(head);
> +}

I don't find this last helper very useful. It seems to muddy water more
than necessary...

Other than that the cleanup looks nice to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
