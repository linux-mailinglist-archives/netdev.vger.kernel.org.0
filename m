Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EECA6D4022
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjDCJUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbjDCJUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:20:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E42A25D;
        Mon,  3 Apr 2023 02:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6EB5B81639;
        Mon,  3 Apr 2023 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6655CC4339C;
        Mon,  3 Apr 2023 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680513619;
        bh=UDNPMuPsDND090IyeyJNHO/ANUFc551BRYCtKd2MvJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PYaIENdHn3xPPl2Slb1J4ZRCepFLzznYLvwTIAXPpE0m9xuefMw0ljahRJbmIKbVW
         7Vyt/EA++I3qqoNlbCJHaOnWKbKjmBDMiTIzB/PJaTe1dPLoi9LxY4kwtZgJaZ6sCX
         I2yUbYoJ4d0MNMpcxQlP3hayg6n0WZbKC5TfltV0q8S+wFOgSLIbCHK9pCgMPXUI1R
         4DAO+8L5VWd5cLNc47H8SfBOfPc65+oy+hmHPhOVT2oz0z2eFRDCs8CT239qBUzd+O
         qaEWLG/FcfJTxhtHCjrRcOlNzWsOEho+70+v13EZZBMbssmbe1eVPFmjl9BkErjCk9
         4hGzkJ/26vkxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E1A2E5EA82;
        Mon,  3 Apr 2023 09:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: Fix an uninit variable access bug in
 __ip6_make_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168051361931.15794.6903951386733937555.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Apr 2023 09:20:19 +0000
References: <20230403073417.2240575-1-william.xuanziyang@huawei.com>
In-Reply-To: <20230403073417.2240575-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dlstevens@us.ibm.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 3 Apr 2023 15:34:17 +0800 you wrote:
> Syzbot reported a bug as following:
> 
> =====================================================
> BUG: KMSAN: uninit-value in arch_atomic64_inc arch/x86/include/asm/atomic64_64.h:88 [inline]
> BUG: KMSAN: uninit-value in arch_atomic_long_inc include/linux/atomic/atomic-long.h:161 [inline]
> BUG: KMSAN: uninit-value in atomic_long_inc include/linux/atomic/atomic-instrumented.h:1429 [inline]
> BUG: KMSAN: uninit-value in __ip6_make_skb+0x2f37/0x30f0 net/ipv6/ip6_output.c:1956
>  arch_atomic64_inc arch/x86/include/asm/atomic64_64.h:88 [inline]
>  arch_atomic_long_inc include/linux/atomic/atomic-long.h:161 [inline]
>  atomic_long_inc include/linux/atomic/atomic-instrumented.h:1429 [inline]
>  __ip6_make_skb+0x2f37/0x30f0 net/ipv6/ip6_output.c:1956
>  ip6_finish_skb include/net/ipv6.h:1122 [inline]
>  ip6_push_pending_frames+0x10e/0x550 net/ipv6/ip6_output.c:1987
>  rawv6_push_pending_frames+0xb12/0xb90 net/ipv6/raw.c:579
>  rawv6_sendmsg+0x297e/0x2e60 net/ipv6/raw.c:922
>  inet_sendmsg+0x101/0x180 net/ipv4/af_inet.c:827
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  ____sys_sendmsg+0xa8e/0xe70 net/socket.c:2476
>  ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2530
>  __sys_sendmsg net/socket.c:2559 [inline]
>  __do_sys_sendmsg net/socket.c:2568 [inline]
>  __se_sys_sendmsg net/socket.c:2566 [inline]
>  __x64_sys_sendmsg+0x367/0x540 net/socket.c:2566
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - [net] ipv6: Fix an uninit variable access bug in __ip6_make_skb()
    https://git.kernel.org/netdev/net/c/ea30388baebc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


