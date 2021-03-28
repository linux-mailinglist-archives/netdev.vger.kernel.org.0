Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FD334BB7A
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 08:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhC1G4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 02:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229489AbhC1G4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 02:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F0926197E;
        Sun, 28 Mar 2021 06:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616914580;
        bh=JFtsDyimHNroQGwlrrE/Kb6wJCayyEL+RtWeHxw8s0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V+OTGY5oEYOE799dLspoH1sUfrGVnOPMPcaXxBFqwtWl6+Iy++NYwVk0RJs0m5ND/
         G0aQETV7o8Vi/kyqK+fYun/MCnVGSSCu9U15op0hD1ZBo8mvdUqd+8bQoZR2mLfUjv
         SKqHYTY79AAcmswXrek0cOCumpTEkSUYYsoU97mQ=
Date:   Sun, 28 Mar 2021 08:56:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Du Cheng <ducheng2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net:qrtr: fix atomic idr allocation in
 qrtr_port_assign()
Message-ID: <YGAokfl9xvl3CnQR@kroah.com>
References: <20210327140702.4916-1-ducheng2@gmail.com>
 <YF89PtWrs2N5XSgb@kroah.com>
 <20210327142520.GA5271@ThinkCentre-M83>
 <YF9BthXs2ha7hnrF@kroah.com>
 <20210327155110.GI1719932@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210327155110.GI1719932@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 03:51:10PM +0000, Matthew Wilcox wrote:
> On Sat, Mar 27, 2021 at 03:31:18PM +0100, Greg Kroah-Hartman wrote:
> > On Sat, Mar 27, 2021 at 10:25:20PM +0800, Du Cheng wrote:
> > > On Sat, Mar 27, 2021 at 03:12:14PM +0100, Greg Kroah-Hartman wrote:
> > > > Adding the xarray maintainer...
> > > > 
> > > > On Sat, Mar 27, 2021 at 10:07:02PM +0800, Du Cheng wrote:
> > > > > add idr_preload() and idr_preload_end() around idr_alloc_u32(GFP_ATOMIC)
> > > > > due to internal use of per_cpu variables, which requires preemption
> > > > > disabling/enabling.
> > > > > 
> > > > > reported as "BUG: "using smp_processor_id() in preemptible" by syzkaller
> > > > > 
> > > > > Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
> > > > > Signed-off-by: Du Cheng <ducheng2@gmail.com>
> > > > > ---
> > > > > changelog
> > > > > v1: change to GFP_KERNEL for idr_alloc_u32() but might sleep
> > > > > v2: revert to GFP_ATOMIC but add preemption disable/enable protection
> > > > > 
> > > > >  net/qrtr/qrtr.c | 6 ++++++
> > > > >  1 file changed, 6 insertions(+)
> > > > > 
> > > > > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > > > > index edb6ac17ceca..6361f169490e 100644
> > > > > --- a/net/qrtr/qrtr.c
> > > > > +++ b/net/qrtr/qrtr.c
> > > > > @@ -722,17 +722,23 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> > > > >  	mutex_lock(&qrtr_port_lock);
> > > > >  	if (!*port) {
> > > > >  		min_port = QRTR_MIN_EPH_SOCKET;
> > > > > +		idr_preload(GFP_ATOMIC);
> > > > >  		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
> > > > > +		idr_preload_end();
> > > > 
> > > > This seems "odd" to me.  We are asking idr_alloc_u32() to abide by
> > > > GFP_ATOMIC, so why do we need to "preload" it with the same type of
> > > > allocation?
> > > > 
> > > > Is there something in the idr/radix/xarray code that can't really handle
> > > > GFP_ATOMIC during a "normal" idr allocation that is causing this warning
> > > > to be hit?  Why is this change the "correct" one?
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > 
> > > >From the comment above idr_preload() in lib/radix-tree.c:1460
> > > /**
> > >  * idr_preload - preload for idr_alloc()
> > >  * @gfp_mask: allocation mask to use for preloading
> > >  *
> > >  * Preallocate memory to use for the next call to idr_alloc().  This function
> > >  * returns with preemption disabled.  It will be enabled by idr_preload_end().
> > >  */
> > > 
> > > idr_alloc is a very simple wrapper around idr_alloc_u32().
> > > 
> > > On top of radix_tree_node_alloc() which is called by idr_alloc_u32(), there is
> > > this comment at line 244 in the same radix-tree.c
> > > /*
> > >  * This assumes that the caller has performed appropriate preallocation, and
> > >  * that the caller has pinned this thread of control to the current CPU.
> > >  */
> > > 
> > > Therefore the preload/preload_end are necessary, or at least should have
> > > preemption disabled
> > 
> > Ah, so it's disabling preemption that is the key here.  Still odd, why
> > is GFP_ATOMIC not sufficient in a normal idr_alloc() call to keep things
> > from doing stuff like this?  Feels like a lot of "internal knowledge" is
> > needed here to use this api properly...
> > 
> > Matthew, is the above change really correct?
> 
> No.
> 
> https://lore.kernel.org/netdev/20200605112922.GB19604@bombadil.infradead.org/
> https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
> https://lore.kernel.org/netdev/20200914192655.GW6583@casper.infradead.org/
> 

Ok, it looks like this code is just abandonded, should we remove it
entirely as no one wants to maintain it?

thanks,

greg k-h
