Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0CD660A73
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 00:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjAFX5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 18:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAFX5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 18:57:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A943AB01
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 15:57:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7818461FA8
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 23:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EC4C433F1;
        Fri,  6 Jan 2023 23:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673049428;
        bh=PH1GsuaMYupZxPyBRAF7/WXeZtOj2B1BPtE6Ow9bNGY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P2++pCqEEWCKxzY4y5q1owm+ocZPOSGZM1AZl17Yav6dawNe5zTE3B99Lso3z8imO
         rpP7cYejj21AFLwnLxXMj4Ea1lEip/fFoz/DlgTtIyhAN7kS5pyLRVvrVG60Yr0ZnY
         8Nnsrqhvb+K2hcJMmrJZbTzrpPGnITqz41tHNstf5m+ISOVZ92VdePdS+FEpvEtQDZ
         08f+0z+d8u5OPGIxrwY2vYnnj59k9k7NpYzhy69UqqdEdzqESyVeyOIhvNbMgOlr8W
         AvvxWwgmseOlB+7YRigkP0QpYljZc6mv4ox+K0W05PYT4PI5dS1DxWkVmH9K6YgCuo
         EEUVQevGa9jPg==
Date:   Fri, 6 Jan 2023 15:57:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kyle Zeng <zengyhkyle@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: net: ipv6: raw: fixes null pointer deference in
 rawv6_push_pending_frames
Message-ID: <20230106155707.27da51b8@kernel.org>
In-Reply-To: <CADW8OBu8R7tp-SfEwNByZqJaV-j2squT1JigniZLPwe0sWpRWg@mail.gmail.com>
References: <Y7iQeGb2xzkf0iR7@westworld>
        <20230106145553.6dd014f1@kernel.org>
        <CADW8OBu8R7tp-SfEwNByZqJaV-j2squT1JigniZLPwe0sWpRWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Jan 2023 16:12:25 -0700 Kyle Zeng wrote:
> Hi Jakub,
> 
> The null dereference can happen if every execution in the loop enters
> the `if (offset >= len) {`branch  and directly `continue` without
> running `csum_skb = skb`.
> A crash report is attached to this email.

I see, please include the stack trace in the commit message in the
future. Do you have a repro for this stack trace?

We check the offset against total (cork) length early in the function
so maybe the accounting goes wrong somewhere or there is some integer
overflow problem?

Reminder: please don't top post on the kernel mailing lists.

> =============================================
> [    7.203616] BUG: kernel NULL pointer dereference, address: 00000000000000b2
> [    7.205204] #PF: supervisor read access in kernel mode
> [    7.206448] #PF: error_code(0x0000) - not-present page
> [    7.207630] PGD 88d0067 P4D 88d0067 PUD 79af067 PMD 0
> [    7.208060] Oops: 0000 [#1] SMP NOPTI
> [    7.208343] CPU: 1 PID: 1846 Comm: poc Not tainted 5.10.133 #39

> [    7.208816] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.15.0-1 04/01/2014
> [    7.209489] RIP: 0010:rawv6_push_pending_frames+0x96/0x1e0
> [    7.209934] Code: 00 00 8d 57 ff 39 d0 0f 8d bc 00 00 00 48 89 7c
> 24 08 41 83 bc 24 d0 01 00 00 01 0f 85 b8 00 00 00 8b a9 88 00 00 00
> 48 89 cb <44> 0f b7 ab b2 00 00 00 44 03 ab c0 00 00 00 44 2b ab c8 00
> 00 00
> [    7.211433] RSP: 0018:ffffc90003487b10 EFLAGS: 00010246
> [    7.211859] RAX: 00000000000000d8 RBX: 0000000000000000 RCX: ffff8880064101c0
> [    7.212410] RDX: 00000000000003c0 RSI: ffff8880064101c0 RDI: 00000000090e5840
> [    7.212992] RBP: 00000000479c45b8 R08: 0000000000000000 R09: ffff8880064101a4
> [    7.213559] R10: ffff8880064103d0 R11: ffff888006524b00 R12: ffff888006410000
> [    7.214106] R13: ffffc90003487c10 R14: ffffc90003487c10 R15: 0000000000000000
> [    7.214653] FS:  00000000017e03c0(0000) GS:ffff88803ec80000(0000)
> knlGS:0000000000000000
> [    7.215272] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    7.215769] CR2: 00000000000000b2 CR3: 0000000009068006 CR4: 0000000000770ee0
> [    7.216318] PKRU: 55555554
> [    7.216532] Call Trace:
> [    7.216744]  rawv6_sendmsg+0x72c/0x7d0
> [    7.217041]  kernel_sendmsg+0x7a/0x90
> [    7.217325]  sock_no_sendpage+0xc1/0xe0
> [    7.217644]  kernel_sendpage+0xa3/0xe0
> [    7.217945]  sock_sendpage+0x23/0x30
> [    7.218224]  pipe_to_sendpage+0x76/0xa0
> [    7.218529]  __splice_from_pipe+0xe5/0x200
> [    7.218870]  ? generic_splice_sendpage+0xa0/0xa0
> [    7.219263]  generic_splice_sendpage+0x72/0xa0
> [    7.219650]  do_splice+0x4ad/0x780
> [    7.219928]  __se_sys_splice+0x162/0x210
> [    7.220231]  do_syscall_64+0x31/0x40
> [    7.220518]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> [    7.220944] RIP: 0033:0x47656d
> [    7.221189] Code: c3 e8 47 28 00 00 0f 1f 80 00 00 00 00 f3 0f 1e
> fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
> 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89
> 01 48
> [    7.222645] RSP: 002b:00007ffd36d11668 EFLAGS: 00000216 ORIG_RAX:
> 0000000000000113
> [    7.223266] RAX: ffffffffffffffda RBX: 000000002000102f RCX: 000000000047656d
> [    7.223860] RDX: 0000000000000007 RSI: 0000000000000000 RDI: 0000000000000005
> [    7.224414] RBP: 00007ffd36d116a0 R08: 000000000804ffe2 R09: 0000000000000000
> [    7.224986] R10: 0000000000000000 R11: 0000000000000216 R12: 0000000000000001
> [    7.225546] R13: 00007ffd36d118d8 R14: 00000000005026c0 R15: 0000000000000002
> [    7.226112] Modules linked in:
> [    7.226350] CR2: 00000000000000b2

