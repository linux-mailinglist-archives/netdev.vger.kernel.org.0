Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D957518367
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiECLnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 07:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234801AbiECLnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 07:43:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24D7BD4;
        Tue,  3 May 2022 04:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73242B81C04;
        Tue,  3 May 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 337AFC385A9;
        Tue,  3 May 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651578011;
        bh=uBUEmPnRw30xrSn/uQ4xm5ZWcUu/jJiBOxud9n1rIzg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tFF7vAQceEL0bmMt6fklB7exInjL4aDmADpsvicZOnt2B+N4BQJGtMFfPXz6BkvX/
         /ppZgiUXf6ZbuobpCVF5fWOwRmQt8zi8avbGGMCr6gDxbzWaNjyi8w8HBmsyTHRJFL
         cSASXOVxo2nFxF4CkrnmfRJboaYwuJNCe+hCHNp8PQ3jS1DCrBZJ9C1YnqM1G3H1aT
         CduA8iHVRXlT5dBlWXE3GiTEgKNxHN1WNvfAmwifL7vq6rAA08JSx54ek8s+7FQjOo
         XRLgNO8B3Jgu7wRqMsjnNYRmiU2jizIfkgveVM7HpkDkTut/BMjOlLnHqQtqvXnUtA
         U2nbaQIG02dPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11A6CE8DD77;
        Tue,  3 May 2022 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
Date:   Tue, 03 May 2022 11:40:11 +0000
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
In-Reply-To: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     edumazet@google.com, santosh.shilimkar@oracle.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        syzbot+694120e1002c117747ed@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-rdma@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 2 May 2022 10:40:18 +0900 you wrote:
> syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
> for TCP socket used by RDS is accessing sock_net() without acquiring a
> refcount on net namespace. Since TCP's retransmission can happen after
> a process which created net namespace terminated, we need to explicitly
> acquire a refcount.
> 
> Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
> Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
> Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: rds: acquire refcount on TCP sockets
    https://git.kernel.org/netdev/net/c/3a58f13a881e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


