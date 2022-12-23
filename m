Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5A2654F05
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 11:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiLWKQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 05:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiLWKQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 05:16:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5D02618
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 02:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671790528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u1U1kXFD5YoO6mGdNH+xJ62te4wv4JV0jDXhW6CfwZY=;
        b=c/Wl4fpYUDduRWKLeFl+Tu1PxAtkppmuot4NnTYzCgHSy9tdq47ygi70ldSMvSHxDBX6RU
        pXHqThKXmXABIeXPrtREmdQ6FCWQA+4LtyaSnNsRO3izOCdr9GyaxSc+dAiQ6tlS4Y+8Jr
        xvCdXx71cJf7Q+S3Oh2fO9AhmDIqt6E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-63-Y_7BEA3lOF20n-5g2JeFhg-1; Fri, 23 Dec 2022 05:15:27 -0500
X-MC-Unique: Y_7BEA3lOF20n-5g2JeFhg-1
Received: by mail-wr1-f69.google.com with SMTP id n12-20020adfc60c000000b0026647ef69f4so915286wrg.10
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 02:15:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u1U1kXFD5YoO6mGdNH+xJ62te4wv4JV0jDXhW6CfwZY=;
        b=ZH1qnYOVfe0nokTrHQ6DpEBoZFHC6HFgpEDUqZWUck4dhG9qy1NSIi+W7RpDArM9rX
         735KprEwGwXJzbWi8fXLmGcPmyntRewzBjT50873PcxIcPvWS8zx1h4kDvdfAdVDBJ6j
         UaojeoxqZ5bFhkuE16VPXuJbzCq/KLz0buFXO7fDGsmP81CVOtXCWZ2AyBijUalyzPrc
         jElJhQi56Mgntw6Mv04FLM1nnYVb94JWA2Fx1Y/hkiRFeJx+2ZP5jYECoxaNNfbHmZ69
         G7C8Qr6F8CuGQXdcw3dys+VPuFsa9EbZ9x0sZDTfjMZy11jm8heSNDKOrvUUv0idyPvk
         sj2w==
X-Gm-Message-State: AFqh2kqSoy/NEmm0pfiRlPmjCTJuKvmAVkN/7ss3O8C08SSqYXupthIV
        CpDpHHBHE4rzFoVEa7nDL2UuA7LbWg8GEHRKW3pRLSK+Cd8SakHh2Rps2D1nnuzNjIicc1AHpZz
        KunrUfzc6SKCHKQ6j
X-Received: by 2002:a5d:4908:0:b0:242:187f:ed44 with SMTP id x8-20020a5d4908000000b00242187fed44mr6060256wrq.68.1671790526338;
        Fri, 23 Dec 2022 02:15:26 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuNRIlOnYQ/M8zAXwnJyutGIRuxrbKoqw7CdmUVJ07bYtDSu0RcvCDYlAlnNRRKONbNpV5N6A==
X-Received: by 2002:a5d:4908:0:b0:242:187f:ed44 with SMTP id x8-20020a5d4908000000b00242187fed44mr6060239wrq.68.1671790526041;
        Fri, 23 Dec 2022 02:15:26 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id e15-20020a5d500f000000b002427bfd17b6sm3270467wrt.63.2022.12.23.02.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 02:15:25 -0800 (PST)
Message-ID: <99793af4ce55ba878bc201571c824a17a37ef81d.camel@redhat.com>
Subject: Re: [PATCH RFC net 1/2] tcp: Add TIME_WAIT sockets in bhash2.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>, joannelkoong@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, jirislaby@kernel.org,
        kuba@kernel.org, kuni1840@gmail.com, netdev@vger.kernel.org
Date:   Fri, 23 Dec 2022 11:15:24 +0100
In-Reply-To: <20221222232647.95259-1-kuniyu@amazon.com>
References: <CAJnrk1YcDEFhKGmpFCULfJBwf3p8Bg-D0VPzTPRdbs4HxdDbVQ@mail.gmail.com>
         <20221222232647.95259-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-12-23 at 08:26 +0900, Kuniyuki Iwashima wrote:
