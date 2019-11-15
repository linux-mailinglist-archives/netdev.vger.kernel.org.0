Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA73FE11D
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 16:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfKOPYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 10:24:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727531AbfKOPYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 10:24:20 -0500
Received: from localhost (unknown [122.147.212.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24F2720732;
        Fri, 15 Nov 2019 15:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573831458;
        bh=abL67/1fMt2ab5egyITGAgwmpW4pz8+D963330VfvTk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HBEKeI52QXxkGIqW2JjKAmlymlFFbeUjGQ4w/JeO8a8cFaIV2gh+wl4mb8Ju7TYtu
         QbepAeD4NczVeM21Pjyr/v0V4j5kyPrbnu1h023h6g6pSnY3X8fAUfgIPZwPpH+s6e
         jd6mN6c3E3WWtQpNT7Mqss7ZKtaYOppO9IYBKM2E=
Date:   Fri, 15 Nov 2019 23:24:16 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH] net-sysfs: Fix reference count leak
Message-ID: <20191115152416.GA377478@kroah.com>
References: <20191115122412.2595-1-jouni.hogander@unikie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115122412.2595-1-jouni.hogander@unikie.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 02:24:12PM +0200, jouni.hogander@unikie.com wrote:
> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Netdev_register_kobject is calling device_initialize. In case of error
> reference taken by device_initialize is not given up. This is
> the rootcause for couple of memory leaks reported by Syzkaller:
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
> Reported-by: syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com
> Cc: David Miller <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> ---
>  net/core/net-sysfs.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 865ba6ca16eb..72ecad583953 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1626,6 +1626,12 @@ static void netdev_release(struct device *d)
>  {
>  	struct net_device *dev = to_net_dev(d);
>  
> +	/* Triggered by an error clean-up (put_device) during
> +	 * initialization.
> +	 */
> +	if (dev->reg_state == NETREG_UNINITIALIZED)
> +		return;
> +

Are you sure about this?  What about the memory involved here, what will
free that?

>  	BUG_ON(dev->reg_state != NETREG_RELEASED);
>  
>  	/* no need to wait for rcu grace period:
> @@ -1745,16 +1751,21 @@ int netdev_register_kobject(struct net_device *ndev)
>  
>  	error = device_add(dev);
>  	if (error)
> -		return error;
> +		goto err_device_add;
>  
>  	error = register_queue_kobjects(ndev);
> -	if (error) {
> -		device_del(dev);
> -		return error;
> -	}
> +	if (error)
> +		goto err_register_queue_kobjects;
>  
>  	pm_runtime_set_memalloc_noio(dev, true);
>  
> +	return error;
> +
> +err_register_queue_kobjects:
> +	device_del(dev);
> +err_device_add:
> +	put_device(dev);
> +
>  	return error;
>  }
>  
> -- 
> 2.17.1

The rest of the patch looks sane to me from a "uses the driver api
correctly now" point of view.  But I don't know the lifetime rules of
the netdev structure enough to say if that check for the reg_state is
correct or not.

thanks,

greg k-h
