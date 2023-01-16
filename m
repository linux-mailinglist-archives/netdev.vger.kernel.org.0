Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271E966B598
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 03:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjAPCZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 21:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbjAPCYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 21:24:46 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD026A78;
        Sun, 15 Jan 2023 18:24:43 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id v6so21852738ejg.6;
        Sun, 15 Jan 2023 18:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ieAvDpUTB6fur3o/45AvL4GwmJeyZ8yDVKySYt8c7jc=;
        b=JoyqPEAWZwkWZ+yWyHE4C0FUaBXwaiRjUz9F4eByEMphBQChIHNMLOYXBUjwIg1BzX
         TrKZ53Dnaa3t01P0prcslC9whuuAr1+ecD6nbP8lYPHB8GdExskzRpsPd2NNZLhxgFbz
         SSilhEnH/eEd/vE0hHyCL1BGoY2C//nb3h4Z7nQ/Cv5hpiSO3hcXwCcFFyz5NEyEzIS4
         HnIgUWLgnwVsQ+fCiyzxJI8jdOztb9AYHGJpY2F2CLbgS+ABpLzwfIgDiL/52EwY49K8
         Ocxr6BeJ98Taf4cHfltokR2t3gASuaq/4ssMaKK6sAxqJkk0JSZ/oi2OMRF2LclHjBba
         ka9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ieAvDpUTB6fur3o/45AvL4GwmJeyZ8yDVKySYt8c7jc=;
        b=2jOAnc/nCgKDTip0jjDIqlQHAepTF2a8XgMzvkU8X/o9eJ4kC4ERRpIUwYmn8FQ2T2
         c5KjFS6N6gFuLmNGb5MDnQvKclFH6RRS42mkUX2k/rJqmD33llWwezqu6ZEbdt6PwNTG
         7i7FTYuekJ7dz6xwQhMn//ZKPdR0/zjxwCw/OF8qiA93P2VIBX+mupJw0w23QCc15EfN
         vqJb8ZQLjNcE/ob5DSFPgzuafrhWeN6DRDEEBVVUWDXPXcaVPloAoq/ZpkeBc24YMGK4
         fjAXhLlesNpq7RBij4Eh8zZ7hySupeXC+mFlYzvEQ3HyrOioZjncgsjZA5zQcRFiqhuX
         MqGg==
X-Gm-Message-State: AFqh2kosDzphkjeZB3t5dKixrjBKREcsjKOgJ9v7rJziZA0N5Z8pDtTS
        oQzAiGOijfF4SOfyg6PRqFZEKBlfqvXKdZSF1pA=
X-Google-Smtp-Source: AMrXdXuU4SMso3XSHFTrDLZGet4nUKmvsnS3QNycJVB0t5Tex0hzmHfjxju2vbPKJkdn6T3p6E1adT4XQxiRNe2mSVA=
X-Received: by 2002:a17:906:c0c9:b0:86d:ec8c:5b3f with SMTP id
 bn9-20020a170906c0c900b0086dec8c5b3fmr290445ejb.50.1673835882109; Sun, 15 Jan
 2023 18:24:42 -0800 (PST)
MIME-Version: 1.0
References: <20230114132705.78400-1-kerneljasonxing@gmail.com>
 <CANn89iJ+KW+=Z13o_K4RpZfoxO8rGaXRXQ07jZfpE5RMH0Uweg@mail.gmail.com> <CAL+tcoD-V-XKrXMMEheBnohD-h6ig12zhtQUAt6ATE4jWcuLvQ@mail.gmail.com>
In-Reply-To: <CAL+tcoD-V-XKrXMMEheBnohD-h6ig12zhtQUAt6ATE4jWcuLvQ@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 16 Jan 2023 10:24:05 +0800
Message-ID: <CAL+tcoDXZhptPXK8D_OSS_m8+LAvdZy6wKXaZvtOYQobzuosxg@mail.gmail.com>
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

On Mon, Jan 16, 2023 at 8:36 AM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> On Mon, Jan 16, 2023 at 12:12 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Sat, Jan 14, 2023 at 2:27 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > >
> > > From: Jason Xing <kernelxing@tencent.com>
> > >
> > >
> > > Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
> > > ---
> > > v2:
> > > 1) adding the sk node into the tail of list to prevent the race.
> > > 2) fix the race condition when handling time-wait socket hashdance.
> > > ---
> > >  net/ipv4/inet_hashtables.c    | 10 ++++++++++
> > >  net/ipv4/inet_timewait_sock.c |  6 +++---
> > >  2 files changed, 13 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > > index 24a38b56fab9..b0b54ad55507 100644
> > > --- a/net/ipv4/inet_hashtables.c
> > > +++ b/net/ipv4/inet_hashtables.c
> > > @@ -650,7 +650,16 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> > >         spin_lock(lock);
> > >         if (osk) {
> > >                 WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> > > +               if (sk_hashed(osk))
> >
> >
> > nit: this should be:
> >
> > if (sk_hashed(osk)) {  [1]
> >     /* multi-line ....
> >      * .... comment.
> >      */
> >    ret = sk_nulls_del_node_init_rcu(osk);
> >    goto unlock;
> > }

Well, after I dug into this part, I found something as below.
If we enter into the 'if (osk) {', we should always skip the next
if-statement which is 'if (found_dup_sk) {' and return a proper value
depending on if the osk is hashed.
However, the code as above would leave variable @ret to be true if the
sk_hashed(osk) returned false, then It would not go to unlock and then
add the node to the list and at last return true which is unexpected.

> > if (found_dup_sk) {  [2]
> >
> > 1) parentheses needed in [1]

> > 2) No else if in [2], since you added a "goto unlock;"

I think this modification is fine and makes the code clearer.

Thanks,
Jason

> >
>
> I'll do that. It looks much better.
>
> Thanks,
> Jason
>
> > > +                       /* Before deleting the node, we insert a new one to make
> > > +                        * sure that the look-up-sk process would not miss either
> > > +                        * of them and that at least one node would exist in ehash
> > > +                        * table all the time. Otherwise there's a tiny chance
> > > +                        * that lookup process could find nothing in ehash table.
> > > +                        */
> > > +                       __sk_nulls_add_node_tail_rcu(sk, list);
> > >                 ret = sk_nulls_del_node_init_rcu(osk);
> > > +               goto unlock;
> > >         } else if (found_dup_sk) {
> > >                 *found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
> > >                 if (*found_dup_sk)
> > > @@ -660,6 +669,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> > >         if (ret)
> > >                 __sk_nulls_add_node_rcu(sk, list);
> > >
> > > +unlock:
> > >         spin_unlock(lock);
> >
> > Thanks.
