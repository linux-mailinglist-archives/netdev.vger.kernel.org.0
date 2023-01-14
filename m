Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D95966AB43
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 13:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjANMGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 07:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjANMGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 07:06:23 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F101722;
        Sat, 14 Jan 2023 04:06:22 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y19so1063363edc.2;
        Sat, 14 Jan 2023 04:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WDsjkLeKel2pUOLcNMvCwbBxuOd8nTCUkWVNrN0y/N4=;
        b=oJs2SeTw3bP/IgcPw8sEJ1PeHd/THXpumPmAfZR3C7Ltr3V4MxNKcBcBBY0i4j6fi2
         lNAsPEug0QoEgPXBd544cRERgQdsyLPs7UUivYFnU6KwVDzdqjAXsb5tPBOgDI3ipyvk
         rReuvkPhN9iWfXfeBb7D0QBORrgtrHh/0sJiIRHAThTafSCOsWx4vWiWH/9pKm8Ql1Gf
         U/0h5fKeRGJ4gwiudK2tjtGsMM4w36vG4DVPDGLNrTVZfhMWv5VGqqICspkNcHZtEt9A
         bsfOFolcBApDGsTjtbhKrqmVXugJZHYNghOT2Cab6RRuCXQF1SWCs6xfKXBty1CUTX2Z
         idVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WDsjkLeKel2pUOLcNMvCwbBxuOd8nTCUkWVNrN0y/N4=;
        b=oN6GjDQO8/5OZMKZO14aUFMhzR2TzzfuUbcAeeYBlIGOHZrZY4oDQ6DhNpi8tbrPml
         VXRc3LzbrCrPgdkTIr0nEeUbFajBEnHTn/DadsiARL5EjE+QxURAUA9sR/RF1WD++Yuz
         j8LUh/1Elm32UBDq0KbkR4N6cd/dV/EQjJ/nhzXhIwrsSMPsqq2n6xXBrptjVl41eqaP
         NaX0Itp+Ba6bn+681f5KJgT/og1wjv762pGvkAdbH9VAthdAOz5nxT3vh6kwtlE2A/1A
         TtaVTKe7es6Pmlx878RF0tjQbX45FtDlgDv58i868Bin0+WEctThSEOnrYee9N1Lbwzb
         GJJQ==
X-Gm-Message-State: AFqh2krauQ/4KjVBcYlTt2QzNBrDtM1CtN8YPNbfCyUk0sD5F9Q1Uxqk
        qXSTJcBR8AneJt6+uCfeO4krmLnFI1SEpwttGrc=
X-Google-Smtp-Source: AMrXdXv6OER/KDFv92Xi3F82DJ5D/K31GnDdv/LmTwJphZ0E2SezjdcJ3ZJhkrc49J5V1CkYLneLjXraBXnVVETgaGw=
X-Received: by 2002:aa7:c497:0:b0:49d:aca5:9ae0 with SMTP id
 m23-20020aa7c497000000b0049daca59ae0mr202832edq.106.1673697980814; Sat, 14
 Jan 2023 04:06:20 -0800 (PST)
MIME-Version: 1.0
References: <20230112065336.41034-1-kerneljasonxing@gmail.com> <CANn89iKQjN1YiHqBTV3+zDYo0G11p-6=p7C-1GvFCp8Y=r4nvQ@mail.gmail.com>
In-Reply-To: <CANn89iKQjN1YiHqBTV3+zDYo0G11p-6=p7C-1GvFCp8Y=r4nvQ@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sat, 14 Jan 2023 20:05:44 +0800
Message-ID: <CAL+tcoACCg+UQG+PAGh1k+-mTJdZ-5jNez5hSGO_i2oWjr7=+w@mail.gmail.com>
Subject: Re: [PATCH net] tcp: avoid the lookup process failing to get sk in
 ehash table
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org--cc, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 14, 2023 at 5:45 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jan 12, 2023 at 7:54 AM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > While one cpu is working on looking up the right socket from ehash
> > table, another cpu is done deleting the request socket and is about
> > to add (or is adding) the big socket from the table. It means that
> > we could miss both of them, even though it has little chance.
> >
> > Let me draw a call trace map of the server side.
> >    CPU 0                           CPU 1
> >    -----                           -----
> > tcp_v4_rcv()                  syn_recv_sock()
> >                             inet_ehash_insert()
> >                             -> sk_nulls_del_node_init_rcu(osk)
> > __inet_lookup_established()
> >                             -> __sk_nulls_add_node_rcu(sk, list)
> >
> > Notice that the CPU 0 is receiving the data after the final ack
> > during 3-way shakehands and CPU 1 is still handling the final ack.
> >
> > Why could this be a real problem?
> > This case is happening only when the final ack and the first data
> > receiving by different CPUs. Then the server receiving data with
> > ACK flag tries to search one proper established socket from ehash
> > table, but apparently it fails as my map shows above. After that,
> > the server fetches a listener socket and then sends a RST because
> > it finds a ACK flag in the skb (data), which obeys RST definition
> > in RFC 793.
> >
> > Many thanks to Eric for great help from beginning to end.
> >
> > Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> >  net/ipv4/inet_hashtables.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > index 24a38b56fab9..18f88cb4efcb 100644
> > --- a/net/ipv4/inet_hashtables.c
> > +++ b/net/ipv4/inet_hashtables.c
> > @@ -650,7 +650,16 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> >         spin_lock(lock);
> >         if (osk) {
> >                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> > +               if (sk_hashed(osk))
> > +                       /* Before deleting the node, we insert a new one to make
> > +                        * sure that the look-up=sk process would not miss either
> > +                        * of them and that at least one node would exist in ehash
> > +                        * table all the time. Otherwise there's a tiny chance
> > +                        * that lookup process could find nothing in ehash table.
> > +                        */
> > +                       __sk_nulls_add_node_rcu(sk, list);
>
> In our private email exchange, I suggested to insert sk at the _tail_
> of the hash bucket.
>

Yes, I noticed that. At that time I kept considering the race
condition of the RCU itself, not the scene you mentioned as below.

> Inserting it at the _head_ would still leave a race condition, because
> a concurrent reader might
> have already started the bucket traversal, and would not see 'sk'.

Thanks for the detailed explanation. Now I see why. I'll replace it
with __sk_nulls_add_node_tail_rcu() function and send the v2 patch.

By the way, I checked the removal of TIMEWAIT socket which is included
in this patch.
I write down the call-trace:
inet_hash_connect()
    -> __inet_hash_connect()
        -> if (sk_unhashed(sk)) {
                inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
                    -> inet_ehash_insert(sk, osk, found_dup_sk);
Therefore, this patch covers the timewait case.

Thanks,
Jason

>
> Thanks.
>
> >                 ret = sk_nulls_del_node_init_rcu(osk);
> > +               goto unlock;
> >         } else if (found_dup_sk) {
> >                 *found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
> >                 if (*found_dup_sk)
> > @@ -660,6 +669,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> >         if (ret)
> >                 __sk_nulls_add_node_rcu(sk, list);
> >
> > +unlock:
> >         spin_unlock(lock);
> >
> >         return ret;
> > --
> > 2.37.3
> >
