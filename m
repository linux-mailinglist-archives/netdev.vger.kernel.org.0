Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1024A120663
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfLPMyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:54:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:39022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727550AbfLPMx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 07:53:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 29D62AFAF;
        Mon, 16 Dec 2019 12:53:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 69B531E0B2E; Mon, 16 Dec 2019 13:53:53 +0100 (CET)
Date:   Mon, 16 Dec 2019 13:53:53 +0100
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
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v11 23/25] mm/gup: track FOLL_PIN pages
Message-ID: <20191216125353.GF22157@quack2.suse.cz>
References: <20191212101741.GD10065@quack2.suse.cz>
 <20191214032617.1670759-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191214032617.1670759-1-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 13-12-19 19:26:17, John Hubbard wrote:
> Add tracking of pages that were pinned via FOLL_PIN.
> 
> As mentioned in the FOLL_PIN documentation, callers who effectively set
> FOLL_PIN are required to ultimately free such pages via unpin_user_page().
> The effect is similar to FOLL_GET, and may be thought of as "FOLL_GET
> for DIO and/or RDMA use".
> 
> Pages that have been pinned via FOLL_PIN are identifiable via a
> new function call:
> 
>    bool page_dma_pinned(struct page *page);
> 
> What to do in response to encountering such a page, is left to later
> patchsets. There is discussion about this in [1], [2], and [3].
> 
> This also changes a BUG_ON(), to a WARN_ON(), in follow_page_mask().
> 
> [1] Some slow progress on get_user_pages() (Apr 2, 2019):
>     https://lwn.net/Articles/784574/
> [2] DMA and get_user_pages() (LPC: Dec 12, 2018):
>     https://lwn.net/Articles/774411/
> [3] The trouble with get_user_pages() (Apr 30, 2018):
>     https://lwn.net/Articles/753027/
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Jérôme Glisse <jglisse@redhat.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
> 
> Hi Jan,
> 
> This should address all of your comments for patch 23!

Thanks. One comment below:

> @@ -1486,6 +1500,10 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
>  	VM_BUG_ON_PAGE(!PageHead(page) && !is_zone_device_page(page), page);
>  	if (flags & FOLL_TOUCH)
>  		touch_pmd(vma, addr, pmd, flags);
> +
> +	if (!try_grab_page(page, flags))
> +		return ERR_PTR(-ENOMEM);
> +
>  	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
>  		/*
>  		 * We don't mlock() pte-mapped THPs. This way we can avoid

I'd move this still a bit higher - just after VM_BUG_ON_PAGE() and before
if (flags & FOLL_TOUCH) test. Because touch_pmd() can update page tables
and we don't won't that if we're going to fail the fault.

With this fixed, the patch looks good to me so you can then add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
