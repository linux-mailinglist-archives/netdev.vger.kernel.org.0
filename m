Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F019E1642FD
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 12:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgBSLHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 06:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgBSLHG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 06:07:06 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DA78208E4;
        Wed, 19 Feb 2020 11:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582110425;
        bh=YveiNU8gnL+vIr/PlvY7malMUjnLerxO6ExoAiWH6os=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eHgrrsybfrZwbcNq4q7bDniEm6QmbNbzqSKVS32ojRouU0lSMhpOSB59R3HsVWCEJ
         LE8kvF4FAetL8ywbYc9HNoox4/tKSO73Ko7aVsXtOeQfKWNuZuTv4ps/zB8VrWpbQv
         tGXtQk/fFtYgmDaH4FGTOMVgEiwYUKu6FsjGI8rI=
Date:   Wed, 19 Feb 2020 13:07:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Lang Cheng <chenglang@huawei.com>,
        dledford@redhat.com, davem@davemloft.net, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, linuxarm@huawei.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>, bhaktipriya96@gmail.com,
        tj@kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [RFC rdma-next] RDMA/core: Add attribute WQ_MEM_RECLAIM to
 workqueue "infiniband"
Message-ID: <20200219110700.GK15239@unreal>
References: <1581996935-46507-1-git-send-email-chenglang@huawei.com>
 <20200218153156.GD31668@ziepe.ca>
 <212eda31-cc86-5487-051b-cb51c368b6fe@huawei.com>
 <20200219064507.GC15239@unreal>
 <1155d15f-4188-e5cd-3e4a-6e0c52e9b1eb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1155d15f-4188-e5cd-3e4a-6e0c52e9b1eb@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 03:40:59PM +0800, Yunsheng Lin wrote:
> +cc Bhaktipriya, Tejun and Jeff
>
> On 2020/2/19 14:45, Leon Romanovsky wrote:
> > On Wed, Feb 19, 2020 at 09:13:23AM +0800, Yunsheng Lin wrote:
> >> On 2020/2/18 23:31, Jason Gunthorpe wrote:
> >>> On Tue, Feb 18, 2020 at 11:35:35AM +0800, Lang Cheng wrote:
> >>>> The hns3 driver sets "hclge_service_task" workqueue with
> >>>> WQ_MEM_RECLAIM flag in order to guarantee forward progress
> >>>> under memory pressure.
> >>>
> >>> Don't do that. WQ_MEM_RECLAIM is only to be used by things interlinked
> >>> with reclaimed processing.
> >>>
> >>> Work on queues marked with WQ_MEM_RECLAIM can't use GFP_KERNEL
> >>> allocations, can't do certain kinds of sleeps, can't hold certain
> >>> kinds of locks, etc.
>
> By the way, what kind of sleeps and locks can not be done in the work
> queued to wq marked with WQ_MEM_RECLAIM?

I didn't see this knowledge documented, but I would assume that
everything that can block memory reclaim progress should not be
in such workqueue.

