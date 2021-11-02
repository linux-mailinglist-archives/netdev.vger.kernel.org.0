Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B1E44353A
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhKBSRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230392AbhKBSRB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 14:17:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F7D860EBB;
        Tue,  2 Nov 2021 18:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635876866;
        bh=J+pRDKiduqRzyUg/D6HiK4A9Z0uhDsaexXFJhAc4KaM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WpP3rus85YpE37W5tgCGUDUGzUDZkf34gc8lJXP1feK8xKhBHcfYOWs8D/lprOtpr
         NF6UqsXl1Q/n49LmMzhEI1X8FGJbq4rr9j3Z+VkQ+1Zw7buqzXVPx97stUo/NO+CAP
         N1Bz/4c5ErMFcWcxPEWQ1hBIBj9kWdmS70mv+2kDXZ/ZI03pZm+yns49lNDuuFz59r
         GvlVT/oyJkIXCyj+yIxa8rMfzEsu5lncx4zJ+BB1jX/u8p2+zP612Llme/tkcyDJab
         TPhq/Tk9vHZzkDFy0aDT/G/hWRBPXKRA7o/ORSM/KUUhGXhiT4Y836yHIH2U7MQU5y
         +6IXX0zAcY7Iw==
Date:   Tue, 2 Nov 2021 20:14:22 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@idosch.org, edwin.peer@broadcom.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <YYF//p5mDQ2/reOD@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
 <YX5Efghyxu5g8kzY@unreal>
 <20211101073259.33406da3@kicinski-fedora-PC1C0HJN>
 <YYAzn+mtrGp/As74@unreal>
 <20211101141613.3373b7f4@kicinski-fedora-PC1C0HJN>
 <YYDyBxNzJSpKXosy@unreal>
 <20211102081412.6d4e2275@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102081412.6d4e2275@kicinski-fedora-PC1C0HJN>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 08:14:12AM -0700, Jakub Kicinski wrote:
> On Tue, 2 Nov 2021 10:08:39 +0200 Leon Romanovsky wrote:
> > On Mon, Nov 01, 2021 at 02:16:13PM -0700, Jakub Kicinski wrote:
> > > On Mon, 1 Nov 2021 20:36:15 +0200 Leon Romanovsky wrote:  
> > > > This is three step process, but mainly it is first step. We need to make
> > > > sure that functions that can re-entry will use nested locks.
> > > > 
> > > > Steps:
> > > > 1. Use proper locking API that supports nesting:
> > > > https://lore.kernel.org/netdev/YYABqfFy%2F%2Fg5Gdis@nanopsycho/T/#mf9dc5cac2013abe413545bbe4a09cc231ae209a4  
> > > 
> > > Whether we provide the an unlocked API or allow lock nesting 
> > > on the driver API is not that important to me.  
> > 
> > Thanks
> 
> Not sure what you're thanking for. I still prefer two explicit APIs.
> Allowing nesting is not really necessary here. Callers know whether
> they hold the lock or not.

I'm doubt about. It maybe easy to tell in reload flow, but it is much
harder inside eswitch mode change (as an example).

> 
> Please see netdevsim, it takes the devlink_lock() at entry points to
> the driver - which in turn means the API which takes a lock can be
> removed once all drivers are converted.

Netdevsim is a nice example, but it is very different from the real device.

> 
> > > > 2. Convert devlink->lock to be RW semaphore:
> > > > commit 4506dd3a90a82a0b6bde238f507907747ab88407
> > > > Author: Leon Romanovsky <leon@kernel.org>
> > > > Date:   Sun Oct 24 16:54:16 2021 +0300
> > > > 
> > > >     devlink: Convert devlink lock to be RW semaphore
> > > > 
> > > >     This is naive conversion of devlink->lock to RW semaphore, so we will be
> > > >     able to differentiate commands that require exclusive access vs. parallel
> > > >     ready-to-run ones.
> > > > 
> > > >     All "set" commands that used devlink->lock are converted to write lock,
> > > >     while all "get" commands are marked with read lock.
> > > > 
> > > > @@ -578,8 +584,12 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
> > > >                 mutex_unlock(&devlink_mutex);
> > > >                 return PTR_ERR(devlink);
> > > >         }
> > > > -       if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
> > > > -               mutex_lock(&devlink->lock);
> > > > +
> > > > +       if (~ops->internal_flags & DEVLINK_NL_FLAG_SHARED_ACCESS)
> > > > +               down_write(&devlink->rwsem);
> > > > +       else
> > > > +               down_read(&devlink->rwsem);
> > > > +  
> > > 
> > > IIUC the RW sem thing is an optimization, it's besides the point.  
> > 
> > I need RW as a way to ensure "exclusive" access during _set_ operation.
> > It is not an optimization, but simple way to understand if parallel
> > access is possible at this specific point of time.
> 
> How is this not an optimization to allow parallel "reads"?

