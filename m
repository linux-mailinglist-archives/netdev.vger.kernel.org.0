Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7646B1C52
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCIHa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjCIHaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:30:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A518C61325
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 23:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 248AF61A35
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83731C4339E;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678347019;
        bh=5bXbHocqKjMyb1gvxJZkVOU7Y6gH5iMSj9HWYgtI6Pk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kgJ5gp5xbAb4aJt6Y2i4YCS3UEu5Dkzi3dBoiWzmtnNiYPvmpLMSbARQYimhWotVo
         JN68tkxWB0AHwCw425pcs9Z1PYx7PGeZCI+Zgd+DISB2Bkv4tpHcJF21p5eLEYkHUv
         5W7vDwHfWIzGXFV/AXrMVAIhofgM06rIV+5Z/brk0ptuEzRFxQH+WBBpAwqkQD5V0O
         jwlrvkQN8jnaPwWk7cHZMT5wjPYYodSQ4HB/UDHEJFfszYkOxkp9rpvLaGwIQ9obxA
         XfutPaeAJY2YLFj//e0NrHgfI8gwOixnWof4mWB1Qm8UCvzvOqYWpxRBut/9fI6gBa
         BvHp8r7CIlvQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68291E4D008;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: avoid double iput when sock_alloc_file fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167834701941.22182.11170584102395922999.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 07:30:19 +0000
References: <20230307173707.468744-1-cascardo@canonical.com>
In-Reply-To: <20230307173707.468744-1-cascardo@canonical.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, axboe@kernel.dk, edumazet@google.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 14:37:07 -0300 you wrote:
> When sock_alloc_file fails to allocate a file, it will call sock_release.
> __sys_socket_file should then not call sock_release again, otherwise there
> will be a double free.
> 
> [   89.319884] ------------[ cut here ]------------
> [   89.320286] kernel BUG at fs/inode.c:1764!
> [   89.320656] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> [   89.321051] CPU: 7 PID: 125 Comm: iou-sqp-124 Not tainted 6.2.0+ #361
> [   89.321535] RIP: 0010:iput+0x1ff/0x240
> [   89.321808] Code: d1 83 e1 03 48 83 f9 02 75 09 48 81 fa 00 10 00 00 77 05 83 e2 01 75 1f 4c 89 ef e8 fb d2 ba 00 e9 80 fe ff ff c3 cc cc cc cc <0f> 0b 0f 0b e9 d0 fe ff ff 0f 0b eb 8d 49 8d b4 24 08 01 00 00 48
> [   89.322760] RSP: 0018:ffffbdd60068bd50 EFLAGS: 00010202
> [   89.323036] RAX: 0000000000000000 RBX: ffff9d7ad3cacac0 RCX: 0000000000001107
> [   89.323412] RDX: 000000000003af00 RSI: 0000000000000000 RDI: ffff9d7ad3cacb40
> [   89.323785] RBP: ffffbdd60068bd68 R08: ffffffffffffffff R09: ffffffffab606438
> [   89.324157] R10: ffffffffacb3dfa0 R11: 6465686361657256 R12: ffff9d7ad3cacb40
> [   89.324529] R13: 0000000080000001 R14: 0000000080000001 R15: 0000000000000002
> [   89.324904] FS:  00007f7b28516740(0000) GS:ffff9d7aeb1c0000(0000) knlGS:0000000000000000
> [   89.325328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   89.325629] CR2: 00007f0af52e96c0 CR3: 0000000002a02006 CR4: 0000000000770ee0
> [   89.326004] PKRU: 55555554
> [   89.326161] Call Trace:
> [   89.326298]  <TASK>
> [   89.326419]  __sock_release+0xb5/0xc0
> [   89.326632]  __sys_socket_file+0xb2/0xd0
> [   89.326844]  io_socket+0x88/0x100
> [   89.327039]  ? io_issue_sqe+0x6a/0x430
> [   89.327258]  io_issue_sqe+0x67/0x430
> [   89.327450]  io_submit_sqes+0x1fe/0x670
> [   89.327661]  io_sq_thread+0x2e6/0x530
> [   89.327859]  ? __pfx_autoremove_wake_function+0x10/0x10
> [   89.328145]  ? __pfx_io_sq_thread+0x10/0x10
> [   89.328367]  ret_from_fork+0x29/0x50
> [   89.328576] RIP: 0033:0x0
> [   89.328732] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> [   89.329073] RSP: 002b:0000000000000000 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
> [   89.329477] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f7b28637a3d
> [   89.329845] RDX: 00007fff4e4318a8 RSI: 00007fff4e4318b0 RDI: 0000000000000400
> [   89.330216] RBP: 00007fff4e431830 R08: 00007fff4e431711 R09: 00007fff4e4318b0
> [   89.330584] R10: 0000000000000000 R11: 0000000000000202 R12: 00007fff4e441b38
> [   89.330950] R13: 0000563835e3e725 R14: 0000563835e40d10 R15: 00007f7b28784040
> [   89.331318]  </TASK>
> [   89.331441] Modules linked in:
> [   89.331617] ---[ end trace 0000000000000000 ]---
> 
> [...]

Here is the summary with links:
  - net: avoid double iput when sock_alloc_file fails
    https://git.kernel.org/netdev/net/c/649c15c7691e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


