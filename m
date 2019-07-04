Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7475FD0A
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfGDSjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfGDSjY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:39:24 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A0EF2189E;
        Thu,  4 Jul 2019 18:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562265563;
        bh=kmsUmHiYtovjV+TzUMycaQqX1N/BN6kBGjDDo116WqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g07dwtkkB6Bl4DN+elUOFmPCmZWe6tfuyy8l7BzN3YjxfzMU/VJddLpDyufgq632a
         RB6bmgeCR5HNYxUXuRijCU2ccjs+QRxiVqICLCmhMRUGdmH0vh46pD5BeuGoe7/VUe
         2n/4+KqO1BcnuWUrOiN/lqbEtb7To2lRqoD6oq1w=
Date:   Thu, 4 Jul 2019 21:39:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v5 00/17] Statistics counter support
Message-ID: <20190704183909.GL7212@mtr-leonro.mtl.com>
References: <20190702100246.17382-1-leon@kernel.org>
 <20190704182529.GA20631@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704182529.GA20631@ziepe.ca>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 03:25:29PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 02, 2019 at 01:02:29PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog:
> >  v4 -> v5:
> >  * Patch #6 and #14 - consolidated many counter release functions,
> >    removed mutex lock protection from dealloc_counter() call
> >    and simplified kref_put/kref_get operations.
> >  * Added Saeed's ACK tags.
> >  v3 -> v4:
> >  * Add counter_dealloc() callback function
> >  * Moved to kref implementation
> >  * Fixed lock during spinlock
> >  v2 -> v3:
> >  * We didn't change use of atomics over kref for management of unbind
> >    counter from QP. The reason to it that bind and unbind are non-symmetric
> >    in regards of put and get, so we need to count differently memory
> >    release flows of HW objects (restrack) and SW bind operations.
> >  * Everything else was addressed.
> >  v1 -> v2:
> >  * Rebased to latest rdma-next
> >  v0 -> v1:
> >  * Changed wording of counter comment
> >  * Removed unneeded assignments
> >  * Added extra patch to present global counters
> >
> >
> > Hi,
> >
> > This series from Mark provides dynamic statistics infrastructure.
> > He uses netlink interface to configure and retrieve those counters.
> >
> > This infrastructure allows to users monitor various objects by binding
> > to them counters. As the beginning, we used QP object as target for
> > those counters, but future patches will include ODP MR information too.
> >
> > Two binding modes are supported:
> >  - Auto: This allows a user to build automatic set of objects to a counter
> >    according to common criteria. For example in a per-type scheme, where in
> >    one process all QPs with same QP type are bound automatically to a single
> >    counter.
> >  - Manual: This allows a user to manually bind objects on a counter.
> >
> > Those two modes are mutual-exclusive with separation between processes,
> > objects created by different processes cannot be bound to a same counter.
> >
> > For objects which don't support counter binding, we will return
> > pre-allocated counters.
> >
> > $ rdma statistic qp set link mlx5_2/1 auto type on
> > $ rdma statistic qp set link mlx5_2/1 auto off
> > $ rdma statistic qp bind link mlx5_2/1 lqpn 178
> > $ rdma statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178
> > $ rdma statistic show
> > $ rdma statistic qp mode
> >
> > Thanks
> >
> >
> > Mark Zhang (17):
> >   net/mlx5: Add rts2rts_qp_counters_set_id field in hca cap
> >   RDMA/restrack: Introduce statistic counter
> >   RDMA/restrack: Add an API to attach a task to a resource
> >   RDMA/restrack: Make is_visible_in_pid_ns() as an API
> >   RDMA/counter: Add set/clear per-port auto mode support
> >   RDMA/counter: Add "auto" configuration mode support
> >   IB/mlx5: Support set qp counter
> >   IB/mlx5: Add counter set id as a parameter for
> >     mlx5_ib_query_q_counters()
> >   IB/mlx5: Support statistic q counter configuration
> >   RDMA/nldev: Allow counter auto mode configration through RDMA netlink
> >   RDMA/netlink: Implement counter dumpit calback
> >   IB/mlx5: Add counter_alloc_stats() and counter_update_stats() support
> >   RDMA/core: Get sum value of all counters when perform a sysfs stat
> >     read
> >   RDMA/counter: Allow manual mode configuration support
> >   RDMA/nldev: Allow counter manual mode configration through RDMA
> >     netlink
> >   RDMA/nldev: Allow get counter mode through RDMA netlink
> >   RDMA/nldev: Allow get default counter statistics through RDMA netlink
>
> Well, I can made the needed edits, can you apply the the first patch
> to the shared branch?

Thanks, pushed
f8efee08dd9d net/mlx5: Add rts2rts_qp_counters_set_id field in hca cap

>
> Thanks,
> Jason
