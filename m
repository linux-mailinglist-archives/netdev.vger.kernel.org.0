Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189255EB18
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfGCSEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfGCSEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 14:04:42 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74DE1218B6;
        Wed,  3 Jul 2019 18:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562177081;
        bh=l8eNhkHQxTiY2MmgR4n+pQPmU054D9+HZx11u36S4VQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kUOfZkb8NTiUCpj1XicSLLFdIFLp/JpnK7uybuVQJ4SiRrOwnWpSxzWWWmSR+jjEb
         njbMLy4fIP9KXivGeeEuHvYPOqeiWoj7aocX9yhM4PEi/v3QgjKqqW6y9JB2iFf7dw
         xpi9SAOA8PSWTFPYVtuZ5l+car/qOalMw+Gn2iXo=
Date:   Wed, 3 Jul 2019 21:04:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 00/13] DEVX asynchronous events
Message-ID: <20190703180437.GE4727@mtr-leonro.mtl.com>
References: <20190630162334.22135-1-leon@kernel.org>
 <20190703152902.GA582@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703152902.GA582@ziepe.ca>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 12:29:03PM -0300, Jason Gunthorpe wrote:
> On Sun, Jun 30, 2019 at 07:23:21PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog:
> >  v1 -> v2:
> >  * Added Saeed's ack to net patches
> >  * Patch #2:
> >   * Fix to gather user asynchronous events on top of kernel events.
> >  * Patch #7:
> >   * Fix obj_id to be 32 bits.
> >  * Patch #8:
> >   * Inline async_event_queue applicable fields into devx_async_event_file.
> >   * Move to use bitfields in few places rather than flags.
> >   * Shorten name of UAPI attribute.
> >  * Patch #10:
> >   * Use explicitly 'struct file *' instead of void *
> >   * Store struct devx_async_event_file * instead of uobj * on the subscription.
> >   * Drop 'is_obj_related' and use list_empty instead.
> >   * Drop the temp arrays as part of the subscription API and move to simpler logic.
> >   * Revise devx_cleanup_subscription() to be success oriented without
> >     the is_close flag.
> >   * Leave key level 1 in the tree upon bad flow to prevent a race with IRQ flow.
> >   * Fix some styling notes.
> >  * Patch #11:
> >   * Use rcu read lock also for the un-affiliated event flow.
> >   * Improve locking scheme as part of read events.
> >   * Return -EIO as soon as destroyed occurred.
> >   * Use a better errno as part read event failure when the buffer size
> >     was too small.
> >   * Upon hot unplug call wake_up_interruptible() unconditionally.
> >   * Use eqe->data for affiliated events header.
> >   * Fix some styling notes.
> >  * Patch #12:
> >   * Use rcu read lock also for the first XA layer.
> >  * Patch #13:
> >   * A new patch to clean up mdev usage from devx code, it can be accessed
> >     from ib_dev now.
> >  v0 -> v1:
> >  * Fix the unbind / hot unplug flows to work properly.
> >  * Fix Ref count handling on the eventfd mode in some flow.
> >  * Rebased to latest rdma-next
> >
> > Thanks
> >
> > >From Yishai:
> >
> > This series enables RDMA applications that use the DEVX interface to
> > subscribe and read device asynchronous events.
> >
> > The solution is designed to allow extension of events in the future
> > without need to perform any changes in the driver code.
> >
> > To enable that few changes had been done in mlx5_core, it includes:
> >  * Reading device event capabilities that are user related
> >    (affiliated and un-affiliated) and set the matching mask upon
> >    creating the matching EQ.
> >  * Enable DEVX/mlx5_ib to register for ANY event instead of the option to
> >    get some hard-coded ones.
> >  * Enable DEVX/mlx5_ib to get the device raw data for CQ completion events.
> >  * Enhance mlx5_core_create/destroy CQ to enable DEVX using them so that CQ
> >    events will be reported as well.
> >
> > In mlx5_ib layer the below changes were done:
> >  * A new DEVX API was introduced to allocate an event channel by using
> >    the uverbs FD object type.
> >  * Implement the FD channel operations to enable read/poo/close over it.
> >  * A new DEVX API was introduced to subscribe for specific events over an
> >    event channel.
> >  * Manage an internal data structure  over XA(s) to subscribe/dispatch events
> >    over the different event channels.
> >  * Use from DEVX the mlx5_core APIs to create/destroy a CQ to be able to
> >    get its relevant events.
> >
> > Yishai
> >
> > Yishai Hadas (13):
> >   net/mlx5: Fix mlx5_core_destroy_cq() error flow
> >   net/mlx5: Use event mask based on device capabilities
> >   net/mlx5: Expose the API to register for ANY event
> >   net/mlx5: mlx5_core_create_cq() enhancements
> >   net/mlx5: Report a CQ error event only when a handler was set
> >   net/mlx5: Report EQE data upon CQ completion
> >   net/mlx5: Expose device definitions for object events
> >   IB/mlx5: Introduce MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD
> >   IB/mlx5: Register DEVX with mlx5_core to get async events
> >   IB/mlx5: Enable subscription for device events over DEVX
> >   IB/mlx5: Implement DEVX dispatching event
> >   IB/mlx5: Add DEVX support for CQ events
> >   IB/mlx5: DEVX cleanup mdev
>
> This looks OK now, can you please apply the net patches to the shared
> branch

Pushed to mlx5-next branch:

e4075c442876 net/mlx5: Expose device definitions for object events
4e0e2ea1886a net/mlx5: Report EQE data upon CQ completion
70a43d3fd4ef net/mlx5: Report a CQ error event only when a handler was set
38164b771947 net/mlx5: mlx5_core_create_cq() enhancements
c0670781f548 net/mlx5: Expose the API to register for ANY event
b9a7ba556207 net/mlx5: Use event mask based on device capabilities
1d49ce1e05f8 net/mlx5: Fix mlx5_core_destroy_cq() error flow

Thanks

>
> Thanks,
> Jason
