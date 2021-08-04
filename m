Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFFF3E0175
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbhHDMuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237557AbhHDMuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 08:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B429960F22;
        Wed,  4 Aug 2021 12:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628081397;
        bh=/MtdWaTlC6+C9726xHfk6+/UTeH5Ez2hZi5v7aXBaj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ap6zetdVjoLCJlz8zlALo0Sn2aZlIcnHZJMRtju4TiMI3XnfPW38pkNbkrpJQqvr+
         dj2IKz+oBUBZ+dGZBNGM0ECNVg+M6YTJaWOOWI/knKFDjpcSwWljMjgFDkFoDW1f9q
         KiXSPAncb9w7QcEOUm8gecdvd/twfrsjQSdVGeAPDGTFj3R5yJZ3lyLa++1eZWeQnI
         KADxCiHAX7CChIm32moW/zwqI2hi95abmJWkJkTfZIsHT7zIzDx4Yxf8rRaciN4xXi
         1ekoik/rjPY8JvdWOcp1x+7dKZqVgt5ddjXNpGQBMifJx/s84jW15qgd8vHSYLNdt6
         e3AOhSb8mWbUA==
Date:   Wed, 4 Aug 2021 15:49:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next] Revert "netdevsim: Add multi-queue support"
Message-ID: <YQqM8XUyHKVaj1WF@unreal>
References: <20210803123921.2374485-1-kuba@kernel.org>
 <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
 <20210803141839.79e99e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpV07aWSt5Jf-zSv6Qh4ydrJMYw54X3Seb8-eKGOpBYX7A@mail.gmail.com>
 <20210803145124.71a8aab4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQo+XJQNAP7jnGw0@unreal>
 <20210804045247.057c5e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804045247.057c5e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 04:52:47AM -0700, Jakub Kicinski wrote:
> On Wed, 4 Aug 2021 10:14:36 +0300 Leon Romanovsky wrote:
> > On Tue, Aug 03, 2021 at 02:51:24PM -0700, Jakub Kicinski wrote:
> > > On Tue, 3 Aug 2021 14:32:19 -0700 Cong Wang wrote:  
> > > > On Tue, Aug 3, 2021 at 2:18 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > 
> > <...>
> > 
> > > > Please remove all those not covered by upstream tests just to be fair??  
> > > 
> > > I'd love to remove all test harnesses upstream which are not used by
> > > upstream tests, sure :)  
> > 
> > Jakub,
> > 
> > Something related and unrelated at the same time.
> > 
> > I need to get rid of devlink_reload_enable()/_disable() to fix some
> > panics in the devlink reload flow.
> > 
> > Such change is relatively easy for the HW drivers, but not so for the
> > netdevism due to attempt to synchronize sysfs with devlink.
> > 
> >   200         mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
> >   201         devlink_reload_disable(devlink);
> >   202         ret = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
> >   203         devlink_reload_enable(devlink);
> >   204         mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
> > 
> > Are these sysfs files declared as UAPI? Or can I update upstream test
> > suite and delete them safely?
> 
> You can change netdevsim in whatever way is appropriate.
> 
> What's your plan, tho? Jiri changed the spawning from rtnetlink 
> to sysfs - may be good to consult with him before typing too much 
> code.

It is something preliminary, I have POC code which works but it is far
from the actual patches yet.

The problem is that "devlink reload" in its current form causes us
(mlx5) a lot of grief. We see deadlocks due to combinations of internal
flows with external ones, without going too much in details loops of
module removal together with health recovery and devlink reload doesn't
work properly :).

The same problem exists in all drivers that implement "devlink reload",
mlx5 just most complicated one and looks like most tested either.

My idea (for now) is pretty simple:
1. Move devlink ops callbacks from devlink_alloc phase to devlink_register().
2. Ensure that devlink_register() is the last command in the probe sequence.
3. Delete devlink_reload_enable/disable. It is not needed if proper ops used.
4. Add reference counting to struct devlink to make sure that we
properly account netlink users, so we will be able to drop big devlink_lock.
5. Convert linked list of devlink instances to be xarray. It gives us an
option to work relatively lockless.
....

Every step solves some bug, even first one solves current bug where
devlink reload statistics presented despite devlink_reload_disable().

Of course, we can try to patch devlink with specific fix for specific
bug, but better to make it error prone from the beginning.

So I'm trying to get a sense what can and what can't be done in the netdev.
And netdevsim combination of devlink and sysfs knobs adds challenges. :)

Thanks
