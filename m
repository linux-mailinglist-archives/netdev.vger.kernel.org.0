Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52976321A46
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 15:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhBVOYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 09:24:25 -0500
Received: from outbound-smtp25.blacknight.com ([81.17.249.193]:50640 "EHLO
        outbound-smtp25.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230079AbhBVOUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 09:20:19 -0500
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Feb 2021 09:20:18 EST
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp25.blacknight.com (Postfix) with ESMTPS id D6DCECABF4
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 14:08:50 +0000 (GMT)
Received: (qmail 26699 invoked from network); 22 Feb 2021 14:08:50 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 22 Feb 2021 14:08:50 -0000
Date:   Mon, 22 Feb 2021 14:08:48 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: alloc_pages_bulk()
Message-ID: <20210222140848.GI3697@techsingularity.net>
References: <20210210084155.GA3697@techsingularity.net>
 <20210210124103.56ed1e95@carbon>
 <20210210130705.GC3629@suse.de>
 <B123FB11-661F-45A6-8235-2982BF3C4B83@oracle.com>
 <20210211091235.GC3697@techsingularity.net>
 <20210211132628.1fe4f10b@carbon>
 <20210215120056.GD3697@techsingularity.net>
 <20210215171038.42f62438@carbon>
 <20210222094256.GH3697@techsingularity.net>
 <20210222124246.690414a2@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210222124246.690414a2@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 12:42:46PM +0100, Jesper Dangaard Brouer wrote:
> On Mon, 22 Feb 2021 09:42:56 +0000
> Mel Gorman <mgorman@techsingularity.net> wrote:
> 
> > On Mon, Feb 15, 2021 at 05:10:38PM +0100, Jesper Dangaard Brouer wrote:
> > > 
> > > On Mon, 15 Feb 2021 12:00:56 +0000
> > > Mel Gorman <mgorman@techsingularity.net> wrote:
> > >   
> > > > On Thu, Feb 11, 2021 at 01:26:28PM +0100, Jesper Dangaard Brouer wrote:  
> > > [...]  
> > > >   
> > > > > I also suggest the API can return less pages than requested. Because I
> > > > > want to to "exit"/return if it need to go into an expensive code path
> > > > > (like buddy allocator or compaction).  I'm assuming we have a flags to
> > > > > give us this behavior (via gfp_flags or alloc_flags)?
> > > > >     
> > > > 
> > > > The API returns the number of pages returned on a list so policies
> > > > around how aggressive it should be allocating the requested number of
> > > > pages could be adjusted without changing the API. Passing in policy
> > > > requests via gfp_flags may be problematic as most (all?) bits are
> > > > already used.  
> > > 
> > > Well, I was just thinking that I would use GFP_ATOMIC instead of
> > > GFP_KERNEL to "communicate" that I don't want this call to take too
> > > long (like sleeping).  I'm not requesting any fancy policy :-)
> > >   
> > 
> > The NFS use case requires opposite semantics
> > -- it really needs those allocations to succeed
> > https://lore.kernel.org/r/161340498400.7780.962495219428962117.stgit@klimt.1015granger.net.
> 
> Sorry, but that is not how I understand the code.
> 
> The code is doing exactly what I'm requesting. If the alloc_pages_bulk()
> doesn't return expected number of pages, then check if others need to
> run.  The old code did schedule_timeout(msecs_to_jiffies(500)), while
> Chuck's patch change this to ask for cond_resched().  Thus, it tries to
> avoid blocking the CPU for too long (when allocating many pages).
> 
> And the nfsd code seems to handle that the code can be interrupted (via
> return -EINTR) via signal_pending(current).  Thus, the nfsd code seems
> to be able to handle if the page allocations failed.
> 

I'm waiting to find out exactly what NFSD is currently doing as the code
in 5.11 is not the same as what Chuck was coding against so I'm not 100%
certain how it currently works.

> 
> > I've asked what code it's based on as it's not 5.11 and I'll iron that
> > out first.
> >
> > Then it might be clearer what the "can fail" semantics should look like.
> > I think it would be best to have pairs of patches where the first patch
> > adjusts the semantics of the bulk allocator and the second adds a user.
> > That will limit the amount of code code carried in the implementation.
> > When the initial users are in place then the implementation can be
> > optimised as the optimisations will require significant refactoring and
> > I not want to refactor multiple times.
> 
> I guess, I should try to code-up the usage in page_pool.
> 
> What is the latest patch for adding alloc_pages_bulk() ?
> 

There isn't a usable latest version until I reconcile the nfsd caller.
The only major change in the API right now is dropping order. It handles
order-0 only.

-- 
Mel Gorman
SUSE Labs
