Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530B35458A8
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242409AbiFIXdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345329AbiFIXdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:33:09 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26FE63503;
        Thu,  9 Jun 2022 16:33:05 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id r3so19850023ilt.8;
        Thu, 09 Jun 2022 16:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GjKCdHOKOJXiqOWxK8wP3ZWw1JOreBSaiDhIoPu+1D0=;
        b=AtPZ/xUWiWGDXu4TFxdox7hx7FKMio2mzUqlzzmB4MeykzrhzoIy/MDPDPnbJN1F1v
         19om9EPXIBlh/jpfSTuNvN5oK7gk6a1MGfKW+1oZGAhjoVTh0kHqIocY8xxRgH6YIJH9
         5JAFVa1B3yMVktEoudZuVJhWZWEo3dfMhE8UAhzNeJ8S6pZs2SulMR7VaI8JqarrfNUq
         FwKqhlWP2v1zP+QAQmOQFX/IzHd9cUkNdxxkOH6gLGHPX8whfRsk/3e7vjXgge0Oy86m
         hkNWHUgmw3npqAIgr3OA1qcqi9srV1lyiaz9xV8KwyW9/ATzQ7cl+QLlyriNQ6QBwBVU
         +dJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GjKCdHOKOJXiqOWxK8wP3ZWw1JOreBSaiDhIoPu+1D0=;
        b=v8ietYF7pFPCnECUBt26gFlXZOjb3nB+4ps8IPOaFYkrPyaI7fPNukmqM2QTdFEEhA
         3FoeplBuZQ0qz2+4W+X9RRcyJciirmicxOjAlh+mS3/S1euzimMitRnn/4NwP97A6AAX
         F4gxEte9I4zz4iuGblsJyWeInMCgzPlLAKBPovczxjlcRXv4TrDwcGzCeFO9yaaDN10R
         pHYIFQz1cFDxMeLLXc3o4E6DDoZKjjBYdg+wBZ4oD9M6DOcwKFe/HzqBfdI+CMvqULat
         lHzTPlN7Ov7zHzgZfFQu8B4p+KydoZ7BANxkK+jTNwFqIi78NpZImhwtVFNMU/1hFn9L
         xYiQ==
X-Gm-Message-State: AOAM531EqqzhtjarMK29laremK16ShYf674SkrpgBqZICJwi2Tqk8Vkt
        oVG3p7ggt8tYhW9mJw00g/2I1kbIpifcWOjcTHFY200m3eKKlw==
X-Google-Smtp-Source: ABdhPJw02J7vPYbtqUK/pc01O0WCpPtewBcihZkUNMYeMWAvLy5xie0vAvmlyGnd/gxosoGcIWPYFP2MFH/UzJpnpO0=
X-Received: by 2002:a05:6e02:b49:b0:2d1:c232:42af with SMTP id
 f9-20020a056e020b4900b002d1c23242afmr25439128ilu.292.1654817585020; Thu, 09
 Jun 2022 16:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220609011844.404011-1-jmaxwell37@gmail.com> <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
 <CAOftzPgU6EaCgf9E407JrbTfWXBYZL=nECWjySVjw8EPtJb6Cg@mail.gmail.com>
In-Reply-To: <CAOftzPgU6EaCgf9E407JrbTfWXBYZL=nECWjySVjw8EPtJb6Cg@mail.gmail.com>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Fri, 10 Jun 2022 09:32:29 +1000
Message-ID: <CAGHK07A_5ZZJkN6vYOTiy50SgF8MnKcO33CmiTzWMTj-YQ+DVg@mail.gmail.com>
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@cilium.io>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Antoine Tenart <atenart@kernel.org>, cutaylor-pub@yahoo.com,
        alexei.starovoitov@gmail.com, kafai@fb.com, i@lmb.io,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 8:22 AM Joe Stringer <joe@cilium.io> wrote:
>
> On Thu, Jun 9, 2022 at 1:30 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 6/9/22 3:18 AM, Jon Maxwell wrote:
> > > A customer reported a request_socket leak in a Calico cloud environment. We
> > > found that a BPF program was doing a socket lookup with takes a refcnt on
> > > the socket and that it was finding the request_socket but returning the parent
> > > LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> > > 1st, resulting in request_sock slab object leak. This patch retains the
> > > existing behaviour of returning full socks to the caller but it also decrements
> > > the child request_socket if one is present before doing so to prevent the leak.
> > >
> > > Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
> > > thanks to Antoine Tenart for the reproducer and patch input.
> > >
> > > Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
> > > Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
> > > Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
> > > Co-developed-by: Antoine Tenart <atenart@kernel.org>
> > > Signed-off-by:: Antoine Tenart <atenart@kernel.org>
> > > Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> > > ---
> > >   net/core/filter.c | 20 ++++++++++++++------
> > >   1 file changed, 14 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 2e32cee2c469..e3c04ae7381f 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
> > >   {
> > >       struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> > >                                          ifindex, proto, netns_id, flags);
> > > +     struct sock *sk1 = sk;
> > >
> > >       if (sk) {
> > >               sk = sk_to_full_sk(sk);
> > > -             if (!sk_fullsock(sk)) {
> > > -                     sock_gen_put(sk);
> > > +             /* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
> > > +              * sock refcnt is decremented to prevent a request_sock leak.
> > > +              */
> > > +             if (!sk_fullsock(sk1))
> > > +                     sock_gen_put(sk1);
> > > +             if (!sk_fullsock(sk))
> > >                       return NULL;
> >
> > [ +Martin/Joe/Lorenz ]
> >
> > I wonder, should we also add some asserts in here to ensure we don't get an unbalance for the
> > bpf_sk_release() case later on? Rough pseudocode could be something like below:
> >
> > static struct sock *
> > __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
> >                  struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
> >                  u64 flags)
> > {
> >          struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> >                                             ifindex, proto, netns_id, flags);
> >          if (sk) {
> >                  struct sock *sk2 = sk_to_full_sk(sk);
> >
> >                  if (!sk_fullsock(sk2))
> >                          sk2 = NULL;
> >                  if (sk2 != sk) {
> >                          sock_gen_put(sk);
> >                          if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
> >                                  WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
> >                                  sk2 = NULL;
> >                          }
> >                  }
> >                  sk = sk2;
> >          }
> >          return sk;
> > }
>
> This seems a bit more readable to me from the perspective of
> understanding the way that the socket references are tracked & freed.

Thanks for the suggestion Daniel and Joe, looks good to me, we will run some
tests with that implemented in our reproducer.

Regards

Jon
