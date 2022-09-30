Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473A85F144A
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 23:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiI3VCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 17:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiI3VCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 17:02:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5E512A4A2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664571737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4C80vH+tOw6Eqizeuk4W/efmL6yFoK7ImEyOeMwzRmU=;
        b=G8YapEXXDEPvuXk5J+SklPWKn41J4cSc9nRM1gh6fa/+CyXNCoNwwTGjZhkP5MetI0yl2B
        IzQdyzBN6SmFhvsYvVbHJQUx7Kf7P7ucsVyBrAySvqik4o/8pMOHkY8Kb/50CIIY1X87Qd
        jTKIaNlOwnZgrAWCS0NfEbQhVyPPUlM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-232-GhS9mDKwNsiN08ntPPrD7Q-1; Fri, 30 Sep 2022 17:02:15 -0400
X-MC-Unique: GhS9mDKwNsiN08ntPPrD7Q-1
Received: by mail-wr1-f72.google.com with SMTP id o7-20020adfba07000000b00228663f217fso1934449wrg.20
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=4C80vH+tOw6Eqizeuk4W/efmL6yFoK7ImEyOeMwzRmU=;
        b=x+sZDcKlW9GhQlaT0qQbfmU4yB9axcTDxa0/1i25gT046MTkoMmhfDm8IHz+Xd6IAH
         B4y/FajtKk3+wE9RtL3fD38Db9s7aLI4kjdbgU8fQzV1ennGzM9JJGQjAqW+8d7G9gqd
         VOiTTSpKdonJWA1KDUH27kTOGNu/kXRWI45EWQXkTndET0MLT7C+B2m44g8+QCBhSTQI
         EuQdoHlI3CUKuwQBaGfk3m7byzM2fJU1R2qI8WeubLGh6AKsl4PzULjZgLiLwVhVJ9Ww
         YDJbPBsmUxMmsoXtjk0ygROLEu1K9ldK/PXW4yMpc3k4m5oiIZt+2nF+CJyoT476Ej2f
         sX9Q==
X-Gm-Message-State: ACrzQf0LjrtHVS4LiF7QCj62m4ii+ky4afX5zJMOlfKsrVMyaYmhZGvm
        Ap6j33q2EkIoJRy0pz2OJHbuqbchVVNNpEh3lou7j3KpvT5B71ExkgowOhto4g78Z5+QcSMOnoa
        jSByLAMBW4PdYVgAw
X-Received: by 2002:a5d:5a15:0:b0:228:cd90:ccd with SMTP id bq21-20020a5d5a15000000b00228cd900ccdmr7323674wrb.658.1664571734564;
        Fri, 30 Sep 2022 14:02:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7nHjIViIJuli510L+3xEn97uwxfxWIM20Ij1yVRrRK+KaQ/O6P/GFSKct654uBHtRh6+tbIA==
X-Received: by 2002:a5d:5a15:0:b0:228:cd90:ccd with SMTP id bq21-20020a5d5a15000000b00228cd900ccdmr7323663wrb.658.1664571734239;
        Fri, 30 Sep 2022 14:02:14 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-71.dyn.eolo.it. [146.241.97.71])
        by smtp.gmail.com with ESMTPSA id b1-20020a5d45c1000000b0022ac119fcc5sm2995047wrs.60.2022.09.30.14.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 14:02:13 -0700 (PDT)
Message-ID: <39ec7558865e4353251b6a863a681897221bfa82.camel@redhat.com>
Subject: Re: [PATCH net-next] gro: add support of (hw)gro packets to gro
 stack
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Date:   Fri, 30 Sep 2022 23:02:12 +0200
In-Reply-To: <CANn89iK4zFYMQDpnT-QKeRtnMzx+YWi+10KeRr2N0zAZ9nB2-Q@mail.gmail.com>
References: <20220930014458.1219217-1-eric.dumazet@gmail.com>
         <82d7338e085c156f044ec7bc55c7d78418439963.camel@redhat.com>
         <CANn89iL-ZE48i59A93Y4qfyZCL45uR6rHqZQ84n3TcRK8e_g=g@mail.gmail.com>
         <CANn89iLXrCUjKw55i8Q6Sqwou0RjnuV2uVJLRqDOyMkcCaPvYg@mail.gmail.com>
         <CANn89iK4zFYMQDpnT-QKeRtnMzx+YWi+10KeRr2N0zAZ9nB2-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-30 at 13:19 -0700, Eric Dumazet wrote:
