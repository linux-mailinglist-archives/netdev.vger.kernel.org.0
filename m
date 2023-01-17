Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4888F66D428
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 03:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbjAQCQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 21:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbjAQCQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 21:16:24 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2CE2331B;
        Mon, 16 Jan 2023 18:16:23 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y19so9512978edc.2;
        Mon, 16 Jan 2023 18:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SBHH5FzfccMmW32bjhWXzbJMdoz9l8k0pEXILz+K/G4=;
        b=Xl1eixT2wQcyDnNB929ADbEnCtq/OPkfs3Df44lrgkdR7Dtcv8dcM4dSdRxmjcgHbi
         4OjieMETZzrr4pcO/FPkmN0VdH028SxvqyLf9ubYIIb9vvBX/vt2t8I8CW2hT5mM+28f
         Sag9uGq43lnbaj9ByMf0acjTwVd/q1i25P9Ovdr17wDY4kI4XyPbWHK9cDknocQPvknC
         HXiZpzzkudGm+S1zufj9vqH335TYYEvFNy/QoHnyxdrV3XF3YnfUH2o198vsL17uwyrG
         6f1F6sRAAuwyDKuIT9eKNIIhA6Zvlcs5ICxk2MkVpVkyVHWhEKMaUAzb5h1TaJEBcmvE
         cMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SBHH5FzfccMmW32bjhWXzbJMdoz9l8k0pEXILz+K/G4=;
        b=sJSGms8h9d1byspnBi3u/QGfmGfv2iDQn3C+sjQxzGhkOjn2grg6intdRl9ZKYu7pv
         9C5j7UUir5LNgpr4LIxYVPZ3IDQgxHXqS7XQgHoGALeV2OI5v2J60mBX7Y4zh7p0PQal
         RTeV/mEhUOz5lgHbSsujNRY7BeZjK8CFIa0tQtLL9PCCgSkNDeH+aWohp6eBKlgGDYTZ
         2AcrINnOfR8eH8uTz0julgE7/2nBorAdjCO+uwLKk2MZqjfd5L90r3yLwwoLvqXGCibn
         l2OnU3nkZn/TsPSykuBqj8ZNPVUumw/wGTR/oiR4t+XC/dPr4FKKsRHiziilS3Ni0z7A
         vmkg==
X-Gm-Message-State: AFqh2kri1c7yWguHCOyJuCnNvkrUit7g5XRoke2yqkp+Wz/Z67VD5KZt
        JSy87oozy8BYeFSTCC48zJUVBgsBDkjMgvJKa9og42v4nf0=
X-Google-Smtp-Source: AMrXdXs1BabaqynfU4EP/SWQXq0h7y29wxFIADNUYGGatv0TblCffUaiP5c83qyBcrFUvFnA+etya6Odiurz99leiJE=
X-Received: by 2002:aa7:d1c3:0:b0:49a:b8ee:ef4b with SMTP id
 g3-20020aa7d1c3000000b0049ab8eeef4bmr118623edp.143.1673921781795; Mon, 16 Jan
 2023 18:16:21 -0800 (PST)
MIME-Version: 1.0
References: <20230116103341.70956-1-kerneljasonxing@gmail.com> <20230116165344.30185-1-kuniyu@amazon.com>
In-Reply-To: <20230116165344.30185-1-kuniyu@amazon.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 17 Jan 2023 10:15:45 +0800
Message-ID: <CAL+tcoB1-MqMf3Yn_qBTbTC9UNBhVW+93j30KJ9zaangkfQHWA@mail.gmail.com>
Subject: Re: [PATCH v5 net] tcp: avoid the lookup process failing to get sk in
 ehash table
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kernelxing@tencent.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org
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

