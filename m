Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C29847F2
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387809AbfHGIq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:46:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:55384 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387743AbfHGIqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 04:46:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8E81EAD29;
        Wed,  7 Aug 2019 08:46:50 +0000 (UTC)
Date:   Wed, 7 Aug 2019 10:46:49 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>, john.hubbard@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
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
Message-ID: <20190807084649.GQ11812@dhcp22.suse.cz>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802091244.GD6461@dhcp22.suse.cz>
 <20190802124146.GL25064@quack2.suse.cz>
 <20190802142443.GB5597@bombadil.infradead.org>
 <20190802145227.GQ25064@quack2.suse.cz>
 <076e7826-67a5-4829-aae2-2b90f302cebd@nvidia.com>
 <20190807083726.GA14658@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807083726.GA14658@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 07-08-19 10:37:26, Jan Kara wrote:
> On Fri 02-08-19 12:14:09, John Hubbard wrote:
> > On 8/2/19 7:52 AM, Jan Kara wrote:
> > > On Fri 02-08-19 07:24:43, Matthew Wilcox wrote:
> > > > On Fri, Aug 02, 2019 at 02:41:46PM +0200, Jan Kara wrote:
> > > > > On Fri 02-08-19 11:12:44, Michal Hocko wrote:
> > > > > > On Thu 01-08-19 19:19:31, john.hubbard@gmail.com wrote:
> > > > > > [...]
> > > > > > > 2) Convert all of the call sites for get_user_pages*(), to
> > > > > > > invoke put_user_page*(), instead of put_page(). This involves dozens of
> > > > > > > call sites, and will take some time.
> > > > > > 
> > > > > > How do we make sure this is the case and it will remain the case in the
> > > > > > future? There must be some automagic to enforce/check that. It is simply
> > > > > > not manageable to do it every now and then because then 3) will simply
> > > > > > be never safe.
> > > > > > 
> > > > > > Have you considered coccinele or some other scripted way to do the
> > > > > > transition? I have no idea how to deal with future changes that would
> > > > > > break the balance though.
> > 
> > Hi Michal,
> > 
> > Yes, I've thought about it, and coccinelle falls a bit short (it's not smart
> > enough to know which put_page()'s to convert). However, there is a debug
> > option planned: a yet-to-be-posted commit [1] uses struct page extensions
> > (obviously protected by CONFIG_DEBUG_GET_USER_PAGES_REFERENCES) to add
> > a redundant counter. That allows:
> > 
> > void __put_page(struct page *page)
> > {
> > 	...
> > 	/* Someone called put_page() instead of put_user_page() */
> > 	WARN_ON_ONCE(atomic_read(&page_ext->pin_count) > 0);
> > 
> > > > > 
> > > > > Yeah, that's why I've been suggesting at LSF/MM that we may need to create
> > > > > a gup wrapper - say vaddr_pin_pages() - and track which sites dropping
> > > > > references got converted by using this wrapper instead of gup. The
> > > > > counterpart would then be more logically named as unpin_page() or whatever
> > > > > instead of put_user_page().  Sure this is not completely foolproof (you can
> > > > > create new callsite using vaddr_pin_pages() and then just drop refs using
> > > > > put_page()) but I suppose it would be a high enough barrier for missed
> > > > > conversions... Thoughts?
> > 
> > The debug option above is still a bit simplistic in its implementation
> > (and maybe not taking full advantage of the data it has), but I think
> > it's preferable, because it monitors the "core" and WARNs.
> > 
> > Instead of the wrapper, I'm thinking: documentation and the passage of
> > time, plus the debug option (perhaps enhanced--probably once I post it
> > someone will notice opportunities), yes?
> 
> So I think your debug option and my suggested renaming serve a bit
> different purposes (and thus both make sense). If you do the renaming, you
> can just grep to see unconverted sites. Also when someone merges new GUP
> user (unaware of the new rules) while you switch GUP to use pins instead of
> ordinary references, you'll get compilation error in case of renaming
> instead of hard to debug refcount leak without the renaming. And such
> conflict is almost bound to happen given the size of GUP patch set... Also
> the renaming serves against the "coding inertia" - i.e., GUP is around for
> ages so people just use it without checking any documentation or comments.
> After switching how GUP works, what used to be correct isn't anymore so
> renaming the function serves as a warning that something has really
> changed.

Fully agreed!

> Your refcount debug patches are good to catch bugs in the conversions done
> but that requires you to be able to excercise the code path in the first
> place which may require particular HW or so, and you also have to enable
> the debug option which means you already aim at verifying the GUP
> references are treated properly.
> 
> 								Honza
> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

-- 
Michal Hocko
SUSE Labs
