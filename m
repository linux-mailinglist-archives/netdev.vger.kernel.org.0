Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA51606F36
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJUFLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiJUFKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:10:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47161E52F3
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 22:10:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05959B82AD5
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AD79C43470;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666329020;
        bh=j35nIZMWQvH+9yEayi8XaoQs07pjAQ2EkNIwob+kj9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YQTDDu4JJ7d/vXV0DWHykx0o+lWcV7de0eaUoLuWlyiUejGTyCslFzA919M80KD+P
         WhW+tHgZiNp9e+1Ge9KtIPcmLaggM4Sz75B8CEIyE8qfs7NS+sd4DaRQeb+NpbskNi
         HLqj1Mmt/2bMs+1Cf/9wv1Wjcuhvx8xcdCJMREm7c1swgTQHa8EgGLS17mDEz7ixJJ
         TCLd6zb/JrRB+He/Ai2hsO2mf/hpzfkqgHFiVOs/JLfeeT9Cv5FWphw6AHRhIvJ7TG
         na0E7cX9Gf/brVFCgn2yjHcLkf1MEpMyUAyZHqjYTOPt0mTOvFjqaMwJLqSHbluIlw
         of3Fgw1ACtBnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D7B2E270EA;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: fix a null-ptr-deref in tipc_topsrv_accept
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166632902051.25874.11226242874677356799.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 05:10:20 +0000
References: <4eee264380c409c61c6451af1059b7fb271a7e7b.1666120790.git.lucien.xin@gmail.com>
In-Reply-To: <4eee264380c409c61c6451af1059b7fb271a7e7b.1666120790.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 18 Oct 2022 15:19:50 -0400 you wrote:
> syzbot found a crash in tipc_topsrv_accept:
> 
>   KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>   Workqueue: tipc_rcv tipc_topsrv_accept
>   RIP: 0010:kernel_accept+0x22d/0x350 net/socket.c:3487
>   Call Trace:
>    <TASK>
>    tipc_topsrv_accept+0x197/0x280 net/tipc/topsrv.c:460
>    process_one_work+0x991/0x1610 kernel/workqueue.c:2289
>    worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>    kthread+0x2e4/0x3a0 kernel/kthread.c:376
>    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
> 
> [...]

Here is the summary with links:
  - [net] tipc: fix a null-ptr-deref in tipc_topsrv_accept
    https://git.kernel.org/netdev/net/c/82cb4e4612c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


