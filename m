Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52FA528293
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbiEPKuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiEPKuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67F4275D3
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 03:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7281D60F5F
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 10:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA52BC385B8;
        Mon, 16 May 2022 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652698211;
        bh=ImB4ek4wXtLm108b+Bw3jRfw/jDgWz+uyFOT03ctOCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rkT7SCNZaCe5j5VyOG9hN4/2cEXWdZbb4pMC5hOEDF7/JiyJ9bZ7lr3bYlMDFoOgi
         vU5o8SyIM2cqcvi3xQw4iKMl/u+wed6BvsNEmgwoS+rDHk0EIog8NE0E8HlxodO/nS
         donWPZWdWow7+Rbsr3Y5W5Wg2hhPxnnlOOAj/clW5yR/MuQEq+0EG3vuVQvsQR3zGd
         woGQuq7z6gMJkEmUOWuyqjVdvvslG0B6/4LzdGBimSKSYWekwzr+YgKoYlzh5rjQll
         kNxzfAxAAPqNjCeFMAMa1JeajyynYjlQDr0yHOeIjhzTmBUnOSIKVgM+ktg//lk+4h
         Dji2Fefh4MJCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEF56F03935;
        Mon, 16 May 2022 10:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_pedit: sanitize shift argument before
 usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269821177.15644.10498593146539677173.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 10:50:11 +0000
References: <a6bca963dca72d5ffeb811a254a4f6415ac7ff74.1652433977.git.pabeni@redhat.com>
In-Reply-To: <a6bca963dca72d5ffeb811a254a4f6415ac7ff74.1652433977.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 13 May 2022 11:27:06 +0200 you wrote:
> syzbot was able to trigger an Out-of-Bound on the pedit action:
> 
> UBSAN: shift-out-of-bounds in net/sched/act_pedit.c:238:43
> shift exponent 1400735974 is too large for 32-bit type 'unsigned int'
> CPU: 0 PID: 3606 Comm: syz-executor151 Not tainted 5.18.0-rc5-syzkaller-00165-g810c2f0a3f86 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  ubsan_epilogue+0xb/0x50 lib/ubsan.c:151
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x187 lib/ubsan.c:322
>  tcf_pedit_init.cold+0x1a/0x1f net/sched/act_pedit.c:238
>  tcf_action_init_1+0x414/0x690 net/sched/act_api.c:1367
>  tcf_action_init+0x530/0x8d0 net/sched/act_api.c:1432
>  tcf_action_add+0xf9/0x480 net/sched/act_api.c:1956
>  tc_ctl_action+0x346/0x470 net/sched/act_api.c:2015
>  rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5993
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:725
>  ____sys_sendmsg+0x6e2/0x800 net/socket.c:2413
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fe36e9e1b59
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffef796fe88 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe36e9e1b59
> RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
> RBP: 00007fe36e9a5d00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe36e9a5d90
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_pedit: sanitize shift argument before usage
    https://git.kernel.org/netdev/net/c/4d42d54a7d6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


