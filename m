Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E9B394DEF
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 21:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhE2Taz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 15:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhE2Tay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 15:30:54 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF00CC061574;
        Sat, 29 May 2021 12:29:16 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id p39so5856119pfw.8;
        Sat, 29 May 2021 12:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G46zYfujT4zH04/0cQEfJ1A0ViI5Iwfsu6ecTXtSdCo=;
        b=bFxRvq3tvmwy81Yfwj89IRa7IGHupYpQZlSGeD4L6D8SKb8eyPrKH8mHnUPemGNCcd
         JesWXoZARtAthklPXTrfMN1vF08KbC0/oCIhSu9TuoiRpzA8Nj7XZujBxOxwmmxRp2t3
         1n1iLoSpuz8JIplgWNTvn9HxomvChWLbGb7Jshh0q4n5LBDelbL/DTpplSuZJBcTknBJ
         v/gVosWZew1DRWTag2m2reBWCPzrdDRpOiQTAtL760g1o/S52aOJ9KFG8OexGwvr994t
         0q2dYyEHlyTUhUoF1oYyYQoXW3SZuiYqCDhaQYVvuitLT8w1AXDc3sWTUWIN3qCi1xFV
         wIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G46zYfujT4zH04/0cQEfJ1A0ViI5Iwfsu6ecTXtSdCo=;
        b=L9HEwy/MQ4bmgqWYOT7CftoUbQ03zfcUjmool5/6HU95uy4PhWTtaQdFRPvveWyStG
         GRZP0mGgXeYWyrsfeJbXI5cKQiJvlf2izyJWpeK5OPXPr9NWRAiJ076MmL13k/tgYek4
         sD2titpckO6/6ovoobhzcjGT58hP7EU/MVDWGqekMGc2tlBrbCp+6TOEGxXGfuNZUs1/
         I1ZAMyd0xSpor0ihMY4lwKgBZ3dtjLJIyh9/9wmAMjvp+03R0q/ZfsN8hxuDgOEKkwWZ
         4GHcJLnJDf1M2+YlYfHeWGmyTMC2jkTrwmqOlgu3f1/I06OQeTQDOubwTQAfsFyeVdlp
         EMlw==
X-Gm-Message-State: AOAM533BTmYDm9Z4LVUEbru4vQ+OZY8h+gp2mpRW0hmBME6O5pxSium9
        SnKlj7quGnEtNx82pBoskobX8W5JUoSOtyUWiLY=
X-Google-Smtp-Source: ABdhPJzhu75o9eNKgOpv5NFFTDClS9vE7XceJcioj7CP/6AGcYu3no9n8Be9KedyIoCUZDwm0umeFzQ8vGVTcPZInQU=
X-Received: by 2002:aa7:8f37:0:b029:2db:551f:ed8e with SMTP id
 y23-20020aa78f370000b02902db551fed8emr9815884pfr.43.1622316556333; Sat, 29
 May 2021 12:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
 <20210527011155.10097-9-xiyou.wangcong@gmail.com> <60b07f49377b6_1cf82088d@john-XPS-13-9370.notmuch>
In-Reply-To: <60b07f49377b6_1cf82088d@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 29 May 2021 12:29:05 -0700
Message-ID: <CAM_iQpU0evVG6_M33ZAgirRsTAJzZcMMN-cYfxqHepbC0UN0iQ@mail.gmail.com>
Subject: Re: [Patch bpf v3 8/8] skmsg: increase sk->sk_drops when dropping packets
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 10:27 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > It is hard to observe packet drops without increasing relevant
> > drop counters, here we should increase sk->sk_drops which is
> > a protocol-independent counter. Fortunately psock is always
> > associated with a struct sock, we can just use psock->sk.
> >
> > Suggested-by: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/core/skmsg.c | 22 ++++++++++++++--------
> >  1 file changed, 14 insertions(+), 8 deletions(-)
> >
>
> [...]
>
> > @@ -942,7 +948,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
> >       case __SK_DROP:
> >       default:
> >  out_free:
> > -             kfree_skb(skb);
> > +             sock_drop(psock->sk, skb);
>
> I must have missed this on first review.
>
> Why should we mark a packet we intentionally drop as sk_drops? I think
> we should leave it as just kfree_skb() this way sk_drops is just
> the error cases and if users want this counter they can always add
> it to the bpf prog itself.

This is actually a mixed case of error and non-error drops,
because bpf_sk_redirect_map() could return SK_DROP
in error cases. And of course users could want to drop packets
in whatever cases.

But if you look at packet filter cases, for example UDP one,
it increases drop counters too when user-defined rules drop
them:

2182         if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr)))
2183                 goto drop;
2184
...
2192 drop:
2193         __UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
2194         atomic_inc(&sk->sk_drops);
2195         kfree_skb(skb);
2196         return -1;


Thanks.
