Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A715423533
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 02:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbhJFAle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 20:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhJFAld (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 20:41:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E2D4611C6;
        Wed,  6 Oct 2021 00:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633480782;
        bh=C6gtW2eVxdP/K4+if+e8DTNKwlCQukYovjuQgN4nAcA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nUCd42BbtvAMD41FGwr8FdLKQUNG4WR3oLvN7W6o0wxbfblCSw87bY/0odfnchFS1
         mIlD6wUzxBDjn5UtdIaakZlD8OW8pwkyANSpeVE9t+K8lH0wXwaYoR2ijHnNyQ+wu9
         lpdIWvXd16C4X7dPngfq47PWiFf52lJ8dRp1+/ws3Nu508JsHZnYlm1sjEMYWj+dQG
         MYaMmbRex+aUeOAsUDYvUA3pLiy7cNrN7zpMESikWYnQjYO3wwRTH6qItR88aI60wN
         vxqJuHgTpbBRHCa3HhjsOhfzCW+HQIEQg8pGvCtlkXzUjCrAZx2Eub9FiOq/Ke98fS
         zPkg40b0q6Wgg==
Date:   Tue, 5 Oct 2021 17:39:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Message-ID: <20211005173940.35bc7bfa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVykXLY7mX4K1ScW@unreal>
References: <cover.1633284302.git.leonro@nvidia.com>
        <92971648bcad41d095d12f5296246fc44ab8f5c7.1633284302.git.leonro@nvidia.com>
        <20211004164413.60e9ce80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVv/nUe63nO8o8wz@unreal>
        <20211005113213.0ee61358@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVykXLY7mX4K1ScW@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 22:15:40 +0300 Leon Romanovsky wrote:
> On Tue, Oct 05, 2021 at 11:32:13AM -0700, Jakub Kicinski wrote:
> > On Tue, 5 Oct 2021 10:32:45 +0300 Leon Romanovsky wrote:  
> > > It is impossible, devlink_register() is part of .probe() flow and if it
> > > wasn't called -> probe didn't success -> net_device doesn't exist.  
> > 
> > Are you talking about reality or the bright future brought by auxbus?  
> 
> I looked on all the drivers which called to devlink_alloc() which is
> starting point before devlink_register(). All of them used it in the
> probe. My annotation patch checks that too.
> 
> https://lore.kernel.org/linux-rdma/f65772d429d2c259bbc18cf5b1bbe61e39eb7081.1633284302.git.leonro@nvidia.com/T/#u
> 
> So IMHO, it is reality.

You say that yet below you admit flashing is broken :/

> > > We are not having net_device without "connected" device beneath, aren't we?
> > > 
> > > At least drivers that I checked are not prepared at all to handle call
> > > to devlink->ops.flash_update() if they didn't probe successfully.  
> > 
> > Last time I checked you moved the devlink_register() at the end of
> > probe which for all no-auxbus drivers means after register_netdev().  
> 
> I need to add a check of if(devlink_register) inside devlink_compat_flash_update().

... and the workarounds start to pile up.

> > I don't like it. If you're feeling strongly please gather support of
> > other developers. Right now it's my preference against yours. I don't
> > even see you making arguments that your approach is better, just that
> > mine is not perfect and requires some similar changes.  
> 
> I have an idea of how to keep static ops and allow devlink_set_ops()
> like functionality.
> 
> What about if I group ops by some sort of commonalities?
> 
> In my case, it will be devlink_reload_ops, which will include reload
> relevant callbacks and provide devlink_set_reload_ops() wrapper to set
> them?
> 
> It will ensure that all pointers are const without need to have feature
> bits.

I don't understand why you keep pushing the op reassignment.
