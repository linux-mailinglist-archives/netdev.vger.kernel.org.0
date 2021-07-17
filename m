Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2053CC605
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 22:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbhGQUNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 16:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234456AbhGQUNB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Jul 2021 16:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C348610CB;
        Sat, 17 Jul 2021 20:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626552604;
        bh=58G3bkfAdDpmQjkclVgO3itgAWBLhreA00ReeKXWzkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=njnJ4JgPKdI71j9OcKrZok/F4TN5EbgnxdD1qUVAyXgpwpazW54Uq1+f2wusBTdqn
         rDkTRFpJEnCjSiztAOXIO+WUtEwkpuz0eJSr5wLATXDBqJ9VDEm0iKiAFMfSBEJWje
         UVS1M2tIuTM82r6bf6vaRtqsiu9TmaHXn7qmIt+08gE0nveJ843uHPSMoEoVXy/UnB
         Ca2JOraSw7HcWy9gSj6rZAVEYT6jJa6+EUA6PwMtlkEGLufMuZCdcznlVdSQYBVFe6
         mXlw41LIiMI2ddzh4hSilLDCw61gqMIlmp/sl6QwxHMZwlnlhFkPSoDDHygF5dFCYk
         80d/+4CRyEh/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6E49F609A3;
        Sat, 17 Jul 2021 20:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [next] igmp: Add ip_mc_list lock in ip_check_mc_rcu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162655260444.25874.8656754870810151576.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Jul 2021 20:10:04 +0000
References: <20210716040617.160609-1-liujian56@huawei.com>
In-Reply-To: <20210716040617.160609-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Jul 2021 12:06:17 +0800 you wrote:
> I got below panic when doing fuzz test:
> 
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 4056 Comm: syz-executor.3 Tainted: G    B             5.14.0-rc1-00195-gcff5c4254439-dirty #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> Call Trace:
> dump_stack_lvl+0x7a/0x9b
> panic+0x2cd/0x5af
> end_report.cold+0x5a/0x5a
> kasan_report+0xec/0x110
> ip_check_mc_rcu+0x556/0x5d0
> __mkroute_output+0x895/0x1740
> ip_route_output_key_hash_rcu+0x2d0/0x1050
> ip_route_output_key_hash+0x182/0x2e0
> ip_route_output_flow+0x28/0x130
> udp_sendmsg+0x165d/0x2280
> udpv6_sendmsg+0x121e/0x24f0
> inet6_sendmsg+0xf7/0x140
> sock_sendmsg+0xe9/0x180
> ____sys_sendmsg+0x2b8/0x7a0
> ___sys_sendmsg+0xf0/0x160
> __sys_sendmmsg+0x17e/0x3c0
> __x64_sys_sendmmsg+0x9e/0x100
> do_syscall_64+0x3b/0x90
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x462eb9
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8
>  48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48>
>  3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f3df5af1c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462eb9
> RDX: 0000000000000312 RSI: 0000000020001700 RDI: 0000000000000007
> RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f3df5af26bc
> R13: 00000000004c372d R14: 0000000000700b10 R15: 00000000ffffffff
> 
> [...]

Here is the summary with links:
  - [next] igmp: Add ip_mc_list lock in ip_check_mc_rcu
    https://git.kernel.org/netdev/net-next/c/23d2b94043ca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


