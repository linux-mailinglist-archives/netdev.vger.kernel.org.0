Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64655128237
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfLTS3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:29:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727390AbfLTS3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 13:29:45 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2FAC21655;
        Fri, 20 Dec 2019 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576866584;
        bh=ezMyUTqia+8GWq7yY+wOcF0j+RT4zhZQ09PnQwqq4KE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xtlhJ22m9XyJ5lWO10q+7J5Sk6+9idLwARTLc3T4M1a05GuHRH5id2sNGPiPWkdyw
         F5aNzJNH2Vp2YMQKi9OPbULXNoF3GMWuF3AVswdPVwVKkqEUvRJYUZgE627DNdfVQF
         4AwRtEvppRShBI0d5vgFOARlPmzYXsKhecOZipAc=
Date:   Fri, 20 Dec 2019 20:29:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     John Hubbard <jhubbard@nvidia.com>,
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
Message-ID: <20191220182939.GA10944@unreal>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191219132607.GA410823@unreal>
 <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
 <20191219210743.GN17227@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219210743.GN17227@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 05:07:43PM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 19, 2019 at 12:30:31PM -0800, John Hubbard wrote:
> > On 12/19/19 5:26 AM, Leon Romanovsky wrote:
> > > On Mon, Dec 16, 2019 at 02:25:12PM -0800, John Hubbard wrote:
> > > > Hi,
> > > >
> > > > This implements an API naming change (put_user_page*() -->
> > > > unpin_user_page*()), and also implements tracking of FOLL_PIN pages. It
> > > > extends that tracking to a few select subsystems. More subsystems will
> > > > be added in follow up work.
> > >
> > > Hi John,
> > >
> > > The patchset generates kernel panics in our IB testing. In our tests, we
> > > allocated single memory block and registered multiple MRs using the single
> > > block.
> > >
> > > The possible bad flow is:
> > >   ib_umem_geti() ->
> > >    pin_user_pages_fast(FOLL_WRITE) ->
> > >     internal_get_user_pages_fast(FOLL_WRITE) ->
> > >      gup_pgd_range() ->
> > >       gup_huge_pd() ->
> > >        gup_hugepte() ->
> > >         try_grab_compound_head() ->
> >
> > Hi Leon,
> >
> > Thanks very much for the detailed report! So we're overflowing...
> >
> > At first look, this seems likely to be hitting a weak point in the
> > GUP_PIN_COUNTING_BIAS-based design, one that I believed could be deferred
> > (there's a writeup in Documentation/core-api/pin_user_page.rst, lines
> > 99-121). Basically it's pretty easy to overflow the page->_refcount
> > with huge pages if the pages have a *lot* of subpages.
> >
> > We can only do about 7 pins on 1GB huge pages that use 4KB subpages.
>
> Considering that establishing these pins is entirely under user
> control, we can't have a limit here.
>
> If the number of allowed pins are exhausted then the
> pin_user_pages_fast() must fail back to the user.
>
> > 3. It would be nice if I could reproduce this. I have a two-node mlx5 Infiniband
> > test setup, but I have done only the tiniest bit of user space IB coding, so
> > if you have any test programs that aren't too hard to deal with that could
> > possibly hit this, or be tweaked to hit it, I'd be grateful. Keeping in mind
> > that I'm not an advanced IB programmer. At all. :)
>
> Clone this:
>
> https://github.com/linux-rdma/rdma-core.git
>
> Install all the required deps to build it (notably cython), see the README.md
>
> $ ./build.sh
> $ build/bin/run_tests.py
>
> If you get things that far I think Leon can get a reproduction for you

I'm not so optimistic about that.

Thanks

>
> Jason
