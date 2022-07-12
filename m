Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20BF5722B5
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 20:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiGLSed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiGLSeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:34:31 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48462BDBB4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 11:34:30 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id j22so15886815ejs.2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 11:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NoXw4aeCG8IN7zyu27WqWJkVTAVV+GuPyeEn58BBUD4=;
        b=lPTCuWX8yToBoTbD2f8GBzhoiQ5ODM/XobCTYH7kAQ+6NyRDAP+vvSVmFRWHVh6r9d
         R98nXTo+jS7OhGhdOMMpSSeuAQ8n92bgtFOC9WqVfBmAgiMg2MPaf+FskoEBo/L/L3To
         1GL9khOW47dhEuA9UEgziXOCu8FFsqSbRAU9a1/F/hq+xD7KslxKOOfr2yWE0yrcXU1S
         Luwa5Pi0BxlBjonyzVh0Jz6XvVMyO2VrXrlnH2QjJyNZeb7IJ6ZXEc6/YNPGVyJsS919
         QKw6EqtHy7LXSeRiJAJyfekI7snRFFCDnN4w8VyHov1Z0rgm2YDRVVSEtBVXgDWCw0KQ
         zn5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NoXw4aeCG8IN7zyu27WqWJkVTAVV+GuPyeEn58BBUD4=;
        b=VvCpOcrwg4prPUagQTuH2LZZDBYeo/85T902MuNV5Jr/AG98Uf2U73zdNsTunnKdIf
         s7eRmJaqwdiyQJ2JjtlleVRNK0YjEfHZwc62F3IteiHU2Cj6x+saci6zQ++wZDCh+eKr
         I3YXDpc/p4i6gka0Gir4G+JGXUjZX0Ylo2ahTORvZX2n3LogTMn8MzB4wiTKEw4TbVSs
         SQYFJ5Eavu7EbeKTleSqnxVqg3gAWFV7+wvkCFPHvrvp/K928O/nAVyXCOdnql1HWJX8
         dBXzfvqf+COCJaN0fid7PEo4uwEQCR8EqAhgLn5jJb+0g3ko9Gew94ompoK9t+fE5rhf
         FxtQ==
X-Gm-Message-State: AJIora/h2hJyCvttpblH9mzSdbPZfxl/gvtFiaNQuh0IbB9oJTF52a4t
        jKhOIxfOgbskGjMVL2VnccHJlsNZzYDSBgHORH0=
X-Google-Smtp-Source: AGRyM1syw/02ugS/NidyD09t8hb2YbuFUC0XVc5k1nHb5Noi27UKBroNjBcTMZtqdDJeWszbzZzkLh7iwMEwZvk1uaY=
X-Received: by 2002:a17:907:734a:b0:72b:7c72:e6b3 with SMTP id
 dq10-20020a170907734a00b0072b7c72e6b3mr5357640ejc.608.1657650868786; Tue, 12
 Jul 2022 11:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220623234242.2083895-1-joannelkoong@gmail.com>
 <20220623234242.2083895-2-joannelkoong@gmail.com> <c075e7c4dcd787cca604f1cb1ddd9c6fc077a3c4.camel@redhat.com>
In-Reply-To: <c075e7c4dcd787cca604f1cb1ddd9c6fc077a3c4.camel@redhat.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 12 Jul 2022 11:34:17 -0700
Message-ID: <CAJnrk1aizKQ_8ab4CBNK+DDyLS3pMfWBG5mvmW4NhtAuUhUiUA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/3] net: Add a bhash2 table hashed by port + address
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
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

