Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698C65A33D9
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345435AbiH0CkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbiH0CkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006486747B
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 19:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8586761C50
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 02:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2E7FC433C1;
        Sat, 27 Aug 2022 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661568015;
        bh=uGu8Rg1TwlBmPomUDlOvdO/phK+I6Z5JNUNCImhNQl0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CWKavgb809LqFeik/wHQDQ9RnHt0G0Uiq22mePNcPtjUcLEE6x6U38ikn4WEZwOGk
         OPy1b9J8F9nDSLfsQzE6T5UsmKnacmrrk4S/lzxECsDmnMUZv3497hgRK9nW27EBiy
         2d+3j1tsslSCJiFEZFpH713tnvIjKUJB27j0gsoq5eHnbeTXFc426kTUtEREefSEBY
         sCXRYmFNNlYRH2krSiSlcfjPdzwinsIX4OiwcToEUyjrHAAeGXHrWrFAnCUttyHKLG
         fR64V8rl7B3Ck61pdFBV7ZIvrqIk/mFTL8myYLnY/nY1PtcvPVyesUnRfRGXQ5Ym+K
         Slz2PVYbSlkKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3694E2A041;
        Sat, 27 Aug 2022 02:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] openvswitch: fix memory leak at failed datapath
 creation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156801479.24651.11589801362865992885.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 02:40:14 +0000
References: <20220825020326.664073-1-andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <20220825020326.664073-1-andrey.zhadchenko@virtuozzo.com>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, aconole@redhat.com, mark.d.gray@redhat.com,
        i.maximets@ovn.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 25 Aug 2022 05:03:26 +0300 you wrote:
> ovs_dp_cmd_new()->ovs_dp_change()->ovs_dp_set_upcall_portids()
> allocates array via kmalloc.
> If for some reason new_vport() fails during ovs_dp_cmd_new()
> dp->upcall_portids must be freed.
> Add missing kfree.
> 
> Kmemleak example:
> unreferenced object 0xffff88800c382500 (size 64):
>   comm "dump_state", pid 323, jiffies 4294955418 (age 104.347s)
>   hex dump (first 32 bytes):
>     5e c2 79 e4 1f 7a 38 c7 09 21 38 0c 80 88 ff ff  ^.y..z8..!8.....
>     03 00 00 00 0a 00 00 00 14 00 00 00 28 00 00 00  ............(...
>   backtrace:
>     [<0000000071bebc9f>] ovs_dp_set_upcall_portids+0x38/0xa0
>     [<000000000187d8bd>] ovs_dp_change+0x63/0xe0
>     [<000000002397e446>] ovs_dp_cmd_new+0x1f0/0x380
>     [<00000000aa06f36e>] genl_family_rcv_msg_doit+0xea/0x150
>     [<000000008f583bc4>] genl_rcv_msg+0xdc/0x1e0
>     [<00000000fa10e377>] netlink_rcv_skb+0x50/0x100
>     [<000000004959cece>] genl_rcv+0x24/0x40
>     [<000000004699ac7f>] netlink_unicast+0x23e/0x360
>     [<00000000c153573e>] netlink_sendmsg+0x24e/0x4b0
>     [<000000006f4aa380>] sock_sendmsg+0x62/0x70
>     [<00000000d0068654>] ____sys_sendmsg+0x230/0x270
>     [<0000000012dacf7d>] ___sys_sendmsg+0x88/0xd0
>     [<0000000011776020>] __sys_sendmsg+0x59/0xa0
>     [<000000002e8f2dc1>] do_syscall_64+0x3b/0x90
>     [<000000003243e7cb>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - [net,v2] openvswitch: fix memory leak at failed datapath creation
    https://git.kernel.org/netdev/net/c/a87406f4adee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


