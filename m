Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB93D128877
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 11:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfLUKIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 05:08:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfLUKIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 05:08:49 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A0D0206EC;
        Sat, 21 Dec 2019 10:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576922927;
        bh=9acaA/8fKn1399pza9UZM74CCEP9IQOiAcwxAFB8uv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C5VL6ejrikwv/fPR/5hW1vC5g7ZxqQArLHZI9V0Acv45zpCoEu7KVSUG363aSOh1d
         8mWTxU92Mkz/MNea4rOvwk4lPkm3QVmugiAJmAPtyzW4ix2JAMqI4I9mKaT4oTHqTx
         danVQGmjzaX4h7HmaTFOuro/EjXVdeZW+yY0HmyE=
Date:   Sat, 21 Dec 2019 12:08:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
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
        Maor Gottlieb <maorg@mellanox.com>
Subject: Re: [PATCH v11 00/25] mm/gup: track dma-pinned pages: FOLL_PIN
Message-ID: <20191221100843.GB13335@unreal>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191219132607.GA410823@unreal>
 <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
 <20191219210743.GN17227@ziepe.ca>
 <20191220182939.GA10944@unreal>
 <1001a5fc-a71d-9c0f-1090-546c4913d8a2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1001a5fc-a71d-9c0f-1090-546c4913d8a2@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 03:54:55PM -0800, John Hubbard wrote:
> On 12/20/19 10:29 AM, Leon Romanovsky wrote:
> ...
> >> $ ./build.sh
> >> $ build/bin/run_tests.py
> >>
> >> If you get things that far I think Leon can get a reproduction for you
> >
> > I'm not so optimistic about that.
> >
>
> OK, I'm going to proceed for now on the assumption that I've got an overflow
> problem that happens when huge pages are pinned. If I can get more information,
> great, otherwise it's probably enough.
>
> One thing: for your repro, if you know the huge page size, and the system
> page size for that case, that would really help. Also the number of pins per
> page, more or less, that you'd expect. Because Jason says that only 2M huge
> pages are used...
>
> Because the other possibility is that the refcount really is going negative,
> likely due to a mismatched pin/unpin somehow.
>
> If there's not an obvious repro case available, but you do have one (is it easy
> to repro, though?), then *if* you have the time, I could point you to a github
> branch that reduces GUP_PIN_COUNTING_BIAS by, say, 4x, by applying this:

I'll see what I can do this Sunday.

>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index bb44c4d2ada7..8526fd03b978 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1077,7 +1077,7 @@ static inline void put_page(struct page *page)
>   * get_user_pages and page_mkclean and other calls that race to set up page
>   * table entries.
>   */
> -#define GUP_PIN_COUNTING_BIAS (1U << 10)
> +#define GUP_PIN_COUNTING_BIAS (1U << 8)
>
>  void unpin_user_page(struct page *page);
>  void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
>
> If that fails to repro, then we would be zeroing in on the root cause.
>
> The branch is here (I just tested it and it seems healthy):
>
> git@github.com:johnhubbard/linux.git  pin_user_pages_tracking_v11_with_diags
>
>
>
> thanks,
> --
> John Hubbard
> NVIDIA
