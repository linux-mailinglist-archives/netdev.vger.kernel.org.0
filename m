Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3EE4146B11
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgAWOUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:20:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728931AbgAWOUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 09:20:19 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90D3920718;
        Thu, 23 Jan 2020 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579789218;
        bh=WYIH6HpVnAxDrjRxXHvOwPgi+kZYfzI34BMeHstETE8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JppFiQ0T/vyuVHddiND1pUGOggSP49oQ2jniHze5MkQo6DqcSH71PNKAuNUy3qj8N
         cG/7zhEzqWq8ZgVTGyuVeRBAMkrnrMC5IhFN/eJ7lTKLReJXHSQ7GwIPtBz5dn3NDM
         xsXeSNNHNUqrI5utZxau3nOrVHq2FCScNU+HcUEo=
Date:   Thu, 23 Jan 2020 06:20:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: Re: [PATCH v4 04/17] octeontx2-pf: Initialize and config queues
Message-ID: <20200123062017.3cbefe70@cakuba>
In-Reply-To: <CA+sq2CenEgQ31St1kGgvWfxgyjv2fhT=Xmpt+QZZrtN3faPAqw@mail.gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579612911-24497-5-git-send-email-sunil.kovvuri@gmail.com>
        <20200121080058.42b0c473@cakuba>
        <CA+sq2CenEgQ31St1kGgvWfxgyjv2fhT=Xmpt+QZZrtN3faPAqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 00:59:54 +0530, Sunil Kovvuri wrote:
> On Tue, Jan 21, 2020 at 9:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 21 Jan 2020 18:51:38 +0530, sunil.kovvuri@gmail.com wrote:  
> > > +dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
> > > +                        gfp_t gfp)
> > > +{
> > > +     dma_addr_t iova;
> > > +
> > > +     /* Check if request can be accommodated in previous allocated page */
> > > +     if (pool->page &&
> > > +         ((pool->page_offset + pool->rbsize) <= PAGE_SIZE)) {

You use straight PAGE_SIZE here

> > > +             pool->pageref++;
> > > +             goto ret;
> > > +     }
> > > +
> > > +     otx2_get_page(pool);
> > > +
> > > +     /* Allocate a new page */
> > > +     pool->page = alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
> > > +                              pool->rbpage_order);

but allocate with order

> > > +     if (unlikely(!pool->page))
> > > +             return -ENOMEM;
> > > +
> > > +     pool->page_offset = 0;
> > > +ret:
> > > +     iova = (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_offset,
> > > +                                   pool->rbsize, DMA_FROM_DEVICE);
> > > +     if (!iova) {
> > > +             if (!pool->page_offset)
> > > +                     __free_pages(pool->page, pool->rbpage_order);
> > > +             pool->page = NULL;
> > > +             return -ENOMEM;
> > > +     }
> > > +     pool->page_offset += pool->rbsize;
> > > +     return iova;
> > > +}  
> >
> > You don't seem to be doing any page recycling if I'm reading this right.
> > Can't you use the standard in-kernel page frag allocator
> > (netdev_alloc_frag/napi_alloc_frag)?  
> 
> netdev_alloc_frag() is costly.
> eg: it does updates to page's refcount per frag allocation.

It would be nice to see it improve rather than have drivers implement 
a slight variation of the scheme :/
