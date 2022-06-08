Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D745A543B85
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbiFHSaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbiFHSaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B41634EC79;
        Wed,  8 Jun 2022 11:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4737B829B4;
        Wed,  8 Jun 2022 18:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8439CC3411E;
        Wed,  8 Jun 2022 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654713013;
        bh=NyibQyyMbL7pZ9fPo62IvGwdNfh4jwodnwbgwo0JuyE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FYjD/H9imUSS/D9lqYQHWbgDSQPfIZYgdaUriuO1xvswh4JB1GYcCIJQjiS1V/CEH
         pIv3mg7X4hXdVWXTEiXJWX7BA7hhEWxhW/3X+qQ/QJnmwX5QloOWp4vfV1SdUWlSGZ
         /LyB4LWB0uqJWJ0Vxl6cQ1McQ2r91RK/iXfG4sC/nuaeTHFLDzdN6xXSOMtO1wj2II
         H54DzJhXaqTESy7r7rt7V/BioKG78VfgnhavOk6YPOq2Im+RWA28cln6NwhdtCxAkt
         40uqT3tZLZ9Oqk0ADXw4+IdATc8YLGbcEHWU2cPUNtDeqg9n4/8b3RpdfRIGvQXn8j
         nY1Ua9W32BDcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A345E737FA;
        Wed,  8 Jun 2022 18:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 1/2] ipv6: Fix signed integer overflow in
 __ip6_append_data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165471301342.10429.11014081493925297631.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 18:30:13 +0000
References: <20220607120028.845916-1-wangyufen@huawei.com>
In-Reply-To: <20220607120028.845916-1-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 7 Jun 2022 20:00:27 +0800 you wrote:
> Resurrect ubsan overflow checks and ubsan report this warning,
> fix it by change the variable [length] type to size_t.
> 
> UBSAN: signed-integer-overflow in net/ipv6/ip6_output.c:1489:19
> 2147479552 + 8567 cannot be represented in type 'int'
> CPU: 0 PID: 253 Comm: err Not tainted 5.16.0+ #1
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>   dump_backtrace+0x214/0x230
>   show_stack+0x30/0x78
>   dump_stack_lvl+0xf8/0x118
>   dump_stack+0x18/0x30
>   ubsan_epilogue+0x18/0x60
>   handle_overflow+0xd0/0xf0
>   __ubsan_handle_add_overflow+0x34/0x44
>   __ip6_append_data.isra.48+0x1598/0x1688
>   ip6_append_data+0x128/0x260
>   udpv6_sendmsg+0x680/0xdd0
>   inet6_sendmsg+0x54/0x90
>   sock_sendmsg+0x70/0x88
>   ____sys_sendmsg+0xe8/0x368
>   ___sys_sendmsg+0x98/0xe0
>   __sys_sendmmsg+0xf4/0x3b8
>   __arm64_sys_sendmmsg+0x34/0x48
>   invoke_syscall+0x64/0x160
>   el0_svc_common.constprop.4+0x124/0x300
>   do_el0_svc+0x44/0xc8
>   el0_svc+0x3c/0x1e8
>   el0t_64_sync_handler+0x88/0xb0
>   el0t_64_sync+0x16c/0x170
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/2] ipv6: Fix signed integer overflow in __ip6_append_data
    https://git.kernel.org/netdev/net/c/f93431c86b63
  - [net-next,v5,2/2] ipv6: Fix signed integer overflow in l2tp_ip6_sendmsg
    https://git.kernel.org/netdev/net/c/f638a84afef3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


