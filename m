Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806C7656157
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 10:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiLZJAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 04:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLZJAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 04:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8145F7D;
        Mon, 26 Dec 2022 01:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01B7560B8F;
        Mon, 26 Dec 2022 09:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F589C433F0;
        Mon, 26 Dec 2022 09:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672045215;
        bh=aW1vkecizWIHtiL9a+UN5zp/QTLiUP7WrL/EJI9w0W4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F910tTiJ0BUsEk6oc+XqMSSC+dBshMn7X2/zvoDE/7yM3LnaMqKOLv6MGrSx1WwZb
         xmjyY8rTAYFbg7WPgemJ4gUXlwtQ0aXHD+YJ72a+zRlEUImMoebzBsu9mXKNsubT/Y
         TJNzsbv3vizUdpqbm/W465Bui4R/MIzyTWB5lYKS1tR87dWuRWtGxEM3U7301q5u7P
         bNjtWG9MkbQarLOLYmPjHAHXFg/yGEofZr1ybvLCIVLW6NIxFfiS/jUMEjuqdkzvMg
         3+Nkon/ZHJFXzHpXbhTGaCD/ZxvO/8fmf8boEEHwPlKK0ezsuU5gggRYCmRcZXSQCA
         s1ekmmELC8IwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BA24C43159;
        Mon, 26 Dec 2022 09:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: sched: fix memory leak in tcindex_set_parms
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167204521517.19910.6310914488260275084.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Dec 2022 09:00:15 +0000
References: <20221222035119.7118-1-yin31149@gmail.com>
In-Reply-To: <20221222035119.7118-1-yin31149@gmail.com>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, 18801353760@163.com, cong.wang@bytedance.com,
        dvyukov@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
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

On Thu, 22 Dec 2022 11:51:19 +0800 you wrote:
> Syzkaller reports a memory leak as follows:
> ====================================
> BUG: memory leak
> unreferenced object 0xffff88810c287f00 (size 256):
>   comm "syz-executor105", pid 3600, jiffies 4294943292 (age 12.990s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
>     [<ffffffff839c9e07>] kmalloc include/linux/slab.h:576 [inline]
>     [<ffffffff839c9e07>] kmalloc_array include/linux/slab.h:627 [inline]
>     [<ffffffff839c9e07>] kcalloc include/linux/slab.h:659 [inline]
>     [<ffffffff839c9e07>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
>     [<ffffffff839c9e07>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
>     [<ffffffff839caa1f>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
>     [<ffffffff8394db62>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
>     [<ffffffff8389e91c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
>     [<ffffffff839eba67>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
>     [<ffffffff839eab87>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>     [<ffffffff839eab87>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
>     [<ffffffff839eb046>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
>     [<ffffffff8383e796>] sock_sendmsg_nosec net/socket.c:714 [inline]
>     [<ffffffff8383e796>] sock_sendmsg+0x56/0x80 net/socket.c:734
>     [<ffffffff8383eb08>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
>     [<ffffffff83843678>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
>     [<ffffffff838439c5>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
>     [<ffffffff83843c14>] __do_sys_sendmmsg net/socket.c:2651 [inline]
>     [<ffffffff83843c14>] __se_sys_sendmmsg net/socket.c:2648 [inline]
>     [<ffffffff83843c14>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
>     [<ffffffff84605fd5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<ffffffff84605fd5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> ====================================
> 
> [...]

Here is the summary with links:
  - [v4] net: sched: fix memory leak in tcindex_set_parms
    https://git.kernel.org/netdev/net/c/399ab7fe0fa0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


