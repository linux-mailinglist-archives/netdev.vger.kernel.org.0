Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA11518FF2
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 23:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242808AbiECVVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 17:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242775AbiECVVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 17:21:35 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E84F40A37
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 14:17:54 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id r11so10404232ybg.6
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 14:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JJYf1HdtGbA9A9BBtbzwA8c5hbVd5d/CHGwQN7JwJ7U=;
        b=sR57+94S8K2MSBxIbfdVC2p1Sv5Z9xP0F60MBr2TtfFdVbe5aMktduW8o4oLoKUN7N
         xyko9XOV6IEoiuIXU2CcOmq8e5QM3C0m+WrlBv4DwwDJ3w0sa7eNEHSwnxV6upXlC5Ga
         5j+5Ls4BlLdjacOWYg2YcOM/xcYChlNvdOU+ZEFseusk9RWFvHHRad0/5oLcJScm2n+d
         USV+gPMGOwb/GB9CY3LpNXZ8Ns7Z3sUdJ0/5EmhjLe/6ue7fD73O/L5Ms8lqiNTKDgWK
         fZaC7dmfLlez40DJLF0QzWO/WuX1+AweXnMf9UyolcAAhJJxuO2B/yb7nftvYiYOlYz1
         04Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JJYf1HdtGbA9A9BBtbzwA8c5hbVd5d/CHGwQN7JwJ7U=;
        b=TQ3DTnHm5dSRqqHzMw4jhzBFpwKG4mZuhQiwBthgpfYcNiEnbZEn2su1GJo0a08a/6
         35oDAPBMbSltOf+19AIp8DZYk2TPoQn9w2k2atmU/VyESXRG9ssa5OEOHLm0Mccc+Ss1
         u+9mRz+ClpM3dHI6me76tUEntNKHMBVEnHoMzmQ81a5Wgru93TilMA0uX/6Uc23FNQWF
         0l3DO9MecHsVqhvB9zIDsSfa3lx87nMbaMQljK4W0PndUVBB/IfrY/xa0iJQuiJalr16
         UEoj5PbaeKe1FmYtgLEChP357Sef9uCmYrvo4lTTmrQOtPYfGYPDOcVMq9lxPPkn3qdA
         f5LQ==
X-Gm-Message-State: AOAM531Sn9kCmCJoBjI0j5Zv77MOB508D0UB3d3CStjbxpDYywV81GMf
        zMgSF8Vf26+zVthf4GEN6kyN1S+SGaK22KnWeuFw0PaQXd3X2E7k
X-Google-Smtp-Source: ABdhPJylOl26DLDExxtzn768hdr7IU/TnhArLsFIfmrQkxdHHXER15nBfzJzN7nmMPEqp/ZCVdxtFKYj9EUWWm8xss4=
X-Received: by 2002:a25:ba50:0:b0:649:b5b2:6fca with SMTP id
 z16-20020a25ba50000000b00649b5b26fcamr6272154ybj.55.1651612673190; Tue, 03
 May 2022 14:17:53 -0700 (PDT)
MIME-Version: 1.0
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp> <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
In-Reply-To: <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 May 2022 14:17:42 -0700
Message-ID: <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 4:40 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net.git (master)
> by Paolo Abeni <pabeni@redhat.com>:
>
> On Mon, 2 May 2022 10:40:18 +0900 you wrote:
> > syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
> > for TCP socket used by RDS is accessing sock_net() without acquiring a
> > refcount on net namespace. Since TCP's retransmission can happen after
> > a process which created net namespace terminated, we need to explicitly
> > acquire a refcount.
> >
> > Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
> > Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> > Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
> > Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
> >
> > [...]
>
> Here is the summary with links:
>   - [v2] net: rds: acquire refcount on TCP sockets
>     https://git.kernel.org/netdev/net/c/3a58f13a881e
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>
>

I think we merged this patch too soon.

My question is : What prevents rds_tcp_conn_path_connect(), and thus
rds_tcp_tune() to be called
after the netns refcount already reached 0 ?

I guess we can wait for next syzbot report, but I think that get_net()
should be replaced
by maybe_get_net()
