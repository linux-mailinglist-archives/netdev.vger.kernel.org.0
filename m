Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A650438EE4
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 07:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhJYFhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 01:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhJYFhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 01:37:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF5D060E74;
        Mon, 25 Oct 2021 05:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635140099;
        bh=Uf7UBRfVAwC6Td7t3UkncqbwGi0fmhPXcq0U0KO4OKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WxPVTWlIVi87y3CqiHBe4pKIDU4PqHWC/qMqqUNqLEQIv2VqfeCLALrDE+o+EWFPH
         h9Pjmsr7yYO7OEN3vazcbzsUNosHsiU5CMDBAkApOJKapyVq2mlpfCURvfWatXsn2q
         8hrnKMcjrnhwnQhvedaG8l76a79MAAgHHVKqLMS4TQS96m/6bFD227oBN+A732GwEp
         jnx8TTbNt8yDXzjtzQ5UHCVnZXXTTukEX47gEgW3L3vecLETo32A3a3SJo298Buga3
         K/xIg9dDEk+hE83PVEcrdMEE1Ov8QDRlwUNQnRpnuhLFgDrX65+YACl5rl4aDbMRJs
         TQpekpbpEVCEg==
Date:   Mon, 25 Oct 2021 08:34:55 +0300
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
Message-ID: <YXZB/3+IR6I0b2xE@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <YXUtbOpjmmWr71dU@unreal>
 <YXU5+XLhQ9zkBGNY@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXU5+XLhQ9zkBGNY@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 01:48:25PM +0300, Ido Schimmel wrote:
> On Sun, Oct 24, 2021 at 12:54:52PM +0300, Leon Romanovsky wrote:
> > On Sun, Oct 24, 2021 at 12:05:12PM +0300, Ido Schimmel wrote:
> > > On Sun, Oct 24, 2021 at 11:42:11AM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Align netdevsim to be like all other physical devices that register and
> > > > unregister devlink traps during their probe and removal respectively.
> > > 
> > > No, this is incorrect. Out of the three drivers that support both reload
> > > and traps, both netdevsim and mlxsw unregister the traps during reload.
> > > Here is another report from syzkaller about mlxsw [1].
> > 
> > Sorry, I overlooked it.
> > 
> > > 
> > > Please revert both 22849b5ea595 ("devlink: Remove not-executed trap
> > > policer notifications") and 8bbeed485823 ("devlink: Remove not-executed
> > > trap group notifications").
> > 
> > However, before we rush and revert commit, can you please explain why
> > current behavior to reregister traps on reload is correct?
> > 
> > I think that you are not changing traps during reload, so traps before
> > reload will be the same as after reload, am I right?
> 
> During reload we tear down the entire driver and load it again. As part
> of the reload_down() operation we tear down the various objects from
> both devlink and the device (e.g., shared buffer, ports, traps, etc.).
> As part of the reload_up() operation we issue a device reset and
> register everything back.

This is an implementation which is arguably questionable and pinpoints
problem with devlink reload. It mixes different SW layers into one big
mess which I tried to untangle.

The devlink "feature" that driver reregisters itself again during execution
of other user-visible devlink command can't be right design.

> 
> While the list of objects doesn't change, their properties (e.g., shared
> buffer size, trap action, policer rate) do change back to the default
> after reload and we cannot go back on that as it's a user-visible
> change.

I don't propose to go back, just prefer to see fixed mlxsw that
shouldn't touch already created and registered objects from net/core/devlink.c.

All reset-to-default should be performed internally to the driver
without any need to devlink_*_register() again, so we will be able to
clean rest devlink notifications.

So at least for the netdevsim, this change looks like the correct one,
while mlxsw should be fixed next.

Thanks
