Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF1871EAE
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387594AbfGWSGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 14:06:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:23143 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729734AbfGWSGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 14:06:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 11:06:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,299,1559545200"; 
   d="scan'208";a="177367161"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jul 2019 11:06:13 -0700
Date:   Tue, 23 Jul 2019 11:06:13 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] net/xdp: convert put_page() to put_user_page*()
Message-ID: <20190723180612.GB29729@iweiny-DESK2.sc.intel.com>
References: <20190722223415.13269-1-jhubbard@nvidia.com>
 <20190722223415.13269-4-jhubbard@nvidia.com>
 <20190723002534.GA10284@iweiny-DESK2.sc.intel.com>
 <a4e9b293-11f8-6b3c-cf4d-308e3b32df34@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4e9b293-11f8-6b3c-cf4d-308e3b32df34@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 09:41:34PM -0700, John Hubbard wrote:
> On 7/22/19 5:25 PM, Ira Weiny wrote:
> > On Mon, Jul 22, 2019 at 03:34:15PM -0700, john.hubbard@gmail.com wrote:
> > > From: John Hubbard <jhubbard@nvidia.com>
> > > 
> > > For pages that were retained via get_user_pages*(), release those pages
> > > via the new put_user_page*() routines, instead of via put_page() or
> > > release_pages().
> > > 
> > > This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> > > ("mm: introduce put_user_page*(), placeholder versions").
> > > 
> > > Cc: Björn Töpel <bjorn.topel@intel.com>
> > > Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> > > Cc: David S. Miller <davem@davemloft.net>
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> > > ---
> > >   net/xdp/xdp_umem.c | 9 +--------
> > >   1 file changed, 1 insertion(+), 8 deletions(-)
> > > 
> > > diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> > > index 83de74ca729a..0325a17915de 100644
> > > --- a/net/xdp/xdp_umem.c
> > > +++ b/net/xdp/xdp_umem.c
> > > @@ -166,14 +166,7 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
> > >   static void xdp_umem_unpin_pages(struct xdp_umem *umem)
> > >   {
> > > -	unsigned int i;
> > > -
> > > -	for (i = 0; i < umem->npgs; i++) {
> > > -		struct page *page = umem->pgs[i];
> > > -
> > > -		set_page_dirty_lock(page);
> > > -		put_page(page);
> > > -	}
> > > +	put_user_pages_dirty_lock(umem->pgs, umem->npgs);
> > 
> > What is the difference between this and
> > 
> > __put_user_pages(umem->pgs, umem->npgs, PUP_FLAGS_DIRTY_LOCK);
> > 
> > ?
> 
> No difference.
> 
> > 
> > I'm a bit concerned with adding another form of the same interface.  We should
> > either have 1 call with flags (enum in this case) or multiple calls.  Given the
> > previous discussion lets move in the direction of having the enum but don't
> > introduce another caller of the "old" interface.
> 
> I disagree that this is a "problem". There is no maintenance pitfall here; there
> are merely two ways to call the put_user_page*() API. Both are correct, and
> neither one will get you into trouble.
> 
> Not only that, but there is ample precedent for this approach in other
> kernel APIs.
> 
> > 
> > So I think on this patch NAK from me.
> > 
> > I also don't like having a __* call in the exported interface but there is a
> > __get_user_pages_fast() call so I guess there is precedent.  :-/
> > 
> 
> I thought about this carefully, and looked at other APIs. And I noticed that
> things like __get_user_pages*() are how it's often done:
> 
> * The leading underscores are often used for the more elaborate form of the
> call (as oppposed to decorating the core function name with "_flags", for
> example).
> 
> * There are often calls in which you can either call the simpler form, or the
> form with flags and additional options, and yes, you'll get the same result.
> 
> Obviously, this stuff is all subject to a certain amount of opinion, but I
> think I'm on really solid ground as far as precedent goes. So I'm pushing
> back on the NAK... :)

Fair enough...  However, we have discussed in the past how GUP can be a
confusing interface to use.

So I'd like to see it be more directed.  Only using the __put_user_pages()
version allows us to ID callers easier through a grep of PUP_FLAGS_DIRTY_LOCK
in addition to directing users to use that interface rather than having to read
the GUP code to figure out that the 2 calls above are equal.  It is not a huge
deal but...

Ira

> 
> thanks,
> -- 
> John Hubbard
> NVIDIA
> 
