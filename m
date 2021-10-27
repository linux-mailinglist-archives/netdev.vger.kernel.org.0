Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB43A43C327
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 08:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbhJ0GqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 02:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231530AbhJ0GqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 02:46:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9757061073;
        Wed, 27 Oct 2021 06:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635317035;
        bh=16Olf4WVQYSRwe1OkFa1dBzILsGrYofaKzrqASex/Zg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HbfzhxOvHNtFDWxRIqBqW/oFXtkwTVszVX6KZTI7cIIZNEmyS5BwtpFZ5FB9Na+eG
         Dim3h+I2yLnBxfUCr3bRMI5N4gkyiPhJkQXAioqR36saTmfu8wMucioBwNmqqJMQ3G
         bWBYXNM5R9Q9U9hq41H5LgBqOkDtiJN8Y0JfoTtB6oHBEtj2Cg5Dw4TaaPJHdQVU34
         bgjlBQnLV/Sa8xU1BAozwvzhnTpx/qAKyGQX9G7MEqSlp9Fh42BseYhStiEv0PHJ0J
         M1tlbYxC57jouCTf8WEBijR5WK0Gg9osWZHdVcrl9RM94vCUhysaU1vjzlgQ6MfbfJ
         g1pOCsvt5qoDQ==
Date:   Wed, 27 Oct 2021 09:43:51 +0300
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
Message-ID: <YXj1J/Z8HYvBWC6Y@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <CAKOOJTzc9pJ1KKDHuGTFDeHb77B2GynA9HEVWKys=zvh_kY+Hw@mail.gmail.com>
 <YXeYjXx92wKdPe02@unreal>
 <CAKOOJTyrzosizeKpfYcu4jMn6SRYrqxU0BzMf8qudAk5e74R9g@mail.gmail.com>
 <YXhVd16heaHCegL1@unreal>
 <CAKOOJTzrQYz4FTDU_d_R0RLA4u6pfK9=+=E_uKMr4VCNbmF_kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTzrQYz4FTDU_d_R0RLA4u6pfK9=+=E_uKMr4VCNbmF_kA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 01:03:41PM -0700, Edwin Peer wrote:
> On Tue, Oct 26, 2021 at 12:22 PM Leon Romanovsky <leon@kernel.org> wrote:
> 
> > At least in mlx5 case, reload_enable() was before register_netdev().
> > It stayed like this after swapping it with devlink_register().
> 
> What am I missing here?
> 
> err = mlx5_init_one(dev);
> if (err) {
>        mlx5_core_err(dev, "mlx5_init_one failed with error code %d\n", err);
>        goto err_init_one;
> }
> 
> err = mlx5_crdump_enable(dev);
> if (err)
>         dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code
> %d\n", err);
> 
> pci_save_state(pdev);
> devlink_register(devlink);
> 
> Doesn't mlx5_init_one() ultimately result in the netdev being
> presented to user space, even if it is via aux bus?

The mlx5_init_one() aux devices, and driver is not always loaded
directly in the Linux kernel. The device creation triggers udev event,
which is handled by udev systemd. The systemd reads various modules.* files
that kernel provides and this is how it knows which driver to load.

In our case, the eth driver is part of mlx5_core module, so at the
device creation phase that module is already loaded and driver/core
will try to autoprobe it.

However, the last step is not always performed and controlled by the
userspace. Users can disable driver autoprobe and bind manually. This
is pretty standard practice in the SR-IOV or VFIO modes.

> 
> > No, it is not requirement, but my suggestion. You need to be aware that
> > after call to devlink_register(), the device will be fully open for devlink
> > netlink access. So it is strongly advised to put devlink_register to be the
> > last command in PCI initialization sequence.
> 
> Right, that's the problem. Once we register the netdev, we're in a
> race with user space, which may expect to be able to call devlink
> before we get to devlink_register().

This is why devlink has monitor mode where you can see devlink device
addition and removal. It is user space job to check that device is
ready.

> 
> > You obviously need to fix your code. Upstream version of bnxt driver
> > doesn't have reload_* support, so all this regression blaming it not
> > relevant here.
> 
> Right, our timing is unfortunate and that's on us. It's still not
> clear to me how to actually fix the devlink reload code without the
> benefit of something similar to the reload enable API.
> 
> > In upstream code, devlink_register() doesn't accept ops like it was
> > before and position of that call does only one thing - opens devlink
> > netlink access. All kernel devlink APIs continue to be accessible even
> > before devlink_register.
> 
> This isn't about kernel API. This is precisely about existing user
> space that expects devlink to work immediately after the netdev
> appears.

Can you please share open source project that has such assumption?

> 
> > It looks like your failure is in backport code.
> 
> Our out-of-tree driver isn't the issue here. I'm talking about the
> proposed upstream code. The issue is what to do in order to get
> something workable upstream for devlink reload. We can't move
> devlink_register() later, that will cause a regression. What do you
> suggest instead?

Fix your test respect devlink notifications and don't ignore them.

Thanks

> 
> Regards,
> Edwin Peer
