Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8F552E249
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 04:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343888AbiETCAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 22:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbiETCAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 22:00:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81329EBE88
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 19:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42744B827D9
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 02:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1D07C34114;
        Fri, 20 May 2022 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653012012;
        bh=oejf32f2rulnwu1qTg9BIcBf5Sew7pPwnO38jl9INkY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bxpNbwYRIHIWv1bgl6rYa95Rr428rAKyABKSayjAj4WrTDFv3Ww3EpY5h9Rp1r5Cv
         Xf3qTep0ZFQGT8JoitUM2s4T2bwpCxO6Y67dIWMB6wy0ZC3Yf8al3YfmerJVn+mCc1
         m/5SJ6fwsS/6wD0g35sKYDe2NoH+0zWT53WXOoYwFrX/Nayzk8nZH4l97dBM1/32Hs
         lvUJYTOcCmGiU1N2CatJoW554l++zPX/BzyDFPS6QB6u+M7gQIsjYq39+OVLU5+ocs
         QSs2w+N3eU1a/iFSLtiYBIlcWPHDFmVA5yEO7sBieATs+0e1DAEHRYx8y9KLRFxK3G
         oR0Fc+SGPKYiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D66E6F03935;
        Fri, 20 May 2022 02:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net] bonding: fix missed rcu protection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165301201187.10759.6971804275230663269.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 02:00:11 +0000
References: <20220519020148.1058344-1-liuhangbin@gmail.com>
In-Reply-To: <20220519020148.1058344-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, jtoppins@redhat.com, eric.dumazet@gmail.com,
        pabeni@redhat.com,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        vladimir.oltean@nxp.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 10:01:48 +0800 you wrote:
> When removing the rcu_read_lock in bond_ethtool_get_ts_info() as
> discussed [1], I didn't notice it could be called via setsockopt,
> which doesn't hold rcu lock, as syzbot pointed:
> 
>   stack backtrace:
>   CPU: 0 PID: 3599 Comm: syz-executor317 Not tainted 5.18.0-rc5-syzkaller-01392-g01f4685797a5 #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   Call Trace:
>    <TASK>
>    __dump_stack lib/dump_stack.c:88 [inline]
>    dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>    bond_option_active_slave_get_rcu include/net/bonding.h:353 [inline]
>    bond_ethtool_get_ts_info+0x32c/0x3a0 drivers/net/bonding/bond_main.c:5595
>    __ethtool_get_ts_info+0x173/0x240 net/ethtool/common.c:554
>    ethtool_get_phc_vclocks+0x99/0x110 net/ethtool/common.c:568
>    sock_timestamping_bind_phc net/core/sock.c:869 [inline]
>    sock_set_timestamping+0x3a3/0x7e0 net/core/sock.c:916
>    sock_setsockopt+0x543/0x2ec0 net/core/sock.c:1221
>    __sys_setsockopt+0x55e/0x6a0 net/socket.c:2223
>    __do_sys_setsockopt net/socket.c:2238 [inline]
>    __se_sys_setsockopt net/socket.c:2235 [inline]
>    __x64_sys_setsockopt+0xba/0x150 net/socket.c:2235
>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>    do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>   RIP: 0033:0x7f8902c8eb39
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net] bonding: fix missed rcu protection
    https://git.kernel.org/netdev/net/c/9b80ccda233f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


