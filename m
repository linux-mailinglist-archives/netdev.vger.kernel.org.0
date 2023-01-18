Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936F5670F4D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 02:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjARBDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 20:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjARBCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 20:02:48 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105995AB7F;
        Tue, 17 Jan 2023 16:52:41 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qx13so21170865ejb.13;
        Tue, 17 Jan 2023 16:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iDH3IR66gHNNuDi2FZ+msgPgqiBQuiijBoXlNj8Pafw=;
        b=WhZbQIKeYDFjG20xt1tw0NKeXCMoFXvzVyOkYv04/pSWp61ihX6m9pZuJg7xJU1Vdb
         pWz9U/ceFnvQhO6phuXGY491gH2P9X3mwPpEJ+9pQEnMtOXrDp3eavNVBzSXmnyIbLje
         qAjFNQm48wXsEsux3ofy6f2z+dZPr3OQW3G5fCGc5pJ5MKqNaCRWr3KZ6X4MdPFyk/dx
         8LzxSES/9CDNZvEU5kyY64r86S1rZCTNHRkZH18Yt/ZlyCiq+D3FsLmbArXPqB8JfMAo
         HDIBWyt5dIGiPzKoORRyyxuiH54UOm0iTrUOfHOgIqPRKPb1CM6Bs2eaDuNNobNqKy2J
         BEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iDH3IR66gHNNuDi2FZ+msgPgqiBQuiijBoXlNj8Pafw=;
        b=tyYKx89sqkUmIU/4iGs+6iJzKtIbpMNIlUTHbCeBIZaNmYZIxbE0W/lc3wPE0/6ad4
         rxHuBvyQvq7QIqu5+gnY7cv+oGKmrKlGlNJRzrMgaX67Y07I3DJYAlF/udDf5vA+hioM
         9IdMai2SoFYb0swD/BJ/ZFZgZG4y6d7eupQew2YnxLe99mixC4UEhS50cS08Fqq3VrY/
         o0NzbYDMmBAu2G3J3QmmQcuudLDxVEiczYeG8dzCPWGUXSrU8RB6xYHnYX9RyRZj6jbv
         qGkboMkLbt5WlWk8BjQHm9MP/501U5eQktpzSq6gRHyA09fiReU34w8tiQQgA7TyXdSB
         ivkg==
X-Gm-Message-State: AFqh2krr+nTPhtVdZqpfaJxKeMWOTtVEQU8sLwX7+hX/IRCBMifNjFxa
        KwuMm9IUZZa3W8mr/nnpj0R0fy4CxxWCMmUhEzg=
X-Google-Smtp-Source: AMrXdXtiiEUm4fri/dS+EUu9JOo+wLvVU06UrUFD95hkqDZ2vl9eY5MkPZvfqj2fosuDRbWbzKtpCvyLg/QFEJlZfug=
X-Received: by 2002:a17:906:5e09:b0:84d:4eae:d35b with SMTP id
 n9-20020a1709065e0900b0084d4eaed35bmr355055eju.73.1674003158785; Tue, 17 Jan
 2023 16:52:38 -0800 (PST)
MIME-Version: 1.0
References: <20230117175340.91712-1-kerneljasonxing@gmail.com> <20230117184140.7010-1-kuniyu@amazon.com>
In-Reply-To: <20230117184140.7010-1-kuniyu@amazon.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 18 Jan 2023 08:52:02 +0800
Message-ID: <CAL+tcoByi9rz_q8Jn3bBHO2hZFk8eBYR51O4VPzdYjq2LOXf_Q@mail.gmail.com>
Subject: Re: [PATCH v6 net] tcp: avoid the lookup process failing to get sk in
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

On Wed, Jan 18, 2023 at 2:42 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Jason Xing <kerneljasonxing@gmail.com>
> Date:   Wed, 18 Jan 2023 01:53:40 +0800
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
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > Link: https://lore.kernel.org/lkml/20230112065336.41034-1-kerneljasonxing@gmail.com/
> > ---
> > v3,4,5,6:
> > 1) nit: adjust the coding style.
> >
> > v2:
> > 1) add the sk node into the tail of list to prevent the race.
> > 2) fix the race condition when handling time-wait socket hashdance.
> > ---
> >  net/ipv4/inet_hashtables.c    | 17 +++++++++++++++--
> >  net/ipv4/inet_timewait_sock.c | 12 ++++++------
> >  2 files changed, 21 insertions(+), 8 deletions(-)
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
> > index 1d77d992e6e7..b66f2dea5a78 100644
> > --- a/net/ipv4/inet_timewait_sock.c
> > +++ b/net/ipv4/inet_timewait_sock.c
> > @@ -91,20 +91,20 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
> >  }
> >  EXPORT_SYMBOL_GPL(inet_twsk_put);
> >
> > -static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
> > -                                struct hlist_nulls_head *list)
> > +static void inet_twsk_add_node_tail_rcu(struct inet_timewait_sock *tw,
> > +                                     struct hlist_nulls_head *list)
> >  {
> > -     hlist_nulls_add_head_rcu(&tw->tw_node, list);
> > +     hlist_nulls_add_tail_rcu(&tw->tw_node, list);
> >  }
> >
> >  static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
> > -                                 struct hlist_head *list)
> > +                                     struct hlist_head *list)
> >  {
> >       hlist_add_head(&tw->tw_bind_node, list);
> >  }
> >
> >  static void inet_twsk_add_bind2_node(struct inet_timewait_sock *tw,
> > -                                  struct hlist_head *list)
> > +                                     struct hlist_head *list)
> >  {
> >       hlist_add_head(&tw->tw_bind2_node, list);
> >  }
>
> You need not change inet_twsk_add_bind_node() and

I'll drop them and then send a v7 patch.

Thanks,
Jason

> inet_twsk_add_bind2_node().
>
> Thanks,
> Kuniyuki
>
>
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