On Tue, Jun 28, 2022 at 3:32 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Thu, 2022-06-23 at 16:42 -0700, Joanne Koong wrote:
> > The current bind hashtable (bhash) is hashed by port only.
> > In the socket bind path, we have to check for bind conflicts by
> > traversing the specified port's inet_bind_bucket while holding the
> > hashbucket's spinlock (see inet_csk_get_port() and
> > inet_csk_bind_conflict()). In instances where there are tons of
> > sockets hashed to the same port at different addresses, the bind
> > conflict check is time-intensive and can cause softirq cpu lockups,
> > as well as stops new tcp connections since __inet_inherit_port()
> > also contests for the spinlock.
> >
> > This patch adds a second bind table, bhash2, that hashes by
> > port and sk->sk_rcv_saddr (ipv4) and sk->sk_v6_rcv_saddr (ipv6).
> > Searching the bhash2 table leads to significantly faster conflict
> > resolution and less time holding the hashbucket spinlock.
> >
> > Please note a few things:
> > * There can be the case where the a socket's address changes after it
> > has been bound. There are two cases where this happens:
> >
> >   1) The case where there is a bind() call on INADDR_ANY (ipv4) or
> >   IPV6_ADDR_ANY (ipv6) and then a connect() call. The kernel will
> >   assign the socket an address when it handles the connect()
> >
> >   2) In inet_sk_reselect_saddr(), which is called when rebuilding the
> >   sk header and a few pre-conditions are met (eg rerouting fails).
> >
> > In these two cases, we need to update the bhash2 table by removing the
> > entry for the old address, and add a new entry reflecting the updated
> > address.
> >
> > * The bhash2 table must have its own lock, even though concurrent
> > accesses on the same port are protected by the bhash lock. Bhash2 must
> > have its own lock to protect against cases where sockets on different
> > ports hash to different bhash hashbuckets but to the same bhash2
> > hashbucket.
> >
> > This brings up a few stipulations:
> >   1) When acquiring both the bhash and the bhash2 lock, the bhash2 lock
> >   will always be acquired after the bhash lock and released before the
> >   bhash lock is released.
> >
> >   2) There are no nested bhash2 hashbucket locks. A bhash2 lock is always
> >   acquired+released before another bhash2 lock is acquired+released.
> >
> > * The bhash table cannot be superseded by the bhash2 table because for
> > bind requests on INADDR_ANY (ipv4) or IPV6_ADDR_ANY (ipv6), every socket
> > bound to that port must be checked for a potential conflict. The bhash
> > table is the only source of port->socket associations.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/net/inet_connection_sock.h |   3 +
> >  include/net/inet_hashtables.h      |  80 ++++++++-
> >  include/net/sock.h                 |  17 +-
> >  net/dccp/ipv4.c                    |  24 ++-
> >  net/dccp/ipv6.c                    |  12 ++
> >  net/dccp/proto.c                   |  34 +++-
> >  net/ipv4/af_inet.c                 |  31 +++-
> >  net/ipv4/inet_connection_sock.c    | 279 ++++++++++++++++++++++-------
> >  net/ipv4/inet_hashtables.c         | 277 ++++++++++++++++++++++++++--
> >  net/ipv4/tcp.c                     |  11 +-
> >  net/ipv4/tcp_ipv4.c                |  21 ++-
> >  net/ipv6/tcp_ipv6.c                |  12 ++
> >  12 files changed, 696 insertions(+), 105 deletions(-)
> >
[...]
> > -static inline void sk_add_bind_node(struct sock *sk,
> > -                                     struct hlist_head *list)
> > +static inline void sk_add_bind_node(struct sock *sk, struct hlist_head *list)
> >  {
> >       hlist_add_head(&sk->sk_bind_node, list);
> >  }
>
> This is an unneeded chunck, that increases the size of an already big
> patch. I would have dropped it.
I will drop this for v2.
>
[...]
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index da81f56fdd1c..47b5fa4f8c24 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -1218,13 +1218,15 @@ EXPORT_SYMBOL(inet_unregister_protosw);
> >
> >  static int inet_sk_reselect_saddr(struct sock *sk)
> >  {
> > +     struct inet_bind_hashbucket *prev_addr_hashbucket;
> >       struct inet_sock *inet = inet_sk(sk);
> >       __be32 old_saddr = inet->inet_saddr;
> >       __be32 daddr = inet->inet_daddr;
> > +     struct ip_options_rcu *inet_opt;
> >       struct flowi4 *fl4;
> >       struct rtable *rt;
> >       __be32 new_saddr;
> > -     struct ip_options_rcu *inet_opt;
> > +     int err;
> >
> >       inet_opt = rcu_dereference_protected(inet->inet_opt,
> >                                            lockdep_sock_is_held(sk));
> > @@ -1239,20 +1241,33 @@ static int inet_sk_reselect_saddr(struct sock *sk)
> >       if (IS_ERR(rt))
> >               return PTR_ERR(rt);
> >
> > -     sk_setup_caps(sk, &rt->dst);
> > -
>
> I don't see why  'sk_setup_caps()' is moved. Additionally it looks like
> it's not called anymore on the error path. It looks like an unrelated
> "optimization", I suggest to drop it.
I think sk_setup_caps() can only get called in the non-error cases,
else it will set some fields of the sk (eg the dst_cache) with
incorrect information.
In the codepath prior to this change, sk_setup_caps() only gets called
in the non-error cases as well (since __sk_prot_rehash(sk)) will
always return 0).
>
>
> Thanks!
>
> Paolo
Thanks for taking a look at this patch Paolo!
>
