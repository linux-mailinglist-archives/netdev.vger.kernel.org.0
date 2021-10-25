Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027B443944D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 12:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhJYK6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232090AbhJYK6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 06:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A68B660F46;
        Mon, 25 Oct 2021 10:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635159381;
        bh=7j8ynqn/OK6718s9WxLto/Xdf9z2pakrrTtvt+j7xhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VdFWBz5UALHdb++MOrmOPw/Omjz7jBCyDwttDm5mHNLX92Z6X0cxLGJVwzoyQpyFd
         xtL0x2hX7Xow/1sZ3UW737AecMYlEdvWE1J0Umuf/4hOW3aH/0+W3RklDJvTVC3qIv
         1cL2f2T47ub3Tc1i4d+2TmdyjfDEyqf3O2j8goeu8OC3NnZDSCQwOGEVSm4UmEBvQQ
         N53BwVW/jjz+aJVOlif2ZJHmnhP0HV4a9idKt9MRRSICsxKmQzyslgs0aGOl6q/JlO
         MHrrhGqALjThygprksogupPh3/XElCSZv6+tr6X97O/LdTkAdQeENJnboKU2suULxV
         q3xC/OaOrNTyA==
Date:   Mon, 25 Oct 2021 13:56:17 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXaNUQv8RwDc0lif@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <YXUtbOpjmmWr71dU@unreal>
 <YXU5+XLhQ9zkBGNY@shredder>
 <YXZB/3+IR6I0b2xE@unreal>
 <YXZl4Gmq6DYSdDM3@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXZl4Gmq6DYSdDM3@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 11:08:00AM +0300, Ido Schimmel wrote:
> On Mon, Oct 25, 2021 at 08:34:55AM +0300, Leon Romanovsky wrote:
> > On Sun, Oct 24, 2021 at 01:48:25PM +0300, Ido Schimmel wrote:
> > > On Sun, Oct 24, 2021 at 12:54:52PM +0300, Leon Romanovsky wrote:
> > > > On Sun, Oct 24, 2021 at 12:05:12PM +0300, Ido Schimmel wrote:
> > > > > On Sun, Oct 24, 2021 at 11:42:11AM +0300, Leon Romanovsky wrote:
> > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > 
> > > > > > Align netdevsim to be like all other physical devices that register and
> > > > > > unregister devlink traps during their probe and removal respectively.
> > > > > 
> > > > > No, this is incorrect. Out of the three drivers that support both reload
> > > > > and traps, both netdevsim and mlxsw unregister the traps during reload.
> > > > > Here is another report from syzkaller about mlxsw [1].
> > > > 
> > > > Sorry, I overlooked it.
> > > > 
> > > > > 
> > > > > Please revert both 22849b5ea595 ("devlink: Remove not-executed trap
> > > > > policer notifications") and 8bbeed485823 ("devlink: Remove not-executed
> > > > > trap group notifications").
> > > > 
> > > > However, before we rush and revert commit, can you please explain why
> > > > current behavior to reregister traps on reload is correct?
> > > > 
> > > > I think that you are not changing traps during reload, so traps before
> > > > reload will be the same as after reload, am I right?
> > > 
> > > During reload we tear down the entire driver and load it again. As part
> > > of the reload_down() operation we tear down the various objects from
> > > both devlink and the device (e.g., shared buffer, ports, traps, etc.).
> > > As part of the reload_up() operation we issue a device reset and
> > > register everything back.
> > 
> > This is an implementation which is arguably questionable and pinpoints
> > problem with devlink reload. It mixes different SW layers into one big
> > mess which I tried to untangle.
> > 
> > The devlink "feature" that driver reregisters itself again during execution
> > of other user-visible devlink command can't be right design.
> > 
> > > 
> > > While the list of objects doesn't change, their properties (e.g., shared
> > > buffer size, trap action, policer rate) do change back to the default
> > > after reload and we cannot go back on that as it's a user-visible
> > > change.
> > 
> > I don't propose to go back, just prefer to see fixed mlxsw that
> > shouldn't touch already created and registered objects from net/core/devlink.c.
> > 
> > All reset-to-default should be performed internally to the driver
> > without any need to devlink_*_register() again, so we will be able to
> > clean rest devlink notifications.
> > 
> > So at least for the netdevsim, this change looks like the correct one,
> > while mlxsw should be fixed next.
> 
> No, it's not correct. After your patch, trap properties like action are
> not set back to the default. Regardless of what you think is the "right
> design", you cannot introduce such regressions.

Again, I'm not against fixing the regression, I'm trying to understand
why it is impossible to fix mlxsw and netdevsim to honor SW layering
properly.

> 
> Calling devlink_*_unregister() in reload_down() and devlink_*_register()
> in reload_up() is not new. It is done for multiple objects (e.g., ports,
> regions, shared buffer, etc). After your patch, netdevsim is still doing
> it.

Yeah, it was introduced by same developers who did it in mlxsw, so no
wonders that same patterns exist in both drivers.

> 
> Again, please revert the two commits I mentioned. If you think they are
> necessary, you can re-submit them in the future, after proper review and
> testing of the affected code paths.

It was posted for review in the ML, no one objected.

Can you please explain why is it so important to touch devlink SW
objects, reallocate them again and again on every reload in mlxsw?

The flow is convoluted without any reason:
devlink reload ->
  mlxsw reload_down -> 
    devlink ... unregister -> 
      mlxsw reload_down again ->
        devlink reload again ->
	  mlxsw reload_up ->
	    devlink ... register ->
	      mlxsw to handle register ->
	        mlxsw reload_up again ->
		  devlink reload finish

Instead of:
devlink reload ->
 mlxsw reload_down ->
   devlink reload again ->
     mlxsw reload_up ->
       devlink reload finish

Thanks

> 
> Thanks