You need to stop everything when _set_ command is called. One way is to
require for all netlink devlink calls to have lock, another solution is
to use RW semaphore. This is why it is not optimization, but an implementation.
Parallel "reads" are nice bonus.

> 
> Anything that calls the driver has no idea whether the driver needs
> read or write locking (assuming drivers depend on devlink for locking
> as they should) so I presume you only plan this for dumps which don't
> call the driver?

I planned to separate based on command nature:
 * _set_ == write lock
 * _get_ == read lock

> 
> Anyway, consider this a nack, it should most definitely not be a part 
> of the initial conversions. We have enough fallout to deal with.

Any solution should take this into account. We can't design scheme that
will be needed to be rewritten immediately after merge.

> 
> > > > How? I have only one rule:
> > > >  * Driver author should be aware that between devlink_register() and
> > > >    devlink_unregister(), users can send netlink commands.
> > > > 
> > > > In your solution, driver authors will need to follow whole devlink
> > > > how-to-use book.  
> > > 
> > > Only if they need refs. If you don't the API is the same as yours.
> > > 
> > > IOW you don't provide an API for advanced use cases at all. You force
> > > the drivers to implement their own reference counting and locking.   
> > 
> > The complex drivers already do it anyway, because they need to reference
> > counting their own structures to make sure that the lifetime of these
> > structures meats their model.
> 
> Well, no comments on what mlx5 does or has to do but it's likely the
> most complex driver. Don't judge what others will benefit from based 
> on mlx5.
> 
> > > I want them to just rely on devlink as a framework.  
> > 
> > And I don't :). For me devlink is a way to configure device, not manage
> > lifetime of driver specific data structures.
> 
> My mind is set here. Obviously "community" can override, so gather
> support from significant devs or it's my way... sorry to be blunt.

No problem

> 
> > > How many driver locks do you have in netdevsim after conversion?
> > > All 3? How do you add a port to the instance from sysfs without a
> > > AB / BA deadlock between the port lock and the devlink lock if the
> > > driver can't take the devlink lock? Are you still going to need the 
> > > "in_reload" wart?  
> > 
> > I don't know yet, because as you wrote before netdevsim is for
> > prototyping and such ABBA deadlock doesn't exist in real devices.
> > 
> > My current focus is real devices for now.
> 
> I wrote it with nfp in mind as well. It has a delayed work which needs
> to take the port lock. Sadly I don't have any nfps handy and I didn't
> want to post an untested patch.

Do you remember why was port configuration implemented with delayed work?

> 
> > Maybe the solution will be to go away from sysfs completely. We will see.
> 
> Sigh, I feel like I just fixed netdevsim after it has been getting bit
> rotted for a couple of years.
> 
> > > > Strange, I see completely opposite picture in the git log with so much
> > > > changes that have Fixes line and add/remove/mention rtnl_lock. Maybe it
> > > > is useful, but almost all if not all drivers full of fixes of rtnl_lock
> > > > usage. I don't want same for the devlink.  
> > > 
> > > If you don't provide a locking API to the drivers you'll have to fix 2x
> > > the bugs, and each of them subtly different. At least maintainers know
> > > what rtnl_lock rules are.  
> > 
> > I clearly remember this patch and the sentence "...in
> > some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
> > again". The word "... some ..." hints to me that maintainers have different
> > opinion on how to use rtnl_lock.
> > 
> > https://lore.kernel.org/netdev/20210809032809.1224002-1-acelan.kao@canonical.com/
> 
> Yes, using rtnl_lock for PM is certainly a bad idea, and I'm not sure
> why Intel does it. There are 10s of drivers which take rtnl_lock
> correctly and it greatly simplifies their lives.

I would say that you are ignoring that most of such drivers don't add
new functionality.

Anyway, I got your point, please give me time to see what I can do.

In case, we will adopt your model, will you convert all drivers?

Thanks
