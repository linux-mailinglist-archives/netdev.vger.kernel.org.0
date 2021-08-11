Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3A43E935E
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhHKOPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232183AbhHKOPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 10:15:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E55A60FE6;
        Wed, 11 Aug 2021 14:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628691314;
        bh=f0kjizqLd+VD5lUdM35um/vxIp7TzPw1x4ZK2OqnNug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JN2WE7a0kboVHSMf63qQ75o9rN7Xzb2fvuUftnVn3ncu65jiGPJgQImbl9zLR7gt2
         ECj23AOp5M3U5AjEM3WKGPlqRG8reoGCZUYQ5MTDS4R10KSSoecDL3lHmSG+3GsvEs
         4fntepYz8A2PCXBEQvXlUS8d3pYJerRtsBn1POuEreuEP8PmrOrPW97XhXV2cCY6mQ
         meHMdidxWiIuhapyTbfmHSIJd+vzCao2WWR+LQq34ugOn2Ar9m2c1oAeVrYuGu3LqT
         Mj/wH9T2lRCDgc8YfdeaJD5udteM+B7LB4H8xjHVgrc8O8DOukTwvKuKJW0MgfU8f+
         y5fow2jbCISsg==
Date:   Wed, 11 Aug 2021 17:15:09 +0300
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
Message-ID: <YRPbbeXPNcLTvbTE@unreal>
References: <cover.1628599239.git.leonro@nvidia.com>
 <20210810165318.323eae24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRNp6Zmh99N3kJVa@unreal>
 <20210811062732.0f569b9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRPYMKxPHUkegEhj@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRPYMKxPHUkegEhj@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 05:01:20PM +0300, Leon Romanovsky wrote:
> On Wed, Aug 11, 2021 at 06:27:32AM -0700, Jakub Kicinski wrote:
> > On Wed, 11 Aug 2021 09:10:49 +0300 Leon Romanovsky wrote:
> > > On Tue, Aug 10, 2021 at 04:53:18PM -0700, Jakub Kicinski wrote:
> > > > On Tue, 10 Aug 2021 16:37:30 +0300 Leon Romanovsky wrote:  
> > > > > This series prepares code to remove devlink_reload_enable/_disable API
> > > > > and in order to do, we move all devlink_register() calls to be right
> > > > > before devlink_reload_enable().
> > > > > 
> > > > > The best place for such a call should be right before exiting from
> > > > > the probe().
> > > > > 
> > > > > This is done because devlink_register() opens devlink netlink to the
> > > > > users and gives them a venue to issue commands before initialization
> > > > > is finished.
> > > > > 
> > > > > 1. Some drivers were aware of such "functionality" and tried to protect
> > > > > themselves with extra locks, state machines and devlink_reload_enable().
> > > > > Let's assume that it worked for them, but I'm personally skeptical about
> > > > > it.
> > > > > 
> > > > > 2. Some drivers copied that pattern, but without locks and state
> > > > > machines. That protected them from reload flows, but not from any _set_
> > > > > routines.
> > > > > 
> > > > > 3. And all other drivers simply didn't understand the implications of early
> > > > > devlink_register() and can be seen as "broken".  
> > > > 
> > > > What are those implications for drivers which don't implement reload?
> > > > Depending on which parts of devlink the drivers implement there may well
> > > > be nothing to worry about.
> > > > 
> > > > Plus devlink instances start out with reload disabled. Could you please
> > > > take a step back and explain why these changes are needed.  
> > > 
> > > The problem is that devlink_register() adds new devlink instance to the
> > > list of visible devlinks (devlink_list). It means that all devlink_*_dumpit()
> > > will try to access devices during their initialization, before they are ready.
> > > 
> > > The more troublesome case is that devlink_list is iterated in the
> > > devlink_get_from_attrs() and it is used in devlink_nl_pre_doit(). The
> > > latter function will return to the caller that new devlink is valid and
> > > such caller will be able to proceed to *_set_doit() functions.
> > > 
> > > Just as an example:
> > >  * user sends netlink message
> > >   * devlink_nl_cmd_eswitch_set_doit()
> > >    * ops->eswitch_mode_set()
> > >     * Are you sure that all drivers protected here?
> > >       I remind that driver is in the middle of its probe().
> > > 
> > > Someone can argue that drivers and devlink are protected from anything
> > > harmful with their global (devlink_mutex and devlink->lock) and internal
> > > (device->lock, e.t.c.) locks. However it is impossible to prove for all
> > > drivers and prone to errors.
> > > 
> > > Reload enable/disable gives false impression that the problem exists in
> > > that flow only, which is not true.
> > > 
> > > devlink_reload_enable() is a duct tape because reload flows much easier
> > > to hit.
> > 
> > Right :/
> > 
> > > > > In this series, we focus on items #1 and #2.
> > > > > 
> > > > > Please share your opinion if I should change ALL other drivers to make
> > > > > sure that devlink_register() is the last command or leave them in an
> > > > > as-is state.  
> > > > 
> > > > Can you please share the output of devlink monitor and ip monitor link
> > > > before and after?  The modified drivers will not register ports before
> > > > they register the devlink instance itself.  
> > > 
> > > Not really, they will register but won't be accessible from the user space.
> > > The only difference is the location of "[dev,new] ..." notification.
> > 
> > Is that because of mlx5's use of auxdev, or locking? I don't see
> > anything that should prevent the port notification from coming out.
> 
> And it is ok, kernel can (and does) send notifications, because we left
> devlink_ops assignment to be in devlink_alloc(). It ensures that all
> flows that worked before will continue to work without too much changes.
> 
> > 
> > I think the notifications need to get straightened out, we can't notify
> > about sub-objects until the object is registered, since they are
> > inaccessible.
> 
> I'm not sure about that. You present the case where kernel and user
> space races against each other and historically kernel doesn't protect
> from such flows. 
> 
> For example, you can randomly remove and add kernel modules. At some
> point of time, you will get "missing symbols errors", just because
> one module tries to load and it depends on already removed one.
> 
> We must protect kernel and this is what I do. User shouldn't access
> devlink instance before he sees "dev name" notification.
> 
> Of course, we can move various iterators to devlink_register(), but it
> will make code much complex, because we have objects that can be
> registered at any time (IMHO. trap is one of them) and I will need to 
> implement notification logic that separate objects that were created
> before devlink_register and after.

Bottom line,
I'm trying to make code simpler, not opposite :).

> 
> Thanks
