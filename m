Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CC33E9331
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhHKOBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232043AbhHKOBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 10:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A55F60551;
        Wed, 11 Aug 2021 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628690486;
        bh=mjtCn1dFbI/d+ZYZyuj2dmqfGr8mrkzkdc01CNS4RXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JqT/n9RCDlFwVqbykebB604435eShWnkY4odBTVBegVagpFeiB8f6Hil3qTzY6/sC
         N4PM7BURZi9Ix16dsUxiZM1ikJoMmqXOcWmBcor0uSCSNt0ZZi3IT6rwwxN9lYMU8E
         UcYe6kX7Q3194PEvZHQ1zEsgf4WS18jzuN3VAeO0TqOWjY5XJTReBBSkwwv5YjrqfL
         BEu6BNaknoaJgTu5UgQHlnR54Qr6+4aSsaScMe2U4GOpsUPgrbiCRRkyI+jCofjxgA
         acjIIuS9ogWQmS0ldahc86Q97X6Tdx0QPWXsOoESh0khjNOggm0nrZmqqwMgP1/Zet
         sSXWavy2p8kKg==
Date:   Wed, 11 Aug 2021 17:01:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 0/5] Move devlink_register to be near
 devlink_reload_enable
Message-ID: <YRPYMKxPHUkegEhj@unreal>
References: <cover.1628599239.git.leonro@nvidia.com>
 <20210810165318.323eae24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRNp6Zmh99N3kJVa@unreal>
 <20210811062732.0f569b9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811062732.0f569b9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 06:27:32AM -0700, Jakub Kicinski wrote:
> On Wed, 11 Aug 2021 09:10:49 +0300 Leon Romanovsky wrote:
> > On Tue, Aug 10, 2021 at 04:53:18PM -0700, Jakub Kicinski wrote:
> > > On Tue, 10 Aug 2021 16:37:30 +0300 Leon Romanovsky wrote:  
> > > > This series prepares code to remove devlink_reload_enable/_disable API
> > > > and in order to do, we move all devlink_register() calls to be right
> > > > before devlink_reload_enable().
> > > > 
> > > > The best place for such a call should be right before exiting from
> > > > the probe().
> > > > 
> > > > This is done because devlink_register() opens devlink netlink to the
> > > > users and gives them a venue to issue commands before initialization
> > > > is finished.
> > > > 
> > > > 1. Some drivers were aware of such "functionality" and tried to protect
> > > > themselves with extra locks, state machines and devlink_reload_enable().
> > > > Let's assume that it worked for them, but I'm personally skeptical about
> > > > it.
> > > > 
> > > > 2. Some drivers copied that pattern, but without locks and state
> > > > machines. That protected them from reload flows, but not from any _set_
> > > > routines.
> > > > 
> > > > 3. And all other drivers simply didn't understand the implications of early
> > > > devlink_register() and can be seen as "broken".  
> > > 
> > > What are those implications for drivers which don't implement reload?
> > > Depending on which parts of devlink the drivers implement there may well
> > > be nothing to worry about.
> > > 
> > > Plus devlink instances start out with reload disabled. Could you please
> > > take a step back and explain why these changes are needed.  
> > 
> > The problem is that devlink_register() adds new devlink instance to the
> > list of visible devlinks (devlink_list). It means that all devlink_*_dumpit()
> > will try to access devices during their initialization, before they are ready.
> > 
> > The more troublesome case is that devlink_list is iterated in the
> > devlink_get_from_attrs() and it is used in devlink_nl_pre_doit(). The
> > latter function will return to the caller that new devlink is valid and
> > such caller will be able to proceed to *_set_doit() functions.
> > 
> > Just as an example:
> >  * user sends netlink message
> >   * devlink_nl_cmd_eswitch_set_doit()
> >    * ops->eswitch_mode_set()
> >     * Are you sure that all drivers protected here?
> >       I remind that driver is in the middle of its probe().
> > 
> > Someone can argue that drivers and devlink are protected from anything
> > harmful with their global (devlink_mutex and devlink->lock) and internal
> > (device->lock, e.t.c.) locks. However it is impossible to prove for all
> > drivers and prone to errors.
> > 
> > Reload enable/disable gives false impression that the problem exists in
> > that flow only, which is not true.
> > 
> > devlink_reload_enable() is a duct tape because reload flows much easier
> > to hit.
> 
> Right :/
> 
> > > > In this series, we focus on items #1 and #2.
> > > > 
> > > > Please share your opinion if I should change ALL other drivers to make
> > > > sure that devlink_register() is the last command or leave them in an
> > > > as-is state.  
> > > 
> > > Can you please share the output of devlink monitor and ip monitor link
> > > before and after?  The modified drivers will not register ports before
> > > they register the devlink instance itself.  
> > 
> > Not really, they will register but won't be accessible from the user space.
> > The only difference is the location of "[dev,new] ..." notification.
> 
> Is that because of mlx5's use of auxdev, or locking? I don't see
> anything that should prevent the port notification from coming out.

And it is ok, kernel can (and does) send notifications, because we left
devlink_ops assignment to be in devlink_alloc(). It ensures that all
flows that worked before will continue to work without too much changes.

> 
> I think the notifications need to get straightened out, we can't notify
> about sub-objects until the object is registered, since they are
> inaccessible.

I'm not sure about that. You present the case where kernel and user
space races against each other and historically kernel doesn't protect
from such flows. 

For example, you can randomly remove and add kernel modules. At some
point of time, you will get "missing symbols errors", just because
one module tries to load and it depends on already removed one.

We must protect kernel and this is what I do. User shouldn't access
devlink instance before he sees "dev name" notification.

Of course, we can move various iterators to devlink_register(), but it
will make code much complex, because we have objects that can be
registered at any time (IMHO. trap is one of them) and I will need to 
implement notification logic that separate objects that were created
before devlink_register and after.

Thanks
