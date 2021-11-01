Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B065C441CB2
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhKAOfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232564AbhKAOff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 10:35:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0426B60ED5;
        Mon,  1 Nov 2021 14:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635777181;
        bh=K056Zi+JlMWxWEkjDSHyn6f9NWs2DaCZjiQpH08tnZs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lUGvN8yyYK6HSQX2ZmeoaEoXnHRPvLEth55nHxXzpsndTltmuRTYuxbG3MFrphD0i
         hl0uDw/7dMfDknz6rmKybqFiS1mb0jWrDpvUVsDvgRMCsReWTQ43izDWPafQPYziL9
         9ET0GiGchaTgVke/VRpdMlnOCybfJhgGAvvm2YVxqxp2apGEp1hirrDaZ383Oc4/D0
         ZYrMVb9OCtdTx6LXS1vw/M7N2wmTr8j8d5DmyO2hmotmn2uSkJuPxaVtOjHbsD52SC
         E9iCF0sOGXBQIiZYNeh8P1wngTaEjryx9BHPXr+X2S4y0i+sjy1BKPrTCJLCkCBLx4
         e3+DWN4txJc6Q==
Date:   Mon, 1 Nov 2021 07:32:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     idosch@idosch.org, edwin.peer@broadcom.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <20211101073259.33406da3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <YX5Efghyxu5g8kzY@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
        <YX5Efghyxu5g8kzY@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Oct 2021 09:23:42 +0200 Leon Romanovsky wrote:
> On Sat, Oct 30, 2021 at 04:12:49PM -0700, Jakub Kicinski wrote:
> > This implements what I think is the right direction for devlink
> > API overhaul. It's an early RFC/PoC because the body of code is
> > rather large so I'd appreciate feedback early... The patches are
> > very roughly split, the point of the posting is primarily to prove
> > that from the driver side the conversion is an net improvement
> > in complexity.
> > 
> > IMO the problems with devlink locking are caused by two things:
> > 
> >  (1) driver has no way to block devlink calls like it does in case
> >      of netedev / rtnl_lock, note that for devlink each driver has
> >      it's own lock so contention is not an issue;
> >      
> >  (2) sometimes devlink calls into the driver without holding its lock
> >      - for operations which may need the driver to call devlink (port
> >      splitting, switch config, reload etc.), the circular dependency
> >      is there, the driver can't solve this problem.
> > 
> > This set "fixes" the ordering by allowing the driver to participate
> > in locking. The lock order remains:
> > 
> >   device_lock -> [devlink_mutex] -> devlink instance -> rtnl_lock
> > 
> > but now driver can take devlink lock itself, and _ALL_ devlink ops
> > are locked.
> > 
> > The expectation is that driver will take the devlink instance lock
> > on its probe and remove paths, hence protecting all configuration
> > paths with the devlink instance lock.
> > 
> > This is clearly demonstrated by the netdevsim conversion. All entry
> > points to driver config are protected by devlink instance lock, so
> > the driver switches to the "I'm already holding the devlink lock" API
> > when calling devlink. All driver locks and trickery is removed.
> > 
> > The part which is slightly more challanging is quiescing async entry
> > points which need to be closed on the devlink reload path (workqueue,
> > debugfs etc.) and which also take devlink instance lock. For that we
> > need to be able to take refs on the devlink instance and let them
> > clean up after themselves rather than waiting synchronously.
> > 
> > That last part is not 100% finished in this patch set - it works but
> > we need the driver to take devlink_mutex (the global lock) from its
> > probe/remove path. I hope this is good enough for an RFC, the problem
> > is easily solved by protecting the devlink XArray with something else
> > than devlink_mutex and/or not holding devlink_mutex around each op
> > (so that there is no ordering between the global and instance locks).
> > Speaking of not holding devlink_mutex around each op this patch set
> > also opens the path for parallel ops to different devlink instances
> > which is currently impossible because all user space calls take
> > devlink_mutex...  
> 
> No, please no.
> 
> This RFC goes against everything that I tried to make before.

