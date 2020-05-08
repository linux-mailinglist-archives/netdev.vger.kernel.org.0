Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109411CAD61
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 15:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgEHNBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 09:01:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49286 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgEHNBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 09:01:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HESb3caQoyVMOAZu/EJbZeE2FdyEFOcn3s85iniKmQI=; b=PuzTMgY3AR9IPEEX7JXASTAx7b
        PGDI7KPFH7SfizJULUIFknDoOuEmGOw+dIGJi2grWiGZ3xbACMqB4TDsS5pFxwJ8dA/jc7IN/nbMH
        7Je6GBTdtB4CBSSyJ53dCggqrD+kUfmkSPVcStchLOozphYWzgFu1ERRudxABVrCYI7c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jX2ct-001N7a-FQ; Fri, 08 May 2020 15:01:15 +0200
Date:   Fri, 8 May 2020 15:01:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Kevin Hao <haokexin@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] octeontx2-pf: Use the napi_alloc_frag() to alloc the
 pool buffers
Message-ID: <20200508130115.GO208718@lunn.ch>
References: <20200508040728.24202-1-haokexin@gmail.com>
 <CA+sq2CfMoOhrVz7tMkKiM3BwAgoyMj6i2RWz0JWwvpBMCO3Whg@mail.gmail.com>
 <20200508053015.GB3222151@pek-khao-d2.corp.ad.wrs.com>
 <CA+sq2CfmFaQ1=8m6vBOD6d_uoez2yU7KrAP1JUMo_nJbe=9_6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2CfmFaQ1=8m6vBOD6d_uoez2yU7KrAP1JUMo_nJbe=9_6g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 01:08:13PM +0530, Sunil Kovvuri wrote:
> On Fri, May 8, 2020 at 11:00 AM Kevin Hao <haokexin@gmail.com> wrote:
> >
> > On Fri, May 08, 2020 at 10:18:27AM +0530, Sunil Kovvuri wrote:
> > > On Fri, May 8, 2020 at 9:43 AM Kevin Hao <haokexin@gmail.com> wrote:
> > > >
> > > > In the current codes, the octeontx2 uses its own method to allocate
> > > > the pool buffers, but there are some issues in this implementation.
> > > > 1. We have to run the otx2_get_page() for each allocation cycle and
> > > >    this is pretty error prone. As I can see there is no invocation
> > > >    of the otx2_get_page() in otx2_pool_refill_task(), this will leave
> > > >    the allocated pages have the wrong refcount and may be freed wrongly.
> > >
> > > Thanks for pointing, will fix.
> > >
> > > > 2. It wastes memory. For example, if we only receive one packet in a
> > > >    NAPI RX cycle, and then allocate a 2K buffer with otx2_alloc_rbuf()
> > > >    to refill the pool buffers and leave the remain area of the allocated
> > > >    page wasted. On a kernel with 64K page, 62K area is wasted.
> > > >
> > > > IMHO it is really unnecessary to implement our own method for the
> > > > buffers allocate, we can reuse the napi_alloc_frag() to simplify
> > > > our code.
> > > >
> > > > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> > >
> > > Have you measured performance with and without your patch ?
> >
> > I will do performance compare later. But I don't think there will be measurable
> > difference.
> >
> > > I didn't use napi_alloc_frag() as it's too costly, if in one NAPI
> > > instance driver
> > > receives 32 pkts, then 32 calls to napi_alloc_frag() and updates to page ref
> > > count per fragment etc are costly.
> >
> > No, the page ref only be updated at the page allocation and all the space are
> > used. In general, the invocation of napi_alloc_frag() will not cause the update
> > of the page ref. So in theory, the count of updating page ref should be reduced
> > by using of napi_alloc_frag() compare to the current otx2 implementation.
> >
> 
> Okay, it seems i misunderstood it.

Hi Sunil

In general, you should not work around issues in the core, you should
improve the core. If your implementation really was more efficient
than the core code, it would of been better if you proposed fixes to
the core, not hide away better code in your own driver.

      Andrew
