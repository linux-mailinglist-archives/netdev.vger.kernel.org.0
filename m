Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26537621C78
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiKHSup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiKHSuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5479961779;
        Tue,  8 Nov 2022 10:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C235561752;
        Tue,  8 Nov 2022 18:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FB66C4314C;
        Tue,  8 Nov 2022 18:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667933415;
        bh=YBZGHj7xrvB55I8T16VnIE0Mvnal19xm3rExq9pkV6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e5qy4pwSxAHAXRcRARcLW+wA0SoYAfT+5enkbnRQsQLHxnf5SNieo0AM9zmD2EIhJ
         i42lZl6FbOyZDKur43eOv7JDxjkPwFuAPe7KM8okio/QlauaWBdTUS0/bbRfloMzqi
         8dIZLyCq8cI9LAE8k2Ul1WsXclfUqpr7WCejJFExEn4cW/2iy8TB9Wb8misVgrItUL
         0jvVU/5f4mL5gYdBbM5M6sg5lx9QaouoYnM9W2jnrDA3dBKHxbjua6dbS/JSE8XPhi
         /UXm/abBLwfuXO0QxoTRLEYcPRf6OO6n20Jzf6GzQQgtylXPpTBbt+7djeLpXgRwKV
         xcpR2YydEJa7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05E8EE270CE;
        Tue,  8 Nov 2022 18:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v4] bpf: Fix memory leaks in __check_func_call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166793341502.24064.11585625251989325212.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 18:50:15 +0000
References: <1667884291-15666-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1667884291-15666-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, andrii@kernel.org,
        martin.lau@linux.dev, yhs@fb.com, joe@wand.net.nz
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Tue, 8 Nov 2022 13:11:31 +0800 you wrote:
> kmemleak reports this issue:
> 
> unreferenced object 0xffff88817139d000 (size 2048):
>   comm "test_progs", pid 33246, jiffies 4307381979 (age 45851.820s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<0000000045f075f0>] kmalloc_trace+0x27/0xa0
>     [<0000000098b7c90a>] __check_func_call+0x316/0x1230
>     [<00000000b4c3c403>] check_helper_call+0x172e/0x4700
>     [<00000000aa3875b7>] do_check+0x21d8/0x45e0
>     [<000000001147357b>] do_check_common+0x767/0xaf0
>     [<00000000b5a595b4>] bpf_check+0x43e3/0x5bc0
>     [<0000000011e391b1>] bpf_prog_load+0xf26/0x1940
>     [<0000000007f765c0>] __sys_bpf+0xd2c/0x3650
>     [<00000000839815d6>] __x64_sys_bpf+0x75/0xc0
>     [<00000000946ee250>] do_syscall_64+0x3b/0x90
>     [<0000000000506b7f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - [bpf,v4] bpf: Fix memory leaks in __check_func_call
    https://git.kernel.org/bpf/bpf/c/eb86559a691c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


