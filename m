Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC266979E4
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbjBOKa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbjBOKaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:30:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F74367DD
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 02:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6277FB81F90
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D251C433EF;
        Wed, 15 Feb 2023 10:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676457018;
        bh=EVG8gyxDqT/4Fba4aKMGEw8pLNpToWmUd3WAHgazfjc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gQqZmYq7dwwfKc/J2VDBuTxaYhNPq1nlIJXNShRf8jVEKoryv6EPDxTMbj/C4rjhT
         SnuF45CmQL9kJW80VJUN/9af9EIJB/ZUPuHrmN6ne6swWpikpoJJ6FB0UL3jzpyWI4
         oC+rkzihAt1JxeTKhzCKaXzfLZVByI7y/dKUSbJZGel/Q2jYcYy6ZeMhkO4aEUo7Mr
         S/TGRKep8olWuUGHAJaugeIlYnJETMBTQT6gMny43Nm7o3KqSIxrPgtVVMKKjePYZs
         44B+SKB8d95o4A7KKukp6myHvbLDoOeeIPFRGKw1dCiDPBXrFpGs8hz6q2Bi0LVms7
         CUVdmhi/319Eg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0237EE21EC4;
        Wed, 15 Feb 2023 10:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: tcindex: search key must be 16 bits
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167645701800.29620.1914956098431742896.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 10:30:18 +0000
References: <20230214014729.648564-1-pctammela@mojatatu.com>
In-Reply-To: <20230214014729.648564-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Feb 2023 22:47:29 -0300 you wrote:
> Syzkaller found an issue where a handle greater than 16 bits would trigger
> a null-ptr-deref in the imperfect hash area update.
> 
> general protection fault, probably for non-canonical address
> 0xdffffc0000000015: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
> CPU: 0 PID: 5070 Comm: syz-executor456 Not tainted
> 6.2.0-rc7-syzkaller-00112-gc68f345b7c42 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/21/2023
> RIP: 0010:tcindex_set_parms+0x1a6a/0x2990 net/sched/cls_tcindex.c:509
> Code: 01 e9 e9 fe ff ff 4c 8b bd 28 fe ff ff e8 0e 57 7d f9 48 8d bb
> a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c
> 02 00 0f 85 94 0c 00 00 48 8b 85 f8 fd ff ff 48 8b 9b a8 00
> RSP: 0018:ffffc90003d3ef88 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000015 RSI: ffffffff8803a102 RDI: 00000000000000a8
> RBP: ffffc90003d3f1d8 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff88801e2b10a8
> R13: dffffc0000000000 R14: 0000000000030000 R15: ffff888017b3be00
> FS: 00005555569af300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000056041c6d2000 CR3: 000000002bfca000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> tcindex_change+0x1ea/0x320 net/sched/cls_tcindex.c:572
> tc_new_tfilter+0x96e/0x2220 net/sched/cls_api.c:2155
> rtnetlink_rcv_msg+0x959/0xca0 net/core/rtnetlink.c:6132
> netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
> netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
> netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1942
> sock_sendmsg_nosec net/socket.c:714 [inline]
> sock_sendmsg+0xd3/0x120 net/socket.c:734
> ____sys_sendmsg+0x334/0x8c0 net/socket.c:2476
> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
> __sys_sendmmsg+0x18f/0x460 net/socket.c:2616
> __do_sys_sendmmsg net/socket.c:2645 [inline]
> __se_sys_sendmmsg net/socket.c:2642 [inline]
> __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2642
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> 
> [...]

Here is the summary with links:
  - [net] net/sched: tcindex: search key must be 16 bits
    https://git.kernel.org/netdev/net/c/42018a322bd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