> On Fri, Sep 30, 2022 at 1:00 PM Eric Dumazet <edumazet@google.com> wrote:
> > 
> > On Fri, Sep 30, 2022 at 12:53 PM Eric Dumazet <edumazet@google.com> wrote:
> > > 
> > > On Fri, Sep 30, 2022 at 1:45 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > 
> > > > On Thu, 2022-09-29 at 18:44 -0700, Eric Dumazet wrote:
> > > > > From: Coco Li <lixiaoyan@google.com>
> > > > > 
> > > > > Current GRO stack only supports incoming packets containing
> > > > > one frame/MSS.
> > > > > 
> > > > > This patch changes GRO to accept packets that are already GRO.
> > > > > 
> > > > > HW-GRO (aka RSC for some vendors) is very often limited in presence
> > > > > of interleaved packets. Linux SW GRO stack can complete the job
> > > > > and provide larger GRO packets, thus reducing rate of ACK packets
> > > > > and cpu overhead.
> > > > > 
> > > > > This also means BIG TCP can be used, even if HW-GRO/RSC was
> > > > > able to cook ~64 KB GRO packets.
> > > > > 
> > > > > Co-Developed-by: Eric Dumazet <edumazet@google.com>
> > > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > > > > ---
> > > > >  net/core/gro.c         | 13 +++++++++----
> > > > >  net/ipv4/tcp_offload.c |  7 ++++++-
> > > > >  2 files changed, 15 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/net/core/gro.c b/net/core/gro.c
> > > > > index b4190eb084672fb4f2be8b437eccb4e8507ff63f..d8e159c4bdf553508cd123bee4f5251908ede9fe 100644
> > > > > --- a/net/core/gro.c
> > > > > +++ b/net/core/gro.c
> > > > > @@ -160,6 +160,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > > > >       unsigned int gro_max_size;
> > > > >       unsigned int new_truesize;
> > > > >       struct sk_buff *lp;
> > > > > +     int segs;
> > > > > 
> > > > >       /* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
> > > > >       gro_max_size = READ_ONCE(p->dev->gro_max_size);
> > > > > @@ -175,6 +176,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > > > >                       return -E2BIG;
> > > > >       }
> > > > > 
> > > > > +     segs = NAPI_GRO_CB(skb)->count;
> > > > >       lp = NAPI_GRO_CB(p)->last;
> > > > >       pinfo = skb_shinfo(lp);
> > > > > 
> > > > > @@ -265,7 +267,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > > > >       lp = p;
> > > > > 
> > > > >  done:
> > > > > -     NAPI_GRO_CB(p)->count++;
> > > > > +     NAPI_GRO_CB(p)->count += segs;
> > > > >       p->data_len += len;
> > > > >       p->truesize += delta_truesize;
> > > > >       p->len += len;
> > > > > @@ -496,8 +498,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
> > > > >               BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
> > > > >                                        sizeof(u32))); /* Avoid slow unaligned acc */
> > > > >               *(u32 *)&NAPI_GRO_CB(skb)->zeroed = 0;
> > > > > -             NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
> > > > > +             NAPI_GRO_CB(skb)->flush = skb_has_frag_list(skb);
> > > > >               NAPI_GRO_CB(skb)->is_atomic = 1;
> > > > > +             NAPI_GRO_CB(skb)->count = max_t(u16, 1,
> > > > > +                                             skb_shinfo(skb)->gso_segs);
> > > > > 
> > > > >               /* Setup for GRO checksum validation */
> > > > >               switch (skb->ip_summed) {
> > > > > @@ -545,10 +549,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
> > > > >       else
> > > > >               gro_list->count++;
> > > > > 
> > > > > -     NAPI_GRO_CB(skb)->count = 1;
> > > > >       NAPI_GRO_CB(skb)->age = jiffies;
> > > > >       NAPI_GRO_CB(skb)->last = skb;
> > > > > -     skb_shinfo(skb)->gso_size = skb_gro_len(skb);
> > > > > +     if (!skb_is_gso(skb))
> > > > > +             skb_shinfo(skb)->gso_size = skb_gro_len(skb);
> > > > >       list_add(&skb->list, &gro_list->list);
> > > > >       ret = GRO_HELD;
> > > > > 
> > > > > @@ -660,6 +664,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
> > > > > 
> > > > >       skb->encapsulation = 0;
> > > > >       skb_shinfo(skb)->gso_type = 0;
> > > > > +     skb_shinfo(skb)->gso_size = 0;
> > > > >       if (unlikely(skb->slow_gro)) {
> > > > >               skb_orphan(skb);
> > > > >               skb_ext_reset(skb);
> > > > > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> > > > > index a844a0d38482d916251f3aca4555c75c9770820c..0223bbfe9568064b47bc6227d342a4d25c9edfa7 100644
> > > > > --- a/net/ipv4/tcp_offload.c
> > > > > +++ b/net/ipv4/tcp_offload.c
> > > > > @@ -255,7 +255,12 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
> > > > > 
> > > > >       mss = skb_shinfo(p)->gso_size;
> > > > > 
> > > > > -     flush |= (len - 1) >= mss;
> > > > > +     if (skb_is_gso(skb)) {
> > > > > +             flush |= (mss != skb_shinfo(skb)->gso_size);
> > > > > +             flush |= ((skb_gro_len(p) % mss) != 0);
> > > > 
> > > > If I read correctly, the '(skb_gro_len(p) % mss) != 0' codition can be
> > > > true only if 'p' was an HW GRO packet (or at least a gso packet before
> > > > entering the GRO engine), am I correct? In that case 'p' staged into
> > > > the GRO hash up to the next packet (skb), just to be flushed.
> > > > 
> > > > Should the above condition be instead:
> > > > 
> > > >                 flush |= ((skb_gro_len(skb) % mss) != 0);
> > > 
> > > Yes, probable typo.
> > > 
> > > > ?
> > > > 
> > > > And possibly use that condition while initializing
> > > > NAPI_GRO_CB(skb)->flush in dev_gro_receive() ?
> > > 
> > > Not sure, this would add an extra test in dev_gro_receive()
> > > 
> > > It seems better to leave the test here, because the prior condition
> > > needs to stay here.
> > > 
> > > if (skb_is_gso(skb)) {
> > >              flush |= (mss != skb_shinfo(skb)->gso_size);
> > > 
> > 
> > Oh well, I think Coco missed the fact that the  ((skb_gro_len(skb) % mss) != 0)
> > condition needs to be put after label out_check_final.
> > 
> > For example, if MSS==1000, and p has 4 segments, we still want to
> > aggregate skb into p
> > if skb payload is not a multiple of MSS.
> > 
> 
> Relative diff would be:
> 
> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index 0223bbfe9568064b47bc6227d342a4d25c9edfa7..79996b007bd64635aea27e3fddf291abe10ceca1
> 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -255,26 +255,27 @@ struct sk_buff *tcp_gro_receive(struct list_head
> *head, struct sk_buff *skb)
> 
>         mss = skb_shinfo(p)->gso_size;
> 
> -       if (skb_is_gso(skb)) {
> +       if (unlikely(skb_is_gso(skb)))
>                 flush |= (mss != skb_shinfo(skb)->gso_size);
> -               flush |= ((skb_gro_len(p) % mss) != 0);
> -       } else {
> +       else
>                 flush |= (len - 1) >= mss;
> -       }
> +
>         flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
>  #ifdef CONFIG_TLS_DEVICE
>         flush |= p->decrypted ^ skb->decrypted;
>  #endif
> 
>         if (flush || skb_gro_receive(p, skb)) {
> -               mss = 1;
> -               goto out_check_final;
> +               flush = 0;
> +               goto check_flags;
>         }
> 
>         tcp_flag_word(th2) |= flags & (TCP_FLAG_FIN | TCP_FLAG_PSH);
> 
>  out_check_final:
> -       flush = len < mss;
> +       flush = len != NAPI_GRO_CB(skb)->count * mss;

Not sure if it's worthy, perhaps mss can be updated under the 
unlikely(skb_is_gso(skb)) a few lines above:

	mss *= NAPI_GRO_CB(skb)->count;

so that here we can avoid the additional operation for the non gso
case? - just:
	flush = len != mss;

In any case LGTM, thanks!

Paolo

