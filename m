Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AC343BAA2
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbhJZTZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235162AbhJZTZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:25:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74BD960EFF;
        Tue, 26 Oct 2021 19:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635276156;
        bh=+nJ6uC+6Wlo9SRX97zlx3q28QZTQWwdv1xNrqnJgLP8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LtzCE42cRGMnvTIpqUWicASA8oUTPKAt75z/IgnIKTZyYIkLIjg31ozJMibPkKkZ3
         OKBLGiPzc5HFJiqTIyOMha2t087q2pOrzdL3DfIUhznxqvv06UJs0u0s55mDfCmvfe
         VG1TjFBtJjG3myKXL7CJg8lJL/Sc+D52TgUiuAroZ7zxwsrkX04OQWx9TIMTJqeCKX
         8sDur7Njl0BWj/hCoL9QxHPtrx354W9UCeMILO6dOrEr0KCStIyvKo5FqDV2IJaqmv
         sDyzQqBlSrsgLui/rC4lzD0c+F2HK/VX/Zmpz1wNAwOxa24DYKJe99fiGtRlqysiwG
         /ZXZEf8SLSgBA==
Date:   Tue, 26 Oct 2021 22:22:31 +0300
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
Message-ID: <YXhVd16heaHCegL1@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <CAKOOJTzc9pJ1KKDHuGTFDeHb77B2GynA9HEVWKys=zvh_kY+Hw@mail.gmail.com>
 <YXeYjXx92wKdPe02@unreal>
 <CAKOOJTyrzosizeKpfYcu4jMn6SRYrqxU0BzMf8qudAk5e74R9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTyrzosizeKpfYcu4jMn6SRYrqxU0BzMf8qudAk5e74R9g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 10:34:39AM -0700, Edwin Peer wrote:
> On Mon, Oct 25, 2021 at 10:56 PM Leon Romanovsky <leon@kernel.org> wrote:
> 
> > > Could we also revert 82465bec3e97 ("devlink: Delete reload
> > > enable/disable interface")?
> >
> > Absolutely not.
> 
> Although the following patch doesn't affect bnxt_en directly, I
> believe the change that will ultimately cause regressions are the
> patches of the form:
> 
> 64ea2d0e7263 ("net/mlx5: Accept devlink user input after driver
> initialization complete")
> 
> Removing the reload enable interface is merely the reason you're
> moving devlink_register() later here, but it's the swapping of the
> relative order of devlinqk_register() and register_netdev() which is
> the problem.

At least in mlx5 case, reload_enable() was before register_netdev().
It stayed like this after swapping it with devlink_register().

> 
> Our proposed devlink reload depends on the netdev being registered.
> This was previously gated by reload enable, but that is a secondary
> issue. The real question is whether you now require devlink_register()
> to go last in general? If so, that's a problem because we'll race with
> user space. User visible regressions will definitely follow.

No, it is not requirement, but my suggestion. You need to be aware that
after call to devlink_register(), the device will be fully open for devlink
netlink access. So it is strongly advised to put devlink_register to be the
last command in PCI initialization sequence.

It is exactly like it was before, but instead of one _reload_ interface
which had extra enable/disable logic, we are protecting all other set/get
commands. Before the change, you was able to send any devlink netlink commands
and crash unprotected driver.

> 
> The bnxt_en driver was only saved from such regressions because you
> did not carry out the same change there as you've done here.
> Otherwise, you would have broken bnxt_en as a consequence. I'm
> obviously not as familiar with mlx5, but I think you may have already
> broken it. I imagine the only reason customers haven't complained
> about this change yet is that few, if any, are running the net-next
> code.

This is not how mlx5 is implemented at all. We use auxiliary bus to
separate PCI core driver and eth netdev driver.

And yes, we have customers who rely on upstream code and test it
methodically.

> 
> > In a nutshell, latest devlink_register() implementation is better
> > implementation of previously existed "reload enable/disable" boolean.
> >
> > You don't need to reorder whole devlink logic, just put a call to
> > devlink_register() in the place where you wanted to put your
> > devlink_reload_enable().
> 
> We can't though, because of the two patches I pointed out previously.
> Moving devlink_register() to the existing devlink_reload_enable()
> location puts it after register_netdev(). That will cause a regression
> with udev and phys port name. We already have the failing test case
> and customer bug report for this. That is why devlink_register() was
> moved earlier in bnxt_en. We can't now do the opposite and move it
> later.

You obviously need to fix your code. Upstream version of bnxt driver
doesn't have reload_* support, so all this regression blaming it not
relevant here.

In upstream code, devlink_register() doesn't accept ops like it was
before and position of that call does only one thing - opens devlink
netlink access. All kernel devlink APIs continue to be accessible even
before devlink_register.

It looks like your failure is in backport code.

Thanks
