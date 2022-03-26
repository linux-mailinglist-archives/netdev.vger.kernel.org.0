Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB52D4E838A
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 19:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiCZSvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 14:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiCZSvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 14:51:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1F8369FB;
        Sat, 26 Mar 2022 11:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1490EB80B84;
        Sat, 26 Mar 2022 18:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2C98C340F3;
        Sat, 26 Mar 2022 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648320610;
        bh=An/i1g5oXYjt2a1ViSlXAPzVxWsKvxZ9XRyMCj3S2C0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KVLvFrJL8OY5a6wBnkpK28z7rYc2KJUE3PRQ7MFDyTKiqzMOCvA85pMJcm0PIXwgW
         gKdjrx0Rju03WOhg9SYIz/ERGsINsE5PnUP8mjMuLN8Qfdf4QJkxh5YdgpyZFsPxzY
         ow+tuUzDsBnCFaGZOPSodR8NWh5MfW58bpru73nZIn6mymg5eStN0MXAR9s+D3UUJH
         Vxqxas4l1hLpi1zB9u4/Ro1n0ES5I/qLu/Oc8v5fGGFVgy3f43j1+RCZl4QkeO0IWW
         heUZ22jdVRbLjcZS0116wo3xDh4ri6iovl7ZkF1gZjbHaUbHRrYe9la3WFFiLFEllS
         AnK+o/m1omPNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 874A2E6D402;
        Sat, 26 Mar 2022 18:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] net/x25: Fix null-ptr-deref caused by x25_disconnect
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164832061055.28772.13748131132872742265.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Mar 2022 18:50:10 +0000
References: <20220326104346.91790-1-duoming@zju.edu.cn>
In-Reply-To: <20220326104346.91790-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ms@dev.tdt.de, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, tanxin.ctf@gmail.com,
        xiyuyang19@fudan.edu.cn, linma@zju.edu.cn
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 26 Mar 2022 18:43:46 +0800 you wrote:
> When the link layer is terminating, x25->neighbour will be set to NULL
> in x25_disconnect(). As a result, it could cause null-ptr-deref bugs in
> x25_sendmsg(),x25_recvmsg() and x25_connect(). One of the bugs is
> shown below.
> 
>     (Thread 1)                 |  (Thread 2)
> x25_link_terminated()          | x25_recvmsg()
>  x25_kill_by_neigh()           |  ...
>   x25_disconnect()             |  lock_sock(sk)
>    ...                         |  ...
>    x25->neighbour = NULL //(1) |
>    ...                         |  x25->neighbour->extended //(2)
> 
> [...]

Here is the summary with links:
  - [net,V2] net/x25: Fix null-ptr-deref caused by x25_disconnect
    https://git.kernel.org/netdev/net/c/7781607938c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


