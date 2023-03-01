Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEA86A721A
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 18:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjCARa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 12:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjCARaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 12:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6D338019
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 09:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E257061448
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26635C433A1;
        Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677691818;
        bh=1D2DKZUbyhTARWnBN9VpTB6U0EfzPzts+he3a5YBXm0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jy2MxaIDAjL0ttd+f6SZJry9aLdHsl0fKNei5rxj6AOHUxaB2055Y/kOiJ91Xl1AY
         qmA7LCthIjZgq3t41RFWXawUEJIxVCd02JN3Sg2JXlPBMoBmdi8CWRDubrP0g93lcy
         K+RnSbb46819NaAQVW7Clsg04aqfvAn6k5boYvk5td6ff4kWJyNgly6sFKK6Asnubb
         /v38SKG5yv4yHJ+5UumX3GsIxZwUOhJp1hwwdPxmmlB1DJWlRuzf8nXhh3kze2+1BO
         QWPKUXhw3MlKtO0UwluOCu6qlsNr4AG6eL2GHKhBdqSoqri13WpylPNH/XdoE9BOW0
         /ms9IhvtV3mlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A594E450AC;
        Wed,  1 Mar 2023 17:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ila: do not generate empty messages in
 ila_xlat_nl_cmd_get_mapping()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167769181803.25108.5708719508540281700.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Mar 2023 17:30:18 +0000
References: <20230227153024.526366-1-edumazet@google.com>
In-Reply-To: <20230227153024.526366-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Feb 2023 15:30:24 +0000 you wrote:
> ila_xlat_nl_cmd_get_mapping() generates an empty skb,
> triggerring a recent sanity check [1].
> 
> Instead, return an error code, so that user space
> can get it.
> 
> [1]
> skb_assert_len
> WARNING: CPU: 0 PID: 5923 at include/linux/skbuff.h:2527 skb_assert_len include/linux/skbuff.h:2527 [inline]
> WARNING: CPU: 0 PID: 5923 at include/linux/skbuff.h:2527 __dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
> Modules linked in:
> CPU: 0 PID: 5923 Comm: syz-executor269 Not tainted 6.2.0-syzkaller-18300-g2ebd1fbb946d #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
> pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : skb_assert_len include/linux/skbuff.h:2527 [inline]
> pc : __dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
> lr : skb_assert_len include/linux/skbuff.h:2527 [inline]
> lr : __dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
> sp : ffff80001e0d6c40
> x29: ffff80001e0d6e60 x28: dfff800000000000 x27: ffff0000c86328c0
> x26: dfff800000000000 x25: ffff0000c8632990 x24: ffff0000c8632a00
> x23: 0000000000000000 x22: 1fffe000190c6542 x21: ffff0000c8632a10
> x20: ffff0000c8632a00 x19: ffff80001856e000 x18: ffff80001e0d5fc0
> x17: 0000000000000000 x16: ffff80001235d16c x15: 0000000000000000
> x14: 0000000000000000 x13: 0000000000000001 x12: 0000000000000001
> x11: ff80800008353a30 x10: 0000000000000000 x9 : 21567eaf25bfb600
> x8 : 21567eaf25bfb600 x7 : 0000000000000001 x6 : 0000000000000001
> x5 : ffff80001e0d6558 x4 : ffff800015c74760 x3 : ffff800008596744
> x2 : 0000000000000001 x1 : 0000000100000000 x0 : 000000000000000e
> Call trace:
> skb_assert_len include/linux/skbuff.h:2527 [inline]
> __dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
> dev_queue_xmit include/linux/netdevice.h:3033 [inline]
> __netlink_deliver_tap_skb net/netlink/af_netlink.c:307 [inline]
> __netlink_deliver_tap+0x45c/0x6f8 net/netlink/af_netlink.c:325
> netlink_deliver_tap+0xf4/0x174 net/netlink/af_netlink.c:338
> __netlink_sendskb net/netlink/af_netlink.c:1283 [inline]
> netlink_sendskb+0x6c/0x154 net/netlink/af_netlink.c:1292
> netlink_unicast+0x334/0x8d4 net/netlink/af_netlink.c:1380
> nlmsg_unicast include/net/netlink.h:1099 [inline]
> genlmsg_unicast include/net/genetlink.h:433 [inline]
> genlmsg_reply include/net/genetlink.h:443 [inline]
> ila_xlat_nl_cmd_get_mapping+0x620/0x7d0 net/ipv6/ila/ila_xlat.c:493
> genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
> genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
> genl_rcv_msg+0x938/0xc1c net/netlink/genetlink.c:1065
> netlink_rcv_skb+0x214/0x3c4 net/netlink/af_netlink.c:2574
> genl_rcv+0x38/0x50 net/netlink/genetlink.c:1076
> netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> netlink_unicast+0x660/0x8d4 net/netlink/af_netlink.c:1365
> netlink_sendmsg+0x800/0xae0 net/netlink/af_netlink.c:1942
> sock_sendmsg_nosec net/socket.c:714 [inline]
> sock_sendmsg net/socket.c:734 [inline]
> ____sys_sendmsg+0x558/0x844 net/socket.c:2479
> ___sys_sendmsg net/socket.c:2533 [inline]
> __sys_sendmsg+0x26c/0x33c net/socket.c:2562
> __do_sys_sendmsg net/socket.c:2571 [inline]
> __se_sys_sendmsg net/socket.c:2569 [inline]
> __arm64_sys_sendmsg+0x80/0x94 net/socket.c:2569
> __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
> invoke_syscall+0x98/0x2c0 arch/arm64/kernel/syscall.c:52
> el0_svc_common+0x138/0x258 arch/arm64/kernel/syscall.c:142
> do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:193
> el0_svc+0x58/0x168 arch/arm64/kernel/entry-common.c:637
> el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
> el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
> irq event stamp: 136484
> hardirqs last enabled at (136483): [<ffff800008350244>] __up_console_sem+0x60/0xb4 kernel/printk/printk.c:345
> hardirqs last disabled at (136484): [<ffff800012358d60>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
> softirqs last enabled at (136418): [<ffff800008020ea8>] softirq_handle_end kernel/softirq.c:414 [inline]
> softirqs last enabled at (136418): [<ffff800008020ea8>] __do_softirq+0xd4c/0xfa4 kernel/softirq.c:600
> softirqs last disabled at (136371): [<ffff80000802b4a4>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
> 
> [...]

Here is the summary with links:
  - [net] ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()
    https://git.kernel.org/netdev/net/c/693aa2c0d9b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


