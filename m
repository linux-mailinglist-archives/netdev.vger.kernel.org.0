Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D6A8582D
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 04:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389645AbfHHChI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 22:37:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:4305 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfHHChH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 22:37:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 19:36:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="186207302"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga002.jf.intel.com with ESMTP; 07 Aug 2019 19:36:38 -0700
Date:   Wed, 7 Aug 2019 19:36:37 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>, john.hubbard@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 00/34] put_user_pages(): miscellaneous call sites
Message-ID: <20190808023637.GA1508@iweiny-DESK2.sc.intel.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802091244.GD6461@dhcp22.suse.cz>
 <20190802124146.GL25064@quack2.suse.cz>
 <20190802142443.GB5597@bombadil.infradead.org>
 <20190802145227.GQ25064@quack2.suse.cz>
 <076e7826-67a5-4829-aae2-2b90f302cebd@nvidia.com>
 <20190807083726.GA14658@quack2.suse.cz>
 <20190807084649.GQ11812@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807084649.GQ11812@dhcp22.suse.cz>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 10:46:49AM +0200, Michal Hocko wrote:
> On Wed 07-08-19 10:37:26, Jan Kara wrote:
> > On Fri 02-08-19 12:14:09, John Hubbard wrote:
> > > On 8/2/19 7:52 AM, Jan Kara wrote:
> > > > On Fri 02-08-19 07:24:43, Matthew Wilcox wrote:
> > > > > On Fri, Aug 02, 2019 at 02:41:46PM +0200, Jan Kara wrote:
> > > > > > On Fri 02-08-19 11:12:44, Michal Hocko wrote:
> > > > > > > On Thu 01-08-19 19:19:31, john.hubbard@gmail.com wrote:
> > > > > > > [...]
> > > > > > > > 2) Convert all of the call sites for get_user_pages*(), to
> > > > > > > > invoke put_user_page*(), instead of put_page(). This involves dozens of
> > > > > > > > call sites, and will take some time.
> > > > > > > 
> > > > > > > How do we make sure this is the case and it will remain the case in the
> > > > > > > future? There must be some automagic to enforce/check that. It is simply
> > > > > > > not manageable to do it every now and then because then 3) will simply
> > > > > > > be never safe.
> > > > > > > 
> > > > > > > Have you considered coccinele or some other scripted way to do the
> > > > > > > transition? I have no idea how to deal with future changes that would
> > > > > > > break the balance though.
> > > 
> > > Hi Michal,
> > > 
> > > Yes, I've thought about it, and coccinelle falls a bit short (it's not smart
> > > enough to know which put_page()'s to convert). However, there is a debug
> > > option planned: a yet-to-be-posted commit [1] uses struct page extensions
> > > (obviously protected by CONFIG_DEBUG_GET_USER_PAGES_REFERENCES) to add
> > > a redundant counter. That allows:
> > > 
> > > void __put_page(struct page *page)
> > > {
> > > 	...
> > > 	/* Someone called put_page() instead of put_user_page() */
> > > 	WARN_ON_ONCE(atomic_read(&page_ext->pin_count) > 0);
> > > 
> > > > > > 
> > > > > > Yeah, that's why I've been suggesting at LSF/MM that we may need to create
> > > > > > a gup wrapper - say vaddr_pin_pages() - and track which sites dropping
> > > > > > references got converted by using this wrapper instead of gup. The
> > > > > > counterpart would then be more logically named as unpin_page() or whatever
> > > > > > instead of put_user_page().  Sure this is not completely foolproof (you can
> > > > > > create new callsite using vaddr_pin_pages() and then just drop refs using
> > > > > > put_page()) but I suppose it would be a high enough barrier for missed
> > > > > > conversions... Thoughts?
> > > 
> > > The debug option above is still a bit simplistic in its implementation
> > > (and maybe not taking full advantage of the data it has), but I think
> > > it's preferable, because it monitors the "core" and WARNs.
> > > 
> > > Instead of the wrapper, I'm thinking: documentation and the passage of
> > > time, plus the debug option (perhaps enhanced--probably once I post it
> > > someone will notice opportunities), yes?
> > 
> > So I think your debug option and my suggested renaming serve a bit
> > different purposes (and thus both make sense). If you do the renaming, you
> > can just grep to see unconverted sites. Also when someone merges new GUP
> > user (unaware of the new rules) while you switch GUP to use pins instead of
> > ordinary references, you'll get compilation error in case of renaming
> > instead of hard to debug refcount leak without the renaming. And such
> > conflict is almost bound to happen given the size of GUP patch set... Also
> > the renaming serves against the "coding inertia" - i.e., GUP is around for
> > ages so people just use it without checking any documentation or comments.
> > After switching how GUP works, what used to be correct isn't anymore so
> > renaming the function serves as a warning that something has really
> > changed.
> 
> Fully agreed!

Ok Prior to this I've been basing all my work for the RDMA/FS DAX stuff in
Johns put_user_pages()...  (Including when I proposed failing truncate with a
lease in June [1])

However, based on the suggestions in that thread it became clear that a new
interface was going to need to be added to pass in the "RDMA file" information
to GUP to associate file pins with the correct processes...

I have many drawings on my white board with "a whole lot of lines" on them to
make sure that if a process opens a file, mmaps it, pins it with RDMA, _closes_
it, and ummaps it; that the resulting file pin can still be traced back to the
RDMA context and all the processes which may have access to it....  No matter
where the original context may have come from.  I believe I have accomplished
that.

Before I go on, I would like to say that the "imbalance" of get_user_pages()
and put_page() bothers me from a purist standpoint...  However, since this
discussion cropped up I went ahead and ported my work to Linus' current master
(5.3-rc3+) and in doing so I only had to steal a bit of Johns code...  Sorry
John...  :-(

I don't have the commit messages all cleaned up and I know there may be some
discussion on these new interfaces but I wanted to throw this series out there
because I think it may be what Jan and Michal are driving at (or at least in
that direction.

Right now only RDMA and DAX FS's are supported.  Other users of GUP will still
fail on a DAX file and regular files will still be at risk.[2]

I've pushed this work (based 5.3-rc3+ (33920f1ec5bf)) here[3]:

https://github.com/weiny2/linux-kernel/tree/linus-rdmafsdax-b0-v3

I think the most relevant patch to this conversation is:

https://github.com/weiny2/linux-kernel/commit/5d377653ba5cf11c3b716f904b057bee6641aaf6

I stole Jans suggestion for a name as the name I used while prototyping was
pretty bad...  So Thanks Jan...  ;-)

Also thanks to John for his contribution on some of this.  I'm still tweaking
put_user_pages under the hood on the DAX path.

Ira

[1] https://lwn.net/Articles/790544/

[2] I've been looking into how to support io_uring next but I've had some issue
getting a test program to actually call GUP in that code path...  :-(

[3] If it would be easier I can just throw an RFC on the list but right now the
cover letter and some of the commit messages are full of the old stuff and
various ideas I have had...

> 
> > Your refcount debug patches are good to catch bugs in the conversions done
> > but that requires you to be able to excercise the code path in the first
> > place which may require particular HW or so, and you also have to enable
> > the debug option which means you already aim at verifying the GUP
> > references are treated properly.
> > 
> > 								Honza
> > 
> > -- 
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
> 
> -- 
> Michal Hocko
> SUSE Labs
