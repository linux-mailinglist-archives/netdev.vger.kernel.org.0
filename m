Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D456E645828
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiLGKuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLGKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEB130573
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BF4F613F8
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77AA7C433C1;
        Wed,  7 Dec 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670410216;
        bh=3aUPGUmyb8rIql69muXhp786WojonmKcTlqkNRRjY4k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eu2iFlBrNmEZTb6DbDeIA2h2m7YbrXdyb+WrQA/DyWOgx6B7Os6x1Kc3qm6h04px8
         zkWwEUfZ0RNj2Lpn0nU2F7BmMctes2JNgVgSbz0uCN2rNCw03JUl+eDhvN38JdLJyL
         AU/pNG5gbvF5fYA/3bwE35CkAxxyXbREXz42vvFSelPFij9H6Q+4GpOTF+Ghnii+rG
         CI/APyUwO/ZKP1tYID6dqlzH4bYjarNJs9ICNY8ZLqE+OOyIGKAiSDEJ8aOHIkyIXu
         kCpZ2lqRouNM7gh40UjalHOkxv4+fWsvcpF9L7KhC+Rwq5DMadxxhe0C+u9rLxzAwe
         9SVnHFFmZyGMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D38DE4D02D;
        Wed,  7 Dec 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: call tipc_lxc_xmit without holding node_read_lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167041021637.1929.7865050600369880856.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 10:50:16 +0000
References: <5bdd1f8fee9db695cfff4528a48c9b9d0523fb00.1670110641.git.lucien.xin@gmail.com>
In-Reply-To: <5bdd1f8fee9db695cfff4528a48c9b9d0523fb00.1670110641.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com,
        shuali@redhat.com, hoang.h.le@dektech.com.au
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat,  3 Dec 2022 18:37:21 -0500 you wrote:
> When sending packets between nodes in netns, it calls tipc_lxc_xmit() for
> peer node to receive the packets where tipc_sk_mcast_rcv()/tipc_sk_rcv()
> might be called, and it's pretty much like in tipc_rcv().
> 
> Currently the local 'node rw lock' is held during calling tipc_lxc_xmit()
> to protect the peer_net not being freed by another thread. However, when
> receiving these packets, tipc_node_add_conn() might be called where the
> peer 'node rw lock' is acquired. Then a dead lock warning is triggered by
> lockdep detector, although it is not a real dead lock:
> 
> [...]

Here is the summary with links:
  - [net] tipc: call tipc_lxc_xmit without holding node_read_lock
    https://git.kernel.org/netdev/net/c/88956177db17

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


