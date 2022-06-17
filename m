Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5197554F5A7
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381863AbiFQKkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381290AbiFQKkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02DF62CD2
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A25BCB8299A
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BD06C341C4;
        Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655462414;
        bh=hr4AGUBPNGkBb0xDRRyDRsMNWBtvv7TG+477g52dx9g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nNrAQyD00hqfLrQ0YuQ82+8bJAApXTNrYTcRlwV3VWWaDBIyu4N5VCzPmMLNvwYKD
         PeRGWG4nh54tKq3ZQ35r7iSC2s7Dkn0vub/rMjt3oEwVqG7xHG65XGKpO7YvcseOV8
         NMvHhzBxT9EbsFPPwS9Mi2VNK2gTpRN9wXcdJuNDn+Gf5lIspL8ysBQ2JeQWaTUAV/
         /M39FjMMQGqcOAeD1EZBs1w2gjcOKML9eDlrzbSRPK8cT56NElFXo5ONECb0o9ZnFE
         eBlH4zd07pYK2vrSvesgKXyUIyKldnxluCxOa5CvKk4+FrzQE3oKhTsOsMbu3vihJL
         qUw/YsO0n0E5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42628E6D466;
        Fri, 17 Jun 2022 10:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] tipc: fix use-after-free Read in tipc_named_reinit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546241426.18293.17808305132928960501.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 10:40:14 +0000
References: <20220617014551.3235-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20220617014551.3235-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org,
        syzbot+47af19f3307fc9c5c82e@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 17 Jun 2022 08:45:51 +0700 you wrote:
> syzbot found the following issue on:
> ==================================================================
> BUG: KASAN: use-after-free in tipc_named_reinit+0x94f/0x9b0
> net/tipc/name_distr.c:413
> Read of size 8 at addr ffff88805299a000 by task kworker/1:9/23764
> 
> CPU: 1 PID: 23764 Comm: kworker/1:9 Not tainted
> 5.18.0-rc4-syzkaller-00878-g17d49e6e8012 #0
> Hardware name: Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Workqueue: events tipc_net_finalize_work
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0xeb/0x495
> mm/kasan/report.c:313
>  print_report mm/kasan/report.c:429 [inline]
>  kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
>  tipc_named_reinit+0x94f/0x9b0 net/tipc/name_distr.c:413
>  tipc_net_finalize+0x234/0x3d0 net/tipc/net.c:138
>  process_one_work+0x996/0x1610 kernel/workqueue.c:2289
>  worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>  kthread+0x2e9/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
>  </TASK>
> [...]
> ==================================================================
> 
> [...]

Here is the summary with links:
  - [net] tipc: fix use-after-free Read in tipc_named_reinit
    https://git.kernel.org/netdev/net/c/911600bf5a5e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


