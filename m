Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158C061F206
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 12:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiKGLkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 06:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiKGLkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 06:40:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5F417073;
        Mon,  7 Nov 2022 03:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B21BB60FEA;
        Mon,  7 Nov 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FF61C43149;
        Mon,  7 Nov 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667821215;
        bh=uyKa6thWYOi+pSLxPXNesIPp24xJss1TiFxR0opfLXc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lL0Toaw5wX9t2xwmF0mtF47cbC/s9aCq7bQGjwwmcxrU/1IMSBxCquLrqac1b5lsy
         7Crh42y4VsDq5LnG8DpaESHZHvp4mA6ajnGVN1KvIXK1PhjtdcAGe+dyyou9sAs6pr
         phDjRYzraClHOGdfXIGDZM8jzy+ihc67yRKbfqfn4CX7t8D6o1sP2kKlhE5uLCgbg+
         p8mNa0EniMIAiSwraAhAt3KuOqWHzcCt8BxivE6A9rhmP0N/r3ULL8bDy/L4qZAfkP
         f7T35+OFly4FZy9TQ1xp02nezBfgYonItYmIDHJ8ol9uxG/MCcqvxQwYOXGbtA5zCt
         +bEmudeY6jMNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06153C41671;
        Mon,  7 Nov 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net v5] tcp: prohibit TCP_REPAIR_OPTIONS if data was already
 sent
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166782121501.20740.4899813037394312629.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 11:40:15 +0000
References: <20221104022723.1066429-1-luwei32@huawei.com>
In-Reply-To: <20221104022723.1066429-1-luwei32@huawei.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        xemul@parallels.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, 4 Nov 2022 10:27:23 +0800 you wrote:
> If setsockopt with option name of TCP_REPAIR_OPTIONS and opt_code
> of TCPOPT_SACK_PERM is called to enable sack after data is sent
> and dupacks are received , it will trigger a warning in function
> tcp_verify_left_out() as follows:
> 
> ============================================
> WARNING: CPU: 8 PID: 0 at net/ipv4/tcp_input.c:2132
> tcp_timeout_mark_lost+0x154/0x160
> tcp_enter_loss+0x2b/0x290
> tcp_retransmit_timer+0x50b/0x640
> tcp_write_timer_handler+0x1c8/0x340
> tcp_write_timer+0xe5/0x140
> call_timer_fn+0x3a/0x1b0
> __run_timers.part.0+0x1bf/0x2d0
> run_timer_softirq+0x43/0xb0
> __do_softirq+0xfd/0x373
> __irq_exit_rcu+0xf6/0x140
> 
> [...]

Here is the summary with links:
  - [net,v5] tcp: prohibit TCP_REPAIR_OPTIONS if data was already sent
    https://git.kernel.org/netdev/net/c/0c175da7b037

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


