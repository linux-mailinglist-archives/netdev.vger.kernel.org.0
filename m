Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D75F1313
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiI3UBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiI3UBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:01:07 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB65D124C29
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 13:01:06 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id s14so6533954ybe.7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 13:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=qvTkOTGHtHTHvpRpYjb2UIM97fETiNZjnxR44+S+/qg=;
        b=AUsCE4HTLVqwolGZPl1t6sd2EGY6pzuiiBSj2zXV+7ndIBw2uRrjan1dD9dmAO+xIr
         fJcOLnhfjv0a1x8rl5hReyDZow+GY0uNZxonC54ikAtrB3Ksc3aeYMQZEFdwHYOhmUl1
         EuCdXSwJ5ixqCROikCn5DDLNIi9OF4v5RytRkN9WvwVE6OCi2kekHeoyuh5rfjSQCziE
         NN5t3PcDQw+2m46VQAJqtd8LiBKTu1potZENH3ddZpJpyx64nQukykxvMM1DzBETxOzr
         W7mBIwHPkT088jq82E45bezNXJwTDe6R34QMMZbfhkAHMFIB+a34yjAqnegYVu2S+wfb
         Ev9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=qvTkOTGHtHTHvpRpYjb2UIM97fETiNZjnxR44+S+/qg=;
        b=vO8xmFrXzvEJ4QMvqhfNOoc7Kw5/aple6/YfBhido+UZP8sp6aEdsJXhEMczi6OdFZ
         48aIX59MyUxHVKPq8KlzVf6ZXSNLvX9IWL6Bg6sLDBXjvR8e60OmuTA2S+cQxdJsbPeq
         I77Uke+c/yVbVeB934tUNHxVkEmMFPDVLyFYbzS3VjpPno21evvwJAwL8jmZF2XPSnY4
         grEVwQ0YN4ayy0OojrVWykoXpdHofUB5rwfV5PXIJUOsr+oXlh++kzbCCJOoSG1WU5qd
         MHyBHYBl0jHEMClYe+ynfMuxZg/BfFS5RnKDmq+8eWJgIJpBzEBSpf7z6968JZV1PQ8/
         K2vA==
X-Gm-Message-State: ACrzQf0ol+UZRzhB40GMvsB1QACeSIY0PsCbDmJ5CCuUK17to4b7jEAT
        kh5vAYdyJOZHITaBaNTNsm1u6BLm8iyTd9G6BqV+Dg==
X-Google-Smtp-Source: AMsMyM6m0RibLbTRKrTdBLR7TtiUWihumJ1IV8JLn15dmR91FQ5l28PUyVB88EGCCsZKGt2/0tCLrFMqWP3fpbPk0VM=
X-Received: by 2002:a25:7a01:0:b0:6b0:820:dd44 with SMTP id
 v1-20020a257a01000000b006b00820dd44mr9080286ybc.387.1664568065814; Fri, 30
 Sep 2022 13:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220930014458.1219217-1-eric.dumazet@gmail.com>
 <82d7338e085c156f044ec7bc55c7d78418439963.camel@redhat.com> <CANn89iL-ZE48i59A93Y4qfyZCL45uR6rHqZQ84n3TcRK8e_g=g@mail.gmail.com>
In-Reply-To: <CANn89iL-ZE48i59A93Y4qfyZCL45uR6rHqZQ84n3TcRK8e_g=g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 30 Sep 2022 13:00:54 -0700
Message-ID: <CANn89iLXrCUjKw55i8Q6Sqwou0RjnuV2uVJLRqDOyMkcCaPvYg@mail.gmail.com>
Subject: Re: [PATCH net-next] gro: add support of (hw)gro packets to gro stack
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
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

