Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B85C66B4FA
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 01:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjAPAgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 19:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjAPAgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 19:36:53 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0409A6A41;
        Sun, 15 Jan 2023 16:36:52 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s3so568030edd.4;
        Sun, 15 Jan 2023 16:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3wlPs+VBNuhHts7wgRKDtTEmK1wtfqcqEGfFdEmet68=;
        b=hDtGW1Qby247h2l3G48B4rVVvhOLDwyCxfMukL5tZqGj1ym2LLIboYUY6+Xb73SM0I
         5MRfxK1tEFNO2j9ldhaY5mcT1iX0DYQElcxxTYxSOWoUMJN3mCA7g+xzVbJ+I3miand1
         WqVhNShSyOjHWafS1vPeK5XPPK5iggrbG0tCVYOXbmUZ+keAzn1mZNLV02fN/V6uY+QJ
         kbxUskUowsoUn9W/Ss9HiJVrjjSiI5NwPEUe2ZkuCf3Ojg9PrZTz+iOuOcCp+otSLa8x
         gyx0YdwTQ/wGZY4pOToUdV/pQU2JfqYxYS7oo4Gg5jZV1hmLKPkqosAtPSQR/2l1naAf
         IYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3wlPs+VBNuhHts7wgRKDtTEmK1wtfqcqEGfFdEmet68=;
        b=FOhk32ozXq+nbWUn853kmh2GNucNnxtpjFKyQynunxANPTIIoPjRTVumTNq8pUrQZH
         VXIKoIIC9PINQ+geKHuVxQBsAiUm5gT9tOI7oMYrrKEcUKxmCbNG8gajpy+GLxRgDmgz
         iDJbNDWWPzbQQId4EYkjmdNbTE5o2cJZERKCaVZwMhC+mPh38/s5CMT2Gk+KxnTnyRiv
         H44mvHCOfnY79IrxellH302VDqsmkS/ao21bY5qVGjM9gajiersgn4EQqiS9ZNuwC/SM
         Rqa26UrwXqmHRxpPHSfocD8xMYJ5E02JMy5HN6Im7z4wgI2uovQRA07qEi/qDjS0HdQU
         g2fQ==
X-Gm-Message-State: AFqh2koqTU1XbcGa/MUJL+7z193SKNdQ+jj5Xn2ZGTs2HwX7gSvISV7m
        JdgqJaonpBHCmfUP8HOJVmW2BeiN8n4OHgoytp5qbHC6fWg=
X-Google-Smtp-Source: AMrXdXut7Iattd5nto2m0DjH47QDco0hABb+8wL5UyO7QS9s+Uff6OFDak8mbumkPuE/ZbKjadNzTX7HxeKUQci6vJI=
X-Received: by 2002:aa7:c497:0:b0:49d:aca5:9ae0 with SMTP id
 m23-20020aa7c497000000b0049daca59ae0mr688442edq.106.1673829410495; Sun, 15
 Jan 2023 16:36:50 -0800 (PST)
MIME-Version: 1.0
References: <20230114132705.78400-1-kerneljasonxing@gmail.com> <CANn89iJ+KW+=Z13o_K4RpZfoxO8rGaXRXQ07jZfpE5RMH0Uweg@mail.gmail.com>
In-Reply-To: <CANn89iJ+KW+=Z13o_K4RpZfoxO8rGaXRXQ07jZfpE5RMH0Uweg@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 16 Jan 2023 08:36:14 +0800
Message-ID: <CAL+tcoD-V-XKrXMMEheBnohD-h6ig12zhtQUAt6ATE4jWcuLvQ@mail.gmail.com>
Subject: Re: [PATCH v2 net] tcp: avoid the lookup process failing to get sk in
 ehash table
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
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

On Mon, Jan 16, 2023 at 12:12 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Jan 14, 2023 at 2:27 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> >
> > Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
> > ---
> > v2:
> > 1) adding the sk node into the tail of list to prevent the race.
> > 2) fix the race condition when handling time-wait socket hashdance.
> > ---
> >  net/ipv4/inet_hashtables.c    | 10 ++++++++++
> >  net/ipv4/inet_timewait_sock.c |  6 +++---
> >  2 files changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > index 24a38b56fab9..b0b54ad55507 100644
> > --- a/net/ipv4/inet_hashtables.c
> > +++ b/net/ipv4/inet_hashtables.c
> > @@ -650,7 +650,16 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> >         spin_lock(lock);
> >         if (osk) {
> >                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> > +               if (sk_hashed(osk))
>
>
> nit: this should be:
>
> if (sk_hashed(osk)) {  [1]
>     /* multi-line ....
>      * .... comment.
>      */
>    ret = sk_nulls_del_node_init_rcu(osk);
>    goto unlock;
> }
> if (found_dup_sk) {  [2]
>
> 1) parentheses needed in [1]
> 2) No else if in [2], since you added a "goto unlock;"
>

I'll do that. It looks much better.

Thanks,
Jason

> > +                       /* Before deleting the node, we insert a new one to make
> > +                        * sure that the look-up-sk process would not miss either
> > +                        * of them and that at least one node would exist in ehash
> > +                        * table all the time. Otherwise there's a tiny chance
> > +                        * that lookup process could find nothing in ehash table.
> > +                        */
> > +                       __sk_nulls_add_node_tail_rcu(sk, list);
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
>
> Thanks.
