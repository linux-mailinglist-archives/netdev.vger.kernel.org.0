Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD8F386C07
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245094AbhEQVLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241743AbhEQVL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 17:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B3CFA61350;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621285810;
        bh=41jlKsAxTdXtVg/ZNEArpk8xqZB1Cn7t81dNwL0DisA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tkzMQNqTXfwvFJLbKEkXPmxmGVOzgU6B07Fs0A84jM4fL/i4hO+XkTrEH0f1l660K
         owt/GdzVCSig7DHaK3q+kp8SbEs5DIsETxPobkUXObxJPhlaCMFGZwAi+ZhSv6GTqs
         G4Wn+s4MKEMwYRr328fJ5HVDuKduqSqqn5CeQhg57eNhP2Hl22f3MK1MSpzHv9Q17n
         HKNiiDuCS8Syc8TG95BJpeCQVN7VhvBfpdgF8CU5xVhc6ZsFKtfdf8scuyIj3PwJZp
         4nikaRz/3640N3Bndx/onG/LUDVi1EYAKVPulgL/pChJeen5QKYc4Z69uiPj1nl3vw
         JyVXri8G4LI5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC58060A35;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] NFC: nci: fix memory leak in nci_allocate_device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162128581070.6429.7239816038541020498.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 21:10:10 +0000
References: <20210514232906.982825-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210514232906.982825-1-mudongliangabcd@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        bongsu.jeon@samsung.com, andrew@lunn.ch, wanghai38@huawei.com,
        zhengyongjun3@huawei.com, alexs@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+19bcfc64a8df1318d1c3@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 15 May 2021 07:29:06 +0800 you wrote:
> nfcmrvl_disconnect fails to free the hci_dev field in struct nci_dev.
> Fix this by freeing hci_dev in nci_free_device.
> 
> BUG: memory leak
> unreferenced object 0xffff888111ea6800 (size 1024):
>   comm "kworker/1:0", pid 19, jiffies 4294942308 (age 13.580s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 60 fd 0c 81 88 ff ff  .........`......
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000004bc25d43>] kmalloc include/linux/slab.h:552 [inline]
>     [<000000004bc25d43>] kzalloc include/linux/slab.h:682 [inline]
>     [<000000004bc25d43>] nci_hci_allocate+0x21/0xd0 net/nfc/nci/hci.c:784
>     [<00000000c59cff92>] nci_allocate_device net/nfc/nci/core.c:1170 [inline]
>     [<00000000c59cff92>] nci_allocate_device+0x10b/0x160 net/nfc/nci/core.c:1132
>     [<00000000006e0a8e>] nfcmrvl_nci_register_dev+0x10a/0x1c0 drivers/nfc/nfcmrvl/main.c:153
>     [<000000004da1b57e>] nfcmrvl_probe+0x223/0x290 drivers/nfc/nfcmrvl/usb.c:345
>     [<00000000d506aed9>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
>     [<00000000bc632c92>] really_probe+0x159/0x4a0 drivers/base/dd.c:554
>     [<00000000f5009125>] driver_probe_device+0x84/0x100 drivers/base/dd.c:740
>     [<000000000ce658ca>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:846
>     [<000000007067d05f>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431
>     [<00000000f8e13372>] __device_attach+0x122/0x250 drivers/base/dd.c:914
>     [<000000009cf68860>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:491
>     [<00000000359c965a>] device_add+0x5be/0xc30 drivers/base/core.c:3109
>     [<00000000086e4bd3>] usb_set_configuration+0x9d9/0xb90 drivers/usb/core/message.c:2164
>     [<00000000ca036872>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
>     [<00000000d40d36f6>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
>     [<00000000bc632c92>] really_probe+0x159/0x4a0 drivers/base/dd.c:554
> 
> [...]

Here is the summary with links:
  - [v2] NFC: nci: fix memory leak in nci_allocate_device
    https://git.kernel.org/netdev/net/c/e0652f8bb44d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


