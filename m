Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955C9539A37
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 01:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345690AbiEaXuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 19:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237770AbiEaXuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 19:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9534D9CF21;
        Tue, 31 May 2022 16:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1237CB81739;
        Tue, 31 May 2022 23:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B791EC3411D;
        Tue, 31 May 2022 23:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654041013;
        bh=tvec4ouEsqif07kqYk3jWXeGiptT9fUwA8mQ/zFtYQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GWuVDvq/eqooPNQH2EJpCsKq9XXnNil9B6xJRXzw3uLxneCJ4X7I6BC/Qp+3cIRto
         xzkqVVB62bcuV88QK80kScUMEGrC82pQNOUgymACgRAhH+4hzIiP55AKfrs76RLN/M
         8CKiPKLI809D79omiKLsDrBI1Bi9f1MMbPuV+Ub1vgtaFJUB7LNpMeFpsw5QuESmq3
         9pMZRpWHMDBJOGfD1IN/mQggxcRSVQYuyBlBQRfZVimYu2GYnUVOKUBojPlXC1lzlK
         lyASZyMf4+AuwW7rGBIsYsC+cFnvRc8NEC1vyVx5UVLMVT8S5c2HdPKue9zboe/YOM
         150gMJhxSw7XQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93D52F0394D;
        Tue, 31 May 2022 23:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf,sockmap: fix sk->sk_forward_alloc warn_on in
 sk_stream_kill_queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165404101360.6040.8102115666257855130.git-patchwork-notify@kernel.org>
Date:   Tue, 31 May 2022 23:50:13 +0000
References: <20220524075311.649153-1-wangyufen@huawei.com>
In-Reply-To: <20220524075311.649153-1-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, kafai@fb.com, dsahern@kernel.org,
        kuba@kernel.org, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 24 May 2022 15:53:11 +0800 you wrote:
> During TCP sockmap redirect pressure test, the following warning is triggered:
> WARNING: CPU: 3 PID: 2145 at net/core/stream.c:205 sk_stream_kill_queues+0xbc/0xd0
> CPU: 3 PID: 2145 Comm: iperf Kdump: loaded Tainted: G        W         5.10.0+ #9
> Call Trace:
>  inet_csk_destroy_sock+0x55/0x110
>  inet_csk_listen_stop+0xbb/0x380
>  tcp_close+0x41b/0x480
>  inet_release+0x42/0x80
>  __sock_release+0x3d/0xa0
>  sock_close+0x11/0x20
>  __fput+0x9d/0x240
>  task_work_run+0x62/0x90
>  exit_to_user_mode_prepare+0x110/0x120
>  syscall_exit_to_user_mode+0x27/0x190
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf,sockmap: fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues
    https://git.kernel.org/bpf/bpf-next/c/84dc313f7b79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


