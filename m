Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F061810058A
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 13:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfKRMZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 07:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbfKRMZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 07:25:30 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9DED206F4;
        Mon, 18 Nov 2019 12:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574079929;
        bh=y8W5feSYOVMmL55Boge+mPkAhCKFugFyDbqQ6R06rsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kTh9opAOXXWRpftwT/ZnZynNfstlUe23LXkGF0vVrwkrGVWnDNcbUKlNHVzRaBFOQ
         qX74nDTEYluD+MlPOTHc5cLPLQgvLjoXYUfxGf+DI8bB7i7nIrRVeln/5qybz+tkbX
         HVDaRCiT6RcoPMHdg/WjBfjNh4oEMaGj7jedoEc8=
Date:   Mon, 18 Nov 2019 14:25:26 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH v3] net-sysfs: Fix reference count leak
Message-ID: <20191118122526.GB52766@unreal>
References: <20191118120650.12597-1-jouni.hogander@unikie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118120650.12597-1-jouni.hogander@unikie.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 02:06:50PM +0200, jouni.hogander@unikie.com wrote:
> From: Jouni Hogander <jouni.hogander@unikie.com>
>
> Netdev_register_kobject is calling device_initialize. In case of error
> reference taken by device_initialize is not given up.
>
> Drivers are supposed to call free_netdev in case of error. In non-error
> case the last reference is given up there and device release sequence
> is triggered. In error case this reference is kept and the release
> sequence is never started.
>
> Fix this reference count leak by allowing giving up the reference also
> in error case in free_netdev.
>
> Also replace BUG_ON with WARN_ON in free_netdev and in netdev_release.
>
> This is the rootcause for couple of memory leaks reported by Syzkaller:
>
> BUG: memory leak unreferenced object 0xffff8880675ca008 (size 256):
>   comm "netdev_register", pid 281, jiffies 4294696663 (age 6.808s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>   backtrace:
>     [<0000000058ca4711>] kmem_cache_alloc_trace+0x167/0x280
>     [<000000002340019b>] device_add+0x882/0x1750
>     [<000000001d588c3a>] netdev_register_kobject+0x128/0x380
>     [<0000000011ef5535>] register_netdevice+0xa1b/0xf00
>     [<000000007fcf1c99>] __tun_chr_ioctl+0x20d5/0x3dd0
>     [<000000006a5b7b2b>] tun_chr_ioctl+0x2f/0x40
>     [<00000000f30f834a>] do_vfs_ioctl+0x1c7/0x1510
>     [<00000000fba062ea>] ksys_ioctl+0x99/0xb0
>     [<00000000b1c1b8d2>] __x64_sys_ioctl+0x78/0xb0
>     [<00000000984cabb9>] do_syscall_64+0x16f/0x580
>     [<000000000bde033d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     [<00000000e6ca2d9f>] 0xffffffffffffffff
>
> BUG: memory leak
> unreferenced object 0xffff8880668ba588 (size 8):
>   comm "kobject_set_nam", pid 286, jiffies 4294725297 (age 9.871s)
>   hex dump (first 8 bytes):
>     6e 72 30 00 cc be df 2b                          nr0....+
>   backtrace:
>     [<00000000a322332a>] __kmalloc_track_caller+0x16e/0x290
>     [<00000000236fd26b>] kstrdup+0x3e/0x70
>     [<00000000dd4a2815>] kstrdup_const+0x3e/0x50
>     [<0000000049a377fc>] kvasprintf_const+0x10e/0x160
>     [<00000000627fc711>] kobject_set_name_vargs+0x5b/0x140
>     [<0000000019eeab06>] dev_set_name+0xc0/0xf0
>     [<0000000069cb12bc>] netdev_register_kobject+0xc8/0x320
>     [<00000000f2e83732>] register_netdevice+0xa1b/0xf00
>     [<000000009e1f57cc>] __tun_chr_ioctl+0x20d5/0x3dd0
>     [<000000009c560784>] tun_chr_ioctl+0x2f/0x40
>     [<000000000d759e02>] do_vfs_ioctl+0x1c7/0x1510
>     [<00000000351d7c31>] ksys_ioctl+0x99/0xb0
>     [<000000008390040a>] __x64_sys_ioctl+0x78/0xb0
>     [<0000000052d196b7>] do_syscall_64+0x16f/0x580
>     [<0000000019af9236>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     [<00000000bc384531>] 0xffffffffffffffff
>
> v2 -> v3:
> * Replaced BUG_ON with WARN_ON in free_netdev and netdev_release
>
> v1 -> v2:
> * Relying on driver calling free_netdev rather than calling
>   put_device directly in error path

This changelog should go after "---" line.

Thanks