>
> >>
> >> From mlx5 driver, it seems that there is GFP_KERNEL allocations
> >> on wq marked with WQ_MEM_RECLAIM too:
> >>
> >> mlx5e_tx_timeout_work() -> mlx5e_safe_reopen_channels() ->
> >> mlx5e_safe_switch_channels() -> mlx5e_open_channels()
> >>
> >> kcalloc() is called with GFP_KERNEL in mlx5e_open_channels(),
> >> and mlx5e_tx_timeout_work() is queued with priv->wq, which is
> >> allocated with WQ_MEM_RECLAIM flags. see:
> >>
> >> mlx5e_netdev_init() -> create_singlethread_workqueue()
> >
> > There are two reasons for that, first mlx5 driver was written far before
> > WQ_MEM_RECLAIM usage was clarified, second mlx5 has bugs.
> >
> >>
> >>
> >> From the comment in kernel/workqueue.c, the work queued with
> >> wq with WQ_MEM_RECLAIM flag set seems to be executed without
> >> blocking under some rare case. I still not quite understand
> >> the comment, and I can not find any doc that point out the
> >> GFP_KERNEL allocations can not be done in wq with WQ_MEM_RECLAIM
> >> yet. Is there any doc that mentions that GFP_KERNEL allocations
> >> can not be done in wq with WQ_MEM_RECLAIM?
> >
> > It is whole purpose of WQ_MEM_RECLAIM flag - allow progress in case of
> > memory pressure. Allocation memory while we are under memory pressure
> > is an invitation for a disaster.
>
> Ok, make sense.
>
> >
> >>
> >>
> >> /**
> >>  * rescuer_thread - the rescuer thread function
> >>  * @__rescuer: self
> >>  *
> >>  * Workqueue rescuer thread function.  There's one rescuer for each
> >>  * workqueue which has WQ_MEM_RECLAIM set.
> >>  *
> >>  * Regular work processing on a pool may block trying to create a new
> >>  * worker which uses GFP_KERNEL allocation which has slight chance of
> >>  * developing into deadlock if some works currently on the same queue
> >>  * need to be processed to satisfy the GFP_KERNEL allocation.  This is
> >>  * the problem rescuer solves.
> >>  *
> >>  * When such condition is possible, the pool summons rescuers of all
> >>  * workqueues which have works queued on the pool and let them process
> >>  * those works so that forward progress can be guaranteed.
> >>  *
> >>  * This should happen rarely.
> >>  *
> >>  * Return: 0
> >>  */
> >>
> >>
> >> The below is the reason we add the sets "hclge_service_task" workqueue
> >> with WQ_MEM_RECLAIM through analysing why other ethernet drivers has
> >> allocated wq with WQ_MEM_RECLAIM flag, I may be wrong about that:
> >
> > Many drivers are developed using copy/paste technique, so it is wrong
> > to assume that "other ethernet drivers" did the right thing.
> >
> >>
> >> hns3 ethernet driver may be used as the low level transport of a
> >> network file system, memory reclaim data path may depend on the
> >> worker in hns3 driver to bring back the ethernet link so that it flush
> >> the some cache to network based disk.
> >
> > Unlikely that this "network file system" dependency on ethernet link is correct.
>
> Ok, I may be wrong about the above usecase.
> but the below commit explicitly state that network devices may be used in
> memory reclaim path.
>
> 0a38c17a21a0 ("fm10k: Remove create_workqueue"):
>
> fm10k: Remove create_workqueue
>
> alloc_workqueue replaces deprecated create_workqueue().
>
> A dedicated workqueue has been used since the workitem (viz
> fm10k_service_task, which manages and runs other subtasks) is involved in
> normal device operation and requires forward progress under memory
> pressure.
>
> create_workqueue has been replaced with alloc_workqueue with max_active
> as 0 since there is no need for throttling the number of active work
> items.
>
> Since network devices may be used in memory reclaim path,
> WQ_MEM_RECLAIM has been set to guarantee forward progress.
>
> flush_workqueue is unnecessary since destroy_workqueue() itself calls
> drain_workqueue() which flushes repeatedly till the workqueue
> becomes empty. Hence the call to flush_workqueue() has been dropped.
>
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>
> So:
> 1. Maybe the above commit log is misleading, and network device driver's
>    wq does not need the WQ_MEM_RECLAIM flag, then maybe document what can
>    not be done in the work queued to wq marked with WQ_MEM_RECLAIM, and
>    remove the WQ_MEM_RECLAIM flag for the wq of network device driver.

I wouldn't truly count on what is written in commit messages of patch
series which globally replaced create_workqueue() interface.

>
>
> 2. If the network device driver's wq does need the WQ_MEM_RECLAIM flag, then
>    hns3 may have tow problems here: WQ_MEM_RECLAIM wq flushing !WQ_MEM_RECLAIM
>    wq problem and GFP_KERNEL allocations in the work queued to WQ_MEM_RECLAIM wq.

You are proposing to put WQ_MEM_RECLAIM in infiniband queue and not to
special queue inside of the driver.

>
> >
> > Thanks
> >
> >>
> >>>
> >>> Jason
> >>>
> >>>
> >>
> >
> > .
> >
>
