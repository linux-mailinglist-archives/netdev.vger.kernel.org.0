Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD8E43ABEF
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 07:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbhJZF7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 01:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235192AbhJZF64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 01:58:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C567061074;
        Tue, 26 Oct 2021 05:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635227793;
        bh=yQqBNggdScygSpqZv7Yg8QOx3/VB58kGvn6AqtODOik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=To9n0eTDTYvcssoZrxKtQMqQBvePwzv1Ua7NybO7SnCTqy/oHCGgJH9dcYpqEYSw2
         r+EYy1/FAGlyT45626FullXij8eJvpTZlwzldepVdteI0/LCrjUjuaXv64/30EoH6W
         hKgl1aOpm5X9YwPPFkCXc5cKqq5onMcB9RbbCnlFb4eG8JtakkCW7iRfB5LOkihtiz
         ILF6uNDVqlzKQSLDwmFWatVyi0GzP/rzGumH1fgcTB5vB2ws70X0FDcG8uH+MaS8Gm
         fafWFiJySP6P93MXhwjv4/7IacAG5CSS6iPH72vXCxBXYILwFXJWgKLbJ8apB2rdem
         +4GcziHyRonzQ==
Date:   Tue, 26 Oct 2021 08:56:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXeYjXx92wKdPe02@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <CAKOOJTzc9pJ1KKDHuGTFDeHb77B2GynA9HEVWKys=zvh_kY+Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTzc9pJ1KKDHuGTFDeHb77B2GynA9HEVWKys=zvh_kY+Hw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 04:19:07PM -0700, Edwin Peer wrote:
> On Sun, Oct 24, 2021 at 3:35 PM Ido Schimmel <idosch@idosch.org> wrote:
> 
> > On Sun, Oct 24, 2021 at 11:42:11AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > Align netdevsim to be like all other physical devices that register and
> > > unregister devlink traps during their probe and removal respectively.
> >
> > No, this is incorrect. Out of the three drivers that support both reload
> > and traps, both netdevsim and mlxsw unregister the traps during reload.
> > Here is another report from syzkaller about mlxsw [1].
> >
> > Please revert both 22849b5ea595 ("devlink: Remove not-executed trap
> > policer notifications") and 8bbeed485823 ("devlink: Remove not-executed
> > trap group notifications").
> 
> Could we also revert 82465bec3e97 ("devlink: Delete reload
> enable/disable interface")? 

Absolutely not.

> This interface is needed because bnxt_en cannot reorder devlink last.
> If Leon had fully carried out the re-ordering in our driver he would
> have introduced a udev phys_port_name regression because of:
> 
> cda2cab0771 ("bnxt_en: Move devlink_register before registering netdev")
> 
> and:
> 
> ab178b058c4 ("bnxt: remove ndo_get_phys_port_name implementation")

devlink_register() doesn't do anything except performing as a barrier.

In a nutshell, latest devlink_register() implementation is better
implementation of previously existed "reload enable/disable" boolean.

You don't need to reorder whole devlink logic, just put a call to
devlink_register() in the place where you wanted to put your
devlink_reload_enable().

> 
> I think this went unnoticed for bnxt_en, because Michael had not yet
> posted our devlink reload patches, which presently rely on the reload
> enable/disable API. Absent horrible kludges in reload down/up which
> currently depends on the netdev, there doesn't appear to be a clean
> way to resolve the circular dependency without the interlocks this API
> provides.

You was supposed to update and retest your out-of-tree implementation
of devlink reload before posting it to the ML. However, if you use
devlink_*() API correctly, such dependency won't exist.

> 
> I imagine other subtle regressions are lying in wait.

Sorry, but we don't have crystal ball and can't guess what else is
broken in your out-of-tree driver.

Thanks

> 
> Regards,
> Edwin Peer
