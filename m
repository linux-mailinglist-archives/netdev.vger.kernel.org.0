Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42A76A9104
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 07:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCCGaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 01:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCCGaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 01:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CC713DCA;
        Thu,  2 Mar 2023 22:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA8636175A;
        Fri,  3 Mar 2023 06:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35F4FC4339E;
        Fri,  3 Mar 2023 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677825018;
        bh=v+TwSUQil/aZqPYrS+I1R19oIpBJBNyY6M6jyph2oWU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h9VtjC7VLhz+YfkMwDQJ3eoKiz2E7LCDy2Wz0YVpOWGevrQpVSVhH3Nv+UBf56bx+
         oKrlf2tXofP1gGkC73neqW5ew4VrqEigRYNFKCqvDjLn1lNnVcWqrH90uy0pDFUtHU
         0ISngIfGfjryIQ+1eHUeCJiSjdPDD9h3/Rr0FURURTl9lJObNYbBOrL+aQjoRw5ajc
         mw0COVmxiwqSDB5Y6DoZHe8OE3EvWgIrqw3pBTM6N1tyAEG/uyYtNlMVr7fqJ+36+B
         DEK+N4n57BcBGZrQ9pqFkM4o9GupW8AoR4BnRP7EDtZwPiLL7M824ZR4O80fTeeZG8
         jZsWRb6A0Cztw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12783E68D5F;
        Fri,  3 Mar 2023 06:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: caif: Fix use-after-free in
 cfusbl_device_notify()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167782501807.9922.6649287078886144648.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Mar 2023 06:30:18 +0000
References: <20230301163913.391304-1-syoshida@redhat.com>
In-Reply-To: <20230301163913.391304-1-syoshida@redhat.com>
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sjur.brandeland@stericsson.com,
        syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  2 Mar 2023 01:39:13 +0900 you wrote:
> syzbot reported use-after-free in cfusbl_device_notify() [1].  This
> causes a stack trace like below:
> 
> BUG: KASAN: use-after-free in cfusbl_device_notify+0x7c9/0x870 net/caif/caif_usb.c:138
> Read of size 8 at addr ffff88807ac4e6f0 by task kworker/u4:6/1214
> 
> CPU: 0 PID: 1214 Comm: kworker/u4:6 Not tainted 5.19.0-rc3-syzkaller-00146-g92f20ff72066 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: netns cleanup_net
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0xeb/0x467 mm/kasan/report.c:313
>  print_report mm/kasan/report.c:429 [inline]
>  kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
>  cfusbl_device_notify+0x7c9/0x870 net/caif/caif_usb.c:138
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
>  call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
>  call_netdevice_notifiers net/core/dev.c:1997 [inline]
>  netdev_wait_allrefs_any net/core/dev.c:10227 [inline]
>  netdev_run_todo+0xbc0/0x10f0 net/core/dev.c:10341
>  default_device_exit_batch+0x44e/0x590 net/core/dev.c:11334
>  ops_exit_list+0x125/0x170 net/core/net_namespace.c:167
>  cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
>  process_one_work+0x996/0x1610 kernel/workqueue.c:2289
>  worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>  kthread+0x2e9/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
>  </TASK>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: caif: Fix use-after-free in cfusbl_device_notify()
    https://git.kernel.org/netdev/net/c/9781e98a9711

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


