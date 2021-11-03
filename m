Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BBB444324
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhKCOOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230472AbhKCOOy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:14:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A186E6052B;
        Wed,  3 Nov 2021 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635948737;
        bh=V49DQ5LaEFPh9YTOPwCOLFLDFof55V0qlxfd8Xu9WtA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m3Fyx5O57eMjqjPO9Hq78WJ75o59N/h7Ym3j6pjCaG4Zb63oxMHDR0dsqpw3y/ZiI
         DrLczYKgFhS8klwFcIcvCerELkbvIcfCMZfRvTy/vOmBGYsajgsoJZ6a60Ag6wVnB6
         Fpu14m2yPJVDFeU0JKhaYWUqRsopMskLTX/SdWqsvz+PkI3/hWZByeEUhWTr89Wh7I
         T70kEyNuuaAnQzRBjxmQMTeITGsKtcgEyPT8mT2s7G3IrcKhDVtMnwHHtrM0lQgACK
         jwctoliO2ebsV0xSFri/m1lCEPeLsgDm2MCmkV2nb9UDnsU/Cylk3eLdfZ0skYxuEE
         rhG2zyOyUp1kg==
Date:   Wed, 3 Nov 2021 07:12:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     idosch@idosch.org, edwin.peer@broadcom.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <20211103071216.20704a2e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <YYI46W0OtHcjB06r@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
        <YX5Efghyxu5g8kzY@unreal>
        <20211101073259.33406da3@kicinski-fedora-PC1C0HJN>
        <YYAzn+mtrGp/As74@unreal>
        <20211101141613.3373b7f4@kicinski-fedora-PC1C0HJN>
        <YYDyBxNzJSpKXosy@unreal>
        <20211102081412.6d4e2275@kicinski-fedora-PC1C0HJN>
        <YYF//p5mDQ2/reOD@unreal>
        <20211102170530.49f8ab4e@kicinski-fedora-PC1C0HJN>
        <YYI46W0OtHcjB06r@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Nov 2021 09:23:21 +0200 Leon Romanovsky wrote:
> > > I'm doubt about. It maybe easy to tell in reload flow, but it is much
> > > harder inside eswitch mode change (as an example).  
> > 
> > Hm, interesting counter example, why is eswitch mode change harder?
> > From devlink side they should be locked the same, and I take the
> > devlink lock on all driver callbacks (probe, remove, sriov).  
> 
> I chose it as an example, because I see calls to eswitch enable/disable
> in so many driver paths that I can't tell for sure which API to use and
> if I need to take devlink lock or not inside the driver.

Really? Certainly not the case for nfp and bnxt. The two paths that
care are devlink mode setting callback (already locked), and sriov
config for spawning the right ports (I recommend all PCI callbacks 
take the devlink lock).

> We also have other troublesome paths, like PCI recovery and health recovery
> which need some sort of protection.

PCI recovery should take the devlink lock like any PCI callback.
Health callbacks are locked in my RFC.

> It can be seen as an example that bringing devlink locking complexity to
> the real HW drivers won't be as good as it is for netdevsim.

I don't see that. Again, do whatever you want for mlx5, but don't stop
others from creating shared infra.

> > > You need to stop everything when _set_ command is called. One way is to
> > > require for all netlink devlink calls to have lock, another solution is
> > > to use RW semaphore. This is why it is not optimization, but an implementation.
> > > Parallel "reads" are nice bonus.  
> > 
> > Sorry I still don't understand. Why is devlink instance lock not
> > enough? Are you saying parallel get is a hard requirement for the
> > rework?  
> 
> Let's try to use the following example:
> terminal A:                                  | terminal B:
>                                              |
>  while [ true ]                              | while [ true ]
>    devlink sb pool show pci/0000:00:09.0     |   devlink dev eswitch set pci/0000:00:09.0 mode switchdev
>                                              |   devlink dev eswitch set pci/0000:00:09.0 mode legacy
> 
> In current implementation without global devlink_mutex, it works ok,
> because every devlink command takes that global mutex and only one
> command runs at the same time. Plus no parallel access is allowed in
> rtneltink level.
> 
> So imagine that we allow parallel access without requiring devlink->lock
> for all .doit() and .dumpit() and continue rely on DEVLINK_NL_FLAG_NO_LOCK
> flag. In this case, terminal A will access driver without any protection
> while terminal B continues to use devlink->lock.
> 
> For this case, we need RW semaphore, terminal A will take read lock,
> terminal B will take write lock.
> 
> So unless you want to require that all devlink calls will have
> devlink->lock, which I think is wrong, we need RW semaphore.

Oh! I don't know how many times I said already that all callbacks should
take the instance lock.  Let me try one more time - all callbacks should
take the instance lock.

> > > I would say that you are ignoring that most of such drivers don't add
> > > new functionality.  
> > 
> > You lost me again. You don't disagree that ability to lock out higher
> > layers is useful for drivers but... ?  
> 
> I disagree, but our views are so different here that nothing good will
> come out of arguing.

You can't disagree with facts. 

If I'm counting right there are ~80 Ethernet drivers which take
rtnl_lock. Do you really think they would all do that if it was easier
to implement their own locking? Or that they are all buggy?

> > > Anyway, I got your point, please give me time to see what I can do.
> > > 
> > > In case, we will adopt your model, will you convert all drivers?  
> > 
> > Yes, sure. The way this RFC is done it should be possible to land 
> > it without any driver changes and then go driver by driver. I find
> > that approach much more manageable.  
> 
> I still believe that we can do everything inside devlink.c without
> touching drivers at all.

?? The git history says you have been touching the drivers quite a bit.
