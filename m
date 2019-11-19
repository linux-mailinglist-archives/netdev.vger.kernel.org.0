Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4ED0102351
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfKSLh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:37:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:35362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727557AbfKSLh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 06:37:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8BC3DBCC5;
        Tue, 19 Nov 2019 11:37:52 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 1D7961E47E5; Tue, 19 Nov 2019 12:37:46 +0100 (CET)
Date:   Tue, 19 Nov 2019 12:37:46 +0100
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
Subject: Re: [PATCH v6 17/24] mm/gup: track FOLL_PIN pages
Message-ID: <20191119113746.GD25605@quack2.suse.cz>
References: <20191119081643.1866232-1-jhubbard@nvidia.com>
 <20191119081643.1866232-18-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119081643.1866232-18-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 19-11-19 00:16:36, John Hubbard wrote:
> @@ -2025,6 +2149,20 @@ static int __record_subpages(struct page *page, unsigned long addr,
>  	return nr;
>  }
>  
> +static bool __pin_compound_head(struct page *head, int refs, unsigned int flags)
> +{

I don't quite like the proliferation of names starting with __. I don't
think there's a good reason for that, particularly in this case. Also 'pin'
here is somewhat misleading as we already use term "pin" for the particular
way of pinning the page. We could have grab_compound_head() or maybe
nail_compound_head() :), but you're native speaker so you may come up with
better word.

> +	if (flags & FOLL_PIN) {
> +		if (unlikely(!try_pin_compound_head(head, refs)))
> +			return false;
> +	} else {
> +		head = try_get_compound_head(head, refs);
> +		if (!head)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  static void put_compound_head(struct page *page, int refs)
>  {
>  	/* Do a get_page() first, in case refs == page->_refcount */

put_compound_head() needs similar treatment as undo_dev_pagemap(), doesn't
it?

> @@ -968,7 +973,18 @@ struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
>  	if (!*pgmap)
>  		return ERR_PTR(-EFAULT);
>  	page = pfn_to_page(pfn);
> -	get_page(page);
> +
> +	if (flags & FOLL_GET)
> +		get_page(page);
> +	else if (flags & FOLL_PIN) {
> +		/*
> +		 * try_pin_page() is not actually expected to fail here because
> +		 * we hold the pmd lock so no one can unmap the pmd and free the
> +		 * page that it points to.
> +		 */
> +		if (unlikely(!try_pin_page(page)))
> +			page = ERR_PTR(-EFAULT);
> +	}

This pattern is rather common. So maybe I'd add a helper grab_page(page,
flags) doing

	if (flags & FOLL_GET)
		get_page(page);
	else if (flags & FOLL_PIN)
		return try_pin_page(page);
	return true;

Otherwise the patch looks good to me now.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
