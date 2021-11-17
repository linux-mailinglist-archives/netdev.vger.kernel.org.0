Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA1A454855
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbhKQOTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238317AbhKQOSw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:18:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 054B661C32;
        Wed, 17 Nov 2021 14:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637158553;
        bh=+YcxgfAxpSpcXphCgxZ2hrgTnryrbL5HVs80NMAeIPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ceo4ThdByhG5ayiWDYHj5r+x+1jOsiWDBouhk3KLwPaDBaYjT9y2GEaTGFesUe/8f
         GSi98Tr1Z0GGh/ULjZyupwWO27J/K62JtIiHSlyceDDjPQg6nnXjeIvf8k67AqI8a8
         kZ57yCiznQwmFBZ4i8XL6W9iwe/y+D+LqvCSZEGamn0GvrrWRaBtJT5tCqFqFvhDp1
         pg48ADNLQcTQcpGDwG5wyqfaltIlnVPP80rXMhSE+qLBw+s8oTtvJBprSB8U/TjaG/
         qI3TQ5tJpzVu9gtRTi31MG2fkev4nBogm88VpPge3eEMLxJ0hXxPrt3DF82LbhH0kQ
         uvdxi99JtsmhA==
Date:   Wed, 17 Nov 2021 16:15:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YZUOlQnQ0NVxRaO/@unreal>
References: <YY0G90fJpu/OtF8L@nanopsycho>
 <YY0J8IOLQBBhok2M@unreal>
 <YY4aEFkVuqR+vauw@nanopsycho>
 <YZCqVig9GQi/o1iz@unreal>
 <YZJCdSy+wzqlwrE2@nanopsycho>
 <20211115125359.GM2105516@nvidia.com>
 <YZJx8raQt+FkKaeY@nanopsycho>
 <20211115150931.GA2386342@nvidia.com>
 <YZNWRXzzRYMNhUEO@nanopsycho>
 <20211116124442.GX2105516@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116124442.GX2105516@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 08:44:42AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 16, 2021 at 07:57:09AM +0100, Jiri Pirko wrote:
> 
> > >There is only one place in the entire kernel calling the per-ns
> > >register_netdevice_notifier_dev_net() and it is burred inside another
> > >part of mlx5 for some reason..
> > 
> > Yep. I added it there to solve this deadlock.
> 
> I wonder how it can work safely inside a driver, since when are
> drivers NS aware?
> 
>         uplink_priv->bond->nb.notifier_call = mlx5e_rep_esw_bond_netevent;
>         ret = register_netdevice_notifier_dev_net(netdev,
>                                                   &uplink_priv->bond->nb,
>                                                   &uplink_priv->bond->nn);
> 
> Doesn't that just loose events when the user moves netdev to another
> namespace?

I don't think so, it looks like holding rtnl_lock is enough.
However, we need all events and not NS-specific ones and it maybe solves
the deadlock, but doesn't solve our issue.

BTW, this makes me wonder how commit 554873e51711 ("net: Do not take net_rwsem in __rtnl_link_unregister()")
aligns with the comment near pernet_ops_rwsem and explode usage in other
places.

    57 /*
    58  * pernet_ops_rwsem: protects: pernet_list, net_generic_ids,
    59  * init_net_initialized and first_device pointer.
    60  * This is internal net namespace object. Please, don't use it
    61  * outside.
    62  */

Thanks
