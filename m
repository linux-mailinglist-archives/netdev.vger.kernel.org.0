Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0B2617D30
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 14:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiKCNAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 09:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiKCNAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 09:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3D312A83;
        Thu,  3 Nov 2022 06:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A8B4B82799;
        Thu,  3 Nov 2022 13:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2565C43140;
        Thu,  3 Nov 2022 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667480417;
        bh=/RcpRCslqdurdWFMDiPMIadrby9asW2XcMsNObuAVjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kdv4i61QzKck3FtR0FUXRUmFz0GfZ7D14JE/NmorbIekj8Gk296REpI4rBvIJ7shg
         zgpfZJ1zqT7MjWxvIlzjt4nohGYA+Gp8Oi4t0QhJ/5cEvOfVbYfOqZIvQaplczMdvT
         EmumuBeETc7LcJXVv0efMCwUOAQq8PYDAGNTD1sGnp6CnAY5EiFLYANbwNPSJoIEuQ
         n3arQCBoY3OG3B5I9QSIpX8RQRsbS9CcCY6J83lQnF2jh1r1q2xGctceynLBuOaUxo
         X3ojdEuhdYLdXbG96Ntq+J9DYPhJ+ST5fdMzjwBxs1JtzeN610a8vDE89IKDIVbrFT
         8vWOehtRdirFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D38F4C41621;
        Thu,  3 Nov 2022 13:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch bpf v2] sock_map: move cancel_work_sync() out of sock lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166748041685.25771.12086173509106537354.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 13:00:16 +0000
References: <20221102043417.279409-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20221102043417.279409-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com, sdf@google.com, john.fastabend@gmail.com,
        jakub@cloudflare.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue,  1 Nov 2022 21:34:17 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Stanislav reported a lockdep warning, which is caused by the
> cancel_work_sync() called inside sock_map_close(), as analyzed
> below by Jakub:
> 
> psock->work.func = sk_psock_backlog()
>   ACQUIRE psock->work_mutex
>     sk_psock_handle_skb()
>       skb_send_sock()
>         __skb_send_sock()
>           sendpage_unlocked()
>             kernel_sendpage()
>               sock->ops->sendpage = inet_sendpage()
>                 sk->sk_prot->sendpage = tcp_sendpage()
>                   ACQUIRE sk->sk_lock
>                     tcp_sendpage_locked()
>                   RELEASE sk->sk_lock
>   RELEASE psock->work_mutex
> 
> [...]

Here is the summary with links:
  - [bpf,v2] sock_map: move cancel_work_sync() out of sock lock
    https://git.kernel.org/bpf/bpf/c/8bbabb3fddcd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


