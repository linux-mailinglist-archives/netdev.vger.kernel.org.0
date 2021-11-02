Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E069443158
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 16:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhKBPQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhKBPQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 11:16:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CA3C60F24;
        Tue,  2 Nov 2021 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635866056;
        bh=+dfXLeESHOQAD3NwfE6Kt8uOxq23nxGJLewjNTaFsV4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NoEPYRQSUIgF7lSzjyV4d/DeAIgtc3ZEPmrDncLfzdvV4//lS69YgW2QgYhDqINcZ
         +jTOmBrZVqXi0GLiXqz1K5oOZnPyDx6bXAVEoHszuWGUdkJY0W9RsoMVrxun859PXn
         HBREx8dBe8Acw4GO/fwIZLJDmKcGzgy2EnF6KE8x2P5kHS2rT/NQtOP0ewpkOOHtWt
         xpV1wUvjUJpe/d64pXGr9+EXnoJuRN0Bzkz++w5bHrg+bTwzE0Shtfid2XQEE7c1QA
         HQUJvCmtCajS7GUseLSrM0+WaDw5HZcpKWRMkDN7/2CAWtoVhN2CncgbsLBOaUFAwS
         zd64r5g1CJB9g==
Date:   Tue, 2 Nov 2021 08:14:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     idosch@idosch.org, edwin.peer@broadcom.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <20211102081412.6d4e2275@kicinski-fedora-PC1C0HJN>
In-Reply-To: <YYDyBxNzJSpKXosy@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
        <YX5Efghyxu5g8kzY@unreal>
        <20211101073259.33406da3@kicinski-fedora-PC1C0HJN>
        <YYAzn+mtrGp/As74@unreal>
        <20211101141613.3373b7f4@kicinski-fedora-PC1C0HJN>
        <YYDyBxNzJSpKXosy@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 10:08:39 +0200 Leon Romanovsky wrote:
> On Mon, Nov 01, 2021 at 02:16:13PM -0700, Jakub Kicinski wrote:
> > On Mon, 1 Nov 2021 20:36:15 +0200 Leon Romanovsky wrote:  
> > > This is three step process, but mainly it is first step. We need to make
> > > sure that functions that can re-entry will use nested locks.
> > > 
> > > Steps:
> > > 1. Use proper locking API that supports nesting:
> > > https://lore.kernel.org/netdev/YYABqfFy%2F%2Fg5Gdis@nanopsycho/T/#mf9dc5cac2013abe413545bbe4a09cc231ae209a4  
> > 
> > Whether we provide the an unlocked API or allow lock nesting 
> > on the driver API is not that important to me.  
> 
> Thanks

Not sure what you're thanking for. I still prefer two explicit APIs.
Allowing nesting is not really necessary here. Callers know whether
they hold the lock or not.

Please see netdevsim, it takes the devlink_lock() at entry points to
the driver - which in turn means the API which takes a lock can be
removed once all drivers are converted.

> > > 2. Convert devlink->lock to be RW semaphore:
> > > commit 4506dd3a90a82a0b6bde238f507907747ab88407
> > > Author: Leon Romanovsky <leon@kernel.org>
> > > Date:   Sun Oct 24 16:54:16 2021 +0300
> > > 
> > >     devlink: Convert devlink lock to be RW semaphore
> > > 
> > >     This is naive conversion of devlink->lock to RW semaphore, so we will be
> > >     able to differentiate commands that require exclusive access vs. parallel
> > >     ready-to-run ones.
> > > 
> > >     All "set" commands that used devlink->lock are converted to write lock,
> > >     while all "get" commands are marked with read lock.
> > > 
> > > @@ -578,8 +584,12 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
> > >                 mutex_unlock(&devlink_mutex);
> > >                 return PTR_ERR(devlink);
> > >         }
> > > -       if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
> > > -               mutex_lock(&devlink->lock);
> > > +
> > > +       if (~ops->internal_flags & DEVLINK_NL_FLAG_SHARED_ACCESS)
> > > +               down_write(&devlink->rwsem);
> > > +       else
> > > +               down_read(&devlink->rwsem);
> > > +  
> > 
> > IIUC the RW sem thing is an optimization, it's besides the point.  
> 
> I need RW as a way to ensure "exclusive" access during _set_ operation.
> It is not an optimization, but simple way to understand if parallel
> access is possible at this specific point of time.

How is this not an optimization to allow parallel "reads"?

Anything that calls the driver has no idea whether the driver needs
read or write locking (assuming drivers depend on devlink for locking
as they should) so I presume you only plan this for dumps which don't
call the driver?

Anyway, consider this a nack, it should most definitely not be a part 
of the initial conversions. We have enough fallout to deal with.

> > > How? I have only one rule:
> > >  * Driver author should be aware that between devlink_register() and
> > >    devlink_unregister(), users can send netlink commands.
> > > 
> > > In your solution, driver authors will need to follow whole devlink
> > > how-to-use book.  
> > 
> > Only if they need refs. If you don't the API is the same as yours.
> > 
> > IOW you don't provide an API for advanced use cases at all. You force
> > the drivers to implement their own reference counting and locking.   
> 
> The complex drivers already do it anyway, because they need to reference
> counting their own structures to make sure that the lifetime of these
> structures meats their model.

Well, no comments on what mlx5 does or has to do but it's likely the
most complex driver. Don't judge what others will benefit from based 
on mlx5.

> > I want them to just rely on devlink as a framework.  
> 
> And I don't :). For me devlink is a way to configure device, not manage
> lifetime of driver specific data structures.

My mind is set here. Obviously "community" can override, so gather
support from significant devs or it's my way... sorry to be blunt.

> > How many driver locks do you have in netdevsim after conversion?
> > All 3? How do you add a port to the instance from sysfs without a
> > AB / BA deadlock between the port lock and the devlink lock if the
> > driver can't take the devlink lock? Are you still going to need the 
> > "in_reload" wart?  
> 
> I don't know yet, because as you wrote before netdevsim is for
> prototyping and such ABBA deadlock doesn't exist in real devices.
> 
> My current focus is real devices for now.

I wrote it with nfp in mind as well. It has a delayed work which needs
to take the port lock. Sadly I don't have any nfps handy and I didn't
want to post an untested patch.

> Maybe the solution will be to go away from sysfs completely. We will see.

Sigh, I feel like I just fixed netdevsim after it has been getting bit
rotted for a couple of years.

> > > Strange, I see completely opposite picture in the git log with so much
> > > changes that have Fixes line and add/remove/mention rtnl_lock. Maybe it
> > > is useful, but almost all if not all drivers full of fixes of rtnl_lock
> > > usage. I don't want same for the devlink.  
> > 
> > If you don't provide a locking API to the drivers you'll have to fix 2x
> > the bugs, and each of them subtly different. At least maintainers know
> > what rtnl_lock rules are.  
> 
> I clearly remember this patch and the sentence "...in
> some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
> again". The word "... some ..." hints to me that maintainers have different
> opinion on how to use rtnl_lock.
> 
> https://lore.kernel.org/netdev/20210809032809.1224002-1-acelan.kao@canonical.com/

Yes, using rtnl_lock for PM is certainly a bad idea, and I'm not sure
why Intel does it. There are 10s of drivers which take rtnl_lock
correctly and it greatly simplifies their lives.
