Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D168A6B561D
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 01:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjCKAAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 19:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjCKAAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 19:00:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB3BF6014;
        Fri, 10 Mar 2023 16:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A63961D7F;
        Sat, 11 Mar 2023 00:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C83FEC4339B;
        Sat, 11 Mar 2023 00:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678492818;
        bh=zf8Ylz3Hw8HYqz9JDe6oUvlgtpVyIBOE7kQt27FbQsM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E4+XI+JsuTuAQyAHdB2a2WJwZtCmCeDv+o1WXnuBEWBy+Bllr+aDIRve8LJNxlJnh
         DTCHyKNwQg/tEt/rTyU7X9xvU8WGXulv9pC4yD7tV6SkAcLPOzAyD3rggyofyyx3KA
         xhR/36TxiT2Hh+dxED1DEo8aHmo3natsFVoieREYsxj11LHahuGVyM6qe0ABbUNnio
         DBZYbxN4K9YynxwGfEM2Bo/wruFD+bdf5kOutqaiO+yadUdU2uFGksvn28uYIcCo1s
         q7LBXBTOLghphKzZaw2a5cUdm9HnboBJv2uZnKmDaMpZC3TGtb+/GOrI3TPqQQx1u9
         v3T0WvphFqI6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABC69E21EEA;
        Sat, 11 Mar 2023 00:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc: pn533: initialize struct pn533_out_arg properly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167849281870.3658.1472133083169115470.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 00:00:18 +0000
References: <20230309165050.207390-1-pchelkin@ispras.ru>
In-Reply-To: <20230309165050.207390-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     kuba@kernel.org, simon.horman@corigine.com,
        krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        linuxlovemin@yonsei.ac.kr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, khoroshilov@ispras.ru,
        lvc-project@linuxtesting.org,
        syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
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

On Thu,  9 Mar 2023 19:50:50 +0300 you wrote:
> struct pn533_out_arg used as a temporary context for out_urb is not
> initialized properly. Its uninitialized 'phy' field can be dereferenced in
> error cases inside pn533_out_complete() callback function. It causes the
> following failure:
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.2.0-rc3-next-20230110-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:pn533_out_complete.cold+0x15/0x44 drivers/nfc/pn533/usb.c:441
> Call Trace:
>  <IRQ>
>  __usb_hcd_giveback_urb+0x2b6/0x5c0 drivers/usb/core/hcd.c:1671
>  usb_hcd_giveback_urb+0x384/0x430 drivers/usb/core/hcd.c:1754
>  dummy_timer+0x1203/0x32d0 drivers/usb/gadget/udc/dummy_hcd.c:1988
>  call_timer_fn+0x1da/0x800 kernel/time/timer.c:1700
>  expire_timers+0x234/0x330 kernel/time/timer.c:1751
>  __run_timers kernel/time/timer.c:2022 [inline]
>  __run_timers kernel/time/timer.c:1995 [inline]
>  run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
>  __do_softirq+0x1fb/0xaf6 kernel/softirq.c:571
>  invoke_softirq kernel/softirq.c:445 [inline]
>  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
>  irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
>  sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
> 
> [...]

Here is the summary with links:
  - [v2] nfc: pn533: initialize struct pn533_out_arg properly
    https://git.kernel.org/netdev/net/c/484b7059796e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


