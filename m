Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62823A018C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbhFHSyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236035AbhFHSv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 14:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4776261574;
        Tue,  8 Jun 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623177604;
        bh=QD5WelL3+iLupAwDt5GfnrifVIUvQha75j6Kyi8h2Oo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VFKcpI6K3R7YhT2PxFwJdhS8tRP/4rH6wGwDFArZS9YT+h/L5juJCgTWOZBIkYcON
         dbOqx/GbaIWeT3cFVDOZGE8tCZoSEv6FZ7m4qNdEiEoTK4TIVkG2At/EmaEQNaNKrC
         MJTZLHS6Mzif4DH+SocZwtm+FWd1IMQD4XDKjL6cQPpgBa+D3yzm0Me0eKXAUFmVTa
         NRxLLS1qrbjOvY4u4qxHEflfqxaO0UOsk1VPQmMRvrinV9tjbhqLeKxEY63MqMMXZQ
         z8skbWvaQBfLaIXO5evmdf8gMO/ThZ90pUVXVFRXli02OCFN9Ep2pSeeIBv9ohVFBD
         iIBFsN7a5fPvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 399B660BE1;
        Tue,  8 Jun 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipv4: fix memory leak in netlbl_cipsov4_add_std
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162317760423.20688.10311638397902674413.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 18:40:04 +0000
References: <20210608015158.3848878-1-sunnanyong@huawei.com>
In-Reply-To: <20210608015158.3848878-1-sunnanyong@huawei.com>
To:     Nanyong Sun <sunnanyong@huawei.com>
Cc:     paul@paul-moore.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 8 Jun 2021 09:51:58 +0800 you wrote:
> Reported by syzkaller:
> BUG: memory leak
> unreferenced object 0xffff888105df7000 (size 64):
> comm "syz-executor842", pid 360, jiffies 4294824824 (age 22.546s)
> hex dump (first 32 bytes):
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> backtrace:
> [<00000000e67ed558>] kmalloc include/linux/slab.h:590 [inline]
> [<00000000e67ed558>] kzalloc include/linux/slab.h:720 [inline]
> [<00000000e67ed558>] netlbl_cipsov4_add_std net/netlabel/netlabel_cipso_v4.c:145 [inline]
> [<00000000e67ed558>] netlbl_cipsov4_add+0x390/0x2340 net/netlabel/netlabel_cipso_v4.c:416
> [<0000000006040154>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320 net/netlink/genetlink.c:739
> [<00000000204d7a1c>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
> [<00000000204d7a1c>] genl_rcv_msg+0x2bf/0x4f0 net/netlink/genetlink.c:800
> [<00000000c0d6a995>] netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2504
> [<00000000d78b9d2c>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
> [<000000009733081b>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> [<000000009733081b>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1340
> [<00000000d5fd43b8>] netlink_sendmsg+0x789/0xc70 net/netlink/af_netlink.c:1929
> [<000000000a2d1e40>] sock_sendmsg_nosec net/socket.c:654 [inline]
> [<000000000a2d1e40>] sock_sendmsg+0x139/0x170 net/socket.c:674
> [<00000000321d1969>] ____sys_sendmsg+0x658/0x7d0 net/socket.c:2350
> [<00000000964e16bc>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2404
> [<000000001615e288>] __sys_sendmsg+0xd3/0x190 net/socket.c:2433
> [<000000004ee8b6a5>] do_syscall_64+0x37/0x90 arch/x86/entry/common.c:47
> [<00000000171c7cee>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> [...]

Here is the summary with links:
  - net: ipv4: fix memory leak in netlbl_cipsov4_add_std
    https://git.kernel.org/netdev/net/c/d612c3f3fae2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


