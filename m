Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91822545952
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 02:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbiFJAtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 20:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiFJAtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 20:49:51 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFCB55B2
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 17:49:49 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id f12so19954031ilj.1
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 17:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IQBfuFQg11MwgcBTfYpZEPLIvXd8BQEbDfztL/woQ5Q=;
        b=TdSj6VJZM0S6K487QlDYaABQgyd57tudNLIpqW+PEvaoEcxcHIz8MNmuMTnVWDaNOj
         9dgNdbLNyvvn/fnaTLm+qnpZ5EFkR2m26i8BA8k0kFdmxYp4k83WOxNMaac47v5sRFYl
         Xh8Qf1stWl2ISSt/YvGvYGQ/MhAWsEYcAn0skL8ERi/SutLG+KW4EUkwI2fqZknMyYdX
         Dqnftb/1qBGpjn1KbxomeYClQYwHvDa8+ol6RnbpYH9NDoL+hof2UzoO7/rc+9B5jfGl
         HXYPQ/fhuaWhSAkiYCJzXHKHWWYYV4A9WSywptJH+qvbngb9fqR7rqxU425+nzw1vlO8
         u3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IQBfuFQg11MwgcBTfYpZEPLIvXd8BQEbDfztL/woQ5Q=;
        b=Gk8lQuQ+teBK3BD+n+8i7RMsJOtz+tuV5+UdZhv/9+UZTcIr5dJA6/tbFYLyPRN4hC
         fkwKHeysl6LLq0xwdneazkdv2Ipr0J8bFfRKs42+Ve8HS+qlyefYburR7xPUMQrxk+Os
         KP6hSY74Wm6M0RSGdVow00j3AXAj394F3tYyLQOxQ0NVjES9LCfA11J9Fjsnsd+1K7aX
         b2d0AGSSFY/za/n33BOeQnXHEJlZykB2sG5L4VcecjA9E5/K5cwf2OUxexghTmKUPA2X
         DteIk9TdWp5V6FBOZzoeFMLBRK77TtwwsI74c0xBtMmBom3uBatND7GSP1Ij0jtjqgGP
         TS/w==
X-Gm-Message-State: AOAM533gcf2MDz4tNN5sRVwcdpFMiadcFyCfh7Zop1ywu2pHCsoFLqEX
        GOSuJN06xC+Qj2JvxP78n1vD4vZ+oJALHijuXdOAeg4SmUo=
X-Google-Smtp-Source: ABdhPJzvyIKbcv1CYL8nsSPkyjVI7eaZxk8JnvCwkGLWCRIIFhMWwq/+aS9HhfKrkV3Wxdb7KLGVidNbeTBgDstQq2U=
X-Received: by 2002:a05:6e02:b49:b0:2d1:c232:42af with SMTP id
 f9-20020a056e020b4900b002d1c23242afmr25629700ilu.292.1654822189029; Thu, 09
 Jun 2022 17:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220609011844.404011-1-jmaxwell37@gmail.com> <165478172265.3884.13579040217428050738@kwain>
In-Reply-To: <165478172265.3884.13579040217428050738@kwain>
From:   Jonathan Maxwell <jmaxwell37@gmail.com>
Date:   Fri, 10 Jun 2022 10:49:13 +1000
Message-ID: <CAGHK07CUygP_90oLvsHEZSy1qRFk5fBqwL+rEp0ODwemq2KaZA@mail.gmail.com>
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        cutaylor-pub@yahoo.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 11:35 PM Antoine Tenart <atenart@kernel.org> wrote:
>
> Hi Jon,
>
> Quoting Jon Maxwell (2022-06-09 03:18:44)
> > A customer reported a request_socket leak in a Calico cloud environment. We
> > found that a BPF program was doing a socket lookup with takes a refcnt on
> > the socket and that it was finding the request_socket but returning the parent
> > LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> > 1st, resulting in request_sock slab object leak. This patch retains the
> > existing behaviour of returning full socks to the caller but it also decrements
> > the child request_socket if one is present before doing so to prevent the leak.
> >
> > Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
> > thanks to Antoine Tenart for the reproducer and patch input.
> >
> > Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
> > Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
>
> "bpf:" should be inside the parenthesis in the two above lines.
>
> Isn't the issue from before edbf8c01de5a for bpf_sk_lookup? Looking at a
> 5.1 kernel[1], __bpf_sk_lookup was called and also did the full socket
> translation[2]. bpf_sk_release would not be called on the original
> socket when that happens.
>
> [1] https://elixir.bootlin.com/linux/v5.1/source/net/core/filter.c#L5204
> [2] https://elixir.bootlin.com/linux/v5.1/source/net/core/filter.c#L5198
>
> > Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
> > Co-developed-by: Antoine Tenart <atenart@kernel.org>
> > Signed-off-by:: Antoine Tenart <atenart@kernel.org>
>
> Please remove the extra ':'.
>

Sure will correct those typos in v1.

Regards

Jon

> Thanks!
> Antoine
>
> > Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> > ---
> >  net/core/filter.c | 20 ++++++++++++++------
> >  1 file changed, 14 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 2e32cee2c469..e3c04ae7381f 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
> >  {
> >         struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> >                                            ifindex, proto, netns_id, flags);
> > +       struct sock *sk1 = sk;
> >
> >         if (sk) {
> >                 sk = sk_to_full_sk(sk);
> > -               if (!sk_fullsock(sk)) {
> > -                       sock_gen_put(sk);
> > +               /* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
> > +                * sock refcnt is decremented to prevent a request_sock leak.
> > +                */
> > +               if (!sk_fullsock(sk1))
> > +                       sock_gen_put(sk1);
> > +               if (!sk_fullsock(sk))
> >                         return NULL;
> > -               }
> >         }
> >
> >         return sk;
> > @@ -6239,13 +6243,17 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
> >  {
> >         struct sock *sk = bpf_skc_lookup(skb, tuple, len, proto, netns_id,
> >                                          flags);
> > +       struct sock *sk1 = sk;
> >
> >         if (sk) {
> >                 sk = sk_to_full_sk(sk);
> > -               if (!sk_fullsock(sk)) {
> > -                       sock_gen_put(sk);
> > +               /* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
> > +                * sock refcnt is decremented to prevent a request_sock leak.
> > +                */
> > +               if (!sk_fullsock(sk1))
> > +                       sock_gen_put(sk1);
> > +               if (!sk_fullsock(sk))
> >                         return NULL;
> > -               }
> >         }
> >
> >         return sk;
> > --
> > 2.31.1
> >
