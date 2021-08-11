Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815643E929D
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhHKN16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229737AbhHKN15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 09:27:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5796C60724;
        Wed, 11 Aug 2021 13:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628688453;
        bh=wfODlyF6YpLmvCjDJOze2CKJ+6gyBk0IVgKttd9SLRQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G6WyNkjE85f2JwoCOY7THXFO87uxHdXqUGyp1kplBnI5CKQuSegBxRlXHp6Pza7qW
         irrlWs1KbTATqCTFYmz5YAeHPPZIPQaUtp5Girl3l0pkJcva3GdxLZ609sfL9t1z8o
         7sQ/Q7KXT2gAbKCJEpqls+8+yC9D339mAzWvUqu4LdLd67skyUePjjJAjLYPOnERpE
         7Ai52Ckm6t7MglYmW2OCnSpH5h2Wy53pPmn4ccEYcLM+chnf+euJbp1Heb9WdQO+wl
         IfR7pyAHEcdpkmA450XvAyrPvbukGF3k1xwKW0KBmrQ2Q6LCFXo1TXxD4UmNexBL80
         0weK5vxuntE4Q==
Date:   Wed, 11 Aug 2021 06:27:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 0/5] Move devlink_register to be near
 devlink_reload_enable
Message-ID: <20210811062732.0f569b9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRNp6Zmh99N3kJVa@unreal>
References: <cover.1628599239.git.leonro@nvidia.com>
        <20210810165318.323eae24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRNp6Zmh99N3kJVa@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 09:10:49 +0300 Leon Romanovsky wrote:
> On Tue, Aug 10, 2021 at 04:53:18PM -0700, Jakub Kicinski wrote:
> > On Tue, 10 Aug 2021 16:37:30 +0300 Leon Romanovsky wrote:  
> > > This series prepares code to remove devlink_reload_enable/_disable API
> > > and in order to do, we move all devlink_register() calls to be right
> > > before devlink_reload_enable().
> > > 
> > > The best place for such a call should be right before exiting from
> > > the probe().
> > > 
> > > This is done because devlink_register() opens devlink netlink to the
> > > users and gives them a venue to issue commands before initialization
> > > is finished.
> > > 
> > > 1. Some drivers were aware of such "functionality" and tried to protect
> > > themselves with extra locks, state machines and devlink_reload_enable().
> > > Let's assume that it worked for them, but I'm personally skeptical about
> > > it.
> > > 
> > > 2. Some drivers copied that pattern, but without locks and state
> > > machines. That protected them from reload flows, but not from any _set_
> > > routines.
> > > 
> > > 3. And all other drivers simply didn't understand the implications of early
> > > devlink_register() and can be seen as "broken".  
> > 
> > What are those implications for drivers which don't implement reload?
> > Depending on which parts of devlink the drivers implement there may well
> > be nothing to worry about.
> > 
> > Plus devlink instances start out with reload disabled. Could you please
> > take a step back and explain why these changes are needed.  
> 
> The problem is that devlink_register() adds new devlink instance to the
> list of visible devlinks (devlink_list). It means that all devlink_*_dumpit()
> will try to access devices during their initialization, before they are ready.
> 
> The more troublesome case is that devlink_list is iterated in the
> devlink_get_from_attrs() and it is used in devlink_nl_pre_doit(). The
> latter function will return to the caller that new devlink is valid and
> such caller will be able to proceed to *_set_doit() functions.
> 
> Just as an example:
>  * user sends netlink message
>   * devlink_nl_cmd_eswitch_set_doit()
>    * ops->eswitch_mode_set()
>     * Are you sure that all drivers protected here?
>       I remind that driver is in the middle of its probe().
> 
> Someone can argue that drivers and devlink are protected from anything
> harmful with their global (devlink_mutex and devlink->lock) and internal
> (device->lock, e.t.c.) locks. However it is impossible to prove for all
> drivers and prone to errors.
> 
> Reload enable/disable gives false impression that the problem exists in
> that flow only, which is not true.
> 
> devlink_reload_enable() is a duct tape because reload flows much easier
> to hit.

Right :/

> > > In this series, we focus on items #1 and #2.
> > > 
> > > Please share your opinion if I should change ALL other drivers to make
> > > sure that devlink_register() is the last command or leave them in an
> > > as-is state.  
> > 
> > Can you please share the output of devlink monitor and ip monitor link
> > before and after?  The modified drivers will not register ports before
> > they register the devlink instance itself.  
> 
> Not really, they will register but won't be accessible from the user space.
> The only difference is the location of "[dev,new] ..." notification.

Is that because of mlx5's use of auxdev, or locking? I don't see
anything that should prevent the port notification from coming out.

I think the notifications need to get straightened out, we can't notify
about sub-objects until the object is registered, since they are
inaccessible.
