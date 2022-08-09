Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115FD58E036
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245703AbiHITaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344662AbiHITaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FF229E;
        Tue,  9 Aug 2022 12:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D5CD61315;
        Tue,  9 Aug 2022 19:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96BA4C433C1;
        Tue,  9 Aug 2022 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660073414;
        bh=h/eUzZfM6RhkPY3+kmkITm+5n0WjJrLJwwJSOtXpq5o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XADqUvYtj2+DHVCCD/VuhyMtp58QzzbDf146IZ/f1ltZab3TsX8Ff+Aej+qNwHcCZ
         Q7LsOYNaI0duoDEnvlq3PVKcCpkPeSiqskbJN4LI/YDNPm9dpWsrr7menXq0ThJs5B
         Kl1dkjsrXHUJuXjhjsASi1HuTq9f46Zz9AbwlWvQN8HyrNAlmv8C6N5upxTjQsO6D3
         SU8YezNl5X5Lj60OsDEuTOB9IBo6bWonpg0IjT7jV3X+qXworD0dm/8/hRbyzTk5tN
         b8cPSxhIyE9+rcXp0PdIRPQ8lSMCKDlVe1DcpWIC6Tc3hM24DiCbQ4/qVM9QEPTVmE
         drqtVHNz0yxdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 785B8C43141;
        Tue,  9 Aug 2022 19:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bgmac:`Fix a BUG triggered by wrong bytes_compl
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166007341448.32181.552976824939020556.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 19:30:14 +0000
References: <20220808173939.193804-1-sbodomerle@gmail.com>
In-Reply-To: <20220808173939.193804-1-sbodomerle@gmail.com>
To:     Sandor Bodo-Merle <sbodomerle@gmail.com>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nbd@openwrt.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  8 Aug 2022 19:39:39 +0200 you wrote:
> On one of our machines we got:
> 
> kernel BUG at lib/dynamic_queue_limits.c:27!\r\n
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM\r\n
> CPU: 0 PID: 1166 Comm: irq/41-bgmac Tainted: G        W  O    4.14.275-rt132 #1\r\n
> Hardware name: BRCM XGS iProc\r\n
> task: ee3415c0 task.stack: ee32a000\r\n
> PC is at dql_completed+0x168/0x178\r\n
> LR is at bgmac_poll+0x18c/0x6d8\r\n
> pc : [<c03b9430>]    lr : [<c04b5a18>]    psr: 800a0313\r\n
> sp : ee32be14  ip : 000005ea  fp : 00000bd4\r\n
> r10: ee558500  r9 : c0116298  r8 : 00000002\r\n
> r7 : 00000000  r6 : ef128810  r5 : 01993267  r4 : 01993851\r\n
> r3 : ee558000  r2 : 000070e1  r1 : 00000bd4  r0 : ee52c180\r\n
> Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none\r\n
> Control: 12c5387d  Table: 8e88c04a  DAC: 00000051\r\n
> Process irq/41-bgmac (pid: 1166, stack limit = 0xee32a210)\r\n
> Stack: (0xee32be14 to 0xee32c000)\r\n
> be00:                                              ee558520 ee52c100 ef128810\r\n
> be20: 00000000 00000002 c0116298 c04b5a18 00000000 c0a0c8c4 c0951780 00000040\r\n
> be40: c0701780 ee558500 ee55d520 ef05b340 ef6f9780 ee558520 00000001 00000040\r\n
> be60: ffffe000 c0a56878 ef6fa040 c0952040 0000012c c0528744 ef6f97b0 fffcfb6a\r\n
> be80: c0a04104 2eda8000 c0a0c4ec c0a0d368 ee32bf44 c0153534 ee32be98 ee32be98\r\n
> bea0: ee32bea0 ee32bea0 ee32bea8 ee32bea8 00000000 c01462e4 ffffe000 ef6f22a8\r\n
> bec0: ffffe000 00000008 ee32bee4 c0147430 ffffe000 c094a2a8 00000003 ffffe000\r\n
> bee0: c0a54528 00208040 0000000c c0a0c8c4 c0a65980 c0124d3c 00000008 ee558520\r\n
> bf00: c094a23c c0a02080 00000000 c07a9910 ef136970 ef136970 ee30a440 ef136900\r\n
> bf20: ee30a440 00000001 ef136900 ee30a440 c016d990 00000000 c0108db0 c012500c\r\n
> bf40: ef136900 c016da14 ee30a464 ffffe000 00000001 c016dd14 00000000 c016db28\r\n
> bf60: ffffe000 ee21a080 ee30a400 00000000 ee32a000 ee30a440 c016dbfc ee25fd70\r\n
> bf80: ee21a09c c013edcc ee32a000 ee30a400 c013ec7c 00000000 00000000 00000000\r\n
> bfa0: 00000000 00000000 00000000 c0108470 00000000 00000000 00000000 00000000\r\n
> bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000\r\n
> bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000\r\n
> [<c03b9430>] (dql_completed) from [<c04b5a18>] (bgmac_poll+0x18c/0x6d8)\r\n
> [<c04b5a18>] (bgmac_poll) from [<c0528744>] (net_rx_action+0x1c4/0x494)\r\n
> [<c0528744>] (net_rx_action) from [<c0124d3c>] (do_current_softirqs+0x1ec/0x43c)\r\n
> [<c0124d3c>] (do_current_softirqs) from [<c012500c>] (__local_bh_enable+0x80/0x98)\r\n
> [<c012500c>] (__local_bh_enable) from [<c016da14>] (irq_forced_thread_fn+0x84/0x98)\r\n
> [<c016da14>] (irq_forced_thread_fn) from [<c016dd14>] (irq_thread+0x118/0x1c0)\r\n
> [<c016dd14>] (irq_thread) from [<c013edcc>] (kthread+0x150/0x158)\r\n
> [<c013edcc>] (kthread) from [<c0108470>] (ret_from_fork+0x14/0x24)\r\n
> Code: a83f15e0 0200001a 0630a0e1 c3ffffea (f201f0e7) \r\n
> 
> [...]

Here is the summary with links:
  - net: bgmac:`Fix a BUG triggered by wrong bytes_compl
    https://git.kernel.org/netdev/net/c/1b7680c6c1f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


