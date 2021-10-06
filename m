Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA50423657
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbhJFDjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230363AbhJFDjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 23:39:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69DE761029;
        Wed,  6 Oct 2021 03:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633491468;
        bh=fTJvpgjSLz51U88Tq9z0xogY4BNYHCRrb0Lb3KcXGeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lj7jul45VtWr3mfTLqNNKm6rz/FWRAEo3Fx3+eR95ugvY+PF1yz7omX9BXFYa8WTI
         cefQaXWSolBdM29Gnr5ezpPI+8goqVhlBLlfqHD2p1dvZulb8TB7/4JUzaNt8w+Mnn
         D21AF5dQwRQ2WbaZNvfmqlv/hYrl108YbAihlbDMMlg7x+07N7EtWETUrUYBdkDvp4
         KzEZ9ybmdssNehD229Ey/H3+CS3S2QaXzpGscDjp0IXj1LXDdSIw7NyrIQWMgEyZpm
         1GJGMisx5HHmhLz79VxP5uc/S0EDhrFz29oRiUvzUY5Q5Jtyu5qrLLtMIf8yHMIlru
         BsErxxOD+UHtg==
Date:   Wed, 6 Oct 2021 06:37:44 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v2 3/5] devlink: Allow set specific ops
 callbacks dynamically
Message-ID: <YV0aCADY4WkLySv4@unreal>
References: <cover.1633284302.git.leonro@nvidia.com>
 <92971648bcad41d095d12f5296246fc44ab8f5c7.1633284302.git.leonro@nvidia.com>
 <20211004164413.60e9ce80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVv/nUe63nO8o8wz@unreal>
 <20211005113213.0ee61358@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVykXLY7mX4K1ScW@unreal>
 <20211005173940.35bc7bfa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005173940.35bc7bfa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 05:39:40PM -0700, Jakub Kicinski wrote:
> On Tue, 5 Oct 2021 22:15:40 +0300 Leon Romanovsky wrote:
> > On Tue, Oct 05, 2021 at 11:32:13AM -0700, Jakub Kicinski wrote:
> > > On Tue, 5 Oct 2021 10:32:45 +0300 Leon Romanovsky wrote:  
> > > > It is impossible, devlink_register() is part of .probe() flow and if it
> > > > wasn't called -> probe didn't success -> net_device doesn't exist.  
> > > 
> > > Are you talking about reality or the bright future brought by auxbus?  
> > 
> > I looked on all the drivers which called to devlink_alloc() which is
> > starting point before devlink_register(). All of them used it in the
> > probe. My annotation patch checks that too.
> > 
> > https://lore.kernel.org/linux-rdma/f65772d429d2c259bbc18cf5b1bbe61e39eb7081.1633284302.git.leonro@nvidia.com/T/#u
> > 
> > So IMHO, it is reality.
> 
> You say that yet below you admit flashing is broken :/

I said more than once, lifetime of devlink is broken. It is placed in
wrong layer, pretend to implement some of driver core functionality
without proper protections and have wrong locks.

At least, I didn't break flash update, there is no change in logic of
flash after any of my changes. Exactly like before, user was able to trigger
flash update through this devlink_compat_flash_update() call without any
protection.

Let's chose random kernel version (v5.11)
https://elixir.bootlin.com/linux/v5.11/source/net/core/devlink.c#L10245
as you can see, it doesn't hold ANY driver core locks, so it can be
called in any time during driver .probe() or .remove(). Drivers that
have implemented ops.flash_update() have no idea about that.

> 
> > > > We are not having net_device without "connected" device beneath, aren't we?
> > > > 
> > > > At least drivers that I checked are not prepared at all to handle call
> > > > to devlink->ops.flash_update() if they didn't probe successfully.  
> > > 
> > > Last time I checked you moved the devlink_register() at the end of
> > > probe which for all no-auxbus drivers means after register_netdev().  
> > 
> > I need to add a check of if(devlink_register) inside devlink_compat_flash_update().
> 
> ... and the workarounds start to pile up.

It is not a workaround, but attempt to fix this mess.

I separated devlink netlink callers from the kernel flow and just need
to continue to fix these external to devlink callers.

> 
> > > I don't like it. If you're feeling strongly please gather support of
> > > other developers. Right now it's my preference against yours. I don't
> > > even see you making arguments that your approach is better, just that
> > > mine is not perfect and requires some similar changes.  
> > 
> > I have an idea of how to keep static ops and allow devlink_set_ops()
> > like functionality.
> > 
> > What about if I group ops by some sort of commonalities?
> > 
> > In my case, it will be devlink_reload_ops, which will include reload
> > relevant callbacks and provide devlink_set_reload_ops() wrapper to set
> > them?
> > 
> > It will ensure that all pointers are const without need to have feature
> > bits.
> 
> I don't understand why you keep pushing the op reassignment.

It is not reassignment, but ability to assign proper callbacks from the
beginning.

The idea is to make sure that lifetime of devlink is managed by proper
ops callbacks, based on them we can control everything inside devlink
by ensuring right locks, order e.t.c.

I want to get rid from random *_enabled flags that always forgotten and
adds complexity that don't give any advantage only issues.

I'm also changing devlink to allow parallel execution and for that I
need to have reliable devlink instance with minimal number of locks.

Thanks
