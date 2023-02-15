Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335AC697586
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjBOEuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBOEuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13742D15A
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 20:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5291661A22
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 04:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAD6CC4339E;
        Wed, 15 Feb 2023 04:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676436617;
        bh=wzyfWRKqgZ5YhZD/SH44xv4dmKg7PBTlrhSY3Xp11jM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wh5v35smoi1uyAfswKi5tBcRDDvRkjEnLdQ5Q4XKmrEh1fgVVbb3w3x84mbB8lnlf
         6HvWbFwbW0y0vUSnIwu6Eusi+gxo2/3SBTgInRVtHRQe6ChWWrWlor3+Eacm4Zejj6
         8xdNpUtoENmZG5S/oqX9F44fE9ABVi9LbSiuZp5kwe7wDVUjvEvyituO8ZhfHWKZou
         2ZffRNmYkCoKwjN9NE50YaGJX2vc1yDm1R5Ltmn/F+d1IV7E9bOUafXlhvz9+H9Pow
         YhHwjsdj4nEMd/mO8tqCQ0WIt7JEPKi73mxut0ky7SeTo2SvfyBkANH2DkeDs3RA8u
         mYIyD4ZzLRsLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8DED9C41677;
        Wed, 15 Feb 2023 04:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 1/1] tipc: fix kernel warning when sending SYN message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167643661757.17897.9736157294318564161.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 04:50:17 +0000
References: <20230214012606.5804-1-tung.q.nguyen@dektech.com.au>
In-Reply-To: <20230214012606.5804-1-tung.q.nguyen@dektech.com.au>
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, jmaloy@redhat.com,
        ying.xue@windriver.com, viro@zeniv.linux.org.uk,
        syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Feb 2023 01:26:06 +0000 you wrote:
> When sending a SYN message, this kernel stack trace is observed:
> 
> ...
> [   13.396352] RIP: 0010:_copy_from_iter+0xb4/0x550
> ...
> [   13.398494] Call Trace:
> [   13.398630]  <TASK>
> [   13.398630]  ? __alloc_skb+0xed/0x1a0
> [   13.398630]  tipc_msg_build+0x12c/0x670 [tipc]
> [   13.398630]  ? shmem_add_to_page_cache.isra.71+0x151/0x290
> [   13.398630]  __tipc_sendmsg+0x2d1/0x710 [tipc]
> [   13.398630]  ? tipc_connect+0x1d9/0x230 [tipc]
> [   13.398630]  ? __local_bh_enable_ip+0x37/0x80
> [   13.398630]  tipc_connect+0x1d9/0x230 [tipc]
> [   13.398630]  ? __sys_connect+0x9f/0xd0
> [   13.398630]  __sys_connect+0x9f/0xd0
> [   13.398630]  ? preempt_count_add+0x4d/0xa0
> [   13.398630]  ? fpregs_assert_state_consistent+0x22/0x50
> [   13.398630]  __x64_sys_connect+0x16/0x20
> [   13.398630]  do_syscall_64+0x42/0x90
> [   13.398630]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - [v3,net,1/1] tipc: fix kernel warning when sending SYN message
    https://git.kernel.org/netdev/net/c/11a4d6f67cf5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


