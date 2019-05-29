Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE6D2DAFC
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfE2Knr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfE2Knr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 06:43:47 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 287F220B1F;
        Wed, 29 May 2019 10:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559126625;
        bh=UZHuK5J4d2ARgW4rgRrKDqFG/SphReo8IyUG0b7Cu14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aP/tevokopg/JutRzQ2zZtW6rD1c/SLHY9A2LqVun0P2V50OZqcuujcQqNyhZjdd0
         m0J+yxsfWHsAvUtJth4efkAGhIJYqmo+m5O0L6LvthmvyFzYIQJ1F/5rpzJC/oSX0r
         aM/CQVSNWxxBdj4Z68KpxgcQIUGT4pkSRyoz9maA=
Date:   Wed, 29 May 2019 13:43:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 05/17] RDMA/counter: Add set/clear per-port
 auto mode support
Message-ID: <20190529104340.GT4633@mtr-leonro.mtl.com>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-6-leon@kernel.org>
 <20190522165608.GA14554@ziepe.ca>
 <20190529101218.GS4633@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529101218.GS4633@mtr-leonro.mtl.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 01:12:18PM +0300, Leon Romanovsky wrote:
> On Wed, May 22, 2019 at 01:56:08PM -0300, Jason Gunthorpe wrote:
> > On Mon, Apr 29, 2019 at 11:34:41AM +0300, Leon Romanovsky wrote:
> > > From: Mark Zhang <markz@mellanox.com>
> > >
> > > Add an API to support set/clear per-port auto mode.
> > >
> > > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > > Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >  drivers/infiniband/core/Makefile   |  2 +-
> > >  drivers/infiniband/core/counters.c | 77 ++++++++++++++++++++++++++++++
> > >  drivers/infiniband/core/device.c   |  4 ++
> > >  include/rdma/ib_verbs.h            |  2 +
> > >  include/rdma/rdma_counter.h        | 24 ++++++++++
> > >  include/uapi/rdma/rdma_netlink.h   | 26 ++++++++++
> > >  6 files changed, 134 insertions(+), 1 deletion(-)
> > >  create mode 100644 drivers/infiniband/core/counters.c
> > >
> > > diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
> > > index 313f2349b518..cddf748c15c9 100644
> > > +++ b/drivers/infiniband/core/Makefile
> > > @@ -12,7 +12,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
> > >  				device.o fmr_pool.o cache.o netlink.o \
> > >  				roce_gid_mgmt.o mr_pool.o addr.o sa_query.o \
> > >  				multicast.o mad.o smi.o agent.o mad_rmpp.o \
> > > -				nldev.o restrack.o
> > > +				nldev.o restrack.o counters.o
> > >
> > >  ib_core-$(CONFIG_SECURITY_INFINIBAND) += security.o
> > >  ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
> > > diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> > > new file mode 100644
> > > index 000000000000..bda8d945a758
> > > +++ b/drivers/infiniband/core/counters.c
> > > @@ -0,0 +1,77 @@
> > > +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> > > +/*
> > > + * Copyright (c) 2019 Mellanox Technologies. All rights reserved.
> > > + */
> > > +#include <rdma/ib_verbs.h>
> > > +#include <rdma/rdma_counter.h>
> > > +
> > > +#include "core_priv.h"
> > > +#include "restrack.h"
> > > +
> > > +#define ALL_AUTO_MODE_MASKS (RDMA_COUNTER_MASK_QP_TYPE)
> > > +
> > > +static int __counter_set_mode(struct rdma_counter_mode *curr,
> > > +			      enum rdma_nl_counter_mode new_mode,
> > > +			      enum rdma_nl_counter_mask new_mask)
> > > +{
> > > +	if ((new_mode == RDMA_COUNTER_MODE_AUTO) &&
> > > +	    ((new_mask & (~ALL_AUTO_MODE_MASKS)) ||
> > > +	     (curr->mode != RDMA_COUNTER_MODE_NONE)))
> > > +		return -EINVAL;
> > > +
> > > +	curr->mode = new_mode;
> > > +	curr->mask = new_mask;
> > > +	return 0;
> > > +}
> > > +
> > > +/**
> > > + * rdma_counter_set_auto_mode() - Turn on/off per-port auto mode
> > > + *
> > > + * When @on is true, the @mask must be set
> > > + */
> > > +int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
> > > +			       bool on, enum rdma_nl_counter_mask mask)
> > > +{
> > > +	struct rdma_port_counter *port_counter;
> > > +	int ret;
> > > +
> > > +	if (!rdma_is_port_valid(dev, port))
> > > +		return -EINVAL;
> > > +
> > > +	port_counter = &dev->port_data[port].port_counter;
> > > +	mutex_lock(&port_counter->lock);
> > > +	if (on) {
> > > +		ret = __counter_set_mode(&port_counter->mode,
> > > +					 RDMA_COUNTER_MODE_AUTO, mask);
> > > +	} else {
> > > +		if (port_counter->mode.mode != RDMA_COUNTER_MODE_AUTO) {
> > > +			ret = -EINVAL;
> > > +			goto out;
> > > +		}
> > > +		ret = __counter_set_mode(&port_counter->mode,
> > > +					 RDMA_COUNTER_MODE_NONE, 0);
> > > +	}
> > > +
> > > +out:
> > > +	mutex_unlock(&port_counter->lock);
> > > +	return ret;
> > > +}
> > > +
> > > +void rdma_counter_init(struct ib_device *dev)
> > > +{
> > > +	struct rdma_port_counter *port_counter;
> > > +	u32 port;
> > > +
> > > +	if (!dev->ops.alloc_hw_stats)
> > > +		return;
> > > +
> > > +	rdma_for_each_port(dev, port) {
> > > +		port_counter = &dev->port_data[port].port_counter;
> > > +		port_counter->mode.mode = RDMA_COUNTER_MODE_NONE;
> > > +		mutex_init(&port_counter->lock);
> > > +	}
> > > +}
> > > +
> > > +void rdma_counter_cleanup(struct ib_device *dev)
> > > +{
> > > +}
> >
> > Please don't add empty functions
>
> It is brought here for symmetry, the function is going to be filled in
> patch "RDMA/core: Get sum value of all counters when perform a sysfs
> stat read".
>
> >
> > > @@ -1304,6 +1307,7 @@ static void __ib_unregister_device(struct ib_device *ib_dev)
> > >  		goto out;
> > >
> > >  	disable_device(ib_dev);
> > > +	rdma_counter_cleanup(ib_dev);
> >
> > This is the wrong place to call this, the patch that actually adds a
> > body is just doing kfree's so it is properly called
> > 'rdma_counter_release' and it belongs in ib_device_release()
>
> I'll move.
>
> >
> > And it shouldn't test hw_stats, and it shouldn't have a 'fail' stanza
> > for allocation either.
>
> Not all devices implement hw_stat.

ok, I think that I found a way to rewrite the code without need to check hw_stat.

Thanks

>
> >
> > Jason
