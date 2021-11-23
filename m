Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55814459A16
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 03:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhKWCai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 21:30:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhKWCah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 21:30:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9AEA60FD7;
        Tue, 23 Nov 2021 02:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637634450;
        bh=pVAUlBxMspmGig7ibnf9L4M8onsP9ZIoqi1m/vBIerI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pbo+njgtbDj4dogQt5o1N0PAsSo37zFuxzUuIifRSrVeUGFkJTMeO9/9GiMCaZL0/
         QYKC2jOjQAZPcSen6/iDuWNf/iw+OAdGlARBHcVb54Hi1EEbJNRaVfNaAy+QLSz8Bc
         jVKTLQsi2vXpr/rYYFUbPqfhZqzlcJ9ZMuiw18wAF3GdJ0ivhzgmqb3IfoUA6LLfwf
         utUtccTCVpTkaa0H7Ftj8xBubLvR9pYMoBF7DedPXF0BnT2fNF7VWNOOj0aaCsw98W
         917cKGW7zx+XoW9fQA2nZL2C3sOdV459ykU1Qt+BdBDwCa46m5mWlT44ZxWQf/tnG3
         j8FtI3IDPrzlQ==
Date:   Mon, 22 Nov 2021 18:27:28 -0800
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
Message-ID: <20211122182728.370889f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZoHGKqLz6UBk2Sx@unreal>
References: <cover.1637173517.git.leonro@nvidia.com>
        <6176a137a4ded48501e8a06fda0e305f9cfc787c.1637173517.git.leonro@nvidia.com>
        <20211117204956.6a36963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZYFvIK9mkP107tD@unreal>
        <20211118174813.54c3731f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZfFDSnnjOG+wSyK@unreal>
        <20211119081017.6676843b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZoHGKqLz6UBk2Sx@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 21 Nov 2021 10:45:12 +0200 Leon Romanovsky wrote:
> On Fri, Nov 19, 2021 at 08:10:17AM -0800, Jakub Kicinski wrote:
> > On Fri, 19 Nov 2021 17:38:53 +0200 Leon Romanovsky wrote:  
> > > My approach works, exactly like it works in other subsystems.
> > > https://lore.kernel.org/netdev/cover.1636390483.git.leonro@nvidia.com/  
> > 
> > What "other subsystems"? I'm aware of the RFC version of these patches.  
> 
> Approach to have fine-grained locking scheme, instead of having one big lock.
> This was done in MM for mmap_sem, we did it for RDMA too.

You're breaking things up to avoid lock ordering issues. The user can
still only run a single write command at a time.

> > Breaking up the locks to to protect sub-objects only is fine for
> > protecting internal lists but now you can't guarantee that the object
> > exists when driver is called.  
> 
> I can only guess about which objects you are talking.

It obviously refers to the port splitting I mentioned below.

> If you are talking about various devlink sub-objects (ports, traps,
> e.t.c), they created by the drivers and as such should be managed by them.
> Also they are connected to devlink which is guaranteed to exist. At the end,
> they called to devlink_XXX->devlink pointer without any existence check.
> 
> If you are talking about devlink instance itself, we guarantee that it
> exists between devlink_alloc() and devlink_free(). It seems to me pretty
> reasonable request from drivers do not access devlink before devlink_alloc()
> or after devlink_free(),
> 
> > I'm sure you'll utter your unprovable "in real drivers.." but the fact
> > is my approach does not suffer from any such issues. Or depends on
> > drivers registering devlink last.  
> 
> Registration of devlink doesn't do anything except opening it to the world.
> The lifetime is controlled with alloc and free. My beloved sentence "in
> real drivers ..." belongs to use of devlink_put and devlink_locks outside
> of devlink.c and nothing more.

As soon as there is a inter-dependency between two subsystems "must 
be last" breaks down.

> > I can start passing a pointer to a devlink_port to split/unsplit
> > functions, which is a great improvement to the devlink driver API.  
> 
> You can do it with my approach too. We incremented reference counter
> of devlink instance when devlink_nl_cmd_port_split_doit() was called,
> and we can safely take devlink->port_list_lock lock before returning
> from pre_doit.

Wait, I thought you'd hold devlink->lock around split/unsplit.

Please look at the port splitting case, mlx5 doesn't implement it
but it's an important feature.

Either way, IDK how ref count on devlink helps with lifetime of a
subobject. You must assume the sub-objects can only be created outside
of the time devlink instance is visible or under devlink->lock?
