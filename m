Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F0745A2DA
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbhKWMnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236595AbhKWMnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:43:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B31561074;
        Tue, 23 Nov 2021 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637671209;
        bh=5qaqYXMB4Z2vfZKrEfV2VP4m4WZltpvKjDDUKOgKSBI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZqqrSp6uKN5MXJ/1ex5fqNKjrnluA8e2YUUq7rHoJ6vIEo0RT0OGJXuVe2Ii+TBwx
         XHD+rgjeFhETXE5+zyr8sg21Mhb26k0JqcQXCVlY86KiE70ESZONijoRIYRHLevA9t
         Yr6IwScpvTEUA25xbftECmbTz7wgiGO3XjlFgbm9TbNOFF2cmTGujOIRmB6LrH3Q+5
         IpSLZ4oLoEiJtpGbfUXirmCJ5lCOXRbg0g5QmaHCmT5UQ0KYmdALHrg990RBPm86db
         jbNm/lXL7F+TyFrV9545F1ohaC6pxNIrLQsSWihv6+IbO5LGencYAJcndaJZ8Q+/ra
         1C26C4dZTSQ+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 894A460A22;
        Tue, 23 Nov 2021 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: Correct PHY handling of smsc95xx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767120955.19545.3650773979093266517.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:40:09 +0000
References: <20211122184445.1159316-1-martyn.welch@collabora.com>
In-Reply-To: <20211122184445.1159316-1-martyn.welch@collabora.com>
To:     Martyn Welch <martyn.welch@collabora.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@collabora.com,
        steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, stable@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 18:44:45 +0000 you wrote:
