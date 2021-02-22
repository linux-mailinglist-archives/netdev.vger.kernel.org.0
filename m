Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B8D321554
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhBVLok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:44:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229947AbhBVLoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 06:44:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613994193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MmzZCjQQYbObSyV51XAvsCh6DM7Wnhv+Pu08wvezplw=;
        b=gs+RIboGBq/6c/tg3zFc+i4YclOG22Sh0ziSEo/Wb4WNMsxdvdIxjXq3hucdgfaAlXkd38
        g78jm+sve6uEbYonBYj44v7cTSXz+kmKR5pj/GReIE6zVhui3PevNHl/03zkHGPLASVPy+
        CkpRNxAMLoY2sxn+OOGaFtpyHRmIIlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-41D8J8JmPjKTNYMKtidFaQ-1; Mon, 22 Feb 2021 06:43:09 -0500
X-MC-Unique: 41D8J8JmPjKTNYMKtidFaQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45731102C7F4;
        Mon, 22 Feb 2021 11:43:07 +0000 (UTC)
Received: from carbon (unknown [10.36.110.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04C861F0;
        Mon, 22 Feb 2021 11:42:57 +0000 (UTC)
Date:   Mon, 22 Feb 2021 12:42:46 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Chuck Lever <chuck.lever@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Jakub Kicinski <kuba@kernel.org>, brouer@redhat.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: alloc_pages_bulk()
Message-ID: <20210222124246.690414a2@carbon>
In-Reply-To: <20210222094256.GH3697@techsingularity.net>
References: <EEB0B974-6E63-41A0-9C01-F0DEA39FC4BF@oracle.com>
        <20210209113108.1ca16cfa@carbon>
        <20210210084155.GA3697@techsingularity.net>
        <20210210124103.56ed1e95@carbon>
        <20210210130705.GC3629@suse.de>
        <B123FB11-661F-45A6-8235-2982BF3C4B83@oracle.com>
        <20210211091235.GC3697@techsingularity.net>
        <20210211132628.1fe4f10b@carbon>
        <20210215120056.GD3697@techsingularity.net>
        <20210215171038.42f62438@carbon>
        <20210222094256.GH3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 09:42:56 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> On Mon, Feb 15, 2021 at 05:10:38PM +0100, Jesper Dangaard Brouer wrote:
> > 
> > On Mon, 15 Feb 2021 12:00:56 +0000
> > Mel Gorman <mgorman@techsingularity.net> wrote:
> >   
> > > On Thu, Feb 11, 2021 at 01:26:28PM +0100, Jesper Dangaard Brouer wrote:  
> > [...]  
> > >   
> > > > I also suggest the API can return less pages than requested. Because I
> > > > want to to "exit"/return if it need to go into an expensive code path
> > > > (like buddy allocator or compaction).  I'm assuming we have a flags to
> > > > give us this behavior (via gfp_flags or alloc_flags)?
> > > >     
> > > 
> > > The API returns the number of pages returned on a list so policies
> > > around how aggressive it should be allocating the requested number of
> > > pages could be adjusted without changing the API. Passing in policy
> > > requests via gfp_flags may be problematic as most (all?) bits are
> > > already used.  
> > 
> > Well, I was just thinking that I would use GFP_ATOMIC instead of
> > GFP_KERNEL to "communicate" that I don't want this call to take too
> > long (like sleeping).  I'm not requesting any fancy policy :-)
> >   
> 
> The NFS use case requires opposite semantics
> -- it really needs those allocations to succeed
> https://lore.kernel.org/r/161340498400.7780.962495219428962117.stgit@klimt.1015granger.net.

Sorry, but that is not how I understand the code.

The code is doing exactly what I'm requesting. If the alloc_pages_bulk()
doesn't return expected number of pages, then check if others need to
run.  The old code did schedule_timeout(msecs_to_jiffies(500)), while
Chuck's patch change this to ask for cond_resched().  Thus, it tries to
avoid blocking the CPU for too long (when allocating many pages).

And the nfsd code seems to handle that the code can be interrupted (via
return -EINTR) via signal_pending(current).  Thus, the nfsd code seems
to be able to handle if the page allocations failed.


> I've asked what code it's based on as it's not 5.11 and I'll iron that
> out first.
>
> Then it might be clearer what the "can fail" semantics should look like.
> I think it would be best to have pairs of patches where the first patch
> adjusts the semantics of the bulk allocator and the second adds a user.
> That will limit the amount of code code carried in the implementation.
> When the initial users are in place then the implementation can be
> optimised as the optimisations will require significant refactoring and
> I not want to refactor multiple times.

I guess, I should try to code-up the usage in page_pool.

What is the latest patch for adding alloc_pages_bulk() ?

The nfsd code (svc_alloc_arg) is called in a context where it can
sleep, and thus use GFP_KERNEL.  In most cases the page_pool will be
called with GFP_ATOMIC.  I don't think I/page_pool will retry the call
like Chuck did, as I cannot (re)schedule others to run.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

