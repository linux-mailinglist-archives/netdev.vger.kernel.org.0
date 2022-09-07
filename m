Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A285AFFC0
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiIGI7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIGI7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:59:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582A715FC5;
        Wed,  7 Sep 2022 01:59:41 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 73so13005077pga.1;
        Wed, 07 Sep 2022 01:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=mKARXm2kMQBJjCoMq1zHo4f6Vijr8sVnvDkYWq/yY00=;
        b=JyzYTnj4Jo1BhJLatgnyH3qO4uNfq7eYWswaPviDRn6zx52TDlV0p+EXjU0/Fj0fBp
         M26YLiYs0SQDzb221bpFX45l30bIjt4i97wrGCR2gHdPUrD8HjxO/WD5gOTMiXWBPr7T
         NBnSINLZz7XpDL0XyMVuWoD7KEY7VEXdKvCxDr1ujie3p4uvgNV9GqLv1WrJ8RhQLxI7
         m8u8O860aneQz74CickxPrLWsfzQfLMHKWnxK9criXkbM7wRbOcYrTMHw+3sBXCaMpj0
         Emt57oBDZZAVyG0XMaXOk6CQHkTX5B8Y2LBvIV4TPOzahoTWXK168Pam0ZfLgG7E82be
         OztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=mKARXm2kMQBJjCoMq1zHo4f6Vijr8sVnvDkYWq/yY00=;
        b=6ADZhX1664NI1adSRckpo3kYQ+aFN6T8razeeCVtC5J8ZSiU4dHHq8RtxrMTX4/VvI
         1XPqvb+YCTHIVBYGmOHeUAfjWeI+QOuDfK3oNmHf+c5XpZOx5jgkJnvMCxBDZ72lfAR3
         VUsXqLIq60uj9oxC98bGxgH30auVRUEHn73V0ZFP3zUcdxS5hBfIEAKnfjRnM1IdQFXr
         6XOaT1M2O9sM6SbxqmgFG5QGySUsIGG/wskND+jmj+X1lxZzT7gKINPr27d4yO4o++jE
         U5FqgmTAN2bAdFi6yIEaI8onBfqa2U7lI0ceyQDraI/dlT7gSWLWIgbyJVM6UJUXpvxj
         FUyg==
X-Gm-Message-State: ACgBeo3dZKhSl8wyjxqaE0RS+jnOuY1ym/KggDs2IFOXyPeiTSEZA/E0
        bGJ9xMmJLWcA7KssUDPkVOaUc7de9ib/zGmf8XE=
X-Google-Smtp-Source: AA6agR7ugy96b6qwQ050Ysi1QiI6Gbohgqoj15UIwkoRiZqKNeVKVVYF3ex9FrK9aiSxRamzOtC48nmR7WaTNe2dVjM=
X-Received: by 2002:a05:6a00:1307:b0:53a:9663:1bd6 with SMTP id
 j7-20020a056a00130700b0053a96631bd6mr2779063pfu.55.1662541180552; Wed, 07 Sep
 2022 01:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220907083304.605526-1-imagedong@tencent.com> <873298fe-7fc2-4417-2852-5180f81f94aa@tessares.net>
In-Reply-To: <873298fe-7fc2-4417-2852-5180f81f94aa@tessares.net>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 7 Sep 2022 16:59:29 +0800
Message-ID: <CADxym3YQCjpVXs8EZr_B7iJDdbjOv53kqiqZqZmJ4fh3KUbzrg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: mptcp: fix unreleased socket in accept queue
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        fw@strlen.de, peter.krystad@linux.intel.com,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Mengen Sun <mengensun@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 7, 2022 at 4:51 PM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> Hi Menglong,
>
> On 07/09/2022 10:33, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > The mptcp socket and its subflow sockets in accept queue can't be
> > released after the process exit.
> >
> > While the release of a mptcp socket in listening state, the
> > corresponding tcp socket will be released too. Meanwhile, the tcp
> > socket in the unaccept queue will be released too. However, only init
> > subflow is in the unaccept queue, and the joined subflow is not in the
> > unaccept queue, which makes the joined subflow won't be released, and
> > therefore the corresponding unaccepted mptcp socket will not be released
> > to.
>
> Thank you for the patch!
>
> (...)
>
> > ---
> >  net/mptcp/protocol.c | 13 +++++++++----
> >  net/mptcp/subflow.c  | 33 ++++++++-------------------------
> >  2 files changed, 17 insertions(+), 29 deletions(-)
> >
> > diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> > index d398f3810662..fe6b7fbb145c 100644
> > --- a/net/mptcp/protocol.c
> > +++ b/net/mptcp/protocol.c
> > @@ -2796,13 +2796,12 @@ static void __mptcp_destroy_sock(struct sock *sk)
> >       sock_put(sk);
> >  }
> >
> > -static void mptcp_close(struct sock *sk, long timeout)
> > +void mptcp_close_nolock(struct sock *sk, long timeout)
>
> I didn't look at it into details but like the previous previous, I don't
> think this one compiles without errors: you define this (non static)
> function here in protocol.c but you don't "expose" it in protocol.h ...
> (see below)
>

Oops...I forgot to commit the protocol.h :)

> > diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> > index c7d49fb6e7bd..cebabf2bb222 100644
> > --- a/net/mptcp/subflow.c
> > +++ b/net/mptcp/subflow.c
>
> (...)
>
> > @@ -1765,11 +1740,19 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
> >               struct sock *sk = (struct sock *)msk;
> >               bool slow;
> >
> > +             sock_hold(sk);
> >               slow = lock_sock_fast_nested(sk);
> >               next = msk->dl_next;
> >               msk->first = NULL;
> >               msk->dl_next = NULL;
> > +
> > +             /* mptcp_close_nolock() will put a extra reference on sk,
> > +              * so we hold one here.
> > +              */
> > +             sock_hold(sk);
> > +             mptcp_close_nolock(sk, 0);
>
> ... I guess the compiler will complain if you try to use it here from
> subflow.c, no?
>

Hmm...The compiler didn't, as I modified protocol.h locally. That
's why I didn't find this mistake :)

> Also, did you have the opportunity to run the different MPTCP selftests
> with this patch?
>

Not yet. I'll do it before the next version.

Thanks!
Menglong Dong

> Cheers,
> Matt
> --
> Tessares | Belgium | Hybrid Access Solutions
> www.tessares.net
