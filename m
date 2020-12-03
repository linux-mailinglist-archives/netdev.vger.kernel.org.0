Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9072CCB0D
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgLCAie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 19:38:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCAie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 19:38:34 -0500
Date:   Wed, 2 Dec 2020 16:37:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606955873;
        bh=+qdNWiIz1NQg7EMckAaTaz9++Gi00k3qkM5yvanGuHw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jfgs181wMKgjLy+0WwjaL8hp16ko2J/nCCEZJgAmZfAqZO6B79BVM1U/ZoA00DF8c
         9dbSY+BZAHnr8k2LpwEQAuvfcFctvJf1TWeHzhUGlIcsswXukY/f4UMIIHsRNucD7J
         keDp0CZSksq0VPSY4bDq7G+ZZkji5Hc4SXUJvPlUy4tBihGZoi9gllj/5Pt5RUoQr7
         UCKcbXrAavvXJwbmNy0GJo12Hdp5uE1OW2OJ61j7+pXHWYk/BHNxInR5BJImQgeTIX
         hSxw4FEjSaqcLkazVNmD++rxmPXNP/0rNbxArOa3SpAhED+ti8BwefVQFTRNNEgQcb
         n6N94QHUv6aLA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <toshiaki.makita1@gmail.com>, <rkovhaev@gmail.com>,
        <stephen@networkplumber.org>, <Jason@zx2c4.com>
Subject: Re: [PATCH net v3] net: fix memory leak in register_netdevice() on
 error path
Message-ID: <20201202163751.17b6fba2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201135457.3549435-1-yangyingliang@huawei.com>
References: <20201201135457.3549435-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 21:54:57 +0800 Yang Yingliang wrote:
> I got a memleak report when doing fault-inject test:
> 
> unreferenced object 0xffff88810ace9000 (size 1024):
>   comm "ip", pid 4622, jiffies 4295457037 (age 43.378s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000008abe41>] __kmalloc+0x10f/0x210
>     [<000000005d3533a6>] veth_dev_init+0x140/0x310
>     [<0000000088353c64>] register_netdevice+0x496/0x7a0
>     [<000000001324d322>] veth_newlink+0x40b/0x960
>     [<00000000d0799866>] __rtnl_newlink+0xd8c/0x1360
>     [<00000000d616040a>] rtnl_newlink+0x6b/0xa0
>     [<00000000e0a1600d>] rtnetlink_rcv_msg+0x3cc/0x9e0
>     [<000000009eeff98b>] netlink_rcv_skb+0x130/0x3a0
>     [<00000000500f8be1>] netlink_unicast+0x4da/0x700
>     [<00000000666c03b3>] netlink_sendmsg+0x7fe/0xcb0
>     [<0000000073b28103>] sock_sendmsg+0x143/0x180
>     [<00000000ad746a30>] ____sys_sendmsg+0x677/0x810
>     [<0000000087dd98e5>] ___sys_sendmsg+0x105/0x180
>     [<00000000028dd365>] __sys_sendmsg+0xf0/0x1c0
>     [<00000000a6bfbae6>] do_syscall_64+0x33/0x40
>     [<00000000e00521b4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> It seems ifb and loopback may also hit the leak, so I try to fix this in
> register_netdevice().
> 
> In common case, priv_destructor() will be called in netdev_run_todo()
> after calling ndo_uninit() in rollback_registered(), on other error
> path in register_netdevice(), ndo_uninit() and priv_destructor() are
> called before register_netdevice() return, but in this case,
> priv_destructor() will never be called, then it causes memory leak,
> so we should call priv_destructor() here.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2 -> v3: In wireguard driver, priv_destructor() will call
> free_netdev(), but it is assigned after register_netdevice(),
> so it will not lead a double free, drop patch#1. Also I've
> test wireguard device, it's no memory leak on this error path.

Sorry I don't want to apply yet another wobbly workaround to this path.
I started hacking on a rework of the registration / free which will
solve this and all the other corner cases which are broken around here.
Stay tuned.
