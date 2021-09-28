Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F5F41AFAE
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 15:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240612AbhI1NMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 09:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235776AbhI1NMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 09:12:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC42C061575;
        Tue, 28 Sep 2021 06:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8Y4+qGyuCO6q39+CSQ6y4fo3O7zf87El/V8Z1fXLg+o=; b=hZMyLWbpDXk1dFAoVgKVJW6UM5
        /7QaKqfb6x7Q5wHPPutTiLBI++SDHPaSdJDbsA9SucV/fdgGEVXZ5ClufUPGbJJl0hew3o0IKHwD4
        Wi+HhA3ERsYP9a+6lPvW9rbaat4K3hJC8VLOXHq+uXY0LaBYNTpnsYCkxFf3M3b/CsXuJp4hnVbTz
        7mN/w1syAaQM5nYuvw/r/5h3UW+aYG20kS+TKp1RhW1kRlrNo5n5W2rARuO1WQqgz7tAm+ixkR2F0
        SoDGH2rRokPB9PyXRTOWIve0oGQeRs+IBgF/RKDwhOzLQIlx3kAc1lYDQeO7TQIUspuwYWouO+XvG
        nzh55p7g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54830)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mVCsz-000191-Pc; Tue, 28 Sep 2021 14:11:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mVCsy-0001ma-1p; Tue, 28 Sep 2021 14:11:04 +0100
Date:   Tue, 28 Sep 2021 14:11:04 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yanfei Xu <yanfei.xu@windriver.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Message-ID: <YVMUaClu3ypcLMDB@shell.armlinux.org.uk>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926045313.2267655-1-yanfei.xu@windriver.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 26, 2021 at 12:53:13PM +0800, Yanfei Xu wrote:
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
> BUG: memory leak
> unreferenced object 0xffff888116f06900 (size 32):
>   comm "kworker/0:2", pid 2670, jiffies 4294944448 (age 7.160s)
>   hex dump (first 32 bytes):
>     75 73 62 2d 30 30 31 3a 30 30 33 00 00 00 00 00  usb-001:003.....
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff81484516>] kstrdup+0x36/0x70 mm/util.c:60
>     [<ffffffff814845a3>] kstrdup_const+0x53/0x80 mm/util.c:83
>     [<ffffffff82296ba2>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
>     [<ffffffff82358d4b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:289
>     [<ffffffff826575f3>] dev_set_name+0x63/0x90 drivers/base/core.c:3147
>     [<ffffffff828dd63b>] __mdiobus_register+0xbb/0x450 drivers/net/phy/mdio_bus.c:535
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
> 
> Reported-by: syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
> Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
> ---
>  drivers/net/phy/mdio_bus.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 53f034fc2ef7..6f4b4e5df639 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -537,6 +537,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	err = device_register(&bus->dev);
>  	if (err) {
>  		pr_err("mii_bus %s failed to register\n", bus->id);
> +		put_device(&bus->dev);
>  		return -EINVAL;
>  	}

This patch is incorrect:

1) the reported failure does not involve this path.
2) device_register() failing does not need a put_device() because
   the contained device_add() undoes everything that it attempted to
   do.

The above backtraces occur because we have had a successful
device_register() fall, but later call device_del() and then kfree()
the mdiobus, which has an embedded the struct device that has pointers
to memory that has not been cleaned up - because kfree() is the wrong
way to handle this.

bus->state needs to be set to indicate that the embedded struct device
has been registered but no longer is registered if we fail after
device_register() has been called.

If device_register() fails, then there is no problem.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
