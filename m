Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18585FE9C0
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 09:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiJNHka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 03:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiJNHkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 03:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C6A65275;
        Fri, 14 Oct 2022 00:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2518B82264;
        Fri, 14 Oct 2022 07:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E994C433B5;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665733216;
        bh=VQSovz9XsMYRgNystyQU9FDrw0nycscqhxO26D3BOac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mxMGUcr5ckAtOhaoe0HbvByTkGlyu11R1WCLtrQplCwqJxUGT9BIHD/KQrdIPmwvh
         cvi2e0x4+iEpF1HfELrnT1jpZ/7hEgc8iUpVMyPaSeMI5h9kDRZ/Fmt6XR3etFyTFo
         2ETroVyCB40oHJyU+UejRo/NdtYeb8QDQ18rKe7+t16ZdW5r7C6gHPrb4urbCeyV6v
         NWyeVzZ5cPPg8NnPeuYIn010KQocZWpr+WQKQ3Qf5c5rS0944TZB2rEUanteXvOklw
         1hMC6F2SloKre8CT6wezk26ksuuz1brap/SWkc6ol4if8PR/US+Fnzll5tIgujpIk8
         WCnVThMJ7sucw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65934E4D00C;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tipc: fix an information leak in tipc_topsrv_kern_subscr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166573321641.24049.9116902216916223588.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Oct 2022 07:40:16 +0000
References: <20221012152514.2060384-1-glider@google.com>
In-Reply-To: <20221012152514.2060384-1-glider@google.com>
To:     Alexander Potapenko <glider@google.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, netdev@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Oct 2022 17:25:14 +0200 you wrote:
> Use a 8-byte write to initialize sub.usr_handle in
> tipc_topsrv_kern_subscr(), otherwise four bytes remain uninitialized
> when issuing setsockopt(..., SOL_TIPC, ...).
> This resulted in an infoleak reported by KMSAN when the packet was
> received:
> 
>   =====================================================
>   BUG: KMSAN: kernel-infoleak in copyout+0xbc/0x100 lib/iov_iter.c:169
>    instrument_copy_to_user ./include/linux/instrumented.h:121
>    copyout+0xbc/0x100 lib/iov_iter.c:169
>    _copy_to_iter+0x5c0/0x20a0 lib/iov_iter.c:527
>    copy_to_iter ./include/linux/uio.h:176
>    simple_copy_to_iter+0x64/0xa0 net/core/datagram.c:513
>    __skb_datagram_iter+0x123/0xdc0 net/core/datagram.c:419
>    skb_copy_datagram_iter+0x58/0x200 net/core/datagram.c:527
>    skb_copy_datagram_msg ./include/linux/skbuff.h:3903
>    packet_recvmsg+0x521/0x1e70 net/packet/af_packet.c:3469
>    ____sys_recvmsg+0x2c4/0x810 net/socket.c:?
>    ___sys_recvmsg+0x217/0x840 net/socket.c:2743
>    __sys_recvmsg net/socket.c:2773
>    __do_sys_recvmsg net/socket.c:2783
>    __se_sys_recvmsg net/socket.c:2780
>    __x64_sys_recvmsg+0x364/0x540 net/socket.c:2780
>    do_syscall_x64 arch/x86/entry/common.c:50
>    do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>    entry_SYSCALL_64_after_hwframe+0x63/0xcd arch/x86/entry/entry_64.S:120
> 
> [...]

Here is the summary with links:
  - tipc: fix an information leak in tipc_topsrv_kern_subscr
    https://git.kernel.org/netdev/net/c/777ecaabd614

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


