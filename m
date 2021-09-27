Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54BD41943A
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhI0Mbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234239AbhI0Mbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:31:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5760D6103B;
        Mon, 27 Sep 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632745807;
        bh=cz++uK88L/frLkWIiahzSaUDP6G3LJ9Iga5JFW+LiAY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dz2+GPyGraIWfEyoVYFAY5kYmd5V8LbgiyD3B4zO0I0fsHw7QzowpU9QBFI5dtVZv
         PbQX4VEHbIWvSwPkmVvSXcS0r+ClmXFuIb5wo2y6HhhygVLuQ5aeCfcT6TyDYZRJg2
         4Fb0g0GeSTvNL/FncxxuIgErLF+7IdnTjs3WLB52tlwKCBLy0Xaq7XN3CJ2NBc2Axd
         l3MLVi7ZzHIGY6pqO3t3vafPnygE5It6B+88Gdrx+J1kSD2OWuqVS32o5b9BKcc2ex
         RGP33xsW9cOYCsC0Kk92CUicsko5ECQD6AgpMBkLdlyFHjym9n6pEBoflT7L+lIIEj
         wBYKymThcSDog==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 47444609CF;
        Mon, 27 Sep 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274580728.1790.11187942293008602400.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 12:30:07 +0000
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
In-Reply-To: <20210926045313.2267655-1-yanfei.xu@windriver.com>
To:     Yanfei Xu <yanfei.xu@windriver.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 26 Sep 2021 12:53:13 +0800 you wrote:
> Once device_register() failed, we should call put_device() to
> decrement reference count for cleanup. Or it will cause memory
> leak.
> 
> BUG: memory leak
> unreferenced object 0xffff888114032e00 (size 256):
>   comm "kworker/1:3", pid 2960, jiffies 4294943572 (age 15.920s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 08 2e 03 14 81 88 ff ff  ................
>     08 2e 03 14 81 88 ff ff 90 76 65 82 ff ff ff ff  .........ve.....
>   backtrace:
>     [<ffffffff8265cfab>] kmalloc include/linux/slab.h:591 [inline]
>     [<ffffffff8265cfab>] kzalloc include/linux/slab.h:721 [inline]
>     [<ffffffff8265cfab>] device_private_init drivers/base/core.c:3203 [inline]
>     [<ffffffff8265cfab>] device_add+0x89b/0xdf0 drivers/base/core.c:3253
>     [<ffffffff828dd643>] __mdiobus_register+0xc3/0x450 drivers/net/phy/mdio_bus.c:537
>     [<ffffffff828cb835>] __devm_mdiobus_register+0x75/0xf0 drivers/net/phy/mdio_devres.c:87
>     [<ffffffff82b92a00>] ax88772_init_mdio drivers/net/usb/asix_devices.c:676 [inline]
>     [<ffffffff82b92a00>] ax88772_bind+0x330/0x480 drivers/net/usb/asix_devices.c:786
>     [<ffffffff82baa33f>] usbnet_probe+0x3ff/0xdf0 drivers/net/usb/usbnet.c:1745
>     [<ffffffff82c36e17>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
>     [<ffffffff82661d17>] call_driver_probe drivers/base/dd.c:517 [inline]
>     [<ffffffff82661d17>] really_probe.part.0+0xe7/0x380 drivers/base/dd.c:596
>     [<ffffffff826620bc>] really_probe drivers/base/dd.c:558 [inline]
>     [<ffffffff826620bc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
>     [<ffffffff826621ba>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
>     [<ffffffff82662a26>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
>     [<ffffffff8265eca7>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
>     [<ffffffff826625a2>] __device_attach+0x122/0x260 drivers/base/dd.c:969
>     [<ffffffff82660916>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:487
>     [<ffffffff8265cd0b>] device_add+0x5fb/0xdf0 drivers/base/core.c:3359
>     [<ffffffff82c343b9>] usb_set_configuration+0x9d9/0xb90 drivers/usb/core/message.c:2170
>     [<ffffffff82c4473c>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
> 
> [...]

Here is the summary with links:
  - net: mdiobus: Fix memory leak in __mdiobus_register
    https://git.kernel.org/netdev/net/c/ab609f25d198

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


