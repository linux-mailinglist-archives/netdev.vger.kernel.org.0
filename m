Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B473B9610
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhGASWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230014AbhGASWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:22:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 421896141F;
        Thu,  1 Jul 2021 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625163604;
        bh=lK+qvA4edPfTZh4V3PrT95wrog0orU75yT/YZQ4O6QA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lBSPqILGDoOeLC36xBYv6JriTGrHwjCJOPsvTMVc4MUEywZBVLEoH5FNzqTgBV2qg
         IQ4DZAyui4EmNfJYvbg5F6rHCpnRLqZieJE7ncbx7frDcloy7Y5rQJXCQ8Pm7RXQ2u
         kIP4GPnV3BttXRE3rdS4nmD82jLd8cZUmi9bbbDb5oPCkBWpn32iC8VizKFk8P5pxx
         +jZ9jPpWUd6azkj8KDSo0HX6yHl/eVT7NMjnhZ/pO9Cv4uZApvpeOtLz3Y4cz/ruJh
         zgxQRP/orq3khy5krNsCQ6c10lornk25/SZisUTmxzK2eeNSgh7hJGLvuawUDNj2FL
         ldK6VJI4sgnyw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 34B9460A56;
        Thu,  1 Jul 2021 18:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/802/mrp: fix memleak in mrp_request_join()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162516360421.12749.14576932158898469827.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 18:20:04 +0000
References: <20210629072237.991461-1-yangyingliang@huawei.com>
In-Reply-To: <20210629072237.991461-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 29 Jun 2021 15:22:37 +0800 you wrote:
> I got kmemleak report when doing fuzz test:
> 
> BUG: memory leak
> unreferenced object 0xffff88810c239500 (size 64):
> comm "syz-executor940", pid 882, jiffies 4294712870 (age 14.631s)
> hex dump (first 32 bytes):
> 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> 00 00 00 00 00 00 00 00 01 00 00 00 01 02 00 04 ................
> backtrace:
> [<00000000a323afa4>] slab_alloc_node mm/slub.c:2972 [inline]
> [<00000000a323afa4>] slab_alloc mm/slub.c:2980 [inline]
> [<00000000a323afa4>] __kmalloc+0x167/0x340 mm/slub.c:4130
> [<000000005034ca11>] kmalloc include/linux/slab.h:595 [inline]
> [<000000005034ca11>] mrp_attr_create net/802/mrp.c:276 [inline]
> [<000000005034ca11>] mrp_request_join+0x265/0x550 net/802/mrp.c:530
> [<00000000fcfd81f3>] vlan_mvrp_request_join+0x145/0x170 net/8021q/vlan_mvrp.c:40
> [<000000009258546e>] vlan_dev_open+0x477/0x890 net/8021q/vlan_dev.c:292
> [<0000000059acd82b>] __dev_open+0x281/0x410 net/core/dev.c:1609
> [<000000004e6dc695>] __dev_change_flags+0x424/0x560 net/core/dev.c:8767
> [<00000000471a09af>] rtnl_configure_link+0xd9/0x210 net/core/rtnetlink.c:3122
> [<0000000037a4672b>] __rtnl_newlink+0xe08/0x13e0 net/core/rtnetlink.c:3448
> [<000000008d5d0fda>] rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3488
> [<000000004882fe39>] rtnetlink_rcv_msg+0x369/0xa10 net/core/rtnetlink.c:5552
> [<00000000907e6c54>] netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2504
> [<00000000e7d7a8c4>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> [<00000000e7d7a8c4>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1340
> [<00000000e0645d50>] netlink_sendmsg+0x78e/0xc90 net/netlink/af_netlink.c:1929
> [<00000000c24559b7>] sock_sendmsg_nosec net/socket.c:654 [inline]
> [<00000000c24559b7>] sock_sendmsg+0x139/0x170 net/socket.c:674
> [<00000000fc210bc2>] ____sys_sendmsg+0x658/0x7d0 net/socket.c:2350
> [<00000000be4577b5>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2404
> 
> [...]

Here is the summary with links:
  - [net] net/802/mrp: fix memleak in mrp_request_join()
    https://git.kernel.org/netdev/net/c/996af62167d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


