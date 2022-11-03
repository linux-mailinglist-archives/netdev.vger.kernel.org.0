Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65F8617554
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 05:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiKCEAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 00:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKCEAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 00:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E6764E5
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34D3E61A15
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 815A1C433B5;
        Thu,  3 Nov 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667448015;
        bh=oxRMF18UE0LOHEfbttV0atBsufVMfY/BQzhoPqaeZes=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LyXSc5nt6sxSINiWtFxIlyBoSMifw5S7Ozqf+va6D1BRTpxLS1t/i+ojX09ERHkJA
         KyFL9hu/qUI+y+X6x0N28MI29cXlZyCB0FfYnD5Nn+rpm8DBC62ku1xGXCQLyP3vDR
         5eD3LenOP49YG2cJfjktKoAoWC7Wuxe8Yb2OZownLIkHu5Hkd9nkrKRXmFwGqdc1SC
         psBdQg3cKOf1/UZhusFARHS/jiY9qYK8ny3yDjfzyDZbxPnPHpxvVvyP7DFMjeFLgx
         cf7EfNKjwU518FwFAAibFZfuXX/gEy5hqs7aU792OSdaGVvRS0uene6Osx+e8P1Gry
         PbGqkpfjPORVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 621ACC41621;
        Thu,  3 Nov 2022 04:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: fix WARNING in ip6_route_net_exit_late()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744801539.16768.5170122880251665044.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 04:00:15 +0000
References: <20221102020610.351330-1-shaozhengchao@huawei.com>
In-Reply-To: <20221102020610.351330-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dlezcano@fr.ibm.com,
        benjamin.thery@bull.net, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 2 Nov 2022 10:06:10 +0800 you wrote:
> During the initialization of ip6_route_net_init_late(), if file
> ipv6_route or rt6_stats fails to be created, the initialization is
> successful by default. Therefore, the ipv6_route or rt6_stats file
> doesn't be found during the remove in ip6_route_net_exit_late(). It
> will cause WRNING.
> 
> The following is the stack information:
> name 'rt6_stats'
> WARNING: CPU: 0 PID: 9 at fs/proc/generic.c:712 remove_proc_entry+0x389/0x460
> Modules linked in:
> Workqueue: netns cleanup_net
> RIP: 0010:remove_proc_entry+0x389/0x460
> PKRU: 55555554
> Call Trace:
> <TASK>
> ops_exit_list+0xb0/0x170
> cleanup_net+0x4ea/0xb00
> process_one_work+0x9bf/0x1710
> worker_thread+0x665/0x1080
> kthread+0x2e4/0x3a0
> ret_from_fork+0x1f/0x30
> </TASK>
> 
> [...]

Here is the summary with links:
  - [net] ipv6: fix WARNING in ip6_route_net_exit_late()
    https://git.kernel.org/netdev/net/c/768b3c745fe5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