On Fri, Sep 30, 2022 at 12:53 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Sep 30, 2022 at 1:45 AM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Thu, 2022-09-29 at 18:44 -0700, Eric Dumazet wrote:
> > > From: Coco Li <lixiaoyan@google.com>
> > >
> > > Current GRO stack only supports incoming packets containing
> > > one frame/MSS.
> > >
> > > This patch changes GRO to accept packets that are already GRO.
> > >
> > > HW-GRO (aka RSC for some vendors) is very often limited in presence
> > > of interleaved packets. Linux SW GRO stack can complete the job
> > > and provide larger GRO packets, thus reducing rate of ACK packets
> > > and cpu overhead.
> > >
> > > This also means BIG TCP can be used, even if HW-GRO/RSC was
> > > able to cook ~64 KB GRO packets.
> > >
> > > Co-Developed-by: Eric Dumazet <edumazet@google.com>
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > > ---
> > >  net/core/gro.c         | 13 +++++++++----
> > >  net/ipv4/tcp_offload.c |  7 ++++++-
> > >  2 files changed, 15 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/net/core/gro.c b/net/core/gro.c
> > > index b4190eb084672fb4f2be8b437eccb4e8507ff63f..d8e159c4bdf553508cd123bee4f5251908ede9fe 100644
> > > --- a/net/core/gro.c
> > > +++ b/net/core/gro.c
> > > @@ -160,6 +160,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > >       unsigned int gro_max_size;
> > >       unsigned int new_truesize;
> > >       struct sk_buff *lp;
> > > +     int segs;
> > >
> > >       /* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
> > >       gro_max_size = READ_ONCE(p->dev->gro_max_size);
> > > @@ -175,6 +176,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > >                       return -E2BIG;
> > >       }
> > >
> > > +     segs = NAPI_GRO_CB(skb)->count;
> > >       lp = NAPI_GRO_CB(p)->last;
> > >       pinfo = skb_shinfo(lp);
> > >
> > > @@ -265,7 +267,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > >       lp = p;
> > >
> > >  done:
> > > -     NAPI_GRO_CB(p)->count++;
> > > +     NAPI_GRO_CB(p)->count += segs;
> > >       p->data_len += len;
> > >       p->truesize += delta_truesize;
> > >       p->len += len;
> > > @@ -496,8 +498,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
> > >               BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
> > >                                        sizeof(u32))); /* Avoid slow unaligned acc */
> > >               *(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
> > > -             NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
> > > +             NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
> > >               NAPI_GRO_CB(skb)->is_atomic = 1;
> > > +             NAPI_GRO_CB(skb)->count = max_t(u16, 1,
> > > +                                             skb_shinfo(skb)->gso_segs);
> > >
> > >               /* Setup for GRO checksum validation */
> > >               switch (skb->ip_summed) {
> > > @@ -545,10 +549,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
> > >       else
> > >               gro_list->count++;
> > >
> > > -     NAPI_GRO_CB(skb)->count = 1;
> > >       NAPI_GRO_CB(skb)->age = jiffies;
> > >       NAPI_GRO_CB(skb)->last = skb;
> > > -     skb_shinfo(skb)->gso_size = skb_gro_len(skb);
> > > +     if (!skb_is_gso(skb))
> > > +             skb_shinfo(skb)->gso_size = skb_gro_len(skb);
> > >       list_add(&skb->list, &gro_list->list);
> > >       ret = GRO_HELD;
> > >
> > > @@ -660,6 +664,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
> > >
> > >       skb->encapsulation = 0;
> > >       skb_shinfo(skb)->gso_type = 0;
> > > +     skb_shinfo(skb)->gso_size = 0;
> > >       if (unlikely(skb->slow_gro)) {
> > >               skb_orphan(skb);
> > >               skb_ext_reset(skb);
> > > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> > > index a844a0d38482d916251f3aca4555c75c9770820c..0223bbfe9568064b47bc6227d342a4d25c9edfa7 100644
> > > --- a/net/ipv4/tcp_offload.c
> > > +++ b/net/ipv4/tcp_offload.c
> > > @@ -255,7 +255,12 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
> > >
> > >       mss = skb_shinfo(p)->gso_size;
> > >
> > > -     flush |= (len - 1) >= mss;
> > > +     if (skb_is_gso(skb)) {
> > > +             flush |= (mss != skb_shinfo(skb)->gso_size);
> > > +             flush |= ((skb_gro_len(p) % mss) != 0);
> >
> > If I read correctly, the '(skb_gro_len(p) % mss) != 0' codition can be
> > true only if 'p' was an HW GRO packet (or at least a gso packet before
> > entering the GRO engine), am I correct? In that case 'p' staged into
> > the GRO hash up to the next packet (skb), just to be flushed.
> >
> > Should the above condition be instead:
> >
> >                 flush |= ((skb_gro_len(skb) % mss) != 0);
>
> Yes, probable typo.
>
> > ?
> >
> > And possibly use that condition while initializing
> > NAPI_GRO_CB(skb)->flush in dev_gro_receive() ?
>
> Not sure, this would add an extra test in dev_gro_receive()
>
> It seems better to leave the test here, because the prior condition
> needs to stay here.
>
> if (skb_is_gso(skb)) {
>              flush |= (mss != skb_shinfo(skb)->gso_size);
>

Oh well, I think Coco missed the fact that the  ((skb_gro_len(skb) % mss) != 0)
condition needs to be put after label out_check_final.

For example, if MSS==1000, and p has 4 segments, we still want to
aggregate skb into p
if skb payload is not a multiple of MSS.


>
> >
> > > +     } else {
> > > +             flush |= (len - 1) >= mss;
> > > +     }
> > >       flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
> > >  #ifdef CONFIG_TLS_DEVICE
> > >       flush |= p->decrypted ^ skb->decrypted;
> >
> > I could not find a NIC doing HW GRO for UDP, so I guess we don't need
> > something similar in udp_offload, right?
>
> Well, this could be added just in case :)