> The smsc95xx driver is dropping phy speed settings and causing a stack
> trace at device unbind:
> 
> [  536.379147] smsc95xx 2-1:1.0 eth1: unregister 'smsc95xx' usb-ci_hdrc.2-1, smsc95xx USB 2.0 Ethernet
> [  536.425029] ------------[ cut here ]------------
> [  536.429650] WARNING: CPU: 0 PID: 439 at fs/kernfs/dir.c:1535 kernfs_remove_by_name_ns+0xb8/0xc0
> [  536.438416] kernfs: can not remove 'attached_dev', no directory
> [  536.444363] Modules linked in: xts dm_crypt dm_mod atmel_mxt_ts smsc95xx usbnet
> [  536.451748] CPU: 0 PID: 439 Comm: sh Tainted: G        W         5.15.0 #1
> [  536.458636] Hardware name: Freescale i.MX53 (Device Tree Support)
> [  536.464735] Backtrace:
> [  536.467190] [<80b1c904>] (dump_backtrace) from [<80b1cb48>] (show_stack+0x20/0x24)
> [  536.474787]  r7:000005ff r6:8035b294 r5:600f0013 r4:80d8af78
> [  536.480449] [<80b1cb28>] (show_stack) from [<80b1f764>] (dump_stack_lvl+0x48/0x54)
> [  536.488035] [<80b1f71c>] (dump_stack_lvl) from [<80b1f788>] (dump_stack+0x18/0x1c)
> [  536.495620]  r5:00000009 r4:80d9b820
> [  536.499198] [<80b1f770>] (dump_stack) from [<80124fac>] (__warn+0xfc/0x114)
> [  536.506187] [<80124eb0>] (__warn) from [<80b1d21c>] (warn_slowpath_fmt+0xa8/0xdc)
> [  536.513688]  r7:000005ff r6:80d9b820 r5:80d9b8e0 r4:83744000
> [  536.519349] [<80b1d178>] (warn_slowpath_fmt) from [<8035b294>] (kernfs_remove_by_name_ns+0xb8/0xc0)
> [  536.528416]  r9:00000001 r8:00000000 r7:824926dc r6:00000000 r5:80df6c2c r4:00000000
> [  536.536162] [<8035b1dc>] (kernfs_remove_by_name_ns) from [<80b1f56c>] (sysfs_remove_link+0x4c/0x50)
> [  536.545225]  r6:7f00f02c r5:80df6c2c r4:83306400
> [  536.549845] [<80b1f520>] (sysfs_remove_link) from [<806f9c8c>] (phy_detach+0xfc/0x11c)
> [  536.557780]  r5:82492000 r4:83306400
> [  536.561359] [<806f9b90>] (phy_detach) from [<806f9cf8>] (phy_disconnect+0x4c/0x58)
> [  536.568943]  r7:824926dc r6:7f00f02c r5:82492580 r4:83306400
> [  536.574604] [<806f9cac>] (phy_disconnect) from [<7f00a310>] (smsc95xx_disconnect_phy+0x30/0x38 [smsc95xx])
> [  536.584290]  r5:82492580 r4:82492580
> [  536.587868] [<7f00a2e0>] (smsc95xx_disconnect_phy [smsc95xx]) from [<7f001570>] (usbnet_stop+0x70/0x1a0 [usbnet])
> [  536.598161]  r5:82492580 r4:82492000
> [  536.601740] [<7f001500>] (usbnet_stop [usbnet]) from [<808baa70>] (__dev_close_many+0xb4/0x12c)
> [  536.610466]  r8:83744000 r7:00000000 r6:83744000 r5:83745b74 r4:82492000
> [  536.617170] [<808ba9bc>] (__dev_close_many) from [<808bab78>] (dev_close_many+0x90/0x120)
> [  536.625365]  r7:00000001 r6:83745b74 r5:83745b8c r4:82492000
> [  536.631026] [<808baae8>] (dev_close_many) from [<808bf408>] (unregister_netdevice_many+0x15c/0x704)
> [  536.640094]  r9:00000001 r8:81130b98 r7:83745b74 r6:83745bc4 r5:83745b8c r4:82492000
> [  536.647840] [<808bf2ac>] (unregister_netdevice_many) from [<808bfa50>] (unregister_netdevice_queue+0xa0/0xe8)
> [  536.657775]  r10:8112bcc0 r9:83306c00 r8:83306c80 r7:8291e420 r6:83744000 r5:00000000
> [  536.665608]  r4:82492000
> [  536.668143] [<808bf9b0>] (unregister_netdevice_queue) from [<808bfac0>] (unregister_netdev+0x28/0x30)
> [  536.677381]  r6:7f01003c r5:82492000 r4:82492000
> [  536.682000] [<808bfa98>] (unregister_netdev) from [<7f000b40>] (usbnet_disconnect+0x64/0xdc [usbnet])
> [  536.691241]  r5:82492000 r4:82492580
> [  536.694819] [<7f000adc>] (usbnet_disconnect [usbnet]) from [<8076b958>] (usb_unbind_interface+0x80/0x248)
> [  536.704406]  r5:7f01003c r4:83306c80
> [  536.707984] [<8076b8d8>] (usb_unbind_interface) from [<8061765c>] (device_release_driver_internal+0x1c4/0x1cc)
> [  536.718005]  r10:8112bcc0 r9:80dff1dc r8:83306c80 r7:83744000 r6:7f01003c r5:00000000
> [  536.725838]  r4:8291e420
> [  536.728373] [<80617498>] (device_release_driver_internal) from [<80617684>] (device_release_driver+0x20/0x24)
> [  536.738302]  r7:83744000 r6:810d4f4c r5:8291e420 r4:8176ae30
> [  536.743963] [<80617664>] (device_release_driver) from [<806156cc>] (bus_remove_device+0xf0/0x148)
> [  536.752858] [<806155dc>] (bus_remove_device) from [<80610018>] (device_del+0x198/0x41c)
> [  536.760880]  r7:83744000 r6:8116e2e4 r5:8291e464 r4:8291e420
> [  536.766542] [<8060fe80>] (device_del) from [<80768fe8>] (usb_disable_device+0xcc/0x1e0)
> [  536.774576]  r10:8112bcc0 r9:80dff1dc r8:00000001 r7:8112bc48 r6:8291e400 r5:00000001
> [  536.782410]  r4:83306c00
> [  536.784945] [<80768f1c>] (usb_disable_device) from [<80769c30>] (usb_set_configuration+0x514/0x8dc)
> [  536.794011]  r10:00000000 r9:00000000 r8:832c3600 r7:00000004 r6:810d5688 r5:00000000
> [  536.801844]  r4:83306c00
> [  536.804379] [<8076971c>] (usb_set_configuration) from [<80775fac>] (usb_generic_driver_disconnect+0x34/0x38)
> [  536.814236]  r10:832c3610 r9:83745ef8 r8:832c3600 r7:00000004 r6:810d5688 r5:83306c00
> [  536.822069]  r4:83306c00
> [  536.824605] [<80775f78>] (usb_generic_driver_disconnect) from [<8076b850>] (usb_unbind_device+0x30/0x70)
> [  536.834100]  r5:83306c00 r4:810d5688
> [  536.837678] [<8076b820>] (usb_unbind_device) from [<8061765c>] (device_release_driver_internal+0x1c4/0x1cc)
> [  536.847432]  r5:822fb480 r4:83306c80
> [  536.851009] [<80617498>] (device_release_driver_internal) from [<806176a8>] (device_driver_detach+0x20/0x24)
> [  536.860853]  r7:00000004 r6:810d4f4c r5:810d5688 r4:83306c80
> [  536.866515] [<80617688>] (device_driver_detach) from [<80614d98>] (unbind_store+0x70/0xe4)
> [  536.874793] [<80614d28>] (unbind_store) from [<80614118>] (drv_attr_store+0x30/0x3c)
> [  536.882554]  r7:00000000 r6:00000000 r5:83739200 r4:80614d28
> [  536.888217] [<806140e8>] (drv_attr_store) from [<8035cb68>] (sysfs_kf_write+0x48/0x54)
> [  536.896154]  r5:83739200 r4:806140e8
> [  536.899732] [<8035cb20>] (sysfs_kf_write) from [<8035be84>] (kernfs_fop_write_iter+0x11c/0x1d4)
> [  536.908446]  r5:83739200 r4:00000004
> [  536.912024] [<8035bd68>] (kernfs_fop_write_iter) from [<802b87fc>] (vfs_write+0x258/0x3e4)
> [  536.920317]  r10:00000000 r9:83745f58 r8:83744000 r7:00000000 r6:00000004 r5:00000000
> [  536.928151]  r4:82adacc0
> [  536.930687] [<802b85a4>] (vfs_write) from [<802b8b0c>] (ksys_write+0x74/0xf4)
> [  536.937842]  r10:00000004 r9:007767a0 r8:83744000 r7:00000000 r6:00000000 r5:82adacc0
> [  536.945676]  r4:82adacc0
> [  536.948213] [<802b8a98>] (ksys_write) from [<802b8ba4>] (sys_write+0x18/0x1c)
> [  536.955367]  r10:00000004 r9:83744000 r8:80100244 r7:00000004 r6:76f47b58 r5:76fc0350
> [  536.963200]  r4:00000004
> [  536.965735] [<802b8b8c>] (sys_write) from [<80100060>] (ret_fast_syscall+0x0/0x48)
> [  536.973320] Exception stack(0x83745fa8 to 0x83745ff0)
> [  536.978383] 5fa0:                   00000004 76fc0350 00000001 007767a0 00000004 00000000
> [  536.986569] 5fc0: 00000004 76fc0350 76f47b58 00000004 76f47c7c 76f48114 00000000 7e87991c
> [  536.994753] 5fe0: 00000498 7e879908 76e6dce8 76eca2e8
> [  536.999922] ---[ end trace 9b835d809816b435 ]---
> 
> [...]

Here is the summary with links:
  - net: usb: Correct PHY handling of smsc95xx
    https://git.kernel.org/netdev/net/c/a049a30fc27c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


