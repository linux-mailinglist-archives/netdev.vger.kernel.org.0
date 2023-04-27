Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D8D6F03A9
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 11:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243348AbjD0JuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 05:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243222AbjD0JuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 05:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720C012F
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 02:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 069FD62630
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 685C0C4339B;
        Thu, 27 Apr 2023 09:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682589019;
        bh=Z24uNoRTkKcAkRLSnLawYEJulETxXE2EO1IMK3vuWHc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HthC/9flZoY+yhIYcUhk2BYySkbnDw0NNjwERjp8zBDUqaNv0JMfM7ckBk2PnbqjN
         MxA4TpiH+9kTiHdtL0LXurJ1ZTgIAI5HHhWkyJfWTc/lWmjllXe32kxowMgOAR34sC
         GL0PM3vXuPhfqor/HegWWfU37ZAlMwpVzCn1hICLIuqkpAzjYuQKyq9RZyarIGR5H+
         0LqVebhQfI7qa81TV/FeU9UthRh2XLdFWVv8FRk2/M+orud5VtCqNwnJy7Mu8k5upq
         vlQV4rSpTlfet9lWJM6o84St+XdkD8er6PmnvZITceo66rB0v6jBYPpoY0P6Hue5lV
         uSUjVyfoBAtQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 51A8AE5FFC8;
        Thu, 27 Apr 2023 09:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: act_pedit: free pedit keys on bail from
 offset check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168258901933.3362.714443980123383199.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Apr 2023 09:50:19 +0000
References: <20230425144725.669262-1-pctammela@mojatatu.com>
In-Reply-To: <20230425144725.669262-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, idosch@idosch.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Apr 2023 11:47:25 -0300 you wrote:
> Ido Schimmel reports a memleak on a syzkaller instance:
>    BUG: memory leak
>    unreferenced object 0xffff88803d45e400 (size 1024):
>      comm "syz-executor292", pid 563, jiffies 4295025223 (age 51.781s)
>      hex dump (first 32 bytes):
>        28 bd 70 00 fb db df 25 02 00 14 1f ff 02 00 02  (.p....%........
>        00 32 00 00 1f 00 00 00 ac 14 14 3e 08 00 07 00  .2.........>....
>      backtrace:
>        [<ffffffff81bd0f2c>] kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
>        [<ffffffff81bd0f2c>] slab_post_alloc_hook mm/slab.h:772 [inline]
>        [<ffffffff81bd0f2c>] slab_alloc_node mm/slub.c:3452 [inline]
>        [<ffffffff81bd0f2c>] __kmem_cache_alloc_node+0x25c/0x320 mm/slub.c:3491
>        [<ffffffff81a865d9>] __do_kmalloc_node mm/slab_common.c:966 [inline]
>        [<ffffffff81a865d9>] __kmalloc+0x59/0x1a0 mm/slab_common.c:980
>        [<ffffffff83aa85c3>] kmalloc include/linux/slab.h:584 [inline]
>        [<ffffffff83aa85c3>] tcf_pedit_init+0x793/0x1ae0 net/sched/act_pedit.c:245
>        [<ffffffff83a90623>] tcf_action_init_1+0x453/0x6e0 net/sched/act_api.c:1394
>        [<ffffffff83a90e58>] tcf_action_init+0x5a8/0x950 net/sched/act_api.c:1459
>        [<ffffffff83a96258>] tcf_action_add+0x118/0x4e0 net/sched/act_api.c:1985
>        [<ffffffff83a96997>] tc_ctl_action+0x377/0x490 net/sched/act_api.c:2044
>        [<ffffffff83920a8d>] rtnetlink_rcv_msg+0x46d/0xd70 net/core/rtnetlink.c:6395
>        [<ffffffff83b24305>] netlink_rcv_skb+0x185/0x490 net/netlink/af_netlink.c:2575
>        [<ffffffff83901806>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:6413
>        [<ffffffff83b21cae>] netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>        [<ffffffff83b21cae>] netlink_unicast+0x5be/0x8a0 net/netlink/af_netlink.c:1365
>        [<ffffffff83b2293f>] netlink_sendmsg+0x9af/0xed0 net/netlink/af_netlink.c:1942
>        [<ffffffff8380c39f>] sock_sendmsg_nosec net/socket.c:724 [inline]
>        [<ffffffff8380c39f>] sock_sendmsg net/socket.c:747 [inline]
>        [<ffffffff8380c39f>] ____sys_sendmsg+0x3ef/0xaa0 net/socket.c:2503
>        [<ffffffff838156d2>] ___sys_sendmsg+0x122/0x1c0 net/socket.c:2557
>        [<ffffffff8381594f>] __sys_sendmsg+0x11f/0x200 net/socket.c:2586
>        [<ffffffff83815ab0>] __do_sys_sendmsg net/socket.c:2595 [inline]
>        [<ffffffff83815ab0>] __se_sys_sendmsg net/socket.c:2593 [inline]
>        [<ffffffff83815ab0>] __x64_sys_sendmsg+0x80/0xc0 net/socket.c:2593
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: act_pedit: free pedit keys on bail from offset check
    https://git.kernel.org/netdev/net/c/1b483d9f5805

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


