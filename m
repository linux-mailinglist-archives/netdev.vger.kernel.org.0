Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA687434
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405970AbfHIIel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:34:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:38264 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbfHIIek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 04:34:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD89FAE49;
        Fri,  9 Aug 2019 08:34:36 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id DC04B1E437E; Fri,  9 Aug 2019 10:34:35 +0200 (CEST)
Date:   Fri, 9 Aug 2019 10:34:35 +0200
From:   Jan Kara <jack@suse.cz>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Michal Hocko <mhocko@kernel.org>, Jan Kara <jack@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
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
Message-ID: <20190809083435.GA17568@quack2.suse.cz>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802091244.GD6461@dhcp22.suse.cz>
 <20190802124146.GL25064@quack2.suse.cz>
 <20190802142443.GB5597@bombadil.infradead.org>
 <20190802145227.GQ25064@quack2.suse.cz>
 <076e7826-67a5-4829-aae2-2b90f302cebd@nvidia.com>
 <20190807083726.GA14658@quack2.suse.cz>
 <20190807084649.GQ11812@dhcp22.suse.cz>
 <20190808023637.GA1508@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808023637.GA1508@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 07-08-19 19:36:37, Ira Weiny wrote:
> On Wed, Aug 07, 2019 at 10:46:49AM +0200, Michal Hocko wrote:
> > > So I think your debug option and my suggested renaming serve a bit
> > > different purposes (and thus both make sense). If you do the renaming, you
> > > can just grep to see unconverted sites. Also when someone merges new GUP
> > > user (unaware of the new rules) while you switch GUP to use pins instead of
> > > ordinary references, you'll get compilation error in case of renaming
> > > instead of hard to debug refcount leak without the renaming. And such
> > > conflict is almost bound to happen given the size of GUP patch set... Also
> > > the renaming serves against the "coding inertia" - i.e., GUP is around for
> > > ages so people just use it without checking any documentation or comments.
> > > After switching how GUP works, what used to be correct isn't anymore so
> > > renaming the function serves as a warning that something has really
> > > changed.
> > 
> > Fully agreed!
> 
> Ok Prior to this I've been basing all my work for the RDMA/FS DAX stuff in
> Johns put_user_pages()...  (Including when I proposed failing truncate with a
> lease in June [1])
> 
> However, based on the suggestions in that thread it became clear that a new
> interface was going to need to be added to pass in the "RDMA file" information
> to GUP to associate file pins with the correct processes...
> 
> I have many drawings on my white board with "a whole lot of lines" on them to
> make sure that if a process opens a file, mmaps it, pins it with RDMA, _closes_
> it, and ummaps it; that the resulting file pin can still be traced back to the
> RDMA context and all the processes which may have access to it....  No matter
> where the original context may have come from.  I believe I have accomplished
> that.
> 
> Before I go on, I would like to say that the "imbalance" of get_user_pages()
> and put_page() bothers me from a purist standpoint...  However, since this
> discussion cropped up I went ahead and ported my work to Linus' current master
> (5.3-rc3+) and in doing so I only had to steal a bit of Johns code...  Sorry
> John...  :-(
> 
> I don't have the commit messages all cleaned up and I know there may be some
> discussion on these new interfaces but I wanted to throw this series out there
> because I think it may be what Jan and Michal are driving at (or at least in
> that direction.
> 
> Right now only RDMA and DAX FS's are supported.  Other users of GUP will still
> fail on a DAX file and regular files will still be at risk.[2]
> 
> I've pushed this work (based 5.3-rc3+ (33920f1ec5bf)) here[3]:
> 
> https://github.com/weiny2/linux-kernel/tree/linus-rdmafsdax-b0-v3
> 
> I think the most relevant patch to this conversation is:
> 
> https://github.com/weiny2/linux-kernel/commit/5d377653ba5cf11c3b716f904b057bee6641aaf6
> 
> I stole Jans suggestion for a name as the name I used while prototyping was
> pretty bad...  So Thanks Jan...  ;-)

For your function, I'd choose a name like vaddr_pin_leased_pages() so that
association with a lease is clear from the name :) Also I'd choose the
counterpart to be vaddr_unpin_leased_page[s](). Especially having put_page in
the name looks confusing to me...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
