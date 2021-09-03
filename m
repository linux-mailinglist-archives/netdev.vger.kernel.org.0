Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AB63FFEB3
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348839AbhICLLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234713AbhICLLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 07:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 98EB9610C8;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630667406;
        bh=YArepy833r2AStUclxTaPudv9UDRXYJrbgxsKWQ3fIw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r85WWH4Rl67aBnSyFpuCEeCj97AcRz6BjzQ9ZmeXClpt8CHcrcg35aqipIS4j+s0r
         yrrbvALWv3zs1JIGzcgCfsNW+FXpAu5nGRVeEn+BKgQ28g05lVrIIssEsHcKfPkEU+
         4sIwOXx3nK0a0YrHrxfnlm1/4hrJvKtCllKLefAiGuhnxj9mnXdaDfYj29e22sUs7h
         zqfO4QfD4kkuUpBZOZNvjtw69lBZygE1UvqFTp9QmRmy6AJ85l49rktlxU3GMFV7wY
         XBnKk/BJFONUfagLUlfYn/DWq1Cc4In3Q7lVDkwTD3fByRfhdUXmHBAxDCvIg0PLlZ
         IKhMRQ3m1Cl+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8F61460A3E;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mptcp: Only send extra TCP acks in eligible socket states
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163066740658.18620.16700027396845323471.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Sep 2021 11:10:06 +0000
References: <20210902185119.283187-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210902185119.283187-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 11:51:19 -0700 you wrote:
> Recent changes exposed a bug where specifically-timed requests to the
> path manager netlink API could trigger a divide-by-zero in
> __tcp_select_window(), as syzkaller does:
> 
> divide error: 0000 [#1] SMP KASAN NOPTI
> CPU: 0 PID: 9667 Comm: syz-executor.0 Not tainted 5.14.0-rc6+ #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:__tcp_select_window+0x509/0xa60 net/ipv4/tcp_output.c:3016
> Code: 44 89 ff e8 c9 29 e9 fd 45 39 e7 0f 8d 20 ff ff ff e8 db 28 e9 fd 44 89 e3 e9 13 ff ff ff e8 ce 28 e9 fd 44 89 e0 44 89 e3 99 <f7> 7c 24 04 29 d3 e9 fc fe ff ff e8 b7 28 e9 fd 44 89 f1 48 89 ea
> RSP: 0018:ffff888031ccf020 EFLAGS: 00010216
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000040000
> RDX: 0000000000000000 RSI: ffff88811532c080 RDI: 0000000000000002
> RBP: 0000000000000000 R08: ffffffff835807c2 R09: 0000000000000000
> R10: 0000000000000004 R11: ffffed1020b92441 R12: 0000000000000000
> R13: 1ffff11006399e08 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007fa4c8344700(0000) GS:ffff88811ae00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2f424000 CR3: 000000003e4e2003 CR4: 0000000000770ef0
> PKRU: 55555554
> Call Trace:
>  tcp_select_window net/ipv4/tcp_output.c:264 [inline]
>  __tcp_transmit_skb+0xc00/0x37a0 net/ipv4/tcp_output.c:1351
>  __tcp_send_ack.part.0+0x3ec/0x760 net/ipv4/tcp_output.c:3972
>  __tcp_send_ack net/ipv4/tcp_output.c:3978 [inline]
>  tcp_send_ack+0x7d/0xa0 net/ipv4/tcp_output.c:3978
>  mptcp_pm_nl_addr_send_ack+0x1ab/0x380 net/mptcp/pm_netlink.c:654
>  mptcp_pm_remove_addr+0x161/0x200 net/mptcp/pm.c:58
>  mptcp_nl_remove_id_zero_address+0x197/0x460 net/mptcp/pm_netlink.c:1328
>  mptcp_nl_cmd_del_addr+0x98b/0xd40 net/mptcp/pm_netlink.c:1359
>  genl_family_rcv_msg_doit.isra.0+0x225/0x340 net/netlink/genetlink.c:731
>  genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
>  genl_rcv_msg+0x341/0x5b0 net/netlink/genetlink.c:792
>  netlink_rcv_skb+0x148/0x430 net/netlink/af_netlink.c:2504
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>  netlink_unicast+0x537/0x750 net/netlink/af_netlink.c:1340
>  netlink_sendmsg+0x846/0xd80 net/netlink/af_netlink.c:1929
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg+0x14e/0x190 net/socket.c:724
>  ____sys_sendmsg+0x709/0x870 net/socket.c:2403
>  ___sys_sendmsg+0xff/0x170 net/socket.c:2457
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> [...]

Here is the summary with links:
  - [net] mptcp: Only send extra TCP acks in eligible socket states
    https://git.kernel.org/netdev/net/c/340fa6667a69

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


