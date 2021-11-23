Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAF545B03D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 00:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhKWXgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 18:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231322AbhKWXgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 18:36:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D28A60FE6;
        Tue, 23 Nov 2021 23:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637710394;
        bh=kG8n/02UM0CjGGDvJB4iPJ9K02MPrvmSl94Egqf9ZVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=skemYkfAQOvf20rppso/nQxkkV8H9HKEwDnPlnSg7RXovNYceEX070AP68QuXeQXh
         TroMsQx4Yy0W6E70/bLP+A9lTLUV6B4P0dOXaGPm4YHd6mVEG4uU224vrSVRt69cAv
         T4LFsKq3gVS+q5y/9Dyx4Rl5Ld9UQ5OKWd3dv3ykbiRsHL0t/cxivq0y2F+Pve7j3c
         /AHQ6h5bAKduQdEc86h0mfsWjnJ2MS5FVFeO41QelqcU5KPcju8TObPSX4b5SIxJjD
         3CpXbRF3C4AAs+iGZW5PnfzSEtWu/lfgQgI7Tik01HbUbS+1/1ZbF9Kltnhiy59VEW
         PR1hVF3CO9Ngg==
Date:   Tue, 23 Nov 2021 15:33:12 -0800
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
Message-ID: <20211123153312.4eecb490@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZynSa6s8kBKtSYB@unreal>
References: <cover.1637173517.git.leonro@nvidia.com>
        <6176a137a4ded48501e8a06fda0e305f9cfc787c.1637173517.git.leonro@nvidia.com>
        <20211117204956.6a36963b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZYFvIK9mkP107tD@unreal>
        <20211118174813.54c3731f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZfFDSnnjOG+wSyK@unreal>
        <20211119081017.6676843b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZoHGKqLz6UBk2Sx@unreal>
        <20211122182728.370889f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZynSa6s8kBKtSYB@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 10:33:13 +0200 Leon Romanovsky wrote:
> > > You can do it with my approach too. We incremented reference counter
> > > of devlink instance when devlink_nl_cmd_port_split_doit() was called,
> > > and we can safely take devlink->port_list_lock lock before returning
> > > from pre_doit.  
> > 
> > Wait, I thought you'd hold devlink->lock around split/unsplit.  
> 
> I'm holding.
> 
>     519 static int devlink_nl_pre_doit(const struct genl_ops *ops,
>     520                                struct sk_buff *skb, struct genl_info *info)
>     521 {
>     ...
>     529
>     530         mutex_lock(&devlink->lock);

Then I'm confused why you said you need to hold a ref count on devlink.
Is it devlink_unregister() that's not taking devlink->lock?

> > Please look at the port splitting case, mlx5 doesn't implement it
> > but it's an important feature.  
> 
> I'll, but please don't forget that it was RFC, just to present that
> devlink can be changed internally without exposing internals.
> 
> > Either way, IDK how ref count on devlink helps with lifetime of a
> > subobject. You must assume the sub-objects can only be created outside
> > of the time devlink instance is visible or under devlink->lock?  
> 
> The devlink lifetime is:
> stages:        I                   II                   III   
>  devlink_alloc -> devlink_register -> devlink_unregister -> devlink_free.
> 
> All sub-objects should be created between devlink_alloc and devlink_free.
> It will ensure that ->devlink pointer is always valid.
> 
> Stage I:
>  * There is no need to hold any devlink locks or increase reference counter.
>    If driver doesn't do anything crazy during its init, nothing in devlink
>    land will run in parallel. 
> Stage II:
>  * There is a need to hold devlink->lock and/or play with reference counter
>    and/or use fine-grained locks. Users can issue "devlink ..." commands.

So sub-objects can (dis)appear only in I/III or under devlink->lock.
Why did you add the per-sub object list locks, then?
