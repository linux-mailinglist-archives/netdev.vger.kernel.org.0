Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E129B49D15A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 19:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244063AbiAZSCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 13:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiAZSCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 13:02:39 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8904C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 10:02:39 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id i10so1117585ybt.10
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 10:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7SdXBvGbOpOY/4kmO/R/ivRpvZgo0xmy4QSxKe3/74U=;
        b=C2DN6CKH0cqmpDDWQpTb+86bIKfsusqney7cqrye6yUpfLpjk/wCs/URhXuomAzZDk
         /yS2jUbpei0RDYlq99g4Cv3mShTY4g3PcLJ6TN4XXkJffI8ZctAIQuIJNt83EcYDkmkF
         555l/foXGL6aD5yk/qzdYUFScRLCrJFQguz1UvvKfhl5TfWYnT0MxNdv5UYfepJ/KpMi
         iywi+CZmxjP10Cj0kp8I73RSHq2TXb61uIenzDS21+e3LPllp3XslIfhRGitY6B6v5t2
         zLo3bzRncg1QPNAZVY7UlVDLxxX8xW7xct7Kk3BrRBNDU5Qt+P3sZqImZEQAYW7Zkijs
         Gjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7SdXBvGbOpOY/4kmO/R/ivRpvZgo0xmy4QSxKe3/74U=;
        b=DL860WzcugAUiJ1FsFURRetnE5/uoMR2d1BdtK3vNL85SDZFtj+Sok4oKTkU2FGAGU
         zzGP84ii5JDb7F2a3Xx29CAfjDh/gVftSDaZsbk3OFwU6/I17Vf2mxrXFNtLhkOr05H+
         FJwu2dOw9rDpx0LCWrCmijHyUIMavMdn460DSmlmJTz8viKXkhuU4RGQhLxbgAQqZswL
         dabWJWQVmUZVT9XqcqSXx9cuqQ7XrCjc/LQaD3CUq2sJwEFm7lOtvM6sBPEGhAEdMoQG
         z13uGG6ytny6qvHo9Li2aRNFw3nzFai64vK0JXHZJHDToblSDuuqpXSie4f7YmQZkenu
         BKnw==
X-Gm-Message-State: AOAM5318IjHMljLJzgkfFBNOXUgapghJof73IgPB9DzkUayK/WROLHkm
        YSQ+jFu2uxlAcnmxtgyK6upCczWv8NfD1ir14Bh3qA==
X-Google-Smtp-Source: ABdhPJzLAcy57agCmX6g7z+ig3kGKeizB4jLOnpaZ7HV88XMt4hjkcq+h1pioK4RACpTvdeTdlFjqneU42Yf3n1hTXs=
X-Received: by 2002:a25:9d11:: with SMTP id i17mr73462ybp.383.1643220158473;
 Wed, 26 Jan 2022 10:02:38 -0800 (PST)
MIME-Version: 1.0
References: <20220124202457.3450198-1-eric.dumazet@gmail.com>
 <20220124202457.3450198-7-eric.dumazet@gmail.com> <6cccaaa7854c98248d663f60404ab6163250107f.camel@redhat.com>
 <CANn89iLCdpgh9vWd_A70mPqkRgLTk9aqNY=zV2ibtVus9YLxeA@mail.gmail.com> <3ecef3c4c1d158fc1c5812918e1710bce57c4812.camel@redhat.com>
In-Reply-To: <3ecef3c4c1d158fc1c5812918e1710bce57c4812.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 Jan 2022 10:02:27 -0800
Message-ID: <CANn89iJrm1yhQOdguVEHh5B=YJGJig-kV3QFkXRat=BWAOHuMQ@mail.gmail.com>
Subject: Re: [PATCH net-next 6/6] ipv4/tcp: do not use per netns ctl sockets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 8:35 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2022-01-26 at 08:24 -0800, Eric Dumazet wrote:
> > I was working a fix. syzbot found the issue yesterday before I went to bed ;)
>
> I know that is not a nice way to get some rest :(
>
> > (And this is not related to MPTCP)
> >
> > My plan is to make struct inet_timewait_death_row not a sub-strutcure
> > of struct netns_ipv4
> >
> > (the atomic_t tw_count becomes a refcount_t as a bonus)
>
> Sounds good. We can test the patch, if that helps (e.g. if syzbot lacks
> a repro or the repro is not very reliable)

Sure, I am going to CC you on the upcoming patch (in few minutes)

Thanks !
