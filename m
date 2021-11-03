Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510E0443DA6
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 08:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhKCH0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 03:26:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231985AbhKCH0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 03:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0686115B;
        Wed,  3 Nov 2021 07:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635924205;
        bh=pH42pQYK0/8Tkq2Dx+0fqkhfIZzhqW3ty+9kAXHyMSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jbFiX6rpwUOXCZefiv04eIrjfEU+8FAS5ho5gUeMcfT1SEpYEK1NkdeX2gDUHxPWP
         Vrt0MMJ706FaCigCw68NoTJkJ1soTJHhodMSQG7nraMuDxB1T8wnO3NzthTA17aT/0
         k5bMKhPYG7Vk4KXuWpSjv8nHwOeQWuaIOIQ/joakdbomKZDWLSXiIZSTmKXGKjO+zB
         p7PQBEOZC3AEaV/4Yz8J1mXZYJqzRadqOBZTEcfzS4fIwyfiWiyKX6GXbelobDAr30
         Zb6f8aU/3hayDgtH14tgwU09E1/57QAXREuwMrdeIig6P2cXpTXXPabIq3LYksQcBx
         YjxUdlRIzcmbA==
Date:   Wed, 3 Nov 2021 09:23:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@idosch.org, edwin.peer@broadcom.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <YYI46W0OtHcjB06r@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
 <YX5Efghyxu5g8kzY@unreal>
 <20211101073259.33406da3@kicinski-fedora-PC1C0HJN>
 <YYAzn+mtrGp/As74@unreal>
 <20211101141613.3373b7f4@kicinski-fedora-PC1C0HJN>
 <YYDyBxNzJSpKXosy@unreal>
 <20211102081412.6d4e2275@kicinski-fedora-PC1C0HJN>
 <YYF//p5mDQ2/reOD@unreal>
 <20211102170530.49f8ab4e@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102170530.49f8ab4e@kicinski-fedora-PC1C0HJN>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 05:05:30PM -0700, Jakub Kicinski wrote:
> On Tue, 2 Nov 2021 20:14:22 +0200 Leon Romanovsky wrote:
> > > > Thanks  
> > > 
> > > Not sure what you're thanking for. I still prefer two explicit APIs.
> > > Allowing nesting is not really necessary here. Callers know whether
> > > they hold the lock or not.  
> > 
> > I'm doubt about. It maybe easy to tell in reload flow, but it is much
> > harder inside eswitch mode change (as an example).
> 
> Hm, interesting counter example, why is eswitch mode change harder?
> From devlink side they should be locked the same, and I take the
> devlink lock on all driver callbacks (probe, remove, sriov).

I chose it as an example, because I see calls to eswitch enable/disable
in so many driver paths that I can't tell for sure which API to use and
if I need to take devlink lock or not inside the driver.

We also have other troublesome paths, like PCI recovery and health recovery
which need some sort of protection.

It can be seen as an example that bringing devlink locking complexity to
the real HW drivers won't be as good as it is for netdevsim.

> 
> > > > I need RW as a way to ensure "exclusive" access during _set_ operation.
> > > > It is not an optimization, but simple way to understand if parallel
> > > > access is possible at this specific point of time.  
> > > 
> > > How is this not an optimization to allow parallel "reads"?  
> > 
> > You need to stop everything when _set_ command is called. One way is to
> > require for all netlink devlink calls to have lock, another solution is
> > to use RW semaphore. This is why it is not optimization, but an implementation.
> > Parallel "reads" are nice bonus.
> 
> Sorry I still don't understand. Why is devlink instance lock not
> enough? Are you saying parallel get is a hard requirement for the
> rework?

Let's try to use the following example:
terminal A:                                  | terminal B:
                                             |
 while [ true ]                              | while [ true ]
   devlink sb pool show pci/0000:00:09.0     |   devlink dev eswitch set pci/0000:00:09.0 mode switchdev
                                             |   devlink dev eswitch set pci/0000:00:09.0 mode legacy

In current implementation without global devlink_mutex, it works ok,
because every devlink command takes that global mutex and only one
command runs at the same time. Plus no parallel access is allowed in
rtneltink level.

So imagine that we allow parallel access without requiring devlink->lock
for all .doit() and .dumpit() and continue rely on DEVLINK_NL_FLAG_NO_LOCK
flag. In this case, terminal A will access driver without any protection
while terminal B continues to use devlink->lock.

For this case, we need RW semaphore, terminal A will take read lock,
terminal B will take write lock.

So unless you want to require that all devlink calls will have
devlink->lock, which I think is wrong, we need RW semaphore.

> 
> > > > I don't know yet, because as you wrote before netdevsim is for
> > > > prototyping and such ABBA deadlock doesn't exist in real devices.
> > > > 
> > > > My current focus is real devices for now.  
> > > 
> > > I wrote it with nfp in mind as well. It has a delayed work which needs
> > > to take the port lock. Sadly I don't have any nfps handy and I didn't
> > > want to post an untested patch.  
> > 
> > Do you remember why was port configuration implemented with delayed work?
> 
> IIRC it was because of the FW API for link info, all ports would get
> accessed at once so we used a work which would lock out devlink port
> splitting and update state of all ports.
> 
> Link state has to be read under rtnl_lock, yet port splitting needs 
> to take rtnl_lock to register new netdevs so there was no prettier 
> way to solve this.
> 
> > > > I clearly remember this patch and the sentence "...in
> > > > some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
> > > > again". The word "... some ..." hints to me that maintainers have different
> > > > opinion on how to use rtnl_lock.
> > > > 
> > > > https://lore.kernel.org/netdev/20210809032809.1224002-1-acelan.kao@canonical.com/  
> > > 
> > > Yes, using rtnl_lock for PM is certainly a bad idea, and I'm not sure
> > > why Intel does it. There are 10s of drivers which take rtnl_lock
> > > correctly and it greatly simplifies their lives.  
> > 
> > I would say that you are ignoring that most of such drivers don't add
> > new functionality.
> 
> You lost me again. You don't disagree that ability to lock out higher
> layers is useful for drivers but... ?

I disagree, but our views are so different here that nothing good will
come out of arguing.

> 
> > Anyway, I got your point, please give me time to see what I can do.
> > 
> > In case, we will adopt your model, will you convert all drivers?
> 
> Yes, sure. The way this RFC is done it should be possible to land 
> it without any driver changes and then go driver by driver. I find
> that approach much more manageable.

I still believe that we can do everything inside devlink.c without
touching drivers at all.

Thanks
