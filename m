Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787274CD50F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiCDNVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiCDNVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:21:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3BF22BEE
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 05:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2664760DE8
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 13:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3975EC340F1;
        Fri,  4 Mar 2022 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646400010;
        bh=u1/GbaNL8gOGSOiPgxt/QeyQ9XbWLAk26Pf0RUAAZbM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eq+gCtVOgpF6Ff2BynmEVsPGK4M/4wDErMYvjtxV4SEDLZni+m+C/K2wJ4OQkBdLZ
         zAMNvSXC9M2RJ4Q8BjO35y7KP+cNiaE+2WFWbd2XzU68J8q0N1HZKdXP7/LHZZ4Kqr
         NJhvSaUbpAetMjwq495VFjwplwFfE3GlJOAhZWTr3efZDryjrT/alavV1QBSJtiAx4
         ZA+Ad0+4f+gOzFwkoH+u3CKYMbcjGuUpL+1GU1rDORiS4FtSaQX6Zt9aOQTj+IJKXW
         MAoX6NqlJswJNqO1cJM1YPwaTy/U2uXK+eGr95SX2LfKhhKRRoQtbIIgndiTtPgfyz
         UM5YGG1//AaWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16772EAC095;
        Fri,  4 Mar 2022 13:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] tipc: fix kernel panic when enabling bearer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164640001008.11229.394495890772849018.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 13:20:10 +0000
References: <20220304032518.9305-1-tung.q.nguyen@dektech.com.au>
In-Reply-To: <20220304032518.9305-1-tung.q.nguyen@dektech.com.au>
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, kuba@kernel.org, shuali@redhat.com,
        jmaloy@redhat.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Mar 2022 03:25:18 +0000 you wrote:
> When enabling a bearer on a node, a kernel panic is observed:
> 
> [    4.498085] RIP: 0010:tipc_mon_prep+0x4e/0x130 [tipc]
> ...
> [    4.520030] Call Trace:
> [    4.520689]  <IRQ>
> [    4.521236]  tipc_link_build_proto_msg+0x375/0x750 [tipc]
> [    4.522654]  tipc_link_build_state_msg+0x48/0xc0 [tipc]
> [    4.524034]  __tipc_node_link_up+0xd7/0x290 [tipc]
> [    4.525292]  tipc_rcv+0x5da/0x730 [tipc]
> [    4.526346]  ? __netif_receive_skb_core+0xb7/0xfc0
> [    4.527601]  tipc_l2_rcv_msg+0x5e/0x90 [tipc]
> [    4.528737]  __netif_receive_skb_list_core+0x20b/0x260
> [    4.530068]  netif_receive_skb_list_internal+0x1bf/0x2e0
> [    4.531450]  ? dev_gro_receive+0x4c2/0x680
> [    4.532512]  napi_complete_done+0x6f/0x180
> [    4.533570]  virtnet_poll+0x29c/0x42e [virtio_net]
> ...
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] tipc: fix kernel panic when enabling bearer
    https://git.kernel.org/netdev/net/c/be4977b847f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