Yup, that we agree on :) I think the reload makes your approach 
a dead end.

> It pushes complexity from the devlink core code to the drivers by
> hiding bugs in the drivers. The average driver author doesn't know
> locking well and won't be able to use devlink reference counting
> correctly. 
> 
> Already your netdevsim conversion shows that it is hard to do and for
> complex drivers it will be a nightmare to convert and maintain.

IDK, the code is very idiomatic for the kernel. Most drivers should not
have to use the ref counts, and I'll provide good enough docs to understand
how to use it.

In fact drivers which don't implement currently unlocked ops require no
changes between you API and this one.

I think "complex core, simple drivers" is the right trade off. With
this set it is now and order of magnitude easier to reason about
netdevsim's locking.

> At the end (long run), we will find ourselves with a maze of completely
> random devlink_get and devlink_lock, exactly like we have now with RTNL
> lock, which people add/delete based on their testing if to judge by the
> commit messages.
> 
> Regarding devlink_mutex, I'm on the path to removing it, this is why
> XArray and reference counting was used in the first place.

devlink_mutex is the only thing protecting the "unlocked" calls right
now, you'd be placing a lot of implicit expectations about driver's
internal locking if you do that.

> Our current complexity is due to the situation that devlink_reload doesn't
> behave like any other _set_ commands, where it supposed to take devlink->lock
> internally. 
> 
> Please give me (testing) time and I'll post a full solution that separates
> _get_ from _set_ commands by changing devlink->lock to be RW semaphore.
> Together with logic to understand that we are in devlink_reload will
> give us a solution that won't require changing drivers and won't push
> locking burden on them.

How is RW semaphore going to solve the problem that ops are unlocked
and have to take the instance lock from within to add/remove ports?

> Please, let's not give up on standalone devlink implementation without
> drivers need to know internal devlink details. It is hard to do but possible.

We may just disagree on this one. Please answer my question above -
so far IDK how you're going to fix the problem of re-reg'ing subobjects
from the reload path.

My experience writing drivers is that it was painfully unclear what 
the devlink locking rules are. Sounds like you'd make them even more
complicated.

This RFC makes the rules simple - all devlink ops are locked.

For the convenience of the drivers they can also take the instance lock
whenever they want to prevent ops from being called. Experience with
rtnl_lock teaches us that this is very useful for drivers.

Accessible lock + refs is how driver core works.

Let me sketch out the driver facing documentation here.

---->8------

Devlink locking guide
=====================

Basic locking
-------------

After calling devlink_register() and until devlink_unregister() is
called the devlink instance is "live" and any callback can be invoked.
If you want to prevent devlink from calling the driver take the
instance lock (devlink_lock()), you will need to call the locked
version of devlink API (prefixed with '__devlink') while holding the
lock.

All devlink callbacks (including health callbacks) are locked so locked
devlink API needs to be used from within them.

Note that devlink locks are per-instance (like device_lock but unlike
rtnl_lock).

Reference use
-------------

Advanced use of devlink may require taking references on the instance.
The primary use for this is to avoid deadlocks between reload/remove
paths and async works which need to take the devlink instance lock.

devlink_get() takes a reference on the instance and should only be
called when the driver is sure to already have some references.

The reference alone does _not_ prevent devlink instance from getting
unregistered so you probably want to check if devlink_is_alive() before
using that ref.

For example a use with a workqueue may look like this:

```
/* schedule work from a path which knows devlink is alive */
void sched_my_work()
{
	devlink_get(devlink);
	if (!schedule_work(priv->some_work))
		/* it was already scheduled */
		devlink_put(devlink);

}

void work_fn()
{
	devlink_lock(devlink);
	if (devlink_is_alive(devlink))
		perform_the_task();
	devlink_lock(devlink);

	/* give up our reference */
	devlink_put(devlink);
}
```

If you want to use devlink references from a context which does not take
a reference on the driver module (e.g. workqueue) - make sure to set
.owner of devlink_ops to THIS_MODULE.
