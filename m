Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D726344201D
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 19:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhKASiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 14:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232017AbhKASix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 14:38:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A9D36052B;
        Mon,  1 Nov 2021 18:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635791779;
        bh=R1qzPsgpKZb/Xjdaeze2S85DhORZXoELOghs+Sp/nKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hL4iwaZZ2rsH7I4DKsCuYuGGy/Sq3vENk1sdx+EIqxBOwiEtWlyqhtOpWMaHrlNUO
         qC7gfvcUSGzMpV97S9cF8U4E0YYvouF7kbEgAJ/iQEspQeWXwCECiookbZcQVY8iKw
         SQrVwux80c+/+kCpVl/ykWau1hg0ZK8TUOVYSmVJE0Lwx8OgVKW6I3RXAS+mYQCAOx
         whGeO2ZXCec6RoydKmV3lVSFPM4LuxfugWj5JEbIKdWP3ylncVDKGU9Yuronz8jkzg
         ePK4RtaA8b4XwsTUynQJyMI72/CKP4XohdmPk/NSh3iOGF9YXoz+HNbb7axQAwdtKE
         E472dBxmc1xSg==
Date:   Mon, 1 Nov 2021 20:36:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@idosch.org, edwin.peer@broadcom.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <YYAzn+mtrGp/As74@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
 <YX5Efghyxu5g8kzY@unreal>
 <20211101073259.33406da3@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101073259.33406da3@kicinski-fedora-PC1C0HJN>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 07:32:59AM -0700, Jakub Kicinski wrote:
> On Sun, 31 Oct 2021 09:23:42 +0200 Leon Romanovsky wrote:
> > On Sat, Oct 30, 2021 at 04:12:49PM -0700, Jakub Kicinski wrote:
> > > This implements what I think is the right direction for devlink
> > > API overhaul. It's an early RFC/PoC because the body of code is
> > > rather large so I'd appreciate feedback early... The patches are
> > > very roughly split, the point of the posting is primarily to prove
> > > that from the driver side the conversion is an net improvement
> > > in complexity.
> > > 
> > > IMO the problems with devlink locking are caused by two things:
> > > 
> > >  (1) driver has no way to block devlink calls like it does in case
> > >      of netedev / rtnl_lock, note that for devlink each driver has
> > >      it's own lock so contention is not an issue;
> > >      
> > >  (2) sometimes devlink calls into the driver without holding its lock
> > >      - for operations which may need the driver to call devlink (port
> > >      splitting, switch config, reload etc.), the circular dependency
> > >      is there, the driver can't solve this problem.
> > > 
> > > This set "fixes" the ordering by allowing the driver to participate
> > > in locking. The lock order remains:
> > > 
> > >   device_lock -> [devlink_mutex] -> devlink instance -> rtnl_lock
> > > 
> > > but now driver can take devlink lock itself, and _ALL_ devlink ops
> > > are locked.
> > > 
> > > The expectation is that driver will take the devlink instance lock
> > > on its probe and remove paths, hence protecting all configuration
> > > paths with the devlink instance lock.
> > > 
> > > This is clearly demonstrated by the netdevsim conversion. All entry
> > > points to driver config are protected by devlink instance lock, so
> > > the driver switches to the "I'm already holding the devlink lock" API
> > > when calling devlink. All driver locks and trickery is removed.
> > > 
> > > The part which is slightly more challanging is quiescing async entry
> > > points which need to be closed on the devlink reload path (workqueue,
> > > debugfs etc.) and which also take devlink instance lock. For that we
> > > need to be able to take refs on the devlink instance and let them
> > > clean up after themselves rather than waiting synchronously.
> > > 
> > > That last part is not 100% finished in this patch set - it works but
> > > we need the driver to take devlink_mutex (the global lock) from its
> > > probe/remove path. I hope this is good enough for an RFC, the problem
> > > is easily solved by protecting the devlink XArray with something else
> > > than devlink_mutex and/or not holding devlink_mutex around each op
> > > (so that there is no ordering between the global and instance locks).
> > > Speaking of not holding devlink_mutex around each op this patch set
> > > also opens the path for parallel ops to different devlink instances
> > > which is currently impossible because all user space calls take
> > > devlink_mutex...  
> > 
> > No, please no.

<...>

> How is RW semaphore going to solve the problem that ops are unlocked
> and have to take the instance lock from within to add/remove ports?

This is three step process, but mainly it is first step. We need to make
sure that functions that can re-entry will use nested locks.

Steps:
1. Use proper locking API that supports nesting:
https://lore.kernel.org/netdev/YYABqfFy%2F%2Fg5Gdis@nanopsycho/T/#mf9dc5cac2013abe413545bbe4a09cc231ae209a4
2. Convert devlink->lock to be RW semaphore:
commit 4506dd3a90a82a0b6bde238f507907747ab88407
Author: Leon Romanovsky <leon@kernel.org>
Date:   Sun Oct 24 16:54:16 2021 +0300

    devlink: Convert devlink lock to be RW semaphore

    This is naive conversion of devlink->lock to RW semaphore, so we will be
    able to differentiate commands that require exclusive access vs. parallel
    ready-to-run ones.

    All "set" commands that used devlink->lock are converted to write lock,
    while all "get" commands are marked with read lock.

@@ -578,8 +584,12 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
                mutex_unlock(&devlink_mutex);
                return PTR_ERR(devlink);
        }
-       if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
-               mutex_lock(&devlink->lock);
+
+       if (~ops->internal_flags & DEVLINK_NL_FLAG_SHARED_ACCESS)
+               down_write(&devlink->rwsem);
+       else
+               down_read(&devlink->rwsem);
+

3. Drop devlink_mutex:
commit 3177af9971c4cd95f9633aeb9b0434687da62fd0
Author: Leon Romanovsky <leon@kernel.org>
Date:   Sun Oct 31 16:05:40 2021 +0200

    devlink: Use xarray locking mechanism instead big devlink lock

    The conversion to XArray together with devlink reference counting
    allows us reuse the following locking pattern:
     xa_lock()
      xa_for_each() {
       devlink_try_get()
       xa_unlock()
       ....
       xa_lock()
     }

    This pattern gives us a way to run any commands between xa_unlock() and
    xa_lock() without big devlink mutex, while making sure that devlink instance
    won't be released.


Steps 2 and 3 were not posted due to merge window and my desire to get
mileage in our regression.

> 
> > Please, let's not give up on standalone devlink implementation without
> > drivers need to know internal devlink details. It is hard to do but possible.
> 
> We may just disagree on this one. Please answer my question above -
> so far IDK how you're going to fix the problem of re-reg'ing subobjects
> from the reload path.
> 
> My experience writing drivers is that it was painfully unclear what 
> the devlink locking rules are. Sounds like you'd make them even more
> complicated.

How? I have only one rule:
 * Driver author should be aware that between devlink_register() and
   devlink_unregister(), users can send netlink commands.

In your solution, driver authors will need to follow whole devlink
how-to-use book.

> 
> This RFC makes the rules simple - all devlink ops are locked.
> 
> For the convenience of the drivers they can also take the instance lock
> whenever they want to prevent ops from being called. Experience with
> rtnl_lock teaches us that this is very useful for drivers.

Strange, I see completely opposite picture in the git log with so much
changes that have Fixes line and add/remove/mention rtnl_lock. Maybe it
is useful, but almost all if not all drivers full of fixes of rtnl_lock
usage. I don't want same for the devlink.

Thanks
