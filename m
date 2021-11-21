Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2A445828D
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 09:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbhKUIsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 03:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhKUIsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 03:48:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E01C60555;
        Sun, 21 Nov 2021 08:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637484316;
        bh=oIzTeQ8dWAqf5/wiroWk46ZDKNRp9gwSpRMBo2v6U34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LMvUbGy4dpaXt/9MkfEvTpXXzKfVEU7u1KfV0iD7HtBVSRJq1rdnPkgxj3e9DzDI+
         1yjjzFlTUaQnALRouTEiWI2jCkp0rcEIpzL4Qu+0wpntZAqZ/8lTP+BAu+ZpiWesqb
         6Qw/Q4VD1Vt8xFrkWehtozTxZAsYb/4OXr7gZZM+zY+FBYudZuYdtkit4xEG+RNxnL
         sIQMQyFuzItDxRm4iNyXPBusEgniI6M+yH+AB2eES5GS0E2NiVEKjWadDwD34o7aZc
         gycj1JeqS8h1/vPbc1+VpjNqcka6gZ0jNy+998KYW5lYW7AuJQkU3mKl0L+Z1tAiIQ
         Y36AogvhKIMIA==
Date:   Sun, 21 Nov 2021 10:45:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Aya Levin <ayal@mellanox.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, drivers@pensando.io,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 5/6] devlink: Reshuffle resource registration
 logic
Message-ID: <YZoHGKqLz6UBk2Sx@unreal>
References: <cover.1637173517.git.leonro@nvidia.com>
 <6176a137a4ded48501e8a06fda0e305f9cfc787c.1637173517.git.leonro@nvidia.com>
 <20211117204956.6a36963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZYFvIK9mkP107tD@unreal>
 <20211118174813.54c3731f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZfFDSnnjOG+wSyK@unreal>
 <20211119081017.6676843b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119081017.6676843b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 08:10:17AM -0800, Jakub Kicinski wrote:
> On Fri, 19 Nov 2021 17:38:53 +0200 Leon Romanovsky wrote:
> > On Thu, Nov 18, 2021 at 05:48:13PM -0800, Jakub Kicinski wrote:
> > > On Thu, 18 Nov 2021 09:50:20 +0200 Leon Romanovsky wrote:  
> > > > And it shouldn't. devlink_resource_find() will return valid resource only
> > > > if there driver is completely bogus with races or incorrect allocations of
> > > > resource_id.
> > > > 
> > > > devlink_*_register(..)
> > > >  mutex_lock(&devlink->lock);
> > > >  if (devlink_*_find(...)) {
> > > >     mutex_unlock(&devlink->lock);
> > > >     return ....;
> > > >  }
> > > >  .....
> > > > 
> > > > It is almost always wrong from locking and layering perspective the pattern above,
> > > > as it is racy by definition if not protected by top layer.
> > > > 
> > > > There are exceptions from the rule above, but devlink is clearly not the
> > > > one of such exceptions.  
> > > 
> > > Just drop the unnecessary "cleanup" patches and limit the amount 
> > > of driver code we'll have to revert if your approach fails.  
> > 
> > My approach works, exactly like it works in other subsystems.
> > https://lore.kernel.org/netdev/cover.1636390483.git.leonro@nvidia.com/
> 
> What "other subsystems"? I'm aware of the RFC version of these patches.

Approach to have fine-grained locking scheme, instead of having one big lock.
This was done in MM for mmap_sem, we did it for RDMA too.

> 
> Breaking up the locks to to protect sub-objects only is fine for
> protecting internal lists but now you can't guarantee that the object
> exists when driver is called.

I can only guess about which objects you are talking.

If you are talking about various devlink sub-objects (ports, traps,
e.t.c), they created by the drivers and as such should be managed by them.
Also they are connected to devlink which is guaranteed to exist. At the end,
they called to devlink_XXX->devlink pointer without any existence check.

If you are talking about devlink instance itself, we guarantee that it
exists between devlink_alloc() and devlink_free(). It seems to me pretty
reasonable request from drivers do not access devlink before devlink_alloc()
or after devlink_free(),

> 
> I'm sure you'll utter your unprovable "in real drivers.." but the fact
> is my approach does not suffer from any such issues. Or depends on
> drivers registering devlink last.

Registration of devlink doesn't do anything except opening it to the world.
The lifetime is controlled with alloc and free. My beloved sentence "in
real drivers ..." belongs to use of devlink_put and devlink_locks outside
of devlink.c and nothing more.

> 
> I can start passing a pointer to a devlink_port to split/unsplit
> functions, which is a great improvement to the devlink driver API.

You can do it with my approach too. We incremented reference counter
of devlink instance when devlink_nl_cmd_port_split_doit() was called,
and we can safely take devlink->port_list_lock lock before returning
from pre_doit.

> 
> > We are waiting to see your proposal extended to support parallel devlink
> > execution and to be applied to real drivers.
> > https://lore.kernel.org/netdev/20211030231254.2477599-1-kuba@kernel.org/
> 
> The conversion to xarray you have done is a great improvement, I don't
> disagree with the way you convert to allow parallel calls either.
> 
> I already told you that real drivers can be converted rather easily,
> even if it's not really necessary.
> 
> But I'm giving you time to make your proposal. If I spend time
> polishing my patches I'll be even more eager to put this behind me.

I see exposure of devlink internals to the driver as last resort, so I
stopped to make proposals after your responses:

"I prefer my version."
https://lore.kernel.org/netdev/20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

"If by "fixed first" you mean it needs 5 locks to be added and to remove
any guarantees on sub-object lifetime then no thanks."
https://lore.kernel.org/netdev/20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

> 
> > Anyway, you are maintainer, you want half work, you will get half work.
> 
> What do you mean half work? You have a record of breaking things 
> in the area and changing directions. How is my request to limit
> unnecessary "cleanups" affecting drivers until the work is finished
> not perfectly reasonable?!?!

I don't know what made you think so. My end goals (parallel execution
and safe devlink reload) and solutions didn't changes:
 * Devlink instance is safe to access by kernel between devlink_alloc() and devlink_free().
 * Devlink instance is visible for users between devlink_register() and devlink_unregister().
 * Locks should be fine-grained and limited.

By saying, half work, I mean that attempt to limit locks leave many
functions to be such that can't fail and as such should be void and not
"return 0".

And regarding "breaking things", I'm not doing it for fun, but with real
desire to improve kernel for everyone, not only for our driver.

> 
> > > I spent enough time going back and forth with you.
> > 
> > Disagreements are hard for everyone, not only for you.
