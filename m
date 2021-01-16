Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9BB2F8AB2
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 03:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbhAPCUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 21:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbhAPCUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 21:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 99D102256F;
        Sat, 16 Jan 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610763608;
        bh=Q3S7/6a5L79Pck139EqvAQXOgSScRd4VYzlsyRaGaAs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CiDdK5OIthw4JO6NPn7HD9pv/dztZg7UcmkIPAp7thKG3ifRw5jiHGYvQ9DCgec3X
         4bEz9tjMKufau7XNh+dAlKVgMdvTQhnov9UykL3bLa1LUwNDHxUwwudwy7DKrz4GYO
         YrHBab3b4ZMZ76FpnBOZTvBczGnO4KDC3QtD1vjy5HvRC8CeL+3Wv8FB0GfnC5h3VE
         ZlfSI5K4CbVzulES+YSGubOs8Xe6x+e1CGDk9Yr++PJPnOE29ax8qkd/mwJ7WbokAa
         84QvF2b2TvwDqWwvXiwW7xIVFWbDDdMPPeuMjl3QOx7XpLJ/BjHZyFEV5C12M1tqB9
         Ba5WiucjjfOLw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 8C2E26017C;
        Sat, 16 Jan 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net_sched: avoid shift-out-of-bounds in
 tcindex_set_parms()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161076360856.6674.16961085253289564188.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 02:20:08 +0000
References: <20210114185229.1742255-1-eric.dumazet@gmail.com>
In-Reply-To: <20210114185229.1742255-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 14 Jan 2021 10:52:29 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> tc_index being 16bit wide, we need to check that TCA_TCINDEX_SHIFT
> attribute is not silly.
> 
> UBSAN: shift-out-of-bounds in net/sched/cls_tcindex.c:260:29
> shift exponent 255 is too large for 32-bit type 'int'
> CPU: 0 PID: 8516 Comm: syz-executor228 Not tainted 5.10.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
>  valid_perfect_hash net/sched/cls_tcindex.c:260 [inline]
>  tcindex_set_parms.cold+0x1b/0x215 net/sched/cls_tcindex.c:425
>  tcindex_change+0x232/0x340 net/sched/cls_tcindex.c:546
>  tc_new_tfilter+0x13fb/0x21b0 net/sched/cls_api.c:2127
>  rtnetlink_rcv_msg+0x8b6/0xb80 net/core/rtnetlink.c:5555
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2336
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2390
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2423
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [...]

Here is the summary with links:
  - [net] net_sched: avoid shift-out-of-bounds in tcindex_set_parms()
    https://git.kernel.org/netdev/net/c/bcd0cf19ef82

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


