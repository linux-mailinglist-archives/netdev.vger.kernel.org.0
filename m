Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 696D8100441
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfKRLd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:33:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbfKRLd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 06:33:56 -0500
Received: from localhost (unknown [89.205.134.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9C252068D;
        Mon, 18 Nov 2019 11:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574076835;
        bh=apnW7+TI+jIaoCAZ4G/U2g2SJq9TGq6eBTkKRL1hKxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0uQumoOB6CFb7PEG/6jP4t04vhKZTXGAc2XJ+EiOrQhp27uOCQi3DaJXBiROeJHtx
         hhW3FDPS3udp6VYlcKUez6dlxI4Roj9g9TJQAc+WXiZEmt+fY7ki8V2e/lpDQ/JSQs
         PWRLcPIdebKGVX/uuMIx8sxr6KIT2R5QJNfxGyc8=
Date:   Mon, 18 Nov 2019 12:33:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH] net-sysfs: Fix reference count leak
Message-ID: <20191118113352.GA183814@kroah.com>
References: <20191118112553.4271-1-jouni.hogander@unikie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118112553.4271-1-jouni.hogander@unikie.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 01:25:53PM +0200, jouni.hogander@unikie.com wrote:
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
> v1 -> v2:
> * Relying on driver calling free_netdev rather than calling
>   put_device directly in error path
> 
> Reported-by: syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com
> Cc: David Miller <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> ---
>  net/core/dev.c       | 14 +++++++-------
>  net/core/net-sysfs.c |  6 +++++-
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 99ac84ff398f..4b8d03f9cba3 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9603,14 +9603,14 @@ void free_netdev(struct net_device *dev)
>  
>  	netdev_unregister_lockdep_key(dev);
>  
> -	/*  Compatibility with error handling in drivers */
> -	if (dev->reg_state == NETREG_UNINITIALIZED) {
> -		netdev_freemem(dev);
> -		return;
> -	}
> +	/* reg_state is NETREG_UNINITIALIZED if there is an error in
> +	 * registration.
> +	 */
> +	BUG_ON(dev->reg_state != NETREG_UNREGISTERED &&
> +	       dev->reg_state != NETREG_UNINITIALIZED);

Are we not trying to remove the number of BUG_ON() calls in the kernel?
This feels like a "I don't know what to do so I am going to just crash
the whole system" failure on behalf of the programmer.  There is no way
to report this as an error and keep on working?

thanks,

greg k-h
