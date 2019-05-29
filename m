Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3532DBE3
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfE2LbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 07:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfE2LbN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 07:31:13 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5025F20B1F;
        Wed, 29 May 2019 11:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559129473;
        bh=HBGcM73UfMoTiS4flQzRUNnSf3of+t7sn9qeElVt3do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=moCUmf1XnAFXVdLTcCrJFlUaPjY9dG8zbcZ9pQrJ2xJdsjms3L230/ntHmrDK9a/u
         JM8kB5HdynpvNoT2N9g92/DZApgbCbWvEUQ4zqjBPs7nMAn9jBHkdzzaYscKfCbIpP
         4Ou6pjlqnnaa8ha/C1grl80wASBLuZtCTXoOo004=
Date:   Wed, 29 May 2019 14:31:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 11/17] RDMA/netlink: Implement counter
 dumpit calback
Message-ID: <20190529113107.GX4633@mtr-leonro.mtl.com>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-12-leon@kernel.org>
 <20190522172137.GD15023@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522172137.GD15023@ziepe.ca>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 02:21:37PM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 29, 2019 at 11:34:47AM +0300, Leon Romanovsky wrote:
> > From: Mark Zhang <markz@mellanox.com>
> >
> > This patch adds the ability to return all available counters
> > together with their properties and hwstats.
> >
> > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/infiniband/core/counters.c |  28 +++++
> >  drivers/infiniband/core/device.c   |   2 +
> >  drivers/infiniband/core/nldev.c    | 173 +++++++++++++++++++++++++++++
> >  include/rdma/ib_verbs.h            |  10 ++
> >  include/rdma/rdma_counter.h        |   3 +
> >  include/uapi/rdma/rdma_netlink.h   |  10 +-
> >  6 files changed, 225 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> > index 665e0d43c21b..36cd9eca1e46 100644
> > +++ b/drivers/infiniband/core/counters.c
> > @@ -62,6 +62,9 @@ static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
> >  {
> >  	struct rdma_counter *counter;
> >
> > +	if (!dev->ops.counter_alloc_stats)
> > +		return NULL;
> > +
>
> Seems weird to add this now, why was it Ok to have counters prior to
> this patch?

Prior to this patch, "sysfs" counters and "netlink" counters were
independent from user perspective.

Thanks

>
> Jason
