Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A4622187
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiKICAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiKICAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201EA27FCE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDDB1B81CF0
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75FA3C43470;
        Wed,  9 Nov 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959215;
        bh=H4ynSPMNh/6JcFCpYdJGj7QO/rSVXMsT904XguDui/0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HaPZr23U9VvUWB8SJxO/oyCShJFWM9nOHi5YwiVAkjRf3bVPtDd6UXQ1E5wdJF9PS
         v1csRVRDZmJ59P/7yp2R5kARMbkloc4DJL/ilNFnQAuAuEar0dgz+eEvwqd2fekbVS
         fyFiVfX6aZ1FVE5eDXfLFp3iKudAvAlqSPpx5z+Goabu30sHTndXgtCJv346VPX30F
         t1Tpim5QQy4Y/w2fp4XnPyiGfvY5Ve89qJcDyCz5P7rOwDIAypsim0A/pQo6xZaj2U
         DdMHh/j2KQ8bcdYbv7mIakfxdI4SmvEKf09je7oGal8iE6ftRz6tdpUveb6clCwiK5
         zihLJ0ZLnhEKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4AA9AE29F4B;
        Wed,  9 Nov 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: tun: call napi_schedule_prep() to ensure we own a
 napi
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166795921530.12027.13095782064380883724.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 02:00:15 +0000
References: <20221107180011.188437-1-edumazet@google.com>
In-Reply-To: <20221107180011.188437-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, wangyufen@huawei.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Nov 2022 18:00:11 +0000 you wrote:
> A recent patch exposed another issue in napi_get_frags()
> caught by syzbot [1]
> 
> Before feeding packets to GRO, and calling napi_complete()
> we must first grab NAPI_STATE_SCHED.
> 
> [1]
> WARNING: CPU: 0 PID: 3612 at net/core/dev.c:6076 napi_complete_done+0x45b/0x880 net/core/dev.c:6076
> Modules linked in:
> CPU: 0 PID: 3612 Comm: syz-executor408 Not tainted 6.1.0-rc3-syzkaller-00175-g1118b2049d77 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:napi_complete_done+0x45b/0x880 net/core/dev.c:6076
> Code: c1 ea 03 0f b6 14 02 4c 89 f0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 24 04 00 00 41 89 5d 1c e9 73 fc ff ff e8 b5 53 22 fa <0f> 0b e9 82 fe ff ff e8 a9 53 22 fa 48 8b 5c 24 08 31 ff 48 89 de
> RSP: 0018:ffffc90003c4f920 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000030 RCX: 0000000000000000
> RDX: ffff8880251c0000 RSI: ffffffff875a58db RDI: 0000000000000007
> RBP: 0000000000000001 R08: 0000000000000007 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: ffff888072d02628
> R13: ffff888072d02618 R14: ffff888072d02634 R15: 0000000000000000
> FS: 0000555555f13300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055c44d3892b8 CR3: 00000000172d2000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> napi_complete include/linux/netdevice.h:510 [inline]
> tun_get_user+0x206d/0x3a60 drivers/net/tun.c:1980
> tun_chr_write_iter+0xdb/0x200 drivers/net/tun.c:2027
> call_write_iter include/linux/fs.h:2191 [inline]
> do_iter_readv_writev+0x20b/0x3b0 fs/read_write.c:735
> do_iter_write+0x182/0x700 fs/read_write.c:861
> vfs_writev+0x1aa/0x630 fs/read_write.c:934
> do_writev+0x133/0x2f0 fs/read_write.c:977
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f37021a3c19
> 
> [...]

Here is the summary with links:
  - [net] net: tun: call napi_schedule_prep() to ensure we own a napi
    https://git.kernel.org/netdev/net/c/07d120aa33cc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


