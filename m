Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8053861625F
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 13:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiKBMAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 08:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiKBMAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 08:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEF422B23;
        Wed,  2 Nov 2022 05:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A80F6192B;
        Wed,  2 Nov 2022 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEB83C433D7;
        Wed,  2 Nov 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667390415;
        bh=oAHzqYx20UrAXdLzaz44Mlipva+q7W5GffCvEeIv77I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hJtb2ZhwW47lvm+6gT1/ScMDKdZq/sQUHDpVhO3Qn1ADsrj7IP3rY0sdHES/G/T4U
         CskGeSq847JrIhaVEazFupFXU7q7Y1JOQuqgPIgJ0ZJ5hB3Br9WOjlm6u/jmxbFjz5
         WmPouA9dhF6IakIihqDCS58aZJYPpbzorUWs5OUaPH8jWLqb1XKRnEEuWj3cAIViUK
         wb1RVxfeLoiH+n5ArJwfYvTrEn8s9mNxmHFdCsdaONKi3i6PEJu6zbgJdnR00GW20T
         IgSZ25dTMbYahR+NBit2FYuKstQU+m5Eq+INagKyPVhUb04F1AND6w5V1i+Tz4Evoq
         0UrICS8qOOEYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACABCE270D5;
        Wed,  2 Nov 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rose: Fix NULL pointer dereference in rose_send_frame()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166739041570.9516.15064436041668449705.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 12:00:15 +0000
References: <20221028161049.113625-1-zhangqilong3@huawei.com>
In-Reply-To: <20221028161049.113625-1-zhangqilong3@huawei.com>
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, f6bvp@free.fr,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 29 Oct 2022 00:10:49 +0800 you wrote:
> The syzkaller reported an issue:
> 
> KASAN: null-ptr-deref in range [0x0000000000000380-0x0000000000000387]
> CPU: 0 PID: 4069 Comm: kworker/0:15 Not tainted 6.0.0-syzkaller-02734-g0326074ff465 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
> Workqueue: rcu_gp srcu_invoke_callbacks
> RIP: 0010:rose_send_frame+0x1dd/0x2f0 net/rose/rose_link.c:101
> Call Trace:
>  <IRQ>
>  rose_transmit_clear_request+0x1d5/0x290 net/rose/rose_link.c:255
>  rose_rx_call_request+0x4c0/0x1bc0 net/rose/af_rose.c:1009
>  rose_loopback_timer+0x19e/0x590 net/rose/rose_loopback.c:111
>  call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
>  expire_timers kernel/time/timer.c:1519 [inline]
>  __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
>  __run_timers kernel/time/timer.c:1768 [inline]
>  run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
>  __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
>  [...]
>  </IRQ>
> 
> [...]

Here is the summary with links:
  - rose: Fix NULL pointer dereference in rose_send_frame()
    https://git.kernel.org/netdev/net/c/e97c089d7a49

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


