Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC206153C9
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 22:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiKAVKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 17:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKAVKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 17:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8341B1EF;
        Tue,  1 Nov 2022 14:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B875B81F0E;
        Tue,  1 Nov 2022 21:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFC43C433D7;
        Tue,  1 Nov 2022 21:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667337016;
        bh=jslqhqdLhyayNMQVdZzcaUt9b7bkbH6kGOlRbS2Qlpw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PDIDEKk0rnWdzIn1aEnU3ERaPexfHFwf4AR0MCY+yjbMVA+iSq/39uGxeOCOCl8Yp
         O3SA6TBk2W42C1RxfKPvAxVpqKfjuDFXEBCGW36g7ub9qO6lgdW4XTZE+1mdu5HSWN
         e82eynLyACkllKUft5sAvnQR9mr6+rSYuNsdonTiu9FTOZ88MlAMqCyaZwU5f6YXqP
         U3GYBlA8twyLyzKf7pj2g+Af0lT5yNqb+qc+04HlKEdmt53xlmbKQdvP5l/qDfWkhl
         9s3gZiBQbeR+GAXkUiOSDNEjh4UhU1jFei06MYNDvQnFPSanBPoUUffDQBl7uCttmi
         2z5qIvIn8jEbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5A17E270D5;
        Tue,  1 Nov 2022 21:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] bpf,
 sockmap: fix the sk->sk_forward_alloc warning of sk_stream_kill_queues()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166733701586.25446.5024409898528693379.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 21:10:15 +0000
References: <1667266296-8794-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1667266296-8794-1-git-send-email-wangyufen@huawei.com>
To:     wangyufen <wangyufen@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com, jakub@cloudflare.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 1 Nov 2022 09:31:36 +0800 you wrote:
> When running `test_sockmap` selftests, got the following warning:
> 
> WARNING: CPU: 2 PID: 197 at net/core/stream.c:205 sk_stream_kill_queues+0xd3/0xf0
> Call Trace:
>   <TASK>
>   inet_csk_destroy_sock+0x55/0x110
>   tcp_rcv_state_process+0xd28/0x1380
>   ? tcp_v4_do_rcv+0x77/0x2c0
>   tcp_v4_do_rcv+0x77/0x2c0
>   __release_sock+0x106/0x130
>   __tcp_close+0x1a7/0x4e0
>   tcp_close+0x20/0x70
>   inet_release+0x3c/0x80
>   __sock_release+0x3a/0xb0
>   sock_close+0x14/0x20
>   __fput+0xa3/0x260
>   task_work_run+0x59/0xb0
>   exit_to_user_mode_prepare+0x1b3/0x1c0
>   syscall_exit_to_user_mode+0x19/0x50
>   do_syscall_64+0x48/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> [...]

Here is the summary with links:
  - [net,v3] bpf, sockmap: fix the sk->sk_forward_alloc warning of sk_stream_kill_queues()
    https://git.kernel.org/bpf/bpf/c/8ec95b94716a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


