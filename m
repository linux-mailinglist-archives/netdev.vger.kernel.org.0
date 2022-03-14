Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904E44D8E33
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245058AbiCNUb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbiCNUbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:31:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AF239822
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 13:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E34CE612B4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 20:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4358CC36AE7;
        Mon, 14 Mar 2022 20:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647289811;
        bh=dk2doHa/i/uGwNcCn9GtoF6Acp3nRspghAJP7unPOic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dVNLMwCG+2tt7LxlpZyB7kTwE7KXIdDey9IbR9A9R89w1UfGamlNUzVxJjz81DkIU
         5PDgmw1RC68fmaaPgex2F9P6a/OZfJyYPQ6h55LWfdLThLDukrXLB5Mc5xkO0A75hk
         KPv2tmuj3eDYmXmS4MZFRvMWNjpb+08v4NpqxyB4yRmfOpr2CeEaylVPrfhW6OrUQ+
         n5kpl3zbxXMfRb9a57XfqMDDXy/hWMgkgJv+QlLQ9KclcJgfEYPZL2ep8OkaFFMAWY
         AVX86BqiwpHxVnyySHgGoN2wy3w9OHtCtcsCxZR5j1MKjUGwWDsbpdBLxPlo+XdnsA
         bdNLMHRg7kw7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1CC36EAC09C;
        Mon, 14 Mar 2022 20:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: disable preemption in dev_core_stats_XXX_inc()
 helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164728981111.21494.4878273308182979524.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 20:30:11 +0000
References: <20220312214505.3294762-1-eric.dumazet@gmail.com>
In-Reply-To: <20220312214505.3294762-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, jeffreyji@google.com, brianvv@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 12 Mar 2022 13:45:05 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot was kind enough to remind us that dev->{tx_dropped|rx_dropped}
> could be increased in process context.
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor413/3593
> caller is netdev_core_stats_alloc+0x98/0x110 net/core/dev.c:10298
> CPU: 1 PID: 3593 Comm: syz-executor413 Not tainted 5.17.0-rc7-syzkaller-02426-g97aeb877de7f #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  check_preemption_disabled+0x16b/0x170 lib/smp_processor_id.c:49
>  netdev_core_stats_alloc+0x98/0x110 net/core/dev.c:10298
>  dev_core_stats include/linux/netdevice.h:3855 [inline]
>  dev_core_stats_rx_dropped_inc include/linux/netdevice.h:3866 [inline]
>  tun_get_user+0x3455/0x3ab0 drivers/net/tun.c:1800
>  tun_chr_write_iter+0xe1/0x200 drivers/net/tun.c:2015
>  call_write_iter include/linux/fs.h:2074 [inline]
>  new_sync_write+0x431/0x660 fs/read_write.c:503
>  vfs_write+0x7cd/0xae0 fs/read_write.c:590
>  ksys_write+0x12d/0x250 fs/read_write.c:643
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f2cf4f887e3
> Code: 5d 41 5c 41 5d 41 5e e9 9b fd ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 18
> RSP: 002b:00007ffd50dd5fd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007ffd50dd6000 RCX: 00007f2cf4f887e3
> RDX: 000000000000002a RSI: 0000000000000000 RDI: 00000000000000c8
> RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffd50dd5ff0 R14: 00007ffd50dd5fe8 R15: 00007ffd50dd5fe4
>  </TASK>
> 
> [...]

Here is the summary with links:
  - [net-next] net: disable preemption in dev_core_stats_XXX_inc() helpers
    https://git.kernel.org/netdev/net-next/c/fc93db153b01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