> From:   Joanne Koong <joannelkoong@gmail.com>
> Date:   Thu, 22 Dec 2022 13:46:57 -0800
> > On Thu, Dec 22, 2022 at 7:06 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > 
> > > On Thu, 2022-12-22 at 00:12 +0900, Kuniyuki Iwashima wrote:
> > > > Jiri Slaby reported regression of bind() with a simple repro. [0]
> > > > 
> > > > The repro creates a TIME_WAIT socket and tries to bind() a new socket
> > > > with the same local address and port.  Before commit 28044fc1d495 ("net:
> > > > Add a bhash2 table hashed by port and address"), the bind() failed with
> > > > -EADDRINUSE, but now it succeeds.
> > > > 
> > > > The cited commit should have put TIME_WAIT sockets into bhash2; otherwise,
> > > > inet_bhash2_conflict() misses TIME_WAIT sockets when validating bind()
> > > > requests if the address is not a wildcard one.
> > 
> > (resending my reply because it wasn't in plaintext mode)
> > 
> > Thanks for adding this! I hadn't realized TIME_WAIT sockets also are
> > considered when checking against inet bind conflicts.
> > 
> > > 
> > > How does keeping the timewait sockets inside bhash2 affect the bind
> > > loopup performance? I fear that could defeat completely the goal of
> > > 28044fc1d495, on quite busy server we could have quite a bit of tw with
> > > the same address/port. If so, we could even consider reverting
> > > 28044fc1d495.
> 
> It will slow down along the number of twsk, but I think it's still faster
> than bhash if we listen() on multiple IP.  If we don't, bhash is always
> faster because of bhash2's additional locking.  However, this is the
> nature of bhash2 from the beginning.

I see. Before 28044fc1d495, todo a bind lookup, we had to traverse all
the tw in bhash. After 28044fc1d495, tw were ignored (in some cases).
My point is: if the number of tw sockets is >> the number of listeners
on multiple IPs, the bhash2 traversal time after this patch will be
comparable to the bhash traversal time before 28044fc1d495, with the
added cost of the double spin lock.

> > 
> > Can you clarify what you mean by bind loopup?
> 
> I think it means just bhash2 traversal.  (s/loopup/lookup/)

Indeed, sorry for the typo!
> 
> > 
> > > > [0]: https://lore.kernel.org/netdev/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
> > > > 
> > > > Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> > > > Reported-by: Jiri Slaby <jirislaby@kernel.org>
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > ---
> > > >  include/net/inet_timewait_sock.h |  2 ++
> > > >  include/net/sock.h               |  5 +++--
> > > >  net/ipv4/inet_hashtables.c       |  5 +++--
> > > >  net/ipv4/inet_timewait_sock.c    | 31 +++++++++++++++++++++++++++++--
> > > >  4 files changed, 37 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
> > > > index 5b47545f22d3..c46ed239ad9a 100644
> > > > --- a/include/net/inet_timewait_sock.h
> > > > +++ b/include/net/inet_timewait_sock.h
> > > > @@ -44,6 +44,7 @@ struct inet_timewait_sock {
> > > >  #define tw_bound_dev_if              __tw_common.skc_bound_dev_if
> > > >  #define tw_node                      __tw_common.skc_nulls_node
> > > >  #define tw_bind_node         __tw_common.skc_bind_node
> > > > +#define tw_bind2_node                __tw_common.skc_bind2_node
> > > >  #define tw_refcnt            __tw_common.skc_refcnt
> > > >  #define tw_hash                      __tw_common.skc_hash
> > > >  #define tw_prot                      __tw_common.skc_prot
> > > > @@ -73,6 +74,7 @@ struct inet_timewait_sock {
> > > >       u32                     tw_priority;
> > > >       struct timer_list       tw_timer;
> > > >       struct inet_bind_bucket *tw_tb;
> > > > +     struct inet_bind2_bucket        *tw_tb2;
> > > >  };
> > > >  #define tw_tclass tw_tos
> > > > 
> > > > diff --git a/include/net/sock.h b/include/net/sock.h
> > > > index dcd72e6285b2..aaec985c1b5b 100644
> > > > --- a/include/net/sock.h
> > > > +++ b/include/net/sock.h
> > > > @@ -156,6 +156,7 @@ typedef __u64 __bitwise __addrpair;
> > > >   *   @skc_tw_rcv_nxt: (aka tw_rcv_nxt) TCP window next expected seq number
> > > >   *           [union with @skc_incoming_cpu]
> > > >   *   @skc_refcnt: reference count
> > > > + *   @skc_bind2_node: bind node in the bhash2 table
> > > >   *
> > > >   *   This is the minimal network layer representation of sockets, the header
> > > >   *   for struct sock and struct inet_timewait_sock.
> > > > @@ -241,6 +242,7 @@ struct sock_common {
> > > >               u32             skc_window_clamp;
> > > >               u32             skc_tw_snd_nxt; /* struct tcp_timewait_sock */
> > > >       };
> > > > +     struct hlist_node       skc_bind2_node;
> > > 
> > > I *think* it would be better adding a tw_bind2_node field to the
> > > inet_timewait_sock struct, so that we leave unmodified the request
> > > socket and we don't change the struct sock binary layout. That could
> > > affect performances moving hot fields on different cachelines.
> > > 
> > +1. The rest of this patch LGTM.
> 
> Then we can't use sk_for_each_bound_bhash2(), or we have to guarantee this.
> 
>   BUILD_BUG_ON(offsetof(struct sock, sk_bind2_node),
>                offsetof(struct inet_timewait_sock, tw_bind2_node))
> 
> Considering the number of members in struct sock, at least we have
> to move sk_bind2_node forward.

You are right, I missed that point.


> Another option is to have another TIME_WAIT list in inet_bind2_bucket like
> tb2->deathrow or something.  sk_for_each_bound_bhash2() is used only in
> inet_bhash2_conflict(), so I think this is feasible.

This will add some more memory cost. I hope it's not a big deal, and
looks like the better option IMHO.

Cheers,

Paolo

