Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5066734BBE9
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 12:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhC1KEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 06:04:54 -0400
Received: from casper.infradead.org ([90.155.50.34]:58084 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhC1KEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 06:04:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ACNwC/KBL9DN7EIf5/Id4KNdpRZ5YSB2j9O3WNH5Cp4=; b=bVEPozAqzzrY/DEuF7LUv3p1u4
        VnX4Bmr62qlT/1goUFYMnT4WfFcEiD3imrn/GhcYqDTwQxUYDNGqwBX9tSabs5ychECX6Zo03iodb
        f8JZcXCS4oIF9YVJxr+zrxjY5b3XzkhambxRuwJGV0+7EjQkCXbQKezOhtF7iIIvV4xinwUMI2p5P
        63w1dQfHsHkzucPuoiuw28vZekMZVfUE+tmz39l4MFCmR33KpbhbAhIBwwDTADotJRTUXynHJZECG
        Kmke2yms4fqKNHMxDszcWgBOBA7bsPK0R99UCihE/Q9zrnCw2eCL8RLfKCuL/rc5/eWh1t3bgcH3Z
        hq8u94Mg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lQSHJ-0003kW-Ff; Sun, 28 Mar 2021 10:04:17 +0000
Date:   Sun, 28 Mar 2021 11:04:17 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Du Cheng <ducheng2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net:qrtr: fix atomic idr allocation in
 qrtr_port_assign()
Message-ID: <20210328100417.GA14132@casper.infradead.org>
References: <20210327140702.4916-1-ducheng2@gmail.com>
 <YF89PtWrs2N5XSgb@kroah.com>
 <20210327142520.GA5271@ThinkCentre-M83>
 <YF9BthXs2ha7hnrF@kroah.com>
 <20210327155110.GI1719932@casper.infradead.org>
 <YGAokfl9xvl3CnQR@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGAokfl9xvl3CnQR@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 08:56:17AM +0200, Greg Kroah-Hartman wrote:
> On Sat, Mar 27, 2021 at 03:51:10PM +0000, Matthew Wilcox wrote:
> > On Sat, Mar 27, 2021 at 03:31:18PM +0100, Greg Kroah-Hartman wrote:
> > > On Sat, Mar 27, 2021 at 10:25:20PM +0800, Du Cheng wrote:
> > > > On Sat, Mar 27, 2021 at 03:12:14PM +0100, Greg Kroah-Hartman wrote:
> > > > > Adding the xarray maintainer...
> > > > > 
> > > > > On Sat, Mar 27, 2021 at 10:07:02PM +0800, Du Cheng wrote:
> > > > > > add idr_preload() and idr_preload_end() around idr_alloc_u32(GFP_ATOMIC)
> > > > > > due to internal use of per_cpu variables, which requires preemption
> > > > > > disabling/enabling.
> > > > > > 
> > > > > > reported as "BUG: "using smp_processor_id() in preemptible" by syzkaller
> > > > > > 
> > > > > > Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
> > > > > > Signed-off-by: Du Cheng <ducheng2@gmail.com>
> > > > > > ---
> > > > > > changelog
> > > > > > v1: change to GFP_KERNEL for idr_alloc_u32() but might sleep
> > > > > > v2: revert to GFP_ATOMIC but add preemption disable/enable protection
> > > > > > 
> > > > > >  net/qrtr/qrtr.c | 6 ++++++
> > > > > >  1 file changed, 6 insertions(+)
> > > > > > 
> > > > > > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > > > > > index edb6ac17ceca..6361f169490e 100644
> > > > > > --- a/net/qrtr/qrtr.c
> > > > > > +++ b/net/qrtr/qrtr.c
> > > > > > @@ -722,17 +722,23 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> > > > > >  	mutex_lock(&qrtr_port_lock);
> > > > > >  	if (!*port) {
> > > > > >  		min_port = QRTR_MIN_EPH_SOCKET;
> > > > > > +		idr_preload(GFP_ATOMIC);
> > > > > >  		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
> > > > > > +		idr_preload_end();
> > > > > 
> > > > > This seems "odd" to me.  We are asking idr_alloc_u32() to abide by
> > > > > GFP_ATOMIC, so why do we need to "preload" it with the same type of
> > > > > allocation?
> > > > > 
> > > > > Is there something in the idr/radix/xarray code that can't really handle
> > > > > GFP_ATOMIC during a "normal" idr allocation that is causing this warning
> > > > > to be hit?  Why is this change the "correct" one?
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > 
> > > > >From the comment above idr_preload() in lib/radix-tree.c:1460
> > > > /**
> > > >  * idr_preload - preload for idr_alloc()
> > > >  * @gfp_mask: allocation mask to use for preloading
> > > >  *
> > > >  * Preallocate memory to use for the next call to idr_alloc().  This function
> > > >  * returns with preemption disabled.  It will be enabled by idr_preload_end().
> > > >  */
> > > > 
> > > > idr_alloc is a very simple wrapper around idr_alloc_u32().
> > > > 
> > > > On top of radix_tree_node_alloc() which is called by idr_alloc_u32(), there is
> > > > this comment at line 244 in the same radix-tree.c
> > > > /*
> > > >  * This assumes that the caller has performed appropriate preallocation, and
> > > >  * that the caller has pinned this thread of control to the current CPU.
> > > >  */
> > > > 
> > > > Therefore the preload/preload_end are necessary, or at least should have
> > > > preemption disabled
> > > 
> > > Ah, so it's disabling preemption that is the key here.  Still odd, why
> > > is GFP_ATOMIC not sufficient in a normal idr_alloc() call to keep things
> > > from doing stuff like this?  Feels like a lot of "internal knowledge" is
> > > needed here to use this api properly...
> > > 
> > > Matthew, is the above change really correct?
> > 
> > No.
> > 
> > https://lore.kernel.org/netdev/20200605112922.GB19604@bombadil.infradead.org/
> > https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
> > https://lore.kernel.org/netdev/20200914192655.GW6583@casper.infradead.org/
> > 
> 
> Ok, it looks like this code is just abandonded, should we remove it
> entirely as no one wants to maintain it?

Fine by me.  I don't use it.  Better to get rid of abandonware than keep
a potential source of security holes.
