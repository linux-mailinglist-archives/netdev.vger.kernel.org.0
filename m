Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091D74DDA90
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 14:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiCRNbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 09:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiCRNba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 09:31:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D64109A6C
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 06:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09E60619A2
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65797C340EC;
        Fri, 18 Mar 2022 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647610210;
        bh=1h+kwCWjboITFNeE05n8kNm7NMQ/K2XxAotA/W/cCZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sHfM55D3iOgbO2XHiKdJnrAJ5ccSi8r1eWxSdogDgfmUeFexvGueJrfhon77WQmnw
         qHjXkaBrdETbr7NwIhSwawd3rRI88iCjZo1YOh6d7a5n2icuElYRay306PQJkO47Pw
         4cRaiA/HQprey9kGbrTi219nAvrY+6XJoigPVnvFf5mjaqbtap8UB7PMH1QlFJIJ6m
         FLThVAX83vceODnwNpj97fSR9HwwdhfL3wru38corKcUAfZ+2LKMNfoCmaTeOTxwWW
         i+BcIi0lA/U9AAfUqrNrGcLNMYA9RqKWiWWh/69s1r8bOdI8snmV2ODuxMywiaEM9l
         LlbBd7NVpFMtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 484C6E6D402;
        Fri, 18 Mar 2022 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] ibmvnic: fix race between xmit and reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164761021029.28441.4974128678522799992.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 13:30:10 +0000
References: <20220317011231.1925467-1-sukadev@linux.ibm.com>
In-Reply-To: <20220317011231.1925467-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, brking@linux.ibm.com, drt@linux.ibm.com,
        ricklind@linux.ibm.com, vaish123@in.ibm.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Mar 2022 18:12:31 -0700 you wrote:
> There is a race between reset and the transmit paths that can lead to
> ibmvnic_xmit() accessing an scrq after it has been freed in the reset
> path. It can result in a crash like:
> 
> 	Kernel attempted to read user page (0) - exploit attempt? (uid: 0)
> 	BUG: Kernel NULL pointer dereference on read at 0x00000000
> 	Faulting instruction address: 0xc0080000016189f8
> 	Oops: Kernel access of bad area, sig: 11 [#1]
> 	...
> 	NIP [c0080000016189f8] ibmvnic_xmit+0x60/0xb60 [ibmvnic]
> 	LR [c000000000c0046c] dev_hard_start_xmit+0x11c/0x280
> 	Call Trace:
> 	[c008000001618f08] ibmvnic_xmit+0x570/0xb60 [ibmvnic] (unreliable)
> 	[c000000000c0046c] dev_hard_start_xmit+0x11c/0x280
> 	[c000000000c9cfcc] sch_direct_xmit+0xec/0x330
> 	[c000000000bfe640] __dev_xmit_skb+0x3a0/0x9d0
> 	[c000000000c00ad4] __dev_queue_xmit+0x394/0x730
> 	[c008000002db813c] __bond_start_xmit+0x254/0x450 [bonding]
> 	[c008000002db8378] bond_start_xmit+0x40/0xc0 [bonding]
> 	[c000000000c0046c] dev_hard_start_xmit+0x11c/0x280
> 	[c000000000c00ca4] __dev_queue_xmit+0x564/0x730
> 	[c000000000cf97e0] neigh_hh_output+0xd0/0x180
> 	[c000000000cfa69c] ip_finish_output2+0x31c/0x5c0
> 	[c000000000cfd244] __ip_queue_xmit+0x194/0x4f0
> 	[c000000000d2a3c4] __tcp_transmit_skb+0x434/0x9b0
> 	[c000000000d2d1e0] __tcp_retransmit_skb+0x1d0/0x6a0
> 	[c000000000d2d984] tcp_retransmit_skb+0x34/0x130
> 	[c000000000d310e8] tcp_retransmit_timer+0x388/0x6d0
> 	[c000000000d315ec] tcp_write_timer_handler+0x1bc/0x330
> 	[c000000000d317bc] tcp_write_timer+0x5c/0x200
> 	[c000000000243270] call_timer_fn+0x50/0x1c0
> 	[c000000000243704] __run_timers.part.0+0x324/0x460
> 	[c000000000243894] run_timer_softirq+0x54/0xa0
> 	[c000000000ea713c] __do_softirq+0x15c/0x3e0
> 	[c000000000166258] __irq_exit_rcu+0x158/0x190
> 	[c000000000166420] irq_exit+0x20/0x40
> 	[c00000000002853c] timer_interrupt+0x14c/0x2b0
> 	[c000000000009a00] decrementer_common_virt+0x210/0x220
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] ibmvnic: fix race between xmit and reset
    https://git.kernel.org/netdev/net/c/4219196d1f66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


