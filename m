Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF42440D6D
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 08:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhJaH0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 03:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhJaH0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 03:26:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60EE260E9B;
        Sun, 31 Oct 2021 07:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635665026;
        bh=kM2FB1oT5avx1707uifWmZJKvUgxmRTg/hA5G7SAIjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oiV3a002ivrcplZya1EB5vFThstuKihX4nMyUNxxlpIg0BS2rgbp0aGtng6xogBJS
         JT0xx1AWcMYLgz+WoNi7sHtfmtR4OM5KBs2akCwVwRLGC8nKbTdcnvS/dvySETZ0Kf
         Vmbh35troK+H5EsPWp9srHhOd2/7g8p/hy8jd1Sx8GAjKG6G7111tEP/zZg9JZxPkU
         VRby2Y9PhcBf/akfEC8GDcfwV1HRYz9FSi5OI8VFXVxTnuWH8oko7Y7Mcal1QuQzMU
         x22rZuQ/XbtGGj2v5ZZovBAniRzGkjJRPm20Jd09zK439LxENlS4frIWgoiCw2Sgjj
         dA9IZ+Jgdnq6g==
Date:   Sun, 31 Oct 2021 09:23:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@idosch.org, edwin.peer@broadcom.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <YX5Efghyxu5g8kzY@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030231254.2477599-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 04:12:49PM -0700, Jakub Kicinski wrote:
> This implements what I think is the right direction for devlink
> API overhaul. It's an early RFC/PoC because the body of code is
> rather large so I'd appreciate feedback early... The patches are
> very roughly split, the point of the posting is primarily to prove
> that from the driver side the conversion is an net improvement
> in complexity.
> 
> IMO the problems with devlink locking are caused by two things:
> 
>  (1) driver has no way to block devlink calls like it does in case
>      of netedev / rtnl_lock, note that for devlink each driver has
>      it's own lock so contention is not an issue;
>      
>  (2) sometimes devlink calls into the driver without holding its lock
>      - for operations which may need the driver to call devlink (port
>      splitting, switch config, reload etc.), the circular dependency
>      is there, the driver can't solve this problem.
> 
> This set "fixes" the ordering by allowing the driver to participate
> in locking. The lock order remains:
> 
>   device_lock -> [devlink_mutex] -> devlink instance -> rtnl_lock
> 
> but now driver can take devlink lock itself, and _ALL_ devlink ops
> are locked.
> 
> The expectation is that driver will take the devlink instance lock
> on its probe and remove paths, hence protecting all configuration
> paths with the devlink instance lock.
> 
> This is clearly demonstrated by the netdevsim conversion. All entry
> points to driver config are protected by devlink instance lock, so
> the driver switches to the "I'm already holding the devlink lock" API
> when calling devlink. All driver locks and trickery is removed.
> 
> The part which is slightly more challanging is quiescing async entry
> points which need to be closed on the devlink reload path (workqueue,
> debugfs etc.) and which also take devlink instance lock. For that we
> need to be able to take refs on the devlink instance and let them
> clean up after themselves rather than waiting synchronously.
> 
> That last part is not 100% finished in this patch set - it works but
> we need the driver to take devlink_mutex (the global lock) from its
> probe/remove path. I hope this is good enough for an RFC, the problem
> is easily solved by protecting the devlink XArray with something else
> than devlink_mutex and/or not holding devlink_mutex around each op
> (so that there is no ordering between the global and instance locks).
> Speaking of not holding devlink_mutex around each op this patch set
> also opens the path for parallel ops to different devlink instances
> which is currently impossible because all user space calls take
> devlink_mutex...

No, please no.

This RFC goes against everything that I tried to make before.

It pushes complexity from the devlink core code to the drivers by
hiding bugs in the drivers. The average driver author doesn't know
locking well and won't be able to use devlink reference counting
correctly. 

Already your netdevsim conversion shows that it is hard to do and for
complex drivers it will be a nightmare to convert and maintain.

At the end (long run), we will find ourselves with a maze of completely
random devlink_get and devlink_lock, exactly like we have now with RTNL
lock, which people add/delete based on their testing if to judge by the
commit messages.

Regarding devlink_mutex, I'm on the path to removing it, this is why
XArray and reference counting was used in the first place.

Our current complexity is due to the situation that devlink_reload doesn't
behave like any other _set_ commands, where it supposed to take devlink->lock
internally. 

Please give me (testing) time and I'll post a full solution that separates
_get_ from _set_ commands by changing devlink->lock to be RW semaphore.
Together with logic to understand that we are in devlink_reload will
give us a solution that won't require changing drivers and won't push
locking burden on them.

Please, let's not give up on standalone devlink implementation without
drivers need to know internal devlink details. It is hard to do but possible.

Thanks

> 
> The patches are on top of the cleanups I posted earlier.
> 
> Jakub Kicinski (5):
>   devlink: add unlocked APIs
>   devlink: add API for explicit locking
>   devlink: allow locking of all ops
>   netdevsim: minor code move
>   netdevsim: use devlink locking
> 
>  drivers/net/netdevsim/bus.c       |  19 -
>  drivers/net/netdevsim/dev.c       | 450 ++++++++-------
>  drivers/net/netdevsim/fib.c       |  62 +--
>  drivers/net/netdevsim/netdevsim.h |   5 -
>  include/net/devlink.h             |  88 +++
>  net/core/devlink.c                | 875 +++++++++++++++++++++---------
>  6 files changed, 996 insertions(+), 503 deletions(-)
> 
> -- 
> 2.31.1
> 
