Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6912E43C6B1
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238746AbhJ0JqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236282AbhJ0JqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 05:46:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3748B60EDF;
        Wed, 27 Oct 2021 09:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635327834;
        bh=VamiCDRY2Jm6wCsoF7Ul2LuA4UNUxvU1NzDgcC1N/XA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SijhGI3zQ4BfXjr5omvlexqH9vB+MKLh3V80St9yLNZDaEJAxOCtd6qtOzHuXieHo
         seJIDXIikcfIcwRY9lqPocqV4K/Jvwjc7YuQPu8C+artADBP7yAyzkgMSNdMpc7nNs
         jKG6Vl4TIm5TdButDhTHostAI1ZxCiZiMjJ/WSs7YYidMLYiYfhUxEKnxeHy6uEKqJ
         28ViZ0IVHiRtKqxGvJmwZRawU3dWq2py8O3g9iJYprZxhdsR8tgScH1lSmlL1aJghH
         hGna+APpSbGfWCfZxL5jwpp3od9EZsSS9SqDrZFwzzrWlI9rtv+5mOwpAEo/lf5hbB
         bWv1CUmAFQbEw==
Date:   Wed, 27 Oct 2021 12:43:50 +0300
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
Message-ID: <YXkfVuthd6G75L/S@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <CAKOOJTzc9pJ1KKDHuGTFDeHb77B2GynA9HEVWKys=zvh_kY+Hw@mail.gmail.com>
 <YXeYjXx92wKdPe02@unreal>
 <CAKOOJTyrzosizeKpfYcu4jMn6SRYrqxU0BzMf8qudAk5e74R9g@mail.gmail.com>
 <YXhVd16heaHCegL1@unreal>
 <CAKOOJTzrQYz4FTDU_d_R0RLA4u6pfK9=+=E_uKMr4VCNbmF_kA@mail.gmail.com>
 <YXj1J/Z8HYvBWC6Y@unreal>
 <CAKOOJTyrUUydu9aNJSB4S_5dfqjkc6Y-14up4-V+aNcQ7TWVdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTyrUUydu9aNJSB4S_5dfqjkc6Y-14up4-V+aNcQ7TWVdQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 01:46:44AM -0700, Edwin Peer wrote:
> On Tue, Oct 26, 2021 at 11:43 PM Leon Romanovsky <leon@kernel.org> wrote:
> 
> > In our case, the eth driver is part of mlx5_core module, so at the
> > device creation phase that module is already loaded and driver/core
> > will try to autoprobe it.
> 
> > However, the last step is not always performed and controlled by the
> > userspace. Users can disable driver autoprobe and bind manually. This
> > is pretty standard practice in the SR-IOV or VFIO modes.
> 
> While you say the netdev will not necessarily be bound, that still
> sounds like the netdev will indeed be presented to user space before
> devlink_register() when it is auto-probed?

And it is ok, there is no binding between netdev and devlink. They are
independent. For example, IB cards have devlink through mlx5_core, but
without netdev at all.

> 
> > This is why devlink has monitor mode where you can see devlink device
> > addition and removal. It is user space job to check that device is
> > ready.
> 
> Isn't it more a question of what existing user space _does_ rather
> than what user space _should_ do?

No, because races of kernel vs. user space always existed and every time,
the answer was the same - it is user space job to avoid race. Kernel
needs to protect itself and we successfully did it here.

Latest example of such programming model can be seen in VFIO too:
https://lore.kernel.org/kvm/20211026090605.91646-1-yishaih@nvidia.com/T/#m89ef326da9405dcefe482bd5a6a54aff7e0b90bc
"Yes. If the userspace races ioctls they get a deserved mess.

This race exists no matter what we do, as soon as the unlock happens a
racing reset ioctl could run in during the system call exit path.

The purpose of the locking is to protect the kernel from hostile
userspace, not to allow userspace to execute concurrent ioctl's in a
sensible way."

> 
> > > This isn't about kernel API. This is precisely about existing user
> > > space that expects devlink to work immediately after the netdev
> > > appears.
> >
> > Can you please share open source project that has such assumption?
> 
> I'm no python expert, but it looks like
> https://github.com/openstack-charmers/mlnx-switchdev-mode/ might.

No, it is not.

> We've certainly had implicit user space assumptions trip over
> registration order before, hence the change we made in January last
> year to move devlink registration earlier. Granted, upon deeper
> analysis, that specific case pertained to phys port name via sysfs,
> which technically only needs port attrs via ndo_get_devlink_port, not
> devlink_register(). That said, I'm certainly not confident that there
> are no other existing users that might expect to be able to invoke
> devlink in ifup scripts.

It is not what your change did, you moved devlink ops registration logic
to be before register_netdev(), this is continue to be in upstream code.
We are registering ops in devlink_alloc() and that function stays to be
at the same place.

> 
> > > What do you suggest instead?
> >
> > Fix your test respect devlink notifications and don't ignore them.
> 
> That's not very helpful. The test case does what the user in the field
> did to break it. We can't assume users have always been using our APIs
> the way we intended.

There is no API here.

Thanks

> 
> Regards,
> Edwin Peer
