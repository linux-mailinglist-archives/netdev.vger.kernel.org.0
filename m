Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2425B130F18
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 10:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgAFJCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 04:02:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:50152 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgAFJCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 04:02:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B2328B027;
        Mon,  6 Jan 2020 09:01:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 821931E0B47; Mon,  6 Jan 2020 10:01:47 +0100 (CET)
Date:   Mon, 6 Jan 2020 10:01:47 +0100
From:   Jan Kara <jack@suse.cz>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
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
        Maor Gottlieb <maorg@mellanox.com>,
        Ran Rozenstein <ranro@mellanox.com>
Subject: Re: [PATCH v11 00/25] mm/gup: track dma-pinned pages: FOLL_PIN
Message-ID: <20200106090147.GA9176@quack2.suse.cz>
References: <20191219132607.GA410823@unreal>
 <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
 <20191219210743.GN17227@ziepe.ca>
 <20191220182939.GA10944@unreal>
 <1001a5fc-a71d-9c0f-1090-546c4913d8a2@nvidia.com>
 <20191222132357.GF13335@unreal>
 <49d57efe-85e1-6910-baf5-c18df1382206@nvidia.com>
 <20191225052612.GA212002@unreal>
 <b879d191-a07c-e808-e48f-2b9bd8ba4fa3@nvidia.com>
 <612aa292-ec45-295c-b56c-c622876620fa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <612aa292-ec45-295c-b56c-c622876620fa@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 28-12-19 20:33:32, John Hubbard wrote:
> On 12/27/19 1:56 PM, John Hubbard wrote:
> ...
> >> It is ancient verification test (~10y) which is not an easy task to
> >> make it understandable and standalone :).
> >>
> > 
> > Is this the only test that fails, btw? No other test failures or hints of
> > problems?
> > 
> > (Also, maybe hopeless, but can *anyone* on the RDMA list provide some
> > characterization of the test, such as how many pins per page, what page
> > sizes are used? I'm still hoping to write a test to trigger something
> > close to this...)
> > 
> > I do have a couple more ideas for test runs:
> > 
> > 1. Reduce GUP_PIN_COUNTING_BIAS to 1. That would turn the whole override of
> > page->_refcount into a no-op, and so if all is well (it may not be!) with the
> > rest of the patch, then we'd expect this problem to not reappear.
> > 
> > 2. Active /proc/vmstat *foll_pin* statistics unconditionally (just for these
> > tests, of course), so we can see if there is a get/put mismatch. However, that
> > will change the timing, and so it must be attempted independently of (1), in
> > order to see if it ends up hiding the repro.
> > 
> > I've updated this branch to implement (1), but not (2), hoping you can give
> > this one a spin?
> > 
> >     git@github.com:johnhubbard/linux.git  pin_user_pages_tracking_v11_with_diags
> > 
> > 
> 
> Also, looking ahead:
> 
> a) if the problem disappears with the latest above test, then we likely have
>    a huge page refcount overflow, and there are a couple of different ways to
>    fix it. 
> 
> b) if it still reproduces with the above, then it's some other random mistake,
>    and in that case I'd be inclined to do a sort of guided (or classic, unguided)
>    git bisect of the series. Because it could be any of several patches.
> 
>    If that's too much trouble, then I'd have to fall back to submitting a few
>    patches at a time and working my way up to the tracking patch...

It could also be that an ordinary page reference is dropped with 'unpin'
thus underflowing the page refcount...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
