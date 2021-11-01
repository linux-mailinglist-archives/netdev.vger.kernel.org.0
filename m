Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4F6442274
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 22:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhKAVSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 17:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhKAVSr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 17:18:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC76C60E54;
        Mon,  1 Nov 2021 21:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635801374;
        bh=S2Fz5G4zQlodXAvHxYUhqOdzfLGDL0sqeERFTMbKS3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JLcHEvINf1PZ6aXSNaU2VRNBB0pxJenCEd9nAkAYs3nxWFgHFpuevfm8f5xCtaN+f
         vOUuzECfRbNoPTQo9PfBBsnu6L8YFC3GSoEr+/fP/8jHmI5oQkiTbsNXSZ5lyO++an
         Mdq2nwiF22AEh/XavXU9nhdfceLdp923ZHwD5FqEVBAiAB5/ZR/OV0pPmnMnDVfL05
         l4tJjZCQnPdQLQNv5ZHd8B4r7hRRMqn4yhneZrbuaF3OEdVMtTa3EdB1Mqsi66b65O
         TqNrvhrIhN01XLwq7DyJDZfsXlR1tGMXAvB/k4dAYEL6Vx/aiAmv3TIz0OWI7pBRFB
         BS3IWQRdI9gNg==
Date:   Mon, 1 Nov 2021 14:16:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     idosch@idosch.org, edwin.peer@broadcom.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <20211101141613.3373b7f4@kicinski-fedora-PC1C0HJN>
In-Reply-To: <YYAzn+mtrGp/As74@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
        <YX5Efghyxu5g8kzY@unreal>
        <20211101073259.33406da3@kicinski-fedora-PC1C0HJN>
        <YYAzn+mtrGp/As74@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Nov 2021 20:36:15 +0200 Leon Romanovsky wrote:
> > How is RW semaphore going to solve the problem that ops are unlocked
> > and have to take the instance lock from within to add/remove ports?  
> 
> This is three step process, but mainly it is first step. We need to make
> sure that functions that can re-entry will use nested locks.
> 
> Steps:
> 1. Use proper locking API that supports nesting:
> https://lore.kernel.org/netdev/YYABqfFy%2F%2Fg5Gdis@nanopsycho/T/#mf9dc5cac2013abe413545bbe4a09cc231ae209a4

Whether we provide the an unlocked API or allow lock nesting 
on the driver API is not that important to me.

> 2. Convert devlink->lock to be RW semaphore:
> commit 4506dd3a90a82a0b6bde238f507907747ab88407
> Author: Leon Romanovsky <leon@kernel.org>
> Date:   Sun Oct 24 16:54:16 2021 +0300
> 
>     devlink: Convert devlink lock to be RW semaphore
> 
>     This is naive conversion of devlink->lock to RW semaphore, so we will be
>     able to differentiate commands that require exclusive access vs. parallel
>     ready-to-run ones.
> 
>     All "set" commands that used devlink->lock are converted to write lock,
>     while all "get" commands are marked with read lock.
> 
> @@ -578,8 +584,12 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
>                 mutex_unlock(&devlink_mutex);
>                 return PTR_ERR(devlink);
>         }
> -       if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
> -               mutex_lock(&devlink->lock);
> +
> +       if (~ops->internal_flags & DEVLINK_NL_FLAG_SHARED_ACCESS)
> +               down_write(&devlink->rwsem);
> +       else
> +               down_read(&devlink->rwsem);
> +

IIUC the RW sem thing is an optimization, it's besides the point.

> 3. Drop devlink_mutex:
> commit 3177af9971c4cd95f9633aeb9b0434687da62fd0
> Author: Leon Romanovsky <leon@kernel.org>
> Date:   Sun Oct 31 16:05:40 2021 +0200
> 
>     devlink: Use xarray locking mechanism instead big devlink lock
> 
>     The conversion to XArray together with devlink reference counting
>     allows us reuse the following locking pattern:
>      xa_lock()
>       xa_for_each() {
>        devlink_try_get()
>        xa_unlock()
>        ....
>        xa_lock()
>      }
> 
>     This pattern gives us a way to run any commands between xa_unlock() and
>     xa_lock() without big devlink mutex, while making sure that devlink instance
>     won't be released.

Yup, I think this part we agree on.

> Steps 2 and 3 were not posted due to merge window and my desire to get
> mileage in our regression.

:)

> > > Please, let's not give up on standalone devlink implementation without
> > > drivers need to know internal devlink details. It is hard to do but possible.  
> > 
> > We may just disagree on this one. Please answer my question above -
> > so far IDK how you're going to fix the problem of re-reg'ing subobjects
> > from the reload path.
> > 
> > My experience writing drivers is that it was painfully unclear what 
> > the devlink locking rules are. Sounds like you'd make them even more
> > complicated.  
> 
> How? I have only one rule:
>  * Driver author should be aware that between devlink_register() and
>    devlink_unregister(), users can send netlink commands.
> 
> In your solution, driver authors will need to follow whole devlink
> how-to-use book.

Only if they need refs. If you don't the API is the same as yours.

IOW you don't provide an API for advanced use cases at all. You force
the drivers to implement their own reference counting and locking. 
I want them to just rely on devlink as a framework.

How many driver locks do you have in netdevsim after conversion?
All 3? How do you add a port to the instance from sysfs without a
AB / BA deadlock between the port lock and the devlink lock if the
driver can't take the devlink lock? Are you still going to need the 
"in_reload" wart?

> > This RFC makes the rules simple - all devlink ops are locked.
> > 
> > For the convenience of the drivers they can also take the instance lock
> > whenever they want to prevent ops from being called. Experience with
> > rtnl_lock teaches us that this is very useful for drivers.  
> 
> Strange, I see completely opposite picture in the git log with so much
> changes that have Fixes line and add/remove/mention rtnl_lock. Maybe it
> is useful, but almost all if not all drivers full of fixes of rtnl_lock
> usage. I don't want same for the devlink.

If you don't provide a locking API to the drivers you'll have to fix 2x
the bugs, and each of them subtly different. At least maintainers know
what rtnl_lock rules are.
