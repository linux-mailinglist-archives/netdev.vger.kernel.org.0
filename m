Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA8144291A
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 09:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhKBILS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 04:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhKBILR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 04:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F11560F70;
        Tue,  2 Nov 2021 08:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635840523;
        bh=pAPXvElC0JcDLoV+Ua2Li9xLpANMB96BNbqg3PWOw2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YgvRCMT7SRFacMXy+k+M8W5LRtN5MXdYzxB5rHQu+v7gRoj4Y5ThLpaYcVNJJQBQm
         Lo+h0n34gn6hrba1N4kBv+j6BMv9iebGTD++/aOaIU23mSnARZK80zm6tC3Sk4e0FD
         z66k/dcsqjQNm8rB7kBXVxcXmJ/fPEoABpN+64Y76siC3wgUduXyI7zLpX0ESIVZ3K
         CfU10G1Kw+MNSCUhTR3bsbeqpiNDUy35S0MescKQKxeuALQfAJvTzay6WIockCUAra
         w9JKLdwUt96wJLaM6iyn4TvUBrofyQ2gBBwg/LGJ7cFlER7a/xkH1hxt5b/i291Nj3
         lsjze9cpqOk7w==
Date:   Tue, 2 Nov 2021 10:08:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@idosch.org, edwin.peer@broadcom.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <YYDyBxNzJSpKXosy@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
 <YX5Efghyxu5g8kzY@unreal>
 <20211101073259.33406da3@kicinski-fedora-PC1C0HJN>
 <YYAzn+mtrGp/As74@unreal>
 <20211101141613.3373b7f4@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101141613.3373b7f4@kicinski-fedora-PC1C0HJN>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 02:16:13PM -0700, Jakub Kicinski wrote:
> On Mon, 1 Nov 2021 20:36:15 +0200 Leon Romanovsky wrote:
> > > How is RW semaphore going to solve the problem that ops are unlocked
> > > and have to take the instance lock from within to add/remove ports?  
> > 
> > This is three step process, but mainly it is first step. We need to make
> > sure that functions that can re-entry will use nested locks.
> > 
> > Steps:
> > 1. Use proper locking API that supports nesting:
> > https://lore.kernel.org/netdev/YYABqfFy%2F%2Fg5Gdis@nanopsycho/T/#mf9dc5cac2013abe413545bbe4a09cc231ae209a4
> 
> Whether we provide the an unlocked API or allow lock nesting 
> on the driver API is not that important to me.

Thanks

> 
> > 2. Convert devlink->lock to be RW semaphore:
> > commit 4506dd3a90a82a0b6bde238f507907747ab88407
> > Author: Leon Romanovsky <leon@kernel.org>
> > Date:   Sun Oct 24 16:54:16 2021 +0300
> > 
> >     devlink: Convert devlink lock to be RW semaphore
> > 
> >     This is naive conversion of devlink->lock to RW semaphore, so we will be
> >     able to differentiate commands that require exclusive access vs. parallel
> >     ready-to-run ones.
> > 
> >     All "set" commands that used devlink->lock are converted to write lock,
> >     while all "get" commands are marked with read lock.
> > 
> > @@ -578,8 +584,12 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
> >                 mutex_unlock(&devlink_mutex);
> >                 return PTR_ERR(devlink);
> >         }
> > -       if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
> > -               mutex_lock(&devlink->lock);
> > +
> > +       if (~ops->internal_flags & DEVLINK_NL_FLAG_SHARED_ACCESS)
> > +               down_write(&devlink->rwsem);
> > +       else
> > +               down_read(&devlink->rwsem);
> > +
> 
> IIUC the RW sem thing is an optimization, it's besides the point.

I need RW as a way to ensure "exclusive" access during _set_ operation.
It is not an optimization, but simple way to understand if parallel
access is possible at this specific point of time.

> 
> > 3. Drop devlink_mutex:
> > commit 3177af9971c4cd95f9633aeb9b0434687da62fd0
> > Author: Leon Romanovsky <leon@kernel.org>
> > Date:   Sun Oct 31 16:05:40 2021 +0200
> > 
> >     devlink: Use xarray locking mechanism instead big devlink lock
> > 
> >     The conversion to XArray together with devlink reference counting
> >     allows us reuse the following locking pattern:
> >      xa_lock()
> >       xa_for_each() {
> >        devlink_try_get()
> >        xa_unlock()
> >        ....
> >        xa_lock()
> >      }
> > 
> >     This pattern gives us a way to run any commands between xa_unlock() and
> >     xa_lock() without big devlink mutex, while making sure that devlink instance
> >     won't be released.
> 
> Yup, I think this part we agree on.
> 
> > Steps 2 and 3 were not posted due to merge window and my desire to get
> > mileage in our regression.
> 
> :)
> 
> > > > Please, let's not give up on standalone devlink implementation without
> > > > drivers need to know internal devlink details. It is hard to do but possible.  
> > > 
> > > We may just disagree on this one. Please answer my question above -
> > > so far IDK how you're going to fix the problem of re-reg'ing subobjects
> > > from the reload path.
> > > 
> > > My experience writing drivers is that it was painfully unclear what 
> > > the devlink locking rules are. Sounds like you'd make them even more
> > > complicated.  
> > 
> > How? I have only one rule:
> >  * Driver author should be aware that between devlink_register() and
> >    devlink_unregister(), users can send netlink commands.
> > 
> > In your solution, driver authors will need to follow whole devlink
> > how-to-use book.
> 
> Only if they need refs. If you don't the API is the same as yours.
> 
> IOW you don't provide an API for advanced use cases at all. You force
> the drivers to implement their own reference counting and locking. 

The complex drivers already do it anyway, because they need to reference
counting their own structures to make sure that the lifetime of these
structures meats their model.

> I want them to just rely on devlink as a framework.

And I don't :). For me devlink is a way to configure device, not manage
lifetime of driver specific data structures.

> 
> How many driver locks do you have in netdevsim after conversion?
> All 3? How do you add a port to the instance from sysfs without a
> AB / BA deadlock between the port lock and the devlink lock if the
> driver can't take the devlink lock? Are you still going to need the 
> "in_reload" wart?

I don't know yet, because as you wrote before netdevsim is for
prototyping and such ABBA deadlock doesn't exist in real devices.

My current focus is real devices for now.

Maybe the solution will be to go away from sysfs completely. We will see.

> 
> > > This RFC makes the rules simple - all devlink ops are locked.
> > > 
> > > For the convenience of the drivers they can also take the instance lock
> > > whenever they want to prevent ops from being called. Experience with
> > > rtnl_lock teaches us that this is very useful for drivers.  
> > 
> > Strange, I see completely opposite picture in the git log with so much
> > changes that have Fixes line and add/remove/mention rtnl_lock. Maybe it
> > is useful, but almost all if not all drivers full of fixes of rtnl_lock
> > usage. I don't want same for the devlink.
> 
> If you don't provide a locking API to the drivers you'll have to fix 2x
> the bugs, and each of them subtly different. At least maintainers know
> what rtnl_lock rules are.

I clearly remember this patch and the sentence "...in
some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
again". The word "... some ..." hints to me that maintainers have different
opinion on how to use rtnl_lock.

https://lore.kernel.org/netdev/20210809032809.1224002-1-acelan.kao@canonical.com/

Thanks
