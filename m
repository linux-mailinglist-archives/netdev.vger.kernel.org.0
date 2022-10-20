Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3FC606BFC
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 01:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJTXP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 19:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJTXPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 19:15:55 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF249224AA2
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 16:15:52 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 63so1382301ybq.4
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 16:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QQpKi+x0LxKqACw/uNBS2aGbKtD5lhFqr7fDWjj/DZQ=;
        b=AT3Tr1In+x+ghVAY9rGnfzzQOgsij6yefZ4tFa0cTQaQQa61QFdfVTwgNj8l2ZfVmi
         mO0/JTt5NXfhWLzTrVdVol/pguP4syq5E5kZGYWSN541/u/wNhlnGBc0Twgn0izew/13
         07nN9lSC18EETJshcwk/N9FAqY4mnU81U+bQDyGgaFZj5ij+lq+ekU3sBj0szsKfp2qs
         5MMHQUF2SqvVS3uoKwiMJM+A/hsiNrg7ZbEAyzoip6owdbAco6czZ74nVbCxHMSYrE0H
         tsHmxXQAiysV8ksTLO0Nobya4Q6WoLSL7yuW0xBjpyjS0GOOPpuxGKRtgyUsbQSrM+/x
         FtBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QQpKi+x0LxKqACw/uNBS2aGbKtD5lhFqr7fDWjj/DZQ=;
        b=yvZOWClQGuuymYjEDygxOL3Cb5p2HgCLnHGc9BkzW8uMO57RKdJc41RtPkogr5y9M2
         7E1DKyPf6JwvaJH9XBv3Q3UzC+nUukUK6LFIOJ/K6R5d7F5DAgNNbyVLGJzT6HYuYZpl
         NWqbEVaFvfYShKlVcRb3rWerS1wyrFQXLpUCs9CVC5hd247acZLoKihYrqwrzz1CQB69
         9L+5nIbPlzErkYhw4uE4Ezh2LUyIg5fKJjcFfWlt4rwIHsMSPz/fX+DyuM/hQf5kFfK0
         HnxjYWv4bReHGLjrHYbr968vWYc3Sh6SFUw3TpNgeACJkJoV80XfEtFp7KUSJ5TGee0Q
         3lWg==
X-Gm-Message-State: ACrzQf1YuzbpjjIjoljSC8wJ9KC77ONH7SHqg/2u4rc1x7PDetwcPCWa
        UFVcrNDEUri6B3tpeA66kV8VBi1qC/75/9/KFmyEFw==
X-Google-Smtp-Source: AMsMyM7TmQlK8F3tp1t9JmyRlR6fHIN0hO5YnJsY48kwxCPCEAMI7OSOkw+fY933VPRfKPmRSk1JU85KzEik4w0uWXs=
X-Received: by 2002:a25:32ca:0:b0:6ca:40e2:90c8 with SMTP id
 y193-20020a2532ca000000b006ca40e290c8mr3948169yby.55.1666307751606; Thu, 20
 Oct 2022 16:15:51 -0700 (PDT)
MIME-Version: 1.0
References: <20221020143201.339599-1-luwei32@huawei.com> <20221020205730.10875-1-kuniyu@amazon.com>
In-Reply-To: <20221020205730.10875-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Oct 2022 16:15:40 -0700
Message-ID: <CANn89iL9pbcNxWxKBqDNsRdSmiZb4F3rQS3FNVzK=yL5JshsHw@mail.gmail.com>
Subject: Re: [PATCH -next,v2] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     luwei32@huawei.com, asml.silence@gmail.com, ast@kernel.org,
        davem@davemloft.net, dsahern@kernel.org, imagedong@tencent.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, ncardwell@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 1:57 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Hi,
>
> The subject should be
>
>   [PATCH net v2] tcp: ....
>
> so that this patch will be backported to the stable tree.
>
>
> From:   Lu Wei <luwei32@huawei.com>
> Date:   Thu, 20 Oct 2022 22:32:01 +0800
> > The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
> > in tcp_add_backlog(), the variable limit is caculated by adding
> > sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
> > of int and overflow. This patch limits sk_rcvbuf and sk_sndbuf
> > to 0x7fff000 and transfers them to u32 to avoid signed-integer
> > overflow.
> >
> > Fixes: c9c3321257e1 ("tcp: add tcp_add_backlog()")
> > Signed-off-by: Lu Wei <luwei32@huawei.com>
> > ---
> >  include/net/sock.h  |  5 +++++
> >  net/core/sock.c     | 10 ++++++----
> >  net/ipv4/tcp_ipv4.c |  3 ++-
> >  3 files changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 9e464f6409a7..cc2d6c4047c2 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -2529,6 +2529,11 @@ static inline void sk_wake_async(const struct sock *sk, int how, int band)
> >  #define SOCK_MIN_SNDBUF              (TCP_SKB_MIN_TRUESIZE * 2)
> >  #define SOCK_MIN_RCVBUF               TCP_SKB_MIN_TRUESIZE
> >
> > +/* limit sk_sndbuf and sk_rcvbuf to 0x7fff0000 to prevent overflow
> > + * when adding sk_sndbuf, sk_rcvbuf and 64K in tcp_add_backlog()
> > + */
> > +#define SOCK_MAX_SNDRCVBUF           (INT_MAX - 0xFFFF)
>
> Should we apply this limit in tcp_rcv_space_adjust() ?
>
>         int rcvmem, rcvbuf;
>         ...
>         rcvbuf = min_t(u64, rcvwin * rcvmem,
>                        READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
>         if (rcvbuf > sk->sk_rcvbuf) {
>                 WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
>         ...
>         }
>
> We still have 64K space if sk_rcvbuf were INT_MAX here though.
>

Thinking more about this, I think we could solve the issue by reducing
the budget
we account for sndbuf.

ACK packets are much smaller than the payload.

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6376ad91576546d48ffcc8ed9cdf8a1904679e33..4bbefb50fe472f69f3eaa1983539595b6fd2e9f4
100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1874,11 +1874,13 @@ bool tcp_add_backlog(struct sock *sk, struct
sk_buff *skb,
        __skb_push(skb, hdrlen);

 no_coalesce:
+       limit = READ_ONCE(sk->sk_rcvbuf) + (READ_ONCE(sk->sk_sndbuf) >> 1);
+
        /* Only socket owner can try to collapse/prune rx queues
         * to reduce memory overhead, so add a little headroom here.
         * Few sockets backlog are possibly concurrently non empty.
         */
-       limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
+       limit += 64*1024;

        if (unlikely(sk_add_backlog(sk, skb, limit))) {
                bh_unlock_sock(sk);
