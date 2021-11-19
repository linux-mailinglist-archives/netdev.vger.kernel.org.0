Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCE9457270
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbhKSQNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:13:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236201AbhKSQNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 11:13:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C882F61B1B;
        Fri, 19 Nov 2021 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637338220;
        bh=cG3wQEplh35ow0AJ/zjgDPh/OW/YWgrK5UulYqGDxjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QUzBGA8kmIZtcrQJdOESL4mgFezTBQBPZ6IJx94GDM8Ef7cYTtYicM66ZX5CwB0hx
         hA7DYnF4aiHKQN36IrOX5FgjRiwxDfgkbE3k4wUdt11b4arRylJqWuD807VFUPW1l0
         JvIs0+qmP+m53U0tTF1kVVogBHKOQZEL2GXW6FtRK9bL8uPx/IBh9SDPCrihQ+kdya
         Zde82zythWLeWnYmxBwh8D/SCXg8y1hqI0uJWl1IbYa2+cnZ/yJ48ODdcpt/8V3oP3
         LrO7YvEvAV+mSHDCz5egdvctVjH9uueybHVHdwgcZsJ55gEnmnbLJGVH6mFl2pF0Yv
         qeTxPJmaxMR9Q==
Date:   Fri, 19 Nov 2021 08:10:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Message-ID: <20211119081017.6676843b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZfFDSnnjOG+wSyK@unreal>
References: <cover.1637173517.git.leonro@nvidia.com>
        <6176a137a4ded48501e8a06fda0e305f9cfc787c.1637173517.git.leonro@nvidia.com>
        <20211117204956.6a36963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZYFvIK9mkP107tD@unreal>
        <20211118174813.54c3731f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZfFDSnnjOG+wSyK@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 17:38:53 +0200 Leon Romanovsky wrote:
> On Thu, Nov 18, 2021 at 05:48:13PM -0800, Jakub Kicinski wrote:
> > On Thu, 18 Nov 2021 09:50:20 +0200 Leon Romanovsky wrote:  
> > > And it shouldn't. devlink_resource_find() will return valid resource only
> > > if there driver is completely bogus with races or incorrect allocations of
> > > resource_id.
> > > 
> > > devlink_*_register(..)
> > >  mutex_lock(&devlink->lock);
> > >  if (devlink_*_find(...)) {
> > >     mutex_unlock(&devlink->lock);
> > >     return ....;
> > >  }
> > >  .....
> > > 
> > > It is almost always wrong from locking and layering perspective the pattern above,
> > > as it is racy by definition if not protected by top layer.
> > > 
> > > There are exceptions from the rule above, but devlink is clearly not the
> > > one of such exceptions.  
> > 
> > Just drop the unnecessary "cleanup" patches and limit the amount 
> > of driver code we'll have to revert if your approach fails.  
> 
> My approach works, exactly like it works in other subsystems.
> https://lore.kernel.org/netdev/cover.1636390483.git.leonro@nvidia.com/

What "other subsystems"? I'm aware of the RFC version of these patches.

Breaking up the locks to to protect sub-objects only is fine for
protecting internal lists but now you can't guarantee that the object
exists when driver is called.

I'm sure you'll utter your unprovable "in real drivers.." but the fact
is my approach does not suffer from any such issues. Or depends on
drivers registering devlink last.

I can start passing a pointer to a devlink_port to split/unsplit
functions, which is a great improvement to the devlink driver API.

> We are waiting to see your proposal extended to support parallel devlink
> execution and to be applied to real drivers.
> https://lore.kernel.org/netdev/20211030231254.2477599-1-kuba@kernel.org/

The conversion to xarray you have done is a great improvement, I don't
disagree with the way you convert to allow parallel calls either.

I already told you that real drivers can be converted rather easily,
even if it's not really necessary.

But I'm giving you time to make your proposal. If I spend time
polishing my patches I'll be even more eager to put this behind me.

> Anyway, you are maintainer, you want half work, you will get half work.

What do you mean half work? You have a record of breaking things 
in the area and changing directions. How is my request to limit
unnecessary "cleanups" affecting drivers until the work is finished
not perfectly reasonable?!?!

> > I spent enough time going back and forth with you.
> 
> Disagreements are hard for everyone, not only for you.