On Tue, Jan 17, 2023 at 12:54 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Jason Xing <kerneljasonxing@gmail.com>
> Date:   Mon, 16 Jan 2023 18:33:41 +0800
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
> > Besides, Eric pointed out there's one more race condition where it
> > handles tw socket hashdance. Only by adding to the tail of the list
> > before deleting the old one can we avoid the race if the reader has
> > already begun the bucket traversal and it would possibly miss the head.
> >
> > Many thanks to Eric for great help from beginning to end.
> >
> > Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
>
> I guess there could be regression if a workload has many long-lived

Sorry, I don't understand. This patch does not add two kinds of
sockets into the ehash table all the time, but reverses the order of
deleting and adding sockets only. The final result is the same as the
old time. I'm wondering why it could cause some regressions if there
are loads of long-lived connections.

> connections, but the change itself looks good.  I left a minor comment
> below.
>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
>

Thanks for reviewing :)

>
> > ---
> > v5:
> > 1) adjust the style once more.
> >
> > v4:
> > 1) adjust the code style and make it easier to read.
> >
> > v3:
> > 1) get rid of else-if statement.
> >
> > v2:
> > 1) adding the sk node into the tail of list to prevent the race.
> > 2) fix the race condition when handling time-wait socket hashdance.
> > ---
> >  net/ipv4/inet_hashtables.c    | 17 +++++++++++++++--
> >  net/ipv4/inet_timewait_sock.c |  6 +++---
> >  2 files changed, 18 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > index 24a38b56fab9..f58d73888638 100644
> > --- a/net/ipv4/inet_hashtables.c
> > +++ b/net/ipv4/inet_hashtables.c
> > @@ -650,8 +650,20 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> >       spin_lock(lock);
> >       if (osk) {
> >               WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
> > -             ret = sk_nulls_del_node_init_rcu(osk);
> > -     } else if (found_dup_sk) {
> > +             ret = sk_hashed(osk);
> > +             if (ret) {
> > +                     /* Before deleting the node, we insert a new one to make
> > +                      * sure that the look-up-sk process would not miss either
> > +                      * of them and that at least one node would exist in ehash
> > +                      * table all the time. Otherwise there's a tiny chance
> > +                      * that lookup process could find nothing in ehash table.
> > +                      */
> > +                     __sk_nulls_add_node_tail_rcu(sk, list);
> > +                     sk_nulls_del_node_init_rcu(osk);
> > +             }
> > +             goto unlock;
> > +     }
> > +     if (found_dup_sk) {
> >               *found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
> >               if (*found_dup_sk)
> >                       ret = false;
> > @@ -660,6 +672,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
> >       if (ret)
> >               __sk_nulls_add_node_rcu(sk, list);
> >
> > +unlock:
> >       spin_unlock(lock);
> >
> >       return ret;
> > diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> > index 1d77d992e6e7..6d681ef52bb2 100644
> > --- a/net/ipv4/inet_timewait_sock.c
> > +++ b/net/ipv4/inet_timewait_sock.c
> > @@ -91,10 +91,10 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
> >  }
> >  EXPORT_SYMBOL_GPL(inet_twsk_put);
> >
> > -static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
> > +static void inet_twsk_add_node_tail_rcu(struct inet_timewait_sock *tw,
> >                                  struct hlist_nulls_head *list)
>
> nit: Please indent here.
>

Before I submitted the patch, I did the check through
./script/checkpatch.py and it outputted some information (no warning,
no error) as you said.
The reason I didn't change that is I would like to leave this part
untouch as it used to be. I have no clue about whether I should send a
v7 patch to adjust the format if necessary.

Thanks,
Jason

>
> >  {
> > -     hlist_nulls_add_head_rcu(&tw->tw_node, list);
> > +     hlist_nulls_add_tail_rcu(&tw->tw_node, list);
> >  }
> >
> >  static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
> > @@ -147,7 +147,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
> >
> >       spin_lock(lock);
> >
> > -     inet_twsk_add_node_rcu(tw, &ehead->chain);
> > +     inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
> >
> >       /* Step 3: Remove SK from hash chain */
> >       if (__sk_nulls_del_node_init_rcu(sk))
> > --
> > 2.37.3
