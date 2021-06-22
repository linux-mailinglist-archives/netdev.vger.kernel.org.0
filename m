Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F72E3B0AF9
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhFVRCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhFVRCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2CC946128C;
        Tue, 22 Jun 2021 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624381204;
        bh=0w4TSVsKjotTn6A06ndjkEj1CrbGiIcN7W4wMOLaBxo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lrfMUhSydQycQo6/Z0i40pV0I7TVCz0bEOXlt6GJ+xNmqEhgkZUvyjCfNNf/gFu0y
         I5tAAIi+CdmsV0OrroZZb7YNbBmybNbFVdHgaydAe+fJOn4RW+6fYRqACWiRCx3Svk
         HvLMBlsYmOhP1LsM3lL7EeCQDN0G9yUodNsOr5fKjSLMv26Dk+2dqBko7/lMzF3l45
         q2uCw92jpZ7zMyixOoP+JZpT6+5m1wL70ReTYK7mJUHA6SkJsRlJfxyb+34aG2khdo
         0bICvwTXGlDgVMgqg1Eicv7b0e2fML7Eymg5Nmrj4OGcr2fehZ2B2//vaY3W0melc6
         TZgHf38kznsLw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DE9960A6C;
        Tue, 22 Jun 2021 17:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] virtio/vsock: avoid NULL deref in
 virtio_transport_seqpacket_allow()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438120411.6164.4901219207131931593.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:00:04 +0000
References: <20210621145348.695341-1-eric.dumazet@gmail.com>
In-Reply-To: <20210621145348.695341-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, arseny.krasnov@kaspersky.com,
        syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 07:53:48 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Make sure the_virtio_vsock is not NULL before dereferencing it.
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000071: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000388-0x000000000000038f]
> CPU: 0 PID: 8452 Comm: syz-executor406 Not tainted 5.13.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:virtio_transport_seqpacket_allow+0xbf/0x210 net/vmw_vsock/virtio_transport.c:503
> Code: e8 c6 d9 ab f8 84 db 0f 84 0f 01 00 00 e8 09 d3 ab f8 48 8d bd 88 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 06 0f 8e 2a 01 00 00 44 0f b6 a5 88 03 00 00
> RSP: 0018:ffffc90003757c18 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 0000000000000071 RSI: ffffffff88c908e7 RDI: 0000000000000388
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff88c90a06 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffffff88c90840 R14: 0000000000000000 R15: 0000000000000001
> FS:  0000000001bee300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000082 CR3: 000000002847e000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  vsock_assign_transport+0x575/0x700 net/vmw_vsock/af_vsock.c:490
>  vsock_connect+0x200/0xc00 net/vmw_vsock/af_vsock.c:1337
>  __sys_connect_file+0x155/0x1a0 net/socket.c:1824
>  __sys_connect+0x161/0x190 net/socket.c:1841
>  __do_sys_connect net/socket.c:1851 [inline]
>  __se_sys_connect net/socket.c:1848 [inline]
>  __x64_sys_connect+0x6f/0xb0 net/socket.c:1848
>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43ee69
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd49e7c788 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ee69
> RDX: 0000000000000010 RSI: 0000000020000080 RDI: 0000000000000003
> RBP: 0000000000402e50 R08: 0000000000000000 R09: 0000000000400488
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402ee0
> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
> 
> [...]

Here is the summary with links:
  - [net-next] virtio/vsock: avoid NULL deref in virtio_transport_seqpacket_allow()
    https://git.kernel.org/netdev/net-next/c/64295f0d01ae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


