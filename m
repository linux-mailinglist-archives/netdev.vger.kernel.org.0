Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CAF4216E5
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238843AbhJDTEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236871AbhJDTD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:03:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB08D610C9;
        Mon,  4 Oct 2021 19:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633374130;
        bh=ums4GQN0hZsGykpaXdF4ywDi56bYq6IogSUjYVxl8jc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tof7535P9szlEJzEUNXb1UiENraBp7dHy173RGKQSYjSVKAughXi6MSyz6Yf84XrH
         gQt19jOUfXXFOigzu7xg7gRmSuJsOZyaCIEsToeXu61Z/QugRK3Ljj9oX2aldLC4wz
         CFrLjxbXlB660i5C8nR/F6WrZUxHGWlP0+mHzGTC4V5Ts0PKpTRBvqfbsR1oneL3i4
         e/mYDb/CTAw45EnUuYG3sreQk+wN1S4FrUkHWwx4JozS7oc6dgpaMawqPgfgjkaJxj
         3RBgIvJX00wpDkcu4AOaOtBZOPLf1cS6s+el7sAP/Rlzio7H0XlQs6joEOcEeGC2xT
         Dyqq9ZaoCqP8A==
Date:   Mon, 4 Oct 2021 22:02:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v2 5/5] devlink: Delete reload enable/disable
 interface
Message-ID: <YVtPruw9kzOQvhZu@unreal>
References: <cover.1633284302.git.leonro@nvidia.com>
 <06ebba9e115d421118b16ac4efda61c2e08f4d50.1633284302.git.leonro@nvidia.com>
 <YVsNfLzhGULiifw2@shredder>
 <YVshg3a9OpotmOQg@unreal>
 <YVsxqsEGkV0A5lvO@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVsxqsEGkV0A5lvO@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 07:54:02PM +0300, Ido Schimmel wrote:
> On Mon, Oct 04, 2021 at 06:45:07PM +0300, Leon Romanovsky wrote:
> > On Mon, Oct 04, 2021 at 05:19:40PM +0300, Ido Schimmel wrote:
> > > On Sun, Oct 03, 2021 at 09:12:06PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > After changes to allow dynamically set the reload_up/_down callbacks,
> > > > we ensure that properly supported devlink ops are not accessible before
> > > > devlink_register, which is last command in the initialization sequence.
> > > > 
> > > > It makes devlink_reload_enable/_disable not relevant anymore and can be
> > > > safely deleted.
> > > > 
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > [...]
> > > 
> > > > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > > > index cb6645012a30..09e48fb232a9 100644
> > > > --- a/drivers/net/netdevsim/dev.c
> > > > +++ b/drivers/net/netdevsim/dev.c
> > > > @@ -1512,7 +1512,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
> > > >  
> > > >  	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
> > > >  	devlink_register(devlink);
> > > > -	devlink_reload_enable(devlink);
> > > >  	return 0;
> > > >  
> > > >  err_psample_exit:
> > > > @@ -1566,9 +1565,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
> > > >  	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
> > > >  	struct devlink *devlink = priv_to_devlink(nsim_dev);
> > > >  
> > > > -	devlink_reload_disable(devlink);
> > > >  	devlink_unregister(devlink);
> > > > -
> > > >  	nsim_dev_reload_destroy(nsim_dev);
> > > >  
> > > >  	nsim_bpf_dev_exit(nsim_dev);
> > > 
> > > I didn't remember why devlink_reload_{enable,disable}() were added in
> > > the first place so it was not clear to me from the commit message why
> > > they can be removed. It is described in commit a0c76345e3d3 ("devlink:
> > > disallow reload operation during device cleanup") with a reproducer.
> > 
> > It was added because devlink ops were accessible by the user space very
> > early in the driver lifetime. All my latest devlink patches are the
> > attempt to fix this arch/design/implementation issue.
> 
> The reproducer in the commit message executed the reload after the
> device was fully initialized. IIRC, the problem there was that nothing
> prevented these two tasks from racing:
> 
> devlink dev reload netdevsim/netdevsim10
> echo 10 > /sys/bus/netdevsim/del_device
> 
> The title also talks about forbidding reload during device cleanup.

It is incomplete title and reproducer. In our verification, we observed
more than 40 bugs related to devlink reload flows and races around it.

> 
> > 
> > > 
> > > Tried the reproducer with this series and I cannot reproduce the issue.
> > > Wasn't quite sure why, but it does not seem to be related to "changes to
> > > allow dynamically set the reload_up/_down callbacks", as this seems to
> > > be specific to mlx5.
> > 
> > You didn't reproduce because of my series that moved
> > devlink_register()/devlink_unregister() to be last/first commands in
> > .probe()/.remove() flows.
> 
> Agree, that is what I wrote in the next paragraph of my reply.
> 
> > 
> > Patch to allow dynamically set ops was needed because mlx5 had logic
> > like this:
> >  if(something)
> >     devlink_reload_enable()
> > 
> > And I needed a way to keep this if ... condition.
> > 
> > > 
> > > IIUC, the reason that the race described in above mentioned commit can
> > > no longer happen is related to the fact that devlink_unregister() is
> > > called first in the device dismantle path, after your previous patches.
> > > Since both the reload operation and devlink_unregister() hold
> > > 'devlink_mutex', it is not possible for the reload operation to race
> > > with device dismantle.
> > > 
> > > Agree? If so, I think it would be good to explain this in the commit
> > > message unless it's clear to everyone else.
> > 
> > I don't agree for very simple reason that devlink_mutex is going to be
> > removed very soon and it is really not a reason why devlink reload is
> > safer now when before.
> > 
> > The reload can't race due to:
> > 1. devlink_unregister(), which works as a barrier to stop accesses
> > from the user space.
> > 2. reference counting that ensures that all in-flight commands are counted.
> > 3. wait_for_completion that blocks till all commands are done.
> 
> So the wait_for_completion() is what prevents the race, not
> 'devlink_mutex' that is taken later. This needs to be explained in the
> commit message to make it clear why the removal is safe.

Can you please suggest what exactly should I write in the commit message
to make it clear?

I'm too much into this delvink stuff already and for me this patch is
trivial. IMHO, that change doesn't need an explanation at all because
coding pattern of refcount + wait_for_completion is pretty common in the
kernel. So I think that I explained good enough: move of
devlink_register/devlink_unregister obsoletes the devlink_reload_* APIs.

I have no problem to update the commit message, just help me with the
message.

Thanks

> 
> Thanks
