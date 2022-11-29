Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262F963C60F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbiK2RDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbiK2RCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:02:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810E86DCDD;
        Tue, 29 Nov 2022 09:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36D6FB817F6;
        Tue, 29 Nov 2022 17:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85744C4347C;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669741218;
        bh=tGBW90FXivzoGyiPkj80nT0i4ORNTcFXhWPQLAsxwu8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q0oeHkvhKB9SndNIyXjF/p72Tc+/RkkCOV+hsovfig6JnbXsorQsNX2pG2EGHR3GM
         vwygU3O60k64/jkgWBm5qXVJifRk2bcqSUgg+hj+TDH7n1sc1kn7NDIk3JaC0TYBv6
         VgmybnCYgFLdb7sSxEnaxjt6J2IjZ/nxrayzEC0UtVlLmA6yGq0l8OGy93OSo9WPj0
         9jECoTlk+0d8yvOCbvZGXOe59dhznD3UD5wu4d5soor7VrOmO+SqV4agALVTo4LeXD
         rH6DqP5sEy5jtUj4fKZPB7/r3nvjVOm4qwiwpkHqg/ecYFB+ZmVdPe8MinSl8Tjur2
         aOanZ8g09i7Iw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B6A1E52557;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] sctp: fix memory leak in sctp_stream_outq_migrate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166974121836.7750.9329219382885985084.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 17:00:18 +0000
References: <20221126031720.378562-1-shaozhengchao@huawei.com>
In-Reply-To: <20221126031720.378562-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, lucien.xin@gmail.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 26 Nov 2022 11:17:20 +0800 you wrote:
> When sctp_stream_outq_migrate() is called to release stream out resources,
> the memory pointed to by prio_head in stream out is not released.
> 
> The memory leak information is as follows:
>  unreferenced object 0xffff88801fe79f80 (size 64):
>    comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
>    hex dump (first 32 bytes):
>      80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
>      90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
>    backtrace:
>      [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
>      [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
>      [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
>      [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
>      [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
>      [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
>      [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
>      [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
>      [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
>      [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
>      [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - [net,v4] sctp: fix memory leak in sctp_stream_outq_migrate()
    https://git.kernel.org/netdev/net/c/9ed7bfc79542

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


