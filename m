Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA1A34B6DD
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 12:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhC0Lq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 07:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhC0Lq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 07:46:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 885CC619C7;
        Sat, 27 Mar 2021 11:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616845585;
        bh=9P8Oe6wOl7y+gwtFnypc0PC7NibUN/VZqyESfo9nVZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cnbsfh8DSWF8ziz033dsf/fzrXBuKsZDx8LzcYLRUOF97VSXh3D+TMHr5aGSD0FtG
         Hxe+KC+1hQSFOjJZvo/HXLpnLd97tco4QaTEE3pCzgEPhGslTIJeF72ok42UDDR/Tj
         GcT6n5obVdkrn9+O/juTsMJCO0eOY/1eVECJVWTw=
Date:   Sat, 27 Mar 2021 12:46:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Du Cheng <ducheng2@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Subject: Re: [PATCH] net:qrtr: fix allocator flag of idr_alloc_u32() in
 qrtr_port_assign()
Message-ID: <YF8bDngTPVRVx1ZY@kroah.com>
References: <20210326033345.162531-1-ducheng2@gmail.com>
 <YF2qDZkNpn8va28r@kroah.com>
 <20210327014437.GA22482@ThinkCentre-M83>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210327014437.GA22482@ThinkCentre-M83>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 09:44:37AM +0800, Du Cheng wrote:
> On Fri, Mar 26, 2021 at 10:31:57AM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Mar 26, 2021 at 11:33:45AM +0800, Du Cheng wrote:
> > > change the allocator flag of idr_alloc_u32 from GFP_ATOMIC to
> > > GFP_KERNEL, as GFP_ATOMIC caused BUG: "using smp_processor_id() in
> > > preemptible" as reported by syzkaller.
> > > 
> > > Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
> > > Signed-off-by: Du Cheng <ducheng2@gmail.com>
> > > ---
> > > Hi David & Jakub,
> > > 
> > > Although this is a simple fix to make syzkaller happy, I feel that maybe a more
> > > proper fix is to convert qrtr_ports from using IDR to radix_tree (which is in
> > > fact xarray) ? 
> > > 
> > > I found some previous work done in 2019 by Matthew Wilcox:
> > > https://lore.kernel.org/netdev/20190820223259.22348-1-willy@infradead.org/t/#mcb60ad4c34e35a6183c7353c8a44ceedfcff297d
> > > but that was not merged as of now. My wild guess is that it was probably
> > > in conflicti with the conversion of radix_tree to xarray during 2020, and that
> > > might cause the direct use of xarray in qrtr.c unfavorable.
> > > 
> > > Shall I proceed with converting qrtr_pors to use radix_tree (or just xarray)?
> 
> Hi Greg,
> 
> After more scrutiny, this is entirely unnecessary, as the idr structure is
> implemented as a radix_tree, which is, you guess it, xarray :)
> 
> So I looked more closely, and this time I found the culprit of the crash. It was
> due to a unprotected per_cpu access:
> ```
> rtp = this_cpu_ptr(&radix_tree_preloads);
>         if (rtp->nr) {
>             ret = rtp->nodes;
>             rtp->nodes = ret->parent;
>             rtp->nr--;
>         }
> ```
> inside
>     -> radix_tree_node_alloc()
>   -> idr_get_free()
> idr_alloc_u32()
> 
> I tried to wrap the idr_alloc_u32() with disable_preemption() and
> enable_preemption(), and it passed my local and syzbot test.
> 
> More digging reveals that idr routines provide such utilities:
> idr_preload() and idr_preload_end(). They do the exact thing but with additional
> radix_tree bookkeeping. Hence I think this should be favorable than allowing
> the allocation to sleep. The syzbot-passed patch is here:
> https://syzkaller.appspot.com/text?tag=Patch&x=14cf5a26d00000
> 
> If it looks good to you, I will send the above patch as V2.

If that resolves the issue, then that's fine with me.

> > Try it and see.  But how would that resolve this issue?  Those other
> > structures would also need to allocate memory at this point in time and
> > you need to tell it if it can sleep or not.
> > 
> > > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > > index edb6ac17ceca..ee42e1e1d4d4 100644
> > > --- a/net/qrtr/qrtr.c
> > > +++ b/net/qrtr/qrtr.c
> > > @@ -722,17 +722,17 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> > >  	mutex_lock(&qrtr_port_lock);
> > >  	if (!*port) {
> > >  		min_port = QRTR_MIN_EPH_SOCKET;
> > > -		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
> > > +		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_KERNEL);
> > 
> > Are you sure that you can sleep in this code path?
> There are only 2 other places there the mutex is held, and they seem to be safe,
> but I can't show that comprehensively.
> If I *were* to go with sleeping in idr_alloc_u32, does lockdep a silverbullet to
> prove lock safty?

I do not think lockdep does not test sleeping stuff, it just checks the
order in which locks are held.

You should be able to trace back the code paths here to ensure that
these functions are called in safe context or not, that might be worth
the effort here to make this fix simpler.

thanks,

greg k-h
