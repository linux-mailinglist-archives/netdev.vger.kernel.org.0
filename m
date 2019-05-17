Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B9C217C6
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 13:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfEQLcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 07:32:36 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:32864 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbfEQLcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 07:32:35 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 9A09925AD7D;
        Fri, 17 May 2019 21:32:33 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 15FC994048B; Fri, 17 May 2019 13:32:30 +0200 (CEST)
Date:   Fri, 17 May 2019 13:32:30 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] RDMA: Directly cast the sockaddr union to sockaddr
Message-ID: <20190517113230.6sx5amsm3vsji2mz@verge.net.au>
References: <20190514005521.GA18085@ziepe.ca>
 <20190516124428.hytvkwfltfi24lrv@verge.net.au>
 <20190516152148.GD22587@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516152148.GD22587@ziepe.ca>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 12:21:48PM -0300, Jason Gunthorpe wrote:
> On Thu, May 16, 2019 at 02:44:28PM +0200, Simon Horman wrote:
> > On Mon, May 13, 2019 at 09:55:21PM -0300, Jason Gunthorpe wrote:
> > > gcc 9 now does allocation size tracking and thinks that passing the member
> > > of a union and then accessing beyond that member's bounds is an overflow.
> > > 
> > > Instead of using the union member, use the entire union with a cast to
> > > get to the sockaddr. gcc will now know that the memory extends the full
> > > size of the union.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> > >  drivers/infiniband/core/addr.c           | 16 ++++++++--------
> > >  drivers/infiniband/hw/ocrdma/ocrdma_ah.c |  5 ++---
> > >  drivers/infiniband/hw/ocrdma/ocrdma_hw.c |  5 ++---
> > >  3 files changed, 12 insertions(+), 14 deletions(-)
> > > 
> > > I missed the ocrdma files in the v1
> > > 
> > > We can revisit what to do with that repetitive union after the merge
> > > window, but this simple patch will eliminate the warnings for now.
> > > 
> > > Linus, I'll send this as a PR tomorrow - there is also a bug fix for
> > > the rdma-netlink changes posted that should go too.
> > 
> > <2c>
> > I would be very happy to see this revisited in such a way
> > that some use is made of the C type system (instead of casts).
> > </2c>
> 
> Well, I was thinking of swapping the union to sockaddr_storage ..
> 
> Do you propose to add a union to the kernel's sockaddr storage?

I understand you have been down that rabbit hole before but,
yes, in an ideal world that would be my preference.
