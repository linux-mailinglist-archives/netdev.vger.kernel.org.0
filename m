Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96265F28FE
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 09:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJCHKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 03:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiJCHKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 03:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AFF1AF0B
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 00:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C5FF60F9C
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 07:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAA6AC433D7;
        Mon,  3 Oct 2022 07:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664781014;
        bh=PWf6W1I3JNzkRZQvmcE5AbcnlOYFy0TtrM+YCdPjjsw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XErWpKsXzdNcOvtEb4pIgqG5vQcMNfsiFsNReiRyrQx6Z9wF0G+RXYjraDS44fVzq
         Nc6m4Px9Yo5dZRJcyU9IYH4Dm450kuTn2qSrv9OaC833v4V9EqgIDOj8sENrMwsq2h
         cMNv7XkloVHCPzCOSIkC+JeEnnaSDntBdoJRxeWvgMnoWkOQosPZgFfS8VDvUnAJLd
         RVspA+9R1ZWw5LaHOm1SgIlGqrKpaMa7oPI6BoAQiCjjTe/daq6xYeyEHAJGtnB8jN
         LpAoADCv2hMR3Vutyinml/DlblN8tISRb5o6XWOGGJd/1/DJz8BtFd/axGdiYe42pa
         hk3xlnr0gf99A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AEFB7E49FA3;
        Mon,  3 Oct 2022 07:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net] af_unix: Fix memory leaks of the whole sk due to OOB
 skb.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166478101471.21968.3096623187565669750.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 07:10:14 +0000
References: <20220929155204.6816-1-kuniyu@amazon.com>
In-Reply-To: <20220929155204.6816-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rao.shoaib@oracle.com, kuni1840@gmail.com,
        netdev@vger.kernel.org, syzkaller@googlegroups.com
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

On Thu, 29 Sep 2022 08:52:04 -0700 you wrote:
> syzbot reported a sequence of memory leaks, and one of them indicated we
> failed to free a whole sk:
> 
>   unreferenced object 0xffff8880126e0000 (size 1088):
>     comm "syz-executor419", pid 326, jiffies 4294773607 (age 12.609s)
>     hex dump (first 32 bytes):
>       00 00 00 00 00 00 00 00 7d 00 00 00 00 00 00 00  ........}.......
>       01 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
>     backtrace:
>       [<000000006fefe750>] sk_prot_alloc+0x64/0x2a0 net/core/sock.c:1970
>       [<0000000074006db5>] sk_alloc+0x3b/0x800 net/core/sock.c:2029
>       [<00000000728cd434>] unix_create1+0xaf/0x920 net/unix/af_unix.c:928
>       [<00000000a279a139>] unix_create+0x113/0x1d0 net/unix/af_unix.c:997
>       [<0000000068259812>] __sock_create+0x2ab/0x550 net/socket.c:1516
>       [<00000000da1521e1>] sock_create net/socket.c:1566 [inline]
>       [<00000000da1521e1>] __sys_socketpair+0x1a8/0x550 net/socket.c:1698
>       [<000000007ab259e1>] __do_sys_socketpair net/socket.c:1751 [inline]
>       [<000000007ab259e1>] __se_sys_socketpair net/socket.c:1748 [inline]
>       [<000000007ab259e1>] __x64_sys_socketpair+0x97/0x100 net/socket.c:1748
>       [<000000007dedddc1>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>       [<000000007dedddc1>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>       [<000000009456679f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - [v1,net] af_unix: Fix memory leaks of the whole sk due to OOB skb.
    https://git.kernel.org/netdev/net/c/7a62ed61367b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


