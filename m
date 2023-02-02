Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B6D6887A1
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBBTkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjBBTkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079187A4BA;
        Thu,  2 Feb 2023 11:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAD72B827EB;
        Thu,  2 Feb 2023 19:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43E31C4339C;
        Thu,  2 Feb 2023 19:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675366818;
        bh=sVehoMmV098RW3QEDQPgN/3VzftEmgxjX/Yq7LNVoQI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FUFbLSdLIKfWYNjf2ZJdbhByRtJT1bPFoGt+zm9bgta1M1rnbqWa76WjwaH8ZmXBN
         9eCrRWjHLGUxAQC7MsW7i36rNRgvRq4Qb27Pvaqr06d5ScRvUo+OUkEyxYeJTUhmcB
         oU9GSr8ZTnu42rdDosoLdwxQ+pcN2BkHupEP3qqMOjs7yGMgiWL+lKYcvqkcacNRaU
         bgILS1tZ12BpApebIK05RRlhZ592r7cy5/F7nXbEN93gYBeDXe+2DPpjI+NA05xnV3
         NK0DPEQJdJRpZg2JbSD6lyYWnjcxLjADyH1tKJtKRh/vbszjzdRbgZgLNefuIhp1Nn
         ugL4avrQGcyLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2392CC0C40E;
        Thu,  2 Feb 2023 19:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: openvswitch: fix flow memory leak in ovs_flow_cmd_new
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167536681814.25016.4688800078010705767.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 19:40:18 +0000
References: <20230201210218.361970-1-pchelkin@ispras.ru>
In-Reply-To: <20230201210218.361970-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     pshelar@ovn.org, simon.horman@corigine.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        echaudro@redhat.com, netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, khoroshilov@ispras.ru,
        lvc-project@linuxtesting.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  2 Feb 2023 00:02:18 +0300 you wrote:
> Syzkaller reports a memory leak of new_flow in ovs_flow_cmd_new() as it is
> not freed when an allocation of a key fails.
> 
> BUG: memory leak
> unreferenced object 0xffff888116668000 (size 632):
>   comm "syz-executor231", pid 1090, jiffies 4294844701 (age 18.871s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000defa3494>] kmem_cache_zalloc include/linux/slab.h:654 [inline]
>     [<00000000defa3494>] ovs_flow_alloc+0x19/0x180 net/openvswitch/flow_table.c:77
>     [<00000000c67d8873>] ovs_flow_cmd_new+0x1de/0xd40 net/openvswitch/datapath.c:957
>     [<0000000010a539a8>] genl_family_rcv_msg_doit+0x22d/0x330 net/netlink/genetlink.c:739
>     [<00000000dff3302d>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
>     [<00000000dff3302d>] genl_rcv_msg+0x328/0x590 net/netlink/genetlink.c:800
>     [<000000000286dd87>] netlink_rcv_skb+0x153/0x430 net/netlink/af_netlink.c:2515
>     [<0000000061fed410>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>     [<000000009dc0f111>] netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
>     [<000000009dc0f111>] netlink_unicast+0x545/0x7f0 net/netlink/af_netlink.c:1339
>     [<000000004a5ee816>] netlink_sendmsg+0x8e7/0xde0 net/netlink/af_netlink.c:1934
>     [<00000000482b476f>] sock_sendmsg_nosec net/socket.c:651 [inline]
>     [<00000000482b476f>] sock_sendmsg+0x152/0x190 net/socket.c:671
>     [<00000000698574ba>] ____sys_sendmsg+0x70a/0x870 net/socket.c:2356
>     [<00000000d28d9e11>] ___sys_sendmsg+0xf3/0x170 net/socket.c:2410
>     [<0000000083ba9120>] __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
>     [<00000000c00628f8>] do_syscall_64+0x30/0x40 arch/x86/entry/common.c:46
>     [<000000004abfdcf4>] entry_SYSCALL_64_after_hwframe+0x61/0xc6
> 
> [...]

Here is the summary with links:
  - [v2] net: openvswitch: fix flow memory leak in ovs_flow_cmd_new
    https://git.kernel.org/netdev/net/c/0c598aed445e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


